.class public Lcom/bilibili/adblock/AdBlockGuard;
.super Ljava/lang/Object;
.source "AdBlockGuard.java"


# static fields
.field private static final BLOCKS:[Ljava/lang/String;

.field private static final LOGPATH:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    const-string v0, "/data/data/tv.danmaku.bili/files/adblock_obs.log"

    sput-object v0, Lcom/bilibili/adblock/AdBlockGuard;->LOGPATH:Ljava/lang/String;

    const/16 v0, 0x13

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "cm.bilibili.com"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "pre-cm.bilibili.com"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "/x/v2/splash/"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "/x/v2/dm/ad"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "/x/v2/view/ad/"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "/x/v2/ad/"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "/xlive/app-ucenter/v1/ad/"

    aput-object v2, v0, v1

    const/16 v1, 0x7

    const-string v2, "/game/center/h5/small/game/advertising_position"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "/open/open_api/v1/miniapp/client/ad/query"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "/open/open_api/v1/miniapp/ad/position/query"

    aput-object v2, v0, v1

    const/16 v1, 0xa

    const-string v2, "/home/ad/current"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "/x/vip/ads/"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "/pugv/adclick/linkreport"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "/advertising"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "/adclick/"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "/ad_report"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "/cps/src_pkg/list"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "/game/center/h5/user/smallgame/iaa_ad_style_exp"

    aput-object v2, v0, v1

    const/16 v1, 0x12

    const-string v2, "dataflow.biliapi.com"

    aput-object v2, v0, v1

    sput-object v0, Lcom/bilibili/adblock/AdBlockGuard;->BLOCKS:[Ljava/lang/String;

    return-void
.end method

.method private static append(Ljava/lang/String;)V
    .locals 3

    :try_start_a
    new-instance v0, Ljava/io/FileOutputStream;

    sget-object v1, Lcom/bilibili/adblock/AdBlockGuard;->LOGPATH:Ljava/lang/String;

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Ljava/io/FileOutputStream;-><init>(Ljava/lang/String;Z)V

    invoke-virtual {p0}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/io/FileOutputStream;->write([B)V

    const/16 v2, 0xa

    invoke-virtual {v0, v2}, Ljava/io/FileOutputStream;->write(I)V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_a
    .catch Ljava/lang/Throwable; {:try_start_a .. :try_end_a} :ret

    :ret
    return-void
.end method

.method public static obs(Ljava/lang/String;)V
    .locals 2

    if-eqz p0, :cond_obs

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "OBS "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    :cond_obs
    return-void
.end method

.method private static matches(Ljava/lang/String;)Z
    .locals 5

    sget-object v0, Lcom/bilibili/adblock/AdBlockGuard;->BLOCKS:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    :cond_loop
    if-ge v2, v1, :cond_no

    aget-object v3, v0, v2

    invoke-virtual {p0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_inc

    const/4 v4, 0x1

    return v4

    :cond_inc
    add-int/lit8 v2, v2, 0x1

    goto :cond_loop

    :cond_no
    const/4 v4, 0x0

    return v4
.end method

.method private static report(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    return-void
.end method

.method public static guard(Lcom/bilibili/lib/ighttp/IgHttpRequest;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    invoke-virtual {p0}, Lcom/bilibili/lib/ighttp/IgHttpRequest;->url()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_ret

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->matches(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_obs

    const-string v1, "BLOCK "

    invoke-static {v1, v0}, Lcom/bilibili/adblock/AdBlockGuard;->report(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v1, Ljava/io/IOException;

    const-string v2, "ad blocked"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_obs
    const-string v1, "OBS "

    invoke-static {v1, v0}, Lcom/bilibili/adblock/AdBlockGuard;->report(Ljava/lang/String;Ljava/lang/String;)V

    :cond_ret
    return-void
.end method

.method public static guard2(Lokhttp3/Request;)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    invoke-virtual {p0}, Lokhttp3/Request;->url()Lokhttp3/HttpUrl;

    move-result-object v0

    if-eqz v0, :cond_ret2

    invoke-virtual {v0}, Lokhttp3/HttpUrl;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->matches(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_obs2

    const-string v1, "BLOCK "

    invoke-static {v1, v0}, Lcom/bilibili/adblock/AdBlockGuard;->report(Ljava/lang/String;Ljava/lang/String;)V

    new-instance v1, Ljava/io/IOException;

    const-string v2, "ad blocked"

    invoke-direct {v1, v2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_obs2
    const-string v1, "OBS "

    invoke-static {v1, v0}, Lcom/bilibili/adblock/AdBlockGuard;->report(Ljava/lang/String;Ljava/lang/String;)V

    :cond_ret2
    return-void
.end method

.method public static filterItems(Ljava/util/ArrayList;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "*>;)V"
        }
    .end annotation

    if-eqz p0, :cond_fret

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result v0

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "FEED-CALL n="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    const/4 v1, 0x0

    const/4 v4, 0x0

    :cond_floop
    if-ge v1, v0, :cond_fend

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;

    if-eqz v3, :cond_finc

    check-cast v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;

    iget-object v3, v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;->cardType:Ljava/lang/String;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "ITEM "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    iget-boolean v3, v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;->isAd:Z

    const-string v6, " isAd="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    iget-boolean v3, v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;->isAd:Z

    if-eqz v3, :cond_fcb

    add-int/lit8 v4, v4, 0x1

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    add-int/lit8 v0, v0, -1

    goto :cond_floop

    :cond_fcb
    iget-object v2, v2, Lcom/bilibili/pegasus/api/model/BasicIndexItem;->ad_cb:Ljava/lang/String;

    if-eqz v2, :cond_finc

    add-int/lit8 v4, v4, 0x1

    invoke-virtual {p0, v1}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    add-int/lit8 v0, v0, -1

    goto :cond_floop

    :cond_finc
    add-int/lit8 v1, v1, 0x1

    goto :cond_floop

    :cond_fend
    if-lez v4, :cond_fret

    const-string v0, "FEED-FILTER removed="

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    :cond_fret
    return-void
.end method
