#==============================================================
# 出力値 - 外部ロケーション関連（04_dbx-workspace-settings へ引き渡し）
#==============================================================

output "ext_loc_storage_account_name" {
  description = "外部ロケーション用ストレージアカウント名"
  value       = azurerm_storage_account.external_location.name
}

output "ext_loc_storage_account_id" {
  description = "外部ロケーション用ストレージアカウントID"
  value       = azurerm_storage_account.external_location.id
}

output "ext_loc_container_name" {
  description = "外部ロケーション用コンテナ名"
  value       = azurerm_storage_container.external_location.name
}

output "ext_loc_abfss_url" {
  description = "外部ロケーションで使用するABFSS URL"
  value       = "abfss://${azurerm_storage_container.external_location.name}@${azurerm_storage_account.external_location.name}.dfs.core.windows.net/"
}

output "ext_loc_managed_identity_id" {
  description = "ユーザー割り当てマネージドIDのリソースID"
  value       = azurerm_user_assigned_identity.external_location.id
}

output "ext_loc_managed_identity_client_id" {
  description = "ユーザー割り当てマネージドIDのクライアントID"
  value       = azurerm_user_assigned_identity.external_location.client_id
}

output "ext_loc_managed_identity_principal_id" {
  description = "ユーザー割り当てマネージドIDのプリンシパルID"
  value       = azurerm_user_assigned_identity.external_location.principal_id
}

output "ext_loc_access_connector_id" {
  description = "Databricksアクセスコネクタのリソースid"
  value       = azurerm_databricks_access_connector.external_location.id
}

output "ext_loc_access_connector_name" {
  description = "Databricksアクセスコネクタ名"
  value       = azurerm_databricks_access_connector.external_location.name
}