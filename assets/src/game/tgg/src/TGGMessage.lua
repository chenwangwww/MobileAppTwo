local GameCMD = require("game.tgg.src.TGGCMD")

local _M = {}

-- 场景状态-游戏
function _M.onScenePlay(data)
    local params = {}

    params.lCellScore = data:readUInt64() -- 单位分数
    params.lUserScore = data:readUInt64() -- 当前分数

    -- 底注选择
    params.wMultiCell = {}
    for i = 1, 5 do
        params.wMultiCell[i] = data:readUInt16()
    end

    params.wSumFreeCount = data:readUInt16() -- 免费摇奖次数
    params.wSumBS = data:readUInt16() -- 当前已累加的免费摇奖奖励倍数
    params.cbBS = data:readUInt8() -- 每次免费摇奖所加倍数：5滚轮+1倍，6滚轮+2倍，7滚轮+3倍
    params.cbBonusLineCount = data:readUInt8() -- 下注线数
    params.lBonusCellScore = data:readUInt64() -- 单线下注分数
    params.szGameRoomName = data:readUString(32) -- 房间名称

    return params
end

-- 卡片滚动
function _M.onSubCardScroll(data)
    local params = {}
    params.cbCardType = {}
    local nSumCards = 0
    for i = 1, 15 do
        params.cbCardType[i] = data:readUInt8()
        nSumCards = nSumCards + params.cbCardType[i]
    end

    params.cbMaskCard = {} -- 中奖图案掩码（具体位置图案是否中奖）
    for i = 1, 15 do
        params.cbMaskCard[i] = data:readUInt8()
    end

    -- 各图案中奖情况:三连四连五连线各中几个, wCount[x][y]:  x为图案，y值(0为5连，1为4连，2为3连)
    params.wCount = {}
    for a = 1, 8 do
        params.wCount[a] = {}
        for b = 1, 3 do
            params.wCount[a][b] = data:readUInt16()
        end
    end

    -- //*********1为中奖图案，0为未中奖图************
    -- //*********0*1*1*0*0****************
    -- //*********1*0*0*0*1****************
    -- //*********0*0*1*1*1****************

    params.lUserScore = data:readInt64() -- 当前分数（未加上本次所赢得的分数值）
    params.lWinScore = data:readInt64() -- 输赢分数 （包含中得彩金的数值）
    params.wFreeCount = data:readUInt8() -- 本次中得免费摇奖次数
    params.wSumFreeCount = data:readUInt16() -- 中得免费摇奖总次数
    params.bFreeGame = data:readUInt8() -- 本次是否免费摇奖
    params.wSumBS = data:readUInt16() -- 当前已累加的免费摇奖奖励倍数
    params.cbBS = data:readUInt8() -- 每次免费摇奖所加倍数：5滚轮+1倍，6滚轮+2倍，7滚轮+3倍

    -- "%Y%m%d%H%M%S"
    params.roundstr = os.date("%H%M%S") .. table.concat(params.cbCardType) .. string.format("%03d", nSumCards)
    return params
end

-- 中奖消息
function _M.onSubMessageInfo(data)
    local params = {}
    params.szContent = data:readUString(200) -- 消息内容
    return params
end

-- 最后的中奖信息
function _M.onSubSendGoldInfo(data)
    local params = {}
    params.szContent = data:readUString(200) -- 消息内容
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
function _M.sendFreeScroll()
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_BONUS_SCROLL, 1024)
    obj:release()
end

return _M
