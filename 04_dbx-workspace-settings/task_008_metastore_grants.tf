#==============================================================
# 008: メタストアの権限設定
#==============================================================

resource "databricks_grants" "metastore" {
  count     = var.metastore_name != "" ? 1 : 0
  provider  = databricks.workspace
  metastore = data.databricks_metastore.this[0].id

  grant {
    principal = databricks_group.uc_users.display_name
    privileges = [
      "CREATE_CATALOG",
      "CREATE_CONNECTION",
      "CREATE_EXTERNAL_LOCATION",
      "CREATE_STORAGE_CREDENTIAL",
      "MANAGE_ALLOWLIST",
      "SET_SHARE_PERMISSION",
      "USE_CONNECTION",
      "USE_MARKETPLACE_ASSETS",
      "USE_PROVIDER",
      "USE_RECIPIENT",
      "USE_SHARE"
    ]
  }

  grant {
    principal = databricks_group.ws_admins.display_name
    privileges = [
      "CREATE_CATALOG",
      "CREATE_CONNECTION",
      "CREATE_EXTERNAL_LOCATION",
      "CREATE_STORAGE_CREDENTIAL",
      "MANAGE_ALLOWLIST",
      "SET_SHARE_PERMISSION",
      "USE_CONNECTION",
      "USE_MARKETPLACE_ASSETS",
      "USE_PROVIDER",
      "USE_RECIPIENT",
      "USE_SHARE"
    ]
  }

  depends_on = [
    databricks_mws_permission_assignment.uc_users,
    databricks_mws_permission_assignment.ws_admins
  ]
}