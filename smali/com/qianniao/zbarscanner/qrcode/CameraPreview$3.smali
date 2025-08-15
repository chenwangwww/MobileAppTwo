.class Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;
.super Ljava/lang/Object;
.source "CameraPreview.java"

# interfaces
.implements Landroid/hardware/Camera$AutoFocusCallback;


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
    .line 145
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onAutoFocus(ZLandroid/hardware/Camera;)V
    .locals 4
    .param p1, "success"    # Z
    .param p2, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 147
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;->this$0:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-static {v1}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->access$400(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Ljava/lang/Runnable;

    move-result-object v1

    const-wide/16 v2, 0x3e8

    invoke-virtual {v0, v1, v2, v3}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 148
    return-void
.end method
