.class public Lorg/cocos2dx/lib/Cocos2dxEditBox;
.super Landroid/widget/EditText;
.source "Cocos2dxEditBox.java"


# static fields
.field public static final kEndActionNext:I = 0x1

.field public static final kEndActionReturn:I = 0x3

.field public static final kEndActionUnknown:I = 0x0

.field private static final kTextHorizontalAlignmentCenter:I = 0x1

.field private static final kTextHorizontalAlignmentLeft:I = 0x0

.field private static final kTextHorizontalAlignmentRight:I = 0x2

.field private static final kTextVerticalAlignmentBottom:I = 0x2

.field private static final kTextVerticalAlignmentCenter:I = 0x1

.field private static final kTextVerticalAlignmentTop:I


# instance fields
.field private changedTextProgrammatically:Ljava/lang/Boolean;

.field endAction:I

.field private final kEditBoxInputFlagInitialCapsAllCharacters:I

.field private final kEditBoxInputFlagInitialCapsSentence:I

.field private final kEditBoxInputFlagInitialCapsWord:I

.field private final kEditBoxInputFlagLowercaseAllCharacters:I

.field private final kEditBoxInputFlagPassword:I

.field private final kEditBoxInputFlagSensitive:I

.field private final kEditBoxInputModeAny:I

.field private final kEditBoxInputModeDecimal:I

.field private final kEditBoxInputModeEmailAddr:I

.field private final kEditBoxInputModeNumeric:I

.field private final kEditBoxInputModePhoneNumber:I

.field private final kEditBoxInputModeSingleLine:I

.field private final kEditBoxInputModeUrl:I

.field private final kKeyboardReturnTypeDefault:I

.field private final kKeyboardReturnTypeDone:I

.field private final kKeyboardReturnTypeGo:I

.field private final kKeyboardReturnTypeNext:I

.field private final kKeyboardReturnTypeSearch:I

.field private final kKeyboardReturnTypeSend:I

.field private mInputFlagConstraints:I

.field private mInputModeConstraints:I

.field private mMaxLength:I

