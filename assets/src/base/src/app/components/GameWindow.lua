local GameWindow = {}

local windows = {}
local winObjects = {}

local function createGameWindow(onInit, onUpdate, onClose, bShowMask, ...)
    local win = display.newNode()
    local _data = {}

    function win:init(...)
        onInit(win, _data, ...)
    end

    function win:update(...)
        onUpdate(win, _data, ...)
    end

    function win:close()
        onClose(win, _data)
        win:removeFromParent()

        for k, v in pairs(winObjects) do
            if v == self then
                winObjects[k] = nil
            end
        end
    end

    function win:addTitleIcon(icon, offset)
        if offset == nil then
            offset = display.LEFT_BOTTOM
        end
        local sp = display.newSprite(icon)
        sp:move(winSize.width / 2 + offset.x, winSize.height - 55 + offset.y):addTo(win)
    end

    function win:setAutoClose(isAutoClose)
        self._isAutoClose = isAutoClose
    end

    local opacity = 470
    if bShowMask == false then
        opacity = 0
    end

    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(display.width / 5)
    mask:setScaleY(display.height / 5)
    mask:setOpacity(opacity):addTo(win)

    function win:setMaskOpacity(opacity)
        mask:setOpacity(opacity)
    end

    local scene = display.getRunningScene()
    win:align(display.CENTER, display.cx, display.cy):addTo(scene)

    win:init(...)
    local winSize = win:getContentSize()
    mask:move(winSize.width / 2, winSize.height / 2)

    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = win:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, 0, winSize.width, winSize.height), pos) and win._isAutoClose == true then
            win:runAction(cc.CallFunc:create(function()
                win:close()
            end))
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    win:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, win)
    return win
end

local function createGameWindowNew(onInit, onUpdate, onClose, bShowMask, container, ...)
    local win = display.newNode()
    local _data = {}

    function win:init(...)
        onInit(win, _data, ...)
    end

    function win:update(...)
        onUpdate(win, _data, ...)
    end

    function win:close()
        onClose(win, _data)
        win:removeFromParent()

        for k, v in pairs(winObjects) do
            if v == self then
                winObjects[k] = nil
            end
        end
    end

    function win:addTitleIcon(icon, offset)
        if offset == nil then
            offset = display.LEFT_BOTTOM
        end
        local sp = display.newSprite(icon)
        sp:move(winSize.width / 2 + offset.x, winSize.height - 55 + offset.y):addTo(win)
    end

    function win:setAutoClose(isAutoClose)
        self._isAutoClose = isAutoClose
    end

    local opacity = 470
    if bShowMask == false then
        opacity = 0
    end

    local size = display.size
    if container ~= nil then
        size = container:getContentSize()
    end

    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(size.width / 5)
    mask:setScaleY(size.height / 5)
    mask:setOpacity(opacity):addTo(win)

    function win:setMaskOpacity(opacity)
        mask:setOpacity(opacity)
    end

    local scene = display.getRunningScene()
    if container ~= nil then
        scene = container
    end
    win:align(display.CENTER, size.width / 2, size.height / 2):addTo(scene)

    win:init(...)
    local winSize = win:getContentSize()
    mask:move(winSize.width / 2, winSize.height / 2)

    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = win:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, 0, winSize.width, winSize.height), pos) and win._isAutoClose == true then
            win:runAction(cc.CallFunc:create(function()
                win:close()
            end))
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    win:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, win)
    return win
end

function GameWindow.registerWindow(name, onInit, onUpdate, onClose, showMask)
    windows[name] = {
        onInit = onInit,
        onUpdate = onUpdate,
        onClose = onClose,
        bShowMask = showMask
    }
end

function GameWindow.ungisterWindow(name)
    windows[name] = nil
end

function GameWindow.openWindow(name, ...)
    local info = windows[name]
    local win = createGameWindow(info.onInit, info.onUpdate, info.onClose, info.bShowMask, ...)
    winObjects[name] = win
    return win
end

function GameWindow.openWindowNew(name, container, ...)
    local info = windows[name]
    local win = createGameWindowNew(info.onInit, info.onUpdate, info.onClose, info.bShowMask, container, ...)
    winObjects[name] = win
    return win
end

function GameWindow.getOpenWindow(name)
    for k, v in pairs(winObjects) do
        if k == name then
            return v
        end
    end
    return nil
end

return GameWindow
