#==============================================================
# 012: スキーマ作成
#
# 前提:
#   - カタログ (011) が作成済みであること
#
# 実施:
#   - var.schema_names に指定したスキーマをカタログ内に作成
#   - UC利用グループを所有者に設定
#   - uc_users に USE_SCHEMA 等の権限を付与、ws_admins に ALL_PRIVILEGES を付与
#==============================================================

resource "databricks_schema" "this" {
  provider      = databricks.workspace
  for_each      = toset(var.schema_names)
  catalog_name  = databricks_catalog.this.name
  name          = each.value
  comment       = "Schema ${each.value} managed by Terraform"
  owner         = databricks_group.uc_users.display_name
  force_destroy = false

  properties = {
    managed_by = "terraform"
  }
}

resource "databricks_grants" "schema" {
  provider = databricks.workspace
  for_each = toset(var.schema_names)
  schema   = "${databricks_catalog.this.name}.${each.value}"

  grant {
    principal  = databricks_group.uc_users.display_name
    privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "CREATE_VOLUME", "SELECT", "MODIFY"]
  }

  grant {
    principal  = databricks_group.ws_admins.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_schema.this
  ]
}