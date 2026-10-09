$ErrorActionPreference = 'Stop'
$adb = "C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$xz  = "$env:USERPROFILE\Downloads\frida-server.xz"
$bin = "$env:USERPROFILE\Downloads\frida-server"
$dev = "/data/local/tmp/android-services"   # 伪装名，规避 frida 特征扫描
$port = 44444

# 解压 xz
if (-not (Test-Path $bin)) {
    Write-Host "[*] 解压 xz"
    & "C:\Windows\System32\tar.exe" -xf $xz -C "$env:USERPROFILE\Downloads"
    Get-ChildItem "$env:USERPROFILE\Downloads" -Filter "frida-server*" | Select-Object Name, Length
}

Write-Host "[*] push"
& $adb push $bin $dev | Select-Object -Last 2
& $adb shell "su -c 'chmod 755 $dev'"

Write-Host "[*] 启动 frida-server (port $port)"
& $adb shell "su -c '$dev -l 0.0.0.0:$port -D'" 2>&1 | Select-Object -Last 3
Start-Sleep 3

Write-Host "[*] 检查进程"
& $adb shell "su -c 'ps -A'" 2>&1 | Select-String "android-services" | Select-Object -First 3 | ForEach-Object { $_.Line.Trim() }

Write-Host "[*] adb forward"
& $adb forward tcp:$port tcp:$port
