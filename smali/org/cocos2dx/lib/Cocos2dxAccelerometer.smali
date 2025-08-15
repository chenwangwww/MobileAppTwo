.class public Lorg/cocos2dx/lib/Cocos2dxAccelerometer;
.super Ljava/lang/Object;
.source "Cocos2dxAccelerometer.java"

# interfaces
.implements Landroid/hardware/SensorEventListener;


# static fields
.field static final ALPHA:F = 0.25f

.field private static final TAG:Ljava/lang/String;


# instance fields
.field final accelerometerValues:[F

.field final compassFieldValues:[F

.field private final mAccelerometer:Landroid/hardware/Sensor;

.field private final mCompass:Landroid/hardware/Sensor;

.field private final mContext:Landroid/content/Context;

.field private final mNaturalOrientation:I

.field private final mSensorManager:Landroid/hardware/SensorManager;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 41
    const-class v0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->TAG:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/4 v2, 0x3

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 52
    new-array v1, v2, [F

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->accelerometerValues:[F

    .line 53
    new-array v1, v2, [F

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->compassFieldValues:[F

    .line 61
    iput-object p1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mContext:Landroid/content/Context;

    .line 63
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mContext:Landroid/content/Context;

    const-string v2, "sensor"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/hardware/SensorManager;

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    .line 64
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;

    move-result-object v1

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mAccelerometer:Landroid/hardware/Sensor;

    .line 65
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    const/4 v2, 0x2

    invoke-virtual {v1, v2}, Landroid/hardware/SensorManager;->getDefaultSensor(I)Landroid/hardware/Sensor;

    move-result-object v1

    iput-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mCompass:Landroid/hardware/Sensor;

    .line 67
    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mContext:Landroid/content/Context;

    const-string v2, "window"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v0

    .line 68
    .local v0, "display":Landroid/view/Display;
    invoke-virtual {v0}, Landroid/view/Display;->getOrientation()I

    move-result v1

    iput v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mNaturalOrientation:I

    .line 69
    return-void
.end method

.method public static native onSensorChanged(FFFJ)V
.end method


# virtual methods
.method public disable()V
    .locals 1

    .prologue
    .line 94
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    invoke-virtual {v0, p0}, Landroid/hardware/SensorManager;->unregisterListener(Landroid/hardware/SensorEventListener;)V

    .line 95
    return-void
.end method

.method public enableAccel()V
    .locals 3

    .prologue
    .line 80
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mAccelerometer:Landroid/hardware/Sensor;

    const/4 v2, 0x1

    invoke-virtual {v0, p0, v1, v2}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    .line 81
    return-void
.end method

.method public enableCompass()V
    .locals 3

    .prologue
    .line 76
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mCompass:Landroid/hardware/Sensor;

    const/4 v2, 0x1

    invoke-virtual {v0, p0, v1, v2}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    .line 77
    return-void
.end method

.method public onAccuracyChanged(Landroid/hardware/Sensor;I)V
    .locals 0
    .param p1, "sensor"    # Landroid/hardware/Sensor;
    .param p2, "accuracy"    # I

    .prologue
    .line 149
    return-void
.end method

.method public onSensorChanged(Landroid/hardware/SensorEvent;)V
    .locals 10
    .param p1, "sensorEvent"    # Landroid/hardware/SensorEvent;

    .prologue
    const/4 v9, 0x0

    const/4 v8, 0x2

    const/4 v7, 0x1

    .line 102
    iget-object v5, p1, Landroid/hardware/SensorEvent;->sensor:Landroid/hardware/Sensor;

    invoke-virtual {v5}, Landroid/hardware/Sensor;->getType()I

    move-result v5

    if-ne v5, v7, :cond_3

    .line 104
    iget-object v5, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v2, v5, v9

    .line 105
    .local v2, "x":F
    iget-object v5, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v3, v5, v7

    .line 106
    .local v3, "y":F
    iget-object v5, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v4, v5, v8

    .line 109
    .local v4, "z":F
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->accelerometerValues:[F

    aput v2, v5, v9

    .line 110
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->accelerometerValues:[F

    aput v3, v5, v7

    .line 111
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->accelerometerValues:[F

    aput v4, v5, v8

    .line 118
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mContext:Landroid/content/Context;

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v5

    iget v0, v5, Landroid/content/res/Configuration;->orientation:I

    .line 120
    .local v0, "orientation":I
    if-ne v0, v8, :cond_2

    iget v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mNaturalOrientation:I

    if-eqz v5, :cond_2

    .line 121
    move v1, v2

    .line 122
    .local v1, "tmp":F
    neg-float v2, v3

    .line 123
    move v3, v1

    .line 131
    .end local v1    # "tmp":F
    :cond_0
    :goto_0
    iget-wide v6, p1, Landroid/hardware/SensorEvent;->timestamp:J

    invoke-static {v2, v3, v4, v6, v7}, Lorg/cocos2dx/lib/Cocos2dxGLSurfaceView;->queueAccelerometer(FFFJ)V

    .line 145
    .end local v0    # "orientation":I
    .end local v2    # "x":F
    .end local v3    # "y":F
    .end local v4    # "z":F
    :cond_1
    :goto_1
    return-void

    .line 124
    .restart local v0    # "orientation":I
    .restart local v2    # "x":F
    .restart local v3    # "y":F
    .restart local v4    # "z":F
    :cond_2
    if-ne v0, v7, :cond_0

    iget v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mNaturalOrientation:I

    if-eqz v5, :cond_0

    .line 125
    move v1, v2

    .line 126
    .restart local v1    # "tmp":F
    move v2, v3

    .line 127
    neg-float v3, v1

    goto :goto_0

    .line 139
    .end local v0    # "orientation":I
    .end local v1    # "tmp":F
    .end local v2    # "x":F
    .end local v3    # "y":F
    .end local v4    # "z":F
    :cond_3
    iget-object v5, p1, Landroid/hardware/SensorEvent;->sensor:Landroid/hardware/Sensor;

    invoke-virtual {v5}, Landroid/hardware/Sensor;->getType()I

    move-result v5

    if-ne v5, v8, :cond_1

    .line 141
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->compassFieldValues:[F

    iget-object v6, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v6, v6, v9

    aput v6, v5, v9

    .line 142
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->compassFieldValues:[F

    iget-object v6, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v6, v6, v7

    aput v6, v5, v7

    .line 143
    iget-object v5, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->compassFieldValues:[F

    iget-object v6, p1, Landroid/hardware/SensorEvent;->values:[F

    aget v6, v6, v8

    aput v6, v5, v8

    goto :goto_1
.end method

.method public setInterval(F)V
    .locals 3
    .param p1, "interval"    # F

    .prologue
    .line 85
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0xb

    if-ge v0, v1, :cond_0

    .line 86
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mAccelerometer:Landroid/hardware/Sensor;

    const/4 v2, 0x1

    invoke-virtual {v0, p0, v1, v2}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    .line 91
    :goto_0
    return-void

    .line 89
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mSensorManager:Landroid/hardware/SensorManager;

    iget-object v1, p0, Lorg/cocos2dx/lib/Cocos2dxAccelerometer;->mAccelerometer:Landroid/hardware/Sensor;

    const v2, 0x49742400    # 1000000.0f

    mul-float/2addr v2, p1

    float-to-int v2, v2

    invoke-virtual {v0, p0, v1, v2}, Landroid/hardware/SensorManager;->registerListener(Landroid/hardware/SensorEventListener;Landroid/hardware/Sensor;I)Z

    goto :goto_0
.end method
