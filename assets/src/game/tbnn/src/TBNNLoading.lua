-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
local TBNNLoading = class("TBNNLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/tbnn/res/scene/scene.png",
    fileName = "game/tbnn/res/scene/scene.plist",
    isPist = true
}, {
    path = "game/tbnn/res/anim/anim.png",
    fileName = "game/tbnn/res/anim/anim.plist",
    isPist = true
}, {
    path = "game/tbnn/res/bull/bullType.png",
    fileName = "game/tbnn/res/bull/bullType.plist",
    isPist = true
}, {
    path = "game/tbnn/res/card/Card.png",
    fileName = "game/tbnn/res/card/Card.plist",
    isPist = true
}, {
    path = "game/tbnn/res/scene/BaseImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/tbnn/res/scene/MosaicGoldRulesBoxImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/tbnn/res/scene/RulesBoxImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/tbnn/res/scene/RulesImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/tbnn/res/scene/WaitImage.png",
    fileName = "",
    isPist = false
}}

function TBNNLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function TBNNLoading.unloadLuaFile()
    local tbnn_files = {"game.tbnn.src.panel.TBNNMenu", "game.tbnn.src.panel.TBNNOperate", "game.tbnn.src.panel.TBNNSeatManager", "game.tbnn.src.panel.TBNNStatus", "game.tbnn.src.panel.TBNNSetting",

                        "game.tbnn.src.TBNNSound", "game.tbnn.src.TBNNCMD", "game.tbnn.src.TBNNAPP", "game.tbnn.src.TBNNLogic", "game.tbnn.src.TBNNMessage", "game.tbnn.src.TBNNScene",
                        "game.tbnn.src.TBNNLoading"}
    for k, v in pairs(tbnn_files) do
        if package.loaded[v] ~= nil then
            package.loaded[v] = nil
        end
    end
end

function TBNNLoading.getLoadingRes()
    return loadingRes
end

function TBNNLoading:ctor(callback)
    TBNNLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function TBNNLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function TBNNLoading:onLoadSuccess()
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
            printLog("self.callback == nil")
        end
    end
end

function TBNNLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function TBNNLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

return TBNNLoading

-- endregion
