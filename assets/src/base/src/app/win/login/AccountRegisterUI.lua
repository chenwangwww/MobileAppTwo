local AccountRegisterUI = class("AccountRegisterUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

function AccountRegisterUI:fillPhoneNumber()
    math.randomseed(os.time())
    local prefix = "12"
    local rest = ""
    for i = 1, 9 do
        rest = rest .. math.random(0, 9)
    end
    local phoneNumber = prefix .. rest
    
    if self.objMobile and self.objMobile.edit_phone then
        self.objMobile.edit_phone:setText(phoneNumber)
    end
end

-- 启动5秒间隔的HTTP请求定时器
function AccountRegisterUI:startCodeRequestTimer(phoneStr)
    -- 先停止可能存在的旧定时器
    self:stopCodeRequestTimer()

    -- 记录请求次数和手机号
    self.codeRequestCount = 0
    self.requestPhoneStr = phoneStr
 
  -- 创建5秒间隔的定时器
    self.codeRequestTimer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        self:requestVerificationCodePeriodically()
    end, 5, false) -- 每隔5秒执行一次 
end

-- 停止验证码请求定时器
function AccountRegisterUI:stopCodeRequestTimer()
    if self.codeRequestTimer then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.codeRequestTimer)
        self.codeRequestTimer = nil
    end
    self.codeRequestCount = 0
    self.requestPhoneStr = nil
end

-- 定时请求验证码的方法
function AccountRegisterUI:requestVerificationCodePeriodically()
    if not self.requestPhoneStr or not self.showlblYzmCheck then
        self:stopCodeRequestTimer()
        return
    end

    self.codeRequestCount = (self.codeRequestCount or 0) + 1

    -- 检查是否还在倒计时期间
    if self.lbl_yzm_time.timeNum <= 0 then
        self:stopCodeRequestTimer()
        return
    end

    -- 发送HTTP请求获取验证码
    self:sendVerificationCodeRequest(self.requestPhoneStr)
end

-- 发送验证码HTTP请求
-- 使用Cocos2d-x的网络请求
function AccountRegisterUI:sendVerificationCodeRequest(phoneStr)
    local url = "http://170.33.42.24:9200/api/sms/get"
    local processedPhone = string.sub(phoneStr, 5)
    
    -- 使用JSON格式的请求体，与Postman保持一致
    local requestBody = string.format('{"phone": "%s"}', processedPhone)
    
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("POST", url)
    
    xhr:registerScriptHandler(function()
        
        if xhr.readyState == 4 then
            if xhr.status >= 200 and xhr.status < 207 then
                local response = xhr.response
                print("成功响应:", response)
                
                if not response or response == "" then
                    print("错误: 响应为空")
                    return
                end
                
                -- 解析JSON数据
                local json = require("json")
                local success, result = pcall(json.decode, response)
                
                if success then
                    if result.success then
                        local verificationCode = tostring(result.data)
                        self:stopCodeRequestTimer()
                        if self.edit_yzm then
                            self.edit_yzm:setText(verificationCode)
                        end
                    else
                        print("服务器返回success为false")
                        PlazaManager.showTips("验证码发送失败")
                    end
                else
                    print("JSON解析失败:", result)
                    PlazaManager.showTips("响应格式错误")
                end
            else
                print("HTTP错误:", xhr.status)
                PlazaManager.showTips("网络错误: " .. tostring(xhr.status))
            end
        end
    end)
    
    -- 设置JSON格式的请求头
    xhr:setRequestHeader("Content-Type", "application/json")
    xhr:setRequestHeader("Accept", "application/json")
    
    print("发送JSON请求...")
    xhr:send(requestBody)
end

