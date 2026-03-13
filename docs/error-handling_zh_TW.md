# 錯誤處理

此文件描述了 GitHub MCP 伺服器中使用的錯誤處理模式，特別是我們如何處理 GitHub API 錯誤，並避免直接使用 mcp-go 的錯誤類型。

## 概觀

GitHub MCP 伺服器實作了一種自定義的錯誤處理方法，主要有兩個目的：

1. **工具回應生成**：向用戶端回傳適當的 MCP 工具錯誤回應
2. **中介軟體檢查**：在請求內容 (context) 中儲存詳細的錯誤資訊，供中介軟體分析

這種雙重方法提供了更好的可觀察性和調試能力，特別是對於遠端伺服器部署，了解失敗的本質（速率限制、身份驗證、404、500 等）對於驗證和監控至關重要。

## 錯誤類型

### GitHubAPIError

用於來自 GitHub API 的 REST API 錯誤：

```go
type GitHubAPIError struct {
    Message  string           `json:"message"`
    Response *github.Response `json:"-"`
    Err      error            `json:"-"`
}
```

### GitHubGraphQLError

用於來自 GitHub API 的 GraphQL API 錯誤：

```go
type GitHubGraphQLError struct {
    Message string `json:"message"`
    Err     error  `json:"-"`
}
```

## 使用模式

### 對於 GitHub REST API 錯誤

不要直接回傳 `mcp.NewToolResultError()`，而是使用：

```go
return ghErrors.NewGitHubAPIErrorResponse(ctx, message, response, err), nil
```

此函數會：
- 使用提供的訊息、回應和錯誤建立一個 `GitHubAPIError`
- 將錯誤儲存在 context 中供中介軟體檢查
- 回傳適當的 MCP 工具錯誤回應

### 對於 GitHub GraphQL API 錯誤

```go
return ghErrors.NewGitHubGraphQLErrorResponse(ctx, message, err), nil
```

### Context 管理

錯誤處理系統使用 context 來儲存錯誤，以便稍後檢查：

```go
// 使用錯誤追蹤初始化 context
ctx = errors.ContextWithGitHubErrors(ctx)

// 檢索錯誤進行檢查（通常在中介軟體中）
apiErrors, err := errors.GetGitHubAPIErrors(ctx)
graphqlErrors, err := errors.GetGitHubGraphQLErrors(ctx)
```

## 設計原則

### 使用者可操作錯誤與開發者錯誤

- **使用者可操作錯誤**（身分驗證失敗、速率限制、404s）應使用錯誤回應函數作為失敗的工具呼叫回傳
- **開發者錯誤**（JSON 編組失敗、內部邏輯錯誤）應作為實際的 Go 錯誤回傳，並透過 MCP 框架向上傳遞

### Context 限制

此方法的設計目的是為了解決目前 mcp-go 中的限制，即 context 不會在請求處理的每個步驟中傳遞。透過將錯誤儲存在 context 值中，中介軟體可以檢查它們而不需要 context 傳遞。

### 優雅的錯誤處理

context 中的錯誤儲存操作旨在優雅地失敗 - 如果 context 儲存失敗，工具仍會向用戶端回傳適當的錯誤回應。

## 優點

1. **可觀察性**：中介軟體可以檢查發生的 GitHub API 錯誤的特定類型
2. **調試**：保留詳細的錯誤資訊，而不會在日誌中洩漏潛在的敏感數據
3. **驗證**：遠端伺服器可以使用錯誤類型和 HTTP 狀態碼來驗證更改是否破壞了功能
4. **隱私**：可以使用 `errors.Is` 檢查以程式化方式進行錯誤檢查，而無需記錄 PII

## 實作範例

```go
func GetIssue(getClient GetClientFn, t translations.TranslationHelperFunc) (tool mcp.Tool, handler server.ToolHandlerFunc) {
    return mcp.NewTool("get_issue", /* ... */),
        func(ctx context.Context, request mcp.CallToolRequest) (*mcp.CallToolResult, error) {
            owner, err := RequiredParam[string](request, "owner")
            if err != nil {
                return mcp.NewToolResultError(err.Error()), nil
            }
            
            client, err := getClient(ctx)
            if err != nil {
                return nil, fmt.Errorf("failed to get GitHub client: %w", err)
            }
            
            issue, resp, err := client.Issues.Get(ctx, owner, repo, issueNumber)
            if err != nil {
                return ghErrors.NewGitHubAPIErrorResponse(ctx,
                    "failed to get issue",
                    resp,
                    err,
                ), nil
            }
            
            return MarshalledTextResult(issue), nil
        }
}
```

這種方法確保了用戶端收到適當的錯誤回應，並且任何中介軟體都可以檢查底層的 GitHub API 錯誤，以進行監控和調試。
