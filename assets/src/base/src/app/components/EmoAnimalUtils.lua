local Layout = require "app.components.Layout"
local _M = {}

local emoDataList = {}
local EmoType = {
    Anim = 1,
    Pic = 2
} -- 表情类型  1:帧动画 2:图片
local EmoMoveType = {
    Head = 1,
    MidScene = 2,
    MoveMidScen = 3
} ----移动类型 1:直接显示在头像旁,2:直接显示在界面中心，3:从头像移动到界面中心再播放动画

function _M.InitEmoList()
    local dataFile = cc.FileUtils:getInstance():getStringFromFile("app/emoanim/emoAniList.json")
    local dataList = {}
    if dataFile ~= nil and string.len(dataFile) > 0 then
        dataList = json.decode(dataFile)
    end

    local count = 0
    if dataList ~= nil and #dataList > 0 then
        for i, itemdata in ipairs(dataList) do
            if itemdata.UseChk == 1 then
                count = count + 1
                emoDataList[count] = itemdata
            end
        end
    end
end

function _M.createEmoList(size, callback)

    local buttonList = {}
    local function clickButton(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            local tag = uiwidget:getTag()
            callback(tag)
        end
    end

    local dataFile = cc.FileUtils:getInstance():getStringFromFile("app/emoanim/emoAniList.json")
    local dataList = {}
    if dataFile ~= nil and string.len(dataFile) > 0 then
        dataList = json.decode(dataFile)
    end

    local count = 0
    if dataList ~= nil and #dataList > 0 then
        for i, itemdata in ipairs(dataList) do
            if itemdata.UseChk == 1 then
                count = count + 1
                emoDataList[count] = itemdata
                local button = ccui.Button:create("app/emoanim/" .. itemdata.MenuImagePath)
                button:setAnchorPoint(display.CENTER)
                button:addTouchEventListener(function(uiwidget, eventType)
                    clickButton(uiwidget, eventType)
                end)
                buttonList[count] = button
            end
        end
    end

    local container = Layout.createTBox("row", nil, 4, buttonList, {
        row = 6,
        col = 6
    })

    local scrollView = cc.ScrollView:create()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scrollView:setViewSize(size)
    scrollView:setContainer(container)
    scrollView:setContentOffset(scrollView:minContainerOffset())

    return scrollView
end
function _M.createEmoAnimal(emoItemdata)
    -- 建立动画
    local animation_1 = cc.Animation:create()
    for i = 1, emoItemdata.AniPicCount do
        local frameName = string.format("app/emoanim/%sani_%d.png", emoItemdata.AniPath, i)
        animation_1:addSpriteFrameWithFile(frameName)
    end
    animation_1:setDelayPerUnit(8 / 60)
    animation_1:setRestoreOriginalFrame(true)

    local animate_1 = cc.Animate:create(animation_1)

    return animate_1
end

function _M.createEmoAniNode(node, direct, seqNo, position, afterfunction)
    if (#emoDataList < seqNo) then
        return
    end
    if emoDataList[seqNo].EmoType == EmoType.Anim then -- 帧动画
        local sprite = cc.Sprite:create("app/emoanim/" .. emoDataList[seqNo].AniFirstPath)
        if (sprite == nil) then
            node:removeFromParent()
            return
        end
        node:addChild(sprite)

        if emoDataList[seqNo].EmoMoveType == EmoMoveType.Head then
            sprite:setPosition(0, 0)
            if (direct == GameDefine.Direct.Top) then
                sprite:setAnchorPoint(display.CENTER_TOP)
            elseif (direct == GameDefine.Direct.Down) then
                sprite:setAnchorPoint(display.CENTER_BOTTOM)
            elseif (direct == GameDefine.Direct.Left) then
                sprite:setAnchorPoint(display.LEFT_CENTER)
            else
                sprite:setAnchorPoint(display.RIGHT_CENTER)
            end
            local animate_1 = _M.createEmoAnimal(emoDataList[seqNo])
            local afterAction = cc.CallFunc:create(function()
                afterfunction()
            end)
            sprite:runAction(cc.Sequence:create(animate_1, afterAction))

        elseif emoDataList[seqNo].EmoMoveType == EmoMoveType.MidScene then
            node:setAnchorPoint(display.CENTER)
            node:setPosition(display.cx, display.cy)
            sprite:setAnchorPoint(display.CENTER)
            sprite:setPosition(0, 0)
            local animate_1 = _M.createEmoAnimal(emoDataList[seqNo])
            local afterAction = cc.CallFunc:create(function()
                afterfunction()
            end)
            sprite:runAction(cc.Sequence:create(animate_1, afterAction))
        elseif emoDataList[seqNo].EmoMoveType == EmoMoveType.MoveMidScen then
            node:setAnchorPoint(display.CENTER)
            node:setPosition(position)
            sprite:setAnchorPoint(display.CENTER)
            sprite:setPosition(0, 0)

            local playAction = cc.CallFunc:create(function()

            end)

            local jumpByAction = cc.JumpTo:create(0.4, cc.vec3(display.cx, display.cy), 100, 1)
            node:runAction(jumpByAction)

            local schedulerID = nil
            local function callFunction()
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                local animate_1 = _M.createEmoAnimal(emoDataList[seqNo])
                local afterAction = cc.CallFunc:create(function()
                    afterfunction()
                end)
                sprite:runAction(cc.Sequence:create(animate_1, afterAction))
            end
            schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callFunction, 0.6, false)
        end
    elseif emoDataList[seqNo].EmoType == EmoType.Pic then -- 图片
        if emoDataList[seqNo].EmoMoveType == EmoMoveType.Head then
            sprite:setPosition(0, 0)
            if (direct == GameDefine.Direct.Top) then
                sprite:setAnchorPoint(display.CENTER_TOP)
            elseif (direct == GameDefine.Direct.Down) then
                sprite:setAnchorPoint(display.CENTER_BOTTOM)
            elseif (direct == GameDefine.Direct.Left) then
                sprite:setAnchorPoint(display.LEFT_CENTER)
            else
                sprite:setAnchorPoint(display.RIGHT_CENTER)
            end
            local afterAction = cc.CallFunc:create(function()
                afterfunction()
            end)
            sprite:runAction(cc.Sequence:create(cc.DelayTime:create(2), afterAction))

        elseif emoDataList[seqNo].EmoMoveType == EmoMoveType.MidScene then
            node:setAnchorPoint(display.CENTER)
            node:setPosition(display.cx, display.cy)
            sprite:setAnchorPoint(display.CENTER)
            sprite:setPosition(0, 0)
            local afterAction = cc.CallFunc:create(function()
                afterfunction()
            end)
            sprite:runAction(cc.Sequence:create(cc.DelayTime:create(2), afterAction))
        elseif emoDataList[seqNo].EmoMoveType == EmoMoveType.MoveMidScen then
            node:setAnchorPoint(display.CENTER)
            node:setPosition(position)
            sprite:setAnchorPoint(display.CENTER)
            sprite:setPosition(0, 0)

            local jumpByAction = cc.JumpTo:create(0.4, cc.vec3(display.cx, display.cy), 100, 1)
            local afterAction = cc.CallFunc:create(function()
                afterfunction()
            end)
            node:runAction(cc.Sequence:create(jumpByAction, cc.DelayTime:create(2), afterAction))
        end
    end

end

return _M
