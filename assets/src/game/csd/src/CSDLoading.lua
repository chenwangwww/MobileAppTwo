local CSDLoading = class("CSDLoading", require("app.win.loading.LoadingUI"))

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local loadingRes = {{
    path = "game/csd/res/ani/bigwin/bigwin.png",
    fileName = "game/csd/res/ani/bigwin/bigwin.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/border/border.png",
    fileName = "game/csd/res/ani/border/border.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_jinbi/jinbi.png",
    fileName = "game/csd/res/ani/fx_jinbi/jinbi.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_luzi_liuguang/liuguang.png",
    fileName = "game/csd/res/ani/fx_luzi_liuguang/liuguang.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_mianfeisancai/mianfeisancai.png",
    fileName = "game/csd/res/ani/fx_mianfeisancai/mianfeisancai.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_qiufeiru/qiufeiru.png",
    fileName = "game/csd/res/ani/fx_qiufeiru/qiufeiru.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_WILD/wild.png",
    fileName = "game/csd/res/ani/fx_WILD/wild.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/fx_zazhong/zazhong.png",
    fileName = "game/csd/res/ani/fx_zazhong/zazhong.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/pic/pic.png",
    fileName = "game/csd/res/ani/pic/pic.plist",
    isPist = true
}, {
    path = "game/csd/res/ani/total/total.png",
    fileName = "game/csd/res/ani/total/total.plist",
    isPist = true
}, {
    path = "game/csd/res/scene/scene.png",
    fileName = "game/csd/res/scene/scene.plist",
    isPist = true
}, {
    path = "game/csd/res/scene/help.png",
    fileName = "game/csd/res/scene/help.plist",
    isPist = true
}, {
    path = "game/csd/res/scene/set.png",
    fileName = "game/csd/res/scene/set.plist",
    isPist = true
}}

function CSDLoading.isCreate()
    if loadingRes == nil or #loadingRes == 0 then
        return false
    end
    return true
end

function CSDLoading.getLoadingRes()
    return loadingRes
end

function CSDLoading:ctor(callback)
    CSDLoading.super.ctor(self)
    self.callback = callback
    self:initData()
    self:loadRes()
end

function CSDLoading:initData()
    self.totalResCount = #loadingRes
    self.loadedCount = 0
end

function CSDLoading:onLoadSuccess()
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

function CSDLoading:loadRes()
    if loadingRes ~= nil then
        for key, var in pairs(loadingRes) do
            cc.Director:getInstance():getTextureCache():addImageAsync(var.path, handler(self, self.loadCallBack))
        end
    end
end

function CSDLoading:loadCallBack(texture2D)
    self:onLoadSuccess()
end

function CSDLoading:unloadLuaFile()
    package.loaded["game.csd.src.panel.CSDHelp"] = nil
    package.loaded["game.csd.src.panel.CSDSetting"] = nil
    package.loaded["game.csd.src.panel.CSDCenter"] = nil
    package.loaded["game.csd.src.panel.CSDSettle"] = nil
    package.loaded["game.csd.src.panel.CSDBet"] = nil
    package.loaded["game.csd.src.panel.CSDGoldHistory"] = nil

    package.loaded["game.csd.src.CSDCMD"] = nil
    package.loaded["game.csd.src.CSDLogic"] = nil
    package.loaded["game.csd.src.CSDSound"] = nil
    package.loaded["game.csd.src.CSDMessage"] = nil
    package.loaded["game.csd.src.CSDScene"] = nil

    package.loaded["game.csd.src.CSDLoading"] = nil
    package.loaded["game.csd.src.CSDAPP"] = nil
end

return CSDLoading

-- endregion
