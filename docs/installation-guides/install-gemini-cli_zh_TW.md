# 在 Google Gemini CLI 中安裝 GitHub MCP Server

## 先決條件

1. 已安裝 Google Gemini CLI (請參閱 [官方 Gemini CLI 文件](https://github.com/google-gemini/gemini-cli))
2. 具備適當範圍的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
3. 本地安裝：已安裝並執行 [Docker](https://www.docker.com/)

<details>
<summary><b>安全地儲存您的 PAT</b></summary>
<br>

為了安全起見，請避免硬編碼您的權杖。在 `~/.gemini/.env` (其中 `~` 是您的家目錄或專案目錄) 中建立或更新您的 PAT：

```bash
# ~/.gemini/.env
GITHUB_MCP_PAT=your_token_here
```

</details>

## GitHub MCP Server 配置

Gemini CLI 的 MCP 伺服器是在其設定 JSON 中的 `mcpServers` 鍵下配置的。

- **全域配置**：`~/.gemini/settings.json`，其中 `~` 是您的家目錄
- **專案特定**：您專案目錄中的 `.gemini/settings.json`

安全地儲存您的 PAT 後，您可以使用以下方法之一將 GitHub MCP Server 配置新增至您的設定檔案中。您可能需要重啟 Gemini CLI 才能使變更生效。

> **注意：** 有關最新的配置選項，請參閱 [主要 README_zh_TW.md](../../README_zh_TW.md)。

### 方法 1：Gemini 擴充功能 (推薦)

最簡單的方法是透過我們的 Gemini 擴充功能使用 GitHub 託管的 MCP 伺服器。

`gemini extensions install https://github.com/github/github-mcp-server`

> [!NOTE]
> 您仍然需要在環境中準備一個名為 `GITHUB_MCP_PAT` 且具備適當範圍的個人存取權杖。

### 方法 2：遠端伺服器

您也可以直接連接到託管的 MCP 伺服器。安全地儲存您的 PAT 後，配置 Gemini CLI：

```json
// ~/.gemini/settings.json
{
    "mcpServers": {
        "github": {
            "httpUrl": "https://api.githubcopilot.com/mcp/",
            "headers": {
                "Authorization": "Bearer $GITHUB_MCP_PAT"
            }
        }
    }
}
```

### 方法 3：本地 Docker

在 Docker 執行的情況下，您可以在容器中執行 GitHub MCP Server：

```json
// ~/.gemini/settings.json
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
                "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_MCP_PAT"
            }
        }
    }
}
```

### 方法 4：二進位檔

您可以從 [GitHub releases 頁面](https://github.com/github/github-mcp-server/releases) 下載最新的二進位發佈版本，或透過執行 `go build -o github-mcp-server ./cmd/github-mcp-server` 從原始碼建置。

然後，將 `/path/to/binary` 替換為二進位檔的實際路徑，配置 Gemini CLI：

```json
// ~/.gemini/settings.json
{
    "mcpServers": {
        "github": {
            "command": "/path/to/binary",
            "args": ["stdio"],
            "env": {
                "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_MCP_PAT"
            }
        }
    }
}
```

## 驗證

若要驗證 GitHub MCP Server 是否已配置，請在終端機中以 `gemini` 啟動 Gemini CLI，然後：

1. **檢查 MCP 伺服器狀態**：

    ```
    /mcp list
    ```

    ```
    ℹConfigured MCP servers:

    🟢 github - Ready (96 tools, 2 prompts)
        Tools:
        - github__add_comment_to_pending_review
        - github__add_issue_comment
        - github__add_sub_issue
        ...
    ```

2. **使用提示詞測試**
    ```
    列出我的 GitHub 儲存庫
    ```

## 額外配置

您可以在這裡找到更多 Gemini CLI 的 MCP 配置選項：[MCP 配置結構](https://google-gemini.github.io/gemini-cli/docs/tools/mcp-server.html#configuration-structure)。例如，繞過工具確認或排除特定工具。

## 疑難排解

### 本地伺服器問題

- **Docker 錯誤**：確保 Docker Desktop 正在執行
    ```bash
    docker --version
    ```
- **映像檔拉取失敗**：嘗試 `docker logout ghcr.io` 然後重試
- **找不到 Docker**：安裝 Docker Desktop 並確保其正在執行

### 身分驗證問題

- **無效的 PAT**：確認您的 GitHub PAT 具備正確的範圍：
    - `repo` - 儲存庫操作
    - `read:packages` - Docker 映像檔存取 (如果使用 Docker)
- **權杖已過期**：產生新的 GitHub PAT

### 配置問題

- **無效的 JSON**：驗證您的配置：
    ```bash
    cat ~/.gemini/settings.json | jq .
    ```
- **MCP 連線問題**：檢查日誌中的連線錯誤：
    ```bash
    gemini --debug "測試命令"
    ```

## 參考資料

- Gemini CLI 文件 > [MCP 配置結構](https://google-gemini.github.io/gemini-cli/docs/tools/mcp-server.html#configuration-structure)
