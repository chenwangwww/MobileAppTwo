local Layout = require "app.components.Layout"

local _M = {}

local function createHScrollView(size, nodes, offset, pads)
    local node = cc.Node:create()
    node:setContentSize(size)

    local container = Layout.createHBox(nodes, offset, pads)

    local scrollView = cc.ScrollView:create()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    scrollView:setViewSize(size)
    scrollView:setContainer(container)
    scrollView:setContentOffset(display.LEFT_BOTTOM)

    function node:setTouchEnabled(b)
        scrollView:setTouchEnabled(b)
    end

    function node:resetContainer(nodes, offset)
        container = Layout.createHBox(nodes, offset)
        scrollView:setContainer(container)
    end

    node:addChild(scrollView)
    return node
end

-- type = "vertical" or "horizontal"
function _M.create(type, size, nodes, offset, pads, align)
    if offset == nil then
        offset = 0
    end
    if type == "horizontal" then
        return createHScrollView(size, nodes, offset, pads)
    end

    local node = cc.Node:create()
    node:setContentSize(size)

    local container = Layout.createVBox(nodes, offset, pads, align)
    if container:getContentSize().width == 0 then
        container:setContentSize(size.width, 0)
    end

    local scrollView = cc.ScrollView:create()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scrollView:setViewSize(size)
    scrollView:setContainer(container)
    scrollView:setContentOffset(scrollView:minContainerOffset())

    function node:setTouchEnabled(b)
        scrollView:setTouchEnabled(b)
    end

    function node:resetContainer(nodes, offset, pads)
        container = Layout.createVBox(nodes, offset, pads)
        scrollView:setContainer(container)
        scrollView:setContentOffset(scrollView:minContainerOffset())
    end

    function node:setContentOffset(x)
        scrollView:setContentOffset(x)
    end

    function node:getContentOffset()
        return scrollView:getContentOffset()
    end

    function node:minContainerOffset()
        return scrollView:minContainerOffset()
    end

    function node:maxContainerOffset()
        return scrollView:maxContainerOffset()
    end

    function node:getContainer()
        return scrollView:getContainer()
    end

    function node:addItem(item)
        container:addElement(item)

        local pos = scrollView:getContentOffset()
        pos.y = pos.y - item:getContentSize().height - offset
        self:setContentOffset(pos)
    end

    function node:removeItem(item)
        container:removeElement(item)

        scrollView:setContentOffset(scrollView:minContainerOffset())
    end

    function node:getContainer()
        return container
    end

    function node:setBounceable(isBounce)
        scrollView:setBounceable(isBounce)
    end

    node:addChild(scrollView)
    return node
end

return _M
