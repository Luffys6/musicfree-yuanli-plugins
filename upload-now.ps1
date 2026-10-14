# 当前目录即仓库根目录
$username = "Luffys6"
$repo = "musicfree-yuanli-plugins"
$baseUrl = "https://13413.kstore.vip/yuanli"
$files = @("wy.js", "kw.js", "kg.js", "qq.js", "xiaomi.js")

Write-Host "当前目录: $(Get-Location)" -ForegroundColor Cyan

# 1. 下载所有 JS 文件
foreach ($file in $files) {
    $url = "$baseUrl/$file"
    Write-Host "下载 $file ..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
        Write-Host "  ✓ $file ($(Get-Item $file).Length bytes)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ $file 失败: $_" -ForegroundColor Red
    }
}

# 2. 生成 yuanli.json
$json = @{
    plugins = @(
        @{ name = "网易"; url = "https://cdn.jsdelivr.net/gh/$username/$repo@main/wy.js"; version = "1.2.1" }
        @{ name = "酷我"; url = "https://cdn.jsdelivr.net/gh/$username/$repo@main/kw.js"; version = "1.2.1" }
        @{ name = "酷狗"; url = "https://cdn.jsdelivr.net/gh/$username/$repo@main/kg.js"; version = "1.2.1" }
        @{ name = "QQ"; url = "https://cdn.jsdelivr.net/gh/$username/$repo@main/qq.js"; version = "1.2.1" }
        @{ name = "bilibili"; url = "https://gitee.com/maotoumao/MusicFreePlugins/raw/v0.1/dist/bilibili/index.js"; version = "0.1.0" }
        @{ name = "小米"; url = "https://cdn.jsdelivr.net/gh/$username/$repo@main/xiaomi.js"; version = "1.2.1" }
    )
} | ConvertTo-Json -Depth 4
$json | Out-File -Encoding utf8 "yuanli.json"
Write-Host "`n生成 yuanli.json 完成" -ForegroundColor Green

# 3. 提交推送
Write-Host "`n检查 Git 状态..." -ForegroundColor Yellow
git status

Write-Host "`n添加文件..." -ForegroundColor Yellow
git add .

Write-Host "`n提交..." -ForegroundColor Yellow
git commit -m "Add yuanli plugins $(Get-Date -Format 'yyyy-MM-dd HH:mm')"

Write-Host "`n推送到 GitHub..." -ForegroundColor Yellow
git push origin main

Write-Host "`n完成！等 1-2 分钟 jsDelivr 缓存后可用：" -ForegroundColor Cyan
Write-Host "https://cdn.jsdelivr.net/gh/$username/$repo@main/yuanli.json" -ForegroundColor Cyan