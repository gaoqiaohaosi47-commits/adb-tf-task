# 02_databricks-workspace

## 実行者
データエンジニア

## 概要
Databricks ワークスペース作成（この時点ではネットワーク未設定）

このモジュールは、Databricks ワークスペースを作成します。ネットワーク設定は後続のモジュールで行われます。

## 作成されるもの
- Databricks ワークスペース

### 出力
- workspace_url: Databricks ワークスペース URL
- workspace_id: Databricks ワークスペース ID（数値）
- workspace_resource_id: Databricks ワークスペースの Azure リソース ID
- managed_resource_group_id: Databricks マネージドリソースグループ ID
- dbfs_storage_account_name: DBFS ストレージアカウント名