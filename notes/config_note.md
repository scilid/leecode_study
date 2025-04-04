# MCP 配置说明

本文档说明了 MCP 相关的配置事项，包括代理设置、环境变量等。

## 代理配置

### 配置文件和脚本

在 `config` 目录下提供了以下文件来简化代理配置：

1. `proxy.json` - 代理配置文件：
```json
{
    "http_proxy": "http://127.0.0.1:7890",
    "https_proxy": "http://127.0.0.1:7890",
    "no_proxy": "localhost,127.0.0.1"
}
```
这个文件存储了代理服务器的配置信息，可以根据实际情况修改代理地址和端口。

2. `setup_proxy.ps1` - 设置代理的 PowerShell 脚本：
```powershell
# 从配置文件读取代理设置
$config = Get-Content -Path "$PSScriptRoot\proxy.json" | ConvertFrom-Json

# 设置系统代理
$env:HTTP_PROXY = $config.http_proxy
$env:HTTPS_PROXY = $config.https_proxy

# 设置Git代理
git config --global http.proxy $config.http_proxy
git config --global https.proxy $config.https_proxy

# 设置npm代理
npm config set proxy $config.http_proxy
npm config set https-proxy $config.https_proxy

Write-Host "代理设置已完成：" -ForegroundColor Green
Write-Host "HTTP_PROXY: $env:HTTP_PROXY" -ForegroundColor Cyan
Write-Host "HTTPS_PROXY: $env:HTTPS_PROXY" -ForegroundColor Cyan
```
这个脚本会：
- 读取 proxy.json 中的配置
- 设置系统环境变量
- 配置 Git 全局代理
- 配置 npm 代理
- 显示设置结果

3. `remove_proxy.ps1` - 移除代理的 PowerShell 脚本：
```powershell
# 移除系统代理
Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue

# 移除Git代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 移除npm代理
npm config delete proxy
npm config delete https-proxy

Write-Host "代理设置已移除" -ForegroundColor Green
```
这个脚本会：
- 移除系统环境变量中的代理设置
- 移除 Git 全局代理配置
- 移除 npm 代理配置
- 显示操作完成信息

### 使用方法

1. 设置代理：
```powershell
# 进入配置目录
cd config

# 根据需要修改 proxy.json 中的代理地址和端口

# 运行设置脚本
.\setup_proxy.ps1
```

2. 移除代理：
```powershell
# 进入配置目录
cd config

# 运行移除脚本
.\remove_proxy.ps1
```

3. 验证代理设置：
```powershell
# 检查环境变量
echo $env:HTTP_PROXY
echo $env:HTTPS_PROXY

# 检查 Git 配置
git config --global --get http.proxy
git config --global --get https.proxy

# 检查 npm 配置
npm config get proxy
npm config get https-proxy
```

### HTTP/HTTPS 代理设置

1. 系统环境变量方式：
```bash
# Windows PowerShell
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"

# Linux/Mac
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"
```

2. Git 配置方式：
```bash
# 设置全局代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890

# 取消全局代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 查看当前代理设置
git config --global --get http.proxy
git config --global --get https.proxy
```

3. npm 配置方式：
```bash
# 设置代理
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890

# 取消代理
npm config delete proxy
npm config delete https-proxy
```

### 常见问题解决

1. 代理无法连接：
- 检查代理服务器是否正常运行
- 验证代理地址和端口是否正确
- 测试代理连接：`curl -x http://127.0.0.1:7890 https://www.google.com`

2. SSL证书问题：
```bash
# Git 忽略 SSL 证书验证（不推荐在生产环境使用）
git config --global http.sslVerify false
```

3. 网络超时：
- 增加超时时间：
```bash
git config --global http.lowSpeedLimit 1000
git config --global http.lowSpeedTime 300
```

## 环境变量配置

### 必需的环境变量

1. `MCP_HOME`: MCP 安装目录
```bash
# Windows PowerShell
$env:MCP_HOME = "C:\path\to\mcp"

# Linux/Mac
export MCP_HOME="/path/to/mcp"
```

2. `PYTHONPATH`: Python 模块搜索路径
```bash
# Windows PowerShell
$env:PYTHONPATH = "$env:MCP_HOME\lib;$env:PYTHONPATH"

# Linux/Mac
export PYTHONPATH="$MCP_HOME/lib:$PYTHONPATH"
```

### 可选的环境变量

1. `MCP_CONFIG`: 配置文件路径
```bash
# Windows PowerShell
$env:MCP_CONFIG = "C:\path\to\config.yaml"

# Linux/Mac
export MCP_CONFIG="/path/to/config.yaml"
```

2. `MCP_LOG_LEVEL`: 日志级别
```bash
# 设置日志级别（DEBUG, INFO, WARNING, ERROR）
$env:MCP_LOG_LEVEL = "DEBUG"
```

## 配置文件说明

MCP 支持通过 YAML 文件进行配置，默认配置文件为 `config.yaml`：

```yaml
proxy:
  http: http://127.0.0.1:7890
  https: http://127.0.0.1:7890
  no_proxy: localhost,127.0.0.1

git:
  user:
    name: Your Name
    email: your.email@example.com
  core:
    editor: vim
    autocrlf: true

log:
  level: INFO
  file: mcp.log
```

## 最佳实践

1. 代理设置
- 优先使用系统环境变量设置代理
- 对于特定工具，可以单独配置代理
- 在不需要时及时关闭代理

2. 环境变量
- 将常用的环境变量设置添加到启动脚本中
- 使用相对路径而不是硬编码的绝对路径
- 注意环境变量的优先级

3. 配置文件
- 保持配置文件的整洁和有序
- 使用注释说明配置项的用途
- 定期备份配置文件

4. 安全性
- 不要在配置文件中存储敏感信息
- 定期更新和检查配置
- 使用环境变量存储敏感信息 