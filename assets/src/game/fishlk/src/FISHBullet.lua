-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
local MathAide = require "game.fishlk.src.MathAide"
local FishBullet = class("FISHBullet", function(filename)
    return cc.Sprite:createWithSpriteFrameName(filename)
end)
local function getRes(path)
    return "game/fishlk/res/" .. path
end

function FishBullet:ctor(filename, bullet, FishGame, bulletAngle)
    self.m_bullet = bullet
    self.m_scene_size = cc.Director:getInstance():getVisibleSize()
    self:enableNodeEvents()
    self:init()
    self.FishGame = FishGame
    self.m_speed = 500
    self.bulletAngle = bulletAngle
    self.m_moveDir = cc.pForAngle(math.rad(90 - bulletAngle))
end
function FishBullet:initPhysicsBody()
    local body = self.FishGame._dataModel:getBodyByName("bullet")
    self:setPhysicsBody(body)
    self:getPhysicsBody():setCategoryBitmask(2)
    self:getPhysicsBody():setCollisionBitmask(0)
    self:getPhysicsBody():setContactTestBitmask(1)
    self:getPhysicsBody():setGravityEnable(false)
end
function FishBullet:onEnter()
    self.scheduleID_Normal = nil
    self.scheduleID_Normal = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateBullet), 0, false)
end
function FishBullet:updateBullet(dt)
    if self.m_bullet.lock_fishid <= 0 then
        self:updateNormalBullet(dt)
    else
        self:updateLockBullet(dt)
    end
end
-- 更新锁定子弹
function FishBullet:updateLockBullet(dt)
    local game_fish = nil
    local isUpdate = false
    if self.m_bullet.lock_fishid > 0 and self.FishGame ~= nil then
        game_fish = self.FishGame.m_fishMgr:GetFishIdToFish(self.m_bullet.lock_fishid)
    end

    if game_fish ~= nil then
        if self.FishGame.m_fishMgr:IsFishMaxScene(game_fish) == true then
            local speed = 35
            local thisPoint = cc.p(self:getPosition())
            local targetPoint = cc.p(game_fish:getPosition())
            local visibleSize = cc.Director:getInstance():getVisibleSize()
            if globalUserInfo.wChairID < 4 then
                targetPoint.x = (Fishlk_CMD.kResolutionWidth - targetPoint.x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
                targetPoint.y = (Fishlk_CMD.kResolutionHeight - targetPoint.y) / Fishlk_CMD.kResolutionHeight * visibleSize.height
            end
            local delta = cc.pSub(targetPoint, thisPoint)
            local distance = cc.pGetDistance(thisPoint, targetPoint)
            local x2 = thisPoint.x + speed * delta.x / distance
            local y2 = thisPoint.y + speed * delta.y / distance
            local newPosition = cc.p(x2, y2)
            self:setPosition(newPosition)

            local deltaRotation = MathAide.IsAngle(thisPoint, targetPoint) + 90
            self:setRotation(deltaRotation)
            isUpdate = true
        end
    end

    if isUpdate == false then
        self.m_bullet.lock_fishid = 0
    end
end
-- 更新正常子弹
function FishBullet:updateNormalBullet(dt)
    local movedis = dt * self.m_speed
    local movedir = cc.p(self.m_moveDir.x * movedis, self.m_moveDir.y * movedis)
    local pos = cc.p(self:getPositionX() + movedir.x, self:getPositionY() + movedir.y)
    self:setPosition(pos.x, pos.y)
    local rect = cc.rect(0, 0, self.FishGame.visibleSize.width, self.FishGame.visibleSize.height)
    local pos = cc.p(self:getPositionX(), self:getPositionY())

    if not cc.rectContainsPoint(rect, pos) then

        if (pos.x <= 0 and pos.y <= 0) or (pos.x <= 0 and pos.y >= self.FishGame.visibleSize.height) or (pos.x >= self.FishGame.visibleSize.width and pos.y >= self.FishGame.visibleSize.height) or
            (pos.x >= self.FishGame.visibleSize.width and pos.y <= 0) then
            local angle = self:getRotation()
            self:setRotation(180 + angle)
            if pos.x <= 0 and pos.y >= self.FishGame.visibleSize.height then
                pos.x = 0;
                pos.y = self.FishGame.visibleSize.height
            elseif pos.x >= self.FishGame.visibleSize.width and pos.y >= self.FishGame.visibleSize.height then
                pos.x = self.FishGame.visibleSize.width
                pos.y = self.FishGame.visibleSize.height
            elseif pos.x >= self.FishGame.visibleSize.width and pos.y <= 0 then
                pos.x = self.FishGame.visibleSize.width
                pos.y = 0;
            elseif pos.x <= 0 and pos.y <= 0 then
                pos.x = 0;
                pos.y = 0;
            end
        elseif pos.x < 0 or pos.x > self.FishGame.visibleSize.width then
            local angle = self:getRotation()
            self:setRotation(-angle)
            if pos.x < 0 then
                pos.x = 0
            else
                pos.x = self.FishGame.visibleSize.width
            end
        else
            local angle = self:getRotation()
            self:setRotation(-angle + 180)
            if pos.y < 0 then
                pos.y = 0
            else
                pos.y = self.FishGame.visibleSize.height
            end
        end

        self.m_moveDir = cc.pForAngle(math.rad(90 - self:getRotation()))

        local movedis = dt * self.m_speed
        local moveDir = cc.p(self.m_moveDir.x * movedis, self.m_moveDir.y * movedis)
        pos = cc.p(self:getPositionX() + moveDir.x, self:getPositionY() + moveDir.y)
        self:setPosition(pos.x, pos.y)
    end
end
function FishBullet:onExit()
    -- print("FishBullet onexit")
    self:disableNodeEvents()
    --[[if self.scheduleID_attackLockFish ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_attackLockFish)
    end--]]
    if self.scheduleID_Normal ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_Normal)
    end
    --[[if self.scheduleID_setPosition ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_setPosition)
    end--]]
