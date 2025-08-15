--[[
JDNNSeatManager.lua
玩家管理
]] local GameCMD = require("game.jdnn.src.JDNNCMD")
local JDNNSound = require("game.jdnn.src.JDNNSound")

local JDNNHandInfo = class("JDNNHandInfo")

local CardState = {
    NONE = 0,
    DISPATCH = 1,
    COVER = 2,
    OPEN = 3
}

local function getCardFrame(card)
    local cardVal = bit.band(card, 0x0f)
    local cardColor = bit.rshift(card, 4)
    local frame = string.format("img_card_%d%X.png", cardColor, cardVal)
    return frame
end

function JDNNHandInfo:ctor(root)
    self.root_ = root

    self.cards_ = {}
    self.cardsPos_ = {}
    self.cardsSca_ = {}
    self.nodeCard_ = self.root_:getChildByName("node_card")
    for i = 1, GameCMD.MAX_CARD do
        self.cards_[i] = self.nodeCard_:getChildByName("CardImage" .. i - 1)
        self.cardsPos_[i] = cc.p(self.cards_[i]:getPosition())
        self.cardsSca_[i] = self.cards_[i]:getScale()
    end
    self.imgOxType_ = self.nodeCard_:getChildByName("CardType")
    self.imgOxType_:hide()
    self.imgStart_ = self.nodeCard_:getChildByName("CardStart")

    self.betMoney_ = self.root_:getChildByName("BetMoney")

    self:showNodeCard(false)
    self:showBets(false)

    self.cardDatas_ = {}
    self.cardState_ = CardState.NONE
end

function JDNNHandInfo:loadCardDatas(cards)
    self.cardDatas_ = cards
end

function JDNNHandInfo:showCards(bOpen)
    self:showNodeCard(true)
    for i, card in ipairs(self.cards_) do
        local frame = getCardFrame(bOpen and self.cardDatas_[i] or 0)
        card:loadTexture(frame, ccui.TextureResType.plistType)
    end
    if not bOpen then
        self.imgOxType_:hide()
    end
end

function JDNNHandInfo:showNodeCard(visible)
    self.nodeCard_:setVisible(visible)
end

function JDNNHandInfo:showBets(visible)
    self.betMoney_:setVisible(visible)
end

function JDNNHandInfo:setBets(bets, bAction)
    self:showBets(true)
    self.betMoney_:getChildByName("score_tf"):setString(GameUtil.formatAsset(bets, false)):setVisible(not bAction)
    for i = 1, 3 do
        if bAction then
            local posx, posy = self.betMoney_:getChildByName("gold_" .. i):getPosition()
            local callback = function()
                JDNNSound.betMoney()
                if i == 3 then
                    self.betMoney_:getChildByName("score_tf"):show()
                end
            end
            self.betMoney_:getChildByName("gold_" .. i):show():move(0, 0):moveTo{
                time = 0.15,
                x = posx,
                y = posy,
                delay = (i - 1) * 0.05,
                onComplete = callback
            }
        else
            self.betMoney_:getChildByName("gold_" .. i):show()
        end
    end
end

function JDNNHandInfo:winBets(srcPos)
    self.betMoney_:getChildByName("score_tf"):hide()
    local localPos = self.nodeCard_:convertToNodeSpace(srcPos)
    for i = 1, 3 do
        local posx, posy = self.betMoney_:getChildByName("gold_" .. i):getPosition()
        local callback = function()
            self.betMoney_:getChildByName("gold_" .. i):move(posx, posy):hide()
        end
        self.betMoney_:getChildByName("gold_" .. i):moveTo{
            time = 0.15,
            x = 0,
            y = 0,
            delay = (i - 1) * 0.05,
            onComplete = callback
        }
    end
end

