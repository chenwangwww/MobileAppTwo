local BindPhoneTipWinUI = class("BindPhoneTipWinUI", require("app.win.base.GameWindowWinBase"))
local BindPhoneWinUI = require("app.win.hall.BindPhoneWinUI")

function BindPhoneTipWinUI:ctor()
    self.super.ctor(self, LangCtrl:getLang().word70, true, false)
    self:setName("BindPhoneTipWinUI")

    -- 读取本地保存的账号信息
    -- local writePassCheck = cc.UserDefault:getInstance():getBoolForKey("zh_c_writePassCheck",false)

    local content = GameUtil.createLabel(LangCtrl:getLang().word71, 30, GameDefine.FontColor, display.CENTER, cc.p(self.midWidth, 380)):addTo(self.panelNode)
    content:setLineHeight(38)
    content:setAdditionalKerning(2)
    content:setMaxLineWidth(480)
    content:setLineBreakWithoutSpace(false)

    local function onClickCheck_jzmj(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()

            if sender.nextShowCheck == false then
                sender.nextShowCheck = true
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(true)
                end

                local nextShowSaveName = string.format("%s_BindPhoneTipShowChk", globalUserInfo.dwGameID)
                cc.UserDefault:getInstance():setBoolForKey(nextShowSaveName, false)
            else
                sender.nextShowCheck = false
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(false)
                end

                local nextShowSaveName = string.format("%s_BindPhoneTipShowChk", globalUserInfo.dwGameID)
                cc.UserDefault:getInstance():setBoolForKey(nextShowSaveName, true)
            end
        end
    end

    local btn_checkNode = ccui.Layout:create()
    btn_checkNode:align(display.LEFT_BOTTOM, cc.p(180, 190))
    btn_checkNode:addTo(self.panelNode)
    btn_checkNode:setTouchEnabled(true)
    btn_checkNode:addTouchEventListener(onClickCheck_jzmj)
    btn_checkNode:setContentSize(180, 60)
    btn_checkNode.nextShowCheck = false
    self.btn_checkNode = btn_checkNode

    local lbl_1 = cc.Label:createWithTTF(LangCtrl:getLang().word72, GameDefine.FontName, 30):align(display.LEFT_CENTER, 50, 30):addTo(btn_checkNode)
    lbl_1:setColor(cc.c3b(0x94, 0xb4, 0xd3))
    local bg_check_1 = ccui.ImageView:create("app/login/check_1.png")
    bg_check_1:align(display.CENTER, 20, 30):addTo(btn_checkNode)

    local bg_check_2 = ccui.ImageView:create("app/login/check_2.png")
    bg_check_2:align(display.CENTER, 20, 30):addTo(btn_checkNode)
    bg_check_2:setName("bg_check_2")
    bg_check_2:setVisible(false)

    self:addCloseBtn()

    local function onYesCallBack(args)
        local ui = BindPhoneWinUI.new(true)
        ui:setCenterOnScene()
        ui:addTo(display.getRunningScene())
        self:removeFromParent()
    end

    local btn_Yes = GameUtil.createButton("app/common/button/btn1.png", nil, onYesCallBack):move(self.midWidth - 150, 110):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_Yes) -- 确定

    local function onNoCallBack(args)
        self:removeFromParent()
    end
    local btn_No = GameUtil.createButton("app/common/button/btn2.png", nil, onNoCallBack):move(self.midWidth + 150, 110):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word12, btn_No) -- 取消
end

return BindPhoneTipWinUI