end
function FishBullet:init()
    --[[local frameName = nil
    local animation = cc.Animation:create()
    for i=1,2 do
        if self.m_bullet.bullet_kind >= Fishlk_CMD.BulletKind.BULLET_KIND_1_NORMAL and self.m_bullet.bullet_kind <= Fishlk_CMD.BulletKind.BULLET_KIND_4_NORMAL then
	        frameName = string.format("bullet%d_norm%d_%d.png", self.m_bullet.bullet_kind + 1, self.m_bullet.chair_id + 1,i)
        end
        if self.m_bullet.bullet_kind >= Fishlk_CMD.BulletKind.BULLET_KIND_1_ION and self.m_bullet.bullet_kind <= Fishlk_CMD.BulletKind.BULLET_KIND_4_ION then
	        frameName = string.format("bullet%d_ion_%d.png",self.m_bullet.bullet_kind - Fishlk_CMD.BulletKind.BULLET_KIND_4_NORMAL,i)
        end
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.2)
    local animate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(animate)
    self:runAction(repeatForever)--]]
end

function FishBullet:GetBulletCmdDate()
    return self.m_bullet
end

function FishBullet:setLockFishID(i)
    self.m_bullet.lock_fishid = i
end

function FishBullet:moveToPoint(target_point, speed) -- ,vector_target_point) 
    self._start_point = cc.p(self:getPosition())
    if self.m_bullet.lock_fishid <= 0 then

        -- 当前点使其与服务器一致
        local current_pos = {}
        current_pos.x = self._start_point.x / self.m_scene_size.width * Fishlk_CMD.kResolutionWidth
        current_pos.y = self._start_point.y / self.m_scene_size.height * Fishlk_CMD.kResolutionHeight

        -- 目标点使其与s服务器一致 
        local target_pos = {}
        target_pos.x = target_point.x / self.m_scene_size.width * Fishlk_CMD.kResolutionWidth
        target_pos.y = target_point.y / self.m_scene_size.height * Fishlk_CMD.kResolutionHeight

        -- 当前点与目标点距离
        local fDistance = cc.pGetDistance(current_pos, target_pos)

        local pmove = cc.MoveTo:create(speed, target_point)
        local funcall = cc.CallFunc:create(function()
            self:moveCallBack(true)
        end)
        local seq = cc.Sequence:create(pmove, funcall)
        self:runAction(seq)
        --[[self.scheduleID_setPosition = nil
        self.count = 0
        self.vector_target_point = vector_target_point
        self.scheduleID_setPosition = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,self.changeBulletPostion),0,false)
        --]]
    else
        local fish = self.FishGame.m_fishMgr:GetFishIdToFish(self.m_bullet.lock_fishid)
        if fish ~= nil then
            self.scheduleID_attackLockFish = nil
            self.scheduleID_attackLockFish = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onAttackLockFish), 0, false)
        end
    end

end
function FishBullet:changeBulletPostion()
    local point_size = #self.vector_target_point
    self.count = self.count + 20
    local temp_point = {}
    if self.count >= point_size then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_setPosition)
        temp_point = self.vector_target_point[point_size]
        self:setPosition(temp_point)
        self:moveCallBack(true)
    else
        temp_point = self.vector_target_point[self.count]
        self:setPosition(temp_point)
    end