function JDNNHandInfo:payBets(targetPos, root)
    self.betMoney_:getChildByName("score_tf"):hide()
    for i = 1, 3 do
        local gold = self.betMoney_:getChildByName("gold_" .. i):hide()
        local srcPos = root:convertToNodeSpace(self.betMoney_:convertToWorldSpace(cc.p(gold:getPosition())))
        local tmpGold = display.newSprite("#MoneyImage.png"):move(srcPos):addTo(root)
        local destPos = root:convertToNodeSpace(targetPos)
        tmpGold:moveTo{
            time = 0.3,
            x = destPos.x,
            y = destPos.y,
            delay = (i - 1) * 0.05,
            removeSelf = true
        }
    end
end

function JDNNHandInfo:flipCards(callback)
    self:showNodeCard(true)
    for i, card in ipairs(self.cards_) do
        local callFunc = cc.CallFunc:create(function()
            local frame = getCardFrame(self.cardDatas_[i] or 0)
            card:loadTexture(frame, ccui.TextureResType.plistType)
            self.cardState_ = CardState.OPEN
        end)
        local seq = cc.Sequence:create(cc.OrbitCamera:create(0.35, 1, 0, 0, -92, 0, 0), callFunc, cc.OrbitCamera:create(0.35, 1, 0, 90, -90, 0, 0), callback and cc.CallFunc:create(callback) or nil)
        card:runAction(seq)
    end
end

function JDNNHandInfo:openCards(cardTyp)
    local function showOxTyp()
        self.imgOxType_:show()
        local ox = cardTyp.oxType
        self.imgOxType_:loadTexture(string.format("CowImage%d.png", ox >= 0x10 and 10 or ox), ccui.TextureResType.plistType)
    end
    if cardTyp.combine then
        self:loadCardDatas(cardTyp.combine)
    end
    -- dispatching
    if self.cardState_ == CardState.DISPATCH then
        self.cardTyp_ = cardTyp
    elseif self.cardState_ == CardState.COVER then
        self:flipCards(showOxTyp)
    else
        self:showCards(true)
        showOxTyp()
    end
end

function JDNNHandInfo:send(cards, delay, callback)
    self.cardState_ = CardState.DISPATCH
    self.cardTyp_ = nil
    self:loadCardDatas(cards)
    self:showNodeCard(true)
    self.imgOxType_:hide()
    for i, card in ipairs(self.cards_) do
        card:loadTexture(getCardFrame(0), ccui.TextureResType.plistType):hide()

        local mirrorCard = self.imgStart_:clone():addTo(self.nodeCard_)
        -- mirrorCard:setGlobalZOrder(1)
        local actionArr = {}
        local delay = cc.DelayTime:create(0.1 * (i - 1) + delay)
        table.insert(actionArr, delay)
        table.insert(actionArr, cc.Show:create())
        local moveTo = cc.MoveTo:create(0.3, self.cardsPos_[i])
        local scaleTo = cc.ScaleTo:create(0.3, self.cardsSca_[i])
        table.insert(actionArr, cc.Spawn:create(moveTo, scaleTo))
        table.insert(actionArr, cc.CallFunc:create(function()
            card:show()
            if i == #self.cards_ then
                self.cardState_ = CardState.COVER
                if self.cardTyp_ then
                    self:openCards(self.cardTyp_)
                end
            end
            if callback then
                callback()
            end
        end))
        table.insert(actionArr, cc.RemoveSelf:create())
        mirrorCard:runAction(cc.Sequence:create(actionArr))
    end
end
-------------------------------------------------------------------------------------------------------
local JDNNUserInfo = class("JDNNUserInfo")

function JDNNUserInfo:ctor(root)
    self.root_ = root

    self.pnlLog_ = self.root_:getChildByName("LogPanel")
    self.avatar_ = GameUtil.createAvatar("", 90, false, nil, nil, "img_avatar_1", false):addTo(self.pnlLog_)
    self.avatar_:move(self.pnlLog_:getChildByName("LogImage"):getPosition())
    self:show(false)
    self:showProfit(false)

    local spr = cc.Sprite:createWithSpriteFrameName("TimerImage.png")
    self.progress_ = cc.ProgressTimer:create(spr)
    self.progress_:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.progress_:setPosition(cc.p(spr:getPosition()))
    self.progress_:addTo(self.root_:getChildByName("TimerNode"))
    self.progress_:setReverseDirection(true)
    self.progress_:setPercentage(0)
