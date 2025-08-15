local BaseGameScene = class("BaseGameScene", cc.load("mvc").ViewBase)

local GameShareWin = require "app.win.game.GameShareWin"
local GiveAlmsWinUI = require "app.win.hall.GiveAlmsWinUI"

local RecordUI = require "app.win.Record.RecordUI"
local NewPlayerGuideDate = require "app.platform.data.NewPlayerGuideDate"

local connIntervalTime = -1
local connWin = nil
local enterBackgroundTime = 0
local willEnterForegroundTime = 0
local difftime = 0

---------------------------------生命周期函数-------------------------
function BaseGameScene:onCreate()
    self:initData()

    if PlazaManager.isNewPlayer == true then
        NewPlayerGuideDate:GameScen_IniGameRoomData()
    end
end

-- 进入场景完成
function BaseGameScene:onEnterTransitionFinish()
    if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
        self:autoSitDown()
    end

    self:addListenerEvent()

    if PlazaManager.isRecordModule() == false then
        if PlazaManager.isNewPlayer ~= true then
            -- 请求游戏配置
            if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
                print("请求游戏配置")
                ModuleMgr.getModule(GameDefine.GAME_MODULE).onQuestOption()
            end
        end
    else
        -- 启动录像ui
        self:createRecordUI()
    end
    self.baseSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateGameTime), 1, false)
end

-- 退出场景
function BaseGameScene:onExit()
    printLog("BaseGameScene", "BaseGameScene:onExit")
end

function BaseGameScene:onCleanup()
    printLog("BaseGameScene", "BaseGameScene:onCleanup")
end

---------------------------------网络函数-----------------------------------
-- 网络是否断开
function BaseGameScene:isDisConnect()
    local netCount = game.getConnectNum(GameDefine.GAME_SOCKET)
    if netCount > 0 then
        return false
    end
    return true
end

--------------------------------声音播放函数-------------------------------
function BaseGameScene:playEffect(path)
    MusicManager.playEffect(path)
end

function BaseGameScene:playBGM(path)
    MusicManager.playBGM(path)
end

function BaseGameScene:stopBGM()
    MusicManager.stopBGM()
end

--------------------------------数据重置------------------------------------
-- 进入游戏初始化参数
function BaseGameScene:initData()
    self.isCopyRoomID = false
    -- 事件
    self.eventData = {}
    -- 桌子玩家列表
    self.tableUserList = {}
    -- 准备列表
    self.tableUserReady = {}
    -- 是否打开场景
    PlazaManager.isOpenGameScene = true
    -- 调度句柄
    self.baseSchedulerID = nil
    -- 刷新设备时间间隔
    self.refreshDeviceTime = 0
    -- 刷新游戏数据时间间隔
    self.refreshGameTime = -1
    -- 账号重复登录
    -- self.accountAgainLogin = false
    -- 断开连接
    self.gameDisConnection = false
    -- 断线重连重置数据
    self:onResetData()
    -- 重置断线参数
    self:onResetGameDisConnection()
    -- 清除启动参数(避免进入游戏退出又重新申请进入)
    if PlazaManager.isPhoneAndPadPlatform() == true then
        game.clearAppStartParams()
        -- game.systemCopy("")
    end

    -- 救济金数据
    self.isLateShowGiveAlmsWin = false
    self.GiveAlmsData = nil

    PlazaManager.ChangeRoomStartChk = false

    PlazaManager.lockGameServerSitMsg = 0
end

-- 离开游戏清空数据
function BaseGameScene:resetBaseData()
    -- 服务端发送过来强制关闭房间
    PlazaManager.closeRoombyServer = 0
    -- 服务端发送过来强制关闭游戏
    PlazaManager.closeGamebyServer = 0

    if PlazaManager.isRecordModule() == true then
        PlazaManager.isDefaultOpenHall = false
        PlazaManager.isOpenGameScene = false
        PlazaManager.closeGameSocket()
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()

        -- 重置录像管理信息
        if PlazaManager.recordManager ~= nil then
            PlazaManager.recordManager:onClose()
            PlazaManager.recordManager = nil
        end
    end

    PlazaManager.isDefaultOpenHall = false
    PlazaManager.isOpenGameScene = false
    PlazaManager.getServerModule().onQuestOutConect()
    PlazaManager.lockGameServerSitMsg = 1

    MusicManager.uncacheAll()

    self:removeListenerEvent()
    self.tableUserList = {}
    self.eventData = {}
    self.tableUserReady = {}
    self.refreshDeviceTime = 0
    self.gameDisConnection = false

    if self.baseSchedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.baseSchedulerID)
        self.baseSchedulerID = nil
    end

    if self.isCopyRoomID then -- 自己有复制房间号
        if PlazaManager.isPhoneAndPadPlatform() == true then
            PlazaManager.isClearCopyInfo = true
            game.systemCopy("")
        end
    end
    self.isCopyRoomID = false

    PlazaManager.ChangeRoomStartChk = false
end

-- 重置玩家准备数据
function BaseGameScene:onResetUserReady(count)
    if count ~= nil and type(count) == "number" and count > 0 then
        for i = 1, count do
            self.tableUserReady[i] = false
        end
    end
end
-- 判断玩家是否准备，参数为Index
function BaseGameScene:getUserReadyByIndex(index)
    local result = false
    local isReady = self.tableUserReady[index]
    if isReady ~= nil then
        result = isReady
    end
    return result
end

-- 清除玩家列表
function BaseGameScene:clearTableUserList()
    self.tableUserList = {}
end

-- 断线重连重置数据
function BaseGameScene:onResetData()
    PlazaManager.clearLockData()
    PlazaManager.isReturnHall = false
    self:clearTableUserList()
end

-- 重置断线参数
function BaseGameScene:onResetGameDisConnection()
    self.gameDisConnection = false
    print("重置断线参数")
end

