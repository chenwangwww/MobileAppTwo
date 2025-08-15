cc.exports.ModuleMgr = {}

ModuleMgr.modules = {}

function ModuleMgr.registerAll()
    ModuleMgr.register(GameDefine.LOGIN_MODULE, require("app.platform.modules.LoginModule"))
    ModuleMgr.register(GameDefine.GAME_MODULE, require("app.platform.modules.ServerModule"))
    ModuleMgr.register(GameDefine.REFRESH_MODULE, require("app.platform.modules.RefreshModule"))
end

function ModuleMgr.register(name, module)
    ModuleMgr.modules[name] = module

    if module.onInit ~= nil then
        module.onInit()
    end
end

function ModuleMgr.unregister(name)
    for k, v in pairs(ModuleMgr.modules) do
        if k == name then
            ModuleMgr.modules[name] = nil
        end
    end
end

function ModuleMgr.getModule(name)
    return ModuleMgr.modules[name]
end

function ModuleMgr.getModules()
    return ModuleMgr.modules
end
