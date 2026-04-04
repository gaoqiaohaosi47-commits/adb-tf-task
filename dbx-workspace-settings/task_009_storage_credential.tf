#==============================================================
# 009: 資格情報 (Storage Credential)
#      - リモートステートからアクセスコネクタ/マネージドID参照
#      - ISOLATED ワークスペース限定
#      - UC利用グループを所有者に
#      - 実行ユーザーに CREATE_EXTERNAL_LOCATION 権限を付与
#==============================================================

resource "databricks_storage_credential" "ext_loc" {
  provider = databricks.workspace
  name     = "${local.ext_access_connector_name}-cred"
  comment  = "Storage credential for external location"

  azure_managed_identity {
    access_connector_id = local.ext_access_connector_id
    managed_identity_id = local.ext_managed_identity_id
  }

  isolation_mode = "ISOLATION_MODE_ISOLATED"
  owner          = databricks_group.uc_users.display_name

  depends_on = [
    databricks_mws_permission_assignment.uc_users,
    # databricks_grants.metastore
  ]
}

resource "databricks_workspace_binding" "credential_binding" {
  provider       = databricks.workspace
  securable_name = databricks_storage_credential.ext_loc.name
  securable_type = "storage_credential"
  workspace_id   = local.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}

resource "databricks_grants" "storage_credential" {
  provider           = databricks.workspace
  storage_credential = databricks_storage_credential.ext_loc.name

  grant {
    principal  = databricks_group.uc_users.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = databricks_group.ws_admins.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_storage_credential.ext_loc
  ]
}