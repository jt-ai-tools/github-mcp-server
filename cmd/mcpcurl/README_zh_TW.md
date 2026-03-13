# mcpcurl

這是一個 CLI 工具，可根據從 MCP 伺服器取得的結構定義 (schema) 動態建立指令，並對配置的 MCP 伺服器執行這些指令。

## 概觀

`mcpcurl` 是一個命令列介面，它可以：

1. 透過 stdio 連接到 MCP 伺服器
2. 動態擷取可用的工具結構定義
3. 為每個工具生成對應的 CLI 指令
4. 根據結構定義處理參數驗證
5. 執行指令並顯示回應

## 安裝

### 先決條件
- Go 1.24 或更高版本
- 可透過 Docker 或本地建置存取 GitHub MCP 伺服器

### 從原始碼編譯
```bash
cd cmd/mcpcurl
go build -o mcpcurl
```

### 使用 Go Install
```bash
go install github.com/github/github-mcp-server/cmd/mcpcurl@latest
```

### 驗證安裝
```bash
./mcpcurl --help
```

## 使用方法

```console
mcpcurl --stdio-server-cmd="<啟動 MCP 伺服器的指令>" <指令> [標記]
```

所有指令都需要 `--stdio-server-cmd` 標記，用於指定執行 MCP 伺服器的指令。

### 可用指令

- `tools`: 包含從結構定義動態生成的所有工具指令
- `schema`: 獲取並顯示來自 MCP 伺服器的原始結構定義
- `help`: 顯示任何指令的說明

### 範例

列出 Github MCP 伺服器中可用的工具：

```console
% ./mcpcurl --stdio-server-cmd "docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN mcp/github" tools --help
Contains all dynamically generated tool commands from the schema

Usage:
  mcpcurl tools [command]

Available Commands:
  add_issue_comment     Add a comment to an existing issue
  create_branch         Create a new branch in a GitHub repository
  create_issue          Create a new issue in a GitHub repository
  create_or_update_file Create or update a single file in a GitHub repository
  create_pull_request   Create a new pull request in a GitHub repository
  create_repository     Create a new GitHub repository in your account
  fork_repository       Fork a GitHub repository to your account or specified organization
  get_file_contents     Get the contents of a file or directory from a GitHub repository
  get_issue             Get details of a specific issue in a GitHub repository
  get_issue_comments    Get comments for a GitHub issue
  list_commits          Get list of commits of a branch in a GitHub repository
  list_issues           List issues in a GitHub repository with filtering options
  push_files            Push multiple files to a GitHub repository in a single commit
  search_code           Search for code across GitHub repositories
  search_issues         Search for issues and pull requests across GitHub repositories
  search_repositories   Search for GitHub repositories
  search_users          Search for users on GitHub
  update_issue          Update an existing issue in a GitHub repository

Flags:
  -h, --help   help for tools

Global Flags:
      --pretty                    Pretty print MCP response (only for JSON responses) (default true)
      --stdio-server-cmd string   Shell command to invoke MCP server via stdio (required)

Use "mcpcurl tools [command] --help" for more information about a command.
```

獲取特定工具的說明：

```console
 % ./mcpcurl --stdio-server-cmd "docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN mcp/github" tools get_issue --help
Get details of a specific issue in a GitHub repository

Usage:
  mcpcurl tools get_issue [flags]

Flags:
  -h, --help                 help for get_issue
      --issue_number float   
      --owner string         
      --repo string

Global Flags:
      --pretty                    Pretty print MCP response (only for JSON responses) (default true)
      --stdio-server-cmd string   Shell command to invoke MCP server via stdio (required)

```

使用其中一個工具：

```console
 % ./mcpcurl --stdio-server-cmd "docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN mcp/github" tools get_issue --owner golang --repo go --issue_number 1
{
  "active_lock_reason": null,
  "assignee": null,
  "assignees": [],
  "author_association": "CONTRIBUTOR",
  "body": "by **rsc+personal@swtch.com**:\n\n\u003cpre\u003eWhat steps will reproduce the problem?\n1. Run build on Ubuntu 9.10, which uses gcc 4.4.1\n\nWhat is the expected output? What do you see instead?\n\nCgo fails with the following error:\n\n{{{\ngo/misc/cgo/stdio$ make\ncgo  file.go\ncould not determine kind of name for C.CString\ncould not determine kind of name for C.puts\ncould not determine kind of name for C.fflushstdout\ncould not determine kind of name for C.free\nthrow: sys·mapaccess1: key not in map\n\npanic PC=0x2b01c2b96a08\nthrow+0x33 /media/scratch/workspace/go/src/pkg/runtime/runtime.c:71\n    throw(0x4d2daf, 0x0)\nsys·mapaccess1+0x74 \n/media/scratch/workspace/go/src/pkg/runtime/hashmap.c:769\n    sys·mapaccess1(0xc2b51930, 0x2b01)\nmain·*Prog·loadDebugInfo+0xa67 \n/media/scratch/workspace/go/src/cmd/cgo/gcc.go:164\n    main·*Prog·loadDebugInfo(0xc2bc0000, 0x2b01)\nmain·main+0x352 \n/media/scratch/workspace/go/src/cmd/cgo/main.go:68\n    main·main()\nmainstart+0xf \n/media/scratch/workspace/go/src/pkg/runtime/amd64/asm.s:55\n    mainstart()\ngoexit /media/scratch/workspace/go/src/pkg/runtime/proc.c:133\n    goexit()\nmake: *** [file.cgo1.go] Error 2\n}}}\n\nPlease use labels and text to provide additional information.\u003c/pre\u003e\n",
  "closed_at": "2014-12-08T10:02:16Z",
  "closed_by": null,
  "comments": 12,
  "comments_url": "https://api.github.com/repos/golang/go/issues/1/comments",
  "created_at": "2009-10-22T06:07:26Z",
  "events_url": "https://api.github.com/repos/golang/go/issues/1/events",
  [...]
}
```

## 動態指令

MCP 伺服器提供的所有工具都自動作為 `tools` 指令下的子指令可用。每個生成的指令都具有：

- 與工具輸入結構定義匹配的適當標記
- 必填參數的驗證
- 類型驗證
- 列舉 (Enum) 驗證（針對具有允許值的字串參數）
- 從工具描述生成的說明文字

## 運作方式

1. `mcpcurl` 使用 `tools/list` 方法向伺服器發送 JSON-RPC 請求
2. 伺服器回傳描述所有可用工具的結構定義
3. `mcpcurl` 根據此結構定義動態建立指令結構
4. 執行指令時，參數會轉換為 JSON-RPC 請求
5. 請求透過 stdin 發送到伺服器，回應則列印到 stdout
