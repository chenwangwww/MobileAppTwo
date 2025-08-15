.class public Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
.super Landroid/opengl/GLSurfaceView;
.source "Cocos2dxGLSurfaceView.java"


# static fields
.field private static final HANDLER_CLOSE_IME_KEYBOARD:I = 0x3

.field private static final HANDLER_OPEN_IME_KEYBOARD:I = 0x2

.field private static final TAG:Ljava/lang/String;

.field private static mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

.field private static sCocos2dxTextInputWraper:Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

.field private static sHandler:Landroid/os/Handler;


# instance fields
.field private mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

.field private mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

.field private mMultipleTouchEnabled:Z

.field private mSoftKeyboardShown:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 43
    const-class v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    .line 85
    invoke-direct {p0, p1}, Landroid/opengl/GLSurfaceView;-><init>(Landroid/content/Context;)V

    .line 61
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    .line 62
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    .line 87
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->initView()V

    .line 88
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .prologue
    .line 91
    invoke-direct {p0, p1, p2}, Landroid/opengl/GLSurfaceView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 61
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    .line 62
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    .line 93
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->initView()V

    .line 94
    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)Lorg/cocos2dx/lib/Cocos2dxEditBox;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    .prologue
    .line 38
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    return-object v0
.end method

.method static synthetic access$100()Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;
    .locals 1

    .prologue
    .line 38
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sCocos2dxTextInputWraper:Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

    return-object v0
.end method

.method static synthetic access$200()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    .locals 1

    .prologue
    .line 38
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    return-object v0
.end method

.method static synthetic access$300(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)Lorg/cocos2dx/lib/Cocos2dxRenderer;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    .prologue
    .line 38
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

    return-object v0
.end method

.method public static closeIMEKeyboard()V
    .locals 2

    .prologue
    .line 428
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 429
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x3

    iput v1, v0, Landroid/os/Message;->what:I

    .line 430
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sHandler:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 431
    return-void
.end method

