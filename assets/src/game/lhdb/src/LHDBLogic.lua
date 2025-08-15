local GameCMD = require("game.lhdb.src.LHDBCMD")

local LHDBLogic = class("LHDBLogic")

function LHDBLogic:ctor()
    self.lockBox_ = 0
    self.gate_ = 0

    self.broadcast_ = {}
    self:initData()
end

local function parseGems(self, gems, len, stage)
    local function extractWord(val, div, n, modval)
        local tmp = val
        for i = 1, n do
            tmp = math.floor(tmp / div)
        end
        return tmp % modval
    end
    local pForShor = {}
    local pWord = {}
    local nIndex = 0
    local length = GameCMD.GEM_WIDE * GameCMD.GEM_HIGH
    for i = 0, len - 1 do
        local rlt = gems[i + 1]
        pWord[0] = extractWord(rlt, 8, 0, 8)
        pWord[1] = extractWord(rlt, 8, 1, 8)
        pWord[2] = extractWord(rlt, 8, 2, 8)
        pWord[3] = extractWord(rlt, 8, 3, 8)
        pWord[4] = extractWord(rlt, 8, 4, 8)

        for j = 0, 4 do
            if j + nIndex >= 0 and nIndex + j < length then
                pForShor[nIndex + j] = pWord[j]
            end
        end
        nIndex = nIndex + 5
    end
    local pResult = {}
    for index = 0, length - 1 do
        local i = index % GameCMD.GEM_WIDE + 1
        local j = math.floor(index / GameCMD.GEM_WIDE) + 1
        local nShort = pForShor[index]
        pResult[i] = pResult[i] or {}
        if nShort == 0 then
            pResult[i][j] = GameCMD.Gems.DRILL_GEM
        elseif nShort == 7 then
            pResult[i][j] = GameCMD.Gems.FAKE_GEM
        else
            if nShort < 0 then
                dump(nShort)
            end
            pResult[i][j] = nShort + 5 * stage
        end
    end
    return pResult
end

function LHDBLogic:initData()
    self.gate_ = 1 -- 当前处于第几关
    self.lockBox_ = 0 -- 当前关对应的墙壁或地板中剩余砖块数
    -- self.gems_ = parseGems(self, args.gems, args.gemLen, args.cStage)
    -- dump(self.gems_)
    self.totalBet_ = 0 -- 玩家当前本场点数
    self.score_ = 0 -- 玩家卡片中的总点数
    self.totalBall_ = 0
    self.lotteryBall_ = 0
    self.goldPool_ = 0 -- 当前总【累积奖】
end

function LHDBLogic:loadGameData(args)
    self.gate_ = args.cStage + 1
    self.lockBox_ = args.cBrickLeft
    self.gems_ = parseGems(self, args.gems, args.gemLen, args.cStage)
    -- dump(self.gems_)
    self.totalBet_ = args.llNowPoint
    self.score_ = args.llCardPoint
    self.totalBall_ = args.cbDragonCount
    self.lotteryBall_ = args.cbDragonCountOk
    self.goldPool_ = args.llCurrentTotal
end

function LHDBLogic:loadBroadcast(broadcast)
    table.insert(self.broadcast_, broadcast)
end

function LHDBLogic:extractBroadcast()
    if not next(self.broadcast_) then
        return
    end
    local front = self.broadcast_[1]
    table.remove(self.broadcast_, 1)
    return front
end

function LHDBLogic:getGems()
    return self.gems_
end

function LHDBLogic:getLockBox()
    return self.lockBox_
end

function LHDBLogic:getGate()
    return self.gate_
end

function LHDBLogic:getTotalBet()
    return self.totalBet_
end

function LHDBLogic:getScore()
    return self.score_
end

function LHDBLogic:getTotalBall()
    return self.totalBall_
end

function LHDBLogic:getLotteryBall()
    return self.lotteryBall_
end

function LHDBLogic:getGoldPool()
    return self.goldPool_
end

return LHDBLogic