-----------------------------场景功能函数------------------------------
-- 离开游戏界面,返回大厅
function BaseGameScene:onExitGame()
    self:resetBaseData()
    PlazaManager.isGameOutHall = true

    local function callbackFunction()
        print("退出开始时间 == " .. game.getSystemTime())
        PlazaManager.closeRefreshSocket()
        PlazaManager.closeGameSocket()
        PlazaManager.lockGameServerSitMsg = 0
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()
        PlazaManager.resetGoalRoomInfo()

        local gameInfo = PlazaManager.getUrlGameInfoByKindID(PlazaManager.curKindID)
        if gameInfo ~= nil then
            if gameInfo.isVerticalScreen == 1 then -- if gameInfo.isVerticalScreen == 1 then
                GameUtil.changeRootView_H(true)
            else
                GameUtil.setGameScreenFit(true)
            end
        end

        if PlazaManager.isNewPlayer == true then
            PlazaManager.openHallLayerData.index = GameDefine.HALL_LAYER_INDEX.HALL
            NewPlayerGuideDate:GameScen_ResetGameRoomData()
            PlazaManager.isNewPlayer = false
            cc.UserDefault:getInstance():setBoolForKey("app_isNewPlayer", false)
        end

        PlazaManager.closeWattingTips()

        print("退出结束时间== " .. game.getSystemTime())
        require("app.MyApp"):create():run("HallScene")
    end
    print("启动150毫秒后退出游戏 == " .. game.getSystemTime())
    local action_1 = cc.CallFunc:create(function()
        callbackFunction()
    end)
    local action_2 = cc.Sequence:create(cc.ScaleBy:create(0.15, 1), action_1)
    self:runAction(action_2)
end

-- 返回大厅
function BaseGameScene:onReturnHall()
    if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS or PlazaManager.curGameType ==
        GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
        if PlazaManager.gameStatus.cbGameStatus ~= GameDefine.GAME_STATUS_END then
            PlazaManager.isReturnHall = true
            self:onSaveLockInfo()
        end

        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()
        self:onExitGame()
    end
end

----------------------------向服务器发送请求消息--------------------------------
-- 换桌函数(指定桌子传参数,不指定桌子不用传)
function BaseGameScene:ChangeRoom(wTableID, szRoomID)
    if PlazaManager.gameServer == nil then
        PlazaManager.showTips(LangCtrl:getLang().word256)
        return
    end

    -- 连接超时
    local function connectionOutTime()
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(LangCtrl:getLang().word257)
    end
    PlazaManager.showWattingTips(LangCtrl:getLang().word258, GameDefine.processTime, connectionOutTime)

    PlazaManager.ChangeRoomStartChk = true

    local sendwTableID = GameDefine.INVALID_TABLE
    local sendwRoomID = ""
    if wTableID ~= nil then
        sendwTableID = wTableID
    end
    if szRoomID ~= nil then
        sendwRoomID = szRoomID
    end

    local enterdata = {}
    enterdata.wTableID = sendwTableID
    enterdata.wChairID = GameDefine.INVALID_CHAIR
    enterdata.szPassword = ""
    enterdata.szPersonalTableID = sendwRoomID
    PlazaManager.getServerModule().onQuestSitDwon(enterdata)
end

-- 申请站起 mustOutChk 1：强制退出，0非强制退出
function BaseGameScene:onQuestStandup(mustOutChk)
    local outChk = 1
    if mustOutChk ~= nil then
        outChk = mustOutChk
    end

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_USER, game.SUB_GR_USER_STANDUP, 1024)
    rpcSend:writeUInt16(globalUserInfo.wTableID)
    rpcSend:writeUInt16(globalUserInfo.wChairID)
    rpcSend:writeUInt8(outChk)
    rpcSend:release()
end

-- 申请解散包房
function BaseGameScene:onQuestDisMissPrivate()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_PERSONAL_TABLE, game.SUB_GR_CANCEL_REQUEST, 1024)
    rpcSend:writeUInt32(globalUserInfo.dwUserID)
    rpcSend:writeUInt32(globalUserInfo.wTableID)
    rpcSend:writeUInt32(globalUserInfo.wChairID)
    local dwElpase = 0
    rpcSend:writeUInt32(dwElpase)
    rpcSend:release()
end

-- 答复解散包房
function BaseGameScene:onCSDisMissPrivateReply(cbAgree)
    if cbAgree == nil then
        cbAgree = 0
    end

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_PERSONAL_TABLE, game.SUB_GR_REQUEST_REPLY, 1024)
    rpcSend:writeUInt32(globalUserInfo.dwUserID)
    rpcSend:writeUInt32(globalUserInfo.wTableID)
    rpcSend:writeUInt8(cbAgree)
    rpcSend:release()
end

-- 请求准备
function BaseGameScene:onQuestReady()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_READY, 1024)
    rpcSend:release()
end

