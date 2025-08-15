.class public Lcom/qianniao/zbarscanner/ZbarManager;
.super Ljava/lang/Object;
.source "ZbarManager.java"


# static fields
.field private static _instance:Lcom/qianniao/zbarscanner/ZbarManager;


# instance fields
.field private _appActivity:Lorg/cocos2dx/lua/AppActivity;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 14
    const/4 v0, 0x0

    sput-object v0, Lcom/qianniao/zbarscanner/ZbarManager;->_instance:Lcom/qianniao/zbarscanner/ZbarManager;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private _startScanner()V
    .locals 1

    .prologue
    .line 31
    iget-object v0, p0, Lcom/qianniao/zbarscanner/ZbarManager;->_appActivity:Lorg/cocos2dx/lua/AppActivity;

    invoke-static {v0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->goZbarActivity(Landroid/app/Activity;)V

    .line 32
    return-void
.end method

.method public static analyzerImage(Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .param p0, "path"    # Ljava/lang/String;

    .prologue
    .line 41
    const-string v0, ""

    .line 42
    .local v0, "result":Ljava/lang/String;
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x13

    if-lt v1, v2, :cond_0

    .line 43
    invoke-static {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->syncDecodeQRCode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 48
    :goto_0
    return-object v0

    .line 45
    :cond_0
    invoke-static {p0}, Lcom/qianniao/zbarscanner/qrcode/QRCodeDecoder;->syncDecodeQRCode2(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method public static getInstance()Lcom/qianniao/zbarscanner/ZbarManager;
    .locals 1

    .prologue
    .line 20
    sget-object v0, Lcom/qianniao/zbarscanner/ZbarManager;->_instance:Lcom/qianniao/zbarscanner/ZbarManager;

    if-nez v0, :cond_0

    .line 21
    new-instance v0, Lcom/qianniao/zbarscanner/ZbarManager;

    invoke-direct {v0}, Lcom/qianniao/zbarscanner/ZbarManager;-><init>()V

    sput-object v0, Lcom/qianniao/zbarscanner/ZbarManager;->_instance:Lcom/qianniao/zbarscanner/ZbarManager;

    .line 22
    :cond_0
    sget-object v0, Lcom/qianniao/zbarscanner/ZbarManager;->_instance:Lcom/qianniao/zbarscanner/ZbarManager;

    return-object v0
.end method

.method public static startScanner()V
    .locals 2

    .prologue
    .line 36
    const-string v0, "ZbarManager"

    const-string v1, "c++ call startScanner"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 37
    invoke-static {}, Lcom/qianniao/zbarscanner/ZbarManager;->getInstance()Lcom/qianniao/zbarscanner/ZbarManager;

    move-result-object v0

    invoke-direct {v0}, Lcom/qianniao/zbarscanner/ZbarManager;->_startScanner()V

    .line 38
    return-void
.end method


# virtual methods
.method public native onZbarScannerComplete(Ljava/lang/String;)V
.end method

.method public setAppActivity(Lorg/cocos2dx/lua/AppActivity;)V
    .locals 0
    .param p1, "activity"    # Lorg/cocos2dx/lua/AppActivity;

    .prologue
    .line 27
    iput-object p1, p0, Lcom/qianniao/zbarscanner/ZbarManager;->_appActivity:Lorg/cocos2dx/lua/AppActivity;

    .line 28
    return-void
.end method
