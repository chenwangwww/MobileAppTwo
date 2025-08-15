local AccountSetPassUI = class("AccountSetPassUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

-- accountdata={szAccounts=1231,szMobilePhone="13341122305"}
function AccountSetPassUI:ctor(accountdata)
    AccountSetPassUI.super.ctor(self, LangCtrl:getLang().word65, true, false)
    self:setName("AccountSetPassUI")

    self.accountdata = accountdata
    local posy = self.winSize.height * 0.73

    self.objMobile = MobilePhone.new()
    self.objMobile:align(display.LEFT_CENTER, 0, posy):addTo(self.panelNode)
    if accountdata then
        self.objMobile:setEditText(accountdata.szMobilePhone)
    end
    self.objMobile.edit_phone:setEnabled(false)

    -- 验证码
    local lbl_yzm = cc.Label:createWithTTF(LangCtrl:getLang().word30, GameDefine.FontName, 24)
    lbl_yzm:setColor(GameDefine.FontColor)
    lbl_yzm:align(display.RIGHT_CENTER, 280, posy - 70):addTo(self.panelNode)

    local edit_yzm = ccui.EditBox:create(cc.size(295, 46), "app/common/comwin/edit_bg.png")
    edit_yzm:setFont(GameDefine.FontName, 24)
    edit_yzm:setFontColor(GameDefine.FontColor_edit)
    edit_yzm:setMaxLength(7)
    edit_yzm:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_yzm:setPlaceHolder(LangCtrl:getLang().word33)
    edit_yzm:setPlaceholderFontSize(24)
    edit_yzm:setPlaceholderFontName(GameDefine.FontName)
    edit_yzm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_yzm:align(display.LEFT_CENTER, 280, posy - 70):addTo(self.panelNode)
    self.edit_yzm = edit_yzm

    local lbl_yzm_time = cc.Label:createWithTTF("", GameDefine.FontName, 24)
    lbl_yzm_time:setColor(GameDefine.FontColor_edit)
    lbl_yzm_time:align(display.CENTER, 540, posy - 70):addTo(self.panelNode)
    lbl_yzm_time.timeNum = 0
    self.lbl_yzm_time = lbl_yzm_time

    local function onGetYzmClick(ref)
        PlazaManager.playClickEffect()

        local phoneStr = self.objMobile:getMobileStr()
        if self.objMobile:verifyMobile() == 0 then
            self.btn_getYzm:setEnabled(false)
            self.showlblYzmCheck = true
            self.lbl_yzm_time.timeNum = 90
            self.lbl_yzm_time:setString(string.format("（%ds）", self.lbl_yzm_time.timeNum))

            PlazaManager.showConectWaitTips(nil)
            local function onConnectResult(isSuccess, ipsCount)
                PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word37, LangCtrl:getLang().word38)
            end
            PlazaManager.getLoginModule().onRequestVerificationCode(phoneStr, onConnectResult)
        else
            PlazaManager.showTips(LangCtrl:getLang().word39)
        end
    end
    self.showlblYzmCheck = false
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if self.showlblYzmCheck == true then
            if self.lbl_yzm_time.timeNum > 0 then
                self.lbl_yzm_time.timeNum = self.lbl_yzm_time.timeNum - 1
                self.lbl_yzm_time:setString(string.format("（%ds）", self.lbl_yzm_time.timeNum))
            else
                self.lbl_yzm_time.timeNum = 0
                self.lbl_yzm_time:setString("")
                self.showlblYzmCheck = false
                self.btn_getYzm:setEnabled(true)
            end
        end
    end, 1, false)

    self.btn_getYzm = GameUtil.newDarkLightBtn(self.panelNode, 2, LangCtrl:getLang().word316, cc.size(130, 40), 24, onGetYzmClick)
    self.btn_getYzm:align(display.CENTER, 640, posy - 68)

    -- 登录新密码
    local lbl_password_1 = cc.Label:createWithTTF(LangCtrl:getLang().word66, GameDefine.FontName, 24)
    lbl_password_1:setColor(GameDefine.FontColor)
    lbl_password_1:align(display.RIGHT_CENTER, 280, posy - 140):addTo(self.panelNode)

    local edit_password_1 = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_password_1:setFont(GameDefine.FontName, 24)
    edit_password_1:setFontColor(GameDefine.FontColor_edit)
    edit_password_1:setMaxLength(33)
    edit_password_1:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_password_1:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_password_1:setPlaceHolder(LangCtrl:getLang().word67)
    edit_password_1:setPlaceholderFontSize(24)
    edit_password_1:setPlaceholderFontName(GameDefine.FontName)
    edit_password_1:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_password_1:align(display.LEFT_CENTER, 280, posy - 140):addTo(self.panelNode)
    self.edit_password_1 = edit_password_1

    -- 确认密码
    local lbl_password_2 = cc.Label:createWithTTF(LangCtrl:getLang().word32, GameDefine.FontName, 24)
    lbl_password_2:setColor(GameDefine.FontColor)
    lbl_password_2:align(display.RIGHT_CENTER, 280, posy - 210):addTo(self.panelNode)

    local edit_password_2 = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_password_2:setFont(GameDefine.FontName, 24)
    edit_password_2:setFontColor(GameDefine.FontColor_edit)
    edit_password_2:setMaxLength(33)
    edit_password_2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_password_2:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_password_2:setPlaceHolder(LangCtrl:getLang().word36)
    edit_password_2:setPlaceholderFontSize(24)
    edit_password_2:setPlaceholderFontName(GameDefine.FontName)
    edit_password_2:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_password_2:align(display.LEFT_CENTER, 280, posy - 210):addTo(self.panelNode)
    self.edit_password_2 = edit_password_2

    local function onClickReSet(ref)
        -- 手机号
        local phoneStr = self.objMobile:getMobileStr()
        if self.objMobile:verifyMobile() ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word40)
            return
        end
        -- 验证码
        local yzmStr = self.edit_yzm:getText()
        if self:isStrOk(yzmStr, 7) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word42)
            return
        end

        -- 登录密码
        local password1 = self.edit_password_1:getText()
        local password2 = self.edit_password_2:getText()
        if self:isStrOk(password1, 33) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word52)
            return
        end

        if password1 ~= password2 then
            PlazaManager.showTips(LangCtrl:getLang().word53)
            return
        end

        local data = {}
        data.szAccount = self.accountdata.szAccounts
        data.szNewPassWord = game.md5(password1)
        data.szMobilePhone = phoneStr
        data.szVerifyCode = yzmStr

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word68, LangCtrl:getLang().word69)
        end
        PlazaManager.getLoginModule().onModifyLogonPassword(data)
    end

    local btn_ok = GameUtil.createButton("app/common/button/btn1.png", nil, onClickReSet):move(self.midWidth, posy - 320):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_ok) -- 确定

    self:addCloseBtn()
end

function AccountSetPassUI:isStrOk(str, limLen)
    -- 字符长度
    if string.len(str) == 0 then
        return 1
    end

    -- 是否全部是空字符串
    local regStr_remove = GameUtil.reomveString(str, " ")
    if string.len(regStr_remove) == 0 then
        return 2
    end

    -- 长度是否超出
    if limLen == nil then
        limLen = 10
    end
    if string.len(str) > limLen then
        return 3
    end

    return 0
end

function AccountSetPassUI:onEnter()
    AccountSetPassUI.super.onEnter(self)

    self.eventData = {}
    self.eventData.onModifyLogonPassSuccess = function()
        self:onModifyLogonPassSuccess()
    end
    game.registerEvent(GameDefine.ModifyLogonPassSuccess, self.eventData.onModifyLogonPassSuccess)
end

function AccountSetPassUI:onExit()
    AccountSetPassUI.super.onExit(self)
    game.unregisterEvent(GameDefine.ModifyLogonPassSuccess, self.eventData.onModifyLogonPassSuccess)
end

---------------消息处理函数------------------------
-- 修改成功
function AccountSetPassUI:onModifyLogonPassSuccess()
    PlazaManager.closeWattingTips()
    self:removeFromParent()
end

return AccountSetPassUI
