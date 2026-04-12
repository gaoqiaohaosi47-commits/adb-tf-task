# 03_ws-after-task

## 実行者
ネットワーク管理者

## 概要
ワークスペース作成後にプライベートエンドポイントを設定し、既存の Private DNS Zone に VNet リンクを追加する。

## 前提条件
- `01_azure-infra` の apply が完了していること
- `02_databricks-workspace` の apply が完了していること
- 各モジュールの `terraform output` 値を `terraform.tfvars` に転記済みであること
- Azure CLI がインストール済みで `az login` 済みであること

## ファイル構成

| ファイル | 役割 |
|---|---|
| `providers.tf` | Terraform / AzureRM プロバイダー設定 |
| `main.tf` | ローカル値定義 |
| `variables.tf` | 入力変数定義（01/02 の outputs を受け取る） |
| `private_dns_zone_dp.tf` | 既存 Private DNS Zone への VNet リンク追加 |
| `endpoint_backend.tf` | Databricks Backend (UI/API) プライベートエンドポイント作成 |
| `endpoint_dbfs.tf` | DBFS (DFS/Blob) プライベートエンドポイント作成 |
| `outputs.tf` | プライベートエンドポイント ID の出力 |
| `terraform.tfvars.sample` | 変数設定サンプル |

## 変数一覧

| 変数名 | 必須 | 説明 |
|---|---|---|
| `prefix` | ✓ | `01 output: prefix` |
| `resource_group_name` | ✓ | `01 output: resource_group_name` |
| `location` | ✓ | `01 output: location` |
| `vnet_id` | ✓ | `01 output: vnet_id` |
| `privatelink_subnet_id` | ✓ | `01 output: privatelink_subnet_id` |
| `dns_zone_dpcp_id` | ✓ | `01 output: dns_zone_dpcp_id` |
| `dns_zone_dpcp_name` | ✓ | `01 output: dns_zone_dpcp_name` |
| `dns_zone_dfs_id` | ✓ | `01 output: dns_zone_dfs_id` |
| `dns_zone_dfs_name` | ✓ | `01 output: dns_zone_dfs_name` |
| `dns_zone_blob_id` | ✓ | `01 output: dns_zone_blob_id` |
| `dns_zone_blob_name` | ✓ | `01 output: dns_zone_blob_name` |
| `dns_zone_resource_group_name` | ✓ | Private DNS Zone が存在する RG 名 |
| `workspace_resource_id` | ✓ | `02 output: workspace_resource_id` |
| `managed_resource_group_id` | ✓ | `02 output: managed_resource_group_id` |
| `dbfs_storage_account_name` | ✓ | `02 output: dbfs_storage_account_name` |
| `subscription_id` | ✓ | Azure サブスクリプション ID |

## 出力一覧

| 出力名 | 説明 |
|---|---|
| `backend_private_endpoint_id` | Databricks Backend プライベートエンドポイント ID |
| `dbfs_dfs_private_endpoint_id` | DBFS DFS プライベートエンドポイント ID |
| `dbfs_blob_private_endpoint_id` | DBFS Blob プライベートエンドポイント ID |

## 実行手順

```bash
cd 03_ws-after-task

# 1. 前段モジュールの出力値を取得
cd ../01_azure-infra && terraform output
cd ../02_databricks-workspace && terraform output
cd ../03_ws-after-task

# 2. 変数ファイルを準備（01/02 の output 値を転記）
cp terraform.tfvars.sample terraform.tfvars
# terraform.tfvars を編集して実際の値を設定

# 3. バックエンド設定ファイルを準備
cp backend.tfbackend.sample backend.tfbackend
# backend.tfbackend を編集して tfstate 保管先のストレージアカウント情報を設定
#   resource_group_name  = "tfstate を保管する RG 名"
#   storage_account_name = "tfstate を保管するストレージアカウント名"
#   container_name       = "tfstate"  # コンテナ名（変更する場合のみ）
#   key                  = "03_ws-after-task/terraform.tfstate"  # 変更不要

# 4. 初期化（リモートバックエンドを指定）
terraform init -backend-config=backend.tfbackend

# 5. 実行計画の確認
terraform plan

# 6. 適用
terraform apply
```