end

function JDNNUserInfo:show(visible)
    self.root_:setVisible(visible)
end

local function setAvatar(self, avatar)
    self.avatar_:updateAvatar(avatar)
end

local function setName(self, name)
    local nickName = self.pnlLog_:getChildByName("NickName")
    nickName:setString(name)
    GameCMD.subText(nickName, 110, "..")
end

local function setScore(self, score)
    self.pnlLog_:getChildByName("Treasure"):setString(GameUtil.formatAsset(score))
end

function JDNNUserInfo:showReady(ready)
    self.root_:getChildByName("OkImage"):setVisible(ready)
    if ready then
        self:finishCD()
        self:showProfit(false)
    end
end

function JDNNUserInfo:showOffline(offline)
    self.root_:getChildByName("OfflineImage"):setVisible(offline)
end

function JDNNUserInfo:setProfit(profit)
    local bmf = self.root_:getChildByName("ResultBaseImage"):getChildByName("ResultNum")
    local fnt = profit >= 0 and GameCMD.RES_PREFIX .. "fonts/AddNum.fnt" or GameCMD.RES_PREFIX .. "fonts/SubNum.fnt"
    bmf:setFntFile(fnt)
    local str = GameUtil.formatAsset(profit, false)
    bmf:setString(profit >= 0 and "+" .. str or str)
end

function JDNNUserInfo:showProfit(show)
    self.root_:getChildByName("ResultBaseImage"):setVisible(show)
end

function JDNNUserInfo:updateData(data)
    if data.avatar then
        setAvatar(self, data.avatar)
    end
    if data.name then
        setName(self, data.name)
    end
    if data.score then
        setScore(self, data.score)
    end
end

function JDNNUserInfo:countDown(dt)
    self:finishCD()
    self.progress_:setPercentage(100)
    self.progress_:setColor(cc.WHITE)
    self.progress_:runAction(cc.Spawn:create(cc.ProgressTo:create(dt, 0), cc.TintTo:create(dt / 2, cc.RED)))
end

function JDNNUserInfo:finishCD()
    self.progress_:setPercentage(0)
    self.progress_:stopAllActions()
end

function JDNNUserInfo:playWinAnim()
    local anim = cc.CSLoader:createNode(GameCMD.RES_PREFIX .. "anim/LogAnim.csb")
    anim:move(self.pnlLog_:getPosition()):addTo(self.root_)
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PREFIX .. "anim/LogAnim.csb")
    action:gotoFrameAndPlay(0, false)
    anim:runAction(action)
    anim:runAction(cc.Sequence:create(cc.DelayTime:create(action:getDuration() / 60), cc.RemoveSelf:create()))
end

-------------------------------------------------------------------------------------------------------
local JDNNSeat = class("JDNNSeat")

function JDNNSeat:ctor(rootUser, rootHand)
    self.userInfo_ = JDNNUserInfo.new(rootUser)
    self.handInfo_ = JDNNHandInfo.new(rootHand)
    self.seatPos_ = rootUser:convertToWorldSpace(cc.p(rootUser:getAnchorPointInPoints()))

    self.chairId_ = nil
    self.bBanker_ = false
end

function JDNNSeat:clean()
    self:removeUser()
    self.handInfo_:showNodeCard(false)
    self.handInfo_:showBets(false)
end

function JDNNSeat:getChairId()
    return self.chairId_
end

function JDNNSeat:getPosition()
    return self.seatPos_
end

function JDNNSeat:setBanker(bBanker)
    self.bBanker_ = bBanker
end

function JDNNSeat:isBanker()
    return self.bBanker_
end

