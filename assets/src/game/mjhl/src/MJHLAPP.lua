-- GameUtil.changeRootView_V(true)
-- 麻将胡了  require('game/mjhl/src/MJHLAPP').create():run()
local MJHLAPP = class("MJHLAPP", cc.load("mvc").AppBase)

function MJHLAPP:ctor(configs)
    PlazaManager.CENTER_APP = "game.mjhl.src.MJHLScene"
    self.configs_ = {
        viewsRoot = "game.mjhl.src",
        modelsRoot = "app.models",
        defaultSceneName = "MJHLScene"
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

return MJHLAPP

-- endregion
