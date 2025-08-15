--[[
JDNNScene.lua
通比牛牛
]] local GameCMD = require("game.jdnn.src.JDNNCMD")
local GameMessage = require("game.jdnn.src.JDNNMessage")
local JDNNLogic = require("game.jdnn.src.JDNNLogic")
local JDNNSound = require("game.jdnn.src.JDNNSound")

local JDNNSeatManager = require("game.jdnn.src.panel.JDNNSeatManager")
local JDNNOperate = require("game.jdnn.src.panel.JDNNOperate")
local JDNNStatus = require("game.jdnn.src.panel.JDNNStatus")
local JDNNMenu = require("game.jdnn.src.panel.JDNNMenu")
local JDNNSetting = require("game.jdnn.src.panel.JDNNSetting")

local JDNNScene = class("JDNNScene", require("app.views.base.BaseGameScene"))

local TRUSTEE_ACTION_TAG = 0x10

local TipTag = {
    SELECT_CHIP = "SelectChip.png",
    WAIT_BET = "WaitAddScore.png",
    WAIT_NEXT_ROUND = "WaitNextRound.png"
}

local function updateTimeStamp(self)
    self.timeStamp_ = os.time()
end

local function initUI(self)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PREFIX .. "Scene.csb")
    self.root_:addTo(self)
    self.timeStamp_ = os.time()
    self.root_:getChildByName("img_bg"):move(display.center)
    self.panel_ = self.root_:getChildByName("panel")
    local bgSize = self.panel_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.panel_:setScale(scale)

    self.pnlTop_ = self.panel_:getChildByName("node_top"):show()
    self.pnlBase_ = self.panel_:getChildByName("node_base")
    self.pnlBase_:getChildByName("img_tip"):ignoreContentAdaptWithSize(true)
end

function JDNNScene:onCreate()
    JDNNScene.super.onCreate(self)

    initUI(self)
    self.seatMngr_ = JDNNSeatManager.new(self.panel_)
    self.operate_ = JDNNOperate.new(self.panel_:getChildByName("node_operate"))
    self.status_ = JDNNStatus.new(self.panel_:getChildByName("node_status"))
    self.menu_ = JDNNMenu.new(self.pnlTop_:getChildByName("node_menu"))
    self:addTouchEvent()

    self.logic_ = JDNNLogic.new()

    self.leftTime_ = 0
    self.isTrustee_ = false -- 托管
    self.autoBetRate_ = 1
    self.operate_:showTrustee(self.isTrustee_)
    self:showRules(false)
    self:showTips(false)
    self:showAuto(false)
end

-- 进入场景完成
function JDNNScene:onEnterTransitionFinish()
    JDNNScene.super.onEnterTransitionFinish(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    self:addEvent()
    JDNNSound.playBGM()

    self.schedulerTick_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.tick), 1.0, false)
end

function JDNNScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function JDNNScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

function JDNNScene:onExit()
    JDNNScene.super.onExit(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT)
    JDNNSound.stopBGM()

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
    self.operate_:setState(JDNNOperate.State.READY)
end

local function addScore(self, lScore)
    GameMessage.sendAddCard(lScore)
end

local function autoOperate(self, delay)
    if not self.isTrustee_ then
        return
    end
    local state = self.operate_:getState()
    if state == JDNNOperate.State.FREE then
        self.operate_:showReady(false)
    elseif state == JDNNOperate.State.COVER then
        self.operate_:showOpenCard(false)
    elseif state == JDNNOperate.State.ADD_SCORE then
        self.operate_:showAddScore(false)
        if self.logic_:getBankerChairId() == globalUserInfo.wChairID then
            return
        end
    else
        return
    end
    local callFunc = function()
        local state = self.operate_:getState()
        if state == JDNNOperate.State.FREE then
            sendReady(self)
        elseif state == JDNNOperate.State.COVER then
            openCard(self)
        elseif state == JDNNOperate.State.ADD_SCORE then
            local lmtScore = self.logic_:getLimitBetScore()
            addScore(self, math.ceil(lmtScore / self.autoBetRate_)) -- min
        end
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(delay or 0), cc.CallFunc:create(callFunc))
    seq:setTag(TRUSTEE_ACTION_TAG)
    self.root_:runAction(seq)
end

local function addAutoTouch(self)
    local function autoTouch(rate)
        self:showAuto(false)
        self.autoBetRate_ = rate
        self.isTrustee_ = not self.isTrustee_
        self.operate_:showTrustee(self.isTrustee_, self.autoBetRate_)
        autoOperate(self)
    end
    local pnlAuto = self.pnlTop_:getChildByName("pnl_auto")
    pnlAuto:getChildByName("btnClose"):addClickEventListener(function()
        self:showAuto(false)
    end)
    for i = 1, 4 do
        pnlAuto:getChildByName("btnBet" .. i):addClickEventListener(function()
            autoTouch(2 ^ (i - 1))
        end)
    end
    pnlAuto:getChildByName("btnRandom"):addClickEventListener(function()
        autoTouch(2 ^ (math.random(1, 4) - 1))
    end)
