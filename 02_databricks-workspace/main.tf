#==============================================================
# ローカル値・共通設定
#==============================================================

data "azurerm_client_config" "current" {}

# 任意: オーナータグ付与（現在のログインユーザー）
data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

# DBFS ストレージアカウント名用ランダムサフィックス（Azure Portal と同形式: dbstorage + 12文字）
resource "random_string" "dbfs_suffix" {
  length  = 12
  upper   = false
  special = false
}

locals {
  dbfsname = "dbstorage${random_string.dbfs_suffix.result}"

  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
  }
}
