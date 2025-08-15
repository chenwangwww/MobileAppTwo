---------------------------------------------------------------------------------
-- 游戏人数
local FISHLK_CMD = {}
FISHLK_CMD.GamePlayer_4 = 8
FISHLK_CMD.LEN_MD5 = 33
FISHLK_CMD.kResolutionWidth = 1366 -- 默认分辨率宽度
FISHLK_CMD.kResolutionHeight = 768 -- 默认分辨率高度
-- 轨迹类型 0直线 1贝塞尔曲线
FISHLK_CMD.TraceType = {
    TRACE_LINEAR = 0,
    TRACE_BEZIER = 1
}

-- 场景类型
FISHLK_CMD.SceneKind = {
    SCENE_KIND_1 = 0,
    SCENE_KIND_2 = 1,
    SCENE_KIND_3 = 2,
    SCENE_KIND_4 = 3,
    SCENE_KIND_5 = 4,

    SCENE_KIND_COUNT = 5
}
-- 鱼状态
FISHLK_CMD.FishState = {
    ACTIVE = 0,
    STOP = 1,
    DEATH = 2
}
FISHLK_CMD.FishActiveTag = {
    LK_TAG = 100,
    TASK_TAG = 101,
    CIRCULAR = 102
}
-- 鱼的种类
FISHLK_CMD.FishKind = {
    FISH_KIND_1 = 0, -- 黄色小鱼
    FISH_KIND_2 = 1, -- 绿色小鱼
    FISH_KIND_3 = 2, -- 斑马线小鱼
    FISH_KIND_4 = 3, -- 大眼睛鱼
    FISH_KIND_5 = 4, --
    FISH_KIND_6 = 5, -- 橘色小丑鱼
    FISH_KIND_7 = 6, -- 河豚鱼
    FISH_KIND_8 = 7, -- 蓝色鱼
    FISH_KIND_9 = 8, -- 灯笼鱼
    FISH_KIND_10 = 9, -- 乌龟
    FISH_KIND_11 = 10, -- 灰色小飞鱼
    FISH_KIND_12 = 11, -- 蝴蝶鱼
    FISH_KIND_13 = 12, -- 粉身蓝尾鱼
    FISH_KIND_14 = 13, -- 箭鱼
    FISH_KIND_15 = 14, -- 魔鬼鱼
    FISH_KIND_16 = 15, -- 银鲨
    FISH_KIND_17 = 16, -- 金鲨
    FISH_KIND_18 = 17, -- 大鲸鱼
    FISH_KIND_19 = 18, -- 金龙
    FISH_KIND_20 = 19, -- 企鹅
    FISH_KIND_LK = 20, -- 李逵
    FISH_KIND_22 = 21, -- 定屏炸弹
    FISH_KIND_23 = 22, -- 局部炸弹
    FISH_KIND_24 = 23, -- 超级炸弹
    FISH_KIND_25 = 24, -- 大三元1
    FISH_KIND_26 = 25, -- 大三元2
    FISH_KIND_27 = 26, -- 大三元3
    FISH_KIND_28 = 27, -- 大四喜1
    FISH_KIND_29 = 28, -- 大四喜2
    FISH_KIND_30 = 29, -- 大四喜3
    FISH_KIND_31 = 30, -- 鱼王1
    FISH_KIND_32 = 31, -- 鱼王2
    FISH_KIND_33 = 32, -- 鱼王3
    FISH_KIND_34 = 33, -- 鱼王4
    FISH_KIND_35 = 34, -- 鱼王5
    FISH_KIND_36 = 35, -- 鱼王6
    FISH_KIND_37 = 36, -- 鱼王7
    FISH_KIND_38 = 37, -- 鱼王8
    FISH_KIND_39 = 38, -- 鱼王9
    FISH_KIND_40 = 39, -- 鱼王10
    FISH_KIND_TASK = 40, -- 任务鱼
    FISH_KIND_COUNT = 41
}

FISHLK_CMD.Award = {
    GOLD_500W_1 = 0,
    GOLD_2500W = 1,
    GOLD_1Y = 2,
    GOLD_1000W_2 = 3,
    GOLD_500W_2 = 4,
    GOLD_5000W = 5,
    GOLD_10Y = 6,
    GOLD_1000W_1 = 7,

    AWARD_COUNT = 8
}

