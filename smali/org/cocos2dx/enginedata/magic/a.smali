.class public Lorg/cocos2dx/enginedata/magic/a;
.super Ljava/lang/Object;
.source "EngineDataManagerHuawei.java"

# interfaces
.implements Lorg/cocos2dx/enginedata/IEngineDataManager;


# static fields
.field private static final a:Ljava/lang/String; = "EngineDataManagerHuawei"

.field private static synthetic f:[I


# instance fields
.field private b:Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

.field private c:Z

.field private d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

.field private e:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameEngineCallBack;


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 84
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 37
    const/4 v0, 0x0

    iput-boolean v0, p0, Lorg/cocos2dx/enginedata/magic/a;->c:Z

    .line 39
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-direct {v0}, Lcom/huawei/android/hwgamesdk/HwGameSDK;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    .line 40
    new-instance v0, Lorg/cocos2dx/enginedata/magic/a$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/enginedata/magic/a$1;-><init>(Lorg/cocos2dx/enginedata/magic/a;)V

    iput-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->e:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameEngineCallBack;

    .line 86
    return-void
.end method

.method static synthetic a(Lorg/cocos2dx/enginedata/magic/a;)Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;
    .locals 1

    .prologue
    .line 36
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->b:Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    return-object v0
.end method

.method static synthetic a()[I
    .locals 3

    .prologue
    .line 32
    sget-object v0, Lorg/cocos2dx/enginedata/magic/a;->f:[I

    if-eqz v0, :cond_0

    :goto_0
    return-object v0

    :cond_0
    invoke-static {}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->values()[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    move-result-object v0

    array-length v0, v0

    new-array v0, v0, [I

    :try_start_0
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x6

    aput v2, v0, v1
    :try_end_0
    .catch Ljava/lang/NoSuchFieldError; {:try_start_0 .. :try_end_0} :catch_5

    :goto_1
    :try_start_1
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->IN_SCENE:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x5

    aput v2, v0, v1
    :try_end_1
    .catch Ljava/lang/NoSuchFieldError; {:try_start_1 .. :try_end_1} :catch_4

    :goto_2
    :try_start_2
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x1

    aput v2, v0, v1
    :try_end_2
    .catch Ljava/lang/NoSuchFieldError; {:try_start_2 .. :try_end_2} :catch_3

    :goto_3
    :try_start_3
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x2

    aput v2, v0, v1
    :try_end_3
    .catch Ljava/lang/NoSuchFieldError; {:try_start_3 .. :try_end_3} :catch_2

    :goto_4
    :try_start_4
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x3

    aput v2, v0, v1
    :try_end_4
    .catch Ljava/lang/NoSuchFieldError; {:try_start_4 .. :try_end_4} :catch_1

    :goto_5
    :try_start_5
    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-virtual {v1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    const/4 v2, 0x4

    aput v2, v0, v1
    :try_end_5
    .catch Ljava/lang/NoSuchFieldError; {:try_start_5 .. :try_end_5} :catch_0

    :goto_6
    sput-object v0, Lorg/cocos2dx/enginedata/magic/a;->f:[I

    goto :goto_0

    :catch_0
    move-exception v1

    goto :goto_6

    :catch_1
    move-exception v1

    goto :goto_5

    :catch_2
    move-exception v1

    goto :goto_4

    :catch_3
    move-exception v1

    goto :goto_3

    :catch_4
    move-exception v1

    goto :goto_2

    :catch_5
    move-exception v1

    goto :goto_1
.end method

.method static synthetic b(Lorg/cocos2dx/enginedata/magic/a;)Z
    .locals 1

    .prologue
    .line 37
    iget-boolean v0, p0, Lorg/cocos2dx/enginedata/magic/a;->c:Z

    return v0
.end method


# virtual methods
.method public destroy()V
    .locals 0

    .prologue
    .line 187
    return-void
.end method

.method public getVendorInfo()Ljava/lang/String;
    .locals 2

    .prologue
    .line 147
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "HuaWei:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v1}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->getApiLevel()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public init(Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;)Z
    .locals 6

    .prologue
    const/4 v3, 0x1

    const/4 v0, 0x0

    .line 152
    if-nez p1, :cond_0

    .line 181
    :goto_0
    return v0

    .line 156
    :cond_0
    iput-object p1, p0, Lorg/cocos2dx/enginedata/magic/a;->b:Lorg/cocos2dx/enginedata/IEngineDataManager$OnSystemCommandListener;

    .line 158
    const/4 v1, 0x1

    .line 161
    :try_start_0
    iget-object v2, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v2}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->getApiLevel()I

    move-result v2

    .line 163
    if-ge v2, v3, :cond_1

    .line 164
    const-string v3, "EngineDataManagerHuawei"

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "Unsupported function: HwGameSDK.getApiLevel: "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, ", min: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 175
    :catch_0
    move-exception v1

    goto :goto_0

    .line 168
    :cond_1
    const/4 v1, 0x2

    if-lt v2, v1, :cond_2

    .line 169
    const/4 v1, 0x1

    iput-boolean v1, p0, Lorg/cocos2dx/enginedata/magic/a;->c:Z

    .line 172
    :cond_2
    iget-object v1, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    iget-object v2, p0, Lorg/cocos2dx/enginedata/magic/a;->e:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameEngineCallBack;

    invoke-virtual {v1, v2}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->registerGame(Lcom/huawei/android/hwgamesdk/HwGameSDK$GameEngineCallBack;)Z
    :try_end_0
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/NoSuchMethodError; {:try_start_0 .. :try_end_0} :catch_1

    move-result v0

    goto :goto_0

    .line 178
    :catch_1
    move-exception v1

    goto :goto_0
.end method

.method public notifyContinuousFrameLost(III)V
    .locals 2

    .prologue
    .line 121
    :try_start_0
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v0, p1, p2, p3}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->notifyContinuousFpsMissed(III)V
    :try_end_0
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_0 .. :try_end_0} :catch_0

    .line 125
    :goto_0
    return-void

    .line 123
    :catch_0
    move-exception v0

    const-string v0, "EngineDataManagerHuawei"

    const-string v1, "Unsupported function: notifyGameStatus"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public notifyFpsChanged(FF)V
    .locals 2

    .prologue
    .line 139
    :try_start_0
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v0, p1, p2}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->notifyFpsChanged(FF)V
    :try_end_0
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_0 .. :try_end_0} :catch_0

    .line 143
    :goto_0
    return-void

    .line 141
    :catch_0
    move-exception v0

    const-string v0, "EngineDataManagerHuawei"

    const-string v1, "Unsupported function: notifyFpsChanged"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public notifyGameStatus(Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;II)V
    .locals 3

    .prologue
    .line 92
    :try_start_0
    invoke-static {}, Lorg/cocos2dx/enginedata/magic/a;->a()[I

    move-result-object v0

    invoke-virtual {p1}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ordinal()I

    move-result v1

    aget v0, v0, v1

    packed-switch v0, :pswitch_data_0

    .line 109
    const-string v0, "EngineDataManagerHuawei"

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "error type: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 116
    :goto_0
    return-void

    .line 94
    :pswitch_0
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 112
    :goto_1
    iget-object v1, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v1, v0, p2, p3}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->notifyGameScene(Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;II)V
    :try_end_0
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 114
    :catch_0
    move-exception v0

    const-string v0, "EngineDataManagerHuawei"

    const-string v1, "Unsupported function: notifyGameStatus"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 97
    :pswitch_1
    :try_start_1
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    goto :goto_1

    .line 100
    :pswitch_2
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_INSCENE:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    goto :goto_1

    .line 103
    :pswitch_3
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    goto :goto_1

    .line 106
    :pswitch_4
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;
    :try_end_1
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    .line 92
    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
        :pswitch_3
        :pswitch_4
        :pswitch_2
    .end packed-switch
.end method

.method public notifyLowFps(IFI)V
    .locals 2

    .prologue
    .line 130
    :try_start_0
    iget-object v0, p0, Lorg/cocos2dx/enginedata/magic/a;->d:Lcom/huawei/android/hwgamesdk/HwGameSDK;

    invoke-virtual {v0, p1, p2, p3}, Lcom/huawei/android/hwgamesdk/HwGameSDK;->notifyFpsDx(IFI)V
    :try_end_0
    .catch Lcom/huawei/android/hwgamesdk/NoExtAPIException; {:try_start_0 .. :try_end_0} :catch_0

    .line 134
    :goto_0
    return-void

    .line 132
    :catch_0
    move-exception v0

    const-string v0, "EngineDataManagerHuawei"

    const-string v1, "Unsupported function: notifyGameStatus"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public pause()V
    .locals 0

    .prologue
    .line 191
    return-void
.end method

.method public resume()V
    .locals 0

    .prologue
    .line 195
    return-void
.end method
