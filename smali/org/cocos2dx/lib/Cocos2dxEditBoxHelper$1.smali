.class final Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;
.super Ljava/lang/Object;
.source "Cocos2dxEditBoxHelper.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->createEditBox(IIIIF)I
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$height:I

.field final synthetic val$index:I

.field final synthetic val$left:I

.field final synthetic val$scaleX:F

.field final synthetic val$top:I

.field final synthetic val$width:I


# direct methods
.method constructor <init>(FIIIII)V
    .locals 0

    .prologue
    .line 85
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$scaleX:F

    iput p2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$left:I

    iput p3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$top:I

    iput p4, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$width:I

    iput p5, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$height:I

    iput p6, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$index:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 6

    .prologue
    const/4 v5, 0x1

    const/4 v4, -0x2

    const/4 v3, 0x0

    .line 88
    new-instance v0, Lorg/cocos2dx/lib/Cocos2dxEditBox;

    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$000()Lorg/cocos2dx/lib/Cocos2dxActivity;

    move-result-object v2

    invoke-direct {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;-><init>(Landroid/content/Context;)V

    .line 89
    .local v0, "editBox":Lorg/cocos2dx/lib/Cocos2dxEditBox;
    invoke-virtual {v0, v5}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setFocusable(Z)V

    .line 90
    invoke-virtual {v0, v5}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setFocusableInTouchMode(Z)V

    .line 91
    const/4 v2, 0x5

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setInputFlag(I)V

    .line 92
    const/4 v2, 0x6

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setInputMode(I)V

    .line 93
    invoke-virtual {v0, v3}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setReturnType(I)V

    .line 94
    const v2, -0x777778

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setHintTextColor(I)V

    .line 96
    const/16 v2, 0x8

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setVisibility(I)V

    .line 97
    invoke-virtual {v0, v3}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setBackgroundColor(I)V

    .line 98
    const/4 v2, -0x1

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTextColor(I)V

    .line 99
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setSingleLine()V

    .line 100
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$scaleX:F

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setOpenGLViewScaleX(F)V

    .line 101
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$scaleX:F

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->getPadding(F)I

    move-result v2

    invoke-virtual {v0, v2, v3, v3, v3}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setPadding(IIII)V

    .line 104
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v1, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 108
    .local v1, "lParams":Landroid/widget/FrameLayout$LayoutParams;
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$left:I

    iput v2, v1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 109
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$top:I

    iput v2, v1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 110
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$width:I

    iput v2, v1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 111
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$height:I

    iput v2, v1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 112
    const/16 v2, 0x33

    iput v2, v1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 114
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$100()Lorg/cocos2dx/lib/ResizeLayout;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Lorg/cocos2dx/lib/ResizeLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 115
    invoke-static {v3}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v2

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTag(Ljava/lang/Object;)V

    .line 116
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$1;

    invoke-direct {v2, p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$1;-><init>(Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;Lorg/cocos2dx/lib/Cocos2dxEditBox;)V

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 147
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$2;

    invoke-direct {v2, p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$2;-><init>(Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;Lorg/cocos2dx/lib/Cocos2dxEditBox;)V

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 184
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$3;

    invoke-direct {v2, p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$3;-><init>(Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;Lorg/cocos2dx/lib/Cocos2dxEditBox;)V

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setOnKeyListener(Landroid/view/View$OnKeyListener;)V

    .line 200
    new-instance v2, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;

    invoke-direct {v2, p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1$4;-><init>(Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;Lorg/cocos2dx/lib/Cocos2dxEditBox;)V

    invoke-virtual {v0, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setOnEditorActionListener(Landroid/widget/TextView$OnEditorActionListener;)V

    .line 214
    invoke-static {}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->access$400()Landroid/util/SparseArray;

    move-result-object v2

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper$1;->val$index:I

    invoke-virtual {v2, v3, v0}, Landroid/util/SparseArray;->put(ILjava/lang/Object;)V

    .line 215
    return-void
.end method