end

function JDNNScene:addTouchEvent()
    self.menu_:addClickCallback(function(menuTyp)
        if menuTyp == JDNNMenu.Type.CHANGE_TAB then
            self:ChangeRoom()
        elseif menuTyp == JDNNMenu.Type.SETTING then
            JDNNSetting:show(self)
        elseif menuTyp == JDNNMenu.Type.RULE then
            self:showRules(true)
        elseif menuTyp == JDNNMenu.Type.RETURN then
            if self:isDisConnect() == true then
                self:onExitGame()
            else
                onReturn(self)
            end
        end
    end)
    self.operate_:addClickCallback(function(opType, ...)
        if JDNNOperate.Type.READY == opType then
            sendReady(self)
        elseif JDNNOperate.Type.OPEN_CARD == opType then
            openCard(self)
        elseif JDNNOperate.Type.AUTO == opType then
            if self.isTrustee_ then
                self.isTrustee_ = not self.isTrustee_
                self.operate_:showTrustee(self.isTrustee_)
                autoOperate(self)
            else
                self:showAuto(true)
            end
        elseif JDNNOperate.Type.ADD_SCORE == opType then
            local lmtScore = self.logic_:getLimitBetScore()
            local divisor = ...
            addScore(self, math.ceil(lmtScore / divisor))
            self.operate_:showAddScore(false)
        end
    end)
    local pnlRule = self.pnlTop_:getChildByName("pnl_rule")
    pnlRule:getChildByName("btn_close"):addClickEventListener(function()
        self:showRules(false)
    end)

    addAutoTouch(self)
end

function JDNNScene:tick()
    local interval = os.time() - self.timeStamp_
    local delta = self.leftTime_ - interval
    delta = delta < 0 and 0 or delta

    self.status_:updateTime(delta)
end

function JDNNScene:showRules(visible)
    self.pnlTop_:getChildByName("pnl_rule"):setVisible(visible)
end

function JDNNScene:showAuto(visible)
    self.pnlTop_:getChildByName("pnl_auto"):setVisible(visible)
end

function JDNNScene:showTips(visible, tipTag)
    if visible then
        self.pnlBase_:getChildByName("img_tip"):loadTexture(tipTag, ccui.TextureResType.plistType):show()
    else
        self.pnlBase_:getChildByName("img_tip"):hide()
    end
end

--------------------------------------------------------------------------------------------
-- 游戏总结束
function JDNNScene:onPersonalEnd(data)
    -- dump(data)
end

function JDNNScene:onShowRoomInfo(info)
    -- dump(info)
end

-- 玩家坐下
function JDNNScene:onUserSitDown(gameUser)
    self.seatMngr_:addUser(gameUser)
end

