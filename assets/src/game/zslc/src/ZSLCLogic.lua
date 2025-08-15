local ZSLCLogic = class("ZSLCLogic")

function ZSLCLogic:ctor(scene)
    self.scene = scene
    -- 卡片类型

    self.tSlotsMap = {
        [0] = "diamondtrain_png/icon_zslc1.png", -- 0 樱桃
        [1] = "diamondtrain_png/icon_zslc2.png", -- 1 柠檬
        [2] = "diamondtrain_png/icon_zslc3.png", -- 2 兰布林
        [3] = "diamondtrain_png/icon_zslc4.png", -- 3 铃铛
        [4] = "diamondtrain_png/icon_zslc5.png", -- 4 金币
        [5] = "diamondtrain_png/icon_zslc6.png", -- 5 钻石
        [6] = "diamondtrain_png/icon_zslc7.png", -- 6 皇冠

        -- jp+
        [7] = "diamondtrain_png/icon_zslc1.png", -- 0 jp樱桃
        [8] = "diamondtrain_png/icon_zslc2.png", -- 1 jp柠檬
        [9] = "diamondtrain_png/icon_zslc3.png", -- 2 jp兰布林
        [10] = "diamondtrain_png/icon_zslc4.png", -- 3 jp铃铛
        [11] = "diamondtrain_png/icon_zslc5.png", -- 4 jp金币
        [12] = "diamondtrain_png/icon_zslc6.png", -- 5 jp钻石
        [13] = "diamondtrain_png/icon_zslc7.png", -- 6 jp皇冠

        [14] = "diamondtrain_png/icon_zslc8.png", -- 6 joker

        [21] = "diamondtrain_png/icon_zslc_huoche.png", -- 火车
        [22] = "diamondtrain_png/icon_zslc_jz.png", -- 金币宝箱
        [23] = "diamondtrain_png/icon_zslc_yanhua.png", -- 烟花
        [24] = "diamondtrain_png/icon_zslc_tanke.png" -- 坦克
    }

    self.tCardTimes = {
        [0] = {2, 4, 10, 20}, -- 樱桃
        [1] = {5, 10, 15, 30}, -- 柠檬
        [2] = {7, 14, 20, 40}, -- 兰布林
        [3] = {12, 24, 30, 60}, -- 铃铛
        [4] = {25, 50, 50, 100}, -- 金币
        [5] = {50, 100, 150, 300}, -- 钻石
        [6] = {100, 200, 300, 600}, -- 皇冠
        [7] = {2, 4, 10, 20}, -- jp樱桃
        [8] = {5, 10, 15, 30}, -- jp柠檬
        [9] = {7, 14, 20, 40}, -- jp兰布林
        [10] = {12, 24, 30, 60}, -- jp铃铛
        [11] = {25, 50, 50, 100}, -- jp金币
        [12] = {50, 100, 150, 300}, -- jp钻石
        [13] = {100, 200, 300, 600} -- jp皇冠
    }

    self.railroad = {21, 0, 4, 2, 1, 0, 3, 6, 2, 0, 1, 4, 3, 0, 23, 1, 2, 5, 0, 1, 4, 24, 3, 0, 1, 5, 2, 1}

    self.nPlayerGold = 0

    self.nCellScore = 0 -- 单位分数
    self.lJetCellScore = 0 -- 单线下注分数
    self.wMultiCell = {25, 50, 75, 100, 125}
    self.nBetTimes = 1 -- 当前押注  每注4单位， 最多125注，每押一次下5注

    self.bIsAutoBet = false
    self.nSpeed = 1
    self.nActionSpeed = 1
end

function ZSLCLogic:getMarioWinPoint(marioIdx, timesIdx)
    local card = self.railroad[marioIdx]
    if card then
        return self:getWinPoint(card, timesIdx)
    else
        print("tarzan getMarioWinPoint error marioIdx, timesIdx:", marioIdx, timesIdx)
        return 0
    end
end

function ZSLCLogic:setCardTimes(times)
    self.tCardTimes = times
end

function ZSLCLogic:getWinPoint(card, timesIdx)
    local times = 0

    if self.tCardTimes[card] and self.tCardTimes[card][timesIdx] then
        times = self.tCardTimes[card][timesIdx] * self.analyze.nBetSum -- self.nCellScore * self:getBetTimes()
    else
        print("tarzan getWinPoint error card, timesIdx:", card, timesIdx)
        dump(self.tCardTimes)
    end

    return times
end

-- 服务器索引转为本地索引
function ZSLCLogic:convertIdx(idx)
    if idx >= 0 and idx < 25 then
        return idx + 4
    elseif idx >= 25 and idx < 28 then
        return idx - 24
    end

    return nil
end

function ZSLCLogic:addBetTimes(times)
    self.nBetTimes = self.nBetTimes + times
    if self.nBetTimes > 125 then
        self.nBetTimes = 125
    end

    self.scene:updateBetTimes()
