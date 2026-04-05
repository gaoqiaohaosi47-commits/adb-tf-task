#==============================================================
# 006: ワークスペースへのIPアクセスリスト設定
#==============================================================

resource "databricks_workspace_conf" "ip_access_list" {
  provider = databricks.workspace
  custom_config = {
    "enableIpAccessLists" = "true"
  }
}

resource "databricks_ip_access_list" "allow_list" {
  for_each = { for item in var.ip_access_list : item.label => item }

  provider     = databricks.workspace
  label        = each.value.label
  list_type    = "ALLOW"
  ip_addresses = each.value.addresses

  depends_on = [
    databricks_workspace_conf.ip_access_list
  ]
}