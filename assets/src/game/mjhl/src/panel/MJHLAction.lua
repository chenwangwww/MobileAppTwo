local MJHLAction = class("MJHLAction")

function MJHLAction:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.frame_cache = cc.SpriteFrameCache:getInstance()
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.Panel_icons1 = scene.layer:getChildByName("Panel_icons1")
    self.Panel_icons2 = scene.layer:getChildByName("Panel_icons2")
    self.Image_mask = self.Panel_icons2:getChildByName("Image_mask")
    self.Image_mask:setOpacity(155)
    self.Image_mask:setVisible(false)

    self.schedulerID = nil
    self.nSpeed = 1
    self:initIcons()
    self.tEffectNode = {}
    self.nLastCol = 1
    self.bIsNoCards = false
end

--[[
      b  1   2   3   4   5
    a
    6    26, 27, 28, 29, 30
    5    21, 22, 23, 24, 25       
    4    16, 17, 18, 19, 20
    3    11, 12, 13, 14, 15
    2    6,  7,  8,  9,  10
    1    1,  2,  3,  4,  5
--]]
function MJHLAction:initIcons()
    self.tImgMap = {}
    self.tPosMap = {}
    self.tXYtoIdx = {}
    local icon, img, x, y, idx
    for a = 1, 6 do
        for b = 1, 5 do
            idx = (a - 1) * 5 + b
            icon = self.logic:getItemIcon(math.random(0, 9), false)
            img = ccui.ImageView:create(icon, 1) -- 150,180    750 900
            y = a * 180 - 90
            x = b * 150 - 75
            img:setPosition(x, y)
            self.Panel_icons1:addChild(img)

            self.tXYtoIdx[x] = self.tXYtoIdx[x] or {}
            self.tXYtoIdx[x][y] = idx

            self.tPosMap[idx] = {
                posIdx = idx,
                posX = x,
                posY = y,
                aIdx = a,
                bIdx = b,
                imgIdx = idx
            }

            self.tImgMap[idx] = {
                imgIdx = idx,
                img = img,
                posIdx = idx,
                curX = x,
                curY = y,
                state = 0,
                bIsGolden = 0, -- 是否金色图标
                nLucky = 0, -- 幸运中奖标记
                elaspe = 0,
                cardId = -1,
                slow_action = nil
            }
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
        local s = 0.075 -- p / 4.0
        return math.pow(2.0, -10.0 * ratio) * math.sin((ratio - s) * (2.0 * math.pi) / p) + 1
    end
end

local function easeOutBounce(ratio)
    local s = 7.5625;
    local p = 2.75;
    local l = nil
    if ratio < (1.0 / p) then
        l = s * math.pow(ratio, 2);
    else
        if ratio < (2.0 / p) then
            ratio = ratio - 1.5 / p;
            l = s * math.pow(ratio, 2) + 0.75;
        else
            if ratio < 2.5 / p then
                ratio = ratio - 2.25 / p;
                l = s * math.pow(ratio, 2) + 0.9375;
            else
                ratio = ratio - 2.625 / p;
                l = s * math.pow(ratio, 2) + 0.984375;
            end
        end
    end
    return l;
end

function MJHLAction:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "mjhl result check frame not found frame:" .. tostring(name)
        print(str)
        local png = "game/mjhl/res/mjhlhetu.png"
        local plist = "game/mjhl/res/mjhlhetu.plist"
        self.frame_cache:addSpriteFrames(plist, png)

        frame = self.frame_cache:getSpriteFrameByName(name)
    end
    return frame ~= nil
end

