local GameCMD = require("game.happyfruit.src.HappyFruitCMD")

local _M = {}

-- 场景状态-游戏
function _M.onScenePlay(data)
    local params = {}

    -- 单位分数
    params.lCellScore = data:readInt64()

    -- 当前分数
    params.lUserScore = data:readInt64()

    -- 底注选择
    params.wMultiCell = {}
    for i = 1, 7 do
        params.wMultiCell[i] = data:readUInt16()
    end

    -- 免费摇奖次数
    params.wBonusCount = data:readUInt16()

    -- 下注线数
    params.cbBonusLineCount = data:readUInt8()

    -- 单线下注分数
    params.lBonusCellScore = data:readInt64()

    -- 彩金池
    params.lGoldPool = data:readInt64()

    -- 房间名称
    params.szGameRoomName = data:readUString(32)

    return params
end

-- 卡片滚动
function _M.onSubCardScroll(data)
    local params = {}

    -- 卡片类型
    params.cbCardType = {}
    for i = 1, 15 do
        params.cbCardType[i] = data:readUInt8()
    end

    -- 当前分数（未加上本次所赢得的分数值）
    params.lUserScore = data:readInt64()

    -- 输赢分数 （包含中得彩金的数值）
    params.lWinScore = data:readInt64()

    -- 中得彩金
    params.lWinGold = data:readInt64()

    -- 中得免费摇奖次数
    params.cbBonusCount = data:readUInt8()

    -- 剩余彩金
    params.lGoldPool = data:readInt64()

    -- 中得免费摇奖总次数
    params.wSumBonusCount = data:readUInt16()

    -- 本次是否免费摇奖
    params.bBonus = data:readUInt8()

    return params
end

-- 中奖消息
function _M.onSubMessageInfo(data)
    local params = {}

    -- 消息内容
    params.szContent = data:readUString(200)

    return params
end

-- 最后的中奖信息
function _M.onSubSendGoldInfo(data)
    local params = {}

    -- 消息内容
    params.szContent = data:readUString(200)

    return params
end

-- 更新彩金池
function _M.onSubUpdateGoldPool(data)
    local params = {}
    params.lGoldPool = data:readInt64()

    return params
end

-- 用户游戏
function _M.sendCardScroll(lTableScore, cbLineCount)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_CARD_SCROLL, 1024)
    obj:writeInt64(lTableScore) -- 单线分数
    obj:writeUInt8(cbLineCount) -- 压注线数
    obj:release()
end

-- 免费摇奖滚动
function _M.sendBonusScroll()
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_BONUS_SCROLL, 1024)
    obj:release()
end

return _M

