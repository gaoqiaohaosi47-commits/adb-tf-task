#==============================================================
# 013: ボリューム作成
#
# 前提:
#   - External Location (010) およびスキーマ (012) が作成済みであること
#
# 実施:
#   - External Location を指定して外部ボリュームを作成
#   - UC利用グループを所有者に設定
#   - uc_users に READ_VOLUME / WRITE_VOLUME を付与、ws_admins に ALL_PRIVILEGES を付与
#==============================================================

resource "databricks_volume" "this" {
  provider         = databricks.workspace
  name             = var.volume_name
  catalog_name     = databricks_catalog.this.name
  schema_name      = var.volume_schema
  volume_type      = "EXTERNAL"
  storage_location = "${local.ext_abfss_url}${var.catalog_name}/${var.volume_schema}/${var.volume_name}"
  owner            = databricks_group.uc_users.display_name
  comment          = "External volume managed by Terraform"

  depends_on = [
    databricks_schema.this,
    databricks_external_location.this
  ]
}

resource "databricks_grants" "volume" {
  provider = databricks.workspace
  volume   = "${databricks_catalog.this.name}.${var.volume_schema}.${var.volume_name}"

  grant {
    principal  = databricks_group.uc_users.display_name
    privileges = ["READ_VOLUME", "WRITE_VOLUME"]
  }

  grant {
    principal  = databricks_group.ws_admins.display_name
    privileges = ["ALL_PRIVILEGES"]
  }

  depends_on = [
    databricks_volume.this
  ]
}