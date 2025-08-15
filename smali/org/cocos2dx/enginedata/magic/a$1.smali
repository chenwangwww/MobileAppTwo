.class Lorg/cocos2dx/enginedata/magic/a$1;
.super Ljava/lang/Object;
.source "EngineDataManagerHuawei.java"

# interfaces
.implements Lcom/huawei/android/hwgamesdk/HwGameSDK$GameEngineCallBack;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/enginedata/magic/a;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic a:Lorg/cocos2dx/enginedata/magic/a;


# direct methods
.method constructor <init>(Lorg/cocos2dx/enginedata/magic/a;)V
    .locals 0

    .prologue
    .line 1
    iput-object p1, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public changeContinuousFpsMissedRate(II)V
    .locals 1

    .prologue
    .line 78
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 79
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onChangeContinuousFrameLostConfig(II)V

    .line 81
    :cond_0
    return-void
.end method

.method public changeDxFpsRate(IF)V
    .locals 1

    .prologue
    .line 43
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 44
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onChangeLowFpsConfig(IF)V

    .line 46
    :cond_0
    return-void
.end method

.method public changeFpsRate(I)V
    .locals 1

    .prologue
    .line 57
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->b(Lorg/cocos2dx/enginedata/magic/a;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 58
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onChangeExpectedFps(I)V

    .line 60
    :cond_0
    return-void
.end method

.method public changeMuteEnabled(Z)V
    .locals 1

    .prologue
    .line 71
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 72
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onChangeMuteEnabled(Z)V

    .line 74
    :cond_0
    return-void
.end method

.method public changeSpecialEffects(I)V
    .locals 1

    .prologue
    .line 64
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 65
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onChangeSpecialEffectLevel(I)V

    .line 67
    :cond_0
    return-void
.end method

.method public queryExpectedFps([I[I)V
    .locals 1

    .prologue
    .line 50
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 51
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a$1;->a:Lorg/cocos2dx/enginedata/magic/a;

    invoke-static {v0}, Lorg/cocos2dx/enginedata/magic/a;->a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    move-result-object v0

    invoke-interface {v0, p1, p2}, Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;->onQueryFps([I[I)V

    .line 53
    :cond_0
    return-void
.end method
