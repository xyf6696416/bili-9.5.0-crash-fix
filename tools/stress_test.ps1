$adb="C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$ser="3B15C800RWN00000"
function A([string]$cmd){ & $adb -s $ser shell $cmd 2>&1 }
& $adb -s $ser shell am force-stop tv.danmaku.bili 2>&1 | Out-Null
Start-Sleep 1
& $adb -s $ser logcat -c 2>&1 | Out-Null
$log="E:\nx\bili_decode\stress_log.txt"
if(Test-Path $log){Remove-Item $log -Force}
$p = Start-Process -FilePath $adb -ArgumentList @('-s',$ser,'logcat') -RedirectStandardOutput $log -PassThru -WindowStyle Hidden
A "monkey -p tv.danmaku.bili -c android.intent.category.LAUNCHER 1" | Select-Object -Last 1
$t0 = Get-Date
$dead = $false
for($i=1;$i -le 36;$i++){
  Start-Sleep 5
  if($i % 3 -eq 0){ A "input tap 400 900" | Out-Null }
  if($i % 4 -eq 0){ A "input swipe 500 1600 500 700 300" | Out-Null }
  if($i % 7 -eq 0){ A "input keyevent KEYCODE_BACK" | Out-Null }
  $ps = (A "ps -A") | Out-String
  $main = ($ps -split "`n") | Where-Object { $_ -match 'danmaku' -and $_ -notmatch ':' }
  if(-not $main){ $dead = $true; Write-Host ("t={0}s  DEAD" -f ((Get-Date)-$t0).TotalSeconds); break }
  if($i % 4 -eq 1){ Write-Host ("t={0,3}s  ALIVE  procs={1}" -f ((Get-Date)-$t0).TotalSeconds, (($ps -split "`n") | Where-Object { $_ -match 'danmaku' }).Count) }
}
Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
Write-Host "=== 崩溃指标扫描 ==="
$hits = Get-Content $log -ErrorAction SilentlyContinue | Select-String -Pattern 'exited cleanly|exited due to signal|WINDOW DIED|AndroidRuntime: FATAL|Fatal signal|tombstone|Process crashed'
if($hits){ $hits | Select-Object -First 20 | ForEach-Object { $_.Line } } else { Write-Host "  (无任何崩溃指标)" }
Write-Host "dead=$dead"
