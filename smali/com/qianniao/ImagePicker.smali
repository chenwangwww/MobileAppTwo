.class public Lcom/qianniao/ImagePicker;
.super Ljava/lang/Object;
.source "ImagePicker.java"


# static fields
.field private static final IMAGE_FILE_LOCATION:Ljava/lang/String;

.field public static final IMAGE_UNSPECIFIED:Ljava/lang/String; = "image/*;video/*"

.field private static MAX_IMAGE_WIDTH:F = 0.0f

.field public static final NONE:I = 0x0

.field public static final PHOTOHRAPH:I = 0x1

.field public static final PHOTORESOULT:I = 0x3

.field public static final PHOTOZOOM:I = 0x2

.field private static TAG:Ljava/lang/String;

.field private static THUMB_IMG_DATA_SIZE:F

.field private static imgUri:Landroid/net/Uri;

.field private static instance:Lcom/qianniao/ImagePicker;

.field private static photoName:Ljava/lang/String;


# instance fields
.field private activity:Landroid/app/Activity;

.field private imagePhotoUri:Landroid/net/Uri;

.field private maxFileSize:F

.field private minFileSize:F

.field public savePath:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .prologue
    const/4 v2, 0x0

    .line 41
    sput-object v2, Lcom/qianniao/ImagePicker;->instance:Lcom/qianniao/ImagePicker;

    .line 43
    const-string v0, "ImagePicker"

    sput-object v0, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    .line 46
    const/high16 v0, 0x45800000    # 4096.0f

    sput v0, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    .line 47
    const/high16 v0, 0x45c00000    # 6144.0f

    sput v0, Lcom/qianniao/ImagePicker;->THUMB_IMG_DATA_SIZE:F

    .line 53
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/temp.jpg"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/qianniao/ImagePicker;->IMAGE_FILE_LOCATION:Ljava/lang/String;

    .line 57
    const-string v0, ""

    sput-object v0, Lcom/qianniao/ImagePicker;->photoName:Ljava/lang/String;

    .line 58
    sput-object v2, Lcom/qianniao/ImagePicker;->imgUri:Landroid/net/Uri;

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .prologue
    const/4 v2, 0x0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    iput-object v2, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    .line 44
    const/high16 v0, 0x49800000    # 1048576.0f

    iput v0, p0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    .line 45
    const/high16 v0, 0x48480000    # 204800.0f

    iput v0, p0, Lcom/qianniao/ImagePicker;->minFileSize:F

    .line 56
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "/temp/"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    .line 60
    iput-object v2, p0, Lcom/qianniao/ImagePicker;->imagePhotoUri:Landroid/net/Uri;

    return-void
.end method

