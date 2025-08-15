local _M = {}

local GameUser = require("app.platform.common.GameUser")

-- 消息列表
local messageList = {}

-- 是否分发消息
local isDispatch = false

-- 分发消息中
local dispatch_ing = false

local loginSchedule = nil

-- 登录注册参数
local loginParams = {}

-- 登录ip列表
local loginIps = nil

function _M.clearLoginIPs()
    loginIps = nil
end

function _M.resetLoginParams()
    loginParams.account = "" -- 登录账号（微信登录则为uniID）
    loginParams.password = "" -- 登录密码
    loginParams.nickName = "" -- 昵称
    loginParams.sex = 1 -- 性别
    loginParams.headimgurl = "" -- 头像
    loginParams.phone = "" -- 手机号码
    loginParams.szVerifyCode = "" -- 手机验证码
    loginParams.openIDAccount = "" -- 微信openIDAccout(其他账号和account保持一致)
    loginParams.openIDPassword = "" -- 微信openIDPassword(其他账号和password保持一致)
    loginParams.accessToken = "" -- 微信Token
    loginParams.openID = ""
end

_M.resetLoginParams()

-- 查找的房间
local _strSearchRoomID = nil

-- 请求网络列表
local questList = {}
local sendQuesting = false

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
    args.ips = PlazaManager.replaceSpecialHost(args.ips)
    args.ips = PlazaManager.confineIPList(args.ips)
    PlazaManager.checkIPPortEqual(args.ips, args.ports)
    print("==============Login Module Start Connection===============")
    rPrint(args)
    print("==========================================================")
    if #args.ips == 0 then
        print("LOGIN_SOCKET ips is empty...")
        if callback ~= nil then
            callback(false)
        end
        return
    end

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
    game.connect(GameDefine.LOGIN_SOCKET, args.ips, {}, {}, args.ports, onConnResult, false, true, 20, 0)
end

-- 连接网络
local function onConnectionServer(processfun, callback)
    -- 0空闲 1连接中 2已连接
    local netState = game.getNetWorkState(GameDefine.LOGIN_SOCKET)
    print("netState == " .. netState)
    if netState == 1 then
        print(GameDefine.LOGIN_SOCKET .. LangCtrl:getLang().word231)
    elseif netState == 2 then
        print(GameDefine.LOGIN_SOCKET .. LangCtrl:getLang().word232)
        if callback ~= nil then
            callback(true)
        end
        processfun()
    elseif netState == 0 then
        print(GameDefine.LOGIN_SOCKET .. LangCtrl:getLang().word233)
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
                    questList = {} -- 清空请求队列
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
                                if type(loginIps) == "table" and #loginIps > 0 then
                                    local ipdatas = table.remove(loginIps)
                                    if ipdatas ~= nil and type(ipdatas) == "table" then
                                        onConnection(ipdatas, onConnectionResult)
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

-- 发送消息