local function updateUserStatus(self, status)
    self.userInfo_:showReady(false)
    self.userInfo_:showOffline(false)
    if status == GameDefine.US_READY then
        self.userInfo_:showReady(true)
        self.handInfo_:showBets(false)
        self.handInfo_:showNodeCard(false)
    elseif status == GameDefine.US_OFFLINE then
        self.userInfo_:showOffline(true)
    end
end

function JDNNSeat:loadUser(gameUser)
    self.userInfo_:show(true)
    self.chairId_ = gameUser.wChairID
    self.userInfo_:updateData{
        avatar = gameUser.avatarURL,
        name = gameUser.szNickName,
        score = gameUser.lScore - gameUser.lTempScore
    }
    updateUserStatus(self, gameUser.cbUserStatus)
end

function JDNNSeat:updateUser(gameUser)
    self.userInfo_:show(true)
    self.userInfo_:updateData{
        score = gameUser.lScore - gameUser.lTempScore
    }
    updateUserStatus(self, gameUser.cbUserStatus)
end

function JDNNSeat:removeUser()
    self.userInfo_:show(false)
    self.userInfo_:showProfit(false)
    self.handInfo_:showBets(false)
    self.chairId_ = nil
end

function JDNNSeat:onGameStart(bankerChair)
    if self:getChairId() then
        self:setBanker(bankerChair == self.chairId_)
        self.userInfo_:showReady(false)
        if not self:isBanker() then
            self.userInfo_:countDown(GameCMD.TIME_USER_ADD_SCORE)
        end
        self.userInfo_:showProfit(false)
        self.handInfo_:showBets(false)
        self.handInfo_:showNodeCard(false)
    else
        self:clean()
    end
end

function JDNNSeat:onGameEnd(args)
    if not self:getChairId() then
        return
    end
    self.userInfo_:countDown(GameCMD.TIME_USER_FREE)
    self.userInfo_:showProfit(true)
    self.userInfo_:setProfit(args.profit)
    -- winner
    if args.revenu > 0 then
        self.userInfo_:playWinAnim()
    end
end

function JDNNSeat:loadUserCards(cards)
    self.handInfo_:loadCardDatas(cards)
end

function JDNNSeat:showHandCards(bOpen)
    self.handInfo_:showCards(bOpen)
end

function JDNNSeat:flipHandCards(callback)
    self.handInfo_:flipCards(callback)
end

function JDNNSeat:openHandCards(cardType)
    self.userInfo_:finishCD()
    self.handInfo_:openCards(cardType)
end

function JDNNSeat:addBets(bets, bAction)
    self.handInfo_:setBets(bets, bAction)
end

function JDNNSeat:sendCards(cards, delay, playSound, callback)
    self.userInfo_:countDown(GameCMD.TIME_USER_OPEN_CARD)
    local cnt = 0
    self.handInfo_:send(cards, delay, function()
        if playSound then
            JDNNSound.dispatchCard()
        end
        cnt = cnt + 1
        if cnt == GameCMD.MAX_CARD and callback then
            callback()
        end
    end)
end

function JDNNSeat:settleBets(bankerSeat, profit, root)
    if profit > 0 then
        self.handInfo_:winBets(bankerSeat:getPosition())
        for i = 1, 3 do
            local srcPos = root:convertToNodeSpace(bankerSeat:getPosition())
            local destPos = root:convertToNodeSpace(self:getPosition())
            local tmpGold = display.newSprite("#MoneyImage.png"):move(srcPos):addTo(root)
            tmpGold:moveTo{
                time = 0.3,
                x = destPos.x,
                y = destPos.y,
                delay = (i - 1) * 0.05,
                removeSelf = true
            }
        end
    elseif profit < 0 then
        self.handInfo_:payBets(bankerSeat:getPosition(), root)
    end
end

-------------------------------------------------------------------------------------------------------
local JDNNSeatManager = class("JDNNSeatManager")

local CHAIR_INDEX = {0, 2, 4, 6}

