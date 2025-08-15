local GameWindowBase = class("GameWindowBase", function()
    return display.newLayer()
end)

function GameWindowBase:ctor(size, isShowMask, isOpenBgClick)
    self.winSize = size
    self.midWidth = self.winSize.width / 2
    self.midHeight = self.winSize.height / 2
    self:setContentSize(size)
    self:onSwallowClickEvent()
    self:enableNodeEvents()

    if isShowMask == nil or isShowMask == true then
        self:addBlackMask()
    end

    self.isOpenBgClick = isOpenBgClick
end

function GameWindowBase:onSwallowClickEvent()
    local function onTouchBegan(touch, event)
        if self.isOpenBgClick == false then
            return true
        end

        local loc = touch:getLocation()
        local pos = self:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, 0, self.winSize.width, self.winSize.height), pos) then
            self:runAction(cc.CallFunc:create(function()
                PlazaManager.playClickEffect()
                self:onClearData()
                self:onClose()
            end))
        end
        return true
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener, self)
end

function GameWindowBase:addBasePanel()
    local panelNode = cc.Node:create()
    self.panelNode = panelNode

    panelNode:setContentSize(self.winSize.width, self.winSize.height)
    panelNode:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)

    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_1.png")
    bg_1:setCapInsets(GameDefine.PanelRect1) -- 206  648
    bg_1:setContentSize(self.winSize.width, self.winSize.height)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(self.panelNode)
end

function GameWindowBase:addPanelBg()
    local bg_2 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    bg_2:setCapInsets(GameDefine.PanelRect2)
    bg_2:setContentSize(self.winSize.width - 10, self.winSize.height - 70)
    bg_2:align(display.LEFT_BOTTOM, 5, 5):addTo(self.panelNode)
end

function GameWindowBase:addTopBg()
    self.topTitleBg = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    self.topTitleBg:setCapInsets(GameDefine.PanelRect3)
    self.topTitleBg:setContentSize(self.winSize.width - 10, 64)
    self.topTitleBg:align(display.CENTER_BOTTOM, self.midWidth, self.winSize.height - 68):addTo(self.panelNode)
end

function GameWindowBase:addPanelTitle(titleStr)
    self:addTopBg()

    local bg_top = ccui.ImageView:create("app/common/comwin/panel_title.png")
    -- bg_top:ignoreContentAdaptWithSize(false)
    -- bg_top:setContentSize(cc.size(winSize.width + 10, 95))
    bg_top:align(display.CENTER_BOTTOM, self.midWidth, self.winSize.height - 66):addTo(self.panelNode)

    if titleStr then
        print("titleStr===>", titleStr)
        GameUtil.addTitleTTF(titleStr, bg_top)
    end
end

function GameWindowBase:addCloseBtn()
    local function onBtnCloseClick(ref)
        self:removeFromParent()
    end
    GameUtil.addEnlargeBtn("app/common/button/btn_close1.png", 1.5, onBtnCloseClick):align(display.CENTER, self.winSize.width - 35, self.winSize.height - 35):addTo(self.panelNode)
end

function GameWindowBase:addBlackMask()
    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(display.width / 5)
    mask:setScaleY(display.height / 5)
    mask:setPosition(self.midWidth, self.midHeight)
    mask:setOpacity(180):addTo(self)
end

function GameWindowBase:onExit()
end

function GameWindowBase:onEnter()
end

function GameWindowBase:onClearData()
end

function GameWindowBase:onClearUp()
    self:disableNodeEvents()
end

function GameWindowBase:onClose()
    self:removeFromParent()
end

function GameWindowBase:setCenterOnScene()
    local x = (display.width - self.winSize.width) / 2
    local y = (display.height - self.winSize.height) / 2
    self:move(x, y)
end

function GameWindowBase:getWidth()
    return self.winSize.width
end

function GameWindowBase:getHight()
    return self.winSize.height
end

function GameWindowBase:setSwallowTouches(isSwallowTouches)
    if type(isSwallowTouches) == "boolean" then
        if self.listener ~= nil then
            self.listener:setSwallowTouches(isSwallowTouches)
        end
    end
end

function GameWindowBase:addToOnCheckExist(node)
    local exit = false
    if node ~= nil then
        local name = self:getName()
        if name ~= nil and name ~= "" then
            if node:getChildByName(name) ~= nil then
                exit = true
            end
        end
    end
    if exit == false and node ~= nil then
        self:addTo(node)
    end
end

return GameWindowBase
