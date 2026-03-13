# 在 Cursor 中安裝 GitHub MCP Server

## 先決條件

1. 已安裝 Cursor IDE (最新版本)
2. 具備適當範圍的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
3. 本地安裝：已安裝並執行 [Docker](https://www.docker.com/)

## 遠端伺服器設定 (推薦)

[![安裝 MCP 伺服器](https://cursor.com/deeplink/mcp-install-dark.svg)](https://cursor.com/en/install-mcp?name=github&config=eyJ1cmwiOiJodHRwczovL2FwaS5naXRodWJjb3BpbG90LmNvbS9tY3AvIiwiaGVhZGVycyI6eyJBdXRob3JpemF0aW9uIjoiQmVhcmVyIFlPVVJfR0lUSFVCX1BBVCJ9fQ%3D%3D)

使用 GitHub 託管的伺服器，網址為 https://api.githubcopilot.com/mcp/。需要 Cursor v0.48.0+ 才能支援 Streamable HTTP。雖然 Cursor 支援部分 MCP 伺服器的 OAuth，但 GitHub 伺服器目前仍需要個人存取權杖 (PAT)。

### 安裝步驟

1. 點擊上方的安裝按鈕並按照流程操作，或直接前往您的全域 MCP 配置檔案 `~/.cursor/mcp.json` 並輸入下方的程式碼區塊
2. 在 Tools & Integrations > MCP tools 中，點擊 "github" 旁邊的鉛筆圖示
3. 將 `YOUR_GITHUB_PAT` 替換為您的實際 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/tokens)
4. 儲存檔案
5. 重啟 Cursor

### Streamable HTTP 配置

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_GITHUB_PAT"
      }
    }
  }
}
```

## 本地伺服器設定

[![安裝 MCP 伺服器](https://cursor.com/deeplink/mcp-install-dark.svg)](https://cursor.com/en/install-mcp?name=github&config=eyJjb21tYW5kIjoiZG9ja2VyIHJ1biAtaSAtLXJtIC1lIEdJVEhVQl9QRVJTT05BTF9BQ0NFU1NfVE9LRU4gZ2hjci5pby9naXRodWIvZ2l0aHViLW1jcC1zZXJ2ZXIiLCJlbnYiOnsiR0lUSFVCX1BFUlNPTkFMX0FDQ0VTU19UT0tFTiI6IllPVVJfR0lUSFVCX1BBVCJ9fQ%3D%3D)

本地 GitHub MCP Server 透過 Docker 執行，需要安裝並執行 Docker Desktop。

### 安裝步驟

1. 點擊上方的安裝按鈕並按照流程操作，或直接前往您的全域 MCP 配置檔案 `~/.cursor/mcp.json` 並輸入下方的程式碼區塊
2. 在 Tools & Integrations > MCP tools 中，點擊 "github" 旁邊的鉛筆圖示
3. 將 `YOUR_GITHUB_PAT` 替換為您的實際 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/tokens)
4. 儲存檔案
5. 重啟 Cursor

### Docker 配置

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

> **重要**：自 2025 年 4 月起，不再支援 npm 套件 `@modelcontextprotocol/server-github`。請改用官方 Docker 映像檔 `ghcr.io/github/github-mcp-server`。

## 配置檔案

- **全域 (所有專案)**：`~/.cursor/mcp.json`
- **專案特定**：專案根目錄下的 `.cursor/mcp.json`

## 驗證安裝

1. 完全重啟 Cursor
2. 檢查 Settings → Tools & Integrations → MCP Tools 中是否有綠點
3. 在 chat/composer 中，檢查 "Available Tools"
4. 測試：「列出我的 GitHub 儲存庫」

## 疑難排解

### 遠端伺服器問題

- **Streamable HTTP 無法運作**：確保您使用的是 Cursor v0.48.0 或更新版本
- **身分驗證失敗**：驗證 PAT 具備正確的範圍
- **連線錯誤**：檢查防火牆/代理伺服器設定

### 本地伺服器問題

- **Docker 錯誤**：確保 Docker Desktop 正在執行
- **映像檔拉取失敗**：嘗試 `docker logout ghcr.io` 然後重試
- **找不到 Docker**：安裝 Docker Desktop 並確保其正在執行

### 一般問題

- **MCP 未載入**：配置後完全重啟 Cursor
- **無效的 JSON**：驗證 JSON 格式是否正確
- **工具未出現**：檢查伺服器在 MCP 設定中是否顯示綠點
- **檢查日誌**：在 Cursor 日誌中尋找與 MCP 相關的錯誤

## 重要注意事項

- **Docker 映像檔**：`ghcr.io/github/github-mcp-server` (官方且受支援)
- **npm 套件**：`@modelcontextprotocol/server-github` (自 2025 年 4 月起棄用 - 不再運作)
- **Cursor 特性**：支援專案與全域配置，使用 `mcpServers` 鍵名
