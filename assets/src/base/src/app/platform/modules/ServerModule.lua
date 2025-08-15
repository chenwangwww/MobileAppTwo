local _M = {}

local GameUser = require("app.platform.common.GameUser")
local GameServer = require("app.platform.common.GameServer")

local isUploadBugly = false

-- 连接的房间属性
local _conn_tagGameServer = nil
-- 连接的参数
local _conn_paramsData = nil
-- 连接枚举
local _linkActionEnum = {
    link_null = 0,
    link_create = 1, -- 创建
    link_join = 2 -- 加入
}
-- 连接动作
local _linkActionType = _linkActionEnum.link_null

local loginIps = nil

local linkNetSchedulerID = nil

-- 链接失败ips
local linkFailedips = {}

local function getOpenGameSceneStr()
    local result = "场景关闭"
    if PlazaManager.isOpenGameScene == true then
        result = "场景打开"
    end
    return result
end

local function getGameServerStr()
    local result = "PlazaManager.gameServer = nil"
    if PlazaManager.gameServer ~= nil then
        result = "PlazaManager.gameServer ~= nil"
    end
    return result
end

local function getCurServerID()
    local result = 0
    if PlazaManager.curServerID ~= nil and PlazaManager.curServerID ~= 0 then
        result = PlazaManager.curServerID
    end
    return result
end

-- 设置下次连接时间
local function getConnIntervalTime(curIntervalTime)
    local result = 10

    if curIntervalTime == 10 then
        result = 30
    elseif curIntervalTime == 30 then
        result = 60
    elseif curIntervalTime == 60 then
        result = 10
    end

    return result
end

-- 清除连接失败的ip
local function clearlLinkFailedip()
    print("清空失败列表")
    linkFailedips = {}
end

-- 检查连接失败的ip是否存在
local function onCheckFailedipisExist(ip, port)
    local result = false

    for k, v in pairs(linkFailedips) do
        if v ~= nil and v.ips ~= nil and type(v.ips) == "table" then
            for k_ip, v_ip in pairs(v.ips) do
                if v_ip.ip ~= nil and v_ip.port ~= nil then
                    if v_ip.ip == ip and v_ip.port == port then
                        result = true
                        break
                    end
                end
            end
            if result == true then
                break
            end
        end
    end

    return result
end

-- 添加连接失败的ip
local function addFailedip(ip, port)
    -- print(debug.traceback())
    -- print("准备添加失败通道到列表 ip == " .. ip .. "  port == " .. port)

    if onCheckFailedipisExist(ip, port) == false then
        print("检测失败通道（ip == " .. ip .. "  port == " .. port .. "  ）不存在失败列表中")

        local ipIndex = -1
        for k_1, v_1 in pairs(_conn_tagGameServer.szGateAddr1) do
            local vPort = _conn_tagGameServer.wGatePort[k_1]
            if string.len(v_1) > 0 and v_1 ~= "0.0.0.0" and v_1 == ip and vPort == port then
                ipIndex = k_1
                print("v_1 == " .. v_1 .. "  vPort == " .. vPort)
                break
            end
        end

        if ipIndex == -1 then
            for k_2, v_2 in pairs(_conn_tagGameServer.szGateAddr2) do
                local vPort2 = _conn_tagGameServer.wGatePort[k_2]
                if string.len(v_2) > 0 and v_2 ~= "0.0.0.0" and v_2 == ip and vPort2 == port then
                    ipIndex = k_2
                    print("v_2 == " .. v_2 .. "  vPort2 == " .. vPort2)
                    break
                end
            end
        end

        if ipIndex == -1 then
            for k, v in pairs(_conn_tagGameServer.szGateAddr) do
                local vPort3 = _conn_tagGameServer.wGatePort[k]
                if string.len(v) > 0 and v ~= "0.0.0.0" and v == ip and vPort3 == port then
                    ipIndex = k
                    print("v == " .. v .. "  vPort3 == " .. vPort3)
                    break
                end
            end
        end

        if ipIndex == -1 then
            print("添加失败通道到列表 ip == " .. ip .. "  port == " .. port .. " 失败 本地通道ip列表里面没找到该通道ip 已经被删除")
        else
            local args = {}
            args.ips = {}

            local failerPort = _conn_tagGameServer.wGatePort[ipIndex]
            if failerPort ~= nil and failerPort ~= 0 then
                local failerip = _conn_tagGameServer.szGateAddr[ipIndex]
                local failerip1 = _conn_tagGameServer.szGateAddr1[ipIndex]
                local failerip2 = _conn_tagGameServer.szGateAddr2[ipIndex]

                print("failerPort ==  " .. failerPort .. "  failerip == " .. failerip .. "  failerip1 == " .. failerip1 .. "  failerip2 == " .. failerip2)

                -- 第一个通道ip
                if failerip ~= nil and string.len(failerip) > 0 and failerip ~= "0.0.0.0" then
                    local ipinfo = {}
                    ipinfo.ip = failerip
                    ipinfo.port = failerPort
                    table.insert(args.ips, ipinfo)
                end

                -- 备用通道1
                if failerip1 ~= nil and string.len(failerip1) > 0 and failerip1 ~= "0.0.0.0" then
                    local ipinfo1 = {}
                    ipinfo1.ip = failerip1
                    ipinfo1.port = failerPort
                    table.insert(args.ips, ipinfo1)
                end

                -- 备用通道2
                if failerip2 ~= nil and string.len(failerip2) > 0 and failerip2 ~= "0.0.0.0" then
                    local ipinfo2 = {}
                    ipinfo2.ip = failerip2
                    ipinfo2.port = failerPort
                    table.insert(args.ips, ipinfo2)
                end
            end

            if #args.ips > 0 then
                -- 连接的次数
                args.connCount = 0
                -- 当前的时间
                args.curTime = 0
                -- 下次连接的间隔时间
                args.connIntervalTime = 10 -- 连接间隔时间。10秒。30秒。60秒 180秒
                -- 上次连接的ip
                args.lastConnip = {}
                args.lastConnip.ip = ip
                args.lastConnip.port = port

                table.insert(linkFailedips, args)
                local str = "添加失败通道到列表 ip == " .. ip .. "  port == " .. port .. " 成功"
                print(str)
            end
        end
    else
        print(" 添加失败通道（ip == " .. ip .. "  port == " .. port .. "  ）失败 已经存在失败列表中")
    end
end

-- 移除某个连接失败的ip
local function removeFailedip(ip, port, isAlldel)
    for i = #linkFailedips, 1, -1 do
        local value = linkFailedips[i]
        if value ~= nil then
            local result = false

            local ipIndex = -1
            for j = #value.ips, 1, -1 do
                local ipinfo = value.ips[j]
                if ipinfo.ip == ip and ipinfo.port == port then
                    if isAlldel == false then
                        table.remove(value.ips, j)
                    else
                        result = true
                    end
                    break
                end
            end

            if result == true then
                table.remove(linkFailedips, i)
                break
            end
        end
    end
end

function _M.getLinkActionEnum()
    return _linkActionEnum
end

function _M.resetServerModuleData()
    _conn_paramsData = nil
    _conn_tagGameServer = nil
    loginIps = nil
    _linkActionType = _linkActionEnum.link_null
    clearlLinkFailedip()
    _M.unlinkNetScheduler()
end

-- 打开游戏场景
local function openGameScene()
    PlazaManager.closeWattingTips()

    if _conn_tagGameServer ~= nil then
        PlazaManager.curKindID = _conn_tagGameServer.wKindID
        PlazaManager.curServerID = _conn_tagGameServer.wServerID
    end
    PlazaManager.isOutGameRoomByServer = false

    -- 设置横屏
    if _conn_tagGameServer ~= nil and PlazaManager.isOpenGameScene == false then
        PlazaManager.isOpenGameScene = true
        game.sendEvent(GameDefine.GR_LOGIN_FINISH_EVENT, _conn_tagGameServer.wKindID)
    end
end

-- 关闭游戏场景
local function closeGameScene()
    -- 房主点击解散房间  服务端会推送弹框消息：decoderFrameSyatemMessage，指令为关闭游戏，在收到自己状态改变消息
    -- 自己点击离开房间  服务端不会推送弹框消息  只会收到自己的状态改变消息
    game.sendEvent(GameDefine.EXIT_GAMESCENE_FINISH_EVENT)
end

