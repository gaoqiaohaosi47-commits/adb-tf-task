#==============================================================
# 変数定義
#==============================================================

#--------------------------------------------------------------
# 01_azure-infra outputs から受け取る値
#--------------------------------------------------------------
variable "workspace_name" {
  type        = string
  description = "Databricks ワークスペース名"
}

variable "managed_resource_group_name" {
  type        = string
  description = "Databricks マネージドリソースグループ名"
}

variable "resource_group_name" {
  type        = string
  description = "01_azure-infra の outputs.resource_group_name（Data Plane RG 名）"
}

variable "location" {
  type        = string
  description = "01_azure-infra の outputs.location（デプロイリージョン）"
}

variable "vnet_id" {
  type        = string
  description = "01_azure-infra の outputs.vnet_id（VNet ID）"
}

variable "public_subnet_name" {
  type        = string
  description = "01_azure-infra の outputs.public_subnet_name"
}

variable "private_subnet_name" {
  type        = string
  description = "01_azure-infra の outputs.private_subnet_name"
}

variable "public_subnet_nsg_association_id" {
  type        = string
  description = "01_azure-infra の outputs.public_subnet_nsg_association_id"
}

variable "private_subnet_nsg_association_id" {
  type        = string
  description = "01_azure-infra の outputs.private_subnet_nsg_association_id"
}

#--------------------------------------------------------------
# ワークスペース設定
#--------------------------------------------------------------
variable "public_network_access_enabled" {
  type        = bool
  description = "ワークスペース Web UI/API へのパブリックアクセスを許可するか"
  default     = true
}

variable "subscription_id" {
  type        = string
  description = "Azure サブスクリプション ID"
}

#--------------------------------------------------------------
# CMK（Customer Managed Key）設定
#--------------------------------------------------------------
variable "cmk_key_vault_id" {
  type        = string
  description = "01_azure-infra の outputs.cmk_key_vault_id（CMK 用 Key Vault ID）"
}

variable "cmk_key_vault_key_id" {
  type        = string
  description = "01_azure-infra の outputs.cmk_key_vault_key_id（CMK 用キー ID）"
}

variable "enable_managed_disk_cmk" {
  type        = bool
  description = "Managed Disk CMK を有効化するか（ワークスペース初回作成後に true に変更して 2回目 apply）"
  default     = false
}
