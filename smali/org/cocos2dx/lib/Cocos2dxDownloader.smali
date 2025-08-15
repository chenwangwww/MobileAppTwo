.class public Lorg/cocos2dx/lib/Cocos2dxDownloader;
.super Ljava/lang/Object;
.source "Cocos2dxDownloader.java"


# static fields
.field private static _resumingSupport:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private _countOfMaxProcessingTasks:I

.field private _httpClient:Lcom/loopj/android/http/AsyncHttpClient;

.field private _id:I

.field private _runningTaskCount:I

.field private _taskMap:Ljava/util/HashMap;

.field private _taskQueue:Ljava/util/Queue;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Queue",
            "<",
            "Ljava/lang/Runnable;",
            ">;"
        }
    .end annotation
.end field

.field private _tempFileNameSufix:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 235
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_resumingSupport:Ljava/util/HashMap;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    .line 227
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 229
    new-instance v0, Lcom/loopj/android/http/AsyncHttpClient;

    invoke-direct {v0}, Lcom/loopj/android/http/AsyncHttpClient;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_httpClient:Lcom/loopj/android/http/AsyncHttpClient;

    .line 232
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    .line 233
    new-instance v0, Ljava/util/LinkedList;

    invoke-direct {v0}, Ljava/util/LinkedList;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskQueue:Ljava/util/Queue;

    .line 234
    const/4 v0, 0x0

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    return-void
.end method

.method static synthetic access$000(Lorg/cocos2dx/lib/Cocos2dxDownloader;)I
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;

    .prologue
    .line 227
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_id:I

    return v0
.end method

