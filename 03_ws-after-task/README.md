# 03_ws-after-task

## 実行者
ネットワーク管理者

## 概要
ワークスペース作成後のプライベートエンドポイント・既存 DNS Zone への VNet リンク追加

このモジュールは、Databricks ワークスペース作成後にプライベートエンドポイントを設定し、既存の DNS Zone に VNet リンクを追加します。

## 作成されるもの
- Backend (UI/API) プライベートエンドポイント
- DBFS DFS プライベートエンドポイント
- DBFS Blob プライベートエンドポイント
- DNS Zone への VNet リンク

### 出力
- backend_private_endpoint_id: Backend (UI/API) プライベートエンドポイント ID
- dbfs_dfs_private_endpoint_id: DBFS DFS プライベートエンドポイント ID
- dbfs_blob_private_endpoint_id: DBFS Blob プライベートエンドポイント ID