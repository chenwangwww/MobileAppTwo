-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- endregion
local JLDB_CMD = {}
-------------------------------------------------------------
-- 公共宏定义
JLDB_CMD.KIND_ID = 204 -- 游戏ID
JLDB_CMD.GAME_NAME = "九连夺宝" -- 游戏名字
-- 组件属性
JLDB_CMD.GAME_PLAYER_1 = 1 -- 游戏人数
JLDB_CMD.VERSION_SERVER = "1.0.0" -- 服务端程序版本
JLDB_CMD.VERSION_CLIENT = "1.0.0" -- 客服端程序版本

JLDB_CMD.GAME_SCENE_FREE = 0 -- 等待开始
JLDB_CMD.GAME_SCENE_PLAY = 100 -- 叫分状态

-- 比倍定义
JLDB_CMD.DICE_BIG = 0 -- 比倍：大
JLDB_CMD.DICE_SMALL = 1 -- 比倍：小
JLDB_CMD.DICE_DRAW = 2 -- 比倍：和

-- 数据长度
JLDB_CMD.SERVER_LEN = 32 -- 房间长度

-- 动画标志
JLDB_CMD.Game1_End = 1
JLDB_CMD.Game1_To_Game1 = 2
JLDB_CMD.CardScroll = 3
JLDB_CMD.ActionCount = 3

------------------------------------------------------------
-- 服务器命令结构

JLDB_CMD.SUB_S_ADD_SCORE = 101 -- 用户加注
JLDB_CMD.SUB_S_CARD_SCROLL = 102 -- 卡片滚动
JLDB_CMD.SUB_S_BIG_SMALL = 103 -- 比倍消息
JLDB_CMD.SUB_S_MARIO_SCROLL = 104 -- 玛丽滚动
JLDB_CMD.SUB_S_BIG_SMALL_RECORD = 105 -- 比倍记录
JLDB_CMD.SUB_S_MESSAGE_INFO = 106 -- 中奖消息
JLDB_CMD.SUB_S_UPDATEGOLDPOOL = 107 -- 更新彩金池

-------------------------------------------------------------
-- 客户端命令结构

JLDB_CMD.SUB_C_ADD_SCORE = 1 -- 用户加注
JLDB_CMD.SUB_C_CARD_SCROLL = 2 -- 卡片滚动
JLDB_CMD.SUB_C_BIG_SMALL = 3 -- 比倍消息
JLDB_CMD.SUB_C_MARIO_SCROLL = 4 -- 玛丽滚动
JLDB_CMD.SUB_C_BIG_SMALL_RECORD = 5 -- 比倍记录
JLDB_CMD.SUB_C_HALF_ALL_DOUBLE = 6 -- 比倍消息

return JLDB_CMD
