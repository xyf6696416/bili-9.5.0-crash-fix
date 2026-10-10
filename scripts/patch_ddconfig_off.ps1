# Force DDConfig ad feature switches to false (official feature flags).
# ASCII only.
$ErrorActionPreference = 'Stop'
$p = 'E:\nx\bili_decode\apktool\smali_classes26\com\bilibili\adcommon\config\DDConfig.smali'
$t = [System.IO.File]::ReadAllText($p).Replace("`r`n", "`n")

$targets = @('getPausePageEnable', 'getVdEndPageKntr', 'getPanelEnableGameWeb')

foreach ($m in $targets) {
  $hdr = '.method public final ' + $m + '()Z'
  $i = $t.IndexOf($hdr)
  if ($i -lt 0) { Write-Host "MISS $m"; continue }
  $end = $t.IndexOf('.end method', $i)
  if ($end -lt 0) { throw "no end method for $m" }
  $body = $t.Substring($i, $end - $i)
  if ($body.Contains('ADKILL_DD_' + $m)) { Write-Host "SKIP $m"; continue }
  $new = $hdr + "`n    .locals 1`n`n    const/4 v0, 0x0    # ADKILL_DD_" + $m + "`n`n    return v0`n"
  $t = $t.Substring(0, $i) + $new + $t.Substring($end)
  Write-Host "OFF $m"
}

[System.IO.File]::WriteAllText($p, $t.Replace("`n", "`r`n"))
Write-Host 'DONE'