-- 登录
function _M.onLogin(args, callback)
    if args.account == "" then
        PlazaManager.showTips(LangCtrl:getLang().word234)
        return
    end

    loginParams.account = args.account
    loginParams.password = args.password
    loginParams.openIDAccount = args.openIDAccount
    loginParams.openIDPassword = args.openIDPassword

    -- 微信注册时候用
    if args.nickName ~= nil then
        loginParams.nickName = GameUtil.subStringFromUTF8(args.nickName, 30, false)
    else
        loginParams.nickName = ""
    end

    if args.sex ~= nil then
        loginParams.sex = args.sex
    else
        loginParams.sex = 0
    end

    if args.headimgurl ~= nil then
        loginParams.headimgurl = args.headimgurl
    end

    loginParams.accessToken = ""
    loginParams.openID = ""
    loginParams.szVerifyCode = ""
    loginParams.phone = ""
    if args.accessToken then
        loginParams.accessToken = args.accessToken
    end
    if args.openID then
        loginParams.openID = args.openID
    end
    if args.szVerifyCode then
        loginParams.szVerifyCode = args.szVerifyCode
    end
    if args.phone then
        loginParams.phone = args.phone
    end

    -- CC验证码
    local str_md5 = string.format("%u", GameDefine.CCValidationKey)
    str_md5 = str_md5 .. loginParams.account
    GameDefine.CCValidation = game.md5(str_md5)

    -- 发送登录消息
    local function sendLoginPackage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_LOGON_ACCOUNTS, 2048)

        local sLoginFlags = game.md5_encrypt(loginParams.account, true)

        local deviceToken = ""

        local appVersion = ""
        local appInfo = PlazaManager.getPhoneInfo()

        local loginInfo = {}
        loginInfo.wModuleID = 1 -- 模块标识
        loginInfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        loginInfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        loginInfo.szPassword = loginParams.password -- 登录密码
        loginInfo.szAccounts = loginParams.account -- 登录帐号
        loginInfo.szMachineID = GameDefine.MachineID -- 机器标识
        loginInfo.szMobilePhone = loginParams.phone -- 电话号码
        loginInfo.szCCFlags = GameDefine.CCValidation -- CC验证
        loginInfo.szLoginFlags = sLoginFlags -- 登录验证
        loginInfo.szOpenIDAccount = loginParams.openIDAccount
        loginInfo.szOpenIDPassword = loginParams.openIDPassword
        loginInfo.szDeviceToken = deviceToken
        loginInfo.szAppVersion = appVersion
        loginInfo.szAppInfo = appInfo
        loginInfo.szVerifyCode = loginParams.szVerifyCode -- 验证码
        loginInfo.accessToken = loginParams.accessToken -- 微信token
        loginInfo.openID = loginParams.openID -- 微信openid

        rpcSend:writeUString(loginInfo.szAppVersion, 66)
        rpcSend:writeUInt16(loginInfo.wModuleID)
        rpcSend:writeUInt32(loginInfo.dwPlazaVersion)
        rpcSend:writeUInt8(loginInfo.cbDeviceType)
        rpcSend:writeUString(loginInfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(loginInfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(loginInfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(loginInfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szLoginFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szOpenIDPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szOpenIDAccount, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(loginInfo.szDeviceToken, 128 * 2)
        rpcSend:writeUString(loginInfo.szAppInfo, 64 * 2)
        rpcSend:writeUString(loginInfo.szVerifyCode, 7 * 2)
        rpcSend:writeUString(loginInfo.accessToken, 126 * 2)

        if GameDefine.playerHostIPStr then
            local tbl_ip = string.split(GameDefine.playerHostIPStr, ".")
            print("----------playerHostIPStr---------", GameDefine.playerHostIPStr)
            rPrint(tbl_ip)
            print("-------------------------")
            for idx, num in ipairs(tbl_ip) do
                print("----tonumber(num)--", tonumber(num))
                rpcSend:writeUInt8(tonumber(num))
                if idx == 4 then
                    break
                end
            end
        else
            print("----------playerHostIPStr not found---------")
            rpcSend:writeUInt32(0)
        end

        rpcSend:writeUString(loginInfo.openID, 32 * 2)
        rpcSend:release()
        print("发送登录消息")
    end

    local function do_get_my_host_ip()
        onConnectionServer(sendLoginPackage, callback)
    end
    PlazaManager.accessPlayerIP(do_get_my_host_ip)
end

function _M.onLoginByPhoneVerifyCode(szMobilePhone, szVerifyCode, callback)
    local args = clone(loginParams)
    args.phone = szMobilePhone
    args.szVerifyCode = szVerifyCode

    _M.onLogin(args, callback)
end

-- 注册
function _M.onRegistered(args, callback)
    -- 注册参数
    loginParams.account = args.account
    loginParams.password = args.password

    loginParams.headimgurl = args.headimgurl
    loginParams.sex = args.sex

    loginParams.accessToken = ""
    loginParams.openID = ""
    if args.accessToken then
        loginParams.accessToken = args.accessToken
    end
    if args.openID then
        loginParams.openID = args.openID
    end

    local name = GameUtil.subStringFromUTF8(args.nickName, 30, false)
    loginParams.nickName = name

    -- 电话号码
    if args.phone ~= nil then
        loginParams.phone = args.phone
    else
        loginParams.phone = "phone"
    end
    -- 手机验证码
    if args.szVerifyCode ~= nil then
        loginParams.szVerifyCode = args.szVerifyCode
    else
        loginParams.szVerifyCode = ""
    end
    if string.len(loginParams.szVerifyCode) > 6 then
        loginParams.szVerifyCode = string.sub(loginParams.szVerifyCode, 1, 6)
    end

    local str_md5 = string.format("%u", GameDefine.CCValidationKey)
    str_md5 = str_md5 .. loginParams.account
    GameDefine.CCValidation = game.md5(str_md5)

    -- 发送注册消息
    local function sendRegisteredPackage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_REGISTER_ACCOUNTS, 4096)

        local sLoginFlags = game.md5_encrypt(loginParams.account, true)

        local deviceToken = "" -- 推送Token
        -- if PlazaManager.isPhoneAndPadPlatform() == true then
        --    deviceToken = game.getPushRegistrationId()
        -- end

        local appVersion = "" -- App版本
        local appMarket = game.getPlatformMarket() -- 获取渠道
        local appInfo = PlazaManager.getPhoneInfo() -- 手机信息

        local registerinfo = {}
        -- 系统信息
        registerinfo.szAppVersion = appVersion -- App版本
        registerinfo.wModuleID = 1 -- 模块标识
        registerinfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        registerinfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型

        -- 注册信息
        registerinfo.wFaceID = 1 -- 头像标识
        registerinfo.cbGender = loginParams.sex -- 用户性别
        registerinfo.szAccounts = loginParams.account -- 登录帐号
        registerinfo.szNickName = loginParams.nickName -- 用户昵称

        -- 密码变量
        registerinfo.szLogonPass = loginParams.password -- 登录密码
        registerinfo.szInsurePass = game.md5("000000") -- 银行密码初始设置为"000000"

        -- 连接信息
        registerinfo.szMachineID = GameDefine.MachineID -- 机器标识
        registerinfo.szPassPortID = "" -- 证件号码
        registerinfo.szMobilePhone = loginParams.phone -- 电话号码
        registerinfo.szQQ = "qq" -- QQ号码
        registerinfo.szCCFlags = GameDefine.CCValidation -- CC验证
        registerinfo.headimgurl = loginParams.headimgurl -- 头像地址
        registerinfo.szLoginFlags = sLoginFlags -- 登录验证

        registerinfo.cbLoginType = PlazaManager.loginType -- 注册类型：0：游客类型 1：微信类型，2：账号类型 3：QQ类型 4：手机类型
        registerinfo.szDeviceToken = deviceToken -- 推送Token

        registerinfo.appMarket = appMarket -- 渠道
        registerinfo.szAppInfo = appInfo -- 手机信息

        registerinfo.szSMSVerifyCode = loginParams.szVerifyCode -- 短信验证码
        registerinfo.accessToken = loginParams.accessToken -- 微信token
        registerinfo.openID = loginParams.openID -- 微信openid

        print("registerinfo.accessToken == " .. registerinfo.accessToken)
        print("registerinfo.openID == " .. registerinfo.openID)

        rpcSend:writeUString(registerinfo.szAppVersion, 66)
        rpcSend:writeUInt16(registerinfo.wModuleID)
        rpcSend:writeUInt32(registerinfo.dwPlazaVersion)
        rpcSend:writeUInt8(registerinfo.cbDeviceType)
        rpcSend:writeUString(registerinfo.szLogonPass, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(registerinfo.szInsurePass, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt16(registerinfo.wFaceID)
        rpcSend:writeUInt8(registerinfo.cbGender)
        rpcSend:writeUString(registerinfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(registerinfo.szNickName, GameDefine.LEN_NICKNAME * 2)
        rpcSend:writeUString(registerinfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(registerinfo.szPassPortID, GameDefine.LEN_PASS_PORT_ID * 2)
        rpcSend:writeUString(registerinfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(registerinfo.szQQ, GameDefine.LEN_QQ * 2)
        rpcSend:writeUString(registerinfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(registerinfo.headimgurl, GameDefine.LEN_HEADIMGURL * 2)
        rpcSend:writeUString(registerinfo.szLoginFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt8(registerinfo.cbLoginType)
        rpcSend:writeUString(registerinfo.szDeviceToken, 128 * 2)
        rpcSend:writeUInt32(registerinfo.appMarket)
        rpcSend:writeUString(registerinfo.szAppInfo, 64 * 2)
        rpcSend:writeUString(registerinfo.szSMSVerifyCode, 7 * 2)
        rpcSend:writeUString(registerinfo.accessToken, 126 * 2)

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

        rpcSend:writeUString(registerinfo.openID, 32 * 2)
        rpcSend:release()
        -- printLog("LoginModule","发送注册信息 registerinfo.szAccounts"..registerinfo.szAccounts.."  registerinfo.szLogonPass="..registerinfo.szLogonPass.."registerinfo.szMachineID ="..GameDefine.MachineID)
    end

    local function do_get_my_host_ip()
        onConnectionServer(sendRegisteredPackage, callback)
    end
    PlazaManager.accessPlayerIP(do_get_my_host_ip)
end

-- 请求领取救济金
function _M.onGiveAlms()
    -- 发送登录消息
    local function sendLoginPackage()
        print("发送领取救济金")
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_GIVE_ALMS, 1024)

        local loginInfo = {}
        loginInfo.wModuleID = 1 -- 模块标识
        loginInfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        loginInfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        loginInfo.szPassword = globalUserInfo.szPassword -- 登录密码
        loginInfo.szAccounts = globalUserInfo.szAccounts -- 登录帐号
        loginInfo.szMachineID = GameDefine.MachineID -- 机器标识
        loginInfo.szMobilePhone = globalUserInfo.szMobilePhone -- 电话号码
        loginInfo.szCCFlags = GameDefine.CCValidation -- CC验证
        loginInfo.szLoginFlags = game.md5_encrypt(globalUserInfo.szAccounts, true) -- 登录验证
        loginInfo.cbOption = 1 -- 请求类型0：仅查询，1：请求发放救济金

        rpcSend:writeUInt16(loginInfo.wModuleID)
        rpcSend:writeUInt32(loginInfo.dwPlazaVersion)
        rpcSend:writeUInt8(loginInfo.cbDeviceType)
        rpcSend:writeUString(loginInfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(loginInfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(loginInfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(loginInfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(loginInfo.szLoginFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt8(loginInfo.cbOption)
        rpcSend:release()
    end
    onConnectionServer(sendLoginPackage, nil)
end

-- 查找是否能创建房间
local cbIsTvGame = false
function _M.onCheckIsCreateRoom(data)
    if data.cbIsTvGame == nil or data.cbIsTvGame == 0 then
        cbIsTvGame = false
    else
        cbIsTvGame = true
    end
    local function checkIsCreateRoom()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_PERSONAL_SERVICE, game.SUB_MB_QUERY_GAME_SERVER, 2048)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt32(data.dwKindID)
        -- 游戏I D
        rpcSend:writeUInt8(data.cbIsJoinGame)
        -- 是否参与游戏 1:创建自己的房间 0：给别人创建房间
        rpcSend:release()
    end
    onConnectionServer(checkIsCreateRoom)
end

-- 搜索游戏房间
function _M.onSearchGameServer(strRoomNumber, callback)
    _strSearchRoomID = strRoomNumber
    local function sendSearchGameServer()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_PERSONAL_SERVICE, game.SUB_MB_SEARCH_SERVER_TABLE, 2048)
        rpcSend:writeUString(strRoomNumber, 7 * 2)
        rpcSend:writeUInt32(0) -- 0为查约战房，非0为查金币房
        rpcSend:release()
    end
    onConnectionServer(sendSearchGameServer, callback)
end

-- 检查是否在游戏中
local function checkInGameServer()
    -- 掉线查询
    local function sendCheckIsGameServer()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_QUERY_INGAME_SEVERID, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:release()
    end
    onConnectionServer(sendCheckIsGameServer)
end

-- 查询家族
function _M.onSearchFamilyList()
    -- 查询家族
    local function sendSearchFamilyList()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_LOGON, game.SUB_MB_LOAD_FAMILY_LIST, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUString(globalUserInfo.szPassword, 33 * 2)
        rpcSend:writeUString(GameDefine.MachineID, 33 * 2)
        rpcSend:release()
    end
    onConnectionServer(sendSearchFamilyList)
end

-- 点亮家族
function _M.onLitFamily(familyid)
    -- 点亮家族
    local function sendLitFamilyList()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_LOGON, game.SUB_MB_SELECT_FAMILY, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUString(globalUserInfo.szPassword, 33 * 2)
        rpcSend:writeUInt32(familyid)
        rpcSend:writeUString(GameDefine.MachineID, 33 * 2)
        rpcSend:release()
    end
    onConnectionServer(sendLitFamilyList)
end

-- 发送银行登录消息
-- data={passType=1,passStr= mdPassStr}
function _M.onLoginBank(data, callback)
    local function loginBank()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_INSURE_LOGON, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(GameDefine.CCValidation, GameDefine.LEN_MD5 * 2)
        rpcSend:release()
    end
    onConnectionServer(loginBank, callback)
end

-- 查询银行信息
function _M.onSearchBankInfo(data, callback)
    local function searchBankInfo()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_QUERY_INSURE_INFO, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(searchBankInfo, callback)
end

-- 发送存款消息
function _M.onStoreGold(data, callback)
    local function storeGold()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_SAVE_SCORE, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(1) -- 0:积分 1：金币
        rpcSend:writeUInt64(data.saveScore)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(storeGold, callback)
end

-- 发送取款消息
function _M.onTakeScore(data, callback)
    local function takeScore()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_TAKE_SCORE, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt64(data.takeScore)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(takeScore, callback)
end

-- 赠送房卡金币根据赠送ID查询用户信息
function _M.onSendSeachGiveUserInfo(data, callback)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_QUERY_USER_BASIC, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwGameID)
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUInt32(data.GiveUserID)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage, callback)
end

-- 发送赠送金币消息
-- data={lTransferScore=1,passType= "",passStr="",gameID=""}
function _M.onSendGiveGoal(data, callback)
    local function sendGiveGoal()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_TRANSFER_SCORE, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt8(0)
        rpcSend:writeUInt64(data.lTransferScore)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(data.gameID, GameDefine.LEN_NICKNAME * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendGiveGoal, callback)
end

-- 发送请求银行赠送金币记录
-- data={passType="",passStr=""}
function _M.onRequestGiveGoalRecord(data, callback)
    local function requestGiveGoalRecord()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_TRANSFER_RECORD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUInt8(0) -- cbALL

        local timetable = os.date("*t", os.time())
        local dtTime = {}
        dtTime.wYear = timetable.year -- 年
        dtTime.wMonth = timetable.month -- 月
        dtTime.wDayOfWeek = timetable.wday -- 星期，0=星期日，1=星期一
        dtTime.wDay = timetable.day -- 日
        dtTime.wHour = timetable.hour -- 时
        dtTime.wMinute = timetable.min -- 分
        dtTime.wSecond = timetable.sec -- 秒
        dtTime.wMilliseconds = 0 -- 毫秒

        rpcSend:writeUInt16(dtTime.wYear)
        rpcSend:writeUInt16(dtTime.wMonth)
        rpcSend:writeUInt16(dtTime.wDayOfWeek)
        rpcSend:writeUInt16(dtTime.wDay)
        rpcSend:writeUInt16(dtTime.wHour)
        rpcSend:writeUInt16(dtTime.wMinute)
        rpcSend:writeUInt16(dtTime.wSecond)
        rpcSend:writeUInt16(dtTime.wMilliseconds)

        rpcSend:writeUInt32(0) -- 记录ID

        rpcSend:release()
    end
    onConnectionServer(requestGiveGoalRecord, callback)
end

-- 查询玩家流水
function _M.onRequestMoneyBack(data, callback)
    local function sendRequestMoneyBack()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_QUERY_USER_RUNNINGACCOUNT, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendRequestMoneyBack, callback)
end

-- 提取玩家流水
function _M.onTakeMoneyBack(data, callback)
    local function sendTakeMoneyBack()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_TAKE_RUNNINGACCOUNT, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendTakeMoneyBack, callback)
end

-- 发送修改设置密码消息
-- data={passType,newPassStr,oldPassStr}
function _M.onSendModiPassMessage(data, callback)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_MODIFY_INSURE_PASS_NEW, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.oldType, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(data.oldPassStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.newPassStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage, callback)
end

-- 发送卡号充值消息
function _M.onSendRechargeMessage(data, callback)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_USELIVECARD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID) -- DWORD 操作员的用户ID
        rpcSend:writeUString(data.szLiveCard, 66) -- TCHAR 33 * 2  卡号12~32长度
        rpcSend:writeUString(data.szPassword, 66) -- TCHAR 33 密码做MD5算法 32长度
        rpcSend:writeUInt32(globalUserInfo.dwGameID) -- DWORD卡号充值的GAMEID(手机端用户只能充值自己的GAMEID,PC端充值可以指定为他人

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
            rpcSend:writeUInt32(0) -- DWORD客户端上传 用户的公网IP
        end

        rpcSend:release()
    end

    local function do_get_my_host_ip()
        onConnectionServer(sendMessage, callback)
    end
    PlazaManager.accessPlayerIP(do_get_my_host_ip)
end

-- 发送验证密码消息
function _M.onSendVerifyPassword(data)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_VERIFY_PASSWORD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.passType)
        rpcSend:writeUString(data.passwordstr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(data.passwordstr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage)
end
-- 发送转换密码消息
function _M.onSendPassTypeChange(data)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_SWITCH_PASSWORD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(PlazaManager.BankPassType)
        rpcSend:writeUString(PlazaManager.BankPassStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage)
end
-- 赠送房卡消息
function _M.onSendGiveRoomCrad(data)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_GIVE_USER_ROOMCARD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwGameID)
        rpcSend:writeUString(PlazaManager.BankPassStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUInt32(data.GiveUserID)
        rpcSend:writeUInt16(data.RoomCardType)
        rpcSend:writeUInt32(data.GiveCardNum)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage)
end
-- 银行家族贡献值兑换房卡或者金币
function _M.onSendExchangeFamilyExp(data)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_EXCHANGE_ROOMCARD, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt16(data.ExchangeType)
        rpcSend:writeUInt64(data.ExchangeNum)
        rpcSend:writeUInt16(PlazaManager.BankPassType)
        rpcSend:writeUString(PlazaManager.BankPassStr, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage)
end

-- 查询用户金币，房卡，贡献点等数据
function _M.onSearchUserGold(callback)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_QUERY_INDIVIDUAL, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage, callback)
end

-- 发送金币兑换房卡的功能
function _M.onSendSeachBuyGoodeMessage(data)
    local function sendMessage()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_GP_USER_GOLD_TRANSFER, 1024)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt64(data.SalePrice)
        rpcSend:writeUInt16(1) -- 1=金币  2=房卡
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendMessage)
end

function _M.onBindWeiXin(args, callback)
    local function onsendBindWeiXin()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_BINDWX, 2048)

        local sLoginFlags = game.md5_encrypt(globalUserInfo.szAccounts, true)

        local bindWXinfo = {}
        bindWXinfo.wModuleID = 1 -- 模块标识
        bindWXinfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        bindWXinfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        bindWXinfo.szPassword = globalUserInfo.szPassword -- 登录密码
        bindWXinfo.szAccounts = globalUserInfo.szAccounts -- 登录账号
        bindWXinfo.szMachineID = GameDefine.MachineID -- 机器标识
        bindWXinfo.szMobilePhone = "phone" -- 电话号码
        bindWXinfo.szCCFlags = GameDefine.CCValidation -- CC验证
        bindWXinfo.szLoginFlags = sLoginFlags -- 登录验证
        bindWXinfo.szWXAccounts = args.account -- 绑定的微信登录帐号
        bindWXinfo.zWXPassword = args.password -- 绑定的微信登录密码
        bindWXinfo.bUpdateUserInfo = 1 -- 绑定成功后是否更新用户的信息
        bindWXinfo.cbGender = args.sex -- 性别
        bindWXinfo.szNickName = args.nickName -- 用户昵称
        bindWXinfo.szFaceAddr = args.headimgurl -- 头像地址

        rpcSend:writeUInt16(bindWXinfo.wModuleID)
        rpcSend:writeUInt32(bindWXinfo.dwPlazaVersion)
        rpcSend:writeUInt8(bindWXinfo.cbDeviceType)
        rpcSend:writeUString(bindWXinfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindWXinfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(bindWXinfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(bindWXinfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(bindWXinfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindWXinfo.szLoginFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindWXinfo.szWXAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(bindWXinfo.zWXPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt8(bindWXinfo.bUpdateUserInfo)
        rpcSend:writeUInt8(bindWXinfo.cbGender)
        rpcSend:writeUString(bindWXinfo.szNickName, GameDefine.LEN_NICKNAME * 2)
        rpcSend:writeUString(bindWXinfo.szFaceAddr, GameDefine.LEN_HEADIMGURL * 2)
        rpcSend:release()
    end
    onConnectionServer(onsendBindWeiXin, callback)
end

-- 请求战绩
function _M.onRequestBattle(gameType, recordMaxCount, callback)
    local function sendQuestBattle()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_USER_SCORE_RECORD, 2048)

        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt32(gameType) -- 房卡（0）或金币模式（1）

        local count = 0
        if recordMaxCount == nil then
            count = 20
        else
            if recordMaxCount > 50 or recordMaxCount == -1 then
                count = 50
            end
        end
        rpcSend:writeUInt32(count) -- 最大条数,-1代表全部

        -- print("发送请求战绩消息  globalUserInfo.dwUserID == "..globalUserInfo.dwUserID.."  gameType == "..gameType .."  count == "..count )
        rpcSend:release()
    end
    onConnectionServer(sendQuestBattle, callback)
end

-- 请求战绩详细信息
function _M.onRequestBattleInfo(szRoomID, callback)
    local function sendQuestBattleInfo()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_USER_SCORE_DETAIL, 2048)
        rpcSend:writeUString(szRoomID, 64)
        rpcSend:release()
    end
    onConnectionServer(sendQuestBattleInfo, callback)
end

-- 修改信息  修改类型(1、昵称。2、头像，3.真实姓名,4.身份证号码，5.QQ号，6.用于显示的手机号)
function _M.onModifyIndividual(wModifyType, szContent, callback)
    local function sendModifyIndividual()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_MODIFY_INDIVIDUAL, 2048)

        local sLoginFlags = game.md5_encrypt(loginParams.account, true)

        local hallVersion = PlazaManager.getHallVersion()
        local devideType = PlazaManager.getDeviceType()

        rpcSend:writeUInt16(1) -- 模块标识
        rpcSend:writeUInt32(hallVersion) -- 广场版本
        rpcSend:writeUInt8(devideType) -- 设备类型
        rpcSend:writeUString(globalUserInfo.szPassword, GameDefine.LEN_MD5 * 2) -- 登录密码
        rpcSend:writeUString(globalUserInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2) -- 登录帐号

        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2) -- 机器标识
        rpcSend:writeUString("phone", GameDefine.LEN_MOBILE_PHONE * 2) -- 电话号码
        rpcSend:writeUString(GameDefine.CCValidation, GameDefine.LEN_MD5 * 2) -- CC验证
        rpcSend:writeUString(sLoginFlags, GameDefine.LEN_MD5 * 2) -- 登录验证

        rpcSend:writeUInt16(wModifyType) -- 修改类型(1、昵称。2、头像，3.真实姓名,4.身份证号码，5.QQ号，6.用于显示的手机号)
        rpcSend:writeUString(szContent, 256 * 2)

        rpcSend:release()
    end
    onConnectionServer(sendModifyIndividual, callback)
end

-- 发送分享成功 cbOption    0：仅查询，1：请求赠送房卡
function _M.onRequestShareInfo(cbOption)
    local function sendShare()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_SHAREFRIENDS, 2048)

        local sLoginFlags = game.md5_encrypt(globalUserInfo.szAccounts, true)

        local bindWXinfo = {}
        bindWXinfo.wModuleID = 1 -- 模块标识
        bindWXinfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        bindWXinfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        bindWXinfo.szPassword = globalUserInfo.szPassword -- 登录密码
        bindWXinfo.szAccounts = globalUserInfo.szAccounts -- 登录账号
        bindWXinfo.szMachineID = GameDefine.MachineID -- 机器标识
        bindWXinfo.szMobilePhone = "phone" -- 电话号码
        bindWXinfo.szCCFlags = GameDefine.CCValidation -- CC验证
        bindWXinfo.szLoginFlags = sLoginFlags -- 登录验证
        bindWXinfo.cbOption = cbOption -- 请求类型

        rpcSend:writeUInt16(bindWXinfo.wModuleID)
        rpcSend:writeUInt32(bindWXinfo.dwPlazaVersion)
        rpcSend:writeUInt8(bindWXinfo.cbDeviceType)
        rpcSend:writeUString(bindWXinfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindWXinfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(bindWXinfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(bindWXinfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(bindWXinfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindWXinfo.szLoginFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt8(bindWXinfo.cbOption)
        rpcSend:release()
    end
    onConnectionServer(sendShare)
end

-- 请求更新游戏列表，游戏类型列表，游戏房间列表
function _M.onRequestServerList(kindIDList)
    local function sendRequestServerList()
        if kindIDList == nil or #kindIDList == 0 then
            local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_SERVER_LIST, game.SUB_GP_GET_LIST, 2048)
            rpcSend:release()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_SERVER_LIST, game.SUB_GP_GET_SERVER, 2048)
            for i = 1, #kindIDList do
                rpcSend:writeUInt16(kindIDList[i])
            end
            rpcSend:release()
        end
    end
    onConnectionServer(sendRequestServerList)
end
-- 请求自己创建的私人房房间列表
function _M.onSendPrivateRoomListMessage(data)
    local function sendPrivateRoomList()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_PERSONAL_SERVICE, game.SUB_MB_QUERY_PERSONAL_ROOM_LIST, 2048)
        rpcSend:writeUInt32(globalUserInfo.dwUserID)
        rpcSend:writeUInt32(data.familyID) -- 家族id为0表示查询的是个人的，不为0代表的是查询的是该家族的
        rpcSend:release()
    end
    onConnectionServer(sendPrivateRoomList)
end

-- 请求验证码
function _M.onRequestVerificationCode(phoneCode, callback)
    local function sendRequestVerificationCode()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_SEND_SMS, 2048)
        rpcSend:writeUString(phoneCode, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(GameDefine.MachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:release()
    end
    onConnectionServer(sendRequestVerificationCode, callback)
end

-- 请求录像信息
function _M.onRequestRecordInfo(args, callback)
    if args == nil or args.szRoomID == nil or args.recordIndex == nil then
        PlazaManager.showTips("查询录像回放错误")
        return
    end

    local function sendRequestRecoed()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_GAME_RECORD, 2048)
        rpcSend:writeUString(args.szRoomID, GameDefine.LEN_SERVER * 2)
        rpcSend:writeUInt32(args.recordIndex)
        -- print("请求查询录像信息 args.szRoomID == "..args.szRoomID.."  args.recordIndex == "..args.recordIndex)
        rpcSend:release()
    end

    onConnectionServer(sendRequestRecoed, callback)
end

-- 请求绑定手机号
-- data={szPassword="",szAccounts="",szMobilePhone="",szVerifyCode=""}
function _M.onBindPhone(data, callback)
    -- 发送绑定手机号消息
    local function sendBindPhoneMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_BIND_PHONE, 1024)

        local bindInfo = {}
        -- 系统信息
        bindInfo.wModuleID = 1 -- 模块标识
        bindInfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        bindInfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        -- 登录信息
        bindInfo.szPassword = data.szPassword -- 登录密码
        bindInfo.szAccounts = data.szAccounts -- 登录帐号

        -- 连接信息
        bindInfo.szMachineID = GameDefine.MachineID -- 机器标识
        bindInfo.szMobilePhone = data.szMobilePhone -- 电话号码
        bindInfo.szCCFlags = GameDefine.CCValidation -- CC验证
        bindInfo.szLoginFlags = game.md5_encrypt(bindInfo.szAccounts, true) -- 登录验证

        bindInfo.szVerifyCode = data.szVerifyCode -- 短信验证码

        rpcSend:writeUInt16(bindInfo.wModuleID)
        rpcSend:writeUInt32(bindInfo.dwPlazaVersion)
        rpcSend:writeUInt8(bindInfo.cbDeviceType)

        rpcSend:writeUString(bindInfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)

        rpcSend:writeUString(bindInfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(bindInfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(bindInfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szLoginFlags, GameDefine.LEN_MD5 * 2)

        rpcSend:writeUString(bindInfo.szVerifyCode, 7 * 2)
        rpcSend:writeUString("", GameDefine.LEN_MD5 * 2) -- 密码
        rpcSend:release()
    end

    onConnectionServer(sendBindPhoneMsg, callback)
end

-- 请求解除绑定手机号
-- data={szPassword="",szAccounts="",szMobilePhone="",szVerifyCode=""}
function _M.onCancelBindPhone(data, callback)
    -- 发送解除绑定手机号消息
    local function sendCancelBindPhoneMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_UNBIND_PHONE, 1024)

        local bindInfo = {}
        -- 系统信息
        bindInfo.wModuleID = 1 -- 模块标识
        bindInfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        bindInfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        -- 登录信息
        bindInfo.szPassword = data.szPassword -- 登录密码
        bindInfo.szAccounts = data.szAccounts -- 登录帐号

        -- 连接信息
        bindInfo.szMachineID = GameDefine.MachineID -- 机器标识
        bindInfo.szMobilePhone = data.szMobilePhone -- 电话号码
        bindInfo.szCCFlags = GameDefine.CCValidation -- CC验证
        bindInfo.szLoginFlags = game.md5_encrypt(bindInfo.szAccounts, true) -- 登录验证

        bindInfo.szVerifyCode = data.szVerifyCode -- 短信验证码

        rpcSend:writeUInt16(bindInfo.wModuleID)
        rpcSend:writeUInt32(bindInfo.dwPlazaVersion)
        rpcSend:writeUInt8(bindInfo.cbDeviceType)

        rpcSend:writeUString(bindInfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)

        rpcSend:writeUString(bindInfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(bindInfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(bindInfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szLoginFlags, GameDefine.LEN_MD5 * 2)

        rpcSend:writeUString(bindInfo.szVerifyCode, 7 * 2)
        rpcSend:release()
    end

    onConnectionServer(sendCancelBindPhoneMsg, callback)
end

-- 查询账号绑定的手机号码是否匹配
function _M.onCheckBindPhoneAndAccoount(data, callback)
    -- 发送绑定手机号消息
    local function sendCheckBindPhoneMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_QUERY_BIND_PHONE, 1024)
        rpcSend:writeUString(data.szAccounts, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(data.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:release()
    end

    onConnectionServer(sendCheckBindPhoneMsg, callback)
end

-- 修改登录密码
function _M.onModifyLogonPassword(data, callback)
    -- 发送修改登录消息
    local function sendModifyLogonPassMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_USER_SERVICE, game.SUB_MB_MODIFY_LOGON_PASS_PHONE, 1024)
        rpcSend:writeUString(data.szAccount, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(data.szNewPassWord, GameDefine.LEN_PASSWORD * 2)
        rpcSend:writeUString(data.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(data.szVerifyCode, 7 * 2)
        rpcSend:release()
    end

    onConnectionServer(sendModifyLogonPassMsg, callback)
end

-- 检测注册账号
function _M.onCheckAccounts(szAccount, callback)
    -- 发送检测注册账号
    local function sendCheckAccountsMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_LOGON, game.SUB_GP_CHECK_ACCOUNTS, 1024)
        rpcSend:writeUString(szAccount, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:release()
    end

    onConnectionServer(sendCheckAccountsMsg, callback)
end

-- 检测注册昵称
function _M.onCheckNiceName(szNiceName, callback)
    -- 发送修改登录消息
    local function sendCheckNiceNameMsg()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_GP_LOGON, game.SUB_GP_CHECK_NICKNAME, 1024)
        rpcSend:writeUString(szNiceName, GameDefine.LEN_NICKNAME * 2)
        rpcSend:release()
    end

    onConnectionServer(sendCheckNiceNameMsg, callback)
end

-- 发送绑定账户
function _M.onBindAccount(args, callback)

    local function sendBindAccount()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_BIND_ACCOUNT, 1024)

        local bindInfo = {}
        -- 系统信息
        bindInfo.wModuleID = 1 -- 模块标识   
        bindInfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本  
        bindInfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        -- 登录信息
        bindInfo.szPassword = globalUserInfo.szPassword -- 登录密码
        bindInfo.szAccounts = globalUserInfo.szAccounts -- 登录帐号

        -- 连接信息
        bindInfo.szMachineID = GameDefine.MachineID -- 机器标识  
        bindInfo.szMobilePhone = args.szMobilePhone -- 电话号码
        bindInfo.szCCFlags = GameDefine.CCValidation -- CC验证
        bindInfo.szLoginFlags = game.md5_encrypt(bindInfo.szAccounts, true) -- 登录验证

        bindInfo.bindAccount = args.account -- 绑定账户
        bindInfo.bindPassword = game.md5(args.password) -- 绑定账户
        bindInfo.szVerifyCode = args.szVerifyCode -- 绑定账户

        print("bindInfo.szVerifyCode == " .. bindInfo.szVerifyCode .. "         args.szVerifyCode == " .. args.szVerifyCode)

        rpcSend:writeUInt16(bindInfo.wModuleID)
        rpcSend:writeUInt32(bindInfo.dwPlazaVersion)
        rpcSend:writeUInt8(bindInfo.cbDeviceType)

        rpcSend:writeUString(bindInfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)

        rpcSend:writeUString(bindInfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(bindInfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(bindInfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szLoginFlags, GameDefine.LEN_MD5 * 2)

        rpcSend:writeUString(bindInfo.bindAccount, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(bindInfo.bindPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(bindInfo.szVerifyCode, 14)

        rpcSend:release()
        print("发送绑定账户中")
    end
    onConnectionServer(sendBindAccount, callback)
end

-- 查询账号迁移
function _M.onCheckDataImport(args, callback)
    local function sendCheckDataImport()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_QUERY_REMOVE_ACCOUNT, 1024)
        local datainfo = {}

        -- 系统信息
        datainfo.wModuleID = 1 -- 模块标识
        datainfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        datainfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        -- 登录信息
        datainfo.szPassword = globalUserInfo.szPassword -- 登录密码
        datainfo.szAccounts = globalUserInfo.szAccounts -- 登录帐号

        -- 连接信息
        datainfo.szMachineID = GameDefine.MachineID -- 机器标识
        datainfo.szMobilePhone = args.szMobilePhone -- 电话号码
        datainfo.szCCFlags = GameDefine.CCValidation -- CC验证
        datainfo.szLoginFlags = game.md5_encrypt(datainfo.szAccounts, true) -- 登录验证

        rpcSend:writeUInt16(datainfo.wModuleID)
        rpcSend:writeUInt32(datainfo.dwPlazaVersion)
        rpcSend:writeUInt8(datainfo.cbDeviceType)

        rpcSend:writeUString(datainfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(datainfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)

        rpcSend:writeUString(datainfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(datainfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(datainfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(datainfo.szLoginFlags, GameDefine.LEN_MD5 * 2)

        rpcSend:release()
        print("发送查询账号迁移")
    end
    onConnectionServer(sendCheckDataImport, callback)
end

-- 账号迁移
function _M.onDataImport(args, callback)
    local function sendDataImport()
        local rpcSend = GamePacketSendHelper.create(GameDefine.LOGIN_SOCKET, game.MDM_MB_LOGON, game.SUB_MB_REMOVE_ACCOUNT, 1024)

        local datainfo = {}

        -- 系统信息
        datainfo.wModuleID = 1 -- 模块标识
        datainfo.dwPlazaVersion = PlazaManager.getHallVersion() -- 广场版本
        datainfo.cbDeviceType = PlazaManager.getDeviceType() -- 设备类型
        -- 登录信息
        datainfo.szPassword = globalUserInfo.szPassword -- 登录密码
        datainfo.szAccounts = globalUserInfo.szAccounts -- 登录帐号

        -- 连接信息
        datainfo.szMachineID = GameDefine.MachineID -- 机器标识
        datainfo.szMobilePhone = "" -- 电话号码
        datainfo.szCCFlags = GameDefine.CCValidation -- CC验证
        datainfo.szLoginFlags = game.md5_encrypt(datainfo.szAccounts, true) -- 登录验证

        -- 老登录信息
        datainfo.szPasswordOld = args.password -- 登录密码
        datainfo.szAccountsOld = args.account -- 登录帐号

        -- 老连接信息
        datainfo.szMachineIDOld = args.szMachineID -- 机器标识
        datainfo.szMobilePhoneOld = args.szMobilePhone -- 电话号码
        datainfo.szCCFlagsOld = args.szCCFlags -- CC验证
        datainfo.szLoginFlagsOld = args.szLoginFlags -- 登录验证
        datainfo.cbOption = args.cbOption

        rpcSend:writeUInt16(datainfo.wModuleID)
        rpcSend:writeUInt32(datainfo.dwPlazaVersion)
        rpcSend:writeUInt8(datainfo.cbDeviceType)

        rpcSend:writeUString(datainfo.szPassword, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(datainfo.szAccounts, GameDefine.LEN_ACCOUNTS * 2)

        rpcSend:writeUString(datainfo.szMachineID, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(datainfo.szMobilePhone, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(datainfo.szCCFlags, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(datainfo.szLoginFlags, GameDefine.LEN_MD5 * 2)

        rpcSend:writeUString(datainfo.szAccountsOld, GameDefine.LEN_ACCOUNTS * 2)
        rpcSend:writeUString(datainfo.szPasswordOld, GameDefine.LEN_MD5 * 2)

        rpcSend:writeUString(datainfo.szMachineIDOld, GameDefine.LEN_MACHINE_ID * 2)
        rpcSend:writeUString(datainfo.szMobilePhoneOld, GameDefine.LEN_MOBILE_PHONE * 2)
        rpcSend:writeUString(datainfo.szCCFlagsOld, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUString(datainfo.szLoginFlagsOld, GameDefine.LEN_MD5 * 2)
        rpcSend:writeUInt8(datainfo.cbOption)

        if datainfo.cbOption == 0 then
            print("发送账号迁移查询")
        else
            print("发送账号迁移")
        end

        rpcSend:release()
    end
    onConnectionServer(sendDataImport, callback)
end

--[[
    --解析数据
]]
local function updatePushNoticeDeviceToken(userId)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local deviceToken = game.getPushNoticeDeviceToken()
    if deviceToken == "" then
        return
    end

    if targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        local postData = string.format("user_id=%d&device_token=%s&platform_user=%s", userId, deviceToken, "ios")

        local sign = game.rsa_sign(postData)
        postData = postData .. "&sign=" .. sign

        game.getHttpJson(GameDefine.updateIosPushToken, postData, 5000, function(succ, content)
            printLog("LoginModule", "更新推送Token 结果")
        end)
    end
end

-- 登陆成功
local function onLoginSuccess(d)
    globalUserInfo.wFaceID = d:readUInt16()
    globalUserInfo.cbGender = d:readUInt8()
    globalUserInfo.dwUserID = d:readUInt32()
    globalUserInfo.dwGameID = d:readUInt32()
    globalUserInfo.dwExperience = d:readUInt32()
    globalUserInfo.dwLoveLiness = d:readUInt32()
    globalUserInfo.lUserScore = d:readInt64() -- 用户游戏币
    globalUserInfo.lUserInsure = d:readInt64() -- 银行游戏币
    globalUserInfo.dwRoomCard = d:readUInt32() -- 房卡
    globalUserInfo.dwRoomCard_reward = d:readUInt32() -- 奖励房卡
    globalUserInfo.dwRoomCard_experience = d:readUInt32() -- 体验房卡

    globalUserInfo.wMasterOrder = d:readUInt16() -- 管理等级
    globalUserInfo.wBankPassType = d:readUInt16() -- 银行密码类型
    globalUserInfo.szNickName = d:readUString(GameDefine.LEN_NICKNAME * 2)
    globalUserInfo.headimgurl = d:readUString(GameDefine.LEN_HEADIMGURL * 2)
    local cbHidePay = d:readUInt8()
    local bIsBindWX = d:readUInt8()
    local cbBindAccount = d:readUInt8() -- 绑定登录账户
    globalUserInfo.isBindWX = bIsBindWX == 1
    globalUserInfo.isBindAccount = cbBindAccount == 1

    if globalUserInfo.cbGender ~= GameDefine.GENDER_MANKIND then
        globalUserInfo.cbGender = GameDefine.GENDER_FEMALE
    end

    globalUserInfo.szRegisterMobile = d:readUString(GameDefine.LEN_MOBILE_PHONE * 2) -- 绑定手机号
    globalUserInfo.cbMemberOrder = d:readUInt16() -- 会员等级
    globalUserInfo.cbRegType = d:readUInt8() -- 账号类型  1：微信账号

    -- 保存登录成功密码
    globalUserInfo.szPassword = loginParams.password
    globalUserInfo.szAccounts = loginParams.account

    -- 银行密码类型
    PlazaManager.bankPassType = globalUserInfo.wBankPassType

    -- 设置CC验证码 密钥+ID
    local str_md5 = string.format("%u%d", GameDefine.CCValidationKey, globalUserInfo.dwUserID)
    GameDefine.CCValidation = game.md5(str_md5)

    if PlazaManager.loginType == GameDefine.LOGIN_TYPE.YK then -- 游客登录方式
        cc.UserDefault:getInstance():setStringForKey("yk_c_account", globalUserInfo.szAccounts)
        cc.UserDefault:getInstance():setStringForKey("yk_c_password", globalUserInfo.szPassword)
        cc.UserDefault:getInstance():setStringForKey("yk_c_nickName", globalUserInfo.szNickName)
        cc.UserDefault:getInstance():setStringForKey("yk_c_headimgurl", globalUserInfo.headimgurl)
        cc.UserDefault:getInstance():setIntegerForKey("yk_c_sex", globalUserInfo.cbGender)
    elseif PlazaManager.loginType == GameDefine.LOGIN_TYPE.ACCOUNT then -- 账号登录方式
        cc.UserDefault:getInstance():setStringForKey("zh_c_account", globalUserInfo.szAccounts)
        cc.UserDefault:getInstance():setStringForKey("zh_c_password", globalUserInfo.szPassword)
        cc.UserDefault:getInstance():setStringForKey("zh_c_nickName", globalUserInfo.szNickName)
        cc.UserDefault:getInstance():setStringForKey("zh_c_headimgurl", globalUserInfo.headimgurl)
        cc.UserDefault:getInstance():setIntegerForKey("yk_c_sex", globalUserInfo.cbGender)
        cc.UserDefault:getInstance():setStringForKey("dq_account_logininfo", "1")
        cc.UserDefault:getInstance():setStringForKey("dq_c_account", "")
        cc.UserDefault:getInstance():setStringForKey("dq_c_password", "")
    end

end

-- 登录失败
local function onLoginFailure(d)
    local isCloseNet = true

    local errorcode = d:readUInt32()
    local szDescribeString = d:readUString(128 * 2)
    local szRegAccount = d:readUString(32 * 2)
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    printLog("LoginModule", "登录失败 错误码：" .. errorcode .. "  描述信息：" .. tostring(szDescribeString) .. "  注册账号：" .. loginParams.account)

    if errorcode == 1 then -- 1账号不存在
        local isRegistered = false
        if game.targetPlatform == cc.PLATFORM_OS_WINDOWS or game.targetPlatform == cc.PLATFORM_OS_MAC then
            if PlazaManager.loginType == GameDefine.LOGIN_TYPE.ACCOUNT or PlazaManager.loginType == GameDefine.LOGIN_TYPE.WEIXIN then
                isRegistered = true
            end
        else
            if PlazaManager.loginType ~= GameDefine.LOGIN_TYPE.ACCOUNT then
                isRegistered = true
            end
        end

        -- xcj
        if (isRegistered == false) then
            if PlazaManager.loginType ~= GameDefine.LOGIN_TYPE.ACCOUNT then
                isRegistered = true
            end
        end

        if isRegistered == true then
            local data = {}
            data.account = loginParams.account
            data.password = loginParams.password
            if loginParams.nickName == nil or loginParams.nickName == "" then
                loginParams.nickName = loginParams.account
            end
            data.nickName = loginParams.nickName
            data.sex = loginParams.sex
            data.headimgurl = loginParams.headimgurl
            if data.headimgurl == nil then
                data.headimgurl = "icon_1.png"
            end
            data.accessToken = loginParams.accessToken
            data.openID = loginParams.openID

            isCloseNet = false
            _M.onRegistered(data, nil)
        else
            PlazaManager.showTips(LangCtrl:getLang().word348)
            PlazaManager.closeWattingTips()
        end
    else
        PlazaManager.showTips(szDescribeString)
        PlazaManager.closeWattingTips()
    end
    game.sendEvent(GameDefine.onLoginFailer, errorcode)

    return isCloseNet
end

-- 登录完成
local function onLoginFinish(d)
    local intermitTime = d:readUInt16() -- 中断时间
    local onlineCountTime = d:readUInt16() -- 更新时间
    local shareStr = GameUtil.filterMultMsg(d:readUString(128 * 2)) -- 二维码分享内容
    globalUserInfo.qrcodeShareContent = shareStr
    print("===onLoginFinish===", intermitTime, onlineCountTime, shareStr)

    if PlazaManager.isCheck == true then
        PlazaManager.addIPV6Address()
    end
    if PlazaManager.loginType == GameDefine.LOGIN_TYPE.WEIXIN then
        _M.onModifyIndividual(1, loginParams.nickName)
        _M.onModifyIndividual(2, loginParams.headimgurl)
    end

    print("准备请求是否卡在游戏中")
    checkInGameServer()
end

-- 家族列表开始
local function onFamilyListBegin(decoder)
    -- printLog("LoginModule","接受家族列表开始")
    PlazaManager.familyInfo = {}
end

-- 家族列表
local function onFamilyList(decoder)
    local uCount = decoder:readUInt32() -- 家族个数
    -- printLog("LoginModule","家族个数 == "..uCount)

    local familyList = {}
    if uCount >= 1 then
        for i = 1, uCount do
            local familyData = {}
            familyData.dwFamilyId = decoder:readUInt32() -- 家族ID
            familyData.dwFamilyNumber = decoder:readUInt32() -- 家族号码
            familyData.wIsActive = decoder:readUInt16() -- 是否点亮家族
            familyData.dwUserCount = decoder:readUInt32() -- 家族人数
            familyData.szFamilyName = decoder:readUString(32 * 2) -- 家族昵称
            familyData.szFamilyHead = decoder:readUString(GameDefine.LEN_HEADIMGURL * 2) -- 家族头像
            --            local str = string.format("familyData.dwFamilyId = %s   familyData.szFamilyName == %s   familyData.szFamilyHead == %s",familyData.dwFamilyId,familyData.szFamilyName,familyData.szFamilyHead)
            --            printLog("LoginModule",str)
            table.insert(familyList, familyData)
        end
    end

    local args = {}
    args.count = uCount
    args.familyList = familyList

    PlazaManager.familyInfo = args

    game.sendEvent(GameDefine.UPDATE_FAMILYLIST)
end

-- 家族列表结束
local function onFamilyListEnd(decoder)
    printLog("LoginModule", "接收家族列表结束")
end

local function onLitFamilyInfo(decoder)
    local nResult = decoder:readUInt32() -- 结果码
    local dwFamilyId = decoder:readUInt32() -- 家族id
    local bIsActive = decoder:readUInt8() -- 是否激活

    if nResult ~= 0 then
        return
    end

    if PlazaManager.familyInfo ~= nil and PlazaManager.familyInfo.familyList ~= nil then
        for key, var in ipairs(PlazaManager.familyInfo.familyList) do
            PlazaManager.familyInfo.familyList[key].wIsActive = 0
            if var.dwFamilyId == dwFamilyId then
                PlazaManager.familyInfo.familyList[key].wIsActive = bIsActive
            end
        end
    end

    game.sendEvent(GameDefine.UPDATE_FAMILY)
end

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
    ServerListData.readGameServerFinish(isAll)
    game.sendEvent(GameDefine.RequestServerListFinish)
end

-- 解析查询房间
local function decoderCheckGameServer(d)
    local dwServerID = d:readUInt32()
    local nCanCreateRoom = d:readUInt8()
    local strRoomID = d:readString(14)
    local szErrDescrybe = d:readUString(GameDefine.LEN_ERROR_INFO * 2)
    szErrDescrybe = GameUtil.filterMultMsg(szErrDescrybe)

    local gameServer = ServerListData.readAndUpdataGameServer(d)
    PlazaManager.closeWattingTips()

    if nCanCreateRoom == 1 and dwServerID > 0 then
        if gameServer ~= nil then
            local args = {}
            args.type = "createRoom"
            args.data = gameServer
            args.cbIsTvGame = cbIsTvGame
            game.sendEvent(GameDefine.OPEN_GAME_WINDOW, args)
        else
            PlazaManager.showTips(LangCtrl:getLang().word235)
        end
    elseif nCanCreateRoom == 0 and string.len(strRoomID) > 0 then
        -- 存在房间
        PlazaManager.showTips(szErrDescrybe)
        _M.onSearchGameServer(strRoomID)
    else
        PlazaManager.showTips(szErrDescrybe)
    end
    game.disconnect(GameDefine.LOGIN_SOCKET)
end

-- 解析查询房间是否存在
local function decoderSearchGameServer(d)
    local dwServerID = d:readUInt32() -- 房间 I D
    local dwTableID = d:readUInt32() -- 桌子 I D
    local dwGoldID = d:readUInt32() -- 金币模式

    local gameServer = ServerListData.readAndUpdataGameServer(d)

    local cbRoomType = d:readUInt8() -- 房间类型 0约战房 1-金币房

    printLog("LoginModule", "decoderSearchGameServer : dwServerID=" .. dwServerID .. "  dwTableID == " .. dwTableID .. "   dwGoldID=" .. dwGoldID)

    if dwServerID > 0 then
        -- local gameServer = ServerListData.getGameServerByServerID(dwServerID)
        if gameServer ~= nil then
            local args = {}
            args.joinData = {}
            args.joinData.wTableID = dwTableID
            args.joinData.btGoldOrRoomCard = dwGoldID
            args.joinData.szPassword = ""
            args.joinData.szPersonalTableID = ""

            if _strSearchRoomID ~= nil then
                args.joinData.szPersonalTableID = _strSearchRoomID
            end

            args.tagGameServer = gameServer

            local isUpdateStatus = PlazaManager.checkGameVersion(gameServer.wKindID)
            if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
                -- PlazaManager.showTips("游戏有新版本请更新")
                local function onDownloadCallback(result, kindid)
                    if result == true then
                        game.sendEvent(GameDefine.CS_JOIN_PRIVATE_EVENT, args)
                    end
                end

                local function onDownloadGame(isOk)
                    if isOk == true then
                        PlazaManager.onDownloadGame(gameServer.wKindID, onDownloadCallback)
                    end
                end

                PlazaManager.closeWattingTips()
                PlazaManager.showConfirmNode("yes_no", LangCtrl:getLang().word236, nil, onDownloadGame)
                return
            end

            game.sendEvent(GameDefine.CS_JOIN_PRIVATE_EVENT, args)
        else
            PlazaManager.closeWattingTips()
            PlazaManager.showTips(LangCtrl:getLang().word237)
        end
    else
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(LangCtrl:getLang().word237)
    end
end

-- 解析玩家游戏状态
local function decoderIsGameServer(d)
    local lockKindID = d:readUInt32()
    local lockServerID = d:readUInt32()
    PlazaManager.setLockData(lockKindID, lockServerID)

    print("请求是否卡在游戏中结束 lockKindID = " .. lockKindID .. " lockServerID = " .. lockServerID)
    -- 发送登录完成
    print("发送登录完成 == ")
    PlazaManager.closeWattingTips()
    game.sendEvent(GameDefine.GP_LOGIN_FINISH_EVENT)
end

-- 解析用户用金币兑换商品
local function decoderShop_PayByGoal(data)
    local result = {}
    result.uResultCode = data:readUInt32()
    result.szString = GameUtil.filterMultMsg(data:readUString(64 * 2))
    result.uRoomCard = data:readUInt32()
    result.lGoldScore = data:readInt64()

    globalUserInfo.dwRoomCard = result.uRoomCard
    globalUserInfo.lUserScore = result.lGoldScore
    -- game.sendEvent(GameDefine.Shop_PayByGoal, result)
    PlazaManager.showTips(result.szString)
    if result.uResultCode == 0 then
        game.sendEvent(GameDefine.UpdataUserGoalInfo)
    end
end

-- 登录银行成功
local function decoderLogonBank_succ(data)
    local result = {}
    result.dwUserID = data:readUInt32() -- 用户 I D
    result.BankGold = data:readInt64() -- 银行金币
    result.GameGold = data:readInt64() -- 游戏金币
    result.lFamilyExpTotal = data:readInt64() -- 个人家族总贡献值
    result.lFamilyExpUsed = data:readInt64() -- 个人家族已经使用的贡献值
    result.dwRoomCard = data:readUInt32() -- 用户房卡(A卡)
    result.dwRoomCard_reward = data:readUInt32() -- 奖励房卡(B卡)
    result.dwRoomCard_experience = data:readUInt32() -- 体验房卡

    globalUserInfo.lUserScore = result.GameGold
    globalUserInfo.lUserInsure = result.BankGold
    globalUserInfo.lFamilyExpTotal = result.lFamilyExpTotal
    globalUserInfo.lFamilyExpUsed = result.lFamilyExpUsed
    globalUserInfo.dwRoomCard = result.dwRoomCard -- 用户房卡(A卡)
    globalUserInfo.dwRoomCard_reward = result.dwRoomCard_reward -- 奖励房卡(B卡)
    globalUserInfo.dwRoomCard_experience = result.dwRoomCard_experience -- 体验房卡

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_LogonSucc, result)
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
end
-- 登录银行失败
local function decoderLogonBank_fail(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 错误代码
    result.szDescribeString = data:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)

    PlazaManager.closeLoginSocket()
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(result.szDescribeString)
end

-- 查询银行信息成功
local function decoderSeachBankInfoSucc(data)
    local result = {}
    result.wRevenueTake = data:readUInt16() -- 取款税收比例
    result.wRevenueTransfer = data:readUInt16() -- 赠送税收比例
    result.wServerID = data:readUInt16() -- 当前是否卡在某个房间的对应标识
    result.lUserScore = data:readInt64() -- 用户金币
    result.lUserInsure = data:readInt64() -- 银行金币
    result.lTransferPrerequisite = data:readInt64() -- 转账条件

    globalUserInfo.lUserScore = result.lUserScore
    globalUserInfo.lUserInsure = result.lUserInsure

    PlazaManager.closeWattingTips()
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SeachInfoSucc, result)
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
end

-- 存取款银行成功
local function decoderQueryBankInfo_succ(data)
    local result = {}
    result.functionType = data:readUInt16() -- 使用类型  1-存款成功 2-取款成功
    result.goalID = data:readUInt16() -- 金币ID
    result.dwUserID = data:readUInt32() -- 用户 I D
    result.lUserScore = data:readInt64() -- 用户金币
    result.lUserInsure = data:readInt64() -- 银行金币
    result.szDescribeString = data:readUString(256 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)

    globalUserInfo.lUserScore = result.lUserScore
    globalUserInfo.lUserInsure = result.lUserInsure
    PlazaManager.closeLoginSocket()
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(data.szDescribeString)

    game.sendEvent(GameDefine.UpdataUserGoalInfo)
    game.sendEvent(GameDefine.Bank_Back_SaveTakeSucc)
end
-- 存取款银行失败
local function decoderQueryBankInfo_fail(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 错误代码
    result.szDescribeString = data:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    PlazaManager.closeLoginSocket()
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(result.szDescribeString)
end

-- 根据ID号查询用户成功
local function decoderSeacherUserByIDSucc(data)
    local result = {}
    result.GiveUserID = data:readUInt32() -- 接受者ID
    result.szNickName = data:readUString(GameDefine.LEN_NICKNAME * 2) -- 接受者昵称
    result.szHeadImg = data:readUString(GameDefine.LEN_HEADIMGURL * 2) -- 接受者头像
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SeachGiveUserSucc, result)
end
-- 根据ID号查询用户失败
local function decoderSeacherUserByIDFail(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 结果代码
    result.szDescribeString = data:readUString(128 * 2)
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SeachGiveUserFail, result)
end

-- 银行赠送金币成功
local function decoderBankTransferSucc(data)
    local result = {}

    result.lUserScore = data:readInt64() -- 用户金币
    result.lUserInsure = data:readInt64() -- 银行金币
    result.dwRecordID = data:readUInt32() -- 记录ID
    result.dwSourceUserID = data:readUInt32() -- 赠送用户ID
    result.dwTargetUserID = data:readUInt32() -- 获赠用户ID
    result.szSourceNickName = data:readUString(GameDefine.LEN_NICKNAME * 2) -- 赠送用户昵称
    result.szTargetNickName = data:readUString(GameDefine.LEN_NICKNAME * 2) -- 获赠用户昵称
    result.lScore = data:readInt64() -- 赠送游戏币

    result.dtTime = {}
    result.dtTime.wYear = data:readUInt16() -- 年
    result.dtTime.wMonth = data:readUInt16() -- 月
    result.dtTime.wDayOfWeek = data:readUInt16() -- 星期，0=星期日，1=星期一
    result.dtTime.wDay = data:readUInt16() -- 日
    result.dtTime.wHour = data:readUInt16() -- 时
    result.dtTime.wMinute = data:readUInt16() -- 分
    result.dtTime.wSecond = data:readUInt16() -- 秒
    result.dtTime.wMilliseconds = data:readUInt16() -- 毫秒

    -- globalUserInfo.lUserScore=result.lUserScore
    globalUserInfo.lUserInsure = result.lUserInsure

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
    game.sendEvent(GameDefine.Bank_Back_TransferSucc, result)
end

-- 银行操作失败
local function decoderBankOperateFailer(decoder)
    local result = {}
    result.lResultCode = decoder:readUInt32() -- 结果码
    result.szDescribeString = decoder:readUString(128 * 2)
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    PlazaManager.closeWattingTips()
    PlazaManager.closeLoginSocket()
    PlazaManager.showTips(result.szDescribeString)
    game.sendEvent("EVENT_USER_SERVER_OPERATE_RESULT", result)
end

-- 银行操作成功
local function decoderBankOperateSuccess(decoder)
    local result = {}
    result.lResultCode = decoder:readUInt32() -- 结果代码
    result.szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    PlazaManager.closeWattingTips()
    PlazaManager.closeLoginSocket()

    game.sendEvent("EVENT_USER_SERVER_OPERATE_RESULT", result)
end

local bankGiveGoalRecordList = {}
-- 接受用户转账记录
local function decoderBankGiveRecord(data)
    local dataRecord = {}
    dataRecord.dwRecordID = data:readUInt32() -- 记录ID
    dataRecord.dwSourceUserID = data:readUInt32() -- 赠送用户ID
    dataRecord.dwTargetUserID = data:readUInt32() -- 被赠送用户ID
    dataRecord.szSourceNickName = data:readUString(GameDefine.LEN_NICKNAME * 2) -- 赠送用户昵称
    dataRecord.szTargetNickName = data:readUString(GameDefine.LEN_NICKNAME * 2) -- 被赠送用户昵称
    dataRecord.lScore = data:readInt64()

    local dtTime = {}
    dtTime.wYear = data:readUInt16() -- 年
    dtTime.wMonth = data:readUInt16() -- 月
    dtTime.wDayOfWeek = data:readUInt16() -- 星期，0=星期日，1=星期一
    dtTime.wDay = data:readUInt16() -- 日
    dtTime.wHour = data:readUInt16() -- 时
    dtTime.wMinute = data:readUInt16() -- 分
    dtTime.wSecond = data:readUInt16() -- 秒
    dtTime.wMilliseconds = data:readUInt16() -- 毫秒
    dataRecord.dtTime = dtTime

    table.insert(bankGiveGoalRecordList, dataRecord)
end
-- 接受用户转账完成
local function decoderBankGiveRecordFinish(data)
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SeachGiveRecordSucc, bankGiveGoalRecordList)
    bankGiveGoalRecordList = {}
end

-- 银行查询或者提取流水返点成功
local function decoderRunningAccountSucc(dataread)
    local data = {}
    data.lNewRunningGold = dataread:readUInt64() -- 可领取的流水返点金币（实际可提数）
    data.lSumRunningGold = dataread:readUInt64() -- 已结算流水
    data.lNewTax = dataread:readUInt64() -- 可领取赠送返点
    data.lSumTax = dataread:readUInt64() -- 已结算的赠送返点
    data.wRate = dataread:readUInt16() -- 流水返点率（千分之几）
    data.lYesterdayWinLose = dataread:readInt64() -- 昨日总输赢，捕鱼活动
    data.lLuckyValue = dataread:readUInt64() -- 今日可提昨日活动返点
    data.szNote = dataread:readUString(350 * 2)
    data.szNote = GameUtil.filterMultMsg(data.szNote)

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_RequestMoneyBackSucc, data)
end

-- 修改银行密码成功消息
local function decoderModiBankPassword_succ(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 结果代码
    result.szDescribeString = data:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_ModiPassword, result)
end

local function decoderBank_VerifyPassResult(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 错误代码
    result.szDescribeString = data:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)

    PlazaManager.closeLoginSocket()
end
-- 密码类型转换结果
local function decoderPassTypeChangeResult(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 结果代码
    result.dwUserID = data:readUInt32() -- 结果代码
    result.wPassType = data:readUInt16() -- 结果代码
    result.PassStr = data:readUString(GameDefine.LEN_PASSWORD * 2)

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_PassTypeChange, result)
end
-- 赠送房卡成功
local function decoderRoomCardGiveSucc(data)
    local result = {}
    result.dwUserID = data:readUInt32() -- 赠送者ID
    result.wRoomCard_1 = data:readUInt32() -- A房卡数量
    result.wRoomCard_2 = data:readUInt32() -- B房卡数量

    globalUserInfo:updateRoomCard2(result.wRoomCard_1, result.wRoomCard_2)

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SendGiveRoomCrad, result)
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
end
-- 赠送房卡失败
local function decoderRoomCardFail(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 结果代码
    result.szDescribeString = data:readUString(128 * 2)
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)

    PlazaManager.closeLoginSocket()
end
-- 家族贡献值兑换房卡金币失败
local function decoderExcRoomCardFail(data)
    local result = {}
    result.lResultCode = data:readUInt32() -- 结果代码
    result.szDescribeString = data:readUString(128 * 2)
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)

    PlazaManager.closeLoginSocket()
end
-- 家族贡献值兑换房卡成功
local function decoderExpExchangeRoomCardSucc(data)
    local result = {}
    result.dwUserID = data:readUInt32() -- 赠送者ID
    result.FamilyExpTotal = data:readInt64() -- 总积分
    result.FamilyExpUsed = data:readInt64() -- 使用积分
    result.dwRoomCard1 = data:readUInt32() -- B卡数量

    globalUserInfo:updateRoomCard2(globalUserInfo.dwRoomCard, result.dwRoomCard1)
    globalUserInfo.lFamilyExpTotal = result.FamilyExpTotal
    globalUserInfo.lFamilyExpUsed = result.FamilyExpUsed

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SendExchangeFamilyExp, result)
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
end
-- 家族贡献值兑换金币成功
local function decoderExpExchangeGoalSucc(data)
    local result = {}
    result.dwUserID = data:readUInt32() -- 赠送者ID
    result.Scole = data:readInt64() -- 用户银行金币
    result.FamilyExpTotal = data:readInt64() -- 总积分
    result.FamilyExpUsed = data:readInt64() -- 使用积分

    globalUserInfo:updateScore(globalUserInfo.lUserScore, result.Scole)
    globalUserInfo.lFamilyExpTotal = result.FamilyExpTotal
    globalUserInfo.lFamilyExpUsed = result.FamilyExpUsed

    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.Bank_Back_SendExchangeFamilyExp, result)
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
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
    PlazaManager.closeLoginSocket()
    game.sendEvent(GameDefine.UpdataUserGoalInfo)
end

-- 登录收到公告消息，解析公告
local function decoderListWelcome(data)
    while (data:isNextRead()) do
        local result = {}
        result.wWelcomeID = data:readUInt16() -- 公告ID
        result.wSortID = data:readUInt16() -- 排序序号
        result.wContentType = data:readUInt16() -- 内容类型：0-活动(URL),1-游戏公告(纯文本),2-HTML,3.滚动公告
        result.szContent = data:readUString(1024 * 2) -- 公告内容
        result.szContent = GameUtil.filterMultMsg(result.szContent, 1)
        result.rollTimes = -1 -- 滚动公告（滚动的次数，-1为永久，其他为次数）
        result.msgState = 0 -- 状态 0-未显示，1-显示（游戏公告和活动使用）

        if result.wContentType == 1 then
            result.wWelcomeName = LangCtrl:getLang().word238 -- 公告名称
        else
            result.wWelcomeName = LangCtrl:getLang().word239
        end

        if result.szContent then
            if result.wContentType == 3 then
                table.insert(PlazaManager.GameWelcomeList, result)
            else
                local newChk = true
                for i = 1, PlazaManager.WelcomeCount do
                    if (result.wWelcomeID == PlazaManager.WelcomeDataList[i].wWelcomeID) then
                        newChk = false
                    end
                end

                if (newChk == true) then
                    PlazaManager.WelcomeCount = PlazaManager.WelcomeCount + 1
                    PlazaManager.WelcomeDataList[PlazaManager.WelcomeCount] = result
                end
            end
        end
    end
    game.sendEvent(GameDefine.AcceptListWelcome)
end

local function onBindWXSuccess(d)
    globalUserInfo.cbGender = d:readUInt8()
    globalUserInfo.szNickName = d:readUString(GameDefine.LEN_NICKNAME * 2)
    globalUserInfo.headimgurl = d:readUString(GameDefine.LEN_HEADIMGURL * 2)
    PlazaManager.loginType = GameDefine.LOGIN_TYPE.WEIXIN

    PlazaManager.closeWattingTips()

    game.sendEvent(GameDefine.SWITCH_HALL_LAYER, {
        bshow = true,
        index = GameDefine.HALL_LAYER_INDEX.FAMILY
    })
end

local function onBindWXFailure(decoder)
    local lResultCode = decoder:readUInt32() -- 结果码
    local szDescribeString = decoder:readUString(128 * 2)
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szDescribeString)
    game.sendEvent(GameDefine.SWITCH_HALL_LAYER, {
        bshow = true,
        index = GameDefine.HALL_LAYER_INDEX.HALL
    })
end

local function onBindAccountFailure(decoder) -- 绑定账户失败
    local lResultCode = decoder:readUInt32() -- 结果码
    local szDescribeString = decoder:readUString(128 * 2)
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    game.sendEvent(GameDefine.BindAccountResult, {
        isSuccess = false,
        szDescribeStr = szDescribeString
    })
end

local function onBindAccountSuccess(decoder) -- 绑定账户成功
    local account = decoder:readUString(GameDefine.LEN_ACCOUNTS * 2)
    -- 账户
    local password = decoder:readUString(GameDefine.LEN_PASSWORD * 2)
    -- 密码
    globalUserInfo.isBindAccount = true

    cc.UserDefault:getInstance():setBoolForKey("zh_c_writePassCheck", true)
    local account_local = cc.UserDefault:getInstance():getStringForKey("zh_c_account", "")
    -- local password_local = cc.UserDefault:getInstance():getStringForKey('zh_c_password', '')
    -- if not (string.len(account_local) > 1 and string.len(password_local) > 1) then
    if string.len(account_local) <= 2 then
        cc.UserDefault:getInstance():setStringForKey("zh_c_account", account)
        cc.UserDefault:getInstance():setStringForKey("zh_c_password", password)
    end

    -- globalUserInfo.szNickName = "new nickName" --去掉游客字样 更新显示  xcj
    print("账户绑定成功  account == " .. account .. "  password == " .. password)

    game.sendEvent(GameDefine.BindAccountResult, {
        isSuccess = true,
        accountStr = account,
        passwordStr = password
    })
end

local function onDataImportSuccess(decoder) -- 数据迁移成功
    local args = {}
    args.dwGameID = decoder:readUInt32() -- 迁移账号GameID
    args.lCash = decoder:readUInt64() -- 迁移的现金数量
    args.lBank = decoder:readUInt64() -- 迁移的保险箱数量
    args.szNickName = decoder:readUString(GameDefine.LEN_NICKNAME * 2)
    args.lrebate = decoder:readUInt64()

    print("迁移数据 == dwGameID == " .. args.dwGameID .. "  lCash == " .. args.lCash .. "    lBank == " .. args.lBank .. "   args.szNickName == " .. args.szNickName)
    game.sendEvent(GameDefine.DataImportSuccess, args)
end

local function onDataImportFailer(decoder) -- 数据迁移失败
    local result = {}
    result.lResultCode = decoder:readUInt32() -- 错误代码
    result.szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
end

local function onCheckDataImportSuccess(decoder) -- 查询数据迁移成功
    local dtTime = {}
    dtTime.wYear = decoder:readUInt16() -- 年
    dtTime.wMonth = decoder:readUInt16() -- 月
    dtTime.wDayOfWeek = decoder:readUInt16() -- 星期，0=星期日，1=星期一
    dtTime.wDay = decoder:readUInt16() -- 日
    dtTime.wHour = decoder:readUInt16() -- 时
    dtTime.wMinute = decoder:readUInt16() -- 分
    dtTime.wSecond = decoder:readUInt16() -- 秒
    dtTime.wMilliseconds = decoder:readUInt16() -- 毫秒

    print("dtTime.wYear == " .. dtTime.wYear)
    print("dtTime.wMonth == " .. dtTime.wMonth)
    print("dtTime.wDayOfWeek == " .. dtTime.wDayOfWeek)
    print("dtTime.wDay == " .. dtTime.wDay)
    print("dtTime.wHour == " .. dtTime.wHour)
    print("dtTime.wMinute == " .. dtTime.wMinute)
    print("dtTime.wSecond == " .. dtTime.wSecond)
    print("dtTime.wMilliseconds == " .. dtTime.wMilliseconds)

    local result = false
    if dtTime.wYear > 0 then
        result = true
        print("已经迁移")
    else
        print("没迁移")
    end

    game.sendEvent(GameDefine.CheckDataImportSuccess, result)
end

local function onCheckDataImportFailer(decoder) -- 查询数据迁移失败
    local result = {}
    result.lResultCode = decoder:readUInt32() -- 错误代码
    result.szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    result.szDescribeString = GameUtil.filterMultMsg(result.szDescribeString)
    game.sendEvent(GameDefine.CheckDataImportFailer, result)
end

local isReadBattle = false
local battleType = nil
local function decoderBattleBegin(decoder)
    print("解析战绩开始")
    battleType = decoder:readUInt32()
    isReadBattle = true
    PlazaManager.battleData[battleType + 1] = {}
end

local PERSONAL_ROOM_CHAIR = 8 -- 私人房间座子上椅子的最大数目
local function decoderBattle(decoder)
    if isReadBattle == false then
        return
    end

    while (decoder:isNextRead()) do
        local battleRecord = {}
        battleRecord.szRoomID = decoder:readUString(32 * 2) -- 房间号
        battleRecord.dwRoomPrice = decoder:readUInt32() -- 房间价格（房卡或所扣金币）
        battleRecord.dwRoundCount = decoder:readUInt32() -- 游戏局数
        battleRecord.dwKindID = decoder:readUInt32() -- 游戏类型ID
        battleRecord.wGoldOrRoomCard = decoder:readUInt32() -- 房卡或金币模式
        battleRecord.dwPlayerCount = decoder:readUInt32() -- 游戏人数

        battleRecord.names = {} -- 各个玩家昵称，已按座位号排序
        for i = 1, PERSONAL_ROOM_CHAIR + 1 do
            local name = decoder:readUString(GameDefine.LEN_NICKNAME * 2)
            table.insert(battleRecord.names, name)
        end

        battleRecord.scores = {} -- 各个玩家分数，已按座位号排序
        for i = 1, PERSONAL_ROOM_CHAIR + 1 do
            local score = decoder:readInt32()
            table.insert(battleRecord.scores, score)
        end

        battleRecord.dwWinnerChairID = decoder:readUInt32() -- 此局赢最多的玩家（房卡从该玩家扣）

        if battleRecord.wGoldOrRoomCard == battleType then
            table.insert(PlazaManager.battleData[battleType + 1], battleRecord)
        end
    end
end

local function decoderBattleEnd(decoder)
    print("解析战绩结束")
    isReadBattle = false
    PlazaManager.closeWattingTips()
    game.sendEvent(GameDefine.BATTLE_DATA_FINISH)
end

local battleDetailCount = 0
local battleDetailReasonCount = 0
local battleDetailDatas = {}
local battleDetailKindID = 0
local function decoderBattleDetailBegin(decoder)
    battleDetailCount = 0
    battleDetailDatas = {}
    battleDetailDatas.gameCount = 0
    battleDetailReasonCount = 0
    battleDetailDatas.names = {} -- 各个玩家昵称，服务端已按座位号排序
    battleDetailDatas.scores = {} -- 每局（最大32局）各个玩家分数，服务端已按座位号排序
    battleDetailDatas.reason = {} -- 写分备注。每个游戏有不同的解析规则

    -- 各个玩家昵称，已按座位号排序。特殊字符串"py78:noplayer"表示该座位是空的。
    for i = 1, GameDefine.PERSONAL_ROOM_CHAIR do
        local name = decoder:readUString(GameDefine.LEN_NICKNAME * 2)
        if name == "py78:noplayer" then
            name = ""
        end
        table.insert(battleDetailDatas.names, name)
    end
    battleDetailKindID = decoder:readInt32() -- 游戏的KindID（指定cbReason的解析规则）
end

-- 战绩明细
local function decoderBattleDetail(decoder)
    local args = {}
    local gameCount = decoder:readUInt8() -- 实际对局数量
    battleDetailDatas.gameCount = battleDetailDatas.gameCount + gameCount

    for i = 1, gameCount do
        battleDetailCount = battleDetailCount + 1
        battleDetailDatas.scores[battleDetailCount] = {}
        for k = 1, GameDefine.PERSONAL_ROOM_CHAIR do
            local score = decoder:readInt32()
            table.insert(battleDetailDatas.scores[battleDetailCount], score)
        end
    end

    local nullDataCount = 32 - gameCount
    if nullDataCount > 0 then
        for i = 1, nullDataCount do
            for k = 1, GameDefine.PERSONAL_ROOM_CHAIR do
                local nullScore = decoder:readInt32()
            end
        end
    end

    -- 写分备注。每个游戏有不同的解析规则
    for i = 1, gameCount do
        battleDetailReasonCount = battleDetailReasonCount + 1
        battleDetailDatas.reason[battleDetailReasonCount] = {}
        if battleDetailKindID == GameDefine.GAME_KINDID.JDNN or battleDetailKindID == GameDefine.GAME_KINDID.TBNN then
            -- 每局（最大32）各个玩家牌型，已按座位号排
            for k = 1, GameDefine.PERSONAL_ROOM_CHAIR do
                local niuniuType = decoder:readInt8()
                table.insert(battleDetailDatas.reason[battleDetailReasonCount], niuniuType)
            end
        end
    end
end

local function decoderBattleDetailEnd(decoder)
    PlazaManager.closeWattingTips()
    game.sendEvent(GameDefine.GP_UPDATE_BATTLE_DETAIL, battleDetailDatas)
end

-- 修改资料成功
local function decoderModifyindSuccess(decoder)
    local wModifyType = decoder:readUInt16()
    local szContent = decoder:readUString(256 * 2)
    if wModifyType == 1 then -- 昵称
        globalUserInfo.szNickName = szContent
    elseif wModifyType == 2 then -- 头像
        globalUserInfo.headimgurl = szContent
    elseif wModifyType == 3 then -- 真实姓名
        globalUserInfo.szCompellation = szContent
        printLog("LoginModule", "修改真实姓名成功 " .. globalUserInfo.szCompellation)
    elseif wModifyType == 4 then -- 身份证号码
        globalUserInfo.szPassPortID = szContent
        printLog("LoginModule", "修改身份证号码成功 " .. globalUserInfo.szPassPortID)
    elseif wModifyType == 5 then -- QQ号
        globalUserInfo.szQQ = szContent
        printLog("LoginModule", "修改QQ号成功 " .. globalUserInfo.szQQ)
    elseif wModifyType == 6 then -- 用于显示的手机号
        globalUserInfo.szMobilePhone = szContent
        printLog("LoginModule", "修改显示的手机号成功 " .. globalUserInfo.szMobilePhone)
    elseif wModifyType == 7 then -- 用于显示的手机号
        globalUserInfo.szWeixin = szContent
        printLog("LoginModule", "修改微信号成功 " .. globalUserInfo.szWeixin)
    end
    local data = {}
    data.wModifyType = wModifyType
    data.szContent = szContent
    game.sendEvent(GameDefine.ModifyPersonInfoSuccess, data)
end

-- 修改资料失败
local function decoderModifyindFailer(decoder)
    local lResultCode = decoder:readUInt32()
    local szDescribeString = decoder:readUString(128 * 2)
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)

    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szDescribeString)
    game.sendEvent(GameDefine.ModifyPersonInfoFail)
end

-- 分享成功
local function decoderShareSuccess(decoder)
    local lMaxGrantCount = decoder:readInt32() -- 最大赠送房卡的次数
    local lRemainGrantCount = decoder:readInt32() -- 剩余赠送房卡的次数
    local lRemainGrantCard = decoder:readInt32() -- 剩余赠送的房卡数量
    local lCurGrantCard = decoder:readInt32() -- 本次赠送的房卡数量

    if PlazaManager.shareInfo == nil then
        PlazaManager.shareInfo = {}
    end

    PlazaManager.shareInfo.lMaxGrantCount = lMaxGrantCount
    PlazaManager.shareInfo.lRemainGrantCount = lRemainGrantCount
    PlazaManager.shareInfo.lRemainGrantCard = lRemainGrantCard
    PlazaManager.shareInfo.lCurGrantCard = lCurGrantCard

    game.sendEvent(GameDefine.GAME_SHARE_SUCCESS)
    if lCurGrantCard > 0 then
        PlazaManager.showTips(LangCtrl:getLang().word351)
    end
end

-- 分享失败
local function decoderShareFailer(decoder)
    local lResultCode = decoder:readInt32() -- 操作代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述信息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szDescribeString)
end

local function decoderUpdate(decoder)
    local cbMustUpdate = decoder:readInt8() -- 强行升级
    local cbAdviceUpdate = decoder:readInt8() -- 建议升级
    local dwCurrentVersion = decoder:readInt32() -- 当前版本
    local szAppVersion = decoder:readUString(66) -- app版本

    print(string.format("新版本冲突:[mustUpdate:%d][adviceUpdate:%d][currentVersion:%d][appVersion:%s]", cbMustUpdate, cbAdviceUpdate, dwCurrentVersion, szAppVersion))

    if cbMustUpdate > 0 or cbAdviceUpdate > 0 then
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(LangCtrl:getLang().word240)
    end
end

-- 查询个人私人房列表返回
local privateRoomData = {}
local function decoderSearchPersonalRoomListSart(decoder)
    privateRoomData = {}
    privateRoomData.count = 0
    privateRoomData.roomList = {}
end
local function decoderSearchPersonalRoomList(decoder)
    local roomData = {}
    roomData.wSocketID = decoder:readUInt32()
    roomData.dwServerID = decoder:readUInt32()
    roomData.dwKindID = decoder:readUInt32() -- 游戏ID
    roomData.dwTableID = decoder:readUInt32() -- 桌子ID
    roomData.dwTableUserID = decoder:readUInt32() -- 桌主ID
    roomData.dwDrawCountLimit = decoder:readUInt32() -- 局数限制
    roomData.dwDrawTimeLimit = decoder:readUInt32() -- 时间限制
    roomData.lCellScore = decoder:readInt64() -- 房间底分
    roomData.lRestrictScore = decoder:readInt64() -- 单局积分上限
    roomData.szRoomID = decoder:readUString(GameDefine.private_ROOM_ID_LEN * 2) -- 房间ID
    roomData.btGoldOrRoomCard = decoder:readUInt8() -- 是金币还是房卡
    roomData.dwGoldID = decoder:readUInt32() -- 金币类型
    roomData.dwBaseGold = decoder:readUInt32() -- 消耗的金币
    roomData.dwRoomCard = decoder:readUInt32() -- 消耗的房卡
    roomData.dwMinGameScore = decoder:readUInt32() -- 身上最少携带金币数量
    roomData.wJoinGamePeopleCount = decoder:readUInt16() -- 参与游戏的人数
    roomData.szPassword = decoder:readUString(GameDefine.LEN_PASSWORD * 2) -- 房间ID
    roomData.szGameRule = {}
    for j = 1, 100 do
        roomData.szGameRule[j] = decoder:readUInt8()
    end
    roomData.btMySelf = decoder:readUInt8() -- 自己的房
    roomData.dwFamilyID = decoder:readUInt32() -- 非零值，只允许对应家族成员和房主加入
    roomData.cbPlayerCount = decoder:readUInt8() -- 进入玩家人数
    roomData.wRoundCount = decoder:readUInt16() -- 已完成局数
    roomData.bStarted = decoder:readUInt8() -- 是否开始
    roomData.dwRemainTime = decoder:readUInt32() -- 剩余的解散时间
    roomData.lReward = decoder:readInt64() -- 金币模式房，最大赢家打赏创建者的金额
    roomData.dwAllUserID = {} -- 如果对应的座位没人，则为0
    for i = 1, 8 do
        roomData.dwAllUserID[i] = decoder:readUInt32()
    end

    roomData.szNickNameList = {}
    for i = 1, 8 do
        roomData.szNickNameList[i] = decoder:readUString(GameDefine.LEN_NICKNAME * 2)
    end

    roomData.szImgAddrList = {}
    for i = 1, 8 do
        roomData.szImgAddrList[i] = decoder:readUString(GameDefine.LEN_HEADIMGURL * 2)
    end

    roomData.timeCreate = decoder:readInt64()
    roomData.timeBegin = decoder:readInt64()
    roomData.wContinueCount = decoder:readUInt16()
    roomData.szDiscripTion1 = decoder:readUString(256 * 2)
    roomData.szDiscripTion2 = decoder:readUString(256 * 2)

    privateRoomData.count = privateRoomData.count + 1
    privateRoomData.roomList[privateRoomData.count] = roomData
end

local function decoderSearchPersonalRoomListEnd(decoder)
    game.sendEvent(GameDefine.BackPrivateRoomListMessage, privateRoomData)
end

local function decoderVerifyCodeSuccess(decoder)
    game.sendEvent(GameDefine.VerifyCode_Request_Success)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(LangCtrl:getLang().word241)
end

local function decoderVerifyCodeFailer(decoder)
    local szMobilePhone = decoder:readUString(GameDefine.LEN_MOBILE_PHONE * 2) -- 电话号码
    local lResultCode = decoder:readInt64() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    game.sendEvent(GameDefine.VerifyCode_Request_Failer, lResultCode)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szDescribeString)
end

local function decoderGiveAlmsSuccess(decoder)
    local data = {}
    data.bGrantNow = decoder:readUInt32() -- 是否可以立即领取救济金0：不可以，1，可以
    data.lMaxCount = decoder:readUInt32() -- 最大领取救济金的次数
    data.lRemainCount = decoder:readUInt32() -- 剩余领取救济金的次数
    data.lAlms = decoder:readUInt32() -- 本次领取的救济金数量
    data.lGold = decoder:readUInt64() -- 用户领取完救济金的当前金币
    data.bTodayOver = decoder:readUInt32() -- 系统是否已经发完当天救济金

    if data.lAlms > 0 then -- 刷新用户金币
        globalUserInfo.lUserScore = data.lGold
        game.sendEvent(GameDefine.UpdataUserGoalInfo)
    end
    PlazaManager.closeLoginSocket()

    game.sendEvent(GameDefine.GiveAlmsSuccess, data)
end

local function decoderGiveAlmsFailer(decoder)
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(szDescribeString)
end

local function decoderOperateFailer(decoder)
    local lResultCode = decoder:readInt32() -- 操作代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述信息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.showTips(szDescribeString)
end

--[[
由于回放数据是多条，且数目是不定的。
所以在返回游戏回放数据前会先返回一条 SUB_MB_GAME_RECORD_START（314），表示回放数据开始传送；
接着返回若干条SUB_MB_GAME_RECORD（315），每条信息搭载一条真正的回放数据；
最后返回一条SUB_MB_GAME_RECORD_END（316），表示回放数据传送完毕。

第一条SUB_MB_GAME_RECORD消息结构:
struct CMD_GR_PersonalTableTip
{
	DWORD							dwTableOwnerUserID;					// 桌主 I D
	TCHAR							szRoomID[7];						// 房间编号
	BYTE							cbGameRule[RULE_LEN];  
	DWORD							dwTurnCount;						// 已进行了几局游戏
	bool							bEndGameRequest;					// 是否发起解散
	int							iRequestReply[MAX_CHAIR];				// 各个玩家回复解散的状态
	tagPersonalTableParameter				PersonalTableInfo;
	DWORD							dwElapse;						// 还剩多少时间自动解散，单位毫秒
};

第二条SUB_MB_GAME_RECORD消息结构:
WORD wSitUserCount;	// 游戏参与的人数

第三条至第N条（N = 3 + wSitUserCount - 1）SUB_MB_GAME_RECORD消息结构:
//用户信息
struct tagUserInfoHead
{
	//用户属性
	DWORD							dwGameID;						//游戏 I D
	DWORD							dwUserID;						//用户 I D
	DWORD							dwGroupID;						//社团 I D

	//头像信息
	WORD							wFaceID;						//头像索引
	DWORD							dwCustomID;						//自定标识

	//用户属性
	BYTE							cbGender;						//用户性别
	BYTE							cbMemberOrder;						//会员等级
	BYTE							cbMasterOrder;						//管理等级

	//用户状态
	WORD							wTableID;						//桌子索引
	WORD							wChairID;						//椅子索引
	BYTE							cbUserStatus;						//用户状态

	//积分信息
	SCORE							lScore;							//用户分数
	SCORE							lGrade;							//用户成绩
	SCORE							lInsure;						//用户银行
    	SCORE                           lTempScore;									//临时保留分数

	//游戏信息
	DWORD							dwWinCount;						//胜利盘数
	DWORD							dwLostCount;						//失败盘数
	DWORD							dwDrawCount;						//和局盘数
	DWORD							dwFleeCount;						//逃跑盘数
	DWORD							dwUserMedal;						//用户奖牌
	DWORD							dwExperience;						//用户经验
	LONG							lLoveLiness;						//用户魅力

	//用户昵称
	TCHAR							szNickName[LEN_NICKNAME];				//用户昵称
	TCHAR							szImgAddr[LEN_IMG_ADDR];				//头像地址
};

第N条数据后的回放数据结构：
+---------------------------------------------------------+
|椅子号(WORD)|主命令(WORD)|子命令(WORD)|具体游戏消息结构体|
+---------------------------------------------------------+
]]
-- 游戏记录
local recordCount = 0
local function decoderRecordBegin(decoder)
    if PlazaManager.recordManager == nil then
        PlazaManager.showTips("处理游戏录像出错")
        return
    end
    recordCount = 0
    PlazaManager.recordManager.recordList = {}
end

-- 解析第一条记录
local function decoderRerordData1(d)
    local args = {}
    args.dwTableOwnerUserID = d:readUInt32() -- 桌主 I D
    args.szRoomID = d:readUString(14) -- 房间编号
    args.cbGameRule = {}
    for i = 1, 100 do
        local cbRule = d:readUInt8()
        table.insert(args.cbGameRule, cbRule)
    end
    args.dwTurnCount = d:readUInt32() -- 已进行了几局游戏

    args.bEndGameRequest = d:readUInt8() == 1 -- 是否申请解散游戏
    args.dwRequestReply = {}
    for i = 1, 100 do
        args.dwRequestReply[i] = d:readUInt32() -- 申请解散状态 0,未处理；1，同意；2，不同意
    end

    args.lMinGameScore = d:readInt64() -- 最少入坐分数
    args.wJoinGamePeopleCount = d:readUInt16() -- 参加游戏的最大人数
    args.lCellScore = d:readInt64() -- 游戏底分
    args.cbGoldOrRoomCard = d:readUInt8()
    args.dwRoomCard = d:readUInt32() -- 消耗的房卡
    args.dwGoldID = d:readUInt32() -- 金币币种id
    args.dwBaseGold = d:readUInt32() -- 消耗的金币
    args.dwDrawCountLimit = d:readUInt32() -- 游戏总局数
    args.dwDrawTimeLimit = d:readUInt32() -- 游戏总时间
    args.dwTimeAfterBeginCount = d:readUInt32() -- 一局开始多长时间后解散桌子 单位秒
    args.dwTimeOffLineCount = d:readUInt32() -- 掉线多长时间后解散桌子  单位秒
    args.dwTimeNotBeginGame = d:readUInt32() -- 多长时间未开始游戏解散桌子	 单位秒
    args.dwTimeAfterCreateRoom = d:readUInt32() -- 私人房创建多长时间后无人坐桌解散桌子
    args.lRestrictScore = d:readInt64() -- 单局积分封顶数
    args.btMyself = d:readUInt8() -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    args.dwFamilyID = d:readUInt32() -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）
    args.lReward = d:readInt64() -- 最大赢家打赏，只有在为他人创建房间，并且是金币模式下才可用
    args.wContinueCount = d:readUInt16() -- 连续创建次数
    args.szDiscripTion1 = d:readUString(256 * 2)
    args.szDiscripTion2 = d:readUString(256 * 2)
    args.cbVideoMode = d:readUInt8() -- 1:视频游戏 0：非视频游戏
    args.dwElpase = math.floor(d:readInt32() / 1000) -- 解散剩余时间

    PlazaManager.recordManager.roomInfo = args
end

-- 解析第二条记录
local function decoderRerordData2(decoder)
    PlazaManager.recordManager.userCount = decoder:readUInt16() -- 游戏参与的人数
end

-- 解析玩家信息
local function decoderRecordGameUserInfo(d)
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

    print("gameUser.dwUserID == " .. gameUser.dwUserID)
    table.insert(PlazaManager.recordManager.userList, gameUser)
end

local function decoderRecord(decoder)
    if PlazaManager.recordManager == nil then
        PlazaManager.showTips("处理游戏录像出错")
        return
    end
    recordCount = recordCount + 1
    if recordCount == 1 then
        decoderRerordData1(decoder)
        decoder:release()
    elseif recordCount == 2 then
        decoderRerordData2(decoder)
        decoder:release()
    else
        local index = PlazaManager.recordManager.userCount + 3
        if recordCount < index then -- 解析玩家数据
            decoderRecordGameUserInfo(decoder)
        else
            -- 解析游戏记录
            table.insert(PlazaManager.recordManager.recordList, decoder)
        end
    end
end

local function decoderRecordEnd(decoder)
    print("游戏回放传送完毕")
    if PlazaManager.recordManager == nil then
        PlazaManager.showTips("处理游戏录像出错")
        return
    end

    PlazaManager.recordManager:onProcessRecord()
end

-- 绑定手机号成功
local function decoderBindPhoneSuccess(decoder)
    globalUserInfo.szRegisterMobile = decoder:readUString(GameDefine.LEN_MOBILE_PHONE * 2)
    game.sendEvent(GameDefine.BindPhoneSuccess)
    print("绑定手机号成功 == " .. globalUserInfo.szRegisterMobile)
    -- PlazaManager.showTips("绑定手机号成功")
end

-- 绑定手机号失败
local function decoderBindPhoneFailure(decoder)
    PlazaManager.closeWattingTips()

    local phone = decoder:readUString(GameDefine.LEN_MOBILE_PHONE * 2)
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.showTips(szDescribeString)
end

-- 解除绑定手机号成功
local function decoderUnBindPhoneSuccess(decoder)
    globalUserInfo.szRegisterMobile = ""
    game.sendEvent(GameDefine.UnBindPhoneSuccess)
    PlazaManager.closeWattingTips()
    print("解绑手机号成功")
    PlazaManager.showTips(LangCtrl:getLang().word242)
end

-- 解除绑定手机号失败
local function decoderUnBindPhoneFailure(decoder)
    PlazaManager.closeWattingTips()
    local phoneStr = decoder:readUString(GameDefine.LEN_MOBILE_PHONE * 2)
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.showTips(szDescribeString)
end

-- 查询绑定该手机号成功
local function decoderQurtyBindPhoneSuccess(decoder)
    local bBind = decoder:readUInt32()
    if bBind == 1 then
        game.sendEvent(GameDefine.CheckBindPhoneSuccess)
    else
        PlazaManager.closeWattingTips()
        PlazaManager.showTips(LangCtrl:getLang().word243)
    end
end
-- 查询绑定该手机号失败
local function decoderQurtyBindPhoneFailure(decoder)
    PlazaManager.closeWattingTips()
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.showTips(szDescribeString)
end

-- 通过手机号修改密码成功
local function decoderModifyLogonPassSuccess(decoder)
    game.sendEvent(GameDefine.ModifyLogonPassSuccess)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(LangCtrl:getLang().word176)
end
-- 通过手机号修改密码失败
local function decoderModifyLogonPassFailure(decoder)
    PlazaManager.closeWattingTips()
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    szDescribeString = GameUtil.filterMultMsg(szDescribeString)
    PlazaManager.showTips(szDescribeString)
end

-- 检测账号，昵称成功
local function decoderCheckAccountSucc(decoder)
    PlazaManager.closeWattingTips()
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息
    game.sendEvent(GameDefine.CheckLoginAccountSucc)
end

-- 检测账号，昵称失败  --xcj lResultCode = 8, 则szDescriberString前31 * 2长度存放的是新的推荐帐号
local function decoderCheckAccountFail(decoder)
    PlazaManager.closeWattingTips()
    local lResultCode = decoder:readUInt32() -- 错误代码
    local szDescribeString = decoder:readUString(128 * 2) -- 描述消息

    if lResultCode == 8 then
        PlazaManager.showTips(LangCtrl:getLang().word244 .. szDescribeString)
    else
        szDescribeString = GameUtil.filterMultMsg(szDescribeString)
        PlazaManager.showTips(szDescribeString)
    end
    game.sendEvent(GameDefine.CheckLoginAccountFail, lResultCode, szDescribeString)
end

function _M.onInit()
end

function _M.accept(name, modId, cmdId)
    if name == GameDefine.LOGIN_SOCKET then
        if modId == game.MDM_MB_LOGON or -- 手机登录命令
        modId == game.MDM_MB_SERVER_LIST or -- 列表命令
        modId == game.MDM_GP_USER_SERVICE or -- 用户命令
        modId == game.MDM_GP_LOGON or -- 广场登录
        modId == game.MDM_MB_PERSONAL_SERVICE or -- 包房命令
        modId == game.MDM_GP_SERVER_LIST then
            return true
        end
    end
    return false
end

function _M.process(name, modId, cmdId, decoder)
    -- 是否释放decoder
    local isRelease = true

    -- 是否关闭网络
    local isCloseNet = false

    if modId == game.MDM_GP_LOGON then -- 广场登录
        if cmdId == game.SUB_GP_UPDATE_NOTIFY then -- 升级提示
            decoderUpdate(decoder)
            isCloseNet = true
        elseif cmdId == game.SUB_GP_CHECK_SUCCESSS then -- 检测账号，昵称成功
            decoderCheckAccountSucc(decoder)
            isCloseNet = true
        elseif cmdId == game.SUB_GP_CHECK_FAILURE then -- 检测账号，昵称失败
            decoderCheckAccountFail(decoder)
            isCloseNet = true
        end
    elseif modId == game.MDM_MB_LOGON then -- 手机登录命令
        isCloseNet = _M.phoneLogin_MB_CMD(cmdId, decoder)
    elseif modId == game.MDM_MB_SERVER_LIST then -- 列表命令
        isCloseNet = _M.serverList_MB_CMD(cmdId, decoder)
    elseif modId == game.MDM_GP_USER_SERVICE then -- 用户命令
        isCloseNet = _M.userServeive_GP_CMD(cmdId, decoder)
    elseif modId == game.MDM_MB_PERSONAL_SERVICE then -- 私人房命令
        isCloseNet = _M.personalRoom_MB_CMD(cmdId, decoder)
    elseif modId == game.MDM_GP_SERVER_LIST then -- 广场列表命令
        isCloseNet = _M.serverList_GP_CMD(cmdId, decoder)
    else
        printLog("LoginModule", "错误命令 name=" .. name .. " modId=" .. modId .. " cmdId=" .. cmdId)
    end

    if isRelease == true then
        decoder:release()
    end

    if isCloseNet == true then
        PlazaManager.closeLoginSocket()
    end
end

-- 登录命令处理
function _M.phoneLogin_MB_CMD(cmdId, decoder)
    local isCloseNet = false
    if cmdId == game.SUB_MB_LOGON_SUCCESS then -- 登录成功
        onLoginSuccess(decoder)
    elseif cmdId == game.SUB_MB_LOGON_FAILURE then -- 登录失败
        isCloseNet = onLoginFailure(decoder)
    elseif cmdId == game.SUB_GP_LOGON_FINISH then -- 登录完成
        onLoginFinish(decoder)
    elseif cmdId == game.SUB_MB_LOAD_FAMILY_LIST_BEGIN then -- 家族列表开始
        onFamilyListBegin(decoder)
    elseif cmdId == game.SUB_MB_LOAD_FAMILY_LIST then -- 家族列表
        onFamilyList(decoder)
    elseif cmdId == game.SUB_MB_LOAD_FAMILY_LIST_END then -- 家族列表结束
        onFamilyListEnd(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_SELECT_FAMILY then -- 点亮家族
        onLitFamilyInfo(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_BINDWX_SUCCESS then -- 绑定微信成功
        onBindWXSuccess(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_BINDWX_FAILURE then -- 绑定微信失败
        onBindWXFailure(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_BINDACCOUNT_SUCCESS then -- 绑定账户成功
        onBindAccountSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_BINDACCOUNT_FAILURE then -- 绑定账户失败
        onBindAccountFailure(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_REMOVEACCOUNT_SUCCESS then -- 迁移成功
        onDataImportSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_REMOVEACCOUNT_FAILURE then -- 迁移失败
        onDataImportFailer(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_QUERYREMOVEACCOUNT_SUCCESS then -- 查询迁移成功
        onCheckDataImportSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_QUERYREMOVEACCOUNT_FAILURE then -- 查询迁移失败
        onCheckDataImportFailer(decoder)
        isCloseNet = false
    end

    return isCloseNet
end

-- 用户命令处理
function _M.userServeive_GP_CMD(cmdId, decoder)
    local isCloseNet = true
    print("用户命令处理  cmdId == " .. cmdId)
    if cmdId == game.SUB_GP_QUERY_INGAME_SEVERID then -- 检测是否卡在游戏中
        decoderIsGameServer(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_GP_USER_GOLD_TRANSFER then -- 用户用金币兑换商品
        decoderShop_PayByGoal(decoder)
    elseif cmdId == game.SUB_GP_USER_INSURE_LOGON_SUCCESS then -- 登录银行成功
        decoderLogonBank_succ(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_INSURE_LOGON_FAILURE then -- 登录银行失败
        decoderLogonBank_fail(decoder)
    elseif cmdId == game.SUB_GP_USER_INSURE_INFO then -- 查询银行资料成功
        decoderSeachBankInfoSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_INSURE_SUCCESS then -- 存取款银行成功
        decoderQueryBankInfo_succ(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_INSURE_FAILURE then -- 存取款银行失败
        decoderQueryBankInfo_fail(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_QUERY_USER_BASIC then -- 银行根据ID号查询用户成功
        decoderSeacherUserByIDSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_QUERY_USER_FAIL then -- 银行根据ID号查询用户失败
        decoderSeacherUserByIDFail(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_TRANSFER_SUCCESS then -- 银行赠送金币成功
        decoderBankTransferSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_OPERATE_FAILURE then -- 银行操作失败
        decoderBankOperateFailer(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_OPERATE_SUCCESS then -- 银行操作成功
        decoderBankOperateSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_TRANSFER_RECORD_RESULT then -- 银行接受用户转账记录
        decoderBankGiveRecord(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_TRANSFER_RECORD_FINISH then -- 银行接受用户转账完成
        decoderBankGiveRecordFinish(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_USER_RUNNINGACCOUNT_INFO then -- 银行查询或者提取流水返点成功
        decoderRunningAccountSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_MODIFY_INSURE_PASS_RESULT then -- 修改银行密码成功
        decoderModiBankPassword_succ(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_VERIFY_PASSWORD then -- 验证银行密码结果
        decoderBank_VerifyPassResult(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_SWITCH_PASSWORD then -- 返回密码类型转换结构
        decoderPassTypeChangeResult(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_GIVE_USER_ROOMCARD then -- 赠送房卡成功
        decoderRoomCardGiveSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_ANS_GIVE_ROOM_CARD_FAIL then -- 赠送房卡失败
        decoderRoomCardFail(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_ANS_EXC_ROOM_CARD_FAIL then -- 兑换房卡和金币失败
        decoderExcRoomCardFail(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_EXP_EXCHANGE_GOAL then -- 家族贡献值兑换金币成功
        decoderExpExchangeGoalSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_EXP_EXCHANGE_ROOMCARD then -- 家族贡献值兑换房卡成功
        decoderExpExchangeRoomCardSucc(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_GP_QUERY_INDIVIDUAL then -- 查询用户的金币,房卡，家族贡献点
        decoderUserInfoGoalMessage(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_SCORE_RECORD_START then -- 战绩开始
        decoderBattleBegin(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_SCORE_RECORD then -- 战绩
        decoderBattle(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_SCORE_RECORD_END then -- 战绩结束
        decoderBattleEnd(decoder)
    elseif cmdId == game.SUB_MB_USER_SCORE_DETAIL_START then -- 战绩明细开始
        decoderBattleDetailBegin(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_SCORE_DETAIL then -- 战绩详细信息
        decoderBattleDetail(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_USER_SCORE_DETAIL_END then -- 战绩明细结束
        decoderBattleDetailEnd(decoder)
    elseif cmdId == game.SUB_MB_OPERATE_SPEED_FAIL then -- 操作速度过快
        decoderOperateFailer(decoder)
    elseif cmdId == game.SUB_MB_MODIFYINDIVIDUAL_SUCCESS then -- 修改资料成功
        decoderModifyindSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_MODIFYINDIVIDUAL_FAILURE then -- 修改资料失败
        decoderModifyindFailer(decoder)
    elseif cmdId == game.SUB_MB_SHAREFRIENDS_SUCCESS then -- 分享成功
        decoderShareSuccess(decoder)
    elseif cmdId == game.SUB_MB_SHAREFRIENDS_FAILURE then -- 分享失败
        decoderShareFailer(decoder)
    elseif cmdId == game.SUB_MB_SEND_SMS_SUCCESS then -- 申请验证码成功
        decoderVerifyCodeSuccess(decoder)
    elseif cmdId == game.SUB_MB_SEND_SMS_FAILURE then -- 申请验证码失败
        decoderVerifyCodeFailer(decoder)
    elseif cmdId == game.SUB_MB_GIVE_ALMS_SUCCESS then -- 领取救济金成功
        decoderGiveAlmsSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_GIVE_ALMS_FAILURE then -- 领取救济金失败
        decoderGiveAlmsFailer(decoder)
        isCloseNet = true
    elseif cmdId == game.SUB_MB_GAME_RECORD_START then -- 录像数据开始
        decoderRecordBegin(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_GAME_RECORD then -- 录像数据
        isRelease = false
        decoderRecord(decoder)
    elseif cmdId == game.SUB_MB_GAME_RECORD_END then -- 录像数据结束
        decoderRecordEnd(decoder)
    elseif cmdId == game.SUB_MB_BIND_PHONE_SUCCESS then -- 绑定手机号成功
        decoderBindPhoneSuccess(decoder)
        isCloseNet = false
    elseif cmdId == game.SUB_MB_BIND_PHONE_FAILURE then -- 绑定手机号失败
        decoderBindPhoneFailure(decoder)
    elseif cmdId == game.SUB_MB_UNBIND_PHONE_SUCCESS then -- 解除绑定手机号成功
        decoderUnBindPhoneSuccess(decoder)
    elseif cmdId == game.SUB_MB_UNBIND_PHONE_FAILURE then -- 解除绑定手机号失败
        decoderUnBindPhoneFailure(decoder)
    elseif cmdId == game.SUB_MB_QUERY_BIND_PHONE_SUCCESS then -- 检查绑定手机成功
        decoderQurtyBindPhoneSuccess(decoder)
    elseif cmdId == game.SUB_MB_QUERY_BIND_PHONE_FAILURE then -- 检查绑定手机号失败
        decoderQurtyBindPhoneFailure(decoder)
    elseif cmdId == game.SUB_MB_MODIFY_LOGON_PASS_PHONE_SUCCESS then -- 通过手机号修改密码成功
        decoderModifyLogonPassSuccess(decoder)
    elseif cmdId == game.SUB_MB_MODIFY_LOGON_PASS_PHONE_FAILURE then -- 通过手机号修改密码失败
        decoderModifyLogonPassFailure(decoder)
    end
    return isCloseNet
end

-- 列表命令处理
function _M.serverList_MB_CMD(cmdId, decoder)
    local isCloseNet = false
    if cmdId == game.SUB_MB_LIST_SERVER then -- 房间数据
        decoderGameServer(decoder)
    elseif cmdId == game.SUB_MB_LIST_KIND then -- kind列表数据
        decoderGameListKind(decoder)
    elseif cmdId == game.SUB_MB_LIST_TYPE then -- 游戏种类列表数据
        decoderGameTypeListKind(decoder)
    elseif cmdId == game.SUB_MB_LIST_FINISH then -- 列表完成
        decoderGameListFinish(true)
    elseif cmdId == game.SUB_MB_LIST_WELCOME then -- 收到公告
        decoderListWelcome(decoder)
    end
    return isCloseNet
end

-- 私人房命令处理
function _M.personalRoom_MB_CMD(cmdId, decoder)
    local isCloseNet = false
    if cmdId == game.SUB_MB_QUERY_GAME_SERVER_RESULT then -- 查询房间返回
        decoderCheckGameServer(decoder)
    elseif cmdId == game.SUB_MB_SEARCH_RESULT then
        decoderSearchGameServer(decoder)
    elseif cmdId == game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT_BEGIN then -- 查询自己创建的私人房列表开始
        decoderSearchPersonalRoomListSart(decoder)
    elseif cmdId == game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT then -- 查询自己创建的私人房列表结果
        decoderSearchPersonalRoomList(decoder)
    elseif cmdId == game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT_END then -- 查询自己创建的私人房列表结束
        decoderSearchPersonalRoomListEnd(decoder)
    end
    return isCloseNet
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

local function dispatchMessage()
    if isDispatch == true then
        if dispatch_ing == false then
            dispatch_ing = true

            while (#messageList > 0) do
                local netData = messageList[1]
                table.remove(messageList, 1)
                if netData ~= nil then
                    _M.processMessage(netData.name, netData.modId, netData.cmdId, netData.decoder)
                end
            end

            dispatch_ing = false
        end
    end
end

-- 清空消息列表
local function clearMessageList()
    messageList = {}
end

-- 是否分发消息
function _M.setDispatchStatue(dispatchStatue)
    --    if dispatchStatue ~= nil and type(dispatchStatue) == "boolean" then
    --        isDispatch = dispatchStatue
    --    end
end

-- 注册分发消息
function _M.regSchedule()
    --    if loginSchedule == nil then
    --        print("注册消息=====")
    --        clearMessageList()
    --        loginSchedule = cc.Director:getInstance():getScheduler():scheduleScriptFunc(dispatchMessage,0,false)
    --        _M.setDispatchStatue(true)
    --    end
end

-- 卸载分发消息
function _M.unSchedule()
    --    if loginSchedule ~= nil then
    --        print("关闭注册消息=====")
    --        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(loginSchedule)
    --        loginSchedule = nil
    --        _M.setDispatchStatue(false)
    --    end
end

return _M
