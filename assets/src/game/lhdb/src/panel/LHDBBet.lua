--[[
LHDBBet.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBMessage = require("game.lhdb.src.LHDBMessage")
local LHDBSound = require("game.lhdb.src.LHDBSound")
local LHDBMsgBox = require "game.lhdb.src.panel.LHDBMsgBox"

local PREFIX = "Game/LHDB/Scene/"

local Key = class("Key")

function Key:ctor(root)
    self.root_ = root
    self.rootSize_ = self.root_:getContentSize()
    self.isOpen_ = nil
    self:switch(false)
end

function Key:setCount(count)
    local text = self.root_:getChildByName("text")
    text:setString(GameUtil.formatAsset(count))
    local size = self.root_:getChildByName("text"):getContentSize()
    local scale = 60 / size.width
    scale = scale > 1 and 1 or scale
    text:setScale(scale)
end

function Key:switch(open)
    self.root_:getChildByName("text"):setVisible(open)
    self.root_:getChildByName("02"):setVisible(not open)

    if open and not self.isOpen_ then
        local anims = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_yaoshi.csb")
        local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_yaoshi.csb")
        action:gotoFrameAndPlay(0, false)
        anims:runAction(action)
        anims:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.RemoveSelf:create()))
        anims:move(self.rootSize_.width / 2, self.rootSize_.height / 2):addTo(self.root_)
    end
    self.isOpen_ = open
end

-----------------------------------------------------------------------------------------------------------
local AutoPanel = class("AutoPanel")

local AutoType = {
    MANUAL = 1,
    TWENTY = 20,
    FIFTY = 50,
    HUANDRED = 100,
    FOREVER = -1
}

function AutoPanel:ctor(root)
    self.root_ = root

    local function onTouchBegan(touch, event)
        self:show(false)
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.root_:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.root_)
end

function AutoPanel:show(visible)
    self.root_:setVisible(visible)
end

function AutoPanel:isVisible()
    return self.root_:isVisible()
end

function AutoPanel:addClickCallback(callback)
    local imgBg = self.root_:getChildByName("img_atuoBg")
    for k, v in pairs(AutoType) do
        local btn = imgBg:getChildByName("Auto_" .. v)
        if btn then
            btn:addClickEventListener(handler(v, callback))
        end
    end
end
-----------------------------------------------------------------------------------------------------------
local LHDBBet = class("LHDBBet")

LHDBBet.AutoType = AutoType

local AutoButtons = {
    [LHDBBet.AutoType.MANUAL] = {PREFIX .. "but_KaiShi_01.png", PREFIX .. "but_KaiShi_02.png"},
    [LHDBBet.AutoType.TWENTY] = {PREFIX .. "but_ZiDong_01.png", PREFIX .. "but_ZiDong_02.png"},
    [LHDBBet.AutoType.FIFTY] = {PREFIX .. "but_ZiDong_01.png", PREFIX .. "but_ZiDong_02.png"},
    [LHDBBet.AutoType.HUANDRED] = {PREFIX .. "but_ZiDong_01.png", PREFIX .. "but_ZiDong_02.png"},
    [LHDBBet.AutoType.FOREVER] = {PREFIX .. "but_WuXian_01.png", PREFIX .. "but_WuXian_02.png"}
}

local function AddSubCallback(root, addCall, subCall)
    root:getChildByName("btn_add"):addClickEventListener(addCall)
    root:getChildByName("btn_sub"):addClickEventListener(subCall)
end

local function enableAddSubTouchable(root, enable)
    root:getChildByName("btn_add"):setTouchEnabled(enable)
    root:getChildByName("btn_sub"):setTouchEnabled(enable)
end

local function getSldPercent(self, betCount, minVal, maxVal)
    betCount = betCount < minVal and minVal or (betCount > maxVal and maxVal or betCount)
    return (betCount - minVal) * 80 / (maxVal - minVal) + 10
end

local function getSldCount(self, percent, minVal, maxVal)
    percent = percent < 10 and 10 or (percent > 90 and 90 or percent)
    local count = (percent - 10) / 80 * (maxVal - minVal) + minVal
    count = math.floor(count / minVal) * minVal
    return count
end

