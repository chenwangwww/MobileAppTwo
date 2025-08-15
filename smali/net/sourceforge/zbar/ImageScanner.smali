.class public Lnet/sourceforge/zbar/ImageScanner;
.super Ljava/lang/Object;
.source "ImageScanner.java"


# instance fields
.field private peer:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 37
    const-string v0, "zbarjni"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 38
    invoke-static {}, Lnet/sourceforge/zbar/ImageScanner;->init()V

    .line 39
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .prologue
    .line 43
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 44
    invoke-direct {p0}, Lnet/sourceforge/zbar/ImageScanner;->create()J

    move-result-wide v0

    iput-wide v0, p0, Lnet/sourceforge/zbar/ImageScanner;->peer:J

    .line 45
    return-void
.end method

.method private native create()J
.end method

.method private native destroy(J)V
.end method

.method private native getResults(J)J
.end method

.method private static native init()V
.end method


# virtual methods
.method public declared-synchronized destroy()V
    .locals 4

    .prologue
    const-wide/16 v2, 0x0

    .line 58
    monitor-enter p0

    :try_start_0
    iget-wide v0, p0, Lnet/sourceforge/zbar/ImageScanner;->peer:J

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    .line 59
    iget-wide v0, p0, Lnet/sourceforge/zbar/ImageScanner;->peer:J

    invoke-direct {p0, v0, v1}, Lnet/sourceforge/zbar/ImageScanner;->destroy(J)V

    .line 60
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lnet/sourceforge/zbar/ImageScanner;->peer:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 62
    :cond_0
    monitor-exit p0

    return-void

    .line 58
    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method public native enableCache(Z)V
.end method

.method protected finalize()V
    .locals 0

    .prologue
    .line 52
    invoke-virtual {p0}, Lnet/sourceforge/zbar/ImageScanner;->destroy()V

    .line 53
    return-void
.end method

.method public getResults()Lnet/sourceforge/zbar/SymbolSet;
    .locals 4

    .prologue
    .line 88
    new-instance v0, Lnet/sourceforge/zbar/SymbolSet;

    iget-wide v2, p0, Lnet/sourceforge/zbar/ImageScanner;->peer:J

    invoke-direct {p0, v2, v3}, Lnet/sourceforge/zbar/ImageScanner;->getResults(J)J

    move-result-wide v2

    invoke-direct {v0, v2, v3}, Lnet/sourceforge/zbar/SymbolSet;-><init>(J)V

    return-object v0
.end method

.method public native parseConfig(Ljava/lang/String;)V
.end method

.method public native scanImage(Lnet/sourceforge/zbar/Image;)I
.end method

.method public native setConfig(III)V
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/IllegalArgumentException;
        }
    .end annotation
.end method
