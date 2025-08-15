.class public Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;
.super Landroid/view/View;
.source "ScanBoxView.java"


# instance fields
.field private mAnimDelayTime:I

.field private mAnimTime:I

.field private mBarCodeTipText:Ljava/lang/String;

.field private mBarcodeRectHeight:I

.field private mBorderColor:I

.field private mBorderSize:I

.field private mCornerColor:I

.field private mCornerLength:I

.field private mCornerSize:I

.field private mCustomGridScanLineDrawable:Landroid/graphics/drawable/Drawable;

.field private mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

.field private mFramingRect:Landroid/graphics/Rect;

.field private mGridScanLineBitmap:Landroid/graphics/Bitmap;

.field private mGridScanLineBottom:F

.field private mGridScanLineRight:F

.field private mHalfCornerSize:F

.field private mIsBarcode:Z

.field private mIsCenterVertical:Z

.field private mIsOnlyDecodeScanBoxArea:Z

.field private mIsScanLineReverse:Z

.field private mIsShowDefaultGridScanLineDrawable:Z

.field private mIsShowDefaultScanLineDrawable:Z

.field private mIsShowTipBackground:Z

.field private mIsShowTipTextAsSingleLine:Z

.field private mIsTipTextBelowRect:Z

.field private mMaskColor:I

.field private mMoveStepDistance:I

.field private mOriginBarCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

.field private mOriginBarCodeScanLineBitmap:Landroid/graphics/Bitmap;

.field private mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

.field private mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

.field private mPaint:Landroid/graphics/Paint;

.field private mQRCodeTipText:Ljava/lang/String;

.field private mRectHeight:I

.field private mRectWidth:I

.field private mScanLineBitmap:Landroid/graphics/Bitmap;

.field private mScanLineColor:I

.field private mScanLineLeft:F

.field private mScanLineMargin:I

.field private mScanLineSize:I

.field private mScanLineTop:F

.field private mTipBackgroundColor:I

.field private mTipBackgroundRadius:I

.field private mTipPaint:Landroid/text/TextPaint;

.field private mTipText:Ljava/lang/String;

.field private mTipTextColor:I

.field private mTipTextMargin:I

.field private mTipTextSize:I

.field private mTipTextSl:Landroid/text/StaticLayout;

.field private mToolbarHeight:I

