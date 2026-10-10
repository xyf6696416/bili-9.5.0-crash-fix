# Neuter the ad-SDK facing IPanelCallback.showPanel as well (belt and braces).
# ASCII only. Single-quoted anchors to avoid PowerShell $ interpolation.
$ErrorActionPreference = 'Stop'
$p = 'E:\nx\bili_decode\apktool\smali_classes14\com\bilibili\ship\theseus\united\page\ad\AdRepository$a.smali'
$t = [System.IO.File]::ReadAllText($p).Replace("`r`n", "`n")
if ($t.Contains('PANELCB type=')) { Write-Host 'SKIP already patched'; exit 0 }

$cls = 'Lcom/bilibili/ship/theseus/united/page/ad/AdRepository' + '$a'

$old = '.method public final showPanel(ILcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;)V' + "`n    .locals 1"
$new = '.method public final showPanel(ILcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;)V' + "`n    .locals 3"
if (-not $t.Contains($old)) { throw 'anchor1 missing' }
$t = $t.Replace($old, $new)

$anchor = '    .end annotation' + "`n`n    .line 1`n    iget-object v0, p0, " + $cls + ';->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;'
$block = '    .end annotation' + "`n`n    new-instance v0, Ljava/lang/StringBuilder;" + "`n`n    const-string v1, `"PANELCB type=`"" + "`n`n    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V" + "`n`n    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;" + "`n`n    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;" + "`n`n    move-result-object v0" + "`n`n    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V" + "`n`n    return-void    # ADKILL_PAUSED_PANEL_CB" + "`n`n    .line 1`n    iget-object v0, p0, " + $cls + ';->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;'
if (-not $t.Contains($anchor)) { throw 'anchor2 missing' }
$t = $t.Replace($anchor, $block)
[System.IO.File]::WriteAllText($p, $t.Replace("`n", "`r`n"))
Write-Host 'PATCH AdRepository$a.showPanel'
