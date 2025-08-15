local BindAccountWinUI = class("BindAccountWinUI", require("app.win.base.GameWindowWinBase"))
local InputPassWinUI = require "app.win.bank.InputPassWinUI"
local MobilePhone = require("app.components.MobilePhone")

function BindAccountWinUI:ctor(isOpenBank)
    BindAccountWinUI.super.ctor(self, LangCtrl:getLang().word85, true, false, cc.size(1000, 650))
    self:setName("BindAccountWinUI")
    self.isBand = true
    self.sendTime = 0
    self.isOpenBank = isOpenBank

    self:initView()
end

function BindAccountWinUI:onEnter()
    BindAccountWinUI.super.onEnter(self)

    self.eventData = {}
    self:addEvent()
end

function BindAccountWinUI:onExit()
    self:removeEvent()

    BindAccountWinUI.super.onExit(self)
end

function BindAccountWinUI:onClearUp()
    self:disableNodeEvents()

    BindAccountWinUI.super.onClearUp(self)
end

function BindAccountWinUI:addEvent()
    self.eventData.onBindPhoneSuccess = function()
        self:onBindPhoneSuccess()
    end -- 绑定手机号成功
    self.eventData.onBindAccountResult = function(args)
        self:onBindAccountResult(args)
    end -- 绑定账号结果
    self.eventData.onCheckLoginAccountSucc = function()
        self:onCheckLoginAccountSucc()
    end -- 检查用户名成功
    self.eventData.onCheckLoginAccountFail = function(lResultCode, szDescribeString)
        self:onCheckLoginAccountFail(lResultCode, szDescribeString)
    end -- 检查用户名失败

    game.registerEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.registerEvent(GameDefine.BindAccountResult, self.eventData.onBindAccountResult)
    game.registerEvent(GameDefine.CheckLoginAccountSucc, self.eventData.onCheckLoginAccountSucc)
    game.registerEvent(GameDefine.CheckLoginAccountFail, self.eventData.onCheckLoginAccountFail)
end

function BindAccountWinUI:removeEvent()
    game.unregisterEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.unregisterEvent(GameDefine.BindAccountResult, self.eventData.onBindAccountResult)
    game.unregisterEvent(GameDefine.CheckLoginAccountSucc, self.eventData.onCheckLoginAccountSucc)
    game.unregisterEvent(GameDefine.CheckLoginAccountFail, self.eventData.onCheckLoginAccountFail)
end

