-- region NewFile_1.lua
-- Author : admin
-- Date   : 2016/12/28
-- 此文件由[BabeLua]插件自动生成
cc.exports.PlazaManager = {}

local MessageBox = require "app.components.MessageBox"
local ProgressControl = require "app.components.ProgressControl"

-- **********************游戏参数*************************--

-- 同桌玩家ip地址
PlazaManager.userIP = nil

-- 游戏房间
PlazaManager.gameServer = nil

-- 游戏状态
PlazaManager.gameStatus = {
    cbGameStatus = 0, -- 游戏状态
    cbAllowLookon = 0 -- 旁观状态
}

-- 是否返回大厅
PlazaManager.isReturnHall = false

-- 游戏锁(登录成功向服务端获取赋值  游戏中收到断线消息赋值)
PlazaManager.lockKindID = 0
PlazaManager.lockServerID = 0

-- 房间锁 (进入房间设置  房间解散清除)
PlazaManager.lockRoomID = nil

-- 当前连接的房间
PlazaManager.curKindID = 0
PlazaManager.curServerID = 0
PlazaManager.curGameType = 0

-- 玩家退出游戏，不处理坐下消息
PlazaManager.lockGameServerSitMsg = 0

-- *******************************************************--

PlazaManager.isTestGame = false -- 是否测试版本
PlazaManager.isHotUpdate = false -- 是否开放热更新
PlazaManager.isCheck = true -- 是否审查版本

PlazaManager.tAllGameMap = {}
PlazaManager.tIsGameShowMap = {}

-- 当前平台
PlazaManager.platform = cc.Application:getInstance():getTargetPlatform()

-- 版本号
PlazaManager.VersionCode = 0
-- 版本名称
PlazaManager.VersionName = ""

if PlazaManager.platform == cc.PLATFORM_OS_ANDROID or PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
    PlazaManager.VersionCode = game.getDeviceVersionCode()
    PlazaManager.VersionName = game.getDeviceVersionName()
end

if PlazaManager.platform == cc.PLATFORM_OS_WINDOWS then
    PlazaManager.VersionCode = game.getWinVersionCode()
    PlazaManager.VersionName = game.getWinVersionName()
end

-- 进入前台时间
PlazaManager.appEnterBackgroundTime = 0
-- 登录方式
PlazaManager.loginType = GameDefine.LOGIN_TYPE.YK
-- 游戏服务器配置文件
PlazaManager.urlGameConfig = nil
-- 游戏本地配置文件
PlazaManager.localGameListResVersion = nil
-- 服务端发送过来强制关闭房间
PlazaManager.closeRoombyServer = 0
-- 服务端发送过来强制关闭游戏
PlazaManager.closeGamebyServer = 0

-- 大厅公告数据
PlazaManager.WelcomeCount = 0
PlazaManager.WelcomeDataList = {}
PlazaManager.GameWelcomeList = {}

-- 排行榜数据
PlazaManager.rankData = {}
PlazaManager.rankDataSelect = 0

-- 战绩数据
PlazaManager.battleData = {}

-- 分享邀请模式(1:赠送房卡分享  0：不赠送房卡分享)
PlazaManager.shareType = 0

-- 记录进入游戏时所打开的页面
PlazaManager.openHallLayerData = nil

-- ios信任模式
PlazaManager.isIosTrust = false

-- 是否是新手，如果是，则进行新手引导
PlazaManager.isNewPlayer = nil

-- 分享信息
PlazaManager.shareInfo = nil

-- 清除粘贴板信息(android有些机器下启动线程去清除 不同步)
PlazaManager.isClearCopyInfo = false

-- 游戏回放管理
PlazaManager.recordManager = nil

-- 游戏中换桌开始标志
PlazaManager.ChangeRoomStartChk = false

-- 大厅中是否已经弹出过绑定手机提示
PlazaManager.BindPhoneTipShowChk = false

-- 是否从游戏推出到大厅
PlazaManager.isGameOutHall = false

-- 大厅刷新时间
PlazaManager.hallRefreshTime = nil

-- *******************************************************--

