# 遠端伺服器文件

本指南說明了遠端 GitHub MCP 伺服器特有的功能、配置選項和標頭。

## 概觀

遠端 GitHub MCP 伺服器旨在作為雲端服務運行。與透過 stdio 通訊的本地伺服器不同，遠端伺服器透過 HTTP/SSE 通訊，並使用 OAuth 進行身分驗證。

## 身份驗證

遠端伺服器使用 OAuth 2.0 進行身分驗證。用戶端必須在 `Authorization` 標頭中提供有效的持有者權杖 (Bearer Token)：

```http
Authorization: Bearer <GITHUB_TOKEN>
```

## 配置標頭

您可以使用自定義 HTTP 標頭來配置遠端伺服器的行為。這些標頭通常在您的 MCP 用戶端配置中設置。

| 標頭 | 說明 | 範例 |
|--------|-------------|---------|
| `X-MCP-Toolsets` | 啟用特定的工具集（以逗號分隔） | `issues,repos` |
| `X-MCP-Tools` | 啟用個別工具（以逗號分隔） | `get_issue,get_me` |
| `X-MCP-Exclude-Tools` | 排除特定工具 | `delete_issue` |
| `X-MCP-Readonly` | 啟用唯讀模式 | `true` |
| `X-MCP-Lockdown` | 啟用鎖定模式 | `true` |
| `X-MCP-Insiders` | 啟用 Insiders 模式 | `true` |

## URL 路徑配置

除了標頭之外，遠端伺服器還支援透過 URL 路徑進行快速配置。

### 工具集路徑

您可以使用 `/x/{toolset}` 路徑來啟用特定的工具集：

- `https://api.githubcopilot.com/mcp/x/issues` — 僅啟用 `issues` 工具集
- `https://api.githubcopilot.com/mcp/x/all` — 啟用所有可用的工具集

### 修飾符路徑

路徑修飾符可以與工具集路徑結合使用：

- `/readonly` — 啟用唯讀模式
- `/insiders` — 啟用 Insiders 模式

**範例：**

- `https://api.githubcopilot.com/mcp/x/issues/readonly`
- `https://api.githubcopilot.com/mcp/insiders`

## 範圍挑戰 (Scope Challenges)

當您嘗試使用權杖中缺少的權限（OAuth 範圍）的工具時，遠端伺服器會回傳一個範圍挑戰。這通常會導致您的 MCP 用戶端提示您授權所需的其他範圍。

詳情請參閱 [範圍過濾](./scope-filtering_zh_TW.md)。

## 相關文件

- [伺服器配置指南](./server-configuration_zh_TW.md)
- [安裝指南](./installation-guides/README_zh_TW.md)
- [README: 可用工具集](../README.md#available-toolsets)
- [README: 工具](../README.md#tools)
