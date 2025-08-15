.class Lorg/cocos2dx/lib/VideoController$1;
.super Ljava/lang/Object;
.source "VideoController.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/lib/VideoController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lorg/cocos2dx/lib/VideoController;


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/VideoController;)V
    .locals 0
    .param p1, "this$0"    # Lorg/cocos2dx/lib/VideoController;

    .prologue
    .line 207
    iput-object p1, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 13
    .param p1, "holder"    # Landroid/view/SurfaceHolder;
    .param p2, "format"    # I
    .param p3, "w"    # I
    .param p4, "h"    # I

    .prologue
    .line 211
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    move/from16 v0, p3

    invoke-static {v5, v0}, Lorg/cocos2dx/lib/VideoController;->access$202(Lorg/cocos2dx/lib/VideoController;I)I

    .line 212
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    move/from16 v0, p4

    invoke-static {v5, v0}, Lorg/cocos2dx/lib/VideoController;->access$302(Lorg/cocos2dx/lib/VideoController;I)I

    .line 214
    const/16 v4, 0x32

    .line 215
    .local v4, "rw":I
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    new-instance v6, Landroid/graphics/RectF;

    const/high16 v7, 0x42c80000    # 100.0f

    const/high16 v8, 0x42c80000    # 100.0f

    const/16 v9, 0x96

    int-to-float v9, v9

    const/16 v10, 0x96

    int-to-float v10, v10

    invoke-direct {v6, v7, v8, v9, v10}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-static {v5, v6}, Lorg/cocos2dx/lib/VideoController;->access$402(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;

    .line 216
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    new-instance v6, Landroid/graphics/RectF;

    const/high16 v7, 0x42c80000    # 100.0f

    iget-object v8, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v8}, Lorg/cocos2dx/lib/VideoController;->access$300(Lorg/cocos2dx/lib/VideoController;)I

    move-result v8

    add-int/lit8 v8, v8, -0x64

    sub-int/2addr v8, v4

    int-to-float v8, v8

    const/16 v9, 0x96

    int-to-float v9, v9

    iget-object v10, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v10}, Lorg/cocos2dx/lib/VideoController;->access$300(Lorg/cocos2dx/lib/VideoController;)I

    move-result v10

    add-int/lit8 v10, v10, -0x64

    int-to-float v10, v10

    invoke-direct {v6, v7, v8, v9, v10}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-static {v5, v6}, Lorg/cocos2dx/lib/VideoController;->access$502(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;

    .line 218
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    new-instance v6, Landroid/graphics/RectF;

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v7}, Lorg/cocos2dx/lib/VideoController;->access$400(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v7

    iget v7, v7, Landroid/graphics/RectF;->left:F

    int-to-float v8, v4

    iget-object v9, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v9}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v9

    mul-float/2addr v8, v9

    const/high16 v9, 0x40000000    # 2.0f

    div-float/2addr v8, v9

    sub-float/2addr v7, v8

    iget-object v8, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v8}, Lorg/cocos2dx/lib/VideoController;->access$400(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v8

    iget v8, v8, Landroid/graphics/RectF;->top:F

    int-to-float v9, v4

    iget-object v10, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v10}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v10

    mul-float/2addr v9, v10

    const/high16 v10, 0x40000000    # 2.0f

    div-float/2addr v9, v10

    sub-float/2addr v8, v9

    iget-object v9, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v9}, Lorg/cocos2dx/lib/VideoController;->access$400(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v9

    iget v9, v9, Landroid/graphics/RectF;->right:F

    int-to-float v10, v4

    iget-object v11, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v11}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v11

    mul-float/2addr v10, v11

    const/high16 v11, 0x40000000    # 2.0f

    div-float/2addr v10, v11

    add-float/2addr v9, v10

    iget-object v10, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v10}, Lorg/cocos2dx/lib/VideoController;->access$400(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v10

    iget v10, v10, Landroid/graphics/RectF;->bottom:F

    int-to-float v11, v4

    iget-object v12, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v12}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v12

    mul-float/2addr v11, v12

    const/high16 v12, 0x40000000    # 2.0f

    div-float/2addr v11, v12

    add-float/2addr v10, v11

    invoke-direct {v6, v7, v8, v9, v10}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-static {v5, v6}, Lorg/cocos2dx/lib/VideoController;->access$602(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;

    .line 219
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    new-instance v6, Landroid/graphics/RectF;

    iget-object v7, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v7}, Lorg/cocos2dx/lib/VideoController;->access$500(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v7

    iget v7, v7, Landroid/graphics/RectF;->left:F

    int-to-float v8, v4

    iget-object v9, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v9}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v9

    mul-float/2addr v8, v9

    const/high16 v9, 0x40000000    # 2.0f

    div-float/2addr v8, v9

    sub-float/2addr v7, v8

    iget-object v8, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v8}, Lorg/cocos2dx/lib/VideoController;->access$500(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v8

    iget v8, v8, Landroid/graphics/RectF;->top:F

    int-to-float v9, v4

    iget-object v10, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v10}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v10

    mul-float/2addr v9, v10

    const/high16 v10, 0x40000000    # 2.0f

    div-float/2addr v9, v10

    sub-float/2addr v8, v9

    iget-object v9, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v9}, Lorg/cocos2dx/lib/VideoController;->access$500(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v9

    iget v9, v9, Landroid/graphics/RectF;->right:F

    int-to-float v10, v4

    iget-object v11, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v11}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v11

    mul-float/2addr v10, v11

    const/high16 v11, 0x40000000    # 2.0f

    div-float/2addr v10, v11

    add-float/2addr v9, v10

    iget-object v10, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v10}, Lorg/cocos2dx/lib/VideoController;->access$500(Lorg/cocos2dx/lib/VideoController;)Landroid/graphics/RectF;

    move-result-object v10

    iget v10, v10, Landroid/graphics/RectF;->bottom:F

    int-to-float v11, v4

    iget-object v12, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v12}, Lorg/cocos2dx/lib/VideoController;->access$700(Lorg/cocos2dx/lib/VideoController;)F

    move-result v12

    mul-float/2addr v11, v12

    const/high16 v12, 0x40000000    # 2.0f

    div-float/2addr v11, v12

    add-float/2addr v10, v11

    invoke-direct {v6, v7, v8, v9, v10}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-static {v5, v6}, Lorg/cocos2dx/lib/VideoController;->access$802(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;

    .line 221
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v5}, Lorg/cocos2dx/lib/VideoController;->access$200(Lorg/cocos2dx/lib/VideoController;)I

    move-result v5

    add-int/lit16 v5, v5, -0x168

    add-int/lit16 v2, v5, -0xc8

    .line 222
    .local v2, "progressW":I
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v5}, Lorg/cocos2dx/lib/VideoController;->access$200(Lorg/cocos2dx/lib/VideoController;)I

    move-result v5

    div-int/lit8 v5, v5, 0x2

    add-int/lit8 v1, v5, 0x5a

    .line 224
    .local v1, "center":I
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v5}, Lorg/cocos2dx/lib/VideoController;->access$300(Lorg/cocos2dx/lib/VideoController;)I

    move-result v5

    add-int/lit8 v3, v5, -0x7d

    .line 226
    .local v3, "progressY":I
    iget-object v5, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    new-instance v6, Landroid/graphics/RectF;

    div-int/lit8 v7, v2, 0x2

    sub-int v7, v1, v7

    int-to-float v7, v7

    int-to-float v8, v3

    div-int/lit8 v9, v2, 0x2

    add-int/2addr v9, v1

    int-to-float v9, v9

    int-to-float v10, v3

    invoke-direct {v6, v7, v8, v9, v10}, Landroid/graphics/RectF;-><init>(FFFF)V

    invoke-static {v5, v6}, Lorg/cocos2dx/lib/VideoController;->access$902(Lorg/cocos2dx/lib/VideoController;Landroid/graphics/RectF;)Landroid/graphics/RectF;

    .line 227
    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 231
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/VideoController;->access$002(Lorg/cocos2dx/lib/VideoController;Z)Z

    .line 232
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v0, p1}, Lorg/cocos2dx/lib/VideoController;->access$1002(Lorg/cocos2dx/lib/VideoController;Landroid/view/SurfaceHolder;)Landroid/view/SurfaceHolder;

    .line 233
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v0}, Lorg/cocos2dx/lib/VideoController;->access$100(Lorg/cocos2dx/lib/VideoController;)Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    invoke-static {v1}, Lorg/cocos2dx/lib/VideoController;->access$1100(Lorg/cocos2dx/lib/VideoController;)Lorg/cocos2dx/lib/VideoController$DrawRunnable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 234
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 2
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .prologue
    .line 238
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/VideoController;->access$1002(Lorg/cocos2dx/lib/VideoController;Landroid/view/SurfaceHolder;)Landroid/view/SurfaceHolder;

    .line 239
    iget-object v0, p0, Lorg/cocos2dx/lib/VideoController$1;->this$0:Lorg/cocos2dx/lib/VideoController;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/VideoController;->access$002(Lorg/cocos2dx/lib/VideoController;Z)Z

    .line 240
    return-void
.end method
