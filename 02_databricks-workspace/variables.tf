#==============================================================
# 変数定義
#==============================================================

#--------------------------------------------------------------
# 01_azure-infra outputs から受け取る値
#--------------------------------------------------------------
variable "prefix" {
  type        = string
  description = "01_azure-infra の outputs.prefix（リソース名プレフィックス）"
}

variable "dbfs_storage_account_name" {
  type        = string
  description = "01_azure-infra の outputs.dbfs_storage_account_name（DBFS ストレージアカウント名）"
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