.field private mScaleX:F


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 6
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/4 v5, 0x4

    const/4 v4, 0x3

    const/4 v3, 0x2

    const/4 v2, 0x1

    const/4 v1, 0x0

    .line 148
    invoke-direct {p0, p1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 45
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeAny:I

    .line 50
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeEmailAddr:I

    .line 55
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeNumeric:I

    .line 60
    iput v4, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModePhoneNumber:I

    .line 65
    iput v5, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeUrl:I

    .line 70
    const/4 v0, 0x5

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeDecimal:I

    .line 75
    const/4 v0, 0x6

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputModeSingleLine:I

    .line 80
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagPassword:I

    .line 85
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagSensitive:I

    .line 90
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagInitialCapsWord:I

    .line 95
    iput v4, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagInitialCapsSentence:I

    .line 100
    iput v5, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagInitialCapsAllCharacters:I

    .line 105
    const/4 v0, 0x5

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kEditBoxInputFlagLowercaseAllCharacters:I

    .line 107
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeDefault:I

    .line 108
    iput v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeDone:I

    .line 109
    iput v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeSend:I

    .line 110
    iput v4, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeSearch:I

    .line 111
    iput v5, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeGo:I

    .line 112
    const/4 v0, 0x5

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->kKeyboardReturnTypeNext:I

    .line 138
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    iput-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->changedTextProgrammatically:Ljava/lang/Boolean;

    .line 144
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->endAction:I

    .line 149
    return-void
.end method


# virtual methods
.method public getChangedTextProgrammatically()Ljava/lang/Boolean;
    .locals 1

    .prologue
    .line 131
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->changedTextProgrammatically:Ljava/lang/Boolean;

    return-object v0
.end method

.method public getOpenGLViewScaleX()F
    .locals 1

    .prologue
    .line 163
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mScaleX:F

    return v0
.end method

.method public onKeyDown(ILandroid/view/KeyEvent;)Z
    .locals 2
    .param p1, "pKeyCode"    # I
    .param p2, "pKeyEvent"    # Landroid/view/KeyEvent;

    .prologue
    .line 287
    packed-switch p1, :pswitch_data_0

    .line 294
    invoke-super {p0, p1, p2}, Landroid/widget/EditText;->onKeyDown(ILandroid/view/KeyEvent;)Z

    move-result v1

    :goto_0
    return v1

    .line 289
    :pswitch_0
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->getContext()Landroid/content/Context;

    move-result-object v0

    check-cast v0, Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 291
    .local v0, "activity":Lorg/cocos2dx/lib/Cocos2dxActivity;
    invoke-virtual {v0}, Lorg/cocos2dx/lib/Cocos2dxActivity;->getGLSurfaceView()Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;

    move-result-object v1

    invoke-virtual {v1}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->requestFocus()Z

    .line 292
    const/4 v1, 0x1

    goto :goto_0

    .line 287
    nop

    :pswitch_data_0
    .packed-switch 0x4
        :pswitch_0
    .end packed-switch
.end method

.method public onKeyPreIme(ILandroid/view/KeyEvent;)Z
    .locals 1
    .param p1, "keyCode"    # I
    .param p2, "event"    # Landroid/view/KeyEvent;

    .prologue
    .line 300
    invoke-super {p0, p1, p2}, Landroid/widget/EditText;->onKeyPreIme(ILandroid/view/KeyEvent;)Z

    move-result v0

    return v0
.end method

.method public setChangedTextProgrammatically(Ljava/lang/Boolean;)V
    .locals 0
    .param p1, "changedTextProgrammatically"    # Ljava/lang/Boolean;

    .prologue
    .line 135
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->changedTextProgrammatically:Ljava/lang/Boolean;

    .line 136
    return-void
.end method

.method public setEditBoxViewRect(IIII)V
    .locals 2
    .param p1, "left"    # I
    .param p2, "top"    # I
    .param p3, "maxWidth"    # I
    .param p4, "maxHeight"    # I

    .prologue
    const/4 v1, -0x2

    .line 152
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 154
    .local v0, "layoutParams":Landroid/widget/FrameLayout$LayoutParams;
    iput p1, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 155
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 156
    iput p3, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 157
    iput p4, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 158
    const/16 v1, 0x33

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 159
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 160
    return-void
.end method

.method public setInputFlag(I)V
    .locals 2
    .param p1, "inputFlag"    # I

    .prologue
    .line 305
    packed-switch p1, :pswitch_data_0

    .line 330
    :goto_0
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    or-int/2addr v0, v1

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setInputType(I)V

    .line 331
    return-void

    .line 307
    :pswitch_0
    const/16 v0, 0x81

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    .line 308
    sget-object v0, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTypeface(Landroid/graphics/Typeface;)V

    .line 309
    new-instance v0, Landroid/text/method/PasswordTransformationMethod;

    invoke-direct {v0}, Landroid/text/method/PasswordTransformationMethod;-><init>()V

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTransformationMethod(Landroid/text/method/TransformationMethod;)V

    goto :goto_0

    .line 312
    :pswitch_1
    const/high16 v0, 0x80000

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    goto :goto_0

    .line 315
    :pswitch_2
    const/16 v0, 0x2000

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    goto :goto_0

    .line 318
    :pswitch_3
    const/16 v0, 0x4000

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    goto :goto_0

    .line 321
    :pswitch_4
    const/16 v0, 0x1000

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    goto :goto_0

    .line 324
    :pswitch_5
    const/4 v0, 0x1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    goto :goto_0

    .line 305
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_4
        :pswitch_5
    .end packed-switch
.end method

.method public setInputMode(I)V
    .locals 2
    .param p1, "inputMode"    # I

    .prologue
    const/4 v1, 0x1

    const/4 v0, 0x0

    .line 252
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTextHorizontalAlignment(I)V

    .line 253
    invoke-virtual {p0, v1}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTextVerticalAlignment(I)V

    .line 254
    packed-switch p1, :pswitch_data_0

    .line 282
    :goto_0
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    iget v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputFlagConstraints:I

    or-int/2addr v0, v1

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setInputType(I)V

    .line 283
    return-void

    .line 256
    :pswitch_0
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setTextVerticalAlignment(I)V

    .line 257
    const v0, 0x20001

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 260
    :pswitch_1
    const/16 v0, 0x21

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 263
    :pswitch_2
    const/16 v0, 0x1002

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 266
    :pswitch_3
    const/4 v0, 0x3

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 269
    :pswitch_4
    const/16 v0, 0x11

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 272
    :pswitch_5
    const/16 v0, 0x3002

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 275
    :pswitch_6
    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    goto :goto_0

    .line 254
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_4
        :pswitch_5
        :pswitch_6
    .end packed-switch
.end method

.method public setMaxLength(I)V
    .locals 4
    .param p1, "maxLength"    # I

    .prologue
    .line 172
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mMaxLength:I

    .line 174
    const/4 v0, 0x1

    new-array v0, v0, [Landroid/text/InputFilter;

    const/4 v1, 0x0

    new-instance v2, Landroid/text/InputFilter$LengthFilter;

    iget v3, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mMaxLength:I

    invoke-direct {v2, v3}, Landroid/text/InputFilter$LengthFilter;-><init>(I)V

    aput-object v2, v0, v1

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setFilters([Landroid/text/InputFilter;)V

    .line 175
    return-void
.end method

.method public setMultilineEnabled(Z)V
    .locals 2
    .param p1, "flag"    # Z

    .prologue
    .line 178
    iget v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    const/high16 v1, 0x20000

    or-int/2addr v0, v1

    iput v0, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mInputModeConstraints:I

    .line 179
    return-void
.end method

.method public setOpenGLViewScaleX(F)V
    .locals 0
    .param p1, "mScaleX"    # F

    .prologue
    .line 167
    iput p1, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mScaleX:F

    .line 168
    return-void
.end method

.method public setReturnType(I)V
    .locals 1
    .param p1, "returnType"    # I

    .prologue
    const v0, 0x10000001

    .line 182
    packed-switch p1, :pswitch_data_0

    .line 202
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    .line 205
    :goto_0
    return-void

    .line 184
    :pswitch_0
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 187
    :pswitch_1
    const v0, 0x10000006

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 190
    :pswitch_2
    const v0, 0x10000004

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 193
    :pswitch_3
    const v0, 0x10000003

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 196
    :pswitch_4
    const v0, 0x10000002

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 199
    :pswitch_5
    const v0, 0x10000005

    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setImeOptions(I)V

    goto :goto_0

    .line 182
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_4
        :pswitch_5
    .end packed-switch
.end method

.method public setTextHorizontalAlignment(I)V
    .locals 2
    .param p1, "alignment"    # I

    .prologue
    .line 208
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->getGravity()I

    move-result v0

    .line 209
    .local v0, "gravity":I
    packed-switch p1, :pswitch_data_0

    .line 220
    and-int/lit8 v1, v0, -0x6

    or-int/lit8 v0, v1, 0x3

    .line 223
    :goto_0
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setGravity(I)V

    .line 224
    return-void

    .line 211
    :pswitch_0
    and-int/lit8 v1, v0, -0x6

    or-int/lit8 v0, v1, 0x3

    .line 212
    goto :goto_0

    .line 214
    :pswitch_1
    and-int/lit8 v1, v0, -0x6

    and-int/lit8 v1, v1, -0x4

    or-int/lit8 v0, v1, 0x1

    .line 215
    goto :goto_0

    .line 217
    :pswitch_2
    and-int/lit8 v1, v0, -0x4

    or-int/lit8 v0, v1, 0x5

    .line 218
    goto :goto_0

    .line 209
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method

.method public setTextVerticalAlignment(I)V
    .locals 4
    .param p1, "alignment"    # I

    .prologue
    const/4 v3, 0x0

    .line 227
    invoke-virtual {p0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->getGravity()I

    move-result v0

    .line 228
    .local v0, "gravity":I
    iget v2, p0, Lorg/cocos2dx/lib/Cocos2dxEditBox;->mScaleX:F

    invoke-static {v2}, Lorg/cocos2dx/lib/Cocos2dxEditBoxHelper;->getPadding(F)I

    move-result v1

    .line 229
    .local v1, "padding":I
    packed-switch p1, :pswitch_data_0

    .line 243
    div-int/lit8 v2, v1, 0x2

    invoke-virtual {p0, v1, v3, v3, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setPadding(IIII)V

    .line 244
    and-int/lit8 v2, v0, -0x31

    and-int/lit8 v2, v2, -0x51

    or-int/lit8 v0, v2, 0x10

    .line 248
    :goto_0
    invoke-virtual {p0, v0}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setGravity(I)V

    .line 249
    return-void

    .line 231
    :pswitch_0
    mul-int/lit8 v2, v1, 0x3

    div-int/lit8 v2, v2, 0x4

    invoke-virtual {p0, v1, v2, v3, v3}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setPadding(IIII)V

    .line 232
    and-int/lit8 v2, v0, -0x51

    or-int/lit8 v0, v2, 0x30

    .line 233
    goto :goto_0

    .line 235
    :pswitch_1
    div-int/lit8 v2, v1, 0x2

    invoke-virtual {p0, v1, v3, v3, v2}, Lorg/cocos2dx/lib/Cocos2dxEditBox;->setPadding(IIII)V

    .line 236
    and-int/lit8 v2, v0, -0x31

    and-int/lit8 v2, v2, -0x51

    or-int/lit8 v0, v2, 0x10

    .line 237
    goto :goto_0

    .line 240
    :pswitch_2
    and-int/lit8 v2, v0, -0x31

    or-int/lit8 v0, v2, 0x50

    .line 241
    goto :goto_0

    .line 229
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method
