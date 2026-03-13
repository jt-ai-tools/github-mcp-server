[![Go Report Card](https://goreportcard.com/badge/github.com/github/github-mcp-server)](https://goreportcard.com/report/github.com/github/github-mcp-server)

# GitHub MCP 伺服器 (GitHub MCP Server)

[English](./README.md) | 繁體中文

GitHub MCP 伺服器將 AI 工具直接連接到 GitHub 平台。這讓 AI 代理、助手和聊天機器人能夠讀取儲存庫和程式碼檔案、管理議題 (Issues) 和拉取請求 (PRs)、分析程式碼並自動化工作流程。這一切都透過自然語言互動完成。

### 使用場景

- **儲存庫管理**：在您有權存取的任何儲存庫中瀏覽和查詢程式碼、搜尋檔案、分析提交 (Commits) 並了解專案結構。
- **議題與 PR 自動化**：建立、更新和管理議題與拉取請求。讓 AI 協助分類錯誤、審查程式碼變更並維護專案看板。
- **CI/CD 與工作流智慧**：監控 GitHub Actions 工作流執行、分析構建失敗原因、管理發布版本，並深入了解您的開發流水線。
- **程式碼分析**：檢查安全發現、審查 Dependabot 警報、了解程式碼模式，並獲得對程式碼庫的全面洞察。
- **團隊協作**：存取討論、管理通知、分析團隊活動並簡化團隊流程。

專為想要將 AI 工具連接到 GitHub 上下文和功能的開發者打造，從簡單的自然語言查詢到複雜的多步代理工作流程皆可適用。

---

## 遠端 GitHub MCP 伺服器

[![在 VS Code 中安裝](https://img.shields.io/badge/VS_Code-Install_Server-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=github&config=%7B%22type%22%3A%20%22http%22%2C%22url%22%3A%20%22https%3A%2F%2Fapi.githubcopilot.com%2Fmcp%2F%22%7D) [![在 VS Code Insiders 中安裝](https://img.shields.io/badge/VS_Code_Insiders-Install_Server-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=github&config=%7B%22type%22%3A%20%22http%22%2C%22url%22%3A%20%22https%3A%2F%2Fapi.githubcopilot.com%2Fmcp%2F%22%7D&quality=insiders)

遠端 GitHub MCP 伺服器由 GitHub 託管，提供最簡單的啟動方法。如果您的 MCP 主機不支援遠端 MCP 伺服器，別擔心！您可以使用 [本機版本的 GitHub MCP 伺服器](https://github.com/github/github-mcp-server?tab=readme-ov-file#local-github-mcp-server) 代替。

### 前提條件

1. 支援遠端伺服器的相容 MCP 主機 (VS Code 1.101+、Claude Desktop、Cursor、Windsurf 等)。
2. 已啟用任何適用的 [策略 (Policies)](./docs/policies-and-governance_zh_TW.md)。

### 在 VS Code 中安裝

如需快速安裝，請使用上方的一鍵安裝按鈕。完成該流程後，切換代理模式 (Agent mode，位於 Copilot Chat 文字輸入框旁)，伺服器將啟動。請確保您使用的是 [VS Code 1.101](https://code.visualstudio.com/updates/v1_101) 或 [更新版本](https://code.visualstudio.com/updates) 以獲得遠端 MCP 和 OAuth 支援。

或者，若要手動配置 VS Code，請從以下範例中選擇適當的 JSON 區塊並將其新增到您的主機配置中：

<table>
<tr><th>使用 OAuth</th><th>使用 GitHub PAT</th></tr>
<tr><th align=left colspan=2>VS Code (版本 1.101 或更高)</th></tr>
<tr valign=top>
<td>

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

</td>
<td>

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${input:github_mcp_pat}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "github_mcp_pat",
      "description": "GitHub 個人存取權杖 (Personal Access Token)",
      "password": true
    }
  ]
}
```

</td>
</tr>
</table>

### 在其他 MCP 主機中安裝

- **[Copilot CLI](./docs/installation-guides/install-copilot-cli_zh_TW.md)** - GitHub Copilot CLI 安裝指南
- **[其他 IDE 中的 GitHub Copilot](./docs/installation-guides/install-other-copilot-ides_zh_TW.md)** - JetBrains、Visual Studio、Eclipse 和 Xcode 的 GitHub Copilot 安裝
- **[Claude 應用程式](./docs/installation-guides/install-claude_zh_TW.md)** - Claude Desktop 和 Claude Code CLI 安裝指南
- **[Codex](./docs/installation-guides/install-codex_zh_TW.md)** - OpenAI Codex 安裝指南
- **[Cursor](./docs/installation-guides/install-cursor_zh_TW.md)** - Cursor IDE 安裝指南
- **[Windsurf](./docs/installation-guides/install-windsurf_zh_TW.md)** - Windsurf IDE 安裝指南
- **[Rovo Dev CLI](./docs/installation-guides/install-rovo-dev-cli_zh_TW.md)** - Rovo Dev CLI 安裝指南

> **注意：** 每個 MCP 主機應用程式都需要配置 GitHub App 或 OAuth App，以支援透過 OAuth 進行遠端存取。任何支援遠端 MCP 伺服器的主機應用程式都應支援使用 PAT 身份驗證的遠端 GitHub 伺服器。配置詳細資訊和支援程度因主機而異。請務必參考主機應用程式的說明文件以獲取更多資訊。

### 配置

#### 工具集配置

有關遠端伺服器配置、工具集、標頭和進階用法的完整詳細資訊，請參閱 [遠端伺服器文件](./docs/remote-server_zh_TW.md)。該文件提供了在 VS Code 和其他 MCP 主機中連接、自定義和安裝遠端 GitHub MCP 伺服器的全面指令和範例。

若未指定工具集，將使用 [預設工具集](#預設工具集)。

#### 體驗版模式 (Insiders Mode)

> **提早體驗新功能！** 遠端伺服器提供體驗版，可提早使用新功能和實驗性工具。

<table>
<tr><th>使用 URL 路徑</th><th>使用標頭</th></tr>
<tr valign=top>
<td>

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/insiders"
    }
  }
}
```

</td>
<td>

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "X-MCP-Insiders": "true"
      }
    }
  }
}
```

</td>
</tr>
</table>

參見 [遠端伺服器文件](./docs/remote-server_zh_TW.md#insiders-mode) 以了解更多詳細資訊和範例，以及 [體驗版功能](./docs/insiders-features_zh_TW.md) 以獲取可用功能的完整清單。

#### GitHub Enterprise

##### 具有資料落地的 GitHub Enterprise Cloud (ghe.com)

GitHub Enterprise Cloud 也可以使用遠端伺服器。

使用 GitHub PAT 權杖的 `https://octocorp.ghe.com` 範例：

