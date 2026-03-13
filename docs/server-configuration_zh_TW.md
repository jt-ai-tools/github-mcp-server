# 伺服器配置指南

本指南幫助您為您的使用案例選擇正確的配置，並向您展示如何套用它。有關可用工具集和工具的完整參考，請參閱 [README](../README.md#tool-configuration)。

## 快速參考
我們目前支援以下 GitHub MCP 伺服器的配置方式：

| 配置 | 遠端伺服器 | 本地伺服器 |
|---------------|---------------|--------------|
| 工具集 | `X-MCP-Toolsets` 標頭或 `/x/{toolset}` URL | `--toolsets` 旗標或 `GITHUB_TOOLSETS` 環境變數 |
| 個別工具 | `X-MCP-Tools` 標頭 | `--tools` 旗標執或 `GITHUB_TOOLS` 環境變數 |
| 排除工具 | `X-MCP-Exclude-Tools` 標頭 | `--exclude-tools` 旗標或 `GITHUB_EXCLUDE_TOOLS` 環境變數 |
| 唯讀模式 | `X-MCP-Readonly` 標頭或 `/readonly` URL | `--read-only` 旗標或 `GITHUB_READ_ONLY` 環境變數 |
| 動態模式 | 不可用 | `--dynamic-toolsets` 旗標或 `GITHUB_DYNAMIC_TOOLSETS` 環境變數 |
| 鎖定模式 | `X-MCP-Lockdown` 標頭 | `--lockdown-mode` 旗標或 `GITHUB_LOCKDOWN_MODE` 環境變數 |
| Insiders 模式 | `X-MCP-Insiders` 標頭或 `/insiders` URL | `--insiders` 旗標或 `GITHUB_INSIDERS` 環境變數 |
| 範圍過濾 | 始終啟用 | 始終啟用 |

> **預設行為：** 如果您未指定任何配置，伺服器將使用 **預設工具集**：`context`, `issues`, `pull_requests`, `repos`, `users`。

---

## 配置運作方式

所有配置選項都是 **可組合的**：您可以將工具集、個別工具、排除工具、動態發現、唯讀模式和鎖定模式以任何適合您工作流程的方式組合。

注意：**唯讀 (read-only)** 模式作為嚴格的安全過濾器，其優先級高於任何其他配置，即使明確要求也會禁用寫入工具。

注意：**排除工具 (excluded tools)** 的優先級高於工具集和個別工具 —— 列出的工具始終被排除，即使啟用了它們的工具集或透過 `--tools` / `X-MCP-Tools` 明確添加。

---

## 配置範例

以下範例使用 VS Code 配置格式來說明概念。如果您使用不同的 MCP 主機 (Cursor, Claude Desktop, JetBrains 等)，您的配置看起來可能略有不同。請參閱 [安裝指南](./installation-guides/README_zh_TW.md) 了解主機特定的設定。

### 啟用特定工具

**最適合：** 確切知道自己需要什麼，並希望透過僅載入將使用的工具來優化 context 使用量的使用者。

**範例：**

<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Tools": "get_file_contents,get_me,pull_request_read"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--tools=get_file_contents,get_me,pull_request_read"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

---

### 啟用特定工具集

**最適合：** 想要啟用多個相關工具集的使用者。

<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Toolsets": "issues,pull_requests"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--toolsets=issues,pull_requests"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

---

### 啟用工具集 + 工具

**最適合：** 希望在某些領域擁有廣泛功能，而在其他領域擁有特定工具的使用者。

啟用整個工具集，然後從您不想完全啟用的工具集中添加個別工具。

<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Toolsets": "repos,issues",
    "X-MCP-Tools": "get_gist,pull_request_read"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--toolsets=repos,issues",
    "--tools=get_gist,pull_request_read"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

**結果：** 所有存儲庫和 issue 工具，加上您需要的 gist 工具。

---

### 排除特定工具

**最適合：** 想要啟用廣泛工具集但需要出於安全、合規性原因或防止不當行為而排除特定工具的使用者。

無論任何其他配置如何，列出的工具都會被移除 —— 即使啟用了它們的工具集或單獨添加了它們。

<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Toolsets": "pull_requests",
    "X-MCP-Exclude-Tools": "create_pull_request,merge_pull_request"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--toolsets=pull_requests",
    "--exclude-tools=create_pull_request,merge_pull_request"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

**結果：** 除了 `create_pull_request` 和 `merge_pull_request` 之外的所有拉取請求工具 —— 使用者僅獲得讀取和審閱工具。

---

### 唯讀模式

**最適合：** 有安全意識的使用者，希望確保伺服器不允許修改 issue、拉取請求、存儲庫等操作。

啟用後，即使請求了非唯讀工具，此模式也會將其禁用。

**範例：**
<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

**選項 A：標頭**
```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Toolsets": "issues,repos,pull_requests",
    "X-MCP-Readonly": "true"
  }
}
```

**選項 B：URL 路徑**
```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/x/all/readonly"
}
```

</td>
<td>


```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--toolsets=issues,repos,pull_requests",
    "--read-only"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

> 即使 `issues` 工具集包含 `create_issue`，它也會在唯讀模式下被排除。

---

### 動態發現（僅限本地）

**最適合：** 讓 LLM 根據需要發現並啟用工具集。

僅啟動發現工具（`enable_toolset`, `list_available_toolsets`, `get_toolset_tools`），然後按需擴展。

<table>
<tr><th>僅限本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--dynamic-toolsets"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

**預先啟用部分工具：**
```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--dynamic-toolsets",
    "--tools=get_me,search_code"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

當伺服器配置中同時啟用了動態模式和特定工具時，伺服器將以 3 個動態工具 + 指定工具啟動。

---

### 鎖定模式 (Lockdown Mode)

**最適合：** 公共存儲庫，您希望限制來自沒有推送權限的使用者的內容。

鎖定模式確保伺服器僅在公共存儲庫中顯示具有該存儲庫推送權限的使用者的內容。私人存儲庫不受影響，協作者保留對其自己內容的完整存取權限。

**範例：**
<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Lockdown": "true"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--lockdown-mode"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

---

### Insiders 模式

**最適合：** 想要在實驗性功能和新工具正式發布之前儘早體驗的使用者。

Insiders 模式解鎖實驗性功能，例如 [MCP 應用程式 (MCP Apps)](./insiders-features_zh_TW.md#mcp-apps) 支援。我們建立此模式是為了推出實驗性功能並收集回饋。因此，如果您正在使用 Insiders，請隨時向我們分享您的回饋！Insiders 模式中的功能可能會根據使用者回饋而更改、演進或刪除。

<table>
<tr><th>遠端伺服器</th><th>本地伺服器</th></tr>
<tr valign="top">
<td>

**選項 A：URL 路徑**
```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/insiders"
}
```

**選項 B：標頭**
```json
{
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/",
  "headers": {
    "X-MCP-Insiders": "true"
  }
}
```

</td>
<td>

```json
{
  "type": "stdio",
  "command": "go",
  "args": [
    "run",
    "./cmd/github-mcp-server",
    "stdio",
    "--insiders"
  ],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
  }
}
```

</td>
</tr>
</table>

有關 Insiders 模式中可用功能的完整清單，請參閱 [Insiders 功能](./insiders-features_zh_TW.md)。

---

### 範圍過濾

**自動功能：** 伺服器根據身份驗證類型以不同方式處理 OAuth 範圍：

- **傳統 PAT** (`ghp_` 前綴)：工具在啟動時根據權杖範圍進行過濾 —— 您只會看到您有權限使用的工具
- **OAuth**（遠端伺服器）：使用範圍挑戰 —— 當工具需要您尚未授予的範圍時，系統會提示您授權
- **其他權杖**：無過濾 —— 顯示所有工具，由 API 強制執行權限

這是透明發生的 —— 不需要配置。如果傳統 PAT 的範圍偵測失敗（例如：網路問題），伺服器會記錄一條警告，並在提供所有工具的情況下繼續運行。

有關過濾如何與不同權杖類型搭配使用的詳細資訊，請參閱 [範圍過濾](./scope-filtering_zh_TW.md)。

---

## 疑難排解

| 問題 | 原因 | 解決方案 |
|---------|-------|----------|
| 伺服器啟動失敗 | `--tools` 或 `X-MCP-Tools` 中的工具名稱無效 | 檢查工具名稱拼寫；使用 [工具列表](../README.md#tools) 中的確切名稱 |
| 寫入工具無法運作 | 啟用了唯讀模式 | 移除 `--read-only` 旗標或 `X-MCP-Readonly` 標頭 |
| 工具缺失 | 未啟用工具集 | 添加所需的工具集或特定工具 |
| 動態工具不可用 | 正在使用遠端伺服器 | 動態模式僅在本地 MCP 伺服器中可用 |

---

## 有用連結

- [README：工具配置](../README.md#tool-configuration)
- [README：可用工具集](../README.md#available-toolsets) — 工具集完整列表
- [README：工具](../README.md#tools) — 個別工具完整列表
- [遠端伺服器文件](./remote-server_zh_TW.md) — 遠端特定的選項和標頭
- [安裝指南](./installation-guides/README_zh_TW.md) — 主機特定設定說明
