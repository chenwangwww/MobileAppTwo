.class public Lorg/cocos2dx/lua/AppActivity;
.super Lorg/cocos2dx/lib/Cocos2dxActivity;
.source "AppActivity.java"


# static fields
.field public static final KEY_EXTRAS:Ljava/lang/String; = "extras"

.field public static final KEY_MESSAGE:Ljava/lang/String; = "message"

.field public static final KEY_TITLE:Ljava/lang/String; = "title"

.field public static final MESSAGE_RECEIVED_ACTION:Ljava/lang/String; = "joy.reightyl.fun.MESSAGE_RECEIVED_ACTION"

.field public static OpenCustServiceQQLuaFuncID:I = 0x0

.field private static PaymHandler:Landroid/os/Handler; = null

.field public static final TAG:Ljava/lang/String; = "AppActivity"

.field private static final THUMB_SIZE:I = 0x64

.field public static WeixinPayLuaFuncID:I

.field public static _orientation:I

.field private static cocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field public static instance:Lorg/cocos2dx/lua/AppActivity;

.field public static isForeground:Z

.field private static pay_luaFunc:I

.field private static resultStatus:Ljava/lang/String;

.field public static startParams:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 67
    const-string v0, ""

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    .line 69
    const/4 v0, 0x0

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->cocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 73
    sput-boolean v1, Lorg/cocos2dx/lua/AppActivity;->isForeground:Z

    .line 79
    const/4 v0, 0x2

    sput v0, Lorg/cocos2dx/lua/AppActivity;->_orientation:I

    .line 293
    new-instance v0, Lorg/cocos2dx/lua/AppActivity$1;

    invoke-direct {v0}, Lorg/cocos2dx/lua/AppActivity$1;-><init>()V

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->PaymHandler:Landroid/os/Handler;

    .line 298
    sput v1, Lorg/cocos2dx/lua/AppActivity;->pay_luaFunc:I

    .line 376
    sput v1, Lorg/cocos2dx/lua/AppActivity;->WeixinPayLuaFuncID:I

    .line 394
    sput v1, Lorg/cocos2dx/lua/AppActivity;->OpenCustServiceQQLuaFuncID:I

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 62
    invoke-direct {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;-><init>()V

    return-void
.end method

.method public static OpenCustServiceQQ(Ljava/lang/String;I)V
    .locals 0
    .param p0, "qqNumStr"    # Ljava/lang/String;
    .param p1, "luaFunc"    # I

    .prologue
    .line 398
    return-void
.end method

.method public static PayByWeixin(Ljava/lang/String;I)V
    .locals 0
    .param p0, "orderInfo"    # Ljava/lang/String;
    .param p1, "luaFunc"    # I

    .prologue
    .line 379
    return-void
.end method

.method public static bmpToByteArray(Landroid/graphics/Bitmap;Z)[B
    .locals 5
    .param p0, "bmp"    # Landroid/graphics/Bitmap;
    .param p1, "needRecycle"    # Z

    .prologue
    .line 261
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 262
    .local v1, "output":Ljava/io/ByteArrayOutputStream;
    sget-object v3, Landroid/graphics/Bitmap$CompressFormat;->PNG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v4, 0x64

    invoke-virtual {p0, v3, v4, v1}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    .line 263
    if-eqz p1, :cond_0

    .line 264
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->recycle()V

    .line 267
    :cond_0
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    .line 269
    .local v2, "result":[B
    :try_start_0
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 274
    :goto_0
    return-object v2

    .line 270
    :catch_0
    move-exception v0

    .line 271
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private static buildTransaction(Ljava/lang/String;)Ljava/lang/String;
    .locals 4
    .param p0, "type"    # Ljava/lang/String;

    .prologue
    .line 286
    if-nez p0, :cond_0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method public static changedActivityOrientation(I)V
    .locals 2
    .param p0, "orientation"    # I

    .prologue
    .line 183
    sput p0, Lorg/cocos2dx/lua/AppActivity;->_orientation:I

    .line 185
    packed-switch p0, :pswitch_data_0

    .line 196
    :goto_0
    return-void

    .line 188
    :pswitch_0
    const-string v0, "debug\u00a0info"

    const-string v1, "\u8c03\u7528\u6a2a\u5c4f\u5207\u6362\u65b9\u6cd5"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 189
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    goto :goto_0

    .line 192
    :pswitch_1
    const-string v0, "debug\u00a0info"

    const-string v1, "\u8c03\u7528\u7ad6\u5c4f\u5207\u6362\u65b9\u6cd5"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 193
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lorg/cocos2dx/lua/AppActivity;->setRequestedOrientation(I)V

    goto :goto_0

    .line 185
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static checkApkExist(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 5
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "packageName"    # Ljava/lang/String;

    .prologue
    const/4 v2, 0x0

    .line 384
    if-eqz p1, :cond_0

    const-string v3, ""

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 390
    :cond_0
    :goto_0
    return v2

    .line 387
    :cond_1
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v3

    const/16 v4, 0x2000

    invoke-virtual {v3, p1, v4}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v1

    .line 388
    .local v1, "info":Landroid/content/pm/ApplicationInfo;
    const/4 v2, 0x1

    goto :goto_0

    .line 389
    .end local v1    # "info":Landroid/content/pm/ApplicationInfo;
    :catch_0
    move-exception v0

    .line 390
    .local v0, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    goto :goto_0
.end method

.method public static clearStartParams()V
    .locals 1

    .prologue
    .line 373
    const-string v0, ""

    sput-object v0, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    .line 374
    return-void
.end method

.method public static getAppPackageName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 344
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->getPackageInfo()Landroid/content/pm/PackageInfo;

    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    return-object v0
.end method

.method public static getDeviceBrand()Ljava/lang/String;
    .locals 2

    .prologue
    .line 421
    const-string v0, "info"

    const-string v1, "getDeviceBrand: "

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 422
    sget-object v0, Landroid/os/Build;->BRAND:Ljava/lang/String;

    return-object v0
.end method

.method public static getDeviceUUID()Ljava/lang/String;
    .locals 7

    .prologue
    .line 305
    const-string v0, ""

    .line 307
    .local v0, "deviceId":Ljava/lang/String;
    :try_start_0
    sget-object v4, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v5, "phone"

    invoke-virtual {v4, v5}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/telephony/TelephonyManager;

    .line 308
    .local v3, "tm":Landroid/telephony/TelephonyManager;
    invoke-virtual {v3}, Landroid/telephony/TelephonyManager;->getDeviceId()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    .line 313
    .end local v3    # "tm":Landroid/telephony/TelephonyManager;
    :goto_0
    if-eqz v0, :cond_0

    const-string v4, ""

    if-ne v0, v4, :cond_1

    .line 315
    :cond_0
    :try_start_1
    sget-object v4, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v4}, Lorg/cocos2dx/lua/AppActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    const-string v5, "android_id"

    invoke-static {v4, v5}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v0

    .line 322
    :cond_1
    :goto_1
    if-eqz v0, :cond_2

    const-string v4, ""

    if-ne v0, v4, :cond_3

    .line 323
    :cond_2
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v4

    const-string v5, "-"

    const-string v6, ""

    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 326
    :cond_3
    return-object v0

    .line 309
    :catch_0
    move-exception v1

    .line 310
    .local v1, "e1":Ljava/lang/Exception;
    const-string v0, ""

    goto :goto_0

    .line 317
    .end local v1    # "e1":Ljava/lang/Exception;
    :catch_1
    move-exception v2

    .line 318
    .local v2, "e2":Ljava/lang/Exception;
    const-string v0, ""

    goto :goto_1
.end method

.method public static getInstall(II)V
    .locals 0
    .param p0, "s"    # I
    .param p1, "luaFunc"    # I

    .prologue
    .line 466
    return-void
.end method

.method public static getMarketVersion()I
    .locals 1

    .prologue
    .line 442
    const/4 v0, 0x1

    return v0
.end method

.method private static getPackageInfo()Landroid/content/pm/PackageInfo;
    .locals 5

    .prologue
    .line 348
    const/4 v1, 0x0

    .line 351
    .local v1, "pi":Landroid/content/pm/PackageInfo;
    :try_start_0
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v3}, Lorg/cocos2dx/lua/AppActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v2

    .line 352
    .local v2, "pm":Landroid/content/pm/PackageManager;
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v3}, Lorg/cocos2dx/lua/AppActivity;->getPackageName()Ljava/lang/String;

    move-result-object v3

    const/16 v4, 0x4000

    invoke-virtual {v2, v3, v4}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v1

    .line 359
    .end local v2    # "pm":Landroid/content/pm/PackageManager;
    :goto_0
    return-object v1

    .line 355
    :catch_0
    move-exception v0

    .line 356
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static getPhoneName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 363
    sget-object v0, Landroid/os/Build;->MANUFACTURER:Ljava/lang/String;

    return-object v0
.end method

.method public static getStartParams()Ljava/lang/String;
    .locals 1

    .prologue
    .line 368
    sget-object v0, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    return-object v0
.end method

.method public static getSystemModel()Ljava/lang/String;
    .locals 2

    .prologue
    .line 411
    const-string v0, "info"

    const-string v1, "getSystemModel: "

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 412
    sget-object v0, Landroid/os/Build;->MODEL:Ljava/lang/String;

    return-object v0
.end method

.method public static getSystemVersion()Ljava/lang/String;
    .locals 2

    .prologue
    .line 431
    const-string v0, "info"

    const-string v1, "getSystemVersion: "

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 432
    sget-object v0, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    return-object v0
.end method

.method public static getVersionCode()I
    .locals 1

    .prologue
    .line 336
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->getPackageInfo()Landroid/content/pm/PackageInfo;

    move-result-object v0

    iget v0, v0, Landroid/content/pm/PackageInfo;->versionCode:I

    return v0
.end method

.method public static getVersionName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 331
    invoke-static {}, Lorg/cocos2dx/lua/AppActivity;->getPackageInfo()Landroid/content/pm/PackageInfo;

    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    return-object v0
.end method

.method public static installationAPK(Ljava/lang/String;)V
    .locals 0
    .param p0, "apkUrl"    # Ljava/lang/String;

    .prologue
    .line 403
    return-void
.end method

.method public static isApkInstalled(Ljava/lang/String;)Z
    .locals 3
    .param p0, "packageName"    # Ljava/lang/String;

    .prologue
    .line 218
    :try_start_0
    sget-object v1, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v1}, Lorg/cocos2dx/lua/AppActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    const/16 v2, 0x2000

    invoke-virtual {v1, p0, v2}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;
    :try_end_0
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    .line 219
    const/4 v1, 0x1

    .line 221
    :goto_0
    return v1

    .line 220
    :catch_0
    move-exception v0

    .line 221
    .local v0, "e":Landroid/content/pm/PackageManager$NameNotFoundException;
    const/4 v1, 0x0

    goto :goto_0
