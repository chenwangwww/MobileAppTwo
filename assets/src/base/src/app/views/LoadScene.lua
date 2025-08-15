local LoadScene = class("LoadScene", cc.load("mvc").ViewBase)

local ClientUpdate = require("app.components.ClientUpdate")
local UpdateAppUI = require("app.win.login.UpdateAppUI")
local LoadLayer = require("app.views.LoadLayer")
cc.exports.LangCtrl = require("app.platform.lang.LangCtrl").new()

function LoadScene:onCreate(callback)
    self.callback = callback
    self.configGameList = nil
    self.localGameListResVersion = nil
    self.QuestWebCount = 0

    self:initView()
end

function LoadScene:initView()
    self.LoadLayer = LoadLayer.new()
    if self.LoadLayer ~= nil then
        local args = {}
        args.versionStr = PlazaManager.getVersionStr()
        args.hitStr = "" -- "抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防上当受骗 适度游戏益脑 沉迷游戏伤身 合理安排时间 享受健康生活"
        args.declareStr = "" -- "软著权人：杭州君游网络科技有限公司     许可证：浙网文[2017]9385-695号"
        self.LoadLayer:setLoadInfo(args)
        self:addChild(self.LoadLayer)
    end
end

function LoadScene:onEnterTransitionFinish()
    self:checkHallisRemove()

    self.QuestWebCount = 0
    self.urlData = nil
    local configPath = PlazaManager.getWritablePath() .. "res/base/" .. PlazaManager.GameListJson
    if cc.FileUtils:getInstance():isFileExist(configPath) then
        local dataFile = cc.FileUtils:getInstance():getStringFromFile(configPath)
        self.urlData = json.decode(dataFile)
    else
        if cc.FileUtils:getInstance():isFileExist(PlazaManager.GameListJson) then
            local dataFile = cc.FileUtils:getInstance():getStringFromFile(PlazaManager.GameListJson)
            self.urlData = json.decode(dataFile)
        end
    end

    PlazaManager.showWattingTips(LangCtrl:getLang().word283, 15, nil, self, true)
    self.startQuestWebTime = os.time()
    self:checkGameList()
end

function LoadScene:checkGameList()
    local time = os.time()

    local isSpare = false
    if self.urlData.isSpare ~= nil and self.urlData.isSpare == 1 then
        isSpare = true
    end
    local url_noTime = ""
    if isSpare == true then
        url_noTime = PlazaManager.getUpdateConfigUrl(true)
    else
        url_noTime = PlazaManager.getUpdateConfigUrl()
    end
    local url = string.format("%s?timenow=%s", url_noTime, time)

    print("url == " .. url)

    local waitTime = 7000
    if self.urlData.iosCheck == 1 then
        waitTime = 30000
    end

    if GameDefine.bIsLocalSkipGameList then
        self:onHttpCallback(nil, false)
    else
        self.QuestWebCount = self.QuestWebCount + 1
        game.getHttpJson(url, "", waitTime, function(succ, content)
            self:loadCheckConfig(succ, content)
        end)
    end
end

function LoadScene:loadCheckConfig(succ, content)
    if succ == true then
        print("请求配置文件成功")
        self.QuestWebCount = 0
        PlazaManager.closeWattingTips()
        local jsonData = json.decode(content)
        self:onHttpCallback(jsonData, true)
    else
        print("请求配置文件失败")
        self.endQuestWebTime = os.time()
        local diffTime = self.endQuestWebTime - self.startQuestWebTime
        print("请求间隔时间 == " .. diffTime)

        if diffTime >= 15 or self.QuestWebCount >= 3 then
            PlazaManager.closeWattingTips()
            self:onHttpCallback(nil, false)
            return
        end

        local function onAgainCheckGameList(args)
            -- 延迟1秒请求
            self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:onDelayQuestWeb()
            end, 1, false)
        end

        if self.urlData ~= nil then
            onAgainCheckGameList(nil)
        else
            PlazaManager.closeWattingTips()
            PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word284)
        end
    end
end

function LoadScene:onDelayQuestWeb()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
    self:checkGameList()
end

-- 更新完成
function LoadScene:onUpdateFinish(isUpdate)
    if isUpdate == true then
        -- 重置大厅与游戏
        for k, v in pairs(package.loaded) do
            if k ~= nil then
                if type(k) == "string" then
                    if string.find(k, "app.") ~= nil or string.find(k, "game.") ~= nil then
                        print("package kill:" .. k)
                        package.loaded[k] = nil
                    end
                end
            end
        end
    end

    if self.callback ~= nil then
        self.callback(self.configGameList)
    end
