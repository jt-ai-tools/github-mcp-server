# 在 Roo Code 中安裝 GitHub MCP Server

[Roo Code](https://github.com/RooCodeInc/Roo-Code) 是一款 AI 編碼助手，可在相容 VS Code 的編輯器 (VS Code, Cursor, Windsurf 等) 中執行。有關一般設定資訊 (先決條件、Docker 安裝、安全最佳實踐)，請參閱 [安裝指南 README](./README_zh_TW.md)。

## 遠端伺服器

### 逐步設定

1. 點擊編輯器側邊欄中的 **Roo Code 圖示** 以開啟 Roo Code 面板
2. 點擊 Roo Code 面板頂部導覽列中的 **齒輪圖示** (⚙️)，然後點擊左側的 **"MCP Servers"** 圖示。
3. 捲動到底部並點擊 **"Edit Global MCP"** (適用於所有專案) 或 **"Edit Project MCP"** (僅適用於目前專案)
4. 將以下配置新增至開啟的檔案 (`mcp_settings.json` 或 `.roo/mcp.json`)
5. 將 `YOUR_GITHUB_PAT` 替換為您的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/tokens)
6. 儲存檔案 — 伺服器應會自動連線

```json
{
  "mcpServers": {
    "github": {
      "type": "streamable-http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_GITHUB_PAT"
      }
    }
  }
}
```

> **重要：** `type` 必須為 `"streamable-http"` (含連字號)。使用 `"http"` 或省略類型將會導致失敗。

若要自訂工具集，請在 `headers` 物件中新增伺服器端標頭，例如 `X-MCP-Toolsets` 或 `X-MCP-Readonly` — 請參閱 [伺服器配置指南](../server-configuration_zh_TW.md)。

## 本地伺服器 (Docker)

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"
      }
    }
  }
}
```

## 疑難排解

- **連線失敗**：確保 `type` 是 `streamable-http`，而非 `http`
- **身分驗證失敗**：驗證 `Authorization` 標頭中的 PAT 是否帶有 `Bearer ` 前綴
- **Docker 問題**：確保 Docker Desktop 正在執行