local function JudgeIPString(ipStr)
    if type(ipStr) ~= "string" then
        return false
    end

    -- 判断长度
    local len = string.len(ipStr)
    if len < 7 or len > 15 then -- 长度不对
        return false
    end

    -- 判断出现的非数字字符
    local point = string.find(ipStr, "%p", 1) -- 字符"."出现的位置
    local pointNum = 0 -- 字符"."出现的次数 正常ip有3个"."
    while point ~= nil do
        if string.sub(ipStr, point, point) ~= "." then -- 得到非数字符号不是字符"."
            return false
        end
        pointNum = pointNum + 1
        point = string.find(ipStr, "%p", point + 1)
        if pointNum > 3 then
            return false
        end
    end
    if pointNum ~= 3 then -- 不是正确的ip格式
        return false
    end

    -- 判断数字对不对
    local num = {}
    for w in string.gmatch(ipStr, "%d+") do
        num[#num + 1] = w
        local kk = tonumber(w)
        if kk == nil or kk > 255 then -- 不是数字或超过ip正常取值范围了
            return false
        end
    end

    if #num ~= 4 then -- 不是4段数字
        return false
    end

    return true
end

-- 获取可写路径
function PlazaManager.getWritablePath()
    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. ".dwqpgame/"
    return storagePath
end

-- 是否录像模式
function PlazaManager.isRecordModule()
    local result = false
    if PlazaManager.recordManager ~= nil then
        result = true
    end
    return result
end

-- 是否手机平台
function PlazaManager.isPhoneAndPadPlatform()
    local result = false
    if PlazaManager.platform == cc.PLATFORM_OS_ANDROID or PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        result = true
    end
    return result
end

-- 获取配置文件更新地址
-- 所有马甲包更新全部一样 唯独读取的配置文件ganelist.json不一样  方便后期控制
function PlazaManager.getUpdateConfigUrl(isSpare)
    local result = ""
    --[[
    if PlazaManager.isPhoneAndPadPlatform() == true then
        local bundleID = game.getBundleID()
        if isSpare ~= nil and isSpare == true then
            if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
                bundleID = game.getBundleID() .. '.android'
            elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
                bundleID = game.getBundleID() .. '.ios'
            end
        end
        print('bundleID == ' .. bundleID)

        local url = GameDefine.platformUpdateUrl[bundleID]
        if url ~= nil then
            result = url
        end
    else
        local bundleID = 'test'

        result = GameDefine.platformUpdateUrl[bundleID]
    end
    --]]
    if PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD or PlazaManager.platform == cc.PLATFORM_OS_MAC then
        result = GameDefine.platformUpdateUrl["ios"]
    else -- cc.PLATFORM_OS_ANDROID or cc.PLATFORM_OS_WINDOWS
        result = GameDefine.platformUpdateUrl["android"]
    end

    return result
end

-- 获取ip地址
function PlazaManager.getLoginIP()
    local args = {}
    args.loginIp = GameDefine.loginIp
    args.loginPort = GameDefine.loginPort

    if GameDefine.isTestGame == true then
        args.loginIp = GameDefine.loginIp_test
        args.loginPort = GameDefine.loginPort_test
    end
    return args
end

function PlazaManager.accessPlayerIP(callback)
    --[[
    if LuaSocket then
        local ip, resolved = LuaSocket.dns.toip(LuaSocket.dns.gethostname())
        print("LuaSocket Access Player HostIP:", ip)
        rPrint(resolved)
        GameDefine.playerHostIPStr = ip
    end
    --]]
    local elaspe = os.time() - (PlazaManager.playerHostIPRefreshTime or 0)
    if elaspe > 300 or GameDefine.playerHostIPStr == nil then
        local xhr = cc.XMLHttpRequest:new()
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        -- "http://ip.myhostadmin.net"
        local url = PlazaManager.urlGameConfig.queryPlayerIP
        if url == nil or string.len(url) <= 3 then
            url = "http://www.net.cn/static/customercare/yourip.asp"
        end
        xhr:open("GET", url)

        local function onGetIP()
            GameDefine.playerHostIPStr = nil
            -- print("Access Player HostIP xhr.response--", xhr.readyState, xhr.status,  xhr.response)
            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                if type(xhr.response) == "string" then
                    for ipstr, _ in string.gmatch(xhr.response, ">(%d+.%d+.%d+.%d+)<") do
                        if JudgeIPString(ipstr) then
                            GameDefine.playerHostIPStr = ipstr
                            print("XMLHttpRequest Access Player HostIP ->", ipstr)
                        end
                    end
                end
            end

            if callback then
                callback(GameDefine.playerHostIPStr)
            end
            xhr:unregisterScriptHandler()
        end

        GameDefine.playerHostIPRefreshTime = os.time()
        xhr:registerScriptHandler(onGetIP)
        xhr:send()
    else
        if callback then
            callback(GameDefine.playerHostIPStr)
        end
    end
end

-- 第三方启动(app已经启动的情况下 会调用该方法)
function PlazaManager.onThirdStartResult(params)
    local data = PlazaManager.decoderAppStartParams()
    if data.token ~= nil then
        if data.token == "1" or data.token == "2" or data.token == "3" then
            print("第三方启动 data.token == " .. data.token)
            if data.zhAccount ~= nil and data.zhAccount ~= "" then
                cc.UserDefault:getInstance():setStringForKey("dq_c_account", data.zhAccount)
            end

            if data.zhPassword ~= nil and data.zhPassword ~= "" then
                cc.UserDefault:getInstance():setStringForKey("dq_c_password", data.zhPassword)
            end

            game.sendEvent(GameDefine.APP_THIRDSTART_SUCCESS)
        end
    end
end

function PlazaManager.isThirdStart()
    local result = false
    local data = PlazaManager.decoderAppStartParams()
    if data.token ~= nil then
        if data.token == "1" or data.token == "2" or data.token == "3" then
            result = true
        end
    end
    return result
end

-- 解析启动参数
function PlazaManager.decoderAppStartParams()
    local result = {}

    if PlazaManager.isPhoneAndPadPlatform() == true then
        local startParams = game.getAppStartParams()
        if startParams ~= nil and type(startParams) == "string" and string.len(startParams) > 0 then
            local roominfo = {}
            local data = {}

            printLog("PlazaManager", "解析启动参数decoderAppStartParams= " .. startParams)
            data = string.split(startParams, "&")

            if #data > 0 then
                local headData = data[1]
                local typeData = string.split(headData, "=")
                if #typeData == 2 then
                    if typeData[2] == "1" then -- 跳转传值
                        result.token = "1"
                        local paramsData = string.split(data[2], "=")
                        if #paramsData == 10 then
                            result.account = paramsData[1]
                            result.password = paramsData[2]
                            result.szMachineID = paramsData[3]
                            result.szMobilePhone = paramsData[4]
                            result.szCCFlags = paramsData[5]
                            result.szLoginFlags = paramsData[6]
                            result.dwGameID = paramsData[7]
                            result.szNickName = paramsData[8]
                            result.zhAccount = paramsData[9]
                            result.zhPassword = paramsData[10]
                        end
                    elseif typeData[2] == "2" then
                        result.token = "2"
                        result.account = data[2]
                    elseif typeData[2] == "3" then
                        result.token = "3"
                        local paramsData = string.split(data[2], "=")
                        if #paramsData == 2 then
                            result.zhAccount = paramsData[1]
                            result.zhPassword = paramsData[2]
                        end
                    end
                end
            end
        end
    end

    return result
end

-- 检查粘贴板信息
function PlazaManager.onCheckCopyRoomInfo(isCheck)
    local result = nil
    if PlazaManager.isPhoneAndPadPlatform() == true then
        local roominfo = game.systemPaste() -- 获取粘贴板信息
        if roominfo ~= nil and type(roominfo) == "string" and string.len(roominfo) > 25 then
            local roominfoStart = string.sub(roominfo, 1, 7)
            if roominfoStart == "房号[" then
                local roomid = string.sub(roominfo, 20, 25)
                if roomid ~= nil and string.len(roomid) == 6 then
                    result = roomid
                    printLog("PlazaManager", "onCheckCopyRoomInfo:id == " .. roomid)
                    if isCheck == true then
                        if PlazaManager.checkCopyRoomID(roomid) == false then
                            result = roomid
                        end
                    end
                end
            end
        end
    end
    return result
end

-- 前后台切换
function PlazaManager.appEnterBackground(isEnterBackground)
    PlazaManager.isClearCopyInfo = false
    if isEnterBackground == true then
        printLog("PlazaManager", "app切换到后台11")
    else
        PlazaManager.closeWattingTips()
        PlazaManager.appEnterBackgroundTime = os.time()
        printLog("PlazaManager", "app切换到前台22")
    end
    game.sendEvent(GameDefine.APP_ENTERBACKGROUND, isEnterBackground)
end

-- 获取本地游戏版本
function PlazaManager.getLocalGameVersion()
    -- 读取本地游戏配置
    local gameResVersion = {}
    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        PlazaManager.tAllGameMap[var.kindid] = var

        if PlazaManager.isCheck then
            if var.isCheckShow == 1 then
                PlazaManager.tIsGameShowMap[var.kindid] = var.isSkipShow ~= 1
            end
        else
            PlazaManager.tIsGameShowMap[var.kindid] = var.isSkipShow ~= 1
        end

        local game = {}
        game.kindid = var.kindid
        game.version = "0"

        local path = "game/" .. var.name
        if cc.FileUtils:getInstance():isDirectoryExist(path) == false then
            local storagePath = PlazaManager.getWritablePath()
            cc.FileUtils:getInstance():createDirectory(storagePath .. "res/game/" .. var.name)
            local str = "{\n\"packageUrl\" : \"%s\",\n\"remoteManifestUrl\" : \"%s\",\n\"remoteVersionUrl\" : \"%s\",\n\"version\" : \"0\"\n}\n"
            local fileStr = string.format(str, var.packageUrl, var.remoteManifestUrl, var.remoteVersionUrl)

            local path1 = storagePath .. "res/game/" .. var.name .. "/version.manifest"
            local path2 = storagePath .. "res/game/" .. var.name .. "/project.manifest"
            cc.FileUtils:getInstance():writeStringToFile(fileStr, path1)
            cc.FileUtils:getInstance():writeStringToFile(fileStr, path2)
        else
            if cc.FileUtils:getInstance():isFileExist(path .. "/project.manifest") == true then
                local gameRes = cc.FileUtils:getInstance():getStringFromFile(path .. "/project.manifest")
                if type(gameRes) == "string" and string.len(gameRes) > 0 then
                    local versionData = json.decode(gameRes)
                    if versionData ~= nil and versionData.version ~= nil then
                        game.version = versionData.version
                    end
                end
            end
        end

        table.insert(gameResVersion, game)
    end

    -- 本地配置
    PlazaManager.localGameListResVersion = gameResVersion
end

function PlazaManager.syncUrl2Manifest(project_manifest, version_manifest, kindid, urlGameConfig)
    local packageUrl = nil
    local remoteManifestUrl = nil
    local remoteVersionUrl = nil

    if kindid == "hallupdateurl" then
        if urlGameConfig and urlGameConfig.hallupdateurl then
            packageUrl = urlGameConfig.hallupdateurl.packageUrl
            remoteManifestUrl = urlGameConfig.hallupdateurl.remoteManifestUrl
            remoteVersionUrl = urlGameConfig.hallupdateurl.remoteVersionUrl
        end
    else
        if urlGameConfig and urlGameConfig.list then
            for key, var in ipairs(urlGameConfig.list) do
                if var.kindid == kindid then
                    packageUrl = var.packageUrl
                    remoteManifestUrl = var.remoteManifestUrl
                    remoteVersionUrl = var.remoteVersionUrl
                    break
                end
            end
        end
    end

    if packageUrl == nil or remoteManifestUrl == nil or remoteVersionUrl == nil then
        print("sync manifest skip, url error:", packageUrl, remoteManifestUrl, remoteVersionUrl)
        return
    end

    local storagePath = PlazaManager.getWritablePath()
    if project_manifest and cc.FileUtils:getInstance():isFileExist(project_manifest) == true then
        local manifest_data = cc.FileUtils:getInstance():getStringFromFile(project_manifest)
        if type(manifest_data) == "string" and string.len(manifest_data) > 0 then
            local versionData = json.decode(manifest_data)
            if versionData ~= nil then
                versionData.packageUrl = packageUrl
                versionData.remoteManifestUrl = remoteManifestUrl
                versionData.remoteVersionUrl = remoteVersionUrl
                local fileStr = json.encode(versionData)
                local path = storagePath .. "res/" .. project_manifest
                cc.FileUtils:getInstance():writeStringToFile(fileStr, path)
                print("synchronized project manifest path1=====>:", path)
                print("write file data1----->:", fileStr)
            end
        end
    else
        -- local str = '{\n"packageUrl" : "%s",\n"remoteManifestUrl" : "%s",\n"remoteVersionUrl" : "%s",\n"version" : "0","mainVersion" : "1.0.0","engineVersion" : "3.16","assets" : {}, "searchPaths" : []\n}\n'
        local str = "{\n\"packageUrl\" : \"%s\",\n\"remoteManifestUrl\" : \"%s\",\n\"remoteVersionUrl\" : \"%s\",\n\"version\" : \"0\"\n}\n"
        local fileStr = string.format(str, packageUrl, remoteManifestUrl, remoteVersionUrl)
        local path = storagePath .. "res/" .. project_manifest
        cc.FileUtils:getInstance():writeStringToFile(fileStr, path)
        print("synchronized project manifest path2=====>:", path)
        print("write file data2----->:", fileStr)
    end

    if version_manifest and cc.FileUtils:getInstance():isFileExist(version_manifest) == true then
        local manifest_data = cc.FileUtils:getInstance():getStringFromFile(version_manifest)
        if type(manifest_data) == "string" and string.len(manifest_data) > 0 then
            local versionData = json.decode(manifest_data)
            if versionData ~= nil then
                versionData.packageUrl = packageUrl
                versionData.remoteManifestUrl = remoteManifestUrl
                versionData.remoteVersionUrl = remoteVersionUrl
                local fileStr = json.encode(versionData)
                local path = storagePath .. "res/" .. version_manifest
                cc.FileUtils:getInstance():writeStringToFile(fileStr, path)
                print("synchronized version manifest path1=====>:", path)
                print("write file data1----->:", fileStr)
            end
        end
    else
        -- local str = '{\n"packageUrl" : "%s",\n"remoteManifestUrl" : "%s",\n"remoteVersionUrl" : "%s",\n"version" : "0","mainVersion" : "1.0.0","engineVersion" : "3.16"\n}\n'
        local str = "{\n\"packageUrl\" : \"%s\",\n\"remoteManifestUrl\" : \"%s\",\n\"remoteVersionUrl\" : \"%s\",\n\"version\" : \"0\"\n}\n"
        local fileStr = string.format(str, packageUrl, remoteManifestUrl, remoteVersionUrl)
        local path = storagePath .. "res/" .. version_manifest
        cc.FileUtils:getInstance():writeStringToFile(fileStr, path)
        print("synchronized version manifest path2=====>:", path)
        print("write file data2----->:", fileStr)
    end
end

-- 检查删除游戏
function PlazaManager.checkGameisRemove()
    cc.FileUtils:getInstance():setSearchPaths({})

    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("src/game/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/")

    -- 查找安装目录下的游戏版本
    local localGameVersion = {}
    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        local path = "game/" .. var.name .. "/project.manifest"
        if cc.FileUtils:getInstance():isFileExist(path) == true then
            local game = {}
            game.kindid = var.kindid
            game.version = "0"
            game.path = nil

            local gameRes = cc.FileUtils:getInstance():getStringFromFile(path)
            if type(gameRes) == "string" and string.len(gameRes) > 0 then
                local versionData = json.decode(gameRes)
                if versionData ~= nil and versionData.version ~= nil then
                    game.version = versionData.version
                end
            end

            table.insert(localGameVersion, game)
        end
    end

    cc.FileUtils:getInstance():setSearchPaths({})

    local storagePath = PlazaManager.getWritablePath()
    cc.FileUtils:getInstance():addSearchPath(storagePath .. "res/")
    cc.FileUtils:getInstance():addSearchPath(storagePath .. "res/base/")
    cc.FileUtils:getInstance():addSearchPath(storagePath .. "res/base/app/")
    cc.FileUtils:getInstance():addSearchPath(storagePath .. "res/game/")
    cc.FileUtils:getInstance():addSearchPath(storagePath)

    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("src/game/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/")

    -- 查找可写目录下的游戏版本
    local localWritableGameVersion = {}
    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        local path = storagePath .. "res/game/" .. var.name .. "/project.manifest"
        if cc.FileUtils:getInstance():isFileExist(path) == true then
            local game = {}
            game.kindid = var.kindid
            game.version = "0"
            game.path = storagePath .. "res/game/" .. var.name

            local gameRes = cc.FileUtils:getInstance():getStringFromFile(path)
            if type(gameRes) == "string" and string.len(gameRes) > 0 then
                local versionData = json.decode(gameRes)
                if versionData ~= nil and versionData.version ~= nil then
                    game.version = versionData.version
                end
            end

            table.insert(localWritableGameVersion, game)
        end
    end

    -- 版本比较
    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        local localVersion = nil
        local writableVersion = nil
        for key_local, var_local in pairs(localGameVersion) do
            if var.kindid == var_local.kindid then
                localVersion = var_local.version
                break
            end
        end

        for key_writable, var_writable in pairs(localWritableGameVersion) do
            if var.kindid == var_writable.kindid then
                writableVersion = var_writable.version
                break
            end
        end

        if localVersion ~= nil and writableVersion ~= nil then
            printLog("PlazaManager", "checkGameisRemove:var.kindid == " .. var.kindid .. "  localVersion == " .. localVersion .. "   writableVersion == " .. writableVersion)
            local localVersion_number = tonumber(localVersion)
            local writableVersion_number = tonumber(writableVersion)

            if localVersion_number ~= nil and writableVersion_number ~= nil then
                if writableVersion_number <= localVersion_number then
                    -- 删除可写目录下的游戏信息
                    local deletePath = nil
                    for key_writable_1, var_writable_1 in pairs(localWritableGameVersion) do
                        if var.kindid == var_writable_1.kindid then
                            deletePath = var_writable_1.path
                            break
                        end
                    end

                    if deletePath ~= nil then
                        printLog("PlazaManager", "checkGameisRemove:deletePath == " .. deletePath)
                        local deleteSuccess = cc.FileUtils:getInstance():removeDirectory(deletePath)
                        if deleteSuccess == true then
                            printLog("PlazaManager", "checkGameisRemove:deletePath == success")
                        end
                    end
                end
            end
        end
    end
end

function PlazaManager.randomStr(len)
    -- math.randomseed(os.time())
    local rankStr = ""
    for i = 1, len do
        local randNum = math.random(1, 3)
        if randNum == 1 then
            randNum = string.char(math.random(0, 25) + 65)
        elseif randNum == 2 then
            randNum = string.char(math.random(0, 25) + 97)
        else
            randNum = math.random(0, 9)
        end
        rankStr = rankStr .. randNum
    end
    return rankStr
end

function PlazaManager.initDeviceUUID()
    local uuid = ""
    if PlazaManager.platform == cc.PLATFORM_OS_WINDOWS then
        uuid = game.getMACaddress()
    else
        uuid = cc.UserDefault:getInstance():getStringForKey("DeviceUUIDInfo", "")
        if uuid == "" and game.getDeviceUUID then
            uuid = game.getDeviceUUID()
            cc.UserDefault:getInstance():setStringForKey("DeviceUUIDInfo", uuid)
        end
    end

    if uuid == "" then
        uuid = PlazaManager.randomStr(30)
        cc.UserDefault:getInstance():setStringForKey("DeviceUUIDInfo", uuid)
    end

    GameDefine.MachineID = uuid
end

function PlazaManager.init(args)
    cc.FileUtils:getInstance():purgeCachedEntries() -- 清理搜索文件缓存，一般是更新资源后进行搜索前调用

    cc.exports.LangCtrl = require("app.platform.lang.LangCtrl").new()
    require "app.platform.data.ServerListData"
    require "app.platform.modules.ModuleMgr"
    require "app.win.loading.LoadingManager"

    local Logger = require "app.components.Logger"

    -- 日志系统
    local log = Logger:new(Logger)
    cc.log = handler(log, log.print)

    ModuleMgr.registerAll()
    -- 初始化游戏音效
    MusicManager.onInit()

    -- 设置访问属性统计url
    game.setTongjiUrl(GameDefine.tongjiUrl)

    game.targetPlatform = cc.Application:getInstance():getTargetPlatform()

    PlazaManager.initDeviceUUID()

    if game.getDeviceVersionCode then
        PlazaManager.VersionCode = game.getDeviceVersionCode()
    else
        PlazaManager.VersionCode = 0
    end

    if game.getDeviceVersionName then
        PlazaManager.VersionName = game.getDeviceVersionName()
    else
        PlazaManager.VersionName = ""
    end

    -- 设置图片压缩的最大和最小
    if game.setImageDataSize then
        game.setImageDataSize(1024 * 1024 * 1, 1024 * 200)
    end

    -- 设置第三方启动通知
    if PlazaManager.isPhoneAndPadPlatform() == true then
        game.setThirdStartNotify(PlazaManager.onThirdStartResult)
    end

    -- 设置app前后台切换通知
    game.appEnterBackgroundNotify(PlazaManager.appEnterBackground)

    -- 初始化录音
    if PlazaManager.isPhoneAndPadPlatform() == true then
        -- 设置web文件查询url
        if game.setSearchFileUrl then
            game.setSearchFileUrl(GameDefine.Chat_SearchFileUrl)
        end
        -- 录音初始化数据

        if game.setVoiceRecordCompleteCallback then
            game.setVoiceRecordCompleteCallback(function(error, duration, filePath)
                game.sendEvent("record_complete", error, duration, filePath)
            end)
        end

        if game.setVoicePlayCompleteCallback then
            game.setVoicePlayCompleteCallback(function(error, filePath)
                MusicManager.resumeBGM()
                MusicManager.refreshBGMVolume()
                game.sendEvent("record_play_complete", error, filePath)
            end)
        end
    end

    -- 游戏配置
    PlazaManager.urlGameConfig = args

    -- 判断是否安装微信
    local isInstallWX = false
    if PlazaManager.isPhoneAndPadPlatform() == true then
        if game.getIsWXAppInstalled() == true and game.getIsWXAppSupportApi() == true then
            isInstallWX = true
        end
    elseif game.targetPlatform == cc.PLATFORM_OS_WINDOWS or game.targetPlatform == cc.PLATFORM_OS_MAC then
        isInstallWX = true
    end
    PlazaManager.isInstallWeiXin = isInstallWX

    local isUpdate = false
    local isTest = false
    local isCheck = false

    if game.targetPlatform == cc.PLATFORM_OS_ANDROID then -- android
        if PlazaManager.urlGameConfig.androidUpdate == 1 then
            isUpdate = true
        end
        if PlazaManager.urlGameConfig.androidCheck == 1 then
            isCheck = true
        end
        if PlazaManager.urlGameConfig.androidTest == 1 then
            isTest = true
        end
    elseif game.targetPlatform == cc.PLATFORM_OS_IPHONE or game.targetPlatform == cc.PLATFORM_OS_IPAD then -- ios
        if PlazaManager.urlGameConfig.iosUpdate == 1 then
            isUpdate = true
        end
        if PlazaManager.urlGameConfig.iosCheck == 1 then
            isCheck = true
        end
        if PlazaManager.urlGameConfig.iosTest == 1 then
            isTest = true
        end
    elseif game.targetPlatform == cc.PLATFORM_OS_MAC or game.targetPlatform == cc.PLATFORM_OS_WINDOWS then -- windows
        if PlazaManager.urlGameConfig.windowsUpdate == 1 then
            isUpdate = true
        end
        if PlazaManager.urlGameConfig.iosCheck == 1 then
            isCheck = true
        end
        if PlazaManager.urlGameConfig.windowsTest == 1 then
            isTest = true
        end
    end

    -- 是否开放热更新
    PlazaManager.isHotUpdate = isUpdate

    -- 是否检查版本
    PlazaManager.isCheck = isCheck
    if PlazaManager.isCheck ~= true then
        GameDefine.waitTime = 7
    end

    -- 是否测试版本
    PlazaManager.isTestGame = isTest

    -- 检查本地游戏
    PlazaManager.checkGameisRemove()

    -- 获取本地游戏版本
    PlazaManager.getLocalGameVersion()

    -- 键盘监听
    PlazaManager.onKeyboardListener()

    PlazaManager.accessPlayerIP()

    GameDefine.IPGroupCount = PlazaManager.urlGameConfig.IPGroupCount or 4
    if PlazaManager.urlGameConfig.hostlists ~= nil and string.len(PlazaManager.urlGameConfig.hostlists) > 2 then
        PlazaManager.urlGameConfig.hostlists = string.gsub(PlazaManager.urlGameConfig.hostlists, " ", "")
        local list = string.split(PlazaManager.urlGameConfig.hostlists, "||")
        if list ~= nil and #list > 0 then
            GameDefine.hostlists = list
        end
    end

    if PlazaManager.urlGameConfig.iplists ~= nil and string.len(PlazaManager.urlGameConfig.iplists) > 4 then
        PlazaManager.urlGameConfig.iplists = string.gsub(PlazaManager.urlGameConfig.iplists, " ", "")
        local ipDataList = string.split(PlazaManager.urlGameConfig.iplists, "=")
        if ipDataList and #ipDataList > 0 then
            GameDefine.loginIp = PlazaManager.replaceSpecialHost(ipDataList)
        end
    end

    if PlazaManager.urlGameConfig.confineiplists ~= nil and string.len(PlazaManager.urlGameConfig.confineiplists) > 4 then
        PlazaManager.urlGameConfig.confineiplists = string.gsub(PlazaManager.urlGameConfig.confineiplists, " ", "")
        local ipDataList = string.split(PlazaManager.urlGameConfig.confineiplists, "=")
        if ipDataList and #ipDataList > 0 then
            GameDefine.ConfineIPList = PlazaManager.replaceSpecialHost(ipDataList)
        end
    end

    if PlazaManager.urlGameConfig.portlists ~= nil and string.len(PlazaManager.urlGameConfig.portlists) > 0 then
        PlazaManager.urlGameConfig.portlists = string.gsub(PlazaManager.urlGameConfig.portlists, " ", "")
        local portlists = string.split(PlazzManager.urlGameConfig.portlists, "=")
        if portlists ~= nil then
            local tempPortTable = {}
            local a_port
            for key, value in ipairs(portlists) do
                a_port = tonumber(value)
                if a_port then
                    table.insert(tempPortTable, a_port)
                end
            end

            if #tempPortTable > 0 then
                GameDefine.loginPort = tempPortTable
            end
        end
    end
end

function PlazaManager.replaceSpecialHost(ips)
    local num = #GameDefine.hostlists
    -- print("============GameDefine.hostlists===========")
    -- rPrint(GameDefine.hostlists)
    -- print("=================ips==================")
    -- rPrint(ips)

    if type(ips) == "table" then
        for k = #ips, 1, -1 do
            if ips[k] == "1.1.1.1" then
                if num > 0 then
                    ips[k] = GameDefine.hostlists[1]
                else
                    table.remove(ips, k)
                end
            elseif ips[k] == "2.2.2.2" then
                if num > 1 then
                    ips[k] = GameDefine.hostlists[2]
                else
                    table.remove(ips, k)
                end
            elseif ips[k] == "3.3.3.3" then
                if num > 2 then
                    ips[k] = GameDefine.hostlists[3]
                else
                    table.remove(ips, k)
                end
            end
        end
    elseif type(ips) == "string" then
        if ips == "1.1.1.1" then
            if num > 0 then
                ips = GameDefine.hostlists[1]
            end
        elseif ips == "2.2.2.2" then
            if num > 1 then
                ips = GameDefine.hostlists[2]
            end
        elseif ips == "3.3.3.3" then
            if num > 2 then
                ips = GameDefine.hostlists[3]
            end
        end
    end

    -- print("=================ips result==================")
    -- rPrint(ips)
    return ips
end

-- 多通道TCP连接时，过滤掉部分通道IP不发起连接
function PlazaManager.confineIPList(ips)
    if type(ips) == "table" then
        for _, aa in pairs(GameDefine.ConfineIPList) do
            for kk = #ips, 1, -1 do
                if ips[kk] == aa then
                    table.remove(ips, kk)
                    print("ConfineIPList ==> remove ip:", kk, aa)
                end
            end
        end
    end
    return ips
end

function PlazaManager.checkIPPortEqual(ips, ports)
    local num = #ips - #ports
    if num < 0 then
        for ii = 1, math.abs(num) do
            table.remove(ports)
        end
    elseif num > 0 then
        for ii = 1, math.abs(num) do
            table.remove(ips)
        end
    end

    num = #ips - #ports
end

function PlazaManager.setLockData(kindid, serverid, roomid)
    PlazaManager.lockKindID = kindid
    PlazaManager.lockServerID = serverid
    PlazaManager.lockRoomID = roomid
end

function PlazaManager.clearLockData()
    PlazaManager.lockKindID = 0
    PlazaManager.lockServerID = 0
    PlazaManager.lockRoomID = nil
end

-- 是否卡在游戏中
function PlazaManager.isLock()
    local result = false
    if PlazaManager.lockKindID > 0 and PlazaManager.lockServerID > 0 then
        result = true
    end
    return result
end

-- 游戏场景是否打开
PlazaManager.isOpenGameScene = false

-- 是否默认打开大厅
PlazaManager.isDefaultOpenHall = true

-- 是否玩家自己被服务器踢出房间
PlazaManager.isOutGameRoomByServer = false

-- 包房信息
local _privateInfo = {}

function PlazaManager.isSendGameServerPackage()
    local result = false
    if PlazaManager.gameServer ~= nil then
        result = true
    end
    return result
end

function PlazaManager.resetRoomServer()
    PlazaManager.gameServer = nil
    PlazaManager.resetPrivateInfo()
    PlazaManager.gameStatus.cbAllowLookon = 0
    PlazaManager.gameStatus.cbGameStatus = 0
end

function PlazaManager.getPrivateInfo()
    return _privateInfo
end

function PlazaManager.resetPrivateInfo()
    _privateInfo.szRoomID = "0" -- 房间编号
    _privateInfo.dwTableOwnerUserID = 0 -- 开房者
    _privateInfo.dwDrawCountLimit = 0 -- 游戏总局数
    _privateInfo.dwDrawTimeLimit = 0 -- 游戏总时间 单位秒
    _privateInfo.lCellScore = 0 -- 游戏底分
    _privateInfo.cbGameRule = nil -- 游戏规则
    _privateInfo.wJoinGamePeopleCount = 0 -- 游戏人数
    _privateInfo.lMinGameScore = 0 -- 最少入座分数
    _privateInfo.cbGoldOrRoomCard = 0 -- 消耗金币还是房卡 0房卡 1金币
    _privateInfo.dwGoldID = 0 -- 金币id
    _privateInfo.dwBaseGold = 0 -- 消耗的金币
    _privateInfo.dwRoomCard = 0 -- 消耗的房卡
    _privateInfo.dwTurnCount = 0 -- 已经玩的局数
    _privateInfo.bGameStart = false -- 是否已经开始游戏
    _privateInfo.dwServerTimeBegin = 0 -- 服务端开始时间
    _privateInfo.dwServerRunTime = 0 -- 服务端运行时间
    _privateInfo.dwLocalRunTime = 0 -- 本地运行时间
    _privateInfo.bEndGameRequest = false -- 是否申请解散时间
    _privateInfo.dwRequestReply = {} -- 申请解散状态
    _privateInfo.dwElpase = 0 -- 申请解散剩余时间
    _privateInfo.cbGameRule = nil
    _privateInfo.lRestrictScore = 0 -- 单局积分封顶数
    _privateInfo.btMyself = 1 -- 1:自己创建房间 0：给他人创建房间（只允许房卡模式）
    _privateInfo.dwFamilyID = 0 -- 0:没有限制，非0：只允许这个家族成员加入或者房主加入（只有家族族长或者家族管理员可以设定）
    _privateInfo.cbVideoMode = 0 -- 1:视频房 0:非视频房
end

function PlazaManager.getGameRemainTime()
    if _privateInfo == nil then
        return 0
    end

    local dwDrawTimeLimit = _privateInfo.dwDrawTimeLimit
    local dwServerRunTime = _privateInfo.dwServerRunTime
    local dwLocalRunTime = _privateInfo.dwLocalRunTime

    local remainTime = dwDrawTimeLimit - dwServerRunTime - dwLocalRunTime
    return remainTime
end

-- 是否最后一局游戏
function PlazaManager.isLastCount()
    if _privateInfo.dwDrawCountLimit <= _privateInfo.dwTurnCount then
        return true
    end
    return false
end

-- 金币场还是房卡场
function PlazaManager.isRoomCard()
    if _privateInfo.cbGoldOrRoomCard == 0 then
        return true
    end
    return false
end

-- 等待提示
PlazaManager.waitingTips = nil
function PlazaManager.closeWattingTips()
    if PlazaManager.waitingTips ~= nil then
        PlazaManager.waitingTips:close()
        PlazaManager.waitingTips = nil
    end
end

function PlazaManager.setWattingData(text, time, callback)
    if PlazaManager.waitingTips ~= nil then
        PlazaManager.waitingTips:setData(text, time, callback)
    end
end

function PlazaManager.showWattingTips(tips, time, callback, contentNode, isShowTips)
    PlazaManager.closeWattingTips()

    local function wattingNotufy()
        if callback ~= nil and type(callback) == "function" then
            callback()
        end
    end

    if isShowTips == true then
        PlazaManager.waitingTips = MessageBox.showConnection(tips, time, wattingNotufy, 0, contentNode)
    else
        PlazaManager.waitingTips = MessageBox.showConnection("", time, wattingNotufy, 0, contentNode)
    end
    -- PlazaManager.waitingTips:registerScriptHandler(function(state)
    --    if state == "exit" then
    --        PlazaManager.waitingTips = nil
    --    end
    --    end)
end

function PlazaManager.showTips(tips, pos)
    if tips and string.len(tips) > 0 then
        MessageBox.showTips(tips, nil, pos) -- cc.RED
    else
        print("PlazaManager.showTips error tips = nil")
    end
end

function PlazaManager.showConfirmNode(types, msg, contentNode, callback, titleStr, fntPath, name, fontsize)
    MessageBox.confirmNode(types, msg, contentNode, callback, titleStr, fntPath, name, fontsize)
end

function PlazaManager.checkGameVersion(kindid)
    local version = nil
    local urlVersion = nil

    -- 服务端
    if PlazaManager.urlGameConfig ~= nil then
        for key, var in ipairs(PlazaManager.urlGameConfig.list) do
            if kindid == var.kindid then
                urlVersion = var.version
                break
            end
        end
    end

    -- 本地
    if PlazaManager.localGameListResVersion ~= nil then
        for key, var in ipairs(PlazaManager.localGameListResVersion) do
            if kindid == var.kindid then
                version = var.version
                break
            end
        end
    end

    -- 审核中或者关闭热更新 不更新游戏
    if PlazaManager.isCheck == true or PlazaManager.isHotUpdate == false then
        return GameDefine.GAME_UPDATE_STATUE.NORMAL
    end

    if version == nil or urlVersion == nil then
        return GameDefine.GAME_UPDATE_STATUE.ERROR -- 出错
    end

    if version == "0" then
        return GameDefine.GAME_UPDATE_STATUE.NeverDownloaded -- 没下载游戏
    end

    printLog("PlazaManager", "checkGameVersion kindid =  " .. kindid .. "version ==" .. version .. "  urlVersion == " .. urlVersion)

    if version == urlVersion then
        return GameDefine.GAME_UPDATE_STATUE.NORMAL
    else
        return GameDefine.GAME_UPDATE_STATUE.UPDATE
    end

    return GameDefine.GAME_UPDATE_STATUE.UPDATE
end

function PlazaManager.onLoginLockServer(ServerID)
    -- 获取房间

    local tagGameServer = nil
    if ServerID == nil then
        tagGameServer = ServerListData.getGameServerByServerID(PlazaManager.lockServerID)
    else
        tagGameServer = ServerListData.getGameServerByServerID(ServerID)
    end

    if tagGameServer == nil then
        PlazaManager.showTips(LangCtrl:getLang().word310)
        return
    end

    -- 连接服务器超时
    local function onConnectOutTime()
        PlazaManager.closeGameSocket()
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()

        PlazaManager.closeWattingTips()
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word311, nil, nil)
    end

    local function onConnectResult(isSuccess, ipsCount)
        if isSuccess == false then
            if ipsCount > 0 then
                PlazaManager.setWattingData(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
            else
                PlazaManager.showTips(LangCtrl:getLang().word246)
            end
        else
            PlazaManager.setWattingData(LangCtrl:getLang().word250, GameDefine.processTime, onConnectOutTime, nil, true)
        end
    end

    local isUpdateStatue = PlazaManager.checkGameVersion(tagGameServer.wKindID)
    if isUpdateStatue == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatue == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        local function onDownloadCallback(result, kindid)
            if result == true then
                PlazaManager.showWattingTips(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
                local args = {}
                args.tagGameServer = tagGameServer
                args.paramsData = nil
                PlazaManager.getServerModule().onConnectionGR(args, onConnectResult)
            end
        end

        local function onDownloadGame(isOk)
            if isOk == true then
                PlazaManager.onDownloadGame(tagGameServer.wKindID, onDownloadCallback)
            end
        end

        PlazaManager.closeWattingTips()
        PlazaManager.showConfirmNode("yes_no", LangCtrl:getLang().word236, nil, onDownloadGame)
        return
    end

    PlazaManager.showWattingTips(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
    local args = {}
    args.tagGameServer = tagGameServer
    args.paramsData = nil
    PlazaManager.getServerModule().onConnectionGR(args, onConnectResult)
end

function PlazaManager.onDownloadLockGame(dwKindID)
    local function onDownloadCallback(result, kindid)
        if result == true then
            PlazaManager.onLoginLockServer()
        end
    end

    local function onDownloadGame(isOk)
        if isOk == true then
            PlazaManager.onDownloadGame(dwKindID, onDownloadCallback)
        end
    end
    PlazaManager.showConfirmNode("yes_no", LangCtrl:getLang().word236, nil, onDownloadGame)
end

function PlazaManager.addIPV6Address()
    ServerListData.addIPV6Address()
end

function PlazaManager.getActiveFamily()
    if PlazaManager.familyInfo ~= nil and PlazaManager.familyInfo.count > 0 then
        for key, var in ipairs(PlazaManager.familyInfo.familyList) do
            if var.wIsActive == 1 then
                return var
            end
        end
    end

    return nil
end

function PlazaManager.checkUserIP(count)
    local result = false
    local ips = {}
    if PlazaManager.userIP == nil then
        return result
    end
    if type(PlazaManager.userIP) ~= "table" then
        return result
    end

    for i = 1, count do
        local ip = PlazaManager.userIP[i]
        if ip ~= nil and #ip > 0 then
            table.insert(ips, ip)
        end
    end

    local len = #ips
    if len > 0 then
        for i = 1, len - 1 do
            if ips[i] == ips[i + 1] then
                result = true
                break
            end
        end
    end

    return result
end

-- 获取LoginModule
function PlazaManager.getLoginModule()
    return ModuleMgr.getModule(GameDefine.LOGIN_MODULE)
end

-- 获取ServerModule
function PlazaManager.getServerModule()
    return ModuleMgr.getModule(GameDefine.GAME_MODULE)
end

-- 获取RefreshModule
function PlazaManager.getRefreshModule()
    return ModuleMgr.getModule(GameDefine.REFRESH_MODULE)
end

-- 断开登录网络
function PlazaManager.closeLoginSocket()
    game.disconnect(GameDefine.LOGIN_SOCKET)
    PlazaManager.getLoginModule().clearLoginIPs()
    PlazaManager.getLoginModule().unSchedule()
end

-- 断开游戏网络
function PlazaManager.closeRefreshSocket()
    PlazaManager.getRefreshModule().clearLoginIPs()
    game.disconnect(GameDefine.REFRESH_SOCKET)
end

-- 断开游戏网络
function PlazaManager.closeGameSocket()
    game.disconnect(GameDefine.GAME_SOCKET)
    PlazaManager.getServerModule().unSchedule()
end

function PlazaManager.getMd516(data)
    if data == nil then
        return nil
    end
    local encryptionStr = game.md5(data)
    return string.sub(encryptionStr, 9, -9)
end

function PlazaManager.getLoginPassword()
    local str = PlazaManager.getMd516(GameDefine.MachineID)
    str = string.format("%s#^(k", str)
    return game.md5(str)
end

function PlazaManager.getLoginWXPassword(openID)
    local str = string.format("xwle%s", openID)
    local encryptionStr = game.md5(str)
    return encryptionStr
end

function PlazaManager.getOpenID(openID)
    local str = string.format("xwle%s", openID)
    local encryptionStr = PlazaManager.getMd516(str)
    return encryptionStr
end

function PlazaManager.isBindWeiXin()
    if PlazaManager.isPhoneAndPadPlatform() == true then
        if PlazaManager.loginType == GameDefine.LOGIN_TYPE.YK or PlazaManager.loginType == GameDefine.LOGIN_TYPE.ACCOUNT then
            if globalUserInfo.isBindWX == false then
                return false
            end
        end
    end

    return true
end

-- 获取设备类型
function PlazaManager.getDeviceType()
    local deviceType = GameDefine.DEVICE_TYPE.PC
    if game.targetPlatform == cc.PLATFORM_OS_ANDROID then
        deviceType = GameDefine.DEVICE_TYPE.ANDROID
    elseif game.targetPlatform == cc.PLATFORM_OS_IPHONE or game.targetPlatform == cc.PLATFORM_OS_IPAD then
        deviceType = GameDefine.DEVICE_TYPE.IPHONE
        if PlazaManager.isIosTrust == true then
            deviceType = GameDefine.DEVICE_TYPE.IPHONETRUST
        end
    end
    return deviceType
end

-- 获取大厅版本
function PlazaManager.getHallVersion()
    local hallVersion = 3 -- pc

    if game.targetPlatform == cc.PLATFORM_OS_ANDROID then
        hallVersion = 3
    elseif game.targetPlatform == cc.PLATFORM_OS_IPHONE or game.targetPlatform == cc.PLATFORM_OS_IPAD then
        hallVersion = 3
    end
    return hallVersion
end

-- 获取游戏版本
function PlazaManager.getGameVersion(dwKindID)
    if PlazaManager.urlGameConfig == nil or PlazaManager.urlGameConfig.list == nil then
        return nil
    end

    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        if var.kindid == dwKindID then
            return var.version
        end
    end

    return nil
end

function PlazaManager.getHallVersionNew()
    return 1
end

-- 获取游戏列表  listType（1:游戏列表  2:审核列表）
function PlazaManager.getGameList(listType)
    local result = {}

    if listType == nil then
        return result
    end

    if PlazaManager.urlGameConfig == nil or PlazaManager.urlGameConfig.list == nil then
        return result
    end

    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        if listType == GameDefine.GAME_LIST_TYPE.NORMAL then
            if var.isSkipShow ~= 1 then
                table.insert(result, var)
            end
        elseif listType == GameDefine.GAME_LIST_TYPE.CHECK then
            if var.isCheckShow == 1 and var.isSkipShow ~= 1 then
                table.insert(result, var)
            end
        end
    end

    return result
end

function PlazaManager.getGameSceneName(wKindID)
    if PlazaManager.urlGameConfig == nil then
        return nil
    end

    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        if var.kindid == wKindID then
            return var.sceneNamePath
        end
    end

    return nil
end

function PlazaManager.getUrlGameInfoByKindID(dwKindID)
    if PlazaManager.urlGameConfig == nil or PlazaManager.urlGameConfig.list == nil then
        return nil
    end

    for key, var in ipairs(PlazaManager.urlGameConfig.list) do
        if var.kindid == dwKindID then
            return var
        end
    end

    return nil
end

-- 关闭客户端
function PlazaManager.closeClient()
    if game.targetPlatform ~= cc.PLATFORM_OS_IPHONE and game.targetPlatform ~= cc.PLATFORM_OS_IPAD then
        cc.Director:getInstance():endToLua()
    end
end

-- 用户银行密码类型和密码
PlazaManager.bankPassType = 0 -- 0-没有密码，1-数字密码,2-手势密码
PlazaManager.bankPassStr = "" -- 银行密码
PlazaManager.bankIsLogonSucc = false
PlazaManager.bankIsModiSucc = false
PlazaManager.bankLogonTime = 0 -- 上次登录时间
PlazaManager.bankOpenType = 1 -- 1:输入银行密码,2:家族红包密码验证,3:房卡赠送,4刷新查询银行信息 5:兑换

function PlazaManager.resetBankData()
    PlazaManager.bankPassStr = "" -- 银行密码
    PlazaManager.bankIsLogonSucc = false
    PlazaManager.bankIsModiSucc = false
    PlazaManager.bankLogonTime = 0 -- 上次登录时间
    PlazaManager.bankOpenType = 1 -- 1:点击银行按钮,2:家族红包密码验证,3:房卡赠送,4刷新查询银行信息
end

-- 根据roomid加入房间
function PlazaManager.onJoinRoomByRoomID(roomid)
    local function connectFailer()
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()
        PlazaManager.closeGameSocket()
    end

    PlazaManager.showConectWaitTips(connectFailer)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, connectFailer, LangCtrl:getLang().word312, LangCtrl:getLang().word313)
    end
    PlazaManager.getLoginModule().onSearchGameServer(roomid, onConnectResult)
end

-- 截取屏幕
function PlazaManager:onAfterCaptured(callback)
    local function afterCaptured(succeed, outputFile)
        if succeed then
            local imagepath = cc.FileUtils:getInstance():fullPathForFilename(outputFile)
            local imageThumbpath = nil

            local imageview = ccui.ImageView:create(imagepath)
            if imageview ~= nil then
                local dataSize = cc.FileUtils:getInstance():getFileSize(imagepath)
                printLog("PlazaManager", "onAfterCaptured: " .. "width=", imageview:getContentSize().width, "height=", imageview:getContentSize().height, "datasize=", dataSize)
            end

            local thumbSize = cc.size(130, 130)
            local thumbRect = cc.rect(0, 0, imageview:getContentSize().width, imageview:getContentSize().height)
            local imageThumbpath = game.genThumbImg(imagepath, thumbSize, thumbRect)

            if imageThumbpath ~= nil and type(imageThumbpath) == "string" and string.len(imageThumbpath) > 0 then
                local imagethumb = ccui.ImageView:create(imageThumbpath)
                if imagethumb ~= nil then
                    local dataSize_thumb = cc.FileUtils:getInstance():getFileSize(imageThumbpath)
                    printLog("PlazaManager", "thumWidth=", imagethumb:getContentSize().width, "thumHeight=", imagethumb:getContentSize().height, "thumDataSize=", dataSize_thumb)
                end
            end

            if callback ~= nil then
                callback(imageThumbpath, imagepath)
            end
        else
            PlazaManager.showTips(LangCtrl:getLang().word314)
        end
    end

    local fileName = "screenshot.jpg"
    cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
    cc.utils:captureScreen(afterCaptured, fileName)
end

function PlazaManager.test()
    local data = {}

    local data1 = {}
    data1.uFamilyId = 12121
    data1.wIsActive = true
    data1.szFamilyName = "sdsds"
    data1.szFamilyHead = "icon_1.png"
    table.insert(data, data1)

    local data2 = {}
    data2.uFamilyId = 12121
    data2.wIsActive = false
    data2.szFamilyName = "asass"
    data2.szFamilyHead = "icon_2.png"
    table.insert(data, data2)

    local data3 = {}
    data3.uFamilyId = 12213
    data3.wIsActive = true
    data3.szFamilyName = "qwqwq"
    data3.szFamilyHead = "icon_3.png"
    table.insert(data, data3)

    local args = {}
    args.count = 3
    args.familyList = data

    PlazaManager.familyInfo = args
end

function PlazaManager.onKeyboardListener()
    local function onKeyPressed(keyCode, event)
    end

    local keyTime = nil
    local function onKeyReleased(keyCode, event)
        if keyCode == cc.KeyCode.KEY_BACK then
            local curTime = os.time()
            if keyTime == nil or curTime - keyTime > 2 then -- 提示玩家再按一次退出游戏
                MessageBox.showTips(LangCtrl:getLang().word308)
            else
                cc.Director:getInstance():endToLua()
            end

            keyTime = curTime
        end
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithFixedPriority(listener, -1)
end

function PlazaManager.inserCopyRoomID(copyRoomID)
    local jsonStr = cc.UserDefault:getInstance():getStringForKey("save_copyRoomIDList", "{}")
    local copyRoomIDList = json.decode(jsonStr)

    if copyRoomIDList ~= nil then
        local exitChk = false
        for i = 1, #copyRoomIDList do
            if copyRoomID == copyRoomIDList[i] then
                exitChk = true
            end
        end

        if exitChk == false then
            table.insert(copyRoomIDList, 1, copyRoomID)
        end
    else
        copyRoomIDList = {}
    end

    local saveJsonStr = json.encode(copyRoomIDList)
    cc.UserDefault:getInstance():setStringForKey("save_copyRoomIDList", saveJsonStr)
end

function PlazaManager.checkCopyRoomID(copyRoomID)
    local jsonStr = cc.UserDefault:getInstance():getStringForKey("save_copyRoomIDList", "{}")
    local copyRoomIDList = json.decode(jsonStr)

    if copyRoomIDList == nil then
        copyRoomIDList = {}
    end
    for i = 1, #copyRoomIDList do
        if copyRoomID == copyRoomIDList[i] then
            return true
        end
    end
    return false
end

function PlazaManager.updataCopyRoomID(roomdataList, count)
    local jsonStr = cc.UserDefault:getInstance():getStringForKey("save_copyRoomIDList", "{}")
    local copyRoomIDList = json.decode(jsonStr)

    if copyRoomIDList == nil then
        copyRoomIDList = {}
    end

    for i = #copyRoomIDList, 1, -1 do
        local exitChk = false
        for i = 1, count do
            if copyRoomIDList[i] == roomdataList[i].szRoomID then
                exitChk = true
                break
            end
        end

        if exitChk == false then
            table.remove(copyRoomIDList, i)
        end
    end

    local saveJsonStr = json.encode(copyRoomIDList)
    cc.UserDefault:getInstance():setStringForKey("save_copyRoomIDList", saveJsonStr)
end

-- 获取游戏name
function PlazaManager.getUrlGameName(kindid)
    local name = nil
    if PlazaManager.urlGameConfig.list ~= nil then
        for key, var in pairs(PlazaManager.urlGameConfig.list) do
            if var.kindid == kindid then
                name = var.name
                break
            end
        end
    end
    return name
end

function PlazaManager.onDownloadGameFinish()
end

-- 下载游戏
local progressNode = nil
function PlazaManager.onDownloadGame(gameData, callback, pos)
    if progressNode == nil then
        local function onDownloadFinish(result, data)
            if callback ~= nil then
                callback(result, data)
            end
            if progressNode ~= nil then
                progressNode:removeFromParent()
                progressNode = nil
            end
        end

        if gameData ~= nil then
            progressNode = ProgressControl.create(gameData, onDownloadFinish)
            if progressNode ~= nil then
                if pos == nil then
                    progressNode:setAnchorPoint(display.CENTER)
                    progressNode:move(display.cx, display.cy):addTo(display.getRunningScene(), 10)
                else
                    progressNode:setAnchorPoint(display.CENTER)
                    progressNode:move(pos):addTo(display.getRunningScene(), 10)
                end
            end
        end
    end
end

-- 清除servermodule数据
function PlazaManager.resetServerModuleData()
    ModuleMgr.getModule(GameDefine.GAME_MODULE).resetServerModuleData()
end

-- 清除系统粘贴版
function PlazaManager.clearSystemCopy()
    if PlazaManager.isPhoneAndPadPlatform() == true then
        local roominfo = PlazaManager.onCheckCopyRoomInfo()
        if roominfo ~= nil then
            game.systemCopy("")
        end
    end
end

-- 获取家族列表
function PlazaManager.getFamilyList()
    local list = ChatDatabase.selectFamily()
    return list
end

-- 获取房间等级
function PlazaManager.getGameRoomType(nodeID)
    if nodeID >= 0 and nodeID <= 2000 then
        return GameDefine.GameRoomType.NormalType
    elseif nodeID > 2000 and nodeID <= 4000 then
        return GameDefine.GameRoomType.FirstType
    elseif nodeID > 4000 and nodeID <= 6000 then
        return GameDefine.GameRoomType.MidType
    elseif nodeID > 6000 and nodeID <= 8000 then
        return GameDefine.GameRoomType.HeightType
    elseif nodeID > 8000 and nodeID <= 10000 then
        return GameDefine.GameRoomType.TopType
    elseif nodeID > 10000 and nodeID <= 11000 then
        return GameDefine.GameRoomType.AntiCheatType
    elseif nodeID > 11000 and nodeID <= 12000 then
        return GameDefine.GameRoomType.ExpeType
    else
        return GameDefine.GameRoomType.ErroType
    end
end

-- 创建金币大厅房间数据
-- 金币大厅包房信息
local _goalRoomInfo = {}
function PlazaManager.getGoalRoomInfo()
    return _goalRoomInfo
end

function PlazaManager.resetGoalRoomInfo()
    _goalRoomInfo.szRoomID = "0" -- 房间编号
    _goalRoomInfo.RoomGrade = 0
    _goalRoomInfo.lCellScore = 0 -- 单元金币
    _goalRoomInfo.lMinEnterScore = 0 -- 进入房间最低金币
    _goalRoomInfo.lMaxEnterScore = 0 -- 进入房间最高金币
    _goalRoomInfo.lMaxUserPerTable = 0 -- 每桌最大人数
end

function PlazaManager.isIphoneX()
    if game.targetPlatform == cc.PLATFORM_OS_IPHONE then
        if display.sizeInPixels.width == 1125 and display.sizeInPixels.height == 2436 then
            return true
        end
    end
    return false
end
-- 与运算
function PlazaManager.BitAndBit(num1, num2)
    local reslt = bit.band(num1, num2)
    return reslt
end

-- 获取手机系统信息
function PlazaManager.getPhoneInfo()
    print("调用获取手机系统信息")
    -- 设备信息
    local systemModel = ""
    local deviceBrand = ""
    local systemVersion = ""

    -- 获取手机型号
    if game.getSystemModel then
        systemModel = game.getSystemModel()
    end

    -- 获取手机厂商
    if game.getDeviceBrand then
        deviceBrand = game.getDeviceBrand()
    end

    -- 获取当前手机系统版本号
    if game.getSystemVersion then
        systemVersion = game.getSystemVersion()
    end

    local phoneInfo = ""

    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_ANDROID then
        phoneInfo = string.format("%s %s %s", deviceBrand, systemModel, systemVersion)
    elseif platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
        if display.sizeInPixels.width == 1125 and display.sizeInPixels.height == 2436 then
            phoneInfo = "iphone iphoneX"
        elseif display.sizeInPixels.width == 640 and display.sizeInPixels.height == 960 then
            phoneInfo = "iphone 4"
        elseif display.sizeInPixels.width == 640 and display.sizeInPixels.height == 1136 then
            phoneInfo = "iphone 5"
        elseif display.sizeInPixels.width == 750 and display.sizeInPixels.height == 1334 then
            phoneInfo = "iphone 6"
        elseif display.sizeInPixels.width == 1242 and display.sizeInPixels.height == 2208 then
            phoneInfo = "iphone 6 plus"
        elseif display.sizeInPixels.width == 768 and display.sizeInPixels.height == 1024 then
            phoneInfo = "ipad"
        elseif display.sizeInPixels.width == 1536 and display.sizeInPixels.height == 2048 then
            phoneInfo = "ipad retina"
        else
            phoneInfo = "iphone 7"
        end
    elseif platform == cc.PLATFORM_OS_WINDOWS then
        phoneInfo = "windows"
    elseif platform == cc.PLATFORM_OS_MAC then
        phoneInfo = "mac"
    end

    print("手机信息 == " .. phoneInfo)
    return phoneInfo
end

-- 获取系统版本号
function PlazaManager.getVersionStr()
    local strVersion = ""
    --[[ --版本号暂时先屏蔽
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        strVersion = 'ANDROID版本: ' .. game.getDeviceVersionName()
    elseif cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
        strVersion = 'IOS版本: ' .. game.getDeviceVersionName()
    end
    --]]
    return strVersion
end

function PlazaManager.playClickEffect()
    if PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        MusicManager.playEffect("sound/buttonEffect.caf")
    else
        MusicManager.playEffect("sound/buttonEffect.ogg")
    end
end

function PlazaManager.radomIP(groupIps, groupPorts, groupCount)
    local result = {}

    if groupIps == nil or type(groupIps) ~= "table" then
        return result
    end

    if groupPorts == nil or type(groupPorts) ~= "table" then
        return result
    end

    if groupCount == nil or type(groupCount) ~= "number" then
        return result
    end

    local ips = clone(groupIps)
    local ports_new = clone(groupPorts)
    local ips_new = {}

    -- 打乱ip
    while #ips > 0 do
        local index = math.random(1, #ips)
        local removeip = table.remove(ips, index)
        table.insert(ips_new, removeip)
    end

    for idx, ip in ipairs(ips_new) do
        local data = result[#result]
        if data == nil or #data.ips >= groupCount then
            data = {
                ips = {},
                ports = {}
            }
            table.insert(result, data)
        end

        table.insert(data.ips, ip)
        table.insert(data.ports, ports_new[math.random(1, #ports_new)])
    end

    -- print('============== IP RroupIps ===============')
    -- rPrint(groupIps)
    -- rPrint(groupPorts)
    -- print('==============Radom IP Result===============', groupCount)
    -- rPrint(result)
    -- print('============================================')

    return result
end

function PlazaManager.onConnectResult(isSuccess, ipsCount, callback, proceStr, proceErroStr)
    local function onConnectOutTime()
        PlazaManager.closeLoginSocket()
        PlazaManager.getLoginModule().clearLoginIPs()
        PlazaManager.closeWattingTips()

        if callback ~= nil then
            callback()
        end

        PlazaManager.showTips(proceErroStr)
    end

    if isSuccess == false then
        if ipsCount > 0 then
            PlazaManager.setWattingData(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
        else
            PlazaManager.closeWattingTips()
            PlazaManager.showTips(LangCtrl:getLang().word246)
        end
    else
        PlazaManager.setWattingData(proceStr, GameDefine.processTime, onConnectOutTime, nil, true)
    end
end

function PlazaManager.showConectWaitTips(callback)
    local function onConnectOutTime()
        PlazaManager.closeLoginSocket()
        PlazaManager.closeWattingTips()
        PlazaManager.getLoginModule().clearLoginIPs()

        if callback ~= nil then
            callback()
        end

        PlazaManager.showTips(LangCtrl:getLang().word246)
    end
    PlazaManager.showWattingTips(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
end

function PlazaManager.isInstalledApp()
    local result = false

    if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
        result = game.isInstalledApp("joy.reightyl.fun")
    elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        result = game.isInstalledApp("reightyl://")
    end
    return result
end

function PlazaManager.onAppStart(str)
    if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
        game.onStartApp("joy.reightyl.fun", "org.cocos2dx.lua.AppActivity", str)
    elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        local iosStr = string.format("reightyl://?%s", str)
        game.onStartApp(iosStr, "", "")
    end
end

function PlazaManager.uploadBuglyLog(title, logStr)
    print("uploadBuglyLog:", title, logStr)
    --[[
    if title ~= nil and logStr ~= nil then
        if type(title) == "string" and type(logStr) == "string" and string.len(title) > 0 and string.len(logStr) > 0 then
            if buglyReportLuaException then
                buglyReportLuaException(title, logStr)
            end
        end
    end
    --]]
end

function PlazaManager.getSendServerNum(goalNum)
    return goalNum * 100
end

function PlazaManager.getAcceptClientNum(goalNum)
    return goalNum / 100
end

function PlazaManager.doEnterGame(wkindID)
    local gameInfo = PlazaManager.getUrlGameInfoByKindID(wkindID)
    if gameInfo ~= nil then
        local function onLoadingFinish()
            local function onClose(isOk)
                if isOk == true then
                    PlazaManager.closeClient()
                end
            end
            -- 判断文件是否存在
            local enterSceneClassName = string.format("game/%s/src/%sAPP", gameInfo.name, string.upper(gameInfo.name))
            if cc.FileUtils:getInstance():isFileExist(enterSceneClassName .. ".lua") or cc.FileUtils:getInstance():isFileExist(enterSceneClassName .. ".luac") then
                if gameInfo.isVerticalScreen == 1 then -- gameInfo.isVerticalScreen == 1
                    local isScreenFit = false
                    if gameInfo.isScreenFit == 1 then
                        isScreenFit = true
                    end
                    GameUtil.changeRootView_V(isScreenFit)
                else
                    --                    local v_gameScreenFit = false
                    --                    if gameInfo.isScreenFit == 1 then
                    --                        v_gameScreenFit = true
                    --                    end
                    GameUtil.setGameScreenFit(false)
                end
                require(enterSceneClassName).create():run()
            else
                PlazaManager.isOpenGameScene = false
                PlazaManager.closeGameSocket()
                PlazaManager.resetServerModuleData()
                PlazaManager.resetRoomServer()
                PlazaManager.resetGoalRoomInfo()

                local hitStr = string.format(LangCtrl:getLang().word281, gameInfo.nameStr)
                PlazaManager.showConfirmNode("yes_no", hitStr, nil, onClose)
            end
        end
        -- 加载loading界面
        LoadingManager.createLoading(wkindID, onLoadingFinish)
    else
        PlazaManager.isOpenGameScene = false
        print("打开游戏场景失败 没有找到对应的游戏信息")
    end
end
-- endregion
