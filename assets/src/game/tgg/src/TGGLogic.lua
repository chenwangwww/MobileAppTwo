local TGGLogic = class("TGGLogic")

function TGGLogic:ctor(scene)
    self.KindID = 1011
    self.scene = scene
    self.bIsTest = GameDefine.bIsLocalTest

    -- 卡片类型  0 - 400倍碟机 1 - 300倍耳机, 2 - 250倍鸡尾酒杯, 3 -200倍啤酒杯 , 4 - 125倍A，5 - 125倍K，6 - 100倍Q，7 - 100倍J，8 - JUMP，9-滚轮
    self.tIconMap = {
        [0] = "tggpic/card_0.png",
        [1] = "tggpic/card_1.png",
        [2] = "tggpic/card_2.png",
        [3] = "tggpic/card_3.png",
        [4] = "tggpic/card_4.png",
        [5] = "tggpic/card_5.png",
        [6] = "tggpic/card_6.png",
        [7] = "tggpic/card_7.png",
        [8] = "tggpic/card_8.png",
        [9] = "tggpic/card_9.png"
    }

    self.tMultipleMap = {
        [0] = {0, 0, 75, 150, 400},
        [1] = {0, 0, 50, 150, 300},
        [2] = {0, 0, 40, 100, 250},
        [3] = {0, 0, 30, 100, 200},
        [4] = {0, 0, 15, 30, 125},
        [5] = {0, 0, 15, 30, 125},
        [6] = {0, 0, 10, 20, 100},
        [7] = {0, 0, 10, 20, 100}
    }

    self.player_name = globalUserInfo.szNickName -- 玩家名字
    self.lUserScore = 0 -- 当前分数
    self.lCellScore = 0 -- 单位分数

    self.nCurMultiCellIdx = 1
    self.wMultiCell = {20, 40, 100, 200, 1000} -- 底注选择
    self.cbBonusLineCount = 20 -- 下注线数
    self.lBonusCellScore = 10 -- 单线下注分数
    self.nBetGold = 200 -- 下注金额

    self.wFreeCount = 0 -- 本次中得免费摇奖次数
    self.wSumFreeCount = 0 -- 中得免费摇奖总次数
    self.wSumBS = 0 -- 当前已累加的免费摇奖奖励倍数
    self.cbBS = 0 -- 每次免费摇奖所加倍数：5滚轮+1倍，6滚轮+2倍，7滚轮+3倍

    self.szGameRoomName = "" -- 房间名称

    self.bIsAutoBet = false
    self.nSpeed = 1
    self.nActionSpeed = 50

    self.tCardList = {{}, {}, {}, {}, {}}
end

function TGGLogic:setFreeBS(wSumBS, cbBS)
    self.wSumBS = wSumBS -- 当前已累加的免费摇奖奖励倍数
    self.cbBS = cbBS -- 每次免费摇奖所加倍数：5滚轮+1倍，6滚轮+2倍，7滚轮+3倍
end

function TGGLogic:createTestData()
    local params = {}
    params.cbCardType = {}
    local nSumCards = 0
    for i = 1, 15 do
        params.cbCardType[i] = math.random(0, 9)
        nSumCards = nSumCards + params.cbCardType[i]
    end

    params.cbMaskCard = {} -- 中奖图案掩码（具体位置图案是否中奖）
    for i = 1, 15 do
        params.cbMaskCard[i] = math.random(0, 1) -- 1为中奖图案，0为未中奖图
    end

    -- 各图案中奖情况:三连四连五连线各中几个,  wCount[x][y]:  x为图案，y值(0为5连，1为4连，2为3连)
    params.wCount = {}
    for a = 1, 8 do
        params.wCount[a] = {}
        for b = 1, 3 do
            params.wCount[a][b] = math.random(0, 2)
        end
    end

    params.lUserScore = 0 -- 当前分数（未加上本次所赢得的分数值）
    params.lWinScore = 0 -- 输赢分数 （包含中得彩金的数值）
    params.wFreeCount = 0 -- 本次中得免费摇奖次数
    params.wSumFreeCount = 0 -- 中得免费摇奖总次数
    params.bFreeGame = 0 -- math.random(0, 1) --本次是否免费摇奖
    params.wSumBS = 0 -- 当前已累加的免费摇奖奖励倍数
    params.cbBS = 0 -- 每次免费摇奖所加倍数：5滚轮+1倍，6滚轮+2倍，7滚轮+3倍

    -- "%Y%m%d%H%M%S"
    params.roundstr = os.date("%H%M%S") .. table.concat(params.cbCardType) .. string.format("%03d", nSumCards)
    return params
end