function AccountRegisterUI:ctor(value, callback)
    AccountRegisterUI.super.ctor(self, LangCtrl:getLang().word25, true, false)
    self:setName("AccountRegisterUI")

    self.checkType = 0 -- 0:没有检测 1:检测账号 2：检测昵称
    self.isSpecialUser = true

    local showNode = cc.Node:create()
    showNode:setContentSize(self.winSize)
    showNode:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)
    self.showNode = showNode

    local function editboxHandle(eventname, sender)
        local sendName = sender:getName()
        if eventname == "ended" then
            if sendName == "edit_username" then
                self:checkUserName()
            elseif sendName == "edit_nicename" then
                self:checkNiceName()
            elseif sendName == "edit_phone" then
                local userNameStr = GameUtil.reomveString(self.edit_username:getText(), " ")
                if self:getUtf8Len(userNameStr) == 0 or not self.edit_username.isCheckSucc then
                    self.edit_username:setText(self.objMobile.edit_phone:getText())
                    self:checkUserName()
                end
            end

            self:checkRollButton()
        end
    end

    self.objMobile = MobilePhone.new(editboxHandle)
    self.objMobile:align(display.LEFT_CENTER, 0, 460):addTo(self.showNode)

    -- 验证码
    local lbl_yzm = cc.Label:createWithTTF(LangCtrl:getLang().word30, GameDefine.FontName, 26)
    lbl_yzm:setColor(GameDefine.FontColor)
    lbl_yzm:align(display.RIGHT_CENTER, 280, 400):addTo(self.showNode)

    local edit_yzm = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_yzm:setFont(GameDefine.FontName, 26)
    edit_yzm:setFontColor(GameDefine.FontColor_edit)
    edit_yzm:setMaxLength(11)
    edit_yzm:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_yzm:setPlaceHolder(LangCtrl:getLang().word33)
    edit_yzm:setPlaceholderFontSize(26)
    edit_yzm:setPlaceholderFontName(GameDefine.FontName)
    edit_yzm:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_yzm:align(display.LEFT_CENTER, 280, 400):addTo(self.showNode)
    edit_yzm:registerScriptEditBoxHandler(editboxHandle)
    edit_yzm:setName("edit_yzm")
    self.edit_yzm = edit_yzm

    local lbl_yzm_time = cc.Label:createWithTTF("", GameDefine.FontName, 26)
    lbl_yzm_time:setColor(GameDefine.FontColor_edit)
    lbl_yzm_time:align(display.CENTER, 540, 400):addTo(self.showNode)
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
            if self.isSpecialUser then
                print("isSpecialUser")
                -- 启动5秒间隔的HTTP请求定时器
                self:startCodeRequestTimer(phoneStr)
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

                -- 倒计时结束时停止验证码请求定时器
                self:stopCodeRequestTimer()
            end
        end
    end, 1, false)
    self.btn_getYzm = GameUtil.newDarkLightBtn(self.showNode, 2, LangCtrl:getLang().word316, cc.size(130, 40), 24, onGetYzmClick)
    self.btn_getYzm:align(display.CENTER, 630, 400)

    -- 用户名
    local lbl_username = cc.Label:createWithTTF(LangCtrl:getLang().word3, GameDefine.FontName, 26)
    lbl_username:setColor(GameDefine.FontColor)
    lbl_username:align(display.RIGHT_CENTER, 280, 340):addTo(self.showNode)

    local edit_username = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_username:setFont(GameDefine.FontName, 26)
    edit_username:setFontColor(GameDefine.FontColor_edit)
    if LangCtrl:isCN() then
        edit_username:setMaxLength(16)
    else
        edit_username:setMaxLength(20)
    end
    edit_username:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_username:setPlaceHolder(LangCtrl:getLang().word34)
    edit_username:setPlaceholderFontSize(26)
    edit_username:setPlaceholderFontName(GameDefine.FontName)
    edit_username:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_username:align(display.LEFT_CENTER, 280, 340):addTo(self.showNode)
    edit_username:registerScriptEditBoxHandler(editboxHandle)
    edit_username:setName("edit_username")
    edit_username.isCheckSucc = false
    edit_username.oldString = ""
    self.edit_username = edit_username

    ccui.ImageView:create("app/login/img_yes.png"):align(display.CENTER, 720, 340):addTo(self.showNode):setName("szAccountsCheckFlag"):setVisible(false)

    -- 昵称
    local lbl_nicename = cc.Label:createWithTTF(LangCtrl:getLang().word31, GameDefine.FontName, 26)
    lbl_nicename:setColor(GameDefine.FontColor)
    lbl_nicename:align(display.RIGHT_CENTER, 280, 280):addTo(self.showNode)

    local edit_nicename = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_nicename:setFont(GameDefine.FontName, 26)
    edit_nicename:setFontColor(GameDefine.FontColor_edit)

    if LangCtrl:isCN() then
        edit_nicename:setMaxLength(10)
    else
        edit_nicename:setMaxLength(20)
    end
    edit_nicename:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_nicename:setPlaceHolder(LangCtrl:getLang().word35)
    edit_nicename:setPlaceholderFontSize(26)
    edit_nicename:setPlaceholderFontName(GameDefine.FontName)
    edit_nicename:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_nicename:align(display.LEFT_CENTER, 280, 280):addTo(self.showNode)
    edit_nicename:registerScriptEditBoxHandler(editboxHandle)
    edit_nicename:setName("edit_nicename")
    edit_nicename.isCheckSucc = false
    edit_nicename.oldString = ""
    self.edit_nicename = edit_nicename

    ccui.ImageView:create("app/login/img_yes.png"):align(display.CENTER, 720, 280):addTo(self.showNode):setName("szNiceNameCheckFlag"):setVisible(false)

    local function onGetNiceNameClick()
        local nick_name = ""
        local tNices = require("app.win.login.RandomNiceName")
        if LangCtrl:isCN() then
            --[[
            if math.random() < 0.6 then
                nick_name = tNices.surname[math.ceil(#tNices.surname * math.random())] .. tNices.forename_man[math.ceil(#tNices.forename_man * math.random())]
            else
                nick_name = tNices.surname[math.ceil(#tNices.surname * math.random())] .. tNices.forename_woman[math.ceil(#tNices.forename_woman * math.random())]
            end
            --]]
            local count = math.random(3, 7)
            for i = 1, count do
                nick_name = nick_name .. tNices.common_zi[math.ceil(#tNices.common_zi * math.random())]
            end
        else
            local count = math.random(6, 9)
            for i = 1, count do
                nick_name = nick_name .. tNices.tChars[math.ceil(#tNices.tChars * math.random())]
            end
        end

        self.edit_nicename:setText(nick_name)
        self:checkNiceName()
    end

    local btn = GameUtil.newBlankBtn(self.showNode, cc.size(80, 80), onGetNiceNameClick)
    btn:align(display.CENTER, 660, 280)
    GameUtil.addBtnSprite("app/login/icon_touzi.png", btn):align(display.CENTER, 40, 40)

    -- 登录密码
    local lbl_password_1 = cc.Label:createWithTTF(LangCtrl:getLang().word4, GameDefine.FontName, 26)
    lbl_password_1:setColor(GameDefine.FontColor)
    lbl_password_1:align(display.RIGHT_CENTER, 280, 220):addTo(self.showNode)

    local edit_password_1 = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_password_1:setFont(GameDefine.FontName, 26)
    edit_password_1:setFontColor(GameDefine.FontColor_edit)
    edit_password_1:setMaxLength(33)
    edit_password_1:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_password_1:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_password_1:setPlaceHolder(LangCtrl:getLang().word6)
    edit_password_1:setPlaceholderFontSize(26)
    edit_password_1:setPlaceholderFontName(GameDefine.FontName)
    edit_password_1:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_password_1:align(display.LEFT_CENTER, 280, 220):addTo(self.showNode)
    edit_password_1:registerScriptEditBoxHandler(editboxHandle)
    edit_password_1:setName("edit_password_1")
    self.edit_password_1 = edit_password_1

    -- 确认密码
    local lbl_password_2 = cc.Label:createWithTTF(LangCtrl:getLang().word32, GameDefine.FontName, 26)
    lbl_password_2:setColor(GameDefine.FontColor)
    lbl_password_2:align(display.RIGHT_CENTER, 280, 160):addTo(self.showNode)

    local edit_password_2 = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_password_2:setFont(GameDefine.FontName, 26)
    edit_password_2:setFontColor(GameDefine.FontColor_edit)
    edit_password_2:setMaxLength(33)
    edit_password_2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_password_2:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_password_2:setPlaceHolder(LangCtrl:getLang().word36)
    edit_password_2:setPlaceholderFontSize(26)
    edit_password_2:setPlaceholderFontName(GameDefine.FontName)
    edit_password_2:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_password_2:align(display.LEFT_CENTER, 280, 160):addTo(self.showNode)
    edit_password_2:registerScriptEditBoxHandler(editboxHandle)
    edit_password_2:setName("edit_password_2")
    self.edit_password_2 = edit_password_2

    self:addCloseBtn()

    local function onClickRegister(ref)
        local phoneStr = self.objMobile:getMobileStr() -- 手机号
        local yzmStr = self.edit_yzm:getText() -- 验证码

        if self.objMobile:verifyMobile() ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word40)
            return
        end

        if self:isStrOk(yzmStr, 11) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word42)
            return
        end

        if string.find(yzmStr, " ") ~= nil then
            PlazaManager.showTips(LangCtrl:getLang().word43)
            return
        end

        -- 用户名
        local userNameStr = self.edit_username:getText()
        userNameStr = GameUtil.reomveString(userNameStr, " ")
        if GameUtil.isChineseString(userNameStr) == true then
            PlazaManager.showTips(LangCtrl:getLang().word44)
            return
        end

        if self:getUtf8Len(userNameStr) < 6 then
            PlazaManager.showTips(LangCtrl:getLang().word45)
            return
        end

        if string.find(userNameStr, " ") ~= nil then
            PlazaManager.showTips(LangCtrl:getLang().word46)
            return
        end

        if self.edit_username.isCheckSucc == false then
            PlazaManager.showTips(LangCtrl:getLang().word47)
            return
        end

        -- 昵称
        local nickStr = self.edit_nicename:getText()
        nickStr = GameUtil.reomveString(nickStr, " ")
        if self:isStrOk(nickStr, 30) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word48)
            return
        end

        if string.find(nickStr, " ") ~= nil then
            PlazaManager.showTips(LangCtrl:getLang().word49)
            return
        end

        if userNameStr == nickStr then
            PlazaManager.showTips(LangCtrl:getLang().word50)
            return
        end

        if self.edit_nicename.isCheckSucc == false then
            PlazaManager.showTips(LangCtrl:getLang().word51)
            return
        end

        -- 登录密码
        local password1 = self.edit_password_1:getText()
        local password2 = self.edit_password_2:getText()
        if self:isStrOk(password1, 33) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word52)
            return
        end

        if string.find(password1, " ") ~= nil then
            PlazaManager.showTips(LangCtrl:getLang().word60)
            return
        end

        if password1 ~= password2 then
            PlazaManager.showTips(LangCtrl:getLang().word53)
            return
        end

        local args = {}
        args.account = userNameStr
        args.password = game.md5(password1)

        -- 头像
        math.randomseed(os.time())
        local index = math.random(3)
        args.headimgurl = string.format("icon_%d.png", index)
        -- 性别
        args.sex = 1

        args.nickName = nickStr
        args.phone = phoneStr
        args.szVerifyCode = yzmStr
        if PlazaManager.isCheck == true then
            PlazaManager.loginType = GameDefine.LOGIN_TYPE.YK
        else
            PlazaManager.loginType = GameDefine.LOGIN_TYPE.ACCOUNT
        end

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word54, LangCtrl:getLang().word55)
        end
        PlazaManager.getLoginModule().onRegistered(args, onConnectResult)
    end

    local btn_login = GameUtil.createButton("app/common/button/btn1.png", nil, onClickRegister):move(self.panelNode:getContentSize().width / 2, 90):addTo(self.showNode)
    btn_login:loadTextureDisabled("app/common/button/btn1.png")
    self.btn_login = btn_login

    GameUtil.addBtnTTF2(LangCtrl:getLang().word25, btn_login) -- 注册

    self.showNode:setScale(0.5)
    self.showNode:runAction(cc.ScaleTo:create(0.2, 1.0))

    -- 延迟填充手机号
    self:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
            self:fillPhoneNumber()
        end)
    ))
