-- region NewFile_1.lua
-- Author : admin
-- Date   : 2016/12/28
-- 此文件由[BabeLua]插件自动生成
local ZSLCAPP = class("ZSLCAPP", cc.load("mvc").AppBase)

function ZSLCAPP:ctor()
    PlazaManager.CENTER_APP = "game.zslc.src.ZSLCScene"
    self.configs_ = {
        viewsRoot = "game.zslc.src",
        modelsRoot = "app.models",
        defaultSceneName = "ZSLCScene"
    }

    for k, v in pairs(configs or {}) do
        self.configs_[k] = v
    end

    if type(self.configs_.viewsRoot) ~= "table" then
        self.configs_.viewsRoot = {self.configs_.viewsRoot}
    end
    if type(self.configs_.modelsRoot) ~= "table" then
        self.configs_.modelsRoot = {self.configs_.modelsRoot}
    end

    if DEBUG > 1 then
        dump(self.configs_, "AppBase configs")
    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    -- event
    self:onCreate()
end

return ZSLCAPP

-- endregion

