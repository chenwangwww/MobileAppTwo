.class Lcom/qianniao/Pasteboard$2;
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
    .line 46
    iput-object p1, p0, Lcom/qianniao/Pasteboard$2;->this$0:Lcom/qianniao/Pasteboard;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .prologue
    .line 49
    iget-object v1, p0, Lcom/qianniao/Pasteboard$2;->this$0:Lcom/qianniao/Pasteboard;

    invoke-static {v1}, Lcom/qianniao/Pasteboard;->access$000(Lcom/qianniao/Pasteboard;)Landroid/app/Activity;

    move-result-object v1

    const-string v2, "clipboard"

    invoke-virtual {v1, v2}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    .line 50
    .local v0, "cm":Landroid/content/ClipboardManager;
    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getText()Ljava/lang/CharSequence;

    move-result-object v1

    if-nez v1, :cond_0

    .line 51
    iget-object v1, p0, Lcom/qianniao/Pasteboard$2;->this$0:Lcom/qianniao/Pasteboard;

    const-string v2, ""

    invoke-static {v1, v2}, Lcom/qianniao/Pasteboard;->access$202(Lcom/qianniao/Pasteboard;Ljava/lang/String;)Ljava/lang/String;

    .line 57
    :goto_0
    iget-object v1, p0, Lcom/qianniao/Pasteboard$2;->this$0:Lcom/qianniao/Pasteboard;

    const/4 v2, 0x0

    invoke-static {v1, v2}, Lcom/qianniao/Pasteboard;->access$302(Lcom/qianniao/Pasteboard;Z)Z

    .line 58
    return-void

    .line 54
    :cond_0
    iget-object v1, p0, Lcom/qianniao/Pasteboard$2;->this$0:Lcom/qianniao/Pasteboard;

    invoke-virtual {v0}, Landroid/content/ClipboardManager;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Lcom/qianniao/Pasteboard;->access$202(Lcom/qianniao/Pasteboard;Ljava/lang/String;)Ljava/lang/String;

    goto :goto_0
.end method
