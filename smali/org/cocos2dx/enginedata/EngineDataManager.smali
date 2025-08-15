.class public Lorg/cocos2dx/enginedata/EngineDataManager;
.super Ljava/lang/Object;
.source "EngineDataManager.java"

# interfaces
.implements Lorg/cocos2dx/enginedata/IEngineDataManager;


# static fields
.field private static final a:Ljava/lang/String; = "EngineDataManager"

.field private static final b:I = 0x3e8

.field private static final c:Ljava/lang/String; = "1.0.0.0"


# instance fields
.field private d:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lorg/cocos2dx/enginedata/IEngineDataManager;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 2

    .prologue
    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    .line 42
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    new-instance v1, Lorg/cocos2dx/enginedata/magic/a;

    invoke-direct {v1}, Lorg/cocos2dx/enginedata/magic/a;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 43
    return-void
.end method


# virtual methods
.method public destroy()V
    .locals 2

    .prologue
    .line 80
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 83
    return-void

    .line 80
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 81
    invoke-interface {v0}, Lorg/cocos2dx/enginedata/IEngineDataManager;->destroy()V

    goto :goto_0
.end method

.method public getVendorInfo()Ljava/lang/String;
    .locals 3

    .prologue
    .line 55
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 56
    const/4 v0, 0x0

    move v1, v0

    :goto_0
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-lt v1, v0, :cond_0

    .line 64
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 57
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 58
    invoke-interface {v0}, Lorg/cocos2dx/enginedata/IEngineDataManager;->getVendorInfo()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 59
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    if-ge v1, v0, :cond_1

    .line 60
    const-string v0, ","

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 56
    :cond_1
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_0
.end method

.method public getVersionCode()I
    .locals 1

    .prologue
    .line 50
    const/16 v0, 0x3e8

    return v0
.end method

.method public getVersionName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 46
    const-string v0, "1.0.0.0"

    return-object v0
.end method

.method public init(Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;)Z
    .locals 3

    .prologue
    .line 69
    const/4 v0, 0x0

    .line 70
    iget-object v1, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move v1, v0

    :cond_0
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    .line 75
    return v1

    .line 70
    :cond_1
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 71
    invoke-interface {v0, p1}, Lorg/cocos2dx/enginedata/IEngineDataManager;->init(Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 72
    const/4 v0, 0x1

    move v1, v0

    goto :goto_0
.end method

.method public notifyContinuousFrameLost(III)V
    .locals 2

    .prologue
    .line 108
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 111
    return-void

    .line 108
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 109
    invoke-interface {v0, p1, p2, p3}, Lorg/cocos2dx/enginedata/IEngineDataManager;->notifyContinuousFrameLost(III)V

    goto :goto_0
.end method

.method public notifyFpsChanged(FF)V
    .locals 2

    .prologue
    .line 122
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 125
    return-void

    .line 122
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 123
    invoke-interface {v0, p1, p2}, Lorg/cocos2dx/enginedata/IEngineDataManager;->notifyFpsChanged(FF)V

    goto :goto_0
.end method

.method public notifyGameStatus(Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;II)V
    .locals 2

    .prologue
    .line 101
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 104
    return-void

    .line 101
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 102
    invoke-interface {v0, p1, p2, p3}, Lorg/cocos2dx/enginedata/IEngineDataManager;->notifyGameStatus(Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;II)V

    goto :goto_0
.end method

.method public notifyLowFps(IFI)V
    .locals 2

    .prologue
    .line 115
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 118
    return-void

    .line 115
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 116
    invoke-interface {v0, p1, p2, p3}, Lorg/cocos2dx/enginedata/IEngineDataManager;->notifyLowFps(IFI)V

    goto :goto_0
.end method

.method public pause()V
    .locals 2

    .prologue
    .line 87
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 90
    return-void

    .line 87
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 88
    invoke-interface {v0}, Lorg/cocos2dx/enginedata/IEngineDataManager;->pause()V

    goto :goto_0
.end method

.method public resume()V
    .locals 2

    .prologue
    .line 94
    iget-object v0, p0, Lorg/cocos2dx/enginedata/EngineDataManager;->d:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_0

    .line 97
    return-void

    .line 94
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager;

    .line 95
    invoke-interface {v0}, Lorg/cocos2dx/enginedata/IEngineDataManager;->resume()V

    goto :goto_0
.end method
