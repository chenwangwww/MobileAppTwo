cc.FileUtils:getInstance():setPopupNotify(false)
-- LuaSocket = require("socket")

require "config"
require "cocos.init"

local function setSeachPath()
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

local function createDirectory()
    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. ".dwqpgame/"
    if not cc.FileUtils:getInstance():isDirectoryExist(storagePath .. "res/") then
        cc.FileUtils:getInstance():createDirectory(storagePath .. "res/")
    end
    if not cc.FileUtils:getInstance():isDirectoryExist(storagePath .. "res/dwqpgametemp/") then
        cc.FileUtils:getInstance():createDirectory(storagePath .. "res/dwqpgametemp/")
    end
    if not cc.FileUtils:getInstance():isDirectoryExist(storagePath .. "res/dwqpgamedowntemp/") then
        cc.FileUtils:getInstance():createDirectory(storagePath .. "res/dwqpgamedowntemp/")
    end
    game.setDownloadPath(storagePath .. "res/dwqpgametemp/")
    game.setDownloadHeadPath(storagePath .. "res/dwqpgamedowntemp/")

    if not cc.FileUtils:getInstance():isDirectoryExist(storagePath .. "res/base/app/") then
        cc.FileUtils:getInstance():createDirectory(storagePath .. "res/base/app/")
    end
    if not cc.FileUtils:getInstance():isDirectoryExist(storagePath .. "res/game/") then
        cc.FileUtils:getInstance():createDirectory(storagePath .. "res/game/")
    end
end

local function requestClass()
    require "app.platform.common.GameDefine"
    require "app.platform.common.MusicManager"
    require "app.platform.common.DebugUtils"
    require "app.platform.msg.CMD_LogonServer"
    require "app.platform.msg.CMD_GameServer"
    require "app.platform.msg.CMD_Correspond"
    require "app.platform.common.GameEvents"
    require "app.platform.common.NetManager"
    require "app.platform.data.GlobalUserInfo"
    require "app.platform.common.GameUtil"
    require "app.platform.common.PlazaManager"
end

local function main()
    setSeachPath()
    createDirectory()
    requestClass()
    MusicManager.onInit()

    if PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD or PlazaManager.platform == cc.PLATFORM_OS_MAC then
        PlazaManager.GameListJson = "app/gamelist2.json"
    else -- cc.PLATFORM_OS_ANDROID or cc.PLATFORM_OS_WINDOWS
        PlazaManager.GameListJson = "app/gamelist1.json"
    end

    local function onLoadComplete(args)
        setSeachPath()
        requestClass()
        PlazaManager.init(args)
        require("app.MyApp"):create():run("LoginScene")
    end
    require("app.MyApp"):create():run("LoadScene", onLoadComplete)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print("main msg:", msg)

    -- local platform = cc.Application:getInstance():getTargetPlatform()
    -- if platform == cc.PLATFORM_OS_ANDROID or platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
    --     if buglyReportLuaException then
    --         buglyReportLuaException(tostring(msg), debug.traceback())
    --     end
    -- end
end
