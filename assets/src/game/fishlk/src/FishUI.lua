-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHLK_CMD = require "game.fishlk.src.FISHLK_CMD"
local MathAide = require "game.fishlk.src.MathAide"
local FishMessage = require "game.fishlk.src.FISHLKMessage"
local FishUI = class("FishUI", function()
    return cc.Layer:create()
end)
local function getRes(path)
    return "game/fishlk/res/" .. path
end

function FishUI:ctor(FishGame)
    self:init()
    self.FishGame = FishGame
    self.isLock = false
end

function FishUI:init()
    self:addUI()
end

function FishUI:addUI()
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local pWidgetWin = cc.Node:create()
    pWidgetWin:setContentSize(self:getContentSize())
    pWidgetWin:addTo(self)
    self.isFirstTouch = true
    -- 退出
    self.m_returnBtn = self:createButtonWithSpriteFrameName(true, "Retrurn.png", "Retrurn_1.png", function()
        self.FishGame:ExitGame()
    end)
    self.m_returnBtn:setPosition(cc.p(self.m_returnBtn:getContentSize().width / 2 + 10, visibleSize.height - self.m_returnBtn:getContentSize().height * 1.2))
    self.m_returnBtn:addTo(pWidgetWin)
    -- 设置
    self.m_settingBtn = self:createButtonWithSpriteFrameName(true, "button-3.png", "button-3_0.png", function()
        if self.FishGame.m_Settings:isVisible() then
            self.FishGame.m_Settings:hideSettings()
        else
            self.FishGame.m_Settings:showSettings()
        end
    end)
    self.m_settingBtn:setPosition(cc.p(visibleSize.width - self.m_settingBtn:getContentSize().width / 2 - 10, visibleSize.height - self.m_settingBtn:getContentSize().height * 1.2))
    self.m_settingBtn:addTo(pWidgetWin)

    -- 帮助
    self.m_helpBtn = self:createButtonWithSpriteFrameName(true, "btn_help_1.png", "btn_help_2.png", function()
        if self.FishGame.m_Help:isVisible() then
            self.FishGame.m_Help:hideHelp()
        else
            self.FishGame.m_Help:showHelp()
        end
    end)
    self.m_helpBtn:setPosition(cc.p(visibleSize.width - self.m_settingBtn:getContentSize().width / 2 - 10, visibleSize.height - self.m_settingBtn:getContentSize().height * 2.5))
    self.m_helpBtn:addTo(pWidgetWin)
    -- 锁定
    --[[self.m_lockFishBtn = self:createButtonWithSpriteFrameName(true,"button-6.png","button-6.png",function()
        self:LockFish(globalUserInfo.wChairID,0)
    end)
    self.m_lockFishBtn:setPosition(cc.p(self.m_lockFishBtn:getContentSize().width/2+self.m_lockFishBtn:getContentSize().width,self.m_lockFishBtn:getContentSize().height * 3))
    self.m_lockFishBtn:addTo(pWidgetWin)
    --解锁
    self.m_unlockFishBtn = self:createButtonWithSpriteFrameName(true,"button-0.png","button-0.png",function()
        self.FishGame.m_fishMgr.m_FishLock[globalUserInfo.wChairID+1] = nil
    end)
    self.m_unlockFishBtn:setPosition(cc.p(self.m_lockFishBtn:getPositionX(),self.m_lockFishBtn:getPositionY()-self.m_unlockFishBtn:getContentSize().height * 1.5))
    self.m_unlockFishBtn:addTo(pWidgetWin) --]]
    self.notice = cc.Sprite:createWithSpriteFrameName("lock_notice.png")
    self.notice:setPosition(cc.p(visibleSize.width / 2, 150))
    self.notice:setVisible(false)
    self.notice:addTo(pWidgetWin)
    local function LockselectedEvent(sender, eventType)
        self.m_LockTog:setScale(1)
        local scaleto = cc.ScaleBy:create(0.1, 0.9, 0.9, 0.9)
        local callfunc1 = cc.CallFunc:create(function()
            self.m_LockTog:setTouchEnabled(false)
        end)
        local callfunc2 = cc.CallFunc:create(function()
            self.m_LockTog:setTouchEnabled(true)
        end)
        local seq = cc.Sequence:create(callfunc1, scaleto, scaleto:reverse(), callfunc2)

        self.m_LockTog:runAction(seq)
        if self.m_LockTog:isSelected() then
            self.m_LockTog:loadTextureBackGround("btn_sd.png", 1)
            self.isLock = true
            if self.isFirstTouch == true then
                self.notice:setVisible(true)
                self.isFirstTouch = false
                local delaytime = cc.DelayTime:create(1.0)
                local fadeout = cc.FadeOut:create(3.0)
                self.notice:runAction(cc.Sequence:create(delaytime, fadeout))
            end
        else
            self.m_LockTog:loadTextureBackGround("btn_sd2.png", 1)
            self.isLock = false
            self:SetLockFish(nil, globalUserInfo.wChairID)
        end
    end
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("FishUI.plist"))
    self.m_LockTog = ccui.CheckBox:create("btn_sd2.png", "btn_sd.png", "btn_sd.png", "btn_sd.png", "btn_sd.png", 1)
    self.m_LockTog:setPosition(cc.p(visibleSize.width / 2 - self.m_LockTog:getContentSize().width / 3 * 2, self.m_LockTog:getContentSize().height / 2))
    self.m_LockTog:addEventListenerCheckBox(LockselectedEvent)
    self.m_LockTog:addTo(pWidgetWin)
    -- 菜单
    --[[self.m_menus = self:createButtonWithSpriteFrameName(true,"dii.png","dii.png",function()
        self:OnMenusClick()
    end)
    self.m_menus:setPosition(cc.p(visibleSize.width,self.m_menus:getContentSize().height*1.8))
    self.m_menus:addTo(pWidgetWin)
    self.m_menus:setZOrder(10)
    self.m_menus:setTag(0)
    local pBs = cc.Sprite:createWithSpriteFrameName("open.png")
    pBs:setPosition(cc.p(self.m_menus:getContentSize().width/2,self.m_menus:getContentSize().height/2))
    pBs:setTag(10)
    self.m_menus:addChild(pBs)--]]
    -- 挂机
    local function selectedEvent(sender, eventType)
        self.m_HangTog:setScale(1)
        self:HangGame(self.m_HangTog:isSelected())
        local scaleto = cc.ScaleBy:create(0.1, 0.9, 0.9, 0.9)
        local callfunc1 = cc.CallFunc:create(function()
            self.m_HangTog:setTouchEnabled(false)
        end)
        local callfunc2 = cc.CallFunc:create(function()
            self.m_HangTog:setTouchEnabled(true)
        end)
        local seq = cc.Sequence:create(callfunc1, scaleto, scaleto:reverse(), callfunc2)
        self.m_HangTog:runAction(seq)

    end
    self.m_HangTog = ccui.CheckBox:create("btn_zd2.png", "btn_zd.png", "btn_zd.png", "btn_zd.png", "btn_zd.png", 1)
    self.m_HangTog:setPosition(cc.p(visibleSize.width / 2 + self.m_HangTog:getContentSize().width / 3 * 2, self.m_HangTog:getContentSize().height / 2))
    self.m_HangTog:addEventListenerCheckBox(selectedEvent)
    self.m_HangTog:addTo(pWidgetWin)
    -- 上分
    --[[self.m_addFishScoreBtn = self:createButtonWithSpriteFrameName(true,"button-2.png","button-2.png",function()
        local cmd = {}
        cmd.chair_id = globalUserInfo.wChairID
        cmd.increase = true
        cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
        local get_string = self.FishGame:GetMd5Info_1(cmd.dwCurrentTime)
        cmd.validate_info = get_string
        FishMessage.send_CMD_C_ExchangeFishScore(cmd)
    end)
    self.m_addFishScoreBtn:setPosition(cc.p(self.m_menus:getPositionX()-self.m_addFishScoreBtn:getContentSize().width*1.4,self.m_menus:getPositionY()+self.m_addFishScoreBtn:getContentSize().height*0.6))
    self.m_addFishScoreBtn:addTo(pWidgetWin)
    --下分
    self.m_reduceFishScoreBtn = self:createButtonWithSpriteFrameName(true,"button-1.png","button-1.png",function()
        local cmd={}
        cmd.chair_id = globalUserInfo.wChairID
        cmd.increase = false
        cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
        local get_string = self.FishGame:GetMd5Info_1(cmd.dwCurrentTime)
        cmd.validate_info = get_string
        FishMessage.send_CMD_C_ExchangeFishScore(cmd)
    end)
    self.m_reduceFishScoreBtn:setPosition(self.m_menus:getPositionX() - self.m_reduceFishScoreBtn:getContentSize().width * 1.43, self.m_menus:getPositionY() - self.m_reduceFishScoreBtn:getContentSize().height * 0.5);
    self.m_reduceFishScoreBtn:addTo(pWidgetWin)--]]

    -- self.m_hangOpenPos = cc.p(self.m_HangTog:getPosition())
    -- self.m_addFishScoreOpenPos = cc.p(self.m_addFishScoreBtn:getPosition())
    -- self.m_reduceFishScoreOpenPos = cc.p(self.m_reduceFishScoreBtn:getPosition() )

    -- self.m_HangTog:setPosition(cc.p(self.m_menus:getPosition()))
    -- self.m_reduceFishScoreBtn:setPosition(cc.p(self.m_menus:getPosition()))
    -- self.m_addFishScoreBtn:setPosition(cc.p(self.m_menus:getPosition()))

    -- self.m_HangTog:setVisible(false)
    -- self.m_addFishScoreBtn:setVisible(false)
    -- self.m_reduceFishScoreBtn:setVisible(false)

