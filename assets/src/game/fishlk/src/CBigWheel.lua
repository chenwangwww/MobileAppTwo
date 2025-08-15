-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHLK_CMD = require "game.fishlk.src.FISHLK_CMD"
local CBigWheel = class("CBigWheel", function(fileName)
    return cc.Sprite:createWithSpriteFrameName(fileName)
end)

function CBigWheel:ctor(fileName, chair_id, award, fish_id, FishGame)
    self.chair_id = chair_id
    self.award = award
    self.fish_id = fish_id
    self.FishGame = FishGame
    self:setSpriteFrame("di.png")
    local pzi = cc.Sprite:createWithSpriteFrameName("zi.png")
    pzi:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
    pzi:addTo(self)
    -- 无限旋转
    local rotateto = cc.RotateTo:create(1, 360 * 4)
    local pscoreRF = cc.RepeatForever:create(rotateto)
    pzi:runAction(pscoreRF)

    -- 5秒后执行角度回调
    local delaytimeAngle = cc.DelayTime:create(5)
    local funcallAngle = cc.CallFunc:create(handler(self, self.ziCallBack))
    local seqAngle = cc.Sequence:create(delaytimeAngle, funcallAngle)
    pzi:runAction(seqAngle)

    local panniou = cc.Sprite:createWithSpriteFrameName("anniou.png")
    panniou:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
    panniou:addTo(self)
    panniou:setRotation(180)
    panniou:setTag(1)
end

function CBigWheel:ziCallBack(node)
    node:stopAllActions()
    local angle = 0.0
    if self.award == FISHLK_CMD.Award.GOLD_5000W then
        angle = 0.0
    elseif self.award == FISHLK_CMD.Award.GOLD_10Y then
        angle = 45.0
    elseif self.award == FISHLK_CMD.Award.GOLD_1000W_1 then
        angle = 90.0
    elseif self.award == FISHLK_CMD.Award.GOLD_500W_1 then
        angle = 135.0
    elseif self.award == FISHLK_CMD.Award.GOLD_2500W then
        angle = 180.0
    elseif self.award == FISHLK_CMD.Award.GOLD_1Y then
        angle = 225.0
    elseif self.award == FISHLK_CMD.Award.GOLD_1000W_2 then
        angle = 270.0
    elseif self.award == FISHLK_CMD.Award.GOLD_500W_2 then
        angle = 315.0
    end
    node:setRotation(angle)
    local delaytime = cc.DelayTime:create(3.0)
    -- 3秒内过度消失
    local fadeout = cc.FadeOut:create(3.0)
    local funcall = cc.CallFunc:create(handler(self, self.removeCallBack))
    local seq = cc.Sequence:create(delaytime, fadeout, funcall)
    self:runAction(seq)

    local delaytimeanniou = cc.DelayTime:create(3.0)
    local fadeoutanniou = cc.FadeOut:create(3.0)
    local seqanniou = cc.Sequence:create(delaytimeanniou, fadeoutanniou)
    self:getChildByTag(1):runAction(seqanniou)

    -- 大转盘结束
    self.FishGame:TreasureBoxOver(self.chair_id, self.award, self.fish_id)
end

function CBigWheel:removeCallBack(node)
    node:removeFromParent()
end
return CBigWheel
-- endregion
