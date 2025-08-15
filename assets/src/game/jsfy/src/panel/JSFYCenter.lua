--[[
JSFYCenter.lua
转盘
]] local GameCMD = require("game.jsfy.src.JSFYCMD")
local JSFYSound = require("game.jsfy.src.JSFYSound")

local PatternTex = {
    [GameCMD.PATTERN.WILD] = "icon_11.png",
    [GameCMD.PATTERN.BONUS] = "icon_10.png",
    [GameCMD.PATTERN.SCATTER] = "icon_9.png",

    [GameCMD.PATTERN.JIANG_SHI] = "icon_8.png",
    [GameCMD.PATTERN.GONG_NV] = "icon_7.png",
    [GameCMD.PATTERN.TONG_ZI] = "icon_6.png",
    [GameCMD.PATTERN.JIN] = "icon_5.png",
    [GameCMD.PATTERN.MU] = "icon_4.png",
    [GameCMD.PATTERN.SHUI] = "icon_3.png",
    [GameCMD.PATTERN.TU] = "icon_2.png",
    [GameCMD.PATTERN.HUO] = "icon_1.png",
    [GameCMD.PATTERN.QUESTION] = "icon_12.png"

    -- [GameCMD.PATTERN.XIANG_HUO] = "icon_12.png",
}

local PatternScale = {
    -- [GameCMD.PATTERN.WILD] = 0.9,
    -- [GameCMD.PATTERN.BONUS] = 0.95,
    -- [GameCMD.PATTERN.XIANG_HUO] = 0.80,
    -- [GameCMD.PATTERN.GONG_NV] = 0.90,
}

local Pattern = class("Pattern", cc.Node)

local function loadAnim(self, patternTex, scale)
    self.spr_ = display.newSprite("#" .. GameCMD.RES_PATH .. "scene/" .. patternTex):addTo(self)
    self.spr_:move(0, 0):setScale(scale or 1)
end

function Pattern:ctor(patternTyp, scale, puzzlePattern)
    self.typ_ = puzzlePattern
    self.bPuzzle_ = false
    if patternTyp == GameCMD.PATTERN.QUESTION then
        self.bPuzzle_ = true
    end
    local patternTex = self.bPuzzle_ and PatternTex[GameCMD.PATTERN.QUESTION] or PatternTex[patternTyp]
    loadAnim(self, patternTex, scale)
    self:stop()
end

local function resetSpr(self)
    self.spr_:stopAllActions()
    self.spr_:setScale(1.0)
end

function Pattern:play()
    resetSpr(self)
    local action = cc.Sequence:create(cc.ScaleTo:create(0.5, 0.7), cc.ScaleTo:create(0.5, 1.0))
    self.spr_:runAction(action)

    if not self.animHit_ then
        self.animHit_ = GameCMD.addAnim("ani/ani_hit.csb", self)
    end
end

function Pattern:stop()
    if self.animHit_ then
        self.animHit_:removeSelf()
        self.animHit_ = nil
    end
    resetSpr(self)
end

function Pattern:solvePuzzle()
    if not self.bPuzzle_ then
        return 0
    end
    local function playfpg()
        local anim = GameCMD.addAnim("ani/ani_fpg.csb", self)
        anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.RemoveSelf:create()))
    end
    local seq = cc.Sequence:create(cc.OrbitCamera:create(0.3, 1, 0, 0, -90, 0, 0), cc.CallFunc:create(function()
        self.spr_:setSpriteFrame(GameCMD.RES_PATH .. "scene/" .. PatternTex[self.typ_])
    end), cc.OrbitCamera:create(0.3, 1, 0, 90, -90, 0, 0), cc.CallFunc:create(playfpg))
    self.spr_:runAction(seq)
    return 1
end

----------------------------------------------------------------------------------------------

local PatternColumn = class("PatternColumn")

