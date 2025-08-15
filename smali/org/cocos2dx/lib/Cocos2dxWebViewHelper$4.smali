.class final Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$4;
.super Ljava/lang/Object;
.source "Cocos2dxWebViewHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->setBackgroundTransparent(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$index:I


# direct methods
.method constructor <init>(I)V
    .locals 0

    .prologue
    .line 107
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$4;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 8

    .prologue
    const/4 v5, 0x0

    .line 110
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->access$200()Landroid/util/SparseArray;

    move-result-object v3

    iget v4, p0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$4;->val$index:I

    invoke-virtual {v3, v4}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lorg/cocos2dx/lib/Cocos2dxWebView;

    .line 111
    .local v2, "webView":Lorg/cocos2dx/lib/Cocos2dxWebView;
    if-eqz v2, :cond_0

    .line 112
    invoke-virtual {v2, v5}, Lorg/cocos2dx/lib/Cocos2dxWebView;->setBackgroundColor(I)V

    .line 114
    :try_start_0
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "setLayerType"

    const/4 v5, 0x2

    new-array v5, v5, [Ljava/lang/Class;

    const/4 v6, 0x0

    sget-object v7, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v7, v5, v6

    const/4 v6, 0x1

    const-class v7, Landroid/graphics/Paint;

    aput-object v7, v5, v6

    invoke-virtual {v3, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    .line 115
    .local v1, "method":Ljava/lang/reflect/Method;
    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    const/4 v5, 0x1

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    aput-object v5, v3, v4

    const/4 v4, 0x1

    const/4 v5, 0x0

    aput-object v5, v3, v4

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 120
    .end local v1    # "method":Ljava/lang/reflect/Method;
    :cond_0
    :goto_0
    return-void

    .line 116
    :catch_0
    move-exception v0

    .line 117
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method
