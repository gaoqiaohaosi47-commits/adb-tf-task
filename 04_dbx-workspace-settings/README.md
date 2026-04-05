# 04_dbx-workspace-settings

## 実行者
データエンジニア

## 概要
Databricks プロバイダー操作（グループ・SP・カタログ等）

このモジュールは、Databricks ワークスペース内の設定を行います。グループ、サービスプリンシパル、カタログなどのリソースを管理します。

ワークスペースのメタストアは自動割り当ての前提

## 作成されるもの
- Databricks グループ (UC利用グループ, WS管理者グループ)
- サービスプリンシパルとシークレット
- SQL ウェアハウス
- IP アクセスリスト
- ワークスペース設定
- メタストア権限
- ストレージ資格情報
- 外部ロケーション
- カタログ、スキーマ、ボリューム
- ネットワークポリシー

### 出力
- uc_users_group_id: UC利用グループID
- ws_admins_group_id: WS管理者グループID
- service_principal_secret: サービスプリンシパルのシークレット
- sql_warehouse_id: SQL ウェアハウスID
- sql_warehouse_jdbc_url: SQL ウェアハウスの JDBC URL
- storage_credential_name: ストレージ資格情報名
- external_location_name: 外部ロケーション名