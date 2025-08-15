local _M = {}

_M.KIND_ID = 27
_M.GAME_PLAYER = 8
_M.GAME_NAME = "火拼牛牛"
_M.RES_PREFIX = "game/jdnn/res/"

_M.MAX_CARD = 5

-- 服务器命令结构
_M.GS_TK_FREE = GameDefine.GAME_STATUS_FREE -- 空闲状态
_M.GS_TK_PLAYING = 102 -- 游戏状态
_M.GS_TK_CALL = 100 -- 叫庄状态
_M.GS_TK_SCORE = 101 -- 下注状态

_M.SUB_S_GAME_START = 100 -- 游戏开始
_M.SUB_S_ADD_SCORE = 101 -- 加注结果
_M.SUB_S_PLAYER_EXIT = 102 -- 用户强退
_M.SUB_S_SEND_CARD = 103 -- 发牌消息
_M.SUB_S_GAME_END = 104 -- 游戏结束
_M.SUB_S_OPEN_CARD = 105 -- 用户摊牌
_M.SUB_S_CALL_BANKER = 106 -- 用户叫庄
_M.SUB_S_ALL_CARD = 107 -- 发送基数 --  GAME_BASE
_M.SUB_S_AMDIN_COMMAND = 108 -- 系统控制
_M.SUB_S_SHOWSTART = 109 -- 通知当前玩家可以开始本局
_M.SUB_S_PASS_BANKER = 110 -- 放弃当庄

_M.TIME_USER_FREE = 15 -- 空闲定时器
_M.TIME_USER_CALL_BANKER = 15 -- 叫庄定时器
_M.TIME_USER_START_GAME = 15 -- 开始定时器
_M.TIME_USER_ADD_SCORE = 15 -- 放弃定时器
_M.TIME_USER_OPEN_CARD = 29 -- 摊牌定时器
_M.TIME_USER_CHANGE_CARD = 15 -- 换牌定时器
-- _M.TIME_USER_OPEN_ING               =10                     -- 开牌中

_M.OxType = {
    NONE = 0x00, -- 无牛

    ONE = 0x01,
    TWO = 0x02,
    THREE = 0x03,
    FOUR = 0x04,
    FIVE = 0x05,
    SIX = 0x06,
    SEVEN = 0x07,
    EIGHT = 0x08,
    NINE = 0x09,

    BULL = 0x10 -- 牛牛
    -- TODO:类型自定
    -- MOSAIC = 0x11,  --五花牛
    -- CALVES = 0x12,  --五小牛
    -- BOMB = 0x13,    --炸弹
}

-- 用户状态
_M.USER_STATUS = {
    NULL = 0, -- null
    PLAYING = 1, -- 游戏
    DYNAMIC = 2 -- 动态
}

_M.SEAT = {
    TOP = 0,
    -- RIGHT_TOP = 1,
    RIGHT_MIDDLE = 1,
    -- RIGHT_DOWN = 2,
    DOWN = 2,
    -- LEFT_DOWN = 4,
    LEFT_MIDDLE = 3
    -- LEFT_TOP = 5
}

_M.subText = function(text, subWidth, repStr)
    if not text or tolua.type(text) ~= "ccui.Text" or not subWidth then
        return
    end

    local width = text:getContentSize().width
    if width <= subWidth then
        return
    end

    local str = text:getString()
    local length = string.utf8len(str)
    for len = length - 1, 1, -1 do
        local tmp = GameUtil.subStringFromUTF8(str, len, nil, false)
        text:setString(tmp)
        width = text:getContentSize().width
        if width <= subWidth then
            str = tmp
            break
        end
    end
    if repStr then
        str = str .. tostring(repStr)
    end
    text:setString(str)
end

return _M
