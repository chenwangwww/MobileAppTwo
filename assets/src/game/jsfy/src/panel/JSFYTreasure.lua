--[[
JSFYTreasure.lua

]] local GameCMD = require("game.jsfy.src.JSFYCMD")
local JSFYSound = require("game.jsfy.src.JSFYSound")
local GameMessage = require("game.jsfy.src.JSFYMessage")

local Box = class("Box")

Box.State = {
    CLOSE = 0,
    FORBID = 1,
    OPEN = 2
}

function Box:ctor(root, lvl, txtTimes)
    self.root_ = root
    self.lvl_ = lvl
    self.txtTimes_ = txtTimes

    self.root_:ignoreContentAdaptWithSize(true)
    local rootSize = self.root_:getContentSize()
    self.txtTimes_:move(rootSize.width / 2, rootSize.height * 0.9):addTo(self.root_)
    self.txtTimes_:setString("")
    self:setState(Box.State.FORBID)
end

function Box:addClickCallback(callback)
    self.root_:addClickEventListener(callback)
end

function Box:setTouchEnabled(enable)
    self.root_:setTouchEnabled(enable)
end

function Box:setState(state, ...)
    self.txtTimes_:setString("")
    self.root_:setColor(cc.WHITE)
    self:setTouchEnabled(false)
    if state == Box.State.CLOSE then
        local tex = string.format("scene/treasure/ui_slots_xyx_bz_%d.png", self.lvl_)
        self.root_:loadTexture(GameCMD.RES_PATH .. tex, ccui.TextureResType.plistType)
        self:setTouchEnabled(true)
    elseif state == Box.State.FORBID then
        local ratio = ...
        local tex = ratio == 0 and "scene/treasure/ui_slots_xyx_zhadan.png" or string.format("scene/treasure/ui_slots_xyx_bz_%d.png", self.lvl_)
        self.root_:loadTexture(GameCMD.RES_PATH .. tex, ccui.TextureResType.plistType)
        if ratio and ratio ~= 0 then
            self.txtTimes_:setString(ratio .. SubLang:word(1))
        end
        self.root_:setColor(cc.c3b(127, 127, 127))
    elseif state == Box.State.OPEN then
        local ratio = ...
        if ratio ~= 0 then
            local tex = string.format("scene/treasure/ui_slots_xyx_bz_%d_2.png", self.lvl_)
            self.root_:loadTexture(GameCMD.RES_PATH .. tex, ccui.TextureResType.plistType)
            self.txtTimes_:setString(ratio .. SubLang:word(1))
            local anim = GameCMD.addAnim("ani/ani_open.csb", self.root_:getParent(), 0, false):move(self.root_:getPosition())
            anim:setScale(0.5)
            anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
        else
            self.root_:hide()
            local anim = GameCMD.addAnim("ani/ani_bomb.csb", self.root_:getParent(), 0, false):move(self.root_:getPosition())
            anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
        end
    end
end

local TreasureUI = class("TreasureUI", cc.Node)

function TreasureUI:ctor()
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "LayerTreasure.csb")
    self.root_:align(display.CENTER, display.center):addTo(self)

    local bgSize = self.root_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.root_:setScale(scale)

    self.pnlSettle_ = self.root_:getChildByName("Panel_Win"):hide()
    self.pnlSettle_:getChildByName("Text_Score"):setString("")
    local pnlBoxes = self.root_:getChildByName("Panel_box")
    local txtTimes = self.root_:getChildByName("Text_BoxTimes")
    self.boxes_ = {}
    for i = 1, 4 do
        local rowBoxes = {}
        for j = 1, 5 do
            local img = pnlBoxes:getChildByName(string.format("Image_box_%d_%d", i, j))
            local box = Box.new(img, i, txtTimes:clone())
            table.insert(rowBoxes, box)
        end
        table.insert(self.boxes_, rowBoxes)
    end
    self:openRowBoxes(1)
end

function TreasureUI:addBoxClickCallback(callback)
    for i = 1, 4 do
        local boxes = {}
        for j = 1, 5 do
            self.boxes_[i][j]:addClickCallback(function()
                if callback then
                    callback(i, j)
                end
            end)
        end
    end
end

function TreasureUI:selectBox(row, col, ratios)
    local rowBoxes = self.boxes_[row]
    for i, box in ipairs(rowBoxes) do
        box:setState(i == col and Box.State.OPEN or Box.State.FORBID, ratios[i])
    end
end

function TreasureUI:openRowBoxes(row)
    local rowBoxes = self.boxes_[row]
    for i, box in ipairs(rowBoxes or {}) do
        box:setState(Box.State.CLOSE)
    end
end

function TreasureUI:BlinkBox(row)
    local rowBoxes = self.boxes_[row]
    local temp_ = 0
    for i, box in ipairs(rowBoxes or {}) do
        box.root_:runAction(cc.Repeat:create(cc.Sequence:create(cc.ScaleTo:create(0.5, 0.5), cc.ScaleTo:create(0.5, 1), cc.CallFunc:create(function()
            temp_ = temp_ + 1
            if temp_ == 50 then
                GameMessage.sendBoxSelect(row - 1, math.random(1, 5) - 1)
            end
        end)), 10))
    end
end

