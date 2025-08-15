local FISHLKAPP = class("FISHLKAPP", cc.load("mvc").AppBase)

function FISHLKAPP:ctor()
    PlazaManager.CENTER_APP = "game.fishlk.src.FISHLKAPP"
    self.configs_ = {
        viewsRoot = "game.fishlk.src",
        modelsRoot = "game.fishlk.src",
        defaultSceneName = "FISHLKScene"
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
    self:onCreate()
end

return FISHLKAPP
