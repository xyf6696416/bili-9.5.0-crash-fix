# Insert a card-level ad drop into PegasusGsonParser.e() right after :goto_2.
#   If the parsed card is a BasePegasusData and getAdInfo() != null, log "ADROP <cardType>"
#   and set the return value to null; g() applies CollectionsKt.filterNotNull so the card disappears.
# WARNING: getDataClass() may return null, never call Class->getName() here (NPE kills the whole feed parse).
$ErrorActionPreference = 'Stop'

$parser = 'E:\nx\bili_decode\apktool\smali_classes11\com\bilibili\pegasus\request\PegasusGsonParser.smali'
$guard  = 'E:\nx\bili_decode\apktool\smali_classes23\com\bilibili\adblock\AdBlockGuard.smali'
$enc = New-Object System.Text.UTF8Encoding($false)

# 1) AdBlockGuard.append must be public (cross-class call to a private method -> IllegalAccessError)
$g = [System.IO.File]::ReadAllText($guard)
if ($g.Contains('.method private static append(Ljava/lang/String;)V')) {
    $g = $g.Replace('.method private static append(Ljava/lang/String;)V', '.method public static append(Ljava/lang/String;)V')
    [System.IO.File]::WriteAllText($guard, $g, $enc)
    '[OK] AdBlockGuard.append made public'
} elseif ($g.Contains('.method public static append(Ljava/lang/String;)V')) {
    '[SKIP] append already public'
} else {
    throw 'append method not found'
}

# 2) insert the ADROP branch
$src = [System.IO.File]::ReadAllLines($parser)
$lines = New-Object System.Collections.Generic.List[string]
foreach ($l in $src) { [void]$lines.Add($l) }

$idx = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq ':goto_2') { $idx = $i; break }
}
if ($idx -lt 0) { throw 'label :goto_2 not found' }
if ($lines[$idx + 1].Trim().StartsWith('instance-of v4, p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;')) {
    '[SKIP] ADROP branch already present'
    return
}

$block = @(
    '    instance-of v4, p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;'
    ''
    '    if-eqz v4, :cond_adinfo_ok'
    ''
    '    check-cast p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;'
    ''
    '    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getAdInfo()Lcom/bilibili/adcommon/data/AdInfo;'
    ''
    '    move-result-object v4'
    ''
    '    if-eqz v4, :cond_adinfo_ok'
    ''
    '    new-instance v4, Ljava/lang/StringBuilder;'
    ''
    '    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V'
    ''
    '    const-string v5, "ADROP "'
    ''
    '    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;'
    ''
    '    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getCardType()Ljava/lang/String;'
    ''
    '    move-result-object v5'
    ''
    '    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;'
    ''
    '    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;'
    ''
    '    move-result-object v4'
    ''
    '    invoke-static {v4}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V'
    ''
    '    const/4 p1, 0x0'
    ''
    '    :cond_adinfo_ok'
    ''
)
[void]$lines.InsertRange($idx + 1, [string[]]$block)
[System.IO.File]::WriteAllLines($parser, $lines, $enc)
"[OK] inserted ADROP branch after :goto_2 (line $($idx + 1)), file now $($lines.Count) lines"
