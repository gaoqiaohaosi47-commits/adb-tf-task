#==============================================================
# 005: SQL ウェアハウスの作成 (サーバレス / 2X-Small)
#==============================================================
# TODO　全てのユーザーに権限
resource "databricks_sql_endpoint" "this" {
  provider                  = databricks.workspace
  name                      = var.sql_warehouse_name
  cluster_size              = "2X-Small"
  min_num_clusters          = 1
  max_num_clusters          = 1
  auto_stop_mins            = 15
  enable_photon             = true
  enable_serverless_compute = true
  warehouse_type            = "PRO"

  tags {
    custom_tags {
      key   = "Environment"
      value = "Testing"
    }
    custom_tags {
      key   = "ManagedBy"
      value = "Terraform"
    }
  }
}

resource "databricks_permissions" "sql_warehouse" {
  provider        = databricks.workspace
  sql_endpoint_id = databricks_sql_endpoint.this.id

  access_control {
    group_name       = databricks_group.uc_users.display_name
    permission_level = "CAN_USE"
  }

  access_control {
    group_name       = databricks_group.ws_admins.display_name
    permission_level = "CAN_MANAGE"
  }

  depends_on = [
    databricks_mws_permission_assignment.uc_users,
    databricks_mws_permission_assignment.ws_admins
  ]
}