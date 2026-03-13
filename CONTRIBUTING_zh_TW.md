## 貢獻指南

[fork]: https://github.com/github/github-mcp-server/fork
[pr]: https://github.com/github/github-mcp-server/compare
[style]: https://github.com/github/github-mcp-server/blob/main/.golangci.yml

您好！我們很高興您有興趣為此專案做出貢獻。您的協助對於保持專案的優秀品質至關重要。

對此專案的貢獻將根據[專案的開源授權](LICENSE)[發佈](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)給大眾。

請注意，此專案發佈時附帶了[貢獻者行為準則](CODE_OF_CONDUCT_zh_TW.md)。參與此專案即表示您同意遵守其條款。

## 我們正在尋找的內容

我們無法保證每個工具、功能或拉取請求 (Pull Request) 都會被批准或合併。我們的重點是支持高品質、高影響力的功能，以推進代理式工作流 (agentic workflows) 並為開發者提供明確的價值。

為了增加您的請求被接受的機會：
* 包含展示實際價值的真實案例或範例。
* 請建立一個 Issue 來概述場景和潛在影響，以便我們及時進行分類並相應地確定優先順序。
* 如果您的請求進展停滯，您可以發起一個討論 (Discussion) 貼文並連結到您的 Issue 或 PR。
* 我們會主動重新審視獲得社群強烈關注（按讚、評論或實際使用證據）的請求。

感謝您的貢獻，並感謝您幫助我們建立真正有價值的工具集！

## 執行與測試程式碼的先決條件

這些是為了能夠在拉取請求 (PR) 提交過程中於本地測試您的更改而需要進行的一次性安裝。

1. 安裝 Go [透過下載](https://go.dev/doc/install) | [透過 Homebrew](https://formulae.brew.sh/formula/go)
2. [安裝 golangci-lint v2](https://golangci-lint.run/welcome/install/#local-installation)

## 提交拉取請求 (Pull Request)

1. [Fork][fork] 並複製 (clone) 儲存庫。
2. 確保測試在您的機器上通過：`go test -v ./...`
3. 確保 Linter 在您的機器上通過：`golangci-lint run`
4. 建立一個新分支：`git checkout -b my-branch-name`
5. 新增您的更改和測試，並確保 Action 工作流仍然通過。
    - 執行 Linter：`script/lint`
    - 更新快照並執行測試：`UPDATE_TOOLSNAPS=true go test ./...`
    - 更新 Readme 文件：`script/generate-docs`
    - 如果重新命名工具，請新增棄用別名（請參閱[工具重命名指南](docs/tool-renaming_zh_TW.md)）。
    - 關於工具集和圖示配置，請參閱[工具集與圖示指南](docs/toolsets-and-icons_zh_TW.md)。
6. 推送到您的 Fork 並[提交拉取請求][pr]至 `main` 分支。
7. 給自己一個鼓勵，等待您的拉取請求被審閱並合併。

以下是一些可以增加您的拉取請求被接受可能性的建議：

- 遵循[樣式指南][style]。
- 撰寫測試。
- 保持您的更改儘可能集中。如果您想進行多個互不依賴的更改，請考慮將它們作為單獨的拉取請求提交。
- 撰寫[良好的提交訊息 (Commit Message)](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。

## 資源

- [如何為開源做貢獻](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