-- 玩家准备
function JDNNScene:onUserReady(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家站起
function JDNNScene:onUserStandup(wChairID)
    -- dump(wChairID)
    self.seatMngr_:removeUser(wChairID)
end

-- 玩家掉线
function JDNNScene:onUserOffline(gameUser)
    -- dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家游戏
function JDNNScene:onUserPlaying(gameUser)
    -- --dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

-- 玩家积分改变
function JDNNScene:onUserScore(gameUser)
    -- --dump(gameUser)
    self.seatMngr_:updateUser(gameUser)
end

function JDNNScene:onChangeRoomSucc()
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
    self.operate_:setState(JDNNOperate.State.FREE)

    autoOperate(self)
end

local function onSceneCallBank(self, data)
    local params = GameMessage.onSceneCallBank(data)
    -- dump(params, "场景叫庄GS_TK_CALL")

    self.leftTime_ = GameCMD.TIME_USER_CALL_BANKER
    updateTimeStamp(self)
    self.status_:setState(GameCMD.GS_TK_CALL)

    self.operate_:showReady(false)
    if params.wCallBanker == globalUserInfo.wChairID then
        GameMessage.sendCallBanker(true)
    end
end

local function onSceneAddScore(self, data)
    local params = GameMessage.onSceneAddScore(data)
    -- dump(params, "场景加注GS_TK_SCORE")
    self.logic_:loadSceneAddScore(params)

    self.leftTime_ = GameCMD.TIME_USER_ADD_SCORE
    updateTimeStamp(self)
    self.status_:setState(GameCMD.SUB_S_ADD_SCORE)
    self.operate_:showReady(false)

    self.seatMngr_:loadSceneBets(params)
    local isPlaying = params.cbPlayStatus[globalUserInfo.wChairID + 1] > 0
    if isPlaying then
        if params.wBankerUser ~= globalUserInfo.wChairID then
            -- not bet yet
            if params.lTableScore[globalUserInfo.wChairID + 1] <= 0 then
                self.operate_:showAddScore(true, self.logic_:getLimitBetScore())
                self:showTips(true, TipTag.SELECT_CHIP)
            end
        else
            self:showTips(true, TipTag.WAIT_BET)
        end
        autoOperate(self)
    else
        self:showTips(true, TipTag.WAIT_NEXT_ROUND)
    end
end

local function onScenePlay(self, data)
    local params = GameMessage.onScenePlay(data)
    -- dump(params, "场景游戏GS_TK_PLAYING")
    self.logic_:loadScenePlayData(params)

    self.leftTime_ = GameCMD.TIME_USER_OPEN_CARD
    updateTimeStamp(self)
    self.status_:setState(GameCMD.SUB_S_OPEN_CARD)
    self.operate_:showReady(false)

    self.seatMngr_:loadScenePlay(self.logic_:getUserCards(), self.logic_:getCardTypes(), params)
    local isOpen = params.bOxCard[globalUserInfo.wChairID + 1] <= 1
    local isPlaying = params.cbPlayStatus[globalUserInfo.wChairID + 1] > 0
    if isPlaying then
        self.operate_:setState(isOpen and JDNNOperate.State.OPENED or JDNNOperate.State.COVER)
        self.operate_:showOpenCard(not isOpen)
        autoOperate(self)
    else
        self:showTips(true, TipTag.WAIT_NEXT_ROUND)
    end
end

-- 场景消息
function JDNNScene:onGameScene(data)
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

    self.leftTime_ = GameCMD.TIME_USER_ADD_SCORE
    updateTimeStamp(self)
    self.status_:setState(GameCMD.SUB_S_ADD_SCORE)
    self:showTips(true, params.wBankerUser == globalUserInfo.wChairID and TipTag.WAIT_BET or TipTag.SELECT_CHIP)
    self.operate_:onGameStart()
    self.seatMngr_:onGameStart(params.wBankerUser)

    if params.wBankerUser ~= globalUserInfo.wChairID then
        self.operate_:showAddScore(true, self.logic_:getLimitBetScore())
        autoOperate(self)
    end
end

local function onSubAddScore(self, data)
    local params = GameMessage.onSubAddScore(data)
    -- dump(params, "加注SUB_S_ADD_SCORE")

    self.seatMngr_:addBets(params.wChairID, params.lScore)
    if params.wChairID == globalUserInfo.wChairID then
        self.operate_:showAddScore(false)
        self:showTips(false)
    end
end

local function onSubSendCard(self, data)
    local params = GameMessage.onSubSendCard(data)
    -- dump(params, "发牌SUB_S_SEND_CARD")
    self.logic_:loadSendCardData(params)

    self.leftTime_ = GameCMD.TIME_USER_OPEN_CARD
    updateTimeStamp(self)
    self.status_:setState(GameCMD.SUB_S_OPEN_CARD)
    self.operate_:setState(JDNNOperate.State.DISPATCH)

    local cbPlayStatus = self.logic_:getPlayStatus()
    self:showTips(cbPlayStatus[globalUserInfo.wChairID + 1] == GameCMD.USER_STATUS.NULL, TipTag.WAIT_NEXT_ROUND)
    -- show open opreate
    self.seatMngr_:dispatchCards(self.logic_:getUserCards(), function()
        if self.operate_:getState() == JDNNOperate.State.DISPATCH then
            self.operate_:setState(JDNNOperate.State.COVER)
            self.operate_:showOpenCard(true)
            autoOperate(self, math.random(5, 25) / 10)
        end
    end)
    JDNNSound.playStart()
end

local function onSubGameEnd(self, data)
    local params = GameMessage.onSubGameEnd(data)
    -- dump(params, "游戏结束SUB_S_GAME_END")

    self.status_:setState(GameCMD.SUB_S_GAME_END)
    self:showTips(false)
    self.operate_:onGameEnd()
    self.seatMngr_:onGameEnd(params)

    autoOperate(self, math.random(2, 3))
end

local function onSubOpenCard(self, data)
    local params = GameMessage.onSubOpenCard(data)
    -- dump(params, "开牌SUB_S_OPEN_CARD")

    local cardTyp = self.logic_:getCardType(params.wChairID)
    if globalUserInfo.wChairID == params.wChairID then
        self.operate_:setState(JDNNOperate.State.OPENED)
        self.operate_:showOpenCard(false)
    end
    self.seatMngr_:openHandCards(params.wChairID, cardTyp)
    JDNNSound.playBull(cardTyp.oxType)
end

local function onSubCallBanker(self, data)
    local params = GameMessage.onSubCallBanker(data)
    -- dump(params, "叫庄SUB_S_CALL_BANKER")

    if params.wCallBanker == globalUserInfo.wChairID then
        GameMessage.sendCallBanker(true)
    end
end

local function onSubPassBanker(self, data)
    -- body
end

-- 游戏消息
function JDNNScene:onGame(cmdID, data)
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

return JDNNScene