-- 转盘赔率索引
FISHLK_CMD.kRotaryAward = {5000000, 25000000, 100000000, 10000000, 5000000, 50000000, 1000000000, 10000000}

-- 炮筒
FISHLK_CMD.BulletKind = {
    BULLET_KIND_1_NORMAL = 0,
    BULLET_KIND_2_NORMAL = 1,
    BULLET_KIND_3_NORMAL = 2,
    BULLET_KIND_4_NORMAL = 3,
    BULLET_KIND_1_ION = 4,
    BULLET_KIND_2_ION = 5,
    BULLET_KIND_3_ION = 6,
    BULLET_KIND_4_ION = 7,

    BULLET_KIND_COUNT = 8
}

-- 服务端命令

FISHLK_CMD.SUB_S_GAME_CONFIG = 100 -- 游戏配置
FISHLK_CMD.SUB_S_FISH_TRACE = 101 -- 鱼的轨迹
FISHLK_CMD.SUB_S_EXCHANGE_FISHSCORE = 102 -- 兑换鱼币
FISHLK_CMD.SUB_S_USER_FIRE = 103 -- 玩家开火
FISHLK_CMD.SUB_S_CATCH_FISH = 104 -- 捕获鱼群
FISHLK_CMD.SUB_S_BULLET_ION_TIMEOUT = 105 -- 大炮过时
FISHLK_CMD.SUB_S_LOCK_TIMEOUT = 106 -- 锁定过时
FISHLK_CMD.SUB_S_CATCH_SWEEP_FISH = 107 -- 打中鱼王炸弹
FISHLK_CMD.SUB_S_CATCH_SWEEP_FISH_RESULT = 108 -- 捕获结果
FISHLK_CMD.SUB_S_HIT_FISH_LK = 109 -- 击中李逵
FISHLK_CMD.SUB_S_SWITCH_SCENE = 110 -- 切换场景
FISHLK_CMD.SUB_S_STOCK_OPERATE_RESULT = 111 -- 库存操作结果			暂时不用
FISHLK_CMD.SUB_S_SCENE_END = 112 -- 场景结束
FISHLK_CMD.SUB_S_TREASURE_BOX_RESULT = 113 -- 大转盘
FISHLK_CMD.SUB_S_GRAB_LK = 114 -- 抢李逵得分
FISHLK_CMD.SUB_S_RETURN_FISHSCORE = 118 -- 返还渔币
FISHLK_CMD.SUB_S_HIT_FISH_TASK = 119 -- 击中任务鱼(红包)
FISHLK_CMD.SUB_S_GAME_STAT_SCENE = 120 -- 鱼阵场景消息
FISHLK_CMD.SUB_S_GAME_STAT_SCENE2 = 121 -- 普通鱼场景消息

--------------------------------------------------------------------------
-- 客户端命令

FISHLK_CMD.SUB_C_EXCHANGE_FISHSCORE = 1 -- 兑换鱼分
FISHLK_CMD.SUB_C_USER_FIRE = 2 -- 用户开火
FISHLK_CMD.SUB_C_CATCH_FISH = 3 -- 捕获鱼				打到鱼
FISHLK_CMD.SUB_C_CATCH_SWEEP_FISH = 4 -- 炸弹炸死的鱼
FISHLK_CMD.SUB_C_HIT_FISH_I = 5 -- 击中鱼				打到李逵
FISHLK_CMD.SUB_C_STOCK_OPERATE = 6 -- 库存操作
FISHLK_CMD.SUB_C_USER_FILTER = 7 -- 玩家过滤
FISHLK_CMD.SUB_C_ANDROID_STAND_UP = 8 --
FISHLK_CMD.SUB_C_FISH20_CONFIG = 9 --
FISHLK_CMD.SUB_C_ANDROID_BULLET_MUL = 10 --
FISHLK_CMD.SUB_C_USER_LOCK_FISH = 11 -- 用户锁定鱼
FISHLK_CMD.SUB_C_OPEN_TREASURE_BOX = 12 -- 大转盘
FISHLK_CMD.SUB_C_HIT_FISH_TASK = 14 -- 击中任务鱼(红包)
return FISHLK_CMD
