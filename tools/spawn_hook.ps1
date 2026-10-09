$ErrorActionPreference = 'Continue'
$adb = "C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$pkg = "tv.danmaku.bili"
$js  = $args[0]
$out = $args[1]

if (Test-Path $out) { Remove-Item $out -Force }
& $adb shell am force-stop $pkg | Out-Null
Start-Sleep -Seconds 2

& frida -H 127.0.0.1:44444 -f $pkg -l $js -t 120 2>&1 | Out-File -Encoding utf8 $out
