local GameCMD = require("game.jsfy.src.JSFYCMD")

local JSFYLogic = class("JSFYLogic")

function JSFYLogic:ctor()

    self.winInfo_ = {}
    self.broadcast_ = {}

    -- self.jossCount_ = 0
    self.bonusCount_ = 0
    self.scatterCnt_ = 0
    self.isBonus = 0
    self.openBoxData = nil
end

function JSFYLogic:JugeisBonus()
    return self.isBonus
end

function JSFYLogic:getBoxData()
    return self.openBoxData
end

function JSFYLogic:getOwnerScore()
    return self.ownerScore_
end

function JSFYLogic:getWinScore()
    return self.winScore_ or 0
end

function JSFYLogic:getBonusCount()
    return self.bonusCount_
end

function JSFYLogic:getScatterCount()
    return self.scatterCnt_
end

function JSFYLogic:setGoldPool(count)
    self.goldPool_ = count
end

function JSFYLogic:getGoldPool()
    return self.goldPool_
end

function JSFYLogic:getWinInfo()
    return self.winInfo_
end

--[[function JSFYLogic:getJossCount()
	return self.jossCount_
end--]]

local function extractWinLine(linePattern)
    local function isWildCanChange(pattern)
        return pattern ~= GameCMD.PATTERN.SCATTER and pattern ~= GameCMD.PATTERN.BONUS -- and pattern ~= GameCMD.PATTERN.XIANG_HUO
    end
    local function isSamePattern(patt1, patt2)
        local cmp1 = patt1 == GameCMD.PATTERN.WILD and (isWildCanChange(patt2) and patt2 or patt1) or patt1
        local cmp2 = patt2 == GameCMD.PATTERN.WILD and (isWildCanChange(patt1) and patt1 or patt2) or patt2
        return cmp1 == cmp2
    end
    local index = 1
    local pattern = nil
    local wildCnt = 0
    local sameCnt = 0
    local wildRowCnt = 0 -- wild起点连续数目
    for i, curr in ipairs(linePattern) do
        if pattern and not isSamePattern(pattern, curr) then
            break
        end
        pattern = (not pattern or pattern == GameCMD.PATTERN.WILD) and curr or pattern
        sameCnt = sameCnt + 1
        wildCnt = wildCnt + (curr == GameCMD.PATTERN.WILD and 1 or 0)
        if pattern == GameCMD.PATTERN.WILD then
            wildRowCnt = wildRowCnt + 1
        end
    end
    -- wild起头至少两个，以僵尸男代替进行比较
    if wildRowCnt >= 2 then
        local lionRatioList = GameCMD.RATIO[GameCMD.PATTERN.JIANG_SHI]
        -- 纯wild或者 僵尸男替代倍率 大于 就近替代倍率
        if not GameCMD.RATIO[pattern] or lionRatioList[wildRowCnt] > GameCMD.RATIO[pattern][sameCnt] then
            pattern = GameCMD.PATTERN.JIANG_SHI
            sameCnt = wildRowCnt
            wildCnt = wildRowCnt
        end
    end
    local ratioLst = GameCMD.RATIO[pattern]
    if not ratioLst then
        return
    end
    local ratio = ratioLst[sameCnt]
    if ratio <= 0 then
        return
    end

    local winLine = {}
    winLine.pattern = pattern
    winLine.sameCount = sameCnt
    winLine.wildCount = wildCnt
    winLine.ratio = ratio
    return winLine
end

local function parsePatterns(self, patterns, AnyCardValue)
    local function extractBonus()
        local BonusTab = {}
        for k, value in ipairs(patterns) do
            if value == GameCMD.PATTERN.BONUS then
                table.insert(BonusTab, k)
            end
        end
        return BonusTab
    end

    local winInfo = {}
    local winLines = {}
    for i = 1, GameCMD.MAX_LINE do
        local arrLineIndex = GameCMD.Lines[i]
        local linePattern = {}
        for j = 1, GameCMD.PATTERN_COL do
            if patterns[arrLineIndex[j]] == GameCMD.PATTERN.QUESTION then
                linePattern[j] = AnyCardValue
            else
                linePattern[j] = patterns[arrLineIndex[j]]
            end
        end
        local winLine = extractWinLine(linePattern)
        if winLine then
            winLine.index = i
            table.insert(winLines, winLine)
            winInfo.ratio = (winInfo.ratio or 0) + winLine.ratio
        end
    end
    winInfo.winLines = winLines
    winInfo.BonusTab = extractBonus()
    -- winInfo.winScore = winInfo.ratio * self.cellScore_ ---TODO:
    -- dump(winInfo.winLines)
    return winInfo
end

function JSFYLogic:loadSceneData(args)
    self.ownerScore_ = args.lUserScore
    self.bonusCount_ = args.wFreeCount
    self.isBonus = args.bBonus
    -- self.scatterCnt_ = args.wSanCaiCount
    -- self.goldPool_ = args.lGoldPool
    -- self.jossCount_ = args.wXiangHuoCount
    if self.isBonus == 1 then
        self.winInfo_ = parsePatterns(self, args.cbCardType, args.cbAnyCardValue)
    end
end

function JSFYLogic:loadCardScollData(args)
    self.ownerScore_ = args.lUserScore + args.lWinScore
    self.winScore_ = args.lWinScore

    self.winInfo_ = parsePatterns(self, args.cbCardType, args.cbAnyCardValue)
    self.winInfo_.bonusCnt = args.cbFreeCount
    -- self.winInfo_.bScatter = args.wSanCaiCount>0 and args.bSanCai < 1 and args.wSumBonusCount==0
    self.winInfo_.freeTotal = args.lSumFreeGold
    -- self.winInfo_.scatterTotal = (args.bSanCai>0 and args.wSanCaiCount==0) and args.lSumScatter or 0

    -- self.jossCount_ = args.wXiangHuoCount
    self.bonusCount_ = args.wSumFreeCount
    -- self.scatterCnt_ = args.wSanCaiCount

    self.isBonus = args.bBonus
    self.openBoxData = args
end

function JSFYLogic:loadBroadcast(broadcast)
    table.insert(self.broadcast_, broadcast)
end

function JSFYLogic:extractBroadcast()
    if not next(self.broadcast_) then
        return
    end
    local front = self.broadcast_[1]
    table.remove(self.broadcast_, 1)
    return front
end

return JSFYLogic
