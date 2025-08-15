local _M = {}

-- 登录ip列表
local loginIps = nil

-- 请求网络列表
local questList = {}
local sendQuesting = false

function _M.clearLoginIPs()
    loginIps = nil
end

local function sendQuest()
    if sendQuesting == false then
        sendQuesting = true
        while (#questList > 0) do
            local call_fun = questList[1]
            if call_fun ~= nil and type(call_fun) == "function" then
                call_fun(true)
            end
            table.remove(questList, 1)
        end
        sendQuesting = false
    end
end

local function onConnection(args, callback)
    local function onConnResult(succ, ip, port, connNum)
        if succ == true then
            loginIps = nil
            if callback ~= nil then
                callback(true)
            end
        else
            if connNum == 0 then
                if callback ~= nil then
                    callback(false)
                end
            end
        end
    end

    args.ips = PlazaManager.replaceSpecialHost(args.ips)
    args.ips = PlazaManager.confineIPList(args.ips)
    PlazaManager.checkIPPortEqual(args.ips, args.ports)
    print("==============Refresh Module Start Connection===============")
    rPrint(args)
    print("==========================================================")
    if #args.ips == 0 then
        print("REFRESH_SOCKET ips is empty...")
        if callback ~= nil then
            callback(false)
        end
        return
    end
    game.connect(GameDefine.REFRESH_SOCKET, args.ips, {}, {}, args.ports, onConnResult, false, true, 20, 0)
end

-- 连接网络
local function onConnectionServer(processfun, callback)
    -- 0空闲 1连接中 2已连接
    local netState = game.getNetWorkState(GameDefine.REFRESH_SOCKET)

    if netState == 1 then
        print(GameDefine.REFRESH_SOCKET .. LangCtrl:getLang().word231)
    elseif netState == 2 then
        print(GameDefine.REFRESH_SOCKET .. LangCtrl:getLang().word232)
        if callback ~= nil then
            callback(true)
        end
        processfun()
    elseif netState == 0 then
        table.insert(questList, processfun)

        if loginIps == nil then
            local function onConnectionResult(isSuccess)
                if isSuccess == true then -- 连接成功
                    if callback ~= nil then
                        callback(true)
                    end
                    _M.clearLoginIPs()
                    sendQuest()
                else
                    -- 连接失败
                    if loginIps ~= nil then
                        -- 如果没有ip列表 则提示失败
                        if #loginIps == 0 then
                            _M.clearLoginIPs()
                            if callback ~= nil then
                                callback(false, 0)
                            end
                        else
                            -- 如果还有ip列表 则继续连接
                            if callback ~= nil then
                                callback(false, 1)
                            end

                            local scheduleScriptHandler = nil
                            local function onReconnection()
                                if scheduleScriptHandler ~= nil then
                                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleScriptHandler)
                                end

                                if loginIps ~= nil and #loginIps > 0 then
                                    local ipdatas = table.remove(loginIps)
                                    onConnection(ipdatas, onConnectionResult)
                                else
                                    _M.clearLoginIPs()
                                    if callback ~= nil then
                                        callback(false, 0)
                                    end
                                end
                            end
                            scheduleScriptHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onReconnection, 0.5, false)
                        end
                    end
                end
            end

            local argsIps = PlazaManager.getLoginIP()
            loginIps = PlazaManager.radomIP(argsIps.loginIp, argsIps.loginPort, GameDefine.IPGroupCount)
            if loginIps ~= nil and #loginIps > 0 then
                local ipdatas = table.remove(loginIps)
                onConnection(ipdatas, onConnectionResult)
            else
                if callback ~= nil then
                    callback(false, 0)
                end
                print("获取ip出错")
            end
        else
            print("发起连接服务器太频繁 loginIps~=nil 上次发起的连接还没结束")
        end
    end
end

-- 请求更新游戏列表，游戏类型列表，游戏房间列表
function _M.onRequestAllServerList(kindIDList)
    local function sendRequestServerList()
        local rpcSend = GamePacketSendHelper.create(GameDefine.REFRESH_SOCKET, game.MDM_GP_SERVER_LIST, game.SUB_GP_GET_LIST, 2048)
        rpcSend:release()
    end
    onConnectionServer(sendRequestServerList)
end

function _M.onRequestServerListByKindID(kindID)
    local function sendRequestServerListByKindID()
        print("请求刷新玩家数量")
        local rpcSend = GamePacketSendHelper.create(GameDefine.REFRESH_SOCKET, game.MDM_GP_SERVER_LIST, game.SUB_GP_GET_SERVER, 2048)
        rpcSend:writeUInt16(kindID)
        rpcSend:release()
    end
    onConnectionServer(sendRequestServerListByKindID)
end

-- 查询用户金币，房卡，贡献点等数据
function _M.onSearchUserGold()
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.REFRESH_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_QUERY_INDIVIDUAL, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
        print("发送用户金币更新")
    end
    onConnectionServer(sendMessage)
