.class Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;
.super Ljava/lang/Object;
.source "Cocos2dxActivity.java"

# interfaces
.implements Landroid/opengl/GLSurfaceView$EGLConfigChooser;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/lib/Cocos2dxActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Cocos2dxEGLConfigChooser"
.end annotation


# instance fields
.field private final EGL_OPENGL_ES2_BIT:I

.field private final EGL_OPENGL_ES3_BIT:I

.field private mConfigAttributes:[I

.field final synthetic this$0:Lorg/cocos2dx/lib/Cocos2dxActivity;


# direct methods
.method public constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;IIIIII)V
    .locals 3
    .param p2, "redSize"    # I
    .param p3, "greenSize"    # I
    .param p4, "blueSize"    # I
    .param p5, "alphaSize"    # I
    .param p6, "depthSize"    # I
    .param p7, "stencilSize"    # I

    .prologue
    const/4 v2, 0x4

    .line 377
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->this$0:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 374
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->EGL_OPENGL_ES2_BIT:I

    .line 375
    const/16 v0, 0x40

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->EGL_OPENGL_ES3_BIT:I

    .line 378
    const/4 v0, 0x6

    new-array v0, v0, [I

    const/4 v1, 0x0

    aput p2, v0, v1

    const/4 v1, 0x1

    aput p3, v0, v1

    const/4 v1, 0x2

    aput p4, v0, v1

    const/4 v1, 0x3

    aput p5, v0, v1

    aput p6, v0, v2

    const/4 v1, 0x5

    aput p7, v0, v1

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    .line 379
    return-void
.end method

.method public constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;[I)V
    .locals 1
    .param p2, "attributes"    # [I

    .prologue
    .line 381
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->this$0:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 374
    const/4 v0, 0x4

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->EGL_OPENGL_ES2_BIT:I

    .line 375
    const/16 v0, 0x40

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->EGL_OPENGL_ES3_BIT:I

    .line 382
    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    .line 383
    return-void
.end method

.method private doChooseConfig(Ljavax/microedition/khronos/egl/EGL10;Ljavax/microedition/khronos/egl/EGLDisplay;[I)Ljavax/microedition/khronos/egl/EGLConfig;
    .locals 8
    .param p1, "egl"    # Ljavax/microedition/khronos/egl/EGL10;
    .param p2, "display"    # Ljavax/microedition/khronos/egl/EGLDisplay;
    .param p3, "attributes"    # [I

    .prologue
    const/4 v7, 0x0

    const/4 v4, 0x1

    .line 430
    new-array v3, v4, [Ljavax/microedition/khronos/egl/EGLConfig;

    .line 431
    .local v3, "configs":[Ljavax/microedition/khronos/egl/EGLConfig;
    new-array v5, v4, [I

    .local v5, "matchedConfigNum":[I
    move-object v0, p1

    move-object v1, p2

    move-object v2, p3

    .line 432
    invoke-interface/range {v0 .. v5}, Ljavax/microedition/khronos/egl/EGL10;->eglChooseConfig(Ljavax/microedition/khronos/egl/EGLDisplay;[I[Ljavax/microedition/khronos/egl/EGLConfig;I[I)Z

    move-result v6

    .line 433
    .local v6, "result":Z
    if-eqz v6, :cond_0

    aget v0, v5, v7

    if-lez v0, :cond_0

    .line 434
    aget-object v0, v3, v7

    .line 436
    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method


# virtual methods
.method public chooseConfig(Ljavax/microedition/khronos/egl/EGL10;Ljavax/microedition/khronos/egl/EGLDisplay;)Ljavax/microedition/khronos/egl/EGLConfig;
    .locals 12
    .param p1, "egl"    # Ljavax/microedition/khronos/egl/EGL10;
    .param p2, "display"    # Ljavax/microedition/khronos/egl/EGLDisplay;

    .prologue
    const/4 v11, 0x2

    const/4 v10, 0x1

    const/4 v9, 0x3

    const/4 v4, 0x0

    const/4 v8, 0x4

    .line 388
    new-array v0, v9, [[I

    const/16 v3, 0xf

    new-array v3, v3, [I

    const/16 v5, 0x3024

    aput v5, v3, v4

    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v5, v5, v4

    aput v5, v3, v10

    const/16 v5, 0x3023

    aput v5, v3, v11

    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v5, v5, v10

    aput v5, v3, v9

    const/16 v5, 0x3022

    aput v5, v3, v8

    const/4 v5, 0x5

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v6, v6, v11

    aput v6, v3, v5

    const/4 v5, 0x6

    const/16 v6, 0x3021

    aput v6, v3, v5

    const/4 v5, 0x7

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v6, v6, v9

    aput v6, v3, v5

    const/16 v5, 0x8

    const/16 v6, 0x3025

    aput v6, v3, v5

    const/16 v5, 0x9

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v6, v6, v8

    aput v6, v3, v5

    const/16 v5, 0xa

    const/16 v6, 0x3026

    aput v6, v3, v5

    const/16 v5, 0xb

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    const/4 v7, 0x5

    aget v6, v6, v7

    aput v6, v3, v5

    const/16 v5, 0xc

    const/16 v6, 0x3040

    aput v6, v3, v5

    const/16 v5, 0xd

    aput v8, v3, v5

    const/16 v5, 0xe

    const/16 v6, 0x3038

    aput v6, v3, v5

    aput-object v3, v0, v4

    const/16 v3, 0xf

    new-array v5, v3, [I

    const/16 v3, 0x3024

    aput v3, v5, v4

    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v3, v3, v4

    aput v3, v5, v10

    const/16 v3, 0x3023

    aput v3, v5, v11

    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v3, v3, v10

    aput v3, v5, v9

    const/16 v3, 0x3022

    aput v3, v5, v8

    const/4 v3, 0x5

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v6, v6, v11

    aput v6, v5, v3

    const/4 v3, 0x6

    const/16 v6, 0x3021

    aput v6, v5, v3

    const/4 v3, 0x7

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v6, v6, v9

    aput v6, v5, v3

    const/16 v3, 0x8

    const/16 v6, 0x3025

    aput v6, v5, v3

    const/16 v6, 0x9

    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v3, v3, v8

    const/16 v7, 0x18

    if-lt v3, v7, :cond_0

    const/16 v3, 0x10

    :goto_0
    aput v3, v5, v6

    const/16 v3, 0xa

    const/16 v6, 0x3026

    aput v6, v5, v3

    const/16 v3, 0xb

    iget-object v6, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    const/4 v7, 0x5

    aget v6, v6, v7

    aput v6, v5, v3

    const/16 v3, 0xc

    const/16 v6, 0x3040

    aput v6, v5, v3

    const/16 v3, 0xd

    aput v8, v5, v3

    const/16 v3, 0xe

    const/16 v6, 0x3038

    aput v6, v5, v3

    aput-object v5, v0, v10

    new-array v3, v9, [I

    fill-array-data v3, :array_0

    aput-object v3, v0, v11

    .line 418
    .local v0, "EGLAttributes":[[I
    const/4 v2, 0x0

    .line 419
    .local v2, "result":Ljavax/microedition/khronos/egl/EGLConfig;
    array-length v5, v0

    move v3, v4

    :goto_1
    if-ge v3, v5, :cond_2

    aget-object v1, v0, v3

    .line 420
    .local v1, "eglAtribute":[I
    invoke-direct {p0, p1, p2, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->doChooseConfig(Ljavax/microedition/khronos/egl/EGL10;Ljavax/microedition/khronos/egl/EGLDisplay;[I)Ljavax/microedition/khronos/egl/EGLConfig;

    move-result-object v2

    .line 421
    if-eqz v2, :cond_1

    move-object v3, v2

    .line 426
    .end local v1    # "eglAtribute":[I
    :goto_2
    return-object v3

    .line 388
    .end local v0    # "EGLAttributes":[[I
    .end local v2    # "result":Ljavax/microedition/khronos/egl/EGLConfig;
    :cond_0
    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxActivity$Cocos2dxEGLConfigChooser;->mConfigAttributes:[I

    aget v3, v3, v8

    goto :goto_0

    .line 419
    .restart local v0    # "EGLAttributes":[[I
    .restart local v1    # "eglAtribute":[I
    .restart local v2    # "result":Ljavax/microedition/khronos/egl/EGLConfig;
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 425
    .end local v1    # "eglAtribute":[I
    :cond_2
    const-string v3, "device_policy"

    const-string v4, "Can not select an EGLConfig for rendering."

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 426
    const/4 v3, 0x0

    goto :goto_2

    .line 388
    :array_0
    .array-data 4
        0x3040
        0x4
        0x3038
    .end array-data
.end method
