#--------------------------------------------------------------
# 外部ロケーション用ストレージ - プライベートエンドポイント (DFS)
# ※ DNSゾーンは既存の azurerm_private_dns_zone.dnsdbfs_dfs を共用
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "ext_loc_dfs" {
  count               = var.ext_storage_public_access_enabled ? 0 : 1
  name                = "ext-loc-pvtendpoint-dfs"
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = azurerm_subnet.dp_plsubnet.id
  tags                = local.tags

  private_service_connection {
    name                           = "ple-${local.prefix}-ext-loc-dfs"
    private_connection_resource_id = azurerm_storage_account.external_location.id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  private_dns_zone_group {
    name                 = "ext-loc-private-dns-zone-dfs"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdbfs_dfs.id]
  }
}

#--------------------------------------------------------------
# 外部ロケーション用ストレージ - プライベートエンドポイント (Blob)
# ※ DNSゾーンは既存の azurerm_private_dns_zone.dnsdbfs_blob を共用
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "ext_loc_blob" {
  count               = var.ext_storage_public_access_enabled ? 0 : 1
  name                = "ext-loc-pvtendpoint-blob"
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = azurerm_subnet.dp_plsubnet.id
  tags                = local.tags

  private_service_connection {
    name                           = "ple-${local.prefix}-ext-loc-blob"
    private_connection_resource_id = azurerm_storage_account.external_location.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "ext-loc-private-dns-zone-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdbfs_blob.id]
  }
}