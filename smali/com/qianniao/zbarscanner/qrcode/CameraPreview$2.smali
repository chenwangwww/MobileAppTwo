.class Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;
.super Ljava/lang/Object;
.source "CameraPreview.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/qianniao/zbarscanner/qrcode/CameraPreview;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 137
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 139
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$000(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Landroid/hardware/Camera;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$100(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$200(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$300(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 140
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$000(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Landroid/hardware/Camera;

    move-result-object v0

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    iget-object v1, v1, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->autoFocusCB:Landroid/hardware/Camera$AutoFocusCallback;

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->autoFocus(Landroid/hardware/Camera$AutoFocusCallback;)V

    .line 142
    :cond_0
    return-void
.end method
