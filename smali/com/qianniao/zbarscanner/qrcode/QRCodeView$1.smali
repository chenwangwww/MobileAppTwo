.class Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;
.super Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;
.source "QRCodeView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->onPreviewFrame([BLandroid/hardware/Camera;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

.field final synthetic val$camera:Landroid/hardware/Camera;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/qrcode/QRCodeView;Landroid/hardware/Camera;[BLcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;Landroid/hardware/Camera;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/qrcode/QRCodeView;
    .param p2, "camera"    # Landroid/hardware/Camera;
    .param p3, "data"    # [B
    .param p4, "delegate"    # Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    .prologue
    .line 236
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iput-object p5, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->val$camera:Landroid/hardware/Camera;

    invoke-direct {p0, p2, p3, p4}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;-><init>(Landroid/hardware/Camera;[BLcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;)V

    return-void
.end method


# virtual methods
.method protected bridge synthetic onPostExecute(Ljava/lang/Object;)V
    .locals 0

    .prologue
    .line 236
    check-cast p1, Ljava/lang/String;

    invoke-virtual {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->onPostExecute(Ljava/lang/String;)V

    return-void
.end method

.method protected onPostExecute(Ljava/lang/String;)V
    .locals 2
    .param p1, "result"    # Ljava/lang/String;

    .prologue
    .line 239
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-boolean v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    if-eqz v0, :cond_0

    .line 240
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    if-eqz v0, :cond_1

    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 242
    :try_start_0
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    invoke-interface {v0, p1}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;->onScanQRCodeSuccess(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1

    .line 252
    :cond_0
    :goto_0
    return-void

    .line 247
    :cond_1
    :try_start_1
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->val$camera:Landroid/hardware/Camera;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->setOneShotPreviewCallback(Landroid/hardware/Camera$PreviewCallback;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 248
    :catch_0
    move-exception v0

    goto :goto_0

    .line 243
    :catch_1
    move-exception v0

    goto :goto_0
.end method
