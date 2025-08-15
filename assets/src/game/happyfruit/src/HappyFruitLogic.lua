local HappyFruitLogic = class("HappyFruitLogic")

function HappyFruitLogic:ctor(scene)
    self.KindID = 205
    self.scene = scene
    -- 卡片类型 0-777,1-bar,2-bonus,3-樱桃，4-铃铛，5-兰布林，6-葡萄，7-柠檬，8-西瓜，9-香焦，10-WILD

    self.tFruitMap = {
        [0] = "fruit_machine_SG_7.png",
        [1] = "fruit_machine_SG_caomei.png",
        [2] = "fruit_machine_SG_scatter.png",
        [3] = "fruit_machine_SG_yingtao.png",
        [4] = "fruit_machine_SG_sz.png",
        [5] = "fruit_machine_SG_juzi.png",
        [6] = "fruit_machine_SG_putao.png",
        [7] = "fruit_machine_SG_ningmeng.png",
        [8] = "fruit_machine_SG_xigua.png",
        [9] = "fruit_machine_SG_xiangjiao.png",
        [10] = "fruit_machine_SG_wild.png"
    }

    -- 九线序列
    self.m_cbCardLine = {{6, 7, 8, 9, 10}, {1, 2, 3, 4, 5}, {11, 12, 13, 14, 15}, {1, 7, 13, 9, 5}, {11, 7, 3, 9, 15}, {1, 2, 8, 14, 15}, {11, 12, 8, 4, 5}, {6, 12, 8, 4, 10}, {6, 2, 8, 14, 10}}

    -- 九线倍率
    self.m_dwCardLineTimes = {
        [0] = {1750, 200, 100, 0},
        [1] = {1250, 175, 75, 0},
        [2] = {400, 50, 25, 0},
        [3] = {800, 100, 45, 0},
        [4] = {650, 80, 35, 0},
        [5] = {550, 70, 30, 0},
        [6] = {400, 50, 25, 0},
        [7] = {250, 40, 15, 0},
        [8] = {85, 10, 3, 0},
        [9] = {75, 10, 3, 1}
    }

    self.cbBonusLineCount = 1 -- 下注线数
    self.player_name = globalUserInfo.szNickName -- 玩家名字
    self.lUserScore = 0 -- 当前分数
    self.lGoldPool = 0 -- 彩金池大小

    self.nCurMultiCellIdx = 1
    self.wMultiCell = {1, 5, 10, 50, 100, 500, 1000} -- 底注选择
    self.lCellScore = 500 -- 单线分数
    self.line_bet = 500 -- 单线投入

    self.wBonusCount = 0 -- 免费摇奖次数
    self.cbBonusCount = 0 -- 中得免费摇奖次数
    self.wSumBonusCount = 0 -- 中得免费摇奖总次数

    self.szGameRoomName = "" -- 房间名称
    self.lWinScore = 0 -- 输赢分数 （包含中得彩金的数值）
    self.lWinGold = 0 -- 中得彩金

    self.bIsAutoBet = false
    self.nSpeed = 1
    self.nActionSpeed = 1
    self:initWinScale()
end

function HappyFruitLogic:changeSpeed()
    self.nSpeed = self.nSpeed + 1
    if self.nSpeed > 5 then
        self.nSpeed = 1
    end
end

function HappyFruitLogic:updateActionSpeed()
    self.nActionSpeed = self.nSpeed
end

function HappyFruitLogic:getSpeed()
    return self.nSpeed
end

function HappyFruitLogic:getActionSpeed()
    return self.nActionSpeed
end

function HappyFruitLogic:initWinScale()
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local framesize = view:getFrameSize()
    -- local Originsize = view:getVisibleOrigin()
    -- local Visiblesize = view:getVisibleSize()
    self.winscale = math.min(framesize.width / display.width, framesize.height / display.height)
end

function HappyFruitLogic:getWinScale()
    return 1
    -- return self.winscale
