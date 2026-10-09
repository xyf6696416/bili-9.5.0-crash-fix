<#
.SYNOPSIS
    一键构建：打补丁 -> zipalign -> apksigner 签名
.DESCRIPTION
    输入你自己的哔哩哔哩 APK（本仓库不附带原版安装包），输出可直接安装的已签名修复包。
    只修改 lib/arm64-v8a/libbili.so 里的 2 条指令（看门狗线程例程入口 + 唯一的 bl exit），
    不重打包 dex/资源，因此不会引入 apktool 重建类问题。
.EXAMPLE
    .\build.ps1 -InputApk D:\bili\哔哩哔哩.apk.1
    .\build.ps1 -InputApk D:\bili\ bili.apk -ExitOnly
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$InputApk,

    [string]$OutDir = ".",

    # Android build-tools 目录（含 zipalign.exe 与 lib\apksigner.jar）
    [string]$BuildTools = $env:ANDROID_BUILD_TOOLS,

    # 签名用 keystore；不传则自动生成一个临时 debug keystore
    [string]$Keystore = "",
    [string]$KeyAlias = "androiddebugkey",
    [string]$KeyPass  = "android",

    # 只把 bl exit 改成 ret（最小改动），不停用看门狗线程
    [switch]$ExitOnly,

    # 装到已连接的 adb 设备
    [switch]$Install,
    [string]$DeviceSerial = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$patcher  = Join-Path $repoRoot "scripts\patch_libbili.py"

if (-not (Test-Path $InputApk)) { throw "找不到输入 APK: $InputApk" }
if (-not (Test-Path $patcher))  { throw "找不到补丁脚本: $patcher" }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$name  = [IO.Path]::GetFileNameWithoutExtension($InputApk)
$patched = Join-Path $OutDir "$name.patched.apk"
$aligned = Join-Path $OutDir "$name.aligned.apk"
$final   = Join-Path $OutDir "$name.fixed.apk"

Write-Host "[1/4] 打补丁 ..." -ForegroundColor Cyan
$pa = @($patcher, $InputApk, $patched)
if ($ExitOnly) { $pa += "--exit-only" }
& python @pa
if ($LASTEXITCODE -ne 0) { throw "补丁失败" }

# ---------- 定位 zipalign / apksigner ----------
Write-Host "[2/4] 定位 Android build-tools ..." -ForegroundColor Cyan
if (-not $BuildTools) {
    $cands = @(
        "$env:LOCALAPPDATA\Android\Sdk\build-tools",
        "$env:ANDROID_HOME\build-tools",
        "$env:USERPROFILE\Tools\build-tools"
    ) | Where-Object { $_ -and (Test-Path $_) }
    $found = foreach ($c in $cands) {
        Get-ChildItem $c -Recurse -Filter zipalign.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    }
    if (-not $found) {
        throw "未找到 zipalign.exe。请安装 Android build-tools 或用 -BuildTools 指定目录（需含 zipalign.exe 与 lib\apksigner.jar）。"
    }
    $BuildTools = Split-Path -Parent $found.FullName
}
$zipalign   = Join-Path $BuildTools "zipalign.exe"
$apksigner  = Join-Path $BuildTools "lib\apksigner.jar"
if (-not (Test-Path $zipalign))  { throw "缺少 zipalign: $zipalign" }
if (-not (Test-Path $apksigner)) { throw "缺少 apksigner: $apksigner" }
Write-Host "     build-tools = $BuildTools"

Write-Host "[3/4] zipalign ..." -ForegroundColor Cyan
& $zipalign -f -v 4 $patched $aligned | Select-Object -Last 1
if ($LASTEXITCODE -ne 0) { throw "zipalign 失败" }

Write-Host "[4/4] 签名 ..." -ForegroundColor Cyan

