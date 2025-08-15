.class Lorg/cocos2dx/lib/VideoController$DrawRunnable;
.super Ljava/lang/Object;
.source "VideoController.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/lib/VideoController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = "DrawRunnable"
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/VideoController;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/VideoController;)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 191
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 10

    .prologue
    const-wide/16 v8, 0x50

    .line 194
    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v4}, Lorg/cocos2dx/lib/VideoController;->access$000(Lorg/cocos2dx/lib/VideoController;)Z

    move-result v4

    if-nez v4, :cond_0

    .line 203
    :goto_0
    return-void

    .line 195
    :cond_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 196
    .local v2, "start":J
    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-virtual {v4}, Lorg/cocos2dx/lib/VideoController;->draw()V

    .line 197
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    .line 198
    .local v0, "end":J
    sub-long v4, v0, v2

    cmp-long v4, v4, v8

    if-gez v4, :cond_1

    .line 199
    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v4}, Lorg/cocos2dx/lib/VideoController;->access$100(Lorg/cocos2dx/lib/VideoController;)Landroid/os/Handler;

    move-result-object v4

    sub-long v6, v0, v2

    sub-long v6, v8, v6

    invoke-virtual {v4, p0, v6, v7}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_0

    .line 201
    :cond_1
    iget-object v4, p0, Lorg/cocos2dx/lib/VideoController$DrawRunnable;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v4}, Lorg/cocos2dx/lib/VideoController;->access$100(Lorg/cocos2dx/lib/VideoController;)Landroid/os/Handler;

    move-result-object v4

    invoke-virtual {v4, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_0
.end method
