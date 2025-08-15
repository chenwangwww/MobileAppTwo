.class final Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;
.super Ljava/lang/Object;
.source "Cocos2dxEngineDataManager.java"

# interfaces
.implements Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->init(Landroid/content/Context;Landroid/opengl/GLSurfaceView;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$glSurfaceView:Landroid/opengl/GLSurfaceView;


# direct methods
.method constructor <init>(Landroid/opengl/GLSurfaceView;)V
    .locals 0

    .prologue
    .line 80
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onChangeContinuousFrameLostConfig(II)V
    .locals 2
    .param p1, "cycle"    # I
    .param p2, "maxFrameMissed"    # I

    .prologue
    .line 96
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$1;

    invoke-direct {v1, p0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;II)V

    invoke-virtual {v0, v1}, Landroid/opengl/GLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 102
    return-void
.end method

.method public onChangeExpectedFps(I)V
    .locals 2
    .param p1, "fps"    # I

    .prologue
    .line 116
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$3;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$3;-><init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;I)V

    invoke-virtual {v0, v1}, Landroid/opengl/GLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 122
    return-void
.end method

.method public onChangeLowFpsConfig(IF)V
    .locals 2
    .param p1, "cycle"    # I
    .param p2, "maxFrameDx"    # F

    .prologue
    .line 106
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;

    invoke-direct {v1, p0, p1, p2}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;-><init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;IF)V

    invoke-virtual {v0, v1}, Landroid/opengl/GLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 112
    return-void
.end method

.method public onChangeMuteEnabled(Z)V
    .locals 2
    .param p1, "enabled"    # Z

    .prologue
    .line 136
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;-><init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;Z)V

    invoke-virtual {v0, v1}, Landroid/opengl/GLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 142
    return-void
.end method

.method public onChangeSpecialEffectLevel(I)V
    .locals 2
    .param p1, "level"    # I

    .prologue
    .line 126
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->val$glSurfaceView:Landroid/opengl/GLSurfaceView;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;-><init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;I)V

    invoke-virtual {v0, v1}, Landroid/opengl/GLSurfaceView;->queueEvent(Ljava/lang/Runnable;)V

    .line 132
    return-void
.end method

.method public onQueryFps([I[I)V
    .locals 0
    .param p1, "expectedFps"    # [I
    .param p2, "realFps"    # [I

    .prologue
    .line 89
    invoke-static {p1, p2}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->access$000([I[I)V

    .line 92
    return-void
.end method
