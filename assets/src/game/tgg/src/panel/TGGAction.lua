local TGGAction = class("TGGAction")

function TGGAction:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.frame_cache = cc.SpriteFrameCache:getInstance()

    self.scheduler = cc.Director:getInstance():getScheduler()
    self.Panel_icons = scene.layer:getChildByName("Panel_icons")

    self.gainFreeGame = scene.layer:getChildByName("gainFreeGame")
    self.gainFreeCountFnt = self.gainFreeGame:getChildByName("gainFreeCountFnt")
    self.gainFreeCountFnt:setFntFile("game/tgg/res/fnt/qtds_label_jb.fnt")
    self.gainFreeGame:setVisible(false)

    self.Text_round = scene.layer:getChildByName("Text_round")
    self.Text_round:setString("")

    self.schedulerID = nil
    self.bIsCanPlayNext = true
    self.nSpeed = 1
    self:initIcons()
    self.tEffectNode = {}
end

--[[
        a   1  2  3  4  5
    b
    1       1, 2, 3, 4, 5
    2       6, 7, 8, 9, 10
    3       11,12,13,14,15
    4       16,17,18,19,20
--]]
function TGGAction:initIcons()
    self.tImgMap = {}
    self.tPosMap = {}
    local icon, img, x, y, idx
    for a = 1, 5 do
        for b = 1, 4 do
            idx = (b - 1) * 5 + a
            icon = self.logic:getItemIcon(math.random(0, 9))
            img = ccui.ImageView:create(icon, 1)
            y = 583 - b * 166
            x = a * 200 - 100
            img:setPosition(x, y)
            self.Panel_icons:addChild(img)

            self.tPosMap[idx] = {
                idx = idx,
                posX = x,
                posY = y,
                aIdx = a,
                bIdx = b,
                imgIdx = idx
            }

            self.tImgMap[idx] = {
                idx = idx,
                img = img,
                posIdx = idx,
                curX = x,
                curY = y,
                state = 0,
                elaspe = 0,
                cardId = -1,
                slow_action = nil
            }
        end
    end
end

function TGGAction:checkDataOK()
    local isok = true
    for idx = 1, 15 do
        local imgInfo = self.tImgMap[self.tPosMap[idx].imgIdx]
        local cardId = self.logic.result.cbCardType[idx]
        if cardId ~= imgInfo.cardId then
            imgInfo.img:setVisible(false)
            isok = false
            print("##############check error pos idx##############", imgInfo.posIdx, imgInfo.cardId, "==>", cardId)
        end
    end
    return isok
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
        local s = 0.075 -- p / 4.0
        return math.pow(2.0, -10.0 * ratio) * math.sin((ratio - s) * (2.0 * math.pi) / p) + 1
    end
end

function TGGAction:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "check frame not found frame:" .. tostring(name)
        print(str)
        local png = "game/tgg/res/tgghetu.png"
        local plist = "game/tgg/res/tgghetu.plist"
        self.frame_cache:addSpriteFrames(plist, png)

        frame = self.frame_cache:getSpriteFrameByName(name)
    end
    return frame ~= nil
end

