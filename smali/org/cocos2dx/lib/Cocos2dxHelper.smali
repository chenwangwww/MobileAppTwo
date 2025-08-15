.class public Lorg/cocos2dx/lib/Cocos2dxHelper;
.super Ljava/lang/Object;
.source "Cocos2dxHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;
    }
.end annotation


# static fields
.field private static final BOOST_TIME:I = 0x7

.field private static final PREFS_NAME:Ljava/lang/String; = "Cocos2dxPrefsFile"

.field private static final RUNNABLES_PER_FRAME:I = 0x5

.field private static final TAG:Ljava/lang/String;

.field private static connection:Landroid/content/ServiceConnection;

.field private static mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

.field private static onActivityResultListeners:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set",
            "<",
            "Landroid/preference/PreferenceManager$OnActivityResultListener;",
            ">;"
        }
    .end annotation
.end field

.field private static sAccelerometerEnabled:Z

.field private static sActivity:Landroid/app/Activity;

.field private static sActivityVisible:Z

.field private static sAssetManager:Landroid/content/res/AssetManager;

.field private static sAssetsPath:Ljava/lang/String;

.field private static sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

.field private static sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

.field private static sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

.field private static sCocos2dxHelperListener:Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;

.field private static sCompassEnabled:Z

.field private static sFileDirectory:Ljava/lang/String;

.field private static sInited:Z

.field private static sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;

.field private static sPackageName:Ljava/lang/String;

.field private static sVibrateService:Landroid/os/Vibrator;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 74
    const-class v0, Lorg/cocos2dx/lib/Cocos2dxHelper;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    .line 89
    sput-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    .line 91
    new-instance v0, Ljava/util/LinkedHashSet;

    invoke-direct {v0}, Ljava/util/LinkedHashSet;-><init>()V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->onActivityResultListeners:Ljava/util/Set;

    .line 92
    sput-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->sVibrateService:Landroid/os/Vibrator;

    .line 94
    sput-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    .line 99
    const-string v0, ""

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetsPath:Ljava/lang/String;

    .line 102
    sput-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;

    .line 112
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sInited:Z

    .line 226
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxHelper$2;

    invoke-direct {v0}, Lorg/cocos2dx/lib/Cocos2dxHelper$2;-><init>()V

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->connection:Landroid/content/ServiceConnection;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 68
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$002(Lcom/enhance/gameservice/IGameTuningService;)Lcom/enhance/gameservice/IGameTuningService;
    .locals 0
    .param p0, "x0"    # Lcom/enhance/gameservice/IGameTuningService;

    .prologue
    .line 68
    sput-object p0, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    return-object p0
.end method

.method static synthetic access$100()Landroid/content/ServiceConnection;
    .locals 1

    .prologue
    .line 68
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->connection:Landroid/content/ServiceConnection;

    return-object v0
.end method

.method static synthetic access$200()Landroid/app/Activity;
    .locals 1

    .prologue
    .line 68
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    return-object v0
.end method

