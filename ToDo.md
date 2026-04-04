# ToDo

## 方針
責任分界に基づき `adb-with-private-link-standard` を 4 モジュールに分離。
各モジュールは独立した tfstate を持ち、モジュール間の値受け渡しは `terraform.tfvars` で行う。

| モジュール | 実行者 | 概要 |
|---|---|---|
| [01_azure-infra](01_azure-infra/) | Azure 基盤管理者 | VNET・NSG・DNS Zone・外部ロケーション用ストレージ等 Azure リソース群 |
| [02_databricks-workspace](02_databricks-workspace/) | データエンジニア | Databricks ワークスペース作成（この時点ではネットワーク未設定） |
| [03_ws-after-task](03_ws-after-task/) | ネットワーク管理者 | ワークスペース作成後のプライベートエンドポイント・既存 DNS Zone への VNet リンク追加 |
| [04_dbx-workspace-settings](04_dbx-workspace-settings/) | データエンジニア | Databricks プロバイダー操作（グループ・SP・カタログ等） |

---

## 01_azure-infra

- [x] `endpoint_dbfs.tf` を削除（03 へ移管）
- [x] `outputs.tf` を修正：後続モジュールへの引き渡し値（prefix、VNET/サブネット/DNS Zone/ストレージ情報）を追加
- [x] `variables.tf` を整理：ワークスペース関連の不要変数（`public_network_access_enabled`）を削除

## 02_databricks-workspace

- [x] `main.tf` を刷新：`random_string.naming` を廃止し `prefix` / `dbfs_storage_account_name` を変数化
- [x] `variables.tf` を刷新：01 の outputs を変数として定義
- [x] `databricks_workspace.tf` を修正：サブネットリソース直参照 → 変数参照に変更
- [x] `outputs.tf` を整理：`managed_resource_group_id` / `dbfs_storage_account_name` を追加
- [x] `terraform.tfvars.sample` を作成：01 の出力値を入力する形式で整備

## 03_ws-after-task

- [x] `main.tf` を刷新：`random_string.naming` 廃止、純粋な変数参照の locals に変更
- [x] `variables.tf` を刷新：01/02 の outputs を変数として定義
- [x] `private_dns_zone_dp.tf` を修正：DNS Zone 新規作成を廃止、既存 DNS Zone への VNet リンク追加のみに変更
- [x] `endpoint_backend.tf` を修正：ワークスペースリソース参照 → 変数参照に変更
- [x] `endpoint_dbfs.tf` を追加（01 から移管）：ワークスペース参照を変数に変更
- [x] `outputs.tf` を整理：不要なワークスペース出力を削除
- [x] `terraform.tfvars.sample` を作成：01/02 の出力値を入力する形式で整備

## 04_dbx-workspace-settings

- [x] `terraform_remote_state.tf` を廃止し `ws_locals.tf` に変更（変数からのマッピング）
- [x] `ws_variables.tf` に 01/02 outputs の変数定義を追加
- [x] `ws_data.tf` のメタストア参照コメントアウトを解除
- [x] `terraform.tfvars.sample` を更新：01/02 の出力値を含む形式に整備

## 共通

- [x] 各モジュールの `terraform.tfvars.sample` に「前のモジュールのどの output を入力すべきか」をコメントで明記
- [ ] コメントを全体的に整理・統一する
