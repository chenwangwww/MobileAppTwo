local HallScene = class("HallScene", cc.load("mvc").ViewBase)

local HallMainLayer = require "app.views.hall.HallMainLayer"
local HallGoldRoomLayer = require "app.views.hall.HallGoldRoomLayer"

local WelcomeWinUI = require "app.win.hall.WelcomeWinUI"
local BankWinUI = require "app.win.bank.BankWinUI"
local GiveAlmsWinUI = require "app.win.hall.GiveAlmsWinUI"
local BindPhoneTipWinUI = require "app.win.hall.BindPhoneTipWinUI"

-- LAYER最大个数
local LAYER_MAX_COUNT = 2

function HallScene:onCreate()
    if PlazaManager.isNewPlayer == true then
        if self:checkIsFirstEnter() == true then
            cc.UserDefault:getInstance():setBoolForKey("app_isNewPlayer", false)
            PlazaManager.isNewPlayer = false
        end
    end
end

-- 检测是否第一次进入游戏
function HallScene:checkIsFirstEnter()
    --[[
    if PlazaManager.isLock() == true  and  PlazaManager.isReturnHall == false then  --锁在房间里面 不是从游戏里面点击返回大厅
        result=true
    else
        local roomid = PlazaManager.isThirdStart()
        if roomid ~= nil then   --是否第三方启动
            result=true
        else
            local roominfo = PlazaManager.onCheckCopyRoomInfo(true)  --检查粘贴板
            if roominfo ~= nil then
                result=true
            end   
        end
    end
    ]]
    local result = false
    if PlazaManager.isLock() == true then
        result = true
    end

    return result
end

function HallScene:onEnter()
    self:onInitView()
    self.EventData = {}
    self:addEvent()

    PlazaManager.rankInfoRefreshTime = os.time()
    PlazaManager.getRefreshModule().onSearchRankInfo(3)
end

function HallScene:onEnterTransitionFinish()
    self:runAction(cc.CallFunc:create(function()
        self:checkIsLockGameServer()
    end))
    local function callFunction()
        PlazaManager.hallRefreshTime = os.time()
        PlazaManager.getRefreshModule().onRequestGameMessage()
    end
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callFunction, 30, false)
end

function HallScene:onExit()
    self:removeEvent()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
    PlazaManager.closeRefreshSocket()
    PlazaManager.closeLoginSocket()
end

-- 检查用户锁在游戏中
function HallScene:checkIsLockGameServer()
    --[[
    if PlazaManager.isLock() == true  and  PlazaManager.isReturnHall == false then  --锁在房间里面 不是从游戏里面点击返回大厅
        PlazaManager.onLoginLockServer()
    else
        local roomid = PlazaManager.isThirdStart()
        if roomid ~= nil then   --是否第三方启动
            PlazaManager.onJoinRoomByRoomID(roomid)
        else
            local roominfo = PlazaManager.onCheckCopyRoomInfo(true)  --检查粘贴板
            if roominfo == nil then
                self:onInitOtherFunction()
            else
                if PlazaManager.isClearCopyInfo == false then
                    if PlazaManager.isPhoneAndPadPlatform() == true then
                        game.systemCopy("")
                    end
                    PlazaManager.onJoinRoomByRoomID(roominfo)
                end
            end   
        end
    end
    ]]
    if PlazaManager.isLock() == true and PlazaManager.isReturnHall == false then -- 锁在房间里面 不是从游戏里面点击返回大厅
        PlazaManager.onLoginLockServer()
    end

    self:onInitOtherFunction()
end

-------------------------------其他功能函数---------------------------------------
function HallScene:onInitView()
    self.currentLayer = nil

    local layer_index = 1

    -- 获取需要打开的页面
    if PlazaManager.openHallLayerData ~= nil and PlazaManager.openHallLayerData.index ~= nil and type(PlazaManager.openHallLayerData.index) == "number" then
        layer_index = PlazaManager.openHallLayerData.index
    end

    -- 超出最大个数 说明赋值的数据出错
    if layer_index > LAYER_MAX_COUNT then
        layer_index = 1
        PlazaManager.openHallLayerData = nil
    end

    -- 是否指定打开默认layer
    if PlazaManager.isDefaultOpenHall == true then
        layer_index = 1
        PlazaManager.openHallLayerData = nil
    end

    local args = {}
    args.index = layer_index
    if PlazaManager.openHallLayerData ~= nil and PlazaManager.openHallLayerData.data ~= nil then
        args.wKindID = PlazaManager.openHallLayerData.data
    end

    -- 除引导页面，其他页面都把引导关闭
    if args.index ~= GameDefine.HALL_LAYER_INDEX.HALL and args.index ~= GameDefine.HALL_LAYER_INDEX.GOALHALL then
        cc.UserDefault:getInstance():setBoolForKey("app_isNewPlayer", false)
        PlazaManager.isNewPlayer = false
    end

    self:setSwitchLayer(args)

    PlazaManager.isDefaultOpenHall = false
