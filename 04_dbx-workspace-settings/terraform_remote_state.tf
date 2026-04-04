#--------------------------------------------------------------
# WS構築側の State 参照
#--------------------------------------------------------------
data "terraform_remote_state" "azure_databricks" {
  backend = "local"
  config = {
    path = "../adb-with-private-link-standard/terraform.tfstate"
  }
}

#--------------------------------------------------------------
# リモートステートからのローカル変数マッピング
#--------------------------------------------------------------
locals {
  # ワークスペース情報
  workspace_url = data.terraform_remote_state.azure_databricks.outputs.workspace_url
  workspace_id  = data.terraform_remote_state.azure_databricks.outputs.workspace_id

  # リソースグループ・ロケーション
  dp_rg_name     = data.terraform_remote_state.azure_databricks.outputs.azurerm_resource_group_name
  dp_rg_location = data.terraform_remote_state.azure_databricks.outputs.location

  # 外部ロケーション用ストレージアカウント
  ext_storage_account_name = data.terraform_remote_state.azure_databricks.outputs.ext_loc_storage_account_name
  ext_storage_account_id   = data.terraform_remote_state.azure_databricks.outputs.ext_loc_storage_account_id
  ext_container_name       = data.terraform_remote_state.azure_databricks.outputs.ext_loc_container_name
  ext_abfss_url            = data.terraform_remote_state.azure_databricks.outputs.ext_loc_abfss_url

  # マネージドID
  ext_managed_identity_id = data.terraform_remote_state.azure_databricks.outputs.ext_loc_managed_identity_id

  # アクセスコネクタ
  ext_access_connector_id   = data.terraform_remote_state.azure_databricks.outputs.ext_loc_access_connector_id
  ext_access_connector_name = data.terraform_remote_state.azure_databricks.outputs.ext_loc_access_connector_name
}