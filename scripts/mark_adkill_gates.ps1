# Add obs-log markers to the ADKILL gates so we can prove the code paths fired.
# ASCII only.
$ErrorActionPreference = 'Stop'
$root = 'E:\nx\bili_decode\apktool'

function Load($p) { [System.IO.File]::ReadAllText($p).Replace("`r`n", "`n") }
function Save($p, $t) { [System.IO.File]::WriteAllText($p, $t.Replace("`n", "`r`n")) }

# --- ColdSplashWrapper.a() ---
$p = Join-Path $root 'smali_classes21\tv\danmaku\bili\splash\shell\ColdSplashWrapper.smali'
$t = Load $p
$old = "    const/4 v0, 0x0`n`n    return v0    # ADKILL_COLD_SPLASH"
$new = "    const-string v0, `"SPLASHCOLD suppressed`"`n`n    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V`n`n    const/4 v0, 0x0`n`n    return v0    # ADKILL_COLD_SPLASH"
if ($t.Contains('SPLASHCOLD suppressed')) { Write-Host 'SKIP cold marker' }
elseif ($t.Contains($old)) { Save $p ($t.Replace($old, $new)); Write-Host 'MARK cold' }
else { throw 'cold anchor missing' }

# --- AdPanelRepository.showPanel() ---
$p = Join-Path $root 'smali_classes14\com\bilibili\ship\theseus\united\page\ad\AdPanelRepository.smali'
$t = Load $p
$old = "    return-void    # ADKILL_PAUSED_PANEL"
$new = "    new-instance v0, Ljava/lang/StringBuilder;`n`n    const-string v1, `"PANELSUP type=`"`n`n    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V`n`n    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;`n`n    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;`n`n    move-result-object v0`n`n    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V`n`n    return-void    # ADKILL_PAUSED_PANEL"
if ($t.Contains('PANELSUP type=')) { Write-Host 'SKIP panel marker' }
elseif ($t.Contains($old)) { Save $p ($t.Replace($old, $new)); Write-Host 'MARK panel' }
else { throw 'panel anchor missing' }

Write-Host 'DONE'
