-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishSettings = class("FishSettings")
local function getRes(path)
    return "game/fishlk/res/" .. path
end
function FishSettings:ctor(m_UILayer)
    self.m_UILayer = m_UILayer
    self.rootNode = cc.CSLoader:createNode(getRes("FishSetting.csb"))
    self.rootNode:setPosition(cc.p(self.m_UILayer:getContentSize().width / 2, self.m_UILayer:getContentSize().height / 2))
    self.rootNode:setAnchorPoint(display.CENTER)
    self.rootNode:setVisible(false)
    self.m_UILayer:addChild(self.rootNode)

    local BG = self.rootNode:getChildByName("BG")
    BG:getChildByName("Btn_ok"):addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            self:hideSettings()
        end
    end)

    self.Slider_music = BG:getChildByName("music_slider")
    self.Slider_music:setPercent(MusicManager.getMusicVal())
    self.Slider_music:addEventListener(function(pSender, eventType)
        if eventType == 0 then
            local percent = pSender:getPercent()
            local volume = percent
            MusicManager.setBGMVolume(volume)
        end
    end)

    self.Slider_effect = BG:getChildByName("effect_slider")
    self.Slider_effect:setPercent(MusicManager.getEffectVal())
    self.Slider_effect:addEventListener(function(pSender, eventType)
        if eventType == 0 then
            local percent = pSender:getPercent()
            local volume = percent
            MusicManager.setEffectVolume(volume)
        end
    end)

    local music_checkBox = BG:getChildByName("music_checkbox")
    music_checkBox:addEventListenerCheckBox(function(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            MusicManager.setBGMVolume(30)
            self.Slider_music:setPercent(30)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            MusicManager.setBGMVolume(0)
            self.Slider_music:setPercent(0)
        end
    end)

    local effect_checkBox = BG:getChildByName("effect_checkbox")
    effect_checkBox:addEventListenerCheckBox(function(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            MusicManager.setEffectVolume(30)
            self.Slider_effect:setPercent(30)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            MusicManager.setEffectVolume(0)
            self.Slider_effect:setPercent(0)
        end
    end)
end

function FishSettings:showSettings()
    self.rootNode:setVisible(true);
end

function FishSettings:hideSettings()
    self.rootNode:setVisible(false);
end

function FishSettings:isVisible()
    return self.rootNode:isVisible()
end

return FishSettings
-- endregion