function TreasureUI:stopAllBoxActionByRow(row)
    local rowBoxes = self.boxes_[row]
    for i, box in ipairs(rowBoxes or {}) do
        box.root_:stopAllActions()
        box.root_:setScale(1)
    end
end

function TreasureUI:setReward(base, ratio)
    local txtReward = self.root_:getChildByName("Image_jg"):getChildByName("Text_jiangli")
    txtReward:setString(string.format(SubLang:word(2), base, ratio, base * ratio))
end

function TreasureUI:settle(winScore, callback)
    self.pnlSettle_:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.Show:create(), cc.CallFunc:create(function()
        JSFYSound.winEnd()
        JSFYSound.addScore()
        local currentScore = 0
        local interval = 0.1
        local tick = 5
        local stepAdd = winScore / tick
        local txtScore = self.pnlSettle_:getChildByName("Text_Score")
        local callFunc = cc.CallFunc:create(function()
            currentScore = currentScore + stepAdd
            currentScore = currentScore > winScore and winScore or currentScore
            txtScore:setString(math.floor(currentScore))
            if currentScore >= winScore then
                self.pnlSettle_:stopAllActions()
                self.pnlSettle_:runAction(cc.Sequence:create(cc.DelayTime:create(3), cc.CallFunc:create(callback)))
            end
        end)
        local seq = cc.Sequence:create(cc.DelayTime:create(interval), callFunc)
        local rep = cc.RepeatForever:create(seq)
        self.pnlSettle_:runAction(rep)
    end)))
end
-------------------------------------------------------------------------------------------------------------
local JSFYTreasure = class("JSFYTreasure")

function JSFYTreasure:ctor()

end

local function getRowRatios(tal)
    local ratios = {}
    --[[local num = 5-(row-1)-(selectRatio==0 and 0 or 1)
	for i=1,num do
		local rand = math.random(1,10)-1
		table.insert(ratios, 50*row - rand*5)
	end
	local bombCnt = row-1 - (selectRatio==0 and 1 or 0)
	for i=1,bombCnt do
		local rand = math.random(1,#ratios+1)
		table.insert(ratios, rand, 0) --bomb
	end--]]
    local ratio = 0
    for index, value in ipairs(tal) do
        if value ~= 0xffff then
            ratio = value
        else
            ratio = 0
        end
        table.insert(ratios, index, ratio)
    end
    return ratios
end

function JSFYTreasure:DealOpenBoxData(params, callback, isConnect)
    local totalRatio = 0
    for row, col in ipairs(params.cbBonusSelect) do
        if col ~= 0xff then
            if isConnect ~= true then
                local ratio = params.wBonusValue[row][col + 1]
                if params.cbBonusSelect[row + 1] and params.cbBonusSelect[row + 1] ~= 0xff then
                    -- TODO
                else
                    local rowRatios = getRowRatios(params.wBonusValue[row])
                    self.ui_:selectBox(row, col + 1, rowRatios)
                end
                if row >= 4 and ratio ~= 0xffff then
                    totalRatio = totalRatio + ratio
                end
                if row >= 4 or ratio == 0xffff then
                    self.ui_:settle(params.lSumBonusGold, function()
                        self:close(params.lWinScore)
                        if callback then
                            callback()
                        end
                    end)
                    JSFYSound.bomb()
                    break
                else
                    totalRatio = totalRatio + ratio
                end
            else
                local ratio = params.wBonusValue[row][col + 1]
                local rowRatios = getRowRatios(params.wBonusValue[row])
                self.ui_:selectBox(row, col + 1, rowRatios)
                if row >= 4 and ratio ~= 0xffff then
                    totalRatio = totalRatio + ratio
                end
                if row >= 4 or ratio == 0xffff then
                    self.ui_:settle(params.lSumBonusGold, function()
                        self:close(params.lWinScore)
                        if callback then
                            callback()
                        end
                    end)
                    JSFYSound.bomb()
                    break
                else
                    totalRatio = totalRatio + ratio
                end
            end
        else
            JSFYSound.openBox()
            self.ui_:openRowBoxes(row)
            if self.isAutoOpenBox == true then
                self.ui_:stopAllBoxActionByRow(row)
                self.ui_:BlinkBox(row)
            end
            break
        end
    end
    self.ui_:setReward(params.lBonusCellScore, totalRatio)
end

function JSFYTreasure:show(parent, params, callback, isConnect)
    -- params = {ratios={10, 60, 0, 0}, base=200}
    self.parent_ = parent
    self.isAutoOpenBox = (parent.bet_.leftTimes_ == "forever")
    self:close(params.lWinScore)
    JSFYSound.playBGM(JSFYSound.BGM.TREASURE)
    self.ui_ = TreasureUI.new()
    self:DealOpenBoxData(params, callback, isConnect)
    self.ui_:addBoxClickCallback(function(row, col)
        self.ui_:stopAllBoxActionByRow(row)
        self.isAutoOpenBox = false
        GameMessage.sendBoxSelect(row - 1, col - 1)
    end)
    self.ui_:addTo(parent)
    self.parent_ = parent
    -- self.ui_:setReward(params.base, totalRatio)
end

function JSFYTreasure:close(score)
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
    self.parent_:updateWinScore(score)
end

return JSFYTreasure
