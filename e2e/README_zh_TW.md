# 端對端 (e2e) 測試

E2E 測試的目的是透過一個簡單的（目前）測試，讓維護者對我們產出物的黑箱行為有一定的信心。它透過以下方式達成：
 * 建立 `github-mcp-server` docker 映像檔
 * 執行該映像檔
 * 透過 stdio 與伺服器互動
 * 發出與即時 GitHub API 互動的請求

## 執行測試

必須執行一個支援透過 `docker` CLI 建立映像檔和容器的服務。

由於這些測試需要一個權杖 (token) 來與 GitHub API 上的實際資源互動，因此它被置於 `e2e` 建置標記 (build flag) 之後。

```
GITHUB_MCP_SERVER_E2E_TOKEN=<您的權杖> go test -v --tags e2e ./e2e
```

`GITHUB_MCP_SERVER_E2E_TOKEN` 環境變數在內部對應到 `GITHUB_PERSONAL_ACCESS_TOKEN`，但將其分開以避免意外重複使用憑證。

## 範例

以下差異將 `get_me` 工具調整為回傳 `foobar` 作為使用者登入名稱。

```diff
diff --git a/pkg/github/context_tools.go b/pkg/github/context_tools.go
index 1c91d70..ac4ef2b 100644
--- a/pkg/github/context_tools.go
+++ b/pkg/github/context_tools.go
@@ -39,6 +39,8 @@ func GetMe(getClient GetClientFn, t translations.TranslationHelperFunc) (tool mc
                                return mcp.NewToolResultError(fmt.Sprintf("failed to get user: %s", string(body))), nil
                        }

+                       user.Login = sPtr("foobar")
+
                        r, err := json.Marshal(user)
                        if err != nil {
                                return nil, fmt.Errorf("failed to marshal user: %w", err)
@@ -47,3 +49,7 @@ func GetMe(getClient GetClientFn, t translations.TranslationHelperFunc) (tool mc
                        return mcp.NewToolResultText(string(r)), nil
                }
 }
+
+func sPtr(s string) *string {
+       return &s
+}
```

執行測試：

```
➜ GITHUB_MCP_SERVER_E2E_TOKEN=$(gh auth token) go test -v --tags e2e ./e2e
=== RUN   TestE2E
    e2e_test.go:92: Building Docker image for e2e tests...
    e2e_test.go:36: Starting Stdio MCP client...
=== RUN   TestE2E/Initialize
=== RUN   TestE2E/CallTool_get_me
    e2e_test.go:85:
                Error Trace:    /Users/williammartin/workspace/github-mcp-server/e2e/e2e_test.go:85
                Error:          Not equal:
                                expected: "foobar"
                                actual  : "williammartin"

                                Diff:
                                --- Expected
                                +++ Actual
                                @@ -1 +1 @@
                                -foobar
                                +williammartin
                Test:           TestE2E/CallTool_get_me
                Messages:       expected login to match
--- FAIL: TestE2E (1.05s)
    --- PASS: TestE2E/Initialize (0.09s)
    --- FAIL: TestE2E/CallTool_get_me (0.46s)
FAIL
FAIL    github.com/github/github-mcp-server/e2e 1.433s
FAIL
```

## 除錯測試

可以提供 `GITHUB_MCP_SERVER_E2E_DEBUG=true` 來使用 MCP 伺服器的程序內 (in-process) 版本執行 e2e 測試。這會稍微減少測試涵蓋範圍，因為它不與 Docker 整合，也不使用 cobra/viper 配置解析。然而，它允許在 MCP 伺服器內部設置斷點，比完全黑箱測試支援更好的除錯流程。

有人可能會認為黑箱測試缺乏失敗的可視性也顯示了產品需求，但這解決了身為維護者所感受到的當前痛點。

## 限制

目前的測試套件刻意將範圍限制得很小。這是因為 e2e 測試的維護成本往往會隨著時間顯著增加。要瞭解 GitHub 整合測試的一些挑戰，請參閱 [go-github 整合測試 README](https://github.com/google/go-github/blob/5b75aa86dba5cf4af2923afa0938774f37fa0a67/test/README.md)。我們將謹慎地擴展此套件！

這些測試非常重複且冗長。這是刻意的，因為我們希望在投入抽象化之前看到它們發展得更多。

目前，對失敗的可視性不是特別好。我們希望我們可以拆分 mcp-go 用戶端，並讓它掛鉤到代表 stdio 的串流，而不需要 exec。這樣我們就可以輕鬆地在除錯器中獲取斷點。

### 全域狀態變更測試

某些工具（例如將所有通知標記為已讀的工具）會更改測試者的全域狀態，且不具備冪等性 (idempotent)，因此它們對於端對端測試的價值不大，應改為依賴單元測試和手動驗證。
