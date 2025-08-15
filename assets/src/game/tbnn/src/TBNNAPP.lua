local TBNNAPP = class("TBNNAPP", cc.load("mvc").AppBase)

function TBNNAPP:ctor()
    PlazaManager.CENTER_APP = "game.tbnn.src.TBNNAPP"
    self.configs_ = {
        viewsRoot = "game.tbnn.src",
        modelsRoot = "app.models",
        defaultSceneName = "TBNNScene"
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

    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    -- event
    self:onCreate()
end

return TBNNAPP

-- endregion
