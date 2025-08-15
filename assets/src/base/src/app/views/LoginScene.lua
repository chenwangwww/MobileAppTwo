local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
local LoginLayer = require "app.views.LoginLayer"
local WeChatManager = require "app.platform.common.WeChatManager"
local AccountLoginUI = require "app.win.login.AccountLoginUI"
local RegisterUI = require "app.win.login.AccountRegisterUI"
local UserAgreementWin = require "app.win.login.UserAgreementUI"
local AccountCheckPhoneUI = require "app.win.login.AccountCheckPhoneUI"

function LoginScene:onCreate(notAutoLogin)
    PlazaManager.isDefaultOpenHall = true
    self:setContentSize(display.size)

    local data = PlazaManager.decoderAppStartParams()
    if data ~= nil and data.token ~= nil then
        if data.token == "1" or data.token == "2" then
            if data.zhAccount ~= nil and data.zhAccount ~= "" then
                cc.UserDefault:getInstance():setStringForKey("zh_c_account", data.zhAccount)
            end

            if data.zhPassword ~= nil and data.zhPassword ~= "" then
                cc.UserDefault:getInstance():setStringForKey("zh_c_password", data.zhPassword)
            end
        end
    end

    -- 设置微信分享回调
    if PlazaManager.isPhoneAndPadPlatform() == true then
        WeChatManager.setShareResult()
    end
    WeChatManager.setLoginCallback(handler(self, self.onLogin))

    self:initView()
    self:addEvent()
    self:onShowTestInfo()
end

function LoginScene:onDisConnection(name, ip, port, connNum, bgReconnect)
    if name ~= GameDefine.LOGIN_SOCKET or connNum >= 1 then
        return
    end
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(LangCtrl:getLang().word349)
end

function LoginScene:addEvent()
    self.onLoginFinishEventNotify = function()
        self:onLoginFinishEvent()
    end
    game.registerEvent(GameDefine.GP_LOGIN_FINISH_EVENT, self.onLoginFinishEventNotify)

    self.appEnterBackground = function()
        self:onAppEnterBackground()
    end
    game.registerEvent(GameDefine.APP_ENTERBACKGROUND, self.appEnterBackground)

    self.thirdStartEvent = function()
        self:onThirdStartSuccess()
    end
    game.registerEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.thirdStartEvent)

    self.onLoginFailerNotify = function(errorCode)
        self:onLoginFailer(errorCode)
    end
    game.registerEvent(GameDefine.onLoginFailer, self.onLoginFailerNotify)

    self.onNetDisConnectNotify = function(name, ip, port, connNum, bgReconnect)
        self:onDisConnection(name, ip, port, connNum, bgReconnect)
    end
    game.registerEvent("onDisConnectioned", self.onNetDisConnectNotify)
end

-- 登录完成
function LoginScene:onLoginFinishEvent()
    require("app.MyApp"):create():run("HallScene")
end

function LoginScene:onEnter()
    print("LoginScene:onEnter")
    PlazaManager.getLoginModule().resetLoginParams()
end

function LoginScene:onEnterTransitionFinish()
    self:onAutoLogin()
    if self.LoginLayer ~= nil then
        self.LoginLayer:setLayerVisible()
    end
end

function LoginScene:onExit()
    print("LoginScene:onExit")
    game.unregisterEvent(GameDefine.GP_LOGIN_FINISH_EVENT, self.onLoginFinishEventNotify)
    game.unregisterEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.thirdStartEvent)
    game.unregisterEvent(GameDefine.APP_ENTERBACKGROUND, self.appEnterBackground)
    game.unregisterEvent(GameDefine.onLoginFailer, self.onLoginFailerNotify)
    game.unregisterEvent("onDisConnectioned", self.onNetDisConnectNotify)
end

function LoginScene:onThirdStartSuccess()
    PlazaManager.closeWattingTips()
    self:onAutoLogin()
end

function LoginScene:onAppEnterBackground()
end