-- 循环随机掉落
function MJHLAction:dropIconSetp1(b)
    local imgInfo, idx, y, cardId, res
    for a = 1, 6 do
        idx = (a - 1) * 5 + b
        imgInfo = self.tImgMap[idx]
        y = imgInfo.curY - self.logic:getActionSpeed()
        if y < 0 then -- 150,180    750 900   
            y = 1080 + y

            cardId = math.random(0, 9)
            res = self.logic:getItemIcon(cardId, 0)
            imgInfo.img:setVisible(self:checkFrame(res))
            imgInfo.img:setOpacity(255)
            imgInfo.cardId = cardId
            imgInfo.bIsGolden = 0
            imgInfo.nLucky = 0
            imgInfo.img:loadTexture(res, 1)

            self.tDropCount[b] = self.tDropCount[b] + 1

            if b == 1 and self.tDropCount[1] > 3 then
                self.state_sign[1] = 2
            end

            if b > 1 and self.state_sign[b - 1] > 1 and self.tDropCount[b] > (3 + 2 * (b - 1)) then
                if (#self.tPreCountHu >= 2 and self.tPreCountHu[2].bIdx >= b) or #self.tPreCountHu < 2 then
                    self.state_sign[b] = 2
                elseif self.state_sign[b - 1] == 32 then
                    self:showPreHuSkel(b)
                    if self.elaspe - self.preHuElaspe > (3 - (self.nSpeed * 0.4)) then
                        self.state_sign[b] = 2
                        self.tSlowDown[b] = 1
                    end
                end
            end
        end
        imgInfo.curY = y
        imgInfo.img:setPositionY(imgInfo.curY)
    end
end

function MJHLAction:playFastTurnAudio()
    self:stopFastTurnAudio()
    self.fastTurnVoiceId = ccexp.AudioEngine:play2d("game/mjhl/res/audio/fastturn.mp3", false, MusicManager.effectVal)
end

function MJHLAction:stopFastTurnAudio()
    if self.fastTurnVoiceId then
        ccexp.AudioEngine:stop(self.fastTurnVoiceId)
        self.fastTurnVoiceId = nil
    end
end

function MJHLAction:showPreHuSkel(bIdx)
    if self.preHuSkelNode then
        self.preHuSkelNode:setVisible(true)
    else
        local json = "game/mjhl/res/spine/fast_vfx_a.json"
        local atlas = "game/mjhl/res/spine/fast_vfx_a.atlas"
        self.preHuSkelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        self.preHuSkelNode:setAnimation(0, "animation", true)
        self.Panel_icons2:addChild(self.preHuSkelNode)
    end
    if self.tFastTurnAudio[bIdx] == 0 then
        self:playFastTurnAudio()
        self.tFastTurnAudio[bIdx] = 1
    end

    local posx = bIdx * 150 - 75
    self.preHuSkelNode:setPosition(bIdx * 150 - 75, 520)
    self.Image_mask:setVisible(true)
    self.Image_mask:setPositionX(posx - 75)
    -- skeletonNode:setTimeScale(self.nSpeed)
end

function MJHLAction:showHuCardSkel(posIdx)
    local json = "game/mjhl/res/spine/scatter_vfx_d.json"
    local atlas = "game/mjhl/res/spine/scatter_vfx_d.atlas"
    local skel = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.Panel_icons2:addChild(skel)
    local tPos = self.tPosMap[posIdx]
    skel:setPosition(tPos.posX, tPos.posY)
    skel:setAnimation(0, "animation", false)
    skel:addAnimation(0, "animation2", true)
    table.insert(self.tHuCardSkel, skel)
    -- skel:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.RemoveSelf:create()))
end

function MJHLAction:cleanPreHuSkel()
    self.Image_mask:stopAllActions()
    self.Image_mask:setVisible(false)
    if self.preHuSkelNode then
        self.preHuSkelNode:setVisible(false)
    end

    for _, skel in pairs(self.tHuCardSkel) do
        skel:removeFromParent()
    end
    self.tHuCardSkel = {}
    self.tPreCountHu = {}
    self.tPreHuMap = {}
end

function MJHLAction:precountHu()
    self.tPreCountHu = {}
    self.tPreHuMap = {}
    local tbl, idx
    for b = 1, 5 do
        local maxn = #self.logic.tCardList[b]
        if maxn >= 5 then -- 大于等于5个数据才计算
            for a = 2, 5 do
                idx = (a - 1) * 5 + b
                tbl = self.logic.tCardList[b][maxn - a + 1]
                if tbl[1] == 9 then
                    local tt = {
                        posIdx = idx,
                        aIdx = a,
                        bIdx = b
                    }
                    table.insert(self.tPreCountHu, tt)
                    self.tPreHuMap[idx] = tt
                end
            end
        end
    end
end

