-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local BulletManager = class("BulletManager")
local FishArms = require "game.fishlk.src.FISHArms"
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
local Fish = require "game.fishlk.src.FISHLKObj"
local MathAide = require "game.fishlk.src.MathAide"
local FishMessage = require "game.fishlk.src.FISHLKMessage"
local FishBullet = require "game.fishlk.src.FISHBullet"
function BulletManager:ctor(FishGame)
    self.bullet_list = {}
    self.FishGame = FishGame
end

function BulletManager:reMoveAllBullet()
    if self.bullet_list ~= nil then
        for i = #self.bullet_list, 1, -1 do
            if self.bullet_list[i] ~= nil then
                local bullet = table.remove(self.bullet_list, i)
                bullet:removeFromParent()
            end
        end
        self.bullet_list = {}
    end
end

function BulletManager:update(dt)
    -- self:Collision()
end

--[[[玩家开火
struct CMD_S_UserFire
{
	BulletKind bullet_kind;//子弹类型
	int bullet_id;//子弹ID
	WORD chair_id;//玩家座位ID
	WORD android_chairid;//机器人座位ID
	//float angle;//玩家开火角度
	FPoint fire_pos;//玩家开火点
	int bullet_multiple;//子弹倍数
	int lock_fishid;//锁定鱼的ID
	SCORE fish_score;//鱼的分数
};--]]
function BulletManager:fire(value)
    local bullet = {}
    bullet.bullet_kind = value.bullet_kind
    bullet.bullet_id = value.bullet_id
    bullet.chair_id = value.chair_id
    bullet.android_chairid = value.android_chairid
    bullet.fire_pos = value.fire_pos
    bullet.bullet_multiple = value.bullet_multiple
    bullet.lock_fishid = value.lock_fishid
    bullet.fish_score = value.fish_score

    -- 适配向量
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()

    local pArms = self.FishGame:FindArms(value.chair_id)
    -- 用户武器点
    local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), origin)
    -- 点击位置转换
    --[[local fire_pos={}
    fire_pos.x = value.fire_pos.x / Fishlk_CMD.kResolutionWidth * visibleSize.width
    fire_pos.y = Fishlk_CMD.kResolutionHeight - value.fire_pos.y
    fire_pos.y = fire_pos.y / Fishlk_CMD.kResolutionHeight * visibleSize.height--]]
    local temp_ViewID = self.FishGame:ChangeViewChairID(value.chair_id + 1)
    local fire_pos = {}
    if temp_ViewID <= 4 then
        fire_pos.x = (Fishlk_CMD.kResolutionWidth - value.fire_pos.x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
        fire_pos.y = value.fire_pos.y / Fishlk_CMD.kResolutionHeight * visibleSize.height
    else
        fire_pos.x = value.fire_pos.x / Fishlk_CMD.kResolutionWidth * visibleSize.width
        fire_pos.y = Fishlk_CMD.kResolutionHeight - value.fire_pos.y
        fire_pos.y = fire_pos.y / Fishlk_CMD.kResolutionHeight * visibleSize.height
    end
    -- 是否锁定鱼
    if bullet.lock_fishid > 0 then
        local fish_lock = self.FishGame.m_fishMgr:GetFishIdToFish(bullet.lock_fishid);
        if fish_lock then
            if globalUserInfo.wChairID < 4 then
                fire_pos.x = (Fishlk_CMD.kResolutionWidth - fish_lock:getPos().x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
                fire_pos.y = (Fishlk_CMD.kResolutionHeight - fish_lock:getPos().y) / Fishlk_CMD.kResolutionHeight * visibleSize.height
            else
                fire_pos = fish_lock:getPos()
            end
        end
    end

    -- 子弹角度
    local bulletAngle = MathAide.IsAngle(userPos, fire_pos) + 90;
    -- 子弹位置
    local bullet_point = cc.pSub(pArms:convertToWorldSpace(cc.p(pArms:getContentSize().width / 2, pArms:getContentSize().height + 20)), origin);

    -- 创建子弹
    local bullet_png = {"bullet_6.png", "bullet_6.png", "bullet_5.png", "bullet_5.png", "bullet_7.png", "bullet_7.png", "bullet_8.png", "bullet_8.png"}
    local pbullet = FishBullet.new(bullet_png[temp_ViewID], bullet, self.FishGame, bulletAngle);
    pbullet:setPosition(bullet_point);
    pbullet:setRotation(bulletAngle);
    pbullet:setScale(0.8)
    pbullet:setTag(1)
    pbullet:initPhysicsBody()
    self.FishGame.m_bulletLayer:addChild(pbullet);

    -- 发射目标方向
    --[[local bullet_start_point = cc.pSub(pbullet:convertToWorldSpace(cc.p(pbullet:getContentSize().width / 2, pbullet:getContentSize().height + 1)) , origin)

	                                                     
	--计算目标点
	local target_point={}
    --local vector_target_point = {}
    local fDistance = cc.pGetDistance(bullet_point,bullet_start_point)
	local index = 1
	while true do
		index = index +1
        local temp_target_point = {}
        local temp_point = cc.pSub(bullet_start_point, bullet_point) 
		target_point = cc.pAdd(cc.p(temp_point.x/ fDistance * index ,temp_point.y/ fDistance * index), bullet_point)
		--是否到达边缘
		if target_point.x <= 0 or target_point.x >= visibleSize.width or target_point.y <= 0 or target_point.y >= visibleSize.height then
			--对角处进行偏移一个像素,避免卡在边上
			if target_point.x <= 0 and target_point.y >= visibleSize.height then
				target_point.x = 1;
				target_point.y = visibleSize.height - 1;
			elseif target_point.x >= visibleSize.width and target_point.y >= visibleSize.height then
				target_point.x = visibleSize.width - 1;
				target_point.y = visibleSize.height - 1;
			elseif target_point.x >= visibleSize.width and target_point.y <= 0 then
				target_point.x = visibleSize.width - 1;
				target_point.y = 1;
			elseif target_point.x <= 0 and target_point.y <= 0 then
				target_point.x = 1;
				target_point.y = 1;
			end
			if index > 2 then
                temp_target_point = target_point
                --table.insert(vector_target_point,temp_target_point)
				break
			end
		end
        temp_target_point = target_point
        --table.insert(vector_target_point,temp_target_point)
	end
    local num = 0.04
    if bullet.lock_fishid > 0 then
        num=0.02
    end
	local speed = cc.pGetDistance(cc.p(pbullet:getPosition()),target_point) / (self.FishGame.m_gameConfig.bullet_speed[bullet.bullet_kind+1]) * num;--锁定状态速度快一点避免从边上穿透

	--子弹移动到点
    --pbullet:moveToPoint(target_point, speed,vector_target_point);
    pbullet:moveToPoint(target_point, speed); --]]
    self:AddBullet(pbullet);
end

function BulletManager:AddBullet(value)
    table.insert(self.bullet_list, value)
end
-- 碰撞监听
function BulletManager:Collision()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    for key, value in ipairs(self.bullet_list) do
        if value:GetBulletCmdDate().lock_fishid > 0 then
            local fish = self.FishGame.m_fishMgr:GetFishIdToFish(value:GetBulletCmdDate().lock_fishid)
            if fish ~= nil and self.FishGame.m_fishMgr:IsFishMaxScene(fish) then
                -- 圆形碰撞
                local temp_fish_pos = {}
                if globalUserInfo.wChairID < 4 then
                    temp_fish_pos.x = (Fishlk_CMD.kResolutionWidth - fish:getPos().x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
                    temp_fish_pos.y = (Fishlk_CMD.kResolutionHeight - fish:getPos().y) / Fishlk_CMD.kResolutionHeight * visibleSize.height
                else
                    temp_fish_pos = fish:getPos()
                end
                if fish:GetFishTrace().fish_kind == Fishlk_CMD.FishKind.FISH_KIND_9 then
                    local fDistance = cc.pGetDistance(cc.p(temp_fish_pos.x, temp_fish_pos.y), cc.p(value:getPosition()))
                    if fDistance <= fish:getContentSize().width / 6 then
                        self:Collisions(fish, value:GetBulletCmdDate(), value, true)
                        self:removeBullet(value)
                        return
                    end
                elseif fish:GetFishTrace().fish_kind > Fishlk_CMD.FishKind.FISH_KIND_9 and fish:GetFishTrace().fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_30 then
                    local fDistance = cc.pGetDistance(cc.p(temp_fish_pos.x, temp_fish_pos.y), cc.p(value:getPosition()))
                    if fDistance <= fish:getContentSize().width / 3 then
                        self:Collisions(fish, value:GetBulletCmdDate(), value, true)
                        self:removeBullet(value)
                        return
                    end
                else
                    -- 色素碰撞
                    --[[local bullet_to_worldpoint = value:getParent():convertToWorldSpace(cc.p(value:getPosition()))
                    local point = fish:convertToNodeSpace(bullet_to_worldpoint)
                    --local rect = cc.rect(0,0,fish:getContentSize().width,fish:getContentSize().height)
                    if self:isCollision(fish,point) then
                        self:Collisions(fish,value:GetBulletCmdDate())
                        self:removeBullet(value)
                        return
                    end--]]
                    local fDistance = cc.pGetDistance(cc.p(temp_fish_pos.x, temp_fish_pos.y), cc.p(value:getPosition()))
                    if fDistance <= fish:getContentSize().width then
                        self:Collisions(fish, value:GetBulletCmdDate(), value, true)
                        self:removeBullet(value)
                        return
                    end
                end
            else
                value:setLockFishID(0)
                self.FishGame.m_fishMgr.m_FishLock[value:GetBulletCmdDate().chair_id + 1] = nil
                return
            end
        else
            for key, fish in ipairs(self.FishGame.m_fishMgr:GetFishList()) do
                if self.FishGame.m_fishMgr:IsFishMaxScene(fish) then
                    -- 圆形碰撞
                    local temp_fish_pos = {}
                    if globalUserInfo.wChairID < 4 then
                        temp_fish_pos.x = (Fishlk_CMD.kResolutionWidth - fish:getPos().x) / Fishlk_CMD.kResolutionWidth * visibleSize.width
                        temp_fish_pos.y = (Fishlk_CMD.kResolutionHeight - fish:getPos().y) / Fishlk_CMD.kResolutionHeight * visibleSize.height
                    else
                        temp_fish_pos = fish:getPos()
                    end
                    --[[if fish:GetFishTrace().fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_24 and fish:GetFishTrace().fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_40 then
                        local fDistance = cc.pGetDistance(cc.p(temp_fish_pos.x,temp_fish_pos.y),cc.p(value:getPosition()))
                        if fDistance <= fish:getContentSize().width/2 then
                            self:Collisions(fish,value:GetBulletCmdDate())
                            self:removeBullet(value)
                            return
                        end
                    else--]]
                    -- 色素碰撞
                    --[[local bullet_to_worldpoint = value:getParent():convertToWorldSpace(cc.p(value:getPosition()))
                        local point = fish:convertToNodeSpace(bullet_to_worldpoint)
                        if self:isCollision(fish,point) then
                            --self:Collisions(fish,value:GetBulletCmdDate())
                            self:removeBullet(value)
                            return
                        end--]]
                    local radius = fish:getContentSize().width
                    if fish:GetFishTrace().fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_15 and fish:GetFishTrace().fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_LK then
                        radius = fish:getContentSize().width / 2
                    end
                    local bullet_pos = {}
                    bullet_pos = cc.p(value:getPosition())
                    if math.abs(bullet_pos.x - temp_fish_pos.x) <= radius and math.abs(bullet_pos.y - temp_fish_pos.y) <= radius then
                        local bullet_to_worldpoint = value:getParent():convertToWorldSpace(bullet_pos)
                        local bullet_to_fishParent = fish:getParent():convertToNodeSpace(bullet_to_worldpoint)
                        local fishPos = cc.p(fish:getPosition());
                        local fishSize = fish:getContentSize()
                        local rotation = fish:getRotation()
                        local x = (bullet_to_fishParent.x - fishPos.x) * math.cos(math.rad(rotation)) - (bullet_to_fishParent.y - fishPos.y) * math.sin(math.rad(rotation)) + fishPos.x
                        local y = (bullet_to_fishParent.x - fishPos.x) * math.sin(math.rad(rotation)) + (bullet_to_fishParent.y - fishPos.y) * math.cos(math.rad(rotation)) + fishPos.y
                        -- local point = fish:convertToNodeSpace(bullet_to_worldpoint)
                        if (x <= fishPos.x + fishSize.width * 0.707 and x >= fishPos.x - fishSize.width * 0.707) and
                            (y <= fishPos.y + fishSize.height * 0.707 and y >= fishPos.y - fishSize.height * 0.707) then
                            self:Collisions(fish, value:GetBulletCmdDate(), value, false)
                            self:removeBullet(value)
                            return
                        end
                        --[[if self:isCollision(fish,point) then
                            self:Collisions(fish,value:GetBulletCmdDate(),value,false)
                            self:removeBullet(value)
                            return
                        end --]]
                    end

                    -- end 
                end
            end
        end
    end
end
-- 碰撞处理
function BulletManager:Collisions(fish, cmd_bullet, bullet, isLockFish)
    -- 变色
    if cmd_bullet.chair_id == globalUserInfo.wChairID then
        fish:setColor(cc.RED)
        fish:stopActionByTag(99)
        local delaytime = cc.DelayTime:create(0.2)
        local pFishColorWhite = cc.TintBy:create(0.1, 255, 255, 255)
        local pFishColorAnim = cc.Sequence:create(delaytime, pFishColorWhite)
        pFishColorAnim:setTag(99)
        fish:runAction(pFishColorAnim)
        local childCount = 0
        if fish:GetFishTrace().fish_kind ~= Fishlk_CMD.FishKind.FISH_KIND_LK and fish:GetFishTrace().fish_kind ~= Fishlk_CMD.FishKind.FISH_KIND_TASK then
            childCount = fish:getChildrenCount()
        end
        for i = 1, childCount do
            local nodes = fish:getChildren()
            local node = nodes[i]
            node:setColor(cc.RED)
            node:stopActionByTag(99)
            local delaytime = cc.DelayTime:create(0.2)
            local pFishColorWhite = cc.TintBy:create(0.1, 255, 255, 255)
            local pFishColorAnim = cc.Sequence:create(delaytime, pFishColorWhite)
            pFishColorAnim:setTag(99)
            node:runAction(pFishColorAnim)

            local childCount1 = node:getChildrenCount()
            for j = 1, childCount1 do
                local nodes1 = fish:getChildren()
                local node1 = nodes1[j]
                node1:setColor(cc.RED)
                node1:stopActionByTag(99)
                local delaytime = cc.DelayTime:create(0.2)
                local pFishColorWhite = cc.TintBy:create(0.1, 255, 255, 255)
                local pFishColorAnim = cc.Sequence:create(delaytime, pFishColorWhite)
                pFishColorAnim:setTag(99)
                node1:runAction(pFishColorAnim)
            end
        end
    end
    local temp_ViewID = self.FishGame:ChangeViewChairID(cmd_bullet.chair_id + 1)
    local filename = {"yellow_%d.png", "yellow_%d.png", "blue_%d.png", "blue_%d.png", "purple_%d.png", "purple_%d.png", "red_%d.png", "red_%d.png"}
    local pFishNet = cc.Sprite:createWithSpriteFrameName(string.format(filename[temp_ViewID], 1))
    local temp_bulletPoint = {}
    -- local movedis = 0.033 * bullet.m_speed
    -- local movedir = cc.p(bullet.m_moveDir.x*movedis,bullet.m_moveDir.y*movedis)
    local movedir = cc.pMul(bullet.m_moveDir, 20)
    local pos = cc.p(bullet:getPositionX() + movedir.x, bullet:getPositionY() + movedir.y)
    if globalUserInfo.wChairID < 4 then
        temp_bulletPoint.x = (Fishlk_CMD.kResolutionWidth - pos.x) / Fishlk_CMD.kResolutionWidth * self.FishGame.visibleSize.width
        temp_bulletPoint.y = (Fishlk_CMD.kResolutionHeight - pos.y) / Fishlk_CMD.kResolutionHeight * self.FishGame.visibleSize.height
    else
        temp_bulletPoint = pos
    end
    if isLockFish == true then
        pFishNet:setPosition(cc.p(fish:getPos().x, fish:getPos().y))
    else
        pFishNet:setPosition(cc.p(temp_bulletPoint.x, temp_bulletPoint.y))
    end
    self.FishGame.m_fishNetLayer:addChild(pFishNet)
    local animation = cc.Animation:create()
    for i = 1, 18 do
        local frameName = string.format(filename[temp_ViewID], i)
        if i == 1 then
            pFishNet:setSpriteFrame(frameName)
        end
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.02)
    local animate = cc.Animate:create(animation)
    local funcall = cc.CallFunc:create(handler(self, self.removeFishNet))
    local pSq = cc.Sequence:create(animate, funcall)
    pFishNet:runAction(pSq)

    local armature = ccs.Armature:create("qipao") -- 创建动画对象
    armature:getAnimation():play("qipao") -- 设置动画对象执行的动画名称
    armature:align(display.CENTER, pFishNet:getContentSize().width / 2, pFishNet:getContentSize().height / 2):addTo(pFishNet)
    if cmd_bullet.chair_id == globalUserInfo.wChairID or cmd_bullet.android_chairid ~= GameDefine.INVALID_CHAIR then
        if fish:GetState() ~= Fishlk_CMD.FishState.DEATH then
            -- 打到李逵
            if fish:GetFishTrace().fish_kind == Fishlk_CMD.FishKind.FISH_KIND_LK then
                local cmd = {}
                cmd.chair_id = globalUserInfo.wChairID
                cmd.fish_id = fish:GetFishID()
                cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
                cmd.validate_info = self.FishGame:GetMd5Info(fish:GetFishID(), cmd_bullet.bullet_id, cmd.dwCurrentTime)
                FishMessage.send_CMD_C_HitFishLK(cmd)
            end
            local cmd = {}
            cmd.chair_id = cmd_bullet.chair_id
            cmd.fish_id = fish:GetFishID()
            cmd.bullet_kind = cmd_bullet.bullet_kind
            cmd.bullet_id = cmd_bullet.bullet_id
            cmd.bullet_multiple = cmd_bullet.bullet_multiple
            cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
            cmd.validate_info = self.FishGame:GetMd5Info(fish:GetFishID(), cmd.bullet_id, cmd.dwCurrentTime)

            FishMessage.send_CMD_C_CatchFish(cmd)
        end
    end
end

function BulletManager:removeBullet(bullet)
    if bullet == nil then
        return
    end
    for key, var in ipairs(self.bullet_list) do
        if var == bullet then
            table.remove(self.bullet_list, key)
            bullet:removeFromParent()
        end
    end
end

-- 碰撞测试
function BulletManager:isCollision(sprite, point)
    local size = sprite:getContentSize()
    local rect = cc.rect(0, 0, size.width, size.height)
    if cc.rectContainsPoint(rect, point) == false then
        return false
    end
    -- R G B A通道值
    local buffer = {}
    -- 当前点相对鱼位置的A通道色值
    local renderTexture = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    renderTexture:beginWithClear(0, 0, 0, 0)
    sprite:draw()
    buffer = gl.readPixels(point.x, point.y, 1, 1, gl.RGBA, gl.UNSIGNED_BYTE, 4)
    renderTexture:endToLua()

    -- 透明度
    local nAlpha = buffer[4]
    if nAlpha == 0 then
        return false
    end
    return true
end

-- 移除渔网
function BulletManager:removeFishNet(pSender)
    pSender:removeFromParent()
end

return BulletManager

-- endregion
