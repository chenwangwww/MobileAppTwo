.class public Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;
.super Ljava/lang/Object;
.source "Cocos2dxEngineDataManager.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "CCEngineDataManager"

.field private static sIsEnabled:Z

.field private static sIsInited:Z

.field private static sManager:Lorg/cocos2dx/enginedata/EngineDataManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 37
    new-instance v0, Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-direct {v0}, Lorg/cocos2dx/enginedata/EngineDataManager;-><init>()V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    .line 38
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    .line 39
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsInited:Z

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .prologue
    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 43
    return-void
.end method

.method static synthetic access$000([I[I)V
    .locals 0
    .param p0, "x0"    # [I
    .param p1, "x1"    # [I

    .prologue
    .line 35
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnQueryFps([I[I)V

    return-void
.end method

.method static synthetic access$100(II)V
    .locals 0
    .param p0, "x0"    # I
    .param p1, "x1"    # I

    .prologue
    .line 35
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnChangeContinuousFrameLostConfig(II)V

    return-void
.end method

.method static synthetic access$200(IF)V
    .locals 0
    .param p0, "x0"    # I
    .param p1, "x1"    # F

    .prologue
    .line 35
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnChangeLowFpsConfig(IF)V

    return-void
.end method

.method static synthetic access$300(I)V
    .locals 0
    .param p0, "x0"    # I

    .prologue
    .line 35
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnChangeExpectedFps(I)V

    return-void
.end method

.method static synthetic access$400(I)V
    .locals 0
    .param p0, "x0"    # I

    .prologue
    .line 35
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnChangeSpecialEffectLevel(I)V

    return-void
.end method

.method static synthetic access$500(Z)V
    .locals 0
    .param p0, "x0"    # Z

    .prologue
    .line 35
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeOnChangeMuteEnabled(Z)V

    return-void
.end method

.method private static convertIntegerToGameStatus(I)Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    .locals 5
    .param p0, "gameStatus"    # I

    .prologue
    .line 181
    invoke-static {}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->values()[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    move-result-object v1

    .line 182
    .local v1, "values":[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    array-length v3, v1

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v3, :cond_1

    aget-object v0, v1, v2

    .line 183
    .local v0, "status":Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    invoke-virtual {v0}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v4

    if-ne p0, v4, :cond_0

    .line 188
    .end local v0    # "status":Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    :goto_1
    return-object v0

    .line 182
    .restart local v0    # "status":Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 188
    .end local v0    # "status":Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    :cond_1
    sget-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    goto :goto_1
.end method

.method public static destroy()V
    .locals 1

    .prologue
    .line 155
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-eqz v0, :cond_0

    .line 156
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0}, Lorg/cocos2dx/enginedata/EngineDataManager;->destroy()V

    .line 158
    :cond_0
    return-void
.end method

.method public static disable()V
    .locals 1

    .prologue
    .line 61
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    .line 62
    return-void
.end method

.method public static getVendorInfo()Ljava/lang/String;
    .locals 1

    .prologue
    .line 174
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-eqz v0, :cond_0

    .line 175
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0}, Lorg/cocos2dx/enginedata/EngineDataManager;->getVendorInfo()Ljava/lang/String;

    move-result-object v0

    .line 177
    :goto_0
    return-object v0

    :cond_0
    const-string v0, ""

    goto :goto_0
.end method

.method public static init(Landroid/content/Context;Landroid/opengl/GLSurfaceView;)Z
    .locals 4
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "glSurfaceView"    # Landroid/opengl/GLSurfaceView;

    .prologue
    const/4 v1, 0x0

    .line 70
    if-nez p0, :cond_0

    .line 71
    const-string v2, "CCEngineDataManager"

    const-string v3, "Context is null"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 151
    :goto_0
    return v1

    .line 75
    :cond_0
    if-nez p1, :cond_1

    .line 76
    const-string v2, "CCEngineDataManager"

    const-string v3, "glSurfaceView is null"

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 80
    :cond_1
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    invoke-direct {v0, p1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;-><init>(Landroid/opengl/GLSurfaceView;)V

    .line 145
    .local v0, "listener":Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;
    sget-boolean v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-eqz v1, :cond_2

    .line 146
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v1, v0}, Lorg/cocos2dx/enginedata/EngineDataManager;->init(Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;)Z

    move-result v1

    sput-boolean v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsInited:Z

    .line 149
    :cond_2
    sget-boolean v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsInited:Z

    invoke-static {v1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeSetSupportOptimization(Z)V

    .line 151
    sget-boolean v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsInited:Z

    goto :goto_0
.end method

.method public static isInited()Z
    .locals 1

    .prologue
    .line 65
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsInited:Z

    return v0
.end method

.method private static native nativeOnChangeContinuousFrameLostConfig(II)V
.end method

.method private static native nativeOnChangeExpectedFps(I)V
.end method

.method private static native nativeOnChangeLowFpsConfig(IF)V
.end method

.method private static native nativeOnChangeMuteEnabled(Z)V
.end method

.method private static native nativeOnChangeSpecialEffectLevel(I)V
.end method

.method private static native nativeOnQueryFps([I[I)V
.end method

.method private static native nativeSetSupportOptimization(Z)V
.end method

.method public static notifyContinuousFrameLost(III)V
    .locals 1
    .param p0, "cycle"    # I
    .param p1, "continuousFrameLostThreshold"    # I
    .param p2, "times"    # I

    .prologue
    .line 219
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-nez v0, :cond_0

    .line 220
    const/4 v0, 0x0

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeSetSupportOptimization(Z)V

    .line 225
    :goto_0
    return-void

    .line 224
    :cond_0
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0, p0, p1, p2}, Lorg/cocos2dx/enginedata/EngineDataManager;->notifyContinuousFrameLost(III)V

    goto :goto_0
.end method

.method public static notifyFpsChanged(FF)V
    .locals 1
    .param p0, "oldFps"    # F
    .param p1, "newFps"    # F

    .prologue
    .line 245
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-nez v0, :cond_0

    .line 246
    const/4 v0, 0x0

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeSetSupportOptimization(Z)V

    .line 251
    :goto_0
    return-void

    .line 250
    :cond_0
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0, p0, p1}, Lorg/cocos2dx/enginedata/EngineDataManager;->notifyFpsChanged(FF)V

    goto :goto_0
.end method

.method public static notifyGameStatus(III)V
    .locals 4
    .param p0, "gameStatus"    # I
    .param p1, "cpuLevel"    # I
    .param p2, "gpuLevel"    # I

    .prologue
    .line 197
    sget-boolean v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-nez v1, :cond_0

    .line 198
    const/4 v1, 0x0

    invoke-static {v1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeSetSupportOptimization(Z)V

    .line 208
    :goto_0
    return-void

    .line 202
    :cond_0
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->convertIntegerToGameStatus(I)Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    move-result-object v0

    .line 203
    .local v0, "status":Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    if-ne v0, v1, :cond_1

    .line 204
    const-string v1, "CCEngineDataManager"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Invalid game status: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 207
    :cond_1
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v1, v0, p1, p2}, Lorg/cocos2dx/enginedata/EngineDataManager;->notifyGameStatus(Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;II)V

    goto :goto_0
.end method

.method public static notifyLowFps(IFI)V
    .locals 1
    .param p0, "cycle"    # I
    .param p1, "lowFpsThreshold"    # F
    .param p2, "lostFrameCount"    # I

    .prologue
    .line 236
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-nez v0, :cond_0

    .line 237
    const/4 v0, 0x0

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->nativeSetSupportOptimization(Z)V

    .line 242
    :goto_0
    return-void

    .line 241
    :cond_0
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0, p0, p1, p2}, Lorg/cocos2dx/enginedata/EngineDataManager;->notifyLowFps(IFI)V

    goto :goto_0
.end method

.method public static pause()V
    .locals 1

    .prologue
    .line 161
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-eqz v0, :cond_0

    .line 162
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0}, Lorg/cocos2dx/enginedata/EngineDataManager;->pause()V

    .line 164
    :cond_0
    return-void
.end method

.method public static resume()V
    .locals 1

    .prologue
    .line 167
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sIsEnabled:Z

    if-eqz v0, :cond_0

    .line 168
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->sManager:Lorg/cocos2dx/enginedata/EngineDataManager;

    invoke-virtual {v0}, Lorg/cocos2dx/enginedata/EngineDataManager;->resume()V

    .line 170
    :cond_0
    return-void
.end method
