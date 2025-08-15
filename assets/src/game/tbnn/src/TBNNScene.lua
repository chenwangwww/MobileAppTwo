--[[
TBNNScene.lua
通比牛牛
]] local GameCMD = require("game.tbnn.src.TBNNCMD")
local GameMessage = require("game.tbnn.src.TBNNMessage")
local TBNNLogic = require("game.tbnn.src.TBNNLogic")
local TBNNSound = require("game.tbnn.src.TBNNSound")

local TBNNSeatManager = require("game.tbnn.src.panel.TBNNSeatManager")
local TBNNOperate = require("game.tbnn.src.panel.TBNNOperate")
local TBNNStatus = require("game.tbnn.src.panel.TBNNStatus")
local TBNNMenu = require("game.tbnn.src.panel.TBNNMenu")
local TBNNSetting = require("game.tbnn.src.panel.TBNNSetting")

local TBNNScene = class("TBNNScene", require("app.views.base.BaseGameScene"))

local TRUSTEE_ACTION_TAG = 0x10

local function updateTimeStamp(self)
    self.timeStamp_ = os.time()
end

local function initUI(self)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PREFIX .. "Scene.csb")
    self.root_:addTo(self)

    self.imgBg_ = self.root_:getChildByName("img_bg"):move(display.center)
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)

    self.pnlTop_ = self.imgBg_:getChildByName("node_top"):show()
    self.pnlBase_ = self.imgBg_:getChildByName("node_base")
    updateTimeStamp(self)
end

function TBNNScene:onCreate()
    TBNNScene.super.onCreate(self)

    initUI(self)
    self.seatMngr_ = TBNNSeatManager.new(self.imgBg_)
    self.operate_ = TBNNOperate.new(self.imgBg_:getChildByName("node_operate"))
    self.status_ = TBNNStatus.new(self.imgBg_:getChildByName("node_status"))
    self.menu_ = TBNNMenu.new(self.pnlTop_:getChildByName("node_menu"))
    self:addTouchEvent()

    self.logic_ = TBNNLogic.new()

    self.leftTime_ = 0
    self.isTrustee_ = false -- 托管
    self.operate_:showTrustee(self.isTrustee_)
    self:showWaitForMatch(false)
    self:showRules(false)

    self:setTableScore(1)
end

-- 进入场景完成
function TBNNScene:onEnterTransitionFinish()
    TBNNScene.super.onEnterTransitionFinish(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    self:addEvent()
    TBNNSound.playBGM()

    self.schedulerTick_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.tick), 1.0, false)
end

function TBNNScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function TBNNScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

function TBNNScene:onExit()
    TBNNScene.super.onExit(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT)
    TBNNSound.stopBGM()

    self:removeEvent()
    if self.schedulerTick_ then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerTick_)
        self.schedulerTick_ = nil
    end

    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

local function onReturn(self)
    if PlazaManager.curGameType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
        if self.status_:getState() ~= GameCMD.GS_TK_FREE and self.status_:getState() ~= GameCMD.SUB_S_GAME_END then
            PlazaManager.showConfirmNode("yes_no", "是否强制退出游戏!", nil, function(rlt)
                if rlt then
                    GameMessage.sendLeave()
                end
            end)
        else
            GameMessage.sendLeave()
        end
    else
        -- TODO:
    end
end

local function openCard(self)
    local cardType = self.logic_:getCardType(globalUserInfo.wChairID)
    GameMessage.sendOpenCard(cardType.oxType == GameCMD.OxType.NONE and 0 or 1)
end

local function sendReady(self)
    GameMessage.sendReady()
    self.operate_:setState(TBNNOperate.State.READY)
end

local function autoOperate(self, delay)
    if not self.isTrustee_ then
        return
    end
    local state = self.operate_:getState()
    if state == TBNNOperate.State.FREE then
        self.operate_:showReady(false)
    elseif state == TBNNOperate.State.COVER then
        self.operate_:showOpenCard(false)
    else
        return
    end
    local callFunc = function()
        local state = self.operate_:getState()
        if state == TBNNOperate.State.FREE then
            sendReady(self)
        elseif state == TBNNOperate.State.COVER then
            openCard(self)
        end
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(delay or 0), cc.CallFunc:create(callFunc))
    seq:setTag(TRUSTEE_ACTION_TAG)
    self.root_:runAction(seq)
