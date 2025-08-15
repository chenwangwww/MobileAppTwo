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
    -- 免费摇奖次数
    params.wFreeCount = data:readUInt16()
    -- 香火个数
    -- params.wXiangHuoCount = data:readUInt16()
    -- 散财摇奖次数
    -- params.wSanCaiCount = data:readUInt16()
    -- 下注线数
    params.cbBonusLineCount = data:readUInt8()
    -- 单线下注分数
    params.lBonusCellScore = data:readInt64()
    -- 免费摇奖累计中奖彩金
    params.lSumFreeGold = data:readInt64()
    -- 彩金池
    -- params.lGoldPool = data:readInt64()
    -- 卡片类型
    params.cbCardType = {}
    for i = 1, 15 do
        params.cbCardType[i] = data:readUInt8()
    end
    -- ?的代替值
    params.cbAnyCardValue = data:readUInt8()
    -- 是否开启宝箱
    params.bBonus = data:readUInt8()
    -- 宝箱的开启情况
    params.wBonusValue = {}
    for i = 1, 4 do
        local temp_value = {}
        for j = 1, 5 do
            temp_value[j] = data:readUInt16()
        end
        params.wBonusValue[i] = temp_value
    end
    -- 玩家选择了第几行的第几列
    params.cbBonusSelect = {}
    for i = 1, 4 do
        params.cbBonusSelect[i] = data:readUInt8()
    end
    -- 累计已中多少宝箱彩金
    params.lSumBonusGold = data:readInt64()
    -- 赢的分数
    params.lWinScore = data:readInt64()
    -- 房间名称
    params.szGameRoomName = data:readUString(32)

    return params
end

-- 卡片滚动
function _M.onSubCardScroll(data)
    local params = {}
    -- 单线下注分数
    params.lBonusCellScore = data:readInt64()
    -- 卡片类型
    params.cbCardType = {}
    for i = 1, 15 do
        params.cbCardType[i] = data:readUInt8()
    end
    -- ?的替代值
    params.cbAnyCardValue = data:readUInt8()
    -- 当前分数（未加上本次所赢得的分数值）
    params.lUserScore = data:readInt64()
    -- 输赢分数 （包含中得彩金的数值）
    params.lWinScore = data:readInt64()
    -- 中得彩金
    -- params.lWinGold = data:readInt64()
    -- 中得免费摇奖次数
    params.cbFreeCount = data:readUInt8()
    -- 剩余彩金
    -- params.lGoldPool = data:readInt64()
    -- 中得免费摇奖总次数
    params.wSumFreeCount = data:readUInt16()
    -- 本次是否免费摇奖
    params.bFree = data:readUInt8()
    -- 免费摇奖获取的总金额
    params.lSumFreeGold = data:readInt64()

    -- 本次散财摇奖总次数
    -- params.wSanCaiCount = data:readUInt16()
    -- 本次是否开宝箱
    params.bBonus = data:readUInt8()

    -- 本次是否是散财
    -- params.bSanCai = data:readUInt8()
    -- 免费总奖励
    -- params.lSumFree = data:readInt64()
    -- 散财总奖励
    -- params.lSumScatter = data:readInt64()
    -- 香火数量
    -- params.wXiangHuoCount = data:readUInt16()

    -- 宝箱的开启情况
    params.wBonusValue = {}
    for i = 1, 4 do
        local temp_value = {}
        for j = 1, 5 do
            temp_value[j] = data:readUInt16()
        end
        params.wBonusValue[i] = temp_value
    end
    -- 玩家选择了第几行的第几列
    params.cbBonusSelect = {}
    for i = 1, 4 do
        params.cbBonusSelect[i] = data:readUInt8()
    end
    -- 累计已中多少宝箱彩金
    params.lSumBonusGold = data:readInt64()
    return params
end

-- 开宝箱
function _M.onSubBonusResult(data)
    local params = {}

    -- 输赢分数 （包含中得彩金的数值）
    params.lWinScore = data:readInt64()
    -- 单线分数
    params.lBonusCellScore = data:readInt64()
    -- 宝箱的开启情况
    params.wBonusValue = {}
    for i = 1, 4 do
        local temp_value = {}
        for j = 1, 5 do
            temp_value[j] = data:readUInt16()
        end
        params.wBonusValue[i] = temp_value
    end
    -- 玩家选择了第几行的第几列
    params.cbBonusSelect = {}
    for i = 1, 4 do
        params.cbBonusSelect[i] = data:readUInt8()
    end
    -- 累计已中多少宝箱彩金
    params.lSumBonusGold = data:readInt64()

    return params
end

-- 中奖消息
function _M.onSubMessageInfo(data)
    local params = {}
    -- 消息内容
    params.szContent = data:readUString(200)

    return params
end

--[[--最后的中奖信息
function _M.onSubSendGoldInfo(data)
    local params = { }
    --消息内容
    params.szContent = data:readUString(200)

    return params
end

--更新彩金池
function _M.onSubUpdateGoldPool(data)
    local params = { }
    params.lGoldPool = data:readInt64()
    return params
end

--彩金历史玩家
function _M.onSubGoldHistory(data)
    local params = { }
    for i=1,3 do
        local record = {}
        record.dwGameID = data:readUInt32()
        record.szNickName = data:readUString(64)
        record.szFaceAddr = data:readUString(328)
        record.lGold = data:readInt64()
        record.lTime = data:readInt64()
        table.insert(params, record)
    end
    return params
end--]]
---------------------------------------------------------------------------------------------------------------------------------
-- 用户游戏
function _M.sendCardScroll(lTableScore, cbLineCount)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 1, 1024)
    obj:writeInt64(lTableScore) -- 单线分数
    obj:writeUInt8(cbLineCount) -- 压注线数
    obj:release()
end

-- 开宝箱
function _M.sendBoxSelect(cbX, cbY)
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 4, 1024)
    obj:writeUInt8(cbX) -- 第几层
    obj:writeUInt8(cbY) -- 第几列
    obj:release()
end

-- 免费摇奖滚动
function _M.sendBonusScroll()
    local obj = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, 2, 1024)
    obj:release()
end

return _M