-------------------UI主界面---------------------------------
function BindAccountWinUI:initView()
    self.edit_yhm_oldStr = ""

    local baseX = 330
    local baseY = 520
    local space = 75
    local fontSize = 30

    local registerPhone = ""
    local isBindPhone = false
    if globalUserInfo.szRegisterMobile ~= nil and string.len(globalUserInfo.szRegisterMobile) > 0 then
        isBindPhone = true
        registerPhone = globalUserInfo.szRegisterMobile
    end

    self.objMobile = MobilePhone.new(handler(self, self.editboxHandle))
    self.objMobile:align(display.LEFT_CENTER, 50, baseY):addTo(self.panelNode)
    if isBindPhone == true then
        self.objMobile:setEditText(registerPhone)
        -- self.objMobile.edit_phone:setEnabled(false)
    end

    -- 验证码
    local lbl_yzm = cc.Label:createWithTTF(LangCtrl:getLang().word30, GameDefine.FontName, fontSize)
    lbl_yzm:setColor(GameDefine.FontColor)
    lbl_yzm:align(display.RIGHT_CENTER, baseX, baseY - space):addTo(self.panelNode)

    local edit_yzm = ccui.EditBox:create(cc.size(340, 50), "app/common/comwin/edit_bg.png")
    edit_yzm:setFont(GameDefine.FontName, fontSize)
    edit_yzm:setFontColor(GameDefine.FontColor)
    edit_yzm:setMaxLength(11)
    edit_yzm:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_yzm:setPlaceHolder(LangCtrl:getLang().word33)
    edit_yzm:setPlaceholderFontSize(fontSize)
    edit_yzm:setPlaceholderFontName(GameDefine.FontName)
    edit_yzm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_yzm:align(display.LEFT_CENTER, baseX, baseY - space):addTo(self.panelNode)
    self.edit_yzm = edit_yzm

    local lbl_yzm_time = cc.Label:createWithTTF("", GameDefine.FontName, fontSize)
    lbl_yzm_time:setColor(GameDefine.FontColor)
    lbl_yzm_time:align(display.CENTER, baseX + 300, baseY - space):addTo(self)
    lbl_yzm_time.timeNum = 0
    self.lbl_yzm_time = lbl_yzm_time

    local function onGetYzmClick(ref)
        PlazaManager.playClickEffect()

        if self.objMobile:verifyMobile() == 0 then
            local phoneStr = self.objMobile:getMobileStr()
            -- 如果绑定了手机  是否是同一个手机号
            local isGetYZM = true
            if isBindPhone == true then
                if phoneStr ~= globalUserInfo.szRegisterMobile then
                    isGetYZM = false
                    PlazaManager.showTips(LangCtrl:getLang().word86)
                end
            end

            if isGetYZM == true then
                self.btn_getYzm:setEnabled(false)
                self.showlblYzmCheck = true
                self.lbl_yzm_time.timeNum = 90
                self.lbl_yzm_time:setString(string.format("（%ds）", self.lbl_yzm_time.timeNum))

                PlazaManager.showConectWaitTips(nil)
                local function onConnectResult(isSuccess, ipsCount)
                    PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word37, LangCtrl:getLang().word38)
                end
                PlazaManager.getLoginModule().onRequestVerificationCode(phoneStr, onConnectResult)
            end
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
    self.btn_getYzm:align(display.CENTER, baseX + 410, baseY - space)

    if self.isBand == true then
        -- 绑定手机号按钮
        local function onClickBindPhone()
            self:sendBindPhoneMsg()
        end
        local btn_BindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickBindPhone):move(self.midWidth, 90):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_BindPhone) -- 账号设置
    end

    self:addCloseBtn()

    -- 账户
    local lbl_yhm = cc.Label:createWithTTF(LangCtrl:getLang().word3, GameDefine.FontName, fontSize)
    lbl_yhm:setColor(GameDefine.FontColor)
    lbl_yhm:align(display.RIGHT_CENTER, baseX, baseY - space * 2):addTo(self.panelNode)

    self.edit_yhm = ccui.EditBox:create(cc.size(340, 50), "app/common/comwin/edit_bg.png")
    self.edit_yhm:setName("edityhm")
    self.edit_yhm:setFont(GameDefine.FontName, fontSize)
    self.edit_yhm:setFontColor(GameDefine.FontColor)
    self.edit_yhm:setMaxLength(16)
    self.edit_yhm:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.edit_yhm:setPlaceHolder(LangCtrl:getLang().word34)
    self.edit_yhm:setPlaceholderFontSize(fontSize)
    self.edit_yhm:setPlaceholderFontName(GameDefine.FontName)
    self.edit_yhm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    self.edit_yhm:registerScriptEditBoxHandler(handler(self, self.editboxHandle))
    self.edit_yhm:align(display.LEFT_CENTER, baseX, baseY - space * 2):addTo(self.panelNode)

    -- 密码
    local lbl_password1 = cc.Label:createWithTTF(LangCtrl:getLang().word4, GameDefine.FontName, fontSize)
    lbl_password1:setColor(GameDefine.FontColor)
    lbl_password1:align(display.RIGHT_CENTER, baseX, baseY - space * 3):addTo(self.panelNode)

    self.edit_password_1 = ccui.EditBox:create(cc.size(340, 50), "app/common/comwin/edit_bg.png")
    self.edit_password_1:setName("editpassword1")
    self.edit_password_1:setFont(GameDefine.FontName, fontSize)
    self.edit_password_1:setFontColor(GameDefine.FontColor)
    self.edit_password_1:setMaxLength(16)
    self.edit_password_1:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.edit_password_1:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.edit_password_1:setPlaceHolder(LangCtrl:getLang().word34)
    self.edit_password_1:setPlaceholderFontSize(fontSize)
    self.edit_password_1:setPlaceholderFontName(GameDefine.FontName)
    self.edit_password_1:setPlaceholderFontColor(GameDefine.FontColor_edit)
    self.edit_password_1:align(display.LEFT_CENTER, baseX, baseY - space * 3):addTo(self.panelNode)
    self.edit_password_1:registerScriptEditBoxHandler(handler(self, self.editboxHandle))

    -- 确认密码
    local lbl_password2 = cc.Label:createWithTTF(LangCtrl:getLang().word32, GameDefine.FontName, fontSize)
    lbl_password2:setColor(GameDefine.FontColor)
    lbl_password2:align(display.RIGHT_CENTER, baseX, baseY - space * 4):addTo(self.panelNode)

    self.edit_password_2 = ccui.EditBox:create(cc.size(340, 50), "app/common/comwin/edit_bg.png")
    self.edit_password_2:setName("editpassword2")
    self.edit_password_2:setFont(GameDefine.FontName, fontSize)
    self.edit_password_2:setFontColor(GameDefine.FontColor)
    self.edit_password_2:setMaxLength(16)
    self.edit_password_2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.edit_password_2:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    self.edit_password_2:setPlaceHolder(LangCtrl:getLang().word36)
    self.edit_password_2:setPlaceholderFontSize(fontSize)
    self.edit_password_2:setPlaceholderFontName(GameDefine.FontName)
    self.edit_password_2:setPlaceholderFontColor(GameDefine.FontColor_edit)
    self.edit_password_2:align(display.LEFT_CENTER, baseX, baseY - space * 4):addTo(self.panelNode)
    self.edit_password_2:registerScriptEditBoxHandler(handler(self, self.editboxHandle))

    -- 说明
    local lbl_sm = cc.Label:createWithTTF(LangCtrl:getLang().word87, GameDefine.FontName, fontSize)
    lbl_sm:setColor(cc.RED)
    lbl_sm:align(display.CENTER, baseX + 170, baseY - space * 5 + 10):addTo(self.panelNode)

    -- 账户错误说明
    self.lbl_yhm_error = cc.Label:createWithTTF("", GameDefine.FontName, fontSize)
    self.lbl_yhm_error:setColor(cc.RED)
    self.lbl_yhm_error:setVisible(false)
    self.lbl_yhm_error:align(display.LEFT_CENTER, baseX + 350, baseY - space * 2):addTo(self.panelNode)

    -- *密码错误说明
    self.lbl_password1_error = cc.Label:createWithTTF("", GameDefine.FontName, fontSize)
    self.lbl_password1_error:setColor(cc.RED)
    self.lbl_password1_error:setVisible(false)
    self.lbl_password1_error:align(display.LEFT_CENTER, baseX + 350, baseY - space * 3):addTo(self.panelNode)

    -- *再次密码错误说明
    self.lbl_password2_error = cc.Label:createWithTTF("", GameDefine.FontName, fontSize)
    self.lbl_password2_error:setColor(cc.RED)
    self.lbl_password2_error:setVisible(false)
    self.lbl_password2_error:align(display.LEFT_CENTER, baseX + 350, baseY - space * 4):addTo(self.panelNode)