-- 登录游戏服务器
local function onLoginServer_step2()
    PlazaManager.lockGameServerSitMsg = 0

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_LOGON, game.SUB_GR_LOGON_USERID, 1024)
    local password = globalUserInfo.szPassword
    local loginRoom = {}

    -- 获取游戏版本号
    local gameVersion = 0
    local gameVersionStr = PlazaManager.getGameVersion(_conn_tagGameServer.wKindID)
    if gameVersionStr ~= nil then
        gameVersion = tonumber(gameVersionStr)
    end

    loginRoom.dwPlazaVersion = PlazaManager.getHallVersion() -- 大厅版本
    loginRoom.dwFrameVersion = PlazaManager.getDeviceType() -- 框架版本
    loginRoom.dwProcessVersion = gameVersion -- 游戏版本
    loginRoom.dwUserID = globalUserInfo.dwUserID
    loginRoom.szPassword = password
    loginRoom.szMachineID = GameDefine.MachineID
    loginRoom.wKindID = _conn_tagGameServer.wKindID
    loginRoom.btGoldOrRoomCard = 1 -- 金币还是房卡

    if _conn_paramsData ~= nil and _conn_paramsData.btGoldOrRoomCard ~= nil then
        loginRoom.btGoldOrRoomCard = _conn_paramsData.btGoldOrRoomCard
    end

    loginRoom.bBuyRoomService = 0
    loginRoom.szCCFlags = "E10ADC3949BA59ABBE56E057F20F883E" -- game.md5("123456")

    rpcSend:writeUInt32(loginRoom.dwPlazaVersion)
    rpcSend:writeUInt32(loginRoom.dwFrameVersion)
    rpcSend:writeUInt32(loginRoom.dwProcessVersion)
    rpcSend:writeUInt32(loginRoom.dwUserID)
    rpcSend:writeUString(loginRoom.szPassword, GameDefine.LEN_MD5 * 2)
    rpcSend:writeUString(loginRoom.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
    rpcSend:writeUInt16(loginRoom.wKindID)
    -- rpcSend:writeUInt32(loginRoom.btGoldOrRoomCard)这个变为ip了

    if GameDefine.playerHostIPStr then
        local tbl_ip = string.split(GameDefine.playerHostIPStr, ".")
        print("----------playerHostIPStr---------", GameDefine.playerHostIPStr)
        rPrint(tbl_ip)
        print("-------------------------")
        for idx, num in ipairs(tbl_ip) do
            rpcSend:writeUInt8(tonumber(num))
            if idx == 4 then
                break
            end
        end
    else
        print("----------playerHostIPStr not found---------")
        rpcSend:writeUInt32(0)
    end

    rpcSend:writeUInt8(loginRoom.bBuyRoomService)
    rpcSend:writeUString(loginRoom.szCCFlags, GameDefine.LEN_MD5 * 2)
    rpcSend:release()
    print("发送登录游戏服务器")
end

local function onLoginServer()
    PlazaManager.accessPlayerIP(onLoginServer_step2)
end

local function onConnection(ip, port, connectCallback, callback)
    if ip == nil or port == nil then
        local str = "no ip:" .. tostring(ip) .. ", port:" .. tostring(port)
        print(str)

        if callback ~= nil then
            callback(false, 0)
        end
        PlazaManager.closeWattingTips()
        if PlazaManager.isOpenGameScene == false then
            PlazaManager.showTips(LangCtrl:getLang().word346)
        end
        return
    end

    ip = PlazaManager.replaceSpecialHost(ip)

    for _, aa in pairs(GameDefine.ConfineIPList) do
        if ip == aa then
            print("GAME_SOCKET ip is in ConfineIPList:", ip)
            if callback ~= nil then
                callback(false, 0)
            end
            PlazaManager.closeWattingTips()
            if PlazaManager.isOpenGameScene == false then
                PlazaManager.showTips(LangCtrl:getLang().word346)
            end
            return
        end
    end

    game.connect(GameDefine.GAME_SOCKET, ip, port, function(succ)
        if succ then
            printLog("ServerModule", "连接游戏服务器成功")

            if callback ~= nil then
                callback(true)
            end

            if connectCallback ~= nil then
                connectCallback()
            end
        else
            if callback ~= nil then
                callback(false, 0)
            end

            printLog("ServerModule", "连接游戏服务器失败")
            PlazaManager.closeWattingTips()
            if PlazaManager.isOpenGameScene == false then
                PlazaManager.showTips(LangCtrl:getLang().word246)
            end
        end
    end, 15, 0)
end

-- 通道变更 重新连接
local function onGateStateConnection(ipInfo)
    if _conn_tagGameServer == nil then
        PlazaManager.showTips(LangCtrl:getLang().word247)
        return
    end

    local args = {}
    args.ips = ipInfo.ips
    args.ports = ipInfo.ports

    if args ~= nil and args.ips ~= nil and args.ports ~= nil and _conn_tagGameServer ~= nil then
        args.ips = PlazaManager.replaceSpecialHost(args.ips)
        args.ips = PlazaManager.confineIPList(args.ips)
        PlazaManager.checkIPPortEqual(args.ips, args.ports)

        if #args.ips == 0 then
            print("GAME_SOCKET onGateStateConnection ips is empty...")
            return
        end

        game.connect(GameDefine.GAME_SOCKET, args.ips, {}, {}, args.ports, function(succ, ip, port, connNum)
            if succ == true then
                print("增加通道链接服务器成功 ip == " .. ip .. "   port == " .. port .. "   connNum == " .. connNum)
            else
                print("增加通道链接服务器失败 ip == " .. ip .. "   port == " .. port .. "   connNum == " .. connNum)
                if connNum > 0 then
                    addFailedip(ip, port)
                end
            end
        end, true, false, 15, 0)
    end
end

local function onGangWayConnection(args, callback)
    if _conn_tagGameServer == nil then
        PlazaManager.showTips(LangCtrl:getLang().word247)
        if callback ~= nil then
            callback(false, 0)
        end
        return
    end

    local ipConnFailCount = 0
    args.ips = PlazaManager.replaceSpecialHost(args.ips)
    args.ips = PlazaManager.confineIPList(args.ips)
    PlazaManager.checkIPPortEqual(args.ips, args.ports)
    local ipConnCount = 0
    for k, v in pairs(args.ips) do
        if string.len(v) > 0 and v ~= "0.0.0.0" then
            ipConnCount = ipConnCount + 1
        end
    end
    print("连接游戏多通道服务器 ip个数=" .. ipConnCount)
    if ipConnCount == 0 then
        PlazaManager.showTips(LangCtrl:getLang().word346)
        if callback ~= nil then
            callback(false, 0)
        end
        return
    end

    _M.registerlinkNetScheduler()
    game.connect(GameDefine.GAME_SOCKET, args.ips, {}, {}, args.ports, function(succ, ip, port, connNum)
        if succ == true and connNum ~= 0 then
            print("连接游戏IP成功 ip == " .. ip .. "  port == " .. port)
            -- 删除连接失败的ip
            if string.len(ip) > 0 and ip ~= "0.0.0.0" and port > 0 then
                removeFailedip(ip, port, true)
            end

            if callback ~= nil then
                callback(true)
                game.sendEvent(GameDefine.CONNECTION_SUCCESS, GameDefine.GAME_SOCKET)
                print("发送游戏连接成功消息")
            end
        else
            -- 保存连接失败的ip
            if string.len(ip) > 0 and ip ~= "0.0.0.0" and port > 0 then
                if _conn_tagGameServer ~= nil then
                    addFailedip(ip, port)
                end
            end

            if connNum == 0 then
                ipConnFailCount = ipConnFailCount + 1
                print("连接失败  本次连接第 == " .. ipConnFailCount .. " 次失败   总共ipcount == " .. ipConnCount)
                if ipConnFailCount == ipConnCount then
                    print("====================网络连接失败====================")
                    clearlLinkFailedip()
                    _M.unlinkNetScheduler()
                    if callback ~= nil then
                        callback(false, 0)
                    end
                end
            end
        end
    end, true, false, 15, 0)
end

-- 连接网络
local function onConnectionServer(connectCallback, callback)
    -- 0空闲 1连接中 2已连接
    local netState = game.getNetWorkState(GameDefine.GAME_SOCKET)
    if netState == 1 then
        print(GameDefine.GAME_SOCKET .. "正在连接中")
    elseif netState == 2 then
        print(GameDefine.GAME_SOCKET .. "已经连接成功 执行回调")
        if callback ~= nil then
            callback(true)
        end

        if connectCallback ~= nil then
            connectCallback()
        end
    elseif netState == 0 then
        if _conn_tagGameServer ~= nil then
            if _conn_tagGameServer.bUseGateServer == true then
                local args = {}
                args.ips = _conn_tagGameServer.szGateAddr
                args.ips1 = _conn_tagGameServer.szGateAddr1
                args.ips2 = _conn_tagGameServer.szGateAddr2
                args.ports = _conn_tagGameServer.wGatePort

                local function onConnectionResult(isSuccess) -- 连接服务器结果
                    if isSuccess == true then
                        if callback ~= nil then
                            callback(true)
                        end

                        if connectCallback ~= nil then
                            connectCallback()
                        end
                    else
                        if callback ~= nil then
                            callback(false, 0)
                        end
                    end
                end

                onGangWayConnection(args, onConnectionResult)
            else
                -- 单通道连接
                local ip = _conn_tagGameServer.szServerAddr
                local port = _conn_tagGameServer.wServerPort
                onConnection(ip, port, connectCallback, callback)
            end
        else
            PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word248)
        end
    end
end

local function loginOutTime()
    PlazaManager.isOpenGameScene = false
    _M.resetServerModuleData()
    PlazaManager.resetRoomServer()
    PlazaManager.closeGameSocket()
    PlazaManager.closeWattingTips()
    PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word249)
end

local function refreshLinkFailedips()
    if linkFailedips == nil or #linkFailedips == 0 then
        return
    end

    for k, v in pairs(linkFailedips) do
        v.curTime = v.curTime + 2
        print("第" .. k .. "条数据===== v.curTime == " .. v.curTime)

        if v.curTime >= v.connIntervalTime and #v.ips >= 1 then
            v.curTime = 0
            v.connIntervalTime = getConnIntervalTime(v.connIntervalTime)

            local curConnIps = {}
            curConnIps.ips = {}
            curConnIps.ports = {}

            if #v.ips > 1 then
                local ipCount = #v.ips
                local ipIndex = 1
                for k_l, v_l in pairs(v.ips) do
                    if v_l.ip == v.lastConnip.ip and v_l.port == v.lastConnip.port then
                        ipIndex = k_l
                        break
                    end
                end

                local curIp = nil
                if ipIndex == ipCount then
                    curIp = v.ips[1]
                else
                    curIp = v.ips[ipIndex + 1]
                end

                if curIp == nil then
                    curIp = v.ips[1]
                end

                local currconnip1 = curIp.ip
                local currconnport1 = curIp.port

                v.lastConnip.ip = currconnip1
                v.lastConnip.port = currconnport1

                table.insert(curConnIps.ips, currconnip1)
                table.insert(curConnIps.ports, currconnport1)
            else
                local currconnip1 = v.ips[1].ip
                local currconnport1 = v.ips[1].port

                v.lastConnip.ip = currconnip1
                v.lastConnip.port = currconnport1

                table.insert(curConnIps.ips, currconnip1)
                table.insert(curConnIps.ports, currconnport1)
            end

            if #curConnIps.ips > 0 and #curConnIps.ports > 0 then
                onGateStateConnection(curConnIps)
            end
        end
    end
end

local function onCheckLinkip(time)
    if PlazaManager.gameServer == nil then
        return
    end

    if _conn_tagGameServer == nil then
        return
    end

    --[[
    local count = #linkFailedips
    if count > 0 then
        print("============onCheckLinkip===========")
        -- dump(linkFailedips)
        print("失败列表有  " .. count .. "   条数据---")
        for k, v in pairs(linkFailedips) do
            print("第" .. k .. "条数据")
            dump(v)
            print("第" .. k .. "条数据")
        end
        print("============onCheckLinkip===========")
    end
    --]]

    refreshLinkFailedips()
end

function _M.registerlinkNetScheduler()
    if linkNetSchedulerID == nil then
        linkNetSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onCheckLinkip, 2, false)
    end
end

function _M.unlinkNetScheduler()
    if linkNetSchedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(linkNetSchedulerID)
        linkNetSchedulerID = nil
    end
end

-- 创建包房
function _M.createPrivate(args)
    _conn_tagGameServer = args.tagGameServer
    _conn_paramsData = args.createRoomData
    _linkActionType = _linkActionEnum.link_create

    local function connectCallback()
        PlazaManager.setWattingData(LangCtrl:getLang().word250, GameDefine.processTime, loginOutTime)
        onLoginServer()
    end

    onConnectionServer(connectCallback)
end

-- 加入包房
function _M.joinPrivate(args)
    _linkActionType = _linkActionEnum.link_join
    _conn_paramsData = args.joinData
    _conn_tagGameServer = args.tagGameServer

    local function connectCallback()
        PlazaManager.setWattingData(LangCtrl:getLang().word250, GameDefine.processTime, loginOutTime)
        onLoginServer()
    end

    onConnectionServer(connectCallback)
