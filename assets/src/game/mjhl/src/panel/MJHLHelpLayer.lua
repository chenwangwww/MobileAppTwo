------------------------------------------------------------------------
local MJHLHelpLayer = class("MJHLHelpLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function MJHLHelpLayer:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/mjhl/res/MJHLHelpLayer.csb")
    self:addChild(self.layer)

    self.ScrollView_1 = self.layer:getChildByName("ScrollView_1")
    self.ScrollView_1:setInnerContainerSize(cc.size(750, 5770))

    local pageView = ccui.ImageView:create("game/mjhl/res/mjhl_bigimg/img_help2.jpg", 0)
    pageView:ignoreContentAdaptWithSize(false)
    pageView:setContentSize(cc.size(750, 2752))
    pageView:setAnchorPoint(display.LEFT_BOTTOM)
    pageView:setPosition(0, 0)
    self.ScrollView_1:addChild(pageView)

    pageView = ccui.ImageView:create("game/mjhl/res/mjhl_bigimg/img_help1.jpg", 0)
    pageView:ignoreContentAdaptWithSize(false)
    pageView:setContentSize(cc.size(750, 3018))
    pageView:setAnchorPoint(display.LEFT_BOTTOM)
    pageView:setPosition(0, 2752)
    self.ScrollView_1:addChild(pageView)

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))
end

function MJHLHelpLayer:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function MJHLHelpLayer:doClose()
    PlazaManager.playClickEffect()
    self:removeFromParent()
end

function MJHLHelpLayer:onEnterTransitionFinish()
end

function MJHLHelpLayer:onExit()
end

return MJHLHelpLayer
