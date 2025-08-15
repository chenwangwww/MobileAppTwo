.class Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;
.super Ljava/lang/Object;
.source "ZbarActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->codeDiscriminate(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

.field final synthetic val$path:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;Ljava/lang/String;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    .prologue
    .line 144
    iput-object p1, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iput-object p2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->val$path:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 5

    .prologue
    .line 148
    invoke-static {}, Landroid/os/Looper;->prepare()V

    .line 149
    const/4 v1, 0x0

    .line 150
    .local v1, "result":Ljava/lang/String;
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x13

    if-lt v2, v3, :cond_0

    .line 151
    iget-object v2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->val$path:Ljava/lang/String;

    invoke-static {v2}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->syncDecodeQRCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 155
    :goto_0
    const-string v2, "zbar_result"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "--->"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 156
    iget-object v2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iget-object v2, v2, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mHandler:Landroid/os/Handler;

    invoke-virtual {v2}, Landroid/os/Handler;->obtainMessage()Landroid/os/Message;

    move-result-object v0

    .line 158
    .local v0, "msg":Landroid/os/Message;
    const/4 v2, 0x1

    iput v2, v0, Landroid/os/Message;->what:I

    .line 159
    iput-object v1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 160
    iget-object v2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iget-object v2, v2, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mHandler:Landroid/os/Handler;

    invoke-virtual {v2, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 161
    return-void

    .line 153
    .end local v0    # "msg":Landroid/os/Message;
    :cond_0
    iget-object v2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;->val$path:Ljava/lang/String;

    invoke-static {v2}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->syncDecodeQRCode2(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    goto :goto_0
.end method
