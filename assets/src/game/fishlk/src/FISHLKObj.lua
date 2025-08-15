-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishlkObj = class("FISHLKObj", function(fileName)
    return cc.Sprite:createWithSpriteFrameName(fileName)
end)
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
local MathAide = require "game.fishlk.src.MathAide"
local FishDeath = require "game.fishlk.src.FISHLKDeath"
local function getRes(path)
    return "game/fishlk/res/" .. path
end

function FishlkObj:ctor(fileName, fishTrace, trace_vector, FishGame)
    self.m_state = Fishlk_CMD.FishState.ACTIVE
    self.m_fishTrace = fishTrace
    self.m_trace_vector = trace_vector
    self.FishGame = FishGame
    -- self.traceIndex = 1
    self.m_beginPos = cc.p(0, 0)
    if #self.m_trace_vector > 0 then
        self.m_beginPos = cc.p(self.m_trace_vector[1].x, self.m_trace_vector[1].y)
        local action = nil
        if self.m_fishTrace.trace_type == Fishlk_CMD.TraceType.TRACE_BEZIER then
            local fDistance = MathAide.CalcDistance(self.m_trace_vector[1].x, self.m_trace_vector[1].y, self.m_trace_vector[2].x, self.m_trace_vector[2].y) +
                                  MathAide.CalcDistance(self.m_trace_vector[2].x, self.m_trace_vector[2].y, self.m_trace_vector[3].x, self.m_trace_vector[3].y)
            local fTime = fDistance / self.m_trace_vector.fSpeed / 18
            local bezierConfig = {cc.p(self.m_trace_vector[1].x, self.m_trace_vector[1].y), cc.p(self.m_trace_vector[2].x, self.m_trace_vector[2].y),
                                  cc.p(self.m_trace_vector[3].x, self.m_trace_vector[3].y)}
            action = cc.BezierTo:create(fTime, bezierConfig)
        else
            local fDistance = MathAide.CalcDistance(self.m_trace_vector[1].x, self.m_trace_vector[1].y, self.m_trace_vector[2].x, self.m_trace_vector[2].y)
            local fTime = fDistance / self.m_trace_vector.fSpeed / 18
            action = cc.MoveTo:create(fTime, cc.p(self.m_trace_vector[2].x, self.m_trace_vector[2].y))
        end
        local seq = cc.Sequence:create(action, cc.CallFunc:create(function()
            self.FishGame.m_fishMgr:RemoveFish(self)
        end))
        self:runAction(seq)
    end
    self:HandleRes()
    self:setZOrder(self.m_fishTrace.fish_kind)
    self:initPhysicsBody()
    self.scheduleID = nil
    self.scheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 0, false)
    self:enableNodeEvents()
end
function FishlkObj:onExit()
    -- print("FishlkObj onexit")
    self:disableNodeEvents()
    if self.scheduleID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID)
    end
end
-- 设置物理属性
function FishlkObj:initPhysicsBody()
    local body = nil
    local fish_kind = self.m_fishTrace.fish_kind
    if fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_24 then
        body = self.FishGame._dataModel:getBodyByType(self.m_fishTrace.fish_kind)
    elseif fish_kind > Fishlk_CMD.FishKind.FISH_KIND_24 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_27 then
        body = self.FishGame._dataModel:getBodyByName("dish_dsy")
    elseif fish_kind > Fishlk_CMD.FishKind.FISH_KIND_27 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_30 then
        body = self.FishGame._dataModel:getBodyByName("halo_dsx")
    elseif fish_kind > Fishlk_CMD.FishKind.FISH_KIND_30 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_40 then
        body = self.FishGame._dataModel:getBodyByName("halo")
    end
    if body == nil then
        print("body is nil.......")
        return
    end

    self:setPhysicsBody(body)
    -- 设置刚体属性
    self:getPhysicsBody():setCategoryBitmask(1)
    self:getPhysicsBody():setCollisionBitmask(0)
    self:getPhysicsBody():setContactTestBitmask(2)
    self:getPhysicsBody():setGravityEnable(false)
