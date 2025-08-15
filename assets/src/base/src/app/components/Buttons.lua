local _M = {}

local function IsLocationInNode(node, loc)
    local pos = node:convertToNodeSpace(loc)
    local s = node:getContentSize()
    local rect = cc.rect(0, 0, s.width, s.height)
    return cc.rectContainsPoint(rect, pos)
end

local function createTouchMaskNode(onTouch)
    local node = cc.Node:create()

    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local location = touch:getLocation()
        if IsLocationInNode(target, location) then
            if onTouch == nil then
                return true
            else
                return onTouch(location)
            end
        end
        return false
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    return node
end

local function createButton(swallow, onPress, onClick, voiceEffect, voiceFile)
    if voiceEffect == nil then
        voiceEffect = true
    end
    if voiceFile == nil then
        voiceFile = "music/common/audio_btn_click.mp3"
    end
    local beganPoint

    local btn = cc.Node:create()
    btn:setAnchorPoint(display.CENTER)

    local function onTouchBegan(touch, event)
        if not btn.enabled then
            return false
        end

        local target = event:getCurrentTarget()
        if not target:isVisible() then
            return false
        end

        local location = touch:getLocation()

        if IsLocationInNode(target, location) then
            beganPoint = touch:getLocation()
            if type(onPress) == "number" then
                btn:setScale(onPress)
            elseif onPress then
                onPress(btn, true)
            end
            --            if voiceEffect == true then
            --                MusicManager.playEffect(voiceFile)
            --            end
            return true
        end
        return false
    end

    local function onTouchEnded(touch, event)
        local target = event:getCurrentTarget()
        local location = touch:getLocation()

        if type(onPress) == "number" then
            btn:setScale(1)
        elseif onPress then
            onPress(btn, false)
        end

        local d = cc.pGetDistance(location, beganPoint)
        if d < 30 then
            if onClick then
                onClick(btn)
            end
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(swallow)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    btn:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, btn)

    function btn:isEnabled()
        return self.enabled
    end
    function btn:setEnabled(enabled)
        self.enabled = enabled
    end

    btn:setEnabled(true)
    return btn
end

local function expandClickRect(btn, rect)
    if rect.left == nil then
        rect.left = 0
    end
    if rect.right == nil then
        rect.right = 0
    end
    if rect.top == nil then
        rect.top = 0
    end
    if rect.bottom == nil then
        rect.bottom = 0
    end

    local size = btn:getContentSize()
    local newSize = cc.size(size.width + rect.left + rect.right, size.height + rect.top + rect.bottom)

    local offsetX, offsetY = rect.left, rect.top

    btn:setContentSize(newSize)

    local nodes = btn:getChildren()

    for i, v in ipairs(nodes) do
        local x, y = v:getPosition()
        v:setPosition(x + offsetX, y + offsetY)
    end

    -- if btn:getChildByName("draw_node") then
    --     btn:removeChildByName("draw_node")
    -- end
    -- debugDraw(btn)
end

local function initButtonWithNode(btn, node)
    local size = node:getContentSize()
    node:setPosition(size.width / 2, size.height / 2)
    btn:addChild(node)
    btn:setContentSize(size)
    return true
end

local function initButtonWithSprite(btn, sprite)
    local succ = initButtonWithNode(btn, sprite)

    btn.sprite = sprite
    return succ, {
        sprite = sprite
    }
end

local function initButtonWithImage(btn, imgName)
    return initButtonWithSprite(btn, cc.Sprite:create(imgName))
end

local function initButtonWithSpriteFrameName(btn, imgName)
    return initButtonWithSprite(btn, cc.Sprite:createWithSpriteFrameName(imgName))
end

local function initButtonWithLabel(btn, labelText, font, fontsize, fontColor)
    local label = cc.Label:createWithTTF(labelText, font, fontsize)
    if fontColor then
        label:setColor(fontColor)
    end
    local succ = initButtonWithNode(btn, label)
    return succ, {
        label = label
    }
end

local function initButtonWithImageAndLabel(btn, imgName, label, font, fontSize, fontColor)
    local sprite = cc.Sprite:create(imgName)
    local label = cc.Label:createWithTTF(label, font, fontSize)

    local size = sprite:getContentSize()
    sprite:setPosition(size.width / 2, size.height / 2)
    btn:addChild(sprite)
    label:setPosition(size.width / 2, size.height / 2)
    if fontColor then
        label:setColor(fontColor)
    end
    btn:addChild(label)
    btn:setContentSize(size)
    return true, {
        sprite = sprite,
        label = label
    }
end

local function initButtonWithImageAndBmfLabel(btn, imgName, label, font)
    local sprite = cc.Sprite:create(imgName)
    local label = cc.Label:createWithBMFont(font, label)

    local size = sprite:getContentSize()
    sprite:setPosition(size.width / 2, size.height / 2)
    btn:addChild(sprite)
    label:setPosition(size.width / 2, size.height / 2)
    if fontColor then
        label:setColor(fontColor)
    end
    btn:addChild(label)
    btn:setContentSize(size)
    return true, {
        sprite = sprite,
        label = label
    }
end

local function initButtonWithProxyNode(btn, node)
    local size = node:getContentSize()

    btn:setAnchorPoint(cc.p(node:getAnchorPoint()))
    btn:setPosition(node:getPosition())
    btn:setContentSize(size)

    node:setAnchorPoint(display.CENTER)
    node:setPosition(size.width * 0.5, size.height * 0.5)

    local parent = node:getParent()

    if parent ~= nil then
        local z = node:getLocalZOrder()
        node:removeFromParent()
        btn:addChild(node)
        parent:addChild(btn, z)
    else
        btn:addChild(node)
    end
    return true
end

local function addEnlargeBtn(swallow, scale, onClick)
    local function onPress(btn, pressed)
        if pressed then
            btn:setScale(scale)
        else
            btn:setScale(1)
        end
    end

    return createButton(swallow, onPress, onClick)
end

local function createImageButton(swallow, normalImg, pressedImg, onClick)
    local sprite

    local function onPress(btn, pressed)
        if pressed then
            sprite:setTexture(pressedImg)
        else
            sprite:setTexture(normalImg)
        end
    end

    local btn = createButton(swallow, onPress, onClick)
    local _, members = initButtonWithImage(btn, normalImg)
    sprite = members.sprite
    return btn
end

_M.IsLocationInNode = IsLocationInNode
_M.createButton = createButton
_M.addEnlargeBtn = addEnlargeBtn
_M.initButtonWithImage = initButtonWithImage
_M.initButtonWithNode = initButtonWithNode
_M.initButtonWithSprite = initButtonWithSprite
_M.initButtonWithLabel = initButtonWithLabel
_M.initButtonWithSpriteFrameName = initButtonWithSpriteFrameName
_M.initButtonWithImageAndLabel = initButtonWithImageAndLabel
_M.initButtonWithImageAndBmfLabel = initButtonWithImageAndBmfLabel
_M.createImageButton = createImageButton
_M.initButtonWithProxyNode = initButtonWithProxyNode
_M.createTouchMaskNode = createTouchMaskNode
_M.expandClickRect = expandClickRect

return _M