------------------------------监听网络消息--------------------------------------------
-- 监听网络消息
function BaseGameScene:addListenerEvent()
    -- 进入场景消息
    self.eventData.onUserEnter = function(gameUser)
        self:onUserEnter(gameUser)
    end -- 玩家进入消息
    self.eventData.onGameStatus = function()
        self:onGameStatus()
    end -- 游戏状态消息（只有进入时接受到一次）
    self.eventData.onUserStatus = function(gameUser)
        self:onUserStatus(gameUser)
    end -- 玩家状态改变消息
    self.eventData.onPrivateInfo = function(args)
        self:onPrivateInfo(args)
    end -- 包房详细细信息
    self.eventData.onGameScene = function(data) -- 场景消息
        -- 换桌时重置用户数据
        if PlazaManager.ChangeRoomStartChk == true then
            self:clearTableUserList()
            self:onChangeRoomSucc()
            self:autoSitDown()
            PlazaManager.ChangeRoomStartChk = false
        end
        self:onGameScene(data)
        self:onResetGameDisConnection()
        PlazaManager.closeWattingTips()
    end

    -- 游戏中消息
    self.eventData.onGame = function(cmdID, data, wChair)
        self:onGame(cmdID, data, wChair)
    end -- 游戏消息
    self.eventData.onUserScore = function(gameUser)
        self:onUserScore(gameUser)
    end -- 玩家积分改变消息
    self.eventData.onDisMissPrivate = function(args)
        self:onDisMissPrivate(args)
    end -- 申请解散包房
    self.eventData.onDisMissPrivateReply = function(args)
        self:onDisMissPrivateReply(args)
    end -- 服务端返回解散包房的答复
    self.eventData.onDisMissPrivateResult = function(args)
        self:onDisMissPrivateResult(args)
    end -- 解散包房结果
    self.eventData.onCSDisMissPrivateReply = function(args)
        self:onCSDisMissPrivateReply(args)
    end -- 客户端答复解散包房

    -- 其他消息
    self.eventData.onCloseScene = function(event_type)
        self:onCloseScene(event_type)
    end -- 关闭游戏场景消息
    self.eventData.onTableStatueChange = function(statueID)
        self:onTableStatueChange(statueID)
    end -- 房间桌子子状态改变
    self.eventData.onGiveAlmsEvent = function(data)
        self:onGiveAlmsSuccess(data)
    end -- 领取救济金

    self.eventData.onChatPlay = function(data)
        self:onChatPlay(data)
    end -- 语音聊天消息
    self.eventData.onDisConnection = function(name, ip, port, connNum, bgReconnect)
        self:onDisConnection(name, ip, port, connNum, bgReconnect)
    end
    -- 断开网络连接
    self.eventData.onConnectFailer = function(name)
        self:onConnectFailer(name)
    end -- 网络连接失败
    self.eventData.onEnterBackground = function(isEnterBackground)
        self:onEnterBackgroundBase(isEnterBackground)
    end -- app前后台切换
    self.eventData.onThirdStartEvent = function()
        self:onThirdStartSuccess()
    end -- 第三方启动
    self.eventData.onAcceptTrumpetContent = function(trumpetData)
        self:onAcceptTrumpetContent(trumpetData)
    end -- 收到游戏喇叭公告
    self.eventData.onAcceptTrumpetContentRoll = function(trumpetData)
        self:onAcceptTrumpetContentRoll(trumpetData)
    end -- 收到游戏喇叭公告(改成游戏中滚动)
    self.eventData.onConnectSuccess = function(name)
        self:onConnectSuccess(name)
    end

    game.registerEvent(GameDefine.GR_USER_ENTER, self.eventData.onUserEnter)
    game.registerEvent(GameDefine.GR_GAME_STATUS, self.eventData.onGameStatus)
    game.registerEvent(GameDefine.GR_USER_STATUS, self.eventData.onUserStatus)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.eventData.onPrivateInfo)
    game.registerEvent(GameDefine.GR_GAME_SCENE, self.eventData.onGameScene)

    game.registerEvent(GameDefine.GR_GAME, self.eventData.onGame)
    game.registerEvent(GameDefine.GR_USER_SCORE, self.eventData.onUserScore)
    game.registerEvent(GameDefine.SC_GR_DISMISS_PRIVATE, self.eventData.onDisMissPrivate)
    game.registerEvent(GameDefine.SC_GR_DISMISS_PRIVATE_REPLY, self.eventData.onDisMissPrivateReply)
    game.registerEvent(GameDefine.SC_GR_DISMISS_PRIVATE_RESULT, self.eventData.onDisMissPrivateResult)
    game.registerEvent(GameDefine.CS_GR_QUEST_DISMISS_PRIVATE_REPLY, self.eventData.onCSDisMissPrivateReply)

    game.registerEvent(GameDefine.EXIT_GAMESCENE_FINISH_EVENT, self.eventData.onCloseScene)
    game.registerEvent(GameDefine.GameTableStatueChange, self.eventData.onTableStatueChange)
    game.registerEvent(GameDefine.GiveAlmsSuccessByGame, self.eventData.onGiveAlmsEvent)

    game.registerEvent(GameDefine.GF_USER_CHAT, self.eventData.onChatPlay)
    game.registerEvent("onDisConnectioned", self.eventData.onDisConnection)
    game.registerEvent(GameDefine.CONNECTION_FAILER, self.eventData.onConnectFailer)
    game.registerEvent(GameDefine.APP_ENTERBACKGROUND, self.eventData.onEnterBackground)
    game.registerEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.eventData.onThirdStartEvent)
    game.registerEvent(GameDefine.AcceptTrumpetContent, self.eventData.onAcceptTrumpetContent)
    game.registerEvent(GameDefine.AcceptTrumpetContentRoll, self.eventData.onAcceptTrumpetContentRoll)
    game.registerEvent(GameDefine.CONNECTION_SUCCESS, self.eventData.onConnectSuccess)
end

function BaseGameScene:removeListenerEvent()
    game.unregisterEvent(GameDefine.GR_USER_ENTER, self.eventData.onUserEnter)
    game.unregisterEvent(GameDefine.GR_GAME_STATUS, self.eventData.onGameStatus)
    game.unregisterEvent(GameDefine.GR_USER_STATUS, self.eventData.onUserStatus)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.eventData.onPrivateInfo)
    game.unregisterEvent(GameDefine.GR_GAME_SCENE, self.eventData.onGameScene)

    game.unregisterEvent(GameDefine.GR_GAME, self.eventData.onGame)
    game.unregisterEvent(GameDefine.GR_USER_SCORE, self.eventData.onUserScore)
    game.unregisterEvent(GameDefine.SC_GR_DISMISS_PRIVATE, self.eventData.onDisMissPrivate)
    game.unregisterEvent(GameDefine.SC_GR_DISMISS_PRIVATE_REPLY, self.eventData.onDisMissPrivateReply)
    game.unregisterEvent(GameDefine.SC_GR_DISMISS_PRIVATE_RESULT, self.eventData.onDisMissPrivateResult)
    game.unregisterEvent(GameDefine.CS_GR_QUEST_DISMISS_PRIVATE_REPLY, self.eventData.onCSDisMissPrivateReply)

    game.unregisterEvent(GameDefine.EXIT_GAMESCENE_FINISH_EVENT, self.eventData.onCloseScene)
    game.unregisterEvent(GameDefine.GameTableStatueChange, self.eventData.onTableStatueChange)
    game.unregisterEvent(GameDefine.GiveAlmsSuccessByGame, self.eventData.onGiveAlmsEvent)

    game.unregisterEvent(GameDefine.GF_USER_CHAT, self.eventData.onChatPlay)
    game.unregisterEvent("onDisConnectioned", self.eventData.onDisConnection)
    game.unregisterEvent(GameDefine.CONNECTION_FAILER, self.eventData.onConnectFailer)
    game.unregisterEvent(GameDefine.APP_ENTERBACKGROUND, self.eventData.onEnterBackground)
    game.unregisterEvent(GameDefine.APP_THIRDSTART_SUCCESS, self.eventData.onThirdStartEvent)
    game.unregisterEvent(GameDefine.AcceptTrumpetContent, self.eventData.onAcceptTrumpetContent)
    game.unregisterEvent(GameDefine.CONNECTION_SUCCESS, self.eventData.onConnectSuccess)
