.class public Lcom/qianniao/zbarscanner/zbar/ZBarView;
.super Lcom/qianniao/zbarscanner/qrcode/QRCodeView;
.source "ZBarView.java"


# instance fields
.field private mScanner:Lnet/sourceforge/zbar/ImageScanner;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attributeSet"    # Landroid/util/AttributeSet;

    .prologue
    .line 22
    const/4 v0, 0x0

    invoke-direct {p0, p1, p2, v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 23
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;
    .param p3, "defStyleAttr"    # I

    .prologue
    .line 26
    invoke-direct {p0, p1, p2, p3}, Lcom/qianniao/zbarscanner/qrcode/QRCodeView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 27
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->setupScanner()V

    .line 28
    return-void
.end method

.method private processData(Lnet/sourceforge/zbar/Image;)Ljava/lang/String;
    .locals 6
    .param p1, "barcode"    # Lnet/sourceforge/zbar/Image;

    .prologue
    .line 59
    const/4 v0, 0x0

    .line 60
    .local v0, "result":Ljava/lang/String;
    iget-object v4, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    invoke-virtual {v4, p1}, Lnet/sourceforge/zbar/ImageScanner;->scanImage(Lnet/sourceforge/zbar/Image;)I

    move-result v4

    if-eqz v4, :cond_1

    .line 61
    iget-object v4, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    invoke-virtual {v4}, Lnet/sourceforge/zbar/ImageScanner;->getResults()Lnet/sourceforge/zbar/SymbolSet;

    move-result-object v3

    .line 62
    .local v3, "syms":Lnet/sourceforge/zbar/SymbolSet;
    invoke-virtual {v3}, Lnet/sourceforge/zbar/SymbolSet;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lnet/sourceforge/zbar/Symbol;

    .line 63
    .local v1, "sym":Lnet/sourceforge/zbar/Symbol;
    invoke-virtual {v1}, Lnet/sourceforge/zbar/Symbol;->getData()Ljava/lang/String;

    move-result-object v2

    .line 64
    .local v2, "symData":Ljava/lang/String;
    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_0

    .line 65
    move-object v0, v2

    .line 70
    .end local v1    # "sym":Lnet/sourceforge/zbar/Symbol;
    .end local v2    # "symData":Ljava/lang/String;
    .end local v3    # "syms":Lnet/sourceforge/zbar/SymbolSet;
    :cond_1
    return-object v0
.end method


# virtual methods
.method public processData([BIIZ)Ljava/lang/String;
    .locals 7
    .param p1, "data"    # [B
    .param p2, "width"    # I
    .param p3, "height"    # I
    .param p4, "isRetry"    # Z

    .prologue
    .line 43
    const/4 v2, 0x0

    .line 44
    .local v2, "result":Ljava/lang/String;
    new-instance v0, Lnet/sourceforge/zbar/Image;

    const-string v3, "Y800"

    invoke-direct {v0, p2, p3, v3}, Lnet/sourceforge/zbar/Image;-><init>(IILjava/lang/String;)V

    .line 46
    .local v0, "barcode":Lnet/sourceforge/zbar/Image;
    iget-object v3, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanBoxView:Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;

    invoke-virtual {v3, p3}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getScanBoxAreaRect(I)Landroid/graphics/Rect;

    move-result-object v1

    .line 47
    .local v1, "rect":Landroid/graphics/Rect;
    if-eqz v1, :cond_0

    if-nez p4, :cond_0

    iget v3, v1, Landroid/graphics/Rect;->left:I

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v4

    add-int/2addr v3, v4

    if-gt v3, p2, :cond_0

    iget v3, v1, Landroid/graphics/Rect;->top:I

    invoke-virtual {v1}, Landroid/graphics/Rect;->height()I

    move-result v4

    add-int/2addr v3, v4

    if-gt v3, p3, :cond_0

    .line 48
    iget v3, v1, Landroid/graphics/Rect;->left:I

    iget v4, v1, Landroid/graphics/Rect;->top:I

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v5

    invoke-virtual {v1}, Landroid/graphics/Rect;->height()I

    move-result v6

    invoke-virtual {v0, v3, v4, v5, v6}, Lnet/sourceforge/zbar/Image;->setCrop(IIII)V

    .line 52
    :cond_0
    invoke-virtual {v0, p1}, Lnet/sourceforge/zbar/Image;->setData([B)V

    .line 53
    invoke-direct {p0, v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->processData(Lnet/sourceforge/zbar/Image;)Ljava/lang/String;

    move-result-object v2

    .line 55
    return-object v2
.end method

.method public setupScanner()V
    .locals 6

    .prologue
    const/4 v3, 0x3

    const/4 v5, 0x0

    .line 31
    new-instance v1, Lnet/sourceforge/zbar/ImageScanner;

    invoke-direct {v1}, Lnet/sourceforge/zbar/ImageScanner;-><init>()V

    iput-object v1, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    .line 32
    iget-object v1, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    const/16 v2, 0x100

    invoke-virtual {v1, v5, v2, v3}, Lnet/sourceforge/zbar/ImageScanner;->setConfig(III)V

    .line 33
    iget-object v1, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    const/16 v2, 0x101

    invoke-virtual {v1, v5, v2, v3}, Lnet/sourceforge/zbar/ImageScanner;->setConfig(III)V

    .line 35
    iget-object v1, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    invoke-virtual {v1, v5, v5, v5}, Lnet/sourceforge/zbar/ImageScanner;->setConfig(III)V

    .line 36
    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 37
    .local v0, "format":Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
    iget-object v2, p0, Lcom/qianniao/zbarscanner/zbar/ZBarView;->mScanner:Lnet/sourceforge/zbar/ImageScanner;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->getId()I

    move-result v3

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v5, v4}, Lnet/sourceforge/zbar/ImageScanner;->setConfig(III)V

    goto :goto_0

    .line 39
    .end local v0    # "format":Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
    :cond_0
    return-void
.end method