function TGGAction:updateTime(dt)
    self.elaspe = self.elaspe + dt
    local imgInfo, idx, count, y, cardId, res

    for a = 1, 5 do
        if self.stop_sign[a] == 1 then
            for b = 1, 4 do
                idx = (b - 1) * 5 + a
                imgInfo = self.tImgMap[idx]
                y = imgInfo.curY - self.logic:getActionSpeed()
                if y < -81 then
                    y = 664 + y
                    count = #self.logic.tCardList[a]
                    if count > 0 then
                        cardId = table.remove(self.logic.tCardList[a])
                        if cardId ~= nil then
                            res = self.logic:getItemIcon(cardId)
                            imgInfo.img:setVisible(self:checkFrame(res))
                            imgInfo.cardId = cardId
                            imgInfo.img:loadTexture(res, 1)
                        else
                            print("error getItemIcon a, b, count", a, b, count, cardId)
                            dump(self.logic.tCardList)
                        end

                        if #self.logic.tCardList[a] == 0 then
                            self.stop_sign[a] = 2
                        end
                    end
                end
                imgInfo.curY = y
                imgInfo.img:setPositionY(imgInfo.curY)
            end

            if self.stop_sign[a] == 2 then
                if a == 5 then
                    MusicManager.playEffect("game/tgg/res/audio/stop.mp3")
                end
                for b = 1, 4 do
                    idx = (b - 1) * 5 + a
                    imgInfo = self.tImgMap[idx]
                    imgInfo.slow_action = {
                        start = imgInfo.curY,
                        over = self:getEndY(imgInfo.curY),
                        sec = 0.6 - (self.nSpeed * 0.06),
                        now = self.elaspe
                    }
                end
            end
        elseif self.stop_sign[a] == 2 then
            local ratio, progress
            for b = 1, 4 do
                idx = (b - 1) * 5 + a
                imgInfo = self.tImgMap[idx]
                ratio = (self.elaspe - imgInfo.slow_action.now) / imgInfo.slow_action.sec
                -- progress = easeOutBack(ratio)
                progress = easeOutElastic(ratio)
                imgInfo.curY = imgInfo.slow_action.start + (imgInfo.slow_action.over - imgInfo.slow_action.start) * progress
                imgInfo.img:setPositionY(imgInfo.curY)
                if imgInfo.curY < -85 then
                    imgInfo.img:setVisible(false)
                end

                if ratio >= 1 then
                    self.stop_sign[a] = 0
                end
            end

            if self.stop_sign[a] == 0 then
                for b = 1, 4 do
                    idx = (b - 1) * 5 + a
                    imgInfo = self.tImgMap[idx]
                    imgInfo.curY = imgInfo.slow_action.over
                    imgInfo.img:setPositionY(imgInfo.curY)
                    self:setPosMap(a, imgInfo)
                end
            end
        end
    end

    if self.stop_sign[5] == 0 then
        self:doGameEnd()
    end
end

function TGGAction:getEndY(y)
    -- 583 417 251 85 -81
    if y >= 417 then
        return 417
    elseif y >= 251 and y < 417 then
        return 251
    elseif y >= 85 and y < 251 then
        return 85
    else
        return -81
    end
end

function TGGAction:setPosMap(a, imgInfo)
    local idx = 0
    for mm = 0, 3 do
        idx = mm * 5 + a
        if self.tPosMap[idx].posY == imgInfo.curY then
            self.tPosMap[idx].imgIdx = imgInfo.idx
            imgInfo.posIdx = idx
            return
        end
    end

    print("error skip pos map===>", a)
    dump(imgInfo)
end

function TGGAction:doGameEnd()
    self:stopAllImgAction()
    self:stopTimer()
    self:checkDataOK()
    self:showWinItem()
end

function TGGAction:showWinItem()
    local hasWin = false
    for k, v in pairs(self.logic.result.cbMaskCard) do
        if v == 1 then
            hasWin = true
            local imgInfo = self.tImgMap[self.tPosMap[k].imgIdx]
            self:showKuangSpine(imgInfo)
            if imgInfo.cardId == 8 then
                self:showJumpWildAni(imgInfo.img)
            elseif imgInfo.cardId == 9 then
                self:showItemFreeAni(imgInfo.img)
            else
                local sc1 = cc.EaseBackIn:create(cc.ScaleTo:create(0.6 - (self.nSpeed * 0.08), 1.1))
                local sc2 = cc.ScaleTo:create(0.4 - self.nSpeed * 0.06, 1)
                local action = cc.RepeatForever:create(cc.Sequence:create(sc1, sc2))
                imgInfo.img:runAction(action)
            end
        end
    end

    local function doNextShow()
        self:showWinResult(hasWin)
    end

    self.logic:setSumFreeCount(self.logic.result.wSumFreeCount)
    if self.logic.result.wFreeCount > 0 then
        MusicManager.playEffect("game/tgg/res/audio/freeWin.mp3")
        self.gainFreeGame:setVisible(true)
        self.gainFreeCountFnt:setString(self.logic.result.wFreeCount)
        self.gainFreeGame:setScale(0.1)
        local sc = cc.EaseElasticOut:create(cc.ScaleTo:create(0.3, 1))
        local delay = cc.DelayTime:create(2 - (self.nSpeed - 1) * 0.3)
        self.gainFreeGame:runAction(cc.Sequence:create(sc, delay, cc.CallFunc:create(doNextShow), cc.Hide:create()))
    else
        self:showWinResult(hasWin)
    end
end

