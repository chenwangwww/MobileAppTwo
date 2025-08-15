------------------------------------------------------------------------
local MLCSSettingLayer = class("MLCSSettingLayer", function()
    return cc.LayerColor:create(cc.c4b(0, 0, 0, 180), display.width, display.height)
end)

function MLCSSettingLayer:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self:enableNodeEvents()
    self:addWinClick()

    self.layer = cc.CSLoader:createNode("game/mlcs/res/MLCSSettingLayer.csb")
    self:addChild(self.layer)

    local Image_bg = self.layer:getChildByName("Image_bg")
    Image_bg:loadTexture("game/mlcs/res/bigbg/settingbg.png", 0)

    if LangCtrl:isEng() then
        local Image_title = Image_bg:getChildByName("Image_title")
        Image_title:setPositionY(258)
        GameUtil.convImgToTTF(Image_title, SubLang:word(6), 36)
    end

    local function onCheckSelectedEvent1(sender, eventType)
        PlazaManager.playClickEffect()
        if eventType == ccui.CheckBoxEventType.selected then
            MusicManager.setBGMVolume(100)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            MusicManager.setBGMVolume(0)
        end
    end
    self.CheckBox_music = self.layer:getChildByName("CheckBox_music")
    self.CheckBox_music:addEventListener(onCheckSelectedEvent1)
    self.CheckBox_music:setSelected(MusicManager.musicVal > 0)

    local function onCheckSelectedEvent2(sender, eventType)
        PlazaManager.playClickEffect()
        if eventType == ccui.CheckBoxEventType.selected then
            MusicManager.setEffectVolume(100)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            MusicManager.setEffectVolume(0)
        end
    end
    self.CheckBox_yinxiao = self.layer:getChildByName("CheckBox_yinxiao")
    self.CheckBox_yinxiao:addEventListener(onCheckSelectedEvent2)
    self.CheckBox_yinxiao:setSelected(MusicManager.effectVal > 0)

    self.Button_close = self.layer:getChildByName("Button_close")
    self.Button_close:addClickEventListener(handler(self, self.doClose))
end

function MLCSSettingLayer:addWinClick()
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function MLCSSettingLayer:doClose()
    PlazaManager.playClickEffect()
    self:removeFromParent()
end

function MLCSSettingLayer:onEnterTransitionFinish()
end

function MLCSSettingLayer:onExit()

end

return MLCSSettingLayer