function JDNNSeatManager:ctor(root)
    self.root_ = root
    local nodeHand = self.root_:getChildByName("node_hand")
    local nodeUser = self.root_:getChildByName("node_user")
    self.seats_ = {}
    for k, seatId in pairs(GameCMD.SEAT) do
        local pnlHand = nodeHand:getChildByName("HandPanel" .. seatId)
        local pnlUser = nodeUser:getChildByName("UserPanel" .. seatId)
        self.seats_[seatId] = JDNNSeat.new(pnlUser, pnlHand)
    end
    self.imgBanker_ = nodeUser:getChildByName("BankerFlag"):hide()
end

function JDNNSeatManager:cleanUsers()
    for k, user in pairs(self.seats_) do
        user:clean()
    end
    self.imgBanker_:hide()
end

local function getAssignSeat(self, chairId)
    local ownerIndex = table.indexof(CHAIR_INDEX, globalUserInfo.wChairID)
    local targetIndex = table.indexof(CHAIR_INDEX, chairId)
    local seatId = (6 + targetIndex - ownerIndex) % 4 -- four persons
    return self.seats_[seatId]
end

local function getUserSeat(self, chairId)
    if chairId == globalUserInfo.wChairID then
        return self.seats_[GameCMD.SEAT.DOWN], GameCMD.SEAT.DOWN
    end
    for id, seat in pairs(self.seats_) do
        if seat:getChairId() == chairId then
            return seat, id
        end
    end
end

local function getBankerSeat(self)
    for k, seat in pairs(self.seats_) do
        if seat:isBanker() then
            return seat
        end
    end
end

local function setBankerFlag(self, seatId, anim)
    local nodeUser = self.root_:getChildByName("node_user")
    if anim then
        local rootSize = self.root_:getContentSize()
        self.imgBanker_:show():move(rootSize.width / 2, rootSize.height / 2):setScale(2)
        local actions = {}
        table.insert(actions, cc.ScaleTo:create(0.15, 1.0))
        table.insert(actions, cc.CallFunc:create(function()
            local particle = cc.ParticleSystemQuad:create(GameCMD.RES_PREFIX .. "anim/zhuangtuowei.plist")
            particle:setPositionType(0)
            local batch = cc.ParticleBatchNode:createWithTexture(particle:getTexture())
            batch:addChild(particle)
            batch:move(self.imgBanker_:getAnchorPointInPoints()):addTo(self.imgBanker_)
        end))
        local dest = cc.p(nodeUser:getChildByName("BankerPos" .. seatId):getPosition())
        table.insert(actions, cc.MoveTo:create(0.2, dest))
        table.insert(actions, cc.CallFunc:create(function()
            self.imgBanker_:removeAllChildren()
            local particle = cc.ParticleSystemQuad:create(GameCMD.RES_PREFIX .. "anim/zhuangboom.plist")
            local batch = cc.ParticleBatchNode:createWithTexture(particle:getTexture())
            batch:addChild(particle)
            batch:setScale(0.4)
            batch:move(self.imgBanker_:getAnchorPointInPoints()):addTo(self.imgBanker_)
            batch:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.RemoveSelf:create()))
        end))
        self.imgBanker_:runAction(cc.Sequence:create(actions))
    else
        self.imgBanker_:removeAllChildren()
        self.imgBanker_:stopAllActions()
        self.imgBanker_:move(nodeUser:getChildByName("BankerPos" .. seatId):getPosition()):show()
    end
end

function JDNNSeatManager:addUser(gameUser)
    local seat = getUserSeat(self, gameUser.wChairID)
    -- 有人
    if seat then
        if seat:getChairId() then
            seat:updateUser(gameUser)
        else
            seat:loadUser(gameUser)
        end
        return
    end
    seat = getAssignSeat(self, gameUser.wChairID)
    if not seat then
        dump("no free seat, chairId:" .. gameUser.wChairID)
        return
    end
    seat:loadUser(gameUser)