.end method

.method public static isWXAppInstalled()Z
    .locals 1

    .prologue
    .line 200
    const/4 v0, 0x0

    .line 201
    .local v0, "result":Z
    return v0
.end method

.method public static isWXAppSupportApi()Z
    .locals 1

    .prologue
    .line 206
    const/4 v0, 0x0

    .line 207
    .local v0, "result":Z
    return v0
.end method

.method public static native onRespJNI(Ljava/lang/String;I)V
.end method

.method public static onRunOtherAPP(Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "packageStr"    # Ljava/lang/String;
    .param p1, "clsStr"    # Ljava/lang/String;

    .prologue
    const/4 v5, 0x0

    .line 227
    if-eqz p0, :cond_0

    const-string v3, ""

    invoke-virtual {v3, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 228
    :cond_0
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v4, "\u542f\u52a8\u53c2\u6570\u51fa\u9519"

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    .line 254
    :goto_0
    return-void

    .line 231
    :cond_1
    if-eqz p1, :cond_2

    const-string v3, ""

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 232
    :cond_2
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v4, "\u542f\u52a8\u53c2\u6570\u51fa\u9519"

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 236
    :cond_3
    :try_start_0
    new-instance v2, Landroid/content/Intent;

    invoke-direct {v2}, Landroid/content/Intent;-><init>()V

    .line 237
    .local v2, "intent":Landroid/content/Intent;
    new-instance v0, Landroid/content/ComponentName;

    invoke-direct {v0, p0, p1}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 238
    .local v0, "cmp":Landroid/content/ComponentName;
    const-string v3, "android.intent.action.MAIN"

    invoke-virtual {v2, v3}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 239
    const-string v3, "android.intent.category.LAUNCHER"

    invoke-virtual {v2, v3}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 240
    const/high16 v3, 0x10000000

    invoke-virtual {v2, v3}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 241
    invoke-virtual {v2, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 242
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const/4 v4, 0x0

    invoke-virtual {v3, v2, v4}, Lorg/cocos2dx/lua/AppActivity;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 243
    .end local v0    # "cmp":Landroid/content/ComponentName;
    .end local v2    # "intent":Landroid/content/Intent;
    :catch_0
    move-exception v1

    .line 245
    .local v1, "e":Ljava/lang/Exception;
    const-string v3, "com.tencent.mobileqq"

    invoke-virtual {p0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_4

    .line 246
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v4, "\u65e0\u6cd5\u8df3\u8f6c\u5230QQ\uff0c\u8bf7\u68c0\u67e5\u60a8\u662f\u5426\u5b89\u88c5\u4e86QQ"

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 247
    :cond_4
    const-string v3, "com.tencent.mm"

    invoke-virtual {p0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_5

    .line 248
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v4, "\u65e0\u6cd5\u8df3\u8f6c\u5230\u5fae\u4fe1\uff0c\u8bf7\u68c0\u67e5\u60a8\u662f\u5426\u5b89\u88c5\u4e86\u5fae\u4fe1"

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 250
    :cond_5
    const-string v3, "info"

    const-string v4, "onRunOtherAPP: \u8df3\u8f6c\u51fa\u9519"

    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 251
    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    const-string v4, "\u8df3\u8f6c\u5230\u7b2c\u4e09\u65b9\u7a0b\u5e8f\u51fa\u9519"

    invoke-static {v3, v4, v5}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v3

    invoke-virtual {v3}, Landroid/widget/Toast;->show()V

    goto :goto_0
.end method

.method public static native onShareRespJNI(I)V
.end method

.method public static onStartApp(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "packageStr"    # Ljava/lang/String;
    .param p1, "clsStr"    # Ljava/lang/String;
    .param p2, "dataStr"    # Ljava/lang/String;

    .prologue
    .line 447
    const-string v4, "info"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "packageStr="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " clsStr = "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 449
    :try_start_0
    new-instance v3, Landroid/content/Intent;

    invoke-direct {v3}, Landroid/content/Intent;-><init>()V

    .line 450
    .local v3, "intent":Landroid/content/Intent;
    new-instance v1, Landroid/content/ComponentName;

    invoke-direct {v1, p0, p1}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 451
    .local v1, "cmp":Landroid/content/ComponentName;
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 452
    .local v0, "bundle":Landroid/os/Bundle;
    const-string v4, "bbyldata"

    invoke-virtual {v0, v4, p2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 453
    invoke-virtual {v3, v0}, Landroid/content/Intent;->putExtras(Landroid/os/Bundle;)Landroid/content/Intent;

    .line 454
    const-string v4, "android.intent.action.MAIN"

    invoke-virtual {v3, v4}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 455
    const-string v4, "android.intent.category.LAUNCHER"

    invoke-virtual {v3, v4}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    .line 456
    const/high16 v4, 0x10000000

    invoke-virtual {v3, v4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 457
    invoke-virtual {v3, v1}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    .line 458
    sget-object v4, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    invoke-virtual {v4, v3}, Lorg/cocos2dx/lua/AppActivity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 462
    .end local v0    # "bundle":Landroid/os/Bundle;
    .end local v1    # "cmp":Landroid/content/ComponentName;
    .end local v3    # "intent":Landroid/content/Intent;
    :goto_0
    return-void

    .line 459
    :catch_0
    move-exception v2

    .line 460
    .local v2, "e":Ljava/lang/Exception;
    const-string v4, "info"

    const-string v5, "\u542f\u52a8\u9519\u8bef"

    invoke-static {v4, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public static native onThirdStartRespJNI(Ljava/lang/String;)V
.end method

.method public static payV2(Ljava/lang/String;I)V
    .locals 0
    .param p0, "orderInfo"    # Ljava/lang/String;
    .param p1, "luaFunc"    # I

    .prologue
    .line 302
    return-void
.end method

.method public static registerWakeupCallback(I)V
    .locals 0
    .param p0, "luaFunc"    # I

    .prologue
    .line 470
    return-void
.end method

.method public static registerWeixin(Ljava/lang/String;)V
    .locals 0
    .param p0, "appID"    # Ljava/lang/String;

    .prologue
    .line 213
    return-void
.end method

.method public static reportEffectPoint(Ljava/lang/String;I)V
    .locals 0
    .param p0, "pointId"    # Ljava/lang/String;
    .param p1, "pointValue"    # I

    .prologue
    .line 474
    return-void
.end method

.method public static sendAuthRequest()V
    .locals 0

    .prologue
    .line 258
    return-void
.end method

.method public static shareImageToWeixin(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0
    .param p0, "thumbImagepath"    # Ljava/lang/String;
    .param p1, "imagepath"    # Ljava/lang/String;
    .param p2, "type"    # I

    .prologue
    .line 283
    return-void
.end method

.method public static shareWebToWeixin(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0
    .param p0, "title"    # Ljava/lang/String;
    .param p1, "description"    # Ljava/lang/String;
    .param p2, "image"    # Ljava/lang/String;
    .param p3, "webpageUrl"    # Ljava/lang/String;
    .param p4, "type"    # I

    .prologue
    .line 279
    return-void
.end method


# virtual methods
.method public getFrameLayout()Landroid/widget/FrameLayout;
    .locals 1

    .prologue
    .line 135
    iget-object v0, p0, Lorg/cocos2dx/lua/AppActivity;->mFrameLayout:Lorg/cocos2dx/lib/ResizeLayout;

    return-object v0
.end method

.method public isMainProcess()Z
    .locals 5

    .prologue
    .line 120
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v2

    .line 121
    .local v2, "pid":I
    const-string v3, "activity"

    invoke-virtual {p0, v3}, Lorg/cocos2dx/lua/AppActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/ActivityManager;

    .line 122
    .local v0, "activityManager":Landroid/app/ActivityManager;
    invoke-virtual {v0}, Landroid/app/ActivityManager;->getRunningAppProcesses()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/ActivityManager$RunningAppProcessInfo;

    .line 123
    .local v1, "appProcess":Landroid/app/ActivityManager$RunningAppProcessInfo;
    iget v4, v1, Landroid/app/ActivityManager$RunningAppProcessInfo;->pid:I

    if-ne v4, v2, :cond_0

    .line 124
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v3

    iget-object v3, v3, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    iget-object v4, v1, Landroid/app/ActivityManager$RunningAppProcessInfo;->processName:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    .line 127
    .end local v1    # "appProcess":Landroid/app/ActivityManager$RunningAppProcessInfo;
    :goto_0
    return v3

    :cond_1
    const/4 v3, 0x0

    goto :goto_0
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .prologue
    .line 159
    const-string v0, "AppActivity"

    const-string v1, "\u8c03\u7528\u8fd4\u56de"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 160
    invoke-super {p0, p1, p2, p3}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onActivityResult(IILandroid/content/Intent;)V

    .line 163
    const/4 v0, 0x1

    if-eq p1, v0, :cond_0

    const/4 v0, 0x2

    if-eq p1, v0, :cond_0

    const/4 v0, 0x3

    if-ne p1, v0, :cond_1

    .line 165
    :cond_0
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v0

    invoke-virtual {v0, p1, p2, p3}, Lcom/qianniao/ImagePicker;->onActivityResult(IILandroid/content/Intent;)V

    .line 167
    :cond_1
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 7
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 82
    invoke-super {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onCreate(Landroid/os/Bundle;)V

    .line 83
    sput-object p0, Lorg/cocos2dx/lua/AppActivity;->instance:Lorg/cocos2dx/lua/AppActivity;

    .line 84
    sput-object p0, Lorg/cocos2dx/lua/AppActivity;->cocos2dxActivity:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 86
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->isMainProcess()Z

    move-result v4

    if-eqz v4, :cond_0

    .line 90
    :cond_0
    invoke-static {}, Lcom/qianniao/zbarscanner/ZbarManager;->getInstance()Lcom/qianniao/zbarscanner/ZbarManager;

    move-result-object v4

    invoke-virtual {v4, p0}, Lcom/qianniao/zbarscanner/ZbarManager;->setAppActivity(Lorg/cocos2dx/lua/AppActivity;)V

    .line 91
    invoke-static {}, Lcom/qianniao/ImagePicker;->getInstance()Lcom/qianniao/ImagePicker;

    move-result-object v4

    invoke-virtual {v4, p0}, Lcom/qianniao/ImagePicker;->setAppActivity(Landroid/app/Activity;)V

    .line 92
    invoke-static {}, Lcom/qianniao/Pasteboard;->getInstance()Lcom/qianniao/Pasteboard;

    move-result-object v4

    invoke-virtual {v4, p0}, Lcom/qianniao/Pasteboard;->setAppActivity(Landroid/app/Activity;)V

    .line 94
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->registerMessageReceiver()V

    .line 98
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getIntent()Landroid/content/Intent;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    .line 99
    .local v0, "bundle":Landroid/os/Bundle;
    if-eqz v0, :cond_3

    const-string v4, "bbyldata"

    invoke-virtual {v0, v4}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_3

    .line 100
    const-string v4, "bbyldata"

    invoke-virtual {v0, v4}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    sput-object v4, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    .line 101
    const-string v4, "info"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "startParams2: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget-object v6, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 114
    :cond_1
    :goto_0
    sget v4, Lorg/cocos2dx/lua/AppActivity;->_orientation:I

    const/4 v5, 0x1

    if-ne v4, v5, :cond_2

    .line 115
    sget v4, Lorg/cocos2dx/lua/AppActivity;->_orientation:I

    invoke-static {v4}, Lorg/cocos2dx/lua/AppActivity;->changedActivityOrientation(I)V

    .line 117
    :cond_2
    return-void

    .line 103
    :cond_3
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getIntent()Landroid/content/Intent;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v1

    .line 104
    .local v1, "intentAction":Ljava/lang/String;
    const-string v4, "android.intent.action.VIEW"

    invoke-virtual {v4, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 105
    invoke-virtual {p0}, Lorg/cocos2dx/lua/AppActivity;->getIntent()Landroid/content/Intent;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v2

    .line 106
    .local v2, "intentData":Landroid/net/Uri;
    if-eqz v2, :cond_1

    .line 107
    invoke-virtual {v2}, Landroid/net/Uri;->getQuery()Ljava/lang/String;

    move-result-object v3

    .line 108
    .local v3, "name":Ljava/lang/String;
    sput-object v3, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    .line 109
    const-string v4, "info"

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "startParams: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget-object v6, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method protected onDestroy()V
    .locals 0

    .prologue
    .line 140
    invoke-super {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onDestroy()V

    .line 141
    return-void
.end method

.method protected onNewIntent(Landroid/content/Intent;)V
    .locals 4
    .param p1, "intent"    # Landroid/content/Intent;

    .prologue
    .line 145
    invoke-super {p0, p1}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onNewIntent(Landroid/content/Intent;)V

    .line 147
    if-eqz p1, :cond_0

    .line 148
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    .line 149
    .local v0, "bundle":Landroid/os/Bundle;
    if-eqz v0, :cond_0

    const-string v1, "bbyldata"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 150
    const-string v1, "bbyldata"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    .line 151
    const-string v1, "info"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "startParams5: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v3, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 152
    sget-object v1, Lorg/cocos2dx/lua/AppActivity;->startParams:Ljava/lang/String;

    invoke-static {v1}, Lorg/cocos2dx/lua/AppActivity;->onThirdStartRespJNI(Ljava/lang/String;)V

    .line 155
    .end local v0    # "bundle":Landroid/os/Bundle;
    :cond_0
    return-void
.end method

.method protected onPause()V
    .locals 1

    .prologue
    .line 178
    const/4 v0, 0x0

    sput-boolean v0, Lorg/cocos2dx/lua/AppActivity;->isForeground:Z

    .line 179
    invoke-super {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onPause()V

    .line 180
    return-void
.end method

.method protected onResume()V
    .locals 1

    .prologue
    .line 171
    const/4 v0, 0x1

    sput-boolean v0, Lorg/cocos2dx/lua/AppActivity;->isForeground:Z

    .line 172
    invoke-super {p0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->onResume()V

    .line 173
    return-void
.end method

.method public registerMessageReceiver()V
    .locals 0

    .prologue
    .line 132
    return-void
.end method
