# 01_azure-infra

## 実行者
Azure 基盤管理者

## 概要
VNET・NSG・DNS Zone・外部ロケーション用ストレージ等 Azure リソース群

このモジュールは、Azure インフラストラクチャの基盤となるリソースを作成します。後続のモジュールで使用する VNET、サブネット、DNS Zone、ストレージアカウントなどのリソースをプロビジョニングします。

## 作成されるもの
- Data Plane リソースグループ
- VNet とサブネット (public, private, privatelink)
- Private DNS Zones
- 外部ロケーション用ストレージアカウント

### 出力
- prefix: 各モジュール共通で使用するリソース名プレフィックス
- dbfs_storage_account_name: Databricks DBFS ストレージアカウント名
- resource_group_name: Data Plane リソースグループ名
- location: デプロイリージョン
- vnet_id: Data Plane VNet ID
- vnet_name: Data Plane VNet 名
- public_subnet_name: Databricks パブリックサブネット名
- private_subnet_name: Databricks プライベートサブネット名
- privatelink_subnet_id: Private Link サブネット ID