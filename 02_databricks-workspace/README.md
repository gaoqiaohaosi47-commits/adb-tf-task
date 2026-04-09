# 02_databricks-workspace

## 実行者
データエンジニア

## 概要
Databricks ワークスペースを作成する。この時点ではプライベートエンドポイントは未設定で、
ネットワーク設定は後続の 03_ws-after-task で行う。

## 前提条件
- `01_azure-infra` の apply が完了していること
- `terraform output` で出力値を取得し `terraform.tfvars` に転記済みであること
- Azure CLI がインストール済みで `az login` 済みであること

## ファイル構成

| ファイル | 役割 |
|---|---|
| `providers.tf` | Terraform / AzureRM プロバイダー設定 |
| `main.tf` | ローカル値定義・タグ設定 |
| `variables.tf` | 入力変数定義（01_azure-infra outputs を受け取る） |
| `databricks_workspace.tf` | Databricks ワークスペース作成（CMK 有効化含む） |
| `cmk.tf` | DBFS Root CMK・Managed Disk CMK のアクセスポリシーと CMK 紐付け |
| `outputs.tf` | ワークスペース情報の出力 |
| `terraform.tfvars.sample` | 変数設定サンプル |

## 変数一覧

| 変数名 | 必須 | 説明 |
|---|---|---|
| `workspace_name` | ✓ | Databricks ワークスペース名 |
| `managed_resource_group_name` | ✓ | Databricks マネージドリソースグループ名 |
| `dbfs_storage_account_name` | ✓ | `01 output: dbfs_storage_account_name` |
| `resource_group_name` | ✓ | `01 output: resource_group_name` |
| `location` | ✓ | `01 output: location` |
| `vnet_id` | ✓ | `01 output: vnet_id` |
| `public_subnet_name` | ✓ | `01 output: public_subnet_name` |
| `private_subnet_name` | ✓ | `01 output: private_subnet_name` |
| `public_subnet_nsg_association_id` | ✓ | `01 output: public_subnet_nsg_association_id` |
| `private_subnet_nsg_association_id` | ✓ | `01 output: private_subnet_nsg_association_id` |
| `subscription_id` | ✓ | Azure サブスクリプション ID |
| `public_network_access_enabled` | - | パブリックアクセス許可（デフォルト: true） |
| `cmk_key_vault_id` | ✓ | `01 output: cmk_key_vault_id` |
| `cmk_key_vault_key_id` | ✓ | `01 output: cmk_key_vault_key_id` |
| `enable_managed_disk_cmk` | - | Managed Disk CMK 有効化フラグ（デフォルト: false、2回目 apply で true に変更） |

## 出力一覧

| 出力名 | 説明 |
|---|---|
| `workspace_url` | Databricks ワークスペース URL |
| `workspace_id` | Databricks ワークスペース ID（数値） |
| `workspace_resource_id` | ワークスペースの Azure リソース ID |
| `managed_resource_group_id` | Databricks マネージドリソースグループ ID |
| `dbfs_storage_account_name` | DBFS ストレージアカウント名 |

## 実行手順

```bash
cd 02_databricks-workspace

# 1. 01_azure-infra の出力値を取得
cd ../01_azure-infra && terraform output
cd ../02_databricks-workspace

# 2. 変数ファイルを準備（01 の output 値を転記）
cp terraform.tfvars.sample terraform.tfvars
# terraform.tfvars を編集して実際の値を設定
# ※ enable_managed_disk_cmk は false のままにする

# 3. 初期化
terraform init

# 4. 実行計画の確認
terraform plan

# 5. 適用（1回目）
# ワークスペース作成・DBFS CMK・Managed Services CMK が完了する
# AzureDatabricks SP へのポリシーは 01_azure-infra apply 済みのため 1回で完結
terraform apply

# 6. Managed Disk CMK を有効化（terraform.tfvars を編集）
# enable_managed_disk_cmk = true に変更

# 7. 適用（2回目）— Managed Disk CMK 設定
terraform apply

# 8. 後続モジュール用に出力値を記録
terraform output
```
