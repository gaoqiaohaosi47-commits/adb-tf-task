#==============================================================
# 010: 外部ロケーション
#
# 前提:
#   - リモートステートからストレージアカウント情報を参照
#   - Storage Credential (009) が作成済みであること
#   - ISOLATED ワークスペース限定
#
# 実施:
#   - External Location を作成
#   - UC利用グループを所有者に設定
#   - uc_users / ws_admins グループに ALL_PRIVILEGES を付与
#==============================================================

# 権限反映の待機（Databricks側の伝播遅延対策）
resource "time_sleep" "wait_for_credential_grants" {
  depends_on = [
    databricks_grants.storage_credential
  ]

  create_duration = "30s"
}

resource "databricks_external_location" "this" {
  provider        = databricks.workspace
  name            = "${local.ext_storage_account_name}-ext-location"
  comment         = "External location for Unity Catalog"
  url             = local.ext_abfss_url
  credential_name = databricks_storage_credential.ext_loc.name
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
  owner           = databricks_group.uc_users.display_name

  depends_on = [
    databricks_storage_credential.ext_loc,
    databricks_grants.storage_credential,
    time_sleep.wait_for_credential_grants
  ]
}

resource "databricks_workspace_binding" "ext_location_binding" {
  provider       = databricks.workspace
  securable_name = databricks_external_location.this.name
  securable_type = "external_location"
  workspace_id   = local.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}

resource "databricks_grants" "external_location" {
  provider          = databricks.workspace
  external_location = databricks_external_location.this.name

  grant {
    principal  = databricks_group.uc_users.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = databricks_group.ws_admins.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
}