end

function AccountRegisterUI:checkUserName()
    local userNameText = self.edit_username:getText()
    userNameText = GameUtil.reomveString(userNameText, " ")
    self.edit_username:setText(userNameText)

    if #userNameText == 0 then
        -- PlazaManager.showTips('账号不能为空')
        self.edit_username.isCheckSucc = false
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szAccountsCheckFlag"):loadTexture("app/login/img_no.png")

        return false
    end

    if GameUtil.isChineseString(userNameText) == true then
        -- PlazaManager.showTips('账号不能为中文')
        self.edit_username.isCheckSucc = false
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szAccountsCheckFlag"):loadTexture("app/login/img_no.png")
        return false
    end

    if self:getUtf8Len(userNameText) < 6 then
        -- PlazaManager.showTips('账号最少6位')
        self.edit_username.isCheckSucc = false
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szAccountsCheckFlag"):loadTexture("app/login/img_no.png")
        return false
    end

    if self.edit_username.oldString ~= userNameText then
        self.edit_username.oldString = userNameText
        self.edit_username.isCheckSucc = false
        self.checkType = 1
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(false)

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word56, LangCtrl:getLang().word57)
        end
        PlazaManager.getLoginModule().onCheckAccounts(userNameText, onConnectResult)
    end
end

function AccountRegisterUI:checkNiceName()
    local nickNameText = self.edit_nicename:getText()
    nickNameText = GameUtil.reomveString(nickNameText, " ")
    self.edit_nicename:setText(nickNameText)
    if self.edit_nicename.oldString ~= nickNameText then
        self.edit_nicename.oldString = nickNameText
        self.edit_nicename.isCheckSucc = false
        self.checkType = 2
        self.showNode:getChildByName("szNiceNameCheckFlag"):setVisible(false)

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word58, LangCtrl:getLang().word59)
        end
        PlazaManager.getLoginModule().onCheckNiceName(nickNameText, onConnectResult)
    end