end

function LoadScene:checkUpdate()
    -- 是否热更新
    local function isUpdate()
        local isHotUpdate = false
        if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
            if self.configGameList.androidUpdate == 1 then
                isHotUpdate = true
            end
        elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
            if self.configGameList.iosUpdate == 1 then
                isHotUpdate = true
            end
        elseif PlazaManager.platform == cc.PLATFORM_OS_WINDOWS or PlazaManager.platform == cc.PLATFORM_OS_MAC then
            if self.configGameList.windowsUpdate == 1 then
                isHotUpdate = true
            end
        end
        return isHotUpdate
    end

    -- 检测主版本是否更新
    local function onMainUpdate()
        local function checkVersion(localVersion, netVersion)
            print("localVersion == " .. localVersion .. "  netVersion == " .. netVersion)
            local result = false
            if string.len(localVersion) > 0 and string.len(netVersion) > 0 then
                local localVersionArray = string.split(localVersion, ".")
                local netVersionArray = string.split(netVersion, ".")
                for k, v in ipairs(localVersionArray) do
                    local localv = tonumber(v)
                    local netv = 0
                    if netVersionArray[k] ~= nil then
                        netv = tonumber(netVersionArray[k])
                    end
                    if localv ~= nil and netv ~= nil then
                        if localv < netv then
                            result = true
                            break
                        end
                    else
                        result = false
                        break
                    end
                end
            end
            return result
        end

        local bMainUpdate = false

        local netVersion = ""
        if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
            netVersion = self.configGameList.androidmainVersion
        elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
            netVersion = self.configGameList.iosmainVersion
        end

        if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
            bMainUpdate = checkVersion(PlazaManager.VersionName, netVersion)
        end

        return bMainUpdate
    end

    -- 删除更新的所有大厅数据
    local function removeHallUpdateData()
        print("调用删除所有大厅的更新数据")
        local remove_paths = {}
        local path_app = PlazaManager.getWritablePath() .. "res/base"
        table.insert(remove_paths, path_app)

        -- 检测是否删除所有游戏
        local removeGame = false
        if self.configGameList.isRemoveGame == 1 then
            removeGame = true
        end
        if removeGame == true then
            local path_game = self:getWritablePath() .. "res/game"
            table.insert(remove_paths, path_game)
        end

        for key, var in ipairs(remove_paths) do
            if cc.FileUtils:getInstance():isDirectoryExist(var) == true then
                local succ = cc.FileUtils:getInstance():removeDirectory(var)
                if succ == true then
                    print("removeFinish true " .. var)
                end
            end
        end
    end

    -- 更新下载完成回调
    local function updataCallFunction(isFinish, apkPath)
        print("apkPath == " .. apkPath)
        -- 下载完成
        if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
            if isFinish == true then
                -- 启动安装
                local className = "org/cocos2dx/lua/AppActivity"
                local args = {apkPath}
                local sigs = "(Ljava/lang/String;)V" -- 传入string参数，无返回值

                local luaj = require "cocos.cocos2d.luaj"
                local ok, ret = luaj.callStaticMethod(className, "installationAPK", args, sigs)
                if ok == true then
                    print("正在安装中")
                end
            else
                print("down failer下载失败")
            end
        elseif PlazaManager.platform == cc.PLATFORM_OS_WINDOWS or PlazaManager.platform == cc.PLATFORM_OS_MAC then
            -- 执行安装
            print("打开安装程序 == " .. apkPath)
            game.onOpenExe(apkPath)
            cc.Director:getInstance():endToLua()
        end
    end

    local function onCloseGame(isOk)
        cc.Director:getInstance():endToLua()
    end

    if isUpdate() == true then
        if onMainUpdate() == true then
            UpdateAppUI.new(self.configGameList, updataCallFunction, removeHallUpdateData):addTo(self)
        else
            -- 检测资源更新
            self:checkedVersion()
        end
    else
        -- 不能更新 直接进入游戏
        self:onUpdateFinish(false)
    end
end

