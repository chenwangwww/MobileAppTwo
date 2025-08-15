-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local RecordManager = class("RecordManager")

local ChatMain = require("app.chat.scripts.ChatMain")
local GameServer = require("app.platform.common.GameServer")

-- 默认读取下一消息的时间
local DEFAULT_READ_NEXT_TIME = 0

-- 默认发送消息的时间
local DEFAULT_SEND_TIME = 2

local DEFAULT_PLAY_SPEED = 3
local PLAY_SPEED_MIN_LEVEL = 1
local PLAY_SPEED_MAX_LEVEL = 4
local DEFAULT_PLAY_FACTOR = {1, 0.8, 0.6, 0.4}

function RecordManager:ctor(args)
    self:resetData()

    self.wKindID = args.dwKindID
    PlazaManager.curKindID = self.wKindID

    --[[
        获取播放速度配置文件
        根据游戏要求 有些游戏在播放速度过快会出bug
        如果对播放速度有要求 可以自己定义一份播放速度的配置文件
        在录像开始前 会先加载游戏自定义的配置文件 没有定义 则用默认的播放速度
        默认发送时间为2秒  读取下一条消息的时间为0秒
    ]]
    local gameInfo = PlazaManager.getUrlGameInfoByKindID(self.wKindID)
    if gameInfo ~= nil then
        local recordClass = nil
        local gameName = gameInfo.name
        local recordClassName = string.format("game/%s/src/%sRecordConfig", gameName, string.upper(gameName))
        print("recordClassName == " .. recordClassName)

        -- 判断文件是否存在
        if cc.FileUtils:getInstance():isFileExist(recordClassName .. ".lua") or cc.FileUtils:getInstance():isFileExist(recordClassName .. ".luac") then
            recordClass = require(recordClassName)
        end

        if recordClass ~= nil then
            self.playSpeedConfig = recordClass.getRecordSpeedConfig()
        end
    end
end

function RecordManager:resetData()
    self.wKindID = 0
    self.userCount = 0
    self.userList = {}
    self.recordList = {}
    self.roomInfo = {}
    self.runTime = 0
    self.isPause = false
    self.playSpeedLevel = PLAY_SPEED_MIN_LEVEL
    self.playSendSpeed = 1
    self.playReadNextSpeed = 1

    self.buffer = nil
    self.wChair = nil
    self.modId = nil
    self.cmdId = nil

    -- 定时器开始生效时间
    self.activeTime = 0

    --[[
    等待发送时间
    self.waitSendTime = 0
    --发送完成等待读取下一条时间
    self.waitReadNextTime = 0
    2个值同时只存在一个（一个为正常值 一个为0值)
    ]]
    self.waitSendTime = DEFAULT_SEND_TIME
    self.waitReadNextTime = DEFAULT_READ_NEXT_TIME

    -- 计时
    self.waitSendTimeTiming = 0
    self.waitReadNextTimeTiming = 0

    self.playSpeedConfig = {}
    self:setPlaySpeed()
end

function RecordManager:setPlaySpeed()
    local playFactor = DEFAULT_PLAY_FACTOR[self.playSpeedLevel]
    if playFactor ~= nil then
        self.playSendSpeed = playFactor * self.waitSendTime
        self.playReadNextSpeed = playFactor * self.waitReadNextTime
        print("设置播放速度完毕  self.playSendSpeed == " .. self.playSendSpeed .. "  self.playReadNextSpeed == " .. self.playReadNextSpeed)
    end
end

function RecordManager:getPlaySpeedLevel()
    return self.playSpeedLevel
end

function RecordManager:getPlaySpeedFactor()
    local factor = DEFAULT_PLAY_FACTOR[self.playSpeedLevel]
    local result = 1
    if factor ~= nil then
        result = factor
    end
    return result
end

