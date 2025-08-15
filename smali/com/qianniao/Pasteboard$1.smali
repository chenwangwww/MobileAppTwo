.class Lcom/qianniao/Pasteboard$1;
.super Ljava/lang/Object;
.source "Pasteboard.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/qianniao/Pasteboard;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/qianniao/Pasteboard;


# direct methods
.method constructor <init>(Lcom/qianniao/Pasteboard;)V
    .locals 0
    .param p1, "this$0"    # Lcom/qianniao/Pasteboard;

    .prologue
    .line 38
    iput-object p1, p0, Lcom/qianniao/Pasteboard$1;->this$0:Lcom/qianniao/Pasteboard;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .prologue
    .line 41
    iget-object v1, p0, Lcom/qianniao/Pasteboard$1;->this$0:Lcom/qianniao/Pasteboard;

    invoke-static {v1}, Lcom/qianniao/Pasteboard;->access$000(Lcom/qianniao/Pasteboard;)Landroid/app/Activity;

    move-result-object v1

    const-string v2, "clipboard"

    invoke-virtual {v1, v2}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    .line 42
    .local v0, "cm":Landroid/content/ClipboardManager;
    iget-object v1, p0, Lcom/qianniao/Pasteboard$1;->this$0:Lcom/qianniao/Pasteboard;

    invoke-static {v1}, Lcom/qianniao/Pasteboard;->access$100(Lcom/qianniao/Pasteboard;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/content/ClipboardManager;->setText(Ljava/lang/CharSequence;)V

    .line 43
    return-void
.end method