end
function FishlkObj:update(dt)
    if self.m_fishTrace ~= nil and self.m_fishTrace.init_count > 0 then
        --[[if #self.m_trace_vector>0 then
            if self.traceIndex >= #self.m_trace_vector then
                --定时器关闭
                self.FishGame.m_fishMgr:RemoveFish(self)
                return
            else
                self:setPosition(cc.p(self.m_trace_vector[self.traceIndex].x,self.m_trace_vector[self.traceIndex].y))
                self.traceIndex = self.traceIndex + 1
            end
        end--]]
        local tag = self:getTag()
        if tag ~= 100 then
            self:SetAngle()
        end
    end
    if self ~= nil then
        self.m_beginPos = cc.p(self:getPosition())
    end
end
function FishlkObj:closeSchdule()
    if self.scheduleID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID)
        self.scheduleID = nil
    end
    --[[if self.scheduleID_active then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_active)
        self.scheduleID_active=nil
    end--]]
end
function FishlkObj:HandleRes()
    self:setScale(1.414)
    if self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_1 then
        self:SetTextureAndAnimate(12, 1, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_2 then
        self:SetTextureAndAnimate(16, 2, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_3 then
        self:SetTextureAndAnimate(24, 3, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_4 then
        self:SetTextureAndAnimate(24, 4, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_5 then
        self:SetTextureAndAnimate(24, 5, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_6 then
        self:SetTextureAndAnimate(25, 6, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_7 then
        self:SetTextureAndAnimate(60, 7, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_8 then
        self:SetTextureAndAnimate(20, 8, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_9 then
        self:SetTextureAndAnimate(24, 9, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_10 then
        self:SetTextureAndAnimate(16, 10, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_11 then
        self:SetTextureAndAnimate(24, 11, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_12 then
        self:SetTextureAndAnimate(12, 12, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_13 then
        self:SetTextureAndAnimate(24, 13, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_14 then
        self:SetTextureAndAnimate(20, 14, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_15 then
        self:SetTextureAndAnimate(24, 15, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_16 then
        self:SetTextureAndAnimate(24, 16, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_17 then
        self:SetTextureAndAnimate(24, 17, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_18 then
        self:SetTextureAndAnimate(9, 18, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_19 then
        self:SetTextureAndAnimate(9, 19, 0.1)
        -- self:setScale(1.414)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_20 then
        self:SetTextureAndAnimate(20, 20, 0.1)
        -- self:setScale(1.414)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_LK then
        self:SetTextureAndAnimate(15, 21, 0.08)
        -- self:setScale(1.414)
        local pMultiple = cc.LabelAtlas:create("0", getRes("bingo_num.png"), 30, 36, string.byte("0"))
        pMultiple:setAnchorPoint(display.CENTER_BOTTOM)
        pMultiple:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height + 20))
        pMultiple:setTag(Fishlk_CMD.FishActiveTag.LK_TAG)
        pMultiple:setString("0")
        pMultiple:addTo(self)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_22 then
        self:SetTextureAndAnimate(15, 22, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_23 then
        self:SetTextureAndAnimate(8, 23, 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_24 then
        self:setContentSize(cc.size(140, 140))
        local pDish = cc.Sprite:createWithSpriteFrameName("fish24_d.png")
        pDish:setPosition(cc.p(70, 70))
        local rotateto = cc.RotateTo:create(2.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        pDish:setTag(Fishlk_CMD.FishKind.FISH_KIND_24)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_25 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(24, 4, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_26 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(24, 5, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_27 then
        self:setContentSize(cc.size(258, 84))
        for i = 1, 3 do
            local pDish = cc.Sprite:createWithSpriteFrameName("dish.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(60, 7, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_28 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(25, 6, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_29 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(20, 8, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_30 then
        self:setContentSize(cc.size(345, 84))
        for i = 1, 4 do
            local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
            pDish:setPosition(cc.p((i - 1) * (pDish:getContentSize().width + 3) + pDish:getContentSize().width / 2, 84 / 2))
            local rotateto = cc.RotateTo:create(1.0, 720)
            local pForever = cc.RepeatForever:create(rotateto)
            pDish:runAction(pForever)
            pDish:addTo(self)
            self:SetCombinationFish(16, 10, cc.p(pDish:getPosition()), 0.1)
        end
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_31 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, pDish:getContentSize().height / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(12, 1, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_32 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(16, 2, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_33 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(24, 3, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_34 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(24, 4, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_35 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(24, 5, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_36 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(25, 6, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_37 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(60, 7, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_38 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(20, 8, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_39 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(24, 9, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_40 then
        self:setContentSize(cc.size(84, 84))
        local pDish = cc.Sprite:createWithSpriteFrameName("halo.png")
        pDish:setPosition(cc.p(pDish:getContentSize().width / 2, 84 / 2))
        local rotateto = cc.RotateTo:create(1.0, 720)
        local pForever = cc.RepeatForever:create(rotateto)
        pDish:runAction(pForever)
        pDish:addTo(self)
        self:SetCombinationFish(16, 10, cc.p(pDish:getPosition()), 0.1)
    elseif self.m_fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_TASK then
        self:SetTextureAndAnimate(1, 25, 0.1)
        local pMultiple = cc.LabelAtlas:create("0", getRes("bingo_num.png"), 30, 36, string.byte("0"))
        pMultiple:setAnchorPoint(display.CENTER_BOTTOM)
        pMultiple:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height + 20))
        pMultiple:setTag(Fishlk_CMD.FishActiveTag.TASK_TAG)
        pMultiple:setString("0")
        pMultiple:addTo(self)
    end
end

function FishlkObj:SetAngle()
    local endPos = cc.p(self:getPosition())
    if self.m_beginPos == nil then
        return
    end
    if self.m_beginPos.x == endPos.x and self.m_beginPos.y == endPos.y then
        return
    end
    -- 计算角度
    local degree = 0
    if endPos.x == self.m_beginPos.x then
        if endPos.y > self.m_beginPos.y then
            degree = math.pi / 2
        end
        if endPos.x < self.m_beginPos.y then
            degree = -math.pi / 2
        end
    else
        local ftan
        if endPos.x < self.m_beginPos.x then
            ftan = -(endPos.y - self.m_beginPos.y) / (endPos.x - self.m_beginPos.x)
        else
            ftan = (endPos.y - self.m_beginPos.y) / (endPos.x - self.m_beginPos.x)
        end
        -- 弧度
        degree = math.atan(ftan)
    end
    -- 转角度
    if endPos.x < self.m_beginPos.x then
        degree = degree / math.pi * 180
        degree = degree + 180
    elseif (endPos.x > self.m_beginPos.x) then
        degree = degree / math.pi * -180
    elseif (endPos.x == self.m_beginPos.x) then
        degree = MathAide.CalcAngle(self.m_beginPos.x, self.m_beginPos.y, endPos.x, endPos.y)
        degree = degree / math.pi * 180
        degree = degree - 90
    end
    self:setRotation(degree)
end

function FishlkObj:SetTextureAndAnimate(count, kind, speed)
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format("fish%d_%02d.png", kind, i)

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

function FishlkObj:SetCombinationFish(count, kind, pos, speed)
    local pFish = cc.Sprite:create()
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format("fish%d_%02d.png", kind, i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(speed)
    local pAnimate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(pAnimate)
    pFish:setPosition(pos)
    pFish:runAction(repeatForever)
    pFish:addTo(self)
end

function FishlkObj:active()
    self.m_state = Fishlk_CMD.FishState.ACTIVE
    self:resume()
    -- self.scheduleID_active = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,self.update),0.01,false)
end

function FishlkObj:death(fish_score)
    -- 添加死鱼
    local fish_kind = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 4, 5, 7, 6, 8, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 25}
    local fileName = string.format("fish%d_d_01.png", fish_kind[self.m_fishTrace.fish_kind + 1])
    local pFishD = FishDeath.new(fileName, self.m_fishTrace, fish_score)
    pFishD:setPosition(self.m_beginPos)
    pFishD:setRotation(self:getRotation())
    pFishD:addTo(self:getParent())
    self.m_state = Fishlk_CMD.FishState.DEATH
    self.FishGame.m_fishMgr:RemoveFish(self)
end

function FishlkObj:stop()
    self.m_state = Fishlk_CMD.FishState.STOP
    self:pause()
end

function FishlkObj:GetFishID()
    return self.m_fishTrace.fish_id
end

function FishlkObj:GetFishTrace()
    return self.m_fishTrace
end

function FishlkObj:getPos()
    return self.m_beginPos
end

function FishlkObj:GetState()
    return self.m_state
end

function FishlkObj:setIndex(index)
    self.traceIndex = index
    self:setPosition(cc.p(self.m_trace_vector[1].x, self.m_trace_vector[1].y))
end
return FishlkObj
-- endregion
