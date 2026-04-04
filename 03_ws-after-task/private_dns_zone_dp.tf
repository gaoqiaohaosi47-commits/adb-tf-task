#==============================================================
# 03_ws-after-task: 既存 Private DNS Zone への VNet リンク追加
#
# 前提:
#   - DNS Zone は 01_azure-infra で作成済み（または既存の共有 DNS Zone）
#   - DNS Zone の ID/名前を tfvars で受け取る
#
# 実施:
#   - ワークスペース用 VNET（01 で作成）を既存 DNS Zone にリンク
#==============================================================

resource "azurerm_private_dns_zone_virtual_network_link" "dpcpdnszonevnetlink" {
  name                  = "${local.prefix}-dpcpspokevnetconnection"
  resource_group_name   = var.dns_zone_resource_group_name
  private_dns_zone_name = local.dns_zone_dpcp_name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_dfs" {
  name                  = "${local.prefix}-dbfsspokevnetconnection-dfs"
  resource_group_name   = var.dns_zone_resource_group_name
  private_dns_zone_name = local.dns_zone_dfs_name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_blob" {
  name                  = "${local.prefix}-dbfsspokevnetconnection-blob"
  resource_group_name   = var.dns_zone_resource_group_name
  private_dns_zone_name = local.dns_zone_blob_name
  virtual_network_id    = var.vnet_id
}
