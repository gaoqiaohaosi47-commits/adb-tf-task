#==============================================================
# 007: ワークスペース機能の設定
#==============================================================

resource "databricks_workspace_conf" "features" {
  provider = databricks.workspace
  custom_config = {
    "enableNotebookTableClipboard" = "false"
    "enableExportNotebook"         = "false"
    "enableWebTerminal"            = "false"
    "enableVerboseAuditLogs"       = "true"
    "enableResultsDownloading"     = "false"
    "enableDbfsFileBrowser"        = "false"
    "enableWorkspaceFilesystem"    = "false"
  }
}