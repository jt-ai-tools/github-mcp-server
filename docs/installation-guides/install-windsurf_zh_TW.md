# 在 Windsurf 中安裝 GitHub MCP Server

## 先決條件
1. 已安裝 Windsurf IDE (最新版本)
2. 具備適當範圍的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
3. 本地安裝：已安裝並執行 [Docker](https://www.docker.com/)

## 遠端伺服器設定 (推薦)

遠端 GitHub MCP Server 由 GitHub 託管於 `https://api.githubcopilot.com/mcp/` 並支援 Streamable HTTP 協定。Windsurf 目前僅支援 PAT 身分驗證。

### Streamable HTTP 配置
Windsurf 支援帶有 `serverUrl` 欄位的 Streamable HTTP 伺服器：

```json
{
  "mcpServers": {
    "github": {
      "serverUrl": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_GITHUB_PAT"
      }
    }
  }
}
```

## 本地伺服器設定

### Docker 安裝 (必要)
**重要**：自 2025 年 4 月起，不再支援 npm 套件 `@modelcontextprotocol/server-github`。請改用官方 Docker 映像檔 `ghcr.io/github/github-mcp-server`。

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"
      }
    }
  }
}
```

## 安裝步驟

### 透過外掛程式商店 (Plugin Store)
1. 開啟 Windsurf 並導覽至 Cascade
2. 點擊 **Plugins** 圖示或 **鐵鎚圖示** (🔨)
3. 搜尋 "GitHub MCP Server"
4. 點擊 **Install** 並在出現提示時輸入您的 PAT
5. 點擊 **Refresh** (🔄)

### 手動配置
1. 點擊 Cascade 中的鐵鎚圖示 (🔨)
2. 點擊 **Configure** 開啟 `~/.codeium/windsurf/mcp_config.json`
3. 從上方新增您選擇的配置
4. 儲存檔案
5. 點擊 MCP 工具列中的 **Refresh** (🔄)

## 配置詳情

- **檔案路徑**：`~/.codeium/windsurf/mcp_config.json`
- **範圍**：僅限全域配置 (不支援個別專案)
- **格式**：必須是有效的 JSON (使用 linter 進行驗證)

## 驗證

安裝後：
1. 在 MCP 工具列中尋找 "1 available MCP server"
2. 點擊鐵鎚圖示以查看可用的 GitHub 工具
3. 測試：「列出我的 GitHub 儲存庫」
4. 檢查伺服器名稱旁邊是否有綠點

## 疑難排解

### 遠端伺服器問題
- **身分驗證失敗**：驗證 PAT 具備正確範圍且未過期
- **連線錯誤**：檢查 HTTPS 連線的防火牆/代理伺服器設定
- **Streamable HTTP 無法運作**：確保您使用的是正確的 `serverUrl` 欄位格式

### 本地伺服器問題
- **Docker 錯誤**：確保 Docker Desktop 正在執行
- **映像檔拉取失敗**：嘗試 `docker logout ghcr.io` 然後重試
- **找不到 Docker**：安裝 Docker Desktop 並確保其正在執行

### 一般問題
- **無效的 JSON**：使用 [jsonlint.com](https://jsonlint.com) 進行驗證
- **工具未出現**：完全重啟 Windsurf
- **檢查日誌**：`~/.codeium/windsurf/logs/`

## 重要注意事項

- **官方儲存庫**：[github/github-mcp-server](https://github.com/github/github-mcp-server)
- **遠端伺服器 URL**：`https://api.githubcopilot.com/mcp/`
- **Docker 映像檔**：`ghcr.io/github/github-mcp-server` (官方且受支援)
- **npm 套件**：`@modelcontextprotocol/server-github` (自 2025 年 4 月起棄用 - 不再運作)
- **Windsurf 限制**：無環境變數插值，僅限全域配置
