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

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional, default: true) If access from public networks should be enabled for the workspace Web UI/API"
  default     = true
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

