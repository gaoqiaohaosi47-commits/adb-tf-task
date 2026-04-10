#==============================================================
# 変数定義
#==============================================================

#--------------------------------------------------------------
# リソース命名
#--------------------------------------------------------------
variable "data_plane_resource_group_name" {
  type        = string
  description = "Data Plane リソースグループ名（create_data_plane_resource_group = true の場合に使用）"
  default     = ""
}

variable "vnet_name" {
  type        = string
  description = "Data Plane VNet 名"
  default     = "dp-vnet"
}

variable "nsg_name" {
  type        = string
  description = "NSG 名"
  default     = "dp-nsg"
}

variable "nsg_rule_aad_name" {
  type        = string
  description = "AAD 許可 NSG ルール名"
  default     = "AllowAAD"
}

variable "nsg_rule_frontdoor_name" {
  type        = string
  description = "Azure Front Door 許可 NSG ルール名"
  default     = "AllowAzureFrontDoor"
}

variable "subnet_public_name" {
  type        = string
  description = "Databricks パブリックサブネット名"
  default     = "dp-public"
}

variable "subnet_private_name" {
  type        = string
  description = "Databricks プライベートサブネット名"
  default     = "dp-private"
}

variable "subnet_privatelink_name" {
  type        = string
  description = "Private Link サブネット名"
  default     = "dp-privatelink"
}

variable "dns_vnet_link_dpcp_name" {
  type        = string
  description = "privatelink.azuredatabricks.net DNS Zone の VNet リンク名"
  default     = "dpcp-vnetlink"
}

variable "dns_vnet_link_dfs_name" {
  type        = string
  description = "privatelink.dfs.core.windows.net DNS Zone の VNet リンク名"
  default     = "dfs-vnetlink"
}

variable "dns_vnet_link_blob_name" {
  type        = string
  description = "privatelink.blob.core.windows.net DNS Zone の VNet リンク名"
  default     = "blob-vnetlink"
}

variable "ext_loc_identity_name" {
  type        = string
  description = "外部ロケーション用マネージド ID 名"
  default     = "ext-loc-identity"
}

variable "ext_loc_access_connector_name" {
  type        = string
  description = "外部ロケーション用 Databricks アクセスコネクタ名"
  default     = "ext-loc-access-connector"
}

variable "ext_loc_private_endpoint_dfs_name" {
  type        = string
  description = "外部ロケーション用ストレージ DFS プライベートエンドポイント名"
  default     = "ext-loc-pe-dfs"
}

variable "ext_loc_private_endpoint_blob_name" {
  type        = string
  description = "外部ロケーション用ストレージ Blob プライベートエンドポイント名"
  default     = "ext-loc-pe-blob"
}

variable "dbfs_storage_account_name" {
  type        = string
  description = "Databricks DBFS ストレージアカウント名（英数字のみ、24文字以内）"
}

#--------------------------------------------------------------
# ネットワーク・リソースグループ
#--------------------------------------------------------------
variable "cidr_dp" {
  type        = string
  description = "(Required) The CIDR for the Azure Data Plane VNet"
}

variable "existing_data_plane_resource_group_name" {
  type        = string
  description = "Specify the name of an existing Resource Group for Data plane resources only if you do not want Terraform to create a new one"
  validation {
    condition     = var.create_data_plane_resource_group == true || length(var.existing_data_plane_resource_group_name) > 0
    error_message = "The resource_group_name variable cannot be empty if create_resource_group is set to false"
  }
}

variable "create_data_plane_resource_group" {
  type        = bool
  description = "Set to true to create a new Azure Resource Group for data plane resources. Set to false to use an existing Resource Group specified in existing_data_plane_resource_group_name"
}

variable "location" {
  type        = string
  description = "(Required) The location for the resources in this module"
}

variable "private_subnet_endpoints" {
  description = "The list of Service endpoints to associate with the private subnet."
  type        = list(string)
  default     = []
}

variable "subscription_id" {}

variable "use_existing_vnet" {
  type        = bool
  description = "Set to true to use an existing VNet. Set to false to create a new one."
  default     = false
}

variable "existing_vnet_name" {
  type        = string
  description = "Name of the existing VNet to use when use_existing_vnet is true"
  default     = ""
  validation {
    condition     = var.use_existing_vnet == false || length(var.existing_vnet_name) > 0
    error_message = "existing_vnet_name must be specified when use_existing_vnet is true"
  }
}

variable "existing_vnet_resource_group_name" {
  type        = string
  description = "Resource group of the existing VNet. Defaults to the data plane resource group if empty."
  default     = ""
}

variable "create_private_dns_zones" {
  type        = bool
  description = "Set to false when deploying multiple environments into the same RG to reuse existing Private DNS Zones"
  default     = true
}

#--------------------------------------------------------------
# CMK（Customer Managed Key）設定
#--------------------------------------------------------------
variable "key_vault_name" {
  type        = string
  description = "CMK 用 Key Vault 名（英数字とハイフン、3〜24文字）"
  default     = "databricks-cmk-kv"
}

variable "cmk_key_name" {
  type        = string
  description = "CMK 用 Key Vault キー名"
  default     = "databricks-cmk"
}

variable "cmk_identity_name" {
  type        = string
  description = "CMK 専用ユーザー割り当てマネージドID 名"
  default     = "cmk-identity"
}

variable "key_vault_private_endpoint_name" {
  type        = string
  description = "CMK Key Vault プライベートエンドポイント名"
  default     = "cmk-kv-pe"
}

variable "dns_vnet_link_kv_name" {
  type        = string
  description = "privatelink.vaultcore.azure.net DNS Zone の VNet リンク名"
  default     = "kv-vnetlink"
}

variable "terraform_operator_ip" {
  type        = string
  description = "terraform apply 実行環境のパブリック IP（Key Vault ネットワーク許可リスト用）。空文字の場合は ip_rules を設定しない"
  default     = ""
}
