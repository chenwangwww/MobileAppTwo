local MLCSAction = class("MLCSAction")

function MLCSAction:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.frame_cache = cc.SpriteFrameCache:getInstance()

    self.scheduler = cc.Director:getInstance():getScheduler()
    self.Panel_icons = scene.layer:getChildByName("Panel_icons")
    self.Sprite_npc = scene.layer:getChildByName("Sprite_npc")
    self.Sprite_npc:runAction(self:showNPCAni())

    self.Sprite_water = scene.layer:getChildByName("Sprite_water")
    self.Sprite_water:runAction(self:showWaterAni())

    local pos = self.Panel_icons:convertToNodeSpace(cc.p(0, display.height))
    self.outHeight = pos.y + 91.5

    self.schedulerID = nil
    self:initIcons()
end

--[[
    b   a   1  2  3  4  5
    3       1, 2, 3, 4, 5
    2       6, 7, 8, 9, 10
    1       11,12,13,14,15
--]]
function MLCSAction:initIcons()
    self.tImgMap = {}
    self.tPosMap = {}
    local icon, img, x, y, idx
    local bottomY
    for a = 1, 5 do
        for b = 1, 3 do
            icon = self.logic:getItemIcon(math.random(0, 8))
            img = ccui.ImageView:create(icon, 1)
            y = b * 183 - 91.5
            x = a * 183 - 91.5
            idx = (3 - b) * 5 + a
            img:setPosition(x, y)
            self.Panel_icons:addChild(img)

            if b == 1 then
                bottomY = -457.5
            elseif b == 2 then
                bottomY = -274.5
            else
                bottomY = -91.5
            end

            self.tPosMap[idx] = {
                idx = idx,
                posX = x,
                posY = y,
                aIdx = a,
                bIdx = b,
                bottomY = bottomY,
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
                cardId = -1
            }
        end
    end
end

function MLCSAction:checkDataOK()
    local isok = true
    for idx = 1, 15 do
        local imgInfo = self.tImgMap[idx]
        local cardId = self.tCards[imgInfo.posIdx]
        if cardId ~= imgInfo.cardId then
            isok = false
            imgInfo.img:setVisible(false)
            print("##############check error pos idx##############", imgInfo.posIdx, imgInfo.cardId, "==>", cardId)
        end
    end
    return isok
end

function MLCSAction:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "check frame not found frame:" .. tostring(name)
        print(str)
        local png = "game/mlcs/res/mlcs.png"
        local plist = "game/mlcs/res/mlcs.plist"
        self.frame_cache:addSpriteFrames(plist, png)

        frame = self.frame_cache:getSpriteFrameByName(name)
    end
    return frame ~= nil
end

function MLCSAction:moveUnderground(imgInfo)
    self.nRunnings = self.nRunnings + 1
    local posInfo = self.tPosMap[imgInfo.posIdx]

    local res
    if self.elaspe > (posInfo.aIdx - 1) * 0.1 + (posInfo.bIdx - 1) * 0.05 then
        local y = imgInfo.curY - self.logic:getActionSpeed()
        if y <= posInfo.bottomY then
            -- 更换新图片
            imgInfo.cardId = self.tCards[imgInfo.posIdx]
            res = self.logic:getItemIcon(imgInfo.cardId)
            imgInfo.img:setVisible(self:checkFrame(res))
            imgInfo.img:loadTexture(res, 1)
            imgInfo.img:removeAllChildren()
            if imgInfo.cardId == 8 then
                self:showFreeSpine(imgInfo.img)
            end
            imgInfo.state = 2
            y = self.outHeight + 549 + y
        end
        imgInfo.curY = y
        imgInfo.img:setPositionY(y)
    end
end

