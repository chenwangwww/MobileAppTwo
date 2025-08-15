--[[
LHDBUtil.lua

]] local LHDBUtil = {}

function LHDBUtil.subText(text, subWidth, repStr)
    if not text or tolua.type(text) ~= "ccui.Text" or not subWidth then
        return
    end

    local width = text:getContentSize().width
    if width <= subWidth then
        return
    end

    local str = text:getString()
    local length = string.utf8len(str)
    for len = length - 1, 1, -1 do
        local tmp = GameUtil.subStringFromUTF8(str, len, nil, false)
        text:setString(tmp)
        width = text:getContentSize().width
        if width <= subWidth then
            str = tmp
            break
        end
    end
    if repStr then
        str = str .. tostring(repStr)
    end
    text:setString(str)
end

return LHDBUtil
