--[[
	游戏定义
]] local _M = {}
_M.KIND_ID = 1005
_M.GAME_PLAYER = 1
_M.GAME_NAME = "天降财神"
_M.GS_MJ_FREE = GameDefine.GAME_STATUS_FREE -- 空闲状态
_M.GS_MJ_PLAY = GameDefine.GAME_STATUS_PLAY -- 游戏状态

_M.RES_PATH = "game/csd/res/"

-- 服务器命令结构
_M.SUB_S_CARD_SCROLL = 101 -- 卡片滚动
_M.SUB_S_MESSAGE_INFO = 102 -- 中奖消息
_M.SUB_S_UPDATEGOLDPOOL = 107 -- 更新彩金池
_M.SUB_S_SENDGOLD_INFO = 108 -- 最后中奖信息播报
_M.SUB_S_GOLD_HISTORY = 109 -- 中奖彩金历史玩家

_M.SUB_C_CARD_SCROLL = 1 -- 卡片滚动
_M.SUB_C_BONUS_SCROLL = 2 -- 免费摇奖滚动

_M.PATTERN_ROW = 3
_M.PATTERN_COL = 5

_M.MAX_LINE = 25
_M.MAX_JOSS = 6

-- 图案
_M.PATTERN = {
    JACKPOT = 0,
    SHI_TOU = 1,
    BA_GUA_YU = 2,
    YU_RU_YI = 3,
    YUAN_BAO = 4,
    TONG_QIAN = 5,
    ACE = 6,
    KING = 7,
    QUEEN = 8,
    JACK = 9,
    WILD = 10,

    SCATTER = 11,
    XIANG_HUO = 12
}

_M.Lines = {{6, 7, 8, 9, 10}, {1, 2, 3, 4, 5}, {11, 12, 13, 14, 15}, {1, 7, 13, 9, 5}, {11, 7, 3, 9, 15}, {6, 2, 3, 4, 10}, {6, 12, 13, 14, 10}, {1, 2, 8, 14, 15}, {11, 12, 8, 4, 5},
            {6, 12, 8, 4, 10}, {6, 2, 8, 14, 10}, {1, 7, 8, 9, 5}, {11, 7, 8, 9, 15}, {1, 7, 3, 9, 5}, {11, 7, 13, 9, 15}, {6, 7, 3, 9, 10}, {6, 7, 13, 9, 10}, {1, 2, 13, 4, 5}, {11, 12, 3, 14, 15},
            {1, 12, 13, 14, 5}, {11, 2, 3, 4, 15}, {6, 12, 3, 14, 10}, {6, 2, 13, 4, 10}, {1, 12, 3, 14, 5}, {11, 2, 13, 4, 15}}

_M.RATIO = {
    [_M.PATTERN.JACKPOT] = {0, 0, 200, 500, 1000},
    [_M.PATTERN.SHI_TOU] = {0, 5, 50, 400, 800},
    [_M.PATTERN.BA_GUA_YU] = {0, 4, 30, 200, 500},
    [_M.PATTERN.YU_RU_YI] = {0, 4, 25, 100, 300},
    [_M.PATTERN.YUAN_BAO] = {0, 0, 20, 75, 150},
    [_M.PATTERN.TONG_QIAN] = {0, 0, 15, 50, 100},
    [_M.PATTERN.ACE] = {0, 0, 10, 30, 80},
    [_M.PATTERN.KING] = {0, 0, 8, 20, 60},
    [_M.PATTERN.QUEEN] = {0, 0, 6, 15, 50},
    [_M.PATTERN.JACK] = {0, 0, 5, 10, 40}
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

