.class public final Lcom/bilibili/pegasus/request/PegasusGsonParser;
.super Lcom/google/gson/TypeAdapter;
.source "BL"


# annotations
.annotation build Landroidx/compose/runtime/internal/StabilityInferred;
    parameters = 0x0
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/google/gson/TypeAdapter<",
        "Lcom/bilibili/pegasus/PegasusHolderData;",
        ">;"
    }
.end annotation


# instance fields
.field public final a:LDr0/b;
    .annotation build Lorg/jetbrains/annotations/NotNull;
    .end annotation
.end field

.field public final b:Lkotlin/Lazy;
    .annotation build Lorg/jetbrains/annotations/NotNull;
    .end annotation
.end field

.field public final c:Lkotlin/Lazy;
    .annotation build Lorg/jetbrains/annotations/NotNull;
    .end annotation
.end field

.field public d:Z

.field public final e:Lcom/google/gson/Gson;


# direct methods
.method public constructor <init>(LDr0/b;Lcom/google/gson/GsonBuilder;)V
    .locals 1
    .param p1    # LDr0/b;
        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param
    .param p2    # Lcom/google/gson/GsonBuilder;
        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param

    .line 1
    invoke-direct {p0}, Lcom/google/gson/TypeAdapter;-><init>()V

    .line 2
    .line 3
    .line 4
    iput-object p1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->a:LDr0/b;

    .line 5
    .line 6
    new-instance p1, LS01/e;

    .line 7
    .line 8
    const/4 v0, 0x4

    .line 9
    invoke-direct {p1, v0}, LS01/e;-><init>(I)V

    .line 10
    .line 11
    .line 12
    invoke-static {p1}, Lkotlin/LazyKt;->lazy(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 13
    .line 14
    .line 15
    move-result-object p1

    .line 16
    iput-object p1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->b:Lkotlin/Lazy;

    .line 17
    .line 18
    new-instance p1, LS01/f;

    .line 19
    .line 20
    const/4 v0, 0x3

    .line 21
    invoke-direct {p1, v0}, LS01/f;-><init>(I)V

    .line 22
    .line 23
    .line 24
    invoke-static {p1}, Lkotlin/LazyKt;->lazy(Lkotlin/jvm/functions/Function0;)Lkotlin/Lazy;

    .line 25
    .line 26
    .line 27
    move-result-object p1

    .line 28
    iput-object p1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->c:Lkotlin/Lazy;

    .line 29
    .line 30
    const/4 p1, 0x1

    .line 31
    iput-boolean p1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->d:Z

    .line 32
    .line 33
    const-class p1, Lcom/bilibili/pegasus/PegasusHolderData;

    .line 34
    .line 35
    invoke-virtual {p2, p1, p0}, Lcom/google/gson/GsonBuilder;->registerTypeAdapter(Ljava/lang/reflect/Type;Ljava/lang/Object;)Lcom/google/gson/GsonBuilder;

    .line 36
    .line 37
    .line 38
    move-result-object p1

    .line 39
    invoke-virtual {p1}, Lcom/google/gson/GsonBuilder;->create()Lcom/google/gson/Gson;

    .line 40
    .line 41
    .line 42
    move-result-object p1

    .line 43
    iput-object p1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->e:Lcom/google/gson/Gson;

    .line 44
    .line 45
    return-void
.end method


# virtual methods
.method public final e(LVP0/a;)Ljava/lang/Object;
    .locals 6

    .line 1
    iget-object v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->a:LDr0/b;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    :try_start_0
    invoke-static {p1}, Lcom/google/gson/internal/r;->a(LVP0/a;)Lcom/google/gson/JsonElement;

    .line 5
    .line 6
    .line 7
    move-result-object p1

    .line 8
    invoke-virtual {p1}, Lcom/google/gson/JsonElement;->isJsonNull()Z

    .line 9
    .line 10
    .line 11
    move-result v2

    .line 12
    if-eqz v2, :cond_0

    .line 13
    .line 14
    goto/16 :goto_4

    .line 15
    .line 16
    :cond_0
    invoke-virtual {p1}, Lcom/google/gson/JsonElement;->getAsJsonObject()Lcom/google/gson/JsonObject;

    .line 17
    .line 18
    .line 19
    move-result-object p1

    .line 20
    if-nez p1, :cond_1

    .line 21
    .line 22
    goto/16 :goto_4

    .line 23
    .line 24
    :cond_1
    const-string v2, "card_type"

    .line 25
    .line 26
    invoke-virtual {p1, v2}, Lcom/google/gson/JsonObject;->get(Ljava/lang/String;)Lcom/google/gson/JsonElement;

    .line 27
    .line 28
    .line 29
    move-result-object v2

    .line 30
    invoke-virtual {v2}, Lcom/google/gson/JsonElement;->getAsString()Ljava/lang/String;

    .line 31
    .line 32
    .line 33
    move-result-object v2

    .line 34

iget-object v3, v0, LDr0/b;->b:Ljava/util/Map;

    .line 35
    .line 36
    invoke-interface {v3, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    .line 37
    .line 38
    .line 39
    move-result-object v3

    .line 40
    check-cast v3, Lcom/bilibili/pegasus/PegasusHolderInfo;

    .line 41
    .line 42
    if-eqz v3, :cond_2

    .line 43
    .line 44
    invoke-interface {v3}, Lcom/bilibili/pegasus/PegasusHolderInfo;->getDataClass()Ljava/lang/Class;

    .line 45
    .line 46
    .line 47
    move-result-object v3

    .line 48

goto :goto_0

    .line 49
    :cond_2
    move-object v3, v1

    .line 50
    :goto_0
    if-nez v3, :cond_3

    .line 51
    .line 52
    goto :goto_4

    .line 53
    :cond_3
    iget-object v0, v0, LDr0/b;->b:Ljava/util/Map;

    .line 54
    .line 55
    invoke-interface {v0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    .line 56
    .line 57
    .line 58
    move-result-object v0

    .line 59
    check-cast v0, Lcom/bilibili/pegasus/PegasusHolderInfo;

    .line 60
    .line 61
    if-eqz v0, :cond_4

    .line 62
    .line 63
    invoke-interface {v0}, Lcom/bilibili/pegasus/PegasusHolderInfo;->getDataParser()Lcom/bilibili/pegasus/PegasusDataParser;

    .line 64
    .line 65
    .line 66
    move-result-object v0

    .line 67
    goto :goto_1

    .line 68
    :cond_4
    move-object v0, v1

    .line 69
    :goto_1
    iget-object v2, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->e:Lcom/google/gson/Gson;

    .line 70
    .line 71
    invoke-virtual {v2, p1, v3}, Lcom/google/gson/Gson;->fromJson(Lcom/google/gson/JsonElement;Ljava/lang/Class;)Ljava/lang/Object;

    .line 72
    .line 73
    .line 74
    move-result-object p1

    .line 75
    check-cast p1, Lcom/bilibili/pegasus/PegasusHolderData;

    .line 76
    .line 77
    if-eqz p1, :cond_5

    .line 78
    .line 79
    if-eqz v0, :cond_5

    .line 80
    .line 81
    invoke-interface {v0, p1}, Lcom/bilibili/pegasus/PegasusDataParser;->parse(Lcom/bilibili/pegasus/PegasusHolderData;)Lcom/bilibili/pegasus/PegasusHolderData;

    .line 82
    .line 83
    .line 84
    move-result-object p1

    .line 85
    goto :goto_2

    .line 86
    :catchall_0
    move-exception p1

    .line 87
    goto :goto_3

    .line 88
    :cond_5
    :goto_2
    instance-of v4, p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;

    if-eqz v4, :cond_adinfo_ok

    check-cast p1, Lcom/bilibili/pegasus/data/base/BasePegasusData;

    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getAdInfo()Lcom/bilibili/adcommon/data/AdInfo;

    move-result-object v4

    if-eqz v4, :cond_adinfo_ok

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "ADROP "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {p1}, Lcom/bilibili/pegasus/data/base/BasePegasusData;->getCardType()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    const/4 p1, 0x0

    :cond_adinfo_ok


iget-boolean v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->d:Z

    .line 89
    .line 90
    if-nez v0, :cond_6

    .line 91
    .line 92
    iget-object v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->b:Lkotlin/Lazy;

    .line 93
    .line 94
    invoke-interface {v0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 95
    .line 96
    .line 97
    move-result-object v0

    .line 98
    check-cast v0, Ljava/lang/Boolean;

    .line 99
    .line 100
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 101
    .line 102
    .line 103
    move-result v0

    .line 104
    if-eqz v0, :cond_6

    .line 105
    .line 106
    instance-of v0, p1, Lcom/bilibili/inline/card/IInlineCardData;

    .line 107
    .line 108
    if-eqz v0, :cond_6

    .line 109
    .line 110
    move-object v0, p1

    .line 111
    check-cast v0, Lcom/bilibili/inline/card/IInlineCardData;

    .line 112
    .line 113
    invoke-interface {v0}, Lcom/bilibili/inline/card/IInlineCardData;->getInlinePlayerItem()Lcom/bilibili/inline/card/IInlinePlayItem;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 114
    .line 115
    .line 116
    :cond_6
    move-object v1, p1

    .line 117
    goto :goto_4

    .line 118
    :goto_3
    iget-object v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->c:Lkotlin/Lazy;

    .line 119
    .line 120
    invoke-interface {v0}, Lkotlin/Lazy;->getValue()Ljava/lang/Object;

    .line 121
    .line 122
    .line 123
    move-result-object v0

    .line 124
    check-cast v0, Ljava/lang/Boolean;

    .line 125
    .line 126
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 127
    .line 128
    .line 129
    move-result v0

    .line 130
    if-eqz v0, :cond_7

    .line 131
    .line 132
    :goto_4
    return-object v1

    .line 133
    :cond_7
    throw p1
.end method

.method public final bridge synthetic f(LVP0/b;Ljava/lang/Object;)V
    .locals 0

    .line 1
    check-cast p2, Lcom/bilibili/pegasus/PegasusHolderData;

    .line 2
    .line 3
    return-void
.end method

.method public final g(Lokhttp3/ResponseBody;)Lcom/bilibili/okretro/GeneralResponse;
    .locals 7
    .param p1    # Lokhttp3/ResponseBody;
        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lokhttp3/ResponseBody;",
            ")",
            "Lcom/bilibili/okretro/GeneralResponse<",
            "Lcom/bilibili/pegasus/data/base/PegasusResponse;",
            ">;"
        }
    .end annotation

    .annotation build Lorg/jetbrains/annotations/NotNull;
    .end annotation

    .line 1
    invoke-virtual {p1}, Lokhttp3/ResponseBody;->charStream()Ljava/io/Reader;

    .line 2
    .line 3
    .line 4
    move-result-object p1

    .line 5
    new-instance v0, Lcom/bilibili/pegasus/request/PegasusGsonParser$a;

    .line 6
    .line 7
    invoke-direct {v0}, Lcom/bilibili/pegasus/request/PegasusGsonParser$a;-><init>()V

    .line 8
    .line 9
    .line 10
    invoke-virtual {v0}, Lcom/google/gson/reflect/TypeToken;->getType()Ljava/lang/reflect/Type;

    .line 11
    .line 12
    .line 13
    move-result-object v0

    .line 14
    iget-object v1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->e:Lcom/google/gson/Gson;

    .line 15
    .line 16
    invoke-virtual {v1, p1, v0}, Lcom/google/gson/Gson;->fromJson(Ljava/io/Reader;Ljava/lang/reflect/Type;)Ljava/lang/Object;

    .line 17
    .line 18
    .line 19
    move-result-object p1

    .line 20
    check-cast p1, Lcom/bilibili/okretro/GeneralResponse;

    .line 21
    .line 22
    iget-object v0, p1, Lcom/bilibili/okretro/GeneralResponse;->data:Ljava/lang/Object;

    .line 23
    .line 24
    move-object v1, v0

    .line 25
    check-cast v1, Lcom/bilibili/pegasus/data/base/PegasusResponse;

    .line 26
    .line 27
    invoke-virtual {v1}, Lcom/bilibili/pegasus/data/base/PegasusResponse;->getItems()Ljava/util/List;

    .line 28
    .line 29
    .line 30
    move-result-object v0

    .line 31
    check-cast v0, Ljava/lang/Iterable;

    .line 32
    .line 33
    invoke-static {v0}, Lkotlin/collections/CollectionsKt;->filterNotNull(Ljava/lang/Iterable;)Ljava/util/List;

    .line 34
    .line 35
    .line 36
    move-result-object v2

    .line 37
    const/4 v3, 0x0

    .line 38
    const/4 v4, 0x0

    .line 39
    const/4 v5, 0x6

    .line 40
    const/4 v6, 0x0

    .line 41
    invoke-static/range {v1 .. v6}, Lcom/bilibili/pegasus/data/base/PegasusResponse;->copy$default(Lcom/bilibili/pegasus/data/base/PegasusResponse;Ljava/util/List;Ltr0/a;Lcom/bilibili/pegasus/data/interestchoose/InterestChoose;ILjava/lang/Object;)Lcom/bilibili/pegasus/data/base/PegasusResponse;

    .line 42
    .line 43
    .line 44
    move-result-object v0

    .line 45
    iget-object v1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->a:LDr0/b;

    .line 46
    .line 47
    iget-object v1, v1, LDr0/b;->a:Lcom/google/common/collect/ImmutableSet;

    .line 48
    .line 49
    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 50
    .line 51
    .line 52
    move-result-object v1

    .line 53
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    .line 54
    .line 55
    .line 56
    move-result v2

    .line 57
    if-eqz v2, :cond_0

    .line 58
    .line 59
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 60
    .line 61
    .line 62
    move-result-object v2

    .line 63
    check-cast v2, Lcom/bilibili/pegasus/request/l;

    .line 64
    .line 65
    invoke-interface {v2, v0}, Lcom/bilibili/pegasus/request/l;->a(Lcom/bilibili/pegasus/data/base/PegasusResponse;)Lcom/bilibili/pegasus/data/base/PegasusResponse;

    .line 66
    .line 67
    .line 68
    move-result-object v0

    .line 69
    goto :goto_0

    .line 70
    :cond_0
    iput-object v0, p1, Lcom/bilibili/okretro/GeneralResponse;->data:Ljava/lang/Object;

    .line 71
    .line 72
    const/4 v0, 0x0

    .line 73
    iput-boolean v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->d:Z

    .line 74
    .line 75
    return-object p1
.end method

.method public final h()V
    .locals 3

    .line 1
    const-class v0, Lwr0/c;

    .line 2
    .line 3
    iget-object v1, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->e:Lcom/google/gson/Gson;

    .line 4
    .line 5
    invoke-virtual {v1, v0}, Lcom/google/gson/Gson;->getAdapter(Ljava/lang/Class;)Lcom/google/gson/TypeAdapter;

    .line 6
    .line 7
    .line 8
    sget-object v0, Lcom/bilibili/app/comm/list/common/feed/PegasusStyle;->INSTANCE:Lcom/bilibili/app/comm/list/common/feed/PegasusStyle;

    .line 9
    .line 10
    invoke-static {v0}, Lcom/bilibili/app/comm/list/common/feed/PegasusStyleKt;->currentIsDoubleColumn(Lcom/bilibili/app/comm/list/common/feed/IPegasusStyle;)Z

    .line 11
    .line 12
    .line 13
    move-result v0

    .line 14
    if-nez v0, :cond_1

    .line 15
    .line 16
    invoke-static {}, Lcom/bilibili/app/comm/list/common/utils/ListDeviceInfoKt;->isHdApp()Z

    .line 17
    .line 18
    .line 19
    move-result v0

    .line 20
    if-eqz v0, :cond_0

    .line 21
    .line 22
    goto :goto_0

    .line 23
    :cond_0
    const-class v0, Lvr0/g;

    .line 24
    .line 25
    invoke-virtual {v1, v0}, Lcom/google/gson/Gson;->getAdapter(Ljava/lang/Class;)Lcom/google/gson/TypeAdapter;

    .line 26
    .line 27
    .line 28
    goto :goto_1

    .line 29
    :cond_1
    :goto_0
    const-class v0, Lvr0/r;

    .line 30
    .line 31
    invoke-virtual {v1, v0}, Lcom/google/gson/Gson;->getAdapter(Ljava/lang/Class;)Lcom/google/gson/TypeAdapter;

    .line 32
    .line 33
    .line 34
    :goto_1
    iget-object v0, p0, Lcom/bilibili/pegasus/request/PegasusGsonParser;->a:LDr0/b;

    .line 35
    .line 36
    iget-object v0, v0, LDr0/b;->b:Ljava/util/Map;

    .line 37
    .line 38
    invoke-interface {v0}, Ljava/util/Map;->values()Ljava/util/Collection;

    .line 39
    .line 40
    .line 41
    move-result-object v0

    .line 42
    check-cast v0, Ljava/lang/Iterable;

    .line 43
    .line 44
    invoke-interface {v0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 45
    .line 46
    .line 47
    move-result-object v0

    .line 48
    :goto_2
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    .line 49
    .line 50
    .line 51
    move-result v2

    .line 52
    if-eqz v2, :cond_2

    .line 53
    .line 54
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 55
    .line 56
    .line 57
    move-result-object v2

    .line 58
    check-cast v2, Lcom/bilibili/pegasus/PegasusHolderInfo;

    .line 59
    .line 60
    invoke-interface {v2}, Lcom/bilibili/pegasus/PegasusHolderInfo;->getDataClass()Ljava/lang/Class;

    .line 61
    .line 62
    .line 63
    move-result-object v2

    .line 64
    invoke-virtual {v1, v2}, Lcom/google/gson/Gson;->getAdapter(Ljava/lang/Class;)Lcom/google/gson/TypeAdapter;

    .line 65
    .line 66
    .line 67
    goto :goto_2

    .line 68
    :cond_2
    return-void
.end method
