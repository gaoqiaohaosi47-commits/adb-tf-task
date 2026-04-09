#==============================================================
# 外部ロケーション Storage の CMK 設定
#
# 前提:
#   - cmk_key_vault.tf の Key Vault・キーが作成済みであること
#   - external_location_storage.tf の Storage アカウントに
#     SystemAssigned identity が設定済みであること
#
# 実施:
#   - Storage システム割り当て identity に Key Vault アクセスポリシーを付与
#   - Storage アカウントに CMK を適用
#==============================================================

#--------------------------------------------------------------
# Storage アカウントのシステム割り当て identity に
# Key Vault アクセスポリシー付与
#--------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "ext_loc_storage" {
  key_vault_id = azurerm_key_vault.cmk.id
  tenant_id    = azurerm_storage_account.external_location.identity[0].tenant_id
  object_id    = azurerm_storage_account.external_location.identity[0].principal_id

  key_permissions = ["Get", "UnwrapKey", "WrapKey"]
}

#--------------------------------------------------------------
# Storage アカウントに CMK を適用
#--------------------------------------------------------------
resource "azurerm_storage_account_customer_managed_key" "external_location" {
  storage_account_id = azurerm_storage_account.external_location.id
  key_vault_id       = azurerm_key_vault.cmk.id
  key_name           = azurerm_key_vault_key.cmk.name

  depends_on = [azurerm_key_vault_access_policy.ext_loc_storage]
}
