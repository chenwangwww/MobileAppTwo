local TGGLoading = class("TGGLoading", require("app.win.loading.LoadingUI"))
local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/tgg/res/tgghetu.png",
    fileName = "game/tgg/res/tgghetu.plist",
    isPist = true
}}

function TGGLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function TGGLoading.getLoadingRes()
    return loadingRes
end

function TGGLoading:ctor(callback)
    TGGLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function TGGLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function TGGLoading:onLoadSuccess()
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

function TGGLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function TGGLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function TGGLoading:unloadLuaFile()
    package.loaded["game.tgg.src.panel.TGGAction"] = nil
    package.loaded["game.tgg.src.panel.TGGButton"] = nil
    package.loaded["game.tgg.src.panel.TGGHelpLayer"] = nil
    package.loaded["game.tgg.src.panel.TGGSettingLayer"] = nil

    package.loaded["game.tgg.src.TGGCMD"] = nil
    package.loaded["game.tgg.src.TGGLogic"] = nil
    package.loaded["game.tgg.src.TGGMessage"] = nil
    package.loaded["game.tgg.src.TGGScene"] = nil

    package.loaded["game.tgg.src.TGGLoading"] = nil
    package.loaded["game.tgg.src.TGGAPP"] = nil
end

return TGGLoading

-- endregion
