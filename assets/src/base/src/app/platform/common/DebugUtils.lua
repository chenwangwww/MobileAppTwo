--[[ rPrint(struct, [limit], [indent])   Recursively print arbitrary data.
   Set limit (default 100) to stanch infinite loops.
   Indents tables as [KEY] VALUE, nested tables as [KEY] [KEY]...[KEY] VALUE
   Set indent ("") to prefix each line:    Mytable [KEY] [KEY]...[KEY] VALUE
--]] cc.exports.rPrint = function(s, l, i) -- recursive Print (structure, limit, indent)
    l = (l) or 100;
    i = i or ""; -- default item limit, indent string
    if (l < 1) then
        print "ERROR: Item limit reached.";
        return l - 1
    end
    local ts = type(s);
    if (ts ~= "table") then
        print(i, ts, s);
        return l - 1
    end
    print(i, ts); -- print "table"
    for k, v in pairs(s) do -- print "[KEY] VALUE"
        l = rPrint(v, l, i .. "\t[" .. tostring(k) .. "]");
        if (l < 0) then
            break
        end
    end
    return l
end

cc.exports.debugDraw = function(node, color)
    local drawNode = cc.DrawNode:create()
    drawNode:setName("draw_node")

    local size = node:getContentSize()

    local poses = {display.LEFT_BOTTOM, cc.p(size.width, 0), cc.p(size.width, size.height), cc.p(0, size.height)}
    if color == nil then
        color = cc.c4f(0, 1, 0, 0.5)
    end
    drawNode:drawSolidPoly(poses, 4, color)
    drawNode:setPosition(display.LEFT_BOTTOM)
    node:addChild(drawNode, 100)

    return drawNode
end

cc.exports.createRectDebugNode = function(size, color)
    local drawNode = cc.DrawNode:create()
    drawNode:setContentSize(size)
    local pts = {display.LEFT_BOTTOM, cc.p(size.width, 0), cc.p(size.width, size.height), cc.p(0, size.height)}
    if color == nil then
        color = cc.c4f(1, 0, 0, 0.5)
    end
    drawNode:drawSolidPoly(pts, 4, color)
    return drawNode
end
