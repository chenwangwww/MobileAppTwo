-- 秘鲁传说  require('game/mlcs/src/MLCSAPP').create():run()
local MLCSAPP = class("MLCSAPP", cc.load("mvc").AppBase)

function MLCSAPP:ctor()
    PlazaManager.CENTER_APP = "game.mlcs.src.MLCSScene"
    self.configs_ = {
        viewsRoot = "game.mlcs.src",
        modelsRoot = "app.models",
        defaultSceneName = "MLCSScene"
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

return MLCSAPP

-- endregion