function MLCSAction:fallTopDown(imgInfo)
    self.nRunnings = self.nRunnings + 1
    if self.elaspe < imgInfo.elaspe then
        return
    end

    local posInfo = self.tPosMap[imgInfo.posIdx]
    local y = imgInfo.curY - self.logic:getActionSpeed()
    if y <= posInfo.posY then
        self.delay_fire = 999999
        imgInfo.state = 3
        y = posInfo.posY
        local sec = 0.1 - (self.nSpeed * 0.015)
        imgInfo.img:runAction(cc.Sequence:create(cc.RotateTo:create(sec, 10), cc.RotateTo:create(sec, 0)))
        MusicManager.playEffect(string.format("game/mlcs/res/audio/gquest_stone_fall%d.mp3", posInfo.bIdx))
    end
    imgInfo.curY = y
    imgInfo.img:setPositionY(y)
end

function MLCSAction:againMove(imgInfo)
    local function callFun()
        local posInfo = self.tPosMap[imgInfo.posIdx]
        imgInfo.state = 2
        imgInfo.curY = (posInfo.bIdx - 1) * 183 + self.outHeight + 91.5
        imgInfo.img:setPositionY(imgInfo.curY)
        imgInfo.img:setOpacity(255)
        imgInfo.img:setRotation(0)

        -- 更换新图片
        imgInfo.cardId = self.tCards[imgInfo.posIdx]
        local res = self.logic:getItemIcon(imgInfo.cardId)
        imgInfo.img:setVisible(self:checkFrame(res))
        imgInfo.img:loadTexture(res, 1)
        if imgInfo.cardId == 8 then
            self:showFreeSpine(imgInfo.img)
        end
    end

    local function callFun0()
        imgInfo.img:removeAllChildren()
    end

    local sec = (0.8 - (self.nSpeed * 0.1)) / 2
    local aabb = cc.Sequence:create(cc.FadeOut:create(sec), cc.CallFunc:create(callFun0), cc.DelayTime:create(sec), cc.CallFunc:create(callFun))
    imgInfo.img:stopAllActions()
    imgInfo.img:runAction(aabb)
    imgInfo.state = 4 -- 爆炸
    table.insert(self.tExplodes, imgInfo)
end

function MLCSAction:freeShake(imgInfo)
    local sec1 = 0.08 - (self.nSpeed * 0.01)
    local function doShake()
        imgInfo.img:setPosition(imgInfo.curX + math.random(-5, 5), imgInfo.curY + math.random(-5, 5))
    end
    local seq1 = cc.Sequence:create(cc.DelayTime:create(sec1), cc.CallFunc:create(doShake))
    imgInfo.img:runAction(cc.RepeatForever:create(seq1))
    imgInfo.state = 4 -- 只抖动爆炸但不消失
end

function MLCSAction:updateTime(dt)
    self.elaspe = self.elaspe + dt
    self.nRunnings = 0
    self.tExplodes = {}
    local count_state = 0
    local imgInfo
    for i = 1, 15 do
        imgInfo = self.tImgMap[i]
        if imgInfo.state == 1 then -- 运动到底部
            self:moveUnderground(imgInfo)
        elseif imgInfo.state == 2 then -- 运动从上落下
            self:fallTopDown(imgInfo)
        elseif imgInfo.state == 3 then -- 运动到目标点 等待爆炸
            self.nRunnings = self.nRunnings + 1
            count_state = count_state + 1
        elseif imgInfo.state == 4 then -- 爆炸
            self.nRunnings = self.nRunnings + 1
        end
    end

    if count_state == 15 and self.delay_fire == 999999 then
        self:checkDataOK()
        -- 检查数据一致性和爆炸奖励
        self:showWinLines()
    end

    if self.elaspe > self.delay_fire then
        self.delay_fire = 999999
        self:doExplosionFalldown()
    end

    if self.nRunnings == 0 or self.tCards == nil or self.elaspe > self.free_delay then
        self:doGameEnd()
    end
end

