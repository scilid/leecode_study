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