function LoginScene:onAutoLogin()
    --[[
    local function autoLogin()
        local openID = cc.UserDefault:getInstance():getStringForKey("wxOpenId", "")
        if openID ~= "" then
            self:onWXLogin()
        end
    end

    local isAgreementSelect = cc.UserDefault:getInstance():getBoolForKey("user_agreement", false)
    if PlazaManager.isPhoneAndPadPlatform() == true then
        if notAutoLogin == nil or notAutoLogin == false then
            if PlazaManager.isCheck == false and isAgreementSelect == true then
                self:runAction(cc.CallFunc:create(function()
                    autoLogin()
                end))
            end
        end
    end
    ]]
end

function LoginScene:initView()
    self.LoginLayer = LoginLayer.new(self, handler(self, self.onCallBack))
    if self.LoginLayer ~= nil then
        local args = {}
        args.versionStr = PlazaManager.getVersionStr()
        args.hitStr = ""
        args.declareStr = ""
        if PlazaManager.isCheck == false then
            args.hitStr = LangCtrl:getLang().word307
            args.declareStr = ""
        end
        self.LoginLayer:setLoadInfo(args)
        self:addChild(self.LoginLayer)
    end
end

function LoginScene:onCallBack(target, name)
    if name == "agreement" then
        self:openWinAgreement()
        self.LoginLayer:setUserAgreementStatue(true)
    else
        globalUserInfo.nGameListPageIdx = nil
        local result = cc.UserDefault:getInstance():getBoolForKey("user_agreement", false)
        if result == false then
            PlazaManager.showTips(LangCtrl:getLang().word350)
            return
        end

        if name == "weixin" then
            self:onWeiXinLogin()
        elseif name == "accountLogin" then
            self:openWinAccountLogin()
        elseif name == "youke" then
            self:openYouKeLogin()
        elseif name == "accountRegister" then
            self:openWinAccountRegister()
        end
    end
end

-- 用户协议
function LoginScene:openWinAgreement()
    local winui = UserAgreementWin.new()
    winui:setCenterOnScene()
    winui:addTo(self)
end

