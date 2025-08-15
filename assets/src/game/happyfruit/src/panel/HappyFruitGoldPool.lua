-- 奖池信息
------------------------------------------------------------------------
local HappyFruitGoldPool = class("HappyFruitGoldPool", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function HappyFruitGoldPool:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/happyfruit/res/HappyFruitGoldPool.csb")
    self:addChild(self.layer)

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))

    self.Text_1 = self.layer:getChildByName("Text_1")
    self.Image_9 = self.layer:getChildByName("Image_9")
    self.Text_GoldInfo = self.layer:getChildByName("Text_GoldInfo")
    self.Text_GoldInfo:ignoreContentAdaptWithSize(false)
    self.Text_GoldInfo:setSize(cc.size(930, 120))

    self:updatePool()
    self:updateInfo()

    self.onEventUpdatePool = handler(self, self.updatePool)
    game.registerEvent("EventUpdateGoldPool", self.onEventUpdatePool)

    self.onEventUpdateInfo = handler(self, self.updateInfo)
    game.registerEvent("EventUpdateFruitLastGoldInfo", self.onEventUpdateInfo)

    if LangCtrl:isEng() then
        local Text_2 = self.layer:getChildByName("Text_2")
        Text_2:setString(SubLang:word(10))
        Text_2:setFontSize(26)

        local Text_3 = self.layer:getChildByName("Text_3")
        Text_3:setString(SubLang:word(11))
        local x, y = Text_3:getPosition()
        Text_3:setPositionX(x + 30)

        local Text_4 = self.layer:getChildByName("Text_4")
        Text_4:setString(SubLang:word(12))
        local Text_5 = self.layer:getChildByName("Text_5")
        Text_5:setString(SubLang:word(13))
        x, y = Text_5:getPosition()
        Text_5:setPositionX(x + 10)

        local Text_6 = self.layer:getChildByName("Text_6")
        Text_6:setString(SubLang:word(12))
        local Text_7 = self.layer:getChildByName("Text_7")
        Text_7:setString(SubLang:word(13))
        x, y = Text_7:getPosition()
        Text_7:setPositionX(x + 10)

        local Text_8 = self.layer:getChildByName("Text_8")
        Text_8:setString(SubLang:word(12))
        local Text_9 = self.layer:getChildByName("Text_9")
        Text_9:setString(SubLang:word(13))
        x, y = Text_9:getPosition()
        Text_9:setPositionX(x + 10)
    end

    -- GameUtil.printNodeTree(1, " - ", self.layer)
end

function HappyFruitGoldPool:updateInfo()
    self.Text_GoldInfo:setString(self.scene.lastMesgInfo)
end

function HappyFruitGoldPool:updatePool()
    local num = self.logic:getPoolCount()
    self.Text_1:setString(num)
    local s = self.Text_1:getContentSize()
    self.Image_9:setPositionX(display.cx - s.width / 2 - 50)
end

function HappyFruitGoldPool:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function HappyFruitGoldPool:doClose()
    self:removeFromParent()
end

function HappyFruitGoldPool:onEnterTransitionFinish()

end

function HappyFruitGoldPool:onExit()
    game.unregisterEvent("EventUpdateGoldPool", self.onEventUpdatePool)
    game.unregisterEvent("EventUpdateFruitLastGoldInfo", self.onEventUpdateInfo)
end

return HappyFruitGoldPool
