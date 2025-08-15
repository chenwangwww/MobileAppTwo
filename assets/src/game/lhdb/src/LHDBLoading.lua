local LHDBLoading = class("LHDBLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/lhdb/res/Gems/gems3.png",
    fileName = "game/lhdb/res/Gems/gems3.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Gems/gems4.png",
    fileName = "game/lhdb/res/Gems/gems4.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/scene.png",
    fileName = "game/lhdb/res/Scene/scene.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/scene2.png",
    fileName = "game/lhdb/res/Scene/scene2.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/Help/help.png",
    fileName = "game/lhdb/res/Scene/Help/help.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/Jackpot/jackpot.png",
    fileName = "game/lhdb/res/Scene/Jackpot/jackpot.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/Level/level.png",
    fileName = "game/lhdb/res/Scene/Level/level.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Scene/Set/set.png",
    fileName = "game/lhdb/res/Scene/Set/set.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Score/score.png",
    fileName = "game/lhdb/res/Score/score.plist",
    isPist = true
}, {
    path = "game/lhdb/res/Font/232323_0.jpg"
}, {
    path = "game/lhdb/res/Font/242424_0.jpg"
}, {
    path = "game/lhdb/res/Font/252525_0.jpg"
}, {
    path = "game/lhdb/res/Font/bierende_0.jpg"
}, {
    path = "game/lhdb/res/Font/combo_0.jpg"
}, {
    path = "game/lhdb/res/Font/Img_JiangChi_21X34.jpg"
}, {
    path = "game/lhdb/res/Font/Img_LongZhu_18X29.jpg"
}, {
    path = "game/lhdb/res/Font/jileijiang_0.jpg"
}, {
    path = "game/lhdb/res/Font/zidong_0.jpg"
}, {
    path = "game/lhdb/res/Font/shuzi_0.jpg"
}, {
    path = "game/lhdb/res/Scene/background.jpg"
}, {
    path = "game/lhdb/res/Scene/background2.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/content_0.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/content_1.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/content_2.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/content_3.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/content_4.jpg"
}, {
    path = "game/lhdb/res/Scene/Help/Img_BangZhuBj.jpg"
}}

function LHDBLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function LHDBLoading.getLoadingRes()
    return loadingRes
end

function LHDBLoading:ctor(callback)
    LHDBLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function LHDBLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function LHDBLoading:onLoadSuccess()
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

function LHDBLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function LHDBLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

local loadFile = {"game.lhdb.src.panel.LHDBGameEnd", "game.lhdb.src.panel.LHDBMenu", "game.lhdb.src.panel.LHDBRule", "game.lhdb.src.panel.LHDBSetting", "game.lhdb.src.panel.LHDBGoldPool",
                  "game.lhdb.src.panel.LHDBGate", "game.lhdb.src.panel.LHDBBet", "game.lhdb.src.panel.LHDBBetInfo", "game.lhdb.src.panel.LHDBCenter", "game.lhdb.src.panel.LHDBTBInfo",
                  "game.lhdb.src.panel.LHDBMsgBox", "game.lhdb.src.panel.LHDBTBLayer", "game.lhdb.src.panel.LHDBReward", "game.lhdb.src.LHDBUtil", "game.lhdb.src.LHDBSound", "game.lhdb.src.LHDBLogic",
                  "game.lhdb.src.LHDBMessage", "game.lhdb.src.LHDBCMD", "game.lhdb.src.LHDBScene", "game.lhdb.src.LHDBAPP", "game.lhdb.src.LHDBLoading"}

function LHDBLoading:unloadLuaFile()
    for k, file in pairs(loadFile) do
        package.loaded[file] = nil
    end
end

return LHDBLoading
