#==============================================================
# ローカル値・共通設定
#==============================================================

data "azurerm_client_config" "current" {}

locals {
  # 01_azure-infra / 02_databricks-workspace の outputs から tfvars で受け取る
  dbfsname       = var.dbfs_storage_account_name
  dp_rg_name     = var.resource_group_name
  dp_rg_location = var.location

  dns_zone_dpcp_id   = var.dns_zone_dpcp_id
  dns_zone_dpcp_name = var.dns_zone_dpcp_name
  dns_zone_dfs_id    = var.dns_zone_dfs_id
  dns_zone_dfs_name  = var.dns_zone_dfs_name
  dns_zone_blob_id   = var.dns_zone_blob_id
  dns_zone_blob_name = var.dns_zone_blob_name
}
