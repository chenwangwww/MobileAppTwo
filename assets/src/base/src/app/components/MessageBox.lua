local _M = {}

-- 自动消息tips
function _M.showTips(text, color, pos)
    local node = display.newNode()
    node:setAnchorPoint(display.CENTER)
    node:setCascadeOpacityEnabled(true)

    local function onClicBg(res)
        node:removeFromParent()
    end
    local mask = GameUtil.createButton("app/common/mask.png", "app/common/mask.png", onClicBg)
    mask:setScaleX(display.width / 5)
    mask:setScaleY(display.height / 5)
    mask:setOpacity(180)
    mask:addTo(node)

    local bg = ccui.Scale9Sprite:create("app/common/comwin/tipbg.png") -- 103, 111
    bg:setCapInsets(cc.rect(45, 50, 13, 11))
    bg:setCascadeOpacityEnabled(true):addTo(node)

    local content = nil
    local size = nil
    if type(text) == "string" then
        if color == nil then
            color = cc.c3b(0xbc, 0xde, 0xff)
        end
        content = cc.Label:createWithTTF(text, "app/fonts/fzcy.ttf", 36)
        content:setColor(color):setCascadeOpacityEnabled(true)
        content:setMaxLineWidth(780)
        content:setLineBreakWithoutSpace(false)
        content:setLineHeight(50)
        content:setAdditionalKerning(1)
        size = content:getContentSize()
    else
        size = text:getContentSize()
        content = text
    end

    size = cc.size(size.width + 100, size.height + 80)
    node:setContentSize(size)
    local midWidth, midHeight = size.width / 2, size.height / 2
    bg:setContentSize(size):align(display.CENTER, midWidth, midHeight)
    mask:move(midWidth, midHeight)

    content:setAnchorPoint(display.CENTER):setPosition(midWidth, midHeight - 5)
    node:addChild(content)

    local secdelay = 2
    if size.width < 650 and size.width >= 300 and size.height < 150 then
        secdelay = 3
    elseif size.width >= 650 and size.width < 850 and size.height < 150 then
        secdelay = 4
    elseif size.width >= 850 or size.height > 150 then
        secdelay = 5
    end

    local spawn = cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0, 50)), cc.FadeOut:create(0.5))
    local action = cc.Sequence:create(cc.DelayTime:create(secdelay), spawn, cc.CallFunc:create(function()
        node:removeFromParent()
    end))
    node:runAction(action)
    if pos ~= nil then
        node:setPosition(pos)
        mask:setPosition(midWidth - (pos.x - display.cx), midHeight - (pos.y - display.cy))
    else
        node:setPosition(display.cx, display.cy)
    end

    local scene = display.getRunningScene()
    scene:addChild(node, 255)
end

