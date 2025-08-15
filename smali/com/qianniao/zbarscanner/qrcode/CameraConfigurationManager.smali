.class final Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;
.super Ljava/lang/Object;
.source "CameraConfigurationManager.java"


# static fields
.field private static final COMMA_PATTERN:Ljava/util/regex/Pattern;

.field private static final TEN_DESIRED_ZOOM:I = 0x1b


# instance fields
.field private cameraResolution:Landroid/graphics/Point;

.field private final mContext:Landroid/content/Context;

.field private mScreenResolution:Landroid/graphics/Point;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 15
    const-string v0, ","

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->COMMA_PATTERN:Ljava/util/regex/Pattern;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 21
    iput-object p1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mContext:Landroid/content/Context;

    .line 22
    return-void
.end method

.method private doSetTorch(Landroid/hardware/Camera;Z)V
    .locals 7
    .param p1, "camera"    # Landroid/hardware/Camera;
    .param p2, "newSetting"    # Z

    .prologue
    const/4 v6, 0x1

    const/4 v5, 0x0

    .line 60
    invoke-virtual {p1}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v1

    .line 63
    .local v1, "parameters":Landroid/hardware/Camera$Parameters;
    if-eqz p2, :cond_1

    .line 64
    invoke-virtual {v1}, Landroid/hardware/Camera$Parameters;->getSupportedFlashModes()Ljava/util/List;

    move-result-object v2

    const/4 v3, 0x2

    new-array v3, v3, [Ljava/lang/String;

    const-string v4, "torch"

    aput-object v4, v3, v5

    const-string v4, "on"

    aput-object v4, v3, v6

    invoke-static {v2, v3}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->findSettableValue(Ljava/util/Collection;[Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 68
    .local v0, "flashMode":Ljava/lang/String;
    :goto_0
    if-eqz v0, :cond_0

    .line 69
    invoke-virtual {v1, v0}, Landroid/hardware/Camera$Parameters;->setFlashMode(Ljava/lang/String;)V

    .line 71
    :cond_0
    invoke-virtual {p1, v1}, Landroid/hardware/Camera;->setParameters(Landroid/hardware/Camera$Parameters;)V

    .line 72
    return-void

    .line 66
    .end local v0    # "flashMode":Ljava/lang/String;
    :cond_1
    invoke-virtual {v1}, Landroid/hardware/Camera$Parameters;->getSupportedFlashModes()Ljava/util/List;

    move-result-object v2

    new-array v3, v6, [Ljava/lang/String;

    const-string v4, "off"

    aput-object v4, v3, v5

    invoke-static {v2, v3}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->findSettableValue(Ljava/util/Collection;[Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .restart local v0    # "flashMode":Ljava/lang/String;
    goto :goto_0
.end method

.method private static findBestMotZoomValue(Ljava/lang/CharSequence;I)I
    .locals 14
    .param p0, "stringValues"    # Ljava/lang/CharSequence;
    .param p1, "tenDesiredZoom"    # I

    .prologue
    .line 176
    const/4 v2, 0x0

    .line 177
    .local v2, "tenBestValue":I
    sget-object v6, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->COMMA_PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v6, p0}, Ljava/util/regex/Pattern;->split(Ljava/lang/CharSequence;)[Ljava/lang/String;

    move-result-object v7

    array-length v8, v7

    const/4 v6, 0x0

    :goto_0
    if-ge v6, v8, :cond_1

    aget-object v1, v7, v6

    .line 178
    .local v1, "stringValue":Ljava/lang/String;
    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    .line 181
    :try_start_0
    invoke-static {v1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-wide v4

    .line 185
    .local v4, "value":D
    const-wide/high16 v10, 0x4024000000000000L    # 10.0

    mul-double/2addr v10, v4

    double-to-int v3, v10

    .line 186
    .local v3, "tenValue":I
    int-to-double v10, p1

    sub-double/2addr v10, v4

    invoke-static {v10, v11}, Ljava/lang/Math;->abs(D)D

    move-result-wide v10

    sub-int v9, p1, v2

    invoke-static {v9}, Ljava/lang/Math;->abs(I)I

    move-result v9

    int-to-double v12, v9

    cmpg-double v9, v10, v12

    if-gez v9, :cond_0

    .line 188
    move v2, v3

    .line 177
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 182
    .end local v3    # "tenValue":I
    .end local v4    # "value":D
    :catch_0
    move-exception v0

    .line 191
    .end local v1    # "stringValue":Ljava/lang/String;
    .end local p1    # "tenDesiredZoom":I
    :goto_1
    return p1

    .restart local p1    # "tenDesiredZoom":I
    :cond_1
    move p1, v2

    goto :goto_1
.end method

.method private static findBestPreviewSizeValue(Ljava/lang/CharSequence;Landroid/graphics/Point;)Landroid/graphics/Point;
    .locals 14
    .param p0, "previewSizeValueString"    # Ljava/lang/CharSequence;
    .param p1, "screenResolution"    # Landroid/graphics/Point;

    .prologue
    const/4 v9, 0x0

    .line 136
    const/4 v0, 0x0

    .line 137
    .local v0, "bestX":I
    const/4 v1, 0x0

    .line 138
    .local v1, "bestY":I
    const v2, 0x7fffffff

    .line 139
    .local v2, "diff":I
    sget-object v10, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->COMMA_PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v10, p0}, Ljava/util/regex/Pattern;->split(Ljava/lang/CharSequence;)[Ljava/lang/String;

    move-result-object v10

    array-length v11, v10

    :goto_0
    if-ge v9, v11, :cond_2

    aget-object v8, v10, v9

    .line 141
    .local v8, "previewSize":Ljava/lang/String;
    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    .line 142
    const/16 v12, 0x78

    invoke-virtual {v8, v12}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    .line 143
    .local v3, "dimPosition":I
    if-gez v3, :cond_1

    .line 139
    :cond_0
    :goto_1
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 150
    :cond_1
    const/4 v12, 0x0

    :try_start_0
    invoke-virtual {v8, v12, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v5

    .line 151
    .local v5, "newX":I
    add-int/lit8 v12, v3, 0x1

    invoke-virtual {v8, v12}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v6

    .line 156
    .local v6, "newY":I
    iget v12, p1, Landroid/graphics/Point;->x:I

    sub-int v12, v5, v12

    invoke-static {v12}, Ljava/lang/Math;->abs(I)I

    move-result v12

    iget v13, p1, Landroid/graphics/Point;->y:I

    sub-int v13, v6, v13

    invoke-static {v13}, Ljava/lang/Math;->abs(I)I

    move-result v13

    add-int v4, v12, v13

    .line 157
    .local v4, "newDiff":I
    if-nez v4, :cond_3

    .line 158
    move v0, v5

    .line 159
    move v1, v6

    .line 169
    .end local v3    # "dimPosition":I
    .end local v4    # "newDiff":I
    .end local v5    # "newX":I
    .end local v6    # "newY":I
    .end local v8    # "previewSize":Ljava/lang/String;
    :cond_2
    if-lez v0, :cond_4

    if-lez v1, :cond_4

    .line 170
    new-instance v9, Landroid/graphics/Point;

    invoke-direct {v9, v0, v1}, Landroid/graphics/Point;-><init>(II)V

    .line 172
    :goto_2
    return-object v9

    .line 152
    .restart local v3    # "dimPosition":I
    .restart local v8    # "previewSize":Ljava/lang/String;
    :catch_0
    move-exception v7

    .line 153
    .local v7, "nfe":Ljava/lang/NumberFormatException;
    goto :goto_1

    .line 161
    .end local v7    # "nfe":Ljava/lang/NumberFormatException;
    .restart local v4    # "newDiff":I
    .restart local v5    # "newX":I
    .restart local v6    # "newY":I
    :cond_3
    if-ge v4, v2, :cond_0

    .line 162
    move v0, v5

    .line 163
    move v1, v6

    .line 164
    move v2, v4

    goto :goto_1

    .line 172
    .end local v3    # "dimPosition":I
    .end local v4    # "newDiff":I
    .end local v5    # "newX":I
    .end local v6    # "newY":I
    .end local v8    # "previewSize":Ljava/lang/String;
    :cond_4
    const/4 v9, 0x0

    goto :goto_2
.end method

.method private static varargs findSettableValue(Ljava/util/Collection;[Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p1, "desiredValues"    # [Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Collection",
            "<",
            "Ljava/lang/String;",
            ">;[",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .prologue
    .line 75
    .local p0, "supportedValues":Ljava/util/Collection;, "Ljava/util/Collection<Ljava/lang/String;>;"
    const/4 v1, 0x0

    .line 76
    .local v1, "result":Ljava/lang/String;
    if-eqz p0, :cond_0

    .line 77
    array-length v3, p1

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v3, :cond_0

    aget-object v0, p1, v2

    .line 78
    .local v0, "desiredValue":Ljava/lang/String;
    invoke-interface {p0, v0}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 79
    move-object v1, v0

    .line 84
    .end local v0    # "desiredValue":Ljava/lang/String;
    :cond_0
    return-object v1

    .line 77
    .restart local v0    # "desiredValue":Ljava/lang/String;
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0
.end method

.method private static getCameraResolution(Landroid/hardware/Camera$Parameters;Landroid/graphics/Point;)Landroid/graphics/Point;
    .locals 4
    .param p0, "parameters"    # Landroid/hardware/Camera$Parameters;
    .param p1, "screenResolution"    # Landroid/graphics/Point;

    .prologue
    .line 121
    const-string v2, "preview-size-values"

    invoke-virtual {p0, v2}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 122
    .local v1, "previewSizeValueString":Ljava/lang/String;
    if-nez v1, :cond_0

    .line 123
    const-string v2, "preview-size-value"

    invoke-virtual {p0, v2}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 125
    :cond_0
    const/4 v0, 0x0

    .line 126
    .local v0, "cameraResolution":Landroid/graphics/Point;
    if-eqz v1, :cond_1

    .line 127
    invoke-static {v1, p1}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->findBestPreviewSizeValue(Ljava/lang/CharSequence;Landroid/graphics/Point;)Landroid/graphics/Point;

    move-result-object v0

    .line 129
    :cond_1
    if-nez v0, :cond_2

    .line 130
    new-instance v0, Landroid/graphics/Point;

    .end local v0    # "cameraResolution":Landroid/graphics/Point;
    iget v2, p1, Landroid/graphics/Point;->x:I

    shr-int/lit8 v2, v2, 0x3

    shl-int/lit8 v2, v2, 0x3

    iget v3, p1, Landroid/graphics/Point;->y:I

    shr-int/lit8 v3, v3, 0x3

    shl-int/lit8 v3, v3, 0x3

    invoke-direct {v0, v2, v3}, Landroid/graphics/Point;-><init>(II)V

    .line 132
    .restart local v0    # "cameraResolution":Landroid/graphics/Point;
    :cond_2
    return-object v0
.end method

.method private setZoom(Landroid/hardware/Camera$Parameters;)V
    .locals 18
    .param p1, "parameters"    # Landroid/hardware/Camera$Parameters;

    .prologue
    .line 196
    const-string v12, "zoom-supported"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    .line 197
    .local v11, "zoomSupportedString":Ljava/lang/String;
    if-eqz v11, :cond_1

    invoke-static {v11}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v12

    if-nez v12, :cond_1

    .line 248
    :cond_0
    :goto_0
    return-void

    .line 201
    :cond_1
    const/16 v8, 0x1b

    .line 203
    .local v8, "tenDesiredZoom":I
    const-string v12, "max-zoom"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 204
    .local v2, "maxZoomString":Ljava/lang/String;
    if-eqz v2, :cond_2

    .line 206
    const-wide/high16 v12, 0x4024000000000000L    # 10.0

    :try_start_0
    invoke-static {v2}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-wide v14

    mul-double/2addr v12, v14

    double-to-int v9, v12

    .line 207
    .local v9, "tenMaxZoom":I
    if-le v8, v9, :cond_2

    .line 208
    move v8, v9

    .line 214
    .end local v9    # "tenMaxZoom":I
    :cond_2
    :goto_1
    const-string v12, "taking-picture-zoom-max"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 215
    .local v7, "takingPictureZoomMaxString":Ljava/lang/String;
    if-eqz v7, :cond_3

    .line 217
    :try_start_1
    invoke-static {v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/NumberFormatException; {:try_start_1 .. :try_end_1} :catch_1

    move-result v9

    .line 218
    .restart local v9    # "tenMaxZoom":I
    if-le v8, v9, :cond_3

    .line 219
    move v8, v9

    .line 225
    .end local v9    # "tenMaxZoom":I
    :cond_3
    :goto_2
    const-string v12, "mot-zoom-values"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 226
    .local v6, "motZoomValuesString":Ljava/lang/String;
    if-eqz v6, :cond_4

    .line 227
    invoke-static {v6, v8}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->findBestMotZoomValue(Ljava/lang/CharSequence;I)I

    move-result v8

    .line 230
    :cond_4
    const-string v12, "mot-zoom-step"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12}, Landroid/hardware/Camera$Parameters;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 231
    .local v3, "motZoomStepString":Ljava/lang/String;
    if-eqz v3, :cond_5

    .line 233
    :try_start_2
    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v12

    invoke-static {v12}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v4

    .line 234
    .local v4, "motZoomStep":D
    const-wide/high16 v12, 0x4024000000000000L    # 10.0

    mul-double/2addr v12, v4

    double-to-int v10, v12

    .line 235
    .local v10, "tenZoomStep":I
    const/4 v12, 0x1

    if-le v10, v12, :cond_5

    .line 236
    rem-int v12, v8, v10
    :try_end_2
    .catch Ljava/lang/NumberFormatException; {:try_start_2 .. :try_end_2} :catch_2

    sub-int/2addr v8, v12

    .line 242
    .end local v4    # "motZoomStep":D
    .end local v10    # "tenZoomStep":I
    :cond_5
    :goto_3
    if-nez v2, :cond_6

    if-eqz v6, :cond_7

    .line 243
    :cond_6
    const-string v12, "zoom"

    int-to-double v14, v8

    const-wide/high16 v16, 0x4024000000000000L    # 10.0

    div-double v14, v14, v16

    invoke-static {v14, v15}, Ljava/lang/String;->valueOf(D)Ljava/lang/String;

    move-result-object v13

    move-object/from16 v0, p1

    invoke-virtual {v0, v12, v13}, Landroid/hardware/Camera$Parameters;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 245
    :cond_7
    if-eqz v7, :cond_0

    .line 246
    const-string v12, "taking-picture-zoom"

    move-object/from16 v0, p1

    invoke-virtual {v0, v12, v8}, Landroid/hardware/Camera$Parameters;->set(Ljava/lang/String;I)V

    goto :goto_0

    .line 210
    .end local v3    # "motZoomStepString":Ljava/lang/String;
    .end local v6    # "motZoomValuesString":Ljava/lang/String;
    .end local v7    # "takingPictureZoomMaxString":Ljava/lang/String;
    :catch_0
    move-exception v12

    goto :goto_1

    .line 221
    .restart local v7    # "takingPictureZoomMaxString":Ljava/lang/String;
    :catch_1
    move-exception v12

    goto :goto_2

    .line 238
    .restart local v3    # "motZoomStepString":Ljava/lang/String;
    .restart local v6    # "motZoomValuesString":Ljava/lang/String;
    :catch_2
    move-exception v12

    goto :goto_3
.end method


# virtual methods
.method public closeFlashlight(Landroid/hardware/Camera;)V
    .locals 1
    .param p1, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 56
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->doSetTorch(Landroid/hardware/Camera;Z)V

    .line 57
    return-void
.end method

.method public getDisplayOrientation()I
    .locals 8

    .prologue
    .line 88
    new-instance v2, Landroid/hardware/Camera$CameraInfo;

    invoke-direct {v2}, Landroid/hardware/Camera$CameraInfo;-><init>()V

    .line 89
    .local v2, "info":Landroid/hardware/Camera$CameraInfo;
    const/4 v6, 0x0

    invoke-static {v6, v2}, Landroid/hardware/Camera;->getCameraInfo(ILandroid/hardware/Camera$CameraInfo;)V

    .line 90
    iget-object v6, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mContext:Landroid/content/Context;

    const-string v7, "window"

    invoke-virtual {v6, v7}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/view/WindowManager;

    .line 91
    .local v5, "wm":Landroid/view/WindowManager;
    invoke-interface {v5}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    .line 93
    .local v1, "display":Landroid/view/Display;
    invoke-virtual {v1}, Landroid/view/Display;->getRotation()I

    move-result v4

    .line 94
    .local v4, "rotation":I
    const/4 v0, 0x0

    .line 95
    .local v0, "degrees":I
    packed-switch v4, :pswitch_data_0

    .line 111
    :goto_0
    iget v6, v2, Landroid/hardware/Camera$CameraInfo;->facing:I

    const/4 v7, 0x1

    if-ne v6, v7, :cond_0

    .line 112
    iget v6, v2, Landroid/hardware/Camera$CameraInfo;->orientation:I

    add-int/2addr v6, v0

    rem-int/lit16 v3, v6, 0x168

    .line 113
    .local v3, "result":I
    rsub-int v6, v3, 0x168

    rem-int/lit16 v3, v6, 0x168

    .line 117
    :goto_1
    return v3

    .line 97
    .end local v3    # "result":I
    :pswitch_0
    const/4 v0, 0x0

    .line 98
    goto :goto_0

    .line 100
    :pswitch_1
    const/16 v0, 0x5a

    .line 101
    goto :goto_0

    .line 103
    :pswitch_2
    const/16 v0, 0xb4

    .line 104
    goto :goto_0

    .line 106
    :pswitch_3
    const/16 v0, 0x10e

    goto :goto_0

    .line 115
    :cond_0
    iget v6, v2, Landroid/hardware/Camera$CameraInfo;->orientation:I

    sub-int/2addr v6, v0

    add-int/lit16 v6, v6, 0x168

    rem-int/lit16 v3, v6, 0x168

    .restart local v3    # "result":I
    goto :goto_1

    .line 95
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
    .end packed-switch
.end method

.method public initFromCameraParameters(Landroid/hardware/Camera;)V
    .locals 7
    .param p1, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 25
    invoke-virtual {p1}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v2

    .line 26
    .local v2, "parameters":Landroid/hardware/Camera$Parameters;
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mContext:Landroid/content/Context;

    const-string v5, "window"

    invoke-virtual {v4, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    .line 27
    .local v1, "manager":Landroid/view/WindowManager;
    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    .line 28
    .local v0, "display":Landroid/view/Display;
    new-instance v4, Landroid/graphics/Point;

    invoke-virtual {v0}, Landroid/view/Display;->getWidth()I

    move-result v5

    invoke-virtual {v0}, Landroid/view/Display;->getHeight()I

    move-result v6

    invoke-direct {v4, v5, v6}, Landroid/graphics/Point;-><init>(II)V

    iput-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    .line 29
    new-instance v3, Landroid/graphics/Point;

    invoke-direct {v3}, Landroid/graphics/Point;-><init>()V

    .line 30
    .local v3, "screenResolutionForCamera":Landroid/graphics/Point;
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v4, v4, Landroid/graphics/Point;->x:I

    iput v4, v3, Landroid/graphics/Point;->x:I

    .line 31
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v4, v4, Landroid/graphics/Point;->y:I

    iput v4, v3, Landroid/graphics/Point;->y:I

    .line 34
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v4, v4, Landroid/graphics/Point;->x:I

    iget-object v5, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v5, v5, Landroid/graphics/Point;->y:I

    if-ge v4, v5, :cond_0

    .line 35
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v4, v4, Landroid/graphics/Point;->y:I

    iput v4, v3, Landroid/graphics/Point;->x:I

    .line 36
    iget-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->mScreenResolution:Landroid/graphics/Point;

    iget v4, v4, Landroid/graphics/Point;->x:I

    iput v4, v3, Landroid/graphics/Point;->y:I

    .line 39
    :cond_0
    invoke-static {v2, v3}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->getCameraResolution(Landroid/hardware/Camera$Parameters;Landroid/graphics/Point;)Landroid/graphics/Point;

    move-result-object v4

    iput-object v4, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->cameraResolution:Landroid/graphics/Point;

    .line 40
    return-void
.end method

.method public openFlashlight(Landroid/hardware/Camera;)V
    .locals 1
    .param p1, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 52
    const/4 v0, 0x1

    invoke-direct {p0, p1, v0}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->doSetTorch(Landroid/hardware/Camera;Z)V

    .line 53
    return-void
.end method

.method public setDesiredCameraParameters(Landroid/hardware/Camera;)V
    .locals 3
    .param p1, "camera"    # Landroid/hardware/Camera;

    .prologue
    .line 43
    invoke-virtual {p1}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;

    move-result-object v0

    .line 44
    .local v0, "parameters":Landroid/hardware/Camera$Parameters;
    iget-object v1, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->cameraResolution:Landroid/graphics/Point;

    iget v1, v1, Landroid/graphics/Point;->x:I

    iget-object v2, p0, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->cameraResolution:Landroid/graphics/Point;

    iget v2, v2, Landroid/graphics/Point;->y:I

    invoke-virtual {v0, v1, v2}, Landroid/hardware/Camera$Parameters;->setPreviewSize(II)V

    .line 45
    invoke-direct {p0, v0}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->setZoom(Landroid/hardware/Camera$Parameters;)V

    .line 47
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/qrcode/CameraConfigurationManager;->getDisplayOrientation()I

    move-result v1

    invoke-virtual {p1, v1}, Landroid/hardware/Camera;->setDisplayOrientation(I)V

    .line 48
    invoke-virtual {p1, v0}, Landroid/hardware/Camera;->setParameters(Landroid/hardware/Camera$Parameters;)V

    .line 49
    return-void
.end method
