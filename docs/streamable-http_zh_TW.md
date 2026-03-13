# 可串流 HTTP 伺服器 (Streamable HTTP Server)

可串流 HTTP (Streamable HTTP) 模式使 GitHub MCP 伺服器能夠作為 HTTP 服務運行，允許用戶端透過標準 HTTP 協定連接。此模式非常適合不適合使用 stdio 傳輸的部署場景，例如反向代理設定、容器化環境或分散式架構。

## 功能

- **可串流 HTTP 傳輸** — 完整的 HTTP 伺服器，支援即時工具回應的串流傳輸
- **OAuth 中繼資料端點** — 針對 OAuth 用戶端的標準 `.well-known/oauth-protected-resource` 探索
- **範圍挑戰支援** — 自動進行範圍驗證，並提供正確的 HTTP 403 回應和 `WWW-Authenticate` 標頭
- **範圍過濾** — 根據已驗證的憑證和權限限制可用工具
- **自定義基礎路徑** — 支援具備自定義基礎 URL 的反向代理部署

## 執行伺服器

### 基本 HTTP 伺服器

在預設連接埠 (8082) 上啟動伺服器：

```bash
github-mcp-server http
```

伺服器將在 `http://localhost:8082` 可用。

### 啟用範圍挑戰

啟用範圍驗證以強制執行 GitHub 權限檢查：

```bash
github-mcp-server http --scope-challenge
```

啟用 `--scope-challenge` 後，權限不足的請求將收到 `403 Forbidden` 回應，並帶有指示所需範圍的 `WWW-Authenticate` 標頭。

### 啟用 OAuth 中繼資料探索

對於在反向代理後方或使用自定義網域的使用，公開 OAuth 中繼資料端點：

```bash
github-mcp-server http --scope-challenge --base-url https://myserver.com --base-path /mcp
```

OAuth 受保護資源中繼資料的 `resource` 屬性將填入伺服器受保護資源端點的完整 URL：

```json
{
  "resource_name": "GitHub MCP Server",
  "resource": "https://myserver.com/mcp",
  "authorization_servers": [
    "https://github.com/login/oauth"
  ],
  "scopes_supported": [
    "repo",
    ...
  ],
  ...
}
```

這允許 OAuth 用戶端自動探索身份驗證要求和端點資訊。

## 用戶端配置

### 使用 OAuth 身份驗證

如果您的 IDE 或用戶端已配置 GitHub 憑證（即 VS Code），只需引用 HTTP 伺服器即可：

```json
{
  "type": "http",
  "url": "http://localhost:8082"
}
```

伺服器將使用用戶端現有的 GitHub 身份驗證。

### 使用持有者權杖 (Bearer Tokens) 或自定義標頭

要提供 PAT 憑證，或自定義伺服器行為偏好，您可以在用戶端配置中包含額外的標頭：

```json
{
  "type": "http",
  "url": "http://localhost:8082",
  "headers": {
    "Authorization": "Bearer ghp_yourtokenhere",
    "X-MCP-Toolsets": "default",
    "X-MCP-Readonly": "true"
  }
}
```

有關用戶端配置選項的更多詳細資訊，請參閱 [遠端伺服器](./remote-server_zh_TW.md) 文件。
