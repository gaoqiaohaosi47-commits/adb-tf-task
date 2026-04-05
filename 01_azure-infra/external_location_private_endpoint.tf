#==============================================================
# 外部ロケーション用ストレージ - プライベートエンドポイント
#
# 前提:
#   - 外部ロケーション用ストレージ (external_location_storage.tf) が作成済みであること
#   - Private DNS Zone (private_dns_zone_dp.tf) が作成済みであること
#   - ext_storage_public_access_enabled = false の場合のみ作成
#
# 実施:
#   - DFS / Blob 向けプライベートエンドポイントを作成
#   - 各 DNS Zone グループに登録
#==============================================================

#--------------------------------------------------------------
# 外部ロケーション用ストレージ - プライベートエンドポイント (DFS)
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "ext_loc_dfs" {
  count               = var.ext_storage_public_access_enabled ? 0 : 1
  name                = "${local.prefix}-ext-loc-pvtendpoint-dfs"
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
    name                 = "${local.prefix}-ext-loc-private-dns-zone-dfs"
    private_dns_zone_ids = [local.dns_zone_dfs_id]
  }
}

#--------------------------------------------------------------
# 外部ロケーション用ストレージ - プライベートエンドポイント (Blob)
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "ext_loc_blob" {
  count               = var.ext_storage_public_access_enabled ? 0 : 1
  name                = "${local.prefix}-ext-loc-pvtendpoint-blob"
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
    name                 = "${local.prefix}-ext-loc-private-dns-zone-blob"
    private_dns_zone_ids = [local.dns_zone_blob_id]
  }
}