end

function HallScene:setSwitchLayer(args)
    local index = args.index
    if self.currentLayer ~= nil then
        local layer_index = self.currentLayer:getLayerIndex()
        if layer_index == index then
            return
        end
    end

    local layer = nil
    if index == GameDefine.HALL_LAYER_INDEX.HALL then
        layer = HallMainLayer.new(args.nPageIdx)
    elseif index == GameDefine.HALL_LAYER_INDEX.GOLD_ROOM then
        layer = HallGoldRoomLayer.new(args.wKindID, args.nPageIdx)
    else
        layer = HallMainLayer.new(args.nPageIdx)
    end
    if layer ~= nil then
        if self.currentLayer ~= nil then
            self:removeChild(self.currentLayer)
            self.currentLayer = nil
        end
        self:addChild(layer)
        self.currentLayer = layer
    end
end

function HallScene:addEvent()
    self.EventData.serverEvent = function(wkindID)
        PlazaManager.doEnterGame(wkindID)
    end -- 登录游戏服务器完成
    self.EventData.thirdStartEvent = function()
        self:onThirdStartSuccess()
    end -- 第三方启动成功
    self.EventData.appEnterBackground = function(isEnterBackground)
        self:onAppEnterBackground(isEnterBackground)
    end -- 后台app返回
    self.EventData.switchLayerEvent = function(args)
        self:setSwitchLayer(args)
    end -- 大厅页面切换
    self.EventData.openWindowEvent = function(args)
        self:onOpenWindow(args)
    end -- 打开弹出框页面（创建房间页面）
    self.EventData.onAcceptListWelcomeEvent = function()
        self:onAcceptListWelcome()
    end -- 接受临时公告消息(目前不启用)
    self.EventData.onUpdataUserGoalInfoEvent = function()
        self:onUpdataUserGoalInfo()
    end -- 金币变化消息
    self.EventData.onGiveAlmsSuccessEvent = function(data)
        self:onGiveAlmsSuccess(data)
    end -- 领取救济金消息
    self.EventData.onLogonBankSucc = function()
        self:onLogonBankSucc()
    end -- 登录银行成功

    self.EventData.onNetDisConnectNotify = function(name, ip, port, connNum, bgReconnect)
        self:onDisConnection(name, ip, port, connNum, bgReconnect)
    end
    game.registerEvent("onDisConnectioned", self.EventData.onNetDisConnectNotify)

    game.registerEvent(GameDefine.GR_LOGIN_FINISH_EVENT, self.EventData.serverEvent)
    game.registerEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.EventData.thirdStartEvent)
    game.registerEvent(GameDefine.APP_ENTERBACKGROUND, self.EventData.appEnterBackground)
    game.registerEvent(GameDefine.SWITCH_HALL_LAYER, self.EventData.switchLayerEvent)
    game.registerEvent(GameDefine.OPEN_GAME_WINDOW, self.EventData.openWindowEvent)
    game.registerEvent(GameDefine.AcceptListWelcome, self.EventData.onAcceptListWelcomeEvent)
    game.registerEvent(GameDefine.UpdataUserGoalInfo, self.EventData.onUpdataUserGoalInfoEvent)
    game.registerEvent(GameDefine.GiveAlmsSuccess, self.EventData.onGiveAlmsSuccessEvent)
    game.registerEvent(GameDefine.Bank_Back_LogonSucc, self.EventData.onLogonBankSucc)
end

function HallScene:removeEvent()
    game.unregisterEvent(GameDefine.GR_LOGIN_FINISH_EVENT, self.EventData.serverEvent)
    game.unregisterEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.EventData.thirdStartEvent)
    game.unregisterEvent(GameDefine.SWITCH_HALL_LAYER, self.EventData.switchLayerEvent)
    game.unregisterEvent(GameDefine.OPEN_GAME_WINDOW, self.EventData.openWindowEvent)
    game.unregisterEvent(GameDefine.AcceptListWelcome, self.EventData.onAcceptListWelcomeEvent)
    game.unregisterEvent(GameDefine.APP_ENTERBACKGROUND, self.EventData.appEnterBackground)
    game.unregisterEvent(GameDefine.UpdataUserGoalInfo, self.EventData.onUpdataUserGoalInfoEvent)
    game.unregisterEvent(GameDefine.GiveAlmsSuccess, self.EventData.onGiveAlmsSuccessEvent)
    game.unregisterEvent(GameDefine.Bank_Back_LogonSucc, self.EventData.onLogonBankSucc)
    game.unregisterEvent("onDisConnectioned", self.EventData.onNetDisConnectNotify)
end

-- 第三方启动成功
function HallScene:onThirdStartSuccess()
    --    local roomid = PlazaManager.isThirdStart()
    --    if roomid ~= nil then
    --        game.clearAppStartParams()
    --        PlazaManager.resetRoomServer()
    --        PlazaManager.onJoinRoomByRoomID(roomid)
    --    end