```
{
    ...
    "github-octocorp": {
      "type": "http",
      "url": "https://copilot-api.octocorp.ghe.com/mcp",
      "headers": {
        "Authorization": "Bearer ${input:github_mcp_pat}"
      }
    },
    ...
}
```

> **注意：** 在 VS Code 和 GitHub Copilot 中搭配使用 OAuth 與 GitHub Enterprise 時，您還需要配置 VS Code 設定以指向您的 GitHub Enterprise 實例 - 請參閱 [從 VS Code 進行身份驗證](https://docs.github.com/en/enterprise-cloud@latest/copilot/how-tos/configure-personal-settings/authenticate-to-ghecom)

##### GitHub Enterprise Server

GitHub Enterprise Server 不支援遠端伺服器代管。請參考本機伺服器配置中的 [GitHub Enterprise Server 和具有資料落地的 Enterprise Cloud (ghe.com)](#github-enterprise-server-和具有資料落地的-enterprise-cloud-ghecom)。

---

## 本機 GitHub MCP 伺服器

[![在 VS Code 中使用 Docker 安裝](https://img.shields.io/badge/VS_Code-Install_Server-0098FF?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=github&inputs=%5B%7B%22id%22%3A%22github_token%22%2C%22type%22%3A%22promptString%22%2C%22description%22%3A%22GitHub%20Personal%20Access%20Token%22%2C%22password%22%3Atrue%7D%5D&config=%7B%22command%22%3A%22docker%22%2C%22args%22%3A%5B%22run%22%2C%22-i%22%2C%22--rm%22%2C%22-e%22%2C%22GITHUB_PERSONAL_ACCESS_TOKEN%22%2C%22ghcr.io%2Fgithub%2Fgithub-mcp-server%22%5D%2C%22env%22%3A%7B%22GITHUB_PERSONAL_ACCESS_TOKEN%22%3A%22%24%7Binput%3Agithub_token%7D%22%7D%7D) [![在 VS Code Insiders 中使用 Docker 安裝](https://img.shields.io/badge/VS_Code_Insiders-Install_Server-24bfa5?style=flat-square&logo=visualstudiocode&logoColor=white)](https://insiders.vscode.dev/redirect/mcp/install?name=github&inputs=%5B%7B%22id%22%3A%22github_token%22%2C%22type%22%3A%22promptString%22%2C%22description%22%3A%22GitHub%20Personal%20Access%20Token%22%2C%22password%22%3Atrue%7D%5D&config=%7B%22command%22%3A%22docker%22%2C%22args%22%3A%5B%22run%22%2C%22-i%22%2C%22--rm%22%2C%22-e%22%2C%22GITHUB_PERSONAL_ACCESS_TOKEN%22%2C%22ghcr.io%2Fgithub%2Fgithub-mcp-server%22%5D%2C%22env%22%3A%7B%22GITHUB_PERSONAL_ACCESS_TOKEN%22%3A%22%24%7Binput%3Agithub_token%7D%22%7D%7D&quality=insiders)

### 前提條件

1. 若要在容器中執行伺服器，您需要安裝 [Docker](https://www.docker.com/)。
2. Docker 安裝後，還需要確保 Docker 正在執行。Docker 映像檔可在 `ghcr.io/github/github-mcp-server` 取得。該映像檔是公開的；如果拉取時出錯，可能是權杖已過期，需要執行 `docker logout ghcr.io`。
3. 最後，您需要 [建立 GitHub 個人存取權杖 (Personal Access Token)](https://github.com/settings/personal-access-tokens/new)。
MCP 伺服器可以使用許多 GitHub API，因此請啟用您願意授權給 AI 工具的權限 (如需了解更多關於存取權杖的資訊，請查看 [說明文件](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens))。

<details><summary><b>安全地處理 PAT</b></summary>

### 環境變數 (推薦)

為了確保您的 GitHub PAT 安全且能在不同的 MCP 主機之間重複使用：

1. **將您的 PAT 儲存在環境變數中**

   ```bash
   export GITHUB_PAT=您的權杖
   ```

   或者建立一個 `.env` 檔案：

   ```env
   GITHUB_PAT=您的權杖
   ```

2. **保護您的 `.env` 檔案**

   ```bash
   # 新增到 .gitignore 以防止意外提交
   echo ".env" >> .gitignore
   ```

3. **在配置中引用權杖**

   ```bash
   # CLI 用法
   claude mcp update github -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PAT

   # 在配置檔案中 (若支援)
   "env": {
     "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
   }
   ```

> **注意**：環境變數支援因主機應用程式和 IDE 而異。某些應用程式 (如 Windsurf) 要求在配置檔案中寫死權杖。

### 權杖安全最佳實踐

- **最小權限範圍**：僅授予必要的權限
  - `repo` - 儲存庫操作
  - `read:packages` - Docker 映像檔存取
  - `read:org` - 組織團隊存取
- **分開權杖**：為不同的專案/環境使用不同的 PAT
- **定期更換**：定期更新權杖
- **切勿提交**：將權杖排除在版本控制之外
- **檔案權限**：限制對包含權杖的配置檔案的存取

  ```bash
  chmod 600 ~/.your-app/config.json
  ```

</details>

### GitHub Enterprise Server 和具有資料落地的 Enterprise Cloud (ghe.com)

旗標 `--gh-host` 和環境變數 `GITHUB_HOST` 可用於設定
GitHub Enterprise Server 或具有資料落地的 GitHub Enterprise Cloud 的主機名稱。

- 對於 GitHub Enterprise Server，請在主機名稱前加上 `https://` URI 方案，否則預設為 `http://`，而 GitHub Enterprise Server 不支援此方案。
- 對於具有資料落地的 GitHub Enterprise Cloud，請使用 `https://您的子網域.ghe.com` 作為主機名稱。

``` json
"github": {
    "command": "docker",
    "args": [
    "run",
    "-i",
    "--rm",
    "-e",
    "GITHUB_PERSONAL_ACCESS_TOKEN",
    "-e",
    "GITHUB_HOST",
    "ghcr.io/github/github-mcp-server"
    ],
    "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}",
        "GITHUB_HOST": "https://<您的 GHES 或 ghe.com 網域名稱>"
    }
}
```

## 安裝

### 在 VS Code 的 GitHub Copilot 中安裝

如需快速安裝，請使用上方的一鍵安裝按鈕。完成該流程後，切換代理模式 (位於 Copilot Chat 文字輸入框旁)，伺服器將啟動。

更多關於在 VS Code 中使用 MCP 伺服器工具的資訊，請參閱 [代理模式文件](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)。

在其他 IDE (JetBrains、Visual Studio、Eclipse 等) 的 GitHub Copilot 中安裝

將以下 JSON 區塊新增到您 IDE 的 MCP 設定中。

```json
{
  "mcp": {
    "inputs": [
      {
        "type": "promptString",
        "id": "github_token",
        "description": "GitHub 個人存取權杖",
        "password": true
      }
    ],
    "servers": {
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
          "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
        }
      }
    }
  }
}
```

(選填) 您可以將類似的範例 (即不含 mcp 鍵) 新增到工作區中名為 `.vscode/mcp.json` 的檔案中。這將允許您與接受相同格式的其他主機應用程式共享配置。

<details>
<summary><b>不含 MCP 鍵的 JSON 區塊範例</b></summary>
<br>

```json
{
  "inputs": [
    {
      "type": "promptString",
      "id": "github_token",
      "description": "GitHub 個人存取權杖",
      "password": true
    }
  ],
  "servers": {
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
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_token}"
      }
    }
  }
}
```

</details>

### 在其他 MCP 主機中安裝

對於其他 MCP 主機應用程式，請參閱我們的安裝指南：

- **[Copilot CLI](./docs/installation-guides/install-copilot-cli_zh_TW.md)** - GitHub Copilot CLI 安裝指南
- **[其他 IDE 中的 GitHub Copilot](./docs/installation-guides/install-other-copilot-ides_zh_TW.md)** - JetBrains、Visual Studio、Eclipse 和 Xcode 的 GitHub Copilot 安裝
- **[Claude Code & Claude Desktop](./docs/installation-guides/install-claude_zh_TW.md)** - Claude Code 和 Claude Desktop 安裝指南
- **[Cursor](./docs/installation-guides/install-cursor_zh_TW.md)** - Cursor IDE 安裝指南
- **[Google Gemini CLI](./docs/installation-guides/install-gemini-cli_zh_TW.md)** - Google Gemini CLI 安裝指南
- **[Windsurf](./docs/installation-guides/install-windsurf_zh_TW.md)** - Windsurf IDE 安裝指南

如需所有安裝選項的完整概覽，請參閱我們的 **[安裝指南索引](./docs/installation-guides/README_zh_TW.md)**。

> **注意：** 任何支援本機 MCP 伺服器的主機應用程式都應該能夠存取本機 GitHub MCP 伺服器。然而，整合的具體配置過程、語法和穩定性將因主機應用程式而異。雖然許多應用程式可能遵循與上述範例類似的格式，但這並不能保證。請參考您的主機應用程式說明文件以獲取正確的 MCP 配置語法和設定過程。

### 從原始碼構建

如果您沒有 Docker，可以使用 `go build` 在
`cmd/github-mcp-server` 目錄中構建二進位檔案，並在設定 `GITHUB_PERSONAL_ACCESS_TOKEN` 環境變數為您的權杖的情況下使用 `github-mcp-server stdio` 命令。若要指定構建的輸出位置，請使用 `-o` 旗標。您應該將伺服器配置為使用構建的可執行文件作為其 `command`。例如：

```JSON
{
  "mcp": {
    "servers": {
      "github": {
        "command": "/path/to/github-mcp-server",
        "args": ["stdio"],
        "env": {
          "GITHUB_PERSONAL_ACCESS_TOKEN": "<您的權杖>"
        }
      }
    }
  }
}
```

### CLI 公用程式

`github-mcp-server` 二進位檔案包含一些有助於調試和探索伺服器的 CLI 子命令。

- `github-mcp-server tool-search "<查詢字串>"` 依名稱、描述和輸入參數名稱搜尋工具。使用 `--max-results` 返回更多相符結果。
範例 (彩色輸出需要 TTY；在 Docker 中執行時使用 `docker run -t` (或 `-it`))：
```bash
docker run -it --rm ghcr.io/github/github-mcp-server tool-search "issue" --max-results 5
github-mcp-server tool-search "issue" --max-results 5
```

## 工具配置

GitHub MCP 伺服器支援透過 `--toolsets` 旗標啟用或停用特定的功能群組。這允許您控制 AI 工具可以使用哪些 GitHub API 功能。僅啟用您需要的工具集可以幫助 LLM 選擇工具並減少上下文大小。

_工具集不限於工具。適用的 MCP 資源 (Resources) 和提示 (Prompts) 也包含在內。_

未指定工具集時，將使用 [預設工具集](#預設工具集)。

> **正在尋找範例？** 請參閱 [伺服器配置指南](./docs/server-configuration_zh_TW.md) 以獲取常見方案，例如最小化設定、唯讀模式以及將工具與工具集組合。

#### 指定工具集

若要指定您希望 LLM 使用的工具集，您可以透過兩種方式傳遞允許清單：

1. **使用命令列參數**：

   ```bash
   github-mcp-server --toolsets repos,issues,pull_requests,actions,code_security
   ```

2. **使用環境變數**：

   ```bash
   GITHUB_TOOLSETS="repos,issues,pull_requests,actions,code_security" ./github-mcp-server
   ```

如果兩者都提供，環境變數 `GITHUB_TOOLSETS` 的優先級高於命令列參數。

#### 指定個別工具

您也可以使用 `--tools` 旗標配置特定工具。工具可以獨立使用，也可以與工具集和動態工具集探索相結合，以進行精細控制。

1. **使用命令列參數**：

   ```bash
   github-mcp-server --tools get_file_contents,issue_read,create_pull_request
   ```

2. **使用環境變數**：

   ```bash
   GITHUB_TOOLS="get_file_contents,issue_read,create_pull_request" ./github-mcp-server
   ```

3. **與工具集組合** (累加)：

   ```bash
   github-mcp-server --toolsets repos,issues --tools get_gist
   ```

   這將註冊 `repos` 和 `issues` 工具集中的所有工具，再加上 `get_gist`。

4. **與動態工具集組合** (累加)：

   ```bash
   github-mcp-server --tools get_file_contents --dynamic-toolsets
   ```

   這將註冊 `get_file_contents` 加上動態工具集工具 (`enable_toolset`, `list_available_toolsets`, `get_toolset_tools`)。

**重要注意事項：**

- 工具、工具集和動態工具集都可以一起使用
- 唯讀模式優先：如果設定了 `--read-only`，即使透過 `--tools` 明確要求，也會跳過寫入工具
- 工具名稱必須完全匹配 (例如：`get_file_contents`，而不是 `getFileContents`)。無效的工具名稱將導致伺服器在啟動時失敗並顯示錯誤訊息
- 當工具重新命名時，舊名稱會作為別名保留以實現向後相容性。詳見 [棄用的工具別名](./docs/deprecated-tool-aliases_zh_TW.md)。

### 在 Docker 中使用工具集

使用 Docker 時，您可以將工具集作為環境變數傳遞：

```bash
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_TOOLSETS="repos,issues,pull_requests,actions,code_security" \
  ghcr.io/github/github-mcp-server
```

### 在 Docker 中使用工具

使用 Docker 時，您可以將特定工具作為環境變數傳遞。您也可以將工具與工具集組合：

```bash
# 僅限工具
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_TOOLS="get_file_contents,issue_read,create_pull_request" \
  ghcr.io/github/github-mcp-server

# 工具與工具集組合 (累加)
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_TOOLSETS="repos,issues" \
  -e GITHUB_TOOLS="get_gist" \
  ghcr.io/github/github-mcp-server
```

### 特殊工具集

#### "all" 工具集

可以提供特殊工具集 `all` 來啟用所有可用的工具集，無論任何其他配置為何：

```bash
./github-mcp-server --toolsets all
```

或者使用環境變數：

```bash
GITHUB_TOOLSETS="all" ./github-mcp-server
```

#### "default" 工具集

預設工具集 `default` 是在未指定工具集時傳遞給伺服器的配置。

預設配置為：

- context
- repos
- issues
- pull_requests
- users

若要保留預設配置並新增額外的工具集：

```bash
GITHUB_TOOLSETS="default,stargazers" ./github-mcp-server
```

### 體驗版模式 (Insiders Mode)

本機 GitHub MCP 伺服器提供體驗版，可提早使用新功能和實驗性工具。

1. **使用命令列參數**：

   ```bash
   ./github-mcp-server --insiders
   ```

2. **使用環境變數**：

   ```bash
   GITHUB_INSIDERS=true ./github-mcp-server
   ```

使用 Docker 時：

```bash
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_INSIDERS=true \
  ghcr.io/github/github-mcp-server
```

### 可用的工具集

提供以下工具集：

<!-- START AUTOMATED TOOLSETS -->
|     | 工具集                 | 描述                                                   |
| --- | ----------------------- | ------------------------------------------------------------- |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/person-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/person-light.png"><img src="pkg/octicons/icons/person-light.png" width="20" height="20" alt="person"></picture> | `context`               | **強烈建議**：提供關於當前使用者和您正在操作的 GitHub 上下文資訊的工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/workflow-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/workflow-light.png"><img src="pkg/octicons/icons/workflow-light.png" width="20" height="20" alt="workflow"></picture> | `actions` | GitHub Actions 工作流和 CI/CD 操作 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/codescan-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/codescan-light.png"><img src="pkg/octicons/icons/codescan-light.png" width="20" height="20" alt="codescan"></picture> | `code_security` | 程式碼安全相關工具，如 GitHub 程式碼掃描 (Code Scanning) |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/copilot-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/copilot-light.png"><img src="pkg/octicons/icons/copilot-light.png" width="20" height="20" alt="copilot"></picture> | `copilot` | Copilot 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/dependabot-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/dependabot-light.png"><img src="pkg/octicons/icons/dependabot-light.png" width="20" height="20" alt="dependabot"></picture> | `dependabot` | Dependabot 工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/comment-discussion-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/comment-discussion-light.png"><img src="pkg/octicons/icons/comment-discussion-light.png" width="20" height="20" alt="comment-discussion"></picture> | `discussions` | GitHub 討論 (Discussions) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/logo-gist-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/logo-gist-light.png"><img src="pkg/octicons/icons/logo-gist-light.png" width="20" height="20" alt="logo-gist"></picture> | `gists` | GitHub Gist 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/git-branch-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/git-branch-light.png"><img src="pkg/octicons/icons/git-branch-light.png" width="20" height="20" alt="git-branch"></picture> | `git` | 用於低階 Git 操作的 GitHub Git API 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/issue-opened-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/issue-opened-light.png"><img src="pkg/octicons/icons/issue-opened-light.png" width="20" height="20" alt="issue-opened"></picture> | `issues` | GitHub 議題 (Issues) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/tag-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/tag-light.png"><img src="pkg/octicons/icons/tag-light.png" width="20" height="20" alt="tag"></picture> | `labels` | GitHub 標籤 (Labels) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/bell-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/bell-light.png"><img src="pkg/octicons/icons/bell-light.png" width="20" height="20" alt="bell"></picture> | `notifications` | GitHub 通知 (Notifications) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/organization-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/organization-light.png"><img src="pkg/octicons/icons/organization-light.png" width="20" height="20" alt="organization"></picture> | `orgs` | GitHub 組織 (Organizations) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/project-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/project-light.png"><img src="pkg/octicons/icons/project-light.png" width="20" height="20" alt="project"></picture> | `projects` | GitHub 專案 (Projects) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/git-pull-request-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/git-pull-request-light.png"><img src="pkg/octicons/icons/git-pull-request-light.png" width="20" height="20" alt="git-pull-request"></picture> | `pull_requests` | GitHub 拉取請求 (Pull Request) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/repo-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/repo-light.png"><img src="pkg/octicons/icons/repo-light.png" width="20" height="20" alt="repo"></picture> | `repos` | GitHub 儲存庫 (Repository) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/shield-lock-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/shield-lock-light.png"><img src="pkg/octicons/icons/shield-lock-light.png" width="20" height="20" alt="shield-lock"></picture> | `secret_protection` | 密鑰保護相關工具，如 GitHub 密鑰掃描 (Secret Scanning) |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/shield-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/shield-light.png"><img src="pkg/octicons/icons/shield-light.png" width="20" height="20" alt="shield"></picture> | `security_advisories` | 安全通報 (Security Advisories) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/star-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/star-light.png"><img src="pkg/octicons/icons/star-light.png" width="20" height="20" alt="star"></picture> | `stargazers` | GitHub 星標者 (Stargazers) 相關工具 |
| <picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/people-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/people-light.png"><img src="pkg/octicons/icons/people-light.png" width="20" height="20" alt="people"></picture> | `users` | GitHub 使用者 (User) 相關工具 |
<!-- END AUTOMATED TOOLSETS -->

### 遠端 GitHub MCP 伺服器中的額外工具集

| 工具集                 | 描述                                                   |
| ----------------------- | ------------------------------------------------------------- |
| `copilot` | Copilot 相關工具 (例如 Copilot Coding Agent) |
| `copilot_spaces` | Copilot Spaces 相關工具 |
| `github_support_docs_search` | 搜尋文件以回答 GitHub 產品和支援問題 |

## 工具 (Tools)

*(註：此部分工具描述眾多，僅列出主要類別，詳細參數請參閱英文版或原始碼)*

<!-- START AUTOMATED TOOLS -->
<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/workflow-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/workflow-light.png"><img src="pkg/octicons/icons/workflow-light.png" width="20" height="20" alt="workflow"></picture> Actions</summary>

- **actions_get** - 獲取 GitHub Actions 資源詳情 (工作流、執行次數、作業和成品)
- **actions_list** - 列出儲存庫中的 GitHub Actions 工作流
- **actions_run_trigger** - 觸發 GitHub Actions 工作流操作
- **get_job_logs** - 獲取 GitHub Actions 工作流作業日誌

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/codescan-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/codescan-light.png"><img src="pkg/octicons/icons/codescan-light.png" width="20" height="20" alt="codescan"></picture> Code Security</summary>

- **get_code_scanning_alert** - 獲取程式碼掃描警報
- **list_code_scanning_alerts** - 列出程式碼掃描警報

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/person-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/person-light.png"><img src="pkg/octicons/icons/person-light.png" width="20" height="20" alt="person"></picture> Context</summary>

- **get_me** - 獲取我的使用者個人資料
- **get_team_members** - 獲取團隊成員
- **get_teams** - 獲取團隊清單

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/copilot-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/copilot-light.png"><img src="pkg/octicons/icons/copilot-light.png" width="20" height="20" alt="copilot"></picture> Copilot</summary>

- **assign_copilot_to_issue** - 將 Copilot 指派給議題
- **request_copilot_review** - 請求 Copilot 審查

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/dependabot-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/dependabot-light.png"><img src="pkg/octicons/icons/dependabot-light.png" width="20" height="20" alt="dependabot"></picture> Dependabot</summary>

- **get_dependabot_alert** - 獲取 Dependabot 警報
- **list_dependabot_alerts** - 列出 Dependabot 警報

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/comment-discussion-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/comment-discussion-light.png"><img src="pkg/octicons/icons/comment-discussion-light.png" width="20" height="20" alt="comment-discussion"></picture> Discussions</summary>

- **get_discussion** - 獲取討論內容
- **get_discussion_comments** - 獲取討論留言
- **list_discussion_categories** - 列出討論分類
- **list_discussions** - 列出討論清單

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/logo-gist-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/logo-gist-light.png"><img src="pkg/octicons/icons/logo-gist-light.png" width="20" height="20" alt="logo-gist"></picture> Gists</summary>

- **create_gist** - 建立 Gist
- **get_gist** - 獲取 Gist 內容
- **list_gists** - 列出 Gist 清單
- **update_gist** - 更新 Gist

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/git-branch-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/git-branch-light.png"><img src="pkg/octicons/icons/git-branch-light.png" width="20" height="20" alt="git-branch"></picture> Git</summary>

- **get_repository_tree** - 獲取儲存庫樹狀結構

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/issue-opened-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/issue-opened-light.png"><img src="pkg/octicons/icons/issue-opened-light.png" width="20" height="20" alt="issue-opened"></picture> Issues</summary>

- **add_issue_comment** - 新增議題留言
- **get_label** - 獲取特定標籤
- **issue_read** - 讀取議題詳情
- **issue_write** - 建立或更新議題
- **list_issue_types** - 列出可用的議題類型
- **list_issues** - 列出議題清單
- **search_issues** - 搜尋議題
- **sub_issue_write** - 變更子議題

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/tag-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/tag-light.png"><img src="pkg/octicons/icons/tag-light.png" width="20" height="20" alt="tag"></picture> Labels</summary>

- **get_label** - 獲取特定標籤
- **label_write** - 標籤寫入操作
- **list_label** - 列出儲存庫標籤

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/bell-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/bell-light.png"><img src="pkg/octicons/icons/bell-light.png" width="20" height="20" alt="bell"></picture> Notifications</summary>

- **dismiss_notification** - 關閉通知
- **get_notification_details** - 獲取通知詳情
- **list_notifications** - 列出通知清單
- **manage_notification_subscription** - 管理通知訂閱
- **manage_repository_notification_subscription** - 管理儲存庫通知訂閱
- **mark_all_notifications_read** - 將所有通知標記為已讀

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/organization-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/organization-light.png"><img src="pkg/octicons/icons/organization-light.png" width="20" height="20" alt="organization"></picture> Organizations</summary>

- **search_orgs** - 搜尋組織

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/project-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/project-light.png"><img src="pkg/octicons/icons/project-light.png" width="20" height="20" alt="project"></picture> Projects</summary>

- **projects_get** - 獲取 GitHub Projects 資源詳情
- **projects_list** - 列出 GitHub Projects 資源
- **projects_write** - 修改 GitHub Project 項目

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/git-pull-request-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/git-pull-request-light.png"><img src="pkg/octicons/icons/git-pull-request-light.png" width="20" height="20" alt="git-pull-request"></picture> Pull Requests</summary>

- **add_comment_to_pending_review** - 向待處理的 PR 審查新增留言
- **add_reply_to_pull_request_comment** - 回覆 PR 留言
- **create_pull_request** - 開啟新的拉取請求
- **list_pull_requests** - 列出拉取請求
- **merge_pull_request** - 合併拉取請求
- **pull_request_read** - 獲取單個 PR 的詳情
- **pull_request_review_write** - PR 審查寫入操作
- **search_pull_requests** - 搜尋拉取請求
- **update_pull_request** - 編輯拉取請求
- **update_pull_request_branch** - 更新 PR 分支

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/repo-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/repo-light.png"><img src="pkg/octicons/icons/repo-light.png" width="20" height="20" alt="repo"></picture> Repositories</summary>

- **create_branch** - 建立分支
- **create_or_update_file** - 建立或更新檔案
- **create_repository** - 建立儲存庫
- **delete_file** - 刪除檔案
- **fork_repository** - 分叉 (Fork) 儲存庫
- **get_commit** - 獲取提交詳情
- **get_file_contents** - 獲取檔案或目錄內容
- **get_latest_release** - 獲取最新發布版本
- **get_release_by_tag** - 依標籤獲取發布版本
- **get_tag** - 獲取標籤詳情
- **list_branches** - 列出分支
- **list_commits** - 列出提交
- **list_releases** - 列出發布版本
- **list_tags** - 列出標籤
- **push_files** - 推送檔案到儲存庫
- **search_code** - 搜尋程式碼
- **search_repositories** - 搜尋儲存庫

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/shield-lock-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/shield-lock-light.png"><img src="pkg/octicons/icons/shield-lock-light.png" width="20" height="20" alt="shield-lock"></picture> Secret Protection</summary>

- **get_secret_scanning_alert** - 獲取密鑰掃描警報
- **list_secret_scanning_alerts** - 列出密鑰掃描警報

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/shield-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/shield-light.png"><img src="pkg/octicons/icons/shield-light.png" width="20" height="20" alt="shield"></picture> Security Advisories</summary>

- **get_global_security_advisory** - 獲取全域安全通報
- **list_global_security_advisories** - 列出全域安全通報
- **list_org_repository_security_advisories** - 列出組織儲存庫安全通報
- **list_repository_security_advisories** - 列出儲存庫安全通報

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/star-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/star-light.png"><img src="pkg/octicons/icons/star-light.png" width="20" height="20" alt="star"></picture> Stargazers</summary>

- **list_starred_repositories** - 列出星標儲存庫
- **star_repository** - 給儲存庫加星
- **unstar_repository** - 取消儲存庫星標

</details>

<details>

<summary><picture><source media="(prefers-color-scheme: dark)" srcset="pkg/octicons/icons/people-dark.png"><source media="(prefers-color-scheme: light)" srcset="pkg/octicons/icons/people-light.png"><img src="pkg/octicons/icons/people-light.png" width="20" height="20" alt="people"></picture> Users</summary>

- **search_users** - 搜尋使用者

</details>
<!-- END AUTOMATED TOOLS -->

### 遠端 GitHub MCP 伺服器中的額外工具

<details>

<summary>Copilot</summary>

- **create_pull_request_with_copilot** - 使用 GitHub Copilot 編碼代理執行任務

</details>

<details>

<summary>Copilot Spaces</summary>

- **get_copilot_space** - 獲取 Copilot Space
- **list_copilot_spaces** - 列出 Copilot Spaces

</details>

<details>

<summary>GitHub 支援文件搜尋</summary>

- **github_support_docs_search** - 檢索相關文件以回答 GitHub 產品和支援問題。

</details>

## 動態工具探索

**注意**：此功能目前處於 Beta 階段，且在遠端 GitHub MCP 伺服器中不可用。請進行測試並在遇到任何問題時告知我們。

您可以開啟動態工具集探索，而不是一開始就啟用所有工具。動態工具集允許 MCP 主機根據使用者提示列出並啟用工具集。這有助於避免模型因可用工具數量過多而感到困惑。

### 使用動態工具探索

使用二進位檔案時，您可以傳遞 `--dynamic-toolsets` 旗標。

```bash
./github-mcp-server --dynamic-toolsets
```

使用 Docker 時，您可以將工具集作為環境變數傳遞：

```bash
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_DYNAMIC_TOOLSETS=1 \
  ghcr.io/github/github-mcp-server
```

## 唯讀模式

若要以唯讀模式執行伺服器，您可以使用 `--read-only` 旗標。這將僅提供唯讀工具，防止對儲存庫、議題、拉取請求等進行任何修改。

```bash
./github-mcp-server --read-only
```

使用 Docker 時，您可以將唯讀模式作為環境變數傳遞：

```bash
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_READ_ONLY=1 \
  ghcr.io/github/github-mcp-server
```

## 鎖定模式 (Lockdown Mode)

鎖定模式限制伺服器從公共儲存庫呈現的內容。啟用後，伺服器會檢查每個項目的作者是否具有對該儲存庫的推送 (Push) 權限。私有儲存庫不受影響，協作者保留對其自身內容的完整存取權。

```bash
./github-mcp-server --lockdown-mode
```

使用 Docker 執行時，設定對應的環境變數：

```bash
docker run -i --rm \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=<您的權杖> \
  -e GITHUB_LOCKDOWN_MODE=1 \
  ghcr.io/github/github-mcp-server
```

鎖定模式的行為取決於所調用的工具。詳情請參閱英文版文件。

## i18n / 覆蓋描述

可以透過在與二進位檔案相同的目錄中建立 `github-mcp-server-config.json` 檔案來覆蓋工具的描述。詳情請參閱英文版文件。

## 程式庫用法

此模組導出的 Go API 目前應被視為不穩定的，並且可能會發生重大變更。

## 授權條款

本專案根據 MIT 開源授權條款授權。完整條款請參閱 [MIT](./LICENSE)。
