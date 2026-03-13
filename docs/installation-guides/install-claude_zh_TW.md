# 在 Claude 應用程式中安裝 GitHub MCP 伺服器

## Claude Code CLI

### 先決條件
- 已安裝 Claude Code CLI
- [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
- 本地設定：已安裝並執行 [Docker](https://www.docker.com/)
- 在專案目錄中開啟 Claude Code（推薦以獲得最佳體驗和明確的配置範圍）

<details>
<summary><b>安全地儲存您的 PAT</b></summary>
<br>

為了安全起見，請避免硬編碼您的權杖。一種常見的方法：

1. 將權杖儲存在 `.env` 檔案中
```
GITHUB_PAT=your_token_here
```

2. 新增到 .gitignore
```bash
echo -e ".env\n.mcp.json" >> .gitignore
```

</details>

### 遠端伺服器設定 (Streamable HTTP)

> **注意**：對於 Claude Code 版本 **2.1.1 及更高版本**，請使用下方的 `add-json` 指令格式。對於舊版本，請參閱[舊版指令格式](#對於舊版本的-claude-code)。
>
> **Windows / CLI 注意事項**：新增 HTTP 伺服器時，`claude mcp add-json` 可能會傳回 `Invalid input`。如果發生這種情況，請使用下方的舊版 `claude mcp add --transport http ...` 指令格式。

1. 在終端機中執行以下指令（不要在 Claude Code CLI 中執行）：
```bash
claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer YOUR_GITHUB_PAT"}}'
```

使用環境變數：
```bash
claude mcp add-json github '{"type":"http","url":"https://api.githubcopilot.com/mcp","headers":{"Authorization":"Bearer '"$(grep GITHUB_PAT .env | cut -d '=' -f2)"'"}}'
```

> **關於 `--scope` 旗標**（選填）：使用此旗標指定配置儲存的位置：
> - `local`（預設）：僅在當前專案中對您可用（在舊版本中稱為 `project`）
> - `project`：透過 `.mcp.json` 檔案與專案中的每個人共享
> - `user`：在所有專案中對您可用（在舊版本中稱為 `global`）
>
> 範例：在指令末尾新增 `--scope user` 以使其在所有專案中可用。

2. 重新啟動 Claude Code
3. 執行 `claude mcp list` 查看 GitHub 伺服器是否已配置

### 本地伺服器設定 (需安裝 Docker)

### 使用 Docker
1. 在終端機中執行以下指令（不要在 Claude Code CLI 中執行）：
```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=YOUR_GITHUB_PAT -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

使用環境變數：
```bash
claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$(grep GITHUB_PAT .env | cut -d '=' -f2) -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```
2. 重新啟動 Claude Code
3. 執行 `claude mcp list` 查看 GitHub 伺服器是否已配置

### 使用二進制檔 (不使用 Docker)

1. 下載 [發佈版二進制檔](https://github.com/github/github-mcp-server/releases)
2. 新增到您的 `PATH`
3. 執行：
```bash
claude mcp add-json github '{"command": "github-mcp-server", "args": ["stdio"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT"}}'
```
2. 重新啟動 Claude Code
3. 執行 `claude mcp list` 查看 GitHub 伺服器是否已配置

### 驗證
```bash
claude mcp list
claude mcp get github
```

### 對於舊版本的 Claude Code

如果您使用的是 Claude Code 版本 **2.1.0 或更早版本**，請使用此舊版指令格式：

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer YOUR_GITHUB_PAT"
```

使用環境變數：
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer $(grep GITHUB_PAT .env | cut -d '=' -f2)"
```

#### Windows (PowerShell)

如果您看到 `missing required argument 'name'`，請將伺服器名稱緊接在 `claude mcp add` 之後：

```powershell
$pat = "YOUR_GITHUB_PAT"
claude mcp add github --transport http https://api.githubcopilot.com/mcp/ -H "Authorization: Bearer $pat"
```

---

## Claude Desktop

> ⚠️ **注意**：部分使用者報告了 Claude Desktop 與基於 Docker 的 MCP 伺服器的相容性問題。我們正在調查中。如果您遇到問題，在我們解決期間，請嘗試使用其他 MCP 主機應用程式！

### 先決條件
- 已安裝 Claude Desktop（最新版本）
- [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
- 已安裝並執行 [Docker](https://www.docker.com/)

> **注意**：Claude Desktop 同時支援本地 (stdio) 和遠端 ("connectors") 的 MCP 伺服器。遠端伺服器通常可以透過 Settings → Connectors → "Add custom connector" 新增。然而，GitHub 遠端 MCP 伺服器需要透過註冊的 GitHub App（或 OAuth App）進行 OAuth 驗證，目前尚不支援此功能。請改用本地 Docker 設定。

### 配置檔案位置
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **Linux**: `~/.config/Claude/claude_desktop_config.json`

### 本地伺服器設定 (Docker)

將此程式碼區塊新增至您的 `claude_desktop_config.json`：

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

### 手動設定步驟
1. 開啟 Claude Desktop。
2. 前往 Settings → Developer → Edit Config。
3. 在配置檔案中貼上方的程式碼區塊。
4. 如果您是在應用程式之外導航到配置檔案：
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
5. 使用文字編輯器開啟檔案。
6. 根據您選擇的配置（遠端或本地）貼上上述程式碼區塊之一。
7. 將 `YOUR_GITHUB_PAT` 替換為您實際的權杖或 $GITHUB_PAT 環境變數。
8. 儲存檔案。
9. 重新啟動 Claude Desktop。

---

## 疑難排解

**驗證失敗：**
- 驗證 PAT 是否具有 `repo` 範圍。
- 檢查權杖是否已過期。

**遠端伺服器：**
- 驗證 URL：`https://api.githubcopilot.com/mcp`

**Docker 問題（僅限本地）：**
- 確保 Docker Desktop 正在執行。
- 嘗試：`docker pull ghcr.io/github/github-mcp-server`
- 如果拉取失敗：執行 `docker logout ghcr.io` 然後重試。

**伺服器未啟動 / 工具未顯示：**
- 執行 `claude mcp list` 查看當前配置的 MCP 伺服器。
- 驗證 JSON 語法。
- 如果使用環境變數儲存 PAT，請確保您已正確引用環境變數。
- 重新啟動 Claude Code 並檢查 `/mcp` 指令。
- 執行 `claude mcp remove github` 刪除 GitHub 伺服器，然後使用不同的方法重複設定程序。
- 確保您在當前處理的專案中執行 Claude Code，以確保 MCP 配置正確套用於您的專案範圍。
- 檢查日誌：
  - Claude Code：使用 `/mcp` 指令。
  - Claude Desktop：`ls ~/Library/Logs/Claude/` 並 `cat ~/Library/Logs/Claude/mcp-server-*.log` (macOS) 或 `%APPDATA%\Claude\logs\` (Windows)。

---

## 重要注意事項

- 自 2025 年 4 月起，npm 套件 `@modelcontextprotocol/server-github` 已棄用。
- 遠端伺服器需要 Streamable HTTP 支援（請檢查您的 Claude 版本）。
- 有關 Claude Code 配置範圍，請參閱 [遠端伺服器設定 (Streamable HTTP)](#遠端伺服器設定-streamable-http) 章節中的 `--scope` 旗標文件。