end

function ZSLCLogic:setBetTimes(times)
    self.nBetTimes = times
    self.scene:updateBetTimes()
end

function ZSLCLogic:getBetTimes()
    return self.nBetTimes
end

function ZSLCLogic:getRailroad()
    return self.railroad
end

function ZSLCLogic:changeSpeed()
    self.nSpeed = self.nSpeed + 1
    if self.nSpeed > 5 then
        self.nSpeed = 1
    end
end

function ZSLCLogic:updateActionSpeed()
    self.nActionSpeed = (self.nSpeed - 1) * 0.3 + 1
end

function ZSLCLogic:getSpeed()
    return self.nSpeed
end

function ZSLCLogic:getActionSpeed()
    return self.nActionSpeed
end

function ZSLCLogic:setIsAutoBet(isAuto)
    self.bIsAutoBet = isAuto
    self.scene:updateAutoBetBtn()
end

function ZSLCLogic:isAutoBet()
    return self.bIsAutoBet
end

function ZSLCLogic:createTest()
    local result = {
        slots = {math.random(0, 14), math.random(0, 14), math.random(0, 14)}, -- 拉霸中三个数据

        marioIdx = math.random(1, 28), -- 火车头停止位置
        winPoint = math.random(0, 88888), -- 赢得分数
        curPoint = math.random(0, 88888), -- 当前分数
        betTimes = math.random(5, 125), -- 下注倍数
        lWinGold = math.random(0, 8888), -- 中得彩金
        lGoldPool = math.random(0, 8888), -- 剩余彩金
        nBetSum = math.random(100, 500), -- 押注金额
        jackpot = {} -- 特殊中奖
    }

    ----[[
    for i = 1, math.random(0, 2) do
        result.jackpot[i] = {
            marioType = 0,
            nCompleteState = 0,
            tMarioIdxs = {},
            record = {} -- {{timestamp = 0, agentIdx = 0}}
        }

        local jackpot_type = math.random(1, 3)
        if jackpot_type == 1 then
            local temp = math.random(1, 28)
            result.jackpot[i].tMarioIdxs = {temp - 3, temp - 2, temp - 1, temp}
            result.jackpot[i].marioType = 1 -- 火车
        elseif jackpot_type == 2 then -- 烟花
            for ii = 1, math.random(5, 6) do
                table.insert(result.jackpot[i].tMarioIdxs, math.random(1, 28))
            end
            result.jackpot[i].marioType = 15
        elseif jackpot_type == 3 then -- 坦克
            for ii = 1, math.random(3, 8) do
                table.insert(result.jackpot[i].tMarioIdxs, math.random(1, 28))
            end
            result.jackpot[i].marioType = 22
        end
    end
    -- ]]

    return result
end

function ZSLCLogic:getMarioType(list)
    for k, v in ipairs(list) do
        if v == 1 then -- 火车
            return 1
        elseif v == 8 then -- 金币宝箱
            return 8
        elseif v == 15 then -- 烟花
            return 15
        elseif v == 22 then -- 坦克
            return 22
        end
    end

    return 0
end

function ZSLCLogic:setBetResult(result)
    local tCardList = {{result.slots[1]}, {result.slots[2]}, {result.slots[3]}}

    local temp
    for i = 1, 3 do
        for ii = 1, (i * 4 + 6) do
            temp = math.random(0, 4)
            table.insert(tCardList[i], temp)
        end
    end
    result.tCardList = tCardList
    result.tCardBak = clone(tCardList)

    self.analyze = result
end

function ZSLCLogic:getSlotsIcon(idx)
    local icon = self.tSlotsMap[idx]
    return icon
end

function ZSLCLogic:getAnalyze()
    return self.analyze
end

function ZSLCLogic:setPlayerGold(gold)
    self.nPlayerGold = gold
    self.scene:updatePlayerGold()
end

function ZSLCLogic:getPlayerGold()
    return self.nPlayerGold
end

function ZSLCLogic:setPoolCount(count)
    self.lGoldPool = count
    self.scene:updateBonus()

    game.sendEvent("EventUpdateGoldPool")
end

function ZSLCLogic:getPoolCount()
    return self.lGoldPool
end

function ZSLCLogic:setMultCell(tbl)
    self.wMultiCell = tbl
end

function ZSLCLogic:setCellScore(score)
    self.nCellScore = score
    self.scene:updateBetTimes()
end

function ZSLCLogic:getCellScore()
    return self.nCellScore
end

function ZSLCLogic:setJetCellScore(score)
    self.lJetCellScore = score
end

function ZSLCLogic:setGameRoomName(name)
    self.szGameRoomName = name
end

function ZSLCLogic:getGameRoomName()
    return self.szGameRoomName
end

return ZSLCLogic
