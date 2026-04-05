#==============================================================
# DBFS プライベートエンドポイント（01_azure-infra より移管）
#
# 前提:
#   - managed_resource_group_id / dbfs_storage_account_name を
#     tfvars で受け取る（02_databricks-workspace の outputs）
#
# 実施:
#   - DBFS ストレージ向け Private Endpoint (DFS / Blob) を作成
#==============================================================

# DBFS プライベートエンドポイント (DFS)
resource "azurerm_private_endpoint" "dp_dbfspe_dfs" {
  name                = var.dbfs_dfs_private_endpoint_name
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "${var.dbfs_dfs_private_endpoint_name}-connection"
    private_connection_resource_id = "${var.managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${local.dbfsname}"
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  private_dns_zone_group {
    name                 = "${var.dbfs_dfs_private_endpoint_name}-dns-zone"
    private_dns_zone_ids = [local.dns_zone_dfs_id]
  }
}

# DBFS プライベートエンドポイント (Blob)
resource "azurerm_private_endpoint" "dp_dbfspe_blob" {
  name                = var.dbfs_blob_private_endpoint_name
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "${var.dbfs_blob_private_endpoint_name}-connection"
    private_connection_resource_id = "${var.managed_resource_group_id}/providers/Microsoft.Storage/storageAccounts/${local.dbfsname}"
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "${var.dbfs_blob_private_endpoint_name}-dns-zone"
    private_dns_zone_ids = [local.dns_zone_blob_id]
  }
}
