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
- [ ] 01_azure-infra のリソース命名を `random_string` / Epoch ベースから変数指定に変更
  - 背景: プロジェクトオーナーがリソース名を自分で決定したい（システム自動生成を廃止）
  - `main.tf`: `random_string.naming` リソースを削除、`local.prefix` / `local.dbfsname` を `var.prefix` / `var.dbfs_storage_account_name` に変更
  - `local.tags` の `Epoch` エントリを削除
  - `variables.tf`: `prefix`（string）・`dbfs_storage_account_name`（string）変数を追加
  - `terraform.tfvars.sample`: 上記変数の記入欄を追加
  - 注意: 02_databricks-workspace / 03_ws-after-task はすでに変数ベースに変更済み

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
- [ ] 一括実行時の権限伝播エラーを解消する
  - `task_009` (Storage Credential) 作成後、WS バインドが Databricks 側に反映される前に `task_010` (External Location) が実行されてエラーになる
  - `time_sleep` または `depends_on` で反映待ちを明示的に追加
  - 実行順序の整理と各タスク間の依存関係を再確認
- [ ] グループ・SP の管理権限問題を解消する
  - 現状: 作成者のみがグループ・SP を管理できる
  - 対応: 管理者グループ（例: `ws-group-managers`）を追加し、グループ管理者権限を付与

## 共通

- [x] 各モジュールの `terraform.tfvars.sample` に「前のモジュールのどの output を入力すべきか」をコメントで明記
- [ ] コメントを全体的に整理・統一する
- [ ] 各モジュールの README に含まれるファイル・変数・実行手順を記載する
