#==============================================================
# プロバイダー設定
#
# 認証方法: Azure CLI (az login)
#   事前に `az login` および `az account set --subscription <id>` を実行してください
#==============================================================

terraform {
  required_version = ">= 1.9.0"

  # リモートバックエンド（Azure Blob Storage）
  # 初期化: terraform init -backend-config=backend.tfbackend
  # backend.tfbackend.sample をコピーして値を設定してください
  backend "azurerm" {}

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.50.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.0"
    }
  }
}

provider "databricks" {
  alias           = "workspace"
  host            = local.workspace_url
  azure_tenant_id = var.azure_tenant_id # 自動検出の誤検知を防ぐため明示指定
}

provider "databricks" {
  alias           = "account"
  host            = "https://accounts.azuredatabricks.net"
  account_id      = var.databricks_account_id
  azure_tenant_id = var.azure_tenant_id # 自動検出の誤検知を防ぐため明示指定
}