end

function HappyFruitLogic:setIsAutoBet(isAuto)
    self.bIsAutoBet = isAuto
    self.scene.buttonView:updateAutoBetBtn()
end

function HappyFruitLogic:isAutoBet()
    return self.bIsAutoBet
end

function HappyFruitLogic:calcResult(list)
    local cbCardIndex = list
    local wMaxBonus = 0
    local w777 = 0

    local lTimes = 0
    local wSameCount = 0
    local wWildCount = 0
    local cbIndex = 0
    local cbCard = 0xff
    local cbLastCard = 0xff

    local winList = {}

    for lineIdx = 1, self.cbBonusLineCount do
        cbCard = 0xff
        wSameCount = 0
        cbIndex = 0xff
        cbLastCard = 0xff
        wWildCount = 0

        for m, n in ipairs(self.m_cbCardLine[lineIdx]) do
            cbIndex = n
            if m == 1 then
                cbCard = cbCardIndex[cbIndex]
            end

            if cbCardIndex[cbIndex] == 10 and cbCard ~= 0 and cbCard ~= 2 then -- wild不能当做bonus & 777
                wSameCount = wSameCount + 1
                if cbCard == 10 then
                    wWildCount = wWildCount + 1
                end
                cbLastCard = 10
            else
                if cbCard == 10 then
                    cbCard = cbCardIndex[cbIndex]
                end

                if (cbCardIndex[cbIndex] == cbLastCard or cbLastCard == 0xff) or
                    (cbLastCard == 10 and cbCardIndex[cbIndex] ~= 0 and cbCardIndex[cbIndex] ~= 2 and (cbCard == 10 or cbCard == cbCardIndex[cbIndex])) then
                    wSameCount = wSameCount + 1
                    cbLastCard = cbCardIndex[cbIndex]
                else
                    break
                end
            end
        end

        if cbCard == 10 then
            cbCard = 0 -- wild当做bar
        end

        local ltmpTime = 0
        if wSameCount >= 2 then
            ltmpTime = self.m_dwCardLineTimes[cbCard][6 - wSameCount]
            if wWildCount >= 2 then
                if self.m_dwCardLineTimes[0][6 - wWildCount] > ltmpTime then -- 全百搭的4连有没有大于百搭变的五连。。。类似情况
                    ltmpTime = self.m_dwCardLineTimes[0][6 - wWildCount]
                end
            end

            if cbCard == 0 and wSameCount >= 3 and self.line_bet >= 50000 then -- 777
                if wSameCount > w777 then
                    w777 = wSameCount
                end
            end

            if ltmpTime > 0 then
                local winPos = {}
                for bbb = 1, wSameCount do
                    winPos[bbb] = self.m_cbCardLine[lineIdx][bbb]
                end

                table.insert(winList, {
                    lineIdx = lineIdx,
                    cardId = cbCard,
                    times = ltmpTime,
                    wSameCount = wSameCount,
                    wWildCount = wWildCount,
                    winPos = winPos
                })
            end
        end
        lTimes = lTimes + ltmpTime
    end

    local bRet = false
    wSameCount = 0
    for i = 1, 5 do
        bRet = false
        for j = 0, 2 do
            if cbCardIndex[j * 5 + i] == 2 then -- 有无连续三列以上出现Bonus
                bRet = true
            end
        end

        if bRet then
            wSameCount = wSameCount + 1
        elseif wSameCount < 3 then
            wSameCount = 0
        end
    end
    wMaxBonus = wSameCount

    local tCardList = {{}, {}, {}, {}, {}}

    for i = 1, 15 do
        table.insert(tCardList[(i - 1) % 5 + 1], list[i] or -1)
    end
    local tCard15 = clone(tCardList)

    local temp
    for i = 1, 5 do
        for ii = 1, (i * 7 - 2) do
            temp = math.random(0, 10)
            table.insert(tCardList[i], temp)
            if ii == 1 then
                table.insert(tCard15[i], temp)
            end
        end
    end

    local ret = {
        lTimes = lTimes,
        wMaxBonus = wMaxBonus,
        w777 = w777,
        winList = winList,
        winGold = lTimes * self.line_bet,
        tCardList = tCardList,
        tCard15 = tCard15
    }
    return ret
