local _M = {}

function _M.create(imgPath, size, length)
    local singleSize = cc.size(size.width / 10, size.height)

    local nodeSize = cc.size(singleSize.width * length, singleSize.height)
    local node = display.newNode()
    node:setContentSize(nodeSize)

    local value = 0

    local sprites = {}
    for i = 1, length do
        local sp = cc.Sprite:create(imgPath, cc.rect(0, 0, singleSize.width, singleSize.height))
        sp:align(display.LEFT_BOTTOM, (i - 1) * singleSize.width, 0):addTo(node)

        sprites[i] = sp
    end

    function node:setValue(_num)
        value = _num
        local valueStr = tostring(value)
        local valLen = #valueStr

        local zeroLen = length - valLen
        for i = 1, zeroLen do
            sprites[i]:setTextureRect(cc.rect(0, 0, singleSize.width, singleSize.height))
        end

        for i = 1, valLen do
            local num = tonumber(string.sub(valueStr, i, i))
            sprites[zeroLen + i]:setTextureRect(cc.rect(num * singleSize.width, 0, singleSize.width, singleSize.height))
        end
    end

    function node:getValue()
        return value
    end

    return node
end

return _M
