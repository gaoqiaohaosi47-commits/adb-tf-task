#--------------------------------------------------------------
# 共通
#--------------------------------------------------------------
variable "databricks_account_id" {
  type        = string
  description = "Databricks アカウントID"
}

#--------------------------------------------------------------
# 001: グループ
#--------------------------------------------------------------
variable "uc_group_name" {
  type        = string
  description = "Unity Catalog 利用の通常グループ名"
  default     = "uc-users"
}

variable "ws_admin_group_name" {
  type        = string
  description = "ワークスペース管理者グループ名"
  default     = "ws-admins"
}

#--------------------------------------------------------------
# 003/004: サービスプリンシパル
#--------------------------------------------------------------
variable "service_principal_display_name" {
  type        = string
  description = "サービスプリンシパルの表示名"
  default     = "tf-automation-sp"
}

#--------------------------------------------------------------
# 005: SQL ウェアハウス
#--------------------------------------------------------------
variable "sql_warehouse_name" {
  type        = string
  description = "SQL ウェアハウス名"
  default     = "tf-sql-warehouse"
}

#--------------------------------------------------------------
# 006: IP アクセスリスト
#--------------------------------------------------------------
variable "ip_access_list" {
  type = list(object({
    label   = string
    address = string
  }))
  description = "許可するIPアドレスリスト"
}

#--------------------------------------------------------------
# 008: メタストア
#--------------------------------------------------------------
variable "metastore_name" {
  type        = string
  description = "既存の Unity Catalog メタストア名"
}

#--------------------------------------------------------------
# 011: カタログ
#--------------------------------------------------------------
variable "catalog_name" {
  type        = string
  description = "作成するカタログ名"
  default     = "main_catalog"
}

#--------------------------------------------------------------
# 012: スキーマ
#--------------------------------------------------------------
variable "schema_names" {
  type        = list(string)
  description = "作成するスキーマ名のリスト"
  default     = ["bronze", "silver", "gold"]
}

#--------------------------------------------------------------
# 013: ボリューム
#--------------------------------------------------------------
variable "volume_name" {
  type        = string
  description = "作成するボリューム名"
  default     = "external_volume"
}

variable "volume_schema" {
  type        = string
  description = "ボリュームを作成するスキーマ名"
  default     = "bronze"
}

#--------------------------------------------------------------
# 015: ネットワークポリシー
#--------------------------------------------------------------
variable "network_policy_id" {
  type        = string
  description = "ネットワークポリシーID（英小文字・数字・ハイフンのみ、最大36文字）"
  default     = "ext-loc-network-policy"
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,34}[a-z0-9]$", var.network_policy_id))
    error_message = "network_policy_id は英小文字・数字・ハイフンのみ使用可能です（最大36文字、先頭末尾はハイフン不可）"
  }
}

variable "network_policy_enforcement_mode" {
  type        = string
  description = "ネットワークポリシーの適用モード (DRY_RUN / ENFORCED)"
  default     = "DRY_RUN"
  validation {
    condition     = contains(["DRY_RUN", "ENFORCED"], var.network_policy_enforcement_mode)
    error_message = "enforcement_mode は DRY_RUN または ENFORCED のいずれかを指定してください"
  }
}

variable "allowed_internet_destinations" {
  type = list(object({
    destination              = string
    internet_destination_type = string
  }))
  description = "許可するインターネット宛先のリスト"
  default     = []
}