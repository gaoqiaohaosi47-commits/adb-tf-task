#--------------------------------------------------------------
# 既存メタストア参照
#--------------------------------------------------------------
data "databricks_metastore" "this" {
  provider = databricks.workspace
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