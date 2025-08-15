local MLCSLogic = class("MLCSLogic")

function MLCSLogic:ctor(scene)
    self.KindID = 1010
    self.scene = scene
    self.bIsTest = GameDefine.bIsLocalTest

    -- 卡片类型  0 - 500倍图 1 - 300倍图, 2 - 150倍图, 3 -100倍图 , 4 - 80倍图，5 - 60倍图，6 - 45倍图，7 - ？，8 - 免费
    self.tIconMap = {
        [0] = "mlcspic/ml_icon_7.png",
        [1] = "mlcspic/ml_icon_6.png",
        [2] = "mlcspic/ml_icon_5.png",
        [3] = "mlcspic/ml_icon_4.png",
        [4] = "mlcspic/ml_icon_3.png",
        [5] = "mlcspic/ml_icon_2.png",
        [6] = "mlcspic/ml_icon_1.png",
        [7] = "mlcspic/ml_icon_9.png",
        [8] = "mlcspic/ml_icon_8.png"
    }

    self.player_name = globalUserInfo.szNickName -- 玩家名字
    self.lUserScore = 0 -- 当前分数
    self.lCellScore = 0 -- 单位分数

    self.nCurMultiCellIdx = 1
    self.wMultiCell = {20, 40, 100, 200, 1000} -- 底注选择
    self.cbBonusLineCount = 20 -- 下注线数
    self.lBonusCellScore = 10 -- 单线下注分数
    self.nBetGold = 200 -- 下注金额

    self.wFreeCount = 0 -- 免费摇奖次数
    self.wSumFreeCount = 0 -- 中得免费摇奖总次数
    self.lFreeSumGold = 0 -- 免费摇奖总盈利

    self.szGameRoomName = "" -- 房间名称

    self.bIsAutoBet = false
    self.nSpeed = 2
    self.nActionSpeed = 40

    self.tCardLists = {}
    self.nCurGroupIdx = 0
    self.tFactor = {1, 1.5, 2, 2.5, 3}

    -- 卡片类型  0 - 500倍图 1 - 300倍图, 2 - 150倍图, 3 -100倍图 , 4 - 80倍图，5 - 60倍图，6 - 45倍图，7 - ？，8 - 免费
    self.tMultipleMap = {
        [0] = {0, 0, 30, 100, 500},
        [1] = {0, 0, 20, 65, 300},
        [2] = {0, 0, 10, 35, 150},
        [3] = {0, 0, 8, 25, 100},
        [4] = {0, 0, 5, 20, 80},
        [5] = {0, 0, 4, 15, 60},
        [6] = {0, 0, 3, 10, 45},
        [7] = {0, 0, 30, 100, 500},
        [8] = {0, 0, 5, 10, 20}
    }

    self.win_lines = {{6, 7, 8, 9, 10}, {1, 2, 3, 4, 5}, {11, 12, 13, 14, 15}, {1, 7, 13, 9, 5}, {11, 7, 3, 9, 15}, {1, 2, 8, 4, 5}, {11, 12, 8, 14, 15}, {6, 12, 13, 14, 10}, {6, 2, 3, 4, 10},
                      {6, 2, 8, 4, 10}, {6, 12, 8, 14, 10}, {1, 7, 3, 9, 5}, {11, 7, 13, 9, 15}, {6, 7, 3, 9, 10}, {6, 7, 13, 9, 10}, {1, 7, 8, 9, 5}, {11, 7, 8, 9, 15}, {1, 7, 13, 14, 15},
                      {11, 7, 3, 4, 5}, {1, 12, 3, 14, 5}}
end

