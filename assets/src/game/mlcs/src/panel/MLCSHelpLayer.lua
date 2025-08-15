------------------------------------------------------------------------
local MLCSHelpLayer = class("MLCSHelpLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function MLCSHelpLayer:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/mlcs/res/MLCSHelpLayer.csb")
    self:addChild(self.layer)

    local Image_bg = self.layer:getChildByName("Image_bg")
    Image_bg:loadTexture("game/mlcs/res/bigbg/rulebg.png", 0)

    self.PageView_1 = self.layer:getChildByName("PageView_1")
    self.PageView_1:setScrollDuration(0.5)

    local pageView = ccui.ImageView:create("game/mlcs/res/bigbg/rule_1.png", 0)
    self.PageView_1:addPage(pageView)

    pageView = ccui.ImageView:create("game/mlcs/res/bigbg/rule_2.png", 0)
    self.PageView_1:addPage(pageView)

    pageView = ccui.ImageView:create("game/mlcs/res/bigbg/rule_3.png", 0)
    self.PageView_1:addPage(pageView)

    self.PageView_1:setCurPageIndex(0)

    self.Button_left = self.layer:getChildByName("Button_left")
    self.Button_left:addClickEventListener(handler(self, self.onClickLeft))

    self.Button_right = self.layer:getChildByName("Button_right")
    self.Button_right:addClickEventListener(handler(self, self.onClickRight))

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))

    self.nCurIdx = 0
end

function MLCSHelpLayer:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function MLCSHelpLayer:onClickLeft()
    PlazaManager.playClickEffect()
    self.nCurIdx = self.nCurIdx - 1
    if self.nCurIdx < 0 then
        self.nCurIdx = 2
    end
    self.PageView_1:scrollToPage(self.nCurIdx, 0.5)
end

function MLCSHelpLayer:onClickRight()
    PlazaManager.playClickEffect()
    self.nCurIdx = self.nCurIdx + 1
    if self.nCurIdx > 2 then
        self.nCurIdx = 0
    end
    self.PageView_1:scrollToPage(self.nCurIdx, 0.5)
end

function MLCSHelpLayer:doClose()
    PlazaManager.playClickEffect()
    self:removeFromParent()
end

function MLCSHelpLayer:onEnterTransitionFinish()
end

function MLCSHelpLayer:onExit()

end

return MLCSHelpLayer
