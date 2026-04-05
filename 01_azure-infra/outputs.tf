#==============================================================
# 出力値（02_databricks-workspace / 03_ws-after-task / 04_dbx-workspace-settings へ引き渡し）
#==============================================================

#--------------------------------------------------------------
# 基本情報
#--------------------------------------------------------------
output "dbfs_storage_account_name" {
  description = "Databricks DBFS ストレージアカウント名（02 でのワークスペース作成時に使用）"
  value       = var.dbfs_storage_account_name
}

output "resource_group_name" {
  description = "Data Plane リソースグループ名"
  value       = local.dp_rg_name
}

output "location" {
  description = "デプロイリージョン"
  value       = local.dp_rg_location
}

#--------------------------------------------------------------
# ネットワーク情報（02/03 への引き渡し用）
#--------------------------------------------------------------
output "vnet_id" {
  description = "Data Plane VNet ID"
  value       = local.dp_vnet_id
}

output "vnet_name" {
  description = "Data Plane VNet 名"
  value       = local.dp_vnet_name
}

output "public_subnet_name" {
  description = "Databricks パブリックサブネット名"
  value       = azurerm_subnet.dp_public.name
}

output "private_subnet_name" {
  description = "Databricks プライベートサブネット名"
  value       = azurerm_subnet.dp_private.name
}

output "privatelink_subnet_id" {
  description = "Private Link サブネット ID（プライベートエンドポイント作成用）"
  value       = azurerm_subnet.dp_plsubnet.id
}

output "public_subnet_nsg_association_id" {
  description = "パブリックサブネット NSG アソシエーション ID"
  value       = azurerm_subnet_network_security_group_association.dp_public.id
}

output "private_subnet_nsg_association_id" {
  description = "プライベートサブネット NSG アソシエーション ID"
  value       = azurerm_subnet_network_security_group_association.dp_private.id
}

#--------------------------------------------------------------
# Private DNS Zone 情報（03 への引き渡し用）
#--------------------------------------------------------------
output "dns_zone_dpcp_id" {
  description = "privatelink.azuredatabricks.net DNS Zone ID"
  value       = local.dns_zone_dpcp_id
}

output "dns_zone_dpcp_name" {
  description = "privatelink.azuredatabricks.net DNS Zone 名"
  value       = local.dns_zone_dpcp_name
}

output "dns_zone_dfs_id" {
  description = "privatelink.dfs.core.windows.net DNS Zone ID"
  value       = local.dns_zone_dfs_id
}

output "dns_zone_dfs_name" {
  description = "privatelink.dfs.core.windows.net DNS Zone 名"
  value       = local.dns_zone_dfs_name
}

output "dns_zone_blob_id" {
  description = "privatelink.blob.core.windows.net DNS Zone ID"
  value       = local.dns_zone_blob_id
}

output "dns_zone_blob_name" {
  description = "privatelink.blob.core.windows.net DNS Zone 名"
  value       = local.dns_zone_blob_name
}
