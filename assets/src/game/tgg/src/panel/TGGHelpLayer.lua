------------------------------------------------------------------------
local TGGHelpLayer = class("TGGHelpLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function TGGHelpLayer:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/tgg/res/TGGHelpLayer.csb")
    self:addChild(self.layer)

    local Image_bg = self.layer:getChildByName("Image_bg")
    Image_bg:loadTexture("game/tgg/res/tggbig/kuang.png", 0)

    self.PageView_1 = self.layer:getChildByName("PageView_1")
    self.PageView_1:setScrollDuration(0.5)
    self.PageView_1:setIndicatorEnabled(true)
    self.PageView_1:setIndicatorPosition(cc.p(480, 0))
    local res =
        {"game/tgg/res/tggbig/img_help1.png", "game/tgg/res/tggbig/img_help2.png", "game/tgg/res/tggbig/img_help3.png", "game/tgg/res/tggbig/img_help4.png", "game/tgg/res/tggbig/img_help5.png"}

    for k, v in ipairs(res) do
        local pageView = ccui.ImageView:create(v, 0)
        pageView:ignoreContentAdaptWithSize(false)
        pageView:setContentSize(cc.size(960, 540))
        self.PageView_1:addPage(pageView)
    end

    self.PageView_1:setCurPageIndex(0)

    -- self.Button_left = self.layer:getChildByName('Button_left')
    -- self.Button_left:addClickEventListener(handler(self, self.onClickLeft))

    -- self.Button_right = self.layer:getChildByName('Button_right')
    -- self.Button_right:addClickEventListener(handler(self, self.onClickRight))

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))

    self.nCurIdx = 0
end

function TGGHelpLayer:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function TGGHelpLayer:onClickLeft()
    PlazaManager.playClickEffect()
    self.nCurIdx = self.nCurIdx - 1
    if self.nCurIdx < 0 then
        self.nCurIdx = 4
    end
    self.PageView_1:scrollToPage(self.nCurIdx, 0.5)
end

function TGGHelpLayer:onClickRight()
    PlazaManager.playClickEffect()
    self.nCurIdx = self.nCurIdx + 1
    if self.nCurIdx > 4 then
        self.nCurIdx = 0
    end
    self.PageView_1:scrollToPage(self.nCurIdx, 0.5)
end

function TGGHelpLayer:doClose()
    PlazaManager.playClickEffect()
    self:removeFromParent()
end

function TGGHelpLayer:onEnterTransitionFinish()
end

function TGGHelpLayer:onExit()
end

return TGGHelpLayer
