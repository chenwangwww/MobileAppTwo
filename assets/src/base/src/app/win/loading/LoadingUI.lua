local LoadingUI = class("LoadingUI", require("app.win.base.GameWindowBase"))

function LoadingUI:ctor()
    local size = cc.size(400, 20)
    LoadingUI.super.ctor(self, size)
    self:initView(size)
end

function LoadingUI:initView(size)
    local node = cc.Node:create()
    local progBg = display.newSprite("app/common/progress/bgprogress1.png")
    local bgsize = progBg:getContentSize()
    node:setContentSize(size)
    node:move(0, 0):addTo(self)

    local function onTouchBegan(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)
    progBg:move(bgsize.width / 2, bgsize.height / 2):addTo(node)

    self.progSp = cc.ProgressTimer:create(display.newSprite("app/common/progress/progress1.png"))
    self.progSp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progSp:setBarChangeRate(display.RIGHT_BOTTOM);
    self.progSp:setMidpoint(display.LEFT_TOP);
    self.progSp:setPosition(bgsize.width / 2, bgsize.height / 2):addTo(node)

    self.lbl = cc.Label:createWithTTF(LangCtrl:getLang().word283, GameDefine.FontName, 16)
    self.lbl:setColor(cc.WHITE)
    self.lbl:setAnchorPoint(display.CENTER)
    self.lbl:setPosition(cc.p(bgsize.width / 2, bgsize.height / 2))
    self.lbl:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    node:addChild(self.lbl)
end

function LoadingUI:setPercent(percent)
    if percent == nil or type(percent) ~= "number" then
        return
    end
    self.progSp:setPercentage(percent)
    self.lbl:setString(string.format(LangCtrl:getLang().word296, percent))
end

return LoadingUI

-- endregion
