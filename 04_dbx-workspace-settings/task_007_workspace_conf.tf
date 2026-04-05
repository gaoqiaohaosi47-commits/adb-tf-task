#==============================================================
# 007: ワークスペース機能の設定
#
# 実施:
#   - ws-config.json (GET /api/2.0/workspace-conf) から admin が変更可能な
#     全キーを列挙し、セキュリティ・ガバナンス観点で値を設定
#
# 凡例:
#   各行末コメントの "default:" は ws-config.json で確認した現在値
#   "disable*" 系キー: true = 機能を無効化、false = 有効化
#   "enable*"  系キー: true = 機能を有効化、false = 無効化
#   数値系: Databricks デフォルト値をコメントに記載
#
# 除外したキー:
#   - ドット区切り (databricks.fe.* 等) のフロントエンド内部フラグ
#   - 読み取り専用・システム状態キー
#     (isAdmin, userId, orgId, shardName, cloud, accountId, *ByTier 系 等)
#==============================================================

resource "databricks_workspace_conf" "features" {
  provider = databricks.workspace
  custom_config = {

    #----------------------------------------------------------
    # 1. セキュリティ・データ漏洩防止
    #----------------------------------------------------------

    # ノートブックのエクスポート禁止 (default: false)
    "disableExportNotebook" = "true"

    # クエリ結果のダウンロード禁止 (default: false)
    "disableResultsDownloading" = "true"

    # 外部データソースタイル非表示 (default: false)
    "disableExternalDataSourcesTiles" = "false"

    # URL からのノートブックインポートを Databricks Docs のみに制限 (default: false)
    "disallowUrlImportExceptFromDocs" = "true"

    # テーブル結果のクリップボードコピー禁止 (default: true)
    "enableNotebookTableClipboard" = "false"

    # ノートブック結果をカスタマー管理ストレージに保存 (default: false)
    "storeInteractiveNotebookResultsInCustomerAccount" = "true"

    # URL を直接レンダリングする HTML 表示を許可 (default: true)
    "allowDisplayHtmlByUrl" = "true"

    # サニタイズ済み HTML 内のインラインスタイルを許可 (default: false)
    "allowStyleInSanitizedHtml" = "false"

    # 許可リスト登録済み iframe ドメインを許可 (default: true)
    "allowWhitelistedIframeDomains" = "true"

    #----------------------------------------------------------
    # 2. 認証・アクセス制御
    #----------------------------------------------------------

    # SSO (Single Sign-On) の有効化 (default: false)
    "enableSingleSignOn" = "false"

    # SSO ログイン画面の表示 (default: false)
    "enableSingleSignOnLogin" = "false"

    # シングルログアウトの有効化 (default: false)
    "enableSingleLogout" = "false"

    # SAML アサーション暗号化 (default: false)
    "enableSamlAssertionEncryptionForWorkspace" = "false"

    # PAT (Personal Access Token) の有効化 - 管理者トグル (default: true)
    "enableTokensConfig" = "true"

    # アカウントレベルでの PAT 無効化 (default: false)
    "disablePersonalAccessTokenForAccount" = "false"

    # パスワードリセットの許可 (default: true)
    "enableResetPassword" = "true"

    # 強パスワードポリシーの強制 (default: false)
    "enableStrongPassword" = "false"

    # 証明書ユーザー名の許可 (default: false)
    "allowCertificateUsernames" = "false"

    # 非管理者ユーザーのワークスペース利用を許可 (default: true)
    "allowNonAdminUsers" = "true"

    # 英数字以外のユーザー名を許可 (default: false)
    "allowNonAlphanumericUsernames" = "false"

    # 任意の長さのユーザー名を許可 (default: false)
    "allowUsernamesOfAnyLength" = "false"

    # AAD ユーザーがワークスペーステナントに属するか確認 (default: false)
    "checkAadUserInWorkspaceTenant" = "false"

    # AAD ユーザー追加前の事前確認 (default: true)
    "checkBeforeAddingAadUser" = "true"

    # X.509 証明書認証の有効化 (default: false)
    "enableX509Authentication" = "false"

    #----------------------------------------------------------
    # 3. ACL・権限設定
    #----------------------------------------------------------

    # クラスター ACL の有効化 - 管理者トグル (default: true)
    "enableClusterAclsConfig" = "true"

    # ジョブ ACL の有効化 - 管理者トグル (default: true)
    "enableJobAclsConfig" = "true"

    # テーブル ACL の有効化 - 管理者トグル (default: false)
    "enableTableAclsConfig" = "false"

    # ワークスペース ACL の有効化 - 管理者トグル (default: true)
    "enableWorkspaceAclsConfig" = "true"

    # マウントポイント ACL の有効化 (default: false)
    "enableMountAclsConfig" = "false"

    # ユーザー分離の強制 (default: false)
    "enforceUserIsolation" = "false"

    # クラスター表示 ACL の強制 (default: true)
    "enforceClusterViewAcls" = "true"

    # ワークスペース表示 ACL の強制 (default: true)
    "enforceWorkspaceViewAcls" = "true"

    # コマンド実行にアタッチ権限を必須化 (default: false)
    "requireAttachPermissionToRunCommand" = "false"

    # クラスター作成を管理者のみに制限 (default: false)
    "enableRestrictedClusterCreation" = "false"

    # 編集権限の拡大 (default: false)
    "broadenedEditPermission" = "false"

    #----------------------------------------------------------
    # 4. 監査ログ
    #----------------------------------------------------------

    # 詳細監査ログの有効化 (default: false)
    "enableVerboseAuditLogs" = "true"

    #----------------------------------------------------------
    # 5. ワークスペース機能
    #----------------------------------------------------------

    # Web ターミナルの有効化 (default: true)
    "enableWebTerminal" = "false"

    # DBFS ファイルブラウザの有効化 (default: false)
    "enableDbfsFileBrowser" = "false"

    # ワークスペースでの DBFS 利用を有効化 (default: true)
    "enableDbfsForWorkspace" = "true"

    # ワークスペースファイルシステムの有効化 (default: true)
    "enableWorkspaceFilesystem" = "false"

    # ワークスペース内ファイル機能の有効化 (default: true)
    "enableFilesInWorkspace" = "true"

    # ノートブックの外部公開を有効化 (default: false)
    "enablePublishNotebooks" = "false"

    # ゴミ箱フォルダの有効化 (default: true)
    "enableTrashFolder" = "true"

    # URL からのインポートを有効化 (default: true)
    "enableImportFromUrl" = "true"

    # IPython 形式のノートブックインポート/エクスポートを有効化 (default: true)
    "enableIPythonImportExport" = "true"

    # フォルダのソースコードエクスポートを有効化 (default: true)
    "enableFolderSourceExport" = "true"

    # フォルダのソースコードインポートを有効化 (default: true)
    "enableFolderSourceImport" = "true"

    # フォルダの HTML エクスポートを有効化 (default: true)
    "enableFolderHtmlExport" = "true"

    # 静的 HTML のインポートを有効化 (default: true)
    "enableStaticHtmlImport" = "true"

    # Repos をデフォルトで有効化 (default: true)
    "enableReposByDefault" = "true"

    # Repos の自動同期を有効化 (default: true)
    "enableRepoAutosync" = "true"

    # プロジェクト許可リスト機能を有効化 (default: false)
    "enableProjectsAllowList" = "false"

    # 全文検索の有効化 (default: false)
    "enableFullTextSearch" = "false"

    # フィードバックフォームを無効化 (default: false)
    "disableFeedback" = "false"

    #----------------------------------------------------------
    # 6. クラスター・コンピュート設定
    #----------------------------------------------------------

    # クラスターの自動再起動を有効化 (default: false)
    "enableAutorestart" = "false"

    # 自動再起動の強制 (default: false)
    "forceAutorestart" = "false"

    # エラスティックディスクの有効化 (default: true)
    "enableElasticDisk" = "true"

    # Azure Spot VM の有効化 (default: true)
    "enableAzureSpotVM" = "true"

    # カスタム Spot 価格設定の有効化 (default: true)
    "enableCustomSpotPricing" = "true"

    # 全ユーザーへの個人 VM ポリシー適用 (default: false)
    "enablePersonalVMPolicyForAllUsers" = "false"

    # サービスプリンシパル用クラスター作成を有効化 (default: false)
    "enableServicePrincipalClusters" = "false"

    # 非推奨のグローバル初期化スクリプトを有効化 (default: false)
    "enableDeprecatedGlobalInitScripts" = "false"

    # 共有クラスターでのライブラリ・初期化スクリプトを有効化 (default: false)
    "enableLibraryAndInitScriptOnSharedCluster" = "false"

    # IMDSv2 の強制を有効化 (default: false)
    "enableEnforceImdsV2" = "false"

    # クラスター IAM ロールの任意指定を無効化 (default: false)
    "disableClusterIamRoleOptionality" = "false"

    #----------------------------------------------------------
    # 7. 数値系（クォータ・上限・デフォルト値）
    #----------------------------------------------------------

    # クラスターに付与できる最大カスタムタグ数 (default: 43)
    "maxCustomTags" = "43"

    # Standard クラスターの最大 vCPU 数 (default: 32)
    "defaultStandardMaxVCpus" = "32"

    # クラスターの自動終了時間（分）(default: 120)
    "defaultAutoterminationMin" = "120"

    # デフォルトのワーカー数 (default: 8)
    "defaultNumWorkers" = "8"

    # PAT の最大有効期間（日）(default: 730)
    "getMaxTokenLifetimeDays" = "730"

    # セッションアイドルタイムアウト（秒）-1 = 無制限 (default: -1)
    "sessionIdleTimeout" = "-1"

  }
}
