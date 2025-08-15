.class public Lorg/cocos2dx/lib/VideoController;
.super Landroid/view/SurfaceView;
.source "VideoController.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/VideoController$DrawRunnable;
    }
.end annotation


# static fields
.field static TAG:Ljava/lang/String;


# instance fields
.field private canvas:Landroid/graphics/Canvas;

.field private clickScale:F

.field private closeRect:Landroid/graphics/RectF;

.field private closeRectClick:Landroid/graphics/RectF;

.field private drawRunnable:Lorg/cocos2dx/lib/VideoController$DrawRunnable;

.field private handler:Landroid/os/Handler;

.field private isDownProgressBtn:Z

.field private isDraw:Z

.field mSHCallback:Landroid/view/SurfaceHolder$Callback;

.field protected paint:Landroid/graphics/Paint;

.field private playRect:Landroid/graphics/RectF;

.field private playRectRectClick:Landroid/graphics/RectF;

.field private progressBtnPos:Landroid/graphics/PointF;

.field private progressBtnRadius:I

.field private progressRect:Landroid/graphics/RectF;

.field private screenH:I

.field private screenW:I

.field private sh:Landroid/view/SurfaceHolder;

.field private video:Lorg/cocos2dx/lib/Cocos2dxVideoView;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 27
    const-string v0, "CloseBtn"

    sput-object v0, Lorg/cocos2dx/lib/VideoController;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;Lorg/cocos2dx/lib/Cocos2dxVideoView;)V
    .locals 2
    .param p1, "activity"    # Lorg/cocos2dx/lib/Cocos2dxActivity;
    .param p2, "video"    # Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .prologue
    .line 52
    invoke-direct {p0, p1}, Landroid/view/SurfaceView;-><init>(Landroid/content/Context;)V

    .line 35
    const/high16 v0, 0x40000000    # 2.0f

    iput v0, p0, Lorg/cocos2dx/lib/VideoController;->clickScale:F

    .line 48
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->handler:Landroid/os/Handler;

    .line 49
    new-instance v0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/VideoController$DrawRunnable;-><init>(Lorg/cocos2dx/lib/VideoController;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->drawRunnable:Lorg/cocos2dx/lib/VideoController$DrawRunnable;

    .line 206
    new-instance v0, Lorg/cocos2dx/lib/VideoController$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/VideoController$1;-><init>(Lorg/cocos2dx/lib/VideoController;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->mSHCallback:Landroid/view/SurfaceHolder$Callback;

    .line 54
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0}, Landroid/graphics/Paint;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    .line 55
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 56
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/lib/VideoController;->isDownProgressBtn:Z

    .line 57
    const/16 v0, 0x1e

    iput v0, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnRadius:I

    .line 58
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    .line 60
    invoke-virtual {p0}, Lorg/cocos2dx/lib/VideoController;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->mSHCallback:Landroid/view/SurfaceHolder$Callback;

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 63
    iput-object p2, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    .line 64
    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/VideoController;)Z
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget-boolean v0, p0, Lorg/cocos2dx/lib/VideoController;->isDraw:Z

    return v0
.end method

.method static synthetic access$002(Lorg/cocos2dx/lib/VideoController;Z)Z
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Z

    .prologue
    .line 25
    iput-boolean p1, p0, Lorg/cocos2dx/lib/VideoController;->isDraw:Z

    return p1
.end method

.method static synthetic access$100(Lorg/cocos2dx/lib/VideoController;)Landroid/os/Handler;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->handler:Landroid/os/Handler;

    return-object v0
.end method

.method static synthetic access$1002(Lorg/cocos2dx/lib/VideoController;Landroid/view/SurfaceHolder;)Landroid/view/SurfaceHolder;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->sh:Landroid/view/SurfaceHolder;

    return-object p1
.end method

.method static synthetic access$1100(Lorg/cocos2dx/lib/VideoController;)Lorg/cocos2dx/lib/VideoController$DrawRunnable;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->drawRunnable:Lorg/cocos2dx/lib/VideoController$DrawRunnable;

    return-object v0
.end method

