$ErrorActionPreference = 'Stop'
$path = 'E:\nx\bili_decode\apktool\smali_classes11\com\bilibili\pegasus\request\PegasusGsonParser.smali'
$txt = [System.IO.File]::ReadAllText($path)
$nl = "`r`n"
if ($txt -notmatch "`r`n") { $nl = "`n" }

# --- 1) AdInfo==null 不再直接放行，改为跳到 :cond_noad 记录 NOAD ---
$anchor1 = 'move-result-object v4' + $nl + $nl + '    if-eqz v4, :cond_adinfo_ok'
$i1 = $txt.IndexOf($anchor1)
if ($i1 -lt 0) { throw 'anchor1 not found' }
if ($txt.IndexOf($anchor1, $i1 + 1) -ge 0) { throw 'anchor1 not unique' }
$txt = $txt.Substring(0, $i1) + ('move-result-object v4' + $nl + $nl + '    if-eqz v4, :cond_noad') + $txt.Substring($i1 + $anchor1.Length)

# --- 2) 在 :cond_adinfo_ok 定义前插入 NOAD 记录块 ---
$anchor2 = $nl + '    :cond_adinfo_ok' + $nl
$i2 = $txt.IndexOf($anchor2)
if ($i2 -lt 0) { throw 'anchor2 not found' }
if ($txt.IndexOf($anchor2, $i2 + 1) -ge 0) { throw 'anchor2 not unique' }

$block = $nl + '    :cond_noad' + $nl
$block += '    new-instance v4, Ljava/lang/StringBuilder;' + $nl + $nl
$block += '    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V' + $nl + $nl
$block += '    const-string v5, "NOAD "' + $nl + $nl
$block += '    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;' + $nl + $nl
$block += '    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getCardType()Ljava/lang/String;' + $nl + $nl
$block += '    move-result-object v5' + $nl + $nl
$block += '    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;' + $nl + $nl
$block += '    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;' + $nl + $nl
$block += '    move-result-object v4' + $nl + $nl
$block += '    invoke-static {v4}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V' + $nl
$block += '    :cond_adinfo_ok' + $nl

$txt = $txt.Substring(0, $i2) + $block + $txt.Substring($i2 + $anchor2.Length)

[System.IO.File]::WriteAllText($path, $txt)
Write-Host 'patched NOAD logging OK'
Select-String -Path $path -Pattern 'cond_noad|NOAD |ADROP |cond_adinfo_ok' | ForEach-Object { "{0}: {1}" -f $_.LineNumber, $_.Line.Trim() }
