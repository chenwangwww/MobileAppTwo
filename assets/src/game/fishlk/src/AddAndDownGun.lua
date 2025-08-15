-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local AddAndDownGun = class("AddAndDownGun", function()
    return cc.LayerColor:create()
end)

function AddAndDownGun:ctor(FishScene, wChairID)
    self.FishGame = FishScene
    self.wChairID = wChairID
    self:initWithColor(ccc4(255, 0, 0, 0))
    self.m_widget = ccui.Widget:create()
    self.m_widget:setContentSize(cc.size(146, 66))
    self.m_widget:addTo(self)
    self.m_widget:setTouchEnabled(false)

    local function downGunClick(args)
        self.FishGame.m_fishUI:downGun()
    end
    local pdownGun = GameUtil.createScaleButton("down_gun.png", "down_gun_1.png", 1.5, cc.p(62, 32.5), 1, downGunClick)
    --[[local pdownGun = ccui.Button:create("down_gun.png","down_gun_1.png","down_gun_1.png",1)
    pdownGun:addTouchEventListener(function(uiwidget, eventType)
		if eventType==ccui.TouchEventType.began then
		    self.FishGame.m_fishUI:downGun()     
	    end
	end)--]]
    pdownGun:setPosition(cc.p(-25, 32.5))
    pdownGun:setTag(0)
    self.m_widget:addChild(pdownGun)

    local function paddGunClick(args)
        self.FishGame.m_fishUI:addGun()
    end
    local paddGun = GameUtil.createScaleButton("up_gun.png", "up_gun_1.png", 1.5, cc.p(31, 32.5), 1, paddGunClick)
    --[[local paddGun = ccui.Button:create("up_gun.png","up_gun_1.png","up_gun_1.png",1)
    paddGun:addTouchEventListener(function(uiwidget, eventType)
		if eventType==ccui.TouchEventType.began then
		    self.FishGame.m_fishUI:addGun()     
	    end
	end) --]]
    paddGun:setPosition(cc.p(220, 32.5))
    paddGun:setTag(1)
    self.m_widget:addChild(paddGun)
end

function AddAndDownGun:showAddAndDownGun()
    -- self:setVisible(true)
    self.m_widget:setTouchEnabled(true)
    self.m_widget:getChildByTag(0):setTouchEnabled(true)
    self.m_widget:getChildByTag(1):setTouchEnabled(true)
end

function AddAndDownGun:hideAddAndDownGun()
    -- self:setVisible(false)
    self.m_widget:getChildByTag(0):setTouchEnabled(false)
    self.m_widget:getChildByTag(1):setTouchEnabled(false)
    self.m_widget:setTouchEnabled(false)
end
return AddAndDownGun
-- endregion
