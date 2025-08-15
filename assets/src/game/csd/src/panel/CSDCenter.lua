--[[
CSDCenter.lua
转盘
]] local GameCMD = require("game.csd.src.CSDCMD")
local CSDSound = require("game.csd.src.CSDSound")

local PatternAni = {
    [GameCMD.PATTERN.SCATTER] = "ani_0.csb",
    [GameCMD.PATTERN.WILD] = "ani_1.csb",
    [GameCMD.PATTERN.JACKPOT] = "ani_2.csb",
    [GameCMD.PATTERN.XIANG_HUO] = "ani_3.csb",
    [GameCMD.PATTERN.SHI_TOU] = "ani_4.csb",
    [GameCMD.PATTERN.BA_GUA_YU] = "ani_5.csb",
    [GameCMD.PATTERN.YU_RU_YI] = "ani_6.csb",
    [GameCMD.PATTERN.YUAN_BAO] = "ani_7.csb",
    [GameCMD.PATTERN.TONG_QIAN] = "ani_8.csb",
    [GameCMD.PATTERN.ACE] = "ani_9.csb",
    [GameCMD.PATTERN.KING] = "ani_10.csb",
    [GameCMD.PATTERN.QUEEN] = "ani_11.csb",
    [GameCMD.PATTERN.JACK] = "ani_12.csb"
}

local PatternScale = {
    [GameCMD.PATTERN.WILD] = 0.9,
    [GameCMD.PATTERN.JACKPOT] = 0.95,
    [GameCMD.PATTERN.XIANG_HUO] = 0.80,
    [GameCMD.PATTERN.BA_GUA_YU] = 0.90
}

local EndFrame = {
    [GameCMD.PATTERN.SCATTER] = 40
}

local Pattern = class("Pattern", cc.Node)

local function showKuang(self, visible)
    local kuang = self.anim_:getChildByName("kuang")
    if kuang then
        kuang:setVisible(visible)
    end
end

local function loadAnim(self, patternTyp, scale)
    self.anim_, self.action_ = GameCMD.addAnim("ani/" .. PatternAni[patternTyp], self)
    self.anim_:move(0, 0):setScale(scale or 1)
end

function Pattern:ctor(patternTyp, scale, endFrame)
    self.typ_ = patternTyp
    self.endFrame_ = endFrame or 0
    loadAnim(self, patternTyp, scale)
    self:stop()
end

function Pattern:play()
    self.action_:gotoFrameAndPlay(0)
    showKuang(self, true)
end

function Pattern:stop()
    self.action_:gotoFrameAndPause(self.endFrame_)
    showKuang(self, false)
end

function Pattern:toggle()
    if self.endFrame_ ~= 0 then
        self.action_:gotoFrameAndPlay(0, self.endFrame_, false)
    else
        self.action_:gotoFrameAndPlay(0, false)
    end
end

function Pattern:showWild(bWild)
    if self.anim_ then
        self.anim_:removeSelf()
        self.anim_ = nil
    end
    local pattype = bWild and GameCMD.PATTERN.WILD or self.typ_
    loadAnim(self, pattype, PatternScale[pattype], EndFrame[pattype])
end

----------------------------------------------------------------------------------------------

local PatternColumn = class("PatternColumn")

