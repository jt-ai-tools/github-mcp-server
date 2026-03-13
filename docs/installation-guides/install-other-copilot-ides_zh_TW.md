# 在 Copilot IDE 中安裝 GitHub MCP Server

GitHub Copilot 在不同 IDE 中安裝 GitHub MCP Server 的快速設定指南。有關 VS Code 的說明，請參閱 [README 中的 VS Code 安裝指南](/README_zh_TW.md#installation-in-vs-code)

### 需求：
- **GitHub Copilot 授權**：任何 Copilot 方案 (Free, Pro, Pro+, Business, Enterprise) 即可存取 Copilot
- **GitHub 帳戶**：個人 GitHub 帳戶 (組織/企業成員資格為選用) 即可存取 GitHub MCP Server
- **Copilot 策略中的 MCP 伺服器**：指派 Copilot 席位的組織必須為 VS Code 中的 Copilot 和 Copilot Coding Agent 啟用此策略，才能進行所有 MCP 存取 – 所有其他 Copilot IDE 將在未來幾個月內遷移到此策略
- **編輯器預覽策略**：指派 Copilot 席位的組織必須在遠端 GitHub MCP Server 處於公開預覽期間啟用此策略以進行 OAuth 存取

> **注意：** 所有 Copilot IDE 現在都支援遠端 GitHub MCP Server。VS Code 提供 OAuth 身分驗證，而 Visual Studio、JetBrains IDE、Xcode 和 Eclipse 目前使用 PAT 身分驗證，OAuth 支援即將推出。

## Visual Studio

需要 Visual Studio 2022 版本 17.14.9 或更新版本。

### 遠端伺服器 (推薦)

遠端 GitHub MCP Server 由 GitHub 託管，提供自動更新且無需本地設定。

#### 配置
1. 在您的解決方案或 %USERPROFILE% 目錄中建立一個 `.mcp.json` 檔案。
2. 新增此配置：
```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```
3. 儲存檔案。等待 CodeLens 更新以提供身分驗證新伺服器的方法，啟用該功能並選擇要進行身分驗證的 GitHub 帳戶。
4. 在 GitHub Copilot Chat 視窗中，切換到 Agent 模式。
5. 在 Chat 視窗中啟動工具選擇器，並啟用 "github" MCP 伺服器中的一或多個工具。

### 本地伺服器

適用於偏好在本地執行 GitHub MCP Server 的使用者。需要安裝並執行 Docker。

#### 配置
1. 在您的解決方案或 %USERPROFILE% 目錄中建立一個 `.mcp.json` 檔案。
2. 新增此配置：
```json
{
  "inputs": [
    {
      "id": "github_pat",
      "description": "GitHub personal access token",
      "type": "promptString",
      "password": true
    }
  ],
  "servers": {
    "github": {
      "type": "stdio",
      "command": "docker",
      "args": [
        "run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${input:github_pat}"
      }
    }
  }
}
```
3. 儲存檔案。等待 CodeLens 更新以提供輸入使用者資訊的方法，啟用該功能並貼上您從 https://github.com/settings/tokens 產生的 PAT。
4. 在 GitHub Copilot Chat 視窗中，切換到 Agent 模式。
5. 在 Chat 視窗中啟動工具選擇器，並啟用 "github" MCP 伺服器中的一或多個工具。

**文件：** [Visual Studio MCP 指南](https://learn.microsoft.com/visualstudio/ide/mcp-servers)

---

## JetBrains IDEs

IntelliJ IDEA、PyCharm、WebStorm 和其他 JetBrains IDE 現已提供 Agent 模式和 MCP 支援的公開預覽。

### 遠端伺服器 (推薦)

遠端 GitHub MCP Server 由 GitHub 託管，提供自動更新且無需本地設定。

> **注意**：JetBrains IDE 尚不支援遠端 GitHub 伺服器的 OAuth 身分驗證。您必須使用個人存取權杖 (PAT)。

#### 配置步驟
1. 安裝/更新 GitHub Copilot 外掛程式
2. 點擊 **狀態列中的 GitHub Copilot 圖示** → **Edit Settings** → **Model Context Protocol** → **Configure**
3. 新增配置：
```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "requestInit": {
        "headers": {
          "Authorization": "Bearer YOUR_GITHUB_PAT"
        }
      }
    }
  }
}
```
4. 按 `Ctrl + S` 或 `Command + S` 儲存，或關閉 `mcp.json` 檔案。配置應立即生效並重啟所有定義的 MCP 伺服器。如有需要，您可以重啟 IDE。

### 本地伺服器

適用於偏好在本地執行 GitHub MCP Server 的使用者。需要安裝並執行 Docker。

#### 配置
```json
{
  "servers": {
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

**文件：** [JetBrains Copilot 指南](https://plugins.jetbrains.com/plugin/17718-github-copilot)

---

## Xcode

Xcode 現已提供 Agent 模式和 MCP 支援的公開預覽。

### 遠端伺服器 (推薦)

遠端 GitHub MCP Server 由 GitHub 託管，提供自動更新且無需本地設定。

> **注意**：Xcode 尚不支援遠端 GitHub 伺服器的 OAuth 身分驗證。您必須使用個人存取權杖 (PAT)。

#### 配置步驟
1. 安裝/更新 [GitHub Copilot for Xcode](https://github.com/github/CopilotForXcode)
2. 開啟 **GitHub Copilot for Xcode app** → **Agent Mode** → **🛠️ Tool Picker** → **Edit Config**
3. 配置您的 MCP 伺服器：
```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "requestInit": {
        "headers": {
          "Authorization": "Bearer YOUR_GITHUB_PAT"
        }
      }
    }
  }
}
```

### 本地伺服器

適用於偏好在本地執行 GitHub MCP Server 的使用者。需要安裝並執行 Docker。

#### 配置
```json
{
  "servers": {
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

**文件：** [Xcode Copilot 指南](https://devblogs.microsoft.com/xcode/github-copilot-exploring-agent-mode-and-mcp-support-in-public-preview-for-xcode/)

---

## Eclipse

Eclipse 2024-03+ 和最新版本的 GitHub Copilot 外掛程式已提供 MCP 支援。

### 遠端伺服器 (推薦)

遠端 GitHub MCP Server 由 GitHub 託管，提供自動更新且無需本地設定。

> **注意**：Eclipse 尚不支援遠端 GitHub 伺服器的 OAuth 身分驗證。您必須使用個人存取權杖 (PAT)。

#### 配置步驟
1. 從 Eclipse Marketplace 安裝 GitHub Copilot 擴充功能
2. 點擊 **GitHub Copilot 圖示** → **Edit Preferences** → **MCP** (在 **GitHub Copilot** 下)
3. 新增 GitHub MCP Server 配置：
```json
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp/",
      "requestInit": {
        "headers": {
          "Authorization": "Bearer YOUR_GITHUB_PAT"
        }
      }
    }
  }
}
```
4. 在偏好設定對話框中點擊 "Apply and Close" 按鈕，配置將自動生效。

### 本地伺服器

適用於偏好在本地執行 GitHub MCP Server 的使用者。需要安裝並執行 Docker。

#### 配置
```json
{
  "servers": {
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

**文件：** [Eclipse Copilot 外掛程式](https://marketplace.eclipse.org/content/github-copilot)

---

## GitHub 個人存取權杖 (PAT)

有關 PAT 身分驗證，請參閱我們的 [個人存取權杖文件](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) 以獲取設定說明。

---

## 使用方式

設定完成後：
1. 完全重啟您的 IDE
2. 在 Copilot Chat 中開啟 Agent 模式
3. 嘗試：*"列出此儲存庫中最近的議題"*
4. Copilot 現在可以存取 GitHub 資料並執行儲存庫操作

---

## 疑難排解

- **連線問題**：驗證 GitHub PAT 權限和 IDE 版本相容性
- **身分驗證錯誤**：檢查您的組織是否已為 Copilot 啟用 MCP 策略
- **工具未出現**：配置變更後重啟 IDE 並檢查錯誤日誌
- **本地伺服器問題**：確保 Docker 針對 Docker 型設定正在執行