function TGGAction:showWinResult(hasWin)
    self.scene.buttonView:updateWinGold(self.logic.result.lWinScore)
    local golds = self.logic.result.lUserScore + self.logic.result.lWinScore
    self.logic:setPlayerGold(golds)

    if self.logic.result.bFreeGame == 1 then
        self.scene.buttonView:showFreeBetResult(2)
    end

    if hasWin then
        MusicManager.playEffect("game/tgg/res/audio/bingo.mp3")

        local delaysec = 0
        if self.logic.result.lWinScore > 0 then
            local beishu = self.logic.result.lWinScore / self.logic.cbBonusLineCount
            if beishu <= 50 then
                self:showBigMegaSuperWin("BIG_WIN", self.logic.result.lWinScore)
            elseif beishu > 50 and beishu <= 500 then
                self:showBigMegaSuperWin("BIG_SUPER", self.logic.result.lWinScore)
            else
                self:showBigMegaSuperWin("BIG_MEGA", self.logic.result.lWinScore)
            end
            delaysec = 3 - (self.nSpeed - 1) * 0.3
        else
            delaysec = 1 - (self.nSpeed - 1) * 0.2
        end

        local function doCallFun()
            self:prepareNext()
        end
        self.Panel_icons:runAction(cc.Sequence:create(cc.DelayTime:create(delaysec), cc.CallFunc:create(doCallFun)))
    else
        self:prepareNext()
    end
end

function TGGAction:prepareNext()
    self.bIsCanPlayNext = true
    self:stopCoinDownVoiceId()
    if self.scene:doNextBetMsg() then
        return
    end

    self.scene.buttonView:updateAutoBetBtn()

    if self.logic:isAutoBet() or self.logic:getSumFreeCount() > 0 then
        self.scene.buttonView:doBet()
    else
        self.scene.buttonView:setButtonState(true)
        if self.logic.result.bFreeGame == 1 then
            self.scene.buttonView:delayShowNormal(1)
        end
    end
end

function TGGAction:showItemFreeAni(parent)
    local animation = cc.Animation:create()
    for i = 1, 14 do
        local frameName = string.format("tggpic/clip_symbol_F_%d.png", i)
        local spriteFrame = self.frame_cache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.1 - self.nSpeed * 0.01)
    local animate = cc.Animate:create(animation)

    local sprite = cc.Sprite:createWithSpriteFrameName("tggpic/clip_symbol_F_1.png")
    sprite:setPosition(116, 110)
    parent:addChild(sprite)
    sprite:runAction(cc.RepeatForever:create(animate))
end

function TGGAction:showJumpWildAni(parent)
    local animation = cc.Animation:create()
    for i = 1, 12 do
        local frameName = string.format("tggpic/clip_symbol_W_%d.png", i)
        local spriteFrame = self.frame_cache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.1 - self.nSpeed * 0.01)
    local animate = cc.Animate:create(animation)

    local sprite = cc.Sprite:createWithSpriteFrameName("tggpic/clip_symbol_W_1.png")
    sprite:setPosition(116, 110)
    sprite:setScale(0.7)
    parent:addChild(sprite)
    sprite:runAction(cc.RepeatForever:create(animate))
end

function TGGAction:showKuangSpine(imgInfo)
    local node = self.tEffectNode[imgInfo.posIdx]
    if node then
        node:setVisible(true)
    else
        local json = "game/tgg/res/spine/tgg_kuang.json"
        local atlas = "game/tgg/res/spine/tgg_kuang.atlas"
        local skeletonNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        skeletonNode:setPosition(cc.p(imgInfo.curX, imgInfo.curY))
        -- skeletonNode:setScale(0.7)
        skeletonNode:setTimeScale(self.nSpeed)
        self.Panel_icons:addChild(skeletonNode)
        skeletonNode:setAnimation(0, "animation", true)
        self.tEffectNode[imgInfo.posIdx] = skeletonNode
    end
end