.method private _genThumbImg(Ljava/lang/String;IIIIII)Ljava/lang/String;
    .locals 20
    .param p1, "filePath"    # Ljava/lang/String;
    .param p2, "w"    # I
    .param p3, "h"    # I
    .param p4, "x"    # I
    .param p5, "y"    # I
    .param p6, "ow"    # I
    .param p7, "oh"    # I

    .prologue
    .line 595
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "genThumbImg: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    move-object/from16 v0, p1

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 597
    new-instance v17, Landroid/graphics/BitmapFactory$Options;

    invoke-direct/range {v17 .. v17}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    .line 598
    .local v17, "options":Landroid/graphics/BitmapFactory$Options;
    const/4 v3, 0x1

    move-object/from16 v0, v17

    iput-boolean v3, v0, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 599
    move-object/from16 v0, p1

    move-object/from16 v1, v17

    invoke-static {v0, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    .line 602
    const/4 v3, 0x1

    move-object/from16 v0, v17

    iput v3, v0, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    .line 605
    const/4 v3, 0x0

    move-object/from16 v0, v17

    iput-boolean v3, v0, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 607
    sget-object v3, Landroid/graphics/Bitmap$Config;->RGB_565:Landroid/graphics/Bitmap$Config;

    move-object/from16 v0, v17

    iput-object v3, v0, Landroid/graphics/BitmapFactory$Options;->inPreferredConfig:Landroid/graphics/Bitmap$Config;

    .line 608
    const/4 v3, 0x1

    move-object/from16 v0, v17

    iput-boolean v3, v0, Landroid/graphics/BitmapFactory$Options;->inDither:Z

    .line 610
    move-object/from16 v0, p1

    move-object/from16 v1, v17

    invoke-static {v0, v1}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 613
    .local v2, "bitmap":Landroid/graphics/Bitmap;
    if-eqz p6, :cond_0

    if-nez p7, :cond_1

    .line 615
    :cond_0
    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getWidth()I

    move-result p6

    .line 616
    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result p7

    .line 619
    :cond_1
    new-instance v7, Landroid/graphics/Matrix;

    invoke-direct {v7}, Landroid/graphics/Matrix;-><init>()V

    .line 620
    .local v7, "mat":Landroid/graphics/Matrix;
    move/from16 v0, p2

    int-to-float v3, v0

    const/high16 v4, 0x3f800000    # 1.0f

    mul-float/2addr v3, v4

    move/from16 v0, p6

    int-to-float v4, v0

    div-float/2addr v3, v4

    move/from16 v0, p3

    int-to-float v4, v0

    const/high16 v5, 0x3f800000    # 1.0f

    mul-float/2addr v4, v5

    move/from16 v0, p7

    int-to-float v5, v0

    div-float/2addr v4, v5

    invoke-virtual {v7, v3, v4}, Landroid/graphics/Matrix;->setScale(FF)V

    .line 621
    const/4 v8, 0x0

    move/from16 v3, p4

    move/from16 v4, p5

    move/from16 v5, p6

    move/from16 v6, p7

    invoke-static/range {v2 .. v8}, Landroid/graphics/Bitmap;->createBitmap(Landroid/graphics/Bitmap;IIIILandroid/graphics/Matrix;Z)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 623
    new-instance v12, Ljava/io/File;

    move-object/from16 v0, p0

    iget-object v3, v0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-direct {v12, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 624
    .local v12, "dirFile":Ljava/io/File;
    invoke-virtual {v12}, Ljava/io/File;->exists()Z

    move-result v3

    if-nez v3, :cond_2

    .line 625
    invoke-virtual {v12}, Ljava/io/File;->mkdir()Z

    .line 628
    :cond_2
    new-instance v9, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v9}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 629
    .local v9, "baos":Ljava/io/ByteArrayOutputStream;
    const/16 v18, 0x64

    .line 630
    .local v18, "pingzi":I
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    move/from16 v0, v18

    invoke-virtual {v2, v3, v0, v9}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 632
    invoke-virtual {v9}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v3

    array-length v11, v3

    .line 633
    .local v11, "dataSize":I
    :goto_0
    int-to-float v3, v11

    sget v4, Lcom/qianniao/ImagePicker;->THUMB_IMG_DATA_SIZE:F

    cmpl-float v3, v3, v4

    if-lez v3, :cond_3

    .line 634
    invoke-virtual {v9}, Ljava/io/ByteArrayOutputStream;->reset()V

    .line 635
    if-lez v18, :cond_4

    .line 636
    add-int/lit8 v18, v18, -0xa

    .line 639
    :goto_1
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    move/from16 v0, v18

    invoke-virtual {v2, v3, v0, v9}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 641
    invoke-virtual {v9}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v3

    array-length v0, v3

    move/from16 v19, v0

    .line 642
    .local v19, "ydataSize":I
    move/from16 v0, v19

    if-ne v0, v11, :cond_5

    .line 649
    .end local v19    # "ydataSize":I
    :cond_3
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ".jpg"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    .line 650
    .local v14, "imgName":Ljava/lang/String;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, p0

    iget-object v4, v0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v16

    .line 651
    .local v16, "newFilePath":Ljava/lang/String;
    new-instance v15, Ljava/io/File;

    invoke-direct/range {v15 .. v16}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 653
    .local v15, "myFile":Ljava/io/File;
    :try_start_0
    new-instance v10, Ljava/io/BufferedOutputStream;

    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v15}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v10, v3}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 654
    .local v10, "bos":Ljava/io/BufferedOutputStream;
    invoke-virtual {v9}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v3

    invoke-virtual {v10, v3}, Ljava/io/BufferedOutputStream;->write([B)V

    .line 655
    invoke-virtual {v10}, Ljava/io/BufferedOutputStream;->flush()V

    .line 656
    invoke-virtual {v10}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 661
    .end local v10    # "bos":Ljava/io/BufferedOutputStream;
    :goto_2
    return-object v16

    .line 638
    .end local v14    # "imgName":Ljava/lang/String;
    .end local v15    # "myFile":Ljava/io/File;
    .end local v16    # "newFilePath":Ljava/lang/String;
    :cond_4
    add-int/lit8 v18, v18, -0x1

    goto :goto_1

    .line 645
    .restart local v19    # "ydataSize":I
    :cond_5
    move/from16 v11, v19

    .line 646
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u56fe\u7247\u538b\u7f29\u540e\uff1a"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v9}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v5

    array-length v5, v5

    div-int/lit16 v5, v5, 0x400

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "KB"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_0

    .line 657
    .end local v19    # "ydataSize":I
    .restart local v14    # "imgName":Ljava/lang/String;
    .restart local v15    # "myFile":Ljava/io/File;
    .restart local v16    # "newFilePath":Ljava/lang/String;
    :catch_0
    move-exception v13

    .line 658
    .local v13, "ex":Ljava/lang/Exception;
    invoke-virtual {v13}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_2
.end method

.method private _saveImagePhoto(Ljava/lang/String;)V
    .locals 7
    .param p1, "imagePath"    # Ljava/lang/String;

    .prologue
    .line 103
    :try_start_0
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 104
    .local v1, "file":Ljava/io/File;
    iget-object v2, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x0

    invoke-static {v2, v3, v4, v5}, Landroid/provider/MediaStore$Images$Media;->insertImage(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 107
    iget-object v2, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    new-instance v3, Landroid/content/Intent;

    const-string v4, "android.intent.action.MEDIA_SCANNER_SCAN_FILE"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "file://"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v5

    invoke-direct {v3, v4, v5}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {v2, v3}, Landroid/app/Activity;->sendBroadcast(Landroid/content/Intent;)V

    .line 109
    const/4 v2, 0x1

    invoke-static {v2}, Lcom/qianniao/ImagePicker;->onSaveImageCallback(Z)V
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 114
    .end local v1    # "file":Ljava/io/File;
    :goto_0
    return-void

    .line 110
    :catch_0
    move-exception v0

    .line 111
    .local v0, "e":Ljava/io/FileNotFoundException;
    const/4 v2, 0x0

    invoke-static {v2}, Lcom/qianniao/ImagePicker;->onSaveImageCallback(Z)V

    .line 112
    invoke-virtual {v0}, Ljava/io/FileNotFoundException;->printStackTrace()V

    goto :goto_0
.end method

.method private _saveVideoPhoto(Ljava/lang/String;)V
    .locals 13
    .param p1, "videoPath"    # Ljava/lang/String;

    .prologue
    const-wide/16 v4, 0x0

    const/4 v6, 0x0

    .line 203
    new-instance v11, Ljava/io/File;

    invoke-direct {v11, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 204
    .local v11, "file":Ljava/io/File;
    sget-object v1, Landroid/os/Environment;->DIRECTORY_MOVIES:Ljava/lang/String;

    invoke-static {v1}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    invoke-virtual {v1}, Ljava/io/File;->toString()Ljava/lang/String;

    move-result-object v0

    .line 206
    .local v0, "dir":Ljava/lang/String;
    invoke-virtual {p0, v0}, Lcom/qianniao/ImagePicker;->isFolderExists(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 207
    invoke-static {v6}, Lcom/qianniao/ImagePicker;->onSaveVideoCallback(Z)V

    .line 227
    :goto_0
    return-void

    .line 211
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v11}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 213
    .local v3, "path":Ljava/lang/String;
    :try_start_0
    iget-object v1, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    invoke-static {v1, p1, v3}, Lcom/qianniao/ImagePicker;->copyBigDataToSD(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 217
    :goto_1
    iget-object v2, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    move-object v1, p0

    move v7, v6

    move-wide v8, v4

    invoke-virtual/range {v1 .. v9}, Lcom/qianniao/ImagePicker;->insertVideoToMediaStore(Landroid/content/Context;Ljava/lang/String;JIIJ)Z

    move-result v12

    .line 219
    .local v12, "isSave":Z
    if-eqz v12, :cond_1

    .line 221
    const/4 v1, 0x1

    invoke-static {v1}, Lcom/qianniao/ImagePicker;->onSaveVideoCallback(Z)V

    goto :goto_0

    .line 214
    .end local v12    # "isSave":Z
    :catch_0
    move-exception v10

    .line 215
    .local v10, "e":Ljava/io/IOException;
    invoke-virtual {v10}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_1

    .line 225
    .end local v10    # "e":Ljava/io/IOException;
    .restart local v12    # "isSave":Z
    :cond_1
    invoke-static {v6}, Lcom/qianniao/ImagePicker;->onSaveVideoCallback(Z)V

    goto :goto_0
.end method

.method public static copyBigDataToSD(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "fileAssetPath"    # Ljava/lang/String;
    .param p2, "strOutFileName"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .prologue
    .line 157
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 158
    .local v1, "file":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v2

    .line 159
    .local v2, "fileLen":J
    new-instance v4, Ljava/io/FileInputStream;

    invoke-direct {v4, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 161
    .local v4, "inputStream":Ljava/io/FileInputStream;
    new-instance v5, Ljava/io/FileOutputStream;

    invoke-direct {v5, p2}, Ljava/io/FileOutputStream;-><init>(Ljava/lang/String;)V

    .line 163
    .local v5, "outputStream":Ljava/io/FileOutputStream;
    long-to-int v6, v2

    new-array v0, v6, [B

    .line 164
    .local v0, "b":[B
    invoke-virtual {v4, v0}, Ljava/io/FileInputStream;->read([B)I

    .line 165
    invoke-virtual {v4}, Ljava/io/FileInputStream;->close()V

    .line 167
    invoke-virtual {v5, v0}, Ljava/io/FileOutputStream;->write([B)V

    .line 168
    invoke-virtual {v5}, Ljava/io/FileOutputStream;->flush()V

    .line 169
    invoke-virtual {v5}, Ljava/io/FileOutputStream;->close()V

    .line 170
    return-void
.end method

.method private decodeUriAsBitmap(Landroid/net/Uri;)Landroid/graphics/Bitmap;
    .locals 3
    .param p1, "uri"    # Landroid/net/Uri;

    .prologue
    .line 582
    const/4 v0, 0x0

    .line 584
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    :try_start_0
    iget-object v2, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v2

    invoke-static {v2}, Landroid/graphics/BitmapFactory;->decodeStream(Ljava/io/InputStream;)Landroid/graphics/Bitmap;
    :try_end_0
    .catch Ljava/io/FileNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    move-object v2, v0

    .line 591
    :goto_0
    return-object v2

    .line 585
    :catch_0
    move-exception v1

    .line 587
    .local v1, "e":Ljava/io/FileNotFoundException;
    invoke-virtual {v1}, Ljava/io/FileNotFoundException;->printStackTrace()V

    .line 588
    const/4 v2, 0x0

    goto :goto_0
.end method

.method public static genThumbImg(Ljava/lang/String;IIIIII)Ljava/lang/String;
    .locals 8
    .param p0, "filePath"    # Ljava/lang/String;
    .param p1, "w"    # I
    .param p2, "h"    # I
    .param p3, "x"    # I
    .param p4, "y"    # I
    .param p5, "ow"    # I
    .param p6, "oh"    # I

    .prologue
    .line 665
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    move-object v1, p0

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    move v6, p5

    move v7, p6

    invoke-direct/range {v0 .. v7}, Lcom/qianniao/ImagePicker;->_genThumbImg(Ljava/lang/String;IIIIII)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static getInstance()Lcom/qianniao/ImagePicker;
    .locals 1

    .prologue
    .line 63
    sget-object v0, Lcom/qianniao/ImagePicker;->instance:Lcom/qianniao/ImagePicker;

    if-nez v0, :cond_0

    .line 65
    new-instance v0, Lcom/qianniao/ImagePicker;

    invoke-direct {v0}, Lcom/qianniao/ImagePicker;-><init>()V

    sput-object v0, Lcom/qianniao/ImagePicker;->instance:Lcom/qianniao/ImagePicker;

    .line 67
    :cond_0
    sget-object v0, Lcom/qianniao/ImagePicker;->instance:Lcom/qianniao/ImagePicker;

    return-object v0
.end method

.method private static getTimeWrap(J)J
    .locals 2
    .param p0, "time"    # J

    .prologue
    .line 129
    const-wide/16 v0, 0x0

    cmp-long v0, p0, v0

    if-gtz v0, :cond_0

    .line 130
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    .line 132
    .end local p0    # "time":J
    :cond_0
    return-wide p0
.end method

.method public static getVideoDuration(Ljava/lang/String;)I
    .locals 1
    .param p0, "filePath"    # Ljava/lang/String;

    .prologue
    .line 274
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/qianniao/ImagePicker;->_getDuration(Ljava/lang/String;)I

    move-result v0

    return v0
.end method

.method private static getVideoMimeType(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 119
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v0

    .line 120
    .local v0, "lowerPath":Ljava/lang/String;
    const-string v1, "mp4"

    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, "mpeg4"

    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 121
    :cond_0
    const-string v1, "video/mp4"

    .line 125
    :goto_0
    return-object v1

    .line 122
    :cond_1
    const-string v1, "3gp"

    invoke-virtual {v0, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    .line 123
    const-string v1, "video/3gp"

    goto :goto_0

    .line 125
    :cond_2
    const-string v1, "video/mp4"

    goto :goto_0
.end method

.method public static getVideoThumb(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "filePath"    # Ljava/lang/String;

    .prologue
    .line 270
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/qianniao/ImagePicker;->_getVideoThumbnail(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static imageCompress(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 670
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/qianniao/ImagePicker;->_imageCompress(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static initCommonContentValues(Ljava/lang/String;J)Landroid/content/ContentValues;
    .locals 9
    .param p0, "filePath"    # Ljava/lang/String;
    .param p1, "time"    # J

    .prologue
    .line 143
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    .line 144
    .local v1, "values":Landroid/content/ContentValues;
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 145
    .local v0, "saveFile":Ljava/io/File;
    invoke-static {p1, p2}, Lcom/qianniao/ImagePicker;->getTimeWrap(J)J

    move-result-wide v2

    .line 146
    .local v2, "timeMillis":J
    const-string v4, "title"

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 147
    const-string v4, "_display_name"

    invoke-virtual {v0}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 148
    const-string v4, "date_modified"

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 149
    const-string v4, "date_added"

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 150
    const-string v4, "_data"

    invoke-virtual {v0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 151
    const-string v4, "_size"

    invoke-virtual {v0}, Ljava/io/File;->length()J

    move-result-wide v6

    invoke-static {v6, v7}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v5

    invoke-virtual {v1, v4, v5}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 152
    return-object v1
.end method

.method private static isFileExists(Ljava/lang/String;)Z
    .locals 3
    .param p0, "filePath"    # Ljava/lang/String;

    .prologue
    .line 572
    :try_start_0
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 573
    .local v1, "file":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v2

    .line 577
    .end local v1    # "file":Ljava/io/File;
    :goto_0
    return v2

    .line 574
    :catch_0
    move-exception v0

    .line 575
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 577
    const/4 v2, 0x0

    goto :goto_0
.end method

.method public static native onImageSaved(Ljava/lang/String;)V
.end method

.method public static native onSaveImageCallback(Z)V
.end method

.method public static native onSaveVideoCallback(Z)V
.end method

.method public static openCamera()V
    .locals 1

    .prologue
    .line 252
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0}, Lcom/qianniao/ImagePicker;->_openCamera()V

    .line 253
    return-void
.end method

.method public static openPhoto()V
    .locals 3

    .prologue
    .line 231
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.PICK"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 232
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "image/*;video/*"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 233
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v1

    iget-object v1, v1, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    const/4 v2, 0x2

    invoke-virtual {v1, v0, v2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 235
    return-void
.end method

.method public static saveImagePhoto(Ljava/lang/String;)V
    .locals 1
    .param p0, "imagePath"    # Ljava/lang/String;

    .prologue
    .line 278
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-direct {v0, p0}, Lcom/qianniao/ImagePicker;->_saveImagePhoto(Ljava/lang/String;)V

    .line 279
    return-void
.end method

.method public static saveVideoPhoto(Ljava/lang/String;)V
    .locals 1
    .param p0, "videoPath"    # Ljava/lang/String;

    .prologue
    .line 282
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-direct {v0, p0}, Lcom/qianniao/ImagePicker;->_saveVideoPhoto(Ljava/lang/String;)V

    .line 283
    return-void
.end method

.method public static setImageDataSize(II)V
    .locals 1
    .param p0, "max"    # I
    .param p1, "min"    # I

    .prologue
    .line 266
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p0, p1}, Lcom/qianniao/ImagePicker;->_setImageDataSize(II)V

    .line 267
    return-void
.end method

.method public static ssetSaveDirectory(Ljava/lang/String;)V
    .locals 1
    .param p0, "dire"    # Ljava/lang/String;

    .prologue
    .line 257
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/qianniao/ImagePicker;->setSaveDirectory(Ljava/lang/String;)V

    .line 258
    return-void
.end method


# virtual methods
.method public _getDuration(Ljava/lang/String;)I
    .locals 3
    .param p1, "path"    # Ljava/lang/String;

    .prologue
    .line 338
    new-instance v1, Landroid/media/MediaMetadataRetriever;

    invoke-direct {v1}, Landroid/media/MediaMetadataRetriever;-><init>()V

    .line 339
    .local v1, "retriever":Landroid/media/MediaMetadataRetriever;
    invoke-virtual {v1, p1}, Landroid/media/MediaMetadataRetriever;->setDataSource(Ljava/lang/String;)V

    .line 340
    const/16 v2, 0x9

    invoke-virtual {v1, v2}, Landroid/media/MediaMetadataRetriever;->extractMetadata(I)Ljava/lang/String;

    move-result-object v0

    .line 341
    .local v0, "duration":Ljava/lang/String;
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    return v2
.end method

.method public _getVideoThumbnail(Ljava/lang/String;)Ljava/lang/String;
    .locals 8
    .param p1, "filePath"    # Ljava/lang/String;

    .prologue
    .line 345
    const/4 v0, 0x0

    .line 346
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    new-instance v4, Landroid/media/MediaMetadataRetriever;

    invoke-direct {v4}, Landroid/media/MediaMetadataRetriever;-><init>()V

    .line 348
    .local v4, "retriever":Landroid/media/MediaMetadataRetriever;
    :try_start_0
    invoke-virtual {v4, p1}, Landroid/media/MediaMetadataRetriever;->setDataSource(Ljava/lang/String;)V

    .line 349
    invoke-virtual {v4}, Landroid/media/MediaMetadataRetriever;->getFrameAtTime()Landroid/graphics/Bitmap;

    move-result-object v0

    .line 351
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    invoke-virtual {v5, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, ".jpg"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 352
    .local v2, "head_img_name":Ljava/lang/String;
    invoke-virtual {p0, v0, v2}, Lcom/qianniao/ImagePicker;->saveFile(Landroid/graphics/Bitmap;Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_3
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move-result-object v3

    .line 364
    .local v3, "newFilePath":Ljava/lang/String;
    :try_start_1
    invoke-virtual {v4}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_0

    .line 370
    .end local v2    # "head_img_name":Ljava/lang/String;
    .end local v3    # "newFilePath":Ljava/lang/String;
    :goto_0
    return-object v3

    .line 366
    .restart local v2    # "head_img_name":Ljava/lang/String;
    .restart local v3    # "newFilePath":Ljava/lang/String;
    :catch_0
    move-exception v1

    .line 367
    .local v1, "e":Ljava/lang/RuntimeException;
    invoke-virtual {v1}, Ljava/lang/RuntimeException;->printStackTrace()V

    goto :goto_0

    .line 356
    .end local v1    # "e":Ljava/lang/RuntimeException;
    .end local v2    # "head_img_name":Ljava/lang/String;
    .end local v3    # "newFilePath":Ljava/lang/String;
    :catch_1
    move-exception v1

    .line 357
    .local v1, "e":Ljava/lang/IllegalArgumentException;
    :try_start_2
    invoke-virtual {v1}, Ljava/lang/IllegalArgumentException;->printStackTrace()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 364
    :try_start_3
    invoke-virtual {v4}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_3
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_2

    .line 370
    .end local v1    # "e":Ljava/lang/IllegalArgumentException;
    :goto_1
    const-string v3, ""

    goto :goto_0

    .line 366
    .restart local v1    # "e":Ljava/lang/IllegalArgumentException;
    :catch_2
    move-exception v1

    .line 367
    .local v1, "e":Ljava/lang/RuntimeException;
    invoke-virtual {v1}, Ljava/lang/RuntimeException;->printStackTrace()V

    goto :goto_1

    .line 359
    .end local v1    # "e":Ljava/lang/RuntimeException;
    :catch_3
    move-exception v1

    .line 360
    .restart local v1    # "e":Ljava/lang/RuntimeException;
    :try_start_4
    invoke-virtual {v1}, Ljava/lang/RuntimeException;->printStackTrace()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 364
    :try_start_5
    invoke-virtual {v4}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_5
    .catch Ljava/lang/RuntimeException; {:try_start_5 .. :try_end_5} :catch_4

    goto :goto_1

    .line 366
    :catch_4
    move-exception v1

    .line 367
    invoke-virtual {v1}, Ljava/lang/RuntimeException;->printStackTrace()V

    goto :goto_1

    .line 363
    .end local v1    # "e":Ljava/lang/RuntimeException;
    :catchall_0
    move-exception v5

    .line 364
    :try_start_6
    invoke-virtual {v4}, Landroid/media/MediaMetadataRetriever;->release()V
    :try_end_6
    .catch Ljava/lang/RuntimeException; {:try_start_6 .. :try_end_6} :catch_5

    .line 369
    :goto_2
    throw v5

    .line 366
    :catch_5
    move-exception v1

    .line 367
    .restart local v1    # "e":Ljava/lang/RuntimeException;
    invoke-virtual {v1}, Ljava/lang/RuntimeException;->printStackTrace()V

    goto :goto_2
.end method

.method public _imageCompress(Ljava/lang/String;)Ljava/lang/String;
    .locals 18
    .param p1, "filePath"    # Ljava/lang/String;

    .prologue
    .line 374
    new-instance v11, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v11}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    .line 375
    .local v11, "options":Landroid/graphics/BitmapFactory$Options;
    const/4 v15, 0x1

    iput-boolean v15, v11, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 376
    move-object/from16 v0, p1

    invoke-static {v0, v11}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    .line 379
    const/4 v15, 0x1

    iput v15, v11, Landroid/graphics/BitmapFactory$Options;->inSampleSize:I

    .line 382
    const/4 v15, 0x0

    iput-boolean v15, v11, Landroid/graphics/BitmapFactory$Options;->inJustDecodeBounds:Z

    .line 384
    sget-object v15, Landroid/graphics/Bitmap$Config;->RGB_565:Landroid/graphics/Bitmap$Config;

    iput-object v15, v11, Landroid/graphics/BitmapFactory$Options;->inPreferredConfig:Landroid/graphics/Bitmap$Config;

    .line 385
    const/4 v15, 0x1

    iput-boolean v15, v11, Landroid/graphics/BitmapFactory$Options;->inDither:Z

    .line 387
    move-object/from16 v0, p1

    invoke-static {v0, v11}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;Landroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object v3

    .line 389
    .local v3, "bm":Landroid/graphics/Bitmap;
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v15

    int-to-float v15, v15

    sget v16, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v15, v15, v16

    if-gtz v15, :cond_0

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v15

    int-to-float v15, v15

    sget v16, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v15, v15, v16

    if-lez v15, :cond_1

    .line 391
    :cond_0
    sget v15, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v16

    move/from16 v0, v16

    int-to-float v0, v0

    move/from16 v16, v0

    div-float v15, v15, v16

    sget v16, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v17

    move/from16 v0, v17

    int-to-float v0, v0

    move/from16 v17, v0

    div-float v16, v16, v17

    invoke-static/range {v15 .. v16}, Ljava/lang/Math;->min(FF)F

    move-result v12

    .line 392
    .local v12, "scale":F
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v15

    int-to-float v15, v15

    mul-float v14, v15, v12

    .line 393
    .local v14, "scaleW":F
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v15

    int-to-float v15, v15

    mul-float v13, v15, v12

    .line 395
    .local v13, "scaleH":F
    float-to-int v15, v14

    float-to-int v0, v13

    move/from16 v16, v0

    move/from16 v0, v16

    invoke-static {v3, v15, v0}, Landroid/media/ThumbnailUtils;->extractThumbnail(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;

    move-result-object v3

    .line 398
    .end local v12    # "scale":F
    .end local v13    # "scaleH":F
    .end local v14    # "scaleW":F
    :cond_1
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 399
    .local v2, "baos":Ljava/io/ByteArrayOutputStream;
    const/16 v5, 0x64

    .line 400
    .local v5, "coptions":I
    sget-object v15, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    invoke-virtual {v3, v15, v5, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 402
    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v15

    int-to-float v15, v15

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v16

    move/from16 v0, v16

    int-to-float v0, v0

    move/from16 v16, v0

    move-object/from16 v0, p0

    move/from16 v1, v16

    invoke-virtual {v0, v15, v1}, Lcom/qianniao/ImagePicker;->getImageMaxDataLen(FF)F

    move-result v8

    .line 404
    .local v8, "maxDataSize":F
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v15

    array-length v15, v15

    int-to-float v6, v15

    .line 405
    .local v6, "currDataSize":F
    :goto_0
    cmpl-float v15, v6, v8

    if-lez v15, :cond_2

    .line 406
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->reset()V

    .line 407
    add-int/lit8 v5, v5, -0xa

    .line 408
    sget-object v15, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    invoke-virtual {v3, v15, v5, v2}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 409
    sget-object v15, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v16, Ljava/lang/StringBuilder;

    invoke-direct/range {v16 .. v16}, Ljava/lang/StringBuilder;-><init>()V

    const-string v17, "\u56fe\u7247\u538b\u7f29\u540e\uff1a"

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v17

    move-object/from16 v0, v17

    array-length v0, v0

    move/from16 v17, v0

    move/from16 v0, v17

    div-int/lit16 v0, v0, 0x400

    move/from16 v17, v0

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v16

    const-string v17, "KB"

    invoke-virtual/range {v16 .. v17}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v16

    invoke-virtual/range {v16 .. v16}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v16

    invoke-static/range {v15 .. v16}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 411
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v15

    array-length v15, v15

    int-to-float v15, v15

    cmpl-float v15, v15, v6

    if-nez v15, :cond_3

    .line 417
    :cond_2
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    move-object/from16 v0, p0

    iget-object v0, v0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    move-object/from16 v16, v0

    invoke-virtual/range {v15 .. v16}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v15

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v16

    invoke-virtual/range {v15 .. v17}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v15

    const-string v16, ".png"

    invoke-virtual/range {v15 .. v16}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v15

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    .line 418
    .local v10, "newFilePath":Ljava/lang/String;
    new-instance v9, Ljava/io/File;

    invoke-direct {v9, v10}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 420
    .local v9, "myFile":Ljava/io/File;
    :try_start_0
    new-instance v4, Ljava/io/BufferedOutputStream;

    new-instance v15, Ljava/io/FileOutputStream;

    invoke-direct {v15, v9}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v4, v15}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 421
    .local v4, "bos":Ljava/io/BufferedOutputStream;
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v15

    invoke-virtual {v4, v15}, Ljava/io/BufferedOutputStream;->write([B)V

    .line 422
    invoke-virtual {v4}, Ljava/io/BufferedOutputStream;->flush()V

    .line 423
    invoke-virtual {v4}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 428
    .end local v4    # "bos":Ljava/io/BufferedOutputStream;
    :goto_1
    return-object v10

    .line 414
    .end local v9    # "myFile":Ljava/io/File;
    .end local v10    # "newFilePath":Ljava/lang/String;
    :cond_3
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v15

    array-length v15, v15

    int-to-float v6, v15

    goto/16 :goto_0

    .line 424
    .restart local v9    # "myFile":Ljava/io/File;
    .restart local v10    # "newFilePath":Ljava/lang/String;
    :catch_0
    move-exception v7

    .line 425
    .local v7, "ex":Ljava/lang/Exception;
    invoke-virtual {v7}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1
.end method

.method _openCamera()V
    .locals 3

    .prologue
    .line 239
    new-instance v1, Ljava/io/File;

    sget-object v2, Lcom/qianniao/ImagePicker;->IMAGE_FILE_LOCATION:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Landroid/net/Uri;->fromFile(Ljava/io/File;)Landroid/net/Uri;

    move-result-object v1

    iput-object v1, p0, Lcom/qianniao/ImagePicker;->imagePhotoUri:Landroid/net/Uri;

    .line 241
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.media.action.IMAGE_CAPTURE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 242
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "output"

    iget-object v2, p0, Lcom/qianniao/ImagePicker;->imagePhotoUri:Landroid/net/Uri;

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 243
    const-string v1, "outputFormat"

    sget-object v2, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    invoke-virtual {v2}, Landroid/graphics/Bitmap$CompressFormat;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 244
    const-string v1, "return-data"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Z)Landroid/content/Intent;

    .line 246
    iget-object v1, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    const/4 v2, 0x1

    invoke-virtual {v1, v0, v2}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 247
    return-void
.end method

.method public _setImageDataSize(II)V
    .locals 1
    .param p1, "max"    # I
    .param p2, "min"    # I

    .prologue
    .line 261
    int-to-float v0, p1

    iput v0, p0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    .line 262
    int-to-float v0, p2

    iput v0, p0, Lcom/qianniao/ImagePicker;->minFileSize:F

    .line 263
    return-void
.end method

.method public copyFile(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 12
    .param p1, "filePath"    # Ljava/lang/String;
    .param p2, "fileType"    # Ljava/lang/String;

    .prologue
    .line 476
    :try_start_0
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 477
    .local v2, "file":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->length()J

    move-result-wide v4

    .line 478
    .local v4, "fileLen":J
    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, v2}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 480
    .local v3, "inputStream":Ljava/io/FileInputStream;
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v9, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v10

    invoke-virtual {v8, v10, v11}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 481
    .local v6, "newFilePath":Ljava/lang/String;
    new-instance v7, Ljava/io/FileOutputStream;

    invoke-direct {v7, v6}, Ljava/io/FileOutputStream;-><init>(Ljava/lang/String;)V

    .line 483
    .local v7, "outputStream":Ljava/io/FileOutputStream;
    long-to-int v8, v4

    new-array v0, v8, [B

    .line 484
    .local v0, "b":[B
    invoke-virtual {v3, v0}, Ljava/io/FileInputStream;->read([B)I

    .line 485
    invoke-virtual {v3}, Ljava/io/FileInputStream;->close()V

    .line 487
    invoke-virtual {v7, v0}, Ljava/io/FileOutputStream;->write([B)V

    .line 488
    invoke-virtual {v7}, Ljava/io/FileOutputStream;->flush()V

    .line 489
    invoke-virtual {v7}, Ljava/io/FileOutputStream;->close()V

    .line 491
    sget-object v8, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    const-string v10, "startPhotoZoom: "

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v8, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 498
    .end local v0    # "b":[B
    .end local v2    # "file":Ljava/io/File;
    .end local v3    # "inputStream":Ljava/io/FileInputStream;
    .end local v4    # "fileLen":J
    .end local v6    # "newFilePath":Ljava/lang/String;
    .end local v7    # "outputStream":Ljava/io/FileOutputStream;
    :goto_0
    return-object v6

    .line 494
    :catch_0
    move-exception v1

    .line 495
    .local v1, "e":Ljava/io/IOException;
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    .line 498
    const-string v6, ""

    goto :goto_0
.end method

.method public getImageMaxDataLen(FF)F
    .locals 7
    .param p1, "w"    # F
    .param p2, "h"    # F

    .prologue
    .line 71
    sget v4, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v4, p1, v4

    if-gtz v4, :cond_0

    sget v4, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v4, p2, v4

    if-lez v4, :cond_1

    .line 72
    :cond_0
    sget v4, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    div-float/2addr v4, p1

    sget v5, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    div-float/2addr v5, p2

    invoke-static {v4, v5}, Ljava/lang/Math;->min(FF)F

    move-result v3

    .line 73
    .local v3, "scale":F
    mul-float/2addr p1, v3

    .line 74
    mul-float/2addr p2, v3

    .line 77
    .end local v3    # "scale":F
    :cond_1
    mul-float v0, p1, p2

    .line 78
    .local v0, "area":F
    iget v4, p0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    sget v5, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    sget v6, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    mul-float/2addr v5, v6

    const/high16 v6, 0x3f800000    # 1.0f

    mul-float/2addr v5, v6

    div-float v2, v4, v5

    .line 80
    .local v2, "prop":F
    mul-float v1, v0, v2

    .line 82
    .local v1, "maxDataLen":F
    iget v4, p0, Lcom/qianniao/ImagePicker;->minFileSize:F

    cmpg-float v4, v1, v4

    if-gez v4, :cond_2

    .line 83
    iget v1, p0, Lcom/qianniao/ImagePicker;->minFileSize:F

    .line 86
    :cond_2
    return v1
.end method

.method public insertVideoToMediaStore(Landroid/content/Context;Ljava/lang/String;JIIJ)Z
    .locals 5
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "filePath"    # Ljava/lang/String;
    .param p3, "createTime"    # J
    .param p5, "width"    # I
    .param p6, "height"    # I
    .param p7, "duration"    # J

    .prologue
    .line 173
    invoke-static {p3, p4}, Lcom/qianniao/ImagePicker;->getTimeWrap(J)J

    move-result-wide p3

    .line 174
    invoke-static {p2, p3, p4}, Lcom/qianniao/ImagePicker;->initCommonContentValues(Ljava/lang/String;J)Landroid/content/ContentValues;

    move-result-object v1

    .line 175
    .local v1, "values":Landroid/content/ContentValues;
    const-string v2, "datetaken"

    invoke-static {p3, p4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 176
    const-wide/16 v2, 0x0

    cmp-long v2, p7, v2

    if-lez v2, :cond_0

    .line 177
    const-string v2, "duration"

    invoke-static {p7, p8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 178
    :cond_0
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x10

    if-le v2, v3, :cond_2

    .line 179
    if-lez p5, :cond_1

    const-string v2, "width"

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 180
    :cond_1
    if-lez p6, :cond_2

    const-string v2, "height"

    invoke-static {p6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 182
    :cond_2
    const-string v2, "mime_type"

    invoke-static {p2}, Lcom/qianniao/ImagePicker;->getVideoMimeType(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 183
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    sget-object v3, Landroid/provider/MediaStore$Video$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {v2, v3, v1}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object v0

    .line 185
    .local v0, "uri":Landroid/net/Uri;
    if-eqz v0, :cond_3

    const/4 v2, 0x1

    :goto_0
    return v2

    :cond_3
    const/4 v2, 0x0

    goto :goto_0
.end method

.method isFolderExists(Ljava/lang/String;)Z
    .locals 3
    .param p1, "strFolder"    # Ljava/lang/String;

    .prologue
    const/4 v1, 0x1

    .line 189
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 190
    .local v0, "file":Ljava/io/File;
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    .line 191
    invoke-virtual {v0}, Ljava/io/File;->mkdirs()Z

    move-result v2

    if-eqz v2, :cond_1

    .line 198
    :cond_0
    :goto_0
    return v1

    .line 194
    :cond_1
    const/4 v1, 0x0

    goto :goto_0
.end method

.method public onActivityResult(IILandroid/content/Intent;)V
    .locals 6
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .prologue
    .line 288
    if-nez p2, :cond_1

    .line 333
    :cond_0
    :goto_0
    return-void

    .line 291
    :cond_1
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "onActivityResult: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 293
    const/4 v3, 0x1

    if-ne p1, v3, :cond_3

    .line 295
    sget-object v3, Lcom/qianniao/ImagePicker;->IMAGE_FILE_LOCATION:Ljava/lang/String;

    invoke-static {v3}, Landroid/graphics/BitmapFactory;->decodeFile(Ljava/lang/String;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 297
    .local v0, "bitmap":Landroid/graphics/Bitmap;
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ".jpg"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 298
    .local v1, "head_img_name":Ljava/lang/String;
    invoke-virtual {p0, v0, v1}, Lcom/qianniao/ImagePicker;->saveFile(Landroid/graphics/Bitmap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 300
    .local v2, "newFilePath":Ljava/lang/String;
    if-eqz v0, :cond_2

    .line 301
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 303
    :cond_2
    invoke-static {v2}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V

    .line 306
    .end local v0    # "bitmap":Landroid/graphics/Bitmap;
    .end local v1    # "head_img_name":Ljava/lang/String;
    .end local v2    # "newFilePath":Ljava/lang/String;
    :cond_3
    const/4 v3, 0x2

    if-ne p1, v3, :cond_6

    .line 309
    if-nez p3, :cond_4

    .line 311
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    const-string v4, "data is null"

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 314
    :cond_4
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v3

    if-nez v3, :cond_5

    .line 316
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    const-string v4, "data.getData() is null"

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 319
    :cond_5
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {p0, v3}, Lcom/qianniao/ImagePicker;->startPhotoZoom(Landroid/net/Uri;)V

    .line 323
    :cond_6
    const/4 v3, 0x3

    if-ne p1, v3, :cond_0

    .line 325
    sget-object v3, Lcom/qianniao/ImagePicker;->imgUri:Landroid/net/Uri;

    invoke-direct {p0, v3}, Lcom/qianniao/ImagePicker;->decodeUriAsBitmap(Landroid/net/Uri;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 326
    .restart local v0    # "bitmap":Landroid/graphics/Bitmap;
    if-nez v0, :cond_7

    .line 328
    sget-object v3, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    const-string v4, "bitmap is null"

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 330
    :cond_7
    const-string v3, "ImageCrop"

    const-string v4, "\u56fe\u7247\u5df2\u7ecf\u4fdd\u5b58\uff0c\u901a\u77e5c++\u5c42\uff0c"

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 331
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v4, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    sget-object v4, Lcom/qianniao/ImagePicker;->photoName:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V

    goto/16 :goto_0
.end method

.method public saveFile(Landroid/graphics/Bitmap;Ljava/lang/String;)Ljava/lang/String;
    .locals 15
    .param p1, "bm"    # Landroid/graphics/Bitmap;
    .param p2, "imgName"    # Ljava/lang/String;

    .prologue
    .line 433
    new-instance v3, Ljava/io/File;

    iget-object v12, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-direct {v3, v12}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 434
    .local v3, "dirFile":Ljava/io/File;
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v12

    if-nez v12, :cond_0

    .line 435
    invoke-virtual {v3}, Ljava/io/File;->mkdir()Z

    .line 438
    :cond_0
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    int-to-float v12, v12

    sget v13, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v12, v12, v13

    if-gtz v12, :cond_1

    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v12

    int-to-float v12, v12

    sget v13, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    cmpl-float v12, v12, v13

    if-lez v12, :cond_2

    .line 440
    :cond_1
    sget v12, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v13

    int-to-float v13, v13

    div-float/2addr v12, v13

    sget v13, Lcom/qianniao/ImagePicker;->MAX_IMAGE_WIDTH:F

    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v14

    int-to-float v14, v14

    div-float/2addr v13, v14

    invoke-static {v12, v13}, Ljava/lang/Math;->min(FF)F

    move-result v9

    .line 441
    .local v9, "scale":F
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    int-to-float v12, v12

    mul-float v11, v12, v9

    .line 442
    .local v11, "scaleW":F
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v12

    int-to-float v12, v12

    mul-float v10, v12, v9

    .line 444
    .local v10, "scaleH":F
    float-to-int v12, v11

    float-to-int v13, v10

    move-object/from16 v0, p1

    invoke-static {v0, v12, v13}, Landroid/media/ThumbnailUtils;->extractThumbnail(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;

    move-result-object p1

    .line 447
    .end local v9    # "scale":F
    .end local v10    # "scaleH":F
    .end local v11    # "scaleW":F
    :cond_2
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 448
    .local v1, "baos":Ljava/io/ByteArrayOutputStream;
    const/16 v8, 0x64

    .line 449
    .local v8, "options":I
    sget-object v12, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    move-object/from16 v0, p1

    invoke-virtual {v0, v12, v8, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 451
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v12

    int-to-float v12, v12

    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v13

    int-to-float v13, v13

    invoke-virtual {p0, v12, v13}, Lcom/qianniao/ImagePicker;->getImageMaxDataLen(FF)F

    move-result v5

    .line 453
    .local v5, "maxDataSize":F
    :goto_0
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v12

    array-length v12, v12

    int-to-float v12, v12

    cmpl-float v12, v12, v5

    if-lez v12, :cond_3

    .line 454
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->reset()V

    .line 455
    add-int/lit8 v8, v8, -0xa

    .line 456
    sget-object v12, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    move-object/from16 v0, p1

    invoke-virtual {v0, v12, v8, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 457
    sget-object v12, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-string v14, "\u56fe\u7247\u538b\u7f29\u540e\uff1a"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v14

    array-length v14, v14

    div-int/lit16 v14, v14, 0x400

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v13

    const-string v14, "KB"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v12, v13}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 460
    :cond_3
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v13, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    move-object/from16 v0, p2

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 461
    .local v7, "newFilePath":Ljava/lang/String;
    new-instance v6, Ljava/io/File;

    invoke-direct {v6, v7}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 463
    .local v6, "myFile":Ljava/io/File;
    :try_start_0
    new-instance v2, Ljava/io/BufferedOutputStream;

    new-instance v12, Ljava/io/FileOutputStream;

    invoke-direct {v12, v6}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v2, v12}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 464
    .local v2, "bos":Ljava/io/BufferedOutputStream;
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v12

    invoke-virtual {v2, v12}, Ljava/io/BufferedOutputStream;->write([B)V

    .line 465
    invoke-virtual {v2}, Ljava/io/BufferedOutputStream;->flush()V

    .line 466
    invoke-virtual {v2}, Ljava/io/BufferedOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 471
    .end local v2    # "bos":Ljava/io/BufferedOutputStream;
    :goto_1
    return-object v7

    .line 467
    :catch_0
    move-exception v4

    .line 468
    .local v4, "ex":Ljava/lang/Exception;
    invoke-virtual {v4}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1
.end method

.method public setAppActivity(Landroid/app/Activity;)V
    .locals 0
    .param p1, "activity"    # Landroid/app/Activity;

    .prologue
    .line 92
    iput-object p1, p0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    .line 93
    return-void
.end method

.method public setSaveDirectory(Ljava/lang/String;)V
    .locals 0
    .param p1, "dire"    # Ljava/lang/String;

    .prologue
    .line 97
    iput-object p1, p0, Lcom/qianniao/ImagePicker;->savePath:Ljava/lang/String;

    .line 98
    return-void
.end method

.method public startPhotoZoom(Landroid/net/Uri;)V
    .locals 21
    .param p1, "uri"    # Landroid/net/Uri;

    .prologue
    .line 504
    const/16 v19, 0x0

    .line 506
    .local v19, "size":I
    :try_start_0
    new-instance v20, Ljava/io/File;

    invoke-virtual/range {p1 .. p1}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    move-result-object v2

    move-object/from16 v0, v20

    invoke-direct {v0, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 508
    .local v20, "srcfile":Ljava/io/File;
    move-object/from16 v0, p0

    iget-object v2, v0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object/from16 v3, p1

    invoke-virtual/range {v2 .. v7}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v9

    .line 509
    .local v9, "cursor":Landroid/database/Cursor;
    invoke-interface {v9}, Landroid/database/Cursor;->moveToFirst()Z

    .line 510
    sget-object v2, Lcom/qianniao/ImagePicker;->TAG:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, ""

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const/4 v4, 0x0

    invoke-interface {v9, v4}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ","

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const/4 v4, 0x1

    invoke-interface {v9, v4}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ","

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const/4 v4, 0x2

    invoke-interface {v9, v4}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 512
    const/4 v2, 0x1

    invoke-interface {v9, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v15

    .line 514
    .local v15, "filePath":Ljava/lang/String;
    invoke-virtual/range {p1 .. p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "file://"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    invoke-virtual/range {p1 .. p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "content://"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 515
    :cond_0
    const-string v2, ".jpg"

    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    const-string v2, ".png"

    .line 516
    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    const-string v2, ".jpeg"

    .line 517
    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    const-string v2, ".gif"

    .line 518
    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    const-string v2, ".mp4"

    .line 519
    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 520
    move-object/from16 v0, p0

    iget-object v2, v0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    const-string v3, "\u4e0d\u652f\u6301\u8be5\u683c\u5f0f"

    const/4 v4, 0x0

    invoke-static {v2, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 568
    .end local v9    # "cursor":Landroid/database/Cursor;
    .end local v15    # "filePath":Ljava/lang/String;
    .end local v20    # "srcfile":Ljava/io/File;
    :goto_0
    return-void

    .line 525
    .restart local v9    # "cursor":Landroid/database/Cursor;
    .restart local v15    # "filePath":Ljava/lang/String;
    .restart local v20    # "srcfile":Ljava/io/File;
    :cond_1
    const-string v2, ".mp4"

    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_5

    .line 526
    invoke-virtual/range {v20 .. v20}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-float v2, v2

    move-object/from16 v0, p0

    iget v3, v0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    cmpl-float v2, v2, v3

    if-lez v2, :cond_2

    .line 528
    const-string v2, "1"

    invoke-static {v2}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 564
    .end local v9    # "cursor":Landroid/database/Cursor;
    .end local v15    # "filePath":Ljava/lang/String;
    .end local v20    # "srcfile":Ljava/io/File;
    :catch_0
    move-exception v10

    .line 565
    .local v10, "e":Ljava/io/IOException;
    invoke-virtual {v10}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 532
    .end local v10    # "e":Ljava/io/IOException;
    .restart local v9    # "cursor":Landroid/database/Cursor;
    .restart local v15    # "filePath":Ljava/lang/String;
    .restart local v20    # "srcfile":Ljava/io/File;
    :cond_2
    :try_start_1
    new-instance v11, Ljava/io/File;

    invoke-direct {v11, v15}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 533
    .local v11, "file":Ljava/io/File;
    invoke-virtual {v11}, Ljava/io/File;->length()J

    move-result-wide v12

    .line 535
    .local v12, "fileLen":J
    long-to-float v2, v12

    move-object/from16 v0, p0

    iget v3, v0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    cmpl-float v2, v2, v3

    if-lez v2, :cond_3

    .line 537
    move-object/from16 v0, p0

    iget-object v2, v0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    const-string v3, "\u89c6\u9891\u6587\u4ef6\u8fc7\u5927"

    const/4 v4, 0x0

    invoke-static {v2, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 541
    :cond_3
    move-object/from16 v0, p0

    invoke-virtual {v0, v15}, Lcom/qianniao/ImagePicker;->_getDuration(Ljava/lang/String;)I

    move-result v19

    .line 543
    const v2, 0xea60

    move/from16 v0, v19

    if-gt v0, v2, :cond_4

    .line 544
    const-string v2, ".mp4"

    move-object/from16 v0, p0

    invoke-virtual {v0, v15, v2}, Lcom/qianniao/ImagePicker;->copyFile(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    .line 545
    .local v14, "fileName":Ljava/lang/String;
    invoke-static {v14}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V

    goto :goto_0

    .line 547
    .end local v14    # "fileName":Ljava/lang/String;
    :cond_4
    move-object/from16 v0, p0

    iget-object v2, v0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    const-string v3, "\u53ea\u652f\u6301\u4e0a\u4f201\u5206\u949f\u4e4b\u5185\u7684\u89c6\u9891"

    const/4 v4, 0x0

    invoke-static {v2, v3, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 549
    .end local v11    # "file":Ljava/io/File;
    .end local v12    # "fileLen":J
    :cond_5
    const-string v2, ".gif"

    invoke-virtual {v15, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_7

    .line 550
    invoke-virtual/range {v20 .. v20}, Ljava/io/File;->length()J

    move-result-wide v2

    long-to-float v2, v2

    move-object/from16 v0, p0

    iget v3, v0, Lcom/qianniao/ImagePicker;->maxFileSize:F

    cmpl-float v2, v2, v3

    if-lez v2, :cond_6

    .line 552
    const-string v2, "1"

    invoke-static {v2}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 555
    :cond_6
    const-string v2, ".gif"

    move-object/from16 v0, p0

    invoke-virtual {v0, v15, v2}, Lcom/qianniao/ImagePicker;->copyFile(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    .line 556
    .restart local v14    # "fileName":Ljava/lang/String;
    invoke-static {v14}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 558
    .end local v14    # "fileName":Ljava/lang/String;
    :cond_7
    move-object/from16 v0, p0

    iget-object v2, v0, Lcom/qianniao/ImagePicker;->activity:Landroid/app/Activity;

    invoke-virtual {v2}, Landroid/app/Activity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v18

    .line 559
    .local v18, "resolver":Landroid/content/ContentResolver;
    move-object/from16 v0, v18

    move-object/from16 v1, p1

    invoke-static {v0, v1}, Landroid/provider/MediaStore$Images$Media;->getBitmap(Landroid/content/ContentResolver;Landroid/net/Uri;)Landroid/graphics/Bitmap;

    move-result-object v8

    .line 560
    .local v8, "bitmap":Landroid/graphics/Bitmap;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ".jpg"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v16

    .line 561
    .local v16, "head_img_name":Ljava/lang/String;
    move-object/from16 v0, p0

    move-object/from16 v1, v16

    invoke-virtual {v0, v8, v1}, Lcom/qianniao/ImagePicker;->saveFile(Landroid/graphics/Bitmap;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v17

    .line 562
    .local v17, "newFilePath":Ljava/lang/String;
    invoke-static/range {v17 .. v17}, Lcom/qianniao/ImagePicker;->onImageSaved(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0
.end method
