local ShopCopyWeChat = class("ShopCopyWeChat", require("app.win.base.GameWindowWinBase"))

function ShopCopyWeChat:ctor(wechat)
    local platform = cc.Application:getInstance():getTargetPlatform()
    self.isCanCopy = platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD or platform == cc.PLATFORM_OS_ANDROID

    if self.isCanCopy and PlazaManager.isPhoneAndPadPlatform() == true then
        game.systemCopy("")
    end

    self.wechat = wechat
    ShopCopyWeChat.super.ctor(self, LangCtrl:getLang().word216, true)
    self:setName("ShopCopyWeChat")
    self:addCloseBtn()

    self:initView()
end

function ShopCopyWeChat:onEnter()
    ShopCopyWeChat.super.onEnter(self)
end

function ShopCopyWeChat:onExit()
    ShopCopyWeChat.super.onExit(self)
end

function ShopCopyWeChat:onClearUp()
    self:disableNodeEvents()
    ShopCopyWeChat.super.onClearUp(self)
end

---------------------ui函数------------------------------
function ShopCopyWeChat:initView()

    -- local avatarurl = string.trim(self.wechat.szFaceAddr or "")
    -- local avatarurl = PlazaManager.urlGameConfig.shopAvatarUrl
    -- local faceAddr = nil
    --[[暂时屏蔽
    if avatarurl and string.len(avatarurl) > 0 then
        faceAddr = avatarurl .. self.wechat.dwGameID .. os.date('.jpg?time=%Y%m%d%H', os.time())
    end
    --]]
    -- GameUtil.createAvatar(faceAddr, 200, false, nil, nil, nil, false):align(display.CENTER_BOTTOM, self.midWidth, self.midHeight + 20):addTo(self.panelNode)

    local headres = "app/win/shop/img_sc_weixin.png"
    if LangCtrl:isEng() then
        headres = "app/win/shop/img_sc_line.png"
    end
    local head = cc.Sprite:create(headres):setScale(1.2)
    head:addTo(self.panelNode):align(display.CENTER_BOTTOM, self.midWidth, self.midHeight + 20)

    GameUtil.createLabel(LangCtrl:getLang().word82 .. self.wechat.szWeixin, 24, cc.c3b(0xbc, 0xde, 0xff), display.CENTER, cc.p(self.midWidth, self.midHeight - 30), GameDefine.FontName, nil, nil, nil,
        true, false):addTo(self.panelNode)

    GameUtil.createLabel(LangCtrl:getLang().word217, 24, GameDefine.FontColor, display.CENTER, cc.p(self.midWidth, self.midHeight - 80), GameDefine.FontName, nil, nil, nil, true, false):addTo(
        self.panelNode)

    -- 在业界拥有良好的口碑，深受广大贵宾的信赖， 
    -- VIP专人全程为您服务，快捷、安全、稳定、可靠，亲可以放心添加充值。
    local lbl =
        GameUtil.createLabel(LangCtrl:getLang().word218, 20, GameDefine.FontColor, display.CENTER, cc.p(self.midWidth, self.midHeight - 120), GameDefine.FontName, nil, nil, nil, true, false):addTo(
            self.panelNode)

    lbl:setMaxLineWidth(700)
    lbl:setLineBreakWithoutSpace(false)

    local function onBtnclick(sender)
        if self.isCanCopy then
            game.systemCopy(self.wechat.szWeixin)
            -- "成功复制微信号，请自己打开微信搜粘贴搜索，然后添加代理进行充值~"
            PlazaManager.showTips(LangCtrl:getLang().word219)
            -- GameUtil.openAppByIdx(1)
        else
            PlazaManager.showTips(LangCtrl:getLang().word84)
        end
    end
    local btnres = "app/common/button/btn1.png"
    local btn_buy = GameUtil.createButton(btnres, nil, onBtnclick):move(self.midWidth, 100):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word26, btn_buy) -- 复制
end

function ShopCopyWeChat:openShopPayWin(wechat)
    local win = ShopCopyWeChat.new(wechat)
    win:setCenterOnScene()
    win:addToOnCheckExist(display.getRunningScene())
end
return ShopCopyWeChat
