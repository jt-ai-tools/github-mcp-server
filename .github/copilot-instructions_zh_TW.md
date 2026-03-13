# GitHub MCP Server - Copilot 指示

## 專案概觀

這是 **GitHub MCP Server**，一個將 AI 工具連接到 GitHub 平台的模型上下文協定 (MCP) 伺服器。它使 AI 代理能夠透過自然語言管理儲存庫、議題 (Issues)、提取請求 (Pull Requests)、工作流程等。

**關鍵細節：**
- **語言：** Go 1.24+（約 3.8 萬行程式碼）
- **類型：** 具有 CLI 介面的 MCP 伺服器應用程式
- **主要套件：** github-mcp-server (stdio MCP 伺服器 - **這是主要焦點**)
- **次要套件：** mcpcurl (測試工具 - 不要弄壞它，但不是優先事項)
- **框架：** 使用 modelcontextprotocol/go-sdk 處理 MCP 協定，使用 google/go-github 處理 GitHub API
- **規模：** 約 60MB 的儲存庫，70 個 Go 檔案
- **函式庫使用：** 此儲存庫也被遠端伺服器用作函式庫。可能被其他儲存庫呼叫的函數應匯出（大寫），即使內部不需要。保留現有的匯出模式。

**程式碼品質標準：**
- **熱門開源儲存庫** - 對程式碼品質和清晰度有很高要求
- **理解優先** - 程式碼必須對廣大受眾清晰易懂
- **乾淨的提交** - 原子化、專注的變更，並帶有清晰的訊息
- **結構** - 始終保持或改進，絕不退化
- **程式碼優於註釋** - 偏好自我文件化的程式碼；僅在必要時添加註釋

## 關鍵建置與驗證步驟

### 必要指令（提交前執行）

**在執行 report_progress 或完成工作之前，請務必按照以下確切順序執行這些指令：**

1. **格式化程式碼：** `script/lint`（執行 `gofmt -s -w .` 然後執行 `golangci-lint`）
2. **執行測試：** `script/test`（執行 `go test -race ./...`）
3. **更新文件：** `script/generate-docs`（如果您修改了 MCP 工具/工具集）

**這些指令執行速度很快：** Lint 約 1 秒，測試約 1 秒（有快取），建置約 1 秒

### 修改 MCP 工具/端點時

如果您更改了任何 MCP 工具定義或結構定義：
1. 使用 `UPDATE_TOOLSNAPS=true go test ./...` 執行測試以更新 toolsnaps
2. 提交 `pkg/github/__toolsnaps__/` 中更新後的 `.snap` 檔案
3. 執行 `script/generate-docs` 以更新 README.md
4. Toolsnaps 記錄了 API 表面並確保變更是刻意的

### 常見建置指令

```bash
# 下載依賴項（很少需要 - 通常已有快取）
go mod download

# 建置伺服器執行檔
go build -v ./cmd/github-mcp-server

# 執行伺服器
./github-mcp-server stdio

# 執行特定套件測試
go test ./pkg/github -v

# 執行特定測試
go test ./pkg/github -run TestGetMe
```

## 專案結構

### 目錄佈局

```
.
├── cmd/
│   ├── github-mcp-server/    # 主要 MCP 伺服器進入點 (主要焦點)
│   └── mcpcurl/              # MCP 測試工具 (次要 - 不要弄壞它)
├── pkg/                      # 公共 API 套件
│   ├── github/               # GitHub API MCP 工具實作
│   │   └── __toolsnaps__/    # 工具結構快照 (*.snap 檔案)
│   ├── toolsets/             # 工具集配置與管理
│   ├── errors/               # 錯誤處理工具
│   ├── sanitize/             # HTML/內容消毒
│   ├── log/                  # 日誌工具
│   ├── raw/                  # 原始數據處理
│   ├── buffer/               # 緩衝區工具
│   └── translations/         # i18n 翻譯支援
├── internal/                 # 內部實作套件
│   ├── ghmcp/                # GitHub MCP 伺服器核心邏輯
│   ├── githubv4mock/         # 用於測試的 GraphQL API 模擬
│   ├── toolsnaps/            # Toolsnap 驗證系統
│   └── profiler/             # 效能剖析
├── e2e/                      # 端對端測試 (需要 GitHub PAT)
├── script/                   # 建置與維護指令碼
├── docs/                     # 文件
├── .github/workflows/        # CI/CD 工作流程
└── [配置文件]                # 見下文
```

### 關鍵配置文件

- **go.mod / go.sum:** Go 模組依賴項 (Go 1.24.0+)
- **.golangci.yml:** Linter 配置 (v2 格式，啟用約 15 個 linter)
- **Dockerfile:** 多階段建置 (golang:1.25.3-alpine → distroless)
- **server.json:** 用於註冊表的 MCP 伺服器元數據
- **.goreleaser.yaml:** 發布自動化配置
- **.gitignore:** 排除 bin/、dist/、vendor/、*.DS_Store、github-mcp-server 執行檔

### 重要指令碼 (script/ 目錄)

