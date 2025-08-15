local MJHLLoading = class("MJHLLoading", require("app.win.loading.LoadingUI"))
local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/mjhl/res/mjhlhetu.png",
    fileName = "game/mjhl/res/mjhlhetu.plist",
    isPist = true
}}

function MJHLLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function MJHLLoading.getLoadingRes()
    return loadingRes
end

function MJHLLoading:ctor(callback)
    MJHLLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function MJHLLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function MJHLLoading:onLoadSuccess()
    self.loadedCount = self.loadedCount + 1
    self:setPercent(self.loadedCount / self.totalResCount * 100)
    if self.loadedCount == self.totalResCount then
        if loadingRes ~= nil and #loadingRes > 0 then
            for key, var in pairs(loadingRes) do
                if var.isPist == true then
                    SpriteFrameUtils.addSpriteFrames(var.fileName, var.path)
                end
            end
        end

        if self.callback ~= nil then
            self.callback()
            self:onClose()
        else
            print("self.callback == nil")
        end
    end
end

function MJHLLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function MJHLLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function MJHLLoading:unloadLuaFile()
    package.loaded["game.mjhl.src.panel.MJHLAction"] = nil
    package.loaded["game.mjhl.src.panel.MJHLTopPanel"] = nil
    package.loaded["game.mjhl.src.panel.MJHLBottomPanel"] = nil
    package.loaded["game.mjhl.src.panel.MJHLHelpLayer"] = nil
    package.loaded["game.mjhl.src.panel.MJHLSettingLayer"] = nil

    package.loaded["game.mjhl.src.MJHLCMD"] = nil
    package.loaded["game.mjhl.src.MJHLLogic"] = nil
    package.loaded["game.mjhl.src.MJHLMessage"] = nil
    package.loaded["game.mjhl.src.MJHLScene"] = nil

    package.loaded["game.mjhl.src.MJHLLoading"] = nil
    package.loaded["game.mjhl.src.MJHLAPP"] = nil
end

return MJHLLoading

-- endregion