-- 游客登录
function LoginScene:openYouKeLogin()
    local account = GameDefine.MachineID
    local args = {}
    args.account = PlazaManager.getMd516(account)

    local str = PlazaManager.getMd516(args.account)
    str = string.format("%s#^(k", str)
    args.password = game.md5(str)

    args.headimgurl = string.format("icon_%d.png", 1)
    args.sex = 1
    local maxLen = math.min(#account, 5)
    args.nickName = LangCtrl:getLang().word309 .. string.sub(account, #account - maxLen, #account)

    local tempstr = PlazaManager.randomStr(3)
    args.nickName = string.gsub(args.nickName, "A7", tempstr) -- 敏感字符替换

    args.openIDAccount = args.account
    args.openIDPassword = args.password
    PlazaManager.loginType = GameDefine.LOGIN_TYPE.YK
    self:onLogin(args)
end

-- 微信登录
function LoginScene:onWeiXinLogin()
    self:onWXLogin(false)
end

-- 账号登录
function LoginScene:openWinAccountLogin()
    PlazaManager.loginType = GameDefine.LOGIN_TYPE.ACCOUNT
    local winui = AccountLoginUI.new(self, handler(self, self.onLogin))
    winui:setCenterOnScene()
    self:addChild(winui)
end

-- 注册账号
function LoginScene:openWinAccountRegister()
    PlazaManager.loginType = GameDefine.LOGIN_TYPE.ACCOUNT
    local loginLayer = RegisterUI.new(self, handler(self, self.onLogin))
    if loginLayer ~= nil then
        local x = (display.width - loginLayer:getContentSize().width) / 2
        local y = (display.height - loginLayer:getContentSize().height) / 2
        loginLayer:move(x, y):addTo(self)
    end
end

-- 微信登录
function LoginScene:onWXLogin(isAutoLogin)
    if PlazaManager.isPhoneAndPadPlatform() == true then
        PlazaManager.loginType = GameDefine.LOGIN_TYPE.WEIXIN

        local function onConnectWeChatFailer()
            PlazaManager.closeWattingTips()
            PlazaManager.showTips("获取微信授权失败")
        end

        PlazaManager.showWattingTips("获取微信授权中", GameDefine.processTime, onConnectWeChatFailer, nil, true)
        WeChatManager.onLogin(isAutoLogin)
    else
        PlazaManager.showTips("微信登录只能在android或者ios环境下")
    end
end

function LoginScene:onShowTestInfo()
    -- pc机或mac机显示测试账号
    if PlazaManager.platform == cc.PLATFORM_OS_MAC or PlazaManager.platform == cc.PLATFORM_OS_WINDOWS then
        self:onShowTestAccount()
    end
end

function LoginScene:onShowTestAccount()
    local dataFile = cc.FileUtils:getInstance():getStringFromFile("app/account.json")
    local jsonData = nil
    if #dataFile ~= 0 and dataFile ~= nil then
        jsonData = json.decode(dataFile)
    end

    local accounts = {}
    if jsonData ~= nil and jsonData.list ~= nil and jsonData.testAccount ~= nil then
        for key, var in ipairs(jsonData.list) do
            if var.id == jsonData.testAccount then
                if var.account_1 ~= nil then
                    table.insert(accounts, var.account_1)
                end
                if var.account_2 ~= nil then
                    table.insert(accounts, var.account_2)
                end
                if var.account_3 ~= nil then
                    table.insert(accounts, var.account_3)
                end
                if var.account_4 ~= nil then
                    table.insert(accounts, var.account_4)
                end
                break
            end
        end
    end

    if #accounts == 0 then
        return
    end

    for i, v in ipairs(accounts) do
        local btn_phone = ccui.Button:create()
        btn_phone:setTitleFontSize(40)
        btn_phone:setTag(i)
        btn_phone:setTitleText(accounts[i])
        btn_phone:align(display.LEFT_CENTER, display.left + 30, display.bottom + i * 60)
        btn_phone:addClickEventListener(function(sender)
            local account = sender:getTitleText()

            local args = {}
            args.account = PlazaManager.getMd516(account)

            local str = PlazaManager.getMd516(args.account)
            str = string.format("%s#^(k", str)
            args.password = game.md5(str)

            args.headimgurl = string.format("icon_%d.png", 1)
            args.sex = 1
            args.nickName = account
            args.openIDAccount = args.account
            args.openIDPassword = args.password

            PlazaManager.loginType = GameDefine.LOGIN_TYPE.YK
            self:onLogin(args)
        end)
        self:addChild(btn_phone)
    end
end

function LoginScene:onLoginFailer(errorCode)
    if errorCode == 21 then
        local winui = AccountCheckPhoneUI.new()
        winui:setCenterOnScene()
        winui:addTo(self)
    end
end

function LoginScene:onLogin(args, processStr, processErrorStr)
    if processStr == nil then
        processStr = LangCtrl:getLang().word288
    end

    if processErrorStr == nil then
        processErrorStr = LangCtrl:getLang().word289
    end

    if args == nil then
        PlazaManager.showTips(LangCtrl:getLang().word290)
        return
    end

    -- 连接服务器超时
    local function onConnectOutTime()
        PlazaManager.closeLoginSocket()
        PlazaManager.getLoginModule().clearLoginIPs()
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(LangCtrl:getLang().word246)
    end
    PlazaManager.showWattingTips(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)

    -- 连接结果
    local function onConnectResult(isSuccess, ipsCount)
        if isSuccess == false then
            if ipsCount > 0 then
                PlazaManager.setWattingData(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
            else
                PlazaManager.closeWattingTips()
                PlazaManager.showTips(LangCtrl:getLang().word246)
            end
        else
            PlazaManager.setWattingData(processStr, GameDefine.processTime, onConnectOutTime, nil, true)
        end
    end
    PlazaManager.getLoginModule().onLogin(args, onConnectResult)
end

return LoginScene
