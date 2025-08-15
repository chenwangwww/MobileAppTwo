local GameCMD = require("game.jpm.src.JPMCMD")

local _M = {}

function _M.onScenePlay(data)
    local params = {}
    params.lCellScore = data:readInt64()
    params.lUserScore = data:readInt64()
    params.wMultiCell = {}
    for i = 1, 5 do
        params.wMultiCell[i] = data:readUInt16()
    end
    params.wFreeCount = data:readUInt16();
    params.cbBonusLineCount = data:readUInt8();
    params.lBonusCellScore = data:readInt64()
    params.szGameRoomName = data:readUString(GameCMD.SERVER_LEN)
    return params
end

function _M.onGameCardScroll(data)
    local params = {}
    params.cbCardType = {}
    for k = 1, 20 do
        params.cbCardType[k] = {};
        for i = 1, 5 do
            params.cbCardType[k][i] = data:readUInt8()
        end
    end
    params.lUserScore = data:readInt64()
    params.lWinScore = data:readInt64()
    params.wFreeCount = data:readInt8()
    params.wSumFreeCount = data:readInt16()
    params.bFree = data:readInt8()
    params.lSumFreeGold = data:readInt64()

    return params
end

function _M.onSubMessageInfo(data)
    local params = {}
    params.szContent = data:readUString(200)
    return params
end

function _M.sendCardScroll(lTableScore, cbLineCount)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_CARD_SCROLL, 1024)
    obj:writeInt64(lTableScore)
    obj:writeUInt8(cbLineCount)
    obj:release()
end

function _M.sendBounsScroll()
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_BONUS_SCROLL, 1024)
    obj:release()
end

return _M
