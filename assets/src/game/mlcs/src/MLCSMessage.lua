local GameCMD = require("game.mlcs.src.MLCSCMD")

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
    params.lFreeSumGold = data:readUInt64() -- 免费摇奖总盈利
    params.cbBonusLineCount = data:readUInt8() -- 下注线数
    params.lBonusCellScore = data:readUInt64() -- 单线下注分数
    params.szGameRoomName = data:readUString(32) -- 房间名称

    return params
end

-- 卡片滚动
function _M.onSubCardScroll(data)
    local params = {}

    -- 卡片类型  0 - 500倍图 1 - 300倍图, 2 - 150倍图, 3 -100倍图 , 4 - 80倍图，5 - 60倍图，6 - 45倍图，7 - ？，8 - 免费
    params.cbCardType = {{}, {}, {}, {}, {}}
    for k = 1, 20 do
        for i = 1, 5 do
            params.cbCardType[i][k] = data:readUInt8()
        end
    end

    params.lUserScore = data:readInt64() -- 当前分数（未加上本次所赢得的分数值）
    params.lWinScore = data:readInt64() -- 输赢分数 （包含中得彩金的数值）
    params.wFreeCount = data:readUInt8() -- 本次中得免费摇奖次数
    params.wSumFreeCount = data:readUInt16() -- 中得免费摇奖总次数
    params.bFreeGame = data:readUInt8() -- 本次是否免费摇奖
    params.lSumFreeGold = data:readUInt64() -- 免费摇奖获取的总金额

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