end

-- 请求排行榜 --xcj 请求一般是金币排行，一次查询50条信息
function _M.onSearchRankInfo(rankType)
    if rankType == nil or (rankType > 3 or rankType < 1) then
        rankType = 3
    end

    local function sendQuestRank()
        local rpcSend = GamePacketSendHelper.create(GameDefine.REFRESH_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_USER_FAMILY_RANKING, 2048)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(rankType) -- 1、个人排行。2、家族排行 3、金币排行
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_MD5 * 2) -- 用户密码
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2) -- 机器序列
        rpcSend:release()
    end
    onConnectionServer(sendQuestRank, nil)
end

-- 请求游戏消息
function _M.onRequestGameMessage()
    -- 发送修改登录消息
    local function sendRequestGameMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.REFRESH_SOCKET, game.MDM_GP_SERVER_LIST, game.SUB_MB_GET_GAME_LOBBY_AD, 1024)
        rpcSend:release()
    end

    onConnectionServer(sendRequestGameMessage)
end

-- 数据解析
-- 解析房间数据
local function decoderGameServer(d)
    ServerListData.readGameServer(d)
end

-- 解析游戏列表数据
local function decoderGameListKind(d)
    ServerListData.readGameListKind(d)
end

-- 解析种类列表数据
local function decoderGameTypeListKind(d)
    ServerListData.readGameTypeListKind(d)
end

-- 游戏列表更新完成 isAll：是否全更新
local function decoderGameListFinish(isAll)
    print("收到房间刷新完毕")
    ServerListData.readGameServerFinish(isAll)
    game.sendEvent(GameDefine.RequestServerListFinish)
end

-- 发送查询用户金币，房卡，贡献点等返回数据
local function decoderUserInfoGoalMessage(data)
    local dwUserID = data:readUInt32()
    if (dwUserID == globalUserInfo.dwUserID) then
        globalUserInfo.lUserScore = data:readInt64()
        globalUserInfo.lFamilyExpTotal = data:readInt64()
        globalUserInfo.lFamilyExpUsed = data:readInt64()

        globalUserInfo.dwRoomCard = data:readUInt32() -- 用户房卡(A卡)
        globalUserInfo.dwRoomCard_reward = data:readUInt32() -- 奖励房卡(B卡)
        globalUserInfo.dwRoomCard_experience = data:readUInt32() -- 体验房卡

        globalUserInfo.szCompellation = data:readUString(GameDefine.LEN_COMPELLATION * 2) -- 资料中的真实名字
        globalUserInfo.szPassPortID = data:readUString(GameDefine.LEN_PASS_PORT_ID * 2) -- 资料中的个人真实身份证号
        globalUserInfo.szQQ = data:readUString(GameDefine.LEN_QQ * 2) -- 资料中的Q Q 号码 或者微信号
        globalUserInfo.szMobilePhone = data:readUString(GameDefine.LEN_MOBILE_PHONE * 2) -- 资料中的 移动电话
        globalUserInfo.szWeixin = data:readUString(GameDefine.LEN_WEIXIN * 2) -- 资料中的Q Q 号码 或者微信号
    end

    PlazaManager.isGameOutHall = false
    PlazaManager.closeRefreshSocket()
    game.sendEvent(GameDefine.UpdataUserGoalInfo)

    -- 获取游戏消息
    local currentTime = os.time()
    if PlazaManager.hallRefreshTime == nil or (PlazaManager.hallRefreshTime ~= nil and (currentTime - PlazaManager.hallRefreshTime) >= 30) then
        PlazaManager.hallRefreshTime = os.time()
        PlazaManager.getRefreshModule().onRequestGameMessage()
    end
end

local isReadRank = false
local rankType = 1 -- 排行榜类别    1、个人排行  2、家族排行.3、个人金币排行
local rankCount = 0
local function decoderRankBegin(decoder)
    rankType = decoder:readUInt16()
    isReadRank = true
    rankCount = 0
    PlazaManager.rankData[rankType] = {}
end

local function decoderRank(decoder)
    if isReadRank == false then
        return
    end

    local wCount = decoder:readUInt16() -- 多少条数据
    if rankType == 1 or rankType == 2 or rankType == 3 then
        local rankData = {}
        for i = 1, wCount do
            local userRankData = {}

            userRankData.dwGameID = decoder:readUInt32()
            userRankData.lScore = decoder:readInt64() -- 积分
            userRankData.szName = decoder:readUString(GameDefine.LEN_NICKNAME * 2) -- 昵称
            userRankData.szFaceAddr = decoder:readUString(GameDefine.LEN_HEADIMGURL * 2) -- 头像
            local szWeixin = decoder:readUString(GameDefine.LEN_WEIXIN * 2) -- 微信
            userRankData.szWeixin = GameUtil.filterMultMsg(szWeixin, 1)

            if userRankData.szWeixin and userRankData.dwGameID > 0 then
                rankCount = rankCount + 1
                userRankData.index = rankCount
                userRankData.wRankType = rankType
                table.insert(PlazaManager.rankData[rankType], userRankData)
            end

        end
    end
