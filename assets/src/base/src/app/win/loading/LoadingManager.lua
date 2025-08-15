-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
cc.exports.LoadingManager = {}
local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local function onClose(isOk)
    if isOk == true then
        PlazaManager.closeClient()
    end
end

local function onCloseGameServer(isOk)
    PlazaManager.closeGameSocket()
    PlazaManager.resetServerModuleData()
    PlazaManager.resetRoomServer()
end

function LoadingManager.createLoading(wkindID, callback)
    local loadingClass = nil
    local gameInfo = PlazaManager.getUrlGameInfoByKindID(wkindID)
    if gameInfo ~= nil then
        local loadingClassName = string.format("game/%s/src/%sLoading", gameInfo.name, string.upper(gameInfo.name))
        if cc.FileUtils:getInstance():isFileExist(loadingClassName .. ".lua") or cc.FileUtils:getInstance():isFileExist(loadingClassName .. ".luac") then
            loadingClass = require(loadingClassName)
        else
            print("not found loadingClassName--->", loadingClassName)
        end
    end

    if loadingClass == nil then
        PlazaManager.isOpenGameScene = false

        PlazaManager.closeGameSocket()
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()

        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word295)
        return
    end

    local isShowLoading = loadingClass.isCreate()
    if isShowLoading then
        local rWin = loadingClass.new(callback)
        if rWin ~= nil then
            local x = (display.width - rWin:getContentSize().width) / 2
            local y = (display.height - rWin:getContentSize().height) / 2
            rWin:move(x, y):addTo(display.getRunningScene(), 255)
        end
    else
        if callback ~= nil then
            callback()
        end
    end
end

function LoadingManager.removeLoadRes(wkindID)
    local gameInfo = PlazaManager.getUrlGameInfoByKindID(wkindID)
    if gameInfo ~= nil then
        local loadingClassName = string.format("game/%s/src/%sLoading", gameInfo.name, string.upper(gameInfo.name))
        if cc.FileUtils:getInstance():isFileExist(loadingClassName .. ".lua") or cc.FileUtils:getInstance():isFileExist(loadingClassName .. ".luac") then
            local loadingClass = require(loadingClassName)
            local isShowLoading = loadingClass.isCreate()

            -- 释放资源
            if isShowLoading then
                local resList = loadingClass.getLoadingRes()
                if resList ~= nil and #resList > 0 then
                    for key, var in pairs(resList) do
                        cc.Director:getInstance():getTextureCache():removeTextureForKey(var.path)
                        if var.isPist == true then
                            if string.len(var.fileName) > 0 then
                                SpriteFrameUtils.removeSpriteFrames(var.fileName)
                            end
                        end
                    end
                end
            end

            -- 删除lua文件
            loadingClass.unloadLuaFile()
        end
    end

    -- LoadingDefine.removeLoadRes(wkindID)
end

-- endregion
