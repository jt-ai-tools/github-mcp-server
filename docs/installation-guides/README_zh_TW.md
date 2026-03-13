# GitHub MCP 伺服器安裝指南

此目錄包含在不同主機應用程式和 IDE 中安裝 GitHub MCP 伺服器的詳細說明。請選擇適合您開發環境的指南。

## 各主機應用程式安裝指南
- **[Copilot CLI](install-copilot-cli_zh_TW.md)** - GitHub Copilot CLI 安裝指南
- **[其他 IDE 中的 GitHub Copilot](install-other-copilot-ides_zh_TW.md)** - 在 JetBrains、Visual Studio、Eclipse 和 Xcode 中搭配 GitHub Copilot 的安裝說明
- **[Antigravity](install-antigravity_zh_TW.md)** - Google Antigravity IDE 安裝說明
- **[Claude 應用程式](install-claude_zh_TW.md)** - Claude 網頁版、Claude Desktop 和 Claude Code CLI 安裝指南
- **[Cline](install-cline_zh_TW.md)** - Cline 安裝指南
- **[Cursor](install-cursor_zh_TW.md)** - Cursor IDE 安裝指南
- **[Google Gemini CLI](install-gemini-cli_zh_TW.md)** - Google Gemini CLI 安裝指南
- **[OpenAI Codex](install-codex_zh_TW.md)** - OpenAI Codex 安裝指南
- **[Roo Code](install-roo-code_zh_TW.md)** - Roo Code 安裝指南
- **[Windsurf](install-windsurf_zh_TW.md)** - Windsurf IDE 安裝指南

## 各主機應用程式支援情況

| 主機應用程式 | 本地 GitHub MCP 支援 | 遠端 GitHub MCP 支援 | 先決條件 | 難度 |
|-----------------|---------------|----------------|---------------|------------|
| Copilot CLI | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Copilot in VS Code | ✅ | ✅ 完整 (OAuth + PAT) | 本地: Docker 或 Go 編譯, GitHub PAT<br>遠端: VS Code 1.101+ | 簡單 |
| Copilot Coding Agent | ✅ | ✅ 完整 (預設開啟; 無需驗證) | 任何 *付費* Copilot 授權 | 預設開啟 |
| Copilot in Visual Studio | ✅ | ✅ 完整 (OAuth + PAT) | 本地: Docker 或 Go 編譯, GitHub PAT<br>遠端: Visual Studio 17.14+ | 簡單 |
| Copilot in JetBrains | ✅ | ✅ 完整 (OAuth + PAT) | 本地: Docker 或 Go 編譯, GitHub PAT<br>遠端: JetBrains Copilot 擴充功能 v1.5.53+ | 簡單 |
| Claude Code | ✅ | ✅ PAT + ❌ 無 OAuth| GitHub MCP 伺服器二進制檔或遠端 URL, GitHub PAT | 簡單 |
| Claude Desktop | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 中等 |
| Cline | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Cursor | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Google Gemini CLI | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Roo Code | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Windsurf | ✅ | ✅ PAT + ❌ 無 OAuth | Docker 或 Go 編譯, GitHub PAT | 簡單 |
| Copilot in Xcode | ✅ | ✅ 完整 (OAuth + PAT) | 本地: Docker 或 Go 編譯, GitHub PAT<br>遠端: Copilot for Xcode 0.41.0+ | 簡單 |
| Copilot in Eclipse | ✅ | ✅ 完整 (OAuth + PAT) | 本地: Docker 或 Go 編譯, GitHub PAT<br>遠端: Eclipse Plug-in for Copilot 0.10.0+ | 簡單 |

**圖例：**
- ✅ = 完全支援
- ❌ = 尚未支援

**注意：** 遠端 MCP 支援需要主機應用程式註冊 GitHub App 或 OAuth App 以支援 OAuth 流程 — 即使該主機應用程式已支援新的 OAuth 規範。目前，僅 VS Code 具備完整的遠端 GitHub 伺服器支援。

## 安裝方法

GitHub MCP 伺服器可以使用多種方法安裝。**對於大多數使用者，Docker 是最熱門且推薦的方法**，但根據您的需求也有其他選擇：

### 🐳 Docker (最常見且推薦)
- **優點**：無需本地編譯、環境一致、更新方便、跨平台運作
- **缺點**：需要安裝並執行 Docker
- **最適合**：大多數使用者，特別是已經在使用 Docker 或想要最簡單設定的使用者
- **適用於**：Claude Desktop、Copilot in VS Code、Cursor、Windsurf 等

### 📦 預編譯二進制檔 (輕量級替代方案)
- **優點**：無需 Docker、透過 stdio 直接執行、設定最少
- **缺點**：需要手動下載和管理更新、平台專屬的二進制檔
- **最適合**：極簡環境、不偏好使用 Docker 的使用者
- **適用於**：Claude Code CLI、輕量級設定

### 🔨 從原始碼編譯 (進階使用者)
- **優點**：最新功能、完全自訂、無外部依賴
- **缺點**：需要 Go 開發環境、設定較複雜
- **先決條件**：[Go 1.24+](https://go.dev/doc/install)
- **編譯指令**：`go build -o github-mcp-server cmd/github-mcp-server/main.go`
- **最適合**：想要最新功能或需要自訂修改的開發者

### 關於 GitHub MCP 伺服器的重要注意事項

- **Docker 映像檔**：官方 Docker 映像檔現在是 `ghcr.io/github/github-mcp-server`
- **npm 套件**：自 2025 年 4 月起，不再支援 npm 套件 `@modelcontextprotocol/server-github`
- **遠端伺服器**：遠端伺服器 URL 為 `https://api.githubcopilot.com/mcp/`

## 一般先決條件

所有使用個人存取權杖 (PAT) 的安裝都需要：
- **GitHub 個人存取權杖 (PAT)**：[在此建立](https://github.com/settings/personal-access-tokens/new)

選配（取決於安裝方法）：
- **Docker**（適用於基於 Docker 的安裝）：[下載 Docker](https://www.docker.com/)
- **Go 1.24+**（適用於從原始碼編譯）：[安裝 Go](https://go.dev/doc/install)

## 安全最佳實踐

無論您選擇哪種安裝方法，請遵循以下安全準則：

1. **安全儲存權杖**：切勿將您的 GitHub PAT 提交到版本控制系統。
2. **限制權杖範圍**：僅授予 GitHub PAT 必要的權限。
3. **檔案權限**：限制對包含權杖的配置檔案的存取。
4. **定期更換**：定期更換您的 GitHub 個人存取權杖。
5. **環境變數**：在主機應用程式支援時使用環境變數。

## 獲取協助

如果您遇到問題：
1. 檢查特定安裝指南中的疑難排解章節。
2. 確認您的 GitHub PAT 具有所需的權限。
3. 確保 Docker 正在執行（適用於本地安裝）。
4. 查看主機應用程式的日誌以獲取錯誤訊息。
5. 參考主 [README.md](../../README_zh_TW.md) 以獲取更多配置選項。

## 配置選項

安裝後，您可能想要探索：
- **工具集 (Toolsets)**：啟用/停用特定的 GitHub API 功能。
- **唯讀模式**：限制為僅限唯讀操作。
- **動態工具發現**：隨需啟用工具。
- **鎖定模式 (Lockdown Mode)**：隱藏沒有推送權限的使用者所建立的公開 Issue 詳細資訊。
