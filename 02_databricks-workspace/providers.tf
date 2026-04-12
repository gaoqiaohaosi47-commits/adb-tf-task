#==============================================================
# プロバイダー設定
#==============================================================

terraform {

  required_version = ">= 1.9.0"

  # リモートバックエンド（Azure Blob Storage）
  # 初期化: terraform init -backend-config=backend.tfbackend
  # backend.tfbackend.sample をコピーして値を設定してください
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
