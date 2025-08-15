-- c++调用
local NetManager = {}

function NetManager:onConnection(name, ip, port, connNum)
    -- printLog("NetManager","onConnection >>> name="..name.."ip="..ip.."port="..port.."connNum="..connNum)
    game.sendEvent("onConnectioned", name, ip, port, connNum)
end

function NetManager:onDisConnectioned(name, ip, port, connNum, bgReconnect)
    -- printLog("NetManager","onDisConnectioned >>>  name="..name.." ip="..ip.." port="..port.." connNum ="..connNum)
    game.sendEvent("onDisConnectioned", name, ip, port, connNum, bgReconnect)
end

function NetManager:onNetPropcess(name, modId, cmdId, error, decoder)
    -- print("NetManager:onNetPropcess == "..name.."  modId == "..modId.."  cmdId == "..cmdId)
    local modules = ModuleMgr.getModules()

    for k, v in pairs(modules) do
        if v.accept then
            if v.accept(name, modId, cmdId) then
                v.process(name, modId, cmdId, decoder)
                break
            end
        end
    end
end

cc.exports.__NetManager__ = NetManager