end

function TBNNScene:addTouchEvent()
    self.menu_:addClickCallback(function(menuTyp)
        if menuTyp == TBNNMenu.Type.CHANGE_TAB then
            self:ChangeRoom()
        elseif menuTyp == TBNNMenu.Type.SETTING then
            TBNNSetting:show(self)
        elseif menuTyp == TBNNMenu.Type.RULE then
            self:showRules(true)
        elseif menuTyp == TBNNMenu.Type.RETURN then
            if self:isDisConnect() == true then
                self:onExitGame()
            else
                onReturn(self)
            end
        end
    end)
    self.operate_:addClickCallback(function(opType, ...)
        if TBNNOperate.Type.READY == opType then
            sendReady(self)
        elseif TBNNOperate.Type.OPEN_CARD == opType then
            openCard(self)
        elseif TBNNOperate.Type.AUTO == opType then
            self.isTrustee_ = not self.isTrustee_
            self.operate_:showTrustee(self.isTrustee_)
            autoOperate(self)
        end
    end)
    local pnlRule = self.pnlTop_:getChildByName("pnl_rule")
    pnlRule:getChildByName("btn_close"):addClickEventListener(function()
        self:showRules(false)
    end)
end

function TBNNScene:tick()
    local interval = os.time() - self.timeStamp_
    local delta = self.leftTime_ - interval
    delta = delta < 0 and 0 or delta

    self.status_:updateTime(delta)
end

function TBNNScene:showWaitForMatch(waiting)
    local pnlWait = self.pnlTop_:getChildByName("pnl_wait")
    pnlWait:hide()
    pnlWait:getChildByName("WaitRotateImage"):stopAllActions()
    if waiting then
        pnlWait:show()
        local rotateBy = cc.RotateBy:create(1.0, 360)
        local repForver = cc.RepeatForever:create(rotateBy)
        pnlWait:getChildByName("WaitRotateImage"):runAction(repForver)
    end
end

function TBNNScene:showRules(visible)
    self.pnlTop_:getChildByName("pnl_rule"):setVisible(visible)
end

function TBNNScene:setTableScore(tabScore)
    local str = string.format("-底分%s-", GameUtil.formatAsset(tabScore, false))
    self.pnlBase_:getChildByName("bmf_baseScore"):setString(str)
end
--------------------------------------------------------------------------------------------
-- 游戏总结束
function TBNNScene:onPersonalEnd(data)
    -- dump(data)
end

function TBNNScene:onShowRoomInfo(info)
    -- dump(info)
end

-- 玩家坐下
function TBNNScene:onUserSitDown(gameUser)
    self.seatMngr_:addUser(gameUser)
end

