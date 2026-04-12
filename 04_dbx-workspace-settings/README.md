# 04_dbx-workspace-settings

## 実行者
データエンジニア

## 概要
Databricks プロバイダーを使用してワークスペース内のリソースを設定する。
グループ・SP・SQL ウェアハウス・Unity Catalog（カタログ/スキーマ/ボリューム）・ネットワークポリシーなどを管理する。

## 前提条件
- `01_azure-infra` および `02_databricks-workspace` の apply が完了していること
- Databricks ワークスペースにアクセスできる状態であること
- Azure CLI がインストール済みで `az login` 済みであること（`az account set --subscription <id>` も実行済み）
- Databricks アカウント管理者権限を持つユーザーで実行すること

## ファイル構成

### 基盤ファイル

| ファイル | 役割 |
|---|---|
| `ws_providers.tf` | Databricks プロバイダー設定（workspace / account） |
| `ws_locals.tf` | 変数からローカル値へのマッピング |
| `ws_variables.tf` | 全変数定義 |
| `ws_data.tf` | データソース定義（現在ユーザー・メタストア） |
| `ws_outputs.tf` | 出力値定義 |
| `terraform.tfvars.sample` | 変数設定サンプル |

### タスクファイル

| ファイル | 実施内容 |
|---|---|
| `task_001_account_groups.tf` | Databricks アカウントレベルのグループ作成 |
| `task_002_workspace_group_assignment.tf` | グループのワークスペース割り当て・エンタイトルメント設定 |
| `task_003_service_principal.tf` | サービスプリンシパルの作成・エンタイトルメント設定 |
| `task_004_service_principal_secret.tf` | サービスプリンシパル シークレット発行 |
| `task_005_sql_warehouse.tf` | SQL ウェアハウス作成 |
| `task_006_ip_access_list.tf` | IP アクセスリスト設定 |
| `task_007_workspace_conf.tf` | ワークスペース機能設定（セキュリティ・ガバナンス） |
| `task_008_metastore_grants.tf` | メタストア権限設定 |
| `task_009_storage_credential.tf` | ストレージ資格情報（Storage Credential）作成 |
| `task_010_external_location.tf` | 外部ロケーション（External Location）作成 |
| `task_011_catalog.tf` | Unity Catalog カタログ作成 |
| `task_012_schema.tf` | スキーマ作成 |
| `task_013_volume.tf` | 外部ボリューム作成 |
| `task_014_ncc.tf` | NCC（Network Connectivity Configuration）作成・バインド |
| `task_015_network_policy.tf` | アカウントレベルのネットワークポリシー作成・適用 |

## 変数一覧

### 02_databricks-workspace outputs

| 変数名 | 説明 |
|---|---|
| `workspace_url` | `02 output: workspace_url` |
| `workspace_id` | `02 output: workspace_id` |

### 01_azure-infra outputs

| 変数名 | 説明 |
|---|---|
| `resource_group_name` | `01 output: resource_group_name` |
| `location` | `01 output: location` |
| `ext_loc_storage_account_name` | `01 output: ext_loc_storage_account_name` |
| `ext_loc_storage_account_id` | `01 output: ext_loc_storage_account_id` |
| `ext_loc_container_name` | `01 output: ext_loc_container_name` |
| `ext_loc_abfss_url` | `01 output: ext_loc_abfss_url` |
| `ext_loc_managed_identity_id` | `01 output: ext_loc_managed_identity_id` |
| `ext_loc_access_connector_id` | `01 output: ext_loc_access_connector_id` |
| `ext_loc_access_connector_name` | `01 output: ext_loc_access_connector_name` |

### 共通・認証

| 変数名 | 必須 | 説明 |
|---|---|---|
| `databricks_account_id` | ✓ | Databricks アカウント ID |
| `azure_tenant_id` | ✓ | Azure テナント ID（`az account show --query tenantId -o tsv` で取得） |

### タスク別変数

| 変数名 | デフォルト | 説明 |
|---|---|---|
| `uc_group_name` | `uc-users` | Unity Catalog 利用グループ名 |
| `ws_admin_group_name` | `ws-admins` | ワークスペース管理者グループ名 |
| `service_principal_display_name` | `tf-automation-sp` | サービスプリンシパル表示名 |
| `sql_warehouse_name` | `tf-sql-warehouse` | SQL ウェアハウス名 |
| `ip_access_list` | - | 許可 IP アドレスリスト（`[{label, address}]` 形式） |
| `metastore_name` | `""` | メタストア名（空文字でスキップ） |
| `catalog_name` | `main_catalog` | カタログ名 |
| `schema_names` | `["bronze","silver","gold"]` | スキーマ名リスト |
| `volume_name` | `external_volume` | ボリューム名 |
| `volume_schema` | `bronze` | ボリューム作成先スキーマ名 |
| `network_policy_id` | `ext-loc-network-policy` | ネットワークポリシー ID |
| `network_policy_enforcement_mode` | `DRY_RUN` | ポリシー適用モード（`DRY_RUN` / `ENFORCED`） |
| `allowed_internet_destinations` | `[]` | 許可インターネット宛先リスト |

## 出力一覧

| 出力名 | 説明 |
|---|---|
| `uc_users_group_id` | UC 利用グループ ID |
| `ws_admins_group_id` | WS 管理者グループ ID |
| `service_principal_secret` | サービスプリンシパル シークレット（sensitive） |
| `sql_warehouse_id` | SQL ウェアハウス ID |
| `sql_warehouse_jdbc_url` | SQL ウェアハウス JDBC URL |
| `storage_credential_name` | ストレージ資格情報名 |
| `external_location_name` | 外部ロケーション名 |
| `external_location_url` | 外部ロケーション URL |
| `catalog_name` | カタログ名 |
| `schema_names` | スキーマ名リスト |
| `volume_path` | ボリュームのフルパス |
| `ncc_id` | NCC ID |

## 実行手順

```bash
cd 04_dbx-workspace-settings

# 1. 前段モジュールの出力値を取得
cd ../01_azure-infra && terraform output
cd ../02_databricks-workspace && terraform output
cd ../04_dbx-workspace-settings

# 2. Azure CLI でログイン
az login
az account set --subscription <subscription_id>

# 3. 変数ファイルを準備（01/02 の output 値を転記）
cp terraform.tfvars.sample terraform.tfvars
# terraform.tfvars を編集して実際の値を設定

# 4. バックエンド設定ファイルを準備
cp backend.tfbackend.sample backend.tfbackend
# backend.tfbackend を編集して tfstate 保管先のストレージアカウント情報を設定
#   resource_group_name  = "tfstate を保管する RG 名"
#   storage_account_name = "tfstate を保管するストレージアカウント名"
#   container_name       = "tfstate"  # コンテナ名（変更する場合のみ）
#   key                  = "04_dbx-workspace-settings/terraform.tfstate"  # 変更不要

# 5. 初期化（リモートバックエンドを指定）
terraform init -backend-config=backend.tfbackend

# 6. 実行計画の確認
terraform plan

# 7. 適用
terraform apply
```

## 注意事項

- グループ・SP はアカウントレベルで作成されるため、同名リソースが既存の場合はエラーになる
  - 対処: `terraform import` で既存リソースを state に取り込む
- NCC で作成されたストレージへのプライベートエンドポイントは、ストレージ側でポータルから承認が必要
- ネットワークポリシーは `DRY_RUN` モードで適用し、動作確認後に `ENFORCED` へ変更することを推奨