local function initColumn(self)
    self.pattern_ = {}
    for i = 1, GameCMD.PATTERN_ROW do
        local randomTyp = self.patternSeed_[math.random(1, #self.patternSeed_)]
        local pattern = Pattern.new(randomTyp, PatternScale[randomTyp], EndFrame[randomTyp])
        pattern:move(self.positions_[i]):addTo(self.root_)
        self.pattern_[i] = pattern
    end
end

function PatternColumn:ctor(root, index)
    self.root_ = root
    self.index_ = index
    self.patternSeed_ = {}
    table.walk(GameCMD.PATTERN, function(typ)
        table.insert(self.patternSeed_, (self.index_ == 5 or typ ~= GameCMD.PATTERN.XIANG_HUO) and typ or nil)
    end)
    self.size_ = cc.size(164, 396)
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
        local pattern = Pattern.new(randomTyp, PatternScale[randomTyp], EndFrame[randomTyp])
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

function PatternColumn:lottery(patterns, finishCall)
    self.lottery_ = patterns
    self.root_:stopAllActions()
    for i, pattyp in ipairs(patterns) do
        local pattern = Pattern.new(pattyp, PatternScale[pattyp], EndFrame[pattyp])
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

function PatternColumn:toggleScatter()
    local index = self:checkPattern(GameCMD.PATTERN.SCATTER)
    if self.pattern_[index] then
        self.pattern_[index]:toggle()
    end
    return index
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
        pattern:showWild(false)
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
        pattern:toggle()
        return self.root_:convertToWorldSpace(cc.p(pattern:getPosition()))
    end
end

function PatternColumn:getPosInWorld(index)
    return self.root_:convertToWorldSpace(self.pattern_[index] and cc.p(self.pattern_[index]:getPosition()) or display.LEFT_BOTTOM)
end

function PatternColumn:convertWild(index, bWild)
    self.pattern_[index]:showWild(bWild)
end
----------------------------------------------------------------------------------------------
local Wheel = class("Wheel")

local LOTTERY_DELAY = {0, 0.2, 0.28, 0.34, 0.38}
local DROP_INTERVAL = {0.1, 0.08, 0.05, 0.05}
local FALL_SPEED = {2400, 3200, 4000, 5000}
local SCROLL_TIME = {1, 0.75, 0.5, 0.25}

local ColumnWildOperate = {
    ADD = 0,
    PLAY = 1,
    STOP = 2,
    CLEAN = 3
}

local function initLantern(self)
    local imgLantern = self.root_:getChildByName("img_denglong")
    local imgLight = imgLantern:getChildByName("spr_light")
    local fadeOut = cc.FadeOut:create(0.5)
    imgLight:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeOut, fadeOut:reverse())))
end

local function getColumnRow(pattIndex)
    local col = (pattIndex - 1) % GameCMD.PATTERN_COL + 1
    local row = GameCMD.PATTERN_ROW - math.floor((pattIndex - 1) / GameCMD.PATTERN_COL)
    return col, row
end

function Wheel:ctor(root)
    self.root_ = root
    initLantern(self)

    self.container_ = self.root_:getChildByName("container")
    self.column_ = {}
    for i = 1, GameCMD.PATTERN_COL do
        self.column_[i] = PatternColumn.new(self.container_:getChildByName("Node_" .. i - 1), i)
    end

    self.scrollTime_ = SCROLL_TIME[1]
    self.scrollRaito_ = 1

    self.freeWildAnims_ = {}
    self.columnWild_ = {} -- 列wild
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
        if not self.columnWild_[i] then
            local delay = (i - 1) * 0.05 / self.scrollRaito_
            table.insert(actions, cc.DelayTime:create(delay))
            table.insert(actions, cc.CallFunc:create(handler(column, scrollColumn)))
        end
    end
    self.container_:runAction(cc.Sequence:create(actions))
    self.startSysTime_ = GameUtil.getSystemTime()
end

local function playRectangleRing(self)
    local nodeScatter = self.root_:getChildByName("scater_ani")
    local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "ani/fx_caishen_length.csb")
    anim:addTo(nodeScatter)
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "ani/fx_caishen_length.csb")
    action:gotoFrameAndPlay(0)
    anim:runAction(action)
end

