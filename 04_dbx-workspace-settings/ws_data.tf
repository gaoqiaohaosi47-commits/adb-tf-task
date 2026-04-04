#--------------------------------------------------------------
# 既存メタストア参照
# ※ metastore_name が指定されている場合のみ読み込む
#--------------------------------------------------------------
data "databricks_metastore" "this" {
  count    = var.metastore_name != "" ? 1 : 0
  provider = databricks.account
  name     = var.metastore_name
}

#--------------------------------------------------------------
# 現在の実行ユーザー情報（ワークスペースレベル）
#--------------------------------------------------------------
data "databricks_current_user" "this" {
  provider = databricks.workspace
}

#--------------------------------------------------------------
# 現在の実行ユーザー情報（アカウントレベル）
#--------------------------------------------------------------
data "databricks_user" "current_account" {
  provider  = databricks.account
  user_name = data.databricks_current_user.this.user_name
}