function TGGLogic:setBetResult(params)
    self:setPlayerGold(params.lUserScore)
    self:setSumFreeCount(params.wSumFreeCount - params.wFreeCount)

    self.result = params
    self.tCardList = {{}, {}, {}, {}, {}}
    for i = 1, 15 do
        table.insert(self.tCardList[(i - 1) % 5 + 1], params.cbCardType[i])
    end

    for i = 1, 5 do
        for ii = 1, i * 3 + 3 do
            table.insert(self.tCardList[i], math.random(0, 9))
        end
    end
end

--[[
        a   1  2  3  4  5
    b
    1       1, 2, 3, 4, 5
    2       6, 7, 8, 9, 10
    3       11,12,13,14,15
    4       16,17,18,19,20
--]]
function TGGLogic:changeSpeed()
    self.nSpeed = self.nSpeed + 1
    if self.nSpeed > 5 then
        self.nSpeed = 1
    end
end

function TGGLogic:updateActionSpeed()
    self.nActionSpeed = self.nSpeed * 15 + 20
end

function TGGLogic:getSpeed()
    return self.nSpeed
end

function TGGLogic:getActionSpeed()
    return self.nActionSpeed
end

function TGGLogic:setIsAutoBet(isAuto)
    self.bIsAutoBet = isAuto
    self.scene.buttonView:updateAutoBetBtn()
end

function TGGLogic:isAutoBet()
    return self.bIsAutoBet
end

function TGGLogic:getItemIcon(idx)
    if idx < 0 or idx > 9 then
        print("get item icon error =============>", idx)
    end
    local icon = self.tIconMap[idx]
    return icon
end

function TGGLogic:setPlayerName(name)
    self.player_name = name
end

function TGGLogic:getPlayerName()
    return self.player_name
end

function TGGLogic:setPlayerGold(gold)
    self.lUserScore = gold
    self.scene.buttonView:updateGold()
end

function TGGLogic:addPlayerGold(gold)
    self.lUserScore = self.lUserScore + gold
    self.scene.buttonView:updateGold()
end

function TGGLogic:getPlayerGold()
    return self.lUserScore
end

function TGGLogic:changeBetGoldByIdx(idx)
    if self.wSumFreeCount <= 0 then
        self.nCurMultiCellIdx = self.nCurMultiCellIdx + idx

        if self.nCurMultiCellIdx < 1 then
            self.nCurMultiCellIdx = #self.wMultiCell
        end
        if self.nCurMultiCellIdx > #self.wMultiCell then
            self.nCurMultiCellIdx = 1
        end

        self.lBonusCellScore = self.wMultiCell[self.nCurMultiCellIdx] * self.lCellScore
        self.nBetGold = self.lBonusCellScore * self.cbBonusLineCount
    end
    self.scene.buttonView:updateBetGold()
end

function TGGLogic:setBouncsInfo(count, score)
    self.cbBonusLineCount = count -- 下注线数
    self.lBonusCellScore = score -- 单线下注分数
    if self.wSumFreeCount > 0 or self.lBonusCellScore > 0 then
        self.nCurMultiCellIdx = 1
        local num = math.floor(self.lBonusCellScore / self.lCellScore)
        for idx, val in ipairs(self.wMultiCell) do
            if val == num then
                self.nCurMultiCellIdx = idx
            end
        end

        if self.nCurMultiCellIdx < 1 then
            self.nCurMultiCellIdx = #self.wMultiCell
        end
        if self.nCurMultiCellIdx > #self.wMultiCell then
            self.nCurMultiCellIdx = 1
        end

        self.nBetGold = self.lBonusCellScore * self.cbBonusLineCount
        self.scene.buttonView:updateBetGold()
    end
end

function TGGLogic:setMultCell(tbl)
    self.wMultiCell = tbl
    self:changeBetGoldByIdx(0)
end

function TGGLogic:setMaxBetGold()
    if self.wSumFreeCount <= 0 then
        self.nCurMultiCellIdx = #self.wMultiCell

        self.lBonusCellScore = self.wMultiCell[self.nCurMultiCellIdx] * self.lCellScore
        self.nBetGold = self.lBonusCellScore * self.cbBonusLineCount
    end
    self.scene.buttonView:updateBetGold()
end

function TGGLogic:getBetGold()
    return self.nBetGold
end

function TGGLogic:setSumFreeCount(count)
    self.wSumFreeCount = count
end

function TGGLogic:addFreeCount(count)
    self.wSumFreeCount = self.wSumFreeCount + count
end

function TGGLogic:setCellScore(score)
    self.lCellScore = score
end

function TGGLogic:getSumFreeCount()
    return self.wSumFreeCount
end

function TGGLogic:setGameRoomName(name)
    self.szGameRoomName = name
end

function TGGLogic:getGameRoomName()
    return self.szGameRoomName
end

return TGGLogic
