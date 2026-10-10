$adb = 'C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe'
$d = @('-s','emulator-5554')
& $adb @d logcat -c | Out-Null
& $adb @d shell am force-stop tv.danmaku.bili | Out-Null
Start-Sleep -Seconds 2
& $adb @d shell am start -n tv.danmaku.bili/.MainActivityV2 | Out-Null
Start-Sleep -Seconds 20
for ($i = 0; $i -lt 4; $i++) {
    & $adb @d shell input swipe 450 1300 450 400 400 | Out-Null
    Start-Sleep -Seconds 3
}
& $adb @d shell input tap 220 900 | Out-Null
Start-Sleep -Seconds 15
& $adb @d shell input keyevent KEYCODE_BACK | Out-Null
Start-Sleep -Seconds 3
& $adb @d shell input tap 375 1545 | Out-Null
Start-Sleep -Seconds 8
& $adb @d logcat -d 2>&1 | Select-String -Pattern "BiliAdBlock" | ForEach-Object { ($_.Line -split 'BiliAdBlock\s+')[1] } | Set-Content -Encoding UTF8 "E:\nx\bili_ad\obs.txt"
& $adb @d logcat -d 2>&1 | Select-String -Pattern "FATAL EXCEPTION|VerifyError|adblock" | Select-Object -First 12 | ForEach-Object { "ERR " + $_.Line.Substring(0,[Math]::Min(200,$_.Line.Length)) } | Set-Content -Encoding UTF8 "E:\nx\bili_ad\err.txt"
& $adb @d shell screencap -p /data/local/tmp/shot3.png | Out-Null
& $adb @d pull /data/local/tmp/shot3.png E:\nx\bili_ad\emu_after.png | Out-Null
Write-Host ("OBS lines: " + (Get-Content "E:\nx\bili_ad\obs.txt" | Measure-Object -Line).Lines)
Write-Host ("ERR lines: " + (Get-Content "E:\nx\bili_ad\err.txt" | Measure-Object -Line).Lines)
