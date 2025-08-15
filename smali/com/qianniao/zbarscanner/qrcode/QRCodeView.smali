.class public abstract Lcom/qianniao/zbarscanner/qrcode/QRCodeView;
.super Landroid/widget/FrameLayout;
.source "QRCodeView.java"

# interfaces
.implements Landroid/hardware/Camera$PreviewCallback;
.implements Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;
    }
.end annotation


# instance fields
.field protected mCamera:Landroid/hardware/Camera;

.field protected mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

.field protected mHandler:Landroid/os/Handler;

.field private mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

.field protected mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

.field protected mProcessDataTask:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

.field protected mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

.field protected mSpotAble:Z


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attributeSet"    # Landroid/util/AttributeSet;

    .prologue
    .line 21
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 22
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .prologue
    .line 25
    invoke-direct {p0, p1, p2, p3}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 17
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    .line 257
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;

    invoke-direct {v0, p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$2;-><init>(Lcom/qianniao/zbarscanner/qrcode/QRCodeView;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

    .line 26
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    .line 27
    invoke-direct {p0, p1, p2}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->initView(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 28
    return-void
.end method

.method private initView(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .prologue
    .line 31
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    .line 33
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    .line 34
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {v0, p1, p2}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->initCustomAttrs(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 36
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->addView(Landroid/view/View;)V

    .line 37
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->addView(Landroid/view/View;)V

    .line 38
    return-void
.end method

.method private startCameraById(I)V
    .locals 3
    .param p1, "cameraId"    # I

    .prologue
    .line 95
    :try_start_0
    invoke-static {p1}, Landroid/hardware/Camera;->open(I)Landroid/hardware/Camera;

    move-result-object v1

    iput-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    .line 96
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v1, v2}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->setCamera(Landroid/hardware/Camera;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 102
    :cond_0
    :goto_0
    return-void

    .line 97
    :catch_0
    move-exception v0

    .line 98
    .local v0, "e":Ljava/lang/Exception;
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    if-eqz v1, :cond_0

    .line 99
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    invoke-interface {v1}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;->onScanQRCodeOpenCameraError()V

    goto :goto_0
.end method


# virtual methods
.method protected cancelProcessDataTask()V
    .locals 1

    .prologue
    .line 199
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mProcessDataTask:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

    if-eqz v0, :cond_0

    .line 200
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mProcessDataTask:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->cancelTask()V

    .line 201
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mProcessDataTask:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

    .line 203
    :cond_0
    return-void
.end method

.method public changeToScanBarcodeStyle()V
    .locals 2

    .prologue
    .line 209
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getIsBarcode()Z

    move-result v0

    if-nez v0, :cond_0

    .line 210
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->setIsBarcode(Z)V

    .line 212
    :cond_0
    return-void
.end method

.method public changeToScanQRCodeStyle()V
    .locals 2

    .prologue
    .line 218
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getIsBarcode()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 219
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->setIsBarcode(Z)V

    .line 221
    :cond_0
    return-void
.end method

.method public closeFlashlight()V
    .locals 1

    .prologue
    .line 182
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->closeFlashlight()V

    .line 183
    return-void
.end method

.method public getIsScanBarcodeStyle()Z
    .locals 1

    .prologue
    .line 229
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getIsBarcode()Z

    move-result v0

    return v0
.end method

.method public hiddenScanRect()V
    .locals 2

    .prologue
    .line 62
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    if-eqz v0, :cond_0

    .line 63
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->setVisibility(I)V

    .line 65
    :cond_0
    return-void
.end method

.method public onDestroy()V
    .locals 1

    .prologue
    const/4 v0, 0x0

    .line 189
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->stopCamera()V

    .line 190
    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    .line 191
    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    .line 192
    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

    .line 193
    return-void
.end method

.method public onPreviewFrame([BLandroid/hardware/Camera;)V
    .locals 6
    .param p1, "data"    # [B
    .param p2, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 234
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    if-eqz v0, :cond_0

    .line 235
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->cancelProcessDataTask()V

    .line 236
    new-instance v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;

    move-object v1, p0

    move-object v2, p2

    move-object v3, p1

    move-object v4, p0

    move-object v5, p2

    invoke-direct/range {v0 .. v5}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;-><init>(Lcom/qianniao/zbarscanner/qrcode/QRCodeView;Landroid/hardware/Camera;[BLcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;Landroid/hardware/Camera;)V

    .line 253
    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView$1;->perform()Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mProcessDataTask:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;

    .line 255
    :cond_0
    return-void
.end method

.method public openFlashlight()V
    .locals 1

    .prologue
    .line 175
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->openFlashlight()V

    .line 176
    return-void
.end method

.method public setDelegate(Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;)V
    .locals 0
    .param p1, "delegate"    # Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    .prologue
    .line 46
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;

    .line 47
    return-void
.end method

.method public showScanRect()V
    .locals 2

    .prologue
    .line 53
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    if-eqz v0, :cond_0

    .line 54
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->setVisibility(I)V

    .line 56
    :cond_0
    return-void
.end method

.method public startCamera()V
    .locals 1

    .prologue
    .line 71
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->startCamera(I)V

    .line 72
    return-void
.end method

.method public startCamera(I)V
    .locals 3
    .param p1, "cameraFacing"    # I

    .prologue
    .line 80
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    if-eqz v2, :cond_1

    .line 91
    :cond_0
    :goto_0
    return-void

    .line 83
    :cond_1
    new-instance v1, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v1}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    .line 84
    .local v1, "cameraInfo":Landroid/hardware/Camera$CameraInfo;
    const/4 v0, 0x0

    .local v0, "cameraId":I
    :goto_1
    invoke-static {}, Landroid/hardware/Camera;->getNumberOfCameras()I

    move-result v2

    if-ge v0, v2, :cond_0

    .line 85
    invoke-static {v0, v1}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    .line 86
    iget v2, v1, Landroid/hardware/Camera$CameraInfo;->facing:I

    if-ne v2, p1, :cond_2

    .line 87
    invoke-direct {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->startCameraById(I)V

    goto :goto_0

    .line 84
    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1
.end method

.method public startSpot()V
    .locals 1

    .prologue
    .line 121
    const/16 v0, 0x5dc

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->startSpotDelay(I)V

    .line 122
    return-void
.end method

.method public startSpotAndShowRect()V
    .locals 0

    .prologue
    .line 166
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->startSpot()V

    .line 167
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->showScanRect()V

    .line 168
    return-void
.end method

.method public startSpotDelay(I)V
    .locals 4
    .param p1, "delay"    # I

    .prologue
    .line 130
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    .line 132
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->startCamera()V

    .line 134
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 135
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

    int-to-long v2, p1

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 136
    return-void
.end method

.method public stopCamera()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 108
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->stopSpotAndHiddenRect()V

    .line 109
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    .line 110
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->stopCameraPreview()V

    .line 111
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mPreview:Lcom/qianniao/zbarscanner/qrcode/CameraPreview;

    invoke-virtual {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/CameraPreview;->setCamera(Landroid/hardware/Camera;)V

    .line 112
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v0}, Landroid/hardware/Camera;->release()V

    .line 113
    iput-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    .line 115
    :cond_0
    return-void
.end method

.method public stopSpot()V
    .locals 2

    .prologue
    .line 142
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->cancelProcessDataTask()V

    .line 144
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mSpotAble:Z

    .line 146
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    if-eqz v0, :cond_0

    .line 147
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mCamera:Landroid/hardware/Camera;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/hardware/Camera;->setOneShotPreviewCallback(Landroid/hardware/Camera$PreviewCallback;)V

    .line 149
    :cond_0
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    if-eqz v0, :cond_1

    .line 150
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->mOneShotPreviewCallbackTask:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 152
    :cond_1
    return-void
.end method

.method public stopSpotAndHiddenRect()V
    .locals 0

    .prologue
    .line 158
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->stopSpot()V

    .line 159
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;->hiddenScanRect()V

    .line 160
    return-void
.end method