end

function JDNNSeatManager:removeUser(wChairID)
    local seat = getUserSeat(self, wChairID)
    -- 有人
    if seat then
        seat:removeUser()
    end
end

function JDNNSeatManager:updateUser(gameUser)
    local seat = getUserSeat(self, gameUser.wChairID)
    -- 有人
    if seat then
        seat:updateUser(gameUser)
    end
end

function JDNNSeatManager:openHandCards(chairId, cardType)
    local seat = getUserSeat(self, chairId)
    if seat then
        seat:openHandCards(cardType)
    end
end

function JDNNSeatManager:addBets(chairId, bets)
    local seat = getUserSeat(self, chairId)
    if seat then
        seat:addBets(bets, true)
    end
end

function JDNNSeatManager:loadSceneBets(args)
    for i = 1, GameCMD.GAME_PLAYER do
        local seat, id = getUserSeat(self, i - 1)
        if seat then
            if seat:getChairId() ~= args.wBankerUser then
                if args.lTableScore[i] > 0 then
                    seat:addBets(args.lTableScore[i], false)
                end
            else
                setBankerFlag(self, id)
                seat:setBanker(true)
            end
        end
    end
end

function JDNNSeatManager:loadScenePlay(userCards, cardTypes, args)
    for i = 1, GameCMD.GAME_PLAYER do
        local cards = userCards[i - 1]
        local seat, id = getUserSeat(self, i - 1)
        local bOxCard = args
        if cards and seat then
            seat:loadUserCards(cards)
            if args.bOxCard[i] == 1 or args.bOxCard[i] == 0 then
                seat:openHandCards(cardTypes[i - 1])
            else
                seat:showHandCards(i - 1 == globalUserInfo.wChairID)
            end
            if seat:getChairId() == args.wBankerUser then
                setBankerFlag(self, id)
                seat:setBanker(true)
            else
                if args.lTableScore[i] > 0 then
                    seat:addBets(args.lTableScore[i], false)
                end
            end
        end
    end
end

function JDNNSeatManager:dispatchCards(userCards, finishCall)
    local delay = 0
    local validIndex = 0
    local validCnt = 0
    for i = 1, GameCMD.GAME_PLAYER do
        local cards = userCards[i - 1]
        local seat = getUserSeat(self, i - 1)
        if cards and seat then
            validCnt = validCnt + 1
            local playSound = seat:getChairId() == globalUserInfo.wChairID
            seat:sendCards(cards, delay, playSound, function()
                validIndex = validIndex + 1
                if validIndex == validCnt and userCards[globalUserInfo.wChairID] then -- 自己在playing状态
                    self.seats_[GameCMD.SEAT.DOWN]:flipHandCards(finishCall)
                end
            end)
            -- delay = delay + #cards*0.05
        end
    end
end

--
function JDNNSeatManager:onGameStart(bankerChair)
    for id, seat in pairs(self.seats_) do
        seat:onGameStart(bankerChair)
        if seat:getChairId() == bankerChair then
            setBankerFlag(self, id, true)
            JDNNSound.playBank()
        end
    end
end

function JDNNSeatManager:onGameEnd(args)
    local ownerWin = false
    local bankerSeat = getBankerSeat(self)
    local nodeUser = self.root_:getChildByName("node_user")
    for id, seat in pairs(self.seats_) do
        local chairId = seat:getChairId()
        if chairId then
            local i = chairId + 1
            local params = {
                status = args.cbPlayStatus[i],
                revenu = args.revenu[i],
                profit = args.score[i]
            }
            seat:onGameEnd(params)
            if seat ~= bankerSeat then
                seat:settleBets(bankerSeat, params.profit, nodeUser)
            end
            if chairId == globalUserInfo.wChairID and params.revenu > 0 then
                ownerWin = true
            end
        end
    end
    if ownerWin then
        JDNNSound.playWin()
    else
        JDNNSound.playLose()
    end
end

return JDNNSeatManager
