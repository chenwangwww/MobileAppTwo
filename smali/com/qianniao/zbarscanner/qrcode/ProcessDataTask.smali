.class public Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;
.super Landroid/os/AsyncTask;
.source "ProcessDataTask.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/os/AsyncTask",
        "<",
        "Ljava/lang/Void;",
        "Ljava/lang/Void;",
        "Ljava/lang/String;",
        ">;"
    }
.end annotation


# instance fields
.field private mCamera:Landroid/hardware/Camera;

.field private mData:[B

.field private mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;


# direct methods
.method public constructor <init>(Landroid/hardware/Camera;[BLcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;)V
    .locals 0
    .param p1, "camera"    # Landroid/hardware/Camera;
    .param p2, "data"    # [B
    .param p3, "delegate"    # Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    .prologue
    .line 12
    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    .line 13
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mCamera:Landroid/hardware/Camera;

    .line 14
    iput-object p2, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mData:[B

    .line 15
    iput-object p3, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    .line 16
    return-void
.end method


# virtual methods
.method public cancelTask()V
    .locals 2

    .prologue
    .line 28
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->getStatus()Landroid/os/AsyncTask$Status;

    move-result-object v0

    sget-object v1, Landroid/os/AsyncTask$Status;->FINISHED:Landroid/os/AsyncTask$Status;

    if-eq v0, v1, :cond_0

    .line 29
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->cancel(Z)Z

    .line 31
    :cond_0
    return-void
.end method

.method protected bridge synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 1

    .prologue
    .line 7
    check-cast p1, [Ljava/lang/Void;

    invoke-virtual {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->doInBackground([Ljava/lang/Void;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/String;
    .locals 14
    .param p1, "params"    # [Ljava/lang/Void;

    .prologue
    const/4 v10, 0x0

    .line 41
    iget-object v11, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mCamera:Landroid/hardware/Camera;

    invoke-virtual {v11}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v3

    .line 42
    .local v3, "parameters":Landroid/hardware/Camera$Parameters;
    invoke-virtual {v3}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;

    move-result-object v5

    .line 43
    .local v5, "size":Landroid/hardware/Camera$Size;
    iget v7, v5, Landroid/hardware/Camera$Size;->width:I

    .line 44
    .local v7, "width":I
    iget v2, v5, Landroid/hardware/Camera$Size;->height:I

    .line 46
    .local v2, "height":I
    iget-object v11, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mData:[B

    array-length v11, v11

    new-array v4, v11, [B

    .line 47
    .local v4, "rotatedData":[B
    const/4 v9, 0x0

    .local v9, "y":I
    :goto_0
    if-ge v9, v2, :cond_1

    .line 48
    const/4 v8, 0x0

    .local v8, "x":I
    :goto_1
    if-ge v8, v7, :cond_0

    .line 49
    mul-int v11, v8, v2

    add-int/2addr v11, v2

    sub-int/2addr v11, v9

    add-int/lit8 v11, v11, -0x1

    iget-object v12, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mData:[B

    mul-int v13, v9, v7

    add-int/2addr v13, v8

    aget-byte v12, v12, v13

    aput-byte v12, v4, v11

    .line 48
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 47
    :cond_0
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 52
    .end local v8    # "x":I
    :cond_1
    move v6, v7

    .line 53
    .local v6, "tmp":I
    move v7, v2

    .line 54
    move v2, v6

    .line 57
    :try_start_0
    iget-object v11, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    if-nez v11, :cond_2

    .line 65
    :goto_2
    return-object v10

    .line 60
    :cond_2
    iget-object v11, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    const/4 v12, 0x0

    invoke-interface {v11, v4, v7, v2, v12}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;->processData([BIIZ)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v10

    goto :goto_2

    .line 61
    :catch_0
    move-exception v0

    .line 63
    .local v0, "e1":Ljava/lang/Exception;
    :try_start_1
    iget-object v11, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    const/4 v12, 0x1

    invoke-interface {v11, v4, v7, v2, v12}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;->processData([BIIZ)Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v10

    goto :goto_2

    .line 64
    :catch_1
    move-exception v1

    .line 65
    .local v1, "e2":Ljava/lang/Exception;
    goto :goto_2
.end method

.method protected onCancelled()V
    .locals 1

    .prologue
    .line 35
    invoke-super {p0}, Landroid/os/AsyncTask;->onCancelled()V

    .line 36
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->mDelegate:Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask$Delegate;

    .line 37
    return-void
.end method

.method public perform()Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;
    .locals 3

    .prologue
    const/4 v2, 0x0

    .line 19
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xb

    if-lt v0, v1, :cond_0

    .line 20
    sget-object v0, Landroid/os/AsyncTask;->THREAD_POOL_EXECUTOR:Ljava/util/concurrent/Executor;

    new-array v1, v2, [Ljava/lang/Void;

    invoke-virtual {p0, v0, v1}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->executeOnExecutor(Ljava/util/concurrent/Executor;[Ljava/lang/Object;)Landroid/os/AsyncTask;

    .line 24
    :goto_0
    return-object p0

    .line 22
    :cond_0
    new-array v0, v2, [Ljava/lang/Void;

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/ProcessDataTask;->execute([Ljava/lang/Object;)Landroid/os/AsyncTask;

    goto :goto_0
.end method
