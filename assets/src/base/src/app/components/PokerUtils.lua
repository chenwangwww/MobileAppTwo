local _M = {}

local SFUtils = require "app.components.SpriteFrameUtils"

function _M.newPoker(info)
    local size = cc.size(151, 209)
    local node = cc.Node:create()
    node:setContentSize(size)

    local bg = nil
    if info == nil then
        bg = SFUtils.newSprite("poker/poker_back.png"):move(size.width / 2, size.height / 2):addTo(node)
    else
        bg = SFUtils.newSprite("poker/bg.png"):move(size.width / 2, size.height / 2):addTo(node)
        node:updatePoker(info)
    end

    function node:showPoker(info, isAction)
        if isAction then
            local cbAction = cc.CallFunc:create(function()
                bg:setSpriteFrame("poker/bg.png")
                self:updatePoker(info)
            end)
            local scale = self:getScaleX()
            self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 0, scale), cbAction, cc.ScaleTo:create(0.2, scale, scale)))
        else
            bg:setSpriteFrame("poker/bg.png")
            self:updatePoker(info)
        end

        self._info = info
    end

    local num1, num2, flower = nil, nil, nil
    function node:updatePoker(info)
        if num1 ~= nil then
            num1:removeSelf()
        end
        if num2 ~= nil then
            num2:removeSelf()
        end
        if flower ~= nil then
            flower:removeSelf()
        end

        local typePath = string.format("poker/bigtag_%d.png", info[1] - 1)
        local numPath = string.format("poker/%s_%d.png", info[1] % 2 == 1 and "red" or "black", info[2] - 1)

        -- 数字
        num1 = SFUtils.newSprite(numPath):move(30, size.height - 30):addTo(node)

        -- 花
        flower = SFUtils.newSprite(typePath):setScale(0.5):move(30, size.height - 80):addTo(node)
        flower = SFUtils.newSprite(typePath):align(display.RIGHT_BOTTOM, size.width - 10, 10):addTo(node)
    end
    return node
end

-- 0 - 12 
function _M.findNiuNum(pokers)
    -- 是否金牛
    local isWdn = true
    for _, v in ipairs(pokers) do
        if v[2] < 11 then
            isWdn = false;
            break
        end
    end
    if isWdn then
        return 12
    end

    -- 是否银牛
    local isWxn = true
    for _, v in ipairs(pokers) do
        if v[2] < 10 then
            isWxn = false;
            break
        end
    end
    if isWxn then
        return 11
    end

    -- 查找牛
    local temp = {}
    for i, v in ipairs(pokers) do
        temp[i] = v[2] > 10 and 10 or v[2]
    end

    for i = 1, 5 do
        for j = i + 1, 5 do
            for k = j + 1, 5 do
                local sum = temp[i] + temp[j] + temp[k]
                if sum % 10 == 0 then -- 找到牛
                    local niuNum = 0
                    for l = 1, 5 do
                        if l ~= i and l ~= j and l ~= k then
                            niuNum = niuNum + temp[l]
                        end
                    end
                    if niuNum % 10 == 0 then
                        return 10
                    else
                        return niuNum % 10
                    end
                end
            end
        end
    end

    return 0
end

return _M
