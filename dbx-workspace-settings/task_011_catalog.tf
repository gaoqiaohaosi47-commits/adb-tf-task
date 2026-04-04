#==============================================================
# 011: カタログ作成
#      - 外部ロケーションのストレージルートを指定
#      - ISOLATED ワークスペース限定
#      - UC利用グループを所有者に
#==============================================================

resource "databricks_catalog" "this" {
  provider       = databricks.workspace
  name           = var.catalog_name
  comment        = "Catalog managed by Terraform"
  storage_root   = "${local.ext_abfss_url}${var.catalog_name}"
  isolation_mode = "ISOLATED"
  owner          = databricks_group.uc_users.display_name
  force_destroy  = false

  properties = {
    managed_by = "terraform"
  }

  depends_on = [
    databricks_external_location.this
  ]
}

resource "databricks_workspace_binding" "catalog_binding" {
  provider       = databricks.workspace
  securable_name = databricks_catalog.this.name
  securable_type = "catalog"
  workspace_id   = local.workspace_id
  binding_type   = "BINDING_TYPE_READ_WRITE"
}

resource "databricks_grants" "catalog" {
  provider = databricks.workspace
  catalog  = databricks_catalog.this.name

  grant {
    principal  = databricks_group.uc_users.display_name
    privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "CREATE_VOLUME"]
  }

  grant {
    principal  = databricks_group.ws_admins.display_name
    privileges = ["ALL_PRIVILEGES"]
  }
}