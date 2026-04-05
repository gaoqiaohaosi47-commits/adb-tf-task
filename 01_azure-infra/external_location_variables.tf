#==============================================================
# 変数定義 - 外部ロケーション用ストレージ
#==============================================================

variable "ext_loc_storage_account_name" {
  type        = string
  description = "外部ロケーション用ストレージアカウント名（英数字のみ、24文字以内）"
}

variable "ext_storage_container_name" {
  type        = string
  description = "外部ロケーション用ストレージコンテナ名"
  default     = "external"
}

variable "ext_storage_public_access_enabled" {
  type        = bool
  description = "外部ロケーション用ストレージへのパブリックアクセスを許可するか (false の場合プライベートエンドポイントを作成)"
  default     = false
}