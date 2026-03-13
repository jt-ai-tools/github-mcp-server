# PAT 範圍過濾

GitHub MCP 伺服器會根據您的傳統個人存取權杖 (PAT) 的 OAuth 範圍自動過濾可用工具。這確保您只會看到您的權杖有權限使用的工具，從而減少雜亂並防止因嘗試執行權杖無法執行的操作而導致錯誤。

> **注意：** 此功能適用於 **傳統 PAT**（以 `ghp_` 開頭的權杖）。細粒度 PAT、GitHub App 安裝權杖和伺服器對伺服器權杖不支援範圍偵測，並會顯示所有工具。

## 運作方式

當伺服器使用傳統 PAT 啟動時，它會向 GitHub API 發送一個輕量級的 HTTP HEAD 請求，以便從 `X-OAuth-Scopes` 標頭中發現您的權杖範圍。需要您的權杖不具備的範圍的工具將被自動隱藏。

**範例：** 如果您的權杖只有 `repo` 和 `gist` 範圍，您將不會看到需要 `admin:org`、`project` 或 `notifications` 範圍的工具。

## PAT 與 OAuth 身份驗證

| 身份驗證 | 範圍處理 |
|---------------|----------------|
| **傳統 PAT** (`ghp_`) | 在啟動時根據權杖範圍過濾工具 - 需要不可用範圍的工具將被隱藏 |
| **OAuth**（僅限遠端伺服器） | 使用 OAuth 範圍挑戰 - 當工具需要您尚未授予的範圍時，系統會提示您授權 |
| **細粒度 PAT** (`github_pat_`) | 無過濾 - 顯示所有工具，由 API 強制執行權限 |
| **GitHub App** (`ghs_`) | 無過濾 - 顯示所有工具，權限基於 App 安裝 |
| **伺服器對伺服器** | 無過濾 - 顯示所有工具，權限基於 App/權杖配置 |

使用 OAuth，遠端伺服器可以根據需要動態請求額外的範圍。對於 PAT，範圍在權杖建立時是固定的，因此伺服器會主動隱藏您無法使用的工具。

## OAuth 範圍挑戰（遠端伺服器）

當使用 [遠端 MCP 伺服器](./remote-server_zh_TW.md) 配合 OAuth 身份驗證時，伺服器使用一種稱為 **範圍挑戰** 的不同方法。伺服器不會預先隱藏工具，而是提供所有工具，並在您嘗試使用需要額外範圍的工具時按需請求。

**運作方式：**
1. 您嘗試使用一個工具（例如：建立 issue）
2. 如果您目前的 OAuth 權杖缺少所需的範圍，伺服器會回傳一個 OAuth 範圍挑戰
3. 您的 MCP 用戶端提示您授權額外的範圍
4. 授權後，操作成功完成

這為 OAuth 使用者提供了更順暢的使用者體驗，因為您只需根據需要授予權限，而不是預先請求所有範圍。

## 檢查您的權杖範圍

要查看您的權杖擁有的範圍，您可以運行：

```bash
curl -sI -H "Authorization: Bearer $GITHUB_PERSONAL_ACCESS_TOKEN" \
  https://api.github.com/user | grep -i x-oauth-scopes
```

範例輸出：
```
x-oauth-scopes: delete_repo, gist, read:org, repo
```

## 範圍階層

某些範圍隱含包含其他範圍：

- `repo` → 包含 `public_repo`, `security_events`
- `admin:org` → 包含 `write:org` → 包含 `read:org`
- `project` → 包含 `read:project`

這意味著如果您的權杖具有 `repo` 範圍，則需要 `security_events` 的工具也將可用。

[README](../README.md#tools) 中的每個工具都列出了其需要和接受的 OAuth 範圍。

## 公共存儲庫存取

僅需要 `repo` 或 `public_repo` 範圍的唯讀工具 **始終可見**，即使您的權杖沒有這些範圍。這是因為這些工具可以在沒有身份驗證的情況下對公共存儲庫運行。

例如，`get_file_contents` 始終可用 - 無論您的權杖範圍如何，您都可以從任何公共存儲庫讀取檔案。然而，如果您的權杖缺少 `repo` 範圍，則像 `create_or_update_file` 這樣的寫入操作將被隱藏。

> **注意：** GitHub API 不會在 `X-OAuth-Scopes` 標頭中回傳 `public_repo` - 它是隱含的。伺服器透過不對唯讀存儲庫工具進行過濾來處理此問題。

## 優雅降級

如果伺服器無法獲取您的權杖範圍（例如：網路問題、速率限制），它會記錄一條警告並在 **不進行過濾** 的情況下繼續運行。這確保了即使範圍偵測失敗，伺服器仍然可用。

```
WARN: failed to fetch token scopes, continuing without scope filtering
```

## 傳統與細粒度個人存取權杖

**傳統 PAT**（`ghp_` 前綴）支援 OAuth 範圍並在 `X-OAuth-Scopes` 標頭中回傳它們。範圍過濾對這些權杖完全有效。

**細粒度 PAT**（`github_pat_` 前綴）使用基於存儲庫存取和特定權限而非 OAuth 範圍的不同權限模型。它們不回傳 `X-OAuth-Scopes` 標頭，因此跳過範圍過濾。所有工具都將可用，但 GitHub API 仍將在 API 層級強制執行權限 - 如果您嘗試使用您的權杖沒有權限的工具，您將收到錯誤。

## GitHub App 和伺服器對伺服器權杖

**GitHub App 安裝權杖**（`ghs_` 前綴）和其他伺服器對伺服器權杖使用基於 App 安裝權限而非 OAuth 範圍的權限模型。這些權杖不回傳 `X-OAuth-Scopes` 標頭，因此跳過範圍過濾。GitHub API 會根據 App 的配置強制執行權限。

## 疑難排解

| 問題 | 原因 | 解決方案 |
|---------|-------|----------|
| 缺少預期工具 | 權杖缺少所需的範圍 | 在 GitHub 設定中 [編輯您的 PAT 範圍](https://github.com/settings/tokens) |
| 儘管 PAT 受限，但所有工具都可見 | 範圍偵測失敗 | 檢查日誌中是否有關於獲取範圍的警告 |
| 「權限不足」錯誤 | 工具可見但範圍不足 | 使用範圍過濾時不應發生這種情況；請報告為錯誤 |

> **提示：** 您可以隨時透過 [GitHub 的權杖設定](https://github.com/settings/tokens) 調整現有傳統 PAT 的範圍。更新範圍後，重新啟動 MCP 伺服器以套用更改。

## 相關文件

- [伺服器配置指南](./server-configuration_zh_TW.md)
- [GitHub PAT 文件](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [OAuth 範圍參考](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps)
