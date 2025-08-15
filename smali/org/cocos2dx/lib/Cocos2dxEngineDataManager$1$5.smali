.class Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;
.super Ljava/lang/Object;
.source "Cocos2dxEngineDataManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->onChangeMuteEnabled(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

.field final synthetic val$enabled:Z


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;Z)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    .prologue
    .line 136
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;->this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    iput-boolean p2, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;->val$enabled:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .prologue
    .line 139
    iget-boolean v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$5;->val$enabled:Z

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->access$500(Z)V

    .line 140
    return-void
.end method
