--[[
	游戏定义
]] local _M = {}
_M.KIND_ID = 1008
_M.GAME_PLAYER = 1
_M.GAME_NAME = "僵尸风云"
_M.GS_MJ_FREE = GameDefine.GAME_STATUS_FREE -- 空闲状态
_M.GS_MJ_PLAY = GameDefine.GAME_STATUS_PLAY -- 游戏状态

_M.RES_PATH = "game/jsfy/res/"

-- 服务器命令结构
_M.SUB_S_CARD_SCROLL = 101 -- 卡片滚动
_M.SUB_S_MESSAGE_INFO = 102 -- 中奖消息
_M.SUB_S_BONUS_RESULT = 103 -- 开宝箱
_M.SUB_S_UPDATEGOLDPOOL = 107 -- 更新彩金池
_M.SUB_S_SENDGOLD_INFO = 108 -- 最后中奖信息播报
_M.SUB_S_GOLD_HISTORY = 109 -- 中奖彩金历史玩家

_M.SUB_C_CARD_SCROLL = 1 -- 卡片滚动
_M.SUB_C_BONUS_SCROLL = 2 -- 免费摇奖滚动
_M.SUB_C_BONUS_SELECT = 4 -- 开宝箱

_M.PATTERN_ROW = 3
_M.PATTERN_COL = 5

_M.MAX_LINE = 30
_M.MAX_JOSS = 6

-- 图案
_M.PATTERN = {
    JIANG_SHI = 0,
    GONG_NV = 1,
    TONG_ZI = 2,
    JIN = 3,
    MU = 4,
    SHUI = 5,
    TU = 6,
    HUO = 7,
    WILD = 8,
    BONUS = 9,
    SCATTER = 10,

    QUESTION = 11 -- DEPRECATED
    -- XIANG_HUO = 12,
}

_M.Lines = {{6, 7, 8, 9, 10}, {1, 2, 3, 4, 5}, {11, 12, 13, 14, 15}, {1, 7, 13, 9, 5}, {11, 7, 3, 9, 15}, {6, 2, 3, 4, 10}, {6, 12, 13, 14, 10}, {1, 2, 8, 14, 15}, {11, 12, 8, 4, 5},
            {6, 12, 8, 4, 10}, {6, 2, 8, 14, 10}, {1, 7, 8, 9, 5}, {11, 7, 8, 9, 15}, {1, 7, 3, 9, 5}, {11, 7, 13, 9, 15}, {6, 7, 3, 9, 10}, {6, 7, 13, 9, 10}, {1, 2, 13, 4, 5}, {11, 12, 3, 14, 15},
            {1, 12, 13, 14, 5}, {11, 2, 3, 4, 15}, {6, 12, 3, 14, 10}, {6, 2, 13, 4, 10}, {1, 12, 3, 14, 5}, {11, 2, 13, 4, 15}, {11, 2, 8, 14, 5}, {1, 12, 8, 4, 15}, {1, 12, 8, 14, 5},
            {11, 2, 8, 4, 15}, {11, 7, 3, 4, 10}}

_M.RATIO = {
    -- [_M.PATTERN.BONUS] = 		{0, 0, 200, 500, 1000},
    -- [_M.PATTERN.JIANG_SHI] = 	{0, 5, 50, 400, 800},
    -- [_M.PATTERN.GONG_NV] = 		{0, 4, 30, 200, 500},
    -- [_M.PATTERN.TONG_ZI] = 		{0, 4, 25, 100, 300},
    -- [_M.PATTERN.JIN] = 			{0, 0, 20, 75, 150},
    -- [_M.PATTERN.MU] = 			{0, 0, 15, 50, 100},
    -- [_M.PATTERN.SHUI] = 		{0, 0, 10, 30, 80},
    -- [_M.PATTERN.TU] = 			{0, 0, 8, 20, 60},
    -- [_M.PATTERN.HUO] = 			{0, 0, 6, 15, 50},
    -- [_M.PATTERN.QUESTION] = 	{0, 0, 5, 10, 40},

    [_M.PATTERN.JIANG_SHI] = {0, 0, 80, 200, 2000},
    [_M.PATTERN.GONG_NV] = {0, 0, 75, 175, 1200},
    [_M.PATTERN.TONG_ZI] = {0, 0, 45, 100, 800},
    [_M.PATTERN.JIN] = {0, 0, 35, 80, 650},
    [_M.PATTERN.MU] = {0, 0, 30, 70, 500},
    [_M.PATTERN.SHUI] = {0, 0, 10, 30, 100},
    [_M.PATTERN.TU] = {0, 0, 5, 15, 70},
    [_M.PATTERN.HUO] = {0, 0, 3, 10, 50}
}

_M.addAnim = function(csbFile, parent, ...)
    local anim = cc.CSLoader:createNode(_M.RES_PATH .. csbFile):addTo(parent)
    local action = cc.CSLoader:createTimeline(_M.RES_PATH .. csbFile)
    if ... then
        action:gotoFrameAndPlay(...)
    else
        action:gotoFrameAndPlay(0)
    end
    anim:runAction(action)
    return anim, action
end

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