.field private mTopOffset:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 7
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/high16 v6, 0x41a00000    # 20.0f

    const/high16 v5, 0x3f800000    # 1.0f

    const/4 v4, 0x0

    const/4 v3, -0x1

    const/4 v2, 0x0

    .line 85
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 86
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0}, Landroid/graphics/Paint;-><init>()V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    .line 87
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setAntiAlias(Z)V

    .line 88
    const-string v0, "#33FFFFFF"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMaskColor:I

    .line 89
    iput v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerColor:I

    .line 90
    invoke-static {p1, v6}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    .line 91
    const/high16 v0, 0x40400000    # 3.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerSize:I

    .line 92
    invoke-static {p1, v5}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    .line 93
    iput v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    .line 94
    const/high16 v0, 0x42b40000    # 90.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    .line 95
    const/high16 v0, 0x43480000    # 200.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    .line 96
    const/high16 v0, 0x430c0000    # 140.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarcodeRectHeight:I

    .line 97
    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    .line 98
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultScanLineDrawable:Z

    .line 99
    iput-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

    .line 100
    iput-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    .line 101
    invoke-static {p1, v5}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderSize:I

    .line 102
    iput v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderColor:I

    .line 103
    const/16 v0, 0x3e8

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimTime:I

    .line 104
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsCenterVertical:Z

    .line 105
    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    .line 106
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    .line 107
    const/high16 v0, 0x40000000    # 2.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    .line 108
    iput-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    .line 109
    const/high16 v0, 0x41600000    # 14.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->sp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSize:I

    .line 110
    iput v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextColor:I

    .line 111
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsTipTextBelowRect:Z

    .line 112
    invoke-static {p1, v6}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    .line 113
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    .line 114
    const-string v0, "#22000000"

    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundColor:I

    .line 115
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipBackground:Z

    .line 116
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsScanLineReverse:Z

    .line 117
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultGridScanLineDrawable:Z

    .line 119
    new-instance v0, Landroid/text/TextPaint;

    invoke-direct {v0}, Landroid/text/TextPaint;-><init>()V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    .line 120
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/text/TextPaint;->setAntiAlias(Z)V

    .line 122
    const/high16 v0, 0x40800000    # 4.0f

    invoke-static {p1, v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->dp2px(Landroid/content/Context;F)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    .line 124
    iput-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsOnlyDecodeScanBoxArea:Z

    .line 125
    return-void
.end method

.method private afterInitCustomAttrs()V
    .locals 3

    .prologue
    const/16 v2, 0x5a

    .line 205
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomGridScanLineDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    .line 206
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomGridScanLineDrawable:Landroid/graphics/drawable/Drawable;

    check-cast v0, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    .line 208
    :cond_0
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    if-nez v0, :cond_1

    .line 209
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030001

    invoke-static {v0, v1}, Landroid/graphics/BitmapFactory;->decodeResource(Landroid/content/res/Resources;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    .line 210
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    invoke-static {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->makeTintBitmap(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    .line 212
    :cond_1
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-static {v0, v2}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->adjustPhotoRotation(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginBarCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    .line 214
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_2

    .line 215
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

    check-cast v0, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {v0}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    .line 217
    :cond_2
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    if-nez v0, :cond_3

    .line 218
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const v1, 0x7f030002

    invoke-static {v0, v1}, Landroid/graphics/BitmapFactory;->decodeResource(Landroid/content/res/Resources;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    .line 219
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    invoke-static {v0, v1}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->makeTintBitmap(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    .line 221
    :cond_3
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-static {v0, v2}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->adjustPhotoRotation(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginBarCodeScanLineBitmap:Landroid/graphics/Bitmap;

    .line 223
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    add-int/2addr v0, v1

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    .line 224
    const/high16 v0, 0x3f800000    # 1.0f

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerSize:I

    int-to-float v1, v1

    mul-float/2addr v0, v1

    const/high16 v1, 0x40000000    # 2.0f

    div-float/2addr v0, v1

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    .line 226
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSize:I

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 227
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextColor:I

    invoke-virtual {v0, v1}, Landroid/text/TextPaint;->setColor(I)V

    .line 229
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->setIsBarcode(Z)V

    .line 230
    return-void
.end method

.method private calFramingRect()V
    .locals 8

    .prologue
    const/high16 v7, 0x3f000000    # 0.5f

    .line 486
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->getScreenResolution(Landroid/content/Context;)Landroid/graphics/Point;

    move-result-object v1

    .line 487
    .local v1, "screenResolution":Landroid/graphics/Point;
    iget v2, v1, Landroid/graphics/Point;->x:I

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    sub-int/2addr v2, v3

    div-int/lit8 v0, v2, 0x2

    .line 488
    .local v0, "leftOffset":I
    new-instance v2, Landroid/graphics/Rect;

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    add-int/2addr v4, v0

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    iget v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    add-int/2addr v5, v6

    invoke-direct {v2, v0, v3, v4, v5}, Landroid/graphics/Rect;-><init>(IIII)V

    iput-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    .line 490
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v2, :cond_0

    .line 491
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->left:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v3

    add-float/2addr v2, v7

    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    .line 495
    :goto_0
    return-void

    .line 493
    :cond_0
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->top:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v3

    add-float/2addr v2, v7

    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iput v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    goto :goto_0
.end method

.method private drawBorderLine(Landroid/graphics/Canvas;)V
    .locals 2
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    .line 283
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderSize:I

    if-lez v0, :cond_0

    .line 284
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 285
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderColor:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 286
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderSize:I

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 287
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/Rect;Landroid/graphics/Paint;)V

    .line 289
    :cond_0
    return-void
.end method

.method private drawCornerLine(Landroid/graphics/Canvas;)V
    .locals 6
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    .line 297
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    const/4 v1, 0x0

    cmpl-float v0, v0, v1

    if-lez v0, :cond_0

    .line 298
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 299
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerColor:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 300
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerSize:I

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 301
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float v1, v0, v1

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v3, v3

    add-float/2addr v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 302
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float v2, v0, v2

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v4, v4

    add-float/2addr v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 303
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v3, v3

    sub-float v3, v0, v3

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 304
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float v2, v0, v2

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v4, v4

    add-float/2addr v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 306
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float v1, v0, v1

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v3, v3

    add-float/2addr v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 307
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v4, v4

    sub-float v4, v0, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 308
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v3, v3

    sub-float v3, v0, v3

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 309
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v1, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    int-to-float v4, v4

    sub-float v4, v0, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 311
    :cond_0
    return-void
.end method

.method private drawMask(Landroid/graphics/Canvas;)V
    .locals 10
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    const/4 v1, 0x0

    .line 264
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v9

    .line 265
    .local v9, "width":I
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v8

    .line 267
    .local v8, "height":I
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMaskColor:I

    if-eqz v0, :cond_0

    .line 268
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v2, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 269
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMaskColor:I

    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 270
    int-to-float v3, v9

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    move v2, v1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 271
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v2, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    add-int/lit8 v0, v0, 0x1

    int-to-float v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 272
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    add-int/lit8 v0, v0, 0x1

    int-to-float v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v4, v0

    int-to-float v5, v9

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    add-int/lit8 v0, v0, 0x1

    int-to-float v6, v0

    iget-object v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v2, p1

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 273
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    add-int/lit8 v0, v0, 0x1

    int-to-float v2, v0

    int-to-float v3, v9

    int-to-float v4, v8

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 275
    :cond_0
    return-void
.end method

.method private drawScanLine(Landroid/graphics/Canvas;)V
    .locals 11
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    const/4 v10, 0x0

    const/high16 v3, 0x3f000000    # 0.5f

    const/4 v5, 0x0

    .line 319
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v0, :cond_3

    .line 320
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_1

    .line 321
    new-instance v6, Landroid/graphics/RectF;

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v1

    add-float/2addr v0, v3

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->bottom:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v3, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v4, v4

    sub-float/2addr v3, v4

    invoke-direct {v6, v0, v1, v2, v3}, Landroid/graphics/RectF;-><init>(FFFF)V

    .line 323
    .local v6, "dstGridRectF":Landroid/graphics/RectF;
    new-instance v8, Landroid/graphics/Rect;

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {v6}, Landroid/graphics/RectF;->width()F

    move-result v1

    sub-float/2addr v0, v1

    float-to-int v0, v0

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v1

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    invoke-direct {v8, v0, v5, v1, v2}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 325
    .local v8, "srcGridRect":Landroid/graphics/Rect;
    iget v0, v8, Landroid/graphics/Rect;->left:I

    if-gez v0, :cond_0

    .line 326
    iput v5, v8, Landroid/graphics/Rect;->left:I

    .line 327
    iget v0, v6, Landroid/graphics/RectF;->right:F

    invoke-virtual {v8}, Landroid/graphics/Rect;->width()I

    move-result v1

    int-to-float v1, v1

    sub-float/2addr v0, v1

    iput v0, v6, Landroid/graphics/RectF;->left:F

    .line 330
    :cond_0
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v8, v6, v1}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 360
    .end local v6    # "dstGridRectF":Landroid/graphics/RectF;
    .end local v8    # "srcGridRect":Landroid/graphics/Rect;
    :goto_0
    return-void

    .line 331
    :cond_1
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_2

    .line 332
    new-instance v7, Landroid/graphics/RectF;

    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    int-to-float v3, v3

    add-float/2addr v2, v3

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->bottom:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v3, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v4, v4

    sub-float/2addr v3, v4

    invoke-direct {v7, v0, v1, v2, v3}, Landroid/graphics/RectF;-><init>(FFFF)V

    .line 333
    .local v7, "lineRect":Landroid/graphics/RectF;
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v10, v7, v1}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    goto :goto_0

    .line 335
    .end local v7    # "lineRect":Landroid/graphics/RectF;
    :cond_2
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 336
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 337
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v2

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v2, v2

    add-float/2addr v2, v0

    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    int-to-float v3, v3

    add-float/2addr v3, v0

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v4, v4

    sub-float v4, v0, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    goto :goto_0

    .line 340
    :cond_3
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_5

    .line 341
    new-instance v6, Landroid/graphics/RectF;

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v1, v1

    add-float/2addr v0, v1

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    add-float/2addr v1, v3

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->right:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v3, v3

    sub-float/2addr v2, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    invoke-direct {v6, v0, v1, v2, v3}, Landroid/graphics/RectF;-><init>(FFFF)V

    .line 343
    .restart local v6    # "dstGridRectF":Landroid/graphics/RectF;
    new-instance v9, Landroid/graphics/Rect;

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v0

    int-to-float v0, v0

    invoke-virtual {v6}, Landroid/graphics/RectF;->height()F

    move-result v1

    sub-float/2addr v0, v1

    float-to-int v0, v0

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v1

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    invoke-direct {v9, v5, v0, v1, v2}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 345
    .local v9, "srcRect":Landroid/graphics/Rect;
    iget v0, v9, Landroid/graphics/Rect;->top:I

    if-gez v0, :cond_4

    .line 346
    iput v5, v9, Landroid/graphics/Rect;->top:I

    .line 347
    iget v0, v6, Landroid/graphics/RectF;->bottom:F

    invoke-virtual {v9}, Landroid/graphics/Rect;->height()I

    move-result v1

    int-to-float v1, v1

    sub-float/2addr v0, v1

    iput v0, v6, Landroid/graphics/RectF;->top:F

    .line 350
    :cond_4
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v9, v6, v1}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    goto/16 :goto_0

    .line 351
    .end local v6    # "dstGridRectF":Landroid/graphics/RectF;
    .end local v9    # "srcRect":Landroid/graphics/Rect;
    :cond_5
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v0, :cond_6

    .line 352
    new-instance v7, Landroid/graphics/RectF;

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v1, v1

    add-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->right:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v3, v3

    sub-float/2addr v2, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v4

    int-to-float v4, v4

    add-float/2addr v3, v4

    invoke-direct {v7, v0, v1, v2, v3}, Landroid/graphics/RectF;-><init>(FFFF)V

    .line 353
    .restart local v7    # "lineRect":Landroid/graphics/RectF;
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v10, v7, v1}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    goto/16 :goto_0

    .line 355
    .end local v7    # "lineRect":Landroid/graphics/RectF;
    :cond_6
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 356
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 357
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v1, v1

    add-float/2addr v1, v0

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v0, v0, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v0, v3

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    int-to-float v3, v3

    sub-float v3, v0, v3

    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    int-to-float v4, v4

    add-float/2addr v4, v0

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    move-object v0, p1

    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    goto/16 :goto_0
.end method

.method private drawTipText(Landroid/graphics/Canvas;)V
    .locals 9
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    const/4 v5, 0x0

    const/4 v8, 0x0

    .line 368
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_0

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    if-nez v2, :cond_1

    .line 418
    :cond_0
    :goto_0
    return-void

    .line 372
    :cond_1
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsTipTextBelowRect:Z

    if-eqz v2, :cond_5

    .line 373
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipBackground:Z

    if-eqz v2, :cond_2

    .line 374
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundColor:I

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 375
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 376
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    if-eqz v2, :cond_3

    .line 377
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    .line 378
    .local v1, "tipRect":Landroid/graphics/Rect;
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v2, v3, v5, v4, v1}, Landroid/text/TextPaint;->getTextBounds(Ljava/lang/String;IILandroid/graphics/Rect;)V

    .line 379
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v2

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v3

    sub-int/2addr v2, v3

    div-int/lit8 v2, v2, 0x2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v2, v3

    int-to-float v0, v2

    .line 380
    .local v0, "left":F
    new-instance v2, Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->bottom:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v3, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v3, v4

    int-to-float v3, v3

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v4

    int-to-float v4, v4

    add-float/2addr v4, v0

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    mul-int/lit8 v5, v5, 0x2

    int-to-float v5, v5

    add-float/2addr v4, v5

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->bottom:I

    iget v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v5, v6

    iget-object v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v6}, Landroid/text/StaticLayout;->getHeight()I

    move-result v6

    add-int/2addr v5, v6

    iget v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v5, v6

    int-to-float v5, v5

    invoke-direct {v2, v0, v3, v4, v5}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    .line 386
    .end local v0    # "left":F
    .end local v1    # "tipRect":Landroid/graphics/Rect;
    :cond_2
    :goto_1
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    .line 387
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    if-eqz v2, :cond_4

    .line 388
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->bottom:I

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v2, v3

    int-to-float v2, v2

    invoke-virtual {p1, v8, v2}, Landroid/graphics/Canvas;->translate(FF)V

    .line 392
    :goto_2
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v2, p1}, Landroid/text/StaticLayout;->draw(Landroid/graphics/Canvas;)V

    .line 393
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V

    goto/16 :goto_0

    .line 382
    :cond_3
    new-instance v2, Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->left:I

    int-to-float v3, v3

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v4, v4, Landroid/graphics/Rect;->bottom:I

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v4, v5

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v4, v5

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->right:I

    int-to-float v5, v5

    iget-object v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v6, v6, Landroid/graphics/Rect;->bottom:I

    iget v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v6, v7

    iget-object v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v7}, Landroid/text/StaticLayout;->getHeight()I

    move-result v7

    add-int/2addr v6, v7

    iget v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v6, v7

    int-to-float v6, v6

    invoke-direct {v2, v3, v4, v5, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    goto :goto_1

    .line 390
    :cond_4
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->left:I

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v2, v3

    int-to-float v2, v2

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->bottom:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    add-int/2addr v3, v4

    int-to-float v3, v3

    invoke-virtual {p1, v2, v3}, Landroid/graphics/Canvas;->translate(FF)V

    goto :goto_2

    .line 395
    :cond_5
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipBackground:Z

    if-eqz v2, :cond_6

    .line 396
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundColor:I

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 397
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 399
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    if-eqz v2, :cond_7

    .line 400
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    .line 401
    .restart local v1    # "tipRect":Landroid/graphics/Rect;
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v2, v3, v5, v4, v1}, Landroid/text/TextPaint;->getTextBounds(Ljava/lang/String;IILandroid/graphics/Rect;)V

    .line 402
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v2

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v3

    sub-int/2addr v2, v3

    div-int/lit8 v2, v2, 0x2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v2, v3

    int-to-float v0, v2

    .line 403
    .restart local v0    # "left":F
    new-instance v2, Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->top:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v3, v4

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v4}, Landroid/text/StaticLayout;->getHeight()I

    move-result v4

    sub-int/2addr v3, v4

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v3, v4

    int-to-float v3, v3

    invoke-virtual {v1}, Landroid/graphics/Rect;->width()I

    move-result v4

    int-to-float v4, v4

    add-float/2addr v4, v0

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    mul-int/lit8 v5, v5, 0x2

    int-to-float v5, v5

    add-float/2addr v4, v5

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->top:I

    iget v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v5, v6

    iget v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v5, v6

    int-to-float v5, v5

    invoke-direct {v2, v0, v3, v4, v5}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    .line 409
    .end local v0    # "left":F
    .end local v1    # "tipRect":Landroid/graphics/Rect;
    :cond_6
    :goto_3
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    .line 410
    iget-boolean v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    if-eqz v2, :cond_8

    .line 411
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->top:I

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v2, v3

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v3}, Landroid/text/StaticLayout;->getHeight()I

    move-result v3

    sub-int/2addr v2, v3

    int-to-float v2, v2

    invoke-virtual {p1, v8, v2}, Landroid/graphics/Canvas;->translate(FF)V

    .line 415
    :goto_4
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v2, p1}, Landroid/text/StaticLayout;->draw(Landroid/graphics/Canvas;)V

    .line 416
    invoke-virtual {p1}, Landroid/graphics/Canvas;->restore()V

    goto/16 :goto_0

    .line 405
    :cond_7
    new-instance v2, Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->left:I

    int-to-float v3, v3

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v4, v4, Landroid/graphics/Rect;->top:I

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v4, v5

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v5}, Landroid/text/StaticLayout;->getHeight()I

    move-result v5

    sub-int/2addr v4, v5

    iget v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    sub-int/2addr v4, v5

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v5, v5, Landroid/graphics/Rect;->right:I

    int-to-float v5, v5

    iget-object v6, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v6, v6, Landroid/graphics/Rect;->top:I

    iget v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v6, v7

    iget v7, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v6, v7

    int-to-float v6, v6

    invoke-direct {v2, v3, v4, v5, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v3, v3

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    int-to-float v4, v4

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mPaint:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    goto :goto_3

    .line 413
    :cond_8
    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->left:I

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    add-int/2addr v2, v3

    int-to-float v2, v2

    iget-object v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v3, v3, Landroid/graphics/Rect;->top:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    sub-int/2addr v3, v4

    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    invoke-virtual {v4}, Landroid/text/StaticLayout;->getHeight()I

    move-result v4

    sub-int/2addr v3, v4

    int-to-float v3, v3

    invoke-virtual {p1, v2, v3}, Landroid/graphics/Canvas;->translate(FF)V

    goto :goto_4
.end method

.method private initCustomAttr(ILandroid/content/res/TypedArray;)V
    .locals 1
    .param p1, "attr"    # I
    .param p2, "typedArray"    # Landroid/content/res/TypedArray;

    .prologue
    .line 139
    if-nez p1, :cond_1

    .line 140
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    .line 202
    :cond_0
    :goto_0
    return-void

    .line 141
    :cond_1
    const/4 v0, 0x1

    if-ne p1, v0, :cond_2

    .line 142
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerSize:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerSize:I

    goto :goto_0

    .line 143
    :cond_2
    const/4 v0, 0x2

    if-ne p1, v0, :cond_3

    .line 144
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerLength:I

    goto :goto_0

    .line 145
    :cond_3
    const/4 v0, 0x7

    if-ne p1, v0, :cond_4

    .line 146
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    goto :goto_0

    .line 147
    :cond_4
    const/4 v0, 0x4

    if-ne p1, v0, :cond_5

    .line 148
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    goto :goto_0

    .line 149
    :cond_5
    const/4 v0, 0x6

    if-ne p1, v0, :cond_6

    .line 150
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMaskColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMaskColor:I

    goto :goto_0

    .line 151
    :cond_6
    const/4 v0, 0x3

    if-ne p1, v0, :cond_7

    .line 152
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCornerColor:I

    goto :goto_0

    .line 153
    :cond_7
    const/16 v0, 0x8

    if-ne p1, v0, :cond_8

    .line 154
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineColor:I

    goto :goto_0

    .line 155
    :cond_8
    const/16 v0, 0x9

    if-ne p1, v0, :cond_9

    .line 156
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineMargin:I

    goto :goto_0

    .line 157
    :cond_9
    const/16 v0, 0xa

    if-ne p1, v0, :cond_a

    .line 158
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultScanLineDrawable:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultScanLineDrawable:Z

    goto :goto_0

    .line 159
    :cond_a
    const/16 v0, 0xb

    if-ne p1, v0, :cond_b

    .line 160
    invoke-virtual {p2, p1}, Landroid/content/res/TypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

    goto :goto_0

    .line 161
    :cond_b
    const/16 v0, 0xc

    if-ne p1, v0, :cond_c

    .line 162
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderSize:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderSize:I

    goto/16 :goto_0

    .line 163
    :cond_c
    const/16 v0, 0xd

    if-ne p1, v0, :cond_d

    .line 164
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBorderColor:I

    goto/16 :goto_0

    .line 165
    :cond_d
    const/16 v0, 0xe

    if-ne p1, v0, :cond_e

    .line 166
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimTime:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getInteger(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimTime:I

    goto/16 :goto_0

    .line 167
    :cond_e
    const/16 v0, 0xf

    if-ne p1, v0, :cond_f

    .line 168
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsCenterVertical:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsCenterVertical:Z

    goto/16 :goto_0

    .line 169
    :cond_f
    const/16 v0, 0x10

    if-ne p1, v0, :cond_10

    .line 170
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    goto/16 :goto_0

    .line 171
    :cond_10
    const/4 v0, 0x5

    if-ne p1, v0, :cond_11

    .line 172
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarcodeRectHeight:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarcodeRectHeight:I

    goto/16 :goto_0

    .line 173
    :cond_11
    const/16 v0, 0x11

    if-ne p1, v0, :cond_12

    .line 174
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    goto/16 :goto_0

    .line 175
    :cond_12
    const/16 v0, 0x13

    if-ne p1, v0, :cond_13

    .line 176
    invoke-virtual {p2, p1}, Landroid/content/res/TypedArray;->getString(I)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarCodeTipText:Ljava/lang/String;

    goto/16 :goto_0

    .line 177
    :cond_13
    const/16 v0, 0x12

    if-ne p1, v0, :cond_14

    .line 178
    invoke-virtual {p2, p1}, Landroid/content/res/TypedArray;->getString(I)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mQRCodeTipText:Ljava/lang/String;

    goto/16 :goto_0

    .line 179
    :cond_14
    const/16 v0, 0x14

    if-ne p1, v0, :cond_15

    .line 180
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSize:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSize:I

    goto/16 :goto_0

    .line 181
    :cond_15
    const/16 v0, 0x15

    if-ne p1, v0, :cond_16

    .line 182
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextColor:I

    goto/16 :goto_0

    .line 183
    :cond_16
    const/16 v0, 0x16

    if-ne p1, v0, :cond_17

    .line 184
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsTipTextBelowRect:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsTipTextBelowRect:Z

    goto/16 :goto_0

    .line 185
    :cond_17
    const/16 v0, 0x17

    if-ne p1, v0, :cond_18

    .line 186
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getDimensionPixelSize(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextMargin:I

    goto/16 :goto_0

    .line 187
    :cond_18
    const/16 v0, 0x18

    if-ne p1, v0, :cond_19

    .line 188
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    goto/16 :goto_0

    .line 189
    :cond_19
    const/16 v0, 0x19

    if-ne p1, v0, :cond_1a

    .line 190
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipBackground:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipBackground:Z

    goto/16 :goto_0

    .line 191
    :cond_1a
    const/16 v0, 0x1a

    if-ne p1, v0, :cond_1b

    .line 192
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundColor:I

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getColor(II)I

    move-result v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundColor:I

    goto/16 :goto_0

    .line 193
    :cond_1b
    const/16 v0, 0x1b

    if-ne p1, v0, :cond_1c

    .line 194
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsScanLineReverse:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsScanLineReverse:Z

    goto/16 :goto_0

    .line 195
    :cond_1c
    const/16 v0, 0x1c

    if-ne p1, v0, :cond_1d

    .line 196
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultGridScanLineDrawable:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultGridScanLineDrawable:Z

    goto/16 :goto_0

    .line 197
    :cond_1d
    const/16 v0, 0x1d

    if-ne p1, v0, :cond_1e

    .line 198
    invoke-virtual {p2, p1}, Landroid/content/res/TypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomGridScanLineDrawable:Landroid/graphics/drawable/Drawable;

    goto/16 :goto_0

    .line 199
    :cond_1e
    const/16 v0, 0x1e

    if-ne p1, v0, :cond_0

    .line 200
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsOnlyDecodeScanBoxArea:Z

    invoke-virtual {p2, p1, v0}, Landroid/content/res/TypedArray;->getBoolean(IZ)Z

    move-result v0

    iput-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsOnlyDecodeScanBoxArea:Z

    goto/16 :goto_0
.end method

.method private moveScanLine()V
    .locals 8

    .prologue
    const/high16 v4, 0x3f000000    # 0.5f

    .line 424
    iget-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v1, :cond_5

    .line 425
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    if-nez v1, :cond_4

    .line 427
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    .line 428
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    .line 429
    .local v0, "scanLineSize":I
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v1, :cond_0

    .line 430
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v0

    .line 433
    :cond_0
    iget-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsScanLineReverse:Z

    if-eqz v1, :cond_3

    .line 434
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    int-to-float v2, v0

    add-float/2addr v1, v2

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->right:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-gtz v1, :cond_1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->left:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v3

    cmpg-float v1, v1, v2

    if-gez v1, :cond_2

    .line 435
    :cond_1
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    neg-int v1, v1

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    .line 476
    .end local v0    # "scanLineSize":I
    :cond_2
    :goto_0
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimDelayTime:I

    int-to-long v2, v1

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v4, v1, Landroid/graphics/Rect;->left:I

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v5, v1, Landroid/graphics/Rect;->top:I

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v6, v1, Landroid/graphics/Rect;->right:I

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v7, v1, Landroid/graphics/Rect;->bottom:I

    move-object v1, p0

    invoke-virtual/range {v1 .. v7}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->postInvalidateDelayed(JIIII)V

    .line 477
    return-void

    .line 438
    .restart local v0    # "scanLineSize":I
    :cond_3
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    int-to-float v2, v0

    add-float/2addr v1, v2

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->right:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-lez v1, :cond_2

    .line 439
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->left:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    add-float/2addr v1, v4

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineLeft:F

    goto :goto_0

    .line 444
    .end local v0    # "scanLineSize":I
    :cond_4
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    .line 445
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->right:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-lez v1, :cond_2

    .line 446
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->left:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    add-float/2addr v1, v4

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineRight:F

    goto :goto_0

    .line 450
    :cond_5
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    if-nez v1, :cond_9

    .line 452
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    .line 453
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineSize:I

    .line 454
    .restart local v0    # "scanLineSize":I
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    if-eqz v1, :cond_6

    .line 455
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v0

    .line 458
    :cond_6
    iget-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsScanLineReverse:Z

    if-eqz v1, :cond_8

    .line 459
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    int-to-float v2, v0

    add-float/2addr v1, v2

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->bottom:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-gtz v1, :cond_7

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->top:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v2, v3

    cmpg-float v1, v1, v2

    if-gez v1, :cond_2

    .line 460
    :cond_7
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    neg-int v1, v1

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    goto/16 :goto_0

    .line 463
    :cond_8
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    int-to-float v2, v0

    add-float/2addr v1, v2

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->bottom:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-lez v1, :cond_2

    .line 464
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    add-float/2addr v1, v4

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineTop:F

    goto/16 :goto_0

    .line 469
    .end local v0    # "scanLineSize":I
    :cond_9
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v2, v2

    add-float/2addr v1, v2

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    .line 470
    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v2, v2, Landroid/graphics/Rect;->bottom:I

    int-to-float v2, v2

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-lez v1, :cond_2

    .line 471
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    iget v1, v1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mHalfCornerSize:F

    add-float/2addr v1, v2

    add-float/2addr v1, v4

    iput v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBottom:F

    goto/16 :goto_0
.end method


# virtual methods
.method public getIsBarcode()Z
    .locals 1

    .prologue
    .line 558
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    return v0
.end method

.method public getScanBoxAreaRect(I)Landroid/graphics/Rect;
    .locals 4
    .param p1, "previewHeight"    # I

    .prologue
    const/high16 v3, 0x3f800000    # 1.0f

    .line 498
    iget-boolean v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsOnlyDecodeScanBoxArea:Z

    if-eqz v1, :cond_0

    .line 499
    new-instance v0, Landroid/graphics/Rect;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    invoke-direct {v0, v1}, Landroid/graphics/Rect;-><init>(Landroid/graphics/Rect;)V

    .line 500
    .local v0, "rect":Landroid/graphics/Rect;
    iget v1, v0, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    mul-float/2addr v1, v3

    int-to-float v2, p1

    mul-float/2addr v1, v2

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getMeasuredHeight()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v1, v2

    float-to-int v1, v1

    iput v1, v0, Landroid/graphics/Rect;->top:I

    .line 501
    iget v1, v0, Landroid/graphics/Rect;->bottom:I

    int-to-float v1, v1

    mul-float/2addr v1, v3

    int-to-float v2, p1

    mul-float/2addr v1, v2

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getMeasuredHeight()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v1, v2

    float-to-int v1, v1

    iput v1, v0, Landroid/graphics/Rect;->bottom:I

    .line 504
    .end local v0    # "rect":Landroid/graphics/Rect;
    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public initCustomAttrs(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 4
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "attrs"    # Landroid/util/AttributeSet;

    .prologue
    .line 128
    sget-object v3, Ljoy/reightyl/fun/R$styleable;->QRCodeView:[I

    invoke-virtual {p1, p2, v3}, Landroid/content/Context;->obtainStyledAttributes(Landroid/util/AttributeSet;[I)Landroid/content/res/TypedArray;

    move-result-object v2

    .line 129
    .local v2, "typedArray":Landroid/content/res/TypedArray;
    invoke-virtual {v2}, Landroid/content/res/TypedArray;->getIndexCount()I

    move-result v0

    .line 130
    .local v0, "count":I
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_0

    .line 131
    invoke-virtual {v2, v1}, Landroid/content/res/TypedArray;->getIndex(I)I

    move-result v3

    invoke-direct {p0, v3, v2}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->initCustomAttr(ILandroid/content/res/TypedArray;)V

    .line 130
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 133
    :cond_0
    invoke-virtual {v2}, Landroid/content/res/TypedArray;->recycle()V

    .line 135
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->afterInitCustomAttrs()V

    .line 136
    return-void
.end method

.method public onDraw(Landroid/graphics/Canvas;)V
    .locals 1
    .param p1, "canvas"    # Landroid/graphics/Canvas;

    .prologue
    .line 234
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mFramingRect:Landroid/graphics/Rect;

    if-nez v0, :cond_0

    .line 256
    :goto_0
    return-void

    .line 239
    :cond_0
    invoke-direct {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->drawMask(Landroid/graphics/Canvas;)V

    .line 242
    invoke-direct {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->drawBorderLine(Landroid/graphics/Canvas;)V

    .line 245
    invoke-direct {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->drawCornerLine(Landroid/graphics/Canvas;)V

    .line 248
    invoke-direct {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->drawScanLine(Landroid/graphics/Canvas;)V

    .line 251
    invoke-direct {p0, p1}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->drawTipText(Landroid/graphics/Canvas;)V

    .line 254
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->moveScanLine()V

    goto :goto_0
.end method

.method protected onSizeChanged(IIII)V
    .locals 0
    .param p1, "w"    # I
    .param p2, "h"    # I
    .param p3, "oldw"    # I
    .param p4, "oldh"    # I

    .prologue
    .line 481
    invoke-super {p0, p1, p2, p3, p4}, Landroid/view/View;->onSizeChanged(IIII)V

    .line 482
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->calFramingRect()V

    .line 483
    return-void
.end method

.method public setIsBarcode(Z)V
    .locals 9
    .param p1, "isBarcode"    # Z

    .prologue
    const/4 v7, 0x1

    const/4 v6, 0x0

    const/high16 v5, 0x3f800000    # 1.0f

    .line 509
    iput-boolean p1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    .line 511
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomGridScanLineDrawable:Landroid/graphics/drawable/Drawable;

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultGridScanLineDrawable:Z

    if-eqz v0, :cond_5

    .line 512
    :cond_0
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v0, :cond_4

    .line 513
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginBarCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    .line 525
    :cond_1
    :goto_0
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v0, :cond_8

    .line 526
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarCodeTipText:Ljava/lang/String;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    .line 527
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mBarcodeRectHeight:I

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    .line 528
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimTime:I

    int-to-float v0, v0

    mul-float/2addr v0, v5

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v1, v1

    mul-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    int-to-float v1, v1

    div-float/2addr v0, v1

    float-to-int v0, v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimDelayTime:I

    .line 535
    :goto_1
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 536
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowTipTextAsSingleLine:Z

    if-eqz v0, :cond_9

    .line 537
    new-instance v0, Landroid/text/StaticLayout;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->getScreenResolution(Landroid/content/Context;)Landroid/graphics/Point;

    move-result-object v3

    iget v3, v3, Landroid/graphics/Point;->x:I

    sget-object v4, Landroid/text/Layout$Alignment;->ALIGN_CENTER:Landroid/text/Layout$Alignment;

    invoke-direct/range {v0 .. v7}, Landroid/text/StaticLayout;-><init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FFZ)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    .line 543
    :cond_2
    :goto_2
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsCenterVertical:Z

    if-eqz v0, :cond_3

    .line 544
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;->getScreenResolution(Landroid/content/Context;)Landroid/graphics/Point;

    move-result-object v0

    iget v8, v0, Landroid/graphics/Point;->y:I

    .line 545
    .local v8, "screenHeight":I
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    if-nez v0, :cond_a

    .line 546
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    sub-int v0, v8, v0

    div-int/lit8 v0, v0, 0x2

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    .line 552
    .end local v8    # "screenHeight":I
    :cond_3
    :goto_3
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->calFramingRect()V

    .line 554
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->postInvalidate()V

    .line 555
    return-void

    .line 515
    :cond_4
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeGridScanLineBitmap:Landroid/graphics/Bitmap;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mGridScanLineBitmap:Landroid/graphics/Bitmap;

    goto :goto_0

    .line 517
    :cond_5
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mCustomScanLineDrawable:Landroid/graphics/drawable/Drawable;

    if-nez v0, :cond_6

    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsShowDefaultScanLineDrawable:Z

    if-eqz v0, :cond_1

    .line 518
    :cond_6
    iget-boolean v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mIsBarcode:Z

    if-eqz v0, :cond_7

    .line 519
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginBarCodeScanLineBitmap:Landroid/graphics/Bitmap;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    goto :goto_0

    .line 521
    :cond_7
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mOriginQRCodeScanLineBitmap:Landroid/graphics/Bitmap;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mScanLineBitmap:Landroid/graphics/Bitmap;

    goto :goto_0

    .line 530
    :cond_8
    iget-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mQRCodeTipText:Ljava/lang/String;

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    .line 531
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    .line 532
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimTime:I

    int-to-float v0, v0

    mul-float/2addr v0, v5

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mMoveStepDistance:I

    int-to-float v1, v1

    mul-float/2addr v0, v1

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    int-to-float v1, v1

    div-float/2addr v0, v1

    float-to-int v0, v0

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mAnimDelayTime:I

    goto :goto_1

    .line 539
    :cond_9
    new-instance v0, Landroid/text/StaticLayout;

    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipText:Ljava/lang/String;

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipPaint:Landroid/text/TextPaint;

    iget v3, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectWidth:I

    iget v4, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipBackgroundRadius:I

    mul-int/lit8 v4, v4, 0x2

    sub-int/2addr v3, v4

    sget-object v4, Landroid/text/Layout$Alignment;->ALIGN_CENTER:Landroid/text/Layout$Alignment;

    invoke-direct/range {v0 .. v7}, Landroid/text/StaticLayout;-><init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FFZ)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTipTextSl:Landroid/text/StaticLayout;

    goto :goto_2

    .line 548
    .restart local v8    # "screenHeight":I
    :cond_a
    iget v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mRectHeight:I

    sub-int v0, v8, v0

    div-int/lit8 v0, v0, 0x2

    iget v1, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mToolbarHeight:I

    div-int/lit8 v1, v1, 0x2

    add-int/2addr v0, v1

    iput v0, p0, Lcom/qianniao/zbarscanner/qrcode/ScanBoxView;->mTopOffset:I

    goto :goto_3
.end method