.method static synthetic access$200(Lorg/cocos2dx/lib/VideoController;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget v0, p0, Lorg/cocos2dx/lib/VideoController;->screenW:I

    return v0
.end method

.method static synthetic access$202(Lorg/cocos2dx/lib/VideoController;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # I

    .prologue
    .line 25
    iput p1, p0, Lorg/cocos2dx/lib/VideoController;->screenW:I

    return p1
.end method

.method static synthetic access$300(Lorg/cocos2dx/lib/VideoController;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget v0, p0, Lorg/cocos2dx/lib/VideoController;->screenH:I

    return v0
.end method

.method static synthetic access$302(Lorg/cocos2dx/lib/VideoController;I)I
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # I

    .prologue
    .line 25
    iput p1, p0, Lorg/cocos2dx/lib/VideoController;->screenH:I

    return p1
.end method

.method static synthetic access$400(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    return-object v0
.end method

.method static synthetic access$402(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/graphics/RectF;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    return-object p1
.end method

.method static synthetic access$500(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    return-object v0
.end method

.method static synthetic access$502(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/graphics/RectF;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    return-object p1
.end method

.method static synthetic access$602(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/graphics/RectF;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->closeRectClick:Landroid/graphics/RectF;

    return-object p1
.end method

.method static synthetic access$700(Lorg/cocos2dx/lib/VideoController;)F
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 25
    iget v0, p0, Lorg/cocos2dx/lib/VideoController;->clickScale:F

    return v0
.end method

.method static synthetic access$802(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/graphics/RectF;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->playRectRectClick:Landroid/graphics/RectF;

    return-object p1
.end method

.method static synthetic access$902(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;
    .locals 0
    .param p0, "x0"    # Lorg/cocos2dx/lib/VideoController;
    .param p1, "x1"    # Landroid/graphics/RectF;

    .prologue
    .line 25
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    return-object p1
.end method

.method private drawClose()V
    .locals 6

    .prologue
    .line 118
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x41200000    # 10.0f

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 119
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->left:F

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v2, v2, Landroid/graphics/RectF;->top:F

    iget-object v3, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->right:F

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->bottom:F

    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 120
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->left:F

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v2, v2, Landroid/graphics/RectF;->bottom:F

    iget-object v3, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->right:F

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->closeRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->top:F

    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 121
    return-void
.end method

.method private drawPlay()V
    .locals 9

    .prologue
    const/high16 v8, 0x40000000    # 2.0f

    const/high16 v7, 0x40400000    # 3.0f

    .line 124
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isPlaying()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 125
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x41200000    # 10.0f

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 127
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->left:F

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    invoke-virtual {v2}, Landroid/graphics/RectF;->width()F

    move-result v2

    div-float/2addr v2, v7

    add-float/2addr v1, v2

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v2, v2, Landroid/graphics/RectF;->top:F

    iget-object v3, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->left:F

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    invoke-virtual {v4}, Landroid/graphics/RectF;->width()F

    move-result v4

    div-float/2addr v4, v7

    add-float/2addr v3, v4

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->bottom:F

    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 128
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->left:F

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    invoke-virtual {v2}, Landroid/graphics/RectF;->width()F

    move-result v2

    div-float/2addr v2, v7

    mul-float/2addr v2, v8

    add-float/2addr v1, v2

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v2, v2, Landroid/graphics/RectF;->top:F

    iget-object v3, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->left:F

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    invoke-virtual {v4}, Landroid/graphics/RectF;->width()F

    move-result v4

    div-float/2addr v4, v7

    mul-float/2addr v4, v8

    add-float/2addr v3, v4

    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->bottom:F

    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 141
    :goto_0
    return-void

    .line 132
    :cond_0
    new-instance v6, Landroid/graphics/Path;

    invoke-direct {v6}, Landroid/graphics/Path;-><init>()V

    .line 133
    .local v6, "path":Landroid/graphics/Path;
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->left:F

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->top:F

    invoke-virtual {v6, v0, v1}, Landroid/graphics/Path;->moveTo(FF)V

    .line 134
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->left:F

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->bottom:F

    invoke-virtual {v6, v0, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 135
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->right:F

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    iget v1, v1, Landroid/graphics/RectF;->top:F

    iget-object v2, p0, Lorg/cocos2dx/lib/VideoController;->playRect:Landroid/graphics/RectF;

    invoke-virtual {v2}, Landroid/graphics/RectF;->width()F

    move-result v2

    div-float/2addr v2, v8

    add-float/2addr v1, v2

    invoke-virtual {v6, v0, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 136
    invoke-virtual {v6}, Landroid/graphics/Path;->close()V

    .line 138
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 139
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual {v0, v6, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    goto :goto_0
.end method

.method private drawProgress()V
    .locals 18

    .prologue
    .line 145
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    const/high16 v3, 0x40a00000    # 5.0f

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 146
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->left:F

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->top:F

    move-object/from16 v0, p0

    iget-object v5, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v5, v5, Landroid/graphics/RectF;->right:F

    move-object/from16 v0, p0

    iget-object v6, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v6, v6, Landroid/graphics/RectF;->bottom:F

    move-object/from16 v0, p0

    iget-object v7, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 148
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    const/high16 v3, 0x42200000    # 40.0f

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 150
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getDuration()I

    move-result v2

    int-to-double v2, v2

    const-wide v4, 0x408f400000000000L    # 1000.0

    div-double/2addr v2, v4

    const-wide v4, 0x407f400000000000L    # 500.0

    add-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->floor(D)D

    move-result-wide v2

    double-to-int v12, v2

    .line 151
    .local v12, "duration":I
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getCurrentPosition()I

    move-result v10

    .line 153
    .local v10, "currPos":I
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getDuration()I

    move-result v17

    .line 154
    .local v17, "total":I
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v2}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getCurrentPosition()I

    move-result v11

    .line 155
    .local v11, "currProg":I
    int-to-double v2, v11

    const-wide/high16 v4, 0x3ff0000000000000L    # 1.0

    mul-double/2addr v2, v4

    move/from16 v0, v17

    int-to-double v4, v0

    div-double/2addr v2, v4

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    invoke-virtual {v4}, Landroid/graphics/RectF;->width()F

    move-result v4

    float-to-double v4, v4

    mul-double v8, v2, v4

    .line 157
    .local v8, "btnProgWidth":D
    move-object/from16 v0, p0

    iget-boolean v2, v0, Lorg/cocos2dx/lib/VideoController;->isDownProgressBtn:Z

    if-nez v2, :cond_0

    .line 158
    new-instance v2, Landroid/graphics/PointF;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->left:F

    double-to-int v4, v8

    int-to-float v4, v4

    add-float/2addr v3, v4

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->top:F

    invoke-direct {v2, v3, v4}, Landroid/graphics/PointF;-><init>(FF)V

    move-object/from16 v0, p0

    iput-object v2, v0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    .line 160
    :cond_0
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v3, v3, Landroid/graphics/PointF;->x:F

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v4, v4, Landroid/graphics/PointF;->y:F

    move-object/from16 v0, p0

    iget v5, v0, Lorg/cocos2dx/lib/VideoController;->progressBtnRadius:I

    int-to-float v5, v5

    move-object/from16 v0, p0

    iget-object v6, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual {v2, v3, v4, v5, v6}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 162
    move/from16 v0, v17

    int-to-double v2, v0

    const-wide v4, 0x408f400000000000L    # 1000.0

    div-double/2addr v2, v4

    const-wide/high16 v4, 0x3fe0000000000000L    # 0.5

    add-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->floor(D)D

    move-result-wide v2

    double-to-int v0, v2

    move/from16 v16, v0

    .line 163
    .local v16, "time_total":I
    int-to-double v2, v11

    const-wide v4, 0x408f400000000000L    # 1000.0

    div-double/2addr v2, v4

    const-wide/high16 v4, 0x3fe0000000000000L    # 0.5

    add-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->floor(D)D

    move-result-wide v2

    double-to-int v15, v2

    .line 165
    .local v15, "time_prog":I
    move/from16 v0, v16

    if-le v15, v0, :cond_1

    move/from16 v15, v16

    .line 167
    :cond_1
    const-string v2, "%02d:%02d"

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    div-int/lit8 v5, v16, 0x3c

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v3, v4

    const/4 v4, 0x1

    rem-int/lit8 v5, v16, 0x3c

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v3, v4

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    .line 168
    .local v14, "str_time_total":Ljava/lang/String;
    const-string v2, "%02d:%02d"

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    div-int/lit8 v5, v15, 0x3c

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v3, v4

    const/4 v4, 0x1

    rem-int/lit8 v5, v15, 0x3c

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v3, v4

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v13

    .line 170
    .local v13, "str_time_prog":Ljava/lang/String;
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Align;->RIGHT:Landroid/graphics/Paint$Align;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    .line 171
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->left:F

    const/high16 v4, 0x42480000    # 50.0f

    sub-float/2addr v3, v4

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->top:F

    const/high16 v5, 0x41a00000    # 20.0f

    add-float/2addr v4, v5

    move-object/from16 v0, p0

    iget-object v5, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual {v2, v13, v3, v4, v5}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 173
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Align;->LEFT:Landroid/graphics/Paint$Align;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    .line 174
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v3, v3, Landroid/graphics/RectF;->right:F

    const/high16 v4, 0x42480000    # 50.0f

    add-float/2addr v3, v4

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v4, v4, Landroid/graphics/RectF;->top:F

    const/high16 v5, 0x41a00000    # 20.0f

    add-float/2addr v4, v5

    move-object/from16 v0, p0

    iget-object v5, v0, Lorg/cocos2dx/lib/VideoController;->paint:Landroid/graphics/Paint;

    invoke-virtual {v2, v14, v3, v4, v5}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 175
    return-void
.end method


# virtual methods
.method public draw()V
    .locals 3

    .prologue
    .line 178
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->sh:Landroid/view/SurfaceHolder;

    const/4 v1, -0x2

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->setFormat(I)V

    .line 180
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->sh:Landroid/view/SurfaceHolder;

    invoke-interface {v0}, Landroid/view/SurfaceHolder;->lockCanvas()Landroid/graphics/Canvas;

    move-result-object v0

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    .line 181
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    if-eqz v0, :cond_0

    .line 182
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    const/4 v1, 0x0

    sget-object v2, Landroid/graphics/PorterDuff$Mode;->CLEAR:Landroid/graphics/PorterDuff$Mode;

    invoke-virtual {v0, v1, v2}, Landroid/graphics/Canvas;->drawColor(ILandroid/graphics/PorterDuff$Mode;)V

    .line 183
    invoke-direct {p0}, Lorg/cocos2dx/lib/VideoController;->drawClose()V

    .line 184
    invoke-direct {p0}, Lorg/cocos2dx/lib/VideoController;->drawPlay()V

    .line 185
    invoke-direct {p0}, Lorg/cocos2dx/lib/VideoController;->drawProgress()V

    .line 188
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController;->sh:Landroid/view/SurfaceHolder;

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController;->canvas:Landroid/graphics/Canvas;

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V

    .line 189
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 11
    .param p1, "event"    # Landroid/view/MotionEvent;

    .prologue
    const/4 v10, 0x1

    const/4 v9, 0x0

    .line 68
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v4

    .line 69
    .local v4, "x":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v5

    .line 70
    .local v5, "y":F
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v6

    and-int/lit16 v6, v6, 0xff

    if-nez v6, :cond_1

    .line 71
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    if-eqz v6, :cond_0

    .line 73
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v6, v6, Landroid/graphics/PointF;->x:F

    sub-float/2addr v6, v4

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v7, v7, Landroid/graphics/PointF;->x:F

    sub-float/2addr v7, v4

    mul-float/2addr v6, v7

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v7, v7, Landroid/graphics/PointF;->y:F

    sub-float/2addr v7, v5

    iget-object v8, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v8, v8, Landroid/graphics/PointF;->y:F

    sub-float/2addr v8, v5

    mul-float/2addr v7, v8

    add-float/2addr v6, v7

    float-to-double v6, v6

    invoke-static {v6, v7}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    .line 75
    .local v0, "d":D
    iget v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnRadius:I

    int-to-float v6, v6

    iget v7, p0, Lorg/cocos2dx/lib/VideoController;->clickScale:F

    mul-float/2addr v6, v7

    float-to-double v6, v6

    cmpg-double v6, v0, v6

    if-gez v6, :cond_0

    .line 114
    .end local v0    # "d":D
    :cond_0
    :goto_0
    return v10

    .line 83
    :cond_1
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v6

    and-int/lit16 v6, v6, 0xff

    const/4 v7, 0x2

    if-ne v6, v7, :cond_4

    .line 84
    iget-boolean v6, p0, Lorg/cocos2dx/lib/VideoController;->isDownProgressBtn:Z

    if-eqz v6, :cond_0

    .line 85
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getHistorySize()I

    move-result v6

    if-lez v6, :cond_0

    .line 86
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v7, v6, Landroid/graphics/PointF;->x:F

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v8

    invoke-virtual {p1, v9}, Landroid/view/MotionEvent;->getHistoricalX(I)F

    move-result v9

    sub-float/2addr v8, v9

    add-float/2addr v7, v8

    iput v7, v6, Landroid/graphics/PointF;->x:F

    .line 87
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v6, v6, Landroid/graphics/PointF;->x:F

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->left:F

    cmpg-float v6, v6, v7

    if-gez v6, :cond_2

    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->left:F

    iput v7, v6, Landroid/graphics/PointF;->x:F

    .line 88
    :cond_2
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v6, v6, Landroid/graphics/PointF;->x:F

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->right:F

    cmpl-float v6, v6, v7

    if-lez v6, :cond_3

    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->right:F

    iput v7, v6, Landroid/graphics/PointF;->x:F

    .line 90
    :cond_3
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->progressBtnPos:Landroid/graphics/PointF;

    iget v6, v6, Landroid/graphics/PointF;->x:F

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->left:F

    sub-float/2addr v6, v7

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v7, v7, Landroid/graphics/RectF;->right:F

    iget-object v8, p0, Lorg/cocos2dx/lib/VideoController;->progressRect:Landroid/graphics/RectF;

    iget v8, v8, Landroid/graphics/RectF;->left:F

    sub-float/2addr v7, v8

    div-float v2, v6, v7

    .line 92
    .local v2, "progress":F
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->getDuration()I

    move-result v6

    int-to-float v6, v6

    mul-float v3, v6, v2

    .line 93
    .local v3, "timeProg":F
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    float-to-int v7, v3

    invoke-virtual {v6, v7}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->seekTo(I)V

    goto :goto_0

    .line 97
    .end local v2    # "progress":F
    .end local v3    # "timeProg":F
    :cond_4
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getAction()I

    move-result v6

    and-int/lit16 v6, v6, 0xff

    if-ne v6, v10, :cond_0

    .line 98
    iget-boolean v6, p0, Lorg/cocos2dx/lib/VideoController;->isDownProgressBtn:Z

    if-eqz v6, :cond_5

    .line 99
    iput-boolean v9, p0, Lorg/cocos2dx/lib/VideoController;->isDownProgressBtn:Z

    .line 100
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->start()V

    goto/16 :goto_0

    .line 102
    :cond_5
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->closeRectClick:Landroid/graphics/RectF;

    invoke-virtual {v6, v4, v5}, Landroid/graphics/RectF;->contains(FF)Z

    move-result v6

    if-eqz v6, :cond_6

    .line 103
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->close()V

    goto/16 :goto_0

    .line 105
    :cond_6
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->playRectRectClick:Landroid/graphics/RectF;

    invoke-virtual {v6, v4, v5}, Landroid/graphics/RectF;->contains(FF)Z

    move-result v6

    if-eqz v6, :cond_0

    .line 106
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->isPlaying()Z

    move-result v6

    if-eqz v6, :cond_7

    .line 107
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->pause()V

    goto/16 :goto_0

    .line 110
    :cond_7
    iget-object v6, p0, Lorg/cocos2dx/lib/VideoController;->video:Lorg/cocos2dx/lib/Cocos2dxVideoView;

    invoke-virtual {v6}, Lorg/cocos2dx/lib/Cocos2dxVideoView;->start()V

    goto/16 :goto_0
.end method
