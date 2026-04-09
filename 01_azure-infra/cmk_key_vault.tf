#==============================================================
# CMK 用 Key Vault リソース
#
# 前提:
#   - Data Plane リソースグループ (main.tf) が作成済みであること
#
# 実施:
#   - CMK 用 Azure Key Vault を作成（パージ保護・ソフト削除有効）
#   - デプロイ実行者にキー管理権限を付与
#   - Databricks CMK 用 RSA キーを作成
#==============================================================

#--------------------------------------------------------------
# Key Vault
#--------------------------------------------------------------
resource "azurerm_key_vault" "cmk" {
  name                       = var.key_vault_name
  location                   = local.dp_rg_location
  resource_group_name        = local.dp_rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  tags                       = local.tags
}

#--------------------------------------------------------------
# デプロイ実行者（terraform operator）のアクセスポリシー
# - キーの作成・管理に必要
#--------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.cmk.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Delete", "Get", "List", "Purge", "Recover", "Update",
    "GetRotationPolicy", "SetRotationPolicy"
  ]
}

#--------------------------------------------------------------
# CMK 用 RSA キー
#--------------------------------------------------------------
resource "azurerm_key_vault_key" "cmk" {
  name         = var.cmk_key_name
  key_vault_id = azurerm_key_vault.cmk.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

#--------------------------------------------------------------
# AzureDatabricks サービスプリンシパル
# アプリ ID 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d は全テナント共通
#--------------------------------------------------------------
data "azuread_service_principal" "databricks" {
  client_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
}

#--------------------------------------------------------------
# AzureDatabricks SP への Key Vault アクセスポリシー
# Managed Services（Notebook 等）CMK 用
# → 02 のワークスペース作成前に適用済みにするため 01 で管理
#--------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "databricks_sp" {
  key_vault_id = azurerm_key_vault.cmk.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.databricks.object_id

  key_permissions = ["Get", "UnwrapKey", "WrapKey"]
}