end

-- 连接服务器
function _M.onConnectionGR(args, callback)
    _conn_tagGameServer = args.tagGameServer
    _conn_paramsData = args.paramsData

    if args.connType == nil then
        _linkActionType = _linkActionEnum.link_null
    else
        _linkActionType = args.connType
    end

    local function sendLogin()
        onLoginServer()
    end

    onConnectionServer(sendLogin, callback)
end

-- 创建包房
local function questCreatePrivate()
    if _conn_paramsData == nil then
        PlazaManager.closeWattingTips()
        PlazaManager.showTips("创建包房失败参数出错")
        _M.resetServerModuleData()
        PlazaManager.resetRoomServer()
        PlazaManager.closeGameSocket()
        return
    end

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_PERSONAL_TABLE, game.SUB_GR_CREATE_TABLE, 2048)

    local lCellScore = _conn_paramsData.lCellScore -- 底分设置
    local dwDrawCountLimit = _conn_paramsData.dwDrawCountLimit -- 局数限制
    local dwDrawTimeLimit = _conn_paramsData.dwDrawTimeLimit -- 时间限制
    local wJoinGamePeopleCount = _conn_paramsData.wJoinGamePeopleCount -- 参与游戏的人数
    local szPassword = _conn_paramsData.szPassword -- 密码设置
    local cbGameRule = _conn_paramsData.cbGameRule -- 游戏规则
    local btGoldOrRoomCard = _conn_paramsData.btGoldOrRoomCard -- 金币还是房卡   - 0房卡，1金币
    local dwGoldID = _conn_paramsData.dwGoldID -- 金币标识码
    local dwBaseGold = _conn_paramsData.dwBaseGold
    local dwRoomCard = _conn_paramsData.dwRoomCard
    local dwMinGameScore = _conn_paramsData.dwMinGameScore -- 身上最少携带金币数量
    local lRestrictScore = _conn_paramsData.lRestrictScore -- 身上最少携带金币数量
    local cbVideoMode = _conn_paramsData.btTvGame -- 是否是视频游戏 0-不是，1是
    if cbVideoMode == nil then
        cbVideoMode = 0
    end
    local cbPayRoomCardPlayer = 1
    cbPayRoomCardPlayer = _conn_paramsData.cbPayRoomCardPlayer -- 付费方式,0:房主付费，1:最大赢家付费，2:族长支付，3：AA支付
    --    if cbPayRoomCardPlayer==nil then cbPayRoomCardPlayer=1 end

    rpcSend:writeUInt64(lCellScore)
    rpcSend:writeUInt32(dwDrawCountLimit)
    rpcSend:writeUInt32(dwDrawTimeLimit)
    rpcSend:writeUInt16(wJoinGamePeopleCount)
    rpcSend:writeUString(szPassword, 33 * 2)

    for i = 1, 100 do
        rpcSend:writeUInt8(cbGameRule[i])
    end

    rpcSend:writeUInt8(btGoldOrRoomCard)
    rpcSend:writeUInt32(dwGoldID)
    rpcSend:writeUInt32(dwBaseGold)
    rpcSend:writeUInt32(dwRoomCard)
    rpcSend:writeUInt32(dwMinGameScore)
    rpcSend:writeUInt64(lRestrictScore)

    local btmyself = _conn_paramsData.btmyself -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    local dwFamilyID = _conn_paramsData.dwFamilyID -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）
    local lReward = _conn_paramsData.lReward -- 金币模式房，最大赢家打赏创建者的金额
    local wContinueCount = _conn_paramsData.wContinueCount --[[连续创建次数（只有给他人建房时，并且只允许某家族成员游戏时，此参数才起作用；
                                                             主要方便族长无需频繁重复手动建房，在无人开始约局游戏正常解散或超时解散，
                                                             还有建房者房卡<房卡模式>不足支付,或者当前房间维护时,连续建房直接终止,房号每次多是重新随机生成)
                                                            --]]
    rpcSend:writeUInt8(btmyself)
    rpcSend:writeUInt32(dwFamilyID)
    rpcSend:writeUInt64(lReward)
    rpcSend:writeUInt16(wContinueCount)
    rpcSend:writeUString(_conn_paramsData.szDiscripTion1, 256 * 2) -- 包房列表显示房间信息字符串
    rpcSend:writeUString(_conn_paramsData.szDiscripTion2, 256 * 2) -- 包房列表复制房间号字符串
    rpcSend:writeUInt8(cbVideoMode)
    -- rpcSend:writeUInt8(cbPayRoomCardPlayer)
    rpcSend:release()

    _linkActionType = _linkActionEnum.link_null
end

local function questJoinPrivate()
    _M.onQuestSitDwon(_conn_paramsData)
    _linkActionType = _linkActionEnum.link_null
end

function _M.onQuestOption()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_GAME_OPTION, 1024)
    rpcSend:writeUInt8(0) -- 旁观标志
    rpcSend:writeUInt32(0) -- 框架版本
    rpcSend:writeUInt32(1) -- 游戏版本
    rpcSend:release()
end

local function onQuestReady()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_READY, 1024)
    rpcSend:release()
end

-- 申请坐下
function _M.onQuestSitDwon(args)
    if _conn_tagGameServer ~= nil then
        if _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS then
            if args.szPersonalTableID == nil or string.len(args.szPersonalTableID) == 0 then
                PlazaManager.showTips("连接房间号为空")
                return
            end
        end
    end

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_USER, game.SUB_GR_USER_SITDOWN, 1024)
    rpcSend:writeUInt16(args.wTableID)
    rpcSend:writeUInt16(args.wChairID)
    rpcSend:writeUString(args.szPassword, GameDefine.LEN_PASSWORD * 2)
    rpcSend:writeUString(args.szPersonalTableID, 7 * 2)
    rpcSend:release()
end

-- 客户端通知服务端断开连接
function _M.onQuestOutConect()
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GR_LOGON, game.SUB_GR_LOGON_OUT, 1024)
    rpcSend:release()
end

local function onLoginGRFinish(args)
    if globalUserInfo.wTableID == GameDefine.INVALID_TABLE and -- 没桌子
    globalUserInfo.wChairID == GameDefine.INVALID_CHAIR and -- 没椅子
    globalUserInfo.cbUserStatus < GameDefine.US_SIT then -- 不是坐下状态
        if _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS then
            -- 包房模式
            if _linkActionType == _linkActionEnum.link_create then
                questCreatePrivate()
            elseif _linkActionType == _linkActionEnum.link_join then
                questJoinPrivate()
            else
                PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word251)
            end
        else
            -- 金币模式
            if _linkActionType == _linkActionEnum.link_join then
                local enterdata = {}
                enterdata.szPassword = ""
                if _conn_paramsData == nil then
                    enterdata.wTableID = GameDefine.INVALID_TABLE
                    enterdata.wChairID = GameDefine.INVALID_CHAIR
                    enterdata.szPersonalTableID = ""
                else
                    enterdata.wTableID = _conn_paramsData.wTableID
                    enterdata.wChairID = _conn_paramsData.wChair
                    if _conn_paramsData.szPersonalTableID ~= nil then
                        enterdata.szPersonalTableID = _conn_paramsData.szPersonalTableID
                    else
                        enterdata.szPersonalTableID = ""
                    end
                end

                print("请求坐下===========================")
                if _conn_tagGameServer.wKindID == 1004 then
                    openGameScene()
                else
                    _M.onQuestSitDwon(enterdata)
                end
            else
                print("通知游戏")
                -- 通知游戏
                if PlazaManager.isOpenGameScene == true then -- 游戏中长时间掉线 已经被服务端踢掉
                    print("准备关闭游戏场景")
                    closeGameScene()
                end
            end
        end
    else
        -- 断线重连
        PlazaManager.curKindID = _conn_tagGameServer.wKindID
        PlazaManager.curServerID = _conn_tagGameServer.wServerID
        -- 没有打开游戏场景 打开游戏场景
        if PlazaManager.isOpenGameScene == false then
            openGameScene()
        else
            -- 打开了游戏场景 请求游戏配置
            print("请求游戏配置=====")
            PlazaManager.closeWattingTips()
            _M.onQuestOption()
        end
    end
end

local function LoginServerFinish()
    local str = string.format("登录完成 globalUserInfo.wTableID = %s  globalUserInfo.wChairID = %s  globalUserInfo.cbUserStatus = %s   _linkActionType = %s", globalUserInfo.wTableID,
        globalUserInfo.wChairID, globalUserInfo.cbUserStatus, _linkActionType)
    printLog("ServerModule", str)

    if _conn_tagGameServer ~= nil then
        cc.UserDefault:getInstance():setIntegerForKey(GameDefine.SaveKindID, _conn_tagGameServer.wKindID)

        if _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then -- 金币大厅
            print("登录服务器成功 金币场")
            PlazaManager.curGameType = GameDefine.GAME_TYPE.GAME_GENRE_GOLD
        elseif _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS then -- 约战房卡模式
            print("登录服务器成功 包房场")
            PlazaManager.curGameType = _conn_tagGameServer.wServerType
        elseif _conn_tagGameServer.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then -- 电玩城
            print("登录服务器成功 电玩场")
            PlazaManager.curGameType = GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER
        end

        onLoginGRFinish()
        print("处理游戏登录完成")
    end
end

--[[
	--解析游戏数据
]]
-- 解析玩家信息
local function decoderUserInfo(d)
    if PlazaManager.gameServer == nil then
        printLog("ServerModule", "decoderUserInfo error:PlazaManager.gameServer=nil")
        return
    end

    local gameUser = GameUser.createGameUser()
    gameUser.dwGameID = d:readUInt32()
    gameUser.dwUserID = d:readUInt32()
    gameUser.dwGroupID = d:readUInt32()
    gameUser.wFaceID = d:readUInt16()
    gameUser.dwCustomID = d:readUInt32()
    gameUser.cbGender = d:readUInt8()
    gameUser.cbMemberOrder = d:readUInt8()
    gameUser.cbMasterOrder = d:readUInt8()
    gameUser.wTableID = d:readUInt16()
    gameUser.wChairID = d:readUInt16()
    gameUser.cbUserStatus = d:readUInt8()
    gameUser.lScore = d:readInt64()
    gameUser.lGrade = d:readInt64()
    gameUser.lInsure = d:readInt64()
    gameUser.lTempScore = d:readInt64()
    gameUser.dwWinCount = d:readUInt32()
    gameUser.dwLostCount = d:readUInt32()
    gameUser.dwDrawCount = d:readUInt32()
    gameUser.dwFleeCount = d:readUInt32()
    gameUser.dwUserMedal = d:readUInt32()
    gameUser.dwExperience = d:readUInt32()
    gameUser.lLoveLiness = d:readUInt32()
    gameUser.szNickName = d:readUString(GameDefine.LEN_NICKNAME * 2)
    gameUser.avatarURL = d:readUString(GameDefine.LEN_HEADIMGURL * 2)

    if gameUser.cbGender ~= GameDefine.GENDER_MANKIND then
        gameUser.cbGender = GameDefine.GENDER_FEMALE
    end

    -- 更新自己信息
    if gameUser.dwUserID == globalUserInfo.dwUserID then
        globalUserInfo:updateUserState(gameUser.wTableID, gameUser.wChairID, gameUser.cbUserStatus)

        local str = string.format("解析游戏玩家(GR_USER_ENTER) dwUserID=%d,szNickName=%s,avatarURL=%s", gameUser.dwUserID, gameUser.szNickName, gameUser.avatarURL)
        printLog("ServerModule", str)
    end

    PlazaManager.gameServer:enterRoom(gameUser)

    -- 通知
    if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE and gameUser.wTableID == globalUserInfo.wTableID then
        game.sendEvent(GameDefine.GR_USER_ENTER, gameUser)
    end
