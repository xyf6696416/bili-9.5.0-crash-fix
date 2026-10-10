.class public final Ltv/danmaku/bili/splash/shell/ColdSplashWrapper;
.super Ljava/lang/Object;
.source "BL"


# annotations
.annotation build Landroidx/compose/runtime/internal/StabilityInferred;
    parameters = 0x0
.end annotation


# instance fields
.field public a:Landroid/view/ViewGroup;
    .annotation build Lorg/jetbrains/annotations/Nullable;
    .end annotation
.end field


# virtual methods
.method public final a(Landroidx/appcompat/app/AppCompatActivity;Landroid/view/ViewGroup;)Z
    .locals 4
    .param p1    # Landroidx/appcompat/app/AppCompatActivity;
        .annotation build Lorg/jetbrains/annotations/NotNull;
        .end annotation
    .end param
    .param p2    # Landroid/view/ViewGroup;
        .annotation build Lorg/jetbrains/annotations/Nullable;
        .end annotation
    .end param

        const-string v0, "SPLASHCOLD suppressed"

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    const/4 v0, 0x0

    return v0    # ADKILL_COLD_SPLASH


.line 1
    const/4 v0, 0x0

    .line 2
    if-nez p2, :cond_0

    .line 3
    .line 4
    return v0

    .line 5
    :cond_0
    iput-object p2, p0, Ltv/danmaku/bili/splash/shell/ColdSplashWrapper;->a:Landroid/view/ViewGroup;

    .line 6
    .line 7
    invoke-virtual {p1}, Landroidx/fragment/app/FragmentActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    .line 8
    .line 9
    .line 10
    move-result-object v1

    .line 11
    const-string v2, "ADSplashFragment"

    .line 12
    .line 13
    invoke-virtual {v1, v2}, Landroidx/fragment/app/FragmentManager;->findFragmentByTag(Ljava/lang/String;)Landroidx/fragment/app/Fragment;

    .line 14
    .line 15
    .line 16
    move-result-object v3

    .line 17
    if-eqz v3, :cond_1

    .line 18
    .line 19
    invoke-static {v1, v3}, LY0/c;->b(Landroidx/fragment/app/FragmentManager;Landroidx/fragment/app/Fragment;)V

    .line 20
    .line 21
    .line 22
    :cond_1
    invoke-virtual {v1}, Landroidx/fragment/app/FragmentManager;->beginTransaction()Landroidx/fragment/app/FragmentTransaction;

    .line 23
    .line 24
    .line 25
    move-result-object v1

    .line 26
    invoke-virtual {p2, v0}, Landroid/view/ViewGroup;->setVisibility(I)V

    .line 27
    .line 28
    .line 29
    new-instance p2, Lkntr/srcs/app/splash/startup/SplashContainerFragment;

    .line 30
    .line 31
    invoke-direct {p2}, Lkntr/srcs/app/splash/startup/SplashContainerFragment;-><init>()V

    .line 32
    .line 33
    .line 34
    const v0, 0x7f0941a3

    .line 35
    .line 36
    .line 37
    invoke-virtual {v1, v0, p2, v2}, Landroidx/fragment/app/FragmentTransaction;->add(ILandroidx/fragment/app/Fragment;Ljava/lang/String;)Landroidx/fragment/app/FragmentTransaction;

    .line 38
    .line 39
    .line 40
    invoke-virtual {v1}, Landroidx/fragment/app/FragmentTransaction;->commitAllowingStateLoss()I

    .line 41
    .line 42
    .line 43
    invoke-virtual {p0, p1}, Ltv/danmaku/bili/splash/shell/ColdSplashWrapper;->b(Landroidx/appcompat/app/AppCompatActivity;)V

    .line 44
    .line 45
    .line 46
    const/4 p1, 0x1

    .line 47
    return p1
.end method

.method public final b(Landroidx/appcompat/app/AppCompatActivity;)V
    .locals 6

    .line 1
    invoke-static {p1}, Landroidx/lifecycle/LifecycleOwnerKt;->getLifecycleScope(Landroidx/lifecycle/LifecycleOwner;)Landroidx/lifecycle/LifecycleCoroutineScope;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    new-instance v3, Ltv/danmaku/bili/splash/shell/ColdSplashWrapper$observerSplashEvent$1;

    .line 6
    .line 7
    const/4 v1, 0x0

    .line 8
    invoke-direct {v3, p0, p1, v1}, Ltv/danmaku/bili/splash/shell/ColdSplashWrapper$observerSplashEvent$1;-><init>(Ltv/danmaku/bili/splash/shell/ColdSplashWrapper;Landroidx/appcompat/app/AppCompatActivity;Lkotlin/coroutines/Continuation;)V

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
