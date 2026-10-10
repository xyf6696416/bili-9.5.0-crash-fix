$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$root = 'E:\nx\bili_decode\apktool'

function Remove-Probe([string]$path, [int]$window) {
  $L = [System.IO.File]::ReadAllLines($path, [System.Text.Encoding]::UTF8)
  $drop = New-Object 'System.Collections.Generic.HashSet[int]'
  for ($i = 0; $i -lt $L.Length; $i++) {
    if ($L[$i] -match 'AdBlockGuard;->obs\(') {
      for ($j = ($i - $window); $j -le $i; $j++) { if ($j -ge 0) { [void]$drop.Add($j) } }
    }
  }
  if ($drop.Count -eq 0) { Write-Host ("  no obs probe: " + $path); return }
  $new = New-Object System.Collections.Generic.List[string]
  for ($i = 0; $i -lt $L.Length; $i++) {
    if ($drop.Contains($i)) { continue }
    if ($L[$i].Trim().StartsWith('# adblock:')) { continue }
    $new.Add($L[$i])
  }
  [System.IO.File]::WriteAllLines($path, $new, $enc)
  Write-Host ("  dropped " + $drop.Count + " lines: " + $path.Replace($root, ''))
}

function Remove-Call([string]$path, [string]$pattern) {
  $L = [System.IO.File]::ReadAllLines($path, [System.Text.Encoding]::UTF8)
  $new = New-Object System.Collections.Generic.List[string]
  $n = 0
  foreach ($x in $L) { if ($x -match $pattern) { $n++ } else { $new.Add($x) } }
  [System.IO.File]::WriteAllLines($path, $new, $enc)
  Write-Host ("  removed " + $n + " call lines: " + $path.Replace($root, ''))
}

Remove-Probe (Join-Path $root 'smali_classes10\com\bilibili\lib\moss\api\KMossServiceImp.smali') 5
Remove-Probe (Join-Path $root 'smali_classes19\kntr\base\net\comm\imp\u$a.smali') 2
Remove-Probe (Join-Path $root 'smali_classes11\com\bilibili\pegasus\request\PegasusResponseTypeAdapter.smali') 2
Remove-Probe (Join-Path $root 'smali_classes10\com\bilibili\lib\ighttp\IgHttpEngine.smali') 1
Remove-Call  (Join-Path $root 'smali_classes11\com\bilibili\pegasus\api\g.smali') 'AdBlockGuard;->filterItems'
Remove-Call  (Join-Path $root 'smali_classes11\com\bilibili\pegasus\api\E.smali') 'AdBlockGuard;->filterItems'

$ic = Join-Path $root 'smali_classes23\com\bilibili\adblock\AdBlockInterceptor.smali'
if (Test-Path $ic) { Remove-Item $ic -Force; Write-Host 'removed AdBlockInterceptor.smali' }

Write-Host 'cleanup done'
