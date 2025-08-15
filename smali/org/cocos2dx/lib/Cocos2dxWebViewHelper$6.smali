.class final Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;
.super Ljava/lang/Object;
.source "Cocos2dxWebViewHelper.java"

# interfaces
.implements Ljava/util/concurrent/Callable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->getOpacityWebView(I)F
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/concurrent/Callable",
        "<",
        "Ljava/lang/Float;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic val$index:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .prologue
    .line 147
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public call()Ljava/lang/Float;
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 150
    const/4 v2, 0x0

    .line 151
    .local v2, "opacity":F
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->access$200()Landroid/util/SparseArray;

    move-result-object v5

    iget v6, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;->val$index:I

    invoke-virtual {v5, v6}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lorg/cocos2dx/lib/Cocos2dxWebView;

    .line 152
    .local v4, "webView":Lorg/cocos2dx/lib/Cocos2dxWebView;
    const/4 v3, 0x0

    .line 153
    .local v3, "valueToReturn":Ljava/lang/Object;
    if-eqz v4, :cond_0

    .line 155
    :try_start_0
    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "getAlpha"

    const/4 v7, 0x0

    new-array v7, v7, [Ljava/lang/Class;

    invoke-virtual {v5, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 156
    .local v1, "method":Ljava/lang/reflect/Method;
    const/4 v5, 0x0

    new-array v5, v5, [Ljava/lang/Object;

    invoke-virtual {v1, v4, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v3

    .line 161
    .end local v1    # "method":Ljava/lang/reflect/Method;
    .end local v3    # "valueToReturn":Ljava/lang/Object;
    :cond_0
    :goto_0
    check-cast v3, Ljava/lang/Float;

    return-object v3

    .line 157
    .restart local v3    # "valueToReturn":Ljava/lang/Object;
    :catch_0
    move-exception v0

    .line 158
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public bridge synthetic call()Ljava/lang/Object;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 147
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;->call()Ljava/lang/Float;

    move-result-object v0

    return-object v0
.end method
