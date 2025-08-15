.class public Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;
.super Ljava/lang/Object;
.source "QRCodeDecoder.java"


# static fields
.field public static final HINTS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map",
            "<",
            "Lcom/google/zxing/DecodeHintType;",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .prologue
    .line 28
    new-instance v1, Ljava/util/EnumMap;

    const-class v2, Lcom/google/zxing/DecodeHintType;

    invoke-direct {v1, v2}, Ljava/util/EnumMap;-><init>(Ljava/lang/Class;)V

    sput-object v1, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->HINTS:Ljava/util/Map;

    .line 31
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 32
    .local v0, "allFormats":Ljava/util/List;, "Ljava/util/List<Lcom/google/zxing/BarcodeFormat;>;"
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->AZTEC:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 33
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->CODABAR:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 34
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->CODE_39:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 35
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->CODE_93:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 36
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->CODE_128:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 37
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->DATA_MATRIX:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 38
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->EAN_8:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 39
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->EAN_13:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 40
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->ITF:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 41
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->MAXICODE:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 42
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->PDF_417:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 43
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->QR_CODE:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 44
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->RSS_14:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 45
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->RSS_EXPANDED:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 46
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->UPC_A:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 47
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->UPC_E:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 48
    sget-object v1, Lcom/google/zxing/BarcodeFormat;->UPC_EAN_EXTENSION:Lcom/google/zxing/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 50
    sget-object v1, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->HINTS:Ljava/util/Map;

    sget-object v2, Lcom/google/zxing/DecodeHintType;->POSSIBLE_FORMATS:Lcom/google/zxing/DecodeHintType;

    invoke-interface {v1, v2, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 51
    sget-object v1, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->HINTS:Ljava/util/Map;

    sget-object v2, Lcom/google/zxing/DecodeHintType;->CHARACTER_SET:Lcom/google/zxing/DecodeHintType;

    const-string v3, "utf-8"

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 52
    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .prologue
    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 55
    return-void
.end method

.method private static getDecodeAbleBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;
    .locals 4
    .param p0, "picturePath"    # Ljava/lang/String;

    .prologue
    .line 133
    :try_start_0
    new-instance v1, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v1}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    .line 134
    .local v1, "options":Landroid/graphics/BitmapFactory$Options;
    const/4 v3, 0x1

    iput-boolean v3, v1, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 135
    invoke-static {p0, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    .line 136
    iget v3, v1, Landroid/graphics/BitmapFactory$Options;->outHeight:I

    div-int/lit16 v2, v3, 0x190

    .line 137
    .local v2, "sampleSize":I
    if-gtz v2, :cond_0

    .line 138
    const/4 v2, 0x1

    .line 139
    :cond_0
    iput v2, v1, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    .line 140
    const/4 v3, 0x0

    iput-boolean v3, v1, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 142
    invoke-static {p0, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v3

    .line 144
    .end local v1    # "options":Landroid/graphics/BitmapFactory$Options;
    .end local v2    # "sampleSize":I
    :goto_0
    return-object v3

    .line 143
    :catch_0
    move-exception v0

    .line 144
    .local v0, "e":Ljava/lang/Exception;
    const/4 v3, 0x0

    goto :goto_0
.end method

.method public static syncDecodeQRCode(Landroid/graphics/Bitmap;)Ljava/lang/String;
    .locals 11
    .param p0, "bitmap"    # Landroid/graphics/Bitmap;

    .prologue
    .line 75
    :try_start_0
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    .line 76
    .local v3, "width":I
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v7

    .line 77
    .local v7, "height":I
    mul-int v0, v3, v7

    new-array v1, v0, [I

    .line 78
    .local v1, "pixels":[I
    const/4 v2, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    move-object v0, p0

    move v6, v3

    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 79
    new-instance v10, Lcom/google/zxing/RGBLuminanceSource;

    invoke-direct {v10, v3, v7, v1}, Lcom/google/zxing/RGBLuminanceSource;-><init>(II[I)V

    .line 80
    .local v10, "source":Lcom/google/zxing/RGBLuminanceSource;
    new-instance v0, Lcom/google/zxing/MultiFormatReader;

    invoke-direct {v0}, Lcom/google/zxing/MultiFormatReader;-><init>()V

    new-instance v2, Lcom/google/zxing/BinaryBitmap;

    new-instance v4, Lcom/google/zxing/common/HybridBinarizer;

    invoke-direct {v4, v10}, Lcom/google/zxing/common/HybridBinarizer;-><init>(Lcom/google/zxing/LuminanceSource;)V

    invoke-direct {v2, v4}, Lcom/google/zxing/BinaryBitmap;-><init>(Lcom/google/zxing/Binarizer;)V

    sget-object v4, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->HINTS:Ljava/util/Map;

    invoke-virtual {v0, v2, v4}, Lcom/google/zxing/MultiFormatReader;->decode(Lcom/google/zxing/BinaryBitmap;Ljava/util/Map;)Lcom/google/zxing/Result;

    move-result-object v9

    .line 81
    .local v9, "result":Lcom/google/zxing/Result;
    invoke-virtual {v9}, Lcom/google/zxing/Result;->getText()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    .line 83
    .end local v1    # "pixels":[I
    .end local v3    # "width":I
    .end local v7    # "height":I
    .end local v9    # "result":Lcom/google/zxing/Result;
    .end local v10    # "source":Lcom/google/zxing/RGBLuminanceSource;
    :goto_0
    return-object v0

    .line 82
    :catch_0
    move-exception v8

    .line 83
    .local v8, "e":Ljava/lang/Exception;
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static syncDecodeQRCode(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "picturePath"    # Ljava/lang/String;

    .prologue
    .line 64
    invoke-static {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->getDecodeAbleBitmap(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v0

    invoke-static {v0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->syncDecodeQRCode(Landroid/graphics/Bitmap;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static syncDecodeQRCode2(Ljava/lang/String;)Ljava/lang/String;
    .locals 12
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    const/4 v9, 0x0

    .line 95
    new-instance v2, Ljava/util/Hashtable;

    invoke-direct {v2}, Ljava/util/Hashtable;-><init>()V

    .line 96
    .local v2, "hints":Ljava/util/Hashtable;, "Ljava/util/Hashtable<Lcom/google/zxing/DecodeHintType;Ljava/lang/String;>;"
    sget-object v10, Lcom/google/zxing/DecodeHintType;->CHARACTER_SET:Lcom/google/zxing/DecodeHintType;

    const-string v11, "utf-8"

    invoke-virtual {v2, v10, v11}, Ljava/util/Hashtable;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 97
    new-instance v3, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v3}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    .line 98
    .local v3, "options":Landroid/graphics/BitmapFactory$Options;
    const/4 v10, 0x1

    iput-boolean v10, v3, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 99
    invoke-static {p0, v3}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v7

    .line 100
    .local v7, "scanBitmap":Landroid/graphics/Bitmap;
    const/4 v10, 0x0

    iput-boolean v10, v3, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 101
    iget v10, v3, Landroid/graphics/BitmapFactory$Options;->outHeight:I

    int-to-float v10, v10

    const/high16 v11, 0x43480000    # 200.0f

    div-float/2addr v10, v11

    float-to-int v6, v10

    .line 102
    .local v6, "sampleSize":I
    if-gtz v6, :cond_0

    .line 103
    const/4 v6, 0x1

    .line 104
    :cond_0
    iput v6, v3, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    .line 105
    invoke-static {p0, v3}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v7

    .line 106
    new-instance v8, Lcom/qianniao/zbarscanner/qrcode/DecodingRGBLuminanceSource;

    invoke-direct {v8, v7}, Lcom/qianniao/zbarscanner/qrcode/DecodingRGBLuminanceSource;-><init>(Landroid/graphics/Bitmap;)V

    .line 107
    .local v8, "source":Lcom/qianniao/zbarscanner/qrcode/DecodingRGBLuminanceSource;
    new-instance v0, Lcom/google/zxing/BinaryBitmap;

    new-instance v10, Lcom/google/zxing/common/HybridBinarizer;

    invoke-direct {v10, v8}, Lcom/google/zxing/common/HybridBinarizer;-><init>(Lcom/google/zxing/LuminanceSource;)V

    invoke-direct {v0, v10}, Lcom/google/zxing/BinaryBitmap;-><init>(Lcom/google/zxing/Binarizer;)V

    .line 108
    .local v0, "bitmap1":Lcom/google/zxing/BinaryBitmap;
    new-instance v4, Lcom/google/zxing/qrcode/QRCodeReader;

    invoke-direct {v4}, Lcom/google/zxing/qrcode/QRCodeReader;-><init>()V

    .line 110
    .local v4, "reader":Lcom/google/zxing/qrcode/QRCodeReader;
    :try_start_0
    invoke-virtual {v4, v0, v2}, Lcom/google/zxing/qrcode/QRCodeReader;->decode(Lcom/google/zxing/BinaryBitmap;Ljava/util/Map;)Lcom/google/zxing/Result;

    move-result-object v5

    .line 111
    .local v5, "result":Lcom/google/zxing/Result;
    if-nez v5, :cond_1

    .line 122
    .end local v5    # "result":Lcom/google/zxing/Result;
    :goto_0
    return-object v9

    .line 111
    .restart local v5    # "result":Lcom/google/zxing/Result;
    :cond_1
    invoke-virtual {v5}, Lcom/google/zxing/Result;->getText()Ljava/lang/String;
    :try_end_0
    .catch Lcom/google/zxing/NotFoundException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lcom/google/zxing/ChecksumException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Lcom/google/zxing/FormatException; {:try_start_0 .. :try_end_0} :catch_2

    move-result-object v9

    goto :goto_0

    .line 112
    .end local v5    # "result":Lcom/google/zxing/Result;
    :catch_0
    move-exception v1

    .line 113
    .local v1, "e":Lcom/google/zxing/NotFoundException;
    invoke-virtual {v1}, Lcom/google/zxing/NotFoundException;->printStackTrace()V

    goto :goto_0

    .line 115
    .end local v1    # "e":Lcom/google/zxing/NotFoundException;
    :catch_1
    move-exception v1

    .line 116
    .local v1, "e":Lcom/google/zxing/ChecksumException;
    invoke-virtual {v1}, Lcom/google/zxing/ChecksumException;->printStackTrace()V

    goto :goto_0

    .line 118
    .end local v1    # "e":Lcom/google/zxing/ChecksumException;
    :catch_2
    move-exception v1

    .line 119
    .local v1, "e":Lcom/google/zxing/FormatException;
    invoke-virtual {v1}, Lcom/google/zxing/FormatException;->printStackTrace()V

    goto :goto_0
.end method
