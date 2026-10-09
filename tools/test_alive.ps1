$adb="C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
& $adb shell am force-stop tv.danmaku.bili 2>&1 | Out-Null
Start-Sleep 1
& $adb logcat -c 2>&1 | Out-Null
$log="E:\nx\bili_decode\test_log.txt"
if(Test-Path $log){Remove-Item $log -Force}
$p = Start-Process -FilePath $adb -ArgumentList 'logcat' -RedirectStandardOutput $log -PassThru -WindowStyle Hidden
& $adb shell am start -n "tv.danmaku.bili/.MainActivityV2" 2>&1 | Select-Object -Last 1
for($i=1;$i -le 12;$i++){
  Start-Sleep 5
  $ps = & $adb shell "ps -A" 2>&1 | Out-String
  $line = ($ps -split "`n") | Where-Object { $_ -match '\btv\.danmaku\.bili\s*$' -and $_ -notmatch ':' -and $_ -notmatch '\[' }
  $alive = if($line){ "ALIVE" } else { "DEAD" }
  Write-Host ("t={0}s  {1}" -f ($i*5), $alive)
  if(-not $line){ break }
}
Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
Write-Host "=== logcat 关键行 ==="
Get-Content $log -ErrorAction SilentlyContinue | Select-String -Pattern 'danmaku|Zygote|DEBUG|tombstone|FATAL|AndroidRuntime|exit cleanly|WINDOW DIED' | Select-Object -Last 25 | ForEach-Object { $_.Line }
