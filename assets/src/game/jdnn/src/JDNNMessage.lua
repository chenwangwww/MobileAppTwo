-- local JDNNCMD = require "app.game.hzmj.JDNNCMD" 
local GameCMD = require("game.jdnn.src.JDNNCMD")

local _M = {}

-- 场景状态-空闲
function _M.onSceneFree(data)
    local params = {}

    -- 基础金币
    params.lCellScore = data:readInt64()

    -- 庄家用户
    params.wBankerUser = data:readUInt16()

    -- 是否托管
    params.bTrustee = {}
    for i = 1, 4 do
        params.bTrustee[i] = data:readUInt8()
    end

    return params
end

-- 场景状态--叫庄
function _M.onSceneCallBank(date)
    local params = {}
    -- 叫庄用户
    params.wCallBanker = data:readUInt16()
    -- 动态加入
    params.cbDynamicJoin = data:readUInt8()
    -- 用户状态
    params.cbPlayStatus = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.cbPlayStatus[i] = data:readUInt8()
    end

    return params
end

-- 场景状态--加注
function _M.onSceneAddScore(data)
    local params = {}
    -- 用户状态
    params.cbPlayStatus = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.cbPlayStatus[i] = data:readUInt8()
    end
    -- 最大下注
    params.lTurnMaxScore = data:readInt64()
    -- 下注数目
    params.lTableScore = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.lTableScore[i] = data:readInt64()
    end
    -- 庄家用户
    params.wBankerUser = data:readUInt16()

    return params
end

function _M.onScenePlay(data)
    local params = {}
    -- 用户状态
    params.cbPlayStatus = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.cbPlayStatus[i] = data:readUInt8()
    end
    -- 最大下注
    params.lTurnMaxScore = data:readInt64()
    -- 下注数目
    params.lTableScore = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.lTableScore[i] = data:readInt64()
    end
    -- 庄家用户
    params.wBankerUser = data:readUInt16()
    -- cards
    local cardCount = GameCMD.GAME_PLAYER * GameCMD.MAX_CARD
    params.cards = {}
    for i = 1, cardCount do
        params.cards[i] = data:readUInt8()
    end
    -- 牛牛数据
    params.bOxCard = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.bOxCard[i] = data:readUInt8()
    end

    return params
end

----------------------------------------------------------
-- 游戏开始
function _M.onSubGameStart(data)
    local params = {}
    -- 最大下注
    params.lTurnMaxScore = data:readInt64()
    -- 庄家用户
    params.wBankerUser = data:readUInt16()
    -- 用户状态
    params.cbPlayStatus = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.cbPlayStatus[i] = data:readUInt8()
    end

    return params
end

-- 叫庄
function _M.onSubCallBanker(data)
    local params = {}
    params.wCallBanker = data:readUInt16()
    params.bFirstTimes = data:readUInt8()
    params.cbPlayerStatus = data:readUInt8()
    return params
end

-- 加注结果
function _M.onSubAddScore(data)
    local params = {}
    -- 加注玩家
    params.wChairID = data:readUInt16()
    -- 加注数目
    params.lScore = data:readInt64()
    -- 玩家状态
    params.cbPlayStatus = data:readUInt8()

    return params
end

-- 发牌消息
function _M.onSubSendCard(data)
    local params = {}
    -- cards
    local cardCount = GameCMD.GAME_PLAYER * GameCMD.MAX_CARD
    params.cards = {}
    for i = 1, cardCount do
        params.cards[i] = data:readUInt8()
    end
    return params
end

-- 亮牌
function _M.onSubOpenCard(data)
    local params = {}
    params.wChairID = data:readUInt8()
    return params
end

-- 游戏结束
function _M.onSubGameEnd(data)
    local params = {}
    -- 游戏税收
    params.revenu = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.revenu[i] = data:readInt64()
    end
    -- 游戏得分
    params.score = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.score[i] = data:readInt64()
    end
    -- cards
    local cardCount = GameCMD.GAME_PLAYER
    params.cards = {}
    for i = 1, cardCount do
        params.cards[i] = data:readUInt8()
    end
    -- 用户状态
    params.cbPlayStatus = {}
    for i = 1, GameCMD.GAME_PLAYER do
        params.cbPlayStatus[i] = data:readUInt8()
    end

    return params
end

------------------------------------------------------------------------------------
--[[
客户端命令结构
]]
------------------------------------------------------------------------------------

function _M.sendReady()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_READY, 1024)
    rpcSend:writeUInt8(1)
    rpcSend:release()
end

function _M.sendLeave()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 4, 1024) -- OxtbNewDefine.SUB_C_LEAVE
    rpcSend:writeUInt8(1)
    rpcSend:release()
end

function _M.sendCallBanker(bBanker)
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 1, 1024)
    rpcSend:writeUInt8(bBanker and 1 or 0)
    rpcSend:release()
end

function _M.sendAddCard(lScore)
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 2, 1024)
    rpcSend:writeUInt64(lScore)
    rpcSend:release()
end

function _M.sendOpenCard(bOX)
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 3, 1024)
    rpcSend:writeUInt8(bOX)
    rpcSend:release()
end

return _M
