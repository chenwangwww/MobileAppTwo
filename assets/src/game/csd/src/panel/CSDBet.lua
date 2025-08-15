--[[
CSDBet.lua
]] local GameCMD = require("game.csd.src.CSDCMD")
local GameMessage = require("game.csd.src.CSDMessage")

local Bit = class("Bit")

local BIT_MAX = 5

function Bit:ctor(root)
    self.root_ = root
    local function onTouchBegan(touch, event)
        self:show(false)
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.root_:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.root_)

    self.imgBg_ = self.root_:getChildByName("img_bg")
end

function Bit:load(bits)
    for i = 1, BIT_MAX do
        local pnl = self.imgBg_:getChildByName("bit_panle_" .. i - 1)
        local bit = bits[i] or {}
        if pnl then
            pnl:getChildByName("bti_amont2"):setString(bit.bet or 0)
            pnl:getChildByName("max_jp"):setString(math.floor(bit.win or 0))
        end
    end
end

function Bit:show(visible)
    self.root_:setVisible(visible)
end

function Bit:markCurrent(index)
    for i = 1, BIT_MAX do
        local pnl = self.imgBg_:getChildByName("bit_panle_" .. i - 1)
        pnl:getChildByName("bit_flag"):setVisible(index == i)
    end
end
-----------------------------------------------------------------------------------
local AutoPanel = class("AutoPanel")

local AutoType = {
    TWENTY = 20,
    FIFTY = 50,
    HUANDRED = 100,
    FOREVER = "forever"
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

    self.btns_ = {}
    self.btns_[AutoType.TWENTY] = self.root_:getChildByName("btn_max_0")
    self.btns_[AutoType.FIFTY] = self.root_:getChildByName("btn_max_1")
    self.btns_[AutoType.HUANDRED] = self.root_:getChildByName("btn_max_2")
    self.btns_[AutoType.FOREVER] = self.root_:getChildByName("btn_max_3")

    for k, v in pairs(self.btns_) do
        v:setScale9Enabled(false)
    end
end

function AutoPanel:show(visible)
    self.root_:setVisible(visible)
end

function AutoPanel:isVisible()
    return self.root_:isVisible()
end

function AutoPanel:addClickCallback(callback)
    for typ, btn in pairs(self.btns_) do
        btn:addClickEventListener(handler(typ, callback))
    end
end

-----------------------------------------------------------------------------------

local CSDBet = class("CSDBet")

CSDBet.State = {
    NORMAL = 0,
    FREE = 1,
    AUTO = 2,
    GXFC = 3
}

local BetConfigs = {
    [CSDBet.State.NORMAL] = {
        normal = "but_XuanZhuan_01.png",
        press = "but_XuanZhuan_02.png",
        disable = "but_XuanZhuan_03.png"
    },
    [CSDBet.State.FREE] = {
        normal = "Img_XuanZhuan_WuXian01.png",
        fnt = "fnt/mianfei.txt.fnt"
    },
    [CSDBet.State.AUTO] = {
        normal = "but_XuanZhuan_ZiDong01.png",
        press = "but_XuanZhuan_ZiDong02.png",
        fnt = "fnt/zidongxuanzhuan.txt.fnt"
    },
    [CSDBet.State.GXFC] = {
        normal = "but_GongXiFaCai.png",
        fnt = "fnt/caishenjiangli.txt.fnt"
    }
}

local function initBet(self)
    local btnBet = self.nodeBet_:getChildByName("btn_bet")
    btnBet:addTouchEventListener(function(pSender, touchType)
        if touchType == ccui.TouchEventType.began then
            if self.state_ == CSDBet.State.NORMAL then
                if not self.autoPnl_:isVisible() then
                    pSender:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                        self.autoPnl_:show(true)
                    end)))
                end
            end
        elseif touchType == ccui.TouchEventType.ended then
            if self.state_ == CSDBet.State.NORMAL then
                pSender:stopAllActions()
                if not self.autoPnl_:isVisible() then
                    if not self:sendBet() then
                        return
                    end
                    self:enableBet(false)
                    self:enableRotate(false)
                end
            else
                self:changeStatus(CSDBet.State.NORMAL)
                self:enableBet(false)
                self:enableRotate(false)
            end
        end
    end)
