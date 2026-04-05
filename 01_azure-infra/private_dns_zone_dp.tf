#==============================================================
# Private DNS Zone
#
# 前提:
#   - Data Plane リソースグループ (main.tf) が作成済みであること
#
# 実施:
#   - Databricks / DFS / Blob 用 Private DNS Zone を作成（または既存を参照）
#   - 各 DNS Zone を Data Plane VNet にリンク
#   - create_private_dns_zones = false の場合は既存ゾーンをデータ参照のみ
#==============================================================

#--------------------------------------------------------------
# Private DNS Zone: privatelink.azuredatabricks.net
#--------------------------------------------------------------
resource "azurerm_private_dns_zone" "dnsdpcp" {
  count               = var.create_private_dns_zones ? 1 : 0
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = local.dp_rg_name
}

data "azurerm_private_dns_zone" "dnsdpcp" {
  count               = var.create_private_dns_zones ? 0 : 1
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = local.dp_rg_name
}

locals {
  dns_zone_dpcp_id      = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdpcp[0].id : data.azurerm_private_dns_zone.dnsdpcp[0].id
  dns_zone_dpcp_name    = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdpcp[0].name : data.azurerm_private_dns_zone.dnsdpcp[0].name
  dns_zone_dfs_id       = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdbfs_dfs[0].id : data.azurerm_private_dns_zone.dnsdbfs_dfs[0].id
  dns_zone_dfs_name     = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdbfs_dfs[0].name : data.azurerm_private_dns_zone.dnsdbfs_dfs[0].name
  dns_zone_blob_id      = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdbfs_blob[0].id : data.azurerm_private_dns_zone.dnsdbfs_blob[0].id
  dns_zone_blob_name    = var.create_private_dns_zones ? azurerm_private_dns_zone.dnsdbfs_blob[0].name : data.azurerm_private_dns_zone.dnsdbfs_blob[0].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dpcpdnszonevnetlink" {
  name                  = "${local.prefix}-dpcpspokevnetconnection"
  resource_group_name   = local.dp_rg_name
  private_dns_zone_name = local.dns_zone_dpcp_name
  virtual_network_id    = local.dp_vnet_id
}

#--------------------------------------------------------------
# Private DNS Zone: privatelink.dfs.core.windows.net
#--------------------------------------------------------------
resource "azurerm_private_dns_zone" "dnsdbfs_dfs" {
  count               = var.create_private_dns_zones ? 1 : 0
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = local.dp_rg_name
}

data "azurerm_private_dns_zone" "dnsdbfs_dfs" {
  count               = var.create_private_dns_zones ? 0 : 1
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = local.dp_rg_name
}

#--------------------------------------------------------------
# Private DNS Zone: privatelink.blob.core.windows.net
#--------------------------------------------------------------
resource "azurerm_private_dns_zone" "dnsdbfs_blob" {
  count               = var.create_private_dns_zones ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.dp_rg_name
}

data "azurerm_private_dns_zone" "dnsdbfs_blob" {
  count               = var.create_private_dns_zones ? 0 : 1
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.dp_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_dfs" {
  name                  = "${local.prefix}-dbfsspokevnetconnection-dfs"
  resource_group_name   = local.dp_rg_name
  private_dns_zone_name = local.dns_zone_dfs_name
  virtual_network_id    = local.dp_vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_blob" {
  name                  = "${local.prefix}-dbfsspokevnetconnection-blob"
  resource_group_name   = local.dp_rg_name
  private_dns_zone_name = local.dns_zone_blob_name
  virtual_network_id    = local.dp_vnet_id
}
