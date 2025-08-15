.class Lcom/qianniao/Pasteboard$3;
.super Ljava/lang/Thread;
.source "Pasteboard.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/Pasteboard;->_systemCopy(Ljava/lang/String;)V
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
    .line 63
    iput-object p1, p0, Lcom/qianniao/Pasteboard$3;->this$0:Lcom/qianniao/Pasteboard;

    invoke-direct {p0}, Ljava/lang/Thread;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 65
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iget-object v1, p0, Lcom/qianniao/Pasteboard$3;->this$0:Lcom/qianniao/Pasteboard;

    iget-object v1, v1, Lcom/qianniao/Pasteboard;->copyrunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 66
    return-void
.end method
