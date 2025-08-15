-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/3/17
-- 此文件由[BabeLua]插件自动生成
local _M = {}

local loginCallback = nil

function _M.setWeChatInfo(isOk, platformInfo, userinfo)
    if isOk == false then
        PlazaManager.closeWattingTips()
        PlazaManager.showTips("微信授权失败1")
        return
    else
        cc.UserDefault:getInstance():setStringForKey("accessToken", platformInfo.accessToken)
        cc.UserDefault:getInstance():setStringForKey("refreshToken", platformInfo.refreshToken)
        cc.UserDefault:getInstance():setStringForKey("wxOpenId", platformInfo.openId)
        cc.UserDefault:getInstance():setStringForKey("wxCode", platformInfo.code)
        cc.UserDefault:getInstance():setStringForKey("wxNickName", userinfo.nickname)
        cc.UserDefault:getInstance():setStringForKey("wxSex", userinfo.sex)
        cc.UserDefault:getInstance():setStringForKey("wxHeadimgurl", userinfo.headimgurl)
        cc.UserDefault:getInstance():setStringForKey("wxunionid", userinfo.unionid)

        local nickname = userinfo.nickname
        local sex = userinfo.sex
        local headimgurl = userinfo.headimgurl
        local unionid = userinfo.unionid
        local accessToken = platformInfo.accessToken

        local args = {}
        args.account = PlazaManager.getOpenID(userinfo.unionid)
        args.password = PlazaManager.getLoginWXPassword(userinfo.unionid)
        args.openIDAccount = PlazaManager.getOpenID(platformInfo.openId)
        args.openIDPassword = PlazaManager.getLoginWXPassword(platformInfo.openId)

        args.nickName = nickname
        args.sex = sex
        args.headimgurl = headimgurl
        args.accessToken = accessToken
        args.openID = platformInfo.openId

        PlazaManager.closeWattingTips()

        if PlazaManager.loginType == GameDefine.LOGIN_TYPE.WEIXIN then
            _M.wxLogin(args)
        end
    end
end

function _M.wxShareNotify(success)
    if success == 0 then
        if PlazaManager.shareType == 1 then
            PlazaManager.getLoginModule().onRequestShareInfo(1)
        end
    else
        PlazaManager.showTips("分享失败")
    end
end

function _M.checkAccessTokenCallBack(isSuccess)
    if isSuccess == true then
        PlazaManager.closeWattingTips()

        local openID = cc.UserDefault:getInstance():getStringForKey("wxOpenId", "")
        local nickname = cc.UserDefault:getInstance():getStringForKey("wxNickName", "")
        local sex = cc.UserDefault:getInstance():getStringForKey("wxSex", "1")
        local headimgurl = cc.UserDefault:getInstance():getStringForKey("wxHeadimgurl", "")
        local unionid = cc.UserDefault:getInstance():getStringForKey("wxunionid", "")
        local accessToken = cc.UserDefault:getInstance():getStringForKey("accessToken", "")
        if openID ~= "" and wxunionid ~= "" then
            local args = {}
            args.account = PlazaManager.getOpenID(unionid)
            args.password = PlazaManager.getLoginWXPassword(unionid)
            args.openIDAccount = PlazaManager.getOpenID(openID)
            args.openIDPassword = PlazaManager.getLoginWXPassword(openID)

            args.nickName = nickname
            args.sex = sex
            args.headimgurl = headimgurl
            args.accessToken = accessToken
            args.openID = openID

            if PlazaManager.loginType == GameDefine.LOGIN_TYPE.WEIXIN then
                _M.wxLogin(args)
            end
        else
            game.sendAuthRequest()
        end
    else
        game.sendAuthRequest()
    end
end

function _M.onLogin(isAutoLogin)
    local accessToken = ""
    local refreshToken = ""
    local wxOpenId = ""
    local wxCode = ""

    -- 是自动登录  手动点击微信登录 每次都会去微信拉去最新信息
    if isAutoLogin ~= false then
        accessToken = cc.UserDefault:getInstance():getStringForKey("accessToken", "")
        refreshToken = cc.UserDefault:getInstance():getStringForKey("refreshToken", "")
        wxOpenId = cc.UserDefault:getInstance():getStringForKey("wxOpenId", "")
        wxCode = cc.UserDefault:getInstance():getStringForKey("wxCode", "")
    end

    if accessToken == "" then
        game.sendAuthRequest()
    else
        game.sendCheckAccessToken(_M.checkAccessTokenCallBack)
    end
end

function _M.setWeiXinNotify()

end

function _M.wxLogin(args)
    if loginCallback ~= nil then
        loginCallback(args)
    end
end

function _M.wxBind(args)
    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, "绑定微信中...", "绑定微信失败")
    end
    PlazaManager.getLoginModule().onBindWeiXin(args, onConnectResult)
end

function _M.setShareResult()
    game.onShareResult(_M.wxShareNotify)
end

function _M.setLoginCallback(callback)
    loginCallback = callback
end

function _M.clearWXData()
    cc.UserDefault:getInstance():setStringForKey("accessToken", "")
    cc.UserDefault:getInstance():setStringForKey("refreshToken", "")
    cc.UserDefault:getInstance():setStringForKey("wxOpenId", "")
    cc.UserDefault:getInstance():setStringForKey("wxCode", "")
    cc.UserDefault:getInstance():setStringForKey("wxCode", "")
    cc.UserDefault:getInstance():setStringForKey("wxNickName", "")
    cc.UserDefault:getInstance():setStringForKey("wxSex", "")
    cc.UserDefault:getInstance():setStringForKey("wxHeadimgurl", "")
    cc.UserDefault:getInstance():setStringForKey("wxunionid", "")
end

return _M

-- endregion
