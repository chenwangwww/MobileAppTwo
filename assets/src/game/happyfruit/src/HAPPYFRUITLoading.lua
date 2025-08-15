local HAPPYFRUITLoading = class("HAPPYFRUITLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/happyfruit/res/fruit_machine.png",
    fileName = "game/happyfruit/res/fruit_machine.plist",
    isPist = true
}}

function HAPPYFRUITLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function HAPPYFRUITLoading.getLoadingRes()
    return loadingRes
end

function HAPPYFRUITLoading:ctor(callback)
    HAPPYFRUITLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function HAPPYFRUITLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function HAPPYFRUITLoading:onLoadSuccess()
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

function HAPPYFRUITLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function HAPPYFRUITLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function HAPPYFRUITLoading:unloadLuaFile()
    package.loaded["game.happyfruit.src.panel.HappyFruitAction"] = nil
    package.loaded["game.happyfruit.src.panel.HappyFruitButton"] = nil
    package.loaded["game.happyfruit.src.panel.HappyFruitText"] = nil
    package.loaded["game.happyfruit.src.panel.HappyFruitGoldPool"] = nil
    package.loaded["game.happyfruit.src.panel.HappyFruitHelpLayer"] = nil
    package.loaded["game.happyfruit.src.panel.HappyFruitSetWin"] = nil

    package.loaded["game.happyfruit.src.HappyFruitCMD"] = nil
    package.loaded["game.happyfruit.src.HappyFruitLogic"] = nil
    package.loaded["game.happyfruit.src.HappyFruitMessage"] = nil
    package.loaded["game.happyfruit.src.HappyFruitScene"] = nil
    package.loaded["game.happyfruit.src.HappyFruitLang"] = nil

    package.loaded["game.happyfruit.src.HAPPYFRUITLoading"] = nil
    package.loaded["game.happyfruit.src.HAPPYFRUITAPP"] = nil
end

return HAPPYFRUITLoading

-- endregion
