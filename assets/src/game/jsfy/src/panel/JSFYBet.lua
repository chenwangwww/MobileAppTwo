--[[
JSFYBet.lua
]] local GameCMD = require("game.jsfy.src.JSFYCMD")
local GameMessage = require("game.jsfy.src.JSFYMessage")

local JSFYBet = class("JSFYBet")

JSFYBet.State = {
    NORMAL = 0,
    FREE = 1,
    AUTO = 2,
    GXFC = 3
}

local BetConfigs = {
    [JSFYBet.State.NORMAL] = {
        normal = GameCMD.RES_PATH .. "scene/js_star1.png",
        press = GameCMD.RES_PATH .. "scene/js_star2.png"
    },
    [JSFYBet.State.FREE] = {
        normal = GameCMD.RES_PATH .. "scene/js_free2.png"
    },
    [JSFYBet.State.AUTO] = {
        normal = GameCMD.RES_PATH .. "scene/js_free1.png",
        press = GameCMD.RES_PATH .. "scene/js_free1.png"
    },
    [JSFYBet.State.GXFC] = {
        normal = GameCMD.RES_PATH .. "scene/js_free1.png"
    }
}

local function initBet(self)
    local btnBet = self.root_:getChildByName("Button_Bet")
    btnBet:addTouchEventListener(function(pSender, touchType)
        if touchType == ccui.TouchEventType.began then
            if self.state_ == JSFYBet.State.NORMAL then
                pSender:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                    pSender.beganState = self.state_
                    self:changeStatus(JSFYBet.State.AUTO, "forever")
                    self:autoBet(false)
                end)))
            end
        elseif touchType == ccui.TouchEventType.ended then
            pSender:stopAllActions()
            if self.state_ == JSFYBet.State.NORMAL then
                if not self:sendBet() then
                    return
                end
                self:enableBet(false)
                self:enableRotate(false)
            elseif not pSender.beganState then
                self:changeStatus(JSFYBet.State.NORMAL)
                self:enableBet(false)
                self:enableRotate(false)
            end
            pSender.beganState = nil
        end
    end)
end

