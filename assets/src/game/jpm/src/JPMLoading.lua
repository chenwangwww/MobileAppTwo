local JPMLoading = class("JPMLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/jpm/res/LayerMain.png",
    fileName = "game/jpm/res/LayerMain.plist",
    isPist = true
}, {
    path = "game/jpm/res/Rule.png",
    fileName = "game/jpm/res/Rule.plist",
    isPist = true
}, {
    path = "game/jpm/res/Lines.png",
    fileName = "game/jpm/res/Lines.plist",
    isPist = true
}, {
    path = "game/jpm/res/DaoGuang.png",
    fileName = "game/jpm/res/DaoGuang.plist",
    isPist = true
}}

function JPMLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function JPMLoading.getLoadingRes()
    return loadingRes
end

function JPMLoading:ctor(callback)
    JPMLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function JPMLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function JPMLoading:onLoadSuccess()
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

function JPMLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function JPMLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function JPMLoading:unloadLuaFile()
    package.loaded["game.jpm.src.panel.JPMCenter"] = nil

    package.loaded["game.jpm.src.JPMCMD"] = nil
    package.loaded["game.jpm.src.JPMSound"] = nil
    package.loaded["game.jpm.src.JPMScene"] = nil

    package.loaded["game.jpm.src.JPMLoading"] = nil
    package.loaded["game.jpm.src.JPMAPP"] = nil
end

return JPMLoading

-- endregion