-- 玩家准备
function TBNNScene:onUserReady(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家站起
function TBNNScene:onUserStandup(wChairID)
    -- dump(wChairID)
    self.seatMngr_:removeUser(wChairID)
end

-- 玩家掉线
function TBNNScene:onUserOffline(gameUser)
    -- dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家游戏
function TBNNScene:onUserPlaying(gameUser)
    -- --dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家积分改变
function TBNNScene:onUserScore(gameUser)
    -- --dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

function TBNNScene:onChangeRoomSucc()
    self.root_:stopActionByTag(TRUSTEE_ACTION_TAG)
    self.seatMngr_:cleanUsers()
end
--------------------------------------------------------------------------------------------
local function onSceneFree(self, data)
    local params = GameMessage.onSceneFree(data)
    -- dump(params, "场景空闲GS_TK_FREE")

    self.leftTime_ = GameCMD.TIME_USER_FREE
    updateTimeStamp(self)
    self.status_:setState(GameCMD.GS_TK_FREE)
    self.operate_:showReady(true)
    self.operate_:setState(TBNNOperate.State.FREE)

    autoOperate(self)
end

local function onSceneCallBank(self, data)

end

local function onSceneAddScore(self, data)
    -- body
end

local function onScenePlay(self, data)
    local params = GameMessage.onScenePlay(data)
    -- dump(params, "场景游戏GS_TK_PLAYING")
    self.logic_:loadScenePlayData(params)

    self.leftTime_ = GameCMD.TIME_USER_OPEN_CARD
    updateTimeStamp(self)
    self.status_:setState(GameCMD.SUB_S_OPEN_CARD)
    self.operate_:showReady(false)
    -- self.seatMngr_:setBetScores(params.lTableScore)
    self:setTableScore(self.logic_:getTableScore())
    self.seatMngr_:loadCards(self.logic_:getUserCards(), self.logic_:getCardTypes(), params.bOxCard)
    local isOpen = params.bOxCard[globalUserInfo.wChairID + 1] <= 1
    local isPlaying = params.cbPlayStatus[globalUserInfo.wChairID + 1] > 0
    if isPlaying then
        self.operate_:setState(isOpen and TBNNOperate.State.OPENED or TBNNOperate.State.COVER)
        self.operate_:showOpenCard(not isOpen)
        autoOperate(self)
    end
end

-- 场景消息
function TBNNScene:onGameScene(data)
    if self.gameDisConnection == true then
        -- 重置基类数据
        self:onResetData()
        -- 清除头像数据
        self:autoSitDown()
    end

    local gameStatus = PlazaManager.gameStatus.cbGameStatus
    if gameStatus == GameCMD.GS_TK_FREE then
        onSceneFree(self, data)
    elseif gameStatus == GameCMD.GS_TK_CALL then
        onSceneCallBank(self, data)
    elseif gameStatus == GameCMD.GS_TK_SCORE then
        onSceneAddScore(self, data)
    elseif gameStatus == GameCMD.GS_TK_PLAYING then
        onScenePlay(self, data)
    end
end
------------------------------------------------------------------
local function onSubGameStart(self, data)
    local params = GameMessage.onSubGameStart(data)
    -- dump(params, "游戏开始SUB_S_GAME_START")
    self.logic_:loadGameStartData(params)

    self.leftTime_ = GameCMD.TIME_USER_OPEN_CARD
    updateTimeStamp(self)
    self:setTableScore(self.logic_:getTableScore())
    self.status_:setState(GameCMD.SUB_S_OPEN_CARD)
    self.operate_:onGameStart()
    self.seatMngr_:onGameStart()

    -- show open opreate
    self.seatMngr_:dispatchCards(self.logic_:getUserCards(), function()
        if self.operate_:getState() == TBNNOperate.State.DISPATCH then
            self.operate_:setState(TBNNOperate.State.COVER)
            self.operate_:showOpenCard(true)
            autoOperate(self, math.random(5, 25) / 10)
        end
    end)
    TBNNSound.playStart()
end

local function onSubAddScore(self, data)
    -- body
end

local function onSubSendCard(self, data)
    -- body
end

local function onSubGameEnd(self, data)
    local params = GameMessage.onSubGameEnd(data)
    -- dump(params, "游戏结束SUB_S_GAME_END")

    self.status_:setState(GameCMD.SUB_S_GAME_END)
    self.operate_:onGameEnd()
    self.seatMngr_:onGameEnd(params)

    autoOperate(self, math.random(2, 3))
end

local function onSubOpenCard(self, data)
    local params = GameMessage.onSubOpenCard(data)
    -- dump(params, "开牌SUB_S_OPEN_CARD")

    local cardTyp = self.logic_:getCardType(params.wChairID)
    if globalUserInfo.wChairID == params.wChairID then
        self.operate_:setState(TBNNOperate.State.OPENED)
        self.operate_:showOpenCard(false)
    end
    self.seatMngr_:openHandCards(params.wChairID, cardTyp)
    TBNNSound.playBull(cardTyp.oxType)
end

local function onSubCallBanker(self, data)
    -- body
end

local function onSubPassBanker(self, data)
    -- body
end

-- 游戏消息
function TBNNScene:onGame(cmdID, data)
    local parseFunc = {
        [GameCMD.SUB_S_GAME_START] = onSubGameStart,
        [GameCMD.SUB_S_ADD_SCORE] = onSubAddScore,
        [GameCMD.SUB_S_SEND_CARD] = onSubSendCard,
        [GameCMD.SUB_S_GAME_END] = onSubGameEnd,
        [GameCMD.SUB_S_OPEN_CARD] = onSubOpenCard,
        [GameCMD.SUB_S_CALL_BANKER] = onSubCallBanker,
        [GameCMD.SUB_S_PASS_BANKER] = onSubPassBanker
    }
    if not parseFunc[cmdID] then
        dump("un define cmd id:" .. cmdID)
        return
    end
    parseFunc[cmdID](self, data)
end

return TBNNScene
