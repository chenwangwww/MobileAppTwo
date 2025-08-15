--[[
TBNNLogic.lua

]] local GameCMD = require("game.tbnn.src.TBNNCMD")

local TBNNLogic = class("TBNNLogic")

function TBNNLogic:ctor()
    self.tableScore_ = 1
    self.userCards_ = {}
    self.cardTypes_ = {}
end

-- color,cardval,logicVal
local function getCardColorAndValue(card)
    local cardVal = bit.band(card, 0x0f)
    local cardColor = bit.rshift(card, 4)
    local logicVal = cardVal
    if cardColor == 4 then -- king
        logicVal = 10 -- 100
    elseif cardVal > 10 then
        logicVal = 10
    end
    return cardColor, cardVal, logicVal
end

local function analysisCardType(cards)
    local function getOxType(combine)
        local sameCnt = {}
        local frontSum = 0
        local tailSum = 0
        local calfNum = 0 -- 小牛
        local mosaicSum = 0 -- 五花
        for i = 1, 5 do
            local color, val, logicVal = getCardColorAndValue(combine[i])
            -- sameCnt[val] = (sameCnt[val] or 0) + 1
            -- --bomb
            -- if sameCnt[val] == 4 then
            --     return GameCMD.OxType.BOMB
            -- end
            -- --calf
            -- if logicVal < 5 then
            --     calfNum = calfNum + 1
            -- elseif val >0x0a and val <=0x0d then --j,q,k
            --     mosaicSum = mosaicSum + 1
            -- end

            if i <= 3 then
                frontSum = frontSum + logicVal
            else
                tailSum = tailSum + logicVal
            end
        end
        -- calves
        -- if calfNum==5 and frontSum + tailSum <= 10 then
        --     return GameCMD.OxType.CALVES
        -- elseif mosaicSum == 5 then --mosaic
        --     return GameCMD.OxType.MOSAIC
        -- end
        if frontSum < 100 and frontSum % 10 ~= 0 then -- no king and no 10s
            return GameCMD.OxType.NONE
        elseif tailSum < 100 and tailSum % 10 ~= 0 then -- no bull
            return tailSum % 10
        else
            return GameCMD.OxType.BULL
        end
    end
    local oxTyp = GameCMD.OxType.NONE
    local combine = nil
    local num = #cards
    for i = 1, num - 2 do
        for j = i + 1, num - 1 do
            for z = j + 1, num do
                local comb = {cards[i], cards[j], cards[z]}
                table.walk(cards, function(card, index)
                    if index ~= i and index ~= j and index ~= z then
                        table.insert(comb, card)
                    end
                end)
                local ox = getOxType(comb)
                if ox == GameCMD.OxType.BOMB or ox == GameCMD.OxType.CALVES or ox == GameCMD.OxType.MOSAIC then
                    return {
                        ["oxType"] = ox,
                        ["combine"] = comb
                    }
                elseif ox > oxTyp then
                    oxTyp = ox
                    combine = comb
                end
            end
        end
    end
    return {
        ["oxType"] = oxTyp,
        ["combine"] = combine
    }
end

local function parseUserCards(self, args)
    local cards = args.cards
    local playerStatus = args.cbPlayStatus
    self.userCards_ = {}
    self.cardTypes_ = {}
    for i = 1, GameCMD.GAME_PLAYER do
        if playerStatus[i] == GameCMD.USER_STATUS.PLAYING then
            local userCards = {cards[GameCMD.MAX_CARD * (i - 1) + 1], cards[GameCMD.MAX_CARD * (i - 1) + 2], cards[GameCMD.MAX_CARD * (i - 1) + 3], cards[GameCMD.MAX_CARD * (i - 1) + 4],
                               cards[GameCMD.MAX_CARD * (i - 1) + 5]}
            self.userCards_[i - 1] = userCards
            self.cardTypes_[i - 1] = analysisCardType(userCards)
            -- dump(self.cardTypes_[i-1])
        end
    end
end

function TBNNLogic:loadScenePlayData(args)
    parseUserCards(self, args)
    for i, tabScore in ipairs(args.lTableScore) do
        if tabScore > 0 then
            self.tableScore_ = tabScore
            break
        end
    end
end

function TBNNLogic:loadGameStartData(args)
    parseUserCards(self, args)
    self.tableScore_ = args.lTableScore
end

function TBNNLogic:getUserCards()
    return self.userCards_
end

function TBNNLogic:getCardTypes()
    return self.cardTypes_
end

function TBNNLogic:getCardType(chairId)
    return self.cardTypes_[chairId]
end

function TBNNLogic:getTableScore()
    return self.tableScore_
end

return TBNNLogic
