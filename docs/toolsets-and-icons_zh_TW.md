# 工具集與圖示

本文檔說明如何在 GitHub MCP 伺服器中使用工具集和圖示。

## 工具集概觀

工具集是相關工具的邏輯分組。每個工具集在 `pkg/github/tools.go` 中定義了中繼資料：

```go
ToolsetMetadataRepos = inventory.ToolsetMetadata{
    ID:          "repos",
    Description: "GitHub Repository related tools",
    Default:     true,
    Icon:        "repo",
}
```

### 工具集欄位

| 欄位 | 類型 | 說明 |
|-------|------|-------------|
| `ID` | `ToolsetID` | 用於 URL 和 CLI 旗標的唯一識別碼（例如：`repos`, `issues`） |
| `Description` | `string` | 在文件中顯示的人類可讀說明 |
| `Default` | `bool` | 是否預設啟用此工具集 |
| `Icon` | `string` | 用於 MCP 用戶端視覺呈現的 Octicon 名稱 |

## 為工具集添加圖示

圖示可幫助使用者在與 MCP 相容的用戶端中快速識別工具集。我們對所有圖示都使用 [Primer Octicons](https://primer.style/foundations/icons)。

### 步驟 1：選擇一個 Octicon

瀏覽 [Octicon 庫](https://primer.style/foundations/icons) 並選擇一個適當的圖示。使用不含尺寸後綴的基本名稱（例如使用 `repo` 而不是 `repo-16`）。

### 步驟 2：將圖示添加到必要圖示列表

圖示在 `pkg/octicons/required_icons.txt` 中定義，這是哪些圖示應該被嵌入的唯一事實來源：

```
# Required icons for the GitHub MCP Server
# Add new icons below (one per line)
repo
issue-opened
git-pull-request
your-new-icon  # 在此處添加您的圖示
```

### 步驟 3：獲取圖示檔案

執行 fetch-icons 指令碼來下載並轉換圖示：

```bash
# 獲取特定圖示
script/fetch-icons your-new-icon

# 或獲取所有必要的圖示
script/fetch-icons
```

此指令碼會：
- 從 [Primer Octicons](https://github.com/primer/octicons) 下載 24px 的 SVG
- 轉換為淺色主題的 PNG（淺色背景下的深色圖示）
- 轉換為深色主題的 PNG（深色背景下的白色圖示）
- 將這兩種變體儲存到 `pkg/octicons/icons/`

**要求：** 該指令碼需要 `rsvg-convert`：
- Ubuntu/Debian: `sudo apt-get install librsvg2-bin`
- macOS: `brew install librsvg`

### 步驟 4：更新工具集中繼資料

在工具集定義中添加或更新 `Icon` 欄位：

```go
// 在 pkg/github/tools.go 中
ToolsetMetadataRepos = inventory.ToolsetMetadata{
    ID:          "repos",
    Description: "GitHub Repository related tools",
    Default:     true,
    Icon:        "repo",  // 添加此行
}
```

### 步驟 5：重新產生文件

執行文件產生器以更新所有 Markdown 檔案：

```bash
go run ./cmd/github-mcp-server generate-docs
```

這會更新以下位置的圖示：
- `README_zh_TW.md` — 工具集表格和工具章節標頭
- `docs/remote-server_zh_TW.md` — 遠端工具集表格

## 僅限遠端工具集

某些工具集僅在遠端 GitHub MCP 伺服器（託管在 `api.githubcopilot.com`）中可用。這些工具集在 `pkg/github/tools.go` 中及其圖示一起定義，但未在本地伺服器中註冊：

```go
// 僅限遠端的工具集
ToolsetMetadataCopilot = inventory.ToolsetMetadata{
    ID:          "copilot",
    Description: "Copilot related tools",
    Icon:        "copilot",
}
```

`RemoteOnlyToolsets()` 函數回傳這些工具集的列表，用於產生文件。

要添加新的僅限遠端工具集：

1. 在 `pkg/github/tools.go` 中添加中繼資料定義
2. 將其添加到 `RemoteOnlyToolsets()` 回傳的切片中
3. 重新產生文件

## 工具圖示繼承

個別工具會繼承其父工具集的圖示。當一個工具註冊到某個工具集時，它的圖示會自動設定：

```go
// 在 pkg/inventory/server_tool.go 中
toolCopy.Icons = tool.Toolset.Icons()
```

這意味著您只需在工具集上設定一次圖示，該工具集中的所有工具都將顯示相同的圖示。

## 圖示在 MCP 中如何運作

MCP 協定透過 `icons` 欄位支援工具圖示。我們提供兩種格式的圖示：

1. **Data URIs** — 嵌入在工具定義中的 Base64 編碼 PNG 影像
2. **淺色/深色變體** — 提供兩種主題變體以確保正確顯示

`octicons.Icons()` 函數產生與 MCP 相容的圖示物件：

```go
// 回傳包含淺色和深色變體的 []mcp.Icon
icons := octicons.Icons("repo")
```

## 現有的工具集圖示

| 工具集 | Octicon 名稱 |
|---------|--------------|
| 上下文 (Context) | `person` |
| 存儲庫 (Repositories) | `repo` |
| Issues | `issue-opened` |
| 拉取請求 (Pull Requests) | `git-pull-request` |
| Git | `git-branch` |
| 使用者 (Users) | `people` |
| 組織 (Organizations) | `organization` |
| Actions | `workflow` |
| 程式碼安全 (Code Security) | `codescan` |
| 密鑰保護 (Secret Protection) | `shield-lock` |
| Dependabot | `dependabot` |
| 討論 (Discussions) | `comment-discussion` |
| Gists | `logo-gist` |
| 安全諮詢 (Security Advisories) | `shield` |
| 專案 (Projects) | `project` |
| 標籤 (Labels) | `tag` |
| 關注者 (Stargazers) | `star` |
| 通知 (Notifications) | `bell` |
| 動態 (Dynamic) | `tools` |
| Copilot | `copilot` |
| 支援搜尋 (Support Search) | `book` |

## 疑難排解

### 圖示未出現在文件中

1. 確保 `pkg/octicons/icons/` 中存在帶有 `-light.png` 和 `-dark.png` 後綴的 PNG 檔案
2. 執行 `go run ./cmd/github-mcp-server generate-docs` 以重新產生
3. 檢查工具集中繼資料上是否設定了 `Icon` 欄位

### 圖示未出現在 MCP 用戶端中

1. 驗證用戶端是否支援 MCP 工具圖示
2. 檢查 `octicons` 套件是否正確產生 Base64 Data URIs
3. 確保圖示名稱與 `pkg/octicons/icons/` 中的檔案匹配

## CI 驗證

以下測試在 CI 中執行，以及早發現圖示問題：

### `pkg/octicons.TestEmbeddedIconsExist`

驗證 `pkg/octicons/required_icons.txt` 中列出的所有圖示是否都有對應的嵌入 PNG 檔案。

### `pkg/github.TestAllToolsetIconsExist`

驗證所有工具集的 `Icon` 欄位引用的圖示是否已正確嵌入。

### `pkg/github.TestToolsetMetadataHasIcons`

確保所有工具集都設定了 `Icon` 欄位。

如果任何測試失敗：
1. 將缺少的圖示添加到 `pkg/octicons/required_icons.txt`
2. 執行 `script/fetch-icons` 下載圖示
3. 提交新的圖示檔案