function RecordManager:setPlaySpeedLevel(isRetreat)
    if isRetreat == true then -- 是否快退
        if self.playSpeedLevel > PLAY_SPEED_MIN_LEVEL then
            self.playSpeedLevel = self.playSpeedLevel - 1
        end
    else
        if self.playSpeedLevel < PLAY_SPEED_MAX_LEVEL then
            self.playSpeedLevel = self.playSpeedLevel + 1
        end
    end
    self:setPlaySpeed()
    -- print("=============== self.playSpeed == "..self.playSpeed.."  self.playSpeedLevel == "..self.playSpeedLevel.."  self.playSpeedDefault == "..self.playSpeedDefault)
end

function RecordManager:onProcessRecord()
    local recordListlen = #self.recordList
    local str = string.format("开始处理录像数据 wKindID==%s userCount==%s recordListlen=%s", self.wKindID, self.userCount, recordListlen)
    print(str)

    -- 检测录像数据
    if self.wKindID == 0 or #self.userList == 0 or #self.recordList == 0 then
        return
    end

    -- 赋值房间信息
    self:setRoomInfo()

    if PlazaManager.getPrivateInfo().szRoomID == "0" then
        return
    end

    -- 更新玩家状态为坐下
    self:onUpdateUserStatus(GameDefine.US_SIT)

    -- 查找自己信息 更新游戏状态
    for key, value in ipairs(self.userList) do
        if value.dwUserID == globalUserInfo.dwUserID then
            globalUserInfo:updateUserState(value.wTableID, value.wChairID, value.cbUserStatus)
        end
    end

    -- 配置房间
    self:configRoom()

    -- 进入房间
    for key, value in ipairs(self.userList) do
        PlazaManager.gameServer:enterRoom(value)
    end

    -- 打开游戏场景
    self:openGameScene()

    -- 游戏状态消息
    PlazaManager.gameStatus.cbGameStatus = 0
    PlazaManager.gameStatus.cbAllowLookon = 0

    -- 定时器
    self.baseSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onUpdateGameTime), 0, false)
end

function RecordManager:configRoom()
    local data = {}
    data.tableCount = 10 -- 桌子数目
    data.chairCount = 10 -- 椅子数目
    data.servetType = 1 -- 房间类型
    data.serverRule = 1 -- 房间规则
    data.lCellScore = 1 -- 单元金币
    data.lMinEnterScore = 1 -- 进入房间最低金币
    data.lMaxEnterScore = 1 -- 进入房间最高金币
    data.lMaxUserPerTable = 10 -- 每桌最大人数

    PlazaManager.getGoalRoomInfo().lCellScore = data.lCellScore
    PlazaManager.getGoalRoomInfo().lMinEnterScore = data.lMinEnterScore
    PlazaManager.getGoalRoomInfo().lMaxEnterScore = data.lMaxEnterScore
    PlazaManager.getGoalRoomInfo().lMaxUserPerTable = data.lMaxUserPerTable

    -- 配置房间
    PlazaManager.gameServer = GameServer.configGameServer(data, 0, 100)
end

