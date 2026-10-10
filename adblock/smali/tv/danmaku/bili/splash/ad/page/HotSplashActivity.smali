.class public final Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;
.super Lcom/bilibili/lib/spy/generated/a;
.source "BL"

# interfaces
.implements Lcom/bilibili/lib/homepage/splash/a;
.implements LSj0/g;


# annotations
.annotation build Landroidx/compose/runtime/internal/StabilityInferred;
    parameters = 0x0
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Lcom/bilibili/lib/spy/generated/a;-><init>()V

    .line 2
    .line 3
    .line 4
    return-void
.end method


# virtual methods
.method public final J2()V
    .locals 0

    .line 1
    invoke-virtual {p0}, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;->o7()V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public final attachBaseContext(Landroid/content/Context;)V
    .locals 0

    .line 1
    invoke-static {p0, p1}, Lcom/bilibili/lib/tribe/core/internal/Hooks;->hookAttachContext(Landroid/content/ContextWrapper;Landroid/content/Context;)Landroid/content/Context;

    .line 2
    .line 3
    .line 4
    move-result-object p1

    .line 5
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->attachBaseContext(Landroid/content/Context;)V

    .line 6
    .line 7
    .line 8
    invoke-static {p0}, Lcom/bilibili/lib/tribe/core/internal/Hooks;->hookAfterAttachContext(Landroid/content/ContextWrapper;)V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public final o7()V
    .locals 6

    .line 1
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->getLifecycleScope(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    new-instance v3, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity$delayFinish$1;

    .line 6
    .line 7
    const/4 v1, 0x0

    .line 8
    invoke-direct {v3, p0, v1}, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity$delayFinish$1;-><init>(Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;Lkotlin/coroutines/Continuation;)V

    .line 9
    .line 10
    .line 11
    const/4 v4, 0x3

    .line 12
    const/4 v5, 0x0

    .line 13
    const/4 v2, 0x0

    .line 14
    invoke-static/range {v0 .. v5}, Lkotlinx/coroutines/BuildersKt;->launch$default(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 15
    .line 16
    .line 17
    return-void
.end method

.method public final onCreate(Landroid/os/Bundle;)V
    .locals 7
    .param p1    # Landroid/os/Bundle;
        .annotation build Lorg/jetbrains/annotations/Nullable;
        .end annotation
    .end param

    .line 1
    if-eqz p1, :cond_0

    .line 2
    .line 3
    const-string v0, "android:support:fragments"

    .line 4
    .line 5
    invoke-virtual {p1, v0}, Landroid/os/Bundle;->remove(Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    invoke-super {p0, p1}, Lcom/bilibili/lib/spy/generated/a;->onCreate(Landroid/os/Bundle;)V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return-void    # ADKILL_HOT_SPLASH


    .line 9
    .line 10
    .line 11
    if-nez p1, :cond_5

    .line 12
    .line 13
    invoke-static {p0}, Landroidx/lifecycle/LifecycleOwnerKt;->getLifecycleScope(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 14
    .line 15
    .line 16
    move-result-object v1

    .line 17
    new-instance v4, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity$onCreate$1;

    .line 18
    .line 19
    const/4 p1, 0x0

    .line 20
    invoke-direct {v4, p0, p1}, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity$onCreate$1;-><init>(Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;Lkotlin/coroutines/Continuation;)V

    .line 21
    .line 22
    .line 23
    const/4 v2, 0x0

    .line 24
    const/4 v3, 0x0

    .line 25
    const/4 v5, 0x3

    .line 26
    const/4 v6, 0x0

    .line 27
    invoke-static/range {v1 .. v6}, Lkotlinx/coroutines/BuildersKt;->launch$default(Lkotlinx/coroutines/CoroutineScope;Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/CoroutineStart;Lkotlin/jvm/functions/Function2;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 28
    .line 29
    .line 30
    sget-object v0, Ltv/danmaku/bili/splash/ad/page/e;->a:[Lkotlin/reflect/KProperty;

    .line 31
    .line 32
    const/4 v1, 0x0

    .line 33
    aget-object v0, v0, v1

    .line 34
    .line 35
    sget-object v0, Ltv/danmaku/bili/splash/ad/page/e;->c:Ltv/danmaku/bili/splash/ad/page/k;

    .line 36
    .line 37
    iget-object v0, v0, Ltv/danmaku/bili/splash/ad/page/k;->b:Ltv/danmaku/bili/splash/ad/model/SplashOrder;

    .line 38
    .line 39
    if-nez v0, :cond_1

    .line 40
    .line 41
    sget-object v0, Ltv/danmaku/bili/splash/ad/model/SplashSource;->HOT:Ltv/danmaku/bili/splash/ad/model/SplashSource;

    .line 42
    .line 43
    invoke-static {v1, v0}, Ltv/danmaku/bili/splash/ad/core/SplashManager;->b(ZLtv/danmaku/bili/splash/ad/model/SplashSource;)Ltv/danmaku/bili/splash/ad/model/SplashOrder;

    .line 44
    .line 45
    .line 46
    move-result-object v0

    .line 47
    :cond_1
    invoke-static {p1}, Ltv/danmaku/bili/splash/ad/page/e;->a(Ltv/danmaku/bili/splash/ad/model/SplashOrder;)V

    .line 48
    .line 49
    .line 50
    if-eqz v0, :cond_2

    .line 51
    .line 52
    invoke-virtual {v0}, Ltv/danmaku/bili/splash/ad/model/SplashOrder;->getRuntimeExtra()LPi1/j;

    .line 53
    .line 54
    .line 55
    move-result-object p1

    .line 56
    if-eqz p1, :cond_2

    .line 57
    .line 58
    const/4 v2, 0x1

    .line 59
    iput-boolean v2, p1, LPi1/j;->h:Z

    .line 60
    .line 61
    :cond_2
    new-instance p1, Landroidx/lifecycle/ViewModelProvider;

    .line 62
    .line 63
    invoke-direct {p1, p0}, Landroidx/lifecycle/ViewModelProvider;-><init>(Landroidx/lifecycle/ViewModelStoreOwner;)V

    .line 64
    .line 65
    .line 66
    const-class v2, Lcom/bilibili/lib/homepage/splash/SplashViewModel;

    .line 67
    .line 68
    invoke-virtual {p1, v2}, Landroidx/lifecycle/ViewModelProvider;->get(Ljava/lang/Class;)Landroidx/lifecycle/ViewModel;

    .line 69
    .line 70
    .line 71
    move-result-object p1

    .line 72
    check-cast p1, Lcom/bilibili/lib/homepage/splash/SplashViewModel;

    .line 73
    .line 74
    new-instance v2, Loc0/f;

    .line 75
    .line 76
    if-eqz v0, :cond_3

    .line 77
    .line 78
    invoke-virtual {v0}, Ltv/danmaku/bili/splash/ad/model/SplashOrder;->getId()J

    .line 79
    .line 80
    .line 81
    move-result-wide v3

    .line 82
    goto :goto_0

    .line 83
    :cond_3
    const-wide/16 v3, 0x0

    .line 84
    .line 85
    :goto_0
    const/16 v5, 0x3e

    .line 86
    .line 87
    invoke-direct {v2, v3, v4, v5}, Loc0/f;-><init>(JI)V

    .line 88
    .line 89
    .line 90
    invoke-virtual {p1, v2}, Lcom/bilibili/lib/homepage/splash/SplashViewModel;->update(Lcom/bilibili/lib/homepage/splash/actions/SplashStateUpdateAction;)V

    .line 91
    .line 92
    .line 93
    invoke-static {v0}, Ltv/danmaku/bili/splash/ad/core/SplashManager;->a(Ltv/danmaku/bili/splash/ad/model/SplashOrder;)Ltv/danmaku/bili/splash/ad/page/BaseSplash;

    .line 94
    .line 95
    .line 96
    move-result-object p1

    .line 97
    if-nez p1, :cond_4

    .line 98
    .line 99
    sget-object p1, Ltv/danmaku/bili/splash/ad/reporter/ad/SplashAdHelper;->a:Ltv/danmaku/bili/splash/ad/reporter/ad/SplashAdHelper;

    .line 100
    .line 101
    const-string v0, "hot"

    .line 102
    .line 103
    invoke-virtual {p1, v0, v1}, Ltv/danmaku/bili/splash/ad/reporter/ad/SplashAdHelper;->r(Ljava/lang/String;Z)V

    .line 104
    .line 105
    .line 106
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 107
    .line 108
    .line 109
    goto :goto_1

    .line 110
    :cond_4
    const-string v0, "HotSplashActivity"

    .line 111
    .line 112
    const-string v1, "show hot splash"

    .line 113
    .line 114
    invoke-static {v0, v1}, Ltv/danmaku/android/log/BLog;->i(Ljava/lang/String;Ljava/lang/String;)V

    .line 115
    .line 116
    .line 117
    invoke-virtual {p0}, Landroidx/fragment/app/FragmentActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 118
    .line 119
    .line 120
    move-result-object v0

    .line 121
    invoke-virtual {v0}, Landroidx/fragment/app/FragmentManager;->beginTransaction()Landroidx/fragment/app/FragmentTransaction;

    .line 122
    .line 123
    .line 124
    move-result-object v0

    .line 125
    const v1, 0x1020002

    .line 126
    .line 127
    .line 128
    const-string v2, "splash"

    .line 129
    .line 130
    invoke-virtual {v0, v1, p1, v2}, Landroidx/fragment/app/FragmentTransaction;->add(ILandroidx/fragment/app/Fragment;Ljava/lang/String;)Landroidx/fragment/app/FragmentTransaction;

    .line 131
    .line 132
    .line 133
    move-result-object p1

    .line 134
    invoke-virtual {p1}, Landroidx/fragment/app/FragmentTransaction;->commitAllowingStateLoss()I

    .line 135
    .line 136
    .line 137
    goto :goto_1

    .line 138
    :cond_5
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 139
    .line 140
    .line 141
    :goto_1
    return-void
.end method

.method public final onDestroy()V
    .locals 4

    .line 1
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    .line 2
    .line 3
    .line 4
    const/4 v0, 0x0

    .line 5
    sput-boolean v0, Ltv/danmaku/bili/splash/ad/page/e;->b:Z

    .line 6
    .line 7
    sget-object v0, Lcom/bilibili/lib/blrouter/BLRouter;->INSTANCE:Lcom/bilibili/lib/blrouter/BLRouter;

    .line 8
    .line 9
    const-class v1, Lpk0/a;

    .line 10
    .line 11
    const/4 v2, 0x0

    .line 12
    const/4 v3, 0x2

    .line 13
    invoke-static {v0, v1, v2, v3, v2}, Lcom/bilibili/lib/blrouter/BLRouter;->get$default(Lcom/bilibili/lib/blrouter/BLRouter;Ljava/lang/Class;Ljava/lang/String;ILjava/lang/Object;)Ljava/lang/Object;

    .line 14
    .line 15
    .line 16
    move-result-object v0

    .line 17
    check-cast v0, Lpk0/a;

    .line 18
    .line 19
    if-eqz v0, :cond_0

    .line 20
    .line 21
    invoke-interface {v0}, Lpk0/a;->b()V

    .line 22
    .line 23
    .line 24
    :cond_0
    return-void
.end method

.method public final onStop()V
    .locals 0

    .line 1
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    .line 2
    .line 3
    .line 4
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 5
    .line 6
    .line 7
    return-void
.end method

.method public final x4(Ljava/lang/String;Ltv/danmaku/bili/splash/ad/model/SplashOrder;Z)V
    .locals 2
    .param p1    # Ljava/lang/String;
        .annotation build Lorg/jetbrains/annotations/Nullable;
        .end annotation
    .end param
    .param p2    # Ltv/danmaku/bili/splash/ad/model/SplashOrder;
        .annotation build Lorg/jetbrains/annotations/Nullable;
        .end annotation
    .end param

    .line 1
    const/4 p3, 0x0

    .line 2
    if-eqz p2, :cond_0

    .line 3
    .line 4
    goto :goto_0

    .line 5
    :cond_0
    move-object p2, p3

    .line 6
    :goto_0
    const-string v0, "HotSplashActivity"

    .line 7
    .line 8
    if-eqz p2, :cond_4

    .line 9
    .line 10
    if-eqz p1, :cond_4

    .line 11
    .line 12
    invoke-static {p1}, Lkotlin/text/StringsKt;->isBlank(Ljava/lang/CharSequence;)Z

    .line 13
    .line 14
    .line 15
    move-result v1

    .line 16
    if-eqz v1, :cond_1

    .line 17
    .line 18
    goto :goto_1

    .line 19
    :cond_1
    invoke-virtual {p2}, Ltv/danmaku/bili/splash/ad/model/SplashOrder;->isAdLoc()Z

    .line 20
    .line 21
    .line 22
    move-result v1

    .line 23
    if-eqz v1, :cond_2

    .line 24
    .line 25
    const/16 v0, 0xf8

    .line 26
    .line 27
    invoke-static {p0, p2, p1, p3, v0}, Ltv/danmaku/bili/splash/ad/reporter/ad/SplashAdHelper;->k(Landroid/content/Context;Ltv/danmaku/bili/splash/ad/model/SplashOrder;Ljava/lang/String;Ljava/lang/String;I)Z

    .line 28
    .line 29
    .line 30
    invoke-virtual {p0}, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;->o7()V

    .line 31
    .line 32
    .line 33
    goto :goto_2

    .line 34
    :cond_2
    new-instance p2, Lcom/bilibili/lib/blrouter/RouteRequest$Builder;

    .line 35
    .line 36
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    .line 37
    .line 38
    .line 39
    move-result-object p3

    .line 40
    invoke-direct {p2, p3}, Lcom/bilibili/lib/blrouter/RouteRequest$Builder;-><init>(Landroid/net/Uri;)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {p2}, Lcom/bilibili/lib/blrouter/RouteRequest$Builder;->build()Lcom/bilibili/lib/blrouter/RouteRequest;

    .line 44
    .line 45
    .line 46
    move-result-object p2

    .line 47
    invoke-static {p2, p0}, Lcom/bilibili/lib/blrouter/BLRouter;->routeTo(Lcom/bilibili/lib/blrouter/RouteRequest;Landroid/content/Context;)Lcom/bilibili/lib/blrouter/RouteResponse;

    .line 48
    .line 49
    .line 50
    move-result-object p2

    .line 51
    invoke-virtual {p2}, Lcom/bilibili/lib/blrouter/RouteResponse;->isSuccess()Z

    .line 52
    .line 53
    .line 54
    move-result p2

    .line 55
    if-nez p2, :cond_3

    .line 56
    .line 57
    const-string p2, "exitSplash, route failed "

    .line 58
    .line 59
    invoke-virtual {p2, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    .line 60
    .line 61
    .line 62
    move-result-object p1

    .line 63
    invoke-static {v0, p1}, Ltv/danmaku/android/log/BLog;->i(Ljava/lang/String;Ljava/lang/String;)V

    .line 64
    .line 65
    .line 66
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 67
    .line 68
    .line 69
    goto :goto_2

    .line 70
    :cond_3
    invoke-virtual {p0}, Ltv/danmaku/bili/splash/ad/page/HotSplashActivity;->o7()V

    .line 71
    .line 72
    .line 73
    goto :goto_2

    .line 74
    :cond_4
    :goto_1
    const-string p1, "exitSplash, splash or jumpUrl is empty"

    .line 75
    .line 76
    invoke-static {v0, p1}, Ltv/danmaku/android/log/BLog;->i(Ljava/lang/String;Ljava/lang/String;)V

    .line 77
    .line 78
    .line 79
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    .line 80
    .line 81
    .line 82
    :goto_2
    return-void
.end method