function MLCSAction:doExplosionFalldown()
    local imgInfo, posInfo
    local isEnd = true

    if self.logic.result.bFreeGame == 1 then
        self.logic:addFreeSumGold(self.now_result.gold)
        self.scene.buttonView:showFreeBetResult(0)
        for posIdx, isok in pairs(self.now_result.tPos) do
            if isok then
                isEnd = false
                posInfo = self.tPosMap[posIdx]
                imgInfo = self.tImgMap[posInfo.imgIdx]
                self:freeShake(imgInfo)
                self:showBombSpine(posInfo.posX, posInfo.posY)
            end
        end
        if not isEnd then
            self.free_delay = self.elaspe + 0.8 - (self.nSpeed * 0.1)
        end
    else
        for posIdx, isok in pairs(self.now_result.tPos) do
            if isok then
                isEnd = false
                posInfo = self.tPosMap[posIdx]
                imgInfo = self.tImgMap[posInfo.imgIdx]

                -- 爆炸消失重新掉落
                self:againMove(imgInfo)
                self:showBombSpine(posInfo.posX, posInfo.posY)
            end
        end
    end

    -- {gold = self.lBonusCellScore * beishu, beishu = beishu, freeCount = freeCount, tPos = tPos}
    if self.now_result.gold > 0 then
        self.scene.buttonView:updateWinGold(self.logic.nMyWinGold)
        self.scene.buttonView:showGainGold(math.floor(self.now_result.gold))
    end

    if self.now_result.freeCount > 0 then
        self.scene.buttonView:showGainFreeCount(math.floor(self.now_result.freeCount))
        self.logic:addFreeCount(self.now_result.freeCount)
    end

    self:moveUpImage()
    if isEnd then
        self.nRunnings = 0
    elseif self.logic.result.bFreeGame == 0 then
        self.tCards = self.logic:nextGroup(self.now_result.tPos)
        MusicManager.playEffect(string.format("game/mlcs/res/audio/gquest_explosion%d.mp3", math.random(1, 3)))
    end
end

function MLCSAction:doGameEnd()
    self:stopAllImgAction()
    self:stopScheduleLine()
    self:stopTimer()
    self.logic.nMyWinFree = math.floor(self.logic.nMyWinFree)
    self.logic.nMyWinGold = math.floor(self.logic.nMyWinGold)

    if self.logic.nMyWinFree ~= self.logic.result.wFreeCount then
        print("##############free count error##############", self.logic.nMyWinFree, "===right===>", self.logic.result.wFreeCount)
    end

    if self.logic.nMyWinGold ~= self.logic.result.lWinScore then
        print("##############gold score error##############", self.logic.nMyWinGold, "===right===>", self.logic.result.lWinScore)
    end

    self.logic:setSumFreeCount(self.logic.result.wSumFreeCount)
    self.logic:setFreeSumGold(self.logic.result.lSumFreeGold)

    if self.scene:doNextBetMsg() then
        return
    end
    self.logic.nCurGroupIdx = 0
    self.scene.buttonView:updateMultiplier()
    self.scene.buttonView:updateWinGold(self.logic.nMyWinGold)

    local golds = self.logic.result.lUserScore + self.logic.result.lWinScore
    self.logic.lUserScore = golds
    self.scene.buttonView:updateAutoBetBtn()

    if self.logic:isAutoBet() or self.logic:getSumFreeCount() > 0 then
        self.logic:setPlayerGold(golds)
        if self.logic.result.bFreeGame == 1 then
            self.scene.buttonView:showFreeBetResult(0)
        end
        self.scene.buttonView:doBet()
    else
        self.scene.buttonView:setButtonState(true)
        if self.logic.result.bFreeGame == 1 then
            self.logic:setPlayerGold(golds)
            self.scene.buttonView:showFreeBetResult(1)
        end
    end
end

