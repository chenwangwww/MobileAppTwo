-- 奖励信息和压线分布说明
------------------------------------------------------------------------
local HappyFruitHelpLayer = class("HappyFruitHelpLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function HappyFruitHelpLayer:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/happyfruit/res/HappyFruitHelpLayer.csb")
    self:addChild(self.layer)

    local Image_8 = self.layer:getChildByName("Image_8")
    Image_8:loadTexture("game/happyfruit/res/png_res/fruit_machine_JLB.png", 0)

    self.Image_4 = self.layer:getChildByName("Image_4") -- 切换按钮
    self.Image_4:setTouchEnabled(true)
    self.Image_4:addClickEventListener(handler(self, self.doSwitch))

    self.Image_5 = self.layer:getChildByName("Image_5") -- 奖励信息
    self.Image_6 = self.layer:getChildByName("Image_6") -- 压线分布
    self.Image_8 = self.layer:getChildByName("Image_8") -- 奖励信息显示
    self.Panel_1 = self.layer:getChildByName("Panel_1") -- 压线分布显示

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))

    self.Image_action = self.layer:getChildByName("Image_action")
    self.Image_action:setTouchEnabled(true)

    self.nCurIdx = 1
end

function HappyFruitHelpLayer:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function HappyFruitHelpLayer:doSwitch()
    if self.nCurIdx == 1 then
        self.Image_8:setVisible(false)
        self.Panel_1:setVisible(true)
        self.Image_5:loadTexture("fruit_machine_zjl.png", 1)
        self.Image_6:loadTexture("fruit_machine_hyx.png", 1)
        self.Image_action:runAction(cc.MoveTo:create(0.1, cc.p(775, 658)))
        self.nCurIdx = 2
    else
        self.Image_8:setVisible(true)
        self.Panel_1:setVisible(false)
        self.Image_5:loadTexture("fruit_machine_hjl.png", 1)
        self.Image_6:loadTexture("fruit_machine_zyx.png", 1)
        self.Image_action:runAction(cc.MoveTo:create(0.1, cc.p(559, 658)))
        self.nCurIdx = 1
    end
end

function HappyFruitHelpLayer:doClose()
    self:removeFromParent()
end

function HappyFruitHelpLayer:onEnterTransitionFinish()

end

function HappyFruitHelpLayer:onExit()

end

return HappyFruitHelpLayer