end

----------------其他UI或者逻辑函数--------------------------------
function BindAccountWinUI:isStrOk(str, limLen)
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

function BindAccountWinUI:sendBindPhoneMsg()
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

    -- 用户名
    local userNameStr = self.edit_yhm:getText()
    if self:onCheckAccount(userNameStr) == false then
        PlazaManager.showTips(LangCtrl:getLang().word7)
        return
    end

    -- 密码
    local password1 = self.edit_password_1:getText()
    local password2 = self.edit_password_2:getText()

    if self:onCheckPassword(password1) == false then
        PlazaManager.showTips(LangCtrl:getLang().word9)
        return
    end

    if password1 ~= password2 then
        self:setLabelStatue(self.lbl_password2_error, true, LangCtrl:getLang().word88)
        PlazaManager.showTips(LangCtrl:getLang().word53)
        return
    else
        self:setLabelStatue(self.lbl_password2_error, false, "")
    end

    local phoneStr = self.objMobile:getMobileStr()
    local isBindPhone = false
    if globalUserInfo.szRegisterMobile ~= nil and string.len(globalUserInfo.szRegisterMobile) > 0 then
        isBindPhone = true
    end

    if isBindPhone == false then
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
    else
        if globalUserInfo.isBindAccount == false then
            self:sendBindAccountMsg()
        else
            PlazaManager.showTips(LangCtrl:getLang().word89)
            self:removeFromParent()
        end
    end