function RecordManager:setRoomInfo()
    PlazaManager.getPrivateInfo().dwTableOwnerUserID = self.roomInfo.dwTableOwnerUserID -- 桌主 I D
    PlazaManager.getPrivateInfo().szRoomID = self.roomInfo.szRoomID -- 房间编号
    PlazaManager.getPrivateInfo().cbGameRule = {}
    for i = 1, 100 do
        table.insert(PlazaManager.getPrivateInfo().cbGameRule, self.roomInfo.cbGameRule[i])
    end
    PlazaManager.getPrivateInfo().dwTurnCount = self.roomInfo.dwTurnCount -- 已进行了几局游戏

    PlazaManager.getPrivateInfo().bEndGameRequest = self.roomInfo.bEndGameRequest -- 是否申请解散游戏
    PlazaManager.getPrivateInfo().dwRequestReply = {}
    for i = 1, 100 do
        PlazaManager.getPrivateInfo().dwRequestReply[i] = self.roomInfo.dwRequestReply[i] -- 申请解散状态 0,未处理；1，同意；2，不同意    
    end

    PlazaManager.getPrivateInfo().lMinGameScore = self.roomInfo.lMinGameScore -- 最少入坐分数
    PlazaManager.getPrivateInfo().wJoinGamePeopleCount = self.roomInfo.wJoinGamePeopleCount -- 参加游戏的最大人数
    PlazaManager.getPrivateInfo().lCellScore = self.roomInfo.lCellScore -- 游戏底分
    PlazaManager.getPrivateInfo().cbGoldOrRoomCard = self.roomInfo.cbGoldOrRoomCard
    PlazaManager.getPrivateInfo().dwRoomCard = self.roomInfo.dwRoomCard -- 消耗的房卡
    PlazaManager.getPrivateInfo().dwGoldID = self.roomInfo.dwGoldID -- 金币币种id
    PlazaManager.getPrivateInfo().dwBaseGold = self.roomInfo.dwBaseGold -- 消耗的金币
    PlazaManager.getPrivateInfo().dwDrawCountLimit = self.roomInfo.dwDrawCountLimit -- 游戏总局数
    PlazaManager.getPrivateInfo().dwDrawTimeLimit = self.roomInfo.dwDrawTimeLimit -- 游戏总时间
    PlazaManager.getPrivateInfo().dwTimeAfterBeginCount = self.roomInfo.dwTimeAfterBeginCount -- 一局开始多长时间后解散桌子 单位秒
    PlazaManager.getPrivateInfo().dwTimeOffLineCount = self.roomInfo.dwTimeOffLineCount -- 掉线多长时间后解散桌子  单位秒
    PlazaManager.getPrivateInfo().dwTimeNotBeginGame = self.roomInfo.dwTimeNotBeginGame -- 多长时间未开始游戏解散桌子	 单位秒
    PlazaManager.getPrivateInfo().dwTimeAfterCreateRoom = self.roomInfo.dwTimeAfterCreateRoom -- 私人房创建多长时间后无人坐桌解散桌子
    PlazaManager.getPrivateInfo().lRestrictScore = self.roomInfo.lRestrictScore -- 单局积分封顶数
    PlazaManager.getPrivateInfo().btMyself = self.roomInfo.btMyself -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    PlazaManager.getPrivateInfo().dwFamilyID = self.roomInfo.dwFamilyID -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）
    PlazaManager.getPrivateInfo().lReward = self.roomInfo.lReward -- 最大赢家打赏，只有在为他人创建房间，并且是金币模式下才可用
    PlazaManager.getPrivateInfo().wContinueCount = self.roomInfo.wContinueCount -- 连续创建次数

    PlazaManager.getPrivateInfo().szDiscripTion1 = self.roomInfo.szDiscripTion1
    PlazaManager.getPrivateInfo().szDiscripTion2 = self.roomInfo.szDiscripTion2
    PlazaManager.getPrivateInfo().cbVideoMode = self.roomInfo.cbVideoMode -- 1:视频游戏 0：非视频游戏
    PlazaManager.getPrivateInfo().cbPayRoomCardPlayer = self.roomInfo.cbPayRoomCardPlayer -- 付费方式,0:房主付费，1:最大赢家付费，2:族长支付，3：AA支付

    PlazaManager.getPrivateInfo().dwElpase = self.roomInfo.dwElpase -- 解散剩余时间
end

function RecordManager:openGameScene()
    ChatMain.exit();
    PlazaManager.closeWattingTips()
    if PlazaManager.isOpenGameScene == false then
        game.sendEvent(GameDefine.GR_LOGIN_FINISH_EVENT, self.wKindID)
    end
end

