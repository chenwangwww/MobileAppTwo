.class public Lnet/sourceforge/zbar/Image;
.super Ljava/lang/Object;
.source "Image.java"


# instance fields
.field private data:Ljava/lang/Object;

.field private peer:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 39
    const-string v0, "zbarjni"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 40
    invoke-static {}, Lnet/sourceforge/zbar/Image;->init()V

    .line 41
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .prologue
    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    invoke-direct {p0}, Lnet/sourceforge/zbar/Image;->create()J

    move-result-wide v0

    iput-wide v0, p0, Lnet/sourceforge/zbar/Image;->peer:J

    .line 47
    return-void
.end method

.method public constructor <init>(II)V
    .locals 0
    .param p1, "width"    # I
    .param p2, "height"    # I

    .prologue
    .line 51
    invoke-direct {p0}, Lnet/sourceforge/zbar/Image;-><init>()V

    .line 52
    invoke-virtual {p0, p1, p2}, Lnet/sourceforge/zbar/Image;->setSize(II)V

    .line 53
    return-void
.end method

.method public constructor <init>(IILjava/lang/String;)V
    .locals 0
    .param p1, "width"    # I
    .param p2, "height"    # I
    .param p3, "format"    # Ljava/lang/String;

    .prologue
    .line 57
    invoke-direct {p0}, Lnet/sourceforge/zbar/Image;-><init>()V

    .line 58
    invoke-virtual {p0, p1, p2}, Lnet/sourceforge/zbar/Image;->setSize(II)V

    .line 59
    invoke-virtual {p0, p3}, Lnet/sourceforge/zbar/Image;->setFormat(Ljava/lang/String;)V

    .line 60
    return-void
.end method

.method constructor <init>(J)V
    .locals 1
    .param p1, "peer"    # J

    .prologue
    .line 69
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 70
    iput-wide p1, p0, Lnet/sourceforge/zbar/Image;->peer:J

    .line 71
    return-void
.end method

.method public constructor <init>(Ljava/lang/String;)V
    .locals 0
    .param p1, "format"    # Ljava/lang/String;

    .prologue
    .line 64
    invoke-direct {p0}, Lnet/sourceforge/zbar/Image;-><init>()V

    .line 65
    invoke-virtual {p0, p1}, Lnet/sourceforge/zbar/Image;->setFormat(Ljava/lang/String;)V

    .line 66
    return-void
.end method

.method private native convert(JLjava/lang/String;)J
.end method

.method private native create()J
.end method

.method private native destroy(J)V
.end method

.method private native getSymbols(J)J
.end method

.method private static native init()V
.end method


# virtual methods
.method public convert(Ljava/lang/String;)Lnet/sourceforge/zbar/Image;
    .locals 4
    .param p1, "format"    # Ljava/lang/String;

    .prologue
    .line 100
    iget-wide v2, p0, Lnet/sourceforge/zbar/Image;->peer:J

    invoke-direct {p0, v2, v3, p1}, Lnet/sourceforge/zbar/Image;->convert(JLjava/lang/String;)J

    move-result-wide v0

    .line 101
    .local v0, "newpeer":J
    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-nez v2, :cond_0

    .line 102
    const/4 v2, 0x0

    .line 103
    :goto_0
    return-object v2

    :cond_0
    new-instance v2, Lnet/sourceforge/zbar/Image;

    invoke-direct {v2, v0, v1}, Lnet/sourceforge/zbar/Image;-><init>(J)V

    goto :goto_0
.end method

.method public declared-synchronized destroy()V
    .locals 4

    .prologue
    const-wide/16 v2, 0x0

    .line 84
    monitor-enter p0

    :try_start_0
    iget-wide v0, p0, Lnet/sourceforge/zbar/Image;->peer:J

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    .line 85
    iget-wide v0, p0, Lnet/sourceforge/zbar/Image;->peer:J

    invoke-direct {p0, v0, v1}, Lnet/sourceforge/zbar/Image;->destroy(J)V

    .line 86
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lnet/sourceforge/zbar/Image;->peer:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 88
    :cond_0
    monitor-exit p0

    return-void

    .line 84
    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method protected finalize()V
    .locals 0

    .prologue
    .line 78
    invoke-virtual {p0}, Lnet/sourceforge/zbar/Image;->destroy()V

    .line 79
    return-void
.end method

.method public native getCrop()[I
.end method

.method public native getData()[B
.end method

.method public native getFormat()Ljava/lang/String;
.end method

.method public native getHeight()I
.end method

.method public native getSequence()I
.end method

.method public native getSize()[I
.end method

.method public getSymbols()Lnet/sourceforge/zbar/SymbolSet;
    .locals 4

    .prologue
    .line 158
    new-instance v0, Lnet/sourceforge/zbar/SymbolSet;

    iget-wide v2, p0, Lnet/sourceforge/zbar/Image;->peer:J

    invoke-direct {p0, v2, v3}, Lnet/sourceforge/zbar/Image;->getSymbols(J)J

    move-result-wide v2

    invoke-direct {v0, v2, v3}, Lnet/sourceforge/zbar/SymbolSet;-><init>(J)V

    return-object v0
.end method

.method public native getWidth()I
.end method

.method public native setCrop(IIII)V
.end method

.method public native setCrop([I)V
.end method

.method public native setData([B)V
.end method

.method public native setData([I)V
.end method

.method public native setFormat(Ljava/lang/String;)V
.end method

.method public native setSequence(I)V
.end method

.method public native setSize(II)V
.end method

.method public native setSize([I)V
.end method
