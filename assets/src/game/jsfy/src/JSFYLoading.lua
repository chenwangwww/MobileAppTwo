local JSFYLoading = class("JSFYLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/jsfy/res/ani/bonus.png",
    fileName = "game/jsfy/res/ani/bonus.plist",
    isPist = true
}, {
    path = "game/jsfy/res/ani/box_bz.png",
    fileName = "game/jsfy/res/ani/box_bz.plist",
    isPist = true
}, {
    path = "game/jsfy/res/ani/icon_g.png",
    fileName = "game/jsfy/res/ani/icon_g.plist",
    isPist = true
}, {
    path = "game/jsfy/res/ani/icon_languang.png",
    fileName = "game/jsfy/res/ani/icon_languang.plist",
    isPist = true
}, {
    path = "game/jsfy/res/ani/kaibx_g.png",
    fileName = "game/jsfy/res/ani/kaibx_g.plist",
    isPist = true
}, {
    path = "game/jsfy/res/rule/rule.png",
    fileName = "game/jsfy/res/rule/rule.plist",
    isPist = true
}, {
    path = "game/jsfy/res/scene/scene.png",
    fileName = "game/jsfy/res/scene/scene.plist",
    isPist = true
}, {
    path = "game/jsfy/res/scene/treasure.png",
    fileName = "game/jsfy/res/scene/treasure.plist",
    isPist = true
}, {
    path = "game/jsfy/res/scene/js_bg.png"
}, {
    path = "game/jsfy/res/scene/line/line1.png"
}, {
    path = "game/jsfy/res/scene/line/line2.png"
}, {
    path = "game/jsfy/res/scene/line/line3.png"
}, {
    path = "game/jsfy/res/scene/line/line4.png"
}, {
    path = "game/jsfy/res/scene/line/line5.png"
}, {
    path = "game/jsfy/res/scene/line/line6.png"
}, {
    path = "game/jsfy/res/scene/line/line7.png"
}, {
    path = "game/jsfy/res/scene/line/line8.png"
}, {
    path = "game/jsfy/res/scene/line/line9.png"
}, {
    path = "game/jsfy/res/scene/line/line10.png"
}, {
    path = "game/jsfy/res/scene/line/line11.png"
}, {
    path = "game/jsfy/res/scene/line/line12.png"
}, {
    path = "game/jsfy/res/scene/line/line13.png"
}, {
    path = "game/jsfy/res/scene/line/line14.png"
}, {
    path = "game/jsfy/res/scene/line/line15.png"
}, {
    path = "game/jsfy/res/scene/line/line16.png"
}, {
    path = "game/jsfy/res/scene/line/line17.png"
}, {
    path = "game/jsfy/res/scene/line/line18.png"
}, {
    path = "game/jsfy/res/scene/line/line19.png"
}, {
    path = "game/jsfy/res/scene/line/line20.png"
}, {
    path = "game/jsfy/res/scene/line/line21.png"
}, {
    path = "game/jsfy/res/scene/line/line22.png"
}, {
    path = "game/jsfy/res/scene/line/line23.png"
}, {
    path = "game/jsfy/res/scene/line/line24.png"
}, {
    path = "game/jsfy/res/scene/line/line25.png"
}, {
    path = "game/jsfy/res/scene/line/line26.png"
}, {
    path = "game/jsfy/res/scene/line/line27.png"
}, {
    path = "game/jsfy/res/scene/line/line28.png"
}, {
    path = "game/jsfy/res/scene/line/line29.png"
}, {
    path = "game/jsfy/res/scene/line/line30.png"
}, {
    path = "game/jsfy/res/setting/setting.png",
    fileName = "game/jsfy/res/setting/setting.plist",
    isPist = true
}}

function JSFYLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function JSFYLoading.getLoadingRes()
    return loadingRes
end

function JSFYLoading:ctor(callback)
    JSFYLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function JSFYLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function JSFYLoading:onLoadSuccess()
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

function JSFYLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function JSFYLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function JSFYLoading:unloadLuaFile()
    package.loaded["game.jsfy.src.panel.JSFYHelp"] = nil
    package.loaded["game.jsfy.src.panel.JSFYSetting"] = nil
    package.loaded["game.jsfy.src.panel.JSFYCenter"] = nil
    package.loaded["game.jsfy.src.panel.JSFYSettle"] = nil
    package.loaded["game.jsfy.src.panel.JSFYBet"] = nil
    package.loaded["game.jsfy.src.panel.JSFYTreasure"] = nil

    package.loaded["game.jsfy.src.JSFYCMD"] = nil
    package.loaded["game.jsfy.src.JSFYLogic"] = nil
    package.loaded["game.jsfy.src.JSFYSound"] = nil
    package.loaded["game.jsfy.src.JSFYMessage"] = nil
    package.loaded["game.jsfy.src.JSFYScene"] = nil

    package.loaded["game.jsfy.src.JSFYLoading"] = nil
    package.loaded["game.jsfy.src.JSFYAPP"] = nil
end

return JSFYLoading

-- endregion
