#==============================================================
# VNet・サブネット・NSG
#
# 前提:
#   - Data Plane リソースグループ (main.tf) が作成済みであること
#
# 実施:
#   - VNet を作成（または既存 VNet を参照）
#   - Databricks 用 public / private サブネットを作成し NSG をアタッチ
#   - Private Link 用サブネットを作成
#==============================================================

#--------------------------------------------------------------
# 既存 VNet のデータ参照（use_existing_vnet = true の場合）
#--------------------------------------------------------------
locals {
  existing_vnet_rg = var.existing_vnet_resource_group_name != "" ? var.existing_vnet_resource_group_name : local.dp_rg_name
}

data "azurerm_virtual_network" "dp_vnet" {
  count               = var.use_existing_vnet ? 1 : 0
  name                = var.existing_vnet_name
  resource_group_name = local.existing_vnet_rg
}

#--------------------------------------------------------------
# VNet（use_existing_vnet = false の場合のみ新規作成）
#--------------------------------------------------------------
resource "azurerm_virtual_network" "dp_vnet" {
  count               = var.use_existing_vnet ? 0 : 1
  name                = var.vnet_name
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  address_space       = [var.cidr_dp]
  tags                = local.tags
}

resource "azurerm_network_security_group" "dp_sg" {
  name                = var.nsg_name
  location            = local.dp_rg_location
  resource_group_name = local.dp_rg_name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "dp_aad" {
  name                        = var.nsg_rule_aad_name
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureActiveDirectory"
  resource_group_name         = local.dp_rg_name
  network_security_group_name = azurerm_network_security_group.dp_sg.name
}

resource "azurerm_network_security_rule" "dp_azfrontdoor" {
  name                        = var.nsg_rule_frontdoor_name
  priority                    = 201
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureFrontDoor.Frontend"
  resource_group_name         = local.dp_rg_name
  network_security_group_name = azurerm_network_security_group.dp_sg.name
}

resource "azurerm_subnet" "dp_public" {
  name                 = var.subnet_public_name
  resource_group_name  = local.dp_rg_name
  virtual_network_name = local.dp_vnet_name
  address_prefixes     = [cidrsubnet(var.cidr_dp, 6, 0)]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "dp_public" {
  subnet_id                 = azurerm_subnet.dp_public.id
  network_security_group_id = azurerm_network_security_group.dp_sg.id
}

resource "azurerm_subnet" "dp_private" {
  name                 = var.subnet_private_name
  resource_group_name  = local.dp_rg_name
  virtual_network_name = local.dp_vnet_name
  address_prefixes     = [cidrsubnet(var.cidr_dp, 6, 1)]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }

  service_endpoints = var.private_subnet_endpoints
}

resource "azurerm_subnet_network_security_group_association" "dp_private" {
  subnet_id                 = azurerm_subnet.dp_private.id
  network_security_group_id = azurerm_network_security_group.dp_sg.id
}

resource "azurerm_subnet" "dp_plsubnet" {
  name                              = var.subnet_privatelink_name
  resource_group_name               = local.dp_rg_name
  virtual_network_name              = local.dp_vnet_name
  address_prefixes                  = [cidrsubnet(var.cidr_dp, 6, 2)]
  private_endpoint_network_policies = "Disabled"
}
