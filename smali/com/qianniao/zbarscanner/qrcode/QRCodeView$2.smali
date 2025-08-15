.class Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;
.super Ljava/lang/Object;
.source "QRCodeView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/qianniao/zbarscanner/qrcode/QRCodeView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/qrcode/QRCodeView;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    .prologue
    .line 257
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 260
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-boolean v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    if-eqz v0, :cond_0

    .line 261
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/QRCodeView;

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->setOneShotPreviewCallback(Landroid/hardware/Camera$PreviewCallback;)V

    .line 263
    :cond_0
    return-void
.end method
