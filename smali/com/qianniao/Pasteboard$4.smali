.class Lcom/qianniao/Pasteboard$4;
.super Ljava/lang/Thread;
.source "Pasteboard.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/Pasteboard;->_systemPaste()Ljava/lang/String;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/Pasteboard;


# direct methods
.method constructor <init>(Lcom/qianniao/Pasteboard;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/Pasteboard;

    .prologue
    .line 86
    iput-object p1, p0, Lcom/qianniao/Pasteboard$4;->this$0:Lcom/qianniao/Pasteboard;

    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 89
    :try_start_0
    iget-object v1, p0, Lcom/qianniao/Pasteboard$4;->this$0:Lcom/qianniao/Pasteboard;

    const/4 v2, 0x1

    invoke-static {v1, v2}, Lcom/qianniao/Pasteboard;->access$302(Lcom/qianniao/Pasteboard;Z)Z

    .line 90
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 92
    .local v0, "hand":Landroid/os/Handler;
    iget-object v1, p0, Lcom/qianniao/Pasteboard$4;->this$0:Lcom/qianniao/Pasteboard;

    iget-object v1, v1, Lcom/qianniao/Pasteboard;->pasterunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 94
    const-wide/16 v2, 0x190

    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 99
    .end local v0    # "hand":Landroid/os/Handler;
    :goto_0
    return-void

    .line 96
    :catch_0
    move-exception v1

    goto :goto_0
.end method
