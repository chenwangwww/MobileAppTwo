local BankWinUI = class("BankWinUI", require("app.win.base.GameWindowBase"))

local BankNodeSave = require "app.win.bank.BankNodeSave"
local BankNodeGiveGoal = require "app.win.bank.BankNodeGiveGoal"
local BankNodeMoneyBack = require "app.win.bank.BankNodeMoneyBack"
local BankNodeModiPass = require "app.win.bank.BankNodeModiPass"
local BankNodeCardRecharge = require "app.win.bank.BankNodeCardRecharge"

function BankWinUI:ctor()
    local winSize = cc.size(1160, 670)
    BankWinUI.super.ctor(self, winSize, true)
    self:setName("BankWinUI")

    self:addBasePanel()
    self:addPanelTitle(LangCtrl:getLang().word128)
    self:addCloseBtn()

    local tabsize = cc.size(260, 575)
    local tabcx = tabsize.width / 2
    local leftNode = cc.Node:create()
    leftNode:setContentSize(tabsize)
    leftNode:align(display.LEFT_BOTTOM, 25, 15):addTo(self.panelNode)

    self.rightSize = cc.size(825, 575)
    self.rightNode = cc.Node:create()
    self.rightNode:setContentSize(self.rightSize)
    self.rightNode:align(display.RIGHT_BOTTOM, self.winSize.width - 25, 15):addTo(self.panelNode)

    self.tablist = {{
        tabname = LangCtrl:getLang().word129,
        tabbtn = nil,
        tablbl = nil
    }, {
        tabname = LangCtrl:getLang().word130,
        tabbtn = nil,
        tablbl = nil
    }, {
        tabname = LangCtrl:getLang().word131,
        tabbtn = nil,
        tablbl = nil
    }, {
        tabname = LangCtrl:getLang().word132,
        tabbtn = nil,
        tablbl = nil
    }, {
        tabname = LangCtrl:getLang().word133,
        tabbtn = nil,
        tablbl = nil
    }}

    -- local color = cc.c3b(240, 223, 244)
    local btn_res1 = "app/common/button/left_tab1.png"
    local btn_res2 = "app/common/button/left_tab2.png" -- 254 102
    local labpos = cc.p(127, 51)
    self.btncolor1, self.btncolor2 = cc.c3b(0x87, 0x7b, 0x6b), cc.c3b(250, 247, 212) -- cc.c3b(72, 42, 16)
    for k, tab in ipairs(self.tablist) do
        local function onChooseClicked(btn)
            PlazaManager.playClickEffect()
            self:doChooseTab(btn.tabvalue)
        end

        local tabbtn = ccui.Button:create(btn_res1, btn_res1, btn_res2)
        local tablbl = GameUtil.createLabel(tab.tabname, 40, self.btncolor1, display.CENTER, labpos, GameDefine.FontName):addTo(tabbtn)
        tablbl:enableOutline(cc.c4b(98, 90, 77), 2)
        -- tablbl:enableBold()
        tabbtn:align(display.CENTER, tabcx, tabsize.height - 55 - (k - 1) * 115):addTo(leftNode)
        tabbtn.tabvalue = k
        tabbtn:addClickEventListener(onChooseClicked)
        self.tablist[k].tabbtn = tabbtn
        self.tablist[k].tablbl = tablbl
    end

    local tabIdx = cc.UserDefault:getInstance():getIntegerForKey("BankWinShowViewName", 1)
    self:doChooseTab(tabIdx)
end

function BankWinUI:doChooseTab(idx)
    for i, v in ipairs(self.tablist) do
        if i == idx then
            v.tabbtn:setEnabled(false)
            v.tablbl:setColor(self.btncolor2)
            v.tablbl:enableOutline(cc.c4b(68, 59, 52, 255), 1)
        else
            v.tabbtn:setEnabled(true)
            v.tablbl:setColor(self.btncolor1)
            v.tablbl:enableOutline(cc.c4b(98, 90, 77, 255), 2)
        end
    end

    local refresh = false
    if self.rightNode:getChildByName("BankNodeMoneyBack") ~= nil then
        if self.rightNode:getChildByName("BankNodeMoneyBack"):getTakeChk() == true then
            refresh = true
        end
    end

    self.rightNode:removeAllChildren()

    if idx == 1 then -- 金币存取
        local winui = BankNodeSave.new(self)
        winui:align(display.LEFT_BOTTOM, 0, 0):addTo(self.rightNode)
    elseif idx == 2 then -- 金币赠送
        local winui = BankNodeGiveGoal.new(self)
        winui:align(display.LEFT_BOTTOM, 0, 0):addTo(self.rightNode)
    elseif idx == 3 then -- 流水返点
        local winui = BankNodeMoneyBack.new(self, self.moneyBackData)
        winui:align(display.LEFT_BOTTOM, 0, 0):addTo(self.rightNode)
    elseif idx == 4 then -- 卡号充值
        local winui = BankNodeCardRecharge.new(self)
        winui:align(display.LEFT_BOTTOM, 0, 0):addTo(self.rightNode)
    elseif idx == 5 then -- 修改密码
        local winui = BankNodeModiPass.new(self)
        winui:align(display.LEFT_BOTTOM, 0, 0):addTo(self.rightNode)
    end
    cc.UserDefault:getInstance():setIntegerForKey("BankWinShowViewName", idx)

    if refresh == true then
        self:sendBankRefreshMessage()
    end
end

function BankWinUI:onEnter()
    BankWinUI.super.onEnter(self)

    self:addEvent()
    self.panelNode:setScale(0.5)
    self.panelNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function BankWinUI:onExit()
    self:removeEvent()
    if PlazaManager.bankIsModiSucc == true then
        PlazaManager.resetBankData()
    end

    PlazaManager.closeLoginSocket()
    BankWinUI.super.onExit(self)
end

function BankWinUI:onClearUp()
    self:disableNodeEvents()
    BankWinUI.super.onClearUp(self)
end

function BankWinUI:addEvent()
    self.eventData = {}
    self.eventData.onRequestMoneyBackSucc = function(data)
        self:onRequestMoneyBackSucc(data)
    end -- 绑定手机号成功

    game.registerEvent(GameDefine.Bank_Back_RequestMoneyBackSucc, self.eventData.onRequestMoneyBackSucc)
end

function BankWinUI:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_RequestMoneyBackSucc, self.eventData.onRequestMoneyBackSucc)
end

function BankWinUI:sendBankRefreshMessage()
    local data = {}
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word134, LangCtrl:getLang().word135)
    end
    PlazaManager.getLoginModule().onSearchBankInfo(data, onConnectResult)
end

function BankWinUI:onRequestMoneyBackSucc(data)
    self.moneyBackData = data
end
return BankWinUI

