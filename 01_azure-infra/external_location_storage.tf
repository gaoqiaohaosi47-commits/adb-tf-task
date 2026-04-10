#==============================================================
# 外部ロケーション用ストレージリソース
#
# 前提:
#   - Data Plane リソースグループ (main.tf) が作成済みであること
#
# 実施:
#   - ユーザー割り当てマネージド ID を作成
#   - Databricks アクセスコネクタを作成し、マネージド ID を紐付け
#   - ADLS Gen2 ストレージアカウントとコンテナを作成
#   - マネージド ID に Storage Blob Data Contributor ロールを割り当て
#==============================================================

#--------------------------------------------------------------
# ユーザー割り当てマネージドID
#--------------------------------------------------------------
resource "azurerm_user_assigned_identity" "external_location" {
  name                = var.ext_loc_identity_name
  resource_group_name = local.dp_rg_name
  location            = local.dp_rg_location
  tags                = local.tags
}

#--------------------------------------------------------------
# Azure Databricks アクセスコネクタ
# - ユーザー割り当てマネージドIDを紐付け
#--------------------------------------------------------------
resource "azurerm_databricks_access_connector" "external_location" {
  name                = var.ext_loc_access_connector_name
  resource_group_name = local.dp_rg_name
  location            = local.dp_rg_location
  tags                = local.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.external_location.id]
  }
}

#--------------------------------------------------------------
# 外部ロケーション用ストレージアカウント (ADLS Gen2)
#--------------------------------------------------------------
resource "azurerm_storage_account" "external_location" {
  name                     = var.ext_loc_storage_account_name
  resource_group_name      = local.dp_rg_name
  location                 = local.dp_rg_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  tags                     = local.tags

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.ext_storage_public_access_enabled

  network_rules {
    default_action = var.ext_storage_public_access_enabled ? "Allow" : "Deny"
    bypass         = ["AzureServices"]
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cmk.id]
  }
}

#--------------------------------------------------------------
# ストレージコンテナ（外部ロケーション用）
#--------------------------------------------------------------
resource "azurerm_storage_container" "external_location" {
  name                  = var.ext_storage_container_name
  storage_account_id    = azurerm_storage_account.external_location.id
  container_access_type = "private"
}

#--------------------------------------------------------------
# ロール割り当て:
# マネージドID → Storage Blob Data Contributor
#--------------------------------------------------------------
resource "azurerm_role_assignment" "ext_loc_blob_contributor" {
  scope                = azurerm_storage_account.external_location.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.external_location.principal_id
}