.class Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;
.super Landroid/os/Handler;
.source "Cocos2dxVideoHelper.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "VideoHandler"
.end annotation


# instance fields
.field mReference:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference",
            "<",
            "Lorg/cocos2dx/lib/Cocos2dxVideoHelper;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)V
    .locals 1
    .param p1, "helper"    # Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .prologue
    .line 74
    invoke-direct {p0}, Landroid/os/Handler;-><init>()V

    .line 75
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    .line 76
    return-void
.end method


# virtual methods
.method public handleMessage(Landroid/os/Message;)V
    .locals 7
    .param p1, "msg"    # Landroid/os/Message;

    .prologue
    const/4 v5, 0x0

    const/4 v4, 0x1

    .line 80
    iget v1, p1, Landroid/os/Message;->what:I

    sparse-switch v1, :sswitch_data_0

    .line 174
    :goto_0
    invoke-super {p0, p1}, Landroid/os/Handler;->handleMessage(Landroid/os/Message;)V

    .line 175
    return-void

    .line 82
    :sswitch_0
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 83
    .local v0, "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$000(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto :goto_0

    .line 87
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_1
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 88
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$100(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto :goto_0

    .line 92
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_2
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 93
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v2, p1, Landroid/os/Message;->arg1:I

    iget v3, p1, Landroid/os/Message;->arg2:I

    iget-object v1, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v1, Ljava/lang/String;

    invoke-static {v0, v2, v3, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$200(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IILjava/lang/String;)V

    goto :goto_0

    .line 97
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_3
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 98
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$300(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto :goto_0

    .line 102
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_4
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 103
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget-object v6, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v6, Landroid/graphics/Rect;

    .line 104
    .local v6, "rect":Landroid/graphics/Rect;
    iget v1, p1, Landroid/os/Message;->arg1:I

    iget v2, v6, Landroid/graphics/Rect;->left:I

    iget v3, v6, Landroid/graphics/Rect;->top:I

    iget v4, v6, Landroid/graphics/Rect;->right:I

    iget v5, v6, Landroid/graphics/Rect;->bottom:I

    invoke-static/range {v0 .. v5}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$400(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IIIII)V

    goto :goto_0

    .line 108
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .end local v6    # "rect":Landroid/graphics/Rect;
    :sswitch_5
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 109
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget-object v6, p1, Landroid/os/Message;->obj:Ljava/lang/Object;

    check-cast v6, Landroid/graphics/Rect;

    .line 110
    .restart local v6    # "rect":Landroid/graphics/Rect;
    iget v1, p1, Landroid/os/Message;->arg2:I

    if-ne v1, v4, :cond_0

    .line 111
    iget v1, p1, Landroid/os/Message;->arg1:I

    iget v2, v6, Landroid/graphics/Rect;->right:I

    iget v3, v6, Landroid/graphics/Rect;->bottom:I

    invoke-static {v0, v1, v4, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$500(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZII)V

    goto :goto_0

    .line 113
    :cond_0
    iget v1, p1, Landroid/os/Message;->arg1:I

    iget v2, v6, Landroid/graphics/Rect;->right:I

    iget v3, v6, Landroid/graphics/Rect;->bottom:I

    invoke-static {v0, v1, v5, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$500(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZII)V

    goto :goto_0

    .line 118
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    .end local v6    # "rect":Landroid/graphics/Rect;
    :sswitch_6
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 119
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$600(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto/16 :goto_0

    .line 123
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_7
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 124
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$700(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto/16 :goto_0

    .line 128
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_8
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 129
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$800(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto/16 :goto_0

    .line 133
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_9
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 134
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    iget v2, p1, Landroid/os/Message;->arg2:I

    invoke-static {v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$900(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;II)V

    goto/16 :goto_0

    .line 138
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_a
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 139
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg2:I

    if-ne v1, v4, :cond_1

    .line 140
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1, v4}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1000(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V

    goto/16 :goto_0

    .line 142
    :cond_1
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1, v5}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1000(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V

    goto/16 :goto_0

    .line 147
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_b
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 148
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1100(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto/16 :goto_0

    .line 152
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_c
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 153
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg2:I

    if-ne v1, v4, :cond_2

    .line 154
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1, v4}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1200(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V

    goto/16 :goto_0

    .line 156
    :cond_2
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1, v5}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1200(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;IZ)V

    goto/16 :goto_0

    .line 161
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_d
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 162
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    invoke-static {v0}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1300(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;)V

    goto/16 :goto_0

    .line 166
    .end local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    :sswitch_e
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper$VideoHandler;->mReference:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;

    .line 167
    .restart local v0    # "helper":Lorg/cocos2dx/lib/Cocos2dxVideoHelper;
    iget v1, p1, Landroid/os/Message;->arg1:I

    invoke-static {v0, v1}, Lorg/cocos2dx/lib/Cocos2dxVideoHelper;->access$1400(Lorg/cocos2dx/lib/Cocos2dxVideoHelper;I)V

    goto/16 :goto_0

    .line 80
    :sswitch_data_0
    .sparse-switch
        0x0 -> :sswitch_0
        0x1 -> :sswitch_1
        0x2 -> :sswitch_2
        0x3 -> :sswitch_4
        0x4 -> :sswitch_3
        0x5 -> :sswitch_6
        0x6 -> :sswitch_7
        0x7 -> :sswitch_8
        0x8 -> :sswitch_9
        0x9 -> :sswitch_a
        0xa -> :sswitch_b
        0xb -> :sswitch_c
        0xc -> :sswitch_5
        0x63 -> :sswitch_e
        0x3e8 -> :sswitch_d
    .end sparse-switch
.end method
