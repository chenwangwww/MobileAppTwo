.class public Lcom/qianniao/Pasteboard;
.super Ljava/lang/Object;
.source "Pasteboard.java"


# static fields
.field private static TAG:Ljava/lang/String;

.field static _instance:Lcom/qianniao/Pasteboard;


# instance fields
.field private activity:Landroid/app/Activity;

.field final copyrunnable:Ljava/lang/Runnable;

.field private isRunHand:Z

.field final pasterunnable:Ljava/lang/Runnable;

.field private systemCopyStr:Ljava/lang/String;

.field private systemPasteStr:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 14
    const/4 v0, 0x0

    sput-object v0, Lcom/qianniao/Pasteboard;->_instance:Lcom/qianniao/Pasteboard;

    .line 18
    const-string v0, "Pasteboard"

    sput-object v0, Lcom/qianniao/Pasteboard;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .prologue
    const/4 v0, 0x0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 16
    iput-object v0, p0, Lcom/qianniao/Pasteboard;->activity:Landroid/app/Activity;

    .line 20
    iput-object v0, p0, Lcom/qianniao/Pasteboard;->systemCopyStr:Ljava/lang/String;

    .line 21
    const-string v0, ""

    iput-object v0, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;

    .line 22
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/qianniao/Pasteboard;->isRunHand:Z

    .line 38
    new-instance v0, Lcom/qianniao/Pasteboard$1;

    invoke-direct {v0, p0}, Lcom/qianniao/Pasteboard$1;-><init>(Lcom/qianniao/Pasteboard;)V

    iput-object v0, p0, Lcom/qianniao/Pasteboard;->copyrunnable:Ljava/lang/Runnable;

    .line 46
    new-instance v0, Lcom/qianniao/Pasteboard$2;

    invoke-direct {v0, p0}, Lcom/qianniao/Pasteboard$2;-><init>(Lcom/qianniao/Pasteboard;)V

    iput-object v0, p0, Lcom/qianniao/Pasteboard;->pasterunnable:Ljava/lang/Runnable;

    .line 32
    return-void
.end method

.method static synthetic access$000(Lcom/qianniao/Pasteboard;)Landroid/app/Activity;
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/Pasteboard;

    .prologue
    .line 13
    iget-object v0, p0, Lcom/qianniao/Pasteboard;->activity:Landroid/app/Activity;

    return-object v0
.end method

