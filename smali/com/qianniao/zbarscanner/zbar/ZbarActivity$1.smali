.class Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;
.super Ljava/lang/Object;
.source "ZbarActivity.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->initLayout()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;


# direct methods
.method constructor <init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    .prologue
    .line 62
    iput-object p1, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 1
    .param p1, "buttonView"    # Landroid/widget/CompoundButton;
    .param p2, "isChecked"    # Z

    .prologue
    .line 65
    if-eqz p2, :cond_0

    .line 66
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->openFlashlight()V

    .line 70
    :goto_0
    return-void

    .line 68
    :cond_0
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;->this$0:Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    iget-object v0, v0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->closeFlashlight()V

    goto :goto_0
.end method
