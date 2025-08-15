.class public Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;
.super Ljava/lang/Object;
.source "ZbarActivity$$ViewBinder.java"

# interfaces
.implements Lbutterknife/ButterKnife$ViewBinder;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Lcom/qianniao/zbarscanner/zbar/ZbarActivity;",
        ">",
        "Ljava/lang/Object;",
        "Lbutterknife/ButterKnife$ViewBinder",
        "<TT;>;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 8
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder<TT;>;"
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bind(Lbutterknife/ButterKnife$Finder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;Ljava/lang/Object;)V
    .locals 4
    .param p1, "finder"    # Lbutterknife/ButterKnife$Finder;
    .param p3, "source"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lbutterknife/ButterKnife$Finder;",
            "TT;",
            "Ljava/lang/Object;",
            ")V"
        }
    .end annotation

    .prologue
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder<TT;>;"
    .local p2, "target":Lcom/qianniao/zbarscanner/zbar/ZbarActivity;, "TT;"
    const v3, 0x7f0c006e

    const v2, 0x7f0c006b

    .line 11
    const-string v1, "field \'mQRCodeView\'"

    invoke-virtual {p1, p3, v2, v1}, Lbutterknife/ButterKnife$Finder;->findRequiredView(Ljava/lang/Object;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 12
    .local v0, "view":Landroid/view/View;
    const-string v1, "field \'mQRCodeView\'"

    invoke-virtual {p1, v0, v2, v1}, Lbutterknife/ButterKnife$Finder;->castView(Landroid/view/View;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/qianniao/zbarscanner/zbar/ZBarView;

    iput-object v1, p2, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    .line 13
    const-string v1, "field \'toggleButton\'"

    invoke-virtual {p1, p3, v3, v1}, Lbutterknife/ButterKnife$Finder;->findRequiredView(Ljava/lang/Object;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .end local v0    # "view":Landroid/view/View;
    check-cast v0, Landroid/view/View;

    .line 14
    .restart local v0    # "view":Landroid/view/View;
    const-string v1, "field \'toggleButton\'"

    invoke-virtual {p1, v0, v3, v1}, Lbutterknife/ButterKnife$Finder;->castView(Landroid/view/View;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/widget/ToggleButton;

    iput-object v1, p2, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->toggleButton:Landroid/widget/ToggleButton;

    .line 15
    const v1, 0x7f0c006c

    const-string v2, "method \'onClickBtn\'"

    invoke-virtual {p1, p3, v1, v2}, Lbutterknife/ButterKnife$Finder;->findRequiredView(Ljava/lang/Object;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .end local v0    # "view":Landroid/view/View;
    check-cast v0, Landroid/view/View;

    .line 16
    .restart local v0    # "view":Landroid/view/View;
    new-instance v1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;

    invoke-direct {v1, p0, p2}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$1;-><init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 24
    const v1, 0x7f0c006d

    const-string v2, "method \'onClickBtn\'"

    invoke-virtual {p1, p3, v1, v2}, Lbutterknife/ButterKnife$Finder;->findRequiredView(Ljava/lang/Object;ILjava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .end local v0    # "view":Landroid/view/View;
    check-cast v0, Landroid/view/View;

    .line 25
    .restart local v0    # "view":Landroid/view/View;
    new-instance v1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$2;

    invoke-direct {v1, p0, p2}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder$2;-><init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 33
    return-void
.end method

.method public bridge synthetic bind(Lbutterknife/ButterKnife$Finder;Ljava/lang/Object;Ljava/lang/Object;)V
    .locals 0

    .prologue
    .line 8
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder<TT;>;"
    check-cast p2, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-virtual {p0, p1, p2, p3}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;->bind(Lbutterknife/ButterKnife$Finder;Lcom/qianniao/zbarscanner/zbar/ZbarActivity;Ljava/lang/Object;)V

    return-void
.end method

.method public unbind(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(TT;)V"
        }
    .end annotation

    .prologue
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder<TT;>;"
    .local p1, "target":Lcom/qianniao/zbarscanner/zbar/ZbarActivity;, "TT;"
    const/4 v0, 0x0

    .line 36
    iput-object v0, p1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    .line 37
    iput-object v0, p1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->toggleButton:Landroid/widget/ToggleButton;

    .line 38
    return-void
.end method

.method public bridge synthetic unbind(Ljava/lang/Object;)V
    .locals 0

    .prologue
    .line 8
    .local p0, "this":Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;, "Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder<TT;>;"
    check-cast p1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-virtual {p0, p1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$$ViewBinder;->unbind(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V

    return-void
.end method
