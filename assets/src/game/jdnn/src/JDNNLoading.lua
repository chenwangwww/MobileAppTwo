-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
local JDNNLoading = class("JDNNLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/jdnn/res/scene/scene.png",
    fileName = "game/jdnn/res/scene/scene.plist",
    isPist = true
}, {
    path = "game/jdnn/res/anim/anim.png",
    fileName = "game/jdnn/res/anim/anim.plist",
    isPist = true
}, {
    path = "game/jdnn/res/bull/bullType.png",
    fileName = "game/jdnn/res/bull/bullType.plist",
    isPist = true
}, {
    path = "game/jdnn/res/card/Card.png",
    fileName = "game/jdnn/res/card/Card.plist",
    isPist = true
}, {
    path = "game/jdnn/res/scene/BaseImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/jdnn/res/scene/MosaicGoldRulesBoxImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/jdnn/res/scene/RulesBoxImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/jdnn/res/scene/RulesImage.png",
    fileName = "",
    isPist = false
}, {
    path = "game/jdnn/res/scene/WaitImage.png",
    fileName = "",
    isPist = false
}}

function JDNNLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function JDNNLoading.unloadLuaFile()
    local jdnn_files = {"game.jdnn.src.panel.JDNNMenu", "game.jdnn.src.panel.JDNNOperate", "game.jdnn.src.panel.JDNNSeatManager", "game.jdnn.src.panel.JDNNStatus", "game.jdnn.src.panel.JDNNSetting",

                        "game.jdnn.src.JDNNSound", "game.jdnn.src.JDNNCMD", "game.jdnn.src.JDNNAPP", "game.jdnn.src.JDNNLogic", "game.jdnn.src.JDNNMessage", "game.jdnn.src.JDNNScene",
                        "game.jdnn.src.JDNNLoading"}
    for k, v in pairs(jdnn_files) do
        if package.loaded[v] ~= nil then
            package.loaded[v] = nil
        end
    end
end

function JDNNLoading.getLoadingRes()
    return loadingRes
end

function JDNNLoading:ctor(callback)
    JDNNLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function JDNNLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function JDNNLoading:onLoadSuccess()
    self.loadedCount = self.loadedCount + 1
    self:setPercent(self.loadedCount / self.totalResCount * 100)
    if self.loadedCount == self.totalResCount then
        printLog("资源加载完成 准备进入游戏")

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

function JDNNLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function JDNNLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

return JDNNLoading

-- endregion
