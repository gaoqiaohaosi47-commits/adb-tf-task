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
  provider     = databricks.workspace
  label        = "allowed-ips"
  list_type    = "ALLOW"
  ip_addresses = [for ip in var.ip_access_list : ip.address]

  depends_on = [
    databricks_workspace_conf.ip_access_list
  ]
}