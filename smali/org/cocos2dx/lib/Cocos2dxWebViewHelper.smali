.class public Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;
.super Ljava/lang/Object;
.source "Cocos2dxWebViewHelper.java"


# static fields
.field private static final TAG:Ljava/lang/String;

.field private static sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field private static sHandler:Landroid/os/Handler;

.field private static sLayout:Landroid/widget/FrameLayout;

.field private static viewTag:I

.field private static webViews:Landroid/util/SparseArray;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/util/SparseArray",
            "<",
            "Lorg/cocos2dx/lib/Cocos2dxWebView;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 23
    const-class v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->TAG:Ljava/lang/String;

    .line 29
    const/4 v0, 0x0

    sput v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->viewTag:I

    return-void
.end method

.method public constructor <init>(Landroid/widget/FrameLayout;)V
    .locals 2
    .param p1, "layout"    # Landroid/widget/FrameLayout;

    .prologue
    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 32
    sput-object p1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sLayout:Landroid/widget/FrameLayout;

    .line 33
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sHandler:Landroid/os/Handler;

    .line 35
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getContext()Landroid/content/Context;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxActivity;

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 36
    new-instance v0, Landroid/util/SparseArray;

    invoke-direct {v0}, Landroid/util/SparseArray;-><init>()V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->webViews:Landroid/util/SparseArray;

    .line 37
    return-void
.end method

.method public static _didFailLoading(ILjava/lang/String;)V
    .locals 0
    .param p0, "index"    # I
    .param p1, "message"    # Ljava/lang/String;

    .prologue
    .line 54
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->didFailLoading(ILjava/lang/String;)V

    .line 55
    return-void
.end method

.method public static _didFinishLoading(ILjava/lang/String;)V
    .locals 0
    .param p0, "index"    # I
    .param p1, "message"    # Ljava/lang/String;

    .prologue
    .line 48
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->didFinishLoading(ILjava/lang/String;)V

    .line 49
    return-void
.end method

.method public static _onJsCallback(ILjava/lang/String;)V
    .locals 0
    .param p0, "index"    # I
    .param p1, "message"    # Ljava/lang/String;

    .prologue
    .line 60
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->onJsCallback(ILjava/lang/String;)V

    .line 61
    return-void
.end method

