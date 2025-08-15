--[[
LHDBCenter.lua
]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBSound = require("game.lhdb.src.LHDBSound")

local PREFIX = "Game/LHDB/Score/"

local Gem = class("Gem")

function Gem:ctor(root)
    self.root_ = root
    self.root_:hide()

    self.anim_ = nil
end

local function getStageAndIndex(gemId)
    return math.floor((gemId - 1) / 5) + 1, (gemId - 1) % 5
end

local function getGemAnimFile(gemId)
    if gemId == 0 then
        return GameCMD.RES_PATH .. "Anims/Key.csb"
    elseif gemId < 0 then
        -- dump("FAKE GEM")
        return GameCMD.RES_PATH .. "Anims/Key.csb"
    else
        local stage, index = getStageAndIndex(gemId)
        return GameCMD.RES_PATH .. string.format("Anims/Gem_%d_%d.csb", stage, index)
    end
end

function Gem:getId()
    return self.gemId_
end

function Gem:erase(callback)
    if not self.gemId_ or not self.anim_ then
        if callback then
            callback()
        end
        return
    end
    self.gemId_ = nil
    self.anim_:removeSelf()
    self.anim_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/Bomb.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/Bomb.csb")
    action:gotoFrameAndPlay(0, false)
    self.anim_:setScale(0.76)
    self.anim_:move(self.root_:getPosition()):addTo(self.root_:getParent())
    self.anim_:runAction(action)
    self.anim_:runAction(cc.Sequence:create(cc.DelayTime:create(0.55), cc.CallFunc:create(function()
        self.anim_:removeSelf()
        self.anim_ = nil
        if callback then
            callback()
        end
    end)))
end

function Gem:dropTo(targetGem, speed, delay, callback)
    targetGem.gemId_ = self.gemId_
    targetGem.anim_ = self.anim_
    self.gemId_ = nil
    self.anim_ = nil
    if not targetGem.anim_ then
        if callback then
            callback()
        end
        return
    end
    local dropFunc = function()
        local dist = cc.pGetDistance(targetGem:getPosition(), self:getPosition())
        local dt = dist / speed
        -- local moveTo = cc.MoveTo:create(dt, cc.pSub(targetGem:getPosition(), cc.p(0,20)))
        local moveTo = cc.EaseIn:create(cc.MoveTo:create(dt, cc.pSub(targetGem:getPosition(), cc.p(0, 20))), 1.1)
        local callFunc = cc.CallFunc:create(function()
            LHDBSound.dropGem()
            if callback then
                callback()
            end
        end)
        local ease = cc.EaseElasticOut:create(cc.MoveBy:create(0.5, cc.p(0, 20)))
        local seq = cc.Sequence:create(moveTo, callFunc, ease)
        targetGem.anim_:runAction(seq)
    end
    targetGem.root_:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(dropFunc)))
end

function Gem:dropNew(gemId, startPos, speed, delay, callback)
    self.gemId_ = gemId
    local file = getGemAnimFile(gemId)

    if not file then
        if callback then
            callback()
        end
        return
    end
    if self.anim_ then
        self.anim_:removeSelf()
    end
    local dropCall = function()
        self.anim_ = cc.CSLoader:createNode(file)
        local action = cc.CSLoader:createTimeline(file)
        local duration = action:getDuration()
        action:gotoFrameAndPlay(0, duration, math.random(0, duration), true)
        self.anim_:runAction(action)
        self.anim_:setScale(0.76)
        self.anim_:move(startPos):addTo(self.root_:getParent())

        local dist = cc.pGetDistance(startPos, self:getPosition())
        local dt = dist / speed
        -- local seq = cc.Sequence:create(cc.MoveTo:create(dt, cc.pSub(self:getPosition(), cc.p(0,20))),
        local seq = cc.Sequence:create(cc.EaseIn:create(cc.MoveTo:create(dt, cc.pSub(self:getPosition(), cc.p(0, 20))), 1.1), cc.CallFunc:create(function()
            LHDBSound.dropGem()
            if callback then
                callback()
            end
        end), cc.EaseElasticOut:create(cc.MoveBy:create(0.5, cc.p(0, 20))))
        self.anim_:runAction(seq)
    end
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(dropCall)))
end

