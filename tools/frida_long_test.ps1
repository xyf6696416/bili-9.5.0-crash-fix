$adb="C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$ser="3B15C800RWN00000"
function A([string]$cmd){ & $adb -s $ser shell $cmd 2>&1 }
& $adb -s $ser shell am force-stop tv.danmaku.bili 2>&1 | Out-Null
& $adb -s $ser logcat -c 2>&1 | Out-Null
Start-Sleep 1
$log="E:\nx\bili_decode\frida_long_log.txt"; $fout="E:\nx\bili_decode\frida_long.txt"
if(Test-Path $log){Remove-Item $log -Force}
if(Test-Path $fout){Remove-Item $fout -Force}
$lc = Start-Process -FilePath $adb -ArgumentList @('-s',$ser,'logcat') -RedirectStandardOutput $log -PassThru -WindowStyle Hidden
$fr = Start-Process -FilePath "frida" -ArgumentList '-H','127.0.0.1:44444','-f','tv.danmaku.bili','-l','E:\nx\bili_decode\hook_min.js','-t','120' -RedirectStandardOutput $fout -RedirectStandardError "$fout.err" -PassThru -WindowStyle Hidden
$dead=$false
for($i=1;$i -le 30;$i++){
  Start-Sleep 5
  $ps = (A "ps -A") | Out-String
  $main = ($ps -split "`n") | Where-Object { $_ -match 'danmaku' -and $_ -notmatch ':' }
  if(-not $main){ $dead=$true; Write-Host ("t={0}s DEAD" -f ($i*5)); break }
  if($i % 3 -eq 1){ Write-Host ("t={0,3}s ALIVE procs={1}" -f ($i*5), (($ps -split "`n") | Where-Object { $_ -match 'danmaku' }).Count) }
}
Write-Host "=== frida 输出 ==="
Get-Content $fout -ErrorAction SilentlyContinue | Select-Object -Skip 12 | Select-Object -First 15 | ForEach-Object { $_.ToString() }
Write-Host "=== 崩溃指标 ==="
Get-Content $log -ErrorAction SilentlyContinue | Select-String -Pattern 'Fatal signal|exited due to signal|exited cleanly|WINDOW DIED|FATAL EXCEPTION|Process crashed' | Select-Object -First 12 | ForEach-Object { $_.Line }
Write-Host "dead=$dead"
Stop-Process -Id $lc.Id -Force -ErrorAction SilentlyContinue
Stop-Process -Id $fr.Id -Force -ErrorAction SilentlyContinue
