local AccountCheckUI = class("AccountCheckUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

function AccountCheckUI:ctor()
    AccountCheckUI.super.ctor(self, LangCtrl:getLang().word61, true, false)
    self:setName("AccountCheckUI")

    local posy = self.winSize.height * 0.68
    local lbl_accoutName = cc.Label:createWithTTF(LangCtrl:getLang().word3, GameDefine.FontName, 24)
    lbl_accoutName:setColor(GameDefine.FontColor)
    lbl_accoutName:align(display.RIGHT_CENTER, 280, posy):addTo(self.panelNode)

    local editAccount = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    editAccount:setFont(GameDefine.FontName, 24)
    editAccount:setFontColor(GameDefine.FontColor_edit)
    editAccount:setMaxLength(30)
    editAccount:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editAccount:setPlaceHolder(LangCtrl:getLang().word62)
    editAccount:setPlaceholderFontSize(24)
    editAccount:setPlaceholderFontName(GameDefine.FontName)
    editAccount:setPlaceholderFontColor(GameDefine.FontColor_edit)
    editAccount:align(display.LEFT_CENTER, 280, posy):addTo(self.panelNode)
    self.editAccount = editAccount

    self.objMobile = MobilePhone.new()
    self.objMobile:align(display.LEFT_CENTER, 0, posy - 100):addTo(self.panelNode)

    local function onClickAccountCheck(args)
        if GameDefine.bIsTestUI then
            local data = {
                szAccounts = "13899998888",
                szMobilePhone = "13899998888"
            }
            -- 忘记密码 下一步
            local aspui = require("app.win.login.AccountSetPassUI").new(data)
            aspui:setCenterOnScene()
            aspui:addTo(display.getRunningScene())
            return
        end

        local accountStr = self.editAccount:getText()
        if self:isStrOk(accountStr) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word7)
            return
        end

        -- 长度是否超出
        if string.len(accountStr) > 30 then
            PlazaManager.showTips(LangCtrl:getLang().word7)
            return
        end

        if GameUtil.isChineseString(accountStr) == true then
            PlazaManager.showTips(LangCtrl:getLang().word8)
            return
        end

        -- 手机号
        if self.objMobile:verifyMobile() ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word40)
            return
        end
        local phoneStr = self.objMobile:getMobileStr()
        -- 发送消息
        local data = {
            szAccounts = accountStr,
            szMobilePhone = phoneStr
        }
        self.requstData = data

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word63, LangCtrl:getLang().word64)
        end
        PlazaManager.getLoginModule().onCheckBindPhoneAndAccoount(self.requstData, onConnectResult)
    end

    self:addCloseBtn()

    local btn_login = GameUtil.createButton("app/common/button/btn1.png", nil, onClickAccountCheck):move(self.midWidth, posy - 280):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word24, btn_login) -- 下一步
end

function AccountCheckUI:onEnter()
    AccountCheckUI.super.onEnter(self)
    PlazaManager.closeWattingTips()
    self.eventData = {}
    self.eventData.onCheckAccontSuccess = function()
        self:onCheckAccontSuccess()
    end
    game.registerEvent(GameDefine.CheckBindPhoneSuccess, self.eventData.onCheckAccontSuccess)
end

function AccountCheckUI:onExit()
    game.unregisterEvent(GameDefine.CheckBindPhoneSuccess, self.eventData.onCheckAccontSuccess)
    AccountCheckUI.super.onExit(self)
end

function AccountCheckUI:isStrOk(str, limLen)
    -- 字符长度
    if string.len(str) == 0 then
        return 1
    end

    -- 是否全部是空字符串
    local regStr_remove = GameUtil.reomveString(str, " ")
    if string.len(regStr_remove) == 0 then
        return 2
    end

    return 0
end

-- accountdata={szAccounts=1231,szMobilePhone="13341122305"}
function AccountCheckUI:onCheckAccontSuccess()
    PlazaManager.closeWattingTips()

    if GameDefine.bIsTestUI then
        return
    end

    local aspui = require("app.win.login.AccountSetPassUI").new(self.requstData)
    aspui:setCenterOnScene()
    aspui:addTo(display.getRunningScene())

    self:removeFromParent()
end

return AccountCheckUI
