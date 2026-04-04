# ToDO : 同一RGのデプロイを有効に
resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {}

# 任意: オーナータグ付与（現在のログインユーザー）
data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  prefix   = join("-", ["tfdemo", random_string.naming.result])
  dbfsname = join("", ["dbfs", random_string.naming.result]) // dbfs name must not have special chars

  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
    Epoch       = random_string.naming.result
  }

  dp_rg_name     = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].name : data.azurerm_resource_group.dp_rg[0].name
  dp_rg_id       = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].id : data.azurerm_resource_group.dp_rg[0].id
  dp_rg_location = var.create_data_plane_resource_group ? azurerm_resource_group.dp_rg[0].location : (var.location == "" ? data.azurerm_resource_group.dp_rg[0].location : var.location)
}

resource "azurerm_resource_group" "dp_rg" {
  count    = var.create_data_plane_resource_group ? 1 : 0
  name     = "adb-dp-${local.prefix}-rg"
  location = var.location
  tags     = local.tags
}

data "azurerm_resource_group" "dp_rg" {
  count = var.create_data_plane_resource_group ? 0 : 1
  name  = var.existing_data_plane_resource_group_name
}