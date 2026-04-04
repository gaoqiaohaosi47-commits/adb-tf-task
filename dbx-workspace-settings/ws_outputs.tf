#--------------------------------------------------------------
# 001: グループ
#--------------------------------------------------------------
output "uc_users_group_id" {
  description = "UC利用グループID"
  value       = databricks_group.uc_users.id
}

output "ws_admins_group_id" {
  description = "WS管理者グループID"
  value       = databricks_group.ws_admins.id
}

#--------------------------------------------------------------
# 004: サービスプリンシパルシークレット (修正)
#--------------------------------------------------------------
output "service_principal_secret" {
  description = "サービスプリンシパルのシークレット"
  value       = databricks_service_principal_secret.automation.secret
  sensitive   = true
}

#--------------------------------------------------------------
# 005: SQL ウェアハウス
#--------------------------------------------------------------
output "sql_warehouse_id" {
  description = "SQL ウェアハウスID"
  value       = databricks_sql_endpoint.this.id
}

output "sql_warehouse_jdbc_url" {
  description = "SQL ウェアハウスの JDBC URL"
  value       = databricks_sql_endpoint.this.jdbc_url
}

#--------------------------------------------------------------
# 009: 資格情報
#--------------------------------------------------------------
output "storage_credential_name" {
  description = "ストレージ資格情報名"
  value       = databricks_storage_credential.ext_loc.name
}

#--------------------------------------------------------------
# 010: 外部ロケーション
#--------------------------------------------------------------
output "external_location_name" {
  description = "外部ロケーション名"
  value       = databricks_external_location.this.name
}

output "external_location_url" {
  description = "外部ロケーションURL"
  value       = databricks_external_location.this.url
}

#--------------------------------------------------------------
# 011: カタログ
#--------------------------------------------------------------
output "catalog_name" {
  description = "カタログ名"
  value       = databricks_catalog.this.name
}

#--------------------------------------------------------------
# 012: スキーマ
#--------------------------------------------------------------
output "schema_names" {
  description = "作成されたスキーマ名一覧"
  value       = [for s in databricks_schema.this : s.name]
}

#--------------------------------------------------------------
# 013: ボリューム
#--------------------------------------------------------------
output "volume_path" {
  description = "ボリュームのフルパス"
  value       = "${databricks_catalog.this.name}.${var.volume_schema}.${var.volume_name}"
}

#--------------------------------------------------------------
# 014: NCC
#--------------------------------------------------------------
output "ncc_id" {
  description = "NCC ID"
  value       = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
}

output "ncc_pe_blob_id" {
  description = "NCC Blob プライベートエンドポイントルールID"
  value       = databricks_mws_ncc_private_endpoint_rule.blob.id
}

output "ncc_pe_dfs_id" {
  description = "NCC DFS プライベートエンドポイントルールID"
  value       = databricks_mws_ncc_private_endpoint_rule.dfs.id
}

