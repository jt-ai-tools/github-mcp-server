# 工具重新命名指南

如何在不破壞現有使用者配置的情況下安全地重命名 MCP 工具。

## 概觀

當工具重新命名時，在 MCP 配置中（例如遠端 MCP 伺服器的 `X-MCP-Tools` 標頭或本地 MCP 伺服器的 `--tools` 旗標）包含舊工具名稱的使用者通常會遇到錯誤。
棄用別名 (Deprecation alias) 系統允許我們透過將舊工具名稱靜默解析為新的正式名稱來維持回溯相容性。

這使我們能夠安全地重新命名工具，而不會為在其伺服器配置中硬引用這些工具的使用者引入破壞性更改。

## 快速步驟

1. **在程式碼中重新命名工具**（通常這會涉及一系列更改，例如更新工具註冊、測試和 toolsnaps）。
2. **在 [pkg/github/deprecated_tool_aliases.go](../pkg/github/deprecated_tool_aliases.go) 中添加棄用別名**：
   ```go
   var DeprecatedToolAliases = map[string]string{
       "old_tool_name": "new_tool_name",
   }
   ```
3. **更新文件**（README 等）以引用新的正式名稱

就是這樣。伺服器將靜默地將舊名稱解析為新名稱。這適用於本地和遠端 MCP 伺服器。

## 範例

如果要將 `get_issue` 重新命名為 `issue_read`：

```go
var DeprecatedToolAliases = map[string]string{
    "get_issue": "issue_read",
}
```

具有此配置的使用者：
```json
{
  "--tools": "get_issue,get_file_contents"
}
```

將會註冊 `issue_read` 和 `get_file_contents` 工具，且不會發生錯誤。

## 當前的棄用

<!-- START AUTOMATED ALIASES -->
| 舊名稱 | 新名稱 |
|----------|----------|
| `add_project_item` | `projects_write` |
| `cancel_workflow_run` | `actions_run_trigger` |
| `delete_project_item` | `projects_write` |
| `delete_workflow_run_logs` | `actions_run_trigger` |
| `download_workflow_run_artifact` | `actions_get` |
| `get_project` | `projects_get` |
| `get_project_field` | `projects_get` |
| `get_project_item` | `projects_get` |
| `get_workflow` | `actions_get` |
| `get_workflow_job` | `actions_get` |
| `get_workflow_job_logs` | `actions_get` |
| `get_workflow_run` | `actions_get` |
| `get_workflow_run_logs` | `actions_get` |
| `get_workflow_run_usage" | `actions_get` |
| `list_project_fields` | `projects_list` |
| `list_project_items` | `projects_list` |
| `list_projects` | `projects_list` |
| `list_workflow_jobs` | `actions_list` |
| `list_workflow_run_artifacts` | `actions_list` |
| `list_workflow_runs` | `actions_list` |
| `list_workflows` | `actions_list` |
| `rerun_failed_jobs` | `actions_run_trigger` |
| `rerun_workflow_run` | `actions_run_trigger` |
| `run_workflow` | `actions_run_trigger` |
| `update_project_item` | `projects_write` |
<!-- END AUTOMATED ALIASES -->
