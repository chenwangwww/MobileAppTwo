local MJHLLogic = class("MJHLLogic")

function MJHLLogic:ctor(scene)
    self.KindID = 1012
    self.scene = scene
    self.bIsTest = GameDefine.bIsLocalTest

    -- 卡片类型  0 - 100倍发财 1 - 80倍红中, 2 - 60倍白板, 3 -40倍八万 , 4 - 20倍五筒，5 - 20倍五条，6 - 10倍二筒，7 - 10倍二条，8 - WILD百搭，9-胡（免费游戏）
    self.tCardAudio = {
        [0] = "game/mjhl/res/audio/facai.mp3",
        [1] = "game/mjhl/res/audio/hongzhong.mp3",
        [2] = "game/mjhl/res/audio/baiban.mp3",
        [3] = "game/mjhl/res/audio/bawan.mp3",
        [4] = "game/mjhl/res/audio/wutong.mp3",
        [5] = "game/mjhl/res/audio/wutiao.mp3",
        [6] = "game/mjhl/res/audio/ertong.mp3",
        [7] = "game/mjhl/res/audio/ertiao.mp3"
        -- [8] = '',
        -- [9] = 'game/mjhl/res/audio/hu.mp3'
    }
    self.tIconMap = {
        [0] = "mjhl_csi/icon_white_0.png",
        [1] = "mjhl_csi/icon_white_1.png",
        [2] = "mjhl_csi/icon_white_2.png",
        [3] = "mjhl_csi/icon_white_3.png",
        [4] = "mjhl_csi/icon_white_4.png",
        [5] = "mjhl_csi/icon_white_5.png",
        [6] = "mjhl_csi/icon_white_6.png",
        [7] = "mjhl_csi/icon_white_7.png",
        [8] = "mjhl_csi/icon_white_8.png",
        [9] = "mjhl_csi/icon_white_9.png"
    }

    self.tGoldenIcon = {
        [0] = "mjhl_csi/icon_golden_0.png",
        [1] = "mjhl_csi/icon_golden_1.png",
        [2] = "mjhl_csi/icon_golden_2.png",
        [3] = "mjhl_csi/icon_golden_3.png",
        [4] = "mjhl_csi/icon_golden_4.png",
        [5] = "mjhl_csi/icon_golden_5.png",
        [6] = "mjhl_csi/icon_golden_6.png",
        [7] = "mjhl_csi/icon_golden_7.png"
    }

    self.tMultipleMap = {
        [0] = {0, 0, 15, 60, 100},
        [1] = {0, 0, 10, 40, 80},
        [2] = {0, 0, 8, 20, 60},
        [3] = {0, 0, 6, 15, 40},
        [4] = {0, 0, 4, 10, 20},
        [5] = {0, 0, 4, 10, 20},
        [6] = {0, 0, 2, 5, 10},
        [7] = {0, 0, 2, 5, 10}
    }

    self.player_name = globalUserInfo.szNickName -- 玩家名字
    self.lUserScore = 0 -- 当前分数
    self.lCellScore = 1 -- 单位分数

    self.nCurMultiCellIdx = 1
    self.wMultiCell = {20, 40, 100, 200, 1000} -- 底注选择
    self.cbBonusLineCount = 20 -- 下注线数
    self.lBonusCellScore = 10 -- 单线下注分数
    self.nBetGold = 200 -- 下注金额

    self.lWinScore = 0 -- 输赢分数 （包含中得彩金的数值）
    self.bFreeGame = 0 -- 本次是否免费摇奖
    self.lFreeSumGold = 0 -- 免费摇奖总盈利
    self.wFreeCount = 0 -- 中得免费摇奖总次数
    self.szGameRoomName = "" -- 房间名称

    self.bIsAutoBet = false
    self.nSpeed = 1
    self.nActionSpeed = 50

    self.tCardList = {{}, {}, {}, {}, {}}
end

function MJHLLogic:playCardAudio(cardId)
    local res = self.tCardAudio[cardId]
    if res then
        MusicManager.playEffect(res)
    end
end

function MJHLLogic:createTestData()
    local params = {}

    -- 卡片类型  0 - 100倍发财 1 - 80倍红中, 2 - 60倍白板, 3 -40倍八万 , 4 - 20倍五筒，5 - 20倍五条，6 - 10倍二筒，7 - 10倍二条，8 - WILD百搭，9-胡（免费游戏）
    params.cbCardType = {}
    for a = 1, 20 do
        params.cbCardType[a] = {}
        for b = 1, 5 do
            params.cbCardType[a][b] = math.random(0, 9) -- math.random(0, 9)
        end
    end

    -- params.cbCardType = {
    --     {0, 0, 0, 0, 1},
    --     {9, 9, 9, 9, 9},
    --     {9, 9, 9, 9, 9},
    --     {9, 9, 9, 9, 9},
    --     {0, 9, 9, 9, 9}
    -- }

    params.cbMaskCardType = {}
    -- 第二三四列，是否显示为金色
    for a = 1, 20 do
        params.cbMaskCardType[a] = {}
        for b = 1, 5 do
            params.cbMaskCardType[a][b] = math.random(0, 1)
        end
    end

    params.lUserScore = math.random(888, 99999) -- 当前分数（未加上本次所赢得的分数值）
    params.lWinScore = math.random(-888, 99999) -- 输赢分数 （包含中得彩金的数值）
    params.wFreeCount = math.random(0, 12) -- 本次中得免费摇奖次数
    params.wSumFreeCount = math.random(0, 12) -- 中得免费摇奖总次数
    params.bFreeGame = math.random(0, 1) -- 本次是否免费摇奖
    params.lFreeSumGold = math.random(0, 9999) -- 免费摇奖获取的总金额

    return params
