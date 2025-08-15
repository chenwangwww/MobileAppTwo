local GameCMD = require("game.zslc.src.ZSLCCMD")

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
    for i = 1, 5 do
        params.wMultiCell[i] = data:readUInt16()
    end

    -- 单线下注分数
    params.lJetCellScore = data:readInt64()

    -- 彩金池
    params.lGoldPool = data:readInt64()

    -- 房间名称
    params.szGameRoomName = data:readUString(64)

    params.dwCardTimes = {} -- 赔率信息
    for i = 0, 13 do
        params.dwCardTimes[i] = params.dwCardTimes[i] or {}
        for ii = 1, 4 do
            params.dwCardTimes[i][ii] = data:readUInt32()
        end
    end

    return params
end

-- 卡片滚动
function _M.onSubCardScroll(data, logic)
    local params = {}

    local tempData = {}

    params.nBetSum = data:readInt64()

    -- 卡片类型
    params.slots = {}
    -- 中间转盘的三个数据0 - 樱桃, 1 - 柠檬, 2 - 兰布林, 3 - 铃铛，4 - 黄金，5 - 钻石，6 - 皇冠,7 - JP樱桃, 8 - JP柠檬, 9 - JP兰布林, 10 - JP铃铛，11 - JP黄金，12 - JP钻石，13 - JP皇冠
    for i = 1, 3 do
        params.slots[i] = data:readUInt8()
    end

    -- 玛丽索引(玛丽顺序2, 1, 0, 3, 6, 2, 0, 1, 4, 3, 0, FIRE_VALUE, 1, 2, 5, 0, 1, 4, TANK_VALUE, 3, 0, 1, 5, 2, 1, TRAIN_VALUE, 0, 4 )
    params.marioIdx = data:readUInt8()

    -- 额外玛丽。如果cbMarioIndex为火车，则此处对应火车的最后停留（4个）
    params.jackpot = {
        [1] = {
            marioType = 0,
            nCompleteState = 0,
            tMarioIdxs = {},
            record = {} -- {{timestamp = 0, agentIdx = 0}}
        },

        [2] = {
            marioType = 0,
            nCompleteState = 0,
            tMarioIdxs = {},
            record = {} -- {{timestamp = 0, agentIdx = 0}}
        }
    }

    -- 额外玛丽。如果cbMarioIndex为火车，则此处对应火车的最后停留（4个）
    for i = 1, 8 do
        params.jackpot[1].tMarioIdxs[i] = data:readUInt8()
    end

    -- 额外玛丽。如果cbExtraMarioIndex1中有烟火或战车，则此处是烟花或坦克的送灯
    for i = 1, 8 do
        params.jackpot[2].tMarioIdxs[i] = data:readUInt8()
    end

    -- 当前分数（未加上本次所赢得的分数值）
    params.curPoint = data:readInt64()

    -- 输赢分数 （包含中得彩金的数值）
    params.winPoint = data:readInt64()

    -- 中得彩金
    params.lWinGold = data:readInt64()

    -- 剩余彩金
    params.lGoldPool = data:readInt64()

    -------------------------------------------------------------
    params.marioIdx = logic:convertIdx(params.marioIdx)

    local temp1, temp2 = {}, {}
    local val

    for i = 1, 8 do
        val = logic:convertIdx(params.jackpot[1].tMarioIdxs[i])
        if val == nil then
            break
        end
        temp1[i] = val
    end

    for i = 1, 8 do
        val = logic:convertIdx(params.jackpot[2].tMarioIdxs[i])
        if val == nil then
            break
        end
        temp2[i] = val
    end

    params.jackpot[1].tMarioIdxs = temp1
    params.jackpot[2].tMarioIdxs = temp2

    params.jackpot[1].marioType = logic:getMarioType({params.marioIdx})
    params.jackpot[2].marioType = logic:getMarioType(params.jackpot[1].tMarioIdxs)

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
function _M.sendCardScroll(lJetCellScore)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, GameCMD.SUB_C_CARD_SCROLL, 1024)
    obj:writeInt64(lJetCellScore) -- 单线分数
    obj:release()
end

return _M

