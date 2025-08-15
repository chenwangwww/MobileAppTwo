.class public Lorg/cocos2dx/lib/Cocos2dxVideoView;
.super Landroid/view/SurfaceView;
.source "Cocos2dxVideoView.java"

# interfaces
.implements Landroid/widget/MediaController$MediaPlayerControl;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;
    }
.end annotation


# static fields
.field private static final AssetResourceRoot:Ljava/lang/String; = "assets/"

.field private static final EVENT_CLOSE:I = 0xff

.field private static final EVENT_COMPLETED:I = 0x3

.field private static final EVENT_PAUSED:I = 0x1

.field private static final EVENT_PLAYING:I = 0x0

.field private static final EVENT_STOPPED:I = 0x2

.field private static final STATE_ERROR:I = -0x1

.field private static final STATE_IDLE:I = 0x0

.field private static final STATE_PAUSED:I = 0x4

.field private static final STATE_PLAYBACK_COMPLETED:I = 0x5

.field private static final STATE_PLAYING:I = 0x3

.field private static final STATE_PREPARED:I = 0x2

.field private static final STATE_PREPARING:I = 0x1


# instance fields
.field private TAG:Ljava/lang/String;

.field private mBufferingUpdateListener:Landroid/media/MediaPlayer$OnBufferingUpdateListener;

.field protected mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field private mCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;

.field private mCurrentBufferPercentage:I

.field private mCurrentState:I

.field private mDuration:I

.field private mErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

.field protected mFullScreenEnabled:Z

.field protected mFullScreenHeight:I

.field protected mFullScreenWidth:I

.field private mIsAssetRouse:Z

.field private mKeepRatio:Z

.field private mLayout:Landroid/widget/FrameLayout;

.field private mMediaPlayer:Landroid/media/MediaPlayer;

.field private mNeedResume:Z

.field private mOnErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

.field private mOnPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

.field private mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

.field mPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

.field mSHCallback:Landroid/view/SurfaceHolder$Callback;

.field private mSeekWhenPrepared:I

.field protected mSizeChangedListener:Landroid/media/MediaPlayer$OnVideoSizeChangedListener;

.field private mSurfaceHolder:Landroid/view/SurfaceHolder;

.field private mTargetState:I

.field private mVideoFilePath:Ljava/lang/String;

.field private mVideoHeight:I

.field private mVideoUri:Landroid/net/Uri;

.field private mVideoWidth:I

.field protected mViewHeight:I

.field protected mViewLeft:I

.field private mViewTag:I

.field protected mViewTop:I

.field protected mViewWidth:I

.field protected mVisibleHeight:I

.field protected mVisibleLeft:I

.field protected mVisibleTop:I

.field protected mVisibleWidth:I

.field private videoController:Lorg/cocos2dx/lib/VideoController;


