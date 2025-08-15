--[[
TBNNSeatManager.lua
玩家管理
]] local GameCMD = require("game.tbnn.src.TBNNCMD")
local TBNNSound = require("game.tbnn.src.TBNNSound")

local TBNNHandCard = class("TBNNHandCard")

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

function TBNNHandCard:ctor(root)
    self.root_ = root

    self.cards_ = {}
    self.cardsPos_ = {}
    self.cardsSca_ = {}
    for i = 1, GameCMD.MAX_CARD do
        self.cards_[i] = self.root_:getChildByName("CardImage" .. i - 1)
        self.cardsPos_[i] = cc.p(self.cards_[i]:getPosition())
        self.cardsSca_[i] = self.cards_[i]:getScale()
    end
    self.imgOxType_ = self.root_:getChildByName("CardType")
    self.imgOxType_:hide()
    self.imgStart_ = self.root_:getChildByName("CardStart")

    self.cardDatas_ = {}
    self.cardState_ = CardState.NONE
end

function TBNNHandCard:show(visible)
    self.root_:setVisible(visible)
end

function TBNNHandCard:loadCardDatas(cards)
    self.cardDatas_ = cards
end

function TBNNHandCard:showCards(bOpen)
    self:show(true)
    for i, card in ipairs(self.cards_) do
        local frame = getCardFrame(bOpen and self.cardDatas_[i] or 0)
        card:loadTexture(frame, ccui.TextureResType.plistType)
    end
    if not bOpen then
        self.imgOxType_:hide()
    end
end

function TBNNHandCard:flipCards(callback)
    self:show(true)
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

function TBNNHandCard:openCards(cardTyp)
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

function TBNNHandCard:send(cards, delay, callback)
    self.cardState_ = CardState.DISPATCH
    self.cardTyp_ = nil
    self:loadCardDatas(cards)
    self:show(true)
    self.imgOxType_:hide()
    for i, card in ipairs(self.cards_) do
        card:loadTexture(getCardFrame(0), ccui.TextureResType.plistType):hide()

        local mirrorCard = self.imgStart_:clone():addTo(self.root_)
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
local TBNNUserInfo = class("TBNNUserInfo")

function TBNNUserInfo:ctor(root)
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

function TBNNUserInfo:show(visible)
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

function TBNNUserInfo:showReady(ready)
    self.root_:getChildByName("OkImage"):setVisible(ready)
    if ready then
        self:finishCD()
        self:showProfit(false)
    end
end

function TBNNUserInfo:showOffline(offline)
    self.root_:getChildByName("OfflineImage"):setVisible(offline)
end

function TBNNUserInfo:setProfit(profit)
    local bmf = self.root_:getChildByName("ResultBaseImage"):getChildByName("ResultNum")
    local fnt = profit >= 0 and GameCMD.RES_PREFIX .. "fonts/AddNum.fnt" or GameCMD.RES_PREFIX .. "fonts/SubNum.fnt"
    bmf:setFntFile(fnt)
    local str = GameUtil.formatAsset(profit, false)
    bmf:setString(profit >= 0 and "+" .. str or str)
end

function TBNNUserInfo:showProfit(show)
    self.root_:getChildByName("ResultBaseImage"):setVisible(show)
end

function TBNNUserInfo:updateData(data)
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

function TBNNUserInfo:countDown(dt)
    self:finishCD()
    self.progress_:setPercentage(100)
    self.progress_:setColor(cc.WHITE)
    self.progress_:runAction(cc.Spawn:create(cc.ProgressTo:create(dt, 0), cc.TintTo:create(dt / 2, cc.RED)))
end

function TBNNUserInfo:finishCD()
    self.progress_:setPercentage(0)
    self.progress_:stopAllActions()
end

function TBNNUserInfo:playWinAnim()
    local anim = cc.CSLoader:createNode(GameCMD.RES_PREFIX .. "anim/LogAnim.csb")
    anim:move(self.pnlLog_:getPosition()):addTo(self.root_)
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PREFIX .. "anim/LogAnim.csb")
    action:gotoFrameAndPlay(0, false)
    anim:runAction(action)
    anim:runAction(cc.Sequence:create(cc.DelayTime:create(action:getDuration() / 60), cc.RemoveSelf:create()))
end
-------------------------------------------------------------------------------------------------------
local TBNNSeat = class("TBNNSeat")

