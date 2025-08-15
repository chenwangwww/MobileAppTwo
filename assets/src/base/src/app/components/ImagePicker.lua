local Buttons = require "app.components.Buttons"
local Layout = require "app.components.Layout"
local MessageBox = require "app.components.MessageBox"

local _M = {}

function _M.imageClipping(texture, onComplete, onCancel)
    local node = cc.Node:create()
    node:setContentSize(display.size)

    local downDraw = cc.DrawNode:create()
    downDraw:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, display.height), cc.c4b(0, 0, 0, 1))
    node:addChild(downDraw)

    local imageSp = cc.Sprite:createWithTexture(texture)
    local imageSize = imageSp:getContentSize()
    local displayMin = math.min(display.width, display.height)
    local scaleX = displayMin / imageSize.width
    local scaleY = displayMin / imageSize.height
    local scaleMin = math.max(scaleX, scaleY)
    imageSp:setScale(scaleMin)

    imageSp:setPosition(display.cx, display.cy)
    node:addChild(imageSp)

    -- 添加蒙版
    local lineWidth = 1
    local downDraw = cc.DrawNode:create()
    downDraw:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, display.height), cc.c4b(0, 0, 0, 0.5))

    local maskDraw = cc.DrawNode:create()
    local maskWidth = math.min(display.width - lineWidth, display.height - lineWidth)
    local maskPos = cc.p((display.width - maskWidth) / 2, (display.height - maskWidth) / 2)
    maskDraw:drawSolidRect(display.LEFT_BOTTOM, cc.p(maskWidth, maskWidth), cc.c4b(1, 1, 0, 0.5))
    maskDraw:setPosition(maskPos)

    local clippingNode = cc.ClippingNode:create(maskDraw)
    clippingNode:setContentSize(display.size)
    clippingNode:addChild(downDraw)
    clippingNode:setInverted(true)
    node:addChild(clippingNode)

    local lineRectDraw = cc.DrawNode:create()
    lineRectDraw:setLineWidth(lineWidth)
    lineRectDraw:drawRect(cc.p(lineWidth, lineWidth), cc.p(maskWidth - lineWidth * 2, maskWidth - lineWidth * 2), cc.c4b(1, 1, 1, 1))
    lineRectDraw:setPosition(maskPos)
    node:addChild(lineRectDraw)

    local function onUpload()
        local clippingWidth = 200

        local renderTexture = cc.RenderTexture:create(clippingWidth, clippingWidth)
        renderTexture:setPosition(display.width * 0.5, display.height * 0.5)
        renderTexture:setVirtualViewport(display.LEFT_BOTTOM, cc.rect(0, 0, clippingWidth, clippingWidth), cc.rect(0, 0, clippingWidth, clippingWidth))
        node:addChild(renderTexture)

        local pos = imageSp:convertToNodeSpace(maskPos)
        imageSp:setAnchorPoint(pos.x / imageSize.width, pos.y / imageSize.height)
        imageSp:setPosition(maskPos)

        local newScale = clippingWidth / maskWidth * imageSp:getScaleX()
        imageSp:setScale(newScale)
        imageSp:setPosition(imageSp:getPositionX() - maskPos.x, imageSp:getPositionY() - maskPos.y)

        local maskNode = cc.DrawNode:create()
        maskNode:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, display.height), cc.c4b(0, 0, 0, 1))
        maskNode:setPosition(0, 0)
        node:addChild(maskNode)

        renderTexture:beginWithClear(0.0, 0.0, 0.0, 0.0)
        imageSp:visit()
        renderTexture:endToLua()

        local idx = 0
        imageSp:scheduleUpdateWithPriorityLua(function()
            idx = idx + 1
            if idx == 2 then
                local image = renderTexture:newImage()
                node:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(0, -display.height)), cc.CallFunc:create(function()
                    onComplete(image)
                end)))
            end
        end, 1)
    end

    local upBtn = Buttons.createButton(true, nil, onUpload)
    Buttons.initButtonWithImage(upBtn, "hall/btn_user.png")
    upBtn:setAnchorPoint(display.CENTER)
    upBtn:setPosition(display.width - 100, 100)
    node:addChild(upBtn)

    local cancelBtn = Buttons.createButton(true, nil, function()
        onCancel(node)
    end)
    Buttons.initButtonWithImage(cancelBtn, "hall/btn_user.png")
    cancelBtn:setAnchorPoint(display.CENTER)
    cancelBtn:setPosition(100, 100)
    node:addChild(cancelBtn)

    local function onTouchBegan(touchs, event)
        return true
    end

    local function onTouchMoved(touchs, event)
        if #touchs == 1 then
            local prePos = touchs[1]:getPreviousLocation()
            local curPos = touchs[1]:getLocation()
            local imgPos = cc.p(imageSp:getPosition())

            curPos = cc.p(imgPos.x + curPos.x - prePos.x, imgPos.y + curPos.y - prePos.y)

            local scale = imageSp:getScaleX()
            local size = cc.size(imageSize.width * scale, imageSize.height * scale)
            curPos = cc.p(math.max(curPos.x, display.width - size.width / 2 - maskPos.x), math.max(curPos.y, display.height - size.height / 2 - maskPos.y))
            curPos = cc.p(math.min(curPos.x, size.width / 2 + maskPos.x), math.min(curPos.y, size.height / 2 + maskPos.y))
            imageSp:setPosition(curPos)
        else
            local distance1 = cc.pGetDistance(touchs[1]:getPreviousLocation(), touchs[2]:getPreviousLocation())
            local distance2 = cc.pGetDistance(touchs[1]:getLocation(), touchs[2]:getLocation())

            local nscale = distance2 / distance1 * imageSp:getScaleX()
            imageSp:setScale(math.max(scaleMin, nscale))

            local curPos = cc.p(imageSp:getPosition())
            local scale = imageSp:getScaleX()
            local size = cc.size(imageSize.width * scale, imageSize.height * scale)
            curPos = cc.p(math.max(curPos.x, display.width - size.width / 2), math.max(curPos.y, display.height - size.height / 2))
            curPos = cc.p(math.min(curPos.x, size.width / 2), math.min(curPos.y, size.height / 2))
            imageSp:setPosition(curPos)
        end
    end

    local function onTouchEnded(touchs, event)
    end

    local listener = nil
    local function onEnterOrExit(tag)
        if tag == "enter" then
            listener = cc.EventListenerTouchAllAtOnce:create()
            listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCHES_BEGAN)
            listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCHES_MOVED)
            listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCHES_ENDED)
            cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, -124)
        elseif tag == "exit" then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(listener)
        end
    end

    node:registerScriptHandler(onEnterOrExit)

    return node
