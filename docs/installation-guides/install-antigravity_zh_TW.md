# 在 Antigravity 中安裝 GitHub MCP 伺服器

本指南介紹如何在 Google 的 Antigravity IDE 中設定 GitHub MCP 伺服器。

## 先決條件

- 已安裝 Antigravity IDE（最新版本）
- 具有適當範圍的 GitHub 個人存取權杖 (PAT)

## 安裝方法

### 選項 1：遠端伺服器 (推薦)

使用 GitHub 託管的伺服器，網址為 `https://api.githubcopilot.com/mcp/`。

> [!NOTE]
> 我們推薦這種手動配置方法，因為目前透過 Antigravity MCP 商店進行的「官方」安裝存在已知問題（通常會導致 Docker 錯誤）。這種直接的遠端連接更為可靠。

#### 步驟 1：存取 MCP 配置

1. 開啟 Antigravity。
2. 點擊 Agent 面板中的 "..."（更多選項）選單。
3. 選擇 "MCP Servers"。
4. 點擊 "Manage MCP Servers"。
5. 點擊 "View raw config"。

這將開啟您的 `mcp_config.json` 檔案，路徑如下：
- **Windows**: `C:\Users\<使用者名稱>\.gemini\antigravity\mcp_config.json`
- **macOS/Linux**: `~/.gemini/antigravity/mcp_config.json`

#### 步驟 2：新增配置

將以下內容新增至您的 `mcp_config.json`：

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

**重要提示**：請注意 Antigravity 對於基於 HTTP 的 MCP 伺服器使用 `serverUrl` 而非 `url`。

#### 步驟 3：配置您的權杖

將 `YOUR_GITHUB_PAT` 替換為您實際的 GitHub 個人存取權杖。

在此建立權杖：https://github.com/settings/tokens

推薦範圍 (Scopes)：
- `repo` - 完整控制私有儲存庫
- `read:org` - 讀取組織和團隊成員資格
- `read:user` - 讀取使用者個人資料數據

#### 步驟 4：重新啟動 Antigravity

關閉並重新開啟 Antigravity 以使更改生效。

#### 步驟 5：驗證安裝

1. 開啟 MCP Servers 面板（... 選單 → MCP Servers）。
2. 您應該會看到 "github" 以及可用工具列表。
3. 您現在可以在對話中使用 GitHub 工具。

> [!NOTE]
> 在某些版本中，MCP Servers 面板中的狀態指示燈可能不會立即變綠，但如果配置正確，工具仍可正常運作。

### 選項 2：本地 Docker 伺服器

如果您偏好使用 Docker 在本地執行伺服器：

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

**要求**：
- 已安裝並執行 Docker Desktop
- Docker 必須在系統的 PATH 中

## 疑難排解

### "Error: serverUrl or command must be specified"

請確保您在遠端伺服器配置中使用的是 `serverUrl`（而非 `url`）。Antigravity 要求基於 HTTP 的 MCP 伺服器必須使用 `serverUrl`。

### 伺服器未出現在 MCP 列表中

- 驗證配置檔案中的 JSON 語法。
- 檢查您的 PAT 是否已過期。
- 完全重新啟動 Antigravity。

### 工具無法運作

- 確保您的 PAT 具有正確的範圍 (Scopes)。
- 檢查 MCP Servers 面板是否有錯誤訊息。
- 驗證遠端伺服器的網路連接。

## 可用工具

安裝後，您將可以存取如下工具：
- `create_repository` - 建立新的 GitHub 儲存庫
- `push_files` - 推送檔案到儲存庫
- `search_repositories` - 搜尋儲存庫
- `create_or_update_file` - 管理檔案內容
- `get_file_contents` - 讀取檔案內容
- 以及更多...

如需可用工具和功能的完整列表，請參閱[主 README](../../README_zh_TW.md)。

## 與其他 IDE 的差異

- **配置鍵值 (Key)**：Antigravity 對於 HTTP 伺服器使用 `serverUrl` 而非 `url`。
- **配置位置**：`.gemini/antigravity/mcp_config.json` 而非 `.cursor/mcp.json`。
- **工具限制**：Antigravity 建議將啟用的工具總數保持在 50 個以下，以獲得最佳效能。

## 下一步

- 探索[伺服器配置指南](../server-configuration_zh_TW.md)以了解進階選項。
- 查看[工具集文件](../../README_zh_TW.md#available-toolsets)以自訂可用工具。
- 參閱[遠端伺服器文件](../remote-server_zh_TW.md)以獲取更多詳細資訊。