end

-- 解析积分改变
local function decoderUserScore(d)
    if PlazaManager.gameServer == nil then
        printLog("ServerModule", "decoderUserScore error:PlazaManager.gameServer=nil")
        return
    end

    local data = {}
    -- 积分信息
    data.dwUserID = d:readUInt32()
    data.lScore = d:readInt64() -- 用户分数
    data.lGrade = d:readInt64() -- 用户成绩
    data.lInsure = d:readInt64() -- 用户银行
    data.lTempScore = d:readInt64() -- 临时保留分数
    -- 游戏信息
    data.dwWinCount = d:readUInt32() -- 胜利盘数
    data.dwLostCount = d:readUInt32() -- 失败盘数
    data.dwDrawCount = d:readUInt32() -- 和局盘数
    data.dwFleeCount = d:readUInt32() -- 逃跑盘数
    data.dwUserMedal = d:readUInt32() -- 用户奖牌
    data.dwExperience = d:readUInt32() -- 用户经验
    data.lLoveLiness = d:readUInt32() -- 用户魅力

    data.dwRoomCard = d:readUInt32() -- 用户房卡
    data.dwRoomCard_reward = d:readUInt32() -- 奖励房卡
    data.dwRoomCard_experience = d:readUInt32() -- 体验房卡

    --    local str = string.format("解析玩家积分改变(SUB_GR_USER_SCORE) dwUserID=%d,lScore=%d,data.dwRoomCard=%d,data.dwRoomCard_reward=%d,data.dwRoomCard_experience=%d",data.dwUserID,data.lScore,data.dwRoomCard,data.dwRoomCard_reward,data.dwRoomCard_experience)
    --	printLog("ServerModule",str)

    if globalUserInfo.dwUserID == data.dwUserID then
        local bUpdateScore = false

        -- 包房模式下的金币场
        if PlazaManager.getPrivateInfo().szRoomID ~= "0" and PlazaManager.getPrivateInfo().cbGoldOrRoomCard == 1 then
            bUpdateScore = true
        end

        -- 金币大厅游戏更新金币值
        if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
            bUpdateScore = true
        end

        -- 电玩城更新游戏币
        if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
            bUpdateScore = true
        end

        globalUserInfo:updateUserScore(data, bUpdateScore)
    end

    local gameUser = PlazaManager.gameServer:getUserByUserID(data.dwUserID)
    if gameUser ~= nil then
        gameUser:updateUserScore(data)

        -- 通知
        if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE and gameUser.wTableID == globalUserInfo.wTableID then
            game.sendEvent(GameDefine.GR_USER_SCORE, gameUser)
        end
    end
end

-- 解析状态改变
local function decoderUserState(d)
    if PlazaManager.gameServer == nil then
        printLog("ServerModule", "decoderUserState error:PlazaManager.gameServer=nil")
        return
    end

    local gameUser = {}

    gameUser.dwUserID = d:readUInt32()
    gameUser.wTableID = d:readUInt16()
    gameUser.wChairID = d:readUInt16()
    gameUser.cbUserStatus = d:readUInt8()

    local oldTableID = GameDefine.INVALID_TABLE
    local oldGameUser = PlazaManager.gameServer:getUserByUserID(gameUser.dwUserID)
    if oldGameUser ~= nil then
        oldTableID = oldGameUser.wTableID
    end

    -- 更新自己状态
    if globalUserInfo.dwUserID == gameUser.dwUserID then
        local str = string.format("解析玩家状态改变(SUB_GR_USER_STATUS) dwUserID=%d,cbUserStatus=%d,wTableID=%d,wChairID=%d", gameUser.dwUserID, gameUser.cbUserStatus, gameUser.wTableID,
            gameUser.wChairID)
        printLog("ServerModule", str)

        globalUserInfo:updateUserState(gameUser.wTableID, gameUser.wChairID, gameUser.cbUserStatus)
        if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
            PlazaManager.getGoalRoomInfo().szRoomID = PlazaManager.gameServer:getTableByTableID(globalUserInfo.wTableID).szRoomID
            PlazaManager.getGoalRoomInfo().RoomGrade = PlazaManager.getGameRoomType(_conn_tagGameServer.wNodeID)
        end
    end

    -- 更新状态
    local newGameUser = PlazaManager.gameServer:updateUserStatus(gameUser.dwUserID, gameUser.wTableID, gameUser.wChairID, gameUser.cbUserStatus)

    -- 通知
    if newGameUser ~= nil then
        if newGameUser.cbUserStatus == GameDefine.US_OFFLINE or -- 断线
        newGameUser.cbUserStatus == GameDefine.US_PLAYING or -- 游戏
        newGameUser.cbUserStatus == GameDefine.US_READY or -- 准备
        newGameUser.cbUserStatus == GameDefine.US_SIT then -- 坐下
            -- 和自己是同桌
            if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE and globalUserInfo.wTableID == newGameUser.wTableID then
                game.sendEvent(GameDefine.GR_USER_STATUS, newGameUser)
            end
        elseif gameUser.cbUserStatus == GameDefine.US_FREE or newGameUser.cbUserStatus == GameDefine.US_NULL then -- 站起
            local isSelfStandUp = false -- 自己站起
            local isDeskmateStandUp = false -- 同桌站起

            if globalUserInfo.dwUserID == gameUser.dwUserID then
                isSelfStandUp = true
            end

            if globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE and globalUserInfo.wTableID == oldTableID then
                isDeskmateStandUp = true
            end

            if _conn_tagGameServer.wKindID == 1004 then
                if isSelfStandUp == true or isDeskmateStandUp == true then
                    game.sendEvent(GameDefine.GR_USER_STATUS, newGameUser)
                end
            else
                if isDeskmateStandUp == true then
                    game.sendEvent(GameDefine.GR_USER_STATUS, newGameUser)
                end
            end
        end
    end

    -- 坐下状态 游戏场景
    if globalUserInfo.dwUserID == gameUser.dwUserID and gameUser.cbUserStatus >= GameDefine.US_SIT and PlazaManager.isOpenGameScene == false then
        if PlazaManager.lockGameServerSitMsg == 0 then
            if _conn_tagGameServer.wKindID ~= 1004 then
                openGameScene()
            end
        end
    end

    -- 换桌过程中，用户坐下，请求场景配置消息
    if globalUserInfo.dwUserID == gameUser.dwUserID and gameUser.cbUserStatus >= GameDefine.US_SIT and PlazaManager.ChangeRoomStartChk == true then
        _M.onQuestOption()
    end

    -- 退出游戏场景
    if globalUserInfo.dwUserID == gameUser.dwUserID and gameUser.cbUserStatus <= GameDefine.US_FREE and PlazaManager.isOpenGameScene == true then
        -- 准备关闭游戏场景
        if PlazaManager.isOutGameRoomByServer == true and PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
            -- 金币大厅踢人不关闭场景
            game.sendEvent(GameDefine.GR_USER_STATUS, newGameUser)
        else
            -- 换桌过程中，不离开游戏场景
            if PlazaManager.ChangeRoomStartChk == true then
                return
            end

            if PlazaManager.closeRoombyServer == 0 and PlazaManager.closeGamebyServer == 0 then
                if PlazaManager.curKindID ~= 1004 then
                    closeGameScene()
                end
            end
        end
    end
end

-- 解析坐下失败
local function decoderGRSitFailure(d)
    local wType = d:readUInt32() -- 消息类型
    local szString = d:readUString(256 * 2) -- 消息内容
    szString = GameUtil.filterMultMsg(szString)
    if _conn_tagGameServer ~= nil and _conn_tagGameServer.wKindID == 1004 then

    else
        PlazaManager.clearLockData()
        PlazaManager.isReturnHall = false

        if PlazaManager.ChangeRoomStartChk ~= true then
            PlazaManager.closeGameSocket()
            _M.resetServerModuleData()
            PlazaManager.resetRoomServer()
        end
        PlazaManager.ChangeRoomStartChk = false
    end

    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szString)
    game.sendEvent(GameDefine.GAME_SITDOWN_FAILER, wType)
end

