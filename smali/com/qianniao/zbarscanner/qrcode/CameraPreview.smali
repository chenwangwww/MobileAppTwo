.class public Lcom/qianniao/zbarscanner/qrcode/CameraPreview;
.super Landroid/view/SurfaceView;
.source "CameraPreview.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;


# static fields
.field private static final TAG:Ljava/lang/String;


# instance fields
.field autoFocusCB:Landroid/hardware/Camera$AutoFocusCallback;

.field private doAutoFocus:Ljava/lang/Runnable;

.field private mAutoFocus:Z

.field private mCamera:Landroid/hardware/Camera;

.field private mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

.field private mPreviewing:Z

.field private mSurfaceCreated:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 12
    const-class v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/4 v0, 0x1

    .line 20
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    .line 14
    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    .line 15
    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mAutoFocus:Z

    .line 16
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mSurfaceCreated:Z

    .line 137
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;

    invoke-direct {v0, p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$2;-><init>(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->doAutoFocus:Ljava/lang/Runnable;

    .line 145
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;

    invoke-direct {v0, p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$3;-><init>(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->autoFocusCB:Landroid/hardware/Camera$AutoFocusCallback;

    .line 21
    return-void
.end method

.method static synthetic access$000(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Landroid/hardware/Camera;
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 11
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    return-object v0
.end method

.method static synthetic access$100(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 11
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    return v0
.end method

.method static synthetic access$200(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 11
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mAutoFocus:Z

    return v0
.end method

.method static synthetic access$300(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Z
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 11
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mSurfaceCreated:Z

    return v0
.end method

.method static synthetic access$400(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)Ljava/lang/Runnable;
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .prologue
    .line 11
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->doAutoFocus:Ljava/lang/Runnable;

    return-object v0
.end method

.method private flashLightAvaliable()Z
    .locals 2

    .prologue
    .line 116
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    if-eqz v0, :cond_0

    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mSurfaceCreated:Z

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    const-string v1, "android.hardware.camera.flash"

    invoke-virtual {v0, v1}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method


# virtual methods
.method public closeFlashlight()V
    .locals 2

    .prologue
    .line 105
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->flashLightAvaliable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 106
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->closeFlashlight(Landroid/hardware/Camera;)V

    .line 112
    :cond_0
    return-void
.end method

.method public isFlashlightOn()Z
    .locals 5

    .prologue
    const/4 v3, 0x0

    .line 125
    :try_start_0
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v4}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v2

    .line 126
    .local v2, "parameters":Landroid/hardware/Camera$Parameters;
    invoke-virtual {v2}, Landroid/hardware/Camera$Parameters;->getFlashMode()Ljava/lang/String;

    move-result-object v1

    .line 127
    .local v1, "flashMode":Ljava/lang/String;
    const-string v4, "torch"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v4

    if-eqz v4, :cond_0

    .line 128
    const/4 v3, 0x1

    .line 133
    .end local v1    # "flashMode":Ljava/lang/String;
    .end local v2    # "parameters":Landroid/hardware/Camera$Parameters;
    :cond_0
    :goto_0
    return v3

    .line 132
    :catch_0
    move-exception v0

    .line 133
    .local v0, "e":Ljava/lang/Exception;
    goto :goto_0
.end method

.method public openFlashlight()V
    .locals 2

    .prologue
    .line 96
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->flashLightAvaliable()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 97
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->openFlashlight(Landroid/hardware/Camera;)V

    .line 102
    :cond_0
    return-void
.end method

.method public setCamera(Landroid/hardware/Camera;)V
    .locals 2
    .param p1, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 24
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    .line 25
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    .line 26
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    .line 27
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->initFromCameraParameters(Landroid/hardware/Camera;)V

    .line 29
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 30
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    if-eqz v0, :cond_1

    .line 31
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->requestLayout()V

    .line 36
    :cond_0
    :goto_0
    return-void

    .line 33
    :cond_1
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->showCameraPreview()V

    goto :goto_0
.end method

.method public showCameraPreview()V
    .locals 3

    .prologue
    .line 64
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    if-eqz v1, :cond_0

    .line 66
    const/4 v1, 0x1

    :try_start_0
    iput-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    .line 67
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/hardware/Camera;->setPreviewDisplay(Landroid/view/SurfaceHolder;)V

    .line 69
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCameraConfigurationManager:Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v1, v2}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->setDesiredCameraParameters(Landroid/hardware/Camera;)V

    .line 70
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v1}, Landroid/hardware/Camera;->startPreview()V

    .line 71
    iget-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mAutoFocus:Z

    if-eqz v1, :cond_0

    .line 72
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->autoFocusCB:Landroid/hardware/Camera$AutoFocusCallback;

    invoke-virtual {v1, v2}, Landroid/hardware/Camera;->autoFocus(Landroid/hardware/Camera$AutoFocusCallback;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 78
    :cond_0
    :goto_0
    return-void

    .line 74
    :catch_0
    move-exception v0

    .line 75
    .local v0, "e":Ljava/lang/Exception;
    sget-object v1, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->TAG:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method public stopCameraPreview()V
    .locals 3

    .prologue
    .line 81
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    if-eqz v1, :cond_0

    .line 83
    :try_start_0
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->doAutoFocus:Ljava/lang/Runnable;

    invoke-virtual {p0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 85
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mPreviewing:Z

    .line 86
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v1}, Landroid/hardware/Camera;->cancelAutoFocus()V

    .line 87
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/hardware/Camera;->setOneShotPreviewCallback(Landroid/hardware/Camera$PreviewCallback;)V

    .line 88
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v1}, Landroid/hardware/Camera;->stopPreview()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 93
    :cond_0
    :goto_0
    return-void

    .line 89
    :catch_0
    move-exception v0

    .line 90
    .local v0, "e":Ljava/lang/Exception;
    sget-object v1, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->TAG:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 1
    .param p1, "surfaceHolder"    # Landroid/view/SurfaceHolder;
    .param p2, "i"    # I
    .param p3, "i2"    # I
    .param p4, "i3"    # I

    .prologue
    .line 45
    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v0

    if-nez v0, :cond_0

    .line 55
    :goto_0
    return-void

    .line 48
    :cond_0
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->stopCameraPreview()V

    .line 50
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$1;

    invoke-direct {v0, p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview$1;-><init>(Lcom/qianniao/zbarscanner/qrcode/CameraPreview;)V

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->post(Ljava/lang/Runnable;)Z

    goto :goto_0
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 1
    .param p1, "surfaceHolder"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 40
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mSurfaceCreated:Z

    .line 41
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 1
    .param p1, "surfaceHolder"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 59
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->mSurfaceCreated:Z

    .line 60
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->stopCameraPreview()V

    .line 61
    return-void
.end method
