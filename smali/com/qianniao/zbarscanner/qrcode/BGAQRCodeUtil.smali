.class public Lcom/qianniao/zbarscanner/qrcode/BGAQRCodeUtil;
.super Ljava/lang/Object;
.source "BGAQRCodeUtil.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static adjustPhotoRotation(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;
    .locals 13
    .param p0, "inputBitmap"    # Landroid/graphics/Bitmap;
    .param p1, "orientationDegree"    # I

    .prologue
    const/high16 v12, 0x40000000    # 2.0f

    .line 38
    if-nez p0, :cond_0

    .line 39
    const/4 v2, 0x0

    .line 62
    :goto_0
    return-object v2

    .line 42
    :cond_0
    new-instance v1, Landroid/graphics/Matrix;

    invoke-direct {v1}, Landroid/graphics/Matrix;-><init>()V

    .line 43
    .local v1, "matrix":Landroid/graphics/Matrix;
    int-to-float v9, p1

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v10

    int-to-float v10, v10

    div-float/2addr v10, v12

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v11

    int-to-float v11, v11

    div-float/2addr v11, v12

    invoke-virtual {v1, v9, v10, v11}, Landroid/graphics/Matrix;->setRotate(FFF)V

    .line 45
    const/16 v9, 0x5a

    if-ne p1, v9, :cond_1

    .line 46
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v9

    int-to-float v3, v9

    .line 47
    .local v3, "outputX":F
    const/4 v4, 0x0

    .line 53
    .local v4, "outputY":F
    :goto_1
    const/16 v9, 0x9

    new-array v6, v9, [F

    .line 54
    .local v6, "values":[F
    invoke-virtual {v1, v6}, Landroid/graphics/Matrix;->getValues([F)V

    .line 55
    const/4 v9, 0x2

    aget v7, v6, v9

    .line 56
    .local v7, "x1":F
    const/4 v9, 0x5

    aget v8, v6, v9

    .line 57
    .local v8, "y1":F
    sub-float v9, v3, v7

    sub-float v10, v4, v8

    invoke-virtual {v1, v9, v10}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    .line 58
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v9

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v10

    sget-object v11, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v9, v10, v11}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 59
    .local v2, "outputBitmap":Landroid/graphics/Bitmap;
    new-instance v5, Landroid/graphics/Paint;

    invoke-direct {v5}, Landroid/graphics/Paint;-><init>()V

    .line 60
    .local v5, "paint":Landroid/graphics/Paint;
    new-instance v0, Landroid/graphics/Canvas;

    invoke-direct {v0, v2}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 61
    .local v0, "canvas":Landroid/graphics/Canvas;
    invoke-virtual {v0, p0, v1, v5}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Matrix;Landroid/graphics/Paint;)V

    goto :goto_0

    .line 49
    .end local v0    # "canvas":Landroid/graphics/Canvas;
    .end local v2    # "outputBitmap":Landroid/graphics/Bitmap;
    .end local v3    # "outputX":F
    .end local v4    # "outputY":F
    .end local v5    # "paint":Landroid/graphics/Paint;
    .end local v6    # "values":[F
    .end local v7    # "x1":F
    .end local v8    # "y1":F
    :cond_1
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v9

    int-to-float v3, v9

    .line 50
    .restart local v3    # "outputX":F
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v9

    int-to-float v4, v9

    .restart local v4    # "outputY":F
    goto :goto_1
.end method

.method public static dp2px(Landroid/content/Context;F)I
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "dpValue"    # F

    .prologue
    .line 30
    const/4 v0, 0x1

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    invoke-static {v0, p1, v1}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v0

    float-to-int v0, v0

    return v0
.end method

.method public static getScreenResolution(Landroid/content/Context;)Landroid/graphics/Point;
    .locals 5
    .param p0, "context"    # Landroid/content/Context;

    .prologue
    .line 18
    const-string v3, "window"

    invoke-virtual {p0, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/WindowManager;

    .line 19
    .local v2, "wm":Landroid/view/WindowManager;
    invoke-interface {v2}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    .line 20
    .local v0, "display":Landroid/view/Display;
    new-instance v1, Landroid/graphics/Point;

    invoke-direct {v1}, Landroid/graphics/Point;-><init>()V

    .line 21
    .local v1, "screenResolution":Landroid/graphics/Point;
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v4, 0xd

    if-lt v3, v4, :cond_0

    .line 22
    invoke-virtual {v0, v1}, Landroid/view/Display;->getSize(Landroid/graphics/Point;)V

    .line 26
    :goto_0
    return-object v1

    .line 24
    :cond_0
    invoke-virtual {v0}, Landroid/view/Display;->getWidth()I

    move-result v3

    invoke-virtual {v0}, Landroid/view/Display;->getHeight()I

    move-result v4

    invoke-virtual {v1, v3, v4}, Landroid/graphics/Point;->set(II)V

    goto :goto_0
.end method

.method public static makeTintBitmap(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;
    .locals 7
    .param p0, "inputBitmap"    # Landroid/graphics/Bitmap;
    .param p1, "tintColor"    # I

    .prologue
    const/4 v6, 0x0

    .line 66
    if-nez p0, :cond_0

    .line 67
    const/4 v1, 0x0

    .line 75
    :goto_0
    return-object v1

    .line 70
    :cond_0
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v4

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getConfig()Landroid/graphics/Bitmap$Config;

    move-result-object v5

    invoke-static {v3, v4, v5}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 71
    .local v1, "outputBitmap":Landroid/graphics/Bitmap;
    new-instance v0, Landroid/graphics/Canvas;

    invoke-direct {v0, v1}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 72
    .local v0, "canvas":Landroid/graphics/Canvas;
    new-instance v2, Landroid/graphics/Paint;

    invoke-direct {v2}, Landroid/graphics/Paint;-><init>()V

    .line 73
    .local v2, "paint":Landroid/graphics/Paint;
    new-instance v3, Landroid/graphics/PorterDuffColorFilter;

    sget-object v4, Landroid/graphics/PorterDuff$Mode;->SRC_IN:Landroid/graphics/PorterDuff$Mode;

    invoke-direct {v3, p1, v4}, Landroid/graphics/PorterDuffColorFilter;-><init>(ILandroid/graphics/PorterDuff$Mode;)V

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColorFilter(Landroid/graphics/ColorFilter;)Landroid/graphics/ColorFilter;

    .line 74
    invoke-virtual {v0, p0, v6, v6, v2}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;FFLandroid/graphics/Paint;)V

    goto :goto_0
.end method

.method public static sp2px(Landroid/content/Context;F)I
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "spValue"    # F

    .prologue
    .line 34
    const/4 v0, 0x2

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    invoke-static {v0, p1, v1}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result v0

    float-to-int v0, v0

    return v0
.end method
