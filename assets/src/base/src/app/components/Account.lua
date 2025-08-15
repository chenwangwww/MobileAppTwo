local config = require "config.Config"
local _M = {}

-- type = 1 正式账号 2 游客
function _M.savedAccount(name)
    local userDefault = cc.UserDefault:getInstance()
    userDefault:setStringForKey("user_name", name)
    userDefault:flush()
end

function _M.loadAccount()
    local info = {}
    local userDefault = cc.UserDefault:getInstance()
    info.name = userDefault:getStringForKey("user_name", "")

    return info
end

function _M.removeAccount()
    local userDefault = cc.UserDefault:getInstance()
    userDefault:deleteValueForKey("user_name")
    userDefault:flush()
end

function _M.savedPlatform(info)
    local userDefault = cc.UserDefault:getInstance()
    userDefault:setStringForKey("platform_appId", info.appId)
    userDefault:setStringForKey("platform_appSecret", info.appSecret)
    userDefault:setStringForKey("platform_code", info.code)
    userDefault:setStringForKey("platform_accessToken", info.accessToken)
    userDefault:setStringForKey("platform_openId", info.openId)
    userDefault:setStringForKey("platform_refreshToken", info.refreshToken)
    userDefault:flush()
end

function _M.loadPlatform()
    local info = {}

    local userDefault = cc.UserDefault:getInstance()
    info.appId = userDefault:getStringForKey("platform_appId", "")
    info.appSecret = userDefault:getStringForKey("platform_appSecret", "")
    info.code = userDefault:getStringForKey("platform_code", "")
    info.accessToken = userDefault:getStringForKey("platform_accessToken", "")
    info.openId = userDefault:getStringForKey("platform_openId", "")
    info.refreshToken = userDefault:getStringForKey("platform_refreshToken", "")

    if #info.appId == 0 then
        info.appId = config.weixinAppId
    end
    if #info.appSecret == 0 then
        info.appSecret = config.weixinAppSecret
    end

    return info
end

function _M.removePlatform()
    local userDefault = cc.UserDefault:getInstance()
    userDefault:deleteValueForKey("platform_appId")
    userDefault:deleteValueForKey("platform_appSecret")
    userDefault:deleteValueForKey("platform_code")
    userDefault:deleteValueForKey("platform_accessToken")
    userDefault:deleteValueForKey("platform_openId")
    userDefault:deleteValueForKey("platform_refreshToken")
    userDefault:flush()
end

return _M
