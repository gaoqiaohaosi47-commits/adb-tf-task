#==============================================================
# 出力値（03_ws-after-task / 04_dbx-workspace-settings へ引き渡し）
#==============================================================
output "workspace_url" {
  description = "Databricks ワークスペース URL"
  value       = "https://${azurerm_databricks_workspace.dp_workspace.workspace_url}/"
}

output "workspace_id" {
  description = "Databricks ワークスペース ID（数値）"
  value       = azurerm_databricks_workspace.dp_workspace.workspace_id
}

output "workspace_resource_id" {
  description = "Databricks ワークスペースの Azure リソース ID"
  value       = azurerm_databricks_workspace.dp_workspace.id
}

output "managed_resource_group_id" {
  description = "Databricks マネージドリソースグループ ID（DBFS エンドポイント作成に必要）"
  value       = azurerm_databricks_workspace.dp_workspace.managed_resource_group_id
}

output "dbfs_storage_account_name" {
  description = "DBFS ストレージアカウント名（03 での Private Endpoint 作成に必要）"
  value       = local.dbfsname
}