function MLCSAction:moveUpImage()
    for _, info in pairs(self.tExplodes) do
        local posInfo = self.tPosMap[info.posIdx]
        if info.posIdx > 10 then
            local up1 = info.posIdx - 5
            local up2 = info.posIdx - 10
            local upPos1 = self.tPosMap[up1]
            local upPos2 = self.tPosMap[up2]
            local upPic1 = self.tImgMap[upPos1.imgIdx]
            local upPic2 = self.tImgMap[upPos2.imgIdx]

            upPic1.posIdx = info.posIdx
            upPic2.posIdx = up1
            info.posIdx = up2
            posInfo.imgIdx = upPic1.idx
            upPos1.imgIdx = upPic2.idx
            upPos2.imgIdx = info.idx

            if upPic1.state == 3 then
                upPic1.state = 2
                upPic1.elaspe = self.elaspe + 0.8 - (self.nSpeed * 0.1)
            end

            if upPic2.state == 3 then
                upPic2.state = 2
                upPic2.elaspe = self.elaspe + 0.8 - (self.nSpeed * 0.1)
            end
        elseif info.posIdx > 5 then
            local up1 = info.posIdx - 5
            local upPos1 = self.tPosMap[up1]
            local upPic1 = self.tImgMap[upPos1.imgIdx]
            upPic1.posIdx = info.posIdx
            info.posIdx = up1

            posInfo.imgIdx = upPic1.idx
            upPos1.imgIdx = info.idx

            if upPic1.state == 3 then
                upPic1.state = 2
                upPic1.elaspe = self.elaspe + 0.8 - (self.nSpeed * 0.1)
            end
        end
    end
end

function MLCSAction:isInAction()
    return self.schedulerID ~= nil
end

function MLCSAction:startBet()
    self.scene.buttonView:updateAutoBetBtn()
    self.scene.buttonView:updateWinGold(0)
    self:stopAllImgAction()
    self:stopScheduleLine()
    self:stopTimer()
    local info
    for i = 1, 15 do
        info = self.tImgMap[i]
        info.elaspe = 0
        info.state = 1
        info.cardId = -1
    end
    self.logic:updateActionSpeed()
    self.nSpeed = self.logic:getSpeed() - 1
    self.elaspe = 0
    self.delay_fire = 999999
    self.free_delay = 999999

    if self.logic.result.bFreeGame == 1 then
        self.scene.buttonView:showFreeBetResult(0)
    else
        self.scene.buttonView:showNormalBottom()
    end

    self.tCards = self.logic:nextGroup()
    if self.tCards == nil then
        return
    end
    self.scene.buttonView:setButtonState(false)
    self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)
end

function MLCSAction:oneWinLine()
    self:stopAllImgAction()
    self.nCurWinListIdx = self.nCurWinListIdx + 1

    if self.nCurWinListIdx > #self.now_result.tWinLines then
        self:stopScheduleLine()
        self.delay_fire = self.elaspe + 0.1
        return
    end

    local winline = self.now_result.tWinLines[self.nCurWinListIdx]
    self.nLightIdx = 1
    if winline.lineID == 18 or winline.lineID == 19 then
        self.nLightIdx = 2
    end

    for _, idx in pairs(winline.tPosIdx) do
        local posInfo = self.tPosMap[idx]
        local imgInfo = self.tImgMap[posInfo.imgIdx]

        local sec1 = 0.08 - (self.nSpeed * 0.01)
        local function doShake()
            imgInfo.img:setPosition(imgInfo.curX + math.random(-5, 5), imgInfo.curY + math.random(-5, 5))
        end
        local seq1 = cc.Sequence:create(cc.DelayTime:create(sec1), cc.CallFunc:create(doShake))

        -- local seq1 = cc.Sequence:create(cc.RotateTo:create(sec1, 10), cc.RotateTo:create(sec1, 0))
        imgInfo.img:runAction(cc.RepeatForever:create(seq1))
        self:addLight(imgInfo.img, false)
    end
end

