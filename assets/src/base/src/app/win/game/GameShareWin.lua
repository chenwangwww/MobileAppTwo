-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/9/30
-- 此文件由[BabeLua]插件自动生成
local GameShareWin = class("GameShareWin", require("app.win.base.GameWindowBase"))
-- local ChatMain = require "chat.scripts.ChatMain"

function GameShareWin:ctor(var, shareData, isShareRuslt)
    local size = cc.size(678, 653)
    GameShareWin.super.ctor(self, size, true)

    display.newSprite("app/win/share/img_gameShare.png"):move(self.midWidth, self.midHeight):addTo(self)

    if isShareRuslt == true then
        self:createShareReusltView(shareData)
    else
        self:createInviteView(shareData)
    end

    local function onShare(index)
        if PlazaManager.isPhoneAndPadPlatform() == true then

        else
            PlazaManager.showTips("android平台和ios平台才能分享")
        end
    end

    local function onClickClose(args)
        game.sendEvent(GameDefine.OnEmoPhraseWinClose)
        self:onClose()
    end
    GameUtil.createButton("app/win/common/btn_close_1.png", "app/win/common/btn_close_2.png", onClickClose):move(612, 500):addTo(self)

end

function GameShareWin:createInviteView(shareData)
    local function onShareFamily()
        local familyListData = PlazaManager.getFamilyList()
        if familyListData == nil or #familyListData == 0 then
            PlazaManager.showTips("还没有加入任何家族")
            return
        end

        local isChangeView = false
        local function onShareNotify(args)
            if isChangeView then
                local isScreenFit = false
                local gameInfo = PlazaManager.getUrlGameInfoByKindID(PlazaManager.curKindID)
                if gameInfo ~= nil then
                    if gameInfo.isVerticalScreen == 0 then
                        if gameInfo.isScreenFit == 1 then
                            isScreenFit = true
                        end
                    end
                end
                game.changeRootView_H(isScreenFit)
                display.getRunningScene():setContentSize(display.size)
            end
            if args == 1 then
                self:onClose()
            end
        end

        if math.min(display.width, display.height) == display.height then
            isChangeView = true
            game.changeRootView_V()
            display.getRunningScene():setContentSize(display.size)
        end

        ChatMain.shareGameRoom(display.getRunningScene(), shareData.name, shareData.title, shareData.icon, shareData.richContent, shareData.tag, onShareNotify)
    end

    local function onShareWX()
        if PlazaManager.isInstallWeiXin == false then
            PlazaManager.showTips("请检查是否安装微信或者安装的微信版本过低")
            return
        end
        if shareData.desc ~= nil and shareData.newUrl ~= nil then
            game.sendShareMessage(shareData.newUrl, shareData.name, shareData.desc, "Icon-152.png", shareData.index)
            self:onClose()
        end
    end

    GameUtil.createButton("app/win/share/btn_game_family.png", "app/win/share/btn_game_family_1.png", onShareFamily):move(181, 280):addTo(self)
    GameUtil.createButton("app/win/share/btn_game_wx.png", "app/win/share/btn_game_wx_1.png", onShareWX):move(490, 280):addTo(self)
end

function GameShareWin:createShareReusltView(shareData)
    local function onShareFamily()
        local familyListData = PlazaManager.getFamilyList()
        if familyListData == nil or #familyListData == 0 then
            PlazaManager.showTips("还没有加入任何家族")
            return
        end

        local isChangeView = false
        local function onShareNotify(args)
            if isChangeView then
                local isScreenFit = false
                local gameInfo = PlazaManager.getUrlGameInfoByKindID(PlazaManager.curKindID)
                if gameInfo ~= nil then
                    if gameInfo.isVerticalScreen == 0 then
                        if gameInfo.isScreenFit == 1 then
                            isScreenFit = true
                        end
                    end
                end

                game.changeRootView_H(isScreenFit)
                display.getRunningScene():setContentSize(display.size)
            end
            if args == 1 then
                self:onClose()
            end
        end

        if math.min(display.width, display.height) == display.height then
            isChangeView = true
            game.changeRootView_V()
            display.getRunningScene():setContentSize(display.size)
        end
        ChatMain.shareGameBalance(display.getRunningScene(), shareData.name, shareData.icon, shareData.imagepath, onShareNotify)
    end

    local function onShareWX()
        if PlazaManager.isInstallWeiXin == false then
            PlazaManager.showTips("请检查是否安装微信或者安装的微信版本过低")
            return
        end
        if shareData.imageThumbpath ~= nil and shareData.imagepath ~= nil then
            game.sendShareImage(shareData.imageThumbpath, shareData.imagepath, 0) -- 微信分享 0好友 1朋友圈
            self:onClose()
        end
    end

    GameUtil.createButton("app/win/share/btn_game_family.png", "app/win/share/btn_game_family_1.png", onShareFamily):move(181, 280):addTo(self)
    GameUtil.createButton("app/win/share/btn_game_wx.png", "app/win/share/btn_game_wx_1.png", onShareWX):move(490, 280):addTo(self)
end
return GameShareWin

-- endregion
