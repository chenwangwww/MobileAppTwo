.class public Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
.super Ljava/lang/Object;
.source "Cocos2dxVideoHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoEventRunnable;,
        Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;
    }
.end annotation


# static fields
.field static final KeyEventBack:I = 0x3e8

.field private static final VideoTaskCreate:I = 0x0

.field private static final VideoTaskFullScreen:I = 0xc

.field private static final VideoTaskKeepRatio:I = 0xb

.field private static final VideoTaskPause:I = 0x5

.field private static final VideoTaskRemove:I = 0x1

.field private static final VideoTaskRestart:I = 0xa

.field private static final VideoTaskResume:I = 0x6

.field private static final VideoTaskSeek:I = 0x8

.field private static final VideoTaskSetRect:I = 0x3

.field private static final VideoTaskSetSource:I = 0x2

.field private static final VideoTaskSetVisible:I = 0x9

.field private static final VideoTaskShowController:I = 0x63

.field private static final VideoTaskStart:I = 0x4

.field private static final VideoTaskStop:I = 0x7

.field static mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

.field private static videoTag:I


# instance fields
.field private mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field private mLayout:Landroid/widget/FrameLayout;

.field private sVideoViews:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray",
            "<",
            "Lorg/cocos2dx/lib/Cocos2dxVideoView;",
            ">;"
        }
    .end annotation
.end field

.field videoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 43
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    .line 54
    const/4 v0, 0x0

    sput v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoTag:I

    return-void
.end method

.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;Landroid/widget/FrameLayout;)V
    .locals 1
    .param p1, "activity"    # Lorg/cocos2dx/lib/Cocos2dxActivity;
    .param p2, "layout"    # Landroid/widget/FrameLayout;

    .prologue
    const/4 v0, 0x0

    .line 46
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 40
    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mLayout:Landroid/widget/FrameLayout;

    .line 41
    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 42
    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    .line 196
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    .line 47
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 48
    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mLayout:Landroid/widget/FrameLayout;

    .line 50
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    .line 51
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    .line 52
    return-void
.end method