end

-----------------------消息处理函数------------------------------------------
-----------------进入场景消息--------------------
-- 玩家进入消息
function BaseGameScene:onUserEnter(gameUser)
    -- 子类实现
end

-- 游戏状态消息
function BaseGameScene:onGameStatus()
    -- 子类实现
end

-- 玩家状态改变消息
function BaseGameScene:onUserStatus(gameUser)
    if gameUser.cbUserStatus == GameDefine.US_SIT then
        -- 坐下状态
        if self:addTableUserList(gameUser) then
            self:onUserSitDown(gameUser)
        else
            -- 坐下失败
            local oldUser = self:getTableUserByChairID(gameUser.dwChairID)
            if oldUser ~= nil and oldUser.dwUserID ~= gameUser.dwUserID then
                -- 清除oldUser
                self:removeTableUserList(oldUser)
                self:onUserSitDown(gameUser)
            else
                print("坐下失败 已经坐下")
            end
        end
    elseif gameUser.cbUserStatus == GameDefine.US_READY then
        -- 准备状态 准备状态  执行坐下  有些游戏没有坐下状态 坐下成功后直接是准备状态
        -- 所以准备状态先判断该玩家是都坐下 没坐下执行坐下
        if self:addTableUserList(gameUser) then
            self:onUserSitDown(gameUser)
        end
        self.tableUserReady[gameUser.wChairID + 1] = true
        self:onUserReady(gameUser)
    elseif gameUser.cbUserStatus == GameDefine.US_FREE then
        -- 金币大厅显示踢人
        if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD and PlazaManager.isOutGameRoomByServer == true and globalUserInfo.dwUserID == gameUser.dwUserID then
            PlazaManager.isOutGameRoomByServer = false
            local function onOutGame(args)
                PlazaManager.closeGameSocket()
                PlazaManager.resetServerModuleData()
                PlazaManager.resetRoomServer()
                PlazaManager.resetGoalRoomInfo()
                self:onExitGame()
            end
            PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word259, nil, onOutGame)
        else
            -- 站起状态
            local wChair = self:removeTableUserList(gameUser)
            if wChair ~= GameDefine.INVALID_CHAIR then
                self:onUserStandup(wChair, gameUser)
            end
        end
    elseif gameUser.cbUserStatus == GameDefine.US_OFFLINE then
        -- 玩家掉线
        self:onUserOffline(gameUser)
    elseif gameUser.cbUserStatus == GameDefine.US_PLAYING then
        -- 玩家游戏
        -- 有些游戏没有坐下状态 坐下成功后直接是游戏状态
        -- 所以游戏状态先判断该玩家是都坐下 没坐下执行坐下
        if self:addTableUserList(gameUser) then
            self:onUserSitDown(gameUser)
        end
        self:onUserPlaying(gameUser)
    end

end

-- 包房详细信息
function BaseGameScene:onPrivateInfo(args)
end

-- 场景消息
function BaseGameScene:onGameScene(data)
    -- 子类实现
end

-----------------游戏中消息--------------------
-- 游戏消息
function BaseGameScene:onGame(cmdID, data, wChair)
    -- 子类实现
end

-- 玩家积分改变消息
function BaseGameScene:onUserScore(gameUser)
    -- 子类实现
end

-- 申请解散私人场消息
function BaseGameScene:onDisMissPrivate(args)
end

-- 解散私人场答复消息
function BaseGameScene:onDisMissPrivateReply(args)
end

-- 申请解散私人场结果消息
function BaseGameScene:onDisMissPrivateResult(args)
end

-----------------其他消息------------------------
-- 关闭场景消息
function BaseGameScene:onCloseScene()
    if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD or PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
        if self.gameDisConnection == true then
            if PlazaManager.curKindID == 205 then
                self:onExitGame()
            else
                local function disconectFunction(args)
                    self:onExitGame()
                end
                PlazaManager.closeWattingTips()
                PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word260, nil, disconectFunction)
            end
        else
            self:onExitGame()
        end
    else
        if PlazaManager.gameStatus.cbGameStatus ~= GameDefine.GAME_STATUS_END then
            self:onExitGame()
        end
    end
end

-- 桌子状态改变消息
function BaseGameScene:onTableStatueChange(statueID)
end

-- 领取救济金成功
function BaseGameScene:onGiveAlmsSuccess(data)
    if self.isLateShowGiveAlmsWin == false then
        local winui = GiveAlmsWinUI.new(data)
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display.getRunningScene())
    else
        self.GiveAlmsData = data
    end
end

-- 玩家语音消息
function BaseGameScene:onChatPlay(data)
    local charid = 0
    local sex = 1
    for k, v in pairs(self.tableUserList) do
        if v.dwUserID == data.SendUserID then
            charid = v.wChairID
            sex = v.cbGender
        end
    end
    if (sex == nil) then
        sex = 1
    end

    game.sendEvent(GameDefine.ShowUserChat, data, charid, sex)
end

-- 网络断开
function BaseGameScene:onDisConnection(name, ip, port, connNum, bgReconnect)
    print("BaseGameScene网络断开 " .. name .. "  connNum == " .. connNum)
    -- 收到服务端的强制关闭不重连
    if PlazaManager.closeGamebyServer > 0 or PlazaManager.closeRoombyServer > 0 then
        return
    end

    -- 是否还有其他的连接链路
    if name ~= GameDefine.GAME_SOCKET or connNum >= 1 then
        return
    end

    -- 判断自己是否在游戏中
    if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
        if self.gameDisConnection == false then
            print("网络断开 准备重连")
            self.gameDisConnection = true
            PlazaManager.resetServerModuleData()
            PlazaManager.resetRoomServer()
            self:onReconnection()
        else
            print("网络已经是断开状态 不重复处理")
        end
    else
        self:onExitGame()
    end
end

