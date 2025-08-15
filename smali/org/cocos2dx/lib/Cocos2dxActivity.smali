.class public abstract Lorg/cocos2dx/lib/Cocos2dxActivity;
.super Landroid/app/Activity;
.source "Cocos2dxActivity.java"

# interfaces
.implements Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;
    }
.end annotation


# static fields
.field private static final TAG:Ljava/lang/String;

.field private static sContext:Lorg/cocos2dx/lib/Cocos2dxActivity;


# instance fields
.field private _remoteRenders:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lorg/cocos2dx/lib/VideoRtcView;",
            ">;"
        }
    .end annotation
.end field

.field private hasFocus:Z

.field private mEditBoxHelper:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;

.field protected mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

.field private mGLContextAttrs:[I

.field private mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

.field private mHandler:Lorg/cocos2dx/lib/Cocos2dxHandler;

.field private mVideoHelper:Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

.field private mWebViewHelper:Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

.field private showVirtualButton:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 60
    const-class v0, Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    .line 69
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->sContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .prologue
    const/4 v0, 0x0

    const/4 v1, 0x0

    .line 55
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 66
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    .line 67
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLContextAttrs:[I

    .line 68
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mHandler:Lorg/cocos2dx/lib/Cocos2dxHandler;

    .line 70
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mVideoHelper:Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 71
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mWebViewHelper:Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

    .line 72
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mEditBoxHelper:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;

    .line 73
    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->hasFocus:Z

    .line 74
    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->showVirtualButton:Z

    .line 76
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->_remoteRenders:Ljava/util/ArrayList;

    .line 244
    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/Cocos2dxActivity;)Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxActivity;

    .prologue
    .line 55
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    return-object v0
.end method

.method public static getContext()Landroid/content/Context;
    .locals 1

    .prologue
    .line 83
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->sContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-object v0
.end method

.method private static native getGLContextAttrs()[I
.end method

.method private initVideoView()V
    .locals 5

    .prologue
    const/16 v4, 0x14

    .line 288
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    const/16 v3, 0x8

    if-ge v0, v3, :cond_0

    .line 289
    new-instance v2, Landroid/view/ViewGroup$LayoutParams;

    invoke-direct {v2, v4, v4}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    .line 291
    .local v2, "params":Landroid/view/ViewGroup$LayoutParams;
    new-instance v1, Lorg/cocos2dx/lib/VideoRtcView;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/VideoRtcView;-><init>(Landroid/content/Context;)V

    .line 292
    .local v1, "layout":Lorg/cocos2dx/lib/VideoRtcView;
    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/VideoRtcView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 293
    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Lorg/cocos2dx/lib/VideoRtcView;->setBackgroundColor(I)V

    .line 294
    const-string v3, ""

    invoke-virtual {v1, v3}, Lorg/cocos2dx/lib/VideoRtcView;->setTag(Ljava/lang/Object;)V

    .line 296
    const/4 v3, 0x4

    invoke-virtual {v1, v3}, Lorg/cocos2dx/lib/VideoRtcView;->setVisibility(I)V

    .line 298
    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-virtual {v3, v1}, Lorg/cocos2dx/lib/ResizeLayout;->addView(Landroid/view/View;)V

    .line 299
    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->_remoteRenders:Ljava/util/ArrayList;

    invoke-virtual {v3, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 288
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 301
    .end local v1    # "layout":Lorg/cocos2dx/lib/VideoRtcView;
    .end local v2    # "params":Landroid/view/ViewGroup$LayoutParams;
    :cond_0
    return-void
.end method

.method private static isAndroidEmulator()Z
    .locals 6

    .prologue
    .line 355
    sget-object v1, Landroid/os/Build;->MODEL:Ljava/lang/String;

    .line 356
    .local v1, "model":Ljava/lang/String;
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "model="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 357
    sget-object v2, Landroid/os/Build;->PRODUCT:Ljava/lang/String;

    .line 358
    .local v2, "product":Ljava/lang/String;
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "product="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 359
    const/4 v0, 0x0

    .line 360
    .local v0, "isEmulator":Z
    if-eqz v2, :cond_1

    .line 361
    const-string v3, "sdk"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "_sdk"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-nez v3, :cond_0

    const-string v3, "sdk_"

    invoke-virtual {v2, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_2

    :cond_0
    const/4 v0, 0x1

    .line 363
    :cond_1
    :goto_0
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "isEmulator="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 364
    return v0

    .line 361
    :cond_2
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private resumeIfHasFocus()V
    .locals 1

    .prologue
    .line 195
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->hasFocus:Z

    if-eqz v0, :cond_0

    .line 196
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->hideVirtualButton()V

    .line 197
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->onResume()V

    .line 198
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->onResume()V

    .line 200
    :cond_0
    return-void
.end method


# virtual methods
.method public getGLSurfaceView()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    .locals 1

    .prologue
    .line 79
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    return-object v0
.end method

.method public getVideoViews()Ljava/util/ArrayList;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/ArrayList",
            "<",
            "Lorg/cocos2dx/lib/VideoRtcView;",
            ">;"
        }
    .end annotation

    .prologue
    .line 304
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->_remoteRenders:Ljava/util/ArrayList;

    return-object v0
.end method

.method protected hideVirtualButton()V
    .locals 14

    .prologue
    .line 320
    iget-boolean v9, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->showVirtualButton:Z

    if-eqz v9, :cond_1

    .line 352
    :cond_0
    :goto_0
    return-void

    .line 324
    :cond_1
    sget v9, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v10, 0x13

    if-lt v9, v10, :cond_0

    .line 327
    const-class v8, Landroid/view/View;

    .line 330
    .local v8, "viewClass":Ljava/lang/Class;
    :try_start_0
    const-string v9, "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 331
    .local v4, "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION":I
    const-string v9, "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 332
    .local v3, "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN":I
    const-string v9, "SYSTEM_UI_FLAG_HIDE_NAVIGATION"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 333
    .local v1, "SYSTEM_UI_FLAG_HIDE_NAVIGATION":I
    const-string v9, "SYSTEM_UI_FLAG_FULLSCREEN"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v0

    .line 334
    .local v0, "SYSTEM_UI_FLAG_FULLSCREEN":I
    const-string v9, "SYSTEM_UI_FLAG_IMMERSIVE_STICKY"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 335
    .local v2, "SYSTEM_UI_FLAG_IMMERSIVE_STICKY":I
    const-string v9, "SYSTEM_UI_FLAG_LAYOUT_STABLE"

    invoke-static {v8, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/Integer;

    invoke-virtual {v9}, Ljava/lang/Integer;->intValue()I

    move-result v5

    .line 338
    .local v5, "SYSTEM_UI_FLAG_LAYOUT_STABLE":I
    const/4 v9, 0x1

    new-array v7, v9, [Ljava/lang/Object;

    const/4 v9, 0x0

    or-int v10, v5, v4

    or-int/2addr v10, v3

    or-int/2addr v10, v1

    or-int/2addr v10, v0

    or-int/2addr v10, v2

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v7, v9

    .line 344
    .local v7, "parameters":[Ljava/lang/Object;
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getWindow()Landroid/view/Window;

    move-result-object v9

    invoke-virtual {v9}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v9

    const-string v10, "setSystemUiVisibility"

    const/4 v11, 0x1

    new-array v11, v11, [Ljava/lang/Class;

    const/4 v12, 0x0

    sget-object v13, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v13, v11, v12

    invoke-static {v9, v10, v11, v7}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->invokeInstanceMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 348
    .end local v0    # "SYSTEM_UI_FLAG_FULLSCREEN":I
    .end local v1    # "SYSTEM_UI_FLAG_HIDE_NAVIGATION":I
    .end local v2    # "SYSTEM_UI_FLAG_IMMERSIVE_STICKY":I
    .end local v3    # "SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN":I
    .end local v4    # "SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION":I
    .end local v5    # "SYSTEM_UI_FLAG_LAYOUT_STABLE":I
    .end local v7    # "parameters":[Ljava/lang/Object;
    :catch_0
    move-exception v6

    .line 349
    .local v6, "e":Ljava/lang/NullPointerException;
    sget-object v9, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    const-string v10, "hideVirtualButton"

    invoke-static {v9, v10, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_0
.end method

.method public init()V
    .locals 10

    .prologue
    const/4 v2, -0x1

    const/16 v1, 0x8

    .line 251
    new-instance v9, Landroid/view/ViewGroup$LayoutParams;

    invoke-direct {v9, v2, v2}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    .line 255
    .local v9, "framelayout_params":Landroid/view/ViewGroup$LayoutParams;
    new-instance v0, Lorg/cocos2dx/lib/ResizeLayout;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/ResizeLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    .line 257
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-virtual {v0, v9}, Lorg/cocos2dx/lib/ResizeLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 260
    new-instance v8, Landroid/view/ViewGroup$LayoutParams;

    const/4 v0, -0x2

    invoke-direct {v8, v2, v0}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    .line 263
    .local v8, "edittext_layout_params":Landroid/view/ViewGroup$LayoutParams;
    new-instance v7, Lorg/cocos2dx/lib/Cocos2dxEditBox;

    invoke-direct {v7, p0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;-><init>(Landroid/content/Context;)V

    .line 264
    .local v7, "edittext":Lorg/cocos2dx/lib/Cocos2dxEditBox;
    invoke-virtual {v7, v8}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 267
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-virtual {v0, v7}, Lorg/cocos2dx/lib/ResizeLayout;->addView(Landroid/view/View;)V

    .line 270
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onCreateView()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    move-result-object v0

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    .line 273
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/ResizeLayout;->addView(Landroid/view/View;)V

    .line 276
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->isAndroidEmulator()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 277
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    const/16 v5, 0x10

    const/4 v6, 0x0

    move v2, v1

    move v3, v1

    move v4, v1

    invoke-virtual/range {v0 .. v6}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setEGLConfigChooser(IIIIII)V

    .line 279
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxRenderer;

    invoke-direct {v1}, Lorg/cocos2dx/lib/Cocos2dxRenderer;-><init>()V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setCocos2dxRenderer(Lorg/cocos2dx/lib/Cocos2dxRenderer;)V

    .line 280
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0, v7}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setCocos2dxEditText(Lorg/cocos2dx/lib/Cocos2dxEditBox;)V

    .line 282
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->initVideoView()V

    .line 284
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->setContentView(Landroid/view/View;)V

    .line 285
    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 3
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .prologue
    .line 236
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getOnActivityResultListeners()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/preference/PreferenceManager$OnActivityResultListener;

    .line 237
    .local v0, "listener":Landroid/preference/PreferenceManager$OnActivityResultListener;
    invoke-interface {v0, p1, p2, p3}, Landroid/preference/PreferenceManager$OnActivityResultListener;->onActivityResult(IILandroid/content/Intent;)Z

    goto :goto_0

    .line 240
    .end local v0    # "listener":Landroid/preference/PreferenceManager$OnActivityResultListener;
    :cond_0
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    .line 241
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    const/16 v2, 0x80

    .line 117
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 120
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->isTaskRoot()Z

    move-result v1

    if-nez v1, :cond_0

    .line 124
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->finish()V

    .line 125
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    const-string v2, "[Workaround] Ignore the activity started from icon!"

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 161
    :goto_0
    return-void

    .line 129
    :cond_0
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->hideVirtualButton()V

    .line 131
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onLoadNativeLibraries()V

    .line 133
    sput-object p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->sContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 134
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxHandler;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxHandler;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;)V

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mHandler:Lorg/cocos2dx/lib/Cocos2dxHandler;

    .line 136
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxHelper;->init(Landroid/app/Activity;)V

    .line 137
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getWindow()Landroid/view/Window;

    move-result-object v1

    invoke-virtual {v1, v2, v2}, Landroid/view/Window;->setFlags(II)V

    .line 139
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getGLContextAttrs()[I

    move-result-object v1

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLContextAttrs:[I

    .line 140
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->init()V

    .line 142
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mVideoHelper:Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    if-nez v1, :cond_1

    .line 143
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-direct {v1, p0, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;Landroid/widget/FrameLayout;)V

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mVideoHelper:Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 146
    :cond_1
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mWebViewHelper:Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

    if-nez v1, :cond_2

    .line 147
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-direct {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;-><init>(Landroid/widget/FrameLayout;)V

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mWebViewHelper:Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

    .line 150
    :cond_2
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mEditBoxHelper:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;

    if-nez v1, :cond_3

    .line 151
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    invoke-direct {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;-><init>(Lorg/cocos2dx/lib/ResizeLayout;)V

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mEditBoxHelper:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;

    .line 154
    :cond_3
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    .line 155
    .local v0, "window":Landroid/view/Window;
    const/16 v1, 0x20

    invoke-virtual {v0, v1}, Landroid/view/Window;->setSoftInputMode(I)V

    .line 158
    const/4 v1, 0x3

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->setVolumeControlStream(I)V

    .line 160
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-static {p0, v1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->init(Landroid/content/Context;Landroid/opengl/GLSurfaceView;)Z

    goto :goto_0
.end method

.method public onCreateView()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    .locals 4

    .prologue
    .line 308
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;-><init>(Landroid/content/Context;)V

    .line 310
    .local v1, "glSurfaceView":Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLContextAttrs:[I

    const/4 v3, 0x3

    aget v2, v2, v3

    if-lez v2, :cond_0

    invoke-virtual {v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v2

    const/4 v3, -0x3

    invoke-interface {v2, v3}, Landroid/view/SurfaceHolder;->setFormat(I)V

    .line 313
    :cond_0
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLContextAttrs:[I

    invoke-direct {v0, p0, v2}, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;[I)V

    .line 314
    .local v0, "chooser":Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;
    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setEGLConfigChooser(Landroid/opengl/GLSurfaceView$EGLConfigChooser;)V

    .line 316
    return-object v1
.end method

.method protected onDestroy()V
    .locals 0

    .prologue
    .line 214
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxAudioFocusManager;->unregisterAudioFocusListener(Landroid/content/Context;)V

    .line 215
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 217
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->destroy()V

    .line 218
    return-void
.end method

.method protected onLoadNativeLibraries()V
    .locals 7

    .prologue
    .line 102
    :try_start_0
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v4

    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    const/16 v6, 0x80

    invoke-virtual {v4, v5, v6}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v0

    .line 103
    .local v0, "ai":Landroid/content/pm/ApplicationInfo;
    iget-object v1, v0, Landroid/content/pm/ApplicationInfo;->metaData:Landroid/os/Bundle;

    .line 104
    .local v1, "bundle":Landroid/os/Bundle;
    const-string v4, "android.app.lib_name"

    invoke-virtual {v1, v4}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 105
    .local v3, "libName":Ljava/lang/String;
    invoke-static {v3}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 109
    .end local v0    # "ai":Landroid/content/pm/ApplicationInfo;
    .end local v1    # "bundle":Landroid/os/Bundle;
    .end local v3    # "libName":Ljava/lang/String;
    :goto_0
    return-void

    .line 106
    :catch_0
    move-exception v2

    .line 107
    .local v2, "e":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method protected onPause()V
    .locals 2

    .prologue
    .line 204
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    const-string v1, "onPause()"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 205
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    .line 206
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxAudioFocusManager;->unregisterAudioFocusListener(Landroid/content/Context;)V

    .line 207
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->onPause()V

    .line 208
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->onPause()V

    .line 209
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->pause()V

    .line 210
    return-void
.end method

.method protected onResume()V
    .locals 2

    .prologue
    .line 176
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    const-string v1, "onResume()"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 177
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 178
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxAudioFocusManager;->registerAudioFocusListener(Landroid/content/Context;)Z

    .line 179
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->hideVirtualButton()V

    .line 180
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->resumeIfHasFocus()V

    .line 182
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->resume()V

    .line 183
    return-void
.end method

.method public onWindowFocusChanged(Z)V
    .locals 3
    .param p1, "hasFocus"    # Z

    .prologue
    .line 187
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxActivity;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onWindowFocusChanged() hasFocus="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 188
    invoke-super {p0, p1}, Landroid/app/Activity;->onWindowFocusChanged(Z)V

    .line 190
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->hasFocus:Z

    .line 191
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->resumeIfHasFocus()V

    .line 192
    return-void
.end method

.method public runOnGLThread(Ljava/lang/Runnable;)V
    .locals 1
    .param p1, "pRunnable"    # Ljava/lang/Runnable;

    .prologue
    .line 230
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0, p1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 231
    return-void
.end method

.method public setEnableVirtualButton(Z)V
    .locals 0
    .param p1, "value"    # Z

    .prologue
    .line 97
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->showVirtualButton:Z

    .line 98
    return-void
.end method

.method public setKeepScreenOn(Z)V
    .locals 2
    .param p1, "value"    # Z

    .prologue
    .line 87
    move v0, p1

    .line 88
    .local v0, "newValue":Z
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxActivity$1;

    invoke-direct {v1, p0, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;Z)V

    invoke-virtual {p0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 94
    return-void
.end method

.method public showDialog(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p1, "pTitle"    # Ljava/lang/String;
    .param p2, "pMessage"    # Ljava/lang/String;

    .prologue
    .line 222
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 223
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x1

    iput v1, v0, Landroid/os/Message;->what:I

    .line 224
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxHandler$DialogMessage;

    invoke-direct {v1, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxHandler$DialogMessage;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    iput-object v1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 225
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity;->mHandler:Lorg/cocos2dx/lib/Cocos2dxHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxHandler;->sendMessage(Landroid/os/Message;)Z

    .line 226
    return-void
.end method
