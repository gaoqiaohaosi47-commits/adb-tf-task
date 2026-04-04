#--------------------------------------------------------------
# terraform_remote_state を廃止し、tfvars 経由で受け取った変数を
# モジュール内 local として再マッピング
#--------------------------------------------------------------
locals {
  # 02_databricks-workspace outputs
  workspace_url = var.workspace_url
  workspace_id  = var.workspace_id

  # 01_azure-infra outputs（リソースグループ・ロケーション）
  dp_rg_name     = var.resource_group_name
  dp_rg_location = var.location

  # 01_azure-infra outputs（外部ロケーション用ストレージ）
  ext_storage_account_name = var.ext_loc_storage_account_name
  ext_storage_account_id   = var.ext_loc_storage_account_id
  ext_container_name       = var.ext_loc_container_name
  ext_abfss_url            = var.ext_loc_abfss_url

  # 01_azure-infra outputs（マネージド ID / アクセスコネクタ）
  ext_managed_identity_id   = var.ext_loc_managed_identity_id
  ext_access_connector_id   = var.ext_loc_access_connector_id
  ext_access_connector_name = var.ext_loc_access_connector_name
}
