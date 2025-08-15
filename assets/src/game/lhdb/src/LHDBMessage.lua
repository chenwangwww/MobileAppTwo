local GameCMD = require("game.lhdb.src.LHDBCMD")

local _M = {}

-- 场景状态-空闲
function _M.onSceneFree(data)
    local params = {}
    params.lCellScore = data:readDouble()
    params.lMaxJetton = data:readDouble()

    return params
end

-- 游戏开始
function _M.onSubGameStart(data)
    local params = {}
    params.llCurrentTotal = data:readInt64() -- 当前总【累积奖】
    params.llBetPoint = data:readInt64() -- 用户每一注的下注点数
    params.lBetCount = data:readInt32() -- 用户下注注数
    params.llCardPoint = data:readInt64() -- 玩家卡片中的总点数
    params.llNowPoint = data:readInt64() -- 玩家当前本场点数
    params.cBrickLeft = data:readUInt8() -- 当前关对应的墙壁或地板中剩余砖块数
    params.cStage = data:readUInt8() -- 当前处于第几关

    -- first start
    params.llMaxBetPoint = data:readInt64() -- 单注点数上限
    params.llMinBetPoint = data:readInt64() -- 单注点数下限
    params.llCellScore = data:readInt64() -- 底分:用【下注点数】*【底分】的结果修改玩家的【金币总额】
    params.llSuperBonusUnit = data:readInt64() -- 超级大奖每注奖金额

    -- new game
    params.gems = {}
    for i = 1, 60 do
        params.gems[i] = data:readUInt16() -- 压缩过的宝石分布
    end
    params.gemLen = data:readUInt16()

    params.cbDragonCount = data:readUInt8()
    params.cbDragonCountOk = data:readUInt8()

    return params
end

function _M.onSubMsgInfo(data)
    local params = {}
    params.szContent = data:readUString(200)
    return params
end

function _M.onSubUpdateGoldPool(data)
    local params = {}
    params.llCurrentTotal = data:readInt64()
    return params
end

------------------------------------------------------------------------------------
--[[
客户端命令结构
]]
------------------------------------------------------------------------------------
-- 用户下注
function _M.sendBetCount(betPoint, betCount)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 801, 1024)
    obj:writeInt64(betPoint)
    obj:writeInt32(betCount)

    obj:release()
end

-- 玩家向服务端汇报中奖奖金额
function _M.sendBonusReport(gemBonus, superCreated)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 809, 1024)
    obj:writeInt64(gemBonus)
    obj:writeInt8(superCreated and 1 or 0)

    obj:release()
end

--
function _M.sendExit(save)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 802, 1024)
    obj:writeInt8(save and 1 or 0)

    obj:release()
end

function _M.sendNewGame()
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 803, 1024)
    obj:release()
end

return _M

