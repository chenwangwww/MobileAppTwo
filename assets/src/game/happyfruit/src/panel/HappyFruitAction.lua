local HappyFruitAction = class("HappyFruitAction")

function HappyFruitAction:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.frame_cache = cc.SpriteFrameCache:getInstance()

    self.scheduler = cc.Director:getInstance():getScheduler()
    self.Panel_machine = scene.Panel_center:getChildByName("Panel_machine")
    self.tPosY = {311, 186, 61, -64}
    self.bIsStop = true
    self.bIsCanPlay = true
    self.bInAction = false
    self:initFruit()
end

function HappyFruitAction:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "check frame not found frame:" .. tostring(name)
        print(str)

        local png = "game/happyfruit/res/fruit_machine.png"
        local plist = "game/happyfruit/res/fruit_machine.plist"
        self.frame_cache:addSpriteFrames(plist, png)
    end

    frame = self.frame_cache:getSpriteFrameByName(name)
    return frame ~= nil
end

-- local frame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(icon)
-- local batch = cc.SpriteBatchNode:createWithTexture(frame:getTexture(), #lst)
-- layer:addChild(batch)

function HappyFruitAction:initFruit()
    self.tFruits = {{}, {}, {}, {}, {}}
    self.tPosMap = {}
    local icon, img, x, y, idx
    for a = 1, 5 do
        for b = 1, 4 do
            icon = self.logic:getFruitIcon(math.random(0, 10))
            img = ccui.ImageView:create(icon, 1)
            y = b * 125 - 64
            x = a * 177 - 88.5
            idx = (3 - b) * 5 + a
            if idx < 16 then
                self.tPosMap[idx] = {
                    idx = idx,
                    x = x,
                    y = y,
                    obj = nil
                }
            end
            img:setPosition(x, y)
            img:setScale(self:caleScale(y))
            self.Panel_machine:addChild(img)
            self.tFruits[a][b] = img
        end
    end
end

local function easeOutBack(ratio)
    local invRatio = ratio - 1.0
    local s = 1.70158
    return math.pow(invRatio, 2) * ((s + 1.0) * invRatio + s) + 1.0
end

local function easeOutElastic(ratio)
    if ratio == 0 or ratio == 1 then
        return ratio
    else
        local p = 0.3
        local s = p / 4.0
        return math.pow(2.0, -10.0 * ratio) * math.sin((ratio - s) * (2.0 * math.pi) / p) + 1
    end
end

function HappyFruitAction:caleScale(posY)
    return 1 - 0.2 * math.min(math.abs(posY - 186), 125) / 125
end

function HappyFruitAction:updateTime(dt)
    self.elaspe = self.elaspe + dt
    local img, y, res, count, card

    if self.bIsStop then
        for a = 1, 5 do
            for b = 1, 4 do
                img = self.tFruits[a][b]
                y = self.tPosY[b]
                img:setPositionY(y)
                img:setScale(self:caleScale(y))
                local frame_name = self:getIconByPosY(a, y)
                img:setVisible(self:checkFrame(frame_name))
                img:loadTexture(frame_name, 1)
                self:setPosMap(a, y, img)
            end
        end
    else
        for a = 1, 5 do
            if self.stop_sign[a] == 1 then

                count = #self.analyze.tCardList[a]
                for b = 1, 4 do
                    img = self.tFruits[a][b]
                    y = img:getPositionY()
                    y = y - (25 * self.logic:getActionSpeed())

                    if y < -64 then
                        y = 490 + y
                        if count > 0 then
                            card = table.remove(self.analyze.tCardList[a])
                            if card then
                                res = self.logic:getFruitIcon(card)
                                img:setVisible(self:checkFrame(res))
                                img:loadTexture(res, 1)
                            else
                                print("error getFruitIcon a, b, count", a, b, count)
                                dump(self.analyze.tCardList)
                            end

                            if #self.analyze.tCardList[a] == 0 then
                                self.stop_sign[a] = 2
                            end
                        end
                    end
                    img:setPositionY(y)
                    img:setScale(self:caleScale(y))
                end
                if self.stop_sign[a] == 2 then
                    self:stopVoiceId()
                    local str = string.format("game/happyfruit/res/audio/slotFruitStop%d.mp3", a)
                    MusicManager.playEffect(str)
                    for b = 1, 4 do
                        img = self.tFruits[a][b]
                        y = img:getPositionY()
                        self.slow_action[a][b] = {
                            start = y,
                            over = self:getEndY(y),
                            sec = 1 / self.logic:getActionSpeed(),
                            now = self.elaspe
                        }
                    end
                end
            elseif self.stop_sign[a] == 2 then
                local slow, ratio, progress
                for b = 1, 4 do
                    img = self.tFruits[a][b]
                    slow = self.slow_action[a][b]
                    ratio = (self.elaspe - slow.now) / slow.sec
                    -- progress = easeOutBack(ratio)
                    progress = easeOutElastic(ratio)
                    y = slow.start + (slow.over - slow.start) * progress
                    img:setPositionY(y)
                    img:setScale(self:caleScale(y))
                    if y < -70 then
                        img:setVisible(false)
                    end

                    if ratio > 1 then
                        self.stop_sign[a] = 0
                    end
                end

                if self.stop_sign[a] == 0 then
                    for b = 1, 4 do
                        img = self.tFruits[a][b]
                        slow = self.slow_action[a][b]
                        img:setPositionY(slow.over)
                        img:setScale(self:caleScale(slow.over))
                        self:setPosMap(a, slow.over, img)
                    end
                end
            end
        end
    end

    self:setCanPlay(false)
    if self.stop_sign[5] == 0 or self.bIsStop then
        self:stopTimer()
        self:showAnalyze()
        self.scene.buttonView:updateSpin()
    end
end

function HappyFruitAction:setStop(stop)
    self.bIsStop = stop
end

function HappyFruitAction:isStop()
    return self.bIsStop
end

function HappyFruitAction:setPosMap(a, over, img)
    local idx = 0
    for mm = 0, 2 do
        idx = mm * 5 + a
        if self.tPosMap[idx].y == over then
            self.tPosMap[idx].obj = img
            return
        end
    end

    if over ~= -64 then
        print("error skip pos map===>", a, over)
        dump(self.tPosMap)
    end
end

function HappyFruitAction:showAnalyze()
    self:stopSchedule()

    local function do_next()
        self:setCanPlay(true)

        if not self.scene:hasBetCache() then
            self.bInAction = false
        end

        if self.logic:getBonusCount() > 0 then
            self.logic:setIsAutoBet(true)
        end

        if #self.analyze.winList > 0 then
            self.nCurWinListIdx = 0
            self:showWinLine()
            self.scheduleLine = self.scheduler:scheduleScriptFunc(handler(self, self.showWinLine), 1 / self.logic:getActionSpeed(), false)
        else

            if self.scene:doNextBetMsg() then
                return
            end

            if self.logic:isAutoBet() then
                self.scene.buttonView:autoMove()
            end
        end
    end

    self.scene:setShowFreeAndWin(self.analyze, do_next)
end

function HappyFruitAction:stopSchedule()
    if self.scheduleLine then
        self.scheduler:unscheduleScriptEntry(self.scheduleLine)
        self.scheduleLine = nil
    end
end

function HappyFruitAction:stopShowAnalyze()
    self:stopSchedule()
    self:stopAllImgAction()
    self.scene.textView:updateLineCount()
end

function HappyFruitAction:stopAllImgAction()
    for k, v in pairs(self.tPosMap) do
        if v.obj then
            local light = v.obj:getChildByName("Win_Eff")
            if light then
                light:removeFromParent()
            end
            v.obj:stopAllActions()
            v.obj:setPosition(v.x, v.y)
            v.obj:setScale(self:caleScale(v.y))
        end
    end
end

function HappyFruitAction:showWinLine()
    self.nCurWinListIdx = self.nCurWinListIdx + 1
    if self.nCurWinListIdx > #self.analyze.winList then
        self.nCurWinListIdx = 1

        if self.scene:doNextBetMsg() then
            return
        end

        if self.logic:isAutoBet() then
            self.scene.buttonView:autoMove()
            return
        end

        if #self.analyze.winList == 1 then
            return
        end
    end
    local win = self.analyze.winList[self.nCurWinListIdx]

    self:stopAllImgAction()
    self.scene.textView:setShowLine(win.lineIdx)
    for _, idx in pairs(win.winPos) do
        --[[
		local s = self:caleScale(self.tPosMap[idx].y)
		local scale1 = cc.ScaleTo:create(0.5, s * 1.1)
		local scale2 = cc.ScaleTo:create(0.5, s)
		local seq = cc.Sequence:create(scale1, scale2)
		local jump = cc.JumpTo:create(1, cc.p(self.tPosMap[idx].x, self.tPosMap[idx].y), 10, 1)
		local spawn = cc.Spawn:create(seq, jump)
		self.tPosMap[idx].obj:runAction(cc.RepeatForever:create(spawn))
		--]]

        -- self:showLight(self.tPosMap[idx].obj)
        self:showArmature(self.tPosMap[idx].obj)
    end
end

function HappyFruitAction:showArmature(obj)
    if obj == nil then
        return
    end

    local json = "game/happyfruit/res/armature/xk.ExportJson"
    local png = "game/happyfruit/res/armature/xk0.png"
    local plist = "game/happyfruit/res/armature/xk0.plist"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(png, plist, json)

    local armature = ccs.Armature:create("xk")
    armature:getAnimation():play("SGKH_xk", -1, 1)
    armature:getAnimation():setSpeedScale(3 * self.logic:getActionSpeed())
    armature:setName("Win_Eff")

    --[[
    local function afterFunction()
      ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(json)
    end
    armature:getAnimation():setMovementEventCallFunc(afterFunction)
	--]]

    local ss = obj:getContentSize()
    armature:setPosition(ss.width / 2, ss.height / 2)
    obj:addChild(armature, -1)
end

function HappyFruitAction:showLight(obj)
    if obj == nil then
        return
    end

    local light = ccui.ImageView:create("SGKH_zjk.png", 1)
    local ss = obj:getContentSize()
    light:setPosition(ss.width / 2, ss.height / 2)
    light:setName("Win_Eff")
    light:setCapInsets(cc.rect(30, 30, 22, 22))

    local scale = obj:getScale()
    light:ignoreContentAdaptWithSize(false)
    light:setContentSize(cc.size(188, 188))

    local sec = 0.5 / self.logic:getActionSpeed()
    local fade1 = cc.FadeTo:create(sec, 68)
    local fade2 = cc.FadeTo:create(sec, 255)
    local rep = cc.RepeatForever:create(cc.Sequence:create(fade1, fade2))
    light:runAction(rep)
    obj:addChild(light)
end

function HappyFruitAction:getEndY(y)
    -- 436, 311, 186, 61, -64
    -- 885, 392
    if y >= 311 then
        return 311
    elseif y >= 186 and y < 311 then
        return 186
    elseif y >= 61 and y < 186 then
        return 61
    else
        return -64
    end
end

function HappyFruitAction:getIconByPosY(a, y)
    local list = self.analyze.tCard15
    local idx = 1

    if y == 311 then
        idx = 1
    elseif y == 186 then
        idx = 2
    elseif y == 61 then
        idx = 3
    end

    local card = list[a][idx]
    if card == nil then
        print("error getIconByPosY a, idx", a, idx)
        dump(list)
    end
    return self.logic:getFruitIcon(card)
end

function HappyFruitAction:isInAction()
    return self.bInAction
end

function HappyFruitAction:startBet()
    self.bInAction = true

    self:stopTimer()
    self:stopSchedule()
    self:stopAllImgAction()

    self.analyze = clone(self.logic:getAnalyze())
    self.elaspe = 0

    self.stop_sign = {1, 1, 1, 1, 1}
    self.slow_action = {{}, {}, {}, {}, {}}
    self.bIsStop = false
    for i = 1, 15 do
        self.tPosMap[i].obj = nil
    end

    self.scene.textView:setShowLine(-1)
    self.scene.buttonView:updateSpin()
    self:stopVoiceId()
    self.voiceId = ccexp.AudioEngine:play2d("game/happyfruit/res/audio/slotFruitStart.mp3", false, MusicManager.effectVal)
    self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)
end

function HappyFruitAction:stopVoiceId()
    if self.voiceId then
        ccexp.AudioEngine:stop(self.voiceId)
        self.voiceId = nil
    end
end

function HappyFruitAction:isCanPlayNext()
    return self.bIsCanPlay
end

function HappyFruitAction:setCanPlay(bb)
    self.bIsCanPlay = bb
end

function HappyFruitAction:stopTimer()
    self.bIsStop = true
    if self.schedulerID then
        self.scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function HappyFruitAction:onExit()
    self:stopTimer()
    self:stopSchedule()
end

return HappyFruitAction
