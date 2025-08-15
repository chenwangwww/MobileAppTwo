.class public interface abstract Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;
.super Ljava/lang/Object;
.source "IEngineDataManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/enginedata/IEngineDataManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x609
    name = "OnSystemCommandListener"
.end annotation


# virtual methods
.method public abstract onChangeContinuousFrameLostConfig(II)V
.end method

.method public abstract onChangeExpectedFps(I)V
.end method

.method public abstract onChangeLowFpsConfig(IF)V
.end method

.method public abstract onChangeMuteEnabled(Z)V
.end method

.method public abstract onChangeSpecialEffectLevel(I)V
.end method

.method public abstract onQueryFps([I[I)V
.end method
