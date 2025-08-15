.class public interface abstract Lorg/cocos2dx/enginedata/IEngineDataManager;
.super Ljava/lang/Object;
.source "IEngineDataManager.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;,
        Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;
    }
.end annotation


# virtual methods
.method public abstract destroy()V
.end method

.method public abstract getVendorInfo()Ljava/lang/String;
.end method

.method public abstract init(Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;)Z
.end method

.method public abstract notifyContinuousFrameLost(III)V
.end method

.method public abstract notifyFpsChanged(FF)V
.end method

.method public abstract notifyGameStatus(Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;II)V
.end method

.method public abstract notifyLowFps(IFI)V
.end method

.method public abstract pause()V
.end method

.method public abstract resume()V
.end method
