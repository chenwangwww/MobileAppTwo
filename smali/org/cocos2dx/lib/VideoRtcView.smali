.class public Lorg/cocos2dx/lib/VideoRtcView;
.super Landroid/widget/FrameLayout;
.source "VideoRtcView.java"


# instance fields
.field public height:F

.field public userId:Ljava/lang/String;

.field public width:F

.field public x:F

.field public y:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/high16 v1, 0x41200000    # 10.0f

    const/4 v0, 0x0

    .line 20
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 12
    iput v0, p0, Lorg/cocos2dx/lib/VideoRtcView;->x:F

    .line 13
    iput v0, p0, Lorg/cocos2dx/lib/VideoRtcView;->y:F

    .line 14
    iput v1, p0, Lorg/cocos2dx/lib/VideoRtcView;->width:F

    .line 15
    iput v1, p0, Lorg/cocos2dx/lib/VideoRtcView;->height:F

    .line 17
    const-string v0, ""

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoRtcView;->userId:Ljava/lang/String;

    .line 21
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .prologue
    const/high16 v2, 0x41200000    # 10.0f

    const/4 v1, 0x0

    .line 24
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 12
    iput v1, p0, Lorg/cocos2dx/lib/VideoRtcView;->x:F

    .line 13
    iput v1, p0, Lorg/cocos2dx/lib/VideoRtcView;->y:F

    .line 14
    iput v2, p0, Lorg/cocos2dx/lib/VideoRtcView;->width:F

    .line 15
    iput v2, p0, Lorg/cocos2dx/lib/VideoRtcView;->height:F

    .line 17
    const-string v0, ""

    iput-object v0, p0, Lorg/cocos2dx/lib/VideoRtcView;->userId:Ljava/lang/String;

    .line 25
    return-void
.end method
