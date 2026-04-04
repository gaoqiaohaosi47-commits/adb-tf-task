#==============================================================
# 014: NCC (Network Connectivity Configuration) 作成
#      - 外部ロケーション用ストレージアカウントの
#        プライベートエンドポイントルール (Blob / DFS)
#==============================================================

resource "databricks_mws_network_connectivity_config" "this" {
  provider = databricks.account
  name     = "${local.ext_storage_account_name}-ncc"
  region   = local.dp_rg_location
}

resource "databricks_mws_ncc_private_endpoint_rule" "blob" {
  provider                       = databricks.account
  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  resource_id                    = local.ext_storage_account_id
  group_id                       = "blob"
}

resource "databricks_mws_ncc_private_endpoint_rule" "dfs" {
  provider                       = databricks.account
  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  resource_id                    = local.ext_storage_account_id
  group_id                       = "dfs"
}

resource "databricks_mws_ncc_binding" "this" {
  provider                       = databricks.account
  network_connectivity_config_id = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
  workspace_id                   = local.workspace_id
}

# # ストレージアカウント側: NCC プライベートエンドポイントの承認 (Blob)
# resource "azurerm_private_endpoint" "ncc_blob_approval" {
#   count               = 0 # NCC側で自動作成されるため手動作成不要。承認のみ必要な場合はポータルで実施
#   name                = "ncc-blob-pe"
#   location            = local.dp_rg_location
#   resource_group_name = local.dp_rg_name
#   subnet_id           = azurerm_subnet.dp_plsubnet.id

#   private_service_connection {
#     name                           = "ncc-blob"
#     private_connection_resource_id = azurerm_storage_account.external_location.id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }
# }