.method static synthetic access$100(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Lcom/loopj/android/http/AsyncHttpClient;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;

    .prologue
    .line 227
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_httpClient:Lcom/loopj/android/http/AsyncHttpClient;

    return-object v0
.end method

.method static synthetic access$200()Ljava/util/HashMap;
    .locals 1

    .prologue
    .line 227
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_resumingSupport:Ljava/util/HashMap;

    return-object v0
.end method

.method static synthetic access$300(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;

    .prologue
    .line 227
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_tempFileNameSufix:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$400(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Ljava/util/HashMap;
    .locals 1
    .param p0, "x0"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;

    .prologue
    .line 227
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    return-object v0
.end method

.method public static cancelAllRequests(Lorg/cocos2dx/lib/Cocos2dxDownloader;)V
    .locals 2
    .param p0, "downloader"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;

    .prologue
    .line 397
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v0

    new-instance v1, Lorg/cocos2dx/lib/Cocos2dxDownloader$4;

    invoke-direct {v1, p0}, Lorg/cocos2dx/lib/Cocos2dxDownloader$4;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 413
    return-void
.end method

.method public static createDownloader(IILjava/lang/String;I)Lorg/cocos2dx/lib/Cocos2dxDownloader;
    .locals 3
    .param p0, "id"    # I
    .param p1, "timeoutInSeconds"    # I
    .param p2, "tempFileNameSufix"    # Ljava/lang/String;
    .param p3, "countOfMaxProcessingTasks"    # I

    .prologue
    .line 276
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-direct {v0}, Lorg/cocos2dx/lib/Cocos2dxDownloader;-><init>()V

    .line 277
    .local v0, "downloader":Lorg/cocos2dx/lib/Cocos2dxDownloader;
    iput p0, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_id:I

    .line 279
    iget-object v1, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_httpClient:Lcom/loopj/android/http/AsyncHttpClient;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Lcom/loopj/android/http/AsyncHttpClient;->setEnableRedirects(Z)V

    .line 280
    if-lez p1, :cond_0

    .line 281
    iget-object v1, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_httpClient:Lcom/loopj/android/http/AsyncHttpClient;

    mul-int/lit16 v2, p1, 0x3e8

    invoke-virtual {v1, v2}, Lcom/loopj/android/http/AsyncHttpClient;->setTimeout(I)V

    .line 284
    :cond_0
    iget-object v1, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_httpClient:Lcom/loopj/android/http/AsyncHttpClient;

    const-class v1, Ljavax/net/ssl/SSLException;

    invoke-static {v1}, Lcom/loopj/android/http/AsyncHttpClient;->allowRetryExceptionClass(Ljava/lang/Class;)V

    .line 286
    iput-object p2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_tempFileNameSufix:Ljava/lang/String;

    .line 287
    iput p3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_countOfMaxProcessingTasks:I

    .line 288
    return-object v0
.end method

.method public static createTask(Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "downloader"    # Lorg/cocos2dx/lib/Cocos2dxDownloader;
    .param p1, "id_"    # I
    .param p2, "url_"    # Ljava/lang/String;
    .param p3, "path_"    # Ljava/lang/String;

    .prologue
    .line 292
    move v0, p1

    .line 293
    .local v0, "id":I
    move-object v3, p2

    .line 294
    .local v3, "url":Ljava/lang/String;
    move-object v1, p3

    .line 296
    .local v1, "path":Ljava/lang/String;
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;

    invoke-direct {v2, v1, p0, v0, v3}, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;-><init>(Ljava/lang/String;Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/lang/String;)V

    .line 393
    .local v2, "taskRunnable":Ljava/lang/Runnable;
    invoke-virtual {p0, v2}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->enqueueTask(Ljava/lang/Runnable;)V

    .line 394
    return-void
.end method

.method public static setResumingSupport(Ljava/lang/String;Ljava/lang/Boolean;)V
    .locals 1
    .param p0, "host"    # Ljava/lang/String;
    .param p1, "support"    # Ljava/lang/Boolean;

    .prologue
    .line 272
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_resumingSupport:Ljava/util/HashMap;

    invoke-virtual {v0, p0, p1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 273
    return-void
.end method


# virtual methods
.method public enqueueTask(Ljava/lang/Runnable;)V
    .locals 3
    .param p1, "taskRunnable"    # Ljava/lang/Runnable;

    .prologue
    .line 417
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskQueue:Ljava/util/Queue;

    monitor-enter v1

    .line 418
    :try_start_0
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_countOfMaxProcessingTasks:I

    if-ge v0, v2, :cond_0

    .line 419
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 420
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    .line 424
    :goto_0
    monitor-exit v1

    .line 425
    return-void

    .line 422
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskQueue:Ljava/util/Queue;

    invoke-interface {v0, p1}, Ljava/util/Queue;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 424
    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method native nativeOnFinish(IIILjava/lang/String;[B)V
.end method

.method native nativeOnProgress(IIJJJ)V
.end method

.method public onFinish(IILjava/lang/String;[B)V
    .locals 7
    .param p1, "id"    # I
    .param p2, "errCode"    # I
    .param p3, "errStr"    # Ljava/lang/String;
    .param p4, "data"    # [B

    .prologue
    .line 260
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lorg/cocos2dx/lib/DownloadTask;

    .line 261
    .local v6, "task":Lorg/cocos2dx/lib/DownloadTask;
    if-nez v6, :cond_0

    .line 269
    :goto_0
    return-void

    .line 262
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/util/HashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 263
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$2;

    move-object v1, p0

    move v2, p1

    move v3, p2

    move-object v4, p3

    move-object v5, p4

    invoke-direct/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxDownloader$2;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;IILjava/lang/String;[B)V

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxHelper;->runOnGLThread(Ljava/lang/Runnable;)V

    goto :goto_0
.end method

.method onProgress(IJJJ)V
    .locals 12
    .param p1, "id"    # I
    .param p2, "downloadBytes"    # J
    .param p4, "downloadNow"    # J
    .param p6, "downloadTotal"    # J

    .prologue
    .line 238
    iget-object v3, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lorg/cocos2dx/lib/DownloadTask;

    .line 239
    .local v2, "task":Lorg/cocos2dx/lib/DownloadTask;
    if-eqz v2, :cond_0

    .line 240
    iput-wide p2, v2, Lorg/cocos2dx/lib/DownloadTask;->bytesReceived:J

    .line 241
    move-wide/from16 v0, p4

    iput-wide v0, v2, Lorg/cocos2dx/lib/DownloadTask;->totalBytesReceived:J

    .line 242
    move-wide/from16 v0, p6

    iput-wide v0, v2, Lorg/cocos2dx/lib/DownloadTask;->totalBytesExpected:J

    .line 244
    :cond_0
    new-instance v3, Lorg/cocos2dx/lib/Cocos2dxDownloader$1;

    move-object v4, p0

    move v5, p1

    move-wide v6, p2

    move-wide/from16 v8, p4

    move-wide/from16 v10, p6

    invoke-direct/range {v3 .. v11}, Lorg/cocos2dx/lib/Cocos2dxDownloader$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;IJJJ)V

    invoke-static {v3}, Lorg/cocos2dx/lib/Cocos2dxHelper;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 250
    return-void
.end method

.method public onStart(I)V
    .locals 3
    .param p1, "id"    # I

    .prologue
    .line 253
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskMap:Ljava/util/HashMap;

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/DownloadTask;

    .line 254
    .local v0, "task":Lorg/cocos2dx/lib/DownloadTask;
    if-eqz v0, :cond_0

    .line 255
    invoke-virtual {v0}, Lorg/cocos2dx/lib/DownloadTask;->resetStatus()V

    .line 257
    :cond_0
    return-void
.end method

.method public runNextTaskIfExists()V
    .locals 3

    .prologue
    .line 428
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskQueue:Ljava/util/Queue;

    monitor-enter v2

    .line 429
    :try_start_0
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_taskQueue:Ljava/util/Queue;

    invoke-interface {v1}, Ljava/util/Queue;->poll()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Runnable;

    .line 430
    .local v0, "taskRunnable":Ljava/lang/Runnable;
    if-eqz v0, :cond_0

    .line 431
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 435
    :goto_0
    monitor-exit v2

    .line 436
    return-void

    .line 433
    :cond_0
    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    add-int/lit8 v1, v1, -0x1

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader;->_runningTaskCount:I

    goto :goto_0

    .line 435
    .end local v0    # "taskRunnable":Ljava/lang/Runnable;
    :catchall_0
    move-exception v1

    monitor-exit v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method
