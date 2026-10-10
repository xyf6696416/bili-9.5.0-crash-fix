$ErrorActionPreference = 'Continue'
$PSNativeCommandUseErrorActionPreference = $false
$adb = 'C:\Users\Administrator\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools\adb.exe'
$d = @('-s','emulator-5554')
$apktool = 'C:\Users\Administrator\Tools\apktool\apktool.bat'
$bt = 'C:\Users\Administrator\Tools\build-tools\android-13'
$java = 'C:\Program Files\Microsoft\jdk-17.0.20.101-hotspot\bin\java.exe'
$ks = 'E:\nx\.dsh\skills\apk-reverse\debug.keystore'
$src = 'E:\nx\bili_decode\apktool'
$rebuilt = 'E:\nx\bili_decode\rebuilt_adblock.apk'
$patched = 'E:\nx\bili_decode\adblock_patched.apk'
$final  = 'E:\nx\bili_decode\adblock_final.apk'

& $apktool b $src -o $rebuilt
if ($LASTEXITCODE -ne 0) { Write-Host "SMALI_BUILD_FAILED"; exit 1 }
python 'E:\nx\bili_repo\scripts\patch_libbili.py' $rebuilt $patched
& "$bt\zipalign.exe" -f -p 4 $patched $final
& $java -jar "$bt\lib\apksigner.jar" sign --ks $ks --ks-pass pass:android --ks-key-alias androiddebugkey --v2-signing-enabled true --v3-signing-enabled true $final
if ($LASTEXITCODE -ne 0) { Write-Host "SIGN_FAILED"; exit 1 }
Write-Host ("BUILT " + (Get-Item $final).Length)
& $adb @d shell am force-stop tv.danmaku.bili
& $adb @d push $final /data/local/tmp/bili_adblock.apk 2>$null | Out-Null
& $adb @d shell pm install -r -t /data/local/tmp/bili_adblock.apk
