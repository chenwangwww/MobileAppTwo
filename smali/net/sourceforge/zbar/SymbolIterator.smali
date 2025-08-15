.class public Lnet/sourceforge/zbar/SymbolIterator;
.super Ljava/lang/Object;
.source "SymbolIterator.java"

# interfaces
.implements Ljava/util/Iterator;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Iterator",
        "<",
        "Lnet/sourceforge/zbar/Symbol;",
        ">;"
    }
.end annotation


# instance fields
.field private current:Lnet/sourceforge/zbar/Symbol;


# direct methods
.method constructor <init>(Lnet/sourceforge/zbar/Symbol;)V
    .locals 0
    .param p1, "first"    # Lnet/sourceforge/zbar/Symbol;

    .prologue
    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 39
    iput-object p1, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    .line 40
    return-void
.end method


# virtual methods
.method public hasNext()Z
    .locals 1

    .prologue
    .line 45
    iget-object v0, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public bridge synthetic next()Ljava/lang/Object;
    .locals 1

    .prologue
    .line 30
    invoke-virtual {p0}, Lnet/sourceforge/zbar/SymbolIterator;->next()Lnet/sourceforge/zbar/Symbol;

    move-result-object v0

    return-object v0
.end method

.method public next()Lnet/sourceforge/zbar/Symbol;
    .locals 6

    .prologue
    .line 51
    iget-object v1, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    if-nez v1, :cond_0

    .line 52
    new-instance v1, Ljava/util/NoSuchElementException;

    const-string v4, "access past end of SymbolIterator"

    invoke-direct {v1, v4}, Ljava/util/NoSuchElementException;-><init>(Ljava/lang/String;)V

    throw v1

    .line 55
    :cond_0
    iget-object v0, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    .line 56
    .local v0, "result":Lnet/sourceforge/zbar/Symbol;
    iget-object v1, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    invoke-virtual {v1}, Lnet/sourceforge/zbar/Symbol;->next()J

    move-result-wide v2

    .line 57
    .local v2, "sym":J
    const-wide/16 v4, 0x0

    cmp-long v1, v2, v4

    if-eqz v1, :cond_1

    .line 58
    new-instance v1, Lnet/sourceforge/zbar/Symbol;

    invoke-direct {v1, v2, v3}, Lnet/sourceforge/zbar/Symbol;-><init>(J)V

    iput-object v1, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    .line 61
    :goto_0
    return-object v0

    .line 60
    :cond_1
    const/4 v1, 0x0

    iput-object v1, p0, Lnet/sourceforge/zbar/SymbolIterator;->current:Lnet/sourceforge/zbar/Symbol;

    goto :goto_0
.end method

.method public remove()V
    .locals 2

    .prologue
    .line 67
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    const-string v1, "SymbolIterator is immutable"

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0
.end method