function Gem:eliminate(callback)
    self.gemId_ = nil
    if not self.anim_ then
        if callback then
            callback()
        end
        return
    end
    local tmp = self.anim_
    self.anim_ = nil

    local oper = math.random(1, 100) > 50 and 1 or -1
    local offsetEndX = self:getPosition().y + math.random(50, 100)
    local endY = -100

    local offsetConX1 = offsetEndX * 0.3 -- math.random(100, 200)
    local offsetConY1 = offsetConX1 * 5 -- math.random(300, 500)

    local endPos = cc.p(self:getPosition().x + offsetEndX * oper, endY)
    local ctrlPnt1 = cc.pAdd(self:getPosition(), cc.p(offsetConX1 * oper, offsetConY1))
    local ctrlPnt2 = cc.p((endPos.x + ctrlPnt1.x) / 2, (endPos.y + ctrlPnt1.y) / 2 + 20)

    local dist = cc.pGetDistance(self:getPosition(), endPos)
    local dt = math.pow(dist / 1500, 0.25)
    local bezier = cc.BezierTo:create(dt, {ctrlPnt1, ctrlPnt2, endPos})
    local seq = cc.Sequence:create(bezier, cc.RemoveSelf:create(), cc.CallFunc:create(callback))
    tmp:runAction(seq)
end

function Gem:getPosition()
    return cc.p(self.root_:getPosition())
end

function Gem:clean()
    if self.anim_ then
        self.anim_:removeSelf()
    end
    self.anim_ = nil
    self.gemId_ = nil
end
----------------------------------------------------------------------------------------------------------------
local Gems = class("Gems")

function Gems:ctor(root)
    self.root_ = root
    local nodeGems = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Gems.csb")
    nodeGems:addTo(self.root_, -1)

    self.cacheMartix_ = {}
    for i = 1, 6 do
        self.cacheMartix_[i] = {}
        for j = 1, 8 do
            self.cacheMartix_[i][j] = Gem.new(nodeGems:getChildByName(string.format("Gem_%d_%d", j - 1, i - 1)))
        end
    end
    self.gemMartix_ = self.cacheMartix_

    self.pnlGemScore_ = self.root_:getChildByName("pnl_gemScore")
    self.pnlScore_ = self.pnlGemScore_:getChildByName("pnl_score")
    self.pnlScoreStartPos_ = cc.p(self.pnlScore_:getPosition())
    self.pnlScore_:hide()
    self.pnlTotalScore_ = self.root_:getChildByName("pnl_totalScore")
    self.pnlTotalScore_:hide()
    self.pnlCombo_ = self.pnlGemScore_:getChildByName("pnl_combo")
    self.pnlCombo_:hide()

    self.betScore_ = 1
    self.totalScore_ = 0
    self.combo_ = 0
    self.lvl_ = 1
    self.data_ = nil

    self.dispatchSpeed_ = 2200
    self.fillSpeed_ = 1500
    self.dropFactor_ = 1
end

function Gems:addUnlockCallback(callback)
    self.unlockCallback_ = callback
end

function Gems:addFinishEraseCallback(callback)
    self.finishEraseCallback_ = callback
end

function Gems:setDropFactor(factor)
    self.dropFactor_ = factor
end

function Gems:initMatrix(lvl)
    self.lvl_ = lvl
    self.gemMartix_ = {}
    local column = self:getWidth()
    if column == 4 or column == 5 then
        for i = 1, column do
            self.gemMartix_[i] = {}
            for j = 1, column do
                table.insert(self.gemMartix_[i], self.cacheMartix_[i + 1][j])
            end
            table.insert(self.gemMartix_[i], self.cacheMartix_[i + 1][7])
            table.insert(self.gemMartix_[i], self.cacheMartix_[i + 1][8])
        end
    else
        self.gemMartix_ = self.cacheMartix_
    end
end

function Gems:getWidth()
    return self.lvl_ + 3
end

local function eraseGemsCallback(self, erased)
    if erased then
        self:fillGems()
    else
        if self.finishEraseCallback_ then
            self.finishEraseCallback_(self.totalScore_)
        end
    end
end

local function uploadUnexception(self)
    if not self.servData_ then
        return
    end

    if PlazaManager.uploadBuglyLog then
        local gems = table.concat(self.servData_.gems, ",")
        local str = string.format("cStage:%d, gemLen:%d, gems:[%s]", self.servData_.cStage, self.servData_.gemLen, gems)
        PlazaManager.uploadBuglyLog("连环夺宝异常上报:", str)
    end
end

