# Git MCP Server 使用演示

本文件演示了如何使用git mcp server执行常见的git操作。

## 可用的Git MCP命令

1. `mcp_git_git_status` - 查看仓库状态
2. `mcp_git_git_add` - 添加文件到暂存区
3. `mcp_git_git_commit` - 提交更改
4. `mcp_git_git_log` - 查看提交历史
5. `mcp_git_git_create_branch` - 创建新分支
6. `mcp_git_git_checkout` - 切换分支
7. `mcp_git_git_diff` - 查看更改
8. `mcp_git_git_diff_staged` - 查看暂存区的更改
9. `mcp_git_git_diff_unstaged` - 查看未暂存的更改

## 使用示例

```python
# 查看状态
mcp_git_git_status(repo_path=".")

# 添加文件
mcp_git_git_add(repo_path=".", files=["file1.txt", "file2.txt"])

# 提交更改
mcp_git_git_commit(repo_path=".", message="Add new files")

# 创建分支
mcp_git_git_create_branch(repo_path=".", branch_name="feature/new-feature")

# 切换分支
mcp_git_git_checkout(repo_path=".", branch_name="feature/new-feature")
```

## 优势

1. 统一的接口
2. 更好的错误处理
3. 集成到自动化流程
4. 跨平台兼容性
5. 可扩展性

## 注意事项

1. 所有路径参数都应该使用相对于仓库根目录的路径
2. 文件列表应该使用数组格式
3. 确保提供所有必需的参数
4. 注意检查返回的错误信息

## 常见问题解决

1. 如果文件没有被正确添加，检查文件路径是否正确
2. 如果提交失败，确保已经添加了文件到暂存区
3. 如果推送失败，检查是否有正确的权限和远程仓库设置

## 文件操作问题解决方案

在Windows环境下处理文件编辑时，可能会遇到权限或编码问题。以下是解决步骤：

1. 检查文件权限：
```powershell
Get-Acl notes/git_mcp_demo.md | Format-List
```
这个命令会显示文件的访问控制列表（ACL），包括所有者和权限信息。

2. 确保目录存在：
```powershell
if (-not (Test-Path notes)) { New-Item -ItemType Directory -Path notes -Force }
```
这个命令会检查目录是否存在，如果不存在则创建它。

3. 创建或更新文件：
```powershell
New-Item -Path notes/git_mcp_demo.md -ItemType File -Force
```
使用`-Force`参数可以确保即使文件存在也能正常操作。

4. 写入文件内容：
可以使用以下几种方法：
- `Set-Content`: 覆盖整个文件内容
- `Add-Content`: 追加内容到文件
- `Out-File`: 使用特定编码（如UTF8）写入文件

示例：
```powershell
Set-Content -Path notes/git_mcp_demo.md -Value "内容" -Encoding UTF8
```

注意事项：
- 在处理中文内容时，建议使用UTF8编码
- 使用`-Force`参数可以绕过一些常见的权限问题
- 如果遇到权限问题，可以检查文件是否被其他程序占用
- 建议先用小段内容测试文件写入，确认成功后再写入完整内容
