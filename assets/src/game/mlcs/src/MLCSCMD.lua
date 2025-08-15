--[[
	游戏定义
]] local _M = {}
_M.KIND_ID = 1010
_M.GAME_PLAYER = 1
_M.GAME_NAME = "秘鲁传说"
_M.GS_MJ_FREE = GameDefine.GAME_STATUS_FREE -- 空闲状态
_M.GS_MJ_PLAY = GameDefine.GAME_STATUS_PLAY -- 游戏状态

-- 服务器命令结构
_M.SUB_S_CARD_SCROLL = 101 -- 卡片滚动
_M.SUB_S_MESSAGE_INFO = 102 -- 中奖消息
_M.SUB_S_SENDGOLD_INFO = 108 -- 最后中奖信息播报
_M.SUB_C_CARD_SCROLL = 1 -- 卡片滚动
_M.SUB_C_BONUS_SCROLL = 2 -- 免费摇奖滚动
_M.SUB_C_ANDROID_STAND_UP = 3 -- 机器人起立

return _M