function Gems:dropGems(data, servData)
    self.servData_ = servData -- 服务端给的数据，用作异常上报使用

    self.data_ = data
    self.totalScore_ = 0
    self.combo_ = 0

    self.pnlTotalScore_:hide()
    self:eliminateGems(function()
        self:dispatchGems(function()
            -- 检查钻头
            local keyGem = self:checkKey()
            if keyGem then
                keyGem:erase(function()
                    if self.unlockCallback_ then
                        self.unlockCallback_()
                    end
                    self:fillGems()
                end)
                LHDBSound.removeKey()
            else
                self:eraseGemsInLine(0.3, handler(self, eraseGemsCallback))
            end
        end)
    end)
end

function Gems:loadBetScore(betScore)
    self.betScore_ = betScore
end

function Gems:clean()
    for i, gemColumn in pairs(self.gemMartix_) do
        for j, gem in ipairs(gemColumn) do
            gem:clean()
        end
    end
    self.totalScore_ = 0
    self.combo_ = 0
    self.pnlTotalScore_:hide()
end

function Gems:isEmpty()
    for i, gemColumn in pairs(self.gemMartix_) do
        for j, gem in ipairs(gemColumn) do
            if gem:getId() then
                return false
            end
        end
    end
    return true
end

function Gems:eliminateGems(callback)
    if not self:isEmpty() then
        LHDBSound.throwGems()
    end
    local totalGems = #self.gemMartix_ * (#self.gemMartix_[1] - 1) -- 顶层不参与
    local index = 0
    for i, gemColumn in pairs(self.gemMartix_) do
        for j, gem in ipairs(gemColumn) do
            if j == #gemColumn then
                gem:clean()
            else
                local gemPos = gem:getPosition()
                gem:eliminate(function()
                    index = index + 1
                    if index == totalGems then
                        if callback then
                            callback()
                        end
                    end
                end)
            end
        end
    end
end

function Gems:dispatchGems(callback)
    local function dispatchColumn(gemColumn, columnData, columnDelay, finishCall)
        local num = #gemColumn
        local index = 1
        local function recursiveDispatch(delay)
            if index > num then
                if finishCall then
                    finishCall()
                end
                return
            end
            local gemId = columnData[1]
            table.remove(columnData, 1)

            local startPos = cc.p(gemColumn[num]:getPosition())
            local floatSpeed = (self.dispatchSpeed_ + math.random(0, 200) - 100) * self.dropFactor_
            gemColumn[index]:dropNew(gemId, startPos, floatSpeed, delay or 0, recursiveDispatch)
            index = index + 1
        end
        recursiveDispatch(columnDelay)
    end
    local tick = 0
    math.newrandomseed()
    for i, gemColumn in pairs(self.gemMartix_) do
        local delay = (math.random(1, 4500) / 10000) / self.dropFactor_
        dispatchColumn(gemColumn, self.data_[i], delay, function()
            tick = tick + 1
            if tick == #self.gemMartix_ then
                if callback then
                    callback()
                end
            end
        end)
    end
end

local function fillGemColumn(self, gemColumn, columnData, columnDelay, finishCall)
    local num = #gemColumn
    local index = 1
    local function recursiveFill(delay)
        if index > num then
            if finishCall then
                finishCall()
            end
            return
        end
        local gem = gemColumn[index]
        index = index + 1
        if not gem:getId() then
            local find = false
            for i = index, num do
                local nxtGem = gemColumn[i]
                if nxtGem:getId() then
                    local floatSpeed = (self.fillSpeed_ + math.random(0, 200) - 100) * self.dropFactor_
                    nxtGem:dropTo(gem, floatSpeed, delay or 0, recursiveFill)
                    find = true
                    break
                end
            end
            -- 顶部用完了
            if not find then
                local gemId = columnData[1]
                table.remove(columnData, 1)
                local floatSpeed = (self.fillSpeed_ + math.random(0, 200) - 100) * self.dropFactor_
                gem:dropNew(gemId, gemColumn[num]:getPosition(), floatSpeed, 0, recursiveFill)
            end
        else
            recursiveFill(delay)
        end
    end
    recursiveFill(columnDelay)
end

function Gems:fillGems()
    local tick = 0
    math.newrandomseed()
    for i, gemColumn in pairs(self.gemMartix_) do
        local delay = (math.random(1, 4500) / 10000) / self.dropFactor_
        fillGemColumn(self, gemColumn, self.data_[i], delay, function()
            tick = tick + 1
            if tick == #self.gemMartix_ then
                self:eraseGemsInLine(0.3, handler(self, eraseGemsCallback))
            end
        end)
    end
end

