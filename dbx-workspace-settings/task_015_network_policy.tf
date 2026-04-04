#==============================================================
# 015: ネットワークポリシー
#      - account_id を明示指定（プロバイダーバグ回避）
#==============================================================

resource "databricks_account_network_policy" "this" {
  provider = databricks.account

  account_id        = var.databricks_account_id # バグ対策
  network_policy_id = var.network_policy_id

  egress = {
    network_access = {
      restriction_mode = "RESTRICTED_ACCESS"

      allowed_internet_destinations = var.allowed_internet_destinations

      allowed_storage_destinations = [
        {
          azure_storage_account    = local.ext_storage_account_name
          azure_storage_service    = "blob"
          storage_destination_type = "AZURE_STORAGE"
        },
        {
          azure_storage_account    = local.ext_storage_account_name
          azure_storage_service    = "dfs"
          storage_destination_type = "AZURE_STORAGE"
        }
      ]

      policy_enforcement = {
        enforcement_mode = var.network_policy_enforcement_mode
      }
    }
  }

  depends_on = [
    databricks_mws_ncc_binding.this
  ]
}