end

-- 后台app返回
function HallScene:onAppEnterBackground(isEnterBackground)
    if isEnterBackground == false then
        local roomid = PlazaManager.onCheckCopyRoomInfo(true)
        if roomid ~= nil then
            if PlazaManager.isPhoneAndPadPlatform() == true then
                game.systemCopy("")
            end
            PlazaManager.resetRoomServer()
            PlazaManager.onJoinRoomByRoomID(roomid)
        end
    end
end

-- 打开弹出款（创建房间）
function HallScene:onOpenWindow(args)
    if args.type == "createRoom" then
        -- CreateRoomWin.new(args.data,nil,args.cbIsTvGame):align(cc.p(0,0),display.cx-375,display.cy-667):addTo(display.getRunningScene())
    end
end

-- 初始化其他功能
function HallScene:onInitOtherFunction()
    -- 如果公告不显示，检查是否显示提示绑定手机号页面
    if PlazaManager.isCheck == false then
        self:onShowBindPhoneTip()
    end
    self:onAcceptListWelcome()
end

-- 收到公告
function HallScene:onAcceptListWelcome()
    if (PlazaManager.WelcomeCount <= 0) then
        return
    end
    -- 检查是否有未显示的公告或者活动
    local exietChk = false
    for i = 1, PlazaManager.WelcomeCount do
        local welcomeItem = PlazaManager.WelcomeDataList[i]
        if (welcomeItem.wContentType == 0 or welcomeItem.wContentType == 1) and welcomeItem.msgState == 0 then
            exietChk = true
            break
        end
    end

    -- 显示公告页面
    if exietChk == true then
        local winui = WelcomeWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(self)
    end
end

-- 金币变化消息
function HallScene:onUpdataUserGoalInfo()
    if (globalUserInfo.lUserScore + globalUserInfo.lUserInsure) < 10000 then
        PlazaManager.getLoginModule().onGiveAlms(true)
    end
end

-- 领取救济金成功消息
function HallScene:onGiveAlmsSuccess(data)
    print("收到救济金领取消息 data.lAlms == " .. data.lAlms)
    if data.lAlms > 0 then -- 领取救济金成功
        local winui = GiveAlmsWinUI.new(data, false)
        winui:setCenterOnScene()
        winui:addToOnCheckExist(self)
    else
        local almsOverShowDataName = string.format("%s_GiveAlmsOverShowData", globalUserInfo.dwGameID)
        local dataStr = cc.UserDefault:getInstance():getStringForKey(almsOverShowDataName, "")
        local currDataStr = tostring(os.date("%x"))
        if currDataStr ~= dataStr and data.bTodayOver == 1 then
            local winui = GiveAlmsWinUI.new(data, true)
            winui:setCenterOnScene()
            winui:addToOnCheckExist(self)
            cc.UserDefault:getInstance():setStringForKey(almsOverShowDataName, currDataStr)
        end
    end
end

function HallScene:onLogonBankSucc()
    print("登录银行成功")
    PlazaManager.closeWattingTips()

    if PlazaManager.bankOpenType == 1 then
        if PlazaManager.bankIsLogonSucc == false then
            PlazaManager.bankIsLogonSucc = true
            PlazaManager.bankLogonTime = os.time()
        end

        local winui = BankWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display:getRunningScene())
    end
end

-- 检查是否显示提示绑定手机号页面
function HallScene:onShowBindPhoneTip()
    if PlazaManager.isCheck == true then
        return
    end

    if PlazaManager.BindPhoneTipShowChk == true then
        return true
    end
    if globalUserInfo.cbRegType == 1 then
        return
    end -- 微信账号不显示账号风险提示

    local nextShowSaveName = string.format("%s_BindPhoneTipShowChk", globalUserInfo.dwGameID)
    local showChk = cc.UserDefault:getInstance():getBoolForKey(nextShowSaveName, true)
    if showChk == true then
        if globalUserInfo.szRegisterMobile == nil or string.len(globalUserInfo.szRegisterMobile) == 0 then
            local winui = BindPhoneTipWinUI.new()
            winui:setCenterOnScene()
            winui:addToOnCheckExist(self)

            PlazaManager.BindPhoneTipShowChk = true
        end
    else
        if globalUserInfo.szRegisterMobile ~= nil and string.len(globalUserInfo.szRegisterMobile) > 0 then
            cc.UserDefault:getInstance():setBoolForKey(nextShowSaveName, true)
        end
    end
end

function HallScene:onDisConnection(name, ip, port, connNum, bgReconnect)
    if name ~= GameDefine.REFRESH_SOCKET and connNum == 0 then
        PlazaManager.closeWattingTips()
        PlazaManager.closeLoginSocket()
        PlazaManager.closeGameSocket()
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()
        -- PlazaManager.showTips("网络繁忙！")
    end
end

return HallScene