.method static synthetic access$300([B)V
    .locals 0
    .param p0, "x0"    # [B

    .prologue
    .line 68
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxHelper;->nativeSetEditTextDialogResult([B)V

    return-void
.end method

.method public static addOnActivityResultListener(Landroid/preference/PreferenceManager$OnActivityResultListener;)V
    .locals 1
    .param p0, "listener"    # Landroid/preference/PreferenceManager$OnActivityResultListener;

    .prologue
    .line 243
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->onActivityResultListeners:Ljava/util/Set;

    invoke-interface {v0, p0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 244
    return-void
.end method

.method public static conversionEncoding([BLjava/lang/String;Ljava/lang/String;)[B
    .locals 3
    .param p0, "text"    # [B
    .param p1, "fromCharset"    # Ljava/lang/String;
    .param p2, "newCharset"    # Ljava/lang/String;

    .prologue
    .line 680
    :try_start_0
    new-instance v1, Ljava/lang/String;

    invoke-direct {v1, p0, p1}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 681
    .local v1, "str":Ljava/lang/String;
    invoke-virtual {v1, p2}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v2

    .line 686
    .end local v1    # "str":Ljava/lang/String;
    :goto_0
    return-object v2

    .line 682
    :catch_0
    move-exception v0

    .line 683
    .local v0, "e":Ljava/io/UnsupportedEncodingException;
    invoke-virtual {v0}, Ljava/io/UnsupportedEncodingException;->printStackTrace()V

    .line 686
    const/4 v2, 0x0

    goto :goto_0
.end method

.method public static deleteValueForKey(Ljava/lang/String;)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;

    .prologue
    .line 671
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 672
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 673
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0, p0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 674
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 675
    return-void
.end method

.method public static disableAccelerometer()V
    .locals 1

    .prologue
    .line 308
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAccelerometerEnabled:Z

    .line 309
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->disable()V

    .line 310
    return-void
.end method

.method public static enableAccelerometer()V
    .locals 1

    .prologue
    .line 294
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAccelerometerEnabled:Z

    .line 295
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->enableAccel()V

    .line 296
    return-void
.end method

.method public static enableCompass()V
    .locals 1

    .prologue
    .line 299
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCompassEnabled:Z

    .line 300
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->enableCompass()V

    .line 301
    return-void
.end method

.method public static end()V
    .locals 1

    .prologue
    .line 454
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->end()V

    .line 455
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->end()V

    .line 456
    return-void
.end method

.method public static fastLoading(I)I
    .locals 3
    .param p0, "sec"    # I

    .prologue
    const/4 v1, -0x1

    .line 726
    :try_start_0
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    if-eqz v2, :cond_0

    .line 727
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    invoke-interface {v2, p0}, Lcom/enhance/gameservice/IGameTuningService;->boostUp(I)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 732
    :cond_0
    :goto_0
    return v1

    .line 730
    :catch_0
    move-exception v0

    .line 731
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static getAccelValue()[F
    .locals 1

    .prologue
    .line 762
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    iget-object v0, v0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->accelerometerValues:[F

    return-object v0
.end method

.method public static getActivity()Landroid/app/Activity;
    .locals 1

    .prologue
    .line 239
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    return-object v0
.end method

.method public static getAssetManager()Landroid/content/res/AssetManager;
    .locals 1

    .prologue
    .line 290
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetManager:Landroid/content/res/AssetManager;

    return-object v0
.end method

.method public static getAssetsPath()Ljava/lang/String;
    .locals 6

    .prologue
    .line 195
    sget-object v4, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetsPath:Ljava/lang/String;

    const-string v5, ""

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 197
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v5

    invoke-virtual {v5}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/Android/obb/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->sPackageName:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 200
    .local v3, "pathToOBB":Ljava/lang/String;
    new-instance v4, Ljava/io/File;

    invoke-direct {v4, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    new-instance v5, Lorg/cocos2dx/lib/Cocos2dxHelper$1;

    invoke-direct {v5}, Lorg/cocos2dx/lib/Cocos2dxHelper$1;-><init>()V

    invoke-virtual {v4, v5}, Ljava/io/File;->list(Ljava/io/FilenameFilter;)[Ljava/lang/String;

    move-result-object v0

    .line 206
    .local v0, "fileNames":[Ljava/lang/String;
    const-string v1, ""

    .line 207
    .local v1, "fullPathToOBB":Ljava/lang/String;
    if-eqz v0, :cond_0

    array-length v4, v0

    if-lez v4, :cond_0

    .line 208
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const/4 v5, 0x0

    aget-object v5, v0, v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 210
    :cond_0
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 211
    .local v2, "obbFile":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v4

    if-eqz v4, :cond_2

    .line 212
    sput-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetsPath:Ljava/lang/String;

    .line 217
    :cond_1
    :goto_0
    sget-object v4, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetsPath:Ljava/lang/String;

    return-object v4

    .line 214
    :cond_2
    sget-object v4, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    iget-object v4, v4, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    sput-object v4, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetsPath:Ljava/lang/String;

    goto :goto_0
.end method

.method public static getBackgroundMusicVolume()F
    .locals 1

    .prologue
    .line 397
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->getBackgroundVolume()F

    move-result v0

    return v0
.end method

.method public static getBoolForKey(Ljava/lang/String;Z)Z
    .locals 10
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # Z

    .prologue
    const/4 v6, 0x1

    const/4 v7, 0x0

    .line 533
    sget-object v8, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v9, "Cocos2dxPrefsFile"

    invoke-virtual {v8, v9, v7}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v4

    .line 535
    .local v4, "settings":Landroid/content/SharedPreferences;
    :try_start_0
    invoke-interface {v4, p0, p1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v6

    .line 558
    :cond_0
    :goto_0
    return v6

    .line 537
    :catch_0
    move-exception v1

    .line 538
    .local v1, "ex":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    .line 540
    invoke-interface {v4}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    .line 541
    .local v0, "allValues":Ljava/util/Map;
    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 542
    .local v5, "value":Ljava/lang/Object;
    instance-of v8, v5, Ljava/lang/String;

    if-eqz v8, :cond_1

    .line 544
    invoke-virtual {v5}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v6}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v6

    goto :goto_0

    .line 546
    :cond_1
    instance-of v8, v5, Ljava/lang/Integer;

    if-eqz v8, :cond_2

    .line 548
    check-cast v5, Ljava/lang/Integer;

    .end local v5    # "value":Ljava/lang/Object;
    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 549
    .local v3, "intValue":I
    if-nez v3, :cond_0

    move v6, v7

    goto :goto_0

    .line 551
    .end local v3    # "intValue":I
    .restart local v5    # "value":Ljava/lang/Object;
    :cond_2
    instance-of v8, v5, Ljava/lang/Float;

    if-eqz v8, :cond_3

    .line 553
    check-cast v5, Ljava/lang/Float;

    .end local v5    # "value":Ljava/lang/Object;
    invoke-virtual {v5}, Ljava/lang/Float;->floatValue()F

    move-result v2

    .line 554
    .local v2, "floatValue":F
    const/4 v8, 0x0

    cmpl-float v8, v2, v8

    if-nez v8, :cond_0

    move v6, v7

    goto :goto_0

    .end local v2    # "floatValue":F
    .restart local v5    # "value":Ljava/lang/Object;
    :cond_3
    move v6, p1

    .line 558
    goto :goto_0
.end method

.method public static getCocos2dxPackageName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 275
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sPackageName:Ljava/lang/String;

    return-object v0
.end method

.method public static getCocos2dxWritablePath()Ljava/lang/String;
    .locals 1

    .prologue
    .line 278
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sFileDirectory:Ljava/lang/String;

    return-object v0
.end method

.method public static getCompassValue()[F
    .locals 1

    .prologue
    .line 766
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    iget-object v0, v0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->compassFieldValues:[F

    return-object v0
.end method

.method public static getCurrentLanguage()Ljava/lang/String;
    .locals 1

    .prologue
    .line 282
    invoke-static {}, Ljava/util/Locale;->getDefault()Ljava/util/Locale;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/Locale;->getLanguage()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static getDPI()I
    .locals 5

    .prologue
    .line 511
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    if-eqz v3, :cond_0

    .line 513
    new-instance v1, Landroid/util/DisplayMetrics;

    invoke-direct {v1}, Landroid/util/DisplayMetrics;-><init>()V

    .line 514
    .local v1, "metrics":Landroid/util/DisplayMetrics;
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    invoke-virtual {v3}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v2

    .line 515
    .local v2, "wm":Landroid/view/WindowManager;
    if-eqz v2, :cond_0

    .line 517
    invoke-interface {v2}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    .line 518
    .local v0, "d":Landroid/view/Display;
    if-eqz v0, :cond_0

    .line 520
    invoke-virtual {v0, v1}, Landroid/view/Display;->getMetrics(Landroid/util/DisplayMetrics;)V

    .line 521
    iget v3, v1, Landroid/util/DisplayMetrics;->density:F

    const/high16 v4, 0x43200000    # 160.0f

    mul-float/2addr v3, v4

    float-to-int v3, v3

    .line 525
    .end local v0    # "d":Landroid/view/Display;
    :goto_0
    return v3

    :cond_0
    const/4 v3, -0x1

    goto :goto_0
.end method

.method public static getDeviceModel()Ljava/lang/String;
    .locals 1

    .prologue
    .line 286
    sget-object v0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    return-object v0
.end method

.method public static getDoubleForKey(Ljava/lang/String;D)D
    .locals 3
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # D

    .prologue
    .line 619
    double-to-float v0, p1

    invoke-static {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getFloatForKey(Ljava/lang/String;F)F

    move-result v0

    float-to-double v0, v0

    return-wide v0
.end method

.method public static getEffectsVolume()F
    .locals 1

    .prologue
    .line 425
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->getEffectsVolume()F

    move-result v0

    return v0
.end method

.method public static getFloatForKey(Ljava/lang/String;F)F
    .locals 8
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # F

    .prologue
    .line 590
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v6, "Cocos2dxPrefsFile"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    .line 592
    .local v3, "settings":Landroid/content/SharedPreferences;
    :try_start_0
    invoke-interface {v3, p0, p1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result p1

    .line 614
    .end local p1    # "defaultValue":F
    :cond_0
    :goto_0
    return p1

    .line 594
    .restart local p1    # "defaultValue":F
    :catch_0
    move-exception v2

    .line 595
    .local v2, "ex":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 597
    invoke-interface {v3}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    .line 598
    .local v0, "allValues":Ljava/util/Map;
    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 599
    .local v4, "value":Ljava/lang/Object;
    instance-of v5, v4, Ljava/lang/String;

    if-eqz v5, :cond_1

    .line 600
    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result p1

    goto :goto_0

    .line 602
    :cond_1
    instance-of v5, v4, Ljava/lang/Integer;

    if-eqz v5, :cond_2

    .line 604
    check-cast v4, Ljava/lang/Integer;

    .end local v4    # "value":Ljava/lang/Object;
    invoke-virtual {v4}, Ljava/lang/Integer;->floatValue()F

    move-result p1

    goto :goto_0

    .line 606
    .restart local v4    # "value":Ljava/lang/Object;
    :cond_2
    instance-of v5, v4, Ljava/lang/Boolean;

    if-eqz v5, :cond_0

    .line 608
    check-cast v4, Ljava/lang/Boolean;

    .end local v4    # "value":Ljava/lang/Object;
    invoke-virtual {v4}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 609
    .local v1, "booleanValue":Z
    if-eqz v1, :cond_0

    .line 610
    const/high16 p1, 0x3f800000    # 1.0f

    goto :goto_0
.end method

.method public static getIntegerForKey(Ljava/lang/String;I)I
    .locals 8
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # I

    .prologue
    .line 562
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v6, "Cocos2dxPrefsFile"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    .line 564
    .local v3, "settings":Landroid/content/SharedPreferences;
    :try_start_0
    invoke-interface {v3, p0, p1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result p1

    .line 586
    .end local p1    # "defaultValue":I
    :cond_0
    :goto_0
    return p1

    .line 566
    .restart local p1    # "defaultValue":I
    :catch_0
    move-exception v2

    .line 567
    .local v2, "ex":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 569
    invoke-interface {v3}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v0

    .line 570
    .local v0, "allValues":Ljava/util/Map;
    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 571
    .local v4, "value":Ljava/lang/Object;
    instance-of v5, v4, Ljava/lang/String;

    if-eqz v5, :cond_1

    .line 572
    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1

    goto :goto_0

    .line 574
    :cond_1
    instance-of v5, v4, Ljava/lang/Float;

    if-eqz v5, :cond_2

    .line 576
    check-cast v4, Ljava/lang/Float;

    .end local v4    # "value":Ljava/lang/Object;
    invoke-virtual {v4}, Ljava/lang/Float;->intValue()I

    move-result p1

    goto :goto_0

    .line 578
    .restart local v4    # "value":Ljava/lang/Object;
    :cond_2
    instance-of v5, v4, Ljava/lang/Boolean;

    if-eqz v5, :cond_0

    .line 580
    check-cast v4, Ljava/lang/Boolean;

    .end local v4    # "value":Ljava/lang/Object;
    invoke-virtual {v4}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 581
    .local v1, "booleanValue":Z
    if-eqz v1, :cond_0

    .line 582
    const/4 p1, 0x1

    goto :goto_0
.end method

.method public static getObbAssetFileDescriptor(Ljava/lang/String;)[J
    .locals 10
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 342
    const/4 v5, 0x3

    new-array v0, v5, [J

    .line 343
    .local v0, "array":[J
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;

    if-eqz v5, :cond_0

    .line 344
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;

    invoke-virtual {v5, p0}, Lcom/android/vending/expansion/zipfile/ZipResourceFile;->getAssetFileDescriptor(Ljava/lang/String;)Landroid/content/res/AssetFileDescriptor;

    move-result-object v1

    .line 345
    .local v1, "descriptor":Landroid/content/res/AssetFileDescriptor;
    if-eqz v1, :cond_0

    .line 347
    :try_start_0
    invoke-virtual {v1}, Landroid/content/res/AssetFileDescriptor;->getParcelFileDescriptor()Landroid/os/ParcelFileDescriptor;

    move-result-object v4

    .line 348
    .local v4, "parcel":Landroid/os/ParcelFileDescriptor;
    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "getFd"

    const/4 v7, 0x0

    new-array v7, v7, [Ljava/lang/Class;

    invoke-virtual {v5, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 349
    .local v3, "method":Ljava/lang/reflect/Method;
    const/4 v6, 0x0

    const/4 v5, 0x0

    new-array v5, v5, [Ljava/lang/Object;

    invoke-virtual {v3, v4, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v5

    int-to-long v8, v5

    aput-wide v8, v0, v6

    .line 350
    const/4 v5, 0x1

    invoke-virtual {v1}, Landroid/content/res/AssetFileDescriptor;->getStartOffset()J

    move-result-wide v6

    aput-wide v6, v0, v5

    .line 351
    const/4 v5, 0x2

    invoke-virtual {v1}, Landroid/content/res/AssetFileDescriptor;->getLength()J

    move-result-wide v6

    aput-wide v6, v0, v5
    :try_end_0
    .catch Ljava/lang/NoSuchMethodException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/IllegalAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_0 .. :try_end_0} :catch_2

    .line 361
    .end local v1    # "descriptor":Landroid/content/res/AssetFileDescriptor;
    .end local v3    # "method":Ljava/lang/reflect/Method;
    .end local v4    # "parcel":Landroid/os/ParcelFileDescriptor;
    :cond_0
    :goto_0
    return-object v0

    .line 352
    .restart local v1    # "descriptor":Landroid/content/res/AssetFileDescriptor;
    :catch_0
    move-exception v2

    .line 353
    .local v2, "e":Ljava/lang/NoSuchMethodException;
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    const-string v6, "Accessing file descriptor directly from the OBB is only supported from Android 3.1 (API level 12) and above."

    invoke-static {v5, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 354
    .end local v2    # "e":Ljava/lang/NoSuchMethodException;
    :catch_1
    move-exception v2

    .line 355
    .local v2, "e":Ljava/lang/IllegalAccessException;
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/IllegalAccessException;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 356
    .end local v2    # "e":Ljava/lang/IllegalAccessException;
    :catch_2
    move-exception v2

    .line 357
    .local v2, "e":Ljava/lang/reflect/InvocationTargetException;
    sget-object v5, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/reflect/InvocationTargetException;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public static getObbFile()Lcom/android/vending/expansion/zipfile/ZipResourceFile;
    .locals 1

    .prologue
    .line 222
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;

    return-object v0
.end method

.method public static getOnActivityResultListeners()Ljava/util/Set;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set",
            "<",
            "Landroid/preference/PreferenceManager$OnActivityResultListener;",
            ">;"
        }
    .end annotation

    .prologue
    .line 247
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->onActivityResultListeners:Ljava/util/Set;

    return-object v0
.end method

.method public static getSDKVersion()I
    .locals 1

    .prologue
    .line 770
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    return v0
.end method

.method public static getStringForKey(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "defaultValue"    # Ljava/lang/String;

    .prologue
    .line 623
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 625
    .local v1, "settings":Landroid/content/SharedPreferences;
    :try_start_0
    invoke-interface {v1, p0, p1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v2

    .line 630
    :goto_0
    return-object v2

    .line 627
    :catch_0
    move-exception v0

    .line 628
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 630
    invoke-interface {v1}, Landroid/content/SharedPreferences;->getAll()Ljava/util/Map;

    move-result-object v2

    invoke-interface {v2, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0
.end method

.method public static getTemperature()I
    .locals 3

    .prologue
    const/4 v1, -0x1

    .line 738
    :try_start_0
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    if-eqz v2, :cond_0

    .line 739
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    invoke-interface {v2}, Lcom/enhance/gameservice/IGameTuningService;->getAbstractTemperature()I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 744
    .local v0, "e":Ljava/lang/Exception;
    :cond_0
    :goto_0
    return v1

    .line 742
    .end local v0    # "e":Ljava/lang/Exception;
    :catch_0
    move-exception v0

    .line 743
    .restart local v0    # "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static getVersion()Ljava/lang/String;
    .locals 5

    .prologue
    .line 322
    :try_start_0
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v2

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v2

    iget-object v1, v2, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 325
    :goto_0
    return-object v1

    .line 324
    :catch_0
    move-exception v0

    .line 325
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, ""

    goto :goto_0
.end method

.method public static init(Landroid/app/Activity;)V
    .locals 21
    .param p0, "activity"    # Landroid/app/Activity;

    .prologue
    .line 114
    sput-object p0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    move-object/from16 v17, p0

    .line 115
    check-cast v17, Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxHelperListener:Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;

    .line 116
    sget-boolean v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sInited:Z

    if-nez v17, :cond_0

    .line 118
    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v10

    .line 119
    .local v10, "pm":Landroid/content/pm/PackageManager;
    const-string v17, "android.hardware.audio.low_latency"

    move-object/from16 v0, v17

    invoke-virtual {v10, v0}, Landroid/content/pm/PackageManager;->hasSystemFeature(Ljava/lang/String;)Z

    move-result v8

    .line 121
    .local v8, "isSupportLowLatency":Z
    sget-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    new-instance v18, Ljava/lang/StringBuilder;

    invoke-direct/range {v18 .. v18}, Ljava/lang/StringBuilder;-><init>()V

    const-string v19, "isSupportLowLatency:"

    invoke-virtual/range {v18 .. v19}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v18

    move-object/from16 v0, v18

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v18

    invoke-virtual/range {v18 .. v18}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v18

    invoke-static/range {v17 .. v18}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    const v11, 0xac44

    .line 124
    .local v11, "sampleRate":I
    const/16 v6, 0xc0

    .line 126
    .local v6, "bufferSizeInFrames":I
    sget v17, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v18, 0x11

    move/from16 v0, v17

    move/from16 v1, v18

    if-lt v0, v1, :cond_1

    .line 127
    const-string v17, "audio"

    move-object/from16 v0, p0

    move-object/from16 v1, v17

    invoke-virtual {v0, v1}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/media/AudioManager;

    .line 131
    .local v3, "am":Landroid/media/AudioManager;
    const-class v5, Landroid/media/AudioManager;

    .line 132
    .local v5, "audioManagerClass":Ljava/lang/Class;
    const/16 v17, 0x1

    move/from16 v0, v17

    new-array v9, v0, [Ljava/lang/Object;

    const/16 v17, 0x0

    const-string v18, "PROPERTY_OUTPUT_SAMPLE_RATE"

    move-object/from16 v0, v18

    invoke-static {v5, v0}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v18

    aput-object v18, v9, v17

    .line 133
    .local v9, "parameters":[Ljava/lang/Object;
    const-string v17, "getProperty"

    const/16 v18, 0x1

    move/from16 v0, v18

    new-array v0, v0, [Ljava/lang/Class;

    move-object/from16 v18, v0

    const/16 v19, 0x0

    const-class v20, Ljava/lang/String;

    aput-object v20, v18, v19

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-static {v3, v0, v1, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->invokeInstanceMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Ljava/lang/String;

    .line 136
    .local v14, "strSampleRate":Ljava/lang/String;
    const/16 v17, 0x1

    move/from16 v0, v17

    new-array v9, v0, [Ljava/lang/Object;

    .end local v9    # "parameters":[Ljava/lang/Object;
    const/16 v17, 0x0

    const-string v18, "PROPERTY_OUTPUT_FRAMES_PER_BUFFER"

    move-object/from16 v0, v18

    invoke-static {v5, v0}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->getConstantValue(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v18

    aput-object v18, v9, v17

    .line 137
    .restart local v9    # "parameters":[Ljava/lang/Object;
    const-string v17, "getProperty"

    const/16 v18, 0x1

    move/from16 v0, v18

    new-array v0, v0, [Ljava/lang/Class;

    move-object/from16 v18, v0

    const/16 v19, 0x0

    const-class v20, Ljava/lang/String;

    aput-object v20, v18, v19

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-static {v3, v0, v1, v9}, Lorg/cocos2dx/lib/Cocos2dxReflectionHelper;->invokeInstanceMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Ljava/lang/String;

    .line 140
    .local v13, "strBufferSizeInFrames":Ljava/lang/String;
    :try_start_0
    invoke-static {v14}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11

    .line 141
    invoke-static {v13}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    move-result v6

    .line 145
    :goto_0
    sget-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    new-instance v18, Ljava/lang/StringBuilder;

    invoke-direct/range {v18 .. v18}, Ljava/lang/StringBuilder;-><init>()V

    const-string v19, "sampleRate: "

    invoke-virtual/range {v18 .. v19}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v18

    move-object/from16 v0, v18

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v18

    const-string v19, ", framesPerBuffer: "

    invoke-virtual/range {v18 .. v19}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v18

    move-object/from16 v0, v18

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v18

    invoke-virtual/range {v18 .. v18}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v18

    invoke-static/range {v17 .. v18}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    .end local v3    # "am":Landroid/media/AudioManager;
    .end local v5    # "audioManagerClass":Ljava/lang/Class;
    .end local v9    # "parameters":[Ljava/lang/Object;
    .end local v13    # "strBufferSizeInFrames":Ljava/lang/String;
    .end local v14    # "strSampleRate":Ljava/lang/String;
    :goto_1
    invoke-static {v8, v11, v6}, Lorg/cocos2dx/lib/Cocos2dxHelper;->nativeSetAudioDeviceInfo(ZII)V

    .line 152
    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    .line 154
    .local v4, "applicationInfo":Landroid/content/pm/ApplicationInfo;
    iget-object v0, v4, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    move-object/from16 v17, v0

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sPackageName:Ljava/lang/String;

    .line 155
    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getFilesDir()Ljava/io/File;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v17

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sFileDirectory:Ljava/lang/String;

    .line 157
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getAssetsPath()Ljava/lang/String;

    move-result-object v17

    invoke-static/range {v17 .. v17}, Lorg/cocos2dx/lib/Cocos2dxHelper;->nativeSetApkPath(Ljava/lang/String;)V

    .line 159
    new-instance v17, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    move-object/from16 v0, v17

    move-object/from16 v1, p0

    invoke-direct {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;-><init>(Landroid/content/Context;)V

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    .line 160
    new-instance v17, Lorg/cocos2dx/lib/Cocos2dxMusic;

    move-object/from16 v0, v17

    move-object/from16 v1, p0

    invoke-direct {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxMusic;-><init>(Landroid/content/Context;)V

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    .line 161
    new-instance v17, Lorg/cocos2dx/lib/Cocos2dxSound;

    move-object/from16 v0, v17

    move-object/from16 v1, p0

    invoke-direct {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxSound;-><init>(Landroid/content/Context;)V

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    .line 162
    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v17

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetManager:Landroid/content/res/AssetManager;

    .line 163
    sget-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAssetManager:Landroid/content/res/AssetManager;

    move-object/from16 v0, p0

    move-object/from16 v1, v17

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxHelper;->nativeSetContext(Landroid/content/Context;Landroid/content/res/AssetManager;)V

    .line 165
    invoke-static/range {p0 .. p0}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->setContext(Landroid/content/Context;)V

    .line 167
    const-string v17, "vibrator"

    move-object/from16 v0, p0

    move-object/from16 v1, v17

    invoke-virtual {v0, v1}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v17

    check-cast v17, Landroid/os/Vibrator;

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sVibrateService:Landroid/os/Vibrator;

    .line 169
    const/16 v17, 0x1

    sput-boolean v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sInited:Z

    .line 172
    new-instance v12, Landroid/content/Intent;

    const-class v17, Lcom/enhance/gameservice/IGameTuningService;

    invoke-virtual/range {v17 .. v17}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v17

    move-object/from16 v0, v17

    invoke-direct {v12, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 173
    .local v12, "serviceIntent":Landroid/content/Intent;
    const-string v17, "com.enhance.gameservice"

    move-object/from16 v0, v17

    invoke-virtual {v12, v0}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 174
    invoke-virtual/range {p0 .. p0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v17

    sget-object v18, Lorg/cocos2dx/lib/Cocos2dxHelper;->connection:Landroid/content/ServiceConnection;

    const/16 v19, 0x1

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    move/from16 v2, v19

    invoke-virtual {v0, v12, v1, v2}, Landroid/content/Context;->bindService(Landroid/content/Intent;Landroid/content/ServiceConnection;I)Z

    move-result v15

    .line 177
    .local v15, "suc":Z
    const/16 v16, 0x1

    .line 179
    .local v16, "versionCode":I
    :try_start_1
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getContext()Landroid/content/Context;

    move-result-object v17

    invoke-virtual/range {v17 .. v17}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v17

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxHelper;->getCocos2dxPackageName()Ljava/lang/String;

    move-result-object v18

    const/16 v19, 0x0

    invoke-virtual/range {v17 .. v19}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v17

    move-object/from16 v0, v17

    iget v0, v0, Landroid/content/pm/PackageInfo;->versionCode:I

    move/from16 v16, v0
    :try_end_1
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_1 .. :try_end_1} :catch_1

    .line 184
    :goto_2
    :try_start_2
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getContext()Landroid/content/Context;

    move-result-object v17

    const/16 v18, 0x0

    move-object/from16 v0, v17

    move/from16 v1, v16

    move/from16 v2, v18

    invoke-static {v0, v1, v2}, Lcom/android/vending/expansion/zipfile/APKExpansionSupport;->getAPKExpansionZipFile(Landroid/content/Context;II)Lcom/android/vending/expansion/zipfile/ZipResourceFile;

    move-result-object v17

    sput-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->sOBBFile:Lcom/android/vending/expansion/zipfile/ZipResourceFile;
    :try_end_2
    .catch Ljava/io/IOException; {:try_start_2 .. :try_end_2} :catch_2

    .line 189
    .end local v4    # "applicationInfo":Landroid/content/pm/ApplicationInfo;
    .end local v6    # "bufferSizeInFrames":I
    .end local v8    # "isSupportLowLatency":Z
    .end local v10    # "pm":Landroid/content/pm/PackageManager;
    .end local v11    # "sampleRate":I
    .end local v12    # "serviceIntent":Landroid/content/Intent;
    .end local v15    # "suc":Z
    .end local v16    # "versionCode":I
    :cond_0
    :goto_3
    return-void

    .line 142
    .restart local v3    # "am":Landroid/media/AudioManager;
    .restart local v5    # "audioManagerClass":Ljava/lang/Class;
    .restart local v6    # "bufferSizeInFrames":I
    .restart local v8    # "isSupportLowLatency":Z
    .restart local v9    # "parameters":[Ljava/lang/Object;
    .restart local v10    # "pm":Landroid/content/pm/PackageManager;
    .restart local v11    # "sampleRate":I
    .restart local v13    # "strBufferSizeInFrames":Ljava/lang/String;
    .restart local v14    # "strSampleRate":Ljava/lang/String;
    :catch_0
    move-exception v7

    .line 143
    .local v7, "e":Ljava/lang/NumberFormatException;
    sget-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    const-string v18, "parseInt failed"

    move-object/from16 v0, v17

    move-object/from16 v1, v18

    invoke-static {v0, v1, v7}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto/16 :goto_0

    .line 147
    .end local v3    # "am":Landroid/media/AudioManager;
    .end local v5    # "audioManagerClass":Ljava/lang/Class;
    .end local v7    # "e":Ljava/lang/NumberFormatException;
    .end local v9    # "parameters":[Ljava/lang/Object;
    .end local v13    # "strBufferSizeInFrames":Ljava/lang/String;
    .end local v14    # "strSampleRate":Ljava/lang/String;
    :cond_1
    sget-object v17, Lorg/cocos2dx/lib/Cocos2dxHelper;->TAG:Ljava/lang/String;

    const-string v18, "android version is lower than 17"

    invoke-static/range {v17 .. v18}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1

    .line 180
    .restart local v4    # "applicationInfo":Landroid/content/pm/ApplicationInfo;
    .restart local v12    # "serviceIntent":Landroid/content/Intent;
    .restart local v15    # "suc":Z
    .restart local v16    # "versionCode":I
    :catch_1
    move-exception v7

    .line 181
    .local v7, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    invoke-virtual {v7}, Landroid/content/pm/PackageManager$NameNotFoundException;->printStackTrace()V

    goto :goto_2

    .line 185
    .end local v7    # "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    :catch_2
    move-exception v7

    .line 186
    .local v7, "e":Ljava/io/IOException;
    invoke-virtual {v7}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_3
.end method

.method public static isActivityVisible()Z
    .locals 1

    .prologue
    .line 251
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivityVisible:Z

    return v0
.end method

.method public static isBackgroundMusicPlaying()Z
    .locals 1

    .prologue
    .line 393
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->isBackgroundMusicPlaying()Z

    move-result v0

    return v0
.end method

.method private static native nativeSetApkPath(Ljava/lang/String;)V
.end method

.method private static native nativeSetAudioDeviceInfo(ZII)V
.end method

.method private static native nativeSetContext(Landroid/content/Context;Landroid/content/res/AssetManager;)V
.end method

.method private static native nativeSetEditTextDialogResult([B)V
.end method

.method public static onEnterBackground()V
    .locals 1

    .prologue
    .line 476
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->onEnterBackground()V

    .line 477
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->onEnterBackground()V

    .line 478
    return-void
.end method

.method public static onEnterForeground()V
    .locals 1

    .prologue
    .line 481
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->onEnterForeground()V

    .line 482
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->onEnterForeground()V

    .line 483
    return-void
.end method

.method public static onPause()V
    .locals 1

    .prologue
    .line 469
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivityVisible:Z

    .line 470
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAccelerometerEnabled:Z

    if-eqz v0, :cond_0

    .line 471
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->disable()V

    .line 473
    :cond_0
    return-void
.end method

.method public static onResume()V
    .locals 1

    .prologue
    .line 459
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivityVisible:Z

    .line 460
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sAccelerometerEnabled:Z

    if-eqz v0, :cond_0

    .line 461
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->enableAccel()V

    .line 463
    :cond_0
    sget-boolean v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCompassEnabled:Z

    if-eqz v0, :cond_1

    .line 464
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->enableCompass()V

    .line 466
    :cond_1
    return-void
.end method

.method public static openURL(Ljava/lang/String;)Z
    .locals 3
    .param p0, "url"    # Ljava/lang/String;

    .prologue
    .line 330
    const/4 v1, 0x0

    .line 332
    .local v1, "ret":Z
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v2, "android.intent.action.VIEW"

    invoke-direct {v0, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 333
    .local v0, "i":Landroid/content/Intent;
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/content/Intent;->setData(Landroid/net/Uri;)Landroid/content/Intent;

    .line 334
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    invoke-virtual {v2, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 335
    const/4 v1, 0x1

    .line 338
    .end local v0    # "i":Landroid/content/Intent;
    :goto_0
    return v1

    .line 336
    :catch_0
    move-exception v2

    goto :goto_0
.end method

.method public static pauseAllEffects()V
    .locals 1

    .prologue
    .line 437
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->pauseAllEffects()V

    .line 438
    return-void
.end method

.method public static pauseBackgroundMusic()V
    .locals 1

    .prologue
    .line 377
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->pauseBackgroundMusic()V

    .line 378
    return-void
.end method

.method public static pauseEffect(I)V
    .locals 1
    .param p0, "soundId"    # I

    .prologue
    .line 417
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->pauseEffect(I)V

    .line 418
    return-void
.end method

.method public static playBackgroundMusic(Ljava/lang/String;Z)V
    .locals 1
    .param p0, "pPath"    # Ljava/lang/String;
    .param p1, "isLoop"    # Z

    .prologue
    .line 369
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxMusic;->playBackgroundMusic(Ljava/lang/String;Z)V

    .line 370
    return-void
.end method

.method public static playEffect(Ljava/lang/String;ZFFF)I
    .locals 6
    .param p0, "path"    # Ljava/lang/String;
    .param p1, "isLoop"    # Z
    .param p2, "pitch"    # F
    .param p3, "pan"    # F
    .param p4, "gain"    # F

    .prologue
    .line 409
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    move-object v1, p0

    move v2, p1

    move v3, p2

    move v4, p3

    move v5, p4

    invoke-virtual/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxSound;->playEffect(Ljava/lang/String;ZFFF)I

    move-result v0

    return v0
.end method

.method public static preloadBackgroundMusic(Ljava/lang/String;)V
    .locals 1
    .param p0, "pPath"    # Ljava/lang/String;

    .prologue
    .line 365
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->preloadBackgroundMusic(Ljava/lang/String;)V

    .line 366
    return-void
.end method

.method public static preloadEffect(Ljava/lang/String;)V
    .locals 1
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 405
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->preloadEffect(Ljava/lang/String;)I

    .line 406
    return-void
.end method

.method public static resumeAllEffects()V
    .locals 1

    .prologue
    .line 441
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->resumeAllEffects()V

    .line 442
    return-void
.end method

.method public static resumeBackgroundMusic()V
    .locals 1

    .prologue
    .line 373
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->resumeBackgroundMusic()V

    .line 374
    return-void
.end method

.method public static resumeEffect(I)V
    .locals 1
    .param p0, "soundId"    # I

    .prologue
    .line 413
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->resumeEffect(I)V

    .line 414
    return-void
.end method

.method public static rewindBackgroundMusic()V
    .locals 1

    .prologue
    .line 385
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->rewindBackgroundMusic()V

    .line 386
    return-void
.end method

.method public static runOnGLThread(Ljava/lang/Runnable;)V
    .locals 1
    .param p0, "r"    # Ljava/lang/Runnable;

    .prologue
    .line 109
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->runOnGLThread(Ljava/lang/Runnable;)V

    .line 110
    return-void
.end method

.method public static setAccelerometerInterval(F)V
    .locals 1
    .param p0, "interval"    # F

    .prologue
    .line 304
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxAccelerometer:Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->setInterval(F)V

    .line 305
    return-void
.end method

.method static setAudioFocus(Z)V
    .locals 1
    .param p0, "isAudioFocus"    # Z

    .prologue
    .line 449
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->setAudioFocus(Z)V

    .line 450
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->setAudioFocus(Z)V

    .line 451
    return-void
.end method

.method public static setBackgroundMusicVolume(F)V
    .locals 1
    .param p0, "volume"    # F

    .prologue
    .line 401
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->setBackgroundVolume(F)V

    .line 402
    return-void
.end method

.method public static setBoolForKey(Ljava/lang/String;Z)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # Z

    .prologue
    .line 635
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 636
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 637
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 638
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 639
    return-void
.end method

.method public static setDoubleForKey(Ljava/lang/String;D)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # D

    .prologue
    .line 657
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 658
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 659
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    double-to-float v2, p1

    invoke-interface {v0, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    .line 660
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 661
    return-void
.end method

.method public static setEditTextDialogResult(Ljava/lang/String;)V
    .locals 3
    .param p0, "pResult"    # Ljava/lang/String;

    .prologue
    .line 496
    :try_start_0
    const-string v1, "UTF8"

    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v0

    .line 498
    .local v0, "bytesUTF8":[B
    sget-object v1, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxHelperListener:Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;

    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxHelper$3;

    invoke-direct {v2, v0}, Lorg/cocos2dx/lib/Cocos2dxHelper$3;-><init>([B)V

    invoke-interface {v1, v2}, Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;->runOnGLThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_0} :catch_0

    .line 507
    .end local v0    # "bytesUTF8":[B
    :goto_0
    return-void

    .line 504
    :catch_0
    move-exception v1

    goto :goto_0
.end method

.method public static setEffectsVolume(F)V
    .locals 1
    .param p0, "volume"    # F

    .prologue
    .line 429
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->setEffectsVolume(F)V

    .line 430
    return-void
.end method

.method public static setFPS(I)I
    .locals 3
    .param p0, "fps"    # I

    .prologue
    const/4 v1, -0x1

    .line 714
    :try_start_0
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    if-eqz v2, :cond_0

    .line 715
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    invoke-interface {v2, p0}, Lcom/enhance/gameservice/IGameTuningService;->setFramePerSecond(I)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 720
    :cond_0
    :goto_0
    return v1

    .line 718
    :catch_0
    move-exception v0

    .line 719
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static setFloatForKey(Ljava/lang/String;F)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # F

    .prologue
    .line 649
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 650
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 651
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    .line 652
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 653
    return-void
.end method

.method public static setIntegerForKey(Ljava/lang/String;I)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # I

    .prologue
    .line 642
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 643
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 644
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 645
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 646
    return-void
.end method

.method public static setKeepScreenOn(Z)V
    .locals 1
    .param p0, "value"    # Z

    .prologue
    .line 313
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->setKeepScreenOn(Z)V

    .line 314
    return-void
.end method

.method public static setLowPowerMode(Z)I
    .locals 3
    .param p0, "enable"    # Z

    .prologue
    const/4 v1, -0x1

    .line 750
    :try_start_0
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    if-eqz v2, :cond_0

    .line 751
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    invoke-interface {v2, p0}, Lcom/enhance/gameservice/IGameTuningService;->setGamePowerSaving(Z)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 756
    :cond_0
    :goto_0
    return v1

    .line 754
    :catch_0
    move-exception v0

    .line 755
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static setResolutionPercent(I)I
    .locals 3
    .param p0, "per"    # I

    .prologue
    const/4 v1, -0x1

    .line 702
    :try_start_0
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    if-eqz v2, :cond_0

    .line 703
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->mGameServiceBinder:Lcom/enhance/gameservice/IGameTuningService;

    invoke-interface {v2, p0}, Lcom/enhance/gameservice/IGameTuningService;->setPreferredResolution(I)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result v1

    .line 708
    :cond_0
    :goto_0
    return v1

    .line 706
    :catch_0
    move-exception v0

    .line 707
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static setStringForKey(Ljava/lang/String;Ljava/lang/String;)V
    .locals 5
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "value"    # Ljava/lang/String;

    .prologue
    .line 664
    sget-object v2, Lorg/cocos2dx/lib/Cocos2dxHelper;->sActivity:Landroid/app/Activity;

    const-string v3, "Cocos2dxPrefsFile"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 665
    .local v1, "settings":Landroid/content/SharedPreferences;
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 666
    .local v0, "editor":Landroid/content/SharedPreferences$Editor;
    invoke-interface {v0, p0, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 667
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 668
    return-void
.end method

.method private static showDialog(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "pTitle"    # Ljava/lang/String;
    .param p1, "pMessage"    # Ljava/lang/String;

    .prologue
    .line 490
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dxHelperListener:Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;

    invoke-interface {v0, p0, p1}, Lorg/cocos2dx/lib/Cocos2dxHelper$Cocos2dxHelperListener;->showDialog(Ljava/lang/String;Ljava/lang/String;)V

    .line 491
    return-void
.end method

.method public static stopAllEffects()V
    .locals 1

    .prologue
    .line 445
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxSound;->stopAllEffects()V

    .line 446
    return-void
.end method

.method public static stopBackgroundMusic()V
    .locals 1

    .prologue
    .line 381
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->stopBackgroundMusic()V

    .line 382
    return-void
.end method

.method public static stopEffect(I)V
    .locals 1
    .param p0, "soundId"    # I

    .prologue
    .line 421
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->stopEffect(I)V

    .line 422
    return-void
.end method

.method public static terminateProcess()V
    .locals 1

    .prologue
    .line 486
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v0

    invoke-static {v0}, Landroid/os/Process;->killProcess(I)V

    .line 487
    return-void
.end method

.method public static unloadEffect(Ljava/lang/String;)V
    .locals 1
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 433
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dSound:Lorg/cocos2dx/lib/Cocos2dxSound;

    invoke-virtual {v0, p0}, Lorg/cocos2dx/lib/Cocos2dxSound;->unloadEffect(Ljava/lang/String;)V

    .line 434
    return-void
.end method

.method public static vibrate(F)V
    .locals 4
    .param p0, "duration"    # F

    .prologue
    .line 317
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sVibrateService:Landroid/os/Vibrator;

    const/high16 v1, 0x447a0000    # 1000.0f

    mul-float/2addr v1, p0

    float-to-long v2, v1

    invoke-virtual {v0, v2, v3}, Landroid/os/Vibrator;->vibrate(J)V

    .line 318
    return-void
.end method

.method public static willPlayBackgroundMusic()Z
    .locals 1

    .prologue
    .line 389
    sget-object v0, Lorg/cocos2dx/lib/Cocos2dxHelper;->sCocos2dMusic:Lorg/cocos2dx/lib/Cocos2dxMusic;

    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxMusic;->willPlayBackgroundMusic()Z

    move-result v0

    return v0
.end method
