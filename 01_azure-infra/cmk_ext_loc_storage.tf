#==============================================================
# 外部ロケーション Storage の CMK 設定
#
# 前提:
#   - cmk_key_vault.tf の Key Vault・キー・CMK専用UA ID が作成済みであること
#   - external_location_storage.tf の Storage アカウントに
#     CMK専用ユーザー割り当て identity が設定済みであること
#
# 実施:
#   - CMK専用ユーザー割り当てIDを使って Storage アカウントに CMK を適用
#   - アクセスポリシーは cmk_key_vault.tf の cmk_identity ポリシーで管理
#==============================================================

#--------------------------------------------------------------
# Storage アカウントに CMK を適用（ユーザー割り当てID 使用）
#--------------------------------------------------------------
resource "azurerm_storage_account_customer_managed_key" "external_location" {
  storage_account_id        = azurerm_storage_account.external_location.id
  key_vault_key_id          = azurerm_key_vault_key.cmk.id
  user_assigned_identity_id = azurerm_user_assigned_identity.cmk.id

  depends_on = [azurerm_key_vault_access_policy.cmk_identity]
}