.method public static _shouldStartLoading(ILjava/lang/String;)Z
    .locals 1
    .param p0, "index"    # I
    .param p1, "message"    # Ljava/lang/String;

    .prologue
    .line 42
    invoke-static {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->shouldStartLoading(ILjava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method static synthetic access$000()Lorg/cocos2dx/lib/Cocos2dxActivity;
    .locals 1

    .prologue
    .line 22
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-object v0
.end method

.method static synthetic access$100()Landroid/widget/FrameLayout;
    .locals 1

    .prologue
    .line 22
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sLayout:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method static synthetic access$200()Landroid/util/SparseArray;
    .locals 1

    .prologue
    .line 22
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->webViews:Landroid/util/SparseArray;

    return-object v0
.end method

.method public static callInMainThread(Ljava/util/concurrent/Callable;)Ljava/lang/Object;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "<T:",
            "Ljava/lang/Object;",
            ">(",
            "Ljava/util/concurrent/Callable",
            "<TT;>;)TT;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/util/concurrent/ExecutionException;,
            Ljava/lang/InterruptedException;
        }
    .end annotation

    .prologue
    .line 274
    .local p0, "call":Ljava/util/concurrent/Callable;, "Ljava/util/concurrent/Callable<TT;>;"
    new-instance v0, Ljava/util/concurrent/FutureTask;

    invoke-direct {v0, p0}, Ljava/util/concurrent/FutureTask;-><init>(Ljava/util/concurrent/Callable;)V

    .line 275
    .local v0, "task":Ljava/util/concurrent/FutureTask;, "Ljava/util/concurrent/FutureTask<TT;>;"
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sHandler:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 276
    invoke-virtual {v0}, Ljava/util/concurrent/FutureTask;->get()Ljava/lang/Object;

    move-result-object v1

    return-object v1
.end method

.method public static canGoBack(I)Z
    .locals 4
    .param p0, "index"    # I

    .prologue
    const/4 v3, 0x0

    .line 280
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$15;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$15;-><init>(I)V

    .line 288
    .local v0, "callable":Ljava/util/concurrent/Callable;, "Ljava/util/concurrent/Callable<Ljava/lang/Boolean;>;"
    :try_start_0
    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->callInMainThread(Ljava/util/concurrent/Callable;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z
    :try_end_0
    .catch Ljava/util/concurrent/ExecutionException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    move-result v2

    .line 292
    :goto_0
    return v2

    .line 289
    :catch_0
    move-exception v1

    .local v1, "e":Ljava/util/concurrent/ExecutionException;
    move v2, v3

    .line 290
    goto :goto_0

    .line 291
    .end local v1    # "e":Ljava/util/concurrent/ExecutionException;
    :catch_1
    move-exception v1

    .local v1, "e":Ljava/lang/InterruptedException;
    move v2, v3

    .line 292
    goto :goto_0
.end method

.method public static canGoForward(I)Z
    .locals 4
    .param p0, "index"    # I

    .prologue
    const/4 v3, 0x0

    .line 297
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$16;

    invoke-direct {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$16;-><init>(I)V

    .line 305
    .local v0, "callable":Ljava/util/concurrent/Callable;, "Ljava/util/concurrent/Callable<Ljava/lang/Boolean;>;"
    :try_start_0
    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->callInMainThread(Ljava/util/concurrent/Callable;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Boolean;

    invoke-virtual {v2}, Ljava/lang/Boolean;->booleanValue()Z
    :try_end_0
    .catch Ljava/util/concurrent/ExecutionException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    move-result v2

    .line 309
    :goto_0
    return v2

    .line 306
    :catch_0
    move-exception v1

    .local v1, "e":Ljava/util/concurrent/ExecutionException;
    move v2, v3

    .line 307
    goto :goto_0

    .line 308
    .end local v1    # "e":Ljava/util/concurrent/ExecutionException;
    :catch_1
    move-exception v1

    .local v1, "e":Ljava/lang/InterruptedException;
    move v2, v3

    .line 309
    goto :goto_0
.end method

.method public static createWebView()I
    .locals 3

    .prologue
    .line 64
    sget v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->viewTag:I

    .line 65
    .local v0, "index":I
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$1;

    invoke-direct {v2, v0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$1;-><init>(I)V

    invoke-virtual {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 77
    sget v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->viewTag:I

    add-int/lit8 v2, v1, 0x1

    sput v2, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->viewTag:I

    return v1
.end method

.method private static native didFailLoading(ILjava/lang/String;)V
.end method

.method private static native didFinishLoading(ILjava/lang/String;)V
.end method

.method public static evaluateJS(ILjava/lang/String;)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "js"    # Ljava/lang/String;

    .prologue
    .line 338
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$19;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$19;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 347
    return-void
.end method

.method public static getOpacityWebView(I)F
    .locals 4
    .param p0, "index"    # I

    .prologue
    .line 146
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0xa

    if-le v2, v3, :cond_0

    .line 147
    new-instance v1, Ljava/util/concurrent/FutureTask;

    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;

    invoke-direct {v2, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$6;-><init>(I)V

    invoke-direct {v1, v2}, Ljava/util/concurrent/FutureTask;-><init>(Ljava/util/concurrent/Callable;)V

    .line 164
    .local v1, "futureResult":Ljava/util/concurrent/FutureTask;, "Ljava/util/concurrent/FutureTask<Ljava/lang/Float;>;"
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v2, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 166
    :try_start_0
    invoke-virtual {v1}, Ljava/util/concurrent/FutureTask;->get()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Float;

    invoke-virtual {v2}, Ljava/lang/Float;->floatValue()F
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v2

    .line 171
    .end local v1    # "futureResult":Ljava/util/concurrent/FutureTask;, "Ljava/util/concurrent/FutureTask<Ljava/lang/Float;>;"
    :goto_0
    return v2

    .line 167
    .restart local v1    # "futureResult":Ljava/util/concurrent/FutureTask;, "Ljava/util/concurrent/FutureTask<Ljava/lang/Float;>;"
    :catch_0
    move-exception v0

    .line 168
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 171
    .end local v0    # "e":Ljava/lang/Exception;
    .end local v1    # "futureResult":Ljava/util/concurrent/FutureTask;, "Ljava/util/concurrent/FutureTask<Ljava/lang/Float;>;"
    :cond_0
    const/high16 v2, 0x3f800000    # 1.0f

    goto :goto_0
.end method

.method public static goBack(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 314
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$17;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$17;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 323
    return-void
.end method

.method public static goForward(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 326
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$18;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$18;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 335
    return-void
.end method

.method public static loadData(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "index"    # I
    .param p1, "data"    # Ljava/lang/String;
    .param p2, "mimeType"    # Ljava/lang/String;
    .param p3, "encoding"    # Ljava/lang/String;
    .param p4, "baseURL"    # Ljava/lang/String;

    .prologue
    .line 199
    sget-object v6, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$9;

    move v1, p0

    move-object v2, p4

    move-object v3, p1

    move-object v4, p2

    move-object v5, p3

    invoke-direct/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$9;-><init>(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v6, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 208
    return-void
.end method

.method public static loadFile(ILjava/lang/String;)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "filePath"    # Ljava/lang/String;

    .prologue
    .line 237
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$12;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$12;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 246
    return-void
.end method

.method public static loadHTMLString(ILjava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "data"    # Ljava/lang/String;
    .param p2, "baseUrl"    # Ljava/lang/String;

    .prologue
    .line 211
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$10;

    invoke-direct {v1, p0, p2, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$10;-><init>(ILjava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 220
    return-void
.end method

.method public static loadUrl(ILjava/lang/String;Z)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "url"    # Ljava/lang/String;
    .param p2, "cleanCachedData"    # Z

    .prologue
    .line 223
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$11;

    invoke-direct {v1, p0, p2, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$11;-><init>(IZLjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 234
    return-void
.end method

.method private static native onJsCallback(ILjava/lang/String;)V
.end method

.method public static reload(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 262
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$14;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$14;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 271
    return-void
.end method

.method public static removeWebView(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 81
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$2;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$2;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 91
    return-void
.end method

.method public static setBackgroundTransparent(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 106
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xa

    if-le v0, v1, :cond_0

    .line 107
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$4;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$4;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 123
    :cond_0
    return-void
.end method

.method public static setJavascriptInterfaceScheme(ILjava/lang/String;)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "scheme"    # Ljava/lang/String;

    .prologue
    .line 187
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$8;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$8;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 196
    return-void
.end method

.method public static setOpacityWebView(IF)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "opacity"    # F

    .prologue
    .line 126
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xa

    if-le v0, v1, :cond_0

    .line 127
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$5;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$5;-><init>(IF)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 142
    :cond_0
    return-void
.end method

.method public static setScalesPageToFit(IZ)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "scalesPageToFit"    # Z

    .prologue
    .line 350
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$20;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$20;-><init>(IZ)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 359
    return-void
.end method

.method public static setVisible(IZ)V
    .locals 2
    .param p0, "index"    # I
    .param p1, "visible"    # Z

    .prologue
    .line 94
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$3;

    invoke-direct {v1, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$3;-><init>(IZ)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 103
    return-void
.end method

.method public static setWebViewRect(IIIII)V
    .locals 7
    .param p0, "index"    # I
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "maxWidth"    # I
    .param p4, "maxHeight"    # I

    .prologue
    .line 175
    sget-object v6, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;

    move v1, p0

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    invoke-direct/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$7;-><init>(IIIII)V

    invoke-virtual {v6, v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 184
    return-void
.end method

.method private static native shouldStartLoading(ILjava/lang/String;)Z
.end method

.method public static stopLoading(I)V
    .locals 2
    .param p0, "index"    # I

    .prologue
    .line 249
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper;->sCocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$13;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxWebViewHelper$13;-><init>(I)V

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 259
    return-void
.end method
