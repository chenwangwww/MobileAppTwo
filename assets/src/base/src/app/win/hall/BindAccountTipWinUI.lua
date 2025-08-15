local BindAccountTipWinUI = class("BindAccountTipWinUI", require("app.win.base.GameWindowWinBase"))
local BindAccountWinUI = require("app.win.hall.BindAccountWinUI")
local InputPassWinUI = require "app.win.bank.InputPassWinUI"

function BindAccountTipWinUI:ctor(isOpenBank)
    self.super.ctor(self, LangCtrl:getLang().word18, true, false)
    self:setName("BindAccountTipWinUI")
    self.isOpenBank = isOpenBank

    -- 读取本地保存的账号信息
    -- local writePassCheck = cc.UserDefault:getInstance():getBoolForKey("zh_c_writePassCheck",false)

    local content = GameUtil.createLabel(LangCtrl:getLang().word122, 30, GameDefine.FontColor, display.CENTER, cc.p(self.midWidth, 350)):addTo(self.panelNode)
    content:setLineHeight(38)
    content:setAdditionalKerning(2)
    content:setMaxLineWidth(580)
    content:setLineBreakWithoutSpace(false)

    local function onClickCheck_jzmj(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            local bindAccountName = string.format("bindAccountNextShow_%s", globalUserInfo.dwGameID)
            if sender.nextShowCheck == false then
                sender.nextShowCheck = true
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(true)
                end

                cc.UserDefault:getInstance():setBoolForKey(bindAccountName, false)
            else
                sender.nextShowCheck = false
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(false)
                end

                cc.UserDefault:getInstance():setBoolForKey(bindAccountName, true)
            end
        end
    end

    local btn_checkNode = ccui.Layout:create()
    btn_checkNode:align(display.LEFT_BOTTOM, cc.p(205, 190))
    btn_checkNode:addTo(self.panelNode)
    btn_checkNode:setTouchEnabled(true)
    btn_checkNode:addTouchEventListener(onClickCheck_jzmj)
    btn_checkNode:setContentSize(180, 60)
    btn_checkNode.nextShowCheck = false
    self.btn_checkNode = btn_checkNode
    btn_checkNode:setVisible(false)

    local lbl_1 = cc.Label:createWithTTF(LangCtrl:getLang().word72, GameDefine.FontName, 30):align(display.LEFT_CENTER, 50, 30):addTo(btn_checkNode)
    lbl_1:setColor(cc.c3b(0xa0, 0xa1, 0x72))
    local bg_check_1 = ccui.ImageView:create("app/login/check_1.png")
    bg_check_1:align(display.CENTER, 20, 30):addTo(btn_checkNode)

    local bg_check_2 = ccui.ImageView:create("app/login/check_2.png")
    bg_check_2:align(display.CENTER, 20, 30):addTo(btn_checkNode)
    bg_check_2:setName("bg_check_2")
    bg_check_2:setVisible(false)

    self:addCloseBtn()

    local function onYesCallBack(args)
        require("app.win.hall.BindAccountWinUI"):openView(self.isOpenBank)
        self:removeFromParent()
    end

    local btn_Yes = GameUtil.createButton("app/common/button/btn1.png", nil, onYesCallBack):move(self.midWidth - 150, 110):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_Yes) -- 确定

    local function onNoCallBack(args)
        if GameDefine.bIsTestUI then
            self:onOpenBank()
        end
        self:removeFromParent()
    end
    local btn_No = GameUtil.createButton("app/common/button/btn2.png", nil, onNoCallBack):move(self.midWidth + 150, 110):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word12, btn_No) -- 取消
end

function BindAccountTipWinUI:onOpenBank()
    if PlazaManager.bankIsLogonSucc == true and os.difftime(os.time(), PlazaManager.bankLogonTime) < 120 then
        local data = {}
        data.passType = PlazaManager.bankPassType
        data.passStr = PlazaManager.bankPassStr

        PlazaManager.bankOpenType = 1

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word100, LangCtrl:getLang().word101)
        end

        PlazaManager.getLoginModule().onLoginBank(data, onConnectResult)
    else
        local winui = InputPassWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display:getRunningScene())
    end
end

function BindAccountTipWinUI:openView(isOpenBank)
    local winui = BindAccountTipWinUI.new(isOpenBank)
    winui:setCenterOnScene()
    winui:addToOnCheckExist(display:getRunningScene())
end

return BindAccountTipWinUI
