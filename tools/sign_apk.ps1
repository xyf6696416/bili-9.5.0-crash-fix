# 对齐 + apksigner 签名（v1+v2+v3），用于 bilibili 重打包后安装
$ErrorActionPreference = 'Stop'
$java = "C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot\bin\java.exe"
$zipalign = "$env:USERPROFILE\Tools\build-tools\android-13\zipalign.exe"
$apksigner = "$env:USERPROFILE\Tools\build-tools\android-13\lib\apksigner.jar"
$ks = "E:\nx\.dsh\skills\apk-reverse\debug.keystore"
$ksPass = "android"
$alias = "androiddebugkey"

$unsigned = "E:\nx\bili_decode\rebuilt_unsigned.apk"
$aligned  = "E:\nx\bili_decode\rebuilt_aligned.apk"
$signed   = "E:\nx\bili_decode\rebuilt_signed.apk"

if (-not (Test-Path $unsigned)) { Write-Error "未找到未签名 APK: $unsigned"; exit 1 }

# 1) 对齐
& $zipalign -p 4 $unsigned $aligned
if (-not (Test-Path $aligned)) { Write-Error "zipalign 失败"; exit 1 }
Write-Host "[*] aligned -> $aligned"

# 2) 签名（v1 v2 v3 全开）
& $java -jar $apksigner sign --ks $ks --ks-key-alias $alias --ks-pass pass:$ksPass --key-pass pass:$ksPass --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true --out $signed $aligned
if (-not (Test-Path $signed)) { Write-Error "apksigner 失败"; exit 1 }

# 3) 校验
& $java -jar $apksigner verify -v $signed

Write-Host "[*] signed -> $signed ($([math]::Round((Get-Item $signed).Length/1MB,1)) MB)"
