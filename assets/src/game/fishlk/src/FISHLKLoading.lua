-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
local FISHLKLoading = class("FISHLKLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = { -- {path="game/fishlk/res/FishLock.png",fileName="game/fishlk/res/FishLock.plist",isPist=true},
{
    path = "game/fishlk/res/LockFishIcon.png",
    fileName = "game/fishlk/res/LockFishIcon.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Santu.png",
    fileName = "game/fishlk/res/Santu.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Settings.png",
    fileName = "game/fishlk/res/Settings.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish1.png",
    fileName = "game/fishlk/res/Fish1.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish2.png",
    fileName = "game/fishlk/res/Fish2.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish3.png",
    fileName = "game/fishlk/res/Fish3.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish4.png",
    fileName = "game/fishlk/res/Fish4.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish5.png",
    fileName = "game/fishlk/res/Fish5.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish6.png",
    fileName = "game/fishlk/res/Fish6.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish7.png",
    fileName = "game/fishlk/res/Fish7.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish8.png",
    fileName = "game/fishlk/res/Fish8.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish9.png",
    fileName = "game/fishlk/res/Fish9.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Fish10.png",
    fileName = "game/fishlk/res/Fish10.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Coin.png",
    fileName = "game/fishlk/res/Coin.plist",
    isPist = true
}, {
    path = "game/fishlk/res/FishUI.png",
    fileName = "game/fishlk/res/FishUI.plist",
    isPist = true
}, {
    path = "game/fishlk/res/Net.png",
    fileName = "game/fishlk/res/Net.plist",
    isPist = true
}, {
    path = "game/fishlk/res/SpecialEffects/bingjian.png",
    fileName = "game/fishlk/res/SpecialEffects/bingjian.plist",
    isPist = true
}, {
    path = "game/fishlk/res/SpecialEffects/ding.png",
    fileName = "game/fishlk/res/SpecialEffects/ding.plist",
    isPist = true
}, {
    path = "game/fishlk/res/SpecialEffects/explode_1.png",
    fileName = "game/fishlk/res/SpecialEffects/explode_1.plist",
    isPist = true
}, {
    path = "game/fishlk/res/SpecialEffects/explode_2.png",
    fileName = "game/fishlk/res/SpecialEffects/explode_2.plist",
    isPist = true
}, {
    path = "game/fishlk/res/SpecialEffects/quan.png",
    fileName = "game/fishlk/res/SpecialEffects/quan.plist",
    isPist = true
}}
function FISHLKLoading:unloadLuaFile()
    package.loaded["game.fishlk.src.FISHLK_CMD"] = nil
    package.loaded["game.fishlk.src.FISHLKAPP"] = nil
    package.loaded["game.fishlk.src.FISHLKScene"] = nil
    package.loaded["game.fishlk.src.AddAndDownGun"] = nil
    package.loaded["game.fishlk.src.BulletManager"] = nil
    package.loaded["game.fishlk.src.CAction"] = nil
    package.loaded["game.fishlk.src.CBigWheel"] = nil
    package.loaded["game.fishlk.src.CBingo"] = nil
    package.loaded["game.fishlk.src.ChipManager"] = nil
    package.loaded["game.fishlk.src.FISHArms"] = nil
    package.loaded["game.fishlk.src.FISHLKChip"] = nil
    package.loaded["game.fishlk.src.FISHLKDeath"] = nil
    package.loaded["game.fishlk.src.FISHLKLoading"] = nil
    package.loaded["game.fishlk.src.FISHLKMessage"] = nil
    package.loaded["game.fishlk.src.FISHLKNoticeFish"] = nil
    package.loaded["game.fishlk.src.FISHLKObj"] = nil
    package.loaded["game.fishlk.src.FISHManager"] = nil
    package.loaded["game.fishlk.src.FishUI"] = nil
    package.loaded["game.fishlk.src.MathAide"] = nil
    package.loaded["game.fishlk.src.FishSettings"] = nil
    package.loaded["game.fishlk.src.FishHelp"] = nil
    package.loaded["game.fishlk.src.FISHBodyFrame"] = nil
end
function FISHLKLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function FISHLKLoading.getLoadingRes()
    return loadingRes
end

function FISHLKLoading:ctor(callback)
    FISHLKLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function FISHLKLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function FISHLKLoading:onLoadSuccess()
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

function FISHLKLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function FISHLKLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

return FISHLKLoading

-- endregion
