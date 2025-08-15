.class public Lnet/sourceforge/zbar/Symbol;
.super Ljava/lang/Object;
.source "Symbol.java"


# static fields
.field public static final CODABAR:I = 0x26

.field public static final CODE128:I = 0x80

.field public static final CODE39:I = 0x27

.field public static final CODE93:I = 0x5d

.field public static final DATABAR:I = 0x22

.field public static final DATABAR_EXP:I = 0x23

.field public static final EAN13:I = 0xd

.field public static final EAN8:I = 0x8

.field public static final I25:I = 0x19

.field public static final ISBN10:I = 0xa

.field public static final ISBN13:I = 0xe

.field public static final NONE:I = 0x0

.field public static final PARTIAL:I = 0x1

.field public static final PDF417:I = 0x39

.field public static final QRCODE:I = 0x40

.field public static final UPCA:I = 0xc

.field public static final UPCE:I = 0x9


# instance fields
.field private peer:J

.field private type:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 77
    const-string v0, "zbarjni"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 78
    invoke-static {}, Lnet/sourceforge/zbar/Symbol;->init()V

    .line 79
    return-void
.end method

.method constructor <init>(J)V
    .locals 1
    .param p1, "peer"    # J

    .prologue
    .line 84
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 85
    iput-wide p1, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    .line 86
    return-void
.end method

.method private native destroy(J)V
.end method

.method private native getComponents(J)J
.end method

.method private native getLocationSize(J)I
.end method

.method private native getLocationX(JI)I
.end method

.method private native getLocationY(JI)I
.end method

.method private native getType(J)I
.end method

.method private static native init()V
.end method


# virtual methods
.method public declared-synchronized destroy()V
    .locals 4

    .prologue
    const-wide/16 v2, 0x0

    .line 96
    monitor-enter p0

    :try_start_0
    iget-wide v0, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    cmp-long v0, v0, v2

    if-eqz v0, :cond_0

    .line 97
    iget-wide v0, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v0, v1}, Lnet/sourceforge/zbar/Symbol;->destroy(J)V

    .line 98
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lnet/sourceforge/zbar/Symbol;->peer:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 100
    :cond_0
    monitor-exit p0

    return-void

    .line 96
    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method

.method protected finalize()V
    .locals 0

    .prologue
    .line 90
    invoke-virtual {p0}, Lnet/sourceforge/zbar/Symbol;->destroy()V

    .line 91
    return-void
.end method

.method public getBounds()[I
    .locals 12

    .prologue
    .line 147
    iget-wide v10, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v10, v11}, Lnet/sourceforge/zbar/Symbol;->getLocationSize(J)I

    move-result v2

    .line 148
    .local v2, "n":I
    if-gtz v2, :cond_0

    .line 149
    const/4 v0, 0x0

    .line 170
    :goto_0
    return-object v0

    .line 151
    :cond_0
    const/4 v9, 0x4

    new-array v0, v9, [I

    .line 152
    .local v0, "bounds":[I
    const v5, 0x7fffffff

    .line 153
    .local v5, "xmin":I
    const/high16 v4, -0x80000000

    .line 154
    .local v4, "xmax":I
    const v8, 0x7fffffff

    .line 155
    .local v8, "ymin":I
    const/high16 v7, -0x80000000

    .line 157
    .local v7, "ymax":I
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_1
    if-ge v1, v2, :cond_5

    .line 158
    iget-wide v10, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v10, v11, v1}, Lnet/sourceforge/zbar/Symbol;->getLocationX(JI)I

    move-result v3

    .line 159
    .local v3, "x":I
    if-le v5, v3, :cond_1

    move v5, v3

    .line 160
    :cond_1
    if-ge v4, v3, :cond_2

    move v4, v3

    .line 162
    :cond_2
    iget-wide v10, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v10, v11, v1}, Lnet/sourceforge/zbar/Symbol;->getLocationY(JI)I

    move-result v6

    .line 163
    .local v6, "y":I
    if-le v8, v6, :cond_3

    move v8, v6

    .line 164
    :cond_3
    if-ge v7, v6, :cond_4

    move v7, v6

    .line 157
    :cond_4
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 166
    .end local v3    # "x":I
    .end local v6    # "y":I
    :cond_5
    const/4 v9, 0x0

    aput v5, v0, v9

    .line 167
    const/4 v9, 0x1

    aput v8, v0, v9

    .line 168
    const/4 v9, 0x2

    sub-int v10, v4, v5

    aput v10, v0, v9

    .line 169
    const/4 v9, 0x3

    sub-int v10, v7, v8

    aput v10, v0, v9

    goto :goto_0
.end method

.method public getComponents()Lnet/sourceforge/zbar/SymbolSet;
    .locals 4

    .prologue
    .line 193
    new-instance v0, Lnet/sourceforge/zbar/SymbolSet;

    iget-wide v2, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v2, v3}, Lnet/sourceforge/zbar/Symbol;->getComponents(J)J

    move-result-wide v2

    invoke-direct {v0, v2, v3}, Lnet/sourceforge/zbar/SymbolSet;-><init>(J)V

    return-object v0
.end method

.method public native getConfigMask()I
.end method

.method public native getCount()I
.end method

.method public native getData()Ljava/lang/String;
.end method

.method public native getDataBytes()[B
.end method

.method public getLocationPoint(I)[I
    .locals 4
    .param p1, "idx"    # I

    .prologue
    .line 179
    const/4 v1, 0x2

    new-array v0, v1, [I

    .line 180
    .local v0, "p":[I
    const/4 v1, 0x0

    iget-wide v2, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v2, v3, p1}, Lnet/sourceforge/zbar/Symbol;->getLocationX(JI)I

    move-result v2

    aput v2, v0, v1

    .line 181
    const/4 v1, 0x1

    iget-wide v2, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v2, v3, p1}, Lnet/sourceforge/zbar/Symbol;->getLocationY(JI)I

    move-result v2

    aput v2, v0, v1

    .line 182
    return-object v0
.end method

.method public native getModifierMask()I
.end method

.method public native getOrientation()I
.end method

.method public native getQuality()I
.end method

.method public getType()I
    .locals 2

    .prologue
    .line 108
    iget v0, p0, Lnet/sourceforge/zbar/Symbol;->type:I

    if-nez v0, :cond_0

    .line 109
    iget-wide v0, p0, Lnet/sourceforge/zbar/Symbol;->peer:J

    invoke-direct {p0, v0, v1}, Lnet/sourceforge/zbar/Symbol;->getType(J)I

    move-result v0

    iput v0, p0, Lnet/sourceforge/zbar/Symbol;->type:I

    .line 110
    :cond_0
    iget v0, p0, Lnet/sourceforge/zbar/Symbol;->type:I

    return v0
.end method

.method native next()J
.end method
