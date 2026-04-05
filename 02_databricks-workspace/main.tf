#==============================================================
# ローカル値・共通設定
#==============================================================

data "azurerm_client_config" "current" {}

# 任意: オーナータグ付与（現在のログインユーザー）
data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  # 01_azure-infra の outputs から tfvars で受け取る
  prefix   = var.prefix
  dbfsname = var.dbfs_storage_account_name

  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
    Prefix      = var.prefix
  }
}