end

local function decoderRankEnd(decoder)
    isReadRank = false
    PlazaManager.closeRefreshSocket()
    game.sendEvent(GameDefine.RANK_DATA_FINISH, rankType)

    _M.onSearchUserGold()
end

-- 操作速度过快
local function decoderOperateFailer(decoder)
    local lResultCode = decoder:readInt32() -- 操作代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述信息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    print(szDescribeString)
end

local function decoderGameWelcome(data)
    local result = {}
    result.wWelcomeID = 0
    result.wContentType = 3
    result.rollTimes = 3
    result.msgState = 0

    result.szGUID = data:readUString(37 * 2)
    result.wSortID = data:readUInt16()
    result.wWelcomeName = LangCtrl:getLang().word245

    local timePublic = {}
    timePublic.wYear = data:readUInt16() -- 年
    timePublic.wMonth = data:readUInt16() -- 月
    timePublic.wDayOfWeek = data:readUInt16() -- 星期，0=星期日，1=星期一
    timePublic.wDay = data:readUInt16() -- 日
    timePublic.wHour = data:readUInt16() -- 时
    timePublic.wMinute = data:readUInt16() -- 分
    timePublic.wSecond = data:readUInt16() -- 秒
    timePublic.wMilliseconds = data:readUInt16() -- 毫秒

    local wContentType = data:readUInt16() -- 类型

    result.szContent = data:readUString(1024 * 2) -- 公告内容
    result.szContent = GameUtil.filterMultMsg(result.szContent, 1)

    if result.szContent then
        local newChk = true
        for i = 1, #PlazaManager.GameWelcomeList do
            if result.wContentType == 3 and PlazaManager.GameWelcomeList[i].szGUID ~= nil then
                if result.szGUID == PlazaManager.GameWelcomeList[i].szGUID then
                    newChk = false
                end
            end
        end

        if newChk == true then
            table.insert(PlazaManager.GameWelcomeList, result)
        end
    end
end

function _M.onInit()
end

function _M.accept(name, modId, cmdId)
    if name == GameDefine.REFRESH_SOCKET then
        if modId == game.MDM_GP_USER_SERVICE or modId == game.MDM_GP_SERVER_LIST then -- 用户命令
            return true
        end
    end
    return false
end

function _M.process(name, modId, cmdId, decoder)
    local isCloseNet = false

    if modId == game.MDM_GP_SERVER_LIST then -- 广场列表命令
        isCloseNet = _M.serverList_GP_CMD(cmdId, decoder)
    elseif modId == game.MDM_GP_USER_SERVICE then
        isCloseNet = _M.userServeive_GP_CMD(cmdId, decoder)
    end

    if isCloseNet == true then
        PlazaManager.closeRefreshSocket()
    end
end

-- 广场列表命令处理
function _M.serverList_GP_CMD(cmdId, decoder)
    local isCloseNet = false
    if cmdId == game.SUB_GP_LIST_SERVER then -- 房间数据
        decoderGameServer(decoder)
    elseif cmdId == game.SUB_GP_LIST_KIND then -- kind列表数据
        decoderGameListKind(decoder)
    elseif cmdId == game.SUB_GP_LIST_TYPE then -- 游戏种类列表数据
        decoderGameTypeListKind(decoder)
    elseif cmdId == game.SUB_GP_LIST_FINISH then -- 列表完成
        decoderGameListFinish(true)
        isCloseNet = true
    elseif cmdId == game.SUB_GP_SERVER_FINISH then -- 房间完成
        decoderGameListFinish(false)
        isCloseNet = true
    end

    return isCloseNet
end

function _M.userServeive_GP_CMD(cmdId, decoder)
    local isCloseNet = false

    if cmdId == game.SUB_GP_QUERY_INDIVIDUAL then -- 查询用户金币
        decoderUserInfoGoalMessage(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_FAMILY_RANKING_BEGIN then -- 排行榜开始
        decoderRankBegin(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_FAMILY_RANKING then -- 排行榜
        decoderRank(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_FAMILY_RANKING_END then -- 排行榜结束
        decoderRankEnd(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_OPERATE_SPEED_FAIL then -- 操作速度过快
        decoderOperateFailer(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_NOTICE_MESSAGE_START then -- 接受游戏获奖滚动消息开始
        -- 和公告一块不用了
        isCloseNet = false
    elseif cmdId == game.SUB_MB_NOTICE_MESSAG then -- 接受游戏获奖游戏消息
        decoderGameWelcome(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_NOTICE_MESSAGE_END then -- 接受游戏获奖游戏消息结束
        -- 和公告一块不用了
        isCloseNet = true
    end

    return isCloseNet
end

return _M