function LoadScene:onHttpCallback(data, isDownSuccess)
    -- 关闭游戏
    local function onClose(isOk)
        if PlazaManager.platform ~= cc.PLATFORM_OS_IPHONE and PlazaManager.platform ~= cc.PLATFORM_OS_IPAD then
            cc.Director:getInstance():endToLua()
        end
    end

    -- 如果下载文件失败 则使用本地配置文件
    local configPath = PlazaManager.getWritablePath() .. "res/base/" .. PlazaManager.GameListJson
    if data == nil then
        if cc.FileUtils:getInstance():isFileExist(configPath) then
            local dataFile = cc.FileUtils:getInstance():getStringFromFile(configPath)
            data = json.decode(dataFile)
        else
            if cc.FileUtils:getInstance():isFileExist(PlazaManager.GameListJson) then
                local dataFile = cc.FileUtils:getInstance():getStringFromFile(PlazaManager.GameListJson)
                data = json.decode(dataFile)
            end
        end
        if data ~= nil then
            data.isDownGameList = false
        end
    else
        -- data不为空 保存本地文件
        local fileStr = json.encode(data)
        cc.FileUtils:getInstance():writeStringToFile(fileStr, configPath)
        data.isDownGameList = true
    end

    if data == nil then
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word284, nil, onClose)
        return
    end

    -- 设置配置文件数据
    self.configGameList = data

    -- 维护公告
    -- if PlazaManager.isPhoneAndPadPlatform() == true then
    if self.configGameList.isMaintain == 1 then
        local list = string.split(self.configGameList.maintainMsg, "http")
        if list[1] and list[1] ~= "" and list[2] and list[2] ~= "" then
            local tipsStr = list[1]
            local qrcode_str = "http" .. list[2]
            local tipsWin = require "app.views.QRCodeUpdate"
            tipsWin:openView(qrcode_str, tipsStr)
        else
            PlazaManager.showConfirmNode("ok", self.configGameList.maintainMsg, nil, onClose)
        end
        return
    end
    -- end

    -- 是否审核版本
    local isCheck = false
    if PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        if self.configGameList.iosCheck == 1 then
            isCheck = true
        end
    elseif PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
        if self.configGameList.androidCheck == 1 then
            isCheck = true
        end
    end

    -- 审核版本或者下载配置文件失败则不进入大厅更新而直接进入登录界面
    if isCheck == true or isDownSuccess == false then
        self:onUpdateFinish(false)
        return
    end

    if isCheck == false then
        -- 设置url
        self:checkUpdate()
    end
end

function LoadScene:onDelayQuestWeb()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
    self:checkGameList()
end

function LoadScene:checkedVersion()
    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. ".dwqpgame/res/"
    cc.FileUtils:getInstance():setSearchPaths({})
    cc.FileUtils:getInstance():addSearchPath(storagePath)
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("src/game/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/")

    print("准备下载大厅")
    self:onDownloadHall()
end

function LoadScene:onDownloadHall()
    local function onDownHallError(ret)
        local errorStr = string.format(LangCtrl:getLang().word285, ret)
        self.LoadLayer:setProcressLabel(errorStr)
        print("大厅下载失败")

        -- 大厅下载失败 也进入登陆界面 由客户端的大厅版本参数和服务端的大厅版本参数比较判断 是否能进入游戏
        cc.FileUtils:getInstance():purgeCachedEntries()
        self:onUpdateFinish(true)
    end

    local function onDownHallProgress(percent, maxCount, currDownLoadIndex)
        self.LoadLayer:setProcress(percent)
        if maxCount > 0 then
            self.LoadLayer:setProcressLabel(string.format(LangCtrl:getLang().word286, currDownLoadIndex, maxCount, percent))
        else
            self.LoadLayer:setProcressLabel(string.format(LangCtrl:getLang().word287, self.hitStr, percent))
        end
    end

    local function onDownHallComplate(args)
        print("大厅下载完成")

        -- 大厅下载完成 启动下载游戏取消 游戏进入大厅后 玩家手动更新某款游戏
        -- self.LoadLayer:setProcress(0)
        -- self.LoadLayer:setProcressLabel("正在加载游戏信息")

        -- 启动游戏下载
        -- self:onDownloadGame()

        cc.FileUtils:getInstance():purgeCachedEntries()
        self:onUpdateFinish(true)
    end

    local storagePath = PlazaManager.getWritablePath() .. "res/base/"
    local hall_temp = PlazaManager.getWritablePath() .. "res/base_temp"
    if cc.FileUtils:getInstance():isDirectoryExist(hall_temp) == true then
        local succ = cc.FileUtils:getInstance():removeDirectory(hall_temp)
        if succ == true then
            print("removeFinish ==  " .. hall_temp)
        else
            print("removeFailer ==  " .. hall_temp)
        end
    end

    PlazaManager.syncUrl2Manifest("base/project.manifest", "base/version.manifest", "hallupdateurl", self.configGameList)
    ClientUpdate.checkUpdate("base/project.manifest", storagePath, true, onDownHallError, onDownHallProgress, onDownHallComplate)
end

