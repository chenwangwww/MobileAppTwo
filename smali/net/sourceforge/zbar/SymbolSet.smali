.class public Lnet/sourceforge/zbar/SymbolSet;
.super Ljava/util/AbstractCollection;
.source "SymbolSet.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/util/AbstractCollection",
        "<",
        "Lnet/sourceforge/zbar/Symbol;",
        ">;"
    }
.end annotation


# instance fields
.field private peer:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 39
    const-string v0, "zbarjni"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 40
    invoke-static {}, Lnet/sourceforge/zbar/SymbolSet;->init()V

    .line 41
    return-void
.end method

.method constructor <init>(J)V
    .locals 1
    .param p1, "peer"    # J

    .prologue
    .line 46
    invoke-direct {p0}, Ljava/util/AbstractCollection;-><init>()V

    .line 47
    iput-wide p1, p0, Lnet/sourceforge/zbar/SymbolSet;->peer:J

    .line 48
    return-void
.end method

.method private native destroy(J)V
.end method

.method private native firstSymbol(J)J
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
    iget-wide v0, p0, Lnet/sourceforge/zbar/SymbolSet;->peer:J

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    .line 59
    iget-wide v0, p0, Lnet/sourceforge/zbar/SymbolSet;->peer:J

    invoke-direct {p0, v0, v1}, Lnet/sourceforge/zbar/SymbolSet;->destroy(J)V

    .line 60
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lnet/sourceforge/zbar/SymbolSet;->peer:J
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

.method protected finalize()V
    .locals 0

    .prologue
    .line 52
    invoke-virtual {p0}, Lnet/sourceforge/zbar/SymbolSet;->destroy()V

    .line 53
    return-void
.end method

.method public iterator()Ljava/util/Iterator;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Iterator",
            "<",
            "Lnet/sourceforge/zbar/Symbol;",
            ">;"
        }
    .end annotation

    .prologue
    .line 70
    iget-wide v2, p0, Lnet/sourceforge/zbar/SymbolSet;->peer:J

    invoke-direct {p0, v2, v3}, Lnet/sourceforge/zbar/SymbolSet;->firstSymbol(J)J

    move-result-wide v0

    .line 71
    .local v0, "sym":J
    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-nez v2, :cond_0

    .line 72
    new-instance v2, Lnet/sourceforge/zbar/SymbolIterator;

    const/4 v3, 0x0

    invoke-direct {v2, v3}, Lnet/sourceforge/zbar/SymbolIterator;-><init>(Lnet/sourceforge/zbar/Symbol;)V

    .line 74
    :goto_0
    return-object v2

    :cond_0
    new-instance v2, Lnet/sourceforge/zbar/SymbolIterator;

    new-instance v3, Lnet/sourceforge/zbar/Symbol;

    invoke-direct {v3, v0, v1}, Lnet/sourceforge/zbar/Symbol;-><init>(J)V

    invoke-direct {v2, v3}, Lnet/sourceforge/zbar/SymbolIterator;-><init>(Lnet/sourceforge/zbar/Symbol;)V

    goto :goto_0
.end method

.method public native size()I
.end method
