.class public Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
.super Ljava/lang/Object;
.source "BarcodeFormat.java"


# static fields
.field public static final ALL_FORMATS:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List",
            "<",
            "Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;",
            ">;"
        }
    .end annotation
.end field

.field public static final CODABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final CODE128:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final CODE39:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final CODE93:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final DATABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final DATABAR_EXP:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final EAN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final EAN8:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final I25:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final ISBN10:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final ISBN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final NONE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final PARTIAL:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final PDF417:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final QRCODE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final UPCA:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

.field public static final UPCE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;


# instance fields
.field private mId:I

.field private mName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .prologue
    .line 12
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/4 v1, 0x0

    const-string v2, "NONE"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->NONE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 13
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/4 v1, 0x1

    const-string v2, "PARTIAL"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->PARTIAL:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 14
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x8

    const-string v2, "EAN8"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->EAN8:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 15
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x9

    const-string v2, "UPCE"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->UPCE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 16
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0xa

    const-string v2, "ISBN10"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ISBN10:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 17
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0xc

    const-string v2, "UPCA"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->UPCA:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 18
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0xd

    const-string v2, "EAN13"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->EAN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 19
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0xe

    const-string v2, "ISBN13"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ISBN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 20
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x19

    const-string v2, "I25"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->I25:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 21
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x22

    const-string v2, "DATABAR"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->DATABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 22
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x23

    const-string v2, "DATABAR_EXP"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->DATABAR_EXP:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 23
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x26

    const-string v2, "CODABAR"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 24
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x27

    const-string v2, "CODE39"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE39:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 25
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x39

    const-string v2, "PDF417"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->PDF417:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 26
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x40

    const-string v2, "QRCODE"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->QRCODE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 27
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x5d

    const-string v2, "CODE93"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE93:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 28
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    const/16 v1, 0x80

    const-string v2, "CODE128"

    invoke-direct {v0, v1, v2}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;-><init>(ILjava/lang/String;)V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE128:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 30
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    .line 33
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->PARTIAL:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 34
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->EAN8:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 35
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->UPCE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 36
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ISBN10:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 37
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->UPCA:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 38
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->EAN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 39
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ISBN13:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 40
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->I25:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 41
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->DATABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 42
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->DATABAR_EXP:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 43
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODABAR:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 44
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE39:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 45
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->PDF417:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 46
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->QRCODE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 47
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE93:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 48
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->CODE128:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 49
    return-void
.end method

.method public constructor <init>(ILjava/lang/String;)V
    .locals 0
    .param p1, "id"    # I
    .param p2, "name"    # Ljava/lang/String;

    .prologue
    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    iput p1, p0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->mId:I

    .line 53
    iput-object p2, p0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->mName:Ljava/lang/String;

    .line 54
    return-void
.end method

.method public static getFormatById(I)Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
    .locals 3
    .param p0, "id"    # I

    .prologue
    .line 65
    sget-object v1, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->ALL_FORMATS:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    .line 66
    .local v0, "format":Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->getId()I

    move-result v2

    if-ne v2, p0, :cond_0

    .line 70
    .end local v0    # "format":Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;
    :goto_0
    return-object v0

    :cond_1
    sget-object v0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->NONE:Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;

    goto :goto_0
.end method


# virtual methods
.method public getId()I
    .locals 1

    .prologue
    .line 57
    iget v0, p0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->mId:I

    return v0
.end method

.method public getName()Ljava/lang/String;
    .locals 1

    .prologue
    .line 61
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/BarcodeFormat;->mName:Ljava/lang/String;

    return-object v0
.end method