.method private static dumpMotionEvent(Landroid/view/MotionEvent;)V
    .locals 9
    .param p0, "event"    # Landroid/view/MotionEvent;

    .prologue
    const/4 v8, 0x6

    const/4 v7, 0x5

    .line 452
    const/16 v5, 0xa

    new-array v3, v5, [Ljava/lang/String;

    const/4 v5, 0x0

    const-string v6, "DOWN"

    aput-object v6, v3, v5

    const/4 v5, 0x1

    const-string v6, "UP"

    aput-object v6, v3, v5

    const/4 v5, 0x2

    const-string v6, "MOVE"

    aput-object v6, v3, v5

    const/4 v5, 0x3

    const-string v6, "CANCEL"

    aput-object v6, v3, v5

    const/4 v5, 0x4

    const-string v6, "OUTSIDE"

    aput-object v6, v3, v5

    const-string v5, "POINTER_DOWN"

    aput-object v5, v3, v7

    const-string v5, "POINTER_UP"

    aput-object v5, v3, v8

    const/4 v5, 0x7

    const-string v6, "7?"

    aput-object v6, v3, v5

    const/16 v5, 0x8

    const-string v6, "8?"

    aput-object v6, v3, v5

    const/16 v5, 0x9

    const-string v6, "9?"

    aput-object v6, v3, v5

    .line 453
    .local v3, "names":[Ljava/lang/String;
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    .line 454
    .local v4, "sb":Ljava/lang/StringBuilder;
    invoke-virtual {p0}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    .line 455
    .local v0, "action":I
    and-int/lit16 v1, v0, 0xff

    .line 456
    .local v1, "actionCode":I
    const-string v5, "event ACTION_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    aget-object v6, v3, v1

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 457
    if-eq v1, v7, :cond_0

    if-ne v1, v8, :cond_1

    .line 458
    :cond_0
    const-string v5, "(pid "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    shr-int/lit8 v6, v0, 0x8

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 459
    const-string v5, ")"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 461
    :cond_1
    const-string v5, "["

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 462
    const/4 v2, 0x0

    .local v2, "i":I
    :goto_0
    invoke-virtual {p0}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v5

    if-ge v2, v5, :cond_3

    .line 463
    const-string v5, "#"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 464
    const-string v5, "(pid "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {p0, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 465
    const-string v5, ")="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {p0, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v6

    float-to-int v6, v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 466
    const-string v5, ","

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {p0, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result v6

    float-to-int v6, v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 467
    add-int/lit8 v5, v2, 0x1

    invoke-virtual {p0}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v6

    if-ge v5, v6, :cond_2

    .line 468
    const-string v5, ";"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 462
    :cond_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 471
    :cond_3
    const-string v5, "]"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 472
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->TAG:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 473
    return-void
.end method

.method private getContentText()Ljava/lang/String;
    .locals 1

    .prologue
    .line 161
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->getContentText()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static getInstance()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;
    .locals 1

    .prologue
    .line 143
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    return-object v0
.end method

.method public static openIMEKeyboard()V
    .locals 2

    .prologue
    .line 421
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 422
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x2

    iput v1, v0, Landroid/os/Message;->what:I

    .line 423
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    invoke-direct {v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->getContentText()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 424
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sHandler:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->sendMessage(Landroid/os/Message;)Z

    .line 425
    return-void
.end method

.method public static queueAccelerometer(FFFJ)V
    .locals 7
    .param p0, "x"    # F
    .param p1, "y"    # F
    .param p2, "z"    # F
    .param p3, "timestamp"    # J

    .prologue
    .line 147
    sget-object v6, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$2;

    move v1, p0

    move v2, p1

    move v3, p2

    move-wide v4, p3

    invoke-direct/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$2;-><init>(FFFJ)V

    invoke-virtual {v6, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 153
    return-void
.end method


# virtual methods
.method public deleteBackward()V
    .locals 1

    .prologue
    .line 443
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$16;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$16;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 449
    return-void
.end method

.method public getCocos2dxEditText()Lorg/cocos2dx/lib/Cocos2dxEditBox;
    .locals 1

    .prologue
    .line 165
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    return-object v0
.end method

.method protected initView()V
    .locals 1

    .prologue
    .line 97
    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setEGLContextClientVersion(I)V

    .line 98
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setFocusableInTouchMode(Z)V

    .line 100
    sput-object p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxGLSurfaceView:Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    .line 101
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sCocos2dxTextInputWraper:Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

    .line 103
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sHandler:Landroid/os/Handler;

    .line 135
    return-void
.end method

.method public insertText(Ljava/lang/String;)V
    .locals 1
    .param p1, "pText"    # Ljava/lang/String;

    .prologue
    .line 434
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$15;

    invoke-direct {v0, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$15;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;Ljava/lang/String;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 440
    return-void
.end method

.method public isMultipleTouchEnabled()Z
    .locals 1

    .prologue
    .line 73
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    return v0
.end method

.method public isSoftKeyboardShown()Z
    .locals 1

    .prologue
    .line 65
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    return v0
.end method

.method public onKeyDown(ILandroid/view/KeyEvent;)Z
    .locals 2
    .param p1, "pKeyCode"    # I
    .param p2, "pKeyEvent"    # Landroid/view/KeyEvent;

    .prologue
    .line 365
    sparse-switch p1, :sswitch_data_0

    .line 384
    invoke-super {p0, p1, p2}, Landroid/opengl/GLSurfaceView;->onKeyDown(ILandroid/view/KeyEvent;)Z

    move-result v0

    :goto_0
    return v0

    .line 367
    :sswitch_0
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    const/16 v1, 0x3e8

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendEmptyMessage(I)Z

    .line 376
    :sswitch_1
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$13;

    invoke-direct {v0, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$13;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;I)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 382
    const/4 v0, 0x1

    goto :goto_0

    .line 365
    nop

    :sswitch_data_0
    .sparse-switch
        0x4 -> :sswitch_0
        0x13 -> :sswitch_1
        0x14 -> :sswitch_1
        0x15 -> :sswitch_1
        0x16 -> :sswitch_1
        0x17 -> :sswitch_1
        0x42 -> :sswitch_1
        0x52 -> :sswitch_1
        0x55 -> :sswitch_1
    .end sparse-switch
.end method

.method public onKeyUp(ILandroid/view/KeyEvent;)Z
    .locals 1
    .param p1, "keyCode"    # I
    .param p2, "event"    # Landroid/view/KeyEvent;

    .prologue
    .line 390
    sparse-switch p1, :sswitch_data_0

    .line 408
    invoke-super {p0, p1, p2}, Landroid/opengl/GLSurfaceView;->onKeyUp(ILandroid/view/KeyEvent;)Z

    move-result v0

    :goto_0
    return v0

    .line 400
    :sswitch_0
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$14;

    invoke-direct {v0, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$14;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;I)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 406
    const/4 v0, 0x1

    goto :goto_0

    .line 390
    :sswitch_data_0
    .sparse-switch
        0x4 -> :sswitch_0
        0x13 -> :sswitch_0
        0x14 -> :sswitch_0
        0x15 -> :sswitch_0
        0x16 -> :sswitch_0
        0x17 -> :sswitch_0
        0x42 -> :sswitch_0
        0x52 -> :sswitch_0
        0x55 -> :sswitch_0
    .end sparse-switch
.end method

.method public onPause()V
    .locals 1

    .prologue
    .line 194
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$4;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$4;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 200
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setRenderMode(I)V

    .line 202
    return-void
.end method

.method public onResume()V
    .locals 1

    .prologue
    .line 182
    invoke-super {p0}, Landroid/opengl/GLSurfaceView;->onResume()V

    .line 183
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setRenderMode(I)V

    .line 184
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$3;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$3;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;)V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 190
    return-void
.end method

.method protected onSizeChanged(IIII)V
    .locals 1
    .param p1, "pNewSurfaceWidth"    # I
    .param p2, "pNewSurfaceHeight"    # I
    .param p3, "pOldSurfaceWidth"    # I
    .param p4, "pOldSurfaceHeight"    # I

    .prologue
    .line 358
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->isInEditMode()Z

    move-result v0

    if-nez v0, :cond_0

    .line 359
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

    invoke-virtual {v0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxRenderer;->setScreenWidthAndHeight(II)V

    .line 361
    :cond_0
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 33
    .param p1, "pMotionEvent"    # Landroid/view/MotionEvent;

    .prologue
    .line 207
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v15

    .line 208
    .local v15, "pointerNumber":I
    new-array v9, v15, [I

    .line 209
    .local v9, "ids":[I
    new-array v0, v15, [F

    move-object/from16 v21, v0

    .line 210
    .local v21, "xs":[F
    new-array v0, v15, [F

    move-object/from16 v28, v0

    .line 212
    .local v28, "ys":[F
    move-object/from16 v0, p0

    iget-boolean v0, v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    move/from16 v31, v0

    if-eqz v31, :cond_0

    .line 213
    invoke-virtual/range {p0 .. p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->getContext()Landroid/content/Context;

    move-result-object v31

    const-string v32, "input_method"

    invoke-virtual/range {v31 .. v32}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/view/inputmethod/InputMethodManager;

    .line 214
    .local v12, "imm":Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual/range {p0 .. p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->getContext()Landroid/content/Context;

    move-result-object v31

    check-cast v31, Landroid/app/Activity;

    invoke-virtual/range {v31 .. v31}, Landroid/app/Activity;->getCurrentFocus()Landroid/view/View;

    move-result-object v16

    .line 215
    .local v16, "view":Landroid/view/View;
    invoke-virtual/range {v16 .. v16}, Landroid/view/View;->getWindowToken()Landroid/os/IBinder;

    move-result-object v31

    const/16 v32, 0x0

    move-object/from16 v0, v31

    move/from16 v1, v32

    invoke-virtual {v12, v0, v1}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z

    .line 216
    invoke-virtual/range {p0 .. p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->requestFocus()Z

    .line 217
    const/16 v31, 0x0

    move/from16 v0, v31

    move-object/from16 v1, p0

    iput-boolean v0, v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    .line 220
    .end local v12    # "imm":Landroid/view/inputmethod/InputMethodManager;
    .end local v16    # "view":Landroid/view/View;
    :cond_0
    const/4 v4, 0x0

    .local v4, "i":I
    :goto_0
    if-ge v4, v15, :cond_1

    .line 221
    move-object/from16 v0, p1

    invoke-virtual {v0, v4}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v31

    aput v31, v9, v4

    .line 222
    move-object/from16 v0, p1

    invoke-virtual {v0, v4}, Landroid/view/MotionEvent;->getX(I)F

    move-result v31

    aput v31, v21, v4

    .line 223
    move-object/from16 v0, p1

    invoke-virtual {v0, v4}, Landroid/view/MotionEvent;->getY(I)F

    move-result v31

    aput v31, v28, v4

    .line 220
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 226
    :cond_1
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v31

    move/from16 v0, v31

    and-int/lit16 v0, v0, 0xff

    move/from16 v31, v0

    packed-switch v31, :pswitch_data_0

    .line 349
    :cond_2
    :goto_1
    :pswitch_0
    const/16 v31, 0x1

    return v31

    .line 228
    :pswitch_1
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v31

    shr-int/lit8 v14, v31, 0x8

    .line 229
    .local v14, "indexPointerDown":I
    move-object/from16 v0, p0

    iget-boolean v0, v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    move/from16 v31, v0

    if-nez v31, :cond_3

    if-nez v14, :cond_2

    .line 232
    :cond_3
    move-object/from16 v0, p1

    invoke-virtual {v0, v14}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v6

    .line 233
    .local v6, "idPointerDown":I
    move-object/from16 v0, p1

    invoke-virtual {v0, v14}, Landroid/view/MotionEvent;->getX(I)F

    move-result v18

    .line 234
    .local v18, "xPointerDown":F
    move-object/from16 v0, p1

    invoke-virtual {v0, v14}, Landroid/view/MotionEvent;->getY(I)F

    move-result v25

    .line 236
    .local v25, "yPointerDown":F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$5;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move/from16 v2, v18

    move/from16 v3, v25

    invoke-direct {v0, v1, v6, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$5;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;IFF)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto :goto_1

    .line 246
    .end local v6    # "idPointerDown":I
    .end local v14    # "indexPointerDown":I
    .end local v18    # "xPointerDown":F
    .end local v25    # "yPointerDown":F
    :pswitch_2
    const/16 v31, 0x0

    move-object/from16 v0, p1

    move/from16 v1, v31

    invoke-virtual {v0, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v5

    .line 247
    .local v5, "idDown":I
    const/16 v31, 0x0

    aget v17, v21, v31

    .line 248
    .local v17, "xDown":F
    const/16 v31, 0x0

    aget v24, v28, v31

    .line 250
    .local v24, "yDown":F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$6;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move/from16 v2, v17

    move/from16 v3, v24

    invoke-direct {v0, v1, v5, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$6;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;IFF)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto :goto_1

    .line 259
    .end local v5    # "idDown":I
    .end local v17    # "xDown":F
    .end local v24    # "yDown":F
    :pswitch_3
    move-object/from16 v0, p0

    iget-boolean v0, v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    move/from16 v31, v0

    if-nez v31, :cond_5

    .line 261
    const/4 v4, 0x0

    :goto_2
    if-ge v4, v15, :cond_2

    .line 262
    aget v31, v9, v4

    if-nez v31, :cond_4

    .line 263
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v11, v0, [I

    const/16 v31, 0x0

    const/16 v32, 0x0

    aput v32, v11, v31

    .line 264
    .local v11, "idsMove":[I
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v0, v0, [F

    move-object/from16 v23, v0

    const/16 v31, 0x0

    aget v32, v21, v4

    aput v32, v23, v31

    .line 265
    .local v23, "xsMove":[F
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v0, v0, [F

    move-object/from16 v30, v0

    const/16 v31, 0x0

    aget v32, v28, v4

    aput v32, v30, v31

    .line 266
    .local v30, "ysMove":[F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$7;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move-object/from16 v2, v23

    move-object/from16 v3, v30

    invoke-direct {v0, v1, v11, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$7;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;[I[F[F)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 261
    .end local v11    # "idsMove":[I
    .end local v23    # "xsMove":[F
    .end local v30    # "ysMove":[F
    :cond_4
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 276
    :cond_5
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$8;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move-object/from16 v2, v21

    move-object/from16 v3, v28

    invoke-direct {v0, v1, v9, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$8;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;[I[F[F)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 286
    :pswitch_4
    invoke-virtual/range {p1 .. p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v31

    shr-int/lit8 v13, v31, 0x8

    .line 287
    .local v13, "indexPointUp":I
    move-object/from16 v0, p0

    iget-boolean v0, v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    move/from16 v31, v0

    if-nez v31, :cond_6

    if-nez v13, :cond_2

    .line 290
    :cond_6
    move-object/from16 v0, p1

    invoke-virtual {v0, v13}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v7

    .line 291
    .local v7, "idPointerUp":I
    move-object/from16 v0, p1

    invoke-virtual {v0, v13}, Landroid/view/MotionEvent;->getX(I)F

    move-result v19

    .line 292
    .local v19, "xPointerUp":F
    move-object/from16 v0, p1

    invoke-virtual {v0, v13}, Landroid/view/MotionEvent;->getY(I)F

    move-result v26

    .line 294
    .local v26, "yPointerUp":F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$9;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move/from16 v2, v19

    move/from16 v3, v26

    invoke-direct {v0, v1, v7, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$9;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;IFF)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 304
    .end local v7    # "idPointerUp":I
    .end local v13    # "indexPointUp":I
    .end local v19    # "xPointerUp":F
    .end local v26    # "yPointerUp":F
    :pswitch_5
    const/16 v31, 0x0

    move-object/from16 v0, p1

    move/from16 v1, v31

    invoke-virtual {v0, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v8

    .line 305
    .local v8, "idUp":I
    const/16 v31, 0x0

    aget v20, v21, v31

    .line 306
    .local v20, "xUp":F
    const/16 v31, 0x0

    aget v27, v28, v31

    .line 308
    .local v27, "yUp":F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$10;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move/from16 v2, v20

    move/from16 v3, v27

    invoke-direct {v0, v1, v8, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$10;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;IFF)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 317
    .end local v8    # "idUp":I
    .end local v20    # "xUp":F
    .end local v27    # "yUp":F
    :pswitch_6
    move-object/from16 v0, p0

    iget-boolean v0, v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    move/from16 v31, v0

    if-nez v31, :cond_8

    .line 319
    const/4 v4, 0x0

    :goto_3
    if-ge v4, v15, :cond_2

    .line 320
    aget v31, v9, v4

    if-nez v31, :cond_7

    .line 321
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v10, v0, [I

    const/16 v31, 0x0

    const/16 v32, 0x0

    aput v32, v10, v31

    .line 322
    .local v10, "idsCancel":[I
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v0, v0, [F

    move-object/from16 v22, v0

    const/16 v31, 0x0

    aget v32, v21, v4

    aput v32, v22, v31

    .line 323
    .local v22, "xsCancel":[F
    const/16 v31, 0x1

    move/from16 v0, v31

    new-array v0, v0, [F

    move-object/from16 v29, v0

    const/16 v31, 0x0

    aget v32, v28, v4

    aput v32, v29, v31

    .line 324
    .local v29, "ysCancel":[F
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$11;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move-object/from16 v2, v22

    move-object/from16 v3, v29

    invoke-direct {v0, v1, v10, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$11;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;[I[F[F)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 319
    .end local v10    # "idsCancel":[I
    .end local v22    # "xsCancel":[F
    .end local v29    # "ysCancel":[F
    :cond_7
    add-int/lit8 v4, v4, 0x1

    goto :goto_3

    .line 334
    :cond_8
    new-instance v31, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$12;

    move-object/from16 v0, v31

    move-object/from16 v1, p0

    move-object/from16 v2, v21

    move-object/from16 v3, v28

    invoke-direct {v0, v1, v9, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView$12;-><init>(Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;[I[F[F)V

    move-object/from16 v0, p0

    move-object/from16 v1, v31

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    goto/16 :goto_1

    .line 226
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_5
        :pswitch_3
        :pswitch_6
        :pswitch_0
        :pswitch_1
        :pswitch_4
    .end packed-switch
.end method

.method public setCocos2dxEditText(Lorg/cocos2dx/lib/Cocos2dxEditBox;)V
    .locals 2
    .param p1, "pCocos2dxEditText"    # Lorg/cocos2dx/lib/Cocos2dxEditBox;

    .prologue
    .line 169
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    .line 170
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    if-eqz v0, :cond_0

    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sCocos2dxTextInputWraper:Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

    if-eqz v0, :cond_0

    .line 171
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxEditText:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->sCocos2dxTextInputWraper:Lorg/cocos2dx/lib/Cocos2dxTextInputWrapper;

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setOnEditorActionListener(Landroid/widget/TextView$OnEditorActionListener;)V

    .line 172
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->requestFocus()Z

    .line 174
    :cond_0
    return-void
.end method

.method public setCocos2dxRenderer(Lorg/cocos2dx/lib/Cocos2dxRenderer;)V
    .locals 1
    .param p1, "renderer"    # Lorg/cocos2dx/lib/Cocos2dxRenderer;

    .prologue
    .line 156
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

    .line 157
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mCocos2dxRenderer:Lorg/cocos2dx/lib/Cocos2dxRenderer;

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->setRenderer(Landroid/opengl/GLSurfaceView$Renderer;)V

    .line 158
    return-void
.end method

.method public setMultipleTouchEnabled(Z)V
    .locals 0
    .param p1, "multipleTouchEnabled"    # Z

    .prologue
    .line 77
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mMultipleTouchEnabled:Z

    .line 78
    return-void
.end method

.method public setSoftKeyboardShown(Z)V
    .locals 0
    .param p1, "softKeyboardShown"    # Z

    .prologue
    .line 69
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->mSoftKeyboardShown:Z

    .line 70
    return-void
.end method
