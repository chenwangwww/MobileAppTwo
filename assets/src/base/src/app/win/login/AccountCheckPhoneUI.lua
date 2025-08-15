local AccountCheckPhoneUI = class("AccountCheckPhoneUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

function AccountCheckPhoneUI:ctor()
    self.super.ctor(self, LangCtrl:getLang().word117, true, false)
    self:setName("AccountCheckPhoneUI")
    self:initView()
end

function AccountCheckPhoneUI:onEnter()
    self.super.onEnter(self)

    self.eventData = {}
    self:addEvent()
end

function AccountCheckPhoneUI:onExit()
    self.super.onExit(self)
    self:removeEvent()
end

function AccountCheckPhoneUI:onClearUp()
    self:disableNodeEvents()

    self.super.onClearUp(self)
end

function AccountCheckPhoneUI:addEvent()
end

function AccountCheckPhoneUI:removeEvent()
end

-------------------UI主界面---------------------------------
function AccountCheckPhoneUI:initView()
    local ss = self.panelNode:getContentSize()
    local lbl_tips = cc.Label:createWithTTF(LangCtrl:getLang().word118, GameDefine.FontName, 24)
    lbl_tips:setColor(GameDefine.FontColor)
    lbl_tips:align(display.CENTER, ss.width / 2, 420):addTo(self.panelNode)

    self.objMobile = MobilePhone.new()
    self.objMobile:align(display.LEFT_CENTER, 0, 350):addTo(self.panelNode)

    -- 验证码
    local lbl_yzm = cc.Label:createWithTTF(LangCtrl:getLang().word30, GameDefine.FontName, 24)
    lbl_yzm:setColor(GameDefine.FontColor)
    lbl_yzm:align(display.RIGHT_CENTER, 280, 270):addTo(self.panelNode)

    local edit_yzm = ccui.EditBox:create(cc.size(295, 46), "app/common/comwin/edit_bg.png")
    edit_yzm:setFont(GameDefine.FontName, 24)
    edit_yzm:setFontColor(GameDefine.FontColor_edit)
    edit_yzm:setMaxLength(11)
    edit_yzm:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_yzm:setPlaceHolder(LangCtrl:getLang().word33)
    edit_yzm:setPlaceholderFontSize(24)
    edit_yzm:setPlaceholderFontName(GameDefine.FontName)
    edit_yzm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_yzm:align(display.LEFT_CENTER, 280, 270):addTo(self.panelNode)
    self.edit_yzm = edit_yzm

    local lbl_yzm_time = cc.Label:createWithTTF("", GameDefine.FontName, 24)
    lbl_yzm_time:setColor(GameDefine.FontColor_edit)
    lbl_yzm_time:align(display.CENTER, 540, 270):addTo(self)
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
    self.btn_getYzm:align(display.CENTER, 640, 270)

    -- 绑定手机号按钮
    local function onClickLogic()
        self:sendBindPhoneMsg()
    end
    local btn_Logic = GameUtil.createButton("app/common/button/btn1.png", nil, onClickLogic):move(ss.width / 2, 160):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_Logic) -- 确定
    self:addCloseBtn()
end

----------------其他UI或者逻辑函数--------------------------------
function AccountCheckPhoneUI:isStrOk(str, limLen)
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

function AccountCheckPhoneUI:sendBindPhoneMsg()
    -- 手机号
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
    local phoneStr = self.objMobile:getMobileStr()
    -- 连接中
    PlazaManager.showConectWaitTips(nil)
    -- 连接结果
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word73, LangCtrl:getLang().word74)
    end
    PlazaManager.getLoginModule().onLoginByPhoneVerifyCode(phoneStr, yzmStr, onConnectResult)
end

return AccountCheckPhoneUI
