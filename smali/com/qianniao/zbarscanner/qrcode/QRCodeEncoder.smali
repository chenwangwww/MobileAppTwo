.class public Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;
.super Ljava/lang/Object;
.source "QRCodeEncoder.java"


# static fields
.field public static final HINTS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map",
            "<",
            "Lcom/google/zxing/EncodeHintType;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .prologue
    .line 20
    new-instance v0, Ljava/util/EnumMap;

    const-class v1, Lcom/google/zxing/EncodeHintType;

    invoke-direct {v0, v1}, Ljava/util/EnumMap;-><init>(Ljava/lang/Class;)V

    sput-object v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->HINTS:Ljava/util/Map;

    .line 23
    sget-object v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->HINTS:Ljava/util/Map;

    sget-object v1, Lcom/google/zxing/EncodeHintType;->CHARACTER_SET:Lcom/google/zxing/EncodeHintType;

    const-string v2, "utf-8"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 24
    sget-object v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->HINTS:Ljava/util/Map;

    sget-object v1, Lcom/google/zxing/EncodeHintType;->ERROR_CORRECTION:Lcom/google/zxing/EncodeHintType;

    sget-object v2, Lcom/google/zxing/qrcode/decoder/ErrorCorrectionLevel;->H:Lcom/google/zxing/qrcode/decoder/ErrorCorrectionLevel;

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 25
    sget-object v0, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->HINTS:Ljava/util/Map;

    sget-object v1, Lcom/google/zxing/EncodeHintType;->MARGIN:Lcom/google/zxing/EncodeHintType;

    const/4 v2, 0x0

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 26
    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .prologue
    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    return-void
.end method

