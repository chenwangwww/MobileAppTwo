local BindPhoneWinUI = class("BindPhoneWinUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

function BindPhoneWinUI:ctor(isBand)
    BindPhoneWinUI.super.ctor(self, LangCtrl:getLang().word70, true, false)
    self:setName("BindPhoneWinUI")
    self.isBand = isBand

    self:initView()
end

function BindPhoneWinUI:onEnter()
    BindPhoneWinUI.super.onEnter(self)

    self.eventData = {}
    self:addEvent()
end

function BindPhoneWinUI:onExit()
    self:removeEvent()

    BindPhoneWinUI.super.onExit(self)
end

function BindPhoneWinUI:onClearUp()
    self:disableNodeEvents()

    BindPhoneWinUI.super.onClearUp(self)
end

function BindPhoneWinUI:addEvent()
    self.eventData.onBindPhoneSuccess = function()
        self:onBindPhoneSuccess()
    end -- 绑定手机号成功
    self.eventData.onUnBindPhoneSuccess = function()
        self:onUnBindPhoneSuccess()
    end -- 解除绑定手机号成功

    game.registerEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.registerEvent(GameDefine.UnBindPhoneSuccess, self.eventData.onUnBindPhoneSuccess)
end

function BindPhoneWinUI:removeEvent()
    game.unregisterEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.unregisterEvent(GameDefine.UnBindPhoneSuccess, self.eventData.onUnBindPhoneSuccess)
end

-------------------UI主界面---------------------------------
function BindPhoneWinUI:initView()

    local posy = self.winSize.height * 0.6

    self.objMobile = MobilePhone.new()
    self.objMobile:align(display.LEFT_CENTER, 0, posy):addTo(self.panelNode)

    -- 验证码
    local lbl_yzm = cc.Label:createWithTTF(LangCtrl:getLang().word30, GameDefine.FontName, 24)
    lbl_yzm:setColor(GameDefine.FontColor)
    lbl_yzm:align(display.RIGHT_CENTER, 280, posy - 100):addTo(self.panelNode)

    local edit_yzm = ccui.EditBox:create(cc.size(295, 46), "app/common/comwin/edit_bg.png")
    edit_yzm:setFont(GameDefine.FontName, 24)
    edit_yzm:setFontColor(GameDefine.FontColor_edit)
    edit_yzm:setMaxLength(11)
    edit_yzm:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_yzm:setPlaceHolder(LangCtrl:getLang().word33)
    edit_yzm:setPlaceholderFontSize(24)
    edit_yzm:setPlaceholderFontName(GameDefine.FontName)
    edit_yzm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_yzm:align(display.LEFT_CENTER, 280, posy - 100):addTo(self.panelNode)
    self.edit_yzm = edit_yzm

    local lbl_yzm_time = cc.Label:createWithTTF("", GameDefine.FontName, 24)
    lbl_yzm_time:setColor(GameDefine.FontColor_edit)
    lbl_yzm_time:align(display.CENTER, 540, posy - 100):addTo(self)
    lbl_yzm_time.timeNum = 0
    self.lbl_yzm_time = lbl_yzm_time

    local function onGetYzmClick(ref)
        PlazaManager.playClickEffect()

        if self.objMobile:verifyMobile() == 0 then
            local phoneStr = self.objMobile:getMobileStr()
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
    self.btn_getYzm:align(display.CENTER, 640, posy - 98)

    if self.isBand == true then
        -- 绑定手机号按钮
        local function onClickBindPhone()
            self:sendBindPhoneMsg()
        end
        local btn_BindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickBindPhone):move(self.midWidth, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word21, btn_BindPhone) -- 绑定手机
    else
        -- 解除绑定手机号按钮
        local function onClickCancelBindPhone()
            self:sendCancelBindPhoneMsg()
        end
        local btn_BindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickCancelBindPhone):move(self.midWidth, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word22, btn_BindPhone) -- 解除绑定
    end

    self:addCloseBtn()
end

----------------其他UI或者逻辑函数--------------------------------
function BindPhoneWinUI:isStrOk(str, limLen)
    -- 字符长度
    if #str == 0 then
        return 1
    end

    -- 是否全部是空字符串
    local regStr_remove = GameUtil.reomveString(str, " ")
    if #regStr_remove == 0 then
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

function BindPhoneWinUI:sendBindPhoneMsg()
    -- 手机号
    if self.objMobile:verifyMobile() ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word40)
        return
    end
    -- 验证码
    local yzmStr = self.edit_yzm:getText()
    if self:isStrOk(yzmStr, 11) ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word42)
        return
    end
    local phoneStr = self.objMobile:getMobileStr()
    local data = {}
    data.szMobilePhone = phoneStr
    data.szVerifyCode = yzmStr
    data.szAccounts = globalUserInfo.szAccounts
    data.szPassword = globalUserInfo.szPassword

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word73, LangCtrl:getLang().word74)
    end
    PlazaManager.getLoginModule().onBindPhone(data, onConnectResult)
end

function BindPhoneWinUI:sendCancelBindPhoneMsg()
    -- 手机号
    if self.objMobile:verifyMobile() ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word40)
        return
    end
    -- 验证码
    local yzmStr = self.edit_yzm:getText()
    if self:isStrOk(yzmStr, 11) ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word42)
        return
    end
    local phoneStr = self.objMobile:getMobileStr()
    local data = {}
    data.szMobilePhone = phoneStr
    data.szVerifyCode = yzmStr
    data.szAccounts = globalUserInfo.szAccounts
    data.szPassword = globalUserInfo.szPassword

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word75, LangCtrl:getLang().word76)
    end
    PlazaManager.getLoginModule().onCancelBindPhone(data, onConnectResult)
end
-----------------------消息处理函数---------------------------
function BindPhoneWinUI:onBindPhoneSuccess()
    PlazaManager.closeWattingTips()
    self:removeFromParent()
end

function BindPhoneWinUI:onUnBindPhoneSuccess()
    PlazaManager.closeWattingTips()
    self:removeFromParent()
end

return BindPhoneWinUI
