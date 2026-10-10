# Patch splash ads (cold + hot) and paused-page ad panel.
# ASCII only.

$ErrorActionPreference = 'Stop'
$root = 'E:\nx\bili_decode\apktool'

function Read-Norm($p) {
  $t = [System.IO.File]::ReadAllText($p)
  return $t.Replace("`r`n", "`n")
}
function Write-Norm($p, $t) {
  $t2 = $t.Replace("`n", "`r`n")
  [System.IO.File]::WriteAllText($p, $t2)
}

# ---------- 1) ColdSplashWrapper.a(AppCompatActivity, ViewGroup)Z -> return false ----------
$p1 = Join-Path $root 'smali_classes21\tv\danmaku\bili\splash\shell\ColdSplashWrapper.smali'
$t = Read-Norm $p1
$anchor = '.method public final a(Landroidx/appcompat/app/AppCompatActivity;Landroid/view/ViewGroup;)Z'
$i = $t.IndexOf($anchor)
if ($i -lt 0) { throw 'anchor1 not found' }
$seg = $t.Substring($i, 400)
if ($seg.Contains('ADKILL_COLD_SPLASH')) {
  Write-Host 'SKIP cold splash (already patched)'
} else {
  $loc = $t.IndexOf('.locals', $i)
  $eol = $t.IndexOf("`n", $loc)
  $ins = "`n    const/4 v0, 0x0`n`n    return v0    # ADKILL_COLD_SPLASH`n"
  $t = $t.Substring(0, $eol) + $ins + $t.Substring($eol)
  Write-Norm $p1 $t
  Write-Host 'PATCH cold splash'
}

# ---------- 2) HotSplashActivity.onCreate -> finish + return ----------
$p2 = Join-Path $root 'smali_classes21\tv\danmaku\bili\splash\ad\page\HotSplashActivity.smali'
$t = Read-Norm $p2
$anchor = 'invoke-super {p0, p1}, Lcom/bilibili/lib/spy/generated/a;->onCreate(Landroid/os/Bundle;)V'
$i = $t.IndexOf($anchor)
if ($i -lt 0) { throw 'anchor2 not found' }
$seg = $t.Substring($i, 300)
if ($seg.Contains('ADKILL_HOT_SPLASH')) {
  Write-Host 'SKIP hot splash (already patched)'
} else {
  $eol = $t.IndexOf("`n", $i)
  $ins = "`n    invoke-virtual {p0}, Landroid/app/Activity;->finish()V`n`n    return-void    # ADKILL_HOT_SPLASH`n"
  $t = $t.Substring(0, $eol) + $ins + $t.Substring($eol)
  Write-Norm $p2 $t
  Write-Host 'PATCH hot splash'
}

# ---------- 3) AdPanelRepository.showPanel -> return-void ----------
$p3 = Join-Path $root 'smali_classes14\com\bilibili\ship\theseus\united\page\ad\AdPanelRepository.smali'
$t = Read-Norm $p3
$anchor = '.method public final showPanel(ILcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;)V'
$i = $t.IndexOf($anchor)
if ($i -lt 0) { throw 'anchor3 not found' }
$seg = $t.Substring($i, 900)
if ($seg.Contains('ADKILL_PAUSED_PANEL')) {
  Write-Host 'SKIP paused panel (already patched)'
} else {
  $loc = $t.IndexOf('.locals', $i)
  $eol = $t.IndexOf("`n", $loc)
  $ins = "`n    return-void    # ADKILL_PAUSED_PANEL`n"
  $t = $t.Substring(0, $eol) + $ins + $t.Substring($eol)
  Write-Norm $p3 $t
  Write-Host 'PATCH paused panel'
}

Write-Host 'DONE'
