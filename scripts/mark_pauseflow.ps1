# Marker at the top of PausedPageService.startPausedPageFlow bridge (o).
# Proves the pause-triggered ad flow is entered; panel gates must then stay silent.
# ASCII only.
$ErrorActionPreference = 'Stop'
$p = 'E:\nx\bili_decode\apktool\smali_classes14\com\bilibili\ship\theseus\united\page\pausedpage\PausedPageService.smali'
$t = [System.IO.File]::ReadAllText($p).Replace("`r`n", "`n")
if ($t.Contains('PAUSEFLOW')) { Write-Host 'SKIP already marked'; exit 0 }

$hdr = '.method public static final o(Lcom/bilibili/ship/theseus/united/page/pausedpage/PausedPageService;Lcom/bilibili/ship/theseus/united/page/pausedpage/PausedPageService$PauseTriggerSource;)V'
$i = $t.IndexOf($hdr)
if ($i -lt 0) { throw 'anchor missing' }
$loc = $t.IndexOf('.locals', $i)
$eol = $t.IndexOf("`n", $loc)
$ins = "`n    const-string v0, `"PAUSEFLOW`"" + "`n`n    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V`n"
$t = $t.Substring(0, $eol) + $ins + $t.Substring($eol)
[System.IO.File]::WriteAllText($p, $t.Replace("`n", "`r`n"))
Write-Host 'MARK PAUSEFLOW'
