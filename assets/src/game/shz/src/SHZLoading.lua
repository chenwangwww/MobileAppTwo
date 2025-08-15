-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/23
-- 此文件由[BabeLua]插件自动生成
local SHZLoading = class("SHZLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/shz/res/game1/gameAction/dagu.png",
    fileName = "game/shz/res/game1/gameAction/dagu.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/gameAction/flash.png",
    fileName = "game/shz/res/game1/gameAction/flash.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/gameAction/game1_itemCommon.png",
    fileName = "game/shz/res/game1/gameAction/game1_itemCommon.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/gameAction/game1_itemJump.png",
    fileName = "game/shz/res/game1/gameAction/game1_itemJump.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/gameAction/piaoqi.png",
    fileName = "game/shz/res/game1/gameAction/piaoqi.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/gameAction/shz_title.png",
    fileName = "game/shz/res/game1/gameAction/shz_title.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/box_frame.png",
    fileName = "game/shz/res/game1/itemAction/box_frame.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/dadao.png",
    fileName = "game/shz/res/game1/itemAction/dadao.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/futou.png",
    fileName = "game/shz/res/game1/itemAction/futou.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/light.png",
    fileName = "game/shz/res/game1/itemAction/light.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/lin.png",
    fileName = "game/shz/res/game1/itemAction/lin.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/lu.png",
    fileName = "game/shz/res/game1/itemAction/lu.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/shuihuzhuan.png",
    fileName = "game/shz/res/game1/itemAction/shuihuzhuan.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/song.png",
    fileName = "game/shz/res/game1/itemAction/song.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/titianxingdao.png",
    fileName = "game/shz/res/game1/itemAction/titianxingdao.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/yinqiang.png",
    fileName = "game/shz/res/game1/itemAction/yinqiang.plist",
    isPist = true
}, {
    path = "game/shz/res/game1/itemAction/zhongyitang.png",
    fileName = "game/shz/res/game1/itemAction/zhongyitang.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_common.png",
    fileName = "game/shz/res/game2/dealer/dealer_common.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_cry.png",
    fileName = "game/shz/res/game2/dealer/dealer_cry.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_dice1.png",
    fileName = "game/shz/res/game2/dealer/dealer_dice1.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_dice2.png",
    fileName = "game/shz/res/game2/dealer/dealer_dice2.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_happy.png",
    fileName = "game/shz/res/game2/dealer/dealer_happy.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/dealer/dealer_open.png",
    fileName = "game/shz/res/game2/dealer/dealer_open.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/desk/desk.png",
    fileName = "game/shz/res/game2/desk/desk.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/gold_action/gold.png",
    fileName = "game/shz/res/game2/gold_action/gold.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/left/left_cheer.png",
    fileName = "game/shz/res/game2/left/left_cheer.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/left/left_common.png",
    fileName = "game/shz/res/game2/left/left_common.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/left/left_cry.png",
    fileName = "game/shz/res/game2/left/left_cry.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/left/left_happy.png",
    fileName = "game/shz/res/game2/left/left_happy.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/right/right_cheer1.png",
    fileName = "game/shz/res/game2/right/right_cheer1.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/right/right_cheer2.png",
    fileName = "game/shz/res/game2/right/right_cheer2.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/right/right_common2.png",
    fileName = "game/shz/res/game2/right/right_common2.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/right/right_cry.png",
    fileName = "game/shz/res/game2/right/right_cry.plist",
    isPist = true
}, {
    path = "game/shz/res/game2/right/right_happy.png",
    fileName = "game/shz/res/game2/right/right_happy.plist",
    isPist = true
}, {
    path = "game/shz/res/setting/setLayer.png",
    fileName = "game/shz/res/setting/setLayer.plist",
    isPist = true
}}
function SHZLoading:unloadLuaFile()
    package.loaded["game.shz.src.SHZ_CMD"] = nil
    package.loaded["game.shz.src.SHZAPP"] = nil
    package.loaded["game.shz.src.SHZScene"] = nil
    package.loaded["game.shz.src.SHZLoading"] = nil
end
function SHZLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function SHZLoading.getLoadingRes()
    return loadingRes
end

function SHZLoading:ctor(callback)
    SHZLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function SHZLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function SHZLoading:onLoadSuccess()
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

function SHZLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function SHZLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

return SHZLoading

-- endregion
