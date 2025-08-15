-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishArms = class("FISHArms", function(filename)
    return cc.Sprite:createWithSpriteFrameName(filename)
end)
local res_pathArms = {"pt1_%d.png", "pt1_%d.png", "pt2_%d.png", "pt2_%d.png", "pt3_%d.png", "pt3_%d.png", "PT4_%d.png", "PT4_%d.png"}
local function getRes(path)
    return "game/fishlk/res/" .. path
end
function FishArms:ctor(filename)
    self:setAnchorPoint(cc.p(0.5, 0.2))
end

function FishArms:SetArmsFile(wChairID)
    self:setAnchorPoint(cc.p(0.5, 0.2))
    self.wChairID = wChairID
    -- self:setSpriteFrame(getRes(filename))
end

function FishArms:GetArmsFile()
    return self.file_type
end

function FishArms:fire()
    self:stopAllActions()
    local animation = cc.Animation:create()
    for i = 1, 5 do
        local frameName = string.format(res_pathArms[self.wChairID], i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.1)
    local animate = cc.Animate:create(animation)
    self:runAction(animate)
end
return FishArms
-- endregion