# direct methods
.method public constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;ILandroid/widget/FrameLayout;)V
    .locals 3
    .param p1, "activity"    # Lorg/cocos2dx/lib/Cocos2dxActivity;
    .param p2, "tag"    # I
    .param p3, "layout"    # Landroid/widget/FrameLayout;

    .prologue
    const/4 v2, 0x0

    const/4 v1, 0x0

    .line 102
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    .line 41
    const-string v0, "Cocos2dxVideoView"

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    .line 62
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 63
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 66
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSurfaceHolder:Landroid/view/SurfaceHolder;

    .line 67
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    .line 68
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    .line 69
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    .line 79
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 81
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewLeft:I

    .line 82
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTop:I

    .line 83
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    .line 84
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    .line 86
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    .line 87
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    .line 88
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 89
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    .line 91
    iput-boolean v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenEnabled:Z

    .line 92
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenWidth:I

    .line 93
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenHeight:I

    .line 95
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    .line 97
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mLayout:Landroid/widget/FrameLayout;

    .line 99
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    .line 197
    iput-boolean v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mNeedResume:Z

    .line 240
    iput-boolean v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    .line 241
    iput-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoFilePath:Ljava/lang/String;

    .line 353
    iput-boolean v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mKeepRatio:Z

    .line 410
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSizeChangedListener:Landroid/media/MediaPlayer$OnVideoSizeChangedListener;

    .line 423
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$2;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$2;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

    .line 450
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$3;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$3;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;

    .line 475
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$4;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$4;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    .line 530
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$5;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$5;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mBufferingUpdateListener:Landroid/media/MediaPlayer$OnBufferingUpdateListener;

    .line 572
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxVideoView$6;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView$6;-><init>(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSHCallback:Landroid/view/SurfaceHolder$Callback;

    .line 104
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    .line 105
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 106
    iput-object p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mLayout:Landroid/widget/FrameLayout;

    .line 108
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->initVideoView()V

    .line 109
    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/Cocos2dxVideoView;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    return v0
.end method

.method static synthetic access$002(Lorg/cocos2dx/lib/Cocos2dxVideoView;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # I

    .prologue
    .line 40
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    return p1
.end method

.method static synthetic access$100(Lorg/cocos2dx/lib/Cocos2dxVideoView;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    return v0
.end method

.method static synthetic access$1000(Lorg/cocos2dx/lib/Cocos2dxVideoView;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$102(Lorg/cocos2dx/lib/Cocos2dxVideoView;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # I

    .prologue
    .line 40
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    return p1
.end method

.method static synthetic access$1100(Lorg/cocos2dx/lib/Cocos2dxVideoView;)Landroid/media/MediaPlayer$OnErrorListener;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    return-object v0
.end method

.method static synthetic access$1202(Lorg/cocos2dx/lib/Cocos2dxVideoView;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # I

    .prologue
    .line 40
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentBufferPercentage:I

    return p1
.end method

.method static synthetic access$1302(Lorg/cocos2dx/lib/Cocos2dxVideoView;Landroid/view/SurfaceHolder;)Landroid/view/SurfaceHolder;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 40
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSurfaceHolder:Landroid/view/SurfaceHolder;

    return-object p1
.end method

.method static synthetic access$1400(Lorg/cocos2dx/lib/Cocos2dxVideoView;)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->openVideo()V

    return-void
.end method

.method static synthetic access$202(Lorg/cocos2dx/lib/Cocos2dxVideoView;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # I

    .prologue
    .line 40
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    return p1
.end method

.method static synthetic access$300(Lorg/cocos2dx/lib/Cocos2dxVideoView;)Landroid/media/MediaPlayer$OnPreparedListener;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

    return-object v0
.end method

.method static synthetic access$400(Lorg/cocos2dx/lib/Cocos2dxVideoView;)Landroid/media/MediaPlayer;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    return-object v0
.end method

.method static synthetic access$500(Lorg/cocos2dx/lib/Cocos2dxVideoView;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSeekWhenPrepared:I

    return v0
.end method

.method static synthetic access$600(Lorg/cocos2dx/lib/Cocos2dxVideoView;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    return v0
.end method

.method static synthetic access$602(Lorg/cocos2dx/lib/Cocos2dxVideoView;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # I

    .prologue
    .line 40
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    return p1
.end method

.method static synthetic access$700(Lorg/cocos2dx/lib/Cocos2dxVideoView;Z)V
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;
    .param p1, "x1"    # Z

    .prologue
    .line 40
    invoke-direct {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->release(Z)V

    return-void
.end method

.method static synthetic access$800(Lorg/cocos2dx/lib/Cocos2dxVideoView;)Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    return-object v0
.end method

.method static synthetic access$900(Lorg/cocos2dx/lib/Cocos2dxVideoView;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 40
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    return v0
.end method

.method private initVideoView()V
    .locals 4

    .prologue
    const/4 v3, 0x1

    const/4 v2, 0x0

    .line 215
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    .line 216
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    .line 217
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSHCallback:Landroid/view/SurfaceHolder$Callback;

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 219
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    const/4 v1, 0x3

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->setType(I)V

    .line 220
    invoke-virtual {p0, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setFocusable(Z)V

    .line 221
    invoke-virtual {p0, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setFocusableInTouchMode(Z)V

    .line 222
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 223
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 224
    return-void
.end method

.method private openVideo()V
    .locals 12

    .prologue
    const/4 v11, 0x1

    const/4 v10, 0x0

    const/4 v9, -0x1

    .line 288
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSurfaceHolder:Landroid/view/SurfaceHolder;

    if-nez v0, :cond_1

    .line 351
    :cond_0
    :goto_0
    return-void

    .line 292
    :cond_1
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    if-eqz v0, :cond_3

    .line 293
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoFilePath:Ljava/lang/String;

    if-eqz v0, :cond_0

    .line 301
    :cond_2
    new-instance v8, Landroid/content/Intent;

    const-string v0, "com.android.music.musicservicecommand"

    invoke-direct {v8, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 302
    .local v8, "i":Landroid/content/Intent;
    const-string v0, "command"

    const-string v1, "pause"

    invoke-virtual {v8, v0, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 303
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v0, v8}, Lorg/cocos2dx/lib/Cocos2dxActivity;->sendBroadcast(Landroid/content/Intent;)V

    .line 307
    invoke-direct {p0, v10}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->release(Z)V

    .line 311
    :try_start_0
    new-instance v0, Landroid/media/MediaPlayer;

    invoke-direct {v0}, Landroid/media/MediaPlayer;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    .line 312
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V

    .line 313
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSizeChangedListener:Landroid/media/MediaPlayer$OnVideoSizeChangedListener;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setOnVideoSizeChangedListener(Landroid/media/MediaPlayer$OnVideoSizeChangedListener;)V

    .line 314
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCompletionListener:Landroid/media/MediaPlayer$OnCompletionListener;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setOnCompletionListener(Landroid/media/MediaPlayer$OnCompletionListener;)V

    .line 315
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V

    .line 316
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mBufferingUpdateListener:Landroid/media/MediaPlayer$OnBufferingUpdateListener;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setOnBufferingUpdateListener(Landroid/media/MediaPlayer$OnBufferingUpdateListener;)V

    .line 318
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSurfaceHolder:Landroid/view/SurfaceHolder;

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setDisplay(Landroid/view/SurfaceHolder;)V

    .line 319
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setAudioStreamType(I)V

    .line 320
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->setScreenOnWhilePlaying(Z)V

    .line 323
    const/4 v0, -0x1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    .line 324
    const/4 v0, 0x0

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentBufferPercentage:I

    .line 325
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    if-eqz v0, :cond_4

    .line 326
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoFilePath:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/content/res/AssetManager;->openFd(Ljava/lang/String;)Landroid/content/res/AssetFileDescriptor;

    move-result-object v6

    .line 327
    .local v6, "afd":Landroid/content/res/AssetFileDescriptor;
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v6}, Landroid/content/res/AssetFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v1

    invoke-virtual {v6}, Landroid/content/res/AssetFileDescriptor;->getStartOffset()J

    move-result-wide v2

    invoke-virtual {v6}, Landroid/content/res/AssetFileDescriptor;->getLength()J

    move-result-wide v4

    invoke-virtual/range {v0 .. v5}, Landroid/media/MediaPlayer;->setDataSource(Ljava/io/FileDescriptor;JJ)V

    .line 332
    .end local v6    # "afd":Landroid/content/res/AssetFileDescriptor;
    :goto_1
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->prepareAsync()V

    .line 337
    const/4 v0, 0x1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_1

    goto/16 :goto_0

    .line 338
    :catch_0
    move-exception v7

    .line 339
    .local v7, "ex":Ljava/io/IOException;
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unable to open content: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoUri:Landroid/net/Uri;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1, v7}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 340
    iput v9, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 341
    iput v9, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 342
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-interface {v0, v1, v11, v10}, Landroid/media/MediaPlayer$OnErrorListener;->onError(Landroid/media/MediaPlayer;II)Z

    goto/16 :goto_0

    .line 295
    .end local v7    # "ex":Ljava/io/IOException;
    .end local v8    # "i":Landroid/content/Intent;
    :cond_3
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoUri:Landroid/net/Uri;

    if-nez v0, :cond_2

    goto/16 :goto_0

    .line 329
    .restart local v8    # "i":Landroid/content/Intent;
    :cond_4
    :try_start_1
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoUri:Landroid/net/Uri;

    invoke-virtual {v0, v1, v2}, Landroid/media/MediaPlayer;->setDataSource(Landroid/content/Context;Landroid/net/Uri;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 344
    :catch_1
    move-exception v7

    .line 345
    .local v7, "ex":Ljava/lang/IllegalArgumentException;
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unable to open content: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoUri:Landroid/net/Uri;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1, v7}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 346
    iput v9, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 347
    iput v9, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 348
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-interface {v0, v1, v11, v10}, Landroid/media/MediaPlayer$OnErrorListener;->onError(Landroid/media/MediaPlayer;II)Z

    goto/16 :goto_0
.end method

.method private release(Z)V
    .locals 2
    .param p1, "cleartargetstate"    # Z

    .prologue
    const/4 v1, 0x0

    .line 606
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_0

    .line 607
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->reset()V

    .line 608
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->release()V

    .line 609
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    .line 610
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 611
    if-eqz p1, :cond_0

    .line 612
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 615
    :cond_0
    return-void
.end method

.method private setVideoURI(Landroid/net/Uri;Ljava/util/Map;)V
    .locals 1
    .param p1, "uri"    # Landroid/net/Uri;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/net/Uri;",
            "Ljava/util/Map",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .prologue
    .local p2, "headers":Ljava/util/Map;, "Ljava/util/Map<Ljava/lang/String;Ljava/lang/String;>;"
    const/4 v0, 0x0

    .line 268
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoUri:Landroid/net/Uri;

    .line 269
    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSeekWhenPrepared:I

    .line 270
    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    .line 271
    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    .line 272
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->openVideo()V

    .line 273
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->requestLayout()V

    .line 274
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->invalidate()V

    .line 275
    return-void
.end method


# virtual methods
.method public canPause()Z
    .locals 1

    .prologue
    .line 725
    const/4 v0, 0x1

    return v0
.end method

.method public canSeekBackward()Z
    .locals 1

    .prologue
    .line 730
    const/4 v0, 0x1

    return v0
.end method

.method public canSeekForward()Z
    .locals 1

    .prologue
    .line 735
    const/4 v0, 0x1

    return v0
.end method

.method public close()V
    .locals 3

    .prologue
    .line 125
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    if-eqz v0, :cond_0

    .line 126
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    const-string v1, "close: 255"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    const/16 v2, 0xff

    invoke-interface {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;->onVideoEvent(II)V

    .line 129
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mLayout:Landroid/widget/FrameLayout;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    invoke-virtual {v0, v1}, Landroid/widget/FrameLayout;->removeView(Landroid/view/View;)V

    .line 131
    :cond_0
    return-void
.end method

.method public fixSize()V
    .locals 4

    .prologue
    const/4 v2, 0x0

    .line 361
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenEnabled:Z

    if-eqz v0, :cond_0

    .line 362
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenWidth:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenHeight:I

    invoke-virtual {p0, v2, v2, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize(IIII)V

    .line 366
    :goto_0
    return-void

    .line 364
    :cond_0
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewLeft:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTop:I

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    invoke-virtual {p0, v0, v1, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize(IIII)V

    goto :goto_0
.end method

.method public fixSize(IIII)V
    .locals 5
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "width"    # I
    .param p4, "height"    # I

    .prologue
    const/4 v4, -0x2

    .line 369
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    if-eqz v1, :cond_0

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    if-nez v1, :cond_1

    .line 370
    :cond_0
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    .line 371
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    .line 372
    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 373
    iput p4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    .line 400
    :goto_0
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    invoke-interface {v1, v2, v3}, Landroid/view/SurfaceHolder;->setFixedSize(II)V

    .line 402
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 404
    .local v0, "lParams":Landroid/widget/FrameLayout$LayoutParams;
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 405
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 406
    const/16 v1, 0x33

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 407
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 408
    return-void

    .line 375
    .end local v0    # "lParams":Landroid/widget/FrameLayout$LayoutParams;
    :cond_1
    if-eqz p3, :cond_5

    if-eqz p4, :cond_5

    .line 376
    iget-boolean v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mKeepRatio:Z

    if-eqz v1, :cond_4

    .line 377
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    mul-int/2addr v1, p4

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    mul-int/2addr v2, p3

    if-le v1, v2, :cond_3

    .line 378
    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 379
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    mul-int/2addr v1, p3

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    div-int/2addr v1, v2

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    .line 384
    :cond_2
    :goto_1
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    sub-int v1, p3, v1

    div-int/lit8 v1, v1, 0x2

    add-int/2addr v1, p1

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    .line 385
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    sub-int v1, p4, v1

    div-int/lit8 v1, v1, 0x2

    add-int/2addr v1, p2

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    goto :goto_0

    .line 380
    :cond_3
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    mul-int/2addr v1, p4

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    mul-int/2addr v2, p3

    if-ge v1, v2, :cond_2

    .line 381
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    mul-int/2addr v1, p4

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    div-int/2addr v1, v2

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 382
    iput p4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    goto :goto_1

    .line 387
    :cond_4
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    .line 388
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    .line 389
    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 390
    iput p4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    goto :goto_0

    .line 394
    :cond_5
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleLeft:I

    .line 395
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleTop:I

    .line 396
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    .line 397
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    goto :goto_0
.end method

.method public getAudioSessionId()I
    .locals 1

    .prologue
    .line 739
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->getAudioSessionId()I

    move-result v0

    return v0
.end method

.method public getBufferPercentage()I
    .locals 1

    .prologue
    .line 710
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_0

    .line 711
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentBufferPercentage:I

    .line 713
    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public getCurrentPosition()I
    .locals 1

    .prologue
    .line 690
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 691
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->getCurrentPosition()I

    move-result v0

    .line 693
    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public getDuration()I
    .locals 1

    .prologue
    .line 678
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 679
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    if-lez v0, :cond_0

    .line 680
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    .line 686
    :goto_0
    return v0

    .line 682
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->getDuration()I

    move-result v0

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    .line 683
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    goto :goto_0

    .line 685
    :cond_1
    const/4 v0, -0x1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    .line 686
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mDuration:I

    goto :goto_0
.end method

.method public isInPlaybackState()Z
    .locals 3

    .prologue
    const/4 v0, 0x1

    .line 717
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v1, :cond_0

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    if-eqz v1, :cond_0

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    if-eq v1, v0, :cond_0

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public isPlaying()Z
    .locals 1

    .prologue
    .line 706
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method protected onMeasure(II)V
    .locals 3
    .param p1, "widthMeasureSpec"    # I
    .param p2, "heightMeasureSpec"    # I

    .prologue
    .line 135
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoWidth:I

    if-eqz v0, :cond_0

    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoHeight:I

    if-nez v0, :cond_1

    .line 136
    :cond_0
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    invoke-virtual {p0, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setMeasuredDimension(II)V

    .line 137
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 144
    :goto_0
    return-void

    .line 140
    :cond_1
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    invoke-virtual {p0, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setMeasuredDimension(II)V

    .line 141
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->TAG:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, ""

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleWidth:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVisibleHeight:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3
    .param p1, "event"    # Landroid/view/MotionEvent;

    .prologue
    const/4 v2, 0x1

    .line 228
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v0

    and-int/lit16 v0, v0, 0xff

    if-ne v0, v2, :cond_0

    .line 230
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 231
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->pause()V

    .line 237
    :cond_0
    :goto_0
    return v2

    .line 232
    :cond_1
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    const/4 v1, 0x4

    if-ne v0, v1, :cond_0

    .line 233
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->resume()V

    goto :goto_0
.end method

.method public pause()V
    .locals 4

    .prologue
    const/4 v3, 0x4

    .line 629
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 630
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 631
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->pause()V

    .line 632
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 633
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    if-eqz v0, :cond_0

    .line 634
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;->onVideoEvent(II)V

    .line 638
    :cond_0
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 639
    return-void
.end method

.method public resolveAdjustedSize(II)I
    .locals 3
    .param p1, "desiredSize"    # I
    .param p2, "measureSpec"    # I

    .prologue
    .line 168
    move v0, p1

    .line 169
    .local v0, "result":I
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getMode(I)I

    move-result v1

    .line 170
    .local v1, "specMode":I
    invoke-static {p2}, Landroid/view/View$MeasureSpec;->getSize(I)I

    move-result v2

    .line 172
    .local v2, "specSize":I
    sparse-switch v1, :sswitch_data_0

    .line 194
    :goto_0
    return v0

    .line 177
    :sswitch_0
    move v0, p1

    .line 178
    goto :goto_0

    .line 185
    :sswitch_1
    invoke-static {p1, v2}, Ljava/lang/Math;->min(II)I

    move-result v0

    .line 186
    goto :goto_0

    .line 190
    :sswitch_2
    move v0, v2

    goto :goto_0

    .line 172
    :sswitch_data_0
    .sparse-switch
        -0x80000000 -> :sswitch_1
        0x0 -> :sswitch_0
        0x40000000 -> :sswitch_2
    .end sparse-switch
.end method

.method public restart()V
    .locals 3

    .prologue
    const/4 v2, 0x3

    .line 669
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 670
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/media/MediaPlayer;->seekTo(I)V

    .line 671
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V

    .line 672
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 673
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 675
    :cond_0
    return-void
.end method

.method public resume()V
    .locals 3

    .prologue
    .line 657
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 658
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    const/4 v1, 0x4

    if-ne v0, v1, :cond_0

    .line 659
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V

    .line 660
    const/4 v0, 0x3

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 661
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    if-eqz v0, :cond_0

    .line 662
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;->onVideoEvent(II)V

    .line 666
    :cond_0
    return-void
.end method

.method public seekTo(I)V
    .locals 1
    .param p1, "msec"    # I

    .prologue
    .line 697
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 698
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0, p1}, Landroid/media/MediaPlayer;->seekTo(I)V

    .line 699
    const/4 v0, 0x0

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSeekWhenPrepared:I

    .line 703
    :goto_0
    return-void

    .line 701
    :cond_0
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSeekWhenPrepared:I

    goto :goto_0
.end method

.method public setFullScreenEnabled(ZII)V
    .locals 1
    .param p1, "enabled"    # Z
    .param p2, "width"    # I
    .param p3, "height"    # I

    .prologue
    .line 156
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenEnabled:Z

    if-eq v0, p1, :cond_1

    .line 157
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenEnabled:Z

    .line 158
    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    .line 159
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenWidth:I

    .line 160
    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mFullScreenHeight:I

    .line 163
    :cond_0
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize()V

    .line 165
    :cond_1
    return-void
.end method

.method public setKeepRatio(Z)V
    .locals 0
    .param p1, "enabled"    # Z

    .prologue
    .line 356
    iput-boolean p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mKeepRatio:Z

    .line 357
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize()V

    .line 358
    return-void
.end method

.method public setOnCompletionListener(Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;)V
    .locals 0
    .param p1, "l"    # Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    .prologue
    .line 556
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    .line 557
    return-void
.end method

.method public setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V
    .locals 0
    .param p1, "l"    # Landroid/media/MediaPlayer$OnErrorListener;

    .prologue
    .line 569
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnErrorListener:Landroid/media/MediaPlayer$OnErrorListener;

    .line 570
    return-void
.end method

.method public setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V
    .locals 0
    .param p1, "l"    # Landroid/media/MediaPlayer$OnPreparedListener;

    .prologue
    .line 545
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnPreparedListener:Landroid/media/MediaPlayer$OnPreparedListener;

    .line 546
    return-void
.end method

.method public setVideoFileName(Ljava/lang/String;)V
    .locals 2
    .param p1, "path"    # Ljava/lang/String;

    .prologue
    const/4 v1, 0x0

    .line 245
    const-string v0, "assets/"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 246
    const-string v0, "assets/"

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    .line 248
    :cond_0
    const-string v0, "/"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 249
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    .line 250
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-direct {p0, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoURI(Landroid/net/Uri;Ljava/util/Map;)V

    .line 257
    :goto_0
    return-void

    .line 253
    :cond_1
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mVideoFilePath:Ljava/lang/String;

    .line 254
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    .line 255
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-direct {p0, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoURI(Landroid/net/Uri;Ljava/util/Map;)V

    goto :goto_0
.end method

.method public setVideoRect(IIII)V
    .locals 4
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "maxWidth"    # I
    .param p4, "maxHeight"    # I

    .prologue
    .line 147
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewLeft:I

    .line 148
    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTop:I

    .line 149
    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    .line 150
    iput p4, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    .line 152
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewLeft:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTop:I

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewWidth:I

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewHeight:I

    invoke-virtual {p0, v0, v1, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->fixSize(IIII)V

    .line 153
    return-void
.end method

.method public setVideoURL(Ljava/lang/String;)V
    .locals 2
    .param p1, "url"    # Ljava/lang/String;

    .prologue
    .line 260
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mIsAssetRouse:Z

    .line 261
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const/4 v1, 0x0

    invoke-direct {p0, v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->setVideoURI(Landroid/net/Uri;Ljava/util/Map;)V

    .line 262
    return-void
.end method

.method public setVisibility(I)V
    .locals 1
    .param p1, "visibility"    # I

    .prologue
    .line 201
    const/4 v0, 0x4

    if-ne p1, v0, :cond_1

    .line 202
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isPlaying()Z

    move-result v0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mNeedResume:Z

    .line 203
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mNeedResume:Z

    if-eqz v0, :cond_0

    .line 204
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getCurrentPosition()I

    move-result v0

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mSeekWhenPrepared:I

    .line 211
    :cond_0
    :goto_0
    invoke-super {p0, p1}, Landroid/view/SurfaceView;->setVisibility(I)V

    .line 212
    return-void

    .line 207
    :cond_1
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mNeedResume:Z

    if-eqz v0, :cond_0

    .line 208
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->start()V

    .line 209
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mNeedResume:Z

    goto :goto_0
.end method

.method public showController()V
    .locals 4

    .prologue
    const/4 v3, -0x2

    .line 112
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    if-nez v1, :cond_0

    .line 113
    new-instance v1, Lorg/cocos2dx/lib/VideoController;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {v1, v2, p0}, Lorg/cocos2dx/lib/VideoController;-><init>(Lorg/cocos2dx/lib/Cocos2dxActivity;Lorg/cocos2dx/lib/Cocos2dxVideoView;)V

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    .line 115
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 118
    .local v0, "lParams":Landroid/widget/FrameLayout$LayoutParams;
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mLayout:Landroid/widget/FrameLayout;

    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    invoke-virtual {v1, v2, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 119
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/VideoController;->setZOrderOnTop(Z)V

    .line 120
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->videoController:Lorg/cocos2dx/lib/VideoController;

    invoke-virtual {v1}, Lorg/cocos2dx/lib/VideoController;->bringToFront()V

    .line 122
    .end local v0    # "lParams":Landroid/widget/FrameLayout$LayoutParams;
    :cond_0
    return-void
.end method

.method public start()V
    .locals 4

    .prologue
    const/4 v3, 0x3

    .line 618
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 619
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->start()V

    .line 620
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 621
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    if-eqz v0, :cond_0

    .line 622
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;->onVideoEvent(II)V

    .line 625
    :cond_0
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 626
    return-void
.end method

.method public stop()V
    .locals 3

    .prologue
    .line 642
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isInPlaybackState()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 643
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 644
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->stopPlayback()V

    .line 645
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    if-eqz v0, :cond_0

    .line 646
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mOnVideoEventListener:Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mViewTag:I

    const/4 v2, 0x2

    invoke-interface {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView$OnVideoEventListener;->onVideoEvent(II)V

    .line 650
    :cond_0
    return-void
.end method

.method public stopPlayback()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 278
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_0

    .line 279
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->stop()V

    .line 280
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    invoke-virtual {v0}, Landroid/media/MediaPlayer;->release()V

    .line 281
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mMediaPlayer:Landroid/media/MediaPlayer;

    .line 282
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mCurrentState:I

    .line 283
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoView;->mTargetState:I

    .line 285
    :cond_0
    return-void
.end method

.method public suspend()V
    .locals 1

    .prologue
    .line 653
    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->release(Z)V

    .line 654
    return-void
.end method
