.class public final enum Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
.super Ljava/lang/Enum;
.source "IEngineDataManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/enginedata/IEngineDataManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "GameStatus"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic ENUM$VALUES:[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum IN_SCENE:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum LAUNCH_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum LAUNCH_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum SCENE_CHANGE_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

.field public static final enum SCENE_CHANGE_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;


# instance fields
.field private status:I


# direct methods
.method static constructor <clinit>()V
    .locals 9

    .prologue
    const/4 v8, 0x4

    const/4 v7, 0x3

    const/4 v6, 0x2

    const/4 v5, 0x1

    const/4 v4, 0x0

    .line 32
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "LAUNCH_BEGIN"

    invoke-direct {v0, v1, v4, v4}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 33
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "LAUNCH_END"

    invoke-direct {v0, v1, v5, v5}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 34
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "SCENE_CHANGE_BEGIN"

    invoke-direct {v0, v1, v6, v6}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 35
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "SCENE_CHANGE_END"

    invoke-direct {v0, v1, v7, v7}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 36
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "IN_SCENE"

    invoke-direct {v0, v1, v8, v8}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->IN_SCENE:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 37
    new-instance v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    const-string v1, "INVALID"

    const/4 v2, 0x5

    const/16 v3, 0x1388

    invoke-direct {v0, v1, v2, v3}, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;-><init>(Ljava/lang/String;II)V

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    .line 30
    const/4 v0, 0x6

    new-array v0, v0, [Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v1, v0, v4

    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->LAUNCH_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v1, v0, v5

    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_BEGIN:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v1, v0, v6

    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->SCENE_CHANGE_END:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v1, v0, v7

    sget-object v1, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->IN_SCENE:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v1, v0, v8

    const/4 v1, 0x5

    sget-object v2, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->INVALID:Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    aput-object v2, v0, v1

    sput-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ENUM$VALUES:[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;II)V
    .locals 0

    .prologue
    .line 40
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 41
    iput p3, p0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->status:I

    .line 42
    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    .locals 1

    .prologue
    .line 1
    const-class v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    return-object v0
.end method

.method public static values()[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;
    .locals 4

    .prologue
    const/4 v3, 0x0

    .line 1
    sget-object v0, Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;->ENUM$VALUES:[Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    array-length v1, v0

    new-array v2, v1, [Lorg/cocos2dx/enginedata/IEngineDataManager$GameStatus;

    invoke-static {v0, v3, v2, v3, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v2
.end method
