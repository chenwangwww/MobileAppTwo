.class Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;
.super Ljava/lang/Object;
.source "Cocos2dxEngineDataManager.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;->onChangeSpecialEffectLevel(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

.field final synthetic val$level:I


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;I)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    .prologue
    .line 126
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;->this$0:Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1;

    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;->val$level:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .prologue
    .line 129
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager$1$4;->val$level:I

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEngineDataManager;->access$400(I)V

    .line 130
    return-void
.end method
