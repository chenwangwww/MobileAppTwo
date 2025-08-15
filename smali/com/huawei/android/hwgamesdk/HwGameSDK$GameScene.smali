.class public final enum Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;
.super Ljava/lang/Enum;
.source "HwGameSDK.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/huawei/android/hwgamesdk/HwGameSDK;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "GameScene"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic ENUM$VALUES:[Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

.field public static final enum GAME_INSCENE:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

.field public static final enum GAME_LAUNCH_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

.field public static final enum GAME_LAUNCH_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

.field public static final enum GAME_SCENECHANGE_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

.field public static final enum GAME_SCENECHANGE_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .prologue
    const/4 v6, 0x4

    const/4 v5, 0x3

    const/4 v4, 0x2

    const/4 v3, 0x1

    const/4 v2, 0x0

    .line 149
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    const-string v1, "GAME_LAUNCH_BEGIN"

    invoke-direct {v0, v1, v2}, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 150
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    const-string v1, "GAME_LAUNCH_END"

    invoke-direct {v0, v1, v3}, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 151
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    const-string v1, "GAME_SCENECHANGE_BEGIN"

    invoke-direct {v0, v1, v4}, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 152
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    const-string v1, "GAME_SCENECHANGE_END"

    invoke-direct {v0, v1, v5}, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 153
    new-instance v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    const-string v1, "GAME_INSCENE"

    invoke-direct {v0, v1, v6}, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_INSCENE:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    .line 147
    const/4 v0, 0x5

    new-array v0, v0, [Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    sget-object v1, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    aput-object v1, v0, v2

    sget-object v1, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_LAUNCH_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    aput-object v1, v0, v3

    sget-object v1, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_BEGIN:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    aput-object v1, v0, v4

    sget-object v1, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_SCENECHANGE_END:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    aput-object v1, v0, v5

    sget-object v1, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->GAME_INSCENE:Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    aput-object v1, v0, v6

    sput-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->ENUM$VALUES:[Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0

    .prologue
    .line 147
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;
    .locals 1

    .prologue
    .line 1
    const-class v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    return-object v0
.end method

.method public static values()[Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;
    .locals 4

    .prologue
    const/4 v3, 0x0

    .line 1
    sget-object v0, Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;->ENUM$VALUES:[Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    array-length v1, v0

    new-array v2, v1, [Lcom/huawei/android/hwgamesdk/HwGameSDK$GameScene;

    invoke-static {v0, v3, v2, v3, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v2
.end method
