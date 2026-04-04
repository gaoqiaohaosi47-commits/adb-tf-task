#==============================================================
# 001: Databricks アカウント単位でのグループ作成
#==============================================================

resource "databricks_group" "uc_users" {
  provider     = databricks.account
  display_name = var.uc_group_name
}

resource "databricks_group" "ws_admins" {
  provider     = databricks.account
  display_name = var.ws_admin_group_name
}