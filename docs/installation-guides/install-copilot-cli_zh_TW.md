# 在 Copilot CLI 中安裝 GitHub MCP Server

GitHub MCP Server 已預先安裝在 Copilot CLI 中，預設啟用唯讀工具。

## 內建伺服器

若要驗證伺服器是否可用，請在啟動的 Copilot CLI 工作階段中執行：

```bash
/mcp show github-mcp-server
```

### 個別工作階段自訂

使用 CLI 旗標來為工作階段自訂伺服器：

```bash
# 啟用額外的工具集
copilot --add-github-mcp-toolset discussions

# 啟用多個額外的工具集
copilot --add-github-mcp-toolset discussions --add-github-mcp-toolset stargazers

# 啟用所有工具集
copilot --enable-all-github-mcp-tools

# 啟用特定工具
copilot --add-github-mcp-tool list_discussions

# 完全停用內建伺服器
copilot --disable-builtin-mcps
```

執行 `copilot --help` 查看所有可用的旗標。有關工具集清單，請參閱 [可用的工具集](../../README_zh_TW.md#available-toolsets)；有關工具清單，請參閱 [工具](../../README_zh_TW.md#tools)。

## 自訂配置

您可以使用互動式命令或手動編輯配置檔案，在 Copilot CLI 中配置 GitHub MCP Server。

> **伺服器命名：** 將您的伺服器命名為 `github-mcp-server` 以替換內建伺服器，或使用不同的名稱 (例如 `github`) 以與其並行執行。

### 先決條件

1. 具備適當範圍的 [GitHub 個人存取權杖 (PAT)](https://github.com/settings/personal-access-tokens/new)
2. 本地伺服器：已安裝並執行 [Docker](https://www.docker.com/)

<details>
<summary><b>安全地儲存您的 PAT</b></summary>
<br>

將您的 PAT 設定為環境變數：

```bash
# 新增至您的 shell 設定檔 (~/.bashrc, ~/.zshrc 等)
export GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here
```

</details>

### 方法 1：互動式設定 (推薦)

在啟動的 Copilot CLI 工作階段中，執行互動式命令：

```bash
/mcp add
```

按照提示配置伺服器。

### 方法 2：手動設定

建立或編輯配置檔案 `~/.copilot/mcp-config.json` 並新增以下配置之一：

#### 遠端伺服器

連接到託管的 MCP 伺服器：

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

有關工具集和唯讀模式等額外選項，請參閱 [遠端伺服器文件](../remote-server_zh_TW.md#optional-headers)。

#### 本地 Docker

在 Docker 執行的情況下，您可以在容器中執行 GitHub MCP Server：

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
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

#### 二進位檔

您可以從 [GitHub releases 頁面](https://github.com/github/github-mcp-server/releases) 下載最新的二進位發佈版本，或透過執行以下命令從原始碼建置：

```bash
go build -o github-mcp-server ./cmd/github-mcp-server
```

然後進行配置 (將 `/path/to/binary` 替換為實際路徑)：

```json
{
  "mcpServers": {
    "github": {
      "command": "/path/to/binary",
      "args": ["stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

## 驗證

1. 重啟 Copilot CLI
2. 執行 `/mcp show` 以列出配置的伺服器
3. 嘗試：「列出我的 GitHub 儲存庫」

## 疑難排解

### 本地伺服器問題

- **Docker 錯誤**：確保 Docker Desktop 正在執行
- **映像檔拉取失敗**：嘗試 `docker logout ghcr.io` 然後重試

### 身分驗證問題

- **無效的 PAT**：確認您的 GitHub PAT 具備正確的範圍：
  - `repo` - 儲存庫操作
  - `read:packages` - Docker 映像檔存取 (如果使用 Docker)
- **權杖已過期**：產生新的 GitHub PAT

### 配置問題

- **無效的 JSON**：驗證您的配置：
  ```bash
  cat ~/.copilot/mcp-config.json | jq .
  ```

## 參考資料

- [Copilot CLI 文件](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
