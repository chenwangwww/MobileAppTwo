local UserAgreementUI = class("UserAgreementUI", require("app.win.base.GameWindowBase"))

function UserAgreementUI:ctor()
    local size = cc.size(854, 530)
    UserAgreementUI.super.ctor(self, size, true)
    self:setName("UserAgreementUI")

    local showNode = cc.Node:create()
    showNode:setContentSize(size)
    showNode:align(display.CENTER, 427, 265):addTo(self)
    self.showNode = showNode

    self:initView()

    self.showNode:setScale(0.5)
    self.showNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function UserAgreementUI:initView()
    local img_bg_1 = cc.Scale9Sprite:create("app/win/useragreement/bg_1.png")
    img_bg_1:setCapInsets(CCRectMake(5, 5, 5, 5))
    img_bg_1:setContentSize(cc.size(854, 530))
    img_bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(self.showNode)

    local function onClickEvent(target)
        self:onClose()
    end
    GameUtil.addEnlargeBtn("app/win/useragreement/bnt_close3.png", 2, onClickEvent):align(display.CENTER, 820, 500):addTo(img_bg_1)

    local lbl_1 = cc.Label:createWithTTF(LangCtrl:getLang().word301, GameDefine.FontName, 36):align(display.CENTER, 427, 495):addTo(img_bg_1)
    lbl_1:setColor(cc.c3b(162, 92, 53))

    local img_bg_2 = cc.Scale9Sprite:create("app/win/useragreement/bg_2.png")
    img_bg_2:setCapInsets(CCRectMake(5, 5, 5, 5))
    img_bg_2:setContentSize(cc.size(778, 426))
    img_bg_2:align(display.CENTER_BOTTOM, 427, 35):addTo(img_bg_1)

    local webView = nil
    if PlazaManager.isPhoneAndPadPlatform() == true then
        webView = ccexp.WebView:create()
        webView:setPosition(427, 250)
        webView:setContentSize(758, 400)
        webView:loadURL(PlazaManager.urlGameConfig.userAgreementUrl)
        -- webView:loadFile("app/useragreement.html")
        webView:setScalesPageToFit(false)

        webView:setOnShouldStartLoading(function(sender, url)
            -- print("onWebViewShouldStartLoading, url is ", url)
            return true
        end)
        webView:setOnDidFinishLoading(function(sender, url)
            -- print("onWebViewDidFinishLoading, url is ", url)
        end)
        webView:setOnDidFailLoading(function(sender, url)
            -- print("onWebViewDidFinishLoading, url is ", url)
        end)
        img_bg_1:addChild(webView)
    end
end

return UserAgreementUI
