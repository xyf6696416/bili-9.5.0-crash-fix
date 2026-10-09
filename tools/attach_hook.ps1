$ErrorActionPreference = 'Continue'
$adb  = "C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$pkg  = "tv.danmaku.bili"
$js   = "E:\nx\bili_decode\hook_antisuicide.js"
$out  = "E:\nx\bili_decode\hook_out.txt"

if (Test-Path $out) { Remove-Item $out -Force }

& $adb shell am force-stop $pkg | Out-Null
Start-Sleep -Seconds 2
& $adb shell am start -n "$pkg/.MainActivityV2" | Out-Null

$mainPid = $null
for ($i = 0; $i -lt 25; $i++) {
    $lines = & $adb shell ps -A 2>$null | Select-String "tv\.danmaku\.bili"
    foreach ($l in $lines) {
        $t = $l.Line.Trim()
        if ($t -notmatch ':' -and $t -notmatch '\[') {
            $cols = $t -split '\s+'
            $mainPid = $cols[1]
            break
        }
    }
    if ($mainPid) { break }
    Start-Sleep -Milliseconds 250
}

Write-Host "MAIN_PID=$mainPid"
if (-not $mainPid) { Write-Host "pid not found"; exit 2 }

& frida -H 127.0.0.1:44444 -p $mainPid -l $js -t 60 2>&1 | Out-File -Encoding utf8 $out
