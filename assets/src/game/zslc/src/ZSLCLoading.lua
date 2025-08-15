local ZSLCLoading = class("ZSLCLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/zslc/res/diamondtrain.png",
    fileName = "game/zslc/res/diamondtrain.plist",
    isPist = true
} -- {path = "game/zslc/res/setting.png", fileName="game/zslc/res/setting.plist", isPist = true},
}

function ZSLCLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function ZSLCLoading.getLoadingRes()
    return loadingRes
end

function ZSLCLoading:ctor(callback)
    ZSLCLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function ZSLCLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function ZSLCLoading:onLoadSuccess()
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

function ZSLCLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function ZSLCLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function ZSLCLoading:unloadLuaFile()
    package.loaded["game.zslc.src.panel.ZSLCAction"] = nil
    package.loaded["game.zslc.src.panel.ZSLCButton"] = nil
    package.loaded["game.zslc.src.panel.ZSLCText"] = nil
    package.loaded["game.zslc.src.panel.ZSLCGoldPool"] = nil
    package.loaded["game.zslc.src.panel.ZSLCHelpLayer"] = nil
    package.loaded["game.zslc.src.panel.ZSLCSetWin"] = nil

    package.loaded["game.zslc.src.ZSLCCMD"] = nil
    package.loaded["game.zslc.src.ZSLCLogic"] = nil
    package.loaded["game.zslc.src.ZSLCMessage"] = nil
    package.loaded["game.zslc.src.ZSLCScene"] = nil

    package.loaded["game.zslc.src.ZSLCLoading"] = nil
    package.loaded["game.zslc.src.ZSLCAPP"] = nil
end

return ZSLCLoading

-- endregion
