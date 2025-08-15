.class Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;
.super Lbutterknife/internal/DebouncingOnClickListener;
.source "ZbarActivity$$ViewBinder.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;->bind(Lbutterknife/ButterKnife$Finder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;Ljava/lang/Object;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;

.field final synthetic val$target:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;

    .prologue
    .line 17
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;"
    iput-object p1, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;

    iput-object p2, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;->val$target:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-direct {p0}, Lbutterknife/internal/DebouncingOnClickListener;-><init>()V

    return-void
.end method


# virtual methods
.method public doClick(Landroid/view/View;)V
    .locals 1
    .param p1, "p0"    # Landroid/view/View;

    .prologue
    .line 21
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;"
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;->val$target:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-virtual {v0, p1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->onClickBtn(Landroid/view/View;)V

    .line 22
    return-void
.end method