end

-----------------------消息处理函数---------------------------
function BindAccountWinUI:onBindPhoneSuccess()
    PlazaManager.closeWattingTips()

    -- local is_yk_need_bind = globalUserInfo.cbRegType == 0 and globalUserInfo.isBindAccount == false

    -- 绑定手机号成功  没绑定账户  发送绑定账户消息
    if globalUserInfo.isBindAccount == false then
        self:sendBindAccountMsg()
    else
        PlazaManager.showTips(LangCtrl:getLang().word90)
        if self.isOpenBank == true then
            self:onOpenBank()
        end
        self:removeFromParent()
    end
end

-------------------------------------------------------------------------------

function BindAccountWinUI:sendBindAccountMsg()
    -- 用户名
    local userNameStr = self.edit_yhm:getText()
    if self:onCheckAccount(userNameStr) == false then
        PlazaManager.showTips(LangCtrl:getLang().word7)
        return
    end

    -- 密码
    local password1 = self.edit_password_1:getText()
    local password2 = self.edit_password_2:getText()

    if self:onCheckPassword(password1) == false then
        PlazaManager.showTips(LangCtrl:getLang().word9)
        return
    end

    if password1 ~= password2 then
        self:setLabelStatue(self.lbl_password2_error, true, LangCtrl:getLang().word88)
        PlazaManager.showTips(LangCtrl:getLang().word53)
        return
    else
        self:setLabelStatue(self.lbl_password2_error, false, "")
    end

    -- 验证码
    local yzmStr = self.edit_yzm:getText()
    if self:isStrOk(yzmStr, 6) ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word42)
        return
    end

    -- 手机号
    if self.objMobile:verifyMobile() ~= 0 then
        PlazaManager.showTips(LangCtrl:getLang().word40)
        return
    end
    local phoneStr = self.objMobile:getMobileStr()
    local data = {}
    data.account = userNameStr
    data.password = password1
    data.szVerifyCode = yzmStr
    data.szMobilePhone = phoneStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word91, LangCtrl:getLang().word92)
    end
    PlazaManager.getLoginModule().onBindAccount(data, onConnectResult)
end

function BindAccountWinUI:onBindAccountResult(args)
    PlazaManager.closeWattingTips()

    if args.isSuccess == false then
        PlazaManager.closeLoginSocket()
        PlazaManager.showTips(args.szDescribeStr)
    else
        globalUserInfo.isBindAccount = true
        PlazaManager.showTips(LangCtrl:getLang().word90)
        if self.isOpenBank == true then
            self:onOpenBank()
        end
        self:removeFromParent()
    end
end

function BindAccountWinUI:onCheckLoginAccountSucc(args)
    self:setLabelStatue(self.lbl_yhm_error, false, "")
end

function BindAccountWinUI:onCheckLoginAccountFail(lResultCode, szDescribeString)
    if lResultCode == 8 and szDescribeString then
        self.edit_yhm:setText(szDescribeString)
        self:onCheckLoginAccountSucc()
        return
    end

    self:setLabelStatue(self.lbl_yhm_error, true, LangCtrl:getLang().word93)