function LoadScene:onDownloadGame()
    local function onDownGameError(ret)
        local errorStr = string.format(LangCtrl:getLang().word285, ret)
        self.LoadLayer:setProcressLabel(errorStr)
    end

    local function onDownGameProgress(percent, maxCount, currDownLoadIndex)
        self.LoadLayer:setProcress(percent)
        if maxCount > 0 then
            self.LoadLayer:setProcressLabel(string.format(LangCtrl:getLang().word286, currDownLoadIndex, maxCount, percent))
        else
            self.LoadLayer:setProcressLabel(string.format(LangCtrl:getLang().word287, percent))
        end
    end

    local function onDownGameComplate(args)
        print("游戏下载完成")
        cc.FileUtils:getInstance():purgeCachedEntries()
        self:onUpdateFinish(true)
    end

    local storagePath = PlazaManager.getWritablePath() .. "res/game/"
    local hall_temp = PlazaManager.getWritablePath() .. "res/game_temp"
    if cc.FileUtils:getInstance():isDirectoryExist(hall_temp) == true then
        local succ = cc.FileUtils:getInstance():removeDirectory(hall_temp)
        if succ == true then
            print("removeFinish ==  " .. hall_temp)
        else
            print("removeFailer ==  " .. hall_temp)
        end
    end
    ClientUpdate.checkUpdate("game/project.manifest", storagePath, true, onDownGameError, onDownGameProgress, onDownGameComplate)
end

function LoadScene:checkHallisRemove()
    local function checkVersion(localVersion, netVersion)
        print("localVersion == " .. localVersion .. "  updateVersion == " .. netVersion)
        local result = false
        if string.len(localVersion) > 0 and string.len(netVersion) > 0 then
            local localVersionArray = string.split(localVersion, ".")
            local netVersionArray = string.split(netVersion, ".")
            for k, v in ipairs(localVersionArray) do
                local localv = tonumber(v)
                local netv = 0
                if netVersionArray[k] ~= nil then
                    netv = tonumber(netVersionArray[k])
                end
                if localv ~= nil and netv ~= nil then
                    if localv > netv then
                        result = true
                        break
                    end
                else
                    result = false
                    break
                end
            end
        end
        return result
    end

    cc.FileUtils:getInstance():setSearchPaths({})

    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")
    cc.FileUtils:getInstance():addSearchPath("src/game/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/res/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/app/")
    cc.FileUtils:getInstance():addSearchPath("src/base/src/")

    -- 安装目录下的版本
    local localHallVersion = nil
    -- 热更目录下的版本
    local updateHallVersion = nil

    -- 热更目录
    local updateHallProjectPath = PlazaManager.getWritablePath() .. "res/base/project.manifest"
    if cc.FileUtils:getInstance():isFileExist(updateHallProjectPath) == true then
        local updateHallProjectStr = cc.FileUtils:getInstance():getStringFromFile(updateHallProjectPath)
        if type(updateHallProjectStr) == "string" and string.len(updateHallProjectStr) > 0 then
            local updateData = json.decode(updateHallProjectStr)
            if updateData ~= nil and updateData.version ~= nil then
                updateHallVersion = updateData.version
            end
        end
    end

    -- 安装目录
    if cc.FileUtils:getInstance():isFileExist("base/project.manifest") == true then
        local localHallProjectStr = cc.FileUtils:getInstance():getStringFromFile("base/project.manifest")
        if type(localHallProjectStr) == "string" and string.len(localHallProjectStr) > 0 then
            local localData = json.decode(localHallProjectStr)
            if localData ~= nil and localData.version ~= nil then
                localHallVersion = localData.version
            end
        end
    end

    if localHallVersion ~= nil and updateHallVersion ~= nil then
        print("localHallVersion == " .. localHallVersion .. "  updateHallVersion == " .. updateHallVersion)
        if checkVersion(localHallVersion, updateHallVersion) == true then
            -- 安装目录下的版本大于热更目录下的版本 说明玩家是覆盖安装 则删除热更所有资源
            local removePath = PlazaManager.getWritablePath() .. "res/base"
            if cc.FileUtils:getInstance():isDirectoryExist(removePath) == true then
                local succ = cc.FileUtils:getInstance():removeDirectory(removePath)
                if succ == true then
                    print("检测本地大厅版本大于热更目录下的版本 删除热更大厅数据" .. removePath)
                end
            end
        end
    else
        if updateHallVersion == nil then
            print("updateHallVersion = nil")
        end
    end

    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. ".dwqpgame/"
    cc.FileUtils:getInstance():setSearchPaths({})

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
end

return LoadScene