function RecordManager:onUpdateGameTime(dt)
    -- 定时器启动2秒后才开始工作
    if self.activeTime < 2 then
        self.activeTime = self.activeTime + dt
        return
    end

    -- 是否暂停
    if self.isPause == true or self.isPause == nil then
        return
    end

    -- 没有读取buffer
    if self.buffer == nil then
        if self.recordList ~= nil and #self.recordList >= 1 then
            if self.waitReadNextTimeTiming >= self.playReadNextSpeed then
                self.waitReadNextTimeTiming = 0
                self.waitReadNextTime = DEFAULT_READ_NEXT_TIME

                -- 读取buffer
                self.buffer = self.recordList[1]
                table.remove(self.recordList, 1)
                print("读取buffer时间================")
                print(os.time())
                print("读取buffer时间================")

                self.wChair = self.buffer:readUInt16()
                self.modId = self.buffer:readUInt16()
                self.cmdId = self.buffer:readUInt16()

                -- 获取时间控制
                local interval_args = self.playSpeedConfig[self.cmdId]
                if interval_args ~= nil then
                    -- 读取下一条时间
                    if interval_args.waitReadNextTime == nil then -- 检测是否为nil
                        interval_args.waitReadNextTime = DEFAULT_READ_NEXT_TIME
                    end
                    if type(interval_args.waitReadNextTime) ~= "number" then -- 检测类型
                        interval_args.waitReadNextTime = DEFAULT_READ_NEXT_TIME
                    end
                    self.waitReadNextTime = interval_args.waitReadNextTime

                    -- 本条消息等待发送时间
                    if interval_args.waitSendTime == nil then -- 检测是否为nil
                        interval_args.waitSendTime = DEFAULT_SEND_TIME
                    end
                    if type(interval_args.waitSendTime) ~= "number" then -- 检测类型
                        interval_args.waitSendTime = DEFAULT_SEND_TIME
                    end
                    self.waitSendTime = interval_args.waitSendTime

                    print("读取buffer  self.modId ==" .. self.modId .. "  self.cmdId == " .. self.cmdId .. "   self.waitReadNextTime == " .. self.waitReadNextTime .. "  self.waitSendTime == " ..
                              self.waitSendTime)
                else
                    self.waitReadNextTime = DEFAULT_READ_NEXT_TIME
                    self.waitSendTime = DEFAULT_SEND_TIME
                end

                -- 设置播放速度
                self:setPlaySpeed()
            else
                self.waitReadNextTimeTiming = self.waitReadNextTimeTiming + dt
                print("自加  self.waitReadNextTimeTiming == " .. self.waitReadNextTimeTiming)
            end
        end
    else -- 读取了buffer
        self.waitSendTimeTiming = self.waitSendTimeTiming + dt

        if self.waitSendTimeTiming >= self.playSendSpeed then
            self.waitSendTimeTiming = 0
            -- 框架命令
            if self.modId == game.MDM_GF_FRAME then
                if self.cmdId == game.SUB_GF_GAME_SCENE then
                    print("录像发送框架消息 wChair == " .. self.wChair .. "  modId == " .. self.modId .. "  cmdId == " .. self.cmdId .. "  self.playSendSpeed == " .. self.playSendSpeed)
                    game.sendEvent(GameDefine.GR_GAME_SCENE, self.buffer)
                    print("========================")
                    print(os.time())
                    print("========================")

                    self.buffer:release()
                    self:resetBufferInfo()
                end
            elseif self.modId == game.MDM_GF_GAME then -- 游戏命令
                print("录像发送游戏消息 wChair == " .. self.wChair .. "  modId == " .. self.modId .. "  cmdId == " .. self.cmdId .. "  self.playSendSpeed == " .. self.playSendSpeed)
                game.sendEvent(GameDefine.GR_GAME, self.cmdId, self.buffer, self.wChair)
                print("========================")
                print(os.time())
                print("========================")
                self.buffer:release()
                self:resetBufferInfo()
            end
        end
    end
end

function RecordManager:resetBufferInfo()
    self.buffer = nil
    self.modId = nil
    self.cmdId = nil
    self.wChair = nil
end

function RecordManager:onUpdateUserStatus(userStatus)
    for key, value in pairs(self.userList) do
        value.cbUserStatus = userStatus
    end
end

function RecordManager:onClose()
    if self.baseSchedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.baseSchedulerID)
        self.baseSchedulerID = nil
    end
end

return RecordManager

-- endregion