.method private _createVideoView(I)V
    .locals 5
    .param p1, "index"    # I

    .prologue
    const/4 v4, -0x2

    .line 215
    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mLayout:Landroid/widget/FrameLayout;

    invoke-direct {v1, v2, p1, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;ILandroid/widget/FrameLayout;)V

    .line 216
    .local v1, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v2, p1, v1}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 217
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 220
    .local v0, "lParams":Landroid/widget/FrameLayout$LayoutParams;
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mLayout:Landroid/widget/FrameLayout;

    invoke-virtual {v2, v1, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 221
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setZOrderOnTop(Z)V

    .line 222
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setOnCompletionListener(Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;)V

    .line 223
    return-void
.end method

.method private _pauseVideo(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 335
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 336
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 337
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->pause()V

    .line 339
    :cond_0
    return-void
.end method

.method private _removeVideoView(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 233
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 234
    .local v0, "view":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 235
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->stopPlayback()V

    .line 236
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->remove(I)V

    .line 237
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mLayout:Landroid/widget/FrameLayout;

    invoke-virtual {v1, v0}, Landroid/widget/FrameLayout;->removeView(Landroid/view/View;)V

    .line 239
    :cond_0
    return-void
.end method

.method private _restartVideo(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 377
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 378
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 379
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->restart()V

    .line 381
    :cond_0
    return-void
.end method

.method private _resumeVideo(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 349
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 350
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 351
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->resume()V

    .line 353
    :cond_0
    return-void
.end method

.method private _seekVideoTo(II)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "msec"    # I

    .prologue
    .line 392
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 393
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 394
    invoke-virtual {v0, p2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->seekTo(I)V

    .line 396
    :cond_0
    return-void
.end method

.method private _setFullScreenEnabled(IZII)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "enabled"    # Z
    .param p3, "width"    # I
    .param p4, "height"    # I

    .prologue
    .line 295
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 296
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 297
    invoke-virtual {v0, p2, p3, p4}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setFullScreenEnabled(ZII)V

    .line 299
    :cond_0
    return-void
.end method

.method private _setVideoKeepRatio(IZ)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "enable"    # Z

    .prologue
    .line 436
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 437
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 438
    invoke-virtual {v0, p2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setKeepRatio(Z)V

    .line 440
    :cond_0
    return-void
.end method

.method private _setVideoRect(IIIII)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "left"    # I
    .param p3, "top"    # I
    .param p4, "maxWidth"    # I
    .param p5, "maxHeight"    # I

    .prologue
    .line 275
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 276
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 277
    invoke-virtual {v0, p2, p3, p4, p5}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoRect(IIII)V

    .line 279
    :cond_0
    return-void
.end method

.method private _setVideoURL(IILjava/lang/String;)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "videoSource"    # I
    .param p3, "videoUrl"    # Ljava/lang/String;

    .prologue
    .line 251
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 252
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 253
    packed-switch p2, :pswitch_data_0

    .line 264
    :cond_0
    :goto_0
    return-void

    .line 255
    :pswitch_0
    invoke-virtual {v0, p3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoFileName(Ljava/lang/String;)V

    goto :goto_0

    .line 258
    :pswitch_1
    invoke-virtual {v0, p3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoURL(Ljava/lang/String;)V

    goto :goto_0

    .line 253
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private _setVideoVisible(IZ)V
    .locals 2
    .param p1, "index"    # I
    .param p2, "visible"    # Z

    .prologue
    .line 412
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 413
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 414
    if-eqz p2, :cond_1

    .line 415
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize()V

    .line 416
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVisibility(I)V

    .line 421
    :cond_0
    :goto_0
    return-void

    .line 418
    :cond_1
    const/4 v1, 0x4

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVisibility(I)V

    goto :goto_0
.end method

.method private _showController(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 450
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 451
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 452
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->showController()V

    .line 454
    :cond_0
    return-void
.end method

.method private _startVideo(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 321
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 322
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 323
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->start()V

    .line 325
    :cond_0
    return-void
.end method

.method private _stopVideo(I)V
    .locals 2
    .param p1, "index"    # I

    .prologue
    .line 363
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v1, p1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 364
    .local v0, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v0, :cond_0

    .line 365
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->stop()V

    .line 367
    :cond_0
    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_createVideoView(I)V

    return-void
.end method

.method static synthetic access$100(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_removeVideoView(I)V

    return-void
.end method

.method static synthetic access$1000(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # Z

    .prologue
    .line 38
    invoke-direct {p0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_setVideoVisible(IZ)V

    return-void
.end method

.method static synthetic access$1100(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_restartVideo(I)V

    return-void
.end method

.method static synthetic access$1200(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # Z

    .prologue
    .line 38
    invoke-direct {p0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_setVideoKeepRatio(IZ)V

    return-void
.end method

.method static synthetic access$1300(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .prologue
    .line 38
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->onBackKeyEvent()V

    return-void
.end method

.method static synthetic access$1400(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_showController(I)V

    return-void
.end method

.method static synthetic access$1500(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)Lorg/cocos2dx/lib/Cocos2dxActivity;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .prologue
    .line 38
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-object v0
.end method

.method static synthetic access$200(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IILjava/lang/String;)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # I
    .param p3, "x3"    # Ljava/lang/String;

    .prologue
    .line 38
    invoke-direct {p0, p1, p2, p3}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_setVideoURL(IILjava/lang/String;)V

    return-void
.end method

.method static synthetic access$300(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_startVideo(I)V

    return-void
.end method

.method static synthetic access$400(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IIIII)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # I
    .param p3, "x3"    # I
    .param p4, "x4"    # I
    .param p5, "x5"    # I

    .prologue
    .line 38
    invoke-direct/range {p0 .. p5}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_setVideoRect(IIIII)V

    return-void
.end method

.method static synthetic access$500(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZII)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # Z
    .param p3, "x3"    # I
    .param p4, "x4"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1, p2, p3, p4}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_setFullScreenEnabled(IZII)V

    return-void
.end method

.method static synthetic access$600(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_pauseVideo(I)V

    return-void
.end method

.method static synthetic access$700(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_resumeVideo(I)V

    return-void
.end method

.method static synthetic access$800(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_stopVideo(I)V

    return-void
.end method

.method static synthetic access$900(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;II)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .param p1, "x1"    # I
    .param p2, "x2"    # I

    .prologue
    .line 38
    invoke-direct {p0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->_seekVideoTo(II)V

    return-void
.end method

.method public static createVideoWidget()I
    .locals 3

    .prologue
    .line 206
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 207
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x0

    iput v1, v0, Landroid/os/Message;->what:I

    .line 208
    sget v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoTag:I

    iput v1, v0, Landroid/os/Message;->arg1:I

    .line 209
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 211
    sget v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoTag:I

    add-int/lit8 v2, v1, 0x1

    sput v2, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->videoTag:I

    return v1
.end method

.method public static native nativeExecuteVideoCallback(II)V
.end method

.method private onBackKeyEvent()V
    .locals 8

    .prologue
    const/4 v7, 0x0

    .line 302
    iget-object v4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v4}, Landroid/util/SparseArray;->size()I

    move-result v3

    .line 303
    .local v3, "viewCount":I
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_0
    if-ge v0, v3, :cond_1

    .line 304
    iget-object v4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v4, v0}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v1

    .line 305
    .local v1, "key":I
    iget-object v4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->sVideoViews:Landroid/util/SparseArray;

    invoke-virtual {v4, v1}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 306
    .local v2, "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    if-eqz v2, :cond_0

    .line 307
    invoke-virtual {v2, v7, v7, v7}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setFullScreenEnabled(ZII)V

    .line 308
    iget-object v4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v5, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoEventRunnable;

    const/16 v6, 0x3e8

    invoke-direct {v5, p0, v1, v6}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoEventRunnable;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;II)V

    invoke-virtual {v4, v5}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 303
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 311
    .end local v1    # "key":I
    .end local v2    # "videoView":Lorg/cocos2dx/lib/Cocos2dxVideoView;
    :cond_1
    return-void
.end method

.method public static pauseVideo(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 328
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 329
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x5

    iput v1, v0, Landroid/os/Message;->what:I

    .line 330
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 331
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 332
    return-void
.end method

.method public static removeVideoWidget(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 226
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 227
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x1

    iput v1, v0, Landroid/os/Message;->what:I

    .line 228
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 229
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 230
    return-void
.end method

.method public static restartVideo(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 370
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 371
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0xa

    iput v1, v0, Landroid/os/Message;->what:I

    .line 372
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 373
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 374
    return-void
.end method

.method public static resumeVideo(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 342
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 343
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x6

    iput v1, v0, Landroid/os/Message;->what:I

    .line 344
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 345
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 346
    return-void
.end method

.method public static seekVideoTo(II)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "msec"    # I

    .prologue
    .line 384
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 385
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0x8

    iput v1, v0, Landroid/os/Message;->what:I

    .line 386
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 387
    iput p1, v0, Landroid/os/Message;->arg2:I

    .line 388
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 389
    return-void
.end method

.method public static setFullScreenEnabled(IZII)V
    .locals 3
    .param p0, "index"    # I
    .param p1, "enabled"    # Z
    .param p2, "width"    # I
    .param p3, "height"    # I

    .prologue
    const/4 v2, 0x0

    .line 282
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 283
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0xc

    iput v1, v0, Landroid/os/Message;->what:I

    .line 284
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 285
    if-eqz p1, :cond_0

    .line 286
    const/4 v1, 0x1

    iput v1, v0, Landroid/os/Message;->arg2:I

    .line 290
    :goto_0
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1, v2, v2, p2, p3}, Landroid/graphics/Rect;-><init>(IIII)V

    iput-object v1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 291
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 292
    return-void

    .line 288
    :cond_0
    iput v2, v0, Landroid/os/Message;->arg2:I

    goto :goto_0
.end method

.method public static setVideoKeepRatioEnabled(IZ)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "enable"    # Z

    .prologue
    .line 424
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 425
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0xb

    iput v1, v0, Landroid/os/Message;->what:I

    .line 426
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 427
    if-eqz p1, :cond_0

    .line 428
    const/4 v1, 0x1

    iput v1, v0, Landroid/os/Message;->arg2:I

    .line 432
    :goto_0
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 433
    return-void

    .line 430
    :cond_0
    const/4 v1, 0x0

    iput v1, v0, Landroid/os/Message;->arg2:I

    goto :goto_0
.end method

.method public static setVideoRect(IIIII)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "maxWidth"    # I
    .param p4, "maxHeight"    # I

    .prologue
    .line 267
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 268
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x3

    iput v1, v0, Landroid/os/Message;->what:I

    .line 269
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 270
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1, p1, p2, p3, p4}, Landroid/graphics/Rect;-><init>(IIII)V

    iput-object v1, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 271
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 272
    return-void
.end method

.method public static setVideoUrl(IILjava/lang/String;)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "videoSource"    # I
    .param p2, "videoUrl"    # Ljava/lang/String;

    .prologue
    .line 242
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 243
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x2

    iput v1, v0, Landroid/os/Message;->what:I

    .line 244
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 245
    iput p1, v0, Landroid/os/Message;->arg2:I

    .line 246
    iput-object p2, v0, Landroid/os/Message;->obj:Ljava/lang/Object;

    .line 247
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 248
    return-void
.end method

.method public static setVideoVisible(IZ)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "visible"    # Z

    .prologue
    .line 399
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 400
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0x9

    iput v1, v0, Landroid/os/Message;->what:I

    .line 401
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 402
    if-eqz p1, :cond_0

    .line 403
    const/4 v1, 0x1

    iput v1, v0, Landroid/os/Message;->arg2:I

    .line 408
    :goto_0
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 409
    return-void

    .line 405
    :cond_0
    const/4 v1, 0x0

    iput v1, v0, Landroid/os/Message;->arg2:I

    goto :goto_0
.end method

.method public static showController(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 443
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 444
    .local v0, "msg":Landroid/os/Message;
    const/16 v1, 0x63

    iput v1, v0, Landroid/os/Message;->what:I

    .line 445
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 446
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 447
    return-void
.end method

.method public static startVideo(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 314
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 315
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x4

    iput v1, v0, Landroid/os/Message;->what:I

    .line 316
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 317
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 318
    return-void
.end method

.method public static stopVideo(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 356
    new-instance v0, Landroid/os/Message;

    invoke-direct {v0}, Landroid/os/Message;-><init>()V

    .line 357
    .local v0, "msg":Landroid/os/Message;
    const/4 v1, 0x7

    iput v1, v0, Landroid/os/Message;->what:I

    .line 358
    iput p0, v0, Landroid/os/Message;->arg1:I

    .line 359
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->mVideoHandler:Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->sendMessage(Landroid/os/Message;)Z

    .line 360
    return-void
.end method
