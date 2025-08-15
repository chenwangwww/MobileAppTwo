.class Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;
.super Ljava/lang/Object;
.source "Cocos2dxEditBoxHelper.java"

# interfaces
.implements Landroid/widget/TextView$OnEditorActionListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;

.field final synthetic val$editBox:Lorg/cocos2dx/lib/Cocos2dxEditBox;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;Lorg/cocos2dx/lib/Cocos2dxEditBox;)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;

    .prologue
    .line 200
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;->this$0:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;

    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;->val$editBox:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onEditorAction(Landroid/widget/TextView;ILandroid/view/KeyEvent;)Z
    .locals 2
    .param p1, "v"    # Landroid/widget/TextView;
    .param p2, "actionId"    # I
    .param p3, "event"    # Landroid/view/KeyEvent;

    .prologue
    const/4 v0, 0x1

    .line 203
    const/4 v1, 0x5

    if-ne p2, v1, :cond_0

    .line 204
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;->val$editBox:Lorg/cocos2dx/lib/Cocos2dxEditBox;

    iput v0, v1, Lorg/cocos2dx/lib/Cocos2dxEditBox;->endAction:I

    .line 205
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;->this$0:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;

    iget v1, v1, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$index:I

    invoke-static {v1}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$300(I)V

    .line 210
    :goto_0
    return v0

    .line 207
    :cond_0
    const/4 v0, 0x6

    if-ne p2, v0, :cond_1

    .line 208
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;->this$0:Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;

    iget v0, v0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$index:I

    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$300(I)V

    .line 210
    :cond_1
    const/4 v0, 0x0

    goto :goto_0
.end method