- **script/lint** - 執行 `gofmt` + `golangci-lint`。**提交前必須執行**
- **script/test** - 執行 `go test -race ./...` (完整測試套件)
- **script/generate-docs** - 更新 README.md 工具文件。工具變更後執行
- **script/licenses** - 當依賴項變更時更新第三方授權檔案
- **script/licenses-check** - 驗證授權合規性 (在 CI 中執行)
- **script/get-me** - get_me 工具的快速測試指令碼
- **script/get-discussions** - 討論區的快速測試
- **script/tag-release** - **絕不使用此指令** - 發布是分開管理的

## GitHub 工作流程 (CI/CD)

除非另有說明，否則所有工作流程都在 push/PR 時執行。位於 `.github/workflows/`：

1. **go.yml** - 在 ubuntu/windows/macos 上建置並測試。執行 `script/test` 並建置執行檔
2. **lint.yml** - 執行 golangci-lint-action v2.5 (GitHub Action)
3. **docs-check.yml** - 透過執行 generate-docs 並檢查 git diff 來驗證 README.md 是否最新
4. **code-scanning.yml** - 針對 Go 和 GitHub Actions 的 CodeQL 安全分析
5. **license-check.yml** - 執行 `script/licenses-check` 以驗證合規性
6. **docker-publish.yml** - 將容器映像檔發布到 ghcr.io
7. **goreleaser.yml** - 建立發布 (僅限 main 分支)
8. **registry-releaser.yml** - 更新 MCP 註冊表

**PR 合併前所有這些都必須通過。** 如果 docs-check 失敗，請執行 `script/generate-docs` 並提交變更。

## 測試指南

### 單元測試

- 使用 `testify` 進行斷言 (關鍵檢查使用 `require`，非阻塞使用 `assert`)
- 測試位於與實作同級的 `*_test.go` 檔案中 (內部測試，非 `_test` 套件)
- 使用 `go-github-mock` (REST) 或 `githubv4mock` (GraphQL) 模擬 GitHub API
- 工具的測試結構：
  1. 測試工具快照
  2. 驗證關鍵結構屬性 (例如 ReadOnly 註解)
  3. 表格驅動的行為測試

### Toolsnaps (工具結構定義快照)

- 每個 MCP 工具在 `pkg/github/__toolsnaps__/*.snap` 中都有一個 JSON 結構快照
- 如果當前結構與快照不同，測試將失敗 (顯示差異)
- 在刻意變更後進行更新：`UPDATE_TOOLSNAPS=true go test ./...`
- **必須提交更新後的 .snap 檔案** - 它們記錄了 API 變更
- 缺失快照會導致 CI 失敗

### 端對端測試

- 位於 `e2e/` 目錄，帶有 `e2e_test.go`
- **需要 GitHub PAT 權杖** - 您通常無法自行執行這些測試
- 執行方式：`GITHUB_MCP_SERVER_E2E_TOKEN=<token> go test -v --tags e2e ./e2e`
- 測試透過 Docker 容器與即時 GitHub API 互動
- **更改 MCP 工具時請保持 e2e 測試更新**
- **在修改此目錄中的測試時，僅使用 e2e 測試樣式**
- 除錯：`GITHUB_MCP_SERVER_E2E_DEBUG=true` 以程序內方式執行 (不使用 Docker)

## 程式碼風格與 Linting

### Go 程式碼要求

- **帶有簡化標記 (-s) 的 gofmt** - 由 `script/lint` 自動執行
- **golangci-lint** 啟用了以下 linter：
  - bodyclose, gocritic, gosec, makezero, misspell, nakedret, revive
  - errcheck, staticcheck, govet, ineffassign, unused
- 排除：third_party/、builtin/、examples/、生成的程式碼

### Go 命名慣例

- **識別字中的縮寫：** 使用 `ID` 而非 `Id`，`API` 而非 `Api`，`URL` 而非 `Url`，`HTTP` 而非 `Http`
- 範例：`userID`, `getAPI`, `parseURL`, `HTTPClient`
- 這適用於變數名稱、函數名稱、結構體欄位等。

### 程式碼模式

- **保持變更最小且集中**在正在解決的特定問題上
- **清晰重於靈巧** - 程式碼必須能被廣大讀者理解
- **原子提交** - 每個提交都應是一個完整、合乎邏輯的變更
- **維持或改進結構** - 絕不退化程式碼組織
- 使用表格驅動測試進行行為測試
- 註釋要節制 - 程式碼應自我文件化
- 遵循標準 Go 慣例 (Effective Go, Go proverbs)
- **提交前徹底測試變更**
- 如果函數可能被其他儲存庫作為函式庫使用，則匯出函數（首字母大寫）

## 常見開發工作流程

### 添加新的 MCP 工具

1. 在 `pkg/github/` 中添加工具實作 (例如 `foo_tools.go`)
2. 在 `pkg/github/` 或 `pkg/toolsets/` 的適當工具集中註冊工具
3. 按照工具測試模式編寫單元測試
4. 執行 `UPDATE_TOOLSNAPS=true go test ./...` 以建立快照
5. 執行 `script/generate-docs` 以更新 README
6. 提交前執行 `script/lint` 和 `script/test`
7. 如果 e2e 測試相關，使用現有測試樣式更新 `e2e/e2e_test.go`
8. 同時提交程式碼 + 快照 + README 變更