function TBNNSeat:ctor(rootUser, rootHand)
    self.userInfo_ = TBNNUserInfo.new(rootUser)
    self.handCard_ = TBNNHandCard.new(rootHand)
    self.handCard_:show(false)

    self.chairId_ = nil
end

function TBNNSeat:clean()
    self:removeUser()
    self.handCard_:show(false)
end

function TBNNSeat:getChairId()
    return self.chairId_
end

local function updateUserStatus(self, status)
    self.userInfo_:showReady(false)
    self.userInfo_:showOffline(false)
    if status == GameDefine.US_READY then
        self.userInfo_:showReady(true)
        self.handCard_:show(false)
    elseif status == GameDefine.US_OFFLINE then
        self.userInfo_:showOffline(true)
    end
end

function TBNNSeat:loadUser(gameUser)
    self.userInfo_:show(true)
    self.chairId_ = gameUser.wChairID
    self.userInfo_:updateData{
        avatar = gameUser.avatarURL,
        name = gameUser.szNickName,
        score = gameUser.lScore
    }
    updateUserStatus(self, gameUser.cbUserStatus)
end

function TBNNSeat:updateUser(gameUser)
    self.userInfo_:show(true)
    self.userInfo_:updateData{
        score = gameUser.lScore
    }
    updateUserStatus(self, gameUser.cbUserStatus)
end

function TBNNSeat:removeUser()
    self.userInfo_:show(false)
    self.userInfo_:showProfit(false)
    self.chairId_ = nil
end

function TBNNSeat:onGameStart()
    if self:getChairId() then
        self.userInfo_:showReady(false)
        self.userInfo_:countDown(GameCMD.TIME_USER_OPEN_CARD)
        self.userInfo_:showProfit(false)
    else
        self:clean()
    end
end

function TBNNSeat:onGameEnd(settle)
    if not self:getChairId() then
        return
    end
    self.userInfo_:countDown(GameCMD.TIME_USER_FREE)
    self.userInfo_:showProfit(true)
    self.userInfo_:setProfit(settle.profit)
    -- winner
    if settle.revenu > 0 then
        self.userInfo_:playWinAnim()
    end
end

function TBNNSeat:loadUserCards(cards)
    self.handCard_:loadCardDatas(cards)
end

function TBNNSeat:showHandCards(bOpen)
    self.handCard_:showCards(bOpen)
end

function TBNNSeat:flipHandCards(callback)
    self.handCard_:flipCards(callback)
end

function TBNNSeat:openHandCards(cardType)
    self.userInfo_:finishCD()
    self.handCard_:openCards(cardType)
end

function TBNNSeat:sendCards(cards, delay, playSound, callback)
    local cnt = 0
    self.handCard_:send(cards, delay, function()
        if playSound then
            TBNNSound.dispatchCard()
        end
        cnt = cnt + 1
        if cnt == GameCMD.MAX_CARD and callback then
            callback()
        end
    end)
end
-------------------------------------------------------------------------------------------------------
local TBNNSeatManager = class("TBNNSeatManager")

local SEAT_PRIORITY = {GameCMD.SEAT.TOP, GameCMD.SEAT.RIGHT_DOWN, GameCMD.SEAT.LEFT_DOWN, GameCMD.SEAT.RIGHT_TOP, GameCMD.SEAT.LEFT_TOP}

-- local function switchViewIndex(chairId, chairCnt)
--     --转换椅子
--     local wChairCount=chairCnt
--     local wMeChairID=globalUserInfo.wChairID--发牌位置
--     local wViewChairID=(chairId+wChairCount*3/2-wMeChairID)%wChairCount

--     local index = wViewChairID + 1
--     return index
-- end

-- local function getSeatId(self, chairId)
-- 	return switchViewIndex(chairId, 8)
-- end

function TBNNSeatManager:ctor(root)
    self.root_ = root
    local nodeCard = self.root_:getChildByName("node_card")
    local nodeUser = self.root_:getChildByName("node_user")
    self.seats_ = {}
    for k, seatId in pairs(GameCMD.SEAT) do
        local pnlHand = nodeCard:getChildByName("HandPanel" .. seatId)
        local pnlUser = nodeUser:getChildByName("UserPanel" .. seatId)
        self.seats_[seatId] = TBNNSeat.new(pnlUser, pnlHand)
    end
    self.pnlGoldMove_ = self.root_:getChildByName("node_top"):getChildByName("pnl_goldMove")
