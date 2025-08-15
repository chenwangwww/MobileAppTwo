-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
local JLDBLoading = class("JLDBLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/jldb/res/frame.png",
    fileName = "game/jldb/res/frame.plist",
    isPist = true
}, {
    path = "game/jldb/res/set.png",
    fileName = "game/jldb/res/set.plist",
    isPist = true
}, {
    path = "game/jldb/res/respak2.png",
    fileName = "game/jldb/res/respak2.plist",
    isPist = true
}, {
    path = "game/jldb/res/respak.png",
    fileName = "game/jldb/res/respak.plist",
    isPist = true
}}

function JLDBLoading:unloadLuaFile()
    package.loaded["game.jldb.src.JLDB_CMD"] = nil
    package.loaded["game.jldb.src.JLDBAPP"] = nil
    package.loaded["game.jldb.src.JLDBScene"] = nil
    package.loaded["game.jldb.src.JLDBLoading"] = nil
end

function JLDBLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function JLDBLoading.getLoadingRes()
    return loadingRes
end

function JLDBLoading:ctor(callback)
    JLDBLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function JLDBLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function JLDBLoading:onLoadSuccess()
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

function JLDBLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function JLDBLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

return JLDBLoading

-- endregion
