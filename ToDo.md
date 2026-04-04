# ToDo

## adb-with-private-link-standard

- [x] 既存 RG を参照する（`create_data_plane_resource_group = false` のパスを検証）
- [x] 既存の VNET を参照する（`use_existing_vnet` 変数で切り替え）
- [x] ワークスペースを作成する（`public_network_access_enabled` を変数参照に修正）
- [x] 同一 RG へのデプロイを有効化（`random_string.naming` の ToDO コメントを削除）
- [x] 同一 RG の場合、既存の Private DNS Zone を参照する（`create_private_dns_zones` 変数で切り替え）
- [x] prefix を使わないハードコードされたリソース名を `local.prefix` で一意化し、複数環境の競合を回避する
  - [endpoint_dbfs.tf](adb-with-private-link-standard/endpoint_dbfs.tf): `dbfspvtendpoint-dp-dfs`, `dbfspvtendpoint-dp-blob`, `private-dns-zone-dbfs-dfs`, `private-dns-zone-dbfs-blob`
  - [endpoint_backend.tf](adb-with-private-link-standard/endpoint_backend.tf): `dpcppvtendpoint-dp`, `dp-private-dns-zone-dpcp`
  - [external_location_private_endpoint.tf](adb-with-private-link-standard/external_location_private_endpoint.tf): `ext-loc-pvtendpoint-dfs`, `ext-loc-pvtendpoint-blob`, `ext-loc-private-dns-zone-dfs`, `ext-loc-private-dns-zone-blob`
  - [private_dns_zone_dp.tf](adb-with-private-link-standard/private_dns_zone_dp.tf): `dpcpspokevnetconnection`, `dbfsspokevnetconnection-dfs`, `dbfsspokevnetconnection-blob`
  - [vnet_dp.tf](adb-with-private-link-standard/vnet_dp.tf): `AllowAAD-dp`, `AllowAzureFrontDoor-dp`

## dbx-workspace-settings

- [x] グループ・サービスプリンシパルのグループ管理者権限を変更（SP を ws_admins グループに追加）
- [x] 全ユーザー（All Account Users）に SQL ウェアハウスの実行権限を付与（`users` グループに CAN_USE を追加）
- [x] ファイルヘッダーコメントを「前提条件」と「実施内容」に分けて整理する
  - 対象ファイル: [task_009](dbx-workspace-settings/task_009_storage_credential.tf), [task_010](dbx-workspace-settings/task_010_external_location.tf), [task_011](dbx-workspace-settings/task_011_catalog.tf), [task_012](dbx-workspace-settings/task_012_schema.tf), [task_013](dbx-workspace-settings/task_013_volume.tf), [task_014](dbx-workspace-settings/task_014_ncc.tf), [task_015](dbx-workspace-settings/task_015_network_policy.tf)
- [x] インライン TODO コメントをヘッダーに集約し、コードブロック内から除去する
  - [task_002](dbx-workspace-settings/task_002_workspace_group_assignment.tf): `# ToDO グループ、サービスプリンシパルの権限を変更`
  - [task_005](dbx-workspace-settings/task_005_sql_warehouse.tf): `# TODO 全てのユーザーに権限`

## 共通

- [x] 既存の同一 RG に対して Terraform を複数回実行し、複数環境を構築できるコードに改修する
- [ ] コメントを全体的に整理・統一する
