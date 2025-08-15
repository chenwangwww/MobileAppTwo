.class Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;
.super Ljava/lang/Object;
.source "Cocos2dxEngineDataManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->onChangeLowFpsConfig(IF)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

.field final synthetic val$cycle:I

.field final synthetic val$maxFrameDx:F


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;IF)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    .prologue
    .line 106
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;->this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;->val$cycle:I

    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;->val$maxFrameDx:F

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .prologue
    .line 109
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;->val$cycle:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$2;->val$maxFrameDx:F

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->access$200(IF)V

    .line 110
    return-void
.end method
