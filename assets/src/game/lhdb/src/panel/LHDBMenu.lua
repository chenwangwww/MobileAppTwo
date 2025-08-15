--[[
LHDBMenu.lua

]] local LHDBMenu = class("LHDBMenu")

LHDBMenu.Type = {
    RULE = 2,
    SETTING = 3,
    RETURN = 4
}

function LHDBMenu:ctor(root)
    self.root_ = root
    self.pnlList_ = self.root_:getChildByName("pnl_buttons")
    local btnMenu = self.root_:getChildByName("btn_menu")
    self.imgArrow_ = btnMenu:getChildByName("MenuArrow")

    self:clean()

    local function onTouchBegan(touch, event)
        self:clean()
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.root_:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.root_)
end

local function showList(self, visible)
    self.pnlList_:setVisible(visible)
    self.root_:getChildByName("img_bg"):setVisible(visible)
end

function LHDBMenu:addClickCallback(callback)
    local btnSwitch = self.root_:getChildByName("btn_menu")
    btnSwitch:addClickEventListener(function()
        self.imgArrow_:setScaleY(-1)
        btnSwitch:setTouchEnabled(false)
        showList(self, true)
    end)
    local clickCallback = function(typ)
        if callback then
            callback(typ)
        end
        self:clean()
    end
    self.pnlList_:getChildByName("BtnHelp"):addClickEventListener(handler(LHDBMenu.Type.RULE, clickCallback))
    self.pnlList_:getChildByName("BtnSet"):addClickEventListener(handler(LHDBMenu.Type.SETTING, clickCallback))
    self.pnlList_:getChildByName("BtnBack"):addClickEventListener(handler(LHDBMenu.Type.RETURN, clickCallback))
end

function LHDBMenu:clean()
    local btnMenu = self.root_:getChildByName("btn_menu")
    btnMenu:setTouchEnabled(true)
    self.imgArrow_:setScaleY(1)
    showList(self, false)
end

return LHDBMenu
