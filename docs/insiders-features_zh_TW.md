# Insiders 功能

本文檔詳細介紹了 GitHub MCP 伺服器中 Insiders 模式下可用的實驗性功能。

## 什麼是 Insiders 模式？

Insiders 模式允許我們在實驗性功能和新工具正式發佈之前，向使用者提供早期存取權。這有助於我們收集回饋並完善功能。Insiders 模式中的功能可能會根據使用者回饋而更改、演進或刪除。

## 如何啟用 Insiders 模式

您可以透過命令列旗標或 HTTP 標頭啟用 Insiders 模式。詳情請參閱 [伺服器配置指南](./server-configuration_zh_TW.md)。

## 現有功能

### MCP 應用程式 (MCP Apps)

MCP 應用程式是一項實驗性功能，允許您直接透過 MCP 伺服器與 GitHub 上的 Copilot 擴充功能（MCP 應用程式）進行互動。

當啟用時，伺服器會自動發現使用者帳戶中安裝的具有 MCP 支援的 GitHub 應用程式。每個應用程式都會作為一個獨立的工具集公開，且其工具可在 MCP 伺服器中使用。

#### 它如何運作

1. **發現**：伺服器查詢 GitHub API 以尋找安裝在您帳戶中且啟用了 MCP 的 GitHub 應用程式。
2. **工具映射**：來自這些應用程式的工具會映射到 MCP 工具，並帶有反映應用程式名稱的前綴。
3. **執行**：當您呼叫這些工具時，MCP 伺服器會充當代理，將請求轉發到 GitHub 應用程式並回傳回應。

#### 配置

您可以透過 `X-MCP-Toolsets` 標頭或 `--toolsets` 旗標啟用特定的 MCP 應用程式。工具集的 ID 將是 GitHub 應用程式的名稱（例如：`github-copilot-radar`）。

範例：
```bash
github-mcp-server stdio --insiders --toolsets=github-copilot-radar
```

有關 Copilot 擴充功能的更多資訊，請參閱 [GitHub 文件](https://docs.github.com/en/copilot/using-github-copilot/using-extensions-to-integrate-external-tools-with-copilot-chat)。