local function initColumn(self)
    self.pattern_ = {}
    for i = 1, GameCMD.PATTERN_ROW do
        local randomTyp = self.patternSeed_[math.random(1, #self.patternSeed_)]
        local pattern = Pattern.new(randomTyp, PatternScale[randomTyp])
        pattern:move(self.positions_[i]):addTo(self.root_)
        self.pattern_[i] = pattern
    end
end

function PatternColumn:ctor(root, index)
    self.root_ = root
    self.index_ = index
    self.patternSeed_ = {}
    table.walk(GameCMD.PATTERN, function(typ)
        table.insert(self.patternSeed_, typ)
    end)
    self.size_ = cc.size(175, 488)
    self.positions_ = {cc.p(self.size_.width / 2, self.size_.height / 6), cc.p(self.size_.width / 2, self.size_.height / 2), cc.p(self.size_.width / 2, self.size_.height * 5 / 6)}
    self.startPos_ = cc.p(self.size_.width / 2, self.size_.height * 7 / 6)
    self.endPos_ = cc.p(self.size_.width / 2, -self.size_.height / 6)
    initColumn(self)

    self.lottery_ = {}
    self.dropInterval_ = 0.10
    self.fallSpeed_ = 2000
end

function PatternColumn:getPosition()
    return cc.p(self.root_:getPosition())
end

function PatternColumn:setDropInterval(interval)
    self.dropInterval_ = interval
end

function PatternColumn:setFallSpeed(speed)
    self.fallSpeed_ = speed
end

function PatternColumn:scroll()
    local function createPattern()
        local randomTyp = self.patternSeed_[math.random(1, #self.patternSeed_)]
        local pattern = Pattern.new(randomTyp, PatternScale[randomTyp])
        pattern:move(self.startPos_):addTo(self.root_)
        return pattern
    end
    local function wheelPattern()
        local pattern = self.pattern_[1] or createPattern()
        if next(self.pattern_) then
            table.remove(self.pattern_, 1)
        end
        local dt = cc.pGetDistance(cc.p(pattern:getPosition()), self.endPos_) / self.fallSpeed_
        local seq = cc.Sequence:create(cc.MoveTo:create(dt, self.endPos_), cc.RemoveSelf:create())
        pattern:runAction(seq)
    end

    wheelPattern()
    wheelPattern()
    wheelPattern()
    local seq = cc.Sequence:create(cc.CallFunc:create(wheelPattern), cc.DelayTime:create(self.dropInterval_))
    local rep = cc.RepeatForever:create(seq)
    self.root_:runAction(rep)
end

function PatternColumn:lottery(patterns, puzzlePattern, finishCall)
    self.lottery_ = patterns
    self.root_:stopAllActions()
    for i, pattyp in ipairs(patterns) do
        local pattern = Pattern.new(pattyp, PatternScale[pattyp], puzzlePattern)
        pattern:move(self.startPos_):addTo(self.root_)
        local delay = (i - 1) * self.dropInterval_
        local dest = self.positions_[i]
        local dt = cc.pGetDistance(cc.p(pattern:getPosition()), dest) / self.fallSpeed_
        local actions = {}
        table.insert(actions, cc.DelayTime:create(delay))
        table.insert(actions, cc.MoveTo:create(dt, dest))
        if finishCall and i == #patterns then
            table.insert(actions, cc.CallFunc:create(finishCall))
        end
        table.insert(actions, cc.MoveBy:create(0.05, cc.p(0, -30)))
        table.insert(actions, cc.EaseElasticOut:create(cc.MoveBy:create(0.6, cc.p(0, 30))))
        local seq = cc.Sequence:create(actions)
        pattern:runAction(seq)
        if self.pattern_[i] then
            self.pattern_[i]:removeSelf()
        end
        self.pattern_[i] = pattern
    end
end

function PatternColumn:checkPattern(pattype)
    return table.indexof(self.lottery_, pattype)
end

function PatternColumn:stopAction()
    for i, pattern in ipairs(self.pattern_) do
        pattern:stop()
    end
end

function PatternColumn:reset()
    for i, pattern in ipairs(self.pattern_) do
        pattern:stop()
    end
end

function PatternColumn:playPattern(row)
    if self.pattern_[row] then
        self.pattern_[row]:play()
    end
end

function PatternColumn:collectPattern(pattype)
    local pattern = self.pattern_[self:checkPattern(pattype)]
    if pattern then
        return self.root_:convertToWorldSpace(cc.p(pattern:getPosition()))
    end
end

function PatternColumn:getPosInWorld(index)
    return self.root_:convertToWorldSpace(self.pattern_[index] and cc.p(self.pattern_[index]:getPosition()) or display.LEFT_BOTTOM)
end

function PatternColumn:solvePuzzles()
    local dtSolve = 0
    for i, pattern in ipairs(self.pattern_) do
        local dt = pattern:solvePuzzle()
        if dt > dtSolve then
            dtSolve = dt
        end
    end
    return dtSolve
end
----------------------------------------------------------------------------------------------
local Wheel = class("Wheel")

local LOTTERY_DELAY = {0, 0.2, 0.28, 0.32, 0.35}
local DROP_INTERVAL = {0.1, 0.08, 0.05, 0.05}
local FALL_SPEED = {2400, 3200, 4000, 5000}
local SCROLL_TIME = {1, 0.75, 0.5, 0.25}

local function getColumnRow(pattIndex)
    local col = (pattIndex - 1) % GameCMD.PATTERN_COL + 1
    local row = GameCMD.PATTERN_ROW - math.floor((pattIndex - 1) / GameCMD.PATTERN_COL)
    return col, row
end

function Wheel:ctor(root)
    self.root_ = root

    self.column_ = {}
    for i = 1, GameCMD.PATTERN_COL do
        self.column_[i] = PatternColumn.new(self.root_:getChildByName("Panel_Roll_" .. i), i)
    end

    self.scrollTime_ = SCROLL_TIME[1]
    self.scrollRaito_ = 1
end

function Wheel:startUp()
    local function scrollColumn(column)
        column:scroll()
    end
    if self.startSysTime_ then
        return
    end -- 已经启动
    local actions = {}
    for i, column in ipairs(self.column_) do
        local delay = (i - 1) * 0.05 / self.scrollRaito_
        table.insert(actions, cc.DelayTime:create(delay))
        table.insert(actions, cc.CallFunc:create(handler(column, scrollColumn)))
    end
    self.root_:runAction(cc.Sequence:create(actions))
    self.startSysTime_ = GameUtil.getSystemTime()
end

local function wheelFinish(self, patterns, puzzlePattern, finishCall)
    local columnPatterns = {}
    for i = 1, GameCMD.PATTERN_COL do
        local colPatterns = {patterns[i + GameCMD.PATTERN_COL * 2], patterns[i + GameCMD.PATTERN_COL], patterns[i]}
        table.insert(columnPatterns, colPatterns)
    end
    local counter = 0
    local scrollNum = #self.column_
    local function finishScroll(index)
        self.column_[index]:lottery(columnPatterns[index], puzzlePattern, function()
            JSFYSound.scrollStop()
            counter = counter + 1
            if counter == scrollNum then
                if finishCall then
                    finishCall()
                end
            end
        end)
    end
    local interval = self.scrollTime_ - (GameUtil.getSystemTime() - self.startSysTime_) / 1000
    local actions = {}
    if interval > 0 then
        table.insert(actions, cc.DelayTime:create(interval))
    end

    for i, column in ipairs(self.column_) do
        local delay = LOTTERY_DELAY[i] / self.scrollRaito_
        table.insert(actions, cc.DelayTime:create(delay))
        table.insert(actions, cc.CallFunc:create(handler(i, finishScroll)))
    end
    self.root_:runAction(cc.Sequence:create(actions))
    self.startSysTime_ = nil
end

function Wheel:finish(patterns, AnyCardValue, finishCall)
    self:startUp()
    local puzzlePattern = AnyCardValue -- math.random(1,8) --TODO:
    wheelFinish(self, patterns, puzzlePattern, function()
        self:solveAllPuzzles(finishCall)
    end)
end

function Wheel:reset()
    for i, column in ipairs(self.column_) do
        column:reset()
    end
end

function Wheel:stopColumnAction()
    for i, column in ipairs(self.column_) do
        column:stopAction()
    end
end

function Wheel:playPatterns(poses)
    for i, pos in ipairs(poses) do
        local col, row = getColumnRow(pos)
        self.column_[col]:playPattern(row)
    end
end

function Wheel:solveAllPuzzles(callback)
    local solveInterval = 0
    for i, column in ipairs(self.column_) do
        local inter = column:solvePuzzles()
        if inter > solveInterval then
            solveInterval = inter
        end
    end
    if solveInterval > 0 then
        JSFYSound.flip()
    end
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(solveInterval), cc.CallFunc:create(callback)))
end

function Wheel:getPatternPosition(index)
    local col, row = getColumnRow(index)
    return self.column_[col]:getPosInWorld(row)
end

function Wheel:setScrollRatio(ratio)
    self.scrollRaito_ = ratio
    self.scrollTime_ = SCROLL_TIME[ratio or 1]
    for i, column in ipairs(self.column_) do
        column:setDropInterval(DROP_INTERVAL[ratio or 1])
        column:setFallSpeed(FALL_SPEED[ratio or 1])
    end
end
----------------------------------------------------------------------------------------------

local JSFYCenter = class("JSFYCenter")

function JSFYCenter:ctor(root)
    self.root_ = root

    self.lines_ = {}
    self.pnlLines_ = self.root_:getChildByName("Node_Line")
    for i = 1, 30 do
        self.lines_[i] = self.pnlLines_:getChildByName("Image_line_" .. i):hide()
    end
    self.wheel_ = Wheel.new(self.root_)
end

function JSFYCenter:addFinishCallback(callback)
    self.finishCallback_ = callback
end

function JSFYCenter:getPatternPosition(pattIndex)
    return self.wheel_:getPatternPosition(pattIndex)
end

function JSFYCenter:setWheelSpeed(ratio)
    self.wheel_:setScrollRatio(ratio)
end

function JSFYCenter:showWinLines(winlines, BonusTab)
    local function showLines(lines)
        JSFYSound.lineHit()
        for i, line in ipairs(self.lines_) do
            line:hide()
        end
        table.walk(lines, function(val)
            self.lines_[val.index]:show()
        end)
    end
    local function showWinPatterns(lines)
        self.wheel_:stopColumnAction()
        local tab = {}
        table.walk(lines, function(val)
            for i = 1, val.sameCount do
                table.insert(tab, GameCMD.Lines[val.index][i])
            end
        end)
        self.wheel_:playPatterns(table.unique(tab, true))
    end
    local function showBonusPatterns(bonusTab)
        if #bonusTab < 3 then
            return
        end
        self.wheel_:playPatterns(table.unique(bonusTab, true))
    end
    self:cleanLines()
    self.wheel_:stopColumnAction()
    -- showBonusPatterns(BonusTab)
    if not next(winlines) then
        return
    end

    showLines(winlines)
    showWinPatterns(winlines)
    -- showBonusPatterns(BonusTab)
    --[[if #winlines==1 then showBonusPatterns(BonusTab) return end

	local index = 1
	local seq = cc.Sequence:create(cc.DelayTime:create(1.0), 
								cc.CallFunc:create(function ()
									showLines{winlines[index]}
									showWinPatterns{winlines[index]}
                                    showBonusPatterns(BonusTab)
									index = index + 1
									if index > #winlines then
										index = 1
									end
								end))
	local rep = cc.RepeatForever:create(seq)
	self.pnlLines_:runAction(rep)--]]
end

function JSFYCenter:cleanLines()
    self.pnlLines_:stopAllActions()
    for i, line in ipairs(self.lines_) do
        line:hide()
    end
end

-- function JSFYCenter:startWheel()
-- 	self.wheel_:startUp()
-- end
function JSFYCenter:reConnectWheel(patterns, AnyCardValue, callback)
    self.wheel_:finish(patterns, AnyCardValue, callback)
end

function JSFYCenter:finishWheel(patterns, AnyCardValue)
    self.wheel_:finish(patterns, AnyCardValue, self.finishCallback_)
end

function JSFYCenter:freeWheel(patterns, AnyCardValue)
    self.wheel_:finish(patterns, AnyCardValue, self.finishCallback_)
end

function JSFYCenter:scatterWheel(patterns, AnyCardValue)
    self.wheel_:finish(patterns, AnyCardValue, self.finishCallback_)
end

function JSFYCenter:reset()
    self:cleanLines()
    self.wheel_:reset()
end

return JSFYCenter
