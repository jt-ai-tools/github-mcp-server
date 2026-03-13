# 在 OpenAI Codex 中安裝 GitHub MCP Server

## 先決條件

1. 已安裝或可使用 OpenAI Codex (已啟用 MCP)
2. [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)

> 遠端 GitHub MCP 伺服器由 GitHub 託管於 `https://api.githubcopilot.com/mcp/` 並支援 Streamable HTTP。

## 遠端配置

編輯 `~/.codex/config.toml` (由 CLI 和 IDE 擴充功能共用) 並新增：

```toml
[mcp_servers.github]
url = "https://api.githubcopilot.com/mcp/"
# 替換為您的真實 PAT (最小權限範圍)。請勿提交此內容。
bearer_token_env_var = "GITHUB_PAT_TOKEN"
```

您也可以透過 Codex CLI 新增：

```cli
codex mcp add github --url https://api.githubcopilot.com/mcp/  
```

<details>
<summary><b>安全地儲存您的 PAT</b></summary>
<br>

為了安全起見，請避免硬編碼您的權杖。一種常見的方法：

1. 將您的權杖儲存在 `.env` 檔案中
```
GITHUB_PAT_TOKEN=ghp_your_token_here
```

2. 新增至 .gitignore
```bash
echo -e ".env" >> .gitignore
```
</details>

## 本地 Docker 配置

如果您偏好使用本地自託管實例而非遠端 HTTP 伺服器，請參考 [OpenAI 的配置文件](https://developers.openai.com/codex/mcp)。

## 驗證

啟動 Codex (CLI 或 IDE) 後：
1. 在 TUI 中執行 `/mcp` 或使用 IDE 的 MCP 面板；確認 `github` 顯示工具。
2. 詢問：「列出我的 GitHub 儲存庫」。
3. 如果遺失工具：
   - 檢查權杖有效性與範圍 (Scopes)。
   - 確認表格名稱正確：`[mcp_servers.github]`。

## 使用方式

設定完成後，Codex 可以直接與 GitHub 互動。它會自動使用預設工具集，但也可以進行 [配置](../../README_zh_TW.md#default-toolset)。嘗試以下範例提示詞：

**儲存庫操作：**
- 「列出我的 GitHub 儲存庫」
- 「顯示 [owner/repo] 最近的議題 (Issues)」
- 「在 [owner/repo] 中建立一個標題為 'Bug: fix login' 的新議題」

**提取請求 (Pull Requests)：**
- 「列出 [owner/repo] 中開啟的提取請求」
- 「顯示 PR #123 的差異 (Diff)」
- 「在 PR #123 中新增評論：'LGTM, approved'」

**Actions 與工作流 (Workflows)：**
- 「顯示 [owner/repo] 最近的工作流執行記錄」
- 「觸發 [owner/repo] 中的 'deploy' 工作流」

**Gists：**
- 「使用此程式碼片段建立一個 Gist」
- 「列出我的 Gists」

> **提示**：在 Codex UI 中使用 `/mcp` 查看所有可用的 GitHub 工具及其說明。

## 為您的 PAT 選擇範圍 (Scopes)

最小實用範圍 (視需要調整)：
- `repo` (一般儲存庫操作)
- `workflow` (若要存取 Actions 工作流)
- `read:org` (若要存取組織級資源)
- `project` (用於經典專案看板)
- `gist` (若使用 Gist 工具)

遵循最小權限原則：僅在工具請求因權限失敗時才新增範圍。

## 疑難排解

| 問題 | 可能原因 | 修正方法 |
|-------|----------------|-----|
| 身分驗證失敗 | 遺失/錯誤的 PAT 範圍 | 重新產生 PAT；確保具備 `repo` 範圍 |
| 401 Unauthorized (遠端) | 權杖已過期/撤銷 | 建立新的 PAT；更新 `bearer_token_env_var` |
| 伺服器未列出 | 表格名稱錯誤或語法錯誤 | 使用 `[mcp_servers.github]`；驗證 TOML |
| 工具遺失 / 零工具 | PAT 範圍不足 | 新增所需的範圍 (workflow, gist 等) |
| 檔案中的權杖有洩漏風險 | 意外提交 | 輪換權杖；將檔案新增至 `.gitignore` |

## 安全最佳實踐
1. 永遠不要將權杖提交至版本控制系統
3. 定期輪換權杖
4. 預先限制範圍；僅在需要時擴充
5. 從您的 GitHub 帳戶中移除未使用的 PAT

## 參考資料
- 遠端伺服器 URL：`https://api.githubcopilot.com/mcp/`
- 發佈二進位檔：[GitHub Releases](https://github.com/github/github-mcp-server/releases)
- OpenAI Codex MCP 文件：https://developers.openai.com/codex/mcp
- 主專案 README：[進階配置選項](../../README_zh_TW.md)
