.class public final Lcom/bilibili/ship/theseus/united/page/ad/AdRepository$a;
.super Ljava/lang/Object;
.source "BL"

# interfaces
.implements Lcom/bilibili/gripper/api/ad/biz/videodetail/IPanelCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;-><init>(Lkotlinx/coroutines/CoroutineScope;Landroidx/fragment/app/FragmentActivity;Lcom/bapis/bilibili/app/viewunite/v1/ViewReply;Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;Lcom/bilibili/ship/theseus/united/page/ad/PageAdRepository;Lcom/bilibili/ship/theseus/united/page/view/d;Lcom/bilibili/ship/theseus/united/page/view/a;Lkotlinx/coroutines/flow/Flow;Lcom/bilibili/ship/theseus/united/page/screenstate/d;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = null
.end annotation


# instance fields
.field public final synthetic a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;


# direct methods
.method public constructor <init>(Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;)V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    iput-object p1, p0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository$a;->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;

    .line 5
    .line 6
    return-void
.end method


# virtual methods
.method public final dismissPanel()V
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository$a;->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;

    .line 2
    .line 3
    iget-object v0, v0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;->b:Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;

    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;->dismissPanel()V

    .line 6
    .line 7
    .line 8
    return-void
.end method

.method public final isPanelShowing()Z
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository$a;->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;

    .line 2
    .line 3
    iget-object v0, v0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;->b:Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;

    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;->isPanelShowing()Z

    .line 6
    .line 7
    .line 8
    move-result v0

    .line 9
    return v0
.end method

.method public final showPanel(ILcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T::",
            "Lcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;",
            ">(ITT;",
            "Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;",
            ")V"
        }
    .end annotation

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "PANELCB type="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/bilibili/adblock/AdBlockGuard;->append(Ljava/lang/String;)V

    return-void    # ADKILL_PAUSED_PANEL_CB

    .line 1
    iget-object v0, p0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository$a;->a:Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;

    .line 2
    .line 3
    iget-object v0, v0, Lcom/bilibili/ship/theseus/united/page/ad/AdRepository;->b:Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;

    .line 4
    .line 5
    invoke-virtual {v0, p1, p2, p3}, Lcom/bilibili/ship/theseus/united/page/ad/AdPanelRepository;->showPanel(ILcom/bilibili/gripper/api/ad/biz/videodetail/IPanelData;Lcom/bilibili/gripper/api/ad/biz/videodetail/IAdPanelListener;)V

    .line 6
    .line 7
    .line 8
    return-void
.end method
