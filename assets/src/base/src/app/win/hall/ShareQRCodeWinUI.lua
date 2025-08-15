local ShareQRCodeWinUI = class("ShareQRCodeWinUI", require("app.win.base.GameWindowWinBase"))

function ShareQRCodeWinUI:ctor(wechat)
    ShareQRCodeWinUI.super.ctor(self, LangCtrl:getLang().word317, true, false, cc.size(766, 532))

    self.wechat = wechat

    self:setName("ShareQRCodeWinUI")
    self:initView()
end

function ShareQRCodeWinUI:onEnter()
    ShareQRCodeWinUI.super.onEnter(self)
end

function ShareQRCodeWinUI:onExit()
    ShareQRCodeWinUI.super.onExit(self)
end

function ShareQRCodeWinUI:onClearUp()
    self:disableNodeEvents()
    ShareQRCodeWinUI.super.onClearUp(self)
end

---------------------ui函数------------------------------
function ShareQRCodeWinUI:initView()

    GameUtil.newSprite("app/win/qrcode_share/npc_fx.png", false):align(display.LEFT_BOTTOM, -60, 0):addTo(self.panelNode)

    self:addCloseBtn()

    local img_pos_x = self.midWidth + 110

    ----[[
    local canGen = PlazaManager.platform == cc.PLATFORM_OS_ANDROID or PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD
    local qrcode_width = 260
    -- local canGen = false

    if canGen then
        local qrcode_str = globalUserInfo.qrcodeShareContent
        if qrcode_str == nil or qrcode_str == "" then
            qrcode_str = "AmazingGame"
        end

        local qrnode = game.generateQRCode(qrcode_str, qrcode_width)
        qrnode:setAnchorPoint(display.CENTER)
        self.panelNode:addChild(qrnode)
        qrnode:setPosition(img_pos_x, self.midHeight)
    else
        local qrcode_image = ccui.ImageView:create("app/win/shop/img_sc_weixin.png", 0)
        qrcode_image:setPosition(img_pos_x, self.midHeight)
        qrcode_image:ignoreContentAdaptWithSize(false)
        qrcode_image:setContentSize(cc.size(qrcode_width, qrcode_width))
        self.panelNode:addChild(qrcode_image)
    end
    -- ]]

    GameUtil.createLabel(LangCtrl:getLang().word119, 24, GameDefine.FontColor, display.CENTER, cc.p(img_pos_x, 55), GameDefine.FontName, nil, nil, nil, true, false):addTo(self.panelNode)
end

function ShareQRCodeWinUI:openView()
    local win = ShareQRCodeWinUI.new()
    win:setCenterOnScene()
    win:addToOnCheckExist(display.getRunningScene())
end
return ShareQRCodeWinUI