end

local function createMenuItem(text)
    local height = 80
    local lineWidth = 1
    local node = cc.Node:create()
    node:setContentSize(cc.size(display.width, height))

    local maskNode = cc.DrawNode:create()
    maskNode:setContentSize(display.size)
    maskNode:setLineWidth(lineWidth)
    maskNode:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, height), cc.c4b(1, 1, 1, 1))
    maskNode:drawRect(display.LEFT_BOTTOM, cc.p(display.width, height), cc.c4b(0, 0, 0, 1))
    node:addChild(maskNode)

    local label = cc.Label:createWithTTF(text, "font/PINGFANG_HEAVY.TTF", 25)
    label:setColor(cc.BLACK)
    label:setPosition(display.width * 0.5, height * 0.5)
    node:addChild(label)

    return node
end

function _M.openPicker(callback)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ~= cc.PLATFORM_OS_IPHONE and targetPlatform ~= cc.PLATFORM_OS_IPAD and targetPlatform ~= cc.PLATFORM_OS_ANDROID then
        MessageBox.showTips("暂不支持当前平台头像替换功能")
        callback(nil)
        return
    end

    local scene = display.getRunningScene()
    local node = cc.Node:create()
    node:setContentSize(display.size)

    local maskNode = cc.DrawNode:create()
    maskNode:setContentSize(display.size)
    maskNode:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, display.height), cc.c4b(0, 0, 0, 0.2))
    node:addChild(maskNode)

    local menus, menuNode, listener = {}, nil, nil

    local function onTouchBegan(touch, event)
        local location = touch:getLocation()
        for i, v in ipairs(menus) do
            local menuPos = cc.p(v:getPosition())
            local menuSize = v:getContentSize()
            local rect = cc.rect(menuPos.x - menuSize.width / 2, menuPos.y - menuSize.height / 2, menuSize.width, menuSize.height)
            if cc.rectContainsPoint(rect, location) then
                if i == 1 or i == 2 then
                    local type = i == 1 and game.IMAGE_PICKER_PHOTO or game.IMAGE_PICKER_CAMERA
                    local moveBy = cc.MoveBy:create(0.2, cc.p(0, -menuNode:getContentSize().width))
                    menuNode:runAction(cc.Sequence:create(moveBy, cc.CallFunc:create(function()
                        game.requiredImagePicker(type, function(texture)
                            if texture ~= nil then
                                local imageClippingNode = _M.imageClipping(texture, function(image)
                                    cc.Director:getInstance():popScene()
                                    scene:removeChild(node)
                                    callback(image)
                                end, function(imageClippingNode)
                                    cc.Director:getInstance():popScene()
                                    menuNode:runAction(cc.MoveBy:create(0.2, cc.p(0, menuNode:getContentSize().width)))
                                end)

                                -- 添加新场景
                                local imagePickerScene = display.newScene()
                                imagePickerScene:addChild(imageClippingNode)
                                cc.Director:getInstance():pushScene(imagePickerScene)
                            else
                                menuNode:runAction(cc.MoveBy:create(0.2, cc.p(0, menuNode:getContentSize().width)))
                            end
                        end)
                    end)))
                elseif i == 3 then
                    local moveBy = cc.MoveBy:create(0.2, cc.p(0, -menuNode:getContentSize().width))
                    menuNode:runAction(cc.Sequence:create(moveBy, cc.CallFunc:create(function()
                        scene:removeChild(node)
                        callback(nil)
                    end)))
                    maskNode:runAction(cc.FadeOut:create(0.2))
                end
                break
            end
        end
        return true
    end

    local menuStrs = {"相册", "相机", "取消"}
    for i, v in ipairs(menuStrs) do
        local menu = createMenuItem(v)
        menu:setAnchorPoint(display.CENTER)
        menus[i] = menu
    end

    menuNode = Layout.createVBox(menus, 0)
    node:addChild(menuNode)

    listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    scene:addChild(node, 255)
end

return _M