end

function HappyFruitLogic:setBetResult(result)
    self.analyze = self:calcResult(result.cbCardType)
    self.analyze.result = result
end

function HappyFruitLogic:updateAfterResult(result)
    if result == nil then
        return
    end
    self:setPlayerGold(result.lUserScore + result.lWinScore)
    self:setPoolCount(result.lGoldPool)
    self:setBonusCount(result.wSumBonusCount)
end

function HappyFruitLogic:getFruitIcon(idx)
    if idx < 0 or idx > 10 then
        print("getFruitIcon error ", idx)
    end
    local icon = self.tFruitMap[idx]
    return icon
end

function HappyFruitLogic:getAnalyze()
    return self.analyze
end

function HappyFruitLogic:setPlayerName(name)
    self.player_name = name
    self.scene.textView:updatePlayerName()
end

function HappyFruitLogic:getPlayerName()
    return self.player_name
end

function HappyFruitLogic:setPlayerGold(gold)
    self.lUserScore = gold
    self.scene.textView:updatePlayerGold()
end

function HappyFruitLogic:getPlayerGold()
    return self.lUserScore
end

function HappyFruitLogic:setPoolCount(count)
    self.lGoldPool = count
    self.scene.textView:updatePoolCount()

    game.sendEvent("EventUpdateGoldPool")
end

function HappyFruitLogic:getPoolCount()
    return self.lGoldPool
end

function HappyFruitLogic:setLineCount(count, skip)
    self.cbBonusLineCount = count
    if self.cbBonusLineCount > 9 then
        self.cbBonusLineCount = 1
    end
    if self.cbBonusLineCount < 1 then
        self.cbBonusLineCount = 9
    end

    self.scene.textView:updateLineCount(skip)
end

function HappyFruitLogic:addLineCount(num)
    self:setLineCount(self.cbBonusLineCount + num)
end

function HappyFruitLogic:getLineCount()
    return self.cbBonusLineCount
end

function HappyFruitLogic:setLineBetByIdx(idx)
    self.nCurMultiCellIdx = idx

    if self.nCurMultiCellIdx < 1 then
        self.nCurMultiCellIdx = #self.wMultiCell
    end
    if self.nCurMultiCellIdx > #self.wMultiCell then
        self.nCurMultiCellIdx = 1
    end

    self.line_bet = self.wMultiCell[self.nCurMultiCellIdx] * self.lCellScore
    self.scene.textView:updateSingleBet()
end

function HappyFruitLogic:setLineBetByVal(val)
    local temp = 1
    for idx, cell in ipairs(self.wMultiCell) do
        if cell * self.lCellScore == val then
            temp = idx
            break
        end
    end
    self:setLineBetByIdx(temp)
end

function HappyFruitLogic:setMultCell(tbl)
    self.wMultiCell = tbl
end

function HappyFruitLogic:setCellScore(score)
    self.lCellScore = score
end

function HappyFruitLogic:addLineBet(idx)
    self:setLineBetByIdx(self.nCurMultiCellIdx + idx)
end

function HappyFruitLogic:getLineBet()
    return self.line_bet
end

function HappyFruitLogic:setBonusCount(count)
    self.wBonusCount = count
    self.scene.buttonView:updateSpin()
end

function HappyFruitLogic:getBonusCount()
    return self.wBonusCount
end

function HappyFruitLogic:setGameRoomName(name)
    self.szGameRoomName = name
end

function HappyFruitLogic:getGameRoomName()
    return self.szGameRoomName
end

return HappyFruitLogic
