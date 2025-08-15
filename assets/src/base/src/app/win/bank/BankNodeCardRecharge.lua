-- 卡号充值
local BankNodeCardRecharge = class("BankNodeCardRecharge", function()
    return cc.Node:create()
end)

function BankNodeCardRecharge:ctor(bankui)
    self.winSize = bankui.rightSize
    self.midWidth = self.winSize.width / 2
    self.midHeight = self.winSize.height / 2
    self:enableNodeEvents()
    self:setName("BankNodeCardRecharge")
    self:setContentSize(self.winSize)

    local img_bg_top = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    img_bg_top:setCapInsets(GameDefine.PanelRect2)
    img_bg_top:setContentSize(self.winSize)
    img_bg_top:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)

    local x1, x2 = 170, 180

    GameUtil.createLabel(LangCtrl:getLang().word209, 26, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(x1, 450)):addTo(self)
    local edit_card = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_card:setFont(GameDefine.FontName, 30)
    edit_card:setFontColor(GameDefine.FontColor_edit)
    edit_card:setMaxLength(30)
    edit_card:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_card:setPlaceHolder(LangCtrl:getLang().word210)
    edit_card:setPlaceholderFontSize(30)
    edit_card:setPlaceholderFontName(GameDefine.FontName)
    edit_card:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_card:align(display.LEFT_CENTER, x2, 450):addTo(self)
    self.edit_card = edit_card

    GameUtil.createLabel(LangCtrl:getLang().word4, 26, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(x1, 350)):addTo(self)
    local edit_pwd = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_pwd:setFont(GameDefine.FontName, 30)
    edit_pwd:setFontColor(GameDefine.FontColor_edit)
    edit_pwd:setMaxLength(30)
    edit_pwd:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_pwd:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_pwd:setPlaceHolder(LangCtrl:getLang().word6)
    edit_pwd:setPlaceholderFontSize(30)
    edit_pwd:setPlaceholderFontName(GameDefine.FontName)
    edit_pwd:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_pwd:align(display.LEFT_CENTER, x2, 350):addTo(self)
    self.edit_pwd = edit_pwd

    local function clickModiPass(btn)
        local card_str = self.edit_card:getText()
        local pwd_str = self.edit_pwd:getText()
        if string.len(card_str) < 6 then
            PlazaManager.showTips(LangCtrl:getLang().word211)
            return
        end

        if string.len(pwd_str) < 6 then
            PlazaManager.showTips(LangCtrl:getLang().word212)
            return
        end

        self:sendMessage(card_str, pwd_str)
    end
    local btn = GameUtil.createButton("app/common/button/btn1.png", nil, clickModiPass):move(self.midWidth, 60):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word15, btn) -- 充值
end

function BankNodeCardRecharge:onEnter()
    self:addEvent()
end

function BankNodeCardRecharge:onExit()
    self:removeEvent()
end

function BankNodeCardRecharge:onClearUp()
    self:disableNodeEvents()
end

function BankNodeCardRecharge:addEvent()
    self.eventData = {}
    self.eventData.onRechargeResult = function(data)
        self:onRechargeResult(data)
    end
    game.registerEvent("EVENT_USER_SERVER_OPERATE_RESULT", self.eventData.onRechargeResult)
end

function BankNodeCardRecharge:removeEvent()
    game.unregisterEvent("EVENT_USER_SERVER_OPERATE_RESULT", self.eventData.onRechargeResult)
end

function BankNodeCardRecharge:sendMessage(card_str, pwd_str)
    local data = {
        szLiveCard = tostring(card_str),
        szPassword = string.lower(game.md5(tostring(pwd_str)))
    }

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word213, LangCtrl:getLang().word214)
    end

    PlazaManager.getLoginModule().onSendRechargeMessage(data, onConnectResult)
end

function BankNodeCardRecharge:onRechargeResult(data)
    if data.lResultCode == 0 then
        self.edit_card:setText("")
        self.edit_pwd:setText("")
        PlazaManager.showTips(LangCtrl:getLang().word215)
    end
end

return BankNodeCardRecharge
