-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishDeath = class("FISHLKDeath", function(fileName)
    return cc.Sprite:createWithSpriteFrameName(fileName)
end)
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
local function getRes(path)
    return "game/fishlk/res/" .. path
end
function FishDeath:ctor(fileName, fishTrace, fish_score)
    self:setAnchorPoint(display.CENTER)
    self.time = 0.0
    self.m_fishTrace = fishTrace
    self:HandleRes()
    local delayTime = cc.DelayTime:create(1.5)
    local callback = cc.CallFunc:create(function()
        self:removeFromParent()
    end)
    local seq = cc.Sequence:create(delayTime, callback)
    self:runAction(seq)
    local szScore = string.format("%d", fish_score)
    local pMultiple = cc.LabelAtlas:create(szScore, getRes("bingo_num.png"), 30, 36, string.byte("0"))
    pMultiple:setPosition(cc.p(self:getContentSize().width / 2 - pMultiple:getContentSize().width / 2, self:getContentSize().height / 2 - pMultiple:getContentSize().height / 2))
    pMultiple:addTo(self)
end

function FishDeath:HandleRes()
    self:setScale(1.414)
    if self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_1 then
        self:SetTextureAndAnimate(5, 1, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_2 then
        self:SetTextureAndAnimate(3, 2, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_3 then
        self:SetTextureAndAnimate(3, 3, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_4 then
        self:SetTextureAndAnimate(8, 4, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_5 then
        self:SetTextureAndAnimate(3, 5, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_6 then
        self:SetTextureAndAnimate(6, 6, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_7 then
        self:SetTextureAndAnimate(3, 7, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_8 then
        self:SetTextureAndAnimate(6, 8, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_9 then
        self:SetTextureAndAnimate(4, 9, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_10 then
        self:SetTextureAndAnimate(7, 10, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_11 then
        self:SetTextureAndAnimate(4, 11, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_12 then
        self:SetTextureAndAnimate(4, 12, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_13 then
        self:SetTextureAndAnimate(4, 13, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_14 then
        self:SetTextureAndAnimate(3, 14, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_15 then
        self:SetTextureAndAnimate(6, 15, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_16 then
        self:SetTextureAndAnimate(6, 16, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_17 then
        self:SetTextureAndAnimate(4, 17, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_18 then
        self:SetTextureAndAnimate(3, 18, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_19 then
        self:SetTextureAndAnimate(4, 19, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_20 then
        self:SetTextureAndAnimate(20, 20, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_LK then
        self:SetTextureAndAnimate(9, 21, 0.08)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_22 then
        self:SetTextureAndAnimate(15, 22, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_23 then
        self:SetTextureAndAnimate(8, 23, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_24 then
        self:setContentSize(cc.size(140, 140))
        local pDish = cc.Sprite:createWithSpriteFrameName("fish24_d.png")
        pDish:setPosition(cc.p(70, 70))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_25 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(8, 4, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_26 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(3, 5, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_27 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(3, 7, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_28 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(6, 6, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_29 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(6, 8, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_30 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(0.5, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(7, 10, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_31 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, pDish:getContentSize().height / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(5, 1, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_32 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(3, 2, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_33 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(3, 3, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_34 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(8, 4, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_35 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(3, 5, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_36 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(6, 6, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_37 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(3, 7, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_38 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(6, 8, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_39 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(4, 9, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_40 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(0.5, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(7, 10, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_TASK then
        self:SetTextureAndAnimate(1, 1, 0.1)
    end
end
function FishDeath:SetTextureAndAnimate(count, kind, speed)
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format("fish%d_d_%02d.png", kind, i)
        if i == 1 then
            self:setSpriteFrame(frameName)
        end
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(speed)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
end

function FishDeath:SetCombinationFish(count, kind, pos, speed)
    local pFish = cc.Sprite:create()
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format("fish%d_d_%02d.png", kind, i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(speed)
    local pAnimate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(pAnimate)
    pFish:setPosition(cc.p(pos.x, pos.y))
    pFish:runAction(repeatForever)
    pFish:addTo(self)
end
return FishDeath
-- endregion
