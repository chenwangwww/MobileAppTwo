-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- endregion
local SHZ_CMD = {}
-------------------------------------------------------------
-- 公共宏定义
SHZ_CMD.KIND_ID = 203 -- 游戏ID
SHZ_CMD.GAME_NAME = "水浒传" -- 游戏名字
-- 组件属性
SHZ_CMD.GAME_PLAYER_1 = 1 -- 游戏人数
SHZ_CMD.VERSION_SERVER = "1.0.0" -- 服务端程序版本
SHZ_CMD.VERSION_CLIENT = "1.0.0" -- 客服端程序版本

SHZ_CMD.GAME_SCENE_FREE = 0 -- 等待开始
SHZ_CMD.GAME_SCENE_PLAY = 100 -- 叫分状态

-- 比倍定义
SHZ_CMD.DICE_BIG = 0 -- 比倍：大
SHZ_CMD.DICE_SMALL = 1 -- 比倍：小
SHZ_CMD.DICE_DRAW = 2 -- 比倍：和

-- 数据长度
SHZ_CMD.SERVER_LEN = 32 -- 房间长度

-- 动画标志
SHZ_CMD.Auto_Win = 1
SHZ_CMD.Auto_Lost = 2
SHZ_CMD.Game2_To_Game1 = 3
SHZ_CMD.Game3_To_Game1 = 4
SHZ_CMD.Game1_To_Game1 = 5
SHZ_CMD.ActionCount = 6
SHZ_CMD.Connect = 6

-- 当前游戏1滚动状态
SHZ_CMD.game1_state_Free = 7
SHZ_CMD.game1_state_scroll = 8

------------------------------------------------------------
-- 服务器命令结构

SHZ_CMD.SUB_S_ADD_SCORE = 101 -- 用户加注
SHZ_CMD.SUB_S_CARD_SCROLL = 102 -- 卡片滚动
SHZ_CMD.SUB_S_BIG_SMALL = 103 -- 比倍消息
SHZ_CMD.SUB_S_MARIO_SCROLL = 104 -- 玛丽滚动
SHZ_CMD.SUB_S_BIG_SMALL_RECORD = 105 -- 比倍记录
SHZ_CMD.SUB_S_MESSAGE_INFO = 106 -- 中奖消息
SHZ_CMD.SUB_S_STOP_MARIO = 107 -- 玛丽结束

-------------------------------------------------------------
-- 客户端命令结构

SHZ_CMD.SUB_C_ADD_SCORE = 1 -- 用户加注
SHZ_CMD.SUB_C_CARD_SCROLL = 2 -- 卡片滚动
SHZ_CMD.SUB_C_BIG_SMALL = 3 -- 比倍消息
SHZ_CMD.SUB_C_MARIO_SCROLL = 4 -- 玛丽滚动
SHZ_CMD.SUB_C_BIG_SMALL_RECORD = 5 -- 比倍记录
SHZ_CMD.SUB_C_HALF_ALL_DOUBLE = 6 -- 比倍消息
SHZ_CMD.SUB_C_STOP_MARIO = 8 -- 玛丽结束
return SHZ_CMD