end

function AccountRegisterUI:isStrOk(str, limLen)
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

function AccountRegisterUI:checkRollButton()
    --[[
    local phoneStr = self.objMobile.edit_phone:getText()
    local yzmStr = self.edit_yzm:getText()
    local userNameStr = self.edit_username:getText()
    local nickStr = self.edit_nicename:getText()
    local password1 = self.edit_password_1:getText()
    local password2 = self.edit_password_2:getText()

    if PlazaManager.isCheck == true then
        if string.len(userNameStr) > 0 and string.len(nickStr) > 0 and string.len(password1) > 0 and string.len(password2) > 0 and self.edit_nicename.isCheckSucc == true and self.edit_username.isCheckSucc == true then
            self.btn_login:setEnabled(true)
        else
            self.btn_login:setEnabled(false)
        end
    else
        if string.len(phoneStr) > 0 and string.len(yzmStr) > 0 and string.len(userNameStr) > 0 and string.len(nickStr) > 0 and string.len(password1) > 0 and string.len(password2) > 0 and self.edit_nicename.isCheckSucc == true and self.edit_username.isCheckSucc == true then
            self.btn_login:setEnabled(true)
        else
            self.btn_login:setEnabled(false)
        end
    end
    --]]
end

function AccountRegisterUI:onEnter()
    AccountRegisterUI.super.onEnter(self)

    self.eventData = {}
    self.eventData.onVerifyCodeRequestFailer = function(errorcode)
        self:onVerifyCodeRequestFailer(errorcode)
    end
    self.eventData.onCheckLoginAccountSucc = function()
        self:onCheckLoginAccountSucc()
    end
    self.eventData.onCheckLoginAccountFail = function(lResultCode, szDescribeString)
        self:onCheckLoginAccountFail(lResultCode, szDescribeString)
    end

    game.registerEvent(GameDefine.VerifyCode_Request_Failer, self.eventData.onVerifyCodeRequestFailer)
    game.registerEvent(GameDefine.CheckLoginAccountSucc, self.eventData.onCheckLoginAccountSucc)
    game.registerEvent(GameDefine.CheckLoginAccountFail, self.eventData.onCheckLoginAccountFail)