end

function FishUI:createButtonWithSpriteFrameName(swallow, normal, press, onclick)
    local sprite = cc.Sprite:createWithSpriteFrameName(normal)
    sprite:setAnchorPoint(display.CENTER)

    local function IsLocationInNode(node, loc)
        local pos = node:convertToNodeSpace(loc)
        local s = node:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        return cc.rectContainsPoint(rect, pos)
    end
    local function onTouchBegan(touch, event)
        if not sprite.enabled then
            return false
        end

        local target = event:getCurrentTarget()
        if not target:isVisible() then
            return false
        end

        local location = touch:getLocation()

        if IsLocationInNode(target, location) then
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(press)
            sprite:initWithSpriteFrame(frame)
            sprite:setAnchorPoint(display.CENTER)
            return true
        end
        return false
    end
    local function onTouchEnded(touch, event)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(normal)
        sprite:initWithSpriteFrame(frame)
        sprite:setAnchorPoint(display.CENTER)
        if onclick then
            onclick(sprite)
        end
    end
    function sprite:isEnabled()
        return self.enabled
    end
    function sprite:setEnabled(enabled)
        self.enabled = enabled
    end

    sprite:setEnabled(true)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(swallow)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    sprite:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, sprite)

    return sprite
end

-- 锁定鱼动作
function FishUI:LockFish(wChairID, bGrabLKonoff)
    -- 切换场景中
    if self.FishGame.m_bSwitchScene then
        return
    end
    self.FishGame.m_isFire = true
    local maxFish = {}
    local nMaxFishKind = FISHLK_CMD.FishKind.FISH_KIND_COUNT
    if bGrabLKonoff == 1 then
        nMaxFishKind = FISHLK_CMD.FishKind.FISH_KIND_LK
    end
    for i, fish in ipairs(self.FishGame.m_fishMgr:GetFishList()) do
        -- 能锁定的鱼
        if fish:GetFishTrace().fish_kind >= FISHLK_CMD.FishKind.FISH_KIND_16 and fish:GetFishTrace().fish_kind <= nMaxFishKind then
            -- 大鱼是否有效
            if self.FishGame.m_fishMgr:IsFishMaxScene(fish) and fish:GetState() ~= FISHLK_CMD.FishState.DEATH then
                table.insert(maxFish, fish)
            end
        end
    end
    -- 同屏下超过两条可锁定的鱼 且本次不可锁定上一次同一条鱼
    if #maxFish > 1 then
        for i, fish in ipairs(maxFish) do
            if fish:GetFishID() == self.m_UpLockFishID then
                -- 李逵达人游戏里，AI如果已经锁定李逵，不再切换
                if bGrabLKonoff == 1 then
                    if fish:GetFishTrace().fish_kind == FISHLK_CMD.FishKind.FISH_KIND_LK then
                        self:SetLockFish(fish, wChairID)
                        return
                    end
                    -- 李逵达人游戏里，锁定鱼，切到较小的鱼身上，这样比较容易打死，赢得分数
                    if fish:GetFishTrace().fish_kind < self.m_UpLockFishKind then
                        self:SetLockFish(fish, wChairID)
                        return
                    end
                end
                -- 删除上次已经锁定的鱼
                for key, var in ipairs(maxFish) do
                    if fish == var then
                        table.remove(maxFish, key)
                    end
                end
                break
            end
        end
    end
    -- 随机取一条锁头的鱼
    --[[if #maxFish > 0 then
        math.randomseed(os.time())
        local index = math.random(1,#maxFish)
        self:SetLockFish(maxFish[index],wChairID)
    else
        self:SetLockFish(nil,wChairID)
    end --]]
end

function FishUI:OnMenusClick()
    self.m_HangTog:stopAllActions()
    self.m_addFishScoreBtn:stopAllActions()
    self.m_reduceFishScoreBtn:stopAllActions()
    self.m_HangTog:setRotation(0)
    self.m_addFishScoreBtn:setRotation(0)
    self.m_reduceFishScoreBtn:setRotation(0)
    -- 打开
    if self.m_menus:getTag() == 0 then
        self.m_menus:setTag(1)
        self.m_HangTog:setPosition(cc.p(self.m_menus:getPosition()))
        self.m_addFishScoreBtn:setPosition(cc.p(self.m_menus:getPosition()))
        self.m_reduceFishScoreBtn:setPosition(cc.p(self.m_menus:getPosition()))
        self.m_HangTog:setVisible(false)
        self.m_addFishScoreBtn:setVisible(false)
        self.m_reduceFishScoreBtn:setVisible(false)

        self:animationReduceFishScoreMoveCallBackOpen()
        local rotateto = cc.RotateTo:create(0.45, -1800)
        local pFangxiang = self.m_menus:getChildByTag(10)
        pFangxiang:runAction(rotateto)
    else
        self:HideMenus()
    end
end

function FishUI:HideMenus()
    if self.m_menus:getTag() == 0 then
        return
    end
    self.m_menus:setTag(0)
    self.m_HangTog:setPosition(cc.p(self.m_hangOpenPos))
    self.m_addFishScoreBtn:setPosition(cc.p(self.m_addFishScoreOpenPos))
    self.m_reduceFishScoreBtn:setPosition(cc.p(self.m_reduceFishScoreOpenPos))
    self.m_HangTog:setVisible(true)
    self.m_addFishScoreBtn:setVisible(true)
    self.m_reduceFishScoreBtn:setVisible(true)

    local pSpawn = self:createAnimationExit(cc.p(self.m_menus:getPosition()), function()
        self:animationHangTogMoveCallBackExit()
    end)
    self.m_HangTog:runAction(pSpawn)

    local rotateto = cc.RotateTo:create(0.45, 1800)
    local pFangxiang = self.m_menus:getChildByTag(10)
    pFangxiang:runAction(rotateto)
end

function FishUI:SetLockFish(fish, wChairID)
    if fish == nil then
        self.FishGame.m_fishMgr.m_FishLock[wChairID + 1] = nil
        self.m_UpLockFishID = 0
        self.m_UpLockFishKind = -1
    else
        self.FishGame.m_fishMgr.m_FishLock[wChairID + 1] = fish
        self.m_UpLockFishID = fish:GetFishID()
        self.m_UpLockFishKind = fish:GetFishTrace().fish_kind
    end
end

-- 设置自动开炮
function FishUI:HangGame(bAuto)
    self.FishGame.m_automaticFire = bAuto
    self.m_HangTog:setSelected(bAuto)
    if self.m_HangTog:isSelected() then
        self.m_HangTog:loadTextureBackGround("btn_zd.png", 1)
    else
        self.m_HangTog:loadTextureBackGround("btn_zd2.png", 1)
    end
end

function FishUI:createAnimationOpen(pos, selector)
    local rotateto = cc.RotateTo:create(0.15, -1080)
    local pMoveTo = cc.MoveTo:create(0.15, cc.p(pos))
    local funcall = nil
    local seq = nil
    if selector ~= nil then
        funcall = cc.CallFunc:create(selector)
        seq = cc.Sequence:create(pMoveTo, funcall)
    else
        seq = cc.Sequence:create(pMoveTo)
    end
    local spawn = cc.Spawn:create(rotateto, seq)
    return spawn
end

function FishUI:createAnimationExit(pos, selector)
    local rotateto = cc.RotateTo:create(0.15, 1080)
    local pMoveTo = cc.MoveTo:create(0.15, cc.p(pos))
    local funcall = cc.CallFunc:create(selector)
    local seq = cc.Sequence:create(pMoveTo, funcall)
    local spawn = cc.Spawn:create(rotateto, seq)
    return spawn
end

-- 下分开
function FishUI:animationReduceFishScoreMoveCallBackOpen()
    self.m_reduceFishScoreBtn:setVisible(true)
    local pSpawn = self:createAnimationOpen(self.m_reduceFishScoreOpenPos, function()
        self:animationAddFishScoreMoveCallBackOpen()
    end)
    self.m_reduceFishScoreBtn:runAction(pSpawn)
end

-- 上分开
function FishUI:animationAddFishScoreMoveCallBackOpen()
    self.m_addFishScoreBtn:setVisible(true)
    local pSpawn = self:createAnimationOpen(self.m_addFishScoreOpenPos, function()
        self:animationHangToMoveCallBackOpen()
    end)
    self.m_addFishScoreBtn:runAction(pSpawn)
end

-- 挂机开
function FishUI:animationHangToMoveCallBackOpen()
    self.m_HangTog:setVisible(true)
    local pSpawn = self:createAnimationOpen(self.m_hangOpenPos, nil)
    self.m_HangTog:runAction(pSpawn)
end

-- 挂机关
function FishUI:animationHangTogMoveCallBackExit()
    self.m_HangTog:setVisible(false)
    local pSpawn = self:createAnimationExit(cc.p(self.m_menus:getPosition()), function()
        self:animationAddFishScoreMoveCallBackExit()
    end)
    self.m_addFishScoreBtn:runAction(pSpawn)
end

-- 上分关
function FishUI:animationAddFishScoreMoveCallBackExit()
    self.m_addFishScoreBtn:setVisible(false)
    local pSpawn = self:createAnimationExit(cc.p(self.m_menus:getPosition()), function()
        self:animationReduceFishScoreMoveCallBackExit()
    end)
    self.m_reduceFishScoreBtn:runAction(pSpawn)
end

-- 下分关
function FishUI:animationReduceFishScoreMoveCallBackExit()
    self.m_reduceFishScoreBtn:setVisible(false)
end

function FishUI:addGun()
    -- 检测能量炮
    --[[if self.FishGame.m_bullet_ion then
        return
    end --]]
    local pMultiple = self.FishGame:FindMultiple(globalUserInfo.wChairID)
    -- 当前倍数
    local userBulletMultiple = tonumber(pMultiple:getString())
    if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
        userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
    elseif userBulletMultiple < 10 then
        userBulletMultiple = userBulletMultiple + 1
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    elseif userBulletMultiple >= 10 and userBulletMultiple < 100 then
        userBulletMultiple = userBulletMultiple + 10
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    elseif userBulletMultiple >= 100 and userBulletMultiple < 1000 then
        userBulletMultiple = userBulletMultiple + 100
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    elseif userBulletMultiple >= 1000 and userBulletMultiple < 10000 then
        userBulletMultiple = userBulletMultiple + 1000
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    elseif userBulletMultiple >= 10000 and userBulletMultiple < 100000 then
        userBulletMultiple = userBulletMultiple + 10000
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    else
        userBulletMultiple = userBulletMultiple + 100000
        if userBulletMultiple > self.FishGame.m_gameConfig.max_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
        end
    end
    if tonumber(pMultiple:getString()) ~= userBulletMultiple then
        local szMultiple = string.format("%d", userBulletMultiple)
        pMultiple:setString(szMultiple)
        -- self.FishGame:UpDateArms()
    end
end

function FishUI:downGun()
    -- 检测能量炮
    --[[if self.FishGame.m_bullet_ion then
        return
    end--]]
    local pMultiple = self.FishGame:FindMultiple(globalUserInfo.wChairID)
    -- 当前倍数
    local userBulletMultiple = tonumber(pMultiple:getString())
    if userBulletMultiple == self.FishGame.m_gameConfig.min_bullet_multiple then
        userBulletMultiple = self.FishGame.m_gameConfig.max_bullet_multiple
    elseif userBulletMultiple <= 10 then
        userBulletMultiple = userBulletMultiple - 1
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    elseif userBulletMultiple > 10 and userBulletMultiple <= 100 then
        if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
            if self.FishGame.m_gameConfig.max_bullet_multiple > 10 then
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 10)
            end
        else
            userBulletMultiple = userBulletMultiple - 10
        end
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    elseif userBulletMultiple > 100 and userBulletMultiple <= 1000 then
        if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
            if self.FishGame.m_gameConfig.max_bullet_multiple > 100 then
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 100)
            end
        else
            userBulletMultiple = userBulletMultiple - 100
        end
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    elseif userBulletMultiple > 1000 and userBulletMultiple <= 10000 then
        if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
            if self.FishGame.m_gameConfig.max_bullet_multiple > 1000 then
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 1000)
            end
        else
            userBulletMultiple = userBulletMultiple - 1000
        end
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    elseif userBulletMultiple > 10000 and userBulletMultiple <= 100000 then
        if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
            if self.FishGame.m_gameConfig.max_bullet_multiple > 10000 then
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 10000)
            end
        else
            userBulletMultiple = userBulletMultiple - 10000
        end
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    else
        if userBulletMultiple == self.FishGame.m_gameConfig.max_bullet_multiple then
            if self.FishGame.m_gameConfig.max_bullet_multiple > 10000 then
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 10000)
            else
                userBulletMultiple = userBulletMultiple - math.mod(self.FishGame.m_gameConfig.max_bullet_multiple, 1000)
            end
        else
            userBulletMultiple = userBulletMultiple - 1000
        end
        if userBulletMultiple < self.FishGame.m_gameConfig.min_bullet_multiple then
            userBulletMultiple = self.FishGame.m_gameConfig.min_bullet_multiple
        end
    end
    if tonumber(pMultiple:getString()) ~= userBulletMultiple then
        local szMultiple = string.format("%d", userBulletMultiple)
        pMultiple:setString(szMultiple)
        -- self.FishGame:UpDateArms()
    end
end
return FishUI
-- endregion