-- 控制掉落6个实图
function MJHLAction:dropIconSetp2(b)
    local imgInfo, idx, y, tbl, res, num, count
    if self.tSlowDown[b] > 0 and self.tSlowDown[b] < 15 then
        self.tSlowDown[b] = self.tSlowDown[b] + 1
    end

    for a = 1, 6 do
        idx = (a - 1) * 5 + b
        imgInfo = self.tImgMap[idx]
        y = imgInfo.curY - self.logic:getActionSpeed() + self.tSlowDown[b]
        if y < 0 then -- 150,180    750 900   
            y = 1080 + y
            count = #self.logic.tCardList[b]
            if count > 0 then
                tbl = table.remove(self.logic.tCardList[b])
                if tbl ~= nil then
                    self.tRealCards[b] = self.tRealCards[b] + 1
                    res = self.logic:getItemIcon(tbl[1], tbl[2])
                    imgInfo.img:setVisible(self:checkFrame(res))
                    imgInfo.img:setOpacity(255)
                    imgInfo.cardId = tbl[1]
                    imgInfo.bIsGolden = tbl[2]
                    imgInfo.nLucky = 0
                    imgInfo.img:loadTexture(res, 1)
                else
                    print("mjhl result error dropIconSetp2 getItemIcon a, b, count", a, b, count)
                    dump(self.logic.tCardList)
                end

                if self.tRealCards[b] == 6 then
                    self.state_sign[b] = 3
                end
            end
        end
        imgInfo.curY = y
        imgInfo.img:setPositionY(imgInfo.curY)
    end

    if self.state_sign[b] == 3 then
        local sss = 0.8
        if self.tSlowDown[b] == 0 then
            sss = 0.4 - (self.nSpeed * 0.05)
        else
            sss = 0.8 - (self.nSpeed * 0.08)
        end

        for a = 1, 6 do
            idx = (a - 1) * 5 + b
            imgInfo = self.tImgMap[idx]
            imgInfo.slow_action = {
                start = imgInfo.curY,
                over = self:getEndY(imgInfo.curY),
                sec = sss,
                now = self.elaspe,
                easeFun = easeOutBack
            }
        end
    end
end

-- 缓动停止
function MJHLAction:dropIconSetp31(b)
    local imgInfo, idx, ratio, progress
    local hasMove = false
    local hasHuAudio = false
    for a = 1, 6 do
        idx = (a - 1) * 5 + b
        imgInfo = self.tImgMap[idx]
        if imgInfo.slow_action then
            hasMove = true
            self.bIsHasDrop = true
            ratio = (self.elaspe - imgInfo.slow_action.now) / imgInfo.slow_action.sec
            progress = imgInfo.slow_action.easeFun(ratio)
            imgInfo.curY = imgInfo.slow_action.start + (imgInfo.slow_action.over - imgInfo.slow_action.start) * progress
            imgInfo.img:setPositionY(imgInfo.curY)

            if ratio >= 1 then
                self.preHuElaspe = self.elaspe
                self.state_sign[b] = 32
                if imgInfo.cardId == 9 then
                    local fixY = self:fixPosY(imgInfo.slow_action.over)
                    local pidx = self.tXYtoIdx[imgInfo.curX][fixY]
                    if self.tPreHuMap[pidx] then
                        self:showHuCardSkel(pidx)
                        hasHuAudio = true
                    end
                end
            end
        end
    end

    if hasHuAudio then
        MusicManager.playEffect("game/mjhl/res/audio/hu.mp3")
    end

    if hasMove and b > self.nLastCol then
        self.nLastCol = b
        -- 第一行就没有掉落，可能直接变成了wild牌， 也可能第二，三行掉落
    end

    if self.state_sign[b] == 32 then
        for a = 1, 6 do
            idx = (a - 1) * 5 + b
            imgInfo = self.tImgMap[idx]
            if imgInfo.slow_action then
                imgInfo.curY = imgInfo.slow_action.over
                imgInfo.img:setPositionY(imgInfo.curY)
            end
            imgInfo.slow_action = nil
        end

        if self.nRolsDrop == 1 then
            MusicManager.playEffect("game/mjhl/res/audio/stop.mp3")
        else
            MusicManager.playEffect("game/mjhl/res/audio/faststop.mp3")
        end

        if b == self.nLastCol then
            self:dropIconSetp32()
        end
    elseif self.bIsHasDrop == false and b == 5 then
        -- print("有变牌，但是都么有掉落, 则状态变化为32")
        self.state_sign = {32, 32, 32, 32, 32}
        self:dropIconSetp32()
    end
end