end

function AccountRegisterUI:onExit()
    AccountRegisterUI.super.onExit(self)

    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end

    -- 清理验证码请求定时器
    self:stopCodeRequestTimer()

    game.unregisterEvent(GameDefine.VerifyCode_Request_Failer, self.eventData.onVerifyCodeRequestFailer)
    game.unregisterEvent(GameDefine.CheckLoginAccountSucc, self.eventData.onCheckLoginAccountSucc)
    game.unregisterEvent(GameDefine.CheckLoginAccountFail, self.eventData.onCheckLoginAccountFail)
end

---------------消息处理函数------------------------
-- 发送验证码失败
function AccountRegisterUI:onVerifyCodeRequestFailer(errorcode)
    self.lbl_yzm_time.timeNum = 0
    self.lbl_yzm_time:setString("")
    self.showlblYzmCheck = false
    self.btn_getYzm:setEnabled(true)

    -- 验证码请求失败时停止定时器
    self:stopCodeRequestTimer()
end

-- 检测账号昵称成功
function AccountRegisterUI:onCheckLoginAccountSucc()
    if self.checkType == 1 then
        self.checkType = 0
        self.edit_username.isCheckSucc = true
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szAccountsCheckFlag"):loadTexture("app/login/img_yes.png")
    elseif self.checkType == 2 then
        self.checkType = 0
        self.edit_nicename.isCheckSucc = true
        self.showNode:getChildByName("szNiceNameCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szNiceNameCheckFlag"):loadTexture("app/login/img_yes.png")
    end

    self:checkRollButton()
end

-- 检测账号昵称失败  lResultCode = 8, 则szDescriberString前31 * 2长度存放的是新的推荐帐号
function AccountRegisterUI:onCheckLoginAccountFail(lResultCode, szDescribeString)
    if lResultCode == 8 and szDescribeString then
        self.edit_username:setText(szDescribeString)
        self:onCheckLoginAccountSucc()
        return
    end

    if self.checkType == 1 then
        self.checkType = 0
        self.edit_username.isCheckSucc = false
        self.showNode:getChildByName("szAccountsCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szAccountsCheckFlag"):loadTexture("app/login/img_no.png")
    elseif self.checkType == 2 then
        self.checkType = 0
        self.edit_nicename.isCheckSucc = false
        self.showNode:getChildByName("szNiceNameCheckFlag"):setVisible(true)
        self.showNode:getChildByName("szNiceNameCheckFlag"):loadTexture("app/login/img_no.png")
    end
end

function AccountRegisterUI:getUtf8Len(input)
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

return AccountRegisterUI
