#==============================================================
# 変数定義
#==============================================================

#--------------------------------------------------------------
# 01_azure-infra outputs から受け取る値
#--------------------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "01_azure-infra の outputs.resource_group_name"
}

variable "location" {
  type        = string
  description = "01_azure-infra の outputs.location"
}

variable "vnet_id" {
  type        = string
  description = "01_azure-infra の outputs.vnet_id（DNS Zone VNet リンク用）"
}

variable "privatelink_subnet_id" {
  type        = string
  description = "01_azure-infra の outputs.privatelink_subnet_id（Private Endpoint 配置先）"
}

variable "dns_zone_dpcp_id" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_dpcp_id"
}

variable "dns_zone_dpcp_name" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_dpcp_name"
}

variable "dns_zone_dfs_id" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_dfs_id"
}

variable "dns_zone_dfs_name" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_dfs_name"
}

variable "dns_zone_blob_id" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_blob_id"
}

variable "dns_zone_blob_name" {
  type        = string
  description = "01_azure-infra の outputs.dns_zone_blob_name"
}

variable "dns_zone_resource_group_name" {
  type        = string
  description = "既存 Private DNS Zone が存在する RG 名（通常は resource_group_name と同値）"
}

#--------------------------------------------------------------
# 02_databricks-workspace outputs から受け取る値
#--------------------------------------------------------------
variable "workspace_resource_id" {
  type        = string
  description = "02_databricks-workspace の outputs.workspace_resource_id（Backend PE 接続先）"
}

variable "managed_resource_group_id" {
  type        = string
  description = "02_databricks-workspace の outputs.managed_resource_group_id（DBFS PE 接続先）"
}

variable "dbfs_storage_account_name" {
  type        = string
  description = "02_databricks-workspace の outputs.dbfs_storage_account_name"
}

#--------------------------------------------------------------
# リソース命名
#--------------------------------------------------------------
variable "dns_vnet_link_dpcp_name" {
  type        = string
  description = "privatelink.azuredatabricks.net DNS Zone への VNet リンク名"
}

variable "dns_vnet_link_dfs_name" {
  type        = string
  description = "privatelink.dfs.core.windows.net DNS Zone への VNet リンク名"
}

variable "dns_vnet_link_blob_name" {
  type        = string
  description = "privatelink.blob.core.windows.net DNS Zone への VNet リンク名"
}

variable "backend_private_endpoint_name" {
  type        = string
  description = "Databricks UI/API 向け Backend プライベートエンドポイント名"
}

variable "dbfs_dfs_private_endpoint_name" {
  type        = string
  description = "DBFS DFS プライベートエンドポイント名"
}

variable "dbfs_blob_private_endpoint_name" {
  type        = string
  description = "DBFS Blob プライベートエンドポイント名"
}

#--------------------------------------------------------------
# Azure 認証
#--------------------------------------------------------------
variable "subscription_id" {
  type        = string
  description = "Azure サブスクリプション ID"
}
