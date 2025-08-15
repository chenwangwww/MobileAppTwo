local SocialShare = class("SocialShare", function()
    return cc.Node:create()
end)

function SocialShare:ctor()
    self.winSize = cc.size(600, 300)
    self:setContentSize(self.winSize)
    self.midWidth, self.midHeight = self.winSize.width / 2, self.winSize.height / 2

    local function onNodeEvent(event)
        if event == "exit" then
        elseif event == "cleanup" then

        end
    end
    self:registerScriptHandler(onNodeEvent)

    self:addNodeTouch()
end

function SocialShare:addNodeTouch()
    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = self:convertToNodeSpace(loc)
        local rect = cc.rect(0, 0, self.winSize.width, self.winSize.height)
        if not cc.rectContainsPoint(rect, pos) then
            self:runAction(cc.CallFunc:create(function()
                self:removeFromParent()
            end))
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function SocialShare:addBlackMask()
    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(self.winSize.width / 5)
    mask:setScaleY(self.winSize.height / 5)
    mask:setPosition(self.midWidth, self.midHeight)
    mask:setOpacity(180):addTo(self)
end

function SocialShare:addNodeBg()
    local bg_2 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    bg_2:setCapInsets(GameDefine.PanelRect2)
    bg_2:setContentSize(self.winSize)
    bg_2:align(display.LEFT_BOTTOM, 0, 0):addTo(self)
end

function SocialShare:addShareText(text)
    local bg_3 = ccui.Scale9Sprite:create("app/common/comwin/edit_bg.png")
    bg_3:setCapInsets(cc.rect(3, 3, 2, 2))
    bg_3:setContentSize(self.winSize.width - 40, 150)
    bg_3:align(display.CENTER_TOP, self.midWidth, self.winSize.height - 20):addTo(self)

    local tips = cc.Label:createWithTTF("已复制，快去粘贴给好友吧~", "app/fonts/fzcs.ttf", 22)
    tips:setColor(GameDefine.FontColor):setCascadeOpacityEnabled(true)
    tips:align(display.CENTER_TOP, cc.p(self.midWidth, self.winSize.height - 30)):addTo(self)

    local content = cc.Label:createWithTTF(text, "app/fonts/fzz.ttf", 22)
    content:setColor(GameDefine.FontColor):setCascadeOpacityEnabled(true)
    content:setMaxLineWidth(self.winSize.width - 60)
    content:setLineBreakWithoutSpace(false)
    content:setLineHeight(30)
    content:setAdditionalKerning(1)
    content:align(display.CENTER_TOP, cc.p(self.midWidth, self.winSize.height - 70)):addTo(self)
end

function SocialShare:addShareBtn()
    local function onWXclick(sender)
        GameUtil.openAppByIdx(1)
        self:removeFromParent()
    end
    local btnres = "app/win/shop/social_wx_img.png"
    GameUtil.addEnlargeBtn(btnres, 1, onWXclick):align(display.CENTER, self.winSize.width / 4, 70):addTo(self)
    local function onQQclick(sender)
        GameUtil.openAppByIdx(2)
        self:removeFromParent()
    end
    btnres = "app/win/shop/social_qq_img.png"
    GameUtil.addEnlargeBtn(btnres, 1, onQQclick):align(display.CENTER, 3 * self.winSize.width / 4, 70):addTo(self)
end

return SocialShare