local function initBetsLines(self)
    local pnlLines = self.root_:getChildByName("pnl_lines")
    AddSubCallback(pnlLines, function()
        LHDBSound.clickButton()
        if self.lines_ + 1 > GameCMD.MAX_BET_LINES then
            return
        end
        self:setLines(self.lines_ + 1)
    end, function()
        LHDBSound.clickButton()
        if self.lines_ - 1 <= 0 then
            return
        end
        self:setLines(self.lines_ - 1)
    end)

    local pnlBet = self.root_:getChildByName("pnl_bets")
    AddSubCallback(pnlBet, function()
        LHDBSound.clickButton()
        if self.betCount_ + self.minBet_ > self.maxBet_ then
            return
        end
        self:setBetCount(self.betCount_ + self.minBet_)
    end, function()
        LHDBSound.clickButton()
        if self.betCount_ - self.minBet_ < self.minBet_ then
            return
        end
        self:setBetCount(self.betCount_ - self.minBet_)
    end)
    self.sldBets_ = pnlBet:getChildByName("sld_bets")
    self.sldBets_:addEventListener(function(pSender, eventTyp)
        local percent = pSender:getPercent()
        percent = percent < 10 and 10 or (percent > 90 and 90 or percent)
        self.sldBets_:setPercent(percent)

        self:setBetCount(getSldCount(self, percent, self.minBet_, self.maxBet_), eventTyp ~= ccui.SliderEventType.slideBallUp)
    end)
end

local function initSpeed(self)
    local pnlBet = self.root_:getChildByName("pnl_speed")
    AddSubCallback(pnlBet, function()
        LHDBSound.clickButton()
        self:setSpeedFactor(self.speedFactor_ + 1)
    end, function()
        LHDBSound.clickButton()
        self:setSpeedFactor(self.speedFactor_ - 1)
    end)
    self.sldSpeed_ = pnlBet:getChildByName("sld_speed")
    self.sldSpeed_:addEventListener(function(pSender, eventTyp)
        local percent = pSender:getPercent()
        percent = percent < 10 and 10 or (percent > 90 and 90 or percent)
        self.sldSpeed_:setPercent(percent)
        self:setSpeedFactor(getSldCount(self, percent, 1, GameCMD.MAX_SPEED), eventTyp ~= ccui.SliderEventType.slideBallUp)
    end)
end

local function initAutoBet(self)
    local btnStart = self.root_:getChildByName("btn_start")
    btnStart:addTouchEventListener(function(pSender, touchType)
        if touchType == ccui.TouchEventType.began then
            LHDBSound.clickButton()
            if self.autoType_ == LHDBBet.AutoType.MANUAL then
                if not self.autoPnl_:isVisible() then
                    pSender:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                        self.autoPnl_:show(true)
                    end)))
                end
            end
        elseif touchType == ccui.TouchEventType.ended then
            if self.autoType_ == LHDBBet.AutoType.MANUAL then
                pSender:stopAllActions()
                if not self.autoPnl_:isVisible() then
                    if not self:sendBet() then
                        return
                    end
                    self:enableBetsAndLines(false)
                    self:enableBet(false)
                end
            else
                self:enableBetsAndLines(false)
                self:enableBet(false)
                self:setBetAutoType(LHDBBet.AutoType.MANUAL)
                self:setBetAutoLeft()
            end
        end
    end)
end

function LHDBBet:ctor(root)
    self.root_ = root

    self.keys_ = {}
    local pnlKeys = self.root_:getChildByName("pnl_keys")
    for i = 1, GameCMD.MAX_BET_LINES do
        self.keys_[i] = Key.new(pnlKeys:getChildByName(string.format("Key%d", i)))
    end
    initBetsLines(self)
    initSpeed(self)

    self.autoPnl_ = AutoPanel.new(self.root_:getChildByName("node_auto"))
    self.autoPnl_:addClickCallback(function(autoTyp)
        LHDBSound.clickButton()
        self.autoPnl_:show(false)
        self:enableBetsAndLines(false)
        self:setBetAutoType(autoTyp)

        local nums = autoTyp
        self.leftTimes_ = nums
        self:setBetAutoLeft(self.leftTimes_)
        self:autoBet()
    end)
    self.autoPnl_:show(false)
    initAutoBet(self)

    self:init{
        minBet = 200,
        maxBet = 4000
    }

    self:setSpeedFactor(1)
    self:setLines(1)
    self:setBetCount(self.minBet_)
    self.leftTimes_ = 0
    self:setBetAutoType(LHDBBet.AutoType.MANUAL)
end

function LHDBBet:startBetCallback(callback)
    self.startBetCallback_ = callback
end

function LHDBBet:init(args)
    self.minBet_ = args.minBet
    self.maxBet_ = args.maxBet

    self:setBetCount(self.minBet_)
end

function LHDBBet:setLines(lines)
    if not lines or type(lines) ~= "number" then
        return
    end

    self.lines_ = lines
    for i, key in ipairs(self.keys_) do
        key:switch(i <= lines)
    end
    self.root_:getChildByName("pnl_lines"):getChildByName("txt_lines"):setString(lines)
