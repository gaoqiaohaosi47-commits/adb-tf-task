#==============================================================
# Backend (UI/API) プライベートエンドポイント
#
# 前提:
#   - ワークスペースリソース ID を tfvars で受け取る（02_databricks-workspace の outputs）
#
# 実施:
#   - Databricks UI/API 向け Private Endpoint を作成
#==============================================================

resource "azurerm_private_endpoint" "dp_dpcp" {
  name                = "${local.prefix}-dpcppvtendpoint-dp"
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "ple-${local.prefix}-dp-dpcp"
    private_connection_resource_id = var.workspace_resource_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "${local.prefix}-dp-private-dns-zone-dpcp"
    private_dns_zone_ids = [local.dns_zone_dpcp_id]
  }
}
