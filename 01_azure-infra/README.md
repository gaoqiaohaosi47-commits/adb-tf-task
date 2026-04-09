# 01_azure-infra

## 実行者
Azure 基盤管理者

## 概要
VNet・NSG・Private DNS Zone・外部ロケーション用ストレージ等の Azure インフラリソースを作成する。
後続モジュール（02/03/04）が必要とするすべての Azure リソースをプロビジョニングする。

## 前提条件
- Azure CLI がインストール済みで `az login` 済みであること
- 対象 Azure サブスクリプションへの Contributor 権限以上を持つこと

## ファイル構成

| ファイル | 役割 |
|---|---|
| `providers.tf` | Terraform / AzureRM / AzureAD プロバイダー設定 |
| `main.tf` | ローカル値定義・リソースグループ作成 |
| `variables.tf` | ネットワーク・RG・CMK 関連の変数定義 |
| `external_location_variables.tf` | 外部ロケーション用ストレージ変数定義 |
| `vnet_dp.tf` | VNet・サブネット・NSG の作成 |
| `private_dns_zone_dp.tf` | Private DNS Zone の作成（または既存参照）と VNet リンク |
| `external_location_storage.tf` | 外部ロケーション用ストレージ・マネージド ID・アクセスコネクタの作成 |
| `external_location_private_endpoint.tf` | 外部ロケーション用ストレージのプライベートエンドポイント作成 |
| `cmk_key_vault.tf` | CMK 用 Key Vault・RSA キー・AzureDatabricks SP アクセスポリシーの作成 |
| `cmk_ext_loc_storage.tf` | 外部ロケーション Storage への CMK 適用 |
| `outputs.tf` | 基本情報・ネットワーク情報・DNS Zone 情報・CMK 情報の出力 |
| `external_location_outputs.tf` | 外部ロケーション関連リソースの出力 |
| `terraform.tfvars.sample` | 変数設定サンプル |

## 変数一覧

| 変数名 | 必須 | 説明 |
|---|---|---|
| `location` | ✓ | デプロイリージョン（例: `japaneast`） |
| `cidr_dp` | ✓ | Data Plane VNet のアドレス空間（例: `10.10.0.0/16`） |
| `subscription_id` | ✓ | Azure サブスクリプション ID |
| `create_data_plane_resource_group` | ✓ | true: RG を新規作成、false: 既存 RG を使用 |
| `existing_data_plane_resource_group_name` | ※ | 既存 RG 名（`create_data_plane_resource_group = false` の場合に必須） |
| `use_existing_vnet` | - | true: 既存 VNet を使用（デフォルト: false） |
| `existing_vnet_name` | ※ | 既存 VNet 名（`use_existing_vnet = true` の場合に必須） |
| `existing_vnet_resource_group_name` | - | 既存 VNet の RG 名（省略時は data plane RG と同一） |
| `create_private_dns_zones` | - | false: 既存 DNS Zone を再利用（複数環境で同一 RG を使う場合） |
| `private_subnet_endpoints` | - | private サブネットに付与する Service Endpoint リスト |
| `ext_storage_container_name` | - | 外部ロケーション用コンテナ名（デフォルト: `external`） |
| `ext_storage_public_access_enabled` | - | 外部ロケーション用ストレージへのパブリックアクセス許可（デフォルト: false） |
| `key_vault_name` | ✓ | CMK 用 Key Vault 名（英数字とハイフン・3〜24文字・グローバル一意） |
| `cmk_key_name` | - | CMK 用 RSA キー名（デフォルト: `databricks-cmk`） |

## 出力一覧

| 出力名 | 説明 |
|---|---|
| `prefix` | リソース名プレフィックス（02/03/04 で使用） |
| `dbfs_storage_account_name` | DBFS ストレージアカウント名 |
| `resource_group_name` | Data Plane リソースグループ名 |
| `location` | デプロイリージョン |
| `vnet_id` | Data Plane VNet ID |
| `vnet_name` | Data Plane VNet 名 |
| `public_subnet_name` | Databricks パブリックサブネット名 |
| `private_subnet_name` | Databricks プライベートサブネット名 |
| `privatelink_subnet_id` | Private Link サブネット ID |
| `public_subnet_nsg_association_id` | パブリックサブネット NSG アソシエーション ID |
| `private_subnet_nsg_association_id` | プライベートサブネット NSG アソシエーション ID |
| `dns_zone_dpcp_id` / `dns_zone_dpcp_name` | `privatelink.azuredatabricks.net` DNS Zone |
| `dns_zone_dfs_id` / `dns_zone_dfs_name` | `privatelink.dfs.core.windows.net` DNS Zone |
| `dns_zone_blob_id` / `dns_zone_blob_name` | `privatelink.blob.core.windows.net` DNS Zone |
| `ext_loc_storage_account_name` | 外部ロケーション用ストレージアカウント名 |
| `ext_loc_storage_account_id` | 外部ロケーション用ストレージアカウント ID |
| `ext_loc_container_name` | 外部ロケーション用コンテナ名 |
| `ext_loc_abfss_url` | 外部ロケーション用 ABFSS URL |
| `ext_loc_managed_identity_id` | ユーザー割り当てマネージド ID のリソース ID |
| `ext_loc_access_connector_id` | Databricks アクセスコネクタのリソース ID |
| `ext_loc_access_connector_name` | Databricks アクセスコネクタ名 |
| `cmk_key_vault_id` | CMK 用 Key Vault ID（02 へ引き渡し） |
| `cmk_key_vault_key_id` | CMK 用 Key Vault キー ID（02 へ引き渡し） |

## 実行手順

```bash
cd 01_azure-infra

# 1. 変数ファイルを準備
cp terraform.tfvars.sample terraform.tfvars
# terraform.tfvars を編集して実際の値を設定

# 2. 初期化
terraform init

# 3. 実行計画の確認
terraform plan

# 4. 適用
terraform apply

# 5. 後続モジュール用に出力値を記録
terraform output
```
