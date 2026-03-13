# 在 Cline 中安裝 GitHub MCP 伺服器

[Cline](https://github.com/cline/cline) 是一款 AI 編碼助理，可在與 VS Code 相容的編輯器（VS Code、Cursor、Windsurf 等）中執行。有關一般設定資訊（先決條件、Docker 安裝、安全最佳實踐），請參閱[安裝指南 README](./README_zh_TW.md)。

## 遠端伺服器

Cline 將 MCP 設定儲存在 `cline_mcp_settings.json` 中。若要編輯它，請點擊編輯器側邊欄中的 Cline 圖示，開啟 Cline 面板右上角的選單，然後選擇 **"MCP Servers"**。您可以透過 **"Remote Servers"** 標籤新增遠端伺服器，或點擊 **"Configure MCP Servers"** 直接編輯 JSON。

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "type": "streamableHttp",
      "disabled": false,
      "headers": {
        "Authorization": "Bearer <YOUR_GITHUB_PAT>"
      },
      "autoApprove": []
    }
  }
}
```

將 `YOUR_GITHUB_PAT` 替換為您的 [GitHub 個人存取權杖](https://github.com/settings/tokens)。若要自訂工具集，請在 `headers` 物件中新增伺服器端標頭，例如 `X-MCP-Toolsets` 或 `X-MCP-Readonly` — 請參閱[伺服器配置指南](../server-configuration_zh_TW.md)。

> **重要提示**：傳輸類型必須是 `"streamableHttp"`（小駝峰式命名，無連字號）。使用 `"streamable-http"` 或省略類型將導致 Cline 回退到 SSE，從而導致 `405` 錯誤。

## 本地伺服器 (Docker)

1. 點擊編輯器側邊欄中的 Cline 圖示（或開啟指令面板並搜尋 "Cline"），然後點擊 **MCP Servers** 圖示（Cline 面板頂部的伺服器堆疊圖示），並點擊 **"Configure MCP Servers"** 以開啟 `cline_mcp_settings.json`。
2. 新增以下配置，將 `YOUR_GITHUB_PAT` 替換為您的 [GitHub 個人存取權杖](https://github.com/settings/tokens)。

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

- **遠端伺服器出現 SSE 錯誤 405**：確保在 `cline_mcp_settings.json` 中將 `"type"` 設定為 `"streamableHttp"`（小駝峰式命名，無連字號）。使用 `"streamable-http"` 或省略 `"type"` 會導致 Cline 回退到 SSE，而此伺服器不支援 SSE。
- **驗證失敗**：驗證您的 PAT 是否具有所需的範圍 (Scopes)。
- **Docker 問題**：確保已安裝並執行 Docker Desktop。