function Find-Tool([string]$name, [string[]]$extraBases = @(), [switch]$DirsFirst) {
    if (-not $DirsFirst) {
        $c = Get-Command $name -ErrorAction SilentlyContinue
        if ($c) { return $c.Source }
    }
    $bases = @($env:JAVA_HOME, $env:ANDROID_HOME, "$env:LOCALAPPDATA\Programs",
               "C:\Program Files\Microsoft", "C:\Program Files\Java",
               "C:\Program Files\Eclipse Adoptium", "C:\Program Files\Android",
               "C:\Program Files (x86)\Java") + $extraBases
    $bases = $bases | Where-Object { $_ -and (Test-Path $_) }
    foreach ($base in $bases) {
        $hit = Get-ChildItem $base -Recurse -Depth 4 -Filter "$name.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }
    if ($DirsFirst) {
        $c = Get-Command $name -ErrorAction SilentlyContinue
        if ($c) { return $c.Source }
    }
    return $null
}

# 优先锁定「完整 JDK」（带 keytool 的那一份），避免命中只有 JRE 启动器的 java.exe
$keytool = Find-Tool "keytool" -DirsFirst
$java = $null
if ($keytool) {
    $cand = Join-Path (Split-Path -Parent $keytool) "java.exe"
    if (Test-Path $cand) { $java = $cand }
}
if (-not $java) { $java = Find-Tool "java" }
if (-not $java) { throw "未找到 java：请安装 JDK 17 并加入 PATH，或设置 JAVA_HOME。" }
if (-not $keytool) { $keytool = Find-Tool "keytool" @((Split-Path -Parent $java)) }
if (-not $keytool) { throw "未找到 keytool（JDK 自带）：java 位于 $java，请检查该 JDK 安装是否完整。" }
Write-Host "     java    = $java"
Write-Host "     keytool = $keytool"

if (-not $Keystore) {
    $Keystore = Join-Path $OutDir "debug.keystore"
    if (-not (Test-Path $Keystore)) {
        Write-Host "     生成临时 debug keystore: $Keystore"
        # keytool 把正常信息写到 stderr，这里临时放宽 ErrorActionPreference，避免被当成终止错误
        $prevEAP = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        & $keytool -genkeypair -keystore $Keystore -alias $KeyAlias `
            -keyalg RSA -keysize 2048 -validity 10000 `
            -storepass $KeyPass -keypass $KeyPass `
            -dname "CN=Android Debug,O=Android,C=US" 2>&1 | Out-Null
        $ErrorActionPreference = $prevEAP
        if (-not (Test-Path $Keystore)) { throw "keytool 生成 keystore 失败" }
    }
}
Copy-Item $aligned $final -Force
& $java -jar $apksigner sign --ks $Keystore --ks-key-alias $KeyAlias `
    --ks-pass "pass:$KeyPass" --key-pass "pass:$KeyPass" `
    --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true $final
if ($LASTEXITCODE -ne 0) { throw "apksigner 签名失败" }
& $java -jar $apksigner verify -v $final | Select-Object -First 6

Write-Host ""
Write-Host "完成: $final  ($([math]::Round((Get-Item $final).Length/1MB,1)) MB)" -ForegroundColor Green

if ($Install) {
    Write-Host "[i] 安装到设备 ..." -ForegroundColor Cyan
    $adbCmd = Get-Command adb -ErrorAction SilentlyContinue
    if (-not $adbCmd) {
        $hit = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages","$env:LOCALAPPDATA\Android" `
            -Recurse -Depth 4 -Filter adb.exe -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $hit) { throw "未找到 adb.exe，请安装 Android Platform-Tools。" }
        $adbCmd = $hit.FullName
    } else { $adbCmd = $adbCmd.Source }
    $adbArgs = @("install", "-r", "-t", "--no-streaming", $final)
    if ($DeviceSerial) { $adbArgs = @("-s", $DeviceSerial) + $adbArgs }
    & $adbCmd @adbArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Host "     adb install 失败，改用 push + pm install ..." -ForegroundColor Yellow
        if ($DeviceSerial) { $adbArgs = @("-s", $DeviceSerial) } else { $adbArgs = @() }
        & $adbCmd @($adbArgs + @("push", $final, "/data/local/tmp/bili_fix.apk"))
        & $adbCmd @($adbArgs + @("shell", "pm install -r -t /data/local/tmp/bili_fix.apk"))
    }
    Write-Host "提示: 若签名与已装版本不同，先执行 adb uninstall tv.danmaku.bili"
}