end
function FishBullet:moveCallBack(isRotation)
    -- 当前点
    local current_point = cc.p(self:getPosition())

    -- 角度计算
    local shootVector = cc.pSub(self._start_point, current_point)
    -- 向量标准化(即向量长度为1)
    local normalizedVector = cc.pNormalize(shootVector)
    -- 算出旋转的弧度
    local radians = math.atan2(normalizedVector.y, -normalizedVector.x)
    -- 将弧度转换成角度
    if isRotation == true then
        local angle = math.deg(-radians) - 90
        if current_point.y <= 0 or current_point.y >= self.m_scene_size.height then
            angle = angle - 180
        end
        self:setRotation(angle)
    end

    -- 适配向量
    local origin = cc.Director:getInstance():getVisibleOrigin()
    -- 目标方向
    local bullet_start_point = cc.pSub(self:convertToWorldSpace(cc.p(self:getContentSize().width / 2, self:getContentSize().height + 1)), origin)
    -- 计算目标点
    local target_point = {}
    -- local vector_target_point = {}
    local fDistance = cc.pGetDistance(current_point, bullet_start_point)
    local index = 0
    while true do
        index = index + 1
        local temp_target_point = {}
        local temp_point = cc.pSub(bullet_start_point, current_point)
        target_point = cc.pAdd(cc.p(temp_point.x / fDistance * index, temp_point.y / fDistance * index), current_point)
        -- 是否到达边缘
        if target_point.x <= 0 or target_point.x >= self.m_scene_size.width or target_point.y <= 0 or target_point.y >= self.m_scene_size.height then
            -- 对角位置进行偏移一个像素，避免卡着边上
            if target_point.x <= 0 and target_point.y >= self.m_scene_size.height then
                target_point.x = 1
                target_point.y = self.m_scene_size.height - 1
            elseif target_point.x >= self.m_scene_size.width and target_point.y >= self.m_scene_size.height then
                target_point.x = self.m_scene_size.width - 1
                target_point.y = self.m_scene_size.height - 1
            elseif target_point.x >= self.m_scene_size.width and target_point.y <= 0 then
                target_point.x = self.m_scene_size.width - 1
                target_point.y = 1
            elseif target_point.x <= 0 and target_point.y <= 0 then
                target_point.x = 1
                target_point.y = 1
            end
            if index > 3 then
                temp_target_point = target_point
                -- table.insert(vector_target_point,temp_target_point)
                break
            end
        end
        temp_target_point = target_point
        -- table.insert(vector_target_point,temp_target_point)
    end
    self.m_bullet.lock_fishid = 0
    local speed = (cc.pGetDistance(current_point, target_point)) / (self.FishGame.m_gameConfig.bullet_speed[self.m_bullet.bullet_kind + 1]) * 0.04
    -- 移动到点
    self:moveToPoint(target_point, speed) -- ,vector_target_point)
end
function FishBullet:onAttackLockFish()
    local game_fish = nil
    local isUpdate = false
    if self.m_bullet.lock_fishid > 0 and self.FishGame ~= nil then
        game_fish = self.FishGame.m_fishMgr:GetFishIdToFish(self.m_bullet.lock_fishid)
    end

    if game_fish ~= nil then
        if self.FishGame.m_fishMgr:IsFishMaxScene(game_fish) == true then
            local speed = 35
            local thisPoint = cc.p(self:getPosition())
            local targetPoint = cc.p(game_fish:getPosition())
            local visibleSize = cc.Director:getInstance():getVisibleSize()
            if globalUserInfo.wChairID < 4 then
                targetPoint.x = (Fishlk_CMD.kResolutionWidth - targetPoint.x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
                targetPoint.y = (Fishlk_CMD.kResolutionHeight - targetPoint.y) / Fishlk_CMD.kResolutionHeight * visibleSize.height
            end
            local delta = cc.pSub(targetPoint, thisPoint)
            local distance = cc.pGetDistance(thisPoint, targetPoint)
            local x2 = thisPoint.x + speed * delta.x / distance
            local y2 = thisPoint.y + speed * delta.y / distance
            local newPosition = cc.p(x2, y2)
            self:setPosition(newPosition)

            local deltaRotation = MathAide.IsAngle(thisPoint, targetPoint) + 90
            self:setRotation(deltaRotation)
            isUpdate = true
        end
    end

    if isUpdate == false then
        if self.scheduleID_attackLockFish ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID_attackLockFish)
            self.m_bullet.lock_fishid = 0
            self:moveCallBack(false)
        end
    end
end

return FishBullet
-- endregion