-- 网络连接失败
function BaseGameScene:onConnectFailer(name)
    if name == GameDefine.GAME_SOCKET then
        if self.gameDisConnection == true then
            local function onExit()
                self:onExitGame()
            end

            print("网络连接失败")
            PlazaManager.closeWattingTips()
            PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word261, nil, onExit)
        end
    end
end

-- 网络连接成功
function BaseGameScene:onConnectSuccess(name)
    if name == GameDefine.GAME_SOCKET then
        if self.gameDisConnection == true then
            self.gameDisConnection = false
            print("网络连接成功")
        end
    end
end

function BaseGameScene:onEnterBackgroundBase(isEnterBackground)
    if isEnterBackground == true then
        --[[
        --游戏切换到后台
        if PlazaManager.gameStatus.cbGameStatus == GameDefine.GAME_STATUS_END then
            PlazaManager.clearSystemCopy()  
        end
        ]]
        willEnterForegroundTime = 0
        difftime = 0
        enterBackgroundTime = os.time()
        print("BaseGameScene游戏切换到后台 enterBackgroundTime == " .. enterBackgroundTime)
    else
        -- 游戏切换到前台
        --[[
        if PlazaManager.gameStatus.cbGameStatus == GameDefine.GAME_STATUS_END then
                --判断是否复制了房间号
                local roominfo = PlazaManager.onCheckCopyRoomInfo()  --检查粘贴板
                if roominfo ~= nil then
                    self:onExitGame()
                end    
        end
        ]]
        if enterBackgroundTime > 0 then
            willEnterForegroundTime = os.time()
            difftime = willEnterForegroundTime - enterBackgroundTime
            print("BaseGameScene游戏切换到前台  willEnterForegroundTime == " .. willEnterForegroundTime .. "  相差 == " .. difftime)
            enterBackgroundTime = 0
            willEnterForegroundTime = 0
        end
    end
    self:onEnterBackground(isEnterBackground)
end

function BaseGameScene:onEnterBackground(isEnterBackground)
    -- 子类实现
end

function BaseGameScene:onThirdStartSuccess()
    self:onExitGame()
end

--------------------------------------------------其他功能函数--------------------------------------
-- 添加玩家
function BaseGameScene:addTableUserList(gameUser)
    if self.tableUserList[gameUser.wChairID + 1] == nil then
        self.tableUserList[gameUser.wChairID + 1] = gameUser
        return true
    else
        printLog("BaseGameScene", "已经有玩家坐下 不执行坐下动作")
    end

    return false
end

-- 删除玩家
function BaseGameScene:removeTableUserList(gameUser)
    local result = GameDefine.INVALID_CHAIR

    for k, v in pairs(self.tableUserList) do
        if v.dwUserID == gameUser.dwUserID then
            result = k
            break
        end
    end

    if result ~= GameDefine.INVALID_CARD then
        self.tableUserList[result] = nil
        result = result - 1
    end

    return result
end

-- 获取玩家 调用这个方法 需要椅子号+1
function BaseGameScene:getTableUser(wChairID)
    if wChairID ~= nil and type(wChairID) == "number" then
        return self.tableUserList[wChairID]
    end
    return nil
end

-- 获取玩家
function BaseGameScene:getTableUserByChairID(wChairID)
    if wChairID ~= nil and type(wChairID) == "number" then
        return self.tableUserList[wChairID + 1]
    end
    return nil
end

-- 获取玩家
function BaseGameScene:getTableUserbyUserID(dwuserID)
    for key, var in pairs(self.tableUserList) do
        if var ~= nil and var.dwUserID == dwuserID then
            return var
        end
    end
    return nil
end

-- 获取玩家人数
function BaseGameScene:getTableUsernumber()
    local result = 0

    for key, var in pairs(self.tableUserList) do
        if var ~= nil then
            result = result + 1
        end
    end

    return result
end

local function sortBySortChairID(item1, item2)
    if item1.wChairID < item2.wChairID then
        return true
    else
        return false
    end
end

-- 重新排序
function BaseGameScene:sortTableUserList()
    -- for key, var in pairs(self.tableUserList) do
    --     if var ~= nil then
    --         printLog("BaseGameScene", "排序前 var.charid == " .. var.wChairID)
    --     end
    -- end

    table.sort(self.tableUserList, sortBySortChairID)

    -- for key, var in pairs(self.tableUserList) do
    --     if var ~= nil then
    --         printLog("BaseGameScene", "排序后 var.charid == " .. var.wChairID)
    --     end
    -- end
end

function BaseGameScene:getTablePlalyeres()
    return self.tableUserList
end

-- 自动坐下
function BaseGameScene:autoSitDown()
    if PlazaManager.isNewPlayer == true and PlazaManager.isRecordModule() == false then
        local userList = NewPlayerGuideDate:getGameScen_UserList()
        for k, v in pairs(userList) do
            if self:addTableUserList(v) then
                self:onUserSitDown(v)
            end
        end
        return
    end

    if PlazaManager.gameServer ~= nil then
        -- 自己坐下
        local gameUser = PlazaManager.gameServer:getUserByUserID(globalUserInfo.dwUserID)
        if gameUser ~= nil then
            if self:addTableUserList(gameUser) then
                self:onUserSitDown(gameUser)
            end
        end

        -- 查找自己桌的玩家
        local gameTable = PlazaManager.gameServer:getTableByTableID(globalUserInfo.wTableID)
        if gameTable ~= nil then
            for k, v in pairs(gameTable.gameUserList) do
                if v.dwUserID ~= globalUserInfo.dwUserID then
                    if self:addTableUserList(v) then
                        self:onUserSitDown(v)
                    end
                end
            end
        end
    end
end

-- 玩家坐下
function BaseGameScene:onUserSitDown(gameUser)
    -- 子类实现
end

-- 玩家准备
function BaseGameScene:onUserReady(gameUser)
    -- 子类实现
end

-- 玩家站起
function BaseGameScene:onUserStandup(wChair)
    -- 子类实现
end

-- 玩家掉线
function BaseGameScene:onUserOffline(gameUser)
    -- 子类实现
end

-- 玩家游戏
function BaseGameScene:onUserPlaying(gameUser)
    -- 子类实现
end