function TGGAction:showBigMegaSuperWin(aniname, num)
    if self.BIG_MEGA_SUPER_WIN == nil then
        local json = "game/tgg/res/spine/BIG_MEGA_SUPER_WIN.json"
        local atlas = "game/tgg/res/spine/BIG_MEGA_SUPER_WIN.atlas"
        local skeletonNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        skeletonNode:setPosition(cc.p(display.cx, display.cy + 100))
        skeletonNode:setScale(0.9)
        self.scene.layer:addChild(skeletonNode)
        self.BIG_MEGA_SUPER_WIN = skeletonNode

        self.bmswText = ccui.TextBMFont:create("", "game/tgg/res/fnt/qtds_label_nyl.fnt"):align(display.CENTER, 0, -300):addTo(skeletonNode)
    end

    MusicManager.playEffect(string.format("game/tgg/res/audio/%s.mp3", aniname))

    self.BIG_MEGA_SUPER_WIN:setTimeScale(self.nSpeed)
    self.BIG_MEGA_SUPER_WIN:setVisible(true)
    self.BIG_MEGA_SUPER_WIN:stopAllActions()
    self.BIG_MEGA_SUPER_WIN:setAnimation(0, aniname, false) -- BIG_MEGA, BIG_SUPER  BIG_WIN
    self.BIG_MEGA_SUPER_WIN:runAction(cc.Sequence:create(cc.DelayTime:create(3 - (self.nSpeed - 1) * 0.4), cc.Hide:create()))

    self.bmswText:stopAllActions()
    self.bmswText:setOpacity(0)
    self.bmswText:setScale(0.1)
    local gap = math.max(math.floor(num / (20 - (self.nSpeed - 1) * 4)), 1)
    self.bmswText:setString(gap)
    self.nNowBMSW = gap
    local function doUpdate()
        self.nNowBMSW = self.nNowBMSW + gap
        if self.nNowBMSW >= num then
            self.nNowBMSW = num
            self.bmswText:stopAllActions()
        end
        self.bmswText:setString(self.nNowBMSW)
    end

    local function doNext()
        local seq1 = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(doUpdate))
        self.bmswText:runAction(cc.RepeatForever:create(seq1))
    end
    self.coinDownVoiceId = ccexp.AudioEngine:play2d("game/tgg/res/audio/coinDown.mp3", false, MusicManager.effectVal)
    local spaw = cc.Spawn:create(cc.FadeIn:create(0.1), cc.ScaleTo:create(0.1, 1))
    local seq2 = cc.Sequence:create(cc.DelayTime:create(1 - (self.nSpeed - 1) * 0.2), spaw, cc.CallFunc:create(doNext))
    self.bmswText:runAction(seq2)
end

function TGGAction:stopCoinDownVoiceId()
    if self.coinDownVoiceId then
        ccexp.AudioEngine:stop(self.coinDownVoiceId)
        self.coinDownVoiceId = nil
    end
end

function TGGAction:cleanKuang()
    for _, v in pairs(self.tEffectNode) do
        v:setVisible(false)
    end
end

function TGGAction:isInAction()
    return self.schedulerID ~= nil or (not self.bIsCanPlayNext)
end

function TGGAction:startBet()
    self.bIsCanPlayNext = false
    self.scene.buttonView:updateWinGold(0)
    self:stopAllImgAction()
    self:cleanKuang()
    self:stopTimer()
    self:stopCoinDownVoiceId()
    local info
    for i = 1, 15 do
        info = self.tImgMap[i]
        info.elaspe = 0
        info.state = 1
        info.cardId = -1
        info.slow_action = nil
    end
    self.logic:updateActionSpeed()
    self.nSpeed = self.logic:getSpeed()
    self.elaspe = 0
    self.delay_fire = 999999
    self.free_delay = 999999

    if self.logic.result.bFreeGame == 1 then
        self.scene.buttonView:showFreeBetResult(1)
    else
        self.scene.buttonView:showNormalBottom()
    end
    self.Text_round:setString(self.logic.result.roundstr)
    self.stop_sign = {1, 1, 1, 1, 1}
    self.scene.buttonView:setButtonState(false)
    self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)
    self.scene.buttonView:updateAutoBetBtn()
    MusicManager.playEffect("game/tgg/res/audio/roll.mp3")
end

function TGGAction:stopAllImgAction()
    for k, v in pairs(self.tImgMap) do
        v.img:removeAllChildren()
        v.img:stopAllActions()
        v.img:setPosition(v.curX, v.curY)
        v.img:setRotation(0)
        v.img:setScale(1)
        v.img:setOpacity(255)
    end
end

function TGGAction:stopTimer()
    if self.schedulerID then
        self.scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function TGGAction:onExit()
    self:stopTimer()
end

return TGGAction
