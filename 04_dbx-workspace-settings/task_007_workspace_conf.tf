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
#
# ※ コメントアウトされている項目は API が受け付けないキーです
#   (POST /api/2.0/workspace-conf で "invalid key" エラーになることを確認済み)
#==============================================================

resource "databricks_workspace_conf" "features" {
  provider = databricks.workspace
  custom_config = {

    #----------------------------------------------------------
    # 1. セキュリティ・データ漏洩防止
    #----------------------------------------------------------

    # ノートブックのエクスポート禁止 (default: false)
    # "disableExportNotebook" = "true"  # ※ API 非対応キー

    # クエリ結果のダウンロード禁止 (default: false)
    # "disableResultsDownloading" = "true"  # ※ API 非対応キー

    # 外部データソースタイル非表示 (default: false)
    # "disableExternalDataSourcesTiles" = "false"  # ※ API 非対応キー

    # URL からのノートブックインポートを Databricks Docs のみに制限 (default: false)
    # "disallowUrlImportExceptFromDocs" = "true"  # ※ API 非対応キー

    # テーブル結果のクリップボードコピー禁止 (default: true)
    "enableNotebookTableClipboard" = "false"

    # ノートブック結果をカスタマー管理ストレージに保存 (default: false)
    "storeInteractiveNotebookResultsInCustomerAccount" = "true"

    # URL を直接レンダリングする HTML 表示を許可 (default: true)
    # "allowDisplayHtmlByUrl" = "true"  # ※ API 非対応キー

    # サニタイズ済み HTML 内のインラインスタイルを許可 (default: false)
    # "allowStyleInSanitizedHtml" = "false"  # ※ API 非対応キー

    # 許可リスト登録済み iframe ドメインを許可 (default: true)
    # "allowWhitelistedIframeDomains" = "true"  # ※ API 非対応キー

    #----------------------------------------------------------
    # 2. 認証・アクセス制御
    #----------------------------------------------------------

    # SSO (Single Sign-On) の有効化 (default: false)
    # "enableSingleSignOn" = "false"  # ※ API 非対応キー

    # SSO ログイン画面の表示 (default: false)
    # "enableSingleSignOnLogin" = "false"  # ※ API 非対応キー

    # シングルログアウトの有効化 (default: false)
    # "enableSingleLogout" = "false"  # ※ API 非対応キー

    # SAML アサーション暗号化 (default: false)
    # "enableSamlAssertionEncryptionForWorkspace" = "false"  # ※ API 非対応キー

    # PAT (Personal Access Token) の有効化 - 管理者トグル (default: true)
    "enableTokensConfig" = "true"

    # アカウントレベルでの PAT 無効化 (default: false)
    # "disablePersonalAccessTokenForAccount" = "false"  # ※ API 非対応キー

    # パスワードリセットの許可 (default: true)
    # "enableResetPassword" = "true"  # ※ API 非対応キー

    # 強パスワードポリシーの強制 (default: false)
    # "enableStrongPassword" = "false"  # ※ API 非対応キー

    # 証明書ユーザー名の許可 (default: false)
    # "allowCertificateUsernames" = "false"  # ※ API 非対応キー

    # 非管理者ユーザーのワークスペース利用を許可 (default: true)
    # "allowNonAdminUsers" = "true"  # ※ API 非対応キー

    # 英数字以外のユーザー名を許可 (default: false)
    # "allowNonAlphanumericUsernames" = "false"  # ※ API 非対応キー

    # 任意の長さのユーザー名を許可 (default: false)
    # "allowUsernamesOfAnyLength" = "false"  # ※ API 非対応キー

    # AAD ユーザーがワークスペーステナントに属するか確認 (default: false)
    # "checkAadUserInWorkspaceTenant" = "false"  # ※ API 非対応キー

    # AAD ユーザー追加前の事前確認 (default: true)
    # "checkBeforeAddingAadUser" = "true"  # ※ API 非対応キー

    # X.509 証明書認証の有効化 (default: false)
    # "enableX509Authentication" = "false"  # ※ API 非対応キー

    #----------------------------------------------------------
    # 3. ACL・権限設定
    #----------------------------------------------------------

    # クラスター ACL の有効化 - 管理者トグル (default: true)
    # "enableClusterAclsConfig" = "true"  # ※ API 非対応キー

    # ジョブ ACL の有効化 - 管理者トグル (default: true)
    # "enableJobAclsConfig" = "true"  # ※ API 非対応キー

    # テーブル ACL の有効化 - 管理者トグル (default: false)
    # "enableTableAclsConfig" = "false"  # ※ API 非対応キー

    # ワークスペース ACL の有効化 - 管理者トグル (default: true)
    # "enableWorkspaceAclsConfig" = "true"  # ※ API 非対応キー

    # マウントポイント ACL の有効化 (default: false)
    # "enableMountAclsConfig" = "false"  # ※ API 非対応キー

    # ユーザー分離の強制 (default: false)
    "enforceUserIsolation" = "false"

    # クラスター表示 ACL の強制 (default: true)
    "enforceClusterViewAcls" = "true"

    # ワークスペース表示 ACL の強制 (default: true)
    "enforceWorkspaceViewAcls" = "true"

    # コマンド実行にアタッチ権限を必須化 (default: false)
    "requireAttachPermissionToRunCommand" = "false"

    # クラスター作成を管理者のみに制限 (default: false)
    # "enableRestrictedClusterCreation" = "false"  # ※ API 非対応キー

    # 編集権限の拡大 (default: false)
    # "broadenedEditPermission" = "false"  # ※ API 非対応キー

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
    # "enableDbfsForWorkspace" = "true"  # ※ API 非対応キー

    # ワークスペースファイルシステムの有効化 (default: true)
    "enableWorkspaceFilesystem" = "false"

    # ワークスペース内ファイル機能の有効化 (default: true)
    "enableFilesInWorkspace" = "true"

    # ノートブックの外部公開を有効化 (default: false)
    # "enablePublishNotebooks" = "false"  # ※ API 非対応キー

    # ゴミ箱フォルダの有効化 (default: true)
    # "enableTrashFolder" = "true"  # ※ API 非対応キー

    # URL からのインポートを有効化 (default: true)
    # "enableImportFromUrl" = "true"  # ※ API 非対応キー

    # IPython 形式のノートブックインポート/エクスポートを有効化 (default: true)
    # "enableIPythonImportExport" = "true"  # ※ API 非対応キー

    # フォルダのソースコードエクスポートを有効化 (default: true)
    # "enableFolderSourceExport" = "true"  # ※ API 非対応キー

    # フォルダのソースコードインポートを有効化 (default: true)
    # "enableFolderSourceImport" = "true"  # ※ API 非対応キー

    # フォルダの HTML エクスポートを有効化 (default: true)
    # "enableFolderHtmlExport" = "true"  # ※ API 非対応キー

    # 静的 HTML のインポートを有効化 (default: true)
    # "enableStaticHtmlImport" = "true"  # ※ API 非対応キー

    # Repos をデフォルトで有効化 (default: true)
    # "enableReposByDefault" = "true"  # ※ API 非対応キー

    # Repos の自動同期を有効化 (default: true)
    # "enableRepoAutosync" = "true"  # ※ API 非対応キー

    # プロジェクト許可リスト機能を有効化 (default: false)
    "enableProjectsAllowList" = "false"

    # 全文検索の有効化 (default: false)
    # "enableFullTextSearch" = "false"  # ※ API 非対応キー

    # フィードバックフォームを無効化 (default: false)
    # "disableFeedback" = "false"  # ※ API 非対応キー

    #----------------------------------------------------------
    # 6. クラスター・コンピュート設定
    #----------------------------------------------------------

    # クラスターの自動再起動を有効化 (default: false)
    "enableAutorestart" = "false"

    # 自動再起動の強制 (default: false)
    # "forceAutorestart" = "false"  # ※ API 非対応キー

    # エラスティックディスクの有効化 (default: true)
    # "enableElasticDisk" = "true"  # ※ API 非対応キー

    # Azure Spot VM の有効化 (default: true)
    # "enableAzureSpotVM" = "true"  # ※ API 非対応キー

    # カスタム Spot 価格設定の有効化 (default: true)
    # "enableCustomSpotPricing" = "true"  # ※ API 非対応キー

    # 全ユーザーへの個人 VM ポリシー適用 (default: false)
    # "enablePersonalVMPolicyForAllUsers" = "false"  # ※ API 非対応キー

    # サービスプリンシパル用クラスター作成を有効化 (default: false)
    # "enableServicePrincipalClusters" = "false"  # ※ API 非対応キー

    # 非推奨のグローバル初期化スクリプトを有効化 (default: false)
    "enableDeprecatedGlobalInitScripts" = "false"

    # 共有クラスターでのライブラリ・初期化スクリプトを有効化 (default: false)
    "enableLibraryAndInitScriptOnSharedCluster" = "false"

    # IMDSv2 の強制を有効化 (default: false)
    "enableEnforceImdsV2" = "false"

    # クラスター IAM ロールの任意指定を無効化 (default: false)
    # "disableClusterIamRoleOptionality" = "false"  # ※ API 非対応キー

    #----------------------------------------------------------
    # 7. 数値系（クォータ・上限・デフォルト値）
    #----------------------------------------------------------

    # クラスターに付与できる最大カスタムタグ数 (default: 43)
    # "maxCustomTags" = "43"  # ※ API 非対応キー

    # Standard クラスターの最大 vCPU 数 (default: 32)
    # "defaultStandardMaxVCpus" = "32"  # ※ API 非対応キー

    # クラスターの自動終了時間（分）(default: 120)
    # "defaultAutoterminationMin" = "120"  # ※ API 非対応キー

    # デフォルトのワーカー数 (default: 8)
    # "defaultNumWorkers" = "8"  # ※ API 非対応キー

    # PAT の最大有効期間（日）(default: 730)
    # "getMaxTokenLifetimeDays" = "730"  # ※ API 非対応キー

    # セッションアイドルタイムアウト（秒）-1 = 無制限 (default: -1)
    # "sessionIdleTimeout" = "-1"  # ※ API 非対応キー

  }
}
