.class final Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;
.super Ljava/lang/Object;
.source "Cocos2dxEditBoxHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->setText(ILjava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$index:I

.field final synthetic val$text:Ljava/lang/String;


# direct methods
.method constructor <init>(ILjava/lang/String;)V
    .locals 0

    .prologue
    .line 331
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;->val$index:I

    iput-object p2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;->val$text:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .prologue
    .line 334
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$400()Landroid/util/SparseArray;

    move-result-object v2

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;->val$index:I

    invoke-virtual {v2, v3}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxEditBox;

    .line 335
    .local v0, "editBox":Lorg/cocos2dx/lib/Cocos2dxEditBox;
    if-eqz v0, :cond_0

    .line 336
    const/4 v2, 0x1

    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setChangedTextProgrammatically(Ljava/lang/Boolean;)V

    .line 337
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;->val$text:Ljava/lang/String;

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setText(Ljava/lang/CharSequence;)V

    .line 338
    iget-object v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$9;->val$text:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v1

    .line 339
    .local v1, "position":I
    invoke-virtual {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setSelection(I)V

    .line 341
    .end local v1    # "position":I
    :cond_0
    return-void
.end method
