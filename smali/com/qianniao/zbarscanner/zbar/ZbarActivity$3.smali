.class Lcom/qianniao/zbarscanner/zbar/ZbarActivity$3;
.super Landroid/os/Handler;
.source "ZbarActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/qianniao/zbarscanner/zbar/ZbarActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    .prologue
    .line 167
    iput-object p1, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$3;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 2
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    .line 171
    const/4 v0, 0x1

    iget v1, p1, Landroid/os/Message;->what:I

    if-ne v0, v1, :cond_0

    .line 172
    iget-object v0, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    if-eqz v0, :cond_0

    .line 173
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$3;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iget-object v1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->onScanQRCodeSuccess(Ljava/lang/String;)V

    .line 175
    :cond_0
    return-void
.end method