local function decoderGate(d)
    local wServerID = d:readUInt16() -- 房间标识
    local szGateAddr = {} -- 服务地址
    local szGateAddr1 = {} -- 服务地址
    local szGateAddr2 = {} -- 服务地址
    local wGatePort = {} -- 房间端口

    for i = 1, 20 do
        local gateAddr = d:readUString(16 * 2)
        table.insert(szGateAddr, gateAddr)
    end

    for i = 1, 20 do
        local gateAddr1 = d:readUString(16 * 2)
        table.insert(szGateAddr1, gateAddr1)
    end

    for i = 1, 20 do
        local gateAddr2 = d:readUString(16 * 2)
        table.insert(szGateAddr2, gateAddr2)
    end

    for i = 1, 20 do
        local gatePort = d:readUInt16()
        table.insert(wGatePort, gatePort)
    end

    local bIsUseGateServer = d:readUInt8() == 1 -- 使用网关

    -- 更新本地存储的网关
    local tagGameServer = ServerListData.getGameServerByServerID(wServerID)
    if tagGameServer == nil then
        return
    end

    local isAdd = false
    local isMinus = false
    local isSpareAdd = false
    local isSpareMinus = false

    -- 新增加的ip
    local addInfo = {}
    addInfo.ips = {}
    addInfo.ports = {}

    local function ipisExist(ip, port, address, ports)
        local index = -1
        for k, v in pairs(address) do
            local address_port = ports[k]
            if v == ip and address_port == port then
                index = k
                break
            end
        end
        return index
    end
    -- 通道增加改变判断
    for k, v in pairs(szGateAddr) do
        local port = wGatePort[k]
        if string.len(v) > 0 and v ~= "0.0.0.0" and port ~= 0 then
            local ipindex = ipisExist(v, port, tagGameServer.szGateAddr, tagGameServer.wGatePort)
            if ipindex == -1 then
                -- 不存在 则新加了通道

                local spareip_1 = szGateAddr1[k]
                local spareip_2 = szGateAddr2[k]
                if spareip_1 ~= "0.0.0.0" then
                    print("wServerID == " .. wServerID .. "  新增加了备用通道1 ip == " .. spareip_1 .. "  port == " .. port)
                end
                if spareip_2 ~= "0.0.0.0" then
                    print("wServerID == " .. wServerID .. "  新增加了备用通道2 ip == " .. spareip_2 .. "  port == " .. port)
                end

                if PlazaManager.curServerID ~= nil and PlazaManager.curServerID ~= 0 then
                    if PlazaManager.curServerID == wServerID then
                        isAdd = true
                        table.insert(addInfo.ips, v)
                        table.insert(addInfo.ports, port)
                        print("wServerID == " .. wServerID .. "  添加新增加的通道 ip == " .. v .. "  port == " .. port)
                    else
                        print("wServerID == " .. wServerID .. "  不添加新增加的通道 ip == " .. v .. "  port == " .. port .. "  serverID不一样")
                    end
                end
            else
                -- 判断备用ip1
                local spareip1 = szGateAddr1[k]
                local localspareip1 = tagGameServer.szGateAddr1[ipindex]
                if spareip1 ~= localspareip1 then
                    if string.len(spareip1) > 0 and spareip1 ~= "0.0.0.0" then
                        isSpareAdd = true
                        print("wServerID == " .. wServerID .. "  新增加了备用通道1 ip == " .. spareip1 .. "  port == " .. port)
                    else
                        isSpareMinus = true
                        print("wServerID == " .. wServerID .. "  减少了备用通道1 ip == " .. localspareip1 .. "  port == " .. port)
                    end
                end
                -- 判断备用ip2
                local spareip2 = szGateAddr2[k]
                local localspareip2 = tagGameServer.szGateAddr2[ipindex]
                if spareip2 ~= localspareip2 then
                    if string.len(spareip2) > 0 and spareip2 ~= "0.0.0.0" then
                        isSpareAdd = true
                        print("wServerID == " .. wServerID .. "  新增加了备用通道2 ip == " .. spareip2 .. "  port == " .. port)
                    else
                        isSpareMinus = true
                        print("wServerID == " .. wServerID .. "  减少了备用通道2 ip == " .. localspareip2 .. "  port == " .. port)
                    end
                end
            end
        end
    end

    -- 通道减少判断
    for k_local, v_local in pairs(tagGameServer.szGateAddr) do
        local local_port = tagGameServer.wGatePort[k_local]
        if string.len(v_local) > 0 and v_local ~= "0.0.0.0" and local_port > 0 then
            local ipindex = ipisExist(v_local, local_port, szGateAddr, wGatePort)
            if ipindex == -1 then
                -- ip不存在。则减少了通道
                isMinus = true
                local port = tagGameServer.wGatePort[k_local]
                print("wServerID == " .. wServerID .. "  减少了通道 ip == " .. v_local .. "  port == " .. port)

                local spareiplocal_1 = tagGameServer.szGateAddr1[k_local]
                local spareiplocal_2 = tagGameServer.szGateAddr2[k_local]
                if string.len(spareiplocal_1) > 0 and spareiplocal_1 ~= "0.0.0.0" then
                    isSpareMinus = true
                    print("wServerID == " .. wServerID .. "  减少了备用通道1 ip == " .. spareiplocal_1 .. "  port == " .. port)
                end
                if string.len(spareiplocal_2) > 0 and spareiplocal_2 ~= "0.0.0.0" then
                    isSpareMinus = true
                    print("wServerID == " .. wServerID .. "  减少了备用通道2 ip == " .. spareiplocal_2 .. "  port == " .. port)
                end

                -- 删除连接失败列表
                if PlazaManager.curServerID ~= nil and PlazaManager.curServerID ~= 0 then
                    if PlazaManager.curServerID == wServerID then
                        removeFailedip(v_local, port, true)
                        print("wServerID == " .. wServerID .. "  删除失败列表中的通道 ip == " .. v_local .. "  port == " .. port)
                    else
                        print("wServerID == " .. wServerID .. "  不删除失败列表中的通道 ip == " .. v_local .. "  port == " .. port .. "  serverID不一样")
                    end
                end
            end
        end
    end

    tagGameServer.szGateAddr = {}
    tagGameServer.szGateAddr1 = {}
    tagGameServer.szGateAddr2 = {}
    tagGameServer.wGatePort = {}
    tagGameServer.szGateAddr = szGateAddr
    tagGameServer.szGateAddr1 = szGateAddr1
    tagGameServer.szGateAddr2 = szGateAddr2
    tagGameServer.wGatePort = wGatePort
    tagGameServer.bUseGateServer = bIsUseGateServer

    if PlazaManager.isOpenGameScene == true and PlazaManager.curServerID ~= 0 and PlazaManager.curServerID == wServerID then
        _conn_tagGameServer = tagGameServer
        if isAdd == true then
            print("通道发生改变 延迟1秒准备追加通道")
            -- 发起连接
            local gateScheduler = nil

            local function onGateChange()
                if gateScheduler ~= nil then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(gateScheduler)
                end
                print("准备发起追加通道")
                onGateStateConnection(addInfo)
            end

            gateScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onGateChange, 1, false)
        end
    end
end

local function decoderUserIP(d)
    -- 根据玩家数游戏各自解析
    -- game.sendEvent(GameDefine.GAME_USER_IP,d)

    -- 默认读取前面10条数据
    -- 收到该消息的时候 没有收到任何有关游戏的数据消息
    -- 判断不了游戏类型  也打开不了游戏场景

    local userIP = {}
    for i = 1, 10 do
        local ip = d:readUInt32()

        local ip_str = string.format("ip == %d", ip)
        --        printLog("ServerModule",ip_str)

        local ipStr = ""
        if ip > 0 then
            ipStr = GameUtil.int2ip(ip)
        end
        userIP[i] = ipStr
    end

    if #userIP > 0 then
        PlazaManager.userIP = userIP
    end
end

-- 解析创建包房成功
local function decoderCreatePrivateSuccess(d)
    PlazaManager.getPrivateInfo().dwTableOwnerUserID = globalUserInfo.dwUserID
    PlazaManager.getPrivateInfo().dwTurnCount = 0 -- 已进行了几局游戏
    PlazaManager.getPrivateInfo().szRoomID = d:readUString(7 * 2) -- 房间编号
    PlazaManager.getPrivateInfo().dwDrawCountLimit = d:readUInt32() -- 局数限制
    PlazaManager.getPrivateInfo().dwDrawTimeLimit = d:readUInt32() -- 时间限制
    PlazaManager.getPrivateInfo().cbGoldOrRoomCard = d:readUInt8() -- 金币还是房卡类型
    PlazaManager.getPrivateInfo().dwGoldID = d:readUInt32() -- 金币id
    PlazaManager.getPrivateInfo().dwBaseGold = d:readUInt32()
    PlazaManager.getPrivateInfo().lCellScore = d:readInt64()
    PlazaManager.getPrivateInfo().dwRoomCard = d:readUInt32()
    PlazaManager.getPrivateInfo().dwMinGameScore = d:readUInt32()
    PlazaManager.getPrivateInfo().cbGameRule = {}
    for i = 1, 100 do
        local rule = d:readUInt8()
        table.insert(PlazaManager.getPrivateInfo().cbGameRule, rule)
    end

    -- 用户房卡
    globalUserInfo.dwRoomCard = d:readUInt32()
    -- xx22
    globalUserInfo.dwRoomCard_reward = d:readUInt32()
    globalUserInfo.dwRoomCard_experience = d:readUInt32()

    PlazaManager.getPrivateInfo().wJoinGamePeopleCount = d:readUInt16() -- 参加游戏的最大人数
    PlazaManager.getPrivateInfo().lRestrictScore = d:readInt64() -- 单局积分封顶数

    PlazaManager.getPrivateInfo().btMyself = d:readUInt8() -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    PlazaManager.getPrivateInfo().dwFamilyID = d:readUInt32() -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）

    PlazaManager.getPrivateInfo().lReward = d:readInt64() -- 最大赢家打赏，只有在为他人创建房间，并且是金币模式下才可用
    PlazaManager.getPrivateInfo().wContinueCount = d:readUInt16() -- 连续创建次数

    PlazaManager.getPrivateInfo().szDiscripTion1 = d:readUString(256 * 2)
    PlazaManager.getPrivateInfo().szDiscripTion2 = d:readUString(256 * 2)

    PlazaManager.getPrivateInfo().cbVideoMode = d:readUInt8() -- 1:视频游戏 0：非视频游戏
    -- PlazaManager.getPrivateInfo().cbPayRoomCardPlayer =d:readUInt8() --付费方式,0:房主付费，1:最大赢家付费，2:族长支付，3：AA支付
    PlazaManager.closeWattingTips()

    -- 赋值房间锁
    -- PlazaManager.lockRoomID = PlazaManager.getPrivateInfo().szRoomID

    if PlazaManager.getPrivateInfo().btMyself == 0 then
        game.sendEvent(GameDefine.BackCreatePrivateRoomSucc, _conn_tagGameServer.wKindID, PlazaManager.getPrivateInfo())
    else
        game.sendEvent(GameDefine.SC_GR_PRIVATE_INFO)
    end
end

-- 解析创建包房失败
local function decoderCreatePrivateFailer(d)
    local errorCode = d:readUInt32()
    local errorStr = d:readUString(128 * 2)
    errorStr = GameUtil.filterMultMsg(errorStr)

    PlazaManager.closeWattingTips()
    PlazaManager.showTips(errorStr)
    _M.resetServerModuleData()
    PlazaManager.resetRoomServer()
    PlazaManager.closeGameSocket()
end

-- 解析解散桌子
local function decoderCancelTable(d)
    local dwTableID = d:readUInt32()
    local cbResult = d:readUInt8() -- 1 ： 解散桌子 0 ： 继续游戏
end

-- 解散包房
local function decoderQuestDisMiss(d)
    local data = {}
    data.dwUserID = d:readUInt32() -- 用户 I D
    data.dwTableID = d:readUInt32() -- 桌子 I D
    data.dwChairID = d:readUInt32() -- 椅子 I D
    data.dwElpase = d:readUInt32() -- 剩余时间
    data.questUserID = data.dwUserID -- 申请解散者
    data.cbAgree = 1

    if data.dwTableID == globalUserInfo.wTableID and globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
        game.sendEvent(GameDefine.SC_GR_DISMISS_PRIVATE, data)
    end
end