.method private static addLogoToQRCode(Landroid/graphics/Bitmap;Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    .locals 11
    .param p0, "src"    # Landroid/graphics/Bitmap;
    .param p1, "logo"    # Landroid/graphics/Bitmap;

    .prologue
    .line 102
    if-eqz p0, :cond_0

    if-nez p1, :cond_1

    :cond_0
    move-object v0, p0

    .line 124
    :goto_0
    return-object v0

    .line 106
    :cond_1
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v7

    .line 107
    .local v7, "srcWidth":I
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v6

    .line 108
    .local v6, "srcHeight":I
    invoke-virtual {p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v4

    .line 109
    .local v4, "logoWidth":I
    invoke-virtual {p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    .line 111
    .local v3, "logoHeight":I
    int-to-float v8, v7

    const/high16 v9, 0x3f800000    # 1.0f

    mul-float/2addr v8, v9

    const/high16 v9, 0x40a00000    # 5.0f

    div-float/2addr v8, v9

    int-to-float v9, v4

    div-float v5, v8, v9

    .line 112
    .local v5, "scaleFactor":F
    sget-object v8, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v7, v6, v8}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 114
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    :try_start_0
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 115
    .local v1, "canvas":Landroid/graphics/Canvas;
    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    invoke-virtual {v1, p0, v8, v9, v10}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;FFLandroid/graphics/Paint;)V

    .line 116
    div-int/lit8 v8, v7, 0x2

    int-to-float v8, v8

    div-int/lit8 v9, v6, 0x2

    int-to-float v9, v9

    invoke-virtual {v1, v5, v5, v8, v9}, Landroid/graphics/Canvas;->scale(FFFF)V

    .line 117
    sub-int v8, v7, v4

    div-int/lit8 v8, v8, 0x2

    int-to-float v8, v8

    sub-int v9, v6, v3

    div-int/lit8 v9, v9, 0x2

    int-to-float v9, v9

    const/4 v10, 0x0

    invoke-virtual {v1, p1, v8, v9, v10}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;FFLandroid/graphics/Paint;)V

    .line 119
    invoke-virtual {v1}, Landroid/graphics/Canvas;->save()I

    .line 120
    invoke-virtual {v1}, Landroid/graphics/Canvas;->restore()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 121
    .end local v1    # "canvas":Landroid/graphics/Canvas;
    :catch_0
    move-exception v2

    .line 122
    .local v2, "e":Ljava/lang/Exception;
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static syncEncodeQRCode(Ljava/lang/String;I)Landroid/graphics/Bitmap;
    .locals 3
    .param p0, "content"    # Ljava/lang/String;
    .param p1, "size"    # I

    .prologue
    .line 38
    const/high16 v0, -0x1000000

    const/4 v1, -0x1

    const/4 v2, 0x0

    invoke-static {p0, p1, v0, v1, v2}, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->syncEncodeQRCode(Ljava/lang/String;IIILandroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    return-object v0
.end method

.method public static syncEncodeQRCode(Ljava/lang/String;II)Landroid/graphics/Bitmap;
    .locals 2
    .param p0, "content"    # Ljava/lang/String;
    .param p1, "size"    # I
    .param p2, "foregroundColor"    # I

    .prologue
    .line 49
    const/4 v0, -0x1

    const/4 v1, 0x0

    invoke-static {p0, p1, p2, v0, v1}, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->syncEncodeQRCode(Ljava/lang/String;IIILandroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    return-object v0
.end method

.method public static syncEncodeQRCode(Ljava/lang/String;IIILandroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    .locals 13
    .param p0, "content"    # Ljava/lang/String;
    .param p1, "size"    # I
    .param p2, "foregroundColor"    # I
    .param p3, "backgroundColor"    # I
    .param p4, "logo"    # Landroid/graphics/Bitmap;

    .prologue
    .line 75
    :try_start_0
    new-instance v1, Lcom/google/zxing/MultiFormatWriter;

    invoke-direct {v1}, Lcom/google/zxing/MultiFormatWriter;-><init>()V

    sget-object v3, Lcom/google/zxing/BarcodeFormat;->QR_CODE:Lcom/google/zxing/BarcodeFormat;

    sget-object v6, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->HINTS:Ljava/util/Map;

    move-object v2, p0

    move v4, p1

    move v5, p1

    invoke-virtual/range {v1 .. v6}, Lcom/google/zxing/MultiFormatWriter;->encode(Ljava/lang/String;Lcom/google/zxing/BarcodeFormat;IILjava/util/Map;)Lcom/google/zxing/common/BitMatrix;

    move-result-object v10

    .line 76
    .local v10, "matrix":Lcom/google/zxing/common/BitMatrix;
    mul-int v3, p1, p1

    new-array v2, v3, [I

    .line 77
    .local v2, "pixels":[I
    const/4 v12, 0x0

    .local v12, "y":I
    :goto_0
    if-ge v12, p1, :cond_2

    .line 78
    const/4 v11, 0x0

    .local v11, "x":I
    :goto_1
    if-ge v11, p1, :cond_1

    .line 79
    invoke-virtual {v10, v11, v12}, Lcom/google/zxing/common/BitMatrix;->get(II)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 80
    mul-int v3, v12, p1

    add-int/2addr v3, v11

    aput p2, v2, v3

    .line 78
    :goto_2
    add-int/lit8 v11, v11, 0x1

    goto :goto_1

    .line 82
    :cond_0
    mul-int v3, v12, p1

    add-int/2addr v3, v11

    aput p3, v2, v3

    goto :goto_2

    .line 89
    .end local v2    # "pixels":[I
    .end local v10    # "matrix":Lcom/google/zxing/common/BitMatrix;
    .end local v11    # "x":I
    .end local v12    # "y":I
    :catch_0
    move-exception v9

    .line 90
    .local v9, "e":Ljava/lang/Exception;
    const/4 v3, 0x0

    .end local v9    # "e":Ljava/lang/Exception;
    :goto_3
    return-object v3

    .line 77
    .restart local v2    # "pixels":[I
    .restart local v10    # "matrix":Lcom/google/zxing/common/BitMatrix;
    .restart local v11    # "x":I
    .restart local v12    # "y":I
    :cond_1
    add-int/lit8 v12, v12, 0x1

    goto :goto_0

    .line 86
    .end local v11    # "x":I
    :cond_2
    sget-object v3, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {p1, p1, v3}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v1

    .line 87
    .local v1, "bitmap":Landroid/graphics/Bitmap;
    const/4 v3, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    move v4, p1

    move v7, p1

    move v8, p1

    invoke-virtual/range {v1 .. v8}, Landroid/graphics/Bitmap;->setPixels([IIIIIII)V

    .line 88
    move-object/from16 v0, p4

    invoke-static {v1, v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->addLogoToQRCode(Landroid/graphics/Bitmap;Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v3

    goto :goto_3
.end method

.method public static syncEncodeQRCode(Ljava/lang/String;IILandroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    .locals 1
    .param p0, "content"    # Ljava/lang/String;
    .param p1, "size"    # I
    .param p2, "foregroundColor"    # I
    .param p3, "logo"    # Landroid/graphics/Bitmap;

    .prologue
    .line 61
    const/4 v0, -0x1

    invoke-static {p0, p1, p2, v0, p3}, Lcom/qianniao/zbarscanner/qrcode/QRCodeEncoder;->syncEncodeQRCode(Ljava/lang/String;IIILandroid/graphics/Bitmap;)Landroid/graphics/Bitmap;

    move-result-object v0

    return-object v0
.end method
