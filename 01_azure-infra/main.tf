#==============================================================
# ローカル値・共通設定
#==============================================================

data "azurerm_client_config" "current" {}

# 任意: オーナータグ付与（現在のログインユーザー）
data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
  }

  dp_rg_name     = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].name : data.azurerm_resource_group.dp_rg[0].name
  dp_rg_id       = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].id : data.azurerm_resource_group.dp_rg[0].id
  dp_rg_location = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].location : (var.location == "" ? data.azurerm_resource_group.dp_rg[0].location : var.location)

  dp_vnet_name = var.use_existing_vnet ? data.azurerm_virtual_network.dp_vnet[0].name : azurerm_virtual_network.dp_vnet[0].name
  dp_vnet_id   = var.use_existing_vnet ? data.azurerm_virtual_network.dp_vnet[0].id : azurerm_virtual_network.dp_vnet[0].id
}

resource "azurerm_resource_group" "dp_rg" {
  count    = var.create_data_plane_resource_group ? 1 : 0
  name     = var.data_plane_resource_group_name
  location = var.location
  tags     = local.tags
}

data "azurerm_resource_group" "dp_rg" {
  count = var.create_data_plane_resource_group ? 0 : 1
  name  = var.existing_data_plane_resource_group_name
}