-- 解散答复
local function decoderQuestReply(d)
    local data = {}
    data.dwUserID = d:readUInt32() -- 用户I D
    data.dwTableID = d:readUInt32() -- 桌子 I D
    data.cbAgree = d:readUInt8() -- 用户答复
    if data.cbAgree == 0 then
        data.cbAgree = 2
    end

    local str = string.format("解散答复 dwUserID=%d   cbAgree=%d", data.dwUserID, data.cbAgree)
    printLog("ServerModule", str)

    -- 此处做下注释 以免混淆
    -- 在约战tip消息里面 服务端发过来的解散答复消息里面的 申请解散状态 0,未处理；1，同意；2，不同意    --客户端端的状态已这个注释为准
    -- 客户端提交给服务端的解散状态 = 0（不能为2）  服务端在解散答复转发也为0 故此处收到状态为0  是需要改成2

    if data.dwTableID == globalUserInfo.wTableID and globalUserInfo.wTableID ~= GameDefine.INVALID_TABLE then
        game.sendEvent(GameDefine.SC_GR_DISMISS_PRIVATE_REPLY, data)
    end
end

-- 请求解散结果
local function decoderQuestResult(d)
    local wTableID = d:readUInt32()
    local resultCode = d:readUInt8() -- 1解散桌子  0 继续游戏
    local args = {}
    args.wTableID = wTableID
    args.resultCode = resultCode
    game.sendEvent(GameDefine.SC_GR_DISMISS_PRIVATE_RESULT, args)
end

-- 结束消息
local function decoderPersonalEnd(d)
    local data = {}
    data.szDescribeString = d:readUString(128 * 2)
    data.szNickNames = {}
    data.scores = {}
    for i = 1, 8 do
        local nickName = d:readUString(GameDefine.LEN_NICKNAME * 2)
        table.insert(data.szNickNames, nickName)
    end

    for i = 1, 8 do
        local score = d:readInt64()
        table.insert(data.scores, score)
    end

    data.btGoldOrRoomCard = d:readUInt8()
    data.dwRoomPrice = d:readUInt32()
    data.dwWinUserID = d:readUInt32() -- 最大赢家
    data.szWinNickName = d:readUString(GameDefine.LEN_NICKNAME * 2)
    --    data.nSpecialInfoLen = d:readUInt32() --特殊信息长度
    --    data.cbSpecialInfo = {}

    --    for i=1,100 do
    --        data.cbSpecialInfo[i] = 0    
    --    end

    --    if data.nSpecialInfoLen > 0 then
    --        for i=1,data.nSpecialInfoLen do
    --            local nData = d:readUInt8()
    --            data.cbSpecialInfo[i] = nData
    --        end
    --    end

    local args = {}
    args.data = data
    args.buffer = d
    -- buffer自己解析
    -- 第一个32位为长度 后面根据各自的游戏各自解析

    game.sendEvent(GameDefine.SC_GR_PRIVATE_END, args)
end

local function decoderPersonalTip(d)
    PlazaManager.getPrivateInfo().dwTableOwnerUserID = d:readUInt32() -- 桌主 I D
    PlazaManager.getPrivateInfo().szRoomID = d:readUString(14) -- 房间编号
    PlazaManager.getPrivateInfo().cbGameRule = {}
    for i = 1, 100 do
        local cbRule = d:readUInt8()
        table.insert(PlazaManager.getPrivateInfo().cbGameRule, cbRule)
    end
    PlazaManager.getPrivateInfo().dwTurnCount = d:readUInt32() -- 已进行了几局游戏

    PlazaManager.getPrivateInfo().bEndGameRequest = d:readUInt8() == 1 -- 是否申请解散游戏
    PlazaManager.getPrivateInfo().dwRequestReply = {}
    for i = 1, 100 do
        PlazaManager.getPrivateInfo().dwRequestReply[i] = d:readUInt32() -- 申请解散状态 0,未处理；1，同意；2，不同意
    end

    PlazaManager.getPrivateInfo().lMinGameScore = d:readInt64() -- 最少入坐分数
    PlazaManager.getPrivateInfo().wJoinGamePeopleCount = d:readUInt16() -- 参加游戏的最大人数
    PlazaManager.getPrivateInfo().lCellScore = d:readInt64() -- 游戏底分
    PlazaManager.getPrivateInfo().cbGoldOrRoomCard = d:readUInt8()
    PlazaManager.getPrivateInfo().dwRoomCard = d:readUInt32() -- 消耗的房卡
    PlazaManager.getPrivateInfo().dwGoldID = d:readUInt32() -- 金币币种id
    PlazaManager.getPrivateInfo().dwBaseGold = d:readUInt32() -- 消耗的金币
    PlazaManager.getPrivateInfo().dwDrawCountLimit = d:readUInt32() -- 游戏总局数
    PlazaManager.getPrivateInfo().dwDrawTimeLimit = d:readUInt32() -- 游戏总时间
    PlazaManager.getPrivateInfo().dwTimeAfterBeginCount = d:readUInt32() -- 一局开始多长时间后解散桌子 单位秒
    PlazaManager.getPrivateInfo().dwTimeOffLineCount = d:readUInt32() -- 掉线多长时间后解散桌子  单位秒
    PlazaManager.getPrivateInfo().dwTimeNotBeginGame = d:readUInt32() -- 多长时间未开始游戏解散桌子	 单位秒
    PlazaManager.getPrivateInfo().dwTimeAfterCreateRoom = d:readUInt32() -- 私人房创建多长时间后无人坐桌解散桌子
    PlazaManager.getPrivateInfo().lRestrictScore = d:readInt64() -- 单局积分封顶数
    PlazaManager.getPrivateInfo().btMyself = d:readUInt8() -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    PlazaManager.getPrivateInfo().dwFamilyID = d:readUInt32() -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）
    PlazaManager.getPrivateInfo().lReward = d:readInt64() -- 最大赢家打赏，只有在为他人创建房间，并且是金币模式下才可用
    PlazaManager.getPrivateInfo().wContinueCount = d:readUInt16() -- 连续创建次数

    PlazaManager.getPrivateInfo().szDiscripTion1 = d:readUString(256 * 2)
    PlazaManager.getPrivateInfo().szDiscripTion2 = d:readUString(256 * 2)
    PlazaManager.getPrivateInfo().cbVideoMode = d:readUInt8() -- 1:视频游戏 0：非视频游戏
    -- PlazaManager.getPrivateInfo().cbPayRoomCardPlayer =d:readUInt8() --付费方式,0:房主付费，1:最大赢家付费，2:族长支付，3：AA支付

    PlazaManager.getPrivateInfo().dwElpase = math.floor(d:readInt32() / 1000) -- 解散剩余时间

    game.sendEvent(GameDefine.SC_GR_PRIVATE_INFO)
end

-- 解析解散私人场
local function decoderPersonalDismiss(d)
    local data = {}

    data.cbIsDissumSuccess = d:readUInt8() -- 是否解散成功
    data.szRoomID = d:readUString(GameDefine.private_ROOM_ID_LEN * 2) -- 桌子 I D

    local timeData = {}
    timeData.wYear = d:readUInt32()
    timeData.wMonth = d:readUInt32()
    timeData.wDayOfWeek = d:readUInt32()
    timeData.wDay = d:readUInt32()
    timeData.wHour = d:readUInt32()
    timeData.wMinute = d:readUInt32()
    timeData.wSecond = d:readUInt32()
    timeData.wMilliseconds = d:readUInt32()
    data.sysDissumeTime = os.date("%m/%d/%y, %H:%M:%S", os.time({
        day = timeData.wDay,
        month = timeData.wMonth,
        year = timeData.wYear,
        sec = timeData.wSecond,
        min = timeData.wMinute,
        hour = timeData.wHour
    }))

    data.PersonalUserScoreInfo = {}
    for i = 1, GameDefine.private_PERSONAL_ROOM_CHAIR do
        local tagPersonalUserScoreInfo = {}
        tagPersonalUserScoreInfo.dwUserID = d:readUInt32() -- 玩家ID
        tagPersonalUserScoreInfo.szUserNicname = d:readUString(GameDefine.LEN_NICKNAME * 2) -- 用户昵称
        tagPersonalUserScoreInfo.lScore = d:readInt64() -- 用户分数
        tagPersonalUserScoreInfo.lGrade = d:readInt64() -- 用户成绩
        tagPersonalUserScoreInfo.lTaxCount = d:readInt64() -- 税收总数
        table.insert(data.PersonalUserScoreInfo, tagPersonalUserScoreInfo)
    end
end

-- 解析游戏状态
local function decoderGameStatus(d)
    PlazaManager.gameStatus.cbGameStatus = d:readUInt8()
    PlazaManager.gameStatus.cbAllowLookon = d:readUInt8()
    game.sendEvent(GameDefine.GR_GAME_STATUS)
end

local function systemCMDProcess(wType, szString)
    -- 是否弹框
    local isEJECT = bit.band(wType, GameDefine.SMT_EJECT)
    -- 是否弹出tip
    local isTip = bit.band(wType, GameDefine.SMT_PROMPT)
    -- 是否滚动tip
    local isRoll = bit.band(wType, GameDefine.SMT_TABLE_ROLL)
    -- 是否关闭房间
    local isCloseRoom = bit.band(wType, GameDefine.SMT_CLOSE_ROOM)
    -- 是否关闭游戏
    local isCloseGame = bit.band(wType, GameDefine.SMT_CLOSE_GAME)
    -- 是否断开连接
    local isCloseNet = bit.band(wType, GameDefine.SMT_CLOSE_LINK)

    --[[
    local info1 = "systemCMDProcess ==> wType:" .. wType .. ", szString==  " .. tostring(szString)
    local info2 = "systemCMDProcess ==> isEJECT:" .. tostring(isEJECT) .. ", isTip:" .. tostring(isTip) .. ", isRoll:" .. tostring(isRoll)
    local info3 = "systemCMDProcess ==> isCloseRoom:" .. tostring(isCloseRoom) .. ", isCloseGame:" .. tostring(isCloseGame) .. ", isCloseNet:" .. tostring(isCloseNet)

    print(info1)
    print(info2)
    print(info3)
    -- ]]

    if isEJECT > 0 or isTip > 0 or isRoll > 0 then
        -- 服务端发送过来强制关闭房间
        PlazaManager.closeRoombyServer = isCloseRoom
        -- 服务端发送过来强制关闭游戏
        PlazaManager.closeGamebyServer = isCloseGame
    else
        PlazaManager.closeRoombyServer = 0
        PlazaManager.closeGamebyServer = 0
    end

    local isHide = false
    if isCloseGame > 0 or isCloseRoom > 0 or isCloseNet > 0 then
        -- 判断玩家是否被服务器
        if isEJECT > 0 then
            PlazaManager.isOutGameRoomByServer = true
        end

        if globalUserInfo.cbUserStatus > 1 and globalUserInfo.wChairID ~= GameDefine.INVALID_CHAIR and PlazaManager.getPrivateInfo().dwTableOwnerUserID == globalUserInfo.dwUserID then
            isHide = true
            PlazaManager.closeRoombyServer = 0
            PlazaManager.closeGamebyServer = 0
        end

        if PlazaManager.isOpenGameScene then
            _M.resetServerModuleData()
            PlazaManager.resetRoomServer()
            PlazaManager.closeGameSocket()
            PlazaManager.closeRefreshSocket()
        end
    end

    local function onCloseFun()
        if isCloseRoom > 0 or isCloseGame > 0 then
            closeGameScene()
        elseif isCloseNet > 0 then
            _M.resetServerModuleData()
            PlazaManager.resetRoomServer()
            PlazaManager.closeGameSocket()
        end
    end

    -- 同时只处理一种
    if isEJECT > 0 then
        if isHide == false then
            PlazaManager.closeWattingTips()
            PlazaManager.showConfirmNode("ok", szString or "tips info", nil, onCloseFun)
        end
    elseif isTip > 0 or isRoll > 0 then
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(szString)
        if isCloseRoom > 0 or isCloseGame > 0 then
            closeGameScene()
        elseif isCloseNet > 0 then
            _M.resetServerModuleData()
            PlazaManager.resetRoomServer()
            PlazaManager.closeGameSocket()
        end
    end
