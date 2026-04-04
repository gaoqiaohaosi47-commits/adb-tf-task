#==============================================================
# 002: ワークスペースへのグループ関連付け・エンタイトルメント設定
#==============================================================

# ToDO　グループ、サービスプリンシパルの権限を変更

# 実行ユーザーをUC利用グループに追加
resource "databricks_group_member" "current_user_to_uc_users" {
  provider  = databricks.account
  group_id  = databricks_group.uc_users.id
  member_id = data.databricks_current_user.this.id

  depends_on = [
    databricks_group.uc_users
  ]
}

# 実行ユーザーをWS管理者グループにも追加
resource "databricks_group_member" "current_user_to_ws_admins" {
  provider  = databricks.account
  group_id  = databricks_group.ws_admins.id
  member_id = data.databricks_current_user.this.id

  depends_on = [
    databricks_group.ws_admins
  ]
}

# UC利用グループ → ワークスペースへ割り当て
resource "databricks_mws_permission_assignment" "uc_users" {
  provider     = databricks.account
  workspace_id = local.workspace_id
  principal_id = databricks_group.uc_users.id
  permissions  = ["USER"]

  depends_on = [
    databricks_group_member.current_user_to_uc_users
  ]
}

# WS管理者グループ → ワークスペースへ割り当て (ADMIN)
resource "databricks_mws_permission_assignment" "ws_admins" {
  provider     = databricks.account
  workspace_id = local.workspace_id
  principal_id = databricks_group.ws_admins.id
  permissions  = ["ADMIN"]

  depends_on = [
    databricks_group_member.current_user_to_ws_admins
  ]
}

# UC利用グループのエンタイトルメント
resource "databricks_entitlements" "uc_users" {
  provider                   = databricks.workspace
  group_id                   = databricks_group.uc_users.id
  workspace_access           = true
  databricks_sql_access      = true
  allow_cluster_create       = false
  allow_instance_pool_create = false

  depends_on = [
    databricks_mws_permission_assignment.uc_users
  ]
}

# WS管理者グループのエンタイトルメント
resource "databricks_entitlements" "ws_admins" {
  provider                   = databricks.workspace
  group_id                   = databricks_group.ws_admins.id
  workspace_access           = true
  databricks_sql_access      = true
  allow_cluster_create       = true
  allow_instance_pool_create = true

  depends_on = [
    databricks_mws_permission_assignment.ws_admins
  ]
}