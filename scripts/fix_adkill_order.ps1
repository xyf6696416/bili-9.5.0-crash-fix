# Move ADKILL instruction lines below the .param/.annotation blocks (smali ordering safety).
# ASCII only.
$ErrorActionPreference = 'Stop'
$root = 'E:\nx\bili_decode\apktool'

function Fix-AfterAnnotations($path, $marker, $block) {
  $t = [System.IO.File]::ReadAllText($path).Replace("`r`n", "`n")
  $i = $t.IndexOf($marker)
  if ($i -lt 0) { Write-Host "MISS $marker in $path"; return }
  # remove the block text
  $j = $t.IndexOf($block)
  if ($j -lt 0) { Write-Host "MISS BLOCK in $path"; return }
  $t2 = $t.Remove($j, $block.Length)
  # find first ".line 1" after the method header
  $k = $t2.IndexOf('.line 1', $j)
  if ($k -lt 0) { Write-Host "MISS .line 1 in $path"; return }
  $t2 = $t2.Insert($k, $block.TrimStart("`n") + "`n")
  [System.IO.File]::WriteAllText($path, $t2.Replace("`n", "`r`n"))
  Write-Host "MOVED $marker in $path"
}

Fix-AfterAnnotations (Join-Path $root 'smali_classes21\tv\danmaku\bili\splash\shell\ColdSplashWrapper.smali') 'ADKILL_COLD_SPLASH' "    const/4 v0, 0x0`n`n    return v0    # ADKILL_COLD_SPLASH`n`n"
Fix-AfterAnnotations (Join-Path $root 'smali_classes14\com\bilibili\ship\theseus\united\page\ad\AdPanelRepository.smali') 'ADKILL_PAUSED_PANEL' "    return-void    # ADKILL_PAUSED_PANEL`n`n"