end

-- 解析框架系统消息
local function decoderFrameSyatemMessage(d)
    local wType = d:readUInt16() -- 消息类型
    local wLength = d:readUInt16() -- 消息长度
    local szString = d:readUString() -- 消息内容
    szString = GameUtil.filterMultMsg(szString)

    systemCMDProcess(wType, szString)
end

-- 解析游戏场景消息
local function decoderGameScene(d)
    -- 游戏场景 不同的游戏 场景消息结构不一样 游戏各自解析
    game.sendEvent(GameDefine.GR_GAME_SCENE, d)

    --    debugLog(debugLogType,"处理场景消息完成 准备上传gps")

    --    --上传gps
    --    local function onUploadGPS(x, y)
    --        if x == nil then x=0 end
    --        if y == nil then y=0 end
    --        print("gps:x == "..x.." gps:y == "..y)

    --        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_GPS, 1024)
    --        rpcSend:writeUInt32(x)
    --        rpcSend:writeUInt32(y)
    --        rpcSend:writeUInt32(globalUserInfo.dwUserID)
    --        rpcSend:writeUInt16(0)
    --        rpcSend:release()
    --        debugLog(debugLogType,"lua发送gps完成")
    --    end

    --    game.requestLocation(onUploadGPS)
end

local function decoderUpdateNotify(d)
    -- 升级标志
    local cbMustUpdatePlaza = d:readUInt8() -- 强行升级
    local cbMustUpdateClient = d:readUInt8() -- 强行升级

    local dwCurrentPlazaVersionPC1 = d:readUInt8() -- 当前版本
    local dwCurrentPlazaVersionPC2 = d:readUInt8() -- 当前版本
    local dwCurrentPlazaVersionPC3 = d:readUInt8() -- 当前版本
    local dwCurrentPlazaVersionPC4 = d:readUInt8() -- 当前版本

    -- 当前版本
    local dwCurrentClientVersionPC5 = d:readUInt8() -- PC大厅
    local dwCurrentClientVersionPC6 = d:readUInt8() -- 手机大厅
    local dwCurrentClientVersionPC7 = d:readUInt8() -- pc游戏
    local dwCurrentClientVersionPC8 = d:readUInt8() -- 手机游戏

    print(dwCurrentPlazaVersionPC1, dwCurrentPlazaVersionPC2, dwCurrentPlazaVersionPC3, dwCurrentPlazaVersionPC4, dwCurrentPlazaVersionPC5, dwCurrentPlazaVersionPC6, dwCurrentPlazaVersionPC7,
        dwCurrentPlazaVersionPC8)

    local function onClose(isOk)
        cc.Director:getInstance():endToLua()
    end

    if cbMustUpdatePlaza == 1 then
        PlazaManager.closeWattingTips()
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word252, nil, onClose)
    end

    if cbMustUpdateClient == 1 then
        PlazaManager.closeWattingTips()
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word253, nil, onClose)
    end
end
-- 解析桌子信息消息
local function decoderTableInfo(d)
    local tableData = {}
    tableData.wTableCount = d:readUInt16() -- 桌子数目
    tableData.TableStatusArray = {}
    for i = 1, tableData.wTableCount do
        local tagTableStatus = {}
        tagTableStatus.cbTableLock = d:readUInt8()
        tagTableStatus.cbPlayStatus = d:readUInt8()
        tagTableStatus.cbTableGameLock = d:readUInt8()
        tagTableStatus.m_wOwnerID = d:readUInt16()
        tagTableStatus.szRoomID = d:readUString(7 * 2)

        tableData.TableStatusArray[i] = tagTableStatus
    end

    if PlazaManager.gameServer ~= nil then
        PlazaManager.gameServer:updateTableInfo(tableData)
    end
end

-- 解析桌子状态消息
local function decoderTableStatues(d)
    local tagTableStatus = {}
    tagTableStatus.wTableID = d:readUInt16()
    tagTableStatus.cbTableLock = d:readUInt8()
    tagTableStatus.cbPlayStatus = d:readUInt8()
    tagTableStatus.cbTableGameLock = d:readUInt8()
    tagTableStatus.m_wOwnerID = d:readUInt16()
    tagTableStatus.szRoomID = d:readUString(7 * 2)

    if PlazaManager.gameServer ~= nil then
        PlazaManager.gameServer:updateTableStatue(tagTableStatus)
    end

    if globalUserInfo.wTableID == tagTableStatus.wTableID then
        game.sendEvent(GameDefine.GameTableStatueChange, tagTableStatus.cbPlayStatus)
    end
end

-- 喇叭消息
local function decoderPropertyTrumpet(d)
    local wType = d:readUInt16() -- 消息类型
    local wLength = d:readUInt16() -- 消息长度
    local szString = d:readUString(1024 * 2) -- 消息内容

    local trumpetData = {}

    trumpetData.TrumpetColor = {} -- 喇叭颜色
    trumpetData.TrumpetColor[1] = 0xff
    trumpetData.TrumpetColor[2] = 0xff
    trumpetData.TrumpetColor[3] = 0xff
    trumpetData.TrumpetColor[4] = 0
    trumpetData.szTrumpetContent = GameUtil.filterMultMsg(szString, 1) -- 喇叭内容

    if trumpetData.szTrumpetContent then
        game.sendEvent(GameDefine.AcceptTrumpetContent, trumpetData)
    end
end

-- 喇叭消息改为滚动消息
local function decoderPropertyTrumpetRoll(d)
    local trumpetData = {}
    trumpetData.wPropertyIndex = d:readUInt16() -- 道具索引
    trumpetData.dwSendUserID = d:readUInt32() -- 用户 I D
    trumpetData.TrumpetColor = {} -- 喇叭颜色
    trumpetData.TrumpetColor[1] = d:readUInt8()
    trumpetData.TrumpetColor[2] = d:readUInt8()
    trumpetData.TrumpetColor[3] = d:readUInt8()
    trumpetData.TrumpetColor[4] = d:readUInt8()
    trumpetData.szSendNickName = d:readUString(GameDefine.LEN_NICKNAME * 2) -- 玩家昵称
    trumpetData.szTrumpetContent = d:readUString(128 * 2) -- 喇叭内容

    trumpetData.szTrumpetContent = GameUtil.filterMultMsg(trumpetData.szTrumpetContent, 1)
    if trumpetData.szTrumpetContent then
        local trumpetDataStr = LangCtrl:getLang().word254 .. trumpetData.szSendNickName .. "：" .. trumpetData.szTrumpetContent
        game.sendEvent(GameDefine.AcceptTrumpetContentRoll, trumpetDataStr)
    end
end

-- 解析登录数据
local function decoderLoginData(cmdId, d)
    if cmdId == game.SUB_GR_LOGON_SUCCESS then -- 登录成功
        local dwUserRight = d:readUInt32() -- 用户权限
        local dwMasterRight = d:readUInt32() -- 管理权限
    elseif cmdId == game.SUB_GR_LOGON_FAILURE then -- 登录失败
        print("SUB_GR_LOGON_FAILURESUB_GR_LOGON_FAILURE")
        local errorCode = d:readUInt32()
        local errorStr = d:readUString()
        errorStr = GameUtil.filterMultMsg(errorStr) or ""
        _M.resetServerModuleData()
        PlazaManager.resetRoomServer()
        PlazaManager.closeGameSocket()
        PlazaManager.closeWattingTips()

        -- 首先查找大括号{} 只要查找到了就当做是登录游戏失败 锁在其它游戏里面处理
        local index1 = string.find(errorStr, "{")
        local index2 = string.find(errorStr, "}")

        if index1 ~= nil and index2 ~= nil then
            local id = string.sub(errorStr, index1 + 1, index2 - 1)
            local serverID = tonumber(id)
            if serverID ~= nil then
                local function onLoginLockServer(isOk)
                    if isOk == true then
                        PlazaManager.onLoginLockServer(serverID)
                    end
                end
                PlazaManager.showConfirmNode("yes_no", errorStr .. LangCtrl:getLang().word255, nil, onLoginLockServer)
            else
                PlazaManager.showTips(errorStr)
            end
        else
            PlazaManager.showTips(errorStr)
        end
        game.sendEvent(GameDefine.LoginGameServerFail)
    elseif cmdId == game.SUB_GR_LOGON_FINISH then -- 登录完成
        print("SUB_GR_LOGON_FINISHSUB_GR_LOGON_FINISH")
        LoginServerFinish()
    elseif cmdId == game.SUB_GR_UPDATE_NOTIFY then -- 升级提示
        decoderUpdateNotify(d)
    end
end