function BaseGameScene:onSaveLockInfo()
    if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS or PlazaManager.curGameType ==
        GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
        PlazaManager.setLockData(PlazaManager.curKindID, PlazaManager.curServerID, PlazaManager.getPrivateInfo().szRoomID)
    elseif PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
        PlazaManager.setLockData(PlazaManager.curKindID, PlazaManager.curServerID, PlazaManager.getGoalRoomInfo().szRoomID)
    end
end

function BaseGameScene:onBaseReconnection()
    if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE and self.gameDisConnection == true then
        -- 获取房间信息
        local tagGameServer = ServerListData.getGameServerByServerID(PlazaManager.curServerID)

        if tagGameServer == nil then
            PlazaManager.showTips(LangCtrl:getLang().word262)
            return
        end

        local function onExit()
            self:onExitGame()
        end

        local function onNextReconnection(args)
            if args == true then
                self:onBaseReconnection()
            else
                if tolua.isnull(self) == false then
                    self:confirmNode("ok", LangCtrl:getLang().word263, onExit)
                else
                    print("tolua.isnull(self) == true3")
                end
            end
        end

        local function setConnIntervalTime()
            if connIntervalTime == 0 then
                connIntervalTime = 60
            else
                connIntervalTime = -1
            end
        end

        -- 连接服务器超时
        local function onConnectOutTime()
            PlazaManager.closeGameSocket()
            PlazaManager.resetServerModuleData()
            PlazaManager.resetRoomServer()

            PlazaManager.closeWattingTips()

            setConnIntervalTime()

            if connIntervalTime >= 10 then
                local showStr = string.format(LangCtrl:getLang().word264, connIntervalTime)
                if tolua.isnull(self) == false then
                    self:confirmNode("yes_no", showStr, onNextReconnection, connIntervalTime)
                else
                    print("tolua.isnull(self) == true4")
                end
            else
                if tolua.isnull(self) == false then
                    self:confirmNode("ok", LangCtrl:getLang().word261, onExit)
                else
                    print("tolua.isnull(self) == true5")
                end
            end
        end

        local function onConnectResult(isSuccess, ipsCount)
            if isSuccess == false then
                if ipsCount > 0 then
                    PlazaManager.setWattingData(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
                else
                    PlazaManager.closeWattingTips()
                    setConnIntervalTime()
                    if connIntervalTime >= 10 then
                        local showStr = string.format(LangCtrl:getLang().word264, connIntervalTime)
                        if tolua.isnull(self) == false then
                            self:confirmNode("yes_no", showStr, onNextReconnection, connIntervalTime)
                        else
                            print("tolua.isnull(self) == true1")
                        end
                    else
                        if tolua.isnull(self) == false then
                            self:confirmNode("ok", LangCtrl:getLang().word261, onExit)
                        else
                            print("tolua.isnull(self) == true2")
                        end
                    end
                end
            else
                PlazaManager.setWattingData(LangCtrl:getLang().word250, GameDefine.processTime, onConnectOutTime, nil, true)
            end
        end

        local function sendConnectionGR()
            local args = {}
            args.tagGameServer = tagGameServer
            args.paramsData = nil
            PlazaManager.getServerModule().onConnectionGR(args, onConnectResult)
        end

        -- 收到断线重连 先弹出网络连接等待 1秒后才进行重连 留出1秒给底层处理
        local scheduleScriptHandler = nil
        local function onReconnectionB()
            if scheduleScriptHandler ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleScriptHandler)
            end
            sendConnectionGR()
        end
        scheduleScriptHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onReconnectionB, 1, false)
        PlazaManager.showWattingTips(LangCtrl:getLang().word266, 17, onConnectOutTime, nil, true)
    else
        local function disconectFunction(args)
            self:onExitGame()
        end
        PlazaManager.closeWattingTips()
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word260, nil, disconectFunction)
    end
end

-- 断线重连
function BaseGameScene:onReconnection()
    connIntervalTime = 0
    difftime = 0
    self:onBaseReconnection()
end

-- 设置 救济金延迟显示
function BaseGameScene:setLateShowGiveAlmsWin(isBool)
    -- 取消救济金延时显示功能，由服务器端控制
    -- self.isLateShowGiveAlmsWin=isBool
end
-- 显示救济金领取成功
function BaseGameScene:ShowGiveAlmsWin()
    if self.isLateShowGiveAlmsWin == true and self.GiveAlmsData ~= nil then
        local winui = GiveAlmsWinUI.new(self.GiveAlmsData)
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display.getRunningScene())
        self.GiveAlmsData = nil
    end
end

function BaseGameScene:updateGameTime(dt)
    self.refreshDeviceTime = self.refreshDeviceTime + 1
    if self.refreshDeviceTime >= 5 then
        self.refreshDeviceTime = 0
        if PlazaManager.isPhoneAndPadPlatform() == true then
            -- self:updateDevice()
        end
    end

    -- 刷新时间
    if self.refreshGameTime ~= -1 then
        self.refreshGameTime = self.refreshGameTime + 1
        if self.refreshGameTime >= 4 then
            self.refreshGameTime = -1
        end
    end
end

-- 刷新wifi 电量
function BaseGameScene:updateDevice()
    local wifiState = game.getWifiSignalState()
    local level = 0
    if wifiState == 0 then
        level = game.getMobileSignalLevel()
    else
        level = game.getWifiSignalLevel()
    end
    local battleLevel = game.getBatteryLevel()
end

-- 分享
function BaseGameScene:onShare(args)
    if args ~= nil and type(args) == "table" and args.desc ~= nil and args.index ~= nil then
        local roomid = PlazaManager.getPrivateInfo().szRoomID
        if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
            roomid = PlazaManager.getGoalRoomInfo().szRoomID
        end

        if string.len(roomid) >= 6 then
            local newUrl = string.format("%s?roomid=%s", GameDefine.shareAddress, roomid)
            args.newUrl = newUrl
            -- 分享家族信息
            local gameinfo = PlazaManager.getUrlGameInfoByKindID(PlazaManager.curKindID)
            args.name = gameinfo.nameStr
            if gameinfo ~= nil then
                args.name = gameinfo.nameStr
                args.title = gameinfo.nameStr
                local icon = string.format("app/common/gameIcon/icon_%s.png", PlazaManager.curKindID)
                args.icon = icon
                args.tag = roomid
                args.richContent = args.desc
            end

            local rWin = GameShareWin.new(self, args)
            if rWin ~= nil then
                local x = (display.width - rWin:getContentSize().width) / 2
                local y = (display.height - rWin:getContentSize().height) / 2
                rWin:move(x, y):addTo(display.getRunningScene())
            end
            -- game.sendShareMessage(newUrl,"牌友都市",args.desc,"Icon-152.png",args.index)
        end
    end
