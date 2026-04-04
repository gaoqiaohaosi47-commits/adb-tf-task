#==============================================================
# 004: サービスプリンシパルのシークレット発行
#==============================================================

resource "databricks_service_principal_secret" "automation" {
  provider             = databricks.account
  service_principal_id = databricks_service_principal.automation.id
}