#==============================================================
# Databricks ワークスペース作成
#
# 前提:
#   - 01_azure-infra の VNet・サブネット・NSG が作成済みであること
#   - terraform.tfvars に 01_azure-infra の outputs 値が設定済みであること
#
# 実施:
#   - Premium SKU の Databricks ワークスペースを作成
#   - カスタム VNet インジェクション（BYO VNet）を設定
#   - DBFS ストレージアカウントを指定
#==============================================================

resource "azurerm_databricks_workspace" "dp_workspace" {
  name                                  = var.workspace_name
  resource_group_name                   = var.resource_group_name
  managed_resource_group_name           = var.managed_resource_group_name
  location                              = var.location
  sku                                   = "premium"
  tags                                  = local.tags
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = "NoAzureDatabricksRules"
  customer_managed_key_enabled          = false

  custom_parameters {
    virtual_network_id                                   = var.vnet_id
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_name                                   = var.public_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id
    storage_account_name                                 = local.dbfsname
  }
}
