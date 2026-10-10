$p = "E:\nx\bili_decode\apktool\smali_classes11\com\bilibili\pegasus\request\PegasusGsonParser.smali"
$t = [System.IO.File]::ReadAllText($p)

$a0 = ".method public final e(LVP0/a;)Ljava/lang/Object;`r`n    .locals 4`r`n"
"anchor0 occ: " + ([regex]::Matches($t, [regex]::Escape($a0)).Count)
$t = $t.Replace($a0, ".method public final e(LVP0/a;)Ljava/lang/Object;`r`n    .locals 6`r`n")

$a1 = "invoke-interface {v3}, Lcom/bilibili/pegasus/PegasusHolderInfo;->getDataClass()Ljava/lang/Class;"
"anchor1 occ: " + ([regex]::Matches($t, [regex]::Escape($a1)).Count)
$i = $t.IndexOf($a1)
$g = $t.IndexOf("goto :goto_0", $i)
"goto idx: $g"

$nl = "`r`n"
$block = ""
$block += "invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;" + $nl + $nl
$block += "    move-result-object v4" + $nl + $nl
$block += "    invoke-static {v4}, Lcom/bilibili/adblock/AdBlockGuard;->obs(Ljava/lang/String;)V" + $nl + $nl
$block += '    const-string v5, "com.bilibili.ad."' + $nl + $nl
$block += "    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z" + $nl + $nl
$block += "    move-result v5" + $nl + $nl
$block += "    if-eqz v5, :cond_ad_ok" + $nl + $nl
$block += "    const/4 v1, 0x0" + $nl + $nl
$block += "    goto/16 :goto_4" + $nl + $nl
$block += "    :cond_ad_ok" + $nl + $nl

$t2 = $t.Substring(0, $g) + $block + $t.Substring($g)
[System.IO.File]::WriteAllText($p, $t2)

Select-String -Path $p -Pattern 'AdBlockGuard|\.locals|:cond_ad_ok|:goto_4' | ForEach-Object {
    "L" + $_.LineNumber + ": " + $_.Line.Trim()
}
