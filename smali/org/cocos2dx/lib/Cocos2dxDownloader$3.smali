.class final Lorg/cocos2dx/lib/Cocos2dxDownloader$3;
.super Ljava/lang/Object;
.source "Cocos2dxDownloader.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxDownloader;->createTask(Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

.field final synthetic val$id:I

.field final synthetic val$path:Ljava/lang/String;

.field final synthetic val$url:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/lang/String;)V
    .locals 0

    .prologue
    .line 296
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$id:I

    iput-object p4, p0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 27

    .prologue
    .line 299
    new-instance v23, Lorg/cocos2dx/lib/DownloadTask;

    invoke-direct/range {v23 .. v23}, Lorg/cocos2dx/lib/DownloadTask;-><init>()V

    .line 300
    .local v23, "task":Lorg/cocos2dx/lib/DownloadTask;
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-nez v2, :cond_0

    .line 302
    new-instance v2, Lorg/cocos2dx/lib/DataTaskHandler;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    move-object/from16 v0, p0

    iget v4, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$id:I

    invoke-direct {v2, v3, v4}, Lorg/cocos2dx/lib/DataTaskHandler;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;I)V

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    .line 303
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$100(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Lcom/loopj/android/http/AsyncHttpClient;

    move-result-object v2

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v3

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    move-object/from16 v0, v23

    iget-object v6, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    invoke-virtual {v2, v3, v4, v6}, Lcom/loopj/android/http/AsyncHttpClient;->get(Landroid/content/Context;Ljava/lang/String;Lcom/loopj/android/http/ResponseHandlerInterface;)Lcom/loopj/android/http/RequestHandle;

    move-result-object v2

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handle:Lcom/loopj/android/http/RequestHandle;

    .line 307
    :cond_0
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    if-nez v2, :cond_2

    .line 380
    :cond_1
    :goto_0
    move-object/from16 v0, v23

    iget-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handle:Lcom/loopj/android/http/RequestHandle;

    if-nez v2, :cond_c

    .line 381
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Can\'t create DownloadTask for "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    .line 382
    .local v14, "errStr":Ljava/lang/String;
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxDownloader$3$1;

    move-object/from16 v0, p0

    invoke-direct {v2, v0, v14}, Lorg/cocos2dx/lib/Cocos2dxDownloader$3$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader$3;Ljava/lang/String;)V

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxHelper;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 391
    .end local v14    # "errStr":Ljava/lang/String;
    :goto_1
    return-void

    .line 311
    :cond_2
    :try_start_0
    new-instance v25, Ljava/net/URI;

    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    move-object/from16 v0, v25

    invoke-direct {v0, v2}, Ljava/net/URI;-><init>(Ljava/lang/String;)V

    .line 312
    .local v25, "uri":Ljava/net/URI;
    invoke-virtual/range {v25 .. v25}, Ljava/net/URI;->getHost()Ljava/lang/String;

    move-result-object v12

    .line 315
    .local v12, "domain":Ljava/lang/String;
    if-nez v12, :cond_3

    .line 316
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    const/16 v3, 0x3f

    invoke-virtual {v2, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v19

    .line 317
    .local v19, "num":I
    if-lez v19, :cond_4

    .line 318
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    const/4 v3, 0x0

    move/from16 v0, v19

    invoke-virtual {v2, v3, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    :try_end_0
    .catch Ljava/net/URISyntaxException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v12

    .line 329
    .end local v19    # "num":I
    :cond_3
    :goto_2
    if-nez v12, :cond_5

    .line 330
    const-string v2, "Cocos2dxDownloader"

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "error, domain is null, url: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    move-object/from16 v0, p0

    iget-object v4, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 320
    .restart local v19    # "num":I
    :cond_4
    :try_start_1
    move-object/from16 v0, p0

    iget-object v12, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;
    :try_end_1
    .catch Ljava/net/URISyntaxException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_2

    .line 324
    .end local v12    # "domain":Ljava/lang/String;
    .end local v19    # "num":I
    .end local v25    # "uri":Ljava/net/URI;
    :catch_0
    move-exception v13

    .line 325
    .local v13, "e":Ljava/net/URISyntaxException;
    goto :goto_0

    .line 334
    .end local v13    # "e":Ljava/net/URISyntaxException;
    .restart local v12    # "domain":Ljava/lang/String;
    .restart local v25    # "uri":Ljava/net/URI;
    :cond_5
    const-string v2, "www."

    invoke-virtual {v12, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_7

    const/4 v2, 0x4

    invoke-virtual {v12, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    .line 335
    .local v5, "host":Ljava/lang/String;
    :goto_3
    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v22

    .line 336
    .local v22, "supportResuming":Ljava/lang/Boolean;
    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v21

    .line 337
    .local v21, "requestHeader":Ljava/lang/Boolean;
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$200()Ljava/util/HashMap;

    move-result-object v2

    invoke-virtual {v2, v5}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_6

    .line 338
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$200()Ljava/util/HashMap;

    move-result-object v2

    invoke-virtual {v2, v5}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v22

    .end local v22    # "supportResuming":Ljava/lang/Boolean;
    check-cast v22, Ljava/lang/Boolean;

    .line 339
    .restart local v22    # "supportResuming":Ljava/lang/Boolean;
    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v21

    .line 342
    :cond_6
    invoke-virtual/range {v21 .. v21}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    if-eqz v2, :cond_8

    .line 343
    new-instance v2, Lorg/cocos2dx/lib/HeadTaskHandler;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    move-object/from16 v0, p0

    iget v4, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$id:I

    move-object/from16 v0, p0

    iget-object v6, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    move-object/from16 v0, p0

    iget-object v7, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    invoke-direct/range {v2 .. v7}, Lorg/cocos2dx/lib/HeadTaskHandler;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    .line 344
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$100(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Lcom/loopj/android/http/AsyncHttpClient;

    move-result-object v6

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v7

    move-object/from16 v0, p0

    iget-object v8, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object/from16 v0, v23

    iget-object v11, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    invoke-virtual/range {v6 .. v11}, Lcom/loopj/android/http/AsyncHttpClient;->head(Landroid/content/Context;Ljava/lang/String;[Lcz/msebera/android/httpclient/Header;Lcom/loopj/android/http/RequestParams;Lcom/loopj/android/http/ResponseHandlerInterface;)Lcom/loopj/android/http/RequestHandle;

    move-result-object v2

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handle:Lcom/loopj/android/http/RequestHandle;

    goto/16 :goto_0

    .end local v5    # "host":Ljava/lang/String;
    .end local v21    # "requestHeader":Ljava/lang/Boolean;
    .end local v22    # "supportResuming":Ljava/lang/Boolean;
    :cond_7
    move-object v5, v12

    .line 334
    goto :goto_3

    .line 349
    .restart local v5    # "host":Ljava/lang/String;
    .restart local v21    # "requestHeader":Ljava/lang/Boolean;
    .restart local v22    # "supportResuming":Ljava/lang/Boolean;
    :cond_8
    new-instance v24, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-static {v3}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$300(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, v24

    invoke-direct {v0, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 350
    .local v24, "tempFile":Ljava/io/File;
    invoke-virtual/range {v24 .. v24}, Ljava/io/File;->isDirectory()Z

    move-result v2

    if-nez v2, :cond_1

    .line 352
    invoke-virtual/range {v24 .. v24}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v20

    .line 353
    .local v20, "parent":Ljava/io/File;
    invoke-virtual/range {v20 .. v20}, Ljava/io/File;->isDirectory()Z

    move-result v2

    if-nez v2, :cond_9

    invoke-virtual/range {v20 .. v20}, Ljava/io/File;->mkdirs()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 355
    :cond_9
    new-instance v15, Ljava/io/File;

    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$path:Ljava/lang/String;

    invoke-direct {v15, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 356
    .local v15, "finalFile":Ljava/io/File;
    invoke-virtual {v15}, Ljava/io/File;->isDirectory()Z

    move-result v2

    if-nez v2, :cond_1

    .line 358
    new-instance v2, Lorg/cocos2dx/lib/FileTaskHandler;

    move-object/from16 v0, p0

    iget-object v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    move-object/from16 v0, p0

    iget v4, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$id:I

    move-object/from16 v0, v24

    invoke-direct {v2, v3, v4, v0, v15}, Lorg/cocos2dx/lib/FileTaskHandler;-><init>(Lorg/cocos2dx/lib/Cocos2dxDownloader;ILjava/io/File;Ljava/io/File;)V

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    .line 359
    const/4 v9, 0x0

    .line 360
    .local v9, "headers":[Lcz/msebera/android/httpclient/Header;
    invoke-virtual/range {v24 .. v24}, Ljava/io/File;->length()J

    move-result-wide v16

    .line 361
    .local v16, "fileLen":J
    invoke-virtual/range {v22 .. v22}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v2

    if-eqz v2, :cond_b

    const-wide/16 v2, 0x0

    cmp-long v2, v16, v2

    if-lez v2, :cond_b

    .line 363
    new-instance v18, Ljava/util/ArrayList;

    invoke-direct/range {v18 .. v18}, Ljava/util/ArrayList;-><init>()V

    .line 364
    .local v18, "list":Ljava/util/List;, "Ljava/util/List<Lcz/msebera/android/httpclient/Header;>;"
    new-instance v2, Lcz/msebera/android/httpclient/message/BasicHeader;

    const-string v3, "Range"

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "bytes="

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    move-wide/from16 v0, v16

    invoke-virtual {v4, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v6, "-"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v2, v3, v4}, Lcz/msebera/android/httpclient/message/BasicHeader;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    move-object/from16 v0, v18

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 365
    invoke-interface/range {v18 .. v18}, Ljava/util/List;->size()I

    move-result v2

    new-array v2, v2, [Lcz/msebera/android/httpclient/Header;

    move-object/from16 v0, v18

    invoke-interface {v0, v2}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v9

    .end local v9    # "headers":[Lcz/msebera/android/httpclient/Header;
    check-cast v9, [Lcz/msebera/android/httpclient/Header;

    .line 377
    .end local v18    # "list":Ljava/util/List;, "Ljava/util/List<Lcz/msebera/android/httpclient/Header;>;"
    .restart local v9    # "headers":[Lcz/msebera/android/httpclient/Header;
    :cond_a
    :goto_4
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$100(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Lcom/loopj/android/http/AsyncHttpClient;

    move-result-object v6

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getActivity()Landroid/app/Activity;

    move-result-object v7

    move-object/from16 v0, p0

    iget-object v8, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$url:Ljava/lang/String;

    const/4 v10, 0x0

    move-object/from16 v0, v23

    iget-object v11, v0, Lorg/cocos2dx/lib/DownloadTask;->handler:Lcom/loopj/android/http/AsyncHttpResponseHandler;

    invoke-virtual/range {v6 .. v11}, Lcom/loopj/android/http/AsyncHttpClient;->get(Landroid/content/Context;Ljava/lang/String;[Lcz/msebera/android/httpclient/Header;Lcom/loopj/android/http/RequestParams;Lcom/loopj/android/http/ResponseHandlerInterface;)Lcom/loopj/android/http/RequestHandle;

    move-result-object v2

    move-object/from16 v0, v23

    iput-object v2, v0, Lorg/cocos2dx/lib/DownloadTask;->handle:Lcom/loopj/android/http/RequestHandle;

    goto/16 :goto_0

    .line 367
    :cond_b
    const-wide/16 v2, 0x0

    cmp-long v2, v16, v2

    if-lez v2, :cond_a

    .line 370
    :try_start_2
    new-instance v26, Ljava/io/PrintWriter;

    move-object/from16 v0, v26

    move-object/from16 v1, v24

    invoke-direct {v0, v1}, Ljava/io/PrintWriter;-><init>(Ljava/io/File;)V

    .line 371
    .local v26, "writer":Ljava/io/PrintWriter;
    const-string v2, ""

    move-object/from16 v0, v26

    invoke-virtual {v0, v2}, Ljava/io/PrintWriter;->print(Ljava/lang/String;)V

    .line 372
    invoke-virtual/range {v26 .. v26}, Ljava/io/PrintWriter;->close()V
    :try_end_2
    .catch Ljava/io/FileNotFoundException; {:try_start_2 .. :try_end_2} :catch_1

    goto :goto_4

    .line 375
    .end local v26    # "writer":Ljava/io/PrintWriter;
    :catch_1
    move-exception v2

    goto :goto_4

    .line 389
    .end local v5    # "host":Ljava/lang/String;
    .end local v9    # "headers":[Lcz/msebera/android/httpclient/Header;
    .end local v12    # "domain":Ljava/lang/String;
    .end local v15    # "finalFile":Ljava/io/File;
    .end local v16    # "fileLen":J
    .end local v20    # "parent":Ljava/io/File;
    .end local v21    # "requestHeader":Ljava/lang/Boolean;
    .end local v22    # "supportResuming":Ljava/lang/Boolean;
    .end local v24    # "tempFile":Ljava/io/File;
    .end local v25    # "uri":Ljava/net/URI;
    :cond_c
    move-object/from16 v0, p0

    iget-object v2, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$downloader:Lorg/cocos2dx/lib/Cocos2dxDownloader;

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxDownloader;->access$400(Lorg/cocos2dx/lib/Cocos2dxDownloader;)Ljava/util/HashMap;

    move-result-object v2

    move-object/from16 v0, p0

    iget v3, v0, Lorg/cocos2dx/lib/Cocos2dxDownloader$3;->val$id:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    move-object/from16 v0, v23

    invoke-virtual {v2, v3, v0}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_1
.end method
