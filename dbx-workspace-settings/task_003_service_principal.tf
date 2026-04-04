#==============================================================
# 003: サービスプリンシパルの作成・エンタイトルメント設定
#==============================================================

resource "databricks_service_principal" "automation" {
  provider     = databricks.account
  display_name = var.service_principal_display_name
}

resource "databricks_mws_permission_assignment" "sp_automation" {
  provider     = databricks.account
  workspace_id = local.workspace_id
  principal_id = databricks_service_principal.automation.id
  permissions  = ["USER"]
}

resource "databricks_entitlements" "sp_automation" {
  provider              = databricks.workspace
  service_principal_id  = databricks_service_principal.automation.id
  workspace_access      = true
  databricks_sql_access = true

  depends_on = [
    databricks_mws_permission_assignment.sp_automation
  ]
}