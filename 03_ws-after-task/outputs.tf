output "backend_private_endpoint_id" {
  description = "Backend (UI/API) プライベートエンドポイント ID"
  value       = azurerm_private_endpoint.dp_dpcp.id
}

output "dbfs_dfs_private_endpoint_id" {
  description = "DBFS DFS プライベートエンドポイント ID"
  value       = azurerm_private_endpoint.dp_dbfspe_dfs.id
}

output "dbfs_blob_private_endpoint_id" {
  description = "DBFS Blob プライベートエンドポイント ID"
  value       = azurerm_private_endpoint.dp_dbfspe_blob.id
}
