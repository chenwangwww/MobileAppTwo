.class public Lcom/qianniao/zbarscanner/zbar/ZbarActivity;
.super Landroid/app/Activity;
.source "ZbarActivity.java"

# interfaces
.implements Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;


# static fields
.field static final REQUEST:I = 0xb


# instance fields
.field mHandler:Landroid/os/Handler;

.field mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;
    .annotation build Lbutterknife/Bind;
        value = {
            0x7f0c006b
        }
    .end annotation
.end field

.field toggleButton:Landroid/widget/ToggleButton;
    .annotation build Lbutterknife/Bind;
        value = {
            0x7f0c006e
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .prologue
    .line 34
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 167
    new-instance v0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$3;

    invoke-direct {v0, p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$3;-><init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V

    iput-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method private codeDiscriminate(Ljava/lang/String;)V
    .locals 2
    .param p1, "path"    # Ljava/lang/String;

    .prologue
    .line 144
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;

    invoke-direct {v1, p0, p1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$2;-><init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 162
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 163
    return-void
.end method

.method public static goZbarActivity(Landroid/app/Activity;)V
    .locals 2
    .param p0, "context"    # Landroid/app/Activity;

    .prologue
    .line 46
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 48
    .local v0, "it":Landroid/content/Intent;
    const/16 v1, 0xb

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    .line 49
    return-void
.end method

.method private initLayout()V
    .locals 2

    .prologue
    .line 60
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0, p0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->setDelegate(Lcom/qianniao/zbarscanner/qrcode/QRCodeView$Delegate;)V

    .line 61
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->startSpotAndShowRect()V

    .line 62
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->toggleButton:Landroid/widget/ToggleButton;

    new-instance v1, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;

    invoke-direct {v1, p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity$1;-><init>(Lcom/qianniao/zbarscanner/zbar/ZbarActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/ToggleButton;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 72
    return-void
.end method

.method private vibrate()V
    .locals 4

    .prologue
    .line 139
    const-string v1, "vibrator"

    invoke-virtual {p0, v1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Vibrator;

    .line 140
    .local v0, "vibrator":Landroid/os/Vibrator;
    const-wide/16 v2, 0xc8

    invoke-virtual {v0, v2, v3}, Landroid/os/Vibrator;->vibrate(J)V

    .line 141
    return-void
.end method


# virtual methods
.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 9
    .param p1, "requestCode"    # I
    .param p2, "resultCode"    # I
    .param p3, "data"    # Landroid/content/Intent;

    .prologue
    const/4 v3, 0x0

    const/4 v8, 0x0

    .line 93
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V

    .line 94
    const/4 v0, -0x1

    if-ne p2, v0, :cond_0

    const/16 v0, 0x11

    if-ne p1, v0, :cond_0

    .line 95
    invoke-virtual {p3}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v1

    .line 96
    .local v1, "uri":Landroid/net/Uri;
    const/4 v7, 0x0

    .line 97
    .local v7, "path":Ljava/lang/String;
    invoke-virtual {v1}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 98
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const/4 v2, 0x1

    new-array v2, v2, [Ljava/lang/String;

    const-string v4, "_data"

    aput-object v4, v2, v8

    move-object v4, v3

    move-object v5, v3

    invoke-virtual/range {v0 .. v5}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v6

    .line 100
    .local v6, "cursor":Landroid/database/Cursor;
    if-nez v6, :cond_1

    .line 101
    const-string v0, "\u56fe\u7247\u6ca1\u627e\u5230"

    invoke-static {p0, v0, v8}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 117
    .end local v1    # "uri":Landroid/net/Uri;
    .end local v6    # "cursor":Landroid/database/Cursor;
    .end local v7    # "path":Ljava/lang/String;
    :cond_0
    :goto_0
    return-void

    .line 104
    .restart local v1    # "uri":Landroid/net/Uri;
    .restart local v6    # "cursor":Landroid/database/Cursor;
    .restart local v7    # "path":Ljava/lang/String;
    :cond_1
    invoke-interface {v6}, Landroid/database/Cursor;->moveToFirst()Z

    .line 105
    const-string v0, "_data"

    invoke-interface {v6, v0}, Landroid/database/Cursor;->getColumnIndex(Ljava/lang/String;)I

    move-result v0

    invoke-interface {v6, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    .line 106
    invoke-interface {v6}, Landroid/database/Cursor;->close()V

    .line 110
    .end local v6    # "cursor":Landroid/database/Cursor;
    :goto_1
    if-eqz v7, :cond_3

    .line 111
    invoke-direct {p0, v7}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->codeDiscriminate(Ljava/lang/String;)V

    goto :goto_0

    .line 108
    :cond_2
    invoke-virtual {v1}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    move-result-object v7

    goto :goto_1

    .line 113
    :cond_3
    const-string v0, "\u56fe\u7247\u8def\u5f84\u4e3a\u7a7a"

    invoke-static {p0, v0, v8}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    goto :goto_0
.end method

.method protected onClickBtn(Landroid/view/View;)V
    .locals 2
    .param p1, "view"    # Landroid/view/View;
    .annotation build Lbutterknife/OnClick;
        value = {
            0x7f0c006c,
            0x7f0c006d
        }
    .end annotation

    .prologue
    .line 76
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v1

    packed-switch v1, :pswitch_data_0

    .line 89
    :goto_0
    return-void

    .line 78
    :pswitch_0
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->finish()V

    goto :goto_0

    .line 81
    :pswitch_1
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 82
    .local v0, "intent":Landroid/content/Intent;
    const-string v1, "android.intent.action.PICK"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 83
    const-string v1, "image/*"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    .line 84
    const/16 v1, 0x11

    invoke-virtual {p0, v0, v1}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->startActivityForResult(Landroid/content/Intent;I)V

    goto :goto_0

    .line 76
    nop

    :pswitch_data_0
    .packed-switch 0x7f0c006c
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .prologue
    .line 53
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 54
    const v0, 0x7f04002d

    invoke-virtual {p0, v0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->setContentView(I)V

    .line 55
    invoke-static {p0}, Lbutterknife/ButterKnife;->bind(Landroid/app/Activity;)V

    .line 56
    invoke-direct {p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->initLayout()V

    .line 57
    return-void
.end method

.method protected onDestroy()V
    .locals 1

    .prologue
    .line 182
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->onDestroy()V

    .line 183
    invoke-static {p0}, Lbutterknife/ButterKnife;->unbind(Ljava/lang/Object;)V

    .line 184
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 186
    return-void
.end method

.method protected onRestart()V
    .locals 1

    .prologue
    .line 121
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->startCamera()V

    .line 122
    invoke-super {p0}, Landroid/app/Activity;->onRestart()V

    .line 123
    return-void
.end method

.method public onResume()V
    .locals 1

    .prologue
    .line 127
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 128
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->startSpotAndShowRect()V

    .line 129
    return-void
.end method

.method public onScanQRCodeOpenCameraError()V
    .locals 2

    .prologue
    .line 200
    const-string v0, "zbar_result"

    const-string v1, "\u6253\u5f00\u76f8\u673a\u51fa\u9519"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 201
    const-string v0, "\u6253\u5f00\u76f8\u673a\u51fa\u9519"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 202
    return-void
.end method

.method public onScanQRCodeSuccess(Ljava/lang/String;)V
    .locals 1
    .param p1, "result"    # Ljava/lang/String;

    .prologue
    .line 194
    invoke-virtual {p0}, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->finish()V

    .line 195
    invoke-static {}, Lcom/qianniao/zbarscanner/ZbarManager;->getInstance()Lcom/qianniao/zbarscanner/ZbarManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/qianniao/zbarscanner/ZbarManager;->onZbarScannerComplete(Ljava/lang/String;)V

    .line 196
    return-void
.end method

.method protected onStop()V
    .locals 1

    .prologue
    .line 133
    iget-object v0, p0, Lcom/qianniao/zbarscanner/zbar/ZbarActivity;->mQRCodeView:Lcom/qianniao/zbarscanner/zbar/ZBarView;

    invoke-virtual {v0}, Lcom/qianniao/zbarscanner/zbar/ZBarView;->stopCamera()V

    .line 135
    invoke-super {p0}, Landroid/app/Activity;->onStop()V

    .line 136
    return-void
.end method