local function wheelFinish(self, patterns, finishCall)
    local columnPatterns = {}
    local toggleScatter = {}
    for i = 1, GameCMD.PATTERN_COL do
        local colPatterns = {patterns[i + GameCMD.PATTERN_COL * 2], patterns[i + GameCMD.PATTERN_COL], patterns[i]}
        table.insert(columnPatterns, colPatterns)
        if i == 1 and table.indexof(colPatterns, GameCMD.PATTERN.SCATTER) then
            toggleScatter[1] = true
        elseif i == 3 and toggleScatter[1] and table.indexof(colPatterns, GameCMD.PATTERN.SCATTER) then
            toggleScatter[3] = true
        elseif i == 5 and toggleScatter[3] and table.indexof(colPatterns, GameCMD.PATTERN.SCATTER) then
            toggleScatter[5] = true
        end
    end
    local counter = 0
    local scrollNum = #self.column_ - table.nums(self.columnWild_)
    local function finishScroll(index)
        self.column_[index]:lottery(columnPatterns[index], function()
            CSDSound.scrollStop()
            if toggleScatter[index] then
                self.column_[index]:toggleScatter()
                CSDSound.scatter()
                if index == 3 then
                    CSDSound.addTime()
                    playRectangleRing(self)
                end
            end
            counter = counter + 1
            if counter == scrollNum then
                self.root_:getChildByName("scater_ani"):removeAllChildren()
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
        if not self.columnWild_[i] then
            local addTime = (i == 5 and toggleScatter[3]) and 1 or 0
            local delay = (LOTTERY_DELAY[i] + addTime) / self.scrollRaito_
            table.insert(actions, cc.DelayTime:create(delay))
            table.insert(actions, cc.CallFunc:create(handler(i, finishScroll)))
        end
    end
    self.container_:runAction(cc.Sequence:create(actions))
    self.startSysTime_ = nil
end

function Wheel:finish(patterns, finishCall)
    self:startUp()
    wheelFinish(self, patterns, finishCall)
end

local function showFreeWilds(self, wilds)
    for i, index in ipairs(wilds) do
        local worldPos = self:getPatternPosition(index)
        local localPos = self.root_:convertToNodeSpace(worldPos)
        local recAnim = GameCMD.addAnim("ani/fx_caishen_width.csb", self.root_):move(localPos)
        GameCMD.addAnim("ani/ani_1.csb", recAnim, 0, 0, false):setScale(PatternScale[GameCMD.PATTERN.WILD])
        self.freeWildAnims_[index] = recAnim
    end
end

function Wheel:freeFinish(patterns, finishCall)
    local seeds = {}
    table.walk(GameCMD.PATTERN, function(typ)
        table.insert(seeds, (typ ~= GameCMD.PATTERN.XIANG_HUO and typ ~= GameCMD.PATTERN.SCATTER) and typ or nil)
    end)
    -- 结果反推wild，用其他图案代替
    local wilds = {}
    for i, patt in ipairs(patterns) do
        if patt == GameCMD.PATTERN.WILD then
            table.insert(wilds, i)
            patterns[i] = seeds[math.random(1, #seeds)]
        end
    end
    showFreeWilds(self, wilds)
    self:startUp()
    wheelFinish(self, patterns, function()
        self:cleanFreeWildAnims()
        self:convertWilds(wilds)
        if finishCall then
            finishCall()
        end
    end)
end

function Wheel:scatterFinish(patterns, columns, finishCall)
    self:operateColumnWild(ColumnWildOperate.ADD, columns)
    self:startUp()
    wheelFinish(self, patterns, finishCall)
end

function Wheel:operateColumnWild(oper, ...)
    local operFunc = {
        [ColumnWildOperate.ADD] = function(columns)
            for i, column in ipairs(columns) do
                local nodeWild = self.root_:getChildByName("wild_ani")
                local anim = GameCMD.addAnim("ani/fx_WILD.csb", nodeWild)
                local panelSize = anim:getChildByName("Panel_1"):getContentSize()
                local pos = cc.pAdd(cc.p(panelSize.width / 2, panelSize.height / 2), self.column_[column]:getPosition())
                anim:move(pos)
                self.columnWild_[column] = anim
            end
            CSDSound.columnWild()
        end,
        [ColumnWildOperate.PLAY] = function()
            table.walk(self.columnWild_, function(anim)
                local action = anim:getActionByTag(0)
                action:gotoFrameAndPlay(0)
            end)
        end,
        [ColumnWildOperate.STOP] = function()
            table.walk(self.columnWild_, function(anim)
                local action = anim:getActionByTag(0)
                action:gotoFrameAndPause(0)
            end)
        end,
        [ColumnWildOperate.CLEAN] = function()
            table.walk(self.columnWild_, function(anim)
                anim:removeSelf()
            end)
            self.columnWild_ = {}
        end
    }
    if operFunc[oper] then
        operFunc[oper](...)
    end
end

function Wheel:cleanFreeWildAnims()
    for k, anim in pairs(self.freeWildAnims_) do
        anim:removeSelf()
    end
    self.freeWildAnims_ = {}
end

function Wheel:reset()
    for i, column in ipairs(self.column_) do
        column:reset()
    end
    self:operateColumnWild(ColumnWildOperate.CLEAN)
end

function Wheel:stopColumnAction()
    for i, column in ipairs(self.column_) do
        column:stopAction()
    end
    self:operateColumnWild(ColumnWildOperate.STOP)
end

function Wheel:collectJoss()
    if not self.columnWild_[#self.column_] then
        return self.column_[#self.column_]:collectPattern(GameCMD.PATTERN.XIANG_HUO)
    end
end

function Wheel:playPatterns(poses)
    local flag = false
    for i, pos in ipairs(poses) do
        local col, row = getColumnRow(pos)
        if not self.columnWild_[col] then
            self.column_[col]:playPattern(row)
        else
            flag = true
        end
    end
    if flag then
        self:operateColumnWild(ColumnWildOperate.PLAY)
    end
end

function Wheel:convertWilds(wilds)
    table.walk(wilds, function(index)
        local col, row = getColumnRow(index)
        self.column_[col]:convertWild(row, true)
    end)
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

local CSDCenter = class("CSDCenter")

function CSDCenter:ctor(root)
    self.root_ = root

    self.lines_ = {}
    self.pnlLines_ = self.root_:getChildByName("pnl_lines")
    for i = 1, 25 do
        self.lines_[i] = self.pnlLines_:getChildByName("xian_" .. i - 1)
    end
    self.wheel_ = Wheel.new(self.root_:getChildByName("pnl_wheel"))
end

function CSDCenter:addFinishCallback(callback)
    self.finishCallback_ = callback
end

function CSDCenter:getPatternPosition(pattIndex)
    return self.wheel_:getPatternPosition(pattIndex)
end

function CSDCenter:setWheelSpeed(ratio)
    self.wheel_:setScrollRatio(ratio)
end

function CSDCenter:showWinLines(winlines)
    local function showLines(lines)
        for i, line in ipairs(self.lines_) do
            line:hide()
            table.walk(lines, function(val)
                if i == val.index then
                    line:show()
                end
            end)
        end
    end
    local function showWinPatterns()
        local tab = {}
        table.walk(winlines, function(val)
            for i = 1, val.sameCount do
                table.insert(tab, GameCMD.Lines[val.index][i])
            end
        end)
        self.wheel_:playPatterns(table.unique(tab, true))
    end
    self:cleanLines()
    self.wheel_:stopColumnAction()
    if not next(winlines) then
        return
    end

    showLines(winlines)
    showWinPatterns()
    local index = 1
    local seq = cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        showLines {winlines[index]}
        index = index + 1
        if index > #winlines then
            index = 1
        end
    end))
    local rep = cc.RepeatForever:create(seq)
    self.pnlLines_:runAction(rep)
end

function CSDCenter:cleanLines()
    self.pnlLines_:stopAllActions()
    for i, line in ipairs(self.lines_) do
        line:hide()
    end
end

-- function CSDCenter:startWheel()
-- 	self.wheel_:startUp()
-- end

function CSDCenter:finishWheel(patterns)
    self.wheel_:finish(patterns, self.finishCallback_)
end

function CSDCenter:freeWheel(patterns)
    self.wheel_:freeFinish(patterns, self.finishCallback_)
end

function CSDCenter:scatterWheel(patterns, columns)
    self.wheel_:scatterFinish(patterns, columns, self.finishCallback_)
end

function CSDCenter:collectJoss()
    return self.wheel_:collectJoss()
end

function CSDCenter:reset()
    self:cleanLines()
    self.wheel_:reset()
end

return CSDCenter
