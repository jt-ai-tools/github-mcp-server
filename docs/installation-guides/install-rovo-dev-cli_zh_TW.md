# 在 Rovo Dev CLI 中安裝 GitHub MCP Server

## 先決條件

1. 已安裝 Rovo Dev CLI (最新版本)
2. 具備適當範圍的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)

## MCP 伺服器設定

使用 GitHub 託管的伺服器，網址為 https://api.githubcopilot.com/mcp/。

### 安裝步驟

1. 執行 `acli rovodev mcp` 開啟 Rovo Dev CLI 的 MCP 配置
2. 參考下方範例新增配置。
3. 將 `YOUR_GITHUB_PAT` 替換為您的實際 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/tokens)
4. 儲存檔案並使用 `acli rovodev` 重啟 Rovo Dev CLI

### 配置範例

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