### 修復 Bug

1. 編寫一個能重現 Bug 的失敗測試
2. 以最小的變更修復 Bug
3. 驗證測試通過且現有測試仍然通過
4. 執行 `script/lint` 和 `script/test`
5. 如果工具結構發生變更，更新 toolsnaps (見上文)

### 更新依賴項

1. 更新 `go.mod` (例如 `go get -u ./...` 或手動更新)
2. 執行 `go mod tidy`
3. 執行 `script/licenses` 以更新授權檔案
4. 執行 `script/test` 以驗證沒有任何損壞
5. 提交 go.mod, go.sum 和 third-party-licenses* 檔案

## 常見錯誤與解決方案

### CI 中出現 "Documentation is out of date"

**修復：** 執行 `script/generate-docs` 並提交 README.md 變更

### Toolsnap 不匹配失敗

**修復：** 執行 `UPDATE_TOOLSNAPS=true go test ./...` 並提交更新後的 .snap 檔案

### Lint 失敗

**修復：** 在本地執行 `script/lint` - 它會自動格式化並顯示問題。手動修復報告的問題。

### 授權檢查失敗

**修復：** 在依賴項變更後執行 `script/licenses` 以重新生成授權檔案

### 更改工具後測試失敗

**可能原因：**
1. 忘記更新 toolsnaps - 使用 `UPDATE_TOOLSNAPS=true` 執行
2. 行為變更導致現有測試損壞 - 驗證意圖並修復測試
3. 結構定義變更未反映在測試中 - 更新測試預期

## 環境變數

- **GITHUB_PERSONAL_ACCESS_TOKEN** - 伺服器運作和 e2e 測試所需
- **GITHUB_HOST** - 用於 GitHub Enterprise Server (以 `https://` 開頭)
- **GITHUB_TOOLSETS** - 以逗號分隔的工具集清單 (覆蓋 --toolsets 標記)
- **GITHUB_READ_ONLY** - 設置為 "1" 以啟用唯讀模式
- **GITHUB_DYNAMIC_TOOLSETS** - 設置為 "1" 以啟用動態工具集發現
- **UPDATE_TOOLSNAPS** - 執行測試時設置為 "true" 以更新快照
- **GITHUB_MCP_SERVER_E2E_TOKEN** - 用於 e2e 測試的權杖
- **GITHUB_MCP_SERVER_E2E_DEBUG** - 設置為 "true" 以進行程序內 e2e 除錯

## 關鍵檔案參考

### 根目錄檔案
```
.dockerignore        - Docker 建置排除項
.gitignore          - Git 排除項 (包括 bin/、dist/、vendor/、執行檔)
.golangci.yml       - Linter 配置
.goreleaser.yaml    - 發布自動化
CODE_OF_CONDUCT.md  - 社群準則
CONTRIBUTING.md     - 貢獻指南 (fork, clone, test, lint 工作流程)
Dockerfile          - 多階段 Go 建置
LICENSE             - MIT 授權
README.md           - 主要文件 (自動生成章節)
SECURITY.md         - 安全政策
SUPPORT.md          - 支援資源
gemini-extension.json - Gemini CLI 配置
go.mod / go.sum     - Go 依賴項
server.json         - MCP 伺服器註冊表元數據
```

### 主要進入點

`cmd/github-mcp-server/main.go` - 使用 cobra 處理 CLI，viper 處理配置，支援：
- `stdio` 指令 (預設) - MCP stdio 傳輸
- `generate-docs` 指令 - 文件生成
- 標記：--toolsets, --read-only, --dynamic-toolsets, --gh-host, --log-file

## 重要提醒

1. **主要焦點：** 本地 stdio MCP 伺服器 (github-mcp-server) - 這是您應該開發和測試的對象
2. **遠端伺服器：** 在進行程式碼變更時忽略遠端伺服器說明（除非特別要求）。此儲存庫被遠端伺服器用作函式庫，因此即使內部不需要，如果函數可能被其他儲存庫呼叫，請保持函數匯出（首字母大寫）。
3. **始終**優先信任這些指示 - 僅在資訊不完整或不正確時才搜尋
4. **絕不**使用 `script/tag-release` 或推送標籤
5. **絕不**在提交 Go 程式碼變更前跳過 `script/lint`
6. **始終**在更改 MCP 工具結構時更新 toolsnaps
7. **始終**在修改工具後執行 `script/generate-docs`
8. 對於特定測試檔案，使用 `go test ./path -run TestName` 而不是完整套件
9. E2E 測試需要 PAT 權杖 - 您可能無法執行它們
10. Toolsnaps 是 API 文件 - 請嚴肅對待變更
11. 建置/測試/lint 非常快 (~1s) - 請頻繁執行
12. CI 中 docs-check 或 license-check 的失敗有簡單的修復方法（執行相關指令碼）
13. mcpcurl 是次要的 - 不要弄壞它，但它不是重點
