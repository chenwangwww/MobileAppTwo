local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local openinstall = class("openinstall")

local activityClassName = "org/cocos2dx/lua/AppActivity"
local openinstallClassName = "com/fm/openinstall/OpenInstall"

function openinstall:getInstall(s, callback)
    print("call getInstall start")

end

function openinstall:registerWakeupHandler(callback)
    print("call registerWakeupHandler start")

end

function openinstall:reportRegister()
    print("call reportRegister start")

end

function openinstall:reportEffectPoint(pointId, pointValue)
    print("call reportEffectPoint start")

end

return openinstall
