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