-- 计算消除奖励图标
function MJHLAction:dropIconSetp32()
    self.nHuTotal = 0
    self:stopFastTurnAudio()
    self:checkIconsPos()
    -- self:printCards()
    self:cleanPreHuSkel()
    local tTemp, tWild = {}, {{}, {}, {}, {}, {}}
    local idx, imgIdx, imgInfo

    -- 数据归类
    for b = 1, 5 do
        for a = 2, 5 do
            idx = (a - 1) * 5 + b
            imgIdx = self.tPosMap[idx].imgIdx
            imgInfo = self.tImgMap[imgIdx]
            if imgInfo.cardId < 0 then
                -- print("======mjhl result cards use up, now empty card directly stop game=======")
                self:doGameEnd()
                return
            end

            if imgInfo.cardId == 8 then
                table.insert(tWild[b], imgInfo)
            end

            if imgInfo.cardId < 8 then
                tTemp[imgInfo.cardId] = tTemp[imgInfo.cardId] or {}
                tTemp[imgInfo.cardId][b] = tTemp[imgInfo.cardId][b] or {}
                table.insert(tTemp[imgInfo.cardId][b], imgInfo)
            end
        end
    end

    local result, isOK = {}, false
    -- 确认中奖图标
    for cId, tT in pairs(tTemp) do
        local tRes = {}
        for b = 1, 5 do
            isOK = false
            if b > 1 then
                local isOK1 = (tT[b - 1] and (#tT[b - 1] > 0)) or (#tWild[b - 1] > 0)
                local isOK2 = (tT[b] and (#tT[b] > 0)) or (#tWild[b] > 0)
                isOK = isOK1 and isOK2
            end

            if b == 1 or isOK then
                tRes[b] = {}

                if tT[b] then
                    for _, imgInfo in pairs(tT[b]) do
                        table.insert(tRes[b], imgInfo)
                    end
                end

                if #tWild[b] > 0 then
                    for _, imgInfo in pairs(tWild[b]) do
                        table.insert(tRes[b], imgInfo)
                    end
                end
            else
                if #tRes >= 3 then
                    table.insert(result, tRes)
                end

                break
            end

            if b == 5 then
                table.insert(result, tRes)
            end
        end
    end

    local tnums, tWinIds = {}, {}
    local bs, winId = 1, -1
    local cardPercent, cardbonus = 0, 0
    local wholeFive = false -- 5个全中
    self.nSingleProfit = 0 -- 单轮掉落回报金额
    -- print("mjhl result cardId colNum cardOdds topMulti lCellScore                      result")
    for _, tRes in ipairs(result) do
        bs = 1
        winId = -1
        tnums = {}
        if #tRes == 5 then
            wholeFive = true
        end
        for ii, tt in ipairs(tRes) do
            bs = bs * #tt
            table.insert(tnums, #tt)
            for _, imgInfo in ipairs(tt) do
                imgInfo.nLucky = 1
                if imgInfo.cardId >= 0 and imgInfo.cardId < 8 then
                    winId = imgInfo.cardId
                end
            end
        end

        if winId >= 0 then
            tWinIds[winId] = true
            self.logic:playCardAudio(winId)
            local multiple = self.logic.tMultipleMap[winId][#tRes]
            cardPercent = multiple * bs * self.scene.topPanel.nTopMulti
            self.nTotalPercent = self.nTotalPercent + cardPercent -- 此轮总赚率
            cardbonus = cardPercent * self.logic.lCellScore
            self.nSingleProfit = self.nSingleProfit + cardbonus

            -- print("mjhl result ",  winId, "   ",  #tRes, "     ", multiple, "      ", self.scene.topPanel.nTopMulti, "     ", self.logic.lCellScore, "     ", table.concat(tnums, " * "), "      ", cardbonus)
        else
            -- print("本轮翻转全部为wild 本轮不计算")
        end
    end

    -- 纯wild牌 大于等于3个的情况下
    bs = 1
    winId = -1
    tnums = {}
    local nMaxWildB = 0
    for b = 1, 5 do
        if (b == 1 and #tWild[1] > 0) or (b > 1 and #tWild[b - 1] > 0 and #tWild[b] > 0) then
            bs = bs * #tWild[b]
            table.insert(tnums, #tWild[b])
            nMaxWildB = b

            if b == 5 then
                wholeFive = true
            end
        else
            break
        end
    end

    if nMaxWildB >= 3 then
        local isHasPureWildWin = false
        for cid = 0, 7 do
            if tWinIds[cid] == nil then
                isHasPureWildWin = true
                self.logic:playCardAudio(cid)
                local multiple = self.logic.tMultipleMap[cid][nMaxWildB]
                cardPercent = multiple * bs * self.scene.topPanel.nTopMulti
                self.nTotalPercent = self.nTotalPercent + cardPercent -- 此轮总赚率
                cardbonus = cardPercent * self.logic.lCellScore
                self.nSingleProfit = self.nSingleProfit + cardbonus

                -- print("mjhl result ",  cid, "   ",  nMaxWildB, "     ", multiple, "      ", self.scene.topPanel.nTopMulti, "     ", self.logic.lCellScore, "     ", table.concat(tnums, " * "), "      ", cardbonus, "      PureWild")
            end
        end

        if isHasPureWildWin then
            for b = 1, nMaxWildB do
                for _, imgInfo in pairs(tWild[b]) do
                    imgInfo.nLucky = 1
                end
            end
        end
    end

    if wholeFive then
        MusicManager.playEffect("game/mjhl/res/audio/quanzhong" .. math.random(1, 2) .. ".mp3")
    end

    self.bHasWinIcon = false
    self.bNeedCleanSkel = false
    for idx, tImg in pairs(self.tImgMap) do
        if tImg.nLucky == 1 then
            self.bHasWinIcon = true
            self.bNeedCleanSkel = true
            self:showIconSkel(tImg)
        end
        if tImg.cardId == 9 and tImg.posIdx >= 6 and tImg.posIdx <= 25 then
            self.nHuTotal = self.nHuTotal + 1
        end
    end

    if self.nHuTotal >= 3 then
        local nfree = (self.nHuTotal - 3) * 2 + 12
        self.tTotalSettlement.wFreeCount = self.tTotalSettlement.wFreeCount + nfree
    end
    self.tTotalSettlement.lWinScore = self.tTotalSettlement.lWinScore + self.nSingleProfit

    if self.logic.result.bFreeGame == 1 then
        self.scene.bottomPanel:setRoundDropBonus(self.nSingleProfit, math.random(1, 3))
        self.scene.bottomPanel:setCurFreeScore(self.tTotalSettlement.lWinScore)
    else
        self.scene.bottomPanel:setRoundDropBonus(self.tTotalSettlement.lWinScore, math.random(1, 3))
    end

    if self.bHasWinIcon then
        self.Image_mask:setVisible(true)
        self.Image_mask:setPositionX(750)
        self.Image_mask:runAction(cc.Sequence:create(cc.DelayTime:create(0.5 - (self.nSpeed - 1) * 0.1), cc.Hide:create()))
        -- MusicManager.playEffect('game/mjhl/res/audio/linewin.mp3')
    end

    -- print("mjhl result====================settlement of this round drop bonus:", self.nSingleProfit)
    self.bNeedDoStep33 = self.bHasWinIcon and self.bIsNoCards == false
    if not self.bNeedDoStep33 then
        self:doGameEnd()
    end
end

function MJHLAction:showIconSkel(imgInfo)
    local skeletonNode = self.tEffectNode[imgInfo.posIdx]
    if skeletonNode then
        skeletonNode:setVisible(true)
    else
        local json = "game/mjhl/res/spine/win_flare.json"
        local atlas = "game/mjhl/res/spine/win_flare.atlas"
        skeletonNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        skeletonNode:setPosition(cc.p(imgInfo.curX + 2, imgInfo.curY - 3))
        self.Panel_icons2:addChild(skeletonNode)
        self.tEffectNode[imgInfo.posIdx] = skeletonNode
    end

    local str = "animation" .. imgInfo.cardId .. imgInfo.bIsGolden
    skeletonNode:setAnimation(0, str, false)
    skeletonNode:setTimeScale(self.nSpeed)

    local function doCallFun1()
        if imgInfo.bIsGolden == 1 then
            imgInfo.bIsGolden = 0
            imgInfo.img:setOpacity(255)
        end

        if self.bNeedDoStep33 then
            self.bNeedDoStep33 = false
            local fun1 = cc.CallFunc:create(handler(self, self.dropIconSetp33))
            local delay1 = cc.DelayTime:create(0.3 - (self.nSpeed - 1) * 0.05)

            local fun2 = cc.CallFunc:create(handler(self, self.cleanIconSkel))
            local delay2 = cc.DelayTime:create(0.3 - (self.nSpeed - 1) * 0.05)
            self.Panel_icons1:runAction(cc.Sequence:create(delay2, fun2, delay1, fun1))
        elseif self.bNeedCleanSkel then
            self.bNeedCleanSkel = false
            local fun1 = cc.CallFunc:create(handler(self, self.cleanIconSkel))
            local delay1 = cc.DelayTime:create(0.5 - (self.nSpeed - 1) * 0.1)
            self.Panel_icons1:runAction(cc.Sequence:create(delay1, fun1))
        end
    end

    if imgInfo.bIsGolden == 1 then
        MusicManager.playEffect("game/mjhl/res/audio/changeWild.mp3")
        local res = self.logic:getItemIcon(8, 0)
        self:checkFrame(res)
        imgInfo.img:setVisible(self:checkFrame(res))
        imgInfo.cardId = 8
        imgInfo.nLucky = 0
        imgInfo.img:loadTexture(res, 1)
    end

    MusicManager.playEffect("game/mjhl/res/audio/xiaochu.mp3")
    imgInfo.img:setOpacity(0)
    local delaycall = cc.DelayTime:create(1 - (self.nSpeed - 1) * 0.2)
    imgInfo.img:runAction(cc.Sequence:create(delaycall, cc.CallFunc:create(doCallFun1)))
end

-- 新的掉落
function MJHLAction:dropIconSetp33()
    self.bNeedDoStep33 = false
    local imgInfo, idx, ratio, progress
    local tbl, res, imgIdx
    local countLucky, bNextRols = 0, false
    for b = 1, 5 do
        countLucky = 0
        for a = 2, 6 do
            idx = (a - 1) * 5 + b
            imgIdx = self.tPosMap[idx].imgIdx
            imgInfo = self.tImgMap[imgIdx]
            if imgInfo.nLucky == 1 then
                tbl = table.remove(self.logic.tCardList[b])
                countLucky = countLucky + 1
                imgInfo.nLucky = 0
                imgInfo.curY = countLucky * 180 + 990
                imgInfo.img:setPositionY(imgInfo.curY)
                imgInfo.img:setOpacity(255)
                if tbl ~= nil then
                    bNextRols = true
                    res = self.logic:getItemIcon(tbl[1], tbl[2])
                    imgInfo.img:setVisible(self:checkFrame(res))
                    imgInfo.cardId = tbl[1]
                    imgInfo.bIsGolden = tbl[2]
                    imgInfo.img:loadTexture(res, 1)
                else
                    self.bIsNoCards = true
                    imgInfo.cardId = -1
                    imgInfo.bIsGolden = 0
                    imgInfo.img:setVisible(false)
                    -- print('mjhl result=========== no cards col===========', b)
                end

                imgInfo.slow_action = {
                    start = imgInfo.curY,
                    over = nil,
                    sec = 0.7 - (self.nSpeed * 0.08),
                    now = self.elaspe,
                    easeFun = easeOutBounce
                }
            elseif countLucky > 0 then
                imgInfo.slow_action = {
                    start = imgInfo.curY,
                    over = imgInfo.curY - (countLucky * 180),
                    sec = 0.7 - (self.nSpeed * 0.08),
                    now = self.elaspe,
                    easeFun = easeOutBounce
                }
            end
        end

        if countLucky > 0 then
            for a = 2, 6 do
                idx = (a - 1) * 5 + b
                imgIdx = self.tPosMap[idx].imgIdx
                imgInfo = self.tImgMap[imgIdx]
                if imgInfo.slow_action and imgInfo.slow_action.over == nil then
                    imgInfo.slow_action.over = imgInfo.curY - (countLucky * 180)
                end
            end
        end
    end
    if bNextRols then
        self.nRolsDrop = self.nRolsDrop + 1
        self.scene.topPanel:setTopMulti(self.nRolsDrop)
    end
    self.nLastCol = 1
    self.bIsHasDrop = false
    self.state_sign = {3, 3, 3, 3, 3}
end

function MJHLAction:updateTime(dt)
    self.elaspe = self.elaspe + dt

    for b = 1, 5 do
        if self.state_sign[b] == 1 then -- 随机掉落
            self:dropIconSetp1(b)
        elseif self.state_sign[b] == 2 then -- 掉落5个实图
            self:dropIconSetp2(b)
        elseif self.state_sign[b] == 3 then -- 缓动停止 消除奖励图标 新的掉落
            self:dropIconSetp31(b)
        end
    end
end

function MJHLAction:getEndY(y)
    -- 1170 990 810 630 450 270 90
    if y >= 990 then
        return 990
    elseif y >= 810 and y < 990 then
        return 810
    elseif y >= 630 and y < 810 then
        return 630
    elseif y >= 450 and y < 630 then
        return 450
    elseif y >= 270 and y < 450 then
        return 270
    elseif y >= 90 and y < 270 then
        return 90
    else
        return 990
    end
end

function MJHLAction:fixPosY(y)
    if y >= 900 and y < 1080 then
        return 990
    elseif y >= 720 and y < 900 then
        return 810
    elseif y >= 540 and y < 720 then
        return 630
    elseif y >= 360 and y < 540 then
        return 450
    elseif y >= 180 and y < 360 then
        return 270
    elseif y >= 0 and y < 180 then
        return 90
    else
        return 990
    end
end

function MJHLAction:printCards()
    local idx, tPos, tCard, tbl
    for a = 2, 5 do
        tbl = {}
        for b = 1, 5 do
            idx = (a - 1) * 5 + b
            tPos = self.tPosMap[idx]
            tCard = self.tImgMap[tPos.imgIdx]
            table.insert(tbl, tCard.cardId)
        end
        print("mjhl result   ", a, "******", table.concat(tbl, " "))
    end
end

function MJHLAction:checkIconsPos()
    local tMap = {}
    for _, imgInfo in pairs(self.tImgMap) do
        local idx = self.tXYtoIdx[imgInfo.curX][imgInfo.curY]
        if idx == nil then
            local fixY = self:fixPosY(imgInfo.curY)
            -- print("mjhl result error checkIconsPos curX, curY, fixY====>", imgInfo.curX, imgInfo.curY, fixY)
            imgInfo.curY = fixY
            imgInfo.img:setPositionY(imgInfo.curY)
        end

        idx = self.tXYtoIdx[imgInfo.curX][imgInfo.curY]
        if idx then
            tMap[imgInfo.curX] = tMap[imgInfo.curX] or {}

            if tMap[imgInfo.curX][imgInfo.curY] == nil then
                tMap[imgInfo.curX][imgInfo.curY] = imgInfo
                self.tPosMap[idx].imgIdx = imgInfo.imgIdx
                imgInfo.posIdx = idx
            else
                local tPos = self.tPosMap[idx]
                print("==========mjhl result checkIconsPos pos overlap error=========")
                dump(tPos)
                dump(tMap[imgInfo.curX][imgInfo.curY])
                dump(imgInfo)
                print("===============error================")
            end
        else
            print("==========mjhl result checkIconsPos curX error=========")
            dump(imgInfo)
        end
    end
end

function MJHLAction:onHideFullScreenSkel()

    --[[
    if self.tTotalSettlement.lWinScore ~= self.logic.result.lWinScore or self.tTotalSettlement.wFreeCount ~= self.logic.result.wFreeCount then
        print("mjhl result settlement error=>lWinScore:", self.tTotalSettlement.lWinScore, "  wFreeCount:", self.tTotalSettlement.wFreeCount)
        print("mjhl result server result=>lWinScore:", self.logic.result.lWinScore, "  wFreeCount:", self.logic.result.wFreeCount)
    end
    --]]

    self.scene.bottomPanel:setScoreChange(self.logic.result.lWinScore)
    self.logic:addPlayerGold(self.logic.result.lWinScore)
    if self.logic.result.lWinScore > 0 then
        MusicManager.playEffect("game/mjhl/res/audio/score_add.mp3")
    end

    if self.logic:getSumFreeCount() > 0 or self.logic:isAutoBet() then
        self.scene.bottomPanel:doBet()
    else
        self.scene.bottomPanel:showNormalBottom()
        self.scene.bottomPanel:setButtonState(true)
        self.scene.bottomPanel.btnStartSkel:setAnimation(0, "daiji", true)
    end
end

function MJHLAction:doGameEnd()
    -- print("mjhl result=============================doGameEnd=============================")
    self:cleanIconSkel()
    self:stopTimer()
    self:stopAllImgAction()
    self.state_sign = {0, 0, 0, 0, 0}

    local isShowAni = false

    -- ikind  1大奖  2巨奖  3超级巨奖
    if self.nTotalPercent > 2000 then
        isShowAni = true
        self.scene.topPanel:showBigWin({self.tTotalSettlement.lWinScore, 3})
    elseif self.nTotalPercent > 1000 then
        isShowAni = true
        self.scene.topPanel:showBigWin({self.tTotalSettlement.lWinScore, 2})
    elseif self.nTotalPercent > 500 then
        isShowAni = true
        self.scene.topPanel:showBigWin({self.tTotalSettlement.lWinScore, 1})
    end

    -- 免费摇奖并都用完了显示总的免费摇奖获得的金币
    if self.logic.result.bFreeGame == 1 and self.logic.result.wSumFreeCount == 0 then
        isShowAni = true
        self.scene.topPanel:showAwardSettlement(self.logic.result.lFreeSumGold)
    end

    if self.logic.result.wFreeCount > 0 then
        isShowAni = true
        -- 显示免费旋转 恭喜获得12次免费旋转
        self.logic:addFreeCount(self.logic.result.wFreeCount)
        self.scene.topPanel:showWinFreeSpin(self.logic.result.wFreeCount)
    end

    if not isShowAni then
        self:onHideFullScreenSkel()
    end
end

function MJHLAction:stopCoinDownVoiceId()
    if self.coinDownVoiceId then
        ccexp.AudioEngine:stop(self.coinDownVoiceId)
        self.coinDownVoiceId = nil
    end
end

function MJHLAction:cleanIconSkel()
    self.bNeedCleanSkel = false
    self.Image_mask:stopAllActions()
    self.Image_mask:setVisible(false)
    for _, v in pairs(self.tEffectNode) do
        v:setVisible(false)
    end
end

function MJHLAction:isInAction()
    return self.schedulerID ~= nil
end

function MJHLAction:startBet()
    self:stopAllImgAction()
    self:cleanIconSkel()
    self:stopTimer()
    self:stopCoinDownVoiceId()
    self.scene.bottomPanel:setRoundDropBonus(0, 1)

    -- FS(方块暂停)  daiji（待机缓速旋转） dianji（点击急加速旋转）  zidong（自动显示方块停止)
    self.scene.bottomPanel.btnStartSkel:setAnimation(0, "dianji", false)
    if self.logic:isAutoBet() then
        self.scene.bottomPanel.btnStartSkel:addAnimation(0, "zidong", true)
    else
        self.scene.bottomPanel.btnStartSkel:addAnimation(0, "daiji", true)
    end

    local info
    for i = 1, 30 do
        info = self.tImgMap[i]
        info.elaspe = 0
        info.state = 1
        info.cardId = -1
        info.nLucky = 0
        info.bIsGolden = 0 -- 是否金色图标
        info.slow_action = nil
    end
    self.logic:updateActionSpeed()
    self.nSpeed = self.logic:getSpeed()
    self.elaspe = 0
    self.preHuElaspe = 0
    self.nHuTotal = 0
    self.nTotalPercent = 0 -- 此轮总赚率
    self.nSingleProfit = 0 -- 单轮掉落回报金额
    self.tTotalSettlement = {
        lWinScore = 0,
        wFreeCount = 0
    }
    self.tDropCount = {0, 0, 0, 0, 0}
    self.tRealCards = {0, 0, 0, 0, 0}
    self.tFastTurnAudio = {0, 0, 0, 0, 0}
    self.nLastCol = 5
    self.bIsNoCards = false
    self.bIsHasDrop = false
    self.tHuCardSkel = {}
    self.nRolsDrop = 1 -- 滚动次数
    self.scene.topPanel:setTopMulti(self.nRolsDrop)
    self.tSlowDown = {0, 0, 0, 0, 0} -- 减速

    if self.logic.result.bFreeGame == 1 then
        self.scene.bottomPanel:showFreeSpinPanel()
        self.scene.bottomPanel:updateFreeSpinLeft()
        self.scene.bottomPanel:setCurFreeScore(0)
    else
        self.scene.bottomPanel:showNormalBottom()
    end
    self.state_sign = {1, 1, 1, 1, 1} -- 0停止状态 1循环随机掉落 2正常掉落4组 3缓动停止状态 4结算计算奖励
    self:precountHu()
    self.scene.bottomPanel:setButtonState(false)
    self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)
    self.scene.bottomPanel:updateAutoBetBtn()
    MusicManager.playEffect("game/mjhl/res/audio/run.mp3")
end

function MJHLAction:stopAllImgAction()
    self.Panel_icons1:stopAllActions()
    for k, v in pairs(self.tImgMap) do
        v.img:removeAllChildren()
        v.img:stopAllActions()
        v.img:setPosition(v.curX, v.curY)
        v.img:setOpacity(255)
    end
end

function MJHLAction:stopTimer()
    if self.schedulerID then
        self.scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function MJHLAction:onExit()
    self:stopTimer()
end

return MJHLAction