-- 解析配置数据
local function decoderGRConfig(cmdId, d)
    if cmdId == game.SUB_GR_CONFIG_SERVER then -- 房间配置
        local data = {}
        data.tableCount = d:readUInt16() -- 桌子数目
        data.chairCount = d:readUInt16() -- 椅子数目
        data.servetType = d:readUInt16() -- 房间类型
        data.serverRule = d:readUInt32() -- 房间规则
        data.lCellScore = d:readUInt64() -- 单元金币
        data.lMinEnterScore = d:readUInt64() -- 进入房间最低金币
        data.lMaxEnterScore = d:readUInt64() -- 进入房间最高金币
        data.lMaxUserPerTable = d:readUInt32() -- 每桌最大人数

        PlazaManager.getGoalRoomInfo().lCellScore = data.lCellScore
        PlazaManager.getGoalRoomInfo().lMinEnterScore = data.lMinEnterScore
        PlazaManager.getGoalRoomInfo().lMaxEnterScore = data.lMaxEnterScore
        PlazaManager.getGoalRoomInfo().lMaxUserPerTable = data.lMaxUserPerTable

        -- 配置房间
        if _conn_tagGameServer ~= nil then
            PlazaManager.gameServer = GameServer.configGameServer(data, _conn_tagGameServer.wServerID, _conn_tagGameServer.dwOnLineCount)
        end
    elseif cmdId == game.SUB_GR_CONFIG_FINISH then -- 配置完成
        printLog("ServerModule", "房间配置完成")
    elseif cmdId == game.SUB_GR_HISTROY then -- 下发游戏记录(30秒)
        local tableGameRule = {}
        tableGameRule.wTableID = d:readUInt16()
        tableGameRule.cbStat = d:readUInt8() -- 当前状态
        tableGameRule.cbCurrTime = d:readUInt8() -- 当前状态已经持续的时长，单位秒
        tableGameRule.wSize = d:readUInt16()
        tableGameRule.cbHistroy = {}
        for i = 1, tableGameRule.wSize do
            tableGameRule.cbHistroy[i] = d:readUInt8()
        end

        -- 更新桌子游戏规则
        if PlazaManager.gameServer ~= nil then
            PlazaManager.gameServer:updateTableGameRule(tableGameRule)
        else
            print("server send data error:1")
        end
    elseif cmdId == game.SUB_GR_TABLE_RULE then -- 下发桌子规则
        local tableRule = {}
        tableRule.wTableID = d:readUInt16()
        tableRule.wSize = d:readUInt16()
        tableRule.cbRule = {}
        for i = 1, tableRule.wSize do
            tableRule.cbRule = d:readUInt8()
        end

        -- 更新桌子规则
        if PlazaManager.gameServer ~= nil then
            PlazaManager.gameServer:updateTableRule(tableRule)
        else
            print("server send data error:2")
        end
    end
end

-- 解析用户数据
local function decoderGRUser(cmdId, d)
    if cmdId == game.SUB_GR_USER_ENTER then -- 用户进入
        decoderUserInfo(d)
    elseif cmdId == game.SUB_GR_USER_SCORE then -- 用户积分
        decoderUserScore(d)
    elseif cmdId == game.SUB_GR_USER_STATUS then -- 用户状态
        decoderUserState(d)
    elseif cmdId == game.SUB_GR_SIT_FAILED then -- 坐下失败
        decoderGRSitFailure(d)
    elseif cmdId == game.SUB_GR_GATE_MODIFY then -- 更新下发多通道网关IP
        decoderGate(d)
    elseif cmdId == game.SUB_GR_USERIP then -- 玩家ip
        decoderUserIP(d)
    elseif cmdId == game.SUB_GR_PROPERTY_TRUMPET then -- 喇叭消息(改为游戏中滚动消息)
        decoderPropertyTrumpetRoll(d)
    end
end

-- 解析包房数据
local function decoderGRPrivate(cmdId, d)
    if cmdId == game.SUB_GR_CREATE_SUCCESS then -- 创建包房成功
        decoderCreatePrivateSuccess(d)
    elseif cmdId == game.SUB_GR_CREATE_FAILURE then -- 创建包房失败
        decoderCreatePrivateFailer(d)
    elseif cmdId == game.SUB_GR_CANCEL_TABLE then -- 解散桌子
        decoderCancelTable(d)
    elseif cmdId == game.SUB_GR_CANCEL_REQUEST then -- 申请解散游戏返回
        decoderQuestDisMiss(d)
    elseif cmdId == game.SUB_GR_REQUEST_RESULT then -- 请求解散结果
        decoderQuestResult(d)
    elseif cmdId == game.SUB_GR_REQUEST_REPLY then -- 请求解散答复
        decoderQuestReply(d)
    elseif cmdId == game.SUB_GR_PERSONAL_TABLE_END then -- 结束消息
        decoderPersonalEnd(d)
    elseif cmdId == game.SUB_GR_HOST_DISSUME_TABLE_RESULT then -- 解散桌子
        decoderPersonalDismiss(d)
    elseif cmdId == game.SUB_GR_CURRECE_ROOMCARD_AND_BEAN then -- 强制解散桌子
        printLog("ServerNodule", "SUB_GR_CURRECE_ROOMCARD_AND_BEAN 强制解散桌子")
    end
end

-- 解析系统命令
local function decoderCMSystem(cmdId, d)
    if cmdId == game.SUB_CM_SYSTEM_MESSAGE then -- 系统消息
        local wType = d:readUInt16() -- 消息类型
        local wLength = d:readUInt16() -- 消息长度
        local szString = d:readUString() -- 消息内容
        szString = GameUtil.filterMultMsg(szString)

        systemCMDProcess(wType, szString)
    end
end

-- 解析用戶聊天命令
local function decoderGFCharGame(cmdId, d)
    if cmdId == game.SUB_GF_USER_CHAT then -- 用户聊天
        local data = {}
        data.ChatLength = d:readUInt16() -- 字符串长度
        data.MsgType = d:readUInt16() -- 类型
        data.Index = d:readUInt16() -- 索引
        data.SendUserID = d:readUInt32() -- 发送用户
        data.TargetUserID = d:readUInt32() -- 目标用户
        data.ChatString = d:readUString(128 * 2) -- 字符串

        local curTime = os.time()
        if curTime - PlazaManager.appEnterBackgroundTime >= 1 then
            game.sendEvent(GameDefine.GF_USER_CHAT, data)
        end
    elseif cmdId == game.SUB_GF_USER_EXPRESSION then -- 用户表情
    elseif cmdId == game.SUB_GR_TABLE_TALK then -- 用户聊天
    end
end

-- 解析获取救济金
local function decoderGFGiveAlms(decoder)
    local data = {}
    data.lRemainCount = decoder:readUInt32() -- 剩余领取救济金的次数
    data.lGrantGold = decoder:readUInt32() -- 本次领取的救济金数量
    if data.lGrantGold > 0 then
        game.sendEvent(GameDefine.GiveAlmsSuccessByGame, data)
    end
end

-- 解析框架命令
local function decoderGFFrame(cmdId, d)
    if cmdId == game.SUB_GF_GAME_STATUS then -- 游戏状态
        decoderGameStatus(d)
    elseif cmdId == game.SUB_GF_GAME_SCENE then -- 游戏场景
        decoderGameScene(d)
    elseif cmdId == game.SUB_GF_SYSTEM_MESSAGE then -- 系统消息
        decoderFrameSyatemMessage(d)
    elseif cmdId == game.SUB_GF_USER_CHAT then -- 用户聊天
        decoderGFCharGame(cmdId, d)
    elseif cmdId == game.SUB_GF_USER_EXPRESSION then -- 用户表情
        decoderGFCharGame(cmdId, d)
    elseif cmdId == game.SUB_GR_TABLE_TALK then -- 用户聊天
        decoderGFCharGame(cmdId, d)
    elseif cmdId == game.SUB_GF_GRANT_ALMS then -- 获取救济金
        decoderGFGiveAlms(d)
    elseif cmdId == game.SUB_GF_SYSTEM_HORN then -- 接受喇叭消息
        decoderPropertyTrumpet(d)
    end
end

-- 解析游戏命令
local function decoderGFGame(cmdId, d)
    if cmdId == game.SUB_GR_PERSONAL_TABLE_TIP then
        decoderPersonalTip(d)
    else
        game.sendEvent(GameDefine.GR_GAME, cmdId, d)
    end
end

local function onConnectioned(name, ip, port, connNum)
    if name == GameDefine.GAME_SOCKET then

        if ip ~= nil and string.len(ip) > 0 and ip ~= "0.0.0.0" and port ~= nil and port > 0 then
            removeFailedip(ip, port, true)
        end
    end
end

local function onDisConnectioned(name, ip, port, connNum, bgReconnect)
    if name == GameDefine.GAME_SOCKET then
        local str = "收到ip断开连接 == ip == " .. ip .. "  port == " .. port .. "  connNum == " .. connNum
        print(str)

        if PlazaManager.gameServer ~= nil and connNum == 0 then
            clearlLinkFailedip()
            _M.unlinkNetScheduler()
        else
            if ip ~= nil and string.len(ip) > 0 and ip ~= "0.0.0.0" and port ~= nil and port > 0 then
                if _conn_tagGameServer ~= nil then
                    addFailedip(ip, port)
                end
            end
        end
    end
end

function _M.onInit()
    -- 请求准备
    game.registerEvent(GameDefine.GR_QUEST_READY, function()
        onQuestReady()
    end)

    game.registerEvent("onConnectioned", function(name, ip, port, connNum)
        onConnectioned(name, ip, port, connNum)
    end)
    game.registerEvent("onDisConnectioned", function(name, ip, port, connNum, bgReconnect)
        onDisConnectioned(name, ip, port, connNum, bgReconnect)
    end)
    PlazaManager.resetRoomServer()
end

function _M.accept(name, modId, cmdId)
    if name == GameDefine.GAME_SOCKET then
        if modId == game.MDM_GR_LOGON or modId == game.MDM_GR_CONFIG or modId == game.MDM_GR_USER or modId == game.MDM_CM_SYSTEM or modId == game.MDM_GF_FRAME or modId == game.MDM_GF_GAME or modId ==
            game.MDM_GR_PERSONAL_TABLE or modId == game.MDM_GR_STATUS then
            return true
        end
    end
    return false
end

function _M.process(name, modId, cmdId, decoder)
    if modId == game.MDM_GR_LOGON then -- 登录命令
        decoderLoginData(cmdId, decoder)
    elseif modId == game.MDM_GR_CONFIG then -- 配置命令
        decoderGRConfig(cmdId, decoder)
    elseif modId == game.MDM_GR_USER then -- 用户命令
        decoderGRUser(cmdId, decoder)
    elseif modId == game.MDM_GR_PERSONAL_TABLE then -- 包房命令
        decoderGRPrivate(cmdId, decoder)
    elseif modId == game.MDM_CM_SYSTEM then -- 系统命令
        decoderCMSystem(cmdId, decoder)
    elseif modId == game.MDM_GF_FRAME then -- 框架命令
        decoderGFFrame(cmdId, decoder)
    elseif modId == game.MDM_GF_GAME then -- 游戏命令
        decoderGFGame(cmdId, decoder)
    elseif modId == game.MDM_GR_STATUS then -- 桌子状态命令
        if cmdId == game.SUB_GR_TABLE_INFO then -- 桌子信息
            decoderTableInfo(decoder)
        elseif cmdId == game.SUB_GR_TABLE_STATUS then -- 桌子状态
            decoderTableStatues(decoder)
        end
    else
        printLog("ServerModule", "错误消息命令 name =" .. name .. " modId=" .. modId .. " cmdId=" .. cmdId)
    end

    decoder:release()
end

function _M.unSchedule()
    -- body
end

return _M