end

-- 复制房间号
function BaseGameScene:onCopyRoomInfo(args)
    -- 获取房间号
    local roomid = PlazaManager.getPrivateInfo().szRoomID
    if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
        roomid = PlazaManager.getGoalRoomInfo().szRoomID
    end
    if string.len(roomid) == 6 then
        local copyStr = string.format("房号[%s] %s (复制此消息打开游戏可直接进入该房间)", roomid, args.desc)
        if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
            copyStr = string.format("房号[%s] %s (复制此消息打开游戏可直接进入该金币大厅房间)", roomid, args.desc)
        end

        game.systemCopy(copyStr)
        self.isCopyRoomID = true
        PlazaManager.showTips("复制房间号成功")
    else
        PlazaManager.showTips("复制房间号出错")
    end
end

-- 刷新
function BaseGameScene:refreshGame()
    if GameDefine.bIsLocalTest then
        print("bIsLocalTest skip refresh game!")
        return
    end

    if self.refreshGameTime == -1 then
        self.refreshGameTime = 0

        if connWin == nil and self.gameDisConnection == false then
            print("调用刷新游戏成功")
            PlazaManager.closeGameSocket()
            self.gameDisConnection = true
            PlazaManager.resetServerModuleData()
            PlazaManager.resetRoomServer()
            self:onReconnection()
        else
            print("调用刷新游戏失败")
        end
    else
        PlazaManager.showTips(LangCtrl:getLang().word158)
    end
end

-- 战绩分享
function BaseGameScene:onShareResultImage()
    local function sendShare(imageThumbpath, imagepath)
        local args = {}
        args.imageThumbpath = imageThumbpath
        args.imagepath = imagepath

        local gameinfo = PlazaManager.getUrlGameInfoByKindID(PlazaManager.curKindID)
        args.name = gameinfo.nameStr
        args.icon = string.format("app/common/gameIcon/icon_%s.png", PlazaManager.curKindID)

        if string.len(imageThumbpath) > 0 then
            local rWin = GameShareWin.new(self, args, true)
            if rWin ~= nil then
                local x = (display.width - rWin:getContentSize().width) / 2
                local y = (display.height - rWin:getContentSize().height) / 2
                rWin:move(x, y):addTo(display.getRunningScene())
            end
        else
            PlazaManager.showTips("截屏失败")
        end
    end
    PlazaManager:onAfterCaptured(sendShare)
end

-- 创建录像ui
function BaseGameScene:createRecordUI()
    local rWin = RecordUI.new()
    if rWin ~= nil then
        local x = (display.width - rWin:getContentSize().width) / 2
        local y = (display.height - rWin:getContentSize().height) / 2
        rWin:move(x, y):addTo(self, 255)
    end
end

-- 换桌成功 清除数据
function BaseGameScene:onChangeRoomSucc()
end

-- 收到游戏喇叭公告
function BaseGameScene:createTrumpetNode(trumpetData, showNode)
    local cliper = showNode:getChildByName("cliperNode")
    local cliperSize = cliper:getContentSize()

    local showStr = tostring(trumpetData.szTrumpetContent)
    local fontColor = cc.c3b(trumpetData.TrumpetColor[1], trumpetData.TrumpetColor[2], trumpetData.TrumpetColor[3])
    local content = GameUtil.createLabel(showStr, 32, fontColor, display.LEFT_CENTER, cc.p(350, 25))
    content:setAdditionalKerning(1)
    cliper:addChild(content)

    local lblSize = content:getContentSize()
    content:align(display.LEFT_CENTER, cliperSize.width, cliperSize.height / 2)

    content:runAction(cc.Sequence:create(cc.MoveTo:create(8, cc.p(-1 * lblSize.width, cliperSize.height / 2)), cc.CallFunc:create(function(sender)
        sender:removeFromParent()

        if self.trumpetDataList ~= nil and #self.trumpetDataList > 0 and self.trumpetShowSeqNo < #self.trumpetDataList then
            self.trumpetShowSeqNo = self.trumpetShowSeqNo + 1
            self:createTrumpetNode(self.trumpetDataList[self.trumpetShowSeqNo], showNode)
        else
            showNode:removeFromParent()
            self.trumpetDataList = {}
            self.trumpetShowSeqNo = 0
            self.trumpetDataShow = false
        end
    end)))
end
function BaseGameScene:onAcceptTrumpetContent(trumpetData)
    if self.trumpetDataList == nil then
        self.trumpetDataList = {}
        self.trumpetShowSeqNo = 0
        self.trumpetDataShow = false
    end

    if self.trumpetDataShow == false then
        -- 创建显示框
        self.trumpetDataShow = true

        local showSize = cc.size(display.width * 0.7, 50)
        local showNode = display.newNode()
        showNode:setContentSize(showSize)
        showNode:align(display.CENTER, display.cx, display.height * 3 / 4):addTo(display.getRunningScene(), 254)

        local bg_laba = ccui.Scale9Sprite:create("app/common/imgbglaba.png")
        bg_laba:setCapInsets(cc.rect(15, 15, 40 - 30, 34 - 30))
        bg_laba:setContentSize(showSize)
        bg_laba:align(display.LEFT_BOTTOM, 0, 0):addTo(showNode)

        GameUtil.newSprite("app/common/xiaolaba.png", false):align(display.CENTER, 0, showSize.height / 2):addTo(showNode)

        local cliper = cc.ClippingNode:create()
        cliper:setContentSize(showSize.width - 50, showSize.height / 2)
        cliper:align(display.LEFT_CENTER, 50, 25):addTo(showNode)
        cliper:setName("cliperNode")

        local drawNode = cc.DrawNode:create()
        local drawPos = {display.LEFT_BOTTOM, cc.p(showSize.width - 50, 0), cc.p(showSize.width - 50, showSize.height), cc.p(0, showSize.height)}
        local color = cc.c4f(1, 1, 1, 1)
        drawNode:drawSolidPoly(drawPos, 4, color)
        cliper:setStencil(drawNode)

        self:createTrumpetNode(trumpetData, showNode)
    else
        table.insert(self.trumpetDataList, trumpetData)
    end