function MLCSLogic:calcRewards(list)
    local tPos = {}
    local totalBeiShu = 0
    local freeCount = 0
    local tWinLines = {}

    local maxIdx = math.min(self.nCurGroupIdx, #self.tFactor)
    local ratio = self.tFactor[maxIdx]

    for lineID, line in ipairs(self.win_lines) do
        local id = list[line[1]]
        if id ~= 8 then
            for count, posIdx in ipairs(line) do
                if id == 7 and list[posIdx] ~= id and list[posIdx] ~= 8 then
                    id = list[posIdx]
                end

                if (list[posIdx] ~= id and list[posIdx] ~= 7) then
                    if count > 3 then
                        local fixCount = count - 1
                        local fixBeishu = self.tMultipleMap[id][fixCount]

                        for iii = 1, count - 1 do
                            if list[line[iii]] ~= 7 then
                                if iii > 3 and self.tMultipleMap[7][iii - 1] > fixBeishu then
                                    id = 7
                                    fixCount = iii - 1
                                    fixBeishu = self.tMultipleMap[7][iii - 1]
                                end
                                break
                            end
                        end
                        totalBeiShu = totalBeiShu + fixBeishu

                        local str = "win line===>lineID:%d,    iconID:%d,    count:%d,    beishu:%d,    multipleBeishu:%.2f"
                        print(string.format(str, lineID, id, fixCount, fixBeishu, ratio * fixBeishu))
                        local winline = {
                            tPosIdx = {},
                            lineID = lineID,
                            nBeishu = fixBeishu,
                            iconId = id,
                            freeNum = 0
                        }
                        for pp = 1, fixCount do
                            table.insert(winline.tPosIdx, line[pp])
                            tPos[line[pp]] = true
                        end
                        table.insert(tWinLines, winline)
                    end
                    break
                elseif count == 5 then
                    local tempBeishu = self.tMultipleMap[id][count]
                    totalBeiShu = totalBeiShu + tempBeishu
                    local str = "win line===>lineID:%d,    iconID:%d,    count:%d,    beishu:%d,    multipleBeishu:%.2f"
                    print(string.format(str, lineID, id, count, tempBeishu, ratio * tempBeishu))

                    local winline = {
                        tPosIdx = {},
                        lineID = lineID,
                        nBeishu = tempBeishu,
                        iconId = id,
                        freeNum = 0
                    }
                    for pp = 1, count do
                        table.insert(winline.tPosIdx, line[pp])
                        tPos[line[pp]] = true
                    end
                    table.insert(tWinLines, winline)
                end
            end
        end
    end

    for lineID, line in ipairs(self.win_lines) do
        for count, posIdx in ipairs(line) do
            if list[posIdx] ~= 8 then
                if count > 3 then
                    local freeNum = self.tMultipleMap[8][count - 1]
                    freeCount = freeCount + freeNum

                    local str = "win free ===>lineID:%d,    count:%d,    freeNum:%d,    multipleFreeNum:%.2f"
                    print(string.format(str, lineID, count - 1, freeNum, ratio * freeNum))
                    local winline = {
                        tPosIdx = {},
                        lineID = lineID,
                        nBeishu = 0,
                        iconId = 8,
                        freeNum = freeNum
                    }

                    for pp = 1, count - 1 do
                        table.insert(winline.tPosIdx, line[pp])
                        tPos[line[pp]] = true
                    end
                    table.insert(tWinLines, winline)
                end
                break
            elseif count == 5 then
                local freeNum = self.tMultipleMap[8][count]
                freeCount = freeCount + freeNum

                local str = "win free ===>lineID:%d,    count:%d,    freeNum:%d,    multipleFreeNum:%.2f"
                print(string.format(str, lineID, count, freeNum, ratio * freeNum))
                local winline = {
                    tPosIdx = {},
                    lineID = lineID,
                    nBeishu = 0,
                    iconId = 8,
                    freeNum = freeNum
                }
                for pp = 1, count do
                    table.insert(winline.tPosIdx, line[pp])
                    tPos[line[pp]] = true
                end
                table.insert(tWinLines, winline)
            end
        end
    end

    local str = "game settlement multiple:%.2f,  totalBeiShu:%d,  multipleTotalBeiShu:%.2f"
    print(string.format(str, ratio, totalBeiShu, totalBeiShu * ratio))
    local gold = ratio * self.lBonusCellScore * totalBeiShu
    freeCount = freeCount * ratio
    self.nMyWinFree = self.nMyWinFree + freeCount
    self.nMyWinGold = self.nMyWinGold + gold
    local ret = {
        gold = gold,
        beishu = totalBeiShu,
        freeCount = freeCount,
        tPos = tPos,
        tWinLines = tWinLines
    }
    return ret
end

function MLCSLogic:createTestData()
    local params = {}
    params.cbCardType = {{}, {}, {}, {}, {}}
    -- 卡片类型  0 - 500倍图 1 - 300倍图, 2 - 150倍图, 3 -100倍图 , 4 - 80倍图，5 - 60倍图，6 - 45倍图，7 - ？，8 - 免费
    for k = 1, 20 do
        for i = 1, 5 do
            params.cbCardType[i][k] = math.random(0, 8)
        end
    end

    params.lUserScore = 0 -- 当前分数（未加上本次所赢得的分数值）
    params.lWinScore = 0 -- 输赢分数 （包含中得彩金的数值）
    params.wFreeCount = 0 -- 本次中得免费摇奖次数
    params.wSumFreeCount = 0 -- 中得免费摇奖总次数
    params.bFreeGame = 1 -- math.random(0, 1) --本次是否免费摇奖
    params.lSumFreeGold = 0 -- 免费摇奖获取的总金额

    return params
end

function MLCSLogic:setBetResult(result)
    self:setPlayerGold(result.lUserScore)
    self:setSumFreeCount(result.wSumFreeCount - result.wFreeCount)

    self.result = result
    self.nMyWinGold = 0
    self.nMyWinFree = 0
    self.tCardLists = clone(result.cbCardType)
    self.nCurGroupIdx = 0
end

function MLCSLogic:nextGroup(tPos)
    local idx
    if tPos then
        local temp = {{}, {}, {}, {}, {}}
        local a, b
        for posIdx, isok in pairs(tPos) do
            if isok then
                a = (posIdx - 1) % 5 + 1
                b = 3 - ((posIdx - a) / 5)
                table.insert(temp[a], b)
            end
        end

        for aa, lst in ipairs(temp) do
            table.sort(lst)
            for ii = #lst, 1, -1 do
                local del = table.remove(self.tCardLists[aa], lst[ii])
                -- idx = (3 - lst[ii]) * 5 + aa
                -- print("del card---->a, b, idx, v:", aa, lst[ii], idx, del)
            end
        end
    end

    self.nCurGroupIdx = self.nCurGroupIdx + 1
    local isShortList = false
    local list = {}
    for a = 1, 5 do
        for b = 1, 3 do
            idx = (3 - b) * 5 + a
            list[idx] = self.tCardLists[a][b]
            if list[idx] == nil then
                isShortList = true -- 列表没数据了
            end
        end
    end

    if isShortList then
        print("==================!!!!!!!!!!cbCardType list is to the end!!!!!!!!!!===============")
        return nil
    else
        self:printList(list)
        self.scene.buttonView:updateMultiplier()
        return list
    end
end

--[[
    b   a   1  2  3  4  5

    3       1, 2, 3, 4, 5
    2       6, 7, 8, 9, 10
    1       11,12,13,14,15
--]]
function MLCSLogic:printList(list)
    print("=================回合================", self.nCurGroupIdx)
    for b = 3, 1, -1 do
        local str = "行" .. b .. ":   "
        for a = 1, 5 do
            local idx = (3 - b) * 5 + a
            str = str .. "    " .. list[idx]
        end
        print(str)
    end
end

function MLCSLogic:changeSpeed()
    self.nSpeed = self.nSpeed + 1
    if self.nSpeed > 5 then
        self.nSpeed = 1
    end
end

function MLCSLogic:updateActionSpeed()
    self.nActionSpeed = self.nSpeed * 20 + 20
end

function MLCSLogic:getSpeed()
    return self.nSpeed
end

function MLCSLogic:getActionSpeed()
    return self.nActionSpeed
end

function MLCSLogic:setIsAutoBet(isAuto)
    self.bIsAutoBet = isAuto
    self.scene.buttonView:updateAutoBetBtn()
end

function MLCSLogic:isAutoBet()
    return self.bIsAutoBet
end

function MLCSLogic:getItemIcon(idx)
    if idx < 0 or idx > 8 then
        print("get item icon error =============>", idx)
    end
    local icon = self.tIconMap[idx]
    return icon
end

function MLCSLogic:setPlayerName(name)
    self.player_name = name
end

function MLCSLogic:getPlayerName()
    return self.player_name
end

function MLCSLogic:setPlayerGold(gold)
    self.lUserScore = gold
    self.scene.buttonView:updateGold()
end

function MLCSLogic:addPlayerGold(gold)
    self.lUserScore = self.lUserScore + gold
    self.scene.buttonView:updateGold()
end

function MLCSLogic:getPlayerGold()
    return self.lUserScore
end

function MLCSLogic:changeBetGoldByIdx(idx)
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

function MLCSLogic:setBouncsInfo(count, score)
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

function MLCSLogic:setMultCell(tbl)
    self.wMultiCell = tbl
    self:changeBetGoldByIdx(0)
end

function MLCSLogic:setMaxBetGold()
    if self.wSumFreeCount <= 0 then
        self.nCurMultiCellIdx = #self.wMultiCell

        self.lBonusCellScore = self.wMultiCell[self.nCurMultiCellIdx] * self.lCellScore
        self.nBetGold = self.lBonusCellScore * self.cbBonusLineCount
    end
    self.scene.buttonView:updateBetGold()
end

function MLCSLogic:getBetGold()
    return self.nBetGold
end

function MLCSLogic:setSumFreeCount(count)
    self.wSumFreeCount = count
end

function MLCSLogic:addFreeCount(count)
    self.wSumFreeCount = self.wSumFreeCount + count
end

function MLCSLogic:setFreeSumGold(gold)
    self.lFreeSumGold = gold
end

function MLCSLogic:addFreeSumGold(gold)
    self.lFreeSumGold = self.lFreeSumGold + gold
end

function MLCSLogic:getFreeSumGold()
    return self.lFreeSumGold
end

function MLCSLogic:setCellScore(score)
    self.lCellScore = score
end

function MLCSLogic:getSumFreeCount()
    return self.wSumFreeCount
end

function MLCSLogic:setGameRoomName(name)
    self.szGameRoomName = name
end

function MLCSLogic:getGameRoomName()
    return self.szGameRoomName
end

return MLCSLogic