end

function TBNNSeatManager:cleanUsers()
    for k, user in pairs(self.seats_) do
        user:clean()
    end
end

local function getFreeSeat(self)
    for k, id in pairs(SEAT_PRIORITY) do
        if not self.seats_[id]:getChairId() then
            return self.seats_[id]
        end
    end
end

local function getUserSeat(self, chairId)
    if chairId == globalUserInfo.wChairID then
        return self.seats_[GameCMD.SEAT.DOWN]
    end
    for id, seat in pairs(self.seats_) do
        if seat:getChairId() == chairId then
            return seat, id
        end
    end
end

function TBNNSeatManager:addUser(gameUser)
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
    seat = getFreeSeat(self)
    if not seat then
        dump("no free seat, chairId:" .. gameUser.wChairID)
        return
    end
    seat:loadUser(gameUser)
end

function TBNNSeatManager:removeUser(wChairID)
    local seat = getUserSeat(self, wChairID)
    -- 有人
    if seat then
        seat:removeUser()
    end
end

function TBNNSeatManager:updateUser(gameUser)
    local seat = getUserSeat(self, gameUser.wChairID)
    -- 有人
    if seat then
        seat:updateUser(gameUser)
    end
end

function TBNNSeatManager:openHandCards(chairId, cardType)
    local seat = getUserSeat(self, chairId)
    if seat then
        seat:openHandCards(cardType)
    end
end

function TBNNSeatManager:loadCards(userCards, cardTypes, bOxCard)
    for i = 1, GameCMD.GAME_PLAYER do
        local cards = userCards[i - 1]
        local seat = getUserSeat(self, i - 1)
        if cards and seat then
            seat:loadUserCards(cards)
            if bOxCard[i] == 1 or bOxCard[i] == 0 then
                seat:openHandCards(cardTypes[i - 1])
            else
                seat:showHandCards(i - 1 == globalUserInfo.wChairID)
            end
        end
    end
end

function TBNNSeatManager:dispatchCards(userCards, finishCall)
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
                if validIndex == validCnt then
                    self.seats_[GameCMD.SEAT.DOWN]:flipHandCards(finishCall)
                end
            end)
            -- delay = delay + #cards*0.05
        end
    end
end

--
function TBNNSeatManager:onGameStart()
    for id, seat in pairs(self.seats_) do
        seat:onGameStart()
    end
end

local function userWin(self, seatId)
    local endPos = cc.p(self.pnlGoldMove_:getChildByName("node_move_" .. seatId):getPosition())
    for id, seat in pairs(self.seats_) do
        local chairId = seat:getChairId()
        if chairId and id ~= seatId then
            local baseStart = cc.p(self.pnlGoldMove_:getChildByName("node_move_" .. id):getPosition())
            local random = math.random(8, 15)
            for i = 1, random do
                local startPos = cc.pAdd(baseStart, cc.p(math.random(0, 80) - 40, math.random(0, 80) - 40))
                local icon = cc.Sprite:createWithSpriteFrameName("MoneyImage.png"):move(startPos):addTo(self.pnlGoldMove_, random - i)

                local targetPos = cc.pAdd(endPos, cc.p(math.random(0, 80) - 40, math.random(0, 80) - 40))
                local actions = {}
                table.insert(actions, cc.DelayTime:create((i - 1) * 0.04))
                table.insert(actions, cc.MoveTo:create(0.4, targetPos))
                table.insert(actions, cc.FadeOut:create(1))
                table.insert(actions, cc.RemoveSelf:create())
                icon:runAction(cc.Sequence:create(actions))
            end
        end
    end
end

function TBNNSeatManager:onGameEnd(args)
    local winner
    for id, seat in pairs(self.seats_) do
        local chairId = seat:getChairId()
        if chairId then
            local i = chairId + 1
            local settle = {
                status = args.cbPlayStatus[i],
                revenu = args.revenu[i],
                profit = args.score[i]
            }
            seat:onGameEnd(settle)
            if settle.revenu > 0 then
                winner = id
            end
        end
    end
    userWin(self, winner)
    if self.seats_[winner]:getChairId() == globalUserInfo.wChairID then
        TBNNSound.playWin()
    else
        TBNNSound.playLose()
    end
end

return TBNNSeatManager