end

-- 游戏中滚动公告（原喇叭消息修改）
function BaseGameScene:onAcceptTrumpetContentRoll(trumpetDataStr)
    print(trumpetDataStr)
end

function BaseGameScene:confirmNode(types, text, callback, time)
    local size = cc.size(702, 430)
    local midWidth, midHeight = size.width / 2, size.height / 2
    local node = display.newNode()
    node:setContentSize(size)
    node:setAnchorPoint(display.CENTER)
    connWin = node

    local startTime = 0
    local endTime = 0
    if time ~= nil then
        endTime = time
    end

    local function onTouchBegan(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(display.width / 5)
    mask:setScaleY(display.height / 5)
    mask:setOpacity(180)
    mask:move(midWidth, midHeight):addTo(node)

    local showNode = display.newNode()
    showNode:setContentSize(size)
    showNode:align(display.CENTER, midWidth, midHeight):addTo(node)

    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_1.png")
    bg_1:setCapInsets(GameDefine.PanelRect1)
    bg_1:setContentSize(size.width, size.height)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(showNode)

    --[[
    local bg_2 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    bg_2:setCapInsets(GameDefine.PanelRect2)
    bg_2:setContentSize(size.width - 90, size.height - 80)
    bg_2:align(display.LEFT_BOTTOM, 45, 40):addTo(showNode)
    --]]

    local titlebg = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    titlebg:setCapInsets(GameDefine.PanelRect3)
    titlebg:setContentSize(size.width - 10, 64)
    titlebg:align(display.CENTER_BOTTOM, midWidth, size.height - 68):addTo(showNode)

    local bg_top = ccui.ImageView:create("app/common/comwin/panel_title.png")
    -- bg_top:ignoreContentAdaptWithSize(false)
    -- bg_top:setContentSize(cc.size(size.width + 10, 95))
    bg_top:align(display.CENTER_BOTTOM, midWidth, size.height - 66):addTo(showNode)

    GameUtil.addTitleTTF(LangCtrl:getLang().word18, bg_top) -- 提示

    local content = nil
    local color = cc.c3b(0xa2, 0x5c, 0x35)
    local textFontSize = 30
    if type(text) == "string" then
        content = cc.Label:createWithTTF(text, GameDefine.FontName, textFontSize)
        content:setColor(color)
        content:setLineHeight(textFontSize + 8)
        content:setAdditionalKerning(1)
        content:setMaxLineWidth(480)
        content:setLineBreakWithoutSpace(false)
    end
    if content ~= nil then
        content:setAnchorPoint(display.CENTER):setPosition(midWidth, midHeight + 50)
        showNode:addChild(content)
    end

    local wattingSchedulerID = nil
    local function updateShowTime()
        startTime = startTime + 1
        local timeDiff = endTime - startTime - difftime
        print("timeDiff == " .. timeDiff .. "  endTime == " .. endTime .. "  startTime == " .. startTime .. "  difftime == " .. difftime)

        if timeDiff <= 0 then
            local isServerOut = false
            if difftime + startTime >= 105 then
                isServerOut = true
            end

            difftime = 0
            if wattingSchedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
            end
            if callback ~= nil then
                if isServerOut == true then
                    callback(false)
                else
                    callback(true)
                end
            end
            node:removeSelf()
            connWin = nil
        else
            if content ~= nil then
                if timeDiff < 0 then
                    timeDiff = 0
                end
                local showStr = string.format(LangCtrl:getLang().word264, timeDiff)
                content:setString(showStr)
            end
        end
    end

    if endTime > 0 then
        wattingSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateShowTime, 1, false)
    end

    if types == "ok" then
        local function onClickCallBack(args)
            PlazaManager.playClickEffect()
            if wattingSchedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
            end
            if callback ~= nil then
                callback(true)
            end
            node:removeSelf()
            connWin = nil
        end
        local okBtn = ccui.Button:create("app/common/button/btn1.png")
        okBtn:addClickEventListener(onClickCallBack)
        okBtn:setZoomScale(-0.1)
        okBtn:align(display.CENTER, midWidth, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, okBtn) -- 确定
    elseif types == "yes_no" then
        local function onYesCallBack(args)
            PlazaManager.playClickEffect()
            if wattingSchedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
            end
            if callback ~= nil then
                callback(true)
            end
            node:removeSelf()
            connWin = nil
        end

        local function onNoCallBack(args)
            PlazaManager.playClickEffect()
            if wattingSchedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
            end
            if callback ~= nil then
                callback(false)
            end
            node:removeSelf()
            connWin = nil
        end

        local yesBtn = ccui.Button:create("app/common/button/btn1.png")
        yesBtn:addClickEventListener(onYesCallBack)
        yesBtn:setZoomScale(-0.1)
        yesBtn:align(display.CENTER, midWidth - 120, 110):addTo(showNode)
        GameUtil.addBtnTTF2(LangCtrl:getLang().word267, yesBtn)

        local noBtn = ccui.Button:create("app/common/button/btn2.png")
        noBtn:addClickEventListener(onNoCallBack)
        noBtn:setZoomScale(-0.1)
        noBtn:align(display.CENTER, midWidth + 120, 110):addTo(showNode)
        GameUtil.addBtnTTF2(LangCtrl:getLang().word268, noBtn)
    end

    function node:close()
        if wattingSchedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
        end
        callback = nil
        self:removeFromParent()
    end

    function node:onExit()
        node:unregisterScriptHandler()
        if wattingSchedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
        end
        callback = nil
    end

    local function onNodeEvent(event)
        if event == "exit" then
            node:onExit()
        end
    end
    node:registerScriptHandler(onNodeEvent)

    local scene = display.getRunningScene()
    node:setPosition(display.cx, display.cy)
    scene:addChild(node, 254)
end

return BaseGameScene
