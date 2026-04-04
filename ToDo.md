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

- [ ] `endpoint_dbfs.tf` を削除（ワークスペース ID 参照のため 03 へ移管）
- [ ] `endpoint_backend.tf` を削除（同上）
- [ ] `outputs.tf` を修正：ワークスペース参照を削除し、後続モジュールへの引き渡し値を追加
  - 出力すべき値: RG 名、VNET 名/ID、サブネット名/ID（public/private/privatelink）、NSG アソシエーション ID、DNS Zone 名/ID、ストレージアカウント名/ID、アクセスコネクタ名/ID、マネージド ID 名/ID、prefix
- [ ] `variables.tf` を整理：ワークスペース関連の不要変数を削除
- [ ] `terraform.tfvars.sample` を更新：01 の入力変数に合わせて整理
- [ ] `private_dns_zone_dp.tf` の整理：VNet リンクは 01 の VNET に対して追加するのでここで正しい（既存 DNS Zone 参照オプションは維持）

## 02_databricks-workspace

- [ ] `main.tf` を刷新：`random_string.naming` を廃止し `prefix` を変数化（01 の outputs から tfvars で受け取る）
- [ ] `variables.tf` を刷新：01 の outputs（VNET ID、サブネット名、NSG アソシエーション ID、RG 名、ロケーション、prefix）を変数として定義
- [ ] `databricks_workspace.tf` を修正：サブネットリソース直参照 → 変数参照に変更
- [ ] `outputs.tf` を整理：03 への引き渡し値を追加（workspace ID、workspace URL、managed_resource_group_id、DBFS ストレージアカウント名）
- [ ] `terraform.tfvars.sample` を作成：01 の出力値を入力する形式で整備

## 03_ws-after-task

- [ ] `main.tf` を刷新：`random_string.naming` 廃止、VNET 関連 locals を変数参照に変更（prefix、RG 名、ロケーション、VNET ID、サブネット ID を変数で受け取る）
- [ ] `variables.tf` を刷新：01/02 の outputs（prefix、RG 名、ロケーション、VNET ID、privatelink サブネット ID、DNS Zone 名/RG、ワークスペース ID、managed_resource_group_id、DBFS ストレージアカウント名）を変数として定義
- [ ] `private_dns_zone_dp.tf` を修正：DNS Zone の新規作成を廃止し `data` ソースのみに変更（既存 DNS Zone への VNet リンク追加のみ実施）
- [ ] `endpoint_backend.tf` を修正：`azurerm_databricks_workspace.dp_workspace.id` → 変数参照に変更
- [ ] `endpoint_dbfs.tf` を追加（01 から移管）：ワークスペース参照を変数に変更
- [ ] `outputs.tf` を整理：不要なワークスペース出力を削除
- [ ] `terraform.tfvars.sample` を作成：01/02 の出力値を入力する形式で整備

## 04_dbx-workspace-settings

- [ ] `terraform_remote_state.tf` を廃止し、参照値を `ws_variables.tf` の変数 + `terraform.tfvars` に移行
- [ ] `ws_providers.tf` を修正：ワークスペース URL を変数参照に変更
- [ ] `terraform.tfvars.sample` を更新：02 の出力値（workspace URL 等）と外部ロケーション情報を追加

## 共通

- [ ] 各モジュールの `terraform.tfvars.sample` に「前のモジュールのどの output を入力すべきか」をコメントで明記
- [ ] コメントを全体的に整理・統一する
