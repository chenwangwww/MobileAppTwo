local MLCSLoading = class("MLCSLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/mlcs/res/mlcs.png",
    fileName = "game/mlcs/res/mlcs.plist",
    isPist = true
}}

function MLCSLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function MLCSLoading.getLoadingRes()
    return loadingRes
end

function MLCSLoading:ctor(callback)
    MLCSLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function MLCSLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function MLCSLoading:onLoadSuccess()
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

function MLCSLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function MLCSLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function MLCSLoading:unloadLuaFile()
    package.loaded["game.mlcs.src.panel.MLCSAction"] = nil
    package.loaded["game.mlcs.src.panel.MLCSButton"] = nil
    package.loaded["game.mlcs.src.panel.MLCSHelpLayer"] = nil
    package.loaded["game.mlcs.src.panel.MLCSSettingLayer"] = nil

    package.loaded["game.mlcs.src.MLCSCMD"] = nil
    package.loaded["game.mlcs.src.MLCSLogic"] = nil
    package.loaded["game.mlcs.src.MLCSMessage"] = nil
    package.loaded["game.mlcs.src.MLCSScene"] = nil

    package.loaded["game.mlcs.src.MLCSLoading"] = nil
    package.loaded["game.mlcs.src.MLCSAPP"] = nil
end

return MLCSLoading

-- endregion
