$p = "E:\nx\bili_decode\apktool\smali_classes11\com\bilibili\pegasus\request\PegasusGsonParser.smali"
$t = [System.IO.File]::ReadAllText($p)

$anchor = "iget-boolean v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->d:Z"
"anchor occ: " + ([regex]::Matches($t, [regex]::Escape($anchor)).Count)
$i = $t.IndexOf($anchor)

$nl = "`r`n"
$b = ""
$b += "instance-of v4, p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;" + $nl + $nl
$b += "    if-eqz v4, :cond_adinfo_ok" + $nl + $nl
$b += "    check-cast p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;" + $nl + $nl
$b += "    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getAdInfo()Lcom/bilibili/adcommon/data/AdInfo;" + $nl + $nl
$b += "    move-result-object v4" + $nl + $nl
$b += "    if-eqz v4, :cond_adinfo_ok" + $nl + $nl
$b += "    new-instance v4, Ljava/lang/StringBuilder;" + $nl + $nl
$b += "    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V" + $nl + $nl
$b += '    const-string v5, "ADROP "' + $nl + $nl
$b += "    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;" + $nl + $nl
$b += "    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getCardType()Ljava/lang/String;" + $nl + $nl
$b += "    move-result-object v5" + $nl + $nl
$b += "    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;" + $nl + $nl
$b += "    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;" + $nl + $nl
$b += "    move-result-object v4" + $nl + $nl
$b += "    invoke-static {v4}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V" + $nl + $nl
$b += "    const/4 v1, 0x0" + $nl + $nl
$b += "    goto/16 :goto_4" + $nl + $nl
$b += "    :cond_adinfo_ok" + $nl + $nl

$t2 = $t.Substring(0, $i) + $b + $t.Substring($i)
[System.IO.File]::WriteAllText($p, $t2)

Select-String -Path $p -Pattern 'AdBlockGuard|:cond_adinfo_ok|:cond_ad_ok|:goto_4|\.locals' | ForEach-Object {
    "L" + $_.LineNumber + ": " + $_.Line.Trim()
}
