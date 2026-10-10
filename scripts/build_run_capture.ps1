$ErrorActionPreference = 'Continue'
& "E:\nx\bili_repo\scripts\build_install_adblock.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "BUILD/INSTALL PROBLEM" }
$adb = 'C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe'
$d = @('-s','emulator-5554')
& $adb @d shell "rm -f /data/data/tv.danmaku.bili/files/adblock_obs.log /data/data/tv.danmaku.bili/files/adblock_alive.txt" | Out-Null
& $adb @d shell am start -n tv.danmaku.bili/.MainActivityV2 | Out-Null
Start-Sleep -Seconds 22
for ($i = 0; $i -lt 5; $i++) { & $adb @d shell input swipe 450 1300 450 400 400 | Out-Null; Start-Sleep -Seconds 3 }
& $adb @d shell input tap 220 900 | Out-Null
Start-Sleep -Seconds 14
& $adb @d shell input keyevent KEYCODE_BACK | Out-Null
Start-Sleep -Seconds 3
& $adb @d shell input tap 375 137 | Out-Null
Start-Sleep -Seconds 4
& $adb @d shell input text "test" | Out-Null
& $adb @d shell input keyevent KEYCODE_ENTER | Out-Null
Start-Sleep -Seconds 12
& $adb @d shell input keyevent KEYCODE_BACK | Out-Null
Start-Sleep -Seconds 3
& $adb @d root | Out-Null
Write-Host "--- files ---"
& $adb @d shell "ls -l /data/data/tv.danmaku.bili/files/adblock_obs.log /data/data/tv.danmaku.bili/files/adblock_alive.txt 2>&1"
& $adb @d shell "cp /data/data/tv.danmaku.bili/files/adblock_obs.log /data/local/tmp/obs.log 2>/dev/null; chmod 644 /data/local/tmp/obs.log 2>/dev/null" | Out-Null
& $adb @d pull /data/local/tmp/obs.log E:\nx\bili_ad\obs.log 2>&1 | Out-Null
if (Test-Path "E:\nx\bili_ad\obs.log") {
    $c = Get-Content "E:\nx\bili_ad\obs.log"
    Write-Host ("obs lines: " + $c.Count)
    Write-Host "--- BLOCK lines ---"
    $c | Select-String "^BLOCK" | Select-Object -First 25
    Write-Host "--- OBS 分类（host+path 前缀） ---"
    $c | Select-String "^OBS" | ForEach-Object { (($_ -replace '^OBS https?://','') -split '\?')[0] } | Group-Object | Sort-Object Count -Descending | Select-Object -First 40 | ForEach-Object { "{0,4}  {1}" -f $_.Count, $_.Name }
} else { Write-Host "no obs.log" }
& $adb @d shell screencap -p /data/local/tmp/shot4.png | Out-Null
& $adb @d pull /data/local/tmp/shot4.png E:\nx\bili_ad\emu_run.png 2>&1 | Out-Null
