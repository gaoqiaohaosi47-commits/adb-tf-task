#==============================================================
# Databricks ワークスペース CMK 設定
#
# 前提:
#   - 01_azure-infra apply 済みで Key Vault・キー・AzureDatabricks SP ポリシーが作成済みであること
#   - terraform.tfvars に cmk_key_vault_id / cmk_key_vault_key_id が設定済みであること
#
# 実施:
#   - DBFS ストレージ identity に Key Vault ポリシー付与（ワークスペース作成後）
#   - DBFS Root CMK 紐付け
#   - Managed Disk identity に Key Vault ポリシー付与
#     （enable_managed_disk_cmk=true の 2回目 apply 時）
#==============================================================

#--------------------------------------------------------------
# DBFS CMK 用アクセスポリシー
# ワークスペース作成後に storage_account_identity が確定してから付与
#--------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "databricks_storage" {
  key_vault_id = var.cmk_key_vault_id
  tenant_id    = azurerm_databricks_workspace.dp_workspace.storage_account_identity[0].tenant_id
  object_id    = azurerm_databricks_workspace.dp_workspace.storage_account_identity[0].principal_id

  key_permissions = ["Get", "UnwrapKey", "WrapKey"]
}

#--------------------------------------------------------------
# DBFS Root CMK 紐付け
#--------------------------------------------------------------
resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "cmk" {
  workspace_id     = azurerm_databricks_workspace.dp_workspace.id
  key_vault_key_id = var.cmk_key_vault_key_id

  depends_on = [azurerm_key_vault_access_policy.databricks_storage]
}

#--------------------------------------------------------------
# Managed Disk CMK 用アクセスポリシー
# 2回目 apply（enable_managed_disk_cmk=true）時に作成
#--------------------------------------------------------------
resource "azurerm_key_vault_access_policy" "databricks_disk" {
  count = var.enable_managed_disk_cmk ? 1 : 0

  key_vault_id = var.cmk_key_vault_id
  tenant_id    = azurerm_databricks_workspace.dp_workspace.managed_disk_identity[0].tenant_id
  object_id    = azurerm_databricks_workspace.dp_workspace.managed_disk_identity[0].principal_id

  key_permissions = ["Get", "UnwrapKey", "WrapKey"]
}