end

function MJHLLogic:setBetResult(params)
    self:setPlayerGold(params.lUserScore) -- 当前分数（未加上本次所赢得的分数值）
    self:setSumFreeCount(params.wSumFreeCount - params.wFreeCount)
    self:setFreeSumGold(params.lFreeSumGold) -- 免费摇奖获取的总金额
    self.lWinScore = params.lWinScore -- 输赢分数 （包含中得彩金的数值）
    self.bFreeGame = params.bFreeGame -- 本次是否免费摇奖

    self.result = params

    self.tCardList = {{}, {}, {}, {}, {}}
    for i = 20, 1, -1 do
        if params.cbCardType[i] then
            local pTbl1, pTbl2 = {}, {}
            for ii = 1, 5 do
                local cid = params.cbCardType[i][ii]
                local msk = params.cbMaskCardType[i][ii]
                table.insert(pTbl1, cid)
                table.insert(pTbl2, msk)
                if msk == 1 and cid > 7 then
                    msk = 0
                end
                local tbl = {cid, msk}
                table.insert(self.tCardList[ii], tbl)
            end
            -- print("mjhl result ", i, " --- ", table.concat(pTbl1, "   "), "   golden:   ", table.concat(pTbl2, "   "))
        end
    end
end

function MJHLLogic:changeSpeed()
    self.nSpeed = self.nSpeed + 1
    if self.nSpeed > 5 then
        self.nSpeed = 1
    end
end

function MJHLLogic:updateActionSpeed()
    self.nActionSpeed = self.nSpeed * 10 + 20
end

function MJHLLogic:getSpeed()
    return self.nSpeed
end

function MJHLLogic:getActionSpeed()
    return self.nActionSpeed
end

function MJHLLogic:setIsAutoBet(isAuto)
    self.bIsAutoBet = isAuto
    self.scene.bottomPanel:updateAutoBetBtn()
end

function MJHLLogic:isAutoBet()
    return self.bIsAutoBet
end

function MJHLLogic:getItemIcon(idx, bIsGolden)
    -- if idx < 0 or idx > 9 or (bIsGolden and idx > 7) then
    --     print('get item icon error =============>', idx, bIsGolden)
    -- end

    local icon = ""
    if bIsGolden == 1 and idx <= 7 then
        icon = self.tGoldenIcon[idx]
    else
        icon = self.tIconMap[idx]
    end
    return icon
end

function MJHLLogic:setPlayerName(name)
    self.player_name = name
end

function MJHLLogic:getPlayerName()
    return self.player_name
end

function MJHLLogic:setPlayerGold(gold)
    self.lUserScore = gold
    self.scene.bottomPanel:updateGold()
end

function MJHLLogic:addPlayerGold(gold)
    self.lUserScore = self.lUserScore + gold
    self.scene.bottomPanel:updateGold()
end

function MJHLLogic:getPlayerGold()
    return self.lUserScore
end

function MJHLLogic:changeBetGoldByIdx(idx)
    if self.wFreeCount <= 0 then
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
    self.scene.bottomPanel:updateBetGold(true)
end

function MJHLLogic:setBouncsInfo(count, score)
    self.cbBonusLineCount = count -- 下注线数
    self.lBonusCellScore = score -- 单线下注分数
    if self.wFreeCount > 0 or self.lBonusCellScore > 0 then
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
        self.scene.bottomPanel:updateBetGold(false)
    end
end

-- 底注选择
function MJHLLogic:setMultCell(tbl)
    self.wMultiCell = tbl
end

function MJHLLogic:setMaxBetGold()
    if self.wFreeCount <= 0 then
        self.nCurMultiCellIdx = #self.wMultiCell

        self.lBonusCellScore = self.wMultiCell[self.nCurMultiCellIdx] * self.lCellScore
        self.nBetGold = self.lBonusCellScore * self.cbBonusLineCount
    end
    self.scene.bottomPanel:updateBetGold(true)
end

function MJHLLogic:getBetGold()
    return self.nBetGold
end

function MJHLLogic:setSumFreeCount(count)
    self.wFreeCount = count
end

function MJHLLogic:setFreeSumGold(gold)
    self.lFreeSumGold = gold
end

function MJHLLogic:getFreeSumGold()
    return self.lFreeSumGold
end

function MJHLLogic:addFreeCount(count)
    self.wFreeCount = self.wFreeCount + count
end

-- 单位分数
function MJHLLogic:setCellScore(score)
    self.lCellScore = score
end

function MJHLLogic:getSumFreeCount()
    return self.wFreeCount
end

function MJHLLogic:setGameRoomName(name)
    self.szGameRoomName = name
end

function MJHLLogic:getGameRoomName()
    return self.szGameRoomName
end

return MJHLLogic