function Gems:lottery(callback)
    if self.totalScore_ > 0 then
        LHDBSound.getScore()
        self.pnlTotalScore_:setScale(0.5)
        self.pnlTotalScore_:getChildByName("txt_score"):setString("总获得：" .. self.totalScore_)
        self.pnlTotalScore_:runAction(cc.Sequence:create(cc.Show:create(), cc.ScaleTo:create(0.3, 1.0), cc.CallFunc:create(function()
            if callback then
                callback()
            end
        end)))
    else
        if callback then
            callback()
        end
    end
end

function Gems:eraseGemsInLine(delayErase, finishCall)
    local gemsArr = self:checkErase()
    if not next(gemsArr) then
        finishCall(false)
        return
    end
    local function settleReward(gemId, num, callback)
        if not gemId or not GameCMD.GemRate[gemId] then
            uploadUnexception(self)
        end
        self.pnlScore_:getChildByName("img_logo"):loadTexture(PREFIX .. string.format("gem_%d_%d.png", getStageAndIndex(gemId)), ccui.TextureResType.plistType)
        self.pnlScore_:getChildByName("txt_num"):setString("X" .. num)
        local verifyNum = num > (self.lvl_ + 13) and self.lvl_ + 13 or num
        local reward = self.betScore_ * GameCMD.GemRate[gemId][verifyNum]
        self.pnlScore_:getChildByName("txt_score"):setString(reward)
        self.pnlScore_:getChildByName("txt_combo"):setString(self.combo_)
        self.pnlScore_:getChildByName("txt_combo"):setVisible(self.combo_ > 0)
        self.totalScore_ = self.totalScore_ + reward
        self.combo_ = self.combo_ + 1

        self.pnlScore_:stopAllActions()
        self.pnlScore_:move(self.pnlScoreStartPos_)
        local spawn1 = cc.Spawn:create(cc.ScaleTo:create(0.3, 1.7), cc.MoveTo:create(0.3, cc.p(self.pnlGemScore_:getChildByName("node_posMid"):getPosition())))
        local spawn2 = cc.Spawn:create(cc.ScaleTo:create(0.2, 1.0), cc.MoveTo:create(0.2, cc.p(self.pnlGemScore_:getChildByName("node_posEnd"):getPosition())))
        self.pnlScore_:runAction(cc.Sequence:create(cc.Show:create(), spawn1, cc.CallFunc:create(callback), cc.DelayTime:create(0.4), spawn2, cc.Hide:create()))
    end
    local function recursiveErase()
        local gems = gemsArr[1]
        if not gems then
            if finishCall then
                finishCall(true)
            end
            return
        end
        table.remove(gemsArr, 1)
        local cnt = 0
        local pos = gems[1]
        local gemId = self.gemMartix_[pos.x][pos.y]:getId()
        for i, pos in ipairs(gems) do
            local gem = self.gemMartix_[pos.x][pos.y]
            gem:erase(function()
                cnt = cnt + 1
                -- erase all
                if cnt == #gems then
                    settleReward(gemId, cnt, recursiveErase)
                end
            end)
        end
        LHDBSound.removeGems()
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(delayErase), cc.CallFunc:create(recursiveErase))
    self.root_:runAction(seq)
end

function Gems:checkErase()
    local function checkNeighbor(posLines, pos2)
        for i, pos in ipairs(posLines) do
            -- 相邻
            if (pos2.x == pos.x and math.abs(pos2.y - pos.y) == 1) or (pos2.y == pos.y and math.abs(pos2.x - pos.x) == 1) then
                return true
            end
        end
    end
    local function extractNeighborPos(posLines, posTab)
        local find = true
        while find do
            find = false
            for i, pos in ipairs(posTab) do
                if checkNeighbor(posLines, pos) then
                    table.insert(posLines, pos)
                    table.remove(posTab, i)
                    find = true
                    break
                end
            end
        end
    end
    local function checkInLines(gemId, lmt)
        local posTab = {}
        for i, gemColumn in pairs(self.gemMartix_) do
            for j, gem in ipairs(gemColumn) do
                if j > self:getWidth() then
                    break
                end
                -- 未填满或者有钻头，异常
                if not gem:getId() or gem:getId() == GameCMD.Gems.DRILL_GEM then
                    uploadUnexception(self)
                    assert(false, "error gemsMap")
                elseif gemId == gem:getId() then
                    table.insert(posTab, {
                        x = i,
                        y = j
                    })
                end
            end
        end
        local linesArr = {}
        while #posTab > 0 do
            local posInLines = {}
            local pos = posTab[1]
            table.remove(posTab, 1)
            table.insert(posInLines, pos)
            extractNeighborPos(posInLines, posTab)
            -- dump(posInLines)
            if #posInLines >= lmt then
                table.insert(linesArr, posInLines)
            end
        end
        return linesArr
    end
    local erases = {}
    for i = 1, 5 do
        table.insertto(erases, checkInLines((self.lvl_ - 1) * 5 + i, self.lvl_ + 3))
    end
    return erases
