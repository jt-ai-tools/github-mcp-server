# 測試

本專案結合使用單元測試和端對端 (e2e) 測試，以確保正確性和穩定性。

## 單元測試模式

- 單元測試與實作程式碼位於同一目錄下，檔案名稱以 `_test.go` 結尾。
- 目前偏好使用內部測試，即測試檔案不帶有 `_test` 套件後綴。
- 測試使用 [testify](https://github.com/stretchr/testify) 進行斷言 (assertions) 和必要陳述 (require statements)。當繼續測試已無意義時使用 `require`，例如在發生預期錯誤之後繼續執行幾乎是不正確的。
- REST 模擬使用儲存庫內的 `MockHTTPClientWithHandlers` 輔助程式執行；GraphQL 模擬使用 `githubv4mock`。
- 每個工具的結構描述 (schema) 都會使用 `toolsnaps` 工具進行快照並檢查更改（見下文）。
- 測試旨在顯式且詳盡，以助於維護和清晰度。
- 處理常式 (Handler) 單元測試應採取以下形式：
    1. 測試工具快照
    2. 對結構描述的關鍵預期（例如 `ReadOnly` 註解）
    3. 表格驅動形式的行為測試

## 端對端 (e2e) 測試

- E2E 測試位於 [`e2e/`](../e2e/) 目錄中。有關執行和偵錯這些測試的完整詳細資訊，請參閱 [e2e/README_zh_TW.md](../e2e/README_zh_TW.md)。

## toolsnaps：工具結構描述快照

- `toolsnaps` 工具確保每個工具的 JSON 結構描述不會發生意外更改。
- 快照儲存在 `__toolsnaps__/*.snap` 檔案中，其中 `*` 代表工具名稱。
- 執行測試時，目前的工具結構描述會與快照進行比較。如果存在差異，測試將失敗並顯示差異。
- 如果您有意更改工具的結構描述，請透過設定環境變數執行測試來更新快照：`UPDATE_TOOLSNAPS=true go test ./...`
- 在 CI 中（當 `GITHUB_ACTIONS=true` 時），缺失的快照將導致測試失敗，以確保快照始終被提交。

## 注意事項

- 某些會更改全域狀態的工具（例如將所有通知標記為已讀）主要透過單元測試而非 e2e 進行測試，以避免副作用。
- 有關 e2e 測試套件的限制和理念的更多資訊，請參閱 [e2e/README_zh_TW.md](../e2e/README_zh_TW.md)。
