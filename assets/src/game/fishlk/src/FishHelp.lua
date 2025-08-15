-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishHelp = class("FishHelp")
local function getRes(path)
    return "game/fishlk/res/" .. path
end

function FishHelp:ctor(m_UILayer)
    self.m_UILayer = m_UILayer
    self.rootNode = cc.CSLoader:createNode(getRes("Help.csb"))
    self.rootNode:setPosition(cc.p(self.m_UILayer:getContentSize().width / 2, self.m_UILayer:getContentSize().height / 2))
    self.rootNode:setAnchorPoint(display.CENTER)
    self.rootNode:setVisible(false)
    self.m_UILayer:addChild(self.rootNode)

    local BG = self.rootNode:getChildByName("help_BG")
    BG:getChildByName("btn_close"):addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            self:hideHelp()
        end
    end)
end

function FishHelp:showHelp()
    self.rootNode:setVisible(true);
end

function FishHelp:hideHelp()
    self.rootNode:setVisible(false);
end

function FishHelp:isVisible()
    return self.rootNode:isVisible()
end
return FishHelp
-- endregion