end

function Gems:checkKey()
    for i, gemColumn in pairs(self.gemMartix_) do
        for j, gem in ipairs(gemColumn) do
            if j > self:getWidth() then
                break
            end
            if gem:getId() == GameCMD.Gems.DRILL_GEM then
                return gem, i, j
            end
        end
    end
end
--------------------------------------------------------------------------------
local GateBox = class("GateBox")

function GateBox:ctor(root)
    self.root_ = root

    self.boxes_ = {}
    for i = 15, 1, -1 do
        table.insert(self.boxes_, self.root_:getChildByName("Box" .. i))
    end
    self.lockBox_ = #self.boxes_
end

function GateBox:initLockBox(lockBox)
    self.lockBox_ = lockBox
    local unlock = 15 - lockBox
    for i = 1, 15 do
        self.boxes_[i]:setVisible(i > unlock)
    end
end

local function showUnlockAnim(self, pos, callback)
    local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_xiangzi.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_xiangzi.csb")
    action:gotoFrameAndPlay(0, false)
    anim:move(pos):addTo(self.root_)
    anim:runAction(action)
    anim:runAction(cc.Sequence:create(cc.DelayTime:create(action:getDuration() / 60), callback and cc.CallFunc:create(callback)))
end

function GateBox:unlockBox(callback)
    for i, box in ipairs(self.boxes_) do
        if box:isVisible() then
            box:hide()
            local pos = cc.p(box:getPosition())
            showUnlockAnim(self, pos, function()
                if callback then
                    callback(self.root_:convertToWorldSpace(pos))
                end
            end)
            self.lockBox_ = self.lockBox_ - 1
            break
        end
    end
end

function GateBox:getLockBox()
    return self.lockBox_
end
--------------------------------------------------------------------------------

local LHDBCenter = class("LHDBCenter")

LHDBCenter.Event = {
    ERASE_FINISH = 0,
    UNLOCK_BOX = 1
}

function LHDBCenter:ctor(root)
    self.root_ = root

    self.gateLvl_ = nil
    -- gems
    self.gems_ = Gems.new(self.root_:getChildByName("pnl_gems"))

    self.gateBox_ = {}
    for i = 1, 3 do
        self.gateBox_[i] = GateBox.new(self.root_:getChildByName("pnl_box" .. i))
    end
end

function LHDBCenter:addEventCallback(callback)
    self.gems_:addFinishEraseCallback(handler(LHDBCenter.Event.ERASE_FINISH, callback))
    self.gems_:addUnlockCallback(function()
        -- 滞后性
        if self.gateLockBox_ >= self.gateBox_[self.gateLvl_]:getLockBox() then
            -- check
            -- dump("lock box from server:" .. self.gateLockBox_ .. " local lock box:" .. self.gateBox_[self.gateLvl_]:getLockBox())
        else
            self.gateBox_[self.gateLvl_]:unlockBox(handler(LHDBCenter.Event.UNLOCK_BOX, callback))
        end
    end)
end

function LHDBCenter:initGateAndLockBox(lvl, lockBox)
    self.gateLvl_ = lvl
    for i, gateBox in ipairs(self.gateBox_) do
        gateBox:initLockBox(i > lvl and 15 or (i < lvl and 0 or lockBox))
    end
    self.gems_:initMatrix(lvl)
    self.gateLockBox_ = lockBox
end

function LHDBCenter:updateGateAndLockBox(lvl, lockBox)
    if lvl ~= self.gateLvl_ then
        self.gateLvl_ = lvl
        self.gems_:initMatrix(lvl)
    end
    self.gateLockBox_ = lockBox
end

function LHDBCenter:dropGems(gemsData, servData)
    self.gems_:dropGems(gemsData, servData)
end

function LHDBCenter:loadBetScore(score)
    self.gems_:loadBetScore(score)
end

function LHDBCenter:setGemDropFactor(factor)
    self.gems_:setDropFactor(factor)
end

function LHDBCenter:settleLottery(callback)
    self.gems_:lottery(callback)
end

function LHDBCenter:cleanGems()
    self.gems_:clean()
end

return LHDBCenter