end

function LHDBBet:setBetCount(count, ignoreVarify)
    if not count or type(count) ~= "number" then
        return
    end

    self.betCount_ = count
    for i, key in ipairs(self.keys_) do
        key:setCount(self.betCount_)
    end
    self.root_:getChildByName("pnl_bets"):getChildByName("txt_bets"):setString(GameUtil.formatAsset(count))
    if not ignoreVarify then
        self.sldBets_:setPercent(getSldPercent(self, count, self.minBet_, self.maxBet_))
    end
end

function LHDBBet:setSpeedFactor(factor, ignoreVarify)
    self.speedFactor_ = factor < 1 and 1 or (factor > GameCMD.MAX_SPEED and GameCMD.MAX_SPEED or factor)
    self.root_:getChildByName("pnl_speed"):getChildByName("txt_speed"):setString("X" .. self.speedFactor_)
    if not ignoreVarify then
        self.sldSpeed_:setPercent(getSldPercent(self, self.speedFactor_, 1, GameCMD.MAX_SPEED))
    end
end

function LHDBBet:enableBetsAndLines(enable)
    enableAddSubTouchable(self.root_:getChildByName("pnl_lines"), enable)
    enableAddSubTouchable(self.root_:getChildByName("pnl_bets"), enable)
    self.root_:getChildByName("pnl_bets"):getChildByName("sld_bets"):setTouchEnabled(enable)
end

function LHDBBet:enableBet(enable)
    local btnStart = self.root_:getChildByName("btn_start")
    btnStart:setTouchEnabled(enable)
    btnStart:setBright(enable)
end

function LHDBBet:setBetAutoType(autoTyp)
    self.autoType_ = autoTyp
    local btnStart = self.root_:getChildByName("btn_start")
    local btnTextures = AutoButtons[autoTyp]
    if btnTextures then
        btnStart:loadTextures(btnTextures[1], btnTextures[2], nil, ccui.TextureResType.plistType)
    end
end

function LHDBBet:setBetAutoLeft(leftTime)
    local btnStart = self.root_:getChildByName("btn_start")
    local txtNum = btnStart:getChildByName("txt_num")
    if self.autoType_ ~= LHDBBet.AutoType.MANUAL and self.autoType_ ~= LHDBBet.AutoType.FOREVER then
        txtNum:setString(leftTime)
    else
        txtNum:setString("")
    end
end

function LHDBBet:getSpeedFactor()
    return self.speedFactor_
end

function LHDBBet:sendBet()
    if not self:regulateBet() then
        return false
    end
    if self.startBetCallback_ then
        self.startBetCallback_()
    end
    LHDBMessage.sendBetCount(self.betCount_, self.lines_)
    return true
end

function LHDBBet:getBetAndLines()
    return self.betCount_, self.lines_
end

function LHDBBet:autoBet()
    if self.autoType_ == LHDBBet.AutoType.MANUAL then
        self:enableBet(true)
        self:enableBetsAndLines(true)
    elseif self.autoType_ == LHDBBet.AutoType.FOREVER then
        local rlt = self:sendBet()
        if not rlt then
            self:resetBet()
            return
        end
    else
        if self.leftTimes_ <= 0 then
            self:resetBet()
            return
        end
        if not self:sendBet() then
            self:resetBet()
            return
        end
    end
    return true
end

function LHDBBet:regulateBet()
    if globalUserInfo.lUserScore < self.betCount_ * self.lines_ then
        self:setBetCount(self.minBet_)
        self:setLines(1)
        if globalUserInfo.lUserScore < self.minBet_ then
            LHDBMsgBox:show(display.getRunningScene(), {
                minBet = self.minBet_
            })
            return false
        else
            local seq = cc.Sequence:create(cc.Show:create(), cc.DelayTime:create(1.0), cc.Hide:create())
            self.root_:getChildByName("img_lackTips"):runAction(seq)
        end
    end
    return true
end

function LHDBBet:receiptBet()
    if self.autoType_ ~= LHDBBet.AutoType.MANUAL and self.autoType_ ~= LHDBBet.AutoType.FOREVER then
        self.leftTimes_ = self.leftTimes_ - 1
        self.leftTimes_ = self.leftTimes_ >= 0 and self.leftTimes_ or 0
        self:setBetAutoLeft(self.leftTimes_)
    end
end

function LHDBBet:resetBet()
    self.leftTimes_ = 0
    self:setBetAutoType(LHDBBet.AutoType.MANUAL)
    self:setBetAutoLeft()
    self:enableBetsAndLines(true)
    self:enableBet(true)
end

return LHDBBet
