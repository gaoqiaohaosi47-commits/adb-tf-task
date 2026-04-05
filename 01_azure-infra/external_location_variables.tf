#==============================================================
# 変数定義 - 外部ロケーション用ストレージ
#==============================================================

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