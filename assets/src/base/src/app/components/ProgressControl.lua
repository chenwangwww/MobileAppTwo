-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/4/27
-- 此文件由[BabeLua]插件自动生成
local ClientUpdate = require("app.components.ClientUpdate")

local _M = {}

function _M.create(dwKindID, callback)
    local node = cc.Node:create()
    local progBg = display.newSprite("app/common/tip_gxdb.png")
    local size = progBg:getContentSize()
    node:setContentSize(size)

    local function onTouchBegan(touch, event)
        local isDel = ClientUpdate.delUpdate()
        if isDel == true then
            if node ~= nil and callback ~= nil then
                node:runAction(cc.CallFunc:create(function()
                    callback(false, dwKindID)
                end))
            end
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    progBg:move(size.width / 2, size.height / 2):addTo(node)

    local progSp = cc.ProgressTimer:create(display.newSprite("app/common/tip_gxdb2.png"))
    progSp:setPercentage(0)
    progSp:setPosition(size.width / 2, size.height / 2):addTo(node)

    local lbl = cc.Label:createWithTTF("", GameDefine.FontName, 28)
    lbl:setColor(cc.WHITE)
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(cc.p(size.width / 2, size.height / 2))
    lbl:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    node:addChild(lbl)

    local name = string.format("%s", PlazaManager.getUrlGameName(dwKindID))
    if name ~= nil then
        local function onError(ret)
            if node == nil then
                print("onError node = nil")
                return
            end
            lbl:setString(LangCtrl:getLang().word229 .. ret)
            if callback ~= nil then
                callback(false, dwKindID)
            end
            PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word229)
        end

        local function onProgress(percent, maxCount, currDownLoadIndex)
            progSp:setPercentage(percent)
            if maxCount > 0 then
                lbl:setString(string.format("%d%%", percent) .. "\n" .. string.format("(%d/%d)", currDownLoadIndex, maxCount))
            else
                lbl:setString(string.format("%d%%", percent))
            end
        end

        local function onComplate(eventCode)
            print("eventCode = " .. eventCode)
            if node == nil then
                print("eventCode = " .. eventCode)
                return
            end

            print("更新单个游戏完成  刷新本地游戏版本缓存")
            -- 更新本地信息
            if cc.FileUtils:getInstance():isFileExist(PlazaManager.getWritablePath() .. "res/game/" .. name .. "/project.manifest") then
                local gameRes = cc.FileUtils:getInstance():getStringFromFile(PlazaManager.getWritablePath() .. "res/game/" .. name .. "/project.manifest")
                if gameRes ~= nil and string.len(gameRes) > 0 then
                    local versionData = json.decode(gameRes)
                    if versionData ~= nil and versionData.version ~= nil and PlazaManager.localGameListResVersion ~= nil then
                        for key, var in ipairs(PlazaManager.localGameListResVersion) do
                            if var.kindid == dwKindID then
                                var.version = versionData.version
                            end
                        end
                    end
                end
            end

            print("更新单个游戏完成  刷新本地游戏版本缓存  完成")

            if callback ~= nil then
                callback(true, dwKindID)
            end
        end

        local storePath = PlazaManager.getWritablePath() .. "res/game/" .. name .. "/"
        local game_temp = PlazaManager.getWritablePath() .. "res/game/" .. name .. "_temp"
        local project_manifest = "game/" .. name .. "/project.manifest"
        local version_manifest = "game/" .. name .. "/version.manifest"
        PlazaManager.syncUrl2Manifest(project_manifest, version_manifest, dwKindID, PlazaManager.urlGameConfig)
        if cc.FileUtils:getInstance():isDirectoryExist(game_temp) == true then
            if game.targetPlatform == cc.PLATFORM_OS_WINDOWS or game.targetPlatform == cc.PLATFORM_OS_MAC then
                ClientUpdate.checkUpdate(project_manifest, storePath, true, onError, onProgress, onComplate)
            else
                local succ = cc.FileUtils:getInstance():removeDirectory(game_temp)
                if succ == true then
                    ClientUpdate.checkUpdate(project_manifest, storePath, true, onError, onProgress, onComplate)
                else
                    print("remove failer ==  " .. game_temp)
                end
            end
        else
            ClientUpdate.checkUpdate(project_manifest, storePath, true, onError, onProgress, onComplate)
        end

        return node
    else
        PlazaManager.showTips(LangCtrl:getLang().word230)
    end

    return nil
end

return _M

-- endregion
