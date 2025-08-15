-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local CBingo = class("CBingo", function(fileName)
    return cc.Sprite:createWithSpriteFrameName(fileName)
end)
local function getRes(path)
    return "game/fishlk/res/" .. path
end
function CBingo:ctor(fileName, score)
    self:setSpriteFrame("bingo_01.png")
    local animation = cc.Animation:create()
    for i = 1, 10 do
        local frameName = string.format("bingo_%02d.png", i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.2)
    local animate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(animate)
    self:runAction(animate)

    local delaytime = cc.DelayTime:create(5)
    local fadeout = cc.FadeOut:create(3)
    local callFunc = cc.CallFunc:create(handler(self, self.removeCallBack))
    local seq = cc.Sequence:create(delaytime, fadeout, callFunc)
    self:runAction(seq)

    -- 分数
    local pScore = cc.LabelAtlas:create("0", getRes("bingo_num.png"), 30, 36, string.byte("0"))
    pScore:setAnchorPoint(display.CENTER)
    pScore:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
    pScore:addTo(self)

    local delaytimeSocre = cc.DelayTime:create(5)
    local fadeoutScore = cc.FadeOut:create(3)
    local seqScore = cc.Sequence:create(delaytimeSocre, fadeoutScore)
    pScore:runAction(seqScore)

    local szScore = tostring(score)
    pScore:setString(szScore)

    local rotateto = cc.RotateTo:create(1, 45)
    local rotateto1 = cc.RotateTo:create(1, -45)
    local pscoreSQ = cc.Sequence:create(rotateto, rotateto1)
    local pscoreRF = cc.RepeatForever:create(pscoreSQ)
    pScore:runAction(pscoreRF)
end

function CBingo:removeCallBack(node)
    node:removeFromParent()
end
return CBingo
-- endregion