end

local function initAddSub(self)
    self.imgBit_:getChildByName("btn_plus"):addClickEventListener(function()
        local index = table.indexof(self.lineBets_, self.lineBet_)
        self.lineBet_ = self.lineBets_[index + 1] or self.lineBets_[1]
        self:setBetCount(self:getBetCount())
        self.bit_:show(true)
    end)
    self.imgBit_:getChildByName("btn_less"):addClickEventListener(function()
        local index = table.indexof(self.lineBets_, self.lineBet_)
        self.lineBet_ = self.lineBets_[index - 1] or self.lineBets_[#self.lineBets_]
        self:setBetCount(self:getBetCount())
        self.bit_:show(true)
    end)
end

function CSDBet:ctor(root)
    self.root_ = root

    self.nodeBet_ = self.root_:getChildByName("node_bet")
    self.imgBit_ = self.root_:getChildByName("img_bit")
    self.imgBit_:getChildByName("bmf_amont"):setString("")
    initBet(self)
    initAddSub(self)

    self.autoPnl_ = AutoPanel.new(self.nodeBet_:getChildByName("node_auto"))
    self.autoPnl_:addClickCallback(function(autoTyp)
        self.autoPnl_:show(false)
        self:changeStatus(CSDBet.State.AUTO, autoTyp)
        self:autoBet()
    end)
    self.autoPnl_:show(false)

    self.bit_ = Bit.new(self.root_:getChildByName("node_bit"))
    self.bit_:show(false)

    self.cacheStatus_ = {}
    self.lineBets_ = {}
    self:changeStatus(CSDBet.State.NORMAL)
    self:enableRotate(false)
end

function CSDBet:addBetCallback(callback)
    self.betCallback_ = callback
end

function CSDBet:loadBetConfig(args)
    self.lineBets_ = {}
    -- 押线数
    self.lineNum_ = GameCMD.MAX_LINE -- 25
    for i = 1, 5 do
        self.lineBets_[i] = args.lCellScore * args.wMultiCell[i]
    end
    -- 单线押注
    self.lineBet_ = table.indexof(self.lineBets_, args.lBonusCellScore) and args.lBonusCellScore or self.lineBets_[1]

    self:setBetCount(self:getBetCount())
    self:updateWinJackpot(args.lGoldPool)
    self.bit_:show(true)
end

function CSDBet:updateWinJackpot(jackpot)
    local wins = {}
    for i, lineBet in ipairs(self.lineBets_) do
        -- jackpot * 0.5 * curr_bet/max_bet
        local winJP = lineBet / self.lineBets_[#self.lineBets_] * 0.5 * jackpot
        table.insert(wins, {
            bet = lineBet * self.lineNum_,
            win = winJP
        })
    end
    self.bit_:load(wins)
end

function CSDBet:getLineBet()
    return self.lineBet_
end

function CSDBet:getBetCount()
    return self.lineBet_ * self.lineNum_
end

local function setStatus(self, state, left)
    local btnBet = self.nodeBet_:getChildByName("btn_bet")
    btnBet:resetNormalRender()
    btnBet:resetPressedRender()
    btnBet:resetDisabledRender()
    btnBet:getChildByName("img_forever"):hide()
    local bmf = btnBet:getChildByName("bmf_num")
    bmf:setString("")
    local config = BetConfigs[state]
    local stateFunc = {
        [CSDBet.State.NORMAL] = function()
            btnBet:loadTextures(config.normal, config.press, config.disable, ccui.TextureResType.plistType)
        end,
        [CSDBet.State.FREE] = function()
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            self:enableRotate(false)
            bmf:setFntFile(GameCMD.RES_PATH .. config.fnt)
        end,
        [CSDBet.State.AUTO] = function()
            self:enableRotate(true)
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            btnBet:loadTexturePressed(config.press, ccui.TextureResType.plistType)
            bmf:setFntFile(GameCMD.RES_PATH .. config.fnt)
        end,
        [CSDBet.State.GXFC] = function()
            btnBet:loadTextureNormal(config.normal, ccui.TextureResType.plistType)
            self:enableRotate(false)
            bmf:setFntFile(GameCMD.RES_PATH .. config.fnt)
        end
    }
    self.state_ = state
    self.leftTimes_ = left
    if stateFunc[state] then
        stateFunc[state]()
    end
    self:setLeftTimes(self.leftTimes_)
end

function CSDBet:changeStatus(state, left)
    if self.state_ ~= state then
        table.insert(self.cacheStatus_, {
            state = self.state_,
            left = self.leftTimes_
        })
    end
    setStatus(self, state, left)
end

function CSDBet:getBetStatus()
    return self.state_, self.leftTimes_
end

function CSDBet:setLeftTimes(left)
    local btnBet = self.nodeBet_:getChildByName("btn_bet")
    local forever = self.state_ == CSDBet.State.AUTO and type(left) == "string"
    btnBet:getChildByName("bmf_num"):setString(forever and "" or left)
    btnBet:getChildByName("img_forever"):setVisible(forever)
end

function CSDBet:setBetCount(count)
    local bmfAmount = self.imgBit_:getChildByName("bmf_amont")
    bmfAmount:setString(count)

    self.bit_:markCurrent(table.indexof(self.lineBets_, self.lineBet_))
end

function CSDBet:enableRotate(enable)
    local btnBet = self.nodeBet_:getChildByName("btn_bet")
    btnBet:setTouchEnabled(enable)
    if self.state_ == CSDBet.State.NORMAL then
        btnBet:setBright(enable)
    else
        btnBet:setBright(true)
    end
end

function CSDBet:enableBet(enable)
    local btnAdd = self.imgBit_:getChildByName("btn_plus")
    btnAdd:setTouchEnabled(enable)
    btnAdd:setBright(enable)
    local btnSub = self.imgBit_:getChildByName("btn_less")
    btnSub:setTouchEnabled(enable)
    btnAdd:setBright(enable)
    btnSub:setBright(enable)
end

function CSDBet:regulateBet()
    if globalUserInfo.lUserScore < self:getBetCount() then
        PlazaManager.showConfirmNode("ok", SubLang:word(1), nil)
        return false
    end
    return true
end

function CSDBet:sendBet()
    if not self:regulateBet() then
        return false
    end
    if self.betCallback_ then
        self.betCallback_(self.state_)
    end
    if self.state_ == CSDBet.State.NORMAL or self.state_ == CSDBet.State.AUTO then
        GameMessage.sendCardScroll(self.lineBet_, self.lineNum_)
    elseif self.state_ == CSDBet.State.FREE or self.state_ == CSDBet.State.GXFC then
        GameMessage.sendBonusScroll()
    end
    return true
end

function CSDBet:autoBet()
    if self.state_ == CSDBet.State.NORMAL then
        self:enableRotate(true)
        self:enableBet(true)
    elseif self.leftTimes_ == AutoType.FOREVER then
        self.bit_:show(false)
        self:enableBet(false)
        local rlt = self:sendBet()
        if not rlt then
            self:resetBet()
            return
        end
    else
        -- 次数用完，恢复上次的选择
        if self.leftTimes_ <= 0 then
            if next(self.cacheStatus_) then
                local lastStatus = self.cacheStatus_[#self.cacheStatus_]
                table.remove(self.cacheStatus_)
                setStatus(self, lastStatus.state, lastStatus.left)
                self:autoBet()
            else
                self:resetBet()
            end
            return
        end
        self.bit_:show(false)
        self:enableBet(false)
        if not self:sendBet() then
            self:resetBet()
            return
        end
    end
    return true
end

function CSDBet:receiptBet()
    if type(self.leftTimes_) == "number" then
        self.leftTimes_ = self.leftTimes_ - 1
        self.leftTimes_ = self.leftTimes_ >= 0 and self.leftTimes_ or 0
        self:setLeftTimes(self.leftTimes_)
    end
end

function CSDBet:resetBet()
    self.leftTimes_ = 0
    self.cacheStatus_ = {}
    setStatus(self, CSDBet.State.NORMAL)
    self:enableRotate(true)
    self:enableBet(true)
end

return CSDBet
