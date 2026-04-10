#==============================================================
# CMK Key Vault — プライベートエンドポイント
#
# 前提:
#   - cmk_key_vault.tf の Key Vault が作成済みであること
#   - vnet_dp.tf の Private Link サブネットが作成済みであること
#
# 実施:
#   - privatelink.vaultcore.azure.net プライベート DNS Zone を作成
#   - VNet リンクを作成
#   - Key Vault プライベートエンドポイントを作成
#==============================================================

#--------------------------------------------------------------
# privatelink.vaultcore.azure.net プライベート DNS Zone
#--------------------------------------------------------------
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.dp_rg_name
  tags                = local.tags
}

#--------------------------------------------------------------
# VNet リンク
#--------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = var.dns_vnet_link_kv_name
  resource_group_name   = local.dp_rg_name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = local.dp_vnet_id
  tags                  = local.tags
}

#--------------------------------------------------------------
# Key Vault プライベートエンドポイント
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "cmk_kv" {
  name                = var.key_vault_private_endpoint_name
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = azurerm_subnet.dp_plsubnet.id
  tags                = local.tags

  private_service_connection {
    name                           = "${var.key_vault_private_endpoint_name}-connection"
    private_connection_resource_id = azurerm_key_vault.cmk.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "${var.key_vault_private_endpoint_name}-dns-zone"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
  }
}
