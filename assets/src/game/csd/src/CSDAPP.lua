local CSDAPP = class("CSDAPP", cc.load("mvc").AppBase)

function CSDAPP:ctor()
    PlazaManager.CENTER_APP = "game.csd.src.CSDScene"
    self.configs_ = {
        viewsRoot = "game.csd.src",
        modelsRoot = "app.models",
        defaultSceneName = "CSDScene"
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

return CSDAPP

-- endregion

