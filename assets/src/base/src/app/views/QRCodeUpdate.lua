local QRCodeUpdate = class("QRCodeUpdate", require("app.win.base.GameWindowWinBase"))

function QRCodeUpdate:ctor(qrcode_str, tips)
    -- 版本更新
    QRCodeUpdate.super.ctor(self, LangCtrl:getLang().word27, true, false, cc.size(766, 532))
    self.qrcode_str = qrcode_str
    self.tips = tips or ""

    self:setName("QRCodeUpdate")
    self:initView()
end

function QRCodeUpdate:onEnter()
    QRCodeUpdate.super.onEnter(self)
end

function QRCodeUpdate:onExit()
    QRCodeUpdate.super.onExit(self)
end

function QRCodeUpdate:onClearUp()
    self:disableNodeEvents()
    QRCodeUpdate.super.onClearUp(self)
end

---------------------ui函数------------------------------
function QRCodeUpdate:initView()
    local img_pos_x = self.midWidth

    ----[[
    local canGen = PlazaManager.platform == cc.PLATFORM_OS_ANDROID or PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD
    local qrcode_width = 260
    -- local canGen = false

    if canGen then
        local qrnode = game.generateQRCode(self.qrcode_str, qrcode_width)
        qrnode:setAnchorPoint(display.CENTER)
        self.panelNode:addChild(qrnode)
        qrnode:setPosition(img_pos_x, self.midHeight + 30)
    else
        local qrcode_image = ccui.ImageView:create("app/win/shop/img_sc_weixin.png", 0)
        qrcode_image:setPosition(img_pos_x, self.midHeight + 30)
        qrcode_image:ignoreContentAdaptWithSize(false)
        qrcode_image:setContentSize(cc.size(qrcode_width, qrcode_width))
        self.panelNode:addChild(qrcode_image)
    end
    -- ]]

    local txt = GameUtil.createLabel(self.tips, 24, GameDefine.FontColor, display.CENTER, cc.p(img_pos_x, 125), GameDefine.FontName, nil, nil, nil, true, false):addTo(self.panelNode)
    txt:setLineHeight(28)
    txt:setAdditionalKerning(1)
    txt:setMaxLineWidth(680)
    txt:setLineBreakWithoutSpace(false)

    local function onYesCallBack()
        cc.Director:getInstance():endToLua()
    end
    local yesBtn = ccui.Button:create("app/common/button/btn1.png")
    yesBtn:addClickEventListener(onYesCallBack)
    yesBtn:setZoomScale(-0.1)
    yesBtn:align(display.CENTER, img_pos_x, 50):addTo(self.panelNode)
    GameUtil.addBtnTTF2("OK", yesBtn) -- 退出游戏
end

function QRCodeUpdate:openView(qrcode_str, tips)
    local win = QRCodeUpdate.new(qrcode_str, tips)
    win:setCenterOnScene()
    win:addToOnCheckExist(display.getRunningScene())
end
return QRCodeUpdate