local function initAddSub(self)
    self.root_:getChildByName("Button_AddBet"):addClickEventListener(function()
        local index = table.indexof(self.lineBets_, self.lineBet_)
        self.lineBet_ = self.lineBets_[index + 1] or self.lineBets_[1]
        self:setBetCount(self:getLineBet(), self:getBetCount())
    end)
    self.root_:getChildByName("Button_SubBet"):addClickEventListener(function()
        local index = table.indexof(self.lineBets_, self.lineBet_)
        self.lineBet_ = self.lineBets_[index - 1] or self.lineBets_[#self.lineBets_]
        self:setBetCount(self:getLineBet(), self:getBetCount())
    end)
end

function JSFYBet:ctor(root)
    self.root_ = root

    local bmfAmount = self.root_:getChildByName("Text_BetLine")
    bmfAmount:setString(SubLang:word(4))

    self:setBetCount(0, 0)
    initBet(self)
    initAddSub(self)

    self.cacheStatus_ = {}
    self.lineBets_ = {}
    self:changeStatus(JSFYBet.State.NORMAL)
    self:enableRotate(false)
end

function JSFYBet:addBetCallback(callback)
    self.betCallback_ = callback
end

function JSFYBet:loadBetConfig(args)
    self.lineBets_ = {}
    -- 押线数
    self.lineNum_ = GameCMD.MAX_LINE -- 30
    for i = 1, 5 do
        self.lineBets_[i] = args.lCellScore * args.wMultiCell[i]
    end
    -- 单线押注
    self.lineBet_ = args.lBonusCellScore

    self:setBetCount(self:getLineBet(), self:getBetCount())
    -- self:updateWinJackpot(args.lGoldPool)
end

function JSFYBet:updateWinJackpot(jackpot)
    local wins = {}
    for i, lineBet in ipairs(self.lineBets_) do
        -- jackpot * 0.5 * curr_bet/max_bet
        local winJP = lineBet / self.lineBets_[#self.lineBets_] * 0.5 * jackpot
        table.insert(wins, {
            bet = lineBet * self.lineNum_,
            win = winJP
        })
    end
end

function JSFYBet:getLineBet()
    return self.lineBet_
end

function JSFYBet:getBetCount()
    return self.lineBet_ * self.lineNum_
end

local function setStatus(self, state, left)
    local btnBet = self.root_:getChildByName("Button_Bet")
    btnBet:resetNormalRender()
    btnBet:resetPressedRender()
    btnBet:resetDisabledRender()
    local config = BetConfigs[state]
    local stateFunc = {
        [JSFYBet.State.NORMAL] = function()
            btnBet:loadTextures(config.normal, config.press, nil, ccui.TextureResType.plistType)
        end,
        [JSFYBet.State.FREE] = function()
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            self:enableRotate(false)
        end,
        [JSFYBet.State.AUTO] = function()
            self:enableRotate(true)
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            btnBet:loadTexturePressed(config.press, ccui.TextureResType.plistType)
        end,
        [JSFYBet.State.GXFC] = function()
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            self:enableRotate(false)
        end
    }
    self.state_ = state
    self.leftTimes_ = left
    if stateFunc[state] then
        stateFunc[state]()
    end
    self:setLeftTimes(self.leftTimes_)
end

function JSFYBet:changeStatus(state, left)
    if self.state_ ~= state then
        table.insert(self.cacheStatus_, {
            state = self.state_,
            left = self.leftTimes_
        })
    end
    setStatus(self, state, left)
end

function JSFYBet:getBetStatus()
    return self.state_, self.leftTimes_
end

function JSFYBet:setLeftTimes(left)
    local btnBet = self.root_:getChildByName("Button_Bet")
    local forever = self.state_ == JSFYBet.State.AUTO and type(left) == "string"
    btnBet:getChildByName("atls_freeAmount"):setString(forever and "" or left)
end

function JSFYBet:setBetCount(linecount, Sumcount)
    local bmfAmount = self.root_:getChildByName("Text_BetScore")
    bmfAmount:setString(linecount)

    local SumAmount = self.root_:getChildByName("Text_SumBet")
    SumAmount:setString(Sumcount)
end

function JSFYBet:enableRotate(enable)
    local btnBet = self.root_:getChildByName("Button_Bet")
    btnBet:setTouchEnabled(enable)
    if self.state_ == JSFYBet.State.NORMAL then
        btnBet:setBright(enable)
    else
        btnBet:setBright(true)
    end
end

function JSFYBet:enableBet(enable)
    local btnAdd = self.root_:getChildByName("Button_AddBet")
    btnAdd:setTouchEnabled(enable)
    btnAdd:setBright(enable)
    local btnSub = self.root_:getChildByName("Button_SubBet")
    btnSub:setTouchEnabled(enable)
    btnAdd:setBright(enable)
    btnSub:setBright(enable)
end

function JSFYBet:regulateBet()
    if globalUserInfo.lUserScore < self:getBetCount() then
        PlazaManager.showConfirmNode("ok", SubLang:word(3), nil)
        return false
    end
    return true
end

function JSFYBet:sendBet()
    if not self:regulateBet() then
        return false
    end
    if self.betCallback_ then
        self.betCallback_(self.state_)
    end
    if self.state_ == JSFYBet.State.NORMAL or self.state_ == JSFYBet.State.AUTO then
        GameMessage.sendCardScroll(self.lineBet_, self.lineNum_)
    elseif self.state_ == JSFYBet.State.FREE or self.state_ == JSFYBet.State.GXFC then
        GameMessage.sendBonusScroll()
    end
    return true
end

function JSFYBet:autoBet(isOpenedBox)
    if self.state_ == JSFYBet.State.NORMAL then
        self:enableRotate(true)
        self:enableBet(true)
    elseif self.leftTimes_ == "forever" then
        self:enableBet(false)
        local temp_time = 0
        if isOpenedBox == true then
            temp_time = 1
        end
        self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(temp_time), cc.CallFunc:create(function()
            local rlt = self:sendBet()
            if not rlt then
                self:resetBet()
                return
            end
        end)))

    else
        -- 次数用完，恢复上次的选择
        if self.leftTimes_ <= 0 then
            if next(self.cacheStatus_) then
                local lastStatus = self.cacheStatus_[#self.cacheStatus_]
                table.remove(self.cacheStatus_)
                setStatus(self, lastStatus.state, lastStatus.left)
                self:autoBet(false)
            else
                self:resetBet()
            end
            return
        end
        self:enableBet(false)
        if not self:sendBet() then
            self:resetBet()
            return
        end
    end
    return true
end

function JSFYBet:receiptBet()
    if type(self.leftTimes_) == "number" then
        self.leftTimes_ = self.leftTimes_ - 1
        self.leftTimes_ = self.leftTimes_ >= 0 and self.leftTimes_ or 0
        self:setLeftTimes(self.leftTimes_)
    end
end

function JSFYBet:resetBet()
    self.leftTimes_ = 0
    self.cacheStatus_ = {}
    setStatus(self, JSFYBet.State.NORMAL)
    self:enableRotate(true)
    self:enableBet(true)
end

return JSFYBet
