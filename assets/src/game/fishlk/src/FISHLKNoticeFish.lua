-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHLKNoticeFish = class("FISHLKNoticeFish", function(pszFileName)
    return cc.Sprite:createWithSpriteFrameName(pszFileName)
end)

local function getRes(path)
    return "game/fishlk/res/" .. path
end
function FISHLKNoticeFish:ctor(pszFileName)
    local delaytime = cc.DelayTime:create(2)
    local fadeOut = cc.FadeOut:create(1)
    local seq = cc.Sequence:create(delaytime, fadeOut, cc.CallFunc:create(function()
        self:removeFromParent()
    end))
    self:runAction(seq)
end

return FISHLKNoticeFish
-- endregion
