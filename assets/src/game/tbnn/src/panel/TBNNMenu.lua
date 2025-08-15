--[[
TBNNMenu.lua

]] local GameCMD = require("game.tbnn.src.TBNNCMD")

local START_POSY = 925
local END_POSY = 420

local TBNNMenu = class("TBNNMenu")

TBNNMenu.Type = {
    CHANGE_TAB = "RatholingBut",
    RULE = "RulesBut",
    SETTING = "SetBut",
    RETURN = "ExitBut"
}

function TBNNMenu:ctor(root)
    self.root_ = root
    self.btnMenu_ = self.root_:getChildByName("btn_menu")
    self.btnMenu_:addClickEventListener(function()
        self.btnMenu_:setTouchEnabled(false)
        self.btnMenu_:setScaleY(-1)
        self.pnlMenu_:moveTo{
            time = 0.2,
            x = 120,
            y = END_POSY
        }
    end)
    self.pnlMenu_ = self.root_:getChildByName("pnl_menu")

    local function onTouchBegan(touch, event)
        self:close()
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.root_:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.root_)
end

function TBNNMenu:addClickCallback(callback)
    for k, widgetName in pairs(TBNNMenu.Type) do
        local widget = self.pnlMenu_:getChildByName(widgetName)
        if widget then
            widget:addClickEventListener(function()
                self:close()
                if callback then
                    callback(widgetName)
                end
            end)
        end
    end
end

function TBNNMenu:close()
    self.btnMenu_:setScaleY(1)
    self.btnMenu_:setTouchEnabled(true)
    self.pnlMenu_:moveTo{
        time = 0.2,
        x = 120,
        y = START_POSY
    }
end

return TBNNMenu
