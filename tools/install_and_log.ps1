# 安装重打包 APK 并抓 logcat 用于复现闪退
$adb = "C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe"
$signed = "E:\nx\bili_decode\rebuilt_signed.apk"
$pkg = "tv.danmaku.bili"

# 0) 设备检查
$devs = & $adb devices 2>&1 | Out-String
if ($devs -notmatch 'device$') { Write-Error "没有已连接的 adb 设备，请先开启 USB 调试并连接手机。`n$devs"; exit 1 }

# 1) 清掉旧 log
& $adb logcat -c

# 2) 安装（允许降级/覆盖）
Write-Host "[*] 安装 $signed ..."
& $adb install -r -d $signed 2>&1 | Out-String -Width 300 | Select-Object -Last 5

# 3) 启动主 Activity 并抓崩溃日志
Write-Host "[*] 启动应用 ..."
& $adb shell am start -n "$pkg/com.bilibili.pegasus.web.HotWeeklyWebActivity" 2>&1 | Select-Object -Last 3

Write-Host "[*] 抓取 25 秒 logcat (崩溃栈/AndroidRuntime) ..."
& $adb logcat -d -T 1 *:E AndroidRuntime:E Crashlytics:E DEBUG:E 2>&1 | Out-String -Width 400 | Select-Object -Last 80