function MLCSAction:addLight(parent, action)
    local light = ccui.ImageView:create(string.format("mlcspic/light%d.png", self.nLightIdx), 1) -- 185
    light:setPosition(91.5, 91.5)
    light:setName("WinLineLightEff")
    light:setCapInsets(cc.rect(24, 24, 2, 2))
    light:ignoreContentAdaptWithSize(false)
    light:setContentSize(cc.size(188, 188))
    parent:addChild(light)

    if action then
        local sec = 0.3 - (self.nSpeed * 0.03)
        local fade1 = cc.FadeTo:create(sec, 100)
        local fade2 = cc.FadeTo:create(sec, 255)
        local rep = cc.RepeatForever:create(cc.Sequence:create(fade1, fade2))
        light:runAction(rep)
    end
end

function MLCSAction:showWinLines()
    self.now_result = self.logic:calcRewards(self.tCards)
    -- local winline = {tPosIdx = {}, lineID = lineID, nBeishu = tempBeishu, iconId = id}
    self:stopScheduleLine()
    if #self.now_result.tWinLines > 0 then
        local gapsec = 1 - (self.nSpeed * 0.15)
        self.delay_fire = self.elaspe + 999
        self.nCurWinListIdx = 0
        self.nLightIdx = 0
        self.scheduleLine = self.scheduler:scheduleScriptFunc(handler(self, self.oneWinLine), gapsec, false)
    else
        self.delay_fire = self.elaspe + 1.2 - (self.nSpeed * 0.1)
    end
end

function MLCSAction:stopScheduleLine()
    if self.scheduleLine then
        self.scheduler:unscheduleScriptEntry(self.scheduleLine)
        self.scheduleLine = nil
    end
end

function MLCSAction:stopAllImgAction()
    for k, v in pairs(self.tImgMap) do
        local light = v.img:getChildByName("WinLineLightEff")
        if light then
            light:removeFromParent()
        end
        v.img:stopAllActions()
        v.img:setPosition(v.curX, v.curY)
        v.img:setRotation(0)
        v.img:setScale(1)
        v.img:setOpacity(255)
    end
end

function MLCSAction:stopTimer()
    if self.schedulerID then
        self.scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function MLCSAction:onExit()
    self:stopScheduleLine()
    self:stopTimer()
end

function MLCSAction:showNPCAni()
    local animation = cc.Animation:create()
    for i = 1, 59 do
        local frameName = string.format("mlcspic/mlcsnpc_%d.png", i)
        local spriteFrame = self.frame_cache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.1)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)
    return cc.RepeatForever:create(animate)
end

function MLCSAction:showWaterAni()
    local animation = cc.Animation:create()
    for i = 1, 24 do
        local frameName = string.format("mlcspic/bg_water_%02d.png", i)
        local spriteFrame = self.frame_cache:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.05)
    local animate = cc.Animate:create(animation)
    return cc.RepeatForever:create(animate)
end

function MLCSAction:showBombSpine(x, y)
    local json = "game/mlcs/res/spine/gquest_icon_bingo.json"
    local atlas = "game/mlcs/res/spine/gquest_icon_bingo.atlas"
    local skeletonNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    skeletonNode:setPosition(cc.p(x, y - 20))
    skeletonNode:setScale(0.7)
    skeletonNode:setTimeScale(self.nSpeed + 1)
    self.Panel_icons:addChild(skeletonNode)
    skeletonNode:setAnimation(0, "animation", false)
    skeletonNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.RemoveSelf:create()))
end

function MLCSAction:showFreeSpine(parent)
    local json = "game/mlcs/res/spine/gquest_free_icon.json"
    local atlas = "game/mlcs/res/spine/gquest_free_icon.atlas"
    local skeletonNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    skeletonNode:setPosition(cc.p(91.5, 91.5))
    -- skeletonNode:setScale(0.7)
    -- skeletonNode:setTimeScale(self.nSpeed + 1)
    parent:addChild(skeletonNode)
    skeletonNode:setAnimation(0, "animation", true)
    -- skeletonNode:runAction(cc.Sequence:create(cc.DelayTime:create(8), cc.RemoveSelf:create()))
end

return MLCSAction