.method static synthetic access$100(Lcom/qianniao/Pasteboard;)Ljava/lang/String;
    .locals 1
    .param p0, "x0"    # Lcom/qianniao/Pasteboard;

    .prologue
    .line 13
    iget-object v0, p0, Lcom/qianniao/Pasteboard;->systemCopyStr:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$202(Lcom/qianniao/Pasteboard;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .param p0, "x0"    # Lcom/qianniao/Pasteboard;
    .param p1, "x1"    # Ljava/lang/String;

    .prologue
    .line 13
    iput-object p1, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;

    return-object p1
.end method

.method static synthetic access$302(Lcom/qianniao/Pasteboard;Z)Z
    .locals 0
    .param p0, "x0"    # Lcom/qianniao/Pasteboard;
    .param p1, "x1"    # Z

    .prologue
    .line 13
    iput-boolean p1, p0, Lcom/qianniao/Pasteboard;->isRunHand:Z

    return p1
.end method

.method public static getInstance()Lcom/qianniao/Pasteboard;
    .locals 1

    .prologue
    .line 24
    sget-object v0, Lcom/qianniao/Pasteboard;->_instance:Lcom/qianniao/Pasteboard;

    if-nez v0, :cond_0

    .line 25
    new-instance v0, Lcom/qianniao/Pasteboard;

    invoke-direct {v0}, Lcom/qianniao/Pasteboard;-><init>()V

    sput-object v0, Lcom/qianniao/Pasteboard;->_instance:Lcom/qianniao/Pasteboard;

    .line 27
    :cond_0
    sget-object v0, Lcom/qianniao/Pasteboard;->_instance:Lcom/qianniao/Pasteboard;

    return-object v0
.end method

.method public static systemCopy(Ljava/lang/String;)V
    .locals 1
    .param p0, "str"    # Ljava/lang/String;

    .prologue
    .line 113
    invoke-static {}, Lcom/qianniao/Pasteboard;->getInstance()Lcom/qianniao/Pasteboard;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/qianniao/Pasteboard;->_systemCopy(Ljava/lang/String;)V

    .line 114
    return-void
.end method

.method public static systemPaste()Ljava/lang/String;
    .locals 1

    .prologue
    .line 117
    invoke-static {}, Lcom/qianniao/Pasteboard;->getInstance()Lcom/qianniao/Pasteboard;

    move-result-object v0

    invoke-virtual {v0}, Lcom/qianniao/Pasteboard;->_systemPaste()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method _systemCopy(Ljava/lang/String;)V
    .locals 1
    .param p1, "str"    # Ljava/lang/String;

    .prologue
    .line 62
    iput-object p1, p0, Lcom/qianniao/Pasteboard;->systemCopyStr:Ljava/lang/String;

    .line 63
    new-instance v0, Lcom/qianniao/Pasteboard$3;

    invoke-direct {v0, p0}, Lcom/qianniao/Pasteboard$3;-><init>(Lcom/qianniao/Pasteboard;)V

    .line 67
    invoke-virtual {v0}, Lcom/qianniao/Pasteboard$3;->start()V

    .line 68
    return-void
.end method

.method _systemPaste()Ljava/lang/String;
    .locals 6

    .prologue
    .line 71
    const-string v4, ""

    iput-object v4, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;

    .line 74
    :try_start_0
    iget-object v4, p0, Lcom/qianniao/Pasteboard;->activity:Landroid/app/Activity;

    const-string v5, "clipboard"

    invoke-virtual {v4, v5}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    .line 75
    .local v0, "cm":Landroid/content/ClipboardManager;
    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getText()Ljava/lang/CharSequence;

    move-result-object v4

    if-nez v4, :cond_0

    .line 76
    const-string v4, ""

    iput-object v4, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;

    .line 82
    :goto_0
    iget-object v4, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;

    .line 107
    .end local v0    # "cm":Landroid/content/ClipboardManager;
    :goto_1
    return-object v4

    .line 79
    .restart local v0    # "cm":Landroid/content/ClipboardManager;
    :cond_0
    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getText()Ljava/lang/CharSequence;

    move-result-object v4

    invoke-interface {v4}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v4

    iput-object v4, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 83
    .end local v0    # "cm":Landroid/content/ClipboardManager;
    :catch_0
    move-exception v1

    .line 86
    .local v1, "e":Ljava/lang/Exception;
    :try_start_1
    new-instance v3, Lcom/qianniao/Pasteboard$4;

    invoke-direct {v3, p0}, Lcom/qianniao/Pasteboard$4;-><init>(Lcom/qianniao/Pasteboard;)V

    .line 102
    .local v3, "th":Ljava/lang/Thread;
    invoke-virtual {v3}, Ljava/lang/Thread;->start()V

    .line 104
    invoke-virtual {v3}, Ljava/lang/Thread;->join()V

    .line 105
    iget-object v4, p0, Lcom/qianniao/Pasteboard;->systemPasteStr:Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    .line 106
    .end local v3    # "th":Ljava/lang/Thread;
    :catch_1
    move-exception v2

    .line 107
    .local v2, "e2":Ljava/lang/Exception;
    const-string v4, ""

    goto :goto_1
.end method

.method public setAppActivity(Landroid/app/Activity;)V
    .locals 0
    .param p1, "activity"    # Landroid/app/Activity;

    .prologue
    .line 35
    iput-object p1, p0, Lcom/qianniao/Pasteboard;->activity:Landroid/app/Activity;

    .line 36
    return-void
.end method