end

function BindAccountWinUI:onCheckAccount(accountStr)
    local userNameStr = GameUtil.reomveString(accountStr, " ")

    if #userNameStr == 0 then
        self:setLabelStatue(self.lbl_yhm_error, true, LangCtrl:getLang().word94)
        return false
    end

    if GameUtil.isChineseString(userNameStr) == true then
        self:setLabelStatue(self.lbl_yhm_error, true, LangCtrl:getLang().word95)
        return false
    end

    if self:getUtf8Len(userNameStr) < 6 then
        self:setLabelStatue(self.lbl_yhm_error, true, LangCtrl:getLang().word96)
        return false
    end

    self:setLabelStatue(self.lbl_yhm_error, false, "")
    return true
end

function BindAccountWinUI:onCheckPassword(passwordStr)
    if #passwordStr == 0 then
        self:setLabelStatue(self.lbl_password1_error, true, LangCtrl:getLang().word94)
        return
    end

    if string.find(passwordStr, " ") ~= nil then
        self:setLabelStatue(self.lbl_password1_error, true, LangCtrl:getLang().word94)
        return
    end

    self:setLabelStatue(self.lbl_password1_error, false, "")
    return true
end

function BindAccountWinUI:editboxHandle(eventname, sender)
    local sendName = sender:getName()

    if eventname == "ended" then
        if sendName == "edityhm" then
            self:checkUserName()
        elseif sendName == "edit_phone" then
            local userNameStr = GameUtil.reomveString(self.edit_yhm:getText(), " ")
            if self:getUtf8Len(userNameStr) == 0 or self.lbl_yhm_error:isVisible() then
                self.edit_yhm:setText(self.objMobile.edit_phone:getText())
                self:checkUserName()
            end
        elseif sendName == "editpassword1" then
            local password1 = self.edit_password_1:getText()
            self:onCheckPassword(password1)
        elseif sendName == "editpassword2" then
            local password1 = self.edit_password_1:getText()
            if self:onCheckPassword(password1) == true then
                local password2 = self.edit_password_2:getText()
                if password1 ~= password2 then
                    self:setLabelStatue(self.lbl_password2_error, true, LangCtrl:getLang().word88)
                else
                    self:setLabelStatue(self.lbl_password2_error, false, "")
                end
            end
        end
    end
end

function BindAccountWinUI:checkUserName()
    local userNameText = self.edit_yhm:getText()
    userNameText = GameUtil.reomveString(userNameText, " ")
    self.edit_yhm:setText(userNameText)

    if self:onCheckAccount(userNameText) == true then
        if self.edit_yhm_oldStr ~= userNameText then
            self.edit_yhm_oldStr = userNameText

            local timeInterval = os.difftime(os.time(), self.sendTime)
            if timeInterval >= 1 then
                self.sendTime = os.time()
                PlazaManager.showConectWaitTips(nil)
                local function onConnectResult(isSuccess, ipsCount)
                    PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word56, LangCtrl:getLang().word57)
                end
                PlazaManager.getLoginModule().onCheckAccounts(userNameText, onConnectResult)
            else
                PlazaManager.showTips(LangCtrl:getLang().word99)
            end
        end
    end
end

function BindAccountWinUI:setLabelStatue(target, isVisible, str)
    if target == nil then
        return
    end
    if str == nil or str == "" then
        target:setString("")
    else
        target:setString(str)
    end

    if isVisible == true then
        target:setVisible(true)
    else
        target:setString("")
        target:setVisible(false)
    end
end

function BindAccountWinUI:getUtf8Len(input)
    local len = string.len(input)
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function BindAccountWinUI:onOpenBank()
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
        PlazaManager.closeLoginSocket()
        local winui = InputPassWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display:getRunningScene())
    end
end

function BindAccountWinUI:openView(isOpenBank)
    local winui = BindAccountWinUI.new(isOpenBank)
    winui:setCenterOnScene()
    winui:addTo(display.getRunningScene())
end

return BindAccountWinUI