-- 确定取消框
function _M.confirmNode(types, text, contentNode, callback, titleStr, fntPath, name, fontsize)
    -- local size = cc.size(702, 430)
    local size = cc.size(882, 542)
    local midWidth, midHeight = size.width / 2, size.height / 2
    local node = display.newNode()
    node:setContentSize(size)
    node:setAnchorPoint(display.CENTER)
    if name ~= nil and type(name) == "string" then
        node:setName(name)
    else
        node:setName("confirmNode")
    end

    local function onTouchBegan(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    local mask = display.newSprite("app/common/mask.png")
    mask:setScaleX(display.width / 5)
    mask:setScaleY(display.height / 5)
    mask:setOpacity(180)
    mask:move(midWidth, midHeight):addTo(node)

    local showNode = display.newNode()
    showNode:setContentSize(size)
    showNode:align(display.CENTER, midWidth, midHeight):addTo(node)

    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_1.png") -- 172  172
    bg_1:setCapInsets(GameDefine.PanelRect1)
    bg_1:setContentSize(size.width, size.height)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(showNode)

    --[[
    local bg_2 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png") -- 150  150
    bg_2:setCapInsets(GameDefine.PanelRect2)
    bg_2:setContentSize(size.width - 90, size.height - 80)
    bg_2:align(display.LEFT_BOTTOM, 45, 40):addTo(showNode)
    --]]

    local titlebg = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    titlebg:setCapInsets(GameDefine.PanelRect3)
    titlebg:setContentSize(size.width - 10, 64)
    titlebg:align(display.CENTER_BOTTOM, midWidth, size.height - 68):addTo(showNode)

    local bg_top = ccui.ImageView:create("app/common/comwin/panel_title.png")
    -- bg_top:ignoreContentAdaptWithSize(false)
    -- bg_top:setContentSize(cc.size(size.width + 10, 95))
    bg_top:align(display.CENTER_BOTTOM, midWidth, size.height - 66):addTo(showNode)

    if titleStr ~= nil and type(titleStr) == "string" then
        if fntPath ~= nil and type(fntPath) == "string" then
            local ss = bg_top:getContentSize()
            local text_title = ccui.TextBMFont:create(titleStr, fntPath)
            text_title:align(display.CENTER, ss.width / 2, ss.height / 2):addTo(bg_top)
        else
            GameUtil.addTitleTTF(titleStr, bg_top) -- 提示
        end
    else
        GameUtil.addTitleTTF(LangCtrl:getLang().word18, bg_top) -- 提示
    end

    local content = nil
    local textFontSize = 36
    if fontsize ~= nil then
        textFontSize = fontsize
    end
    if type(text) == "string" then
        content = cc.Label:createWithTTF(text, GameDefine.FontName, textFontSize)
        content:setColor(GameDefine.FontColor)
        -- content:setOpacity(170)
        content:setLineHeight(textFontSize + 8)
        content:setAdditionalKerning(1)
        content:setMaxLineWidth(480)
        content:setLineBreakWithoutSpace(false)
    else
        content = text
    end
    if content ~= nil then
        content:setAnchorPoint(display.CENTER):setPosition(midWidth, midHeight + 50)
        showNode:addChild(content)
    end

    if types == "ok" then
        local function onClickCallBack(args)
            PlazaManager.playClickEffect()
            if callback ~= nil then
                callback(true)
            end
            node:removeSelf()
        end
        local okBtn = ccui.Button:create("app/common/button/btn1.png")
        okBtn:addClickEventListener(onClickCallBack)
        okBtn:setZoomScale(-0.1)
        okBtn:align(display.CENTER, midWidth, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, okBtn) -- 确定
    elseif types == "yes_no" then
        local function onYesCallBack(args)
            PlazaManager.playClickEffect()
            if callback ~= nil then
                callback(true)
            end
            node:removeSelf()
        end

        local function onNoCallBack(args)
            PlazaManager.playClickEffect()
            if callback ~= nil then
                callback(false)
            end
            node:removeSelf()
        end

        local yesBtn = ccui.Button:create("app/common/button/btn1.png")
        yesBtn:addClickEventListener(onYesCallBack)
        yesBtn:setZoomScale(-0.1)
        yesBtn:align(display.CENTER, midWidth - 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, yesBtn) -- 确定

        local noBtn = ccui.Button:create("app/common/button/btn2.png")
        noBtn:addClickEventListener(onNoCallBack)
        noBtn:setZoomScale(-0.1)
        noBtn:align(display.CENTER, midWidth + 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word12, noBtn) -- 取消
    elseif types == "out_continue" then
        local function onYesCallBack(args)
            PlazaManager.playClickEffect()
            if callback ~= nil then
                callback(true)
            end
            node:removeSelf()
        end

        local function onNoCallBack(args)
            PlazaManager.playClickEffect()
            if callback ~= nil then
                callback(false)
            end
            node:removeSelf()
        end

        local yesBtn = ccui.Button:create("app/common/button/btn1.png")
        yesBtn:addClickEventListener(onYesCallBack)
        yesBtn:setZoomScale(-0.1)
        yesBtn:align(display.CENTER, midWidth - 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word13, yesBtn) -- 退出

        local noBtn = ccui.Button:create("app/common/button/btn2.png")
        noBtn:addClickEventListener(onNoCallBack)
        noBtn:setZoomScale(-0.1)
        noBtn:align(display.CENTER, midWidth + 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word14, noBtn) -- 继续
    end

    if contentNode ~= nil then
        node:setPosition(display.cx, display.cy)
        contentNode:addChild(node, 254)
    else
        local scene = display.getRunningScene()
        node:setPosition(display.cx, display.cy)
        scene:addChild(node, 254)
    end

    function node:close()
        self:removeFromParent()
    end

    showNode:setScale(0.5)
    showNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function _M.confirmText(type, text, callback, color)
    if color == nil then
        color = cc.WHITE
    end

    local label = cc.Label:createWithTTF(text, GameDefine.FontName, 36)
    label:setLineBreakWithoutSpace(false)
    label:setMaxLineWidth(800)
    label:setColor(color)

    _M.confirmNode(type, label, callback)
end

-- 网络连接
function _M.showConnection(text, time, callback, maskOpacity, contentNode)
    if maskOpacity == nil then
        maskOpacity = 0
    end
    local remainTime = time
    local conn_callback = nil
    if callback then
        conn_callback = callback
    end
    local isUpdate = true
    local connStr = text
    local startTime = 1

    local scene = nil
    if contentNode == nil then
        scene = display:getRunningScene()
    else
        scene = contentNode
    end

    local node = cc.Node:create()
    node:setContentSize(display.size)
    local function onTouchBegan(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    local drawNode = cc.DrawNode:create()
    drawNode:drawSolidRect(display.LEFT_BOTTOM, cc.p(display.width, display.height), cc.c4b(0, 0, 0, maskOpacity))
    -- 0.5
    node:addChild(drawNode)

    local size = cc.size(914, 597)
    local content = nil
    local conttenttime = nil
    local color = cc.c3b(0xbc, 0xde, 0xff)

    if connStr ~= nil then
        if type(connStr) == "string" then
            content = cc.Label:createWithTTF(connStr, GameDefine.FontName, 36)
            content:setColor(color)
            content:enableOutline(cc.c4b(94, 26, 5, 255), 2) -- 标题描边颜色
            content:setOpacity(170)
        else
            content = connStr
        end
        content:setAnchorPoint(display.CENTER):setPosition(display.cx, display.cy - 110)
        node:addChild(content)
    end

    if remainTime ~= nil then
        conttenttime = cc.Label:createWithTTF(1, GameDefine.FontName, 36)
        conttenttime:setColor(color)
        conttenttime:setOpacity(170)
        conttenttime:setAnchorPoint(display.CENTER):setPosition(display.cx, display.cy)
        node:addChild(conttenttime)
    end

    local loadbg = cc.Sprite:create("app/common/loadingBg.png")
    loadbg:setPosition(display.center)
    node:addChild(loadbg)

    local sp = cc.Sprite:create("app/common/loading.png")
    sp:setPosition(display.center)
    node:addChild(sp)
    sp:runAction(cc.RepeatForever:create(cc.EaseRateAction:create(cc.RotateBy:create(1.5, 360), 0.8)))

    local _isClick = false
    function node:setEnabled(val)
        if val == _isClick then
            return
        end
        _isClick = val
        listener:setEnabled(not val)
        drawNode:setVisible(not val)
    end

    local function updateShowTime()
        if isUpdate == true then
            startTime = startTime + 1

            if conttenttime ~= nil and startTime >= 0 then
                conttenttime:setString(startTime)
            end

            if remainTime - startTime <= 0 then
                if conn_callback ~= nil then
                    conn_callback(true)
                    conn_callback = nil
                end
            end
        end
    end

    local wattingSchedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateShowTime, 1, false)

    function node:close()
        if wattingSchedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
        end
        conn_callback = nil
        self:removeFromParent()
    end

    function node:setData(textStr, timeStr, call_back)
        isUpdate = false
        startTime = 0
        if remainTime then
            remainTime = timeStr
        end

        if textStr ~= nil and string.len(textStr) > 0 then
            if content then
                content:setString(textStr)
            end
        end

        if call_back then
            conn_callback = call_back
        else
            conn_callback = nil
        end
        isUpdate = true
    end

    function node:onExit()
        node:unregisterScriptHandler()
        if wattingSchedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(wattingSchedulerID)
        end
        PlazaManager.waitingTips = nil
        conn_callback = nil
    end

    local function onNodeEvent(event)
        if event == "exit" then
            node:onExit()
        end
    end
    node:registerScriptHandler(onNodeEvent)

    scene:addChild(node, 255)

    return node
end

return _M
