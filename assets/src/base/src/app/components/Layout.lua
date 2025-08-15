local _M = {}

local function getOffsets(offsets)
    if offsets == nil then
        return 0, 0
    else
        return offsets.col or 0, offsets.row or 0
    end
end

local function getPads(pads)
    if pads == nil then
        return 0, 0, 0, 0
    else
        return pads.left or 0, pads.right or 0, pads.top or 0, pads.bottom or 0
    end
end

function _M.createHBox(nodes, offset, pads, align)
    if align == nil then
        align = "center"
    end

    local container = display.newNode()

    local width, height = 0, 0
    local rowXs = {}

    if offset == nil then
        offset = 0
    end

    local x, size = 0
    for i, node in ipairs(nodes) do
        size = node:getContentSize()

        rowXs[i] = x + size.width * 0.5
        x = x + size.width + offset

        width = width + size.width
        if size.height > height then
            height = size.height
        end
        if align == "center" then
            node:setAnchorPoint(display.CENTER)
        elseif align == "top" then
            node:setAnchorPoint(display.CENTER_TOP)
        elseif align == "down" then
            node:setAnchorPoint(display.CENTER_BOTTOM)
        end

    end

    local padLeft, padRight, padTop, padBottom = getPads(pads)

    width = width + padLeft + padRight + (#nodes - 1) * offset

    local offsetY
    if align == "center" then
        offsetY = height / 2
    elseif align == "top" then
        offsetY = height
    elseif align == "down" then
        offsetY = 0
    end

    for i, node in ipairs(nodes) do
        node:setPosition(padLeft + rowXs[i], padBottom + offsetY)
        node:setTag(i)
        container:addChild(node)
    end

    height = height + padTop + padBottom
    container:setContentSize(cc.size(width, height))

    function container:getElement(idx)
        return nodes[idx]
    end

    return container
end

function _M.createVBox(nodes, offset, pads, align)
    if align == nil then
        align = "center"
    end

    local container = display.newNode()

    local width, height = 0, 0
    local rowYs = {}

    if offset == nil then
        offset = 0
    end

    local y, size = 0

    local padLeft, padRight, padTop, padBottom = getPads(pads)

    local function setNodesPos()
        width, height = 0, 0
        y, size = 0, nil
        for i, node in ipairs(nodes) do
            size = node:getContentSize()

            rowYs[i] = y - size.height * 0.5
            y = y - size.height - offset

            if size.width > width then
                width = size.width
            end
            height = height + size.height
        end

        height = height + padTop + padBottom + (#nodes - 1) * offset

        for i, node in ipairs(nodes) do
            node:setAnchorPoint(display.CENTER)

            local alignPos = 0
            if align == "center" then
                alignPos = width / 2
            elseif align == "left" then
                alignPos = node:getContentSize().width / 2
            else
                alignPos = width - node:getContentSize().width / 2
            end

            node:setPosition(padLeft + alignPos, height - padTop + rowYs[i])
            node:setTag(i)
            if not node:getParent() then
                container:addChild(node)
            end
        end

        width = width + padLeft + padRight
        container:setContentSize(cc.size(width, height))
    end

    setNodesPos()

    function container:getElement(idx)
        return nodes[idx]
    end

    function container:addElement(e, pos)
        if pos == nil or pos < 1 then
            pos = #nodes + 1
        end
        if pos > #nodes + 1 then
            pos = #nodes + 1
        end
        table.insert(nodes, pos, e)
        setNodesPos()
    end

    function container:removeElement(e)
        local removeIdx = -1
        local height = e:getContentSize().height

        for i, v in ipairs(nodes) do
            if v == e then
                removeIdx = i
                break
            end
        end

        if removeIdx ~= -1 then
            for i = 1, removeIdx do
                local v = nodes[i]
                v:setPositionY(v:getPositionY() - height)
            end
        end

        if removeIdx ~= -1 then
            e:removeFromParent()
            table.remove(nodes, removeIdx)

            local size = self:getContentSize()
            self:setContentSize(cc.size(size.width, size.height - height))
        end
    end

    return container
end

function _M.createTBox(type, rows, cols, nodes, offsets, pads)
    local calcXY
    if type == "row" then
        calcXY = function(i)
            return (i - 1) % cols + 1, math.ceil(i / cols)
        end
    elseif type == "column" then
        calcXY = function(i)
            return math.ceil(i / rows), (i - 1) % rows + 1
        end
    else
        error("Unsupport Table Box type!")
    end

    local container = cc.Node:create()

    local width, height = 0, 0
    local colWidths, rowHeights = {}, {}

    local x, y, size
    for i, node in ipairs(nodes) do
        x, y = calcXY(i)
        size = node:getContentSize()
        if colWidths[x] == nil then
            colWidths[x] = 0
        end
        if colWidths[x] < size.width then
            colWidths[x] = size.width
        end
        if rowHeights[y] == nil then
            rowHeights[y] = 0
        end
        if rowHeights[y] < size.height then
            rowHeights[y] = size.height
        end
    end

    local colXs, rowYs = {0}, {0}
    local offsetX, offsetY = getOffsets(offsets)

    x, y = 0, 0
    for i, v in ipairs(colWidths) do
        colXs[i] = x + v * 0.5
        x = x + v + offsetX
        width = width + v
    end
    for i, v in ipairs(rowHeights) do
        rowYs[i] = y - v * 0.5
        y = y - v - offsetY
        height = height + v
    end

    local padLeft, padRight, padTop, padBottom = getPads(pads)

    width = width + padLeft + padRight + (#colWidths - 1) * offsetX
    height = height + padTop + padBottom + (#rowHeights - 1) * offsetY

    for i, node in ipairs(nodes) do
        x, y = calcXY(i)
        node:setPosition(padLeft + colXs[x], height - padTop + rowYs[y])
        node:setTag(i)
        container:addChild(node)
    end

    container:setContentSize(cc.size(width, height))

    function container:getElement(idx)
        return nodes[idx]
    end

    return container
end

return _M
