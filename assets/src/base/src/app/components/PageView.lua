require "app.components.Buttons"
local Layout = require "app.components.Layout"

local _M = {}

local function createBarNode(size, normalImg, lightImg, isPlist)
    local node = cc.Node:create()
    node:setContentSize(size)

    local firstStr = isPlist == true and "#" or ""
    local normalSprite = display.newSprite(firstStr .. normalImg)
    if normalSprite == nil then
        return nil
    end
    normalSprite:setPosition(size.width / 2, size.height / 2)
    node:addChild(normalSprite)

    local lightSprite = display.newSprite(firstStr .. lightImg)
    lightSprite:setPosition(size.width / 2, size.height / 2)
    node:addChild(lightSprite)

    function node:setLight(value)
        self._light = value
        normalSprite:setVisible(not value)
        lightSprite:setVisible(value)
    end

    node:setLight(false)

    return node
end

local function createPageBar(count, elemSize, imgPattern, isNum, isPlist)
    local node = cc.Node:create()

    local maxCount = 10
    local nodes = {}
    local selectedIdx

    function node:setCount(count)
        if count > maxCount then
            count = maxCount
        end
        self:removeAllChildren()
        selectedIdx = nil
        nodes = {}
        for i = 1, count do
            local pageNode
            if isNum then
                pageNode = createBarNode(elemSize, string.format(imgPattern, tostring(i)), string.format(imgPattern, tostring(i) .. "_light"), isPlist)
            else
                pageNode = createBarNode(elemSize, string.format(imgPattern, ""), string.format(imgPattern, "_light"), isPlist)
            end
            if pageNode then
                nodes[#nodes + 1] = pageNode
            end
        end
        local container = Layout.createHBox(nodes, 10)
        self:setContentSize(container:getContentSize())
        self:addChild(container)
    end

    function node:setSelected(idx)
        if idx > maxCount then
            idx = maxCount
        end

        if selectedIdx ~= nil and nodes[selectedIdx] ~= nil then
            nodes[selectedIdx]:setLight(false)
        end
        if idx <= #nodes then
            nodes[idx]:setLight(true)
        end
        selectedIdx = idx
    end

    return node
end

local function createLayout(containers, size)
    local container = cc.Node:create()
    container:setContentSize(size)
    container:setTag(1)
    containers[#containers + 1] = container

    local layout = ccui.Layout:create()
    layout:setContentSize(size)
    layout:addChild(container)

    return layout
end

-- barImgPattern = "abc/abc%s.png" %s will be replace by 1, 1_light, 2, 2_light ...
-- onInit(node, pageIdx)
-- onPageTurning(node, pageIdx)
function _M.create(size, barOffset, barImgPattern, count, cacheCount, onInit, onPageTurning, isBarImgPageNum, isPlist)
    if isBarImgPageNum == nil then
        isBarImgPageNum = false
    end

    if barOffset == nil then
        barOffset = display.LEFT_BOTTOM
    end
    local pageNode = cc.Node:create()
    local pageView = ccui.PageView:create()
    pageNode._count = count

    local lastPageIndex = 0

    local containers = {}

    local function createView()
        for i = 1, count do
            local layout = createLayout(containers, size)
            pageView:addPage(layout)
        end
    end
    createView()

    if cacheCount == 0 then
        for i = 1, count do
            onInit(containers[i], i)
        end
    else
        error("Unsupport now!")
    end

    local average = math.floor(cacheCount / 2)

    local pageBar = nil
    local function addPageBar(c)
        pageBar = createPageBar(c, cc.size(32, 32), barImgPattern, isBarImgPageNum, isPlist)
        pageBar:setCount(c)
        pageBar:setAnchorPoint(display.CENTER_TOP)
        pageBar:setPosition(size.width * 0.5 + barOffset.x, barOffset.y)
        pageBar:setSelected(1)

        pageNode:addChild(pageBar)
    end

    if count > 1 and barImgPattern ~= nil then
        addPageBar(count)
    end

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local idx = sender:getCurPageIndex()
            if idx ~= lastPageIndex then
                lastPageIndex = idx
                onPageTurning(containers[idx + 1], idx + 1)

                if pageBar ~= nil then
                    pageBar:setSelected(idx + 1)
                end
            end
        end
    end

    pageView:addEventListener(pageViewEvent)

    pageView:setTouchEnabled(true)
    pageView:setContentSize(size)
    pageView:setAnchorPoint(display.CENTER)
    pageView:setPosition(size.width / 2, size.height / 2)

    pageNode:setContentSize(size)
    pageNode:addChild(pageView)

    function pageNode.refreshCurPage()
        local cur = pageView:getCurPageIndex() + 1
        containers[cur]:removeAllChildren()
        onInit(containers[cur], cur)
    end

    function pageNode:setPage(pageIdx)
        local currIdx = pageView:getCurPageIndex() + 1
        if pageIdx > self._count or pageIdx == currIdx then
            return
        end
        pageView:scrollToPage(pageIdx - 1)
        pageView:update(1000000)
        pageBar:setSelected(pageIdx)
    end

    function pageNode:setCount(count)
        if count == self._count then
            return
        end

        if count > 0 and pageBar == nil then
            addPageBar(count)
            pageBar:setCount(count)
        elseif count == 0 and pageBar then
            pageNode:removeChild(pageBar)
            pageBar = nil
        end

        if count > self._count then
            for i = 1, count - self._count do
                pageView:addPage(createLayout(containers, size))
                onInit(containers[#containers], #containers)
            end
        else
            local cur = pageView:getCurPageIndex()
            if cur >= count then
                pageView:scrollToPage(count - 1)
                pageView:update(1000000)
            end
            local reCount = self._count - count
            while reCount > 0 do
                pageView:removePageAtIndex(#containers)
                table.remove(containers, #containers)

                reCount = reCount - 1
            end
        end

        if count > 0 then
            pageBar:setSelected(pageView:getCurPageIndex() + 1)
        end
        self._count = count
    end

    function pageNode:isEnabled()
        return pageView:isTouchEnabled()
    end

    function pageNode:setEnabled(value)
        pageView:setTouchEnabled(value)
    end

    return pageNode
end

return _M
