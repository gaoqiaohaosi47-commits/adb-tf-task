output "dp_databricks_azure_workspace_resource_id" {
  description = "**Deprecated** The ID of the Databricks Workspace in the Azure management plane."
  value       = azurerm_databricks_workspace.dp_workspace.id
}

output "dp_workspace_url" {
  value       = "https://${azurerm_databricks_workspace.dp_workspace.workspace_url}/"
  description = "**Deprecated** Renamed to `workspace_url` to align with naming used in other modules"
}

output "workspace_url" {
  value       = "https://${azurerm_databricks_workspace.dp_workspace.workspace_url}/"
  description = "The workspace URL which is of the format 'adb-{workspaceId}.{random}.azuredatabricks.net'"
}

output "workspace_id" {
  description = "The Databricks workspace ID"
  value       = azurerm_databricks_workspace.dp_workspace.workspace_id
}


output "location" {
  value = var.location
}
output "azurerm_resource_group_name" {
  value = local.dp_rg_name
}
output "databricks_workspace_url" {
  value       = "https://${azurerm_databricks_workspace.dp_workspace.workspace_url}/"
}
output "databricks_workspace_id" {
  value       = azurerm_databricks_workspace.dp_workspace.workspace_id
}
