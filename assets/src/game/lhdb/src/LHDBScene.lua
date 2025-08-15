local GameMessage = require("game.lhdb.src.LHDBMessage")
local GameCMD = require("game.lhdb.src.LHDBCMD")

local LHDBLogic = require("game.lhdb.src.LHDBLogic")
local LHDBGate = require("game.lhdb.src.panel.LHDBGate")
local LHDBBet = require("game.lhdb.src.panel.LHDBBet")
local LHDBBetInfo = require("game.lhdb.src.panel.LHDBBetInfo")
local LHDBCenter = require("game.lhdb.src.panel.LHDBCenter")
local LHDBMenu = require("game.lhdb.src.panel.LHDBMenu")
local LHDBRule = require "game.lhdb.src.panel.LHDBRule"
local LHDBSetting = require "game.lhdb.src.panel.LHDBSetting"
local LHDBGoldPool = require "game.lhdb.src.panel.LHDBGoldPool"
local LHDBTBLayer = require "game.lhdb.src.panel.LHDBTBLayer"
local LHDBReward = require "game.lhdb.src.panel.LHDBReward"

local LHDBSound = require("game.lhdb.src.LHDBSound")
local LHDBUtil = require "game.lhdb.src.LHDBUtil"

local LHDBScene = class("LHDBScene", require("app.views.base.BaseGameScene"))

local GameState = {
    SEND = 0,
    REPLY = 1,
    FINISH = 2
}

local function initUI(self)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "LHDBScene.csb")
    self.root_:addTo(self)

    self.imgBg_ = self.root_:getChildByName("img_bg")
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)
end

local function removeConfirmNode()
    local runningScene = display.getRunningScene()
    if runningScene:getChildByName("WaiteFreeConfirm") then
        runningScene:removeChildByName("WaiteFreeConfirm")
    end
    if runningScene:getChildByName("StandUpConfirm") then
        runningScene:removeChildByName("StandUpConfirm")
    end
end

local function overtimeReconnect(self, open)
    self.root_:stopActionByTag(0xaa)
    if not open then
        return
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(8.0), cc.CallFunc:create(function()
        self:refreshGame()
    end))
    seq:setTag(0xaa)
    self.root_:runAction(seq)
end

local function sendNewGame(self)
    overtimeReconnect(self, true)
    GameMessage.sendNewGame()
end

local function gemEventCallback(self, event, ...)
    local function handleFinish()
        table.remove(self.cacheSubGameData_, 1)
        if next(self.cacheSubGameData_) then
            self:doSubNextGame(self.cacheSubGameData_[1])
        else
            local dt = 1.0 / self.bet_:getSpeedFactor()
            self:runAction(cc.Sequence:create(cc.DelayTime:create(dt), cc.CallFunc:create(function()
                self.gameState_ = GameState.FINISH
                self.bet_:autoBet()
            end)))
        end
    end
    local function newGameRound()
        self.betInfo_:setOwnerGold(self.logic_:getScore())
        self.betInfo_:setTotalBet(self.logic_:getTotalBet())
        if self.logic_:getLockBox() <= 0 then
            local nxtGate = self.logic_:getGate() + 1
            self:openNewGateCeremony(nxtGate, function(oper)
                self.gate_:setGate(nxtGate)
                if oper == "DoorClosed" then
                    LHDBSound.closeDoor()

                    if nxtGate >= 4 then
                        -- self.bet_:resetBet()
                        self.center_:cleanGems()
                        self.gameState_ = GameState.FINISH
                        -- 第四关
                        local params = {}
                        params.total = self.logic_:getTotalBall()
                        params.lottery = self.logic_:getLotteryBall()
                        params.bet = self.logic_:getTotalBet()
                        params.score = self.logic_:getScore()
                        params.pool = self.logic_:getGoldPool()
                        params.finishCall = handler(self, sendNewGame)
                        LHDBTBLayer:show(self, params)

                        self.cachebetLines_ = {self.bet_:getBetAndLines()}
                    end
                elseif oper == "DoorOpen" then
                    LHDBSound.openDoor()
                else
                    -- tb gate 
                    if nxtGate >= 4 then
                        return
                    end
                    handleFinish()
                end
            end)
        else
            handleFinish()
        end
    end
    local function showReward(callback, ...)
        local winScore = ...
        local betCnt, lines = self.bet_:getBetAndLines()
        local betScore = betCnt * lines
        if winScore == 0 then
            if callback then
                callback()
            end
            return
        elseif winScore / betScore < 10 then
            self.center_:settleLottery(callback)
            return
        end
        local params = {}
        params.base = betScore
        params.win = winScore
        LHDBReward:show(params, callback)
    end
    if event == LHDBCenter.Event.ERASE_FINISH then
        showReward(newGameRound, ...)
    elseif event == LHDBCenter.Event.UNLOCK_BOX then
        if self.ballCount_ ~= self.logic_:getTotalBall() then
            self.ballCount_ = self.logic_:getTotalBall()
            self.betInfo_:addBall(self.ballCount_, ...)
        end
    end
end

function LHDBScene:onCreate()
    cc.exports.SubLang = require("game.lhdb.src.LHDBLang").new()
    LHDBScene.super.onCreate(self)

    initUI(self)
    self.gate_ = LHDBGate.new(self.imgBg_:getChildByName("pnl_gate"))
    self.bet_ = LHDBBet.new(self.imgBg_:getChildByName("pnl_bet"))
    self.betInfo_ = LHDBBetInfo.new(self.imgBg_:getChildByName("pnl_info"))
    self.center_ = LHDBCenter.new(self.imgBg_:getChildByName("pnl_center"))
    self.center_:addEventCallback(handler(self, gemEventCallback))
    self.menu_ = LHDBMenu.new(self.imgBg_:getChildByName("pnl_menu"))
    LHDBReward:register(self)
    self:addTouchEvent()

    self.logic_ = LHDBLogic.new()

    self:updateRoomInfo()
    self:updateOwnerInfo{
        name = "",
        score = 0
    }

    self.cacheSubGameData_ = {}
    self.ballCount_ = 0
    self.gameState_ = GameState.FINISH
end

-- 进入场景完成
function LHDBScene:onEnterTransitionFinish()
    LHDBScene.super.onEnterTransitionFinish(self)
    LHDBSound.playBGM()
    self:addEvent()
    self:onQuestReady()

    self:playBroadcast()
end

function LHDBScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)

    self.onEventSitDownFail = handler(self, self.onSitDownFail)
    game.registerEvent(GameDefine.GAME_SITDOWN_FAILER, self.onEventSitDownFail)
end

function LHDBScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
    game.unregisterEvent(GameDefine.GAME_SITDOWN_FAILER, self.onEventSitDownFail)
end

function LHDBScene:onExit()
    LHDBScene.super.onExit(self)
    LHDBSound.stopBGM()
    self:removeEvent()

    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

local function closeGame(self)
    self:onQuestStandup()
    self:onExitGame()
end

local function onReturn(self)
    if self:isDisConnect() then
        self:onExitGame()
        return
    end
    if globalUserInfo.cbUserStatus >= GameDefine.US_PLAYING then
        GameMessage.sendExit(true)
    else
        closeGame(self)
    end
end

local function forTest(self)
    local params = {}
    params.total = 25 -- self.logic_:getTotalBall()
    params.lottery = 3 -- self.logic_:getLotteryBall()
    params.bet = self.logic_:getTotalBet()
    params.score = self.logic_:getScore()
    params.pool = self.logic_:getGoldPool()
    LHDBTBLayer:show(self, params)
    self.cachebetLines_ = {self.bet_:getBetAndLines()}

    local str = "恭喜【" .. math.random() .. "】中得彩金1526562131"
    self.logic_:loadBroadcast(str)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
    LHDBGoldPool:addBroadcast(str)
end

function LHDBScene:addTouchEvent()
    self.menu_:addClickCallback(function(typ)
        if typ == LHDBMenu.Type.RETURN then
            onReturn(self)
        elseif typ == LHDBMenu.Type.SETTING then
            LHDBSetting:show(self)
        elseif typ == LHDBMenu.Type.RULE then
            LHDBRule:show(self)
            if GameDefine.bIsLocalTest then
                forTest(self)
            end
        end
    end)
    local pnlGate = self.imgBg_:getChildByName("pnl_gate")
    pnlGate:addClickEventListener(function()
        LHDBRule:show(self, self.logic_:getGate() + 1)
    end)
    self.betInfo_:addGoldPoolCallback(function()
        LHDBGoldPool:show(self)
        LHDBGoldPool:addHelpCallback(function()
            LHDBGoldPool:close()
            LHDBRule:show(self, LHDBRule.Item.GOLD_POOL)
        end)
    end)
    self.bet_:startBetCallback(function()
        self.gameState_ = GameState.SEND
        overtimeReconnect(self, true)
    end)
end

function LHDBScene:updateRoomInfo()
end

function LHDBScene:updateOwnerInfo(info)

end

function LHDBScene:updateUserScore(gameUser)
    -- self.betInfo_:setOwnerGold(gameUser.lScore)
end

local function createCeremonyAnim()
    local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_men.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_men.csb")
    return anim, action
end

function LHDBScene:openNewGateCeremony(gateLvl, operDoorCallback)
    local gateImg = {"Img_DiYiGuan_Zi.png", "Img_DiErGuan_Zi.png", "Img_DiSanGuan_Zi.png", "Img_LongXue_Zi.png"}
    local anim, action = createCeremonyAnim()
    action:gotoFrameAndPlay(0, false)
    action:setFrameEventCallFunc(function(frame)
        if not frame then
            return
        end
        local str = frame:getEvent()
        if str == "DoorOpened" then
            anim:removeSelf()
        end
        if operDoorCallback then
            operDoorCallback(str)
        end
    end)
    anim:getChildByName("Panel_1"):getChildByName("ImgLevel"):setTexture(GameCMD.RES_PATH .. string.format("Anims/Men/%s", gateImg[gateLvl or 1]))
    local scale = math.min(display.width / 1280, display.height / 720)
    anim:setScale(scale)
    anim:move(display.center):addTo(self, 1)
    anim:runAction(action)
end

function LHDBScene:playBroadcast()
    local pnlBroadcast = self.imgBg_:getChildByName("pnl_broadcast")
    local broadcast = self.logic_:extractBroadcast()
    if not broadcast then
        self.broadcasting_ = false
        pnlBroadcast:hide()
        return
    end
    self.broadcasting_ = true
    pnlBroadcast:show()
    local pnlScroll = pnlBroadcast:getChildByName("pnl_scroll")
    local txt = pnlScroll:getChildByName("txt_broadcast")
    txt:stopAllActions()
    local scrollSize = pnlScroll:getContentSize()
    txt:setPositionX(scrollSize.width)
    txt:setString(broadcast)
    local txtSize = txt:getContentSize()
    txt:moveBy{
        time = 7.0,
        x = -txtSize.width - scrollSize.width,
        y = 0,
        onComplete = handler(self, self.playBroadcast)
    }
end

function LHDBScene:resetGameScene()
end

-- =============继承父类的方法==============
function LHDBScene:onSitDownFail(errType)
    -- 满员
    if errType == 4 then
        PlazaManager.showConfirmNode("ok", SubLang:word(3), nil, function(rlt)
            -- self.tabChange_:switch()
        end)
    end
end

-- 玩家坐下
function LHDBScene:onUserSitDown(gameUser)
    if gameUser.wChairID == globalUserInfo.wChairID then
        self:updateUserScore(gameUser)
    end
end

function LHDBScene:onShowRoomInfo(info)
    -- dump(info)
end

function LHDBScene:onPersonalEnd(data)
    -- dump(data)
end

-- 玩家准备
function LHDBScene:onUserReady(gameUser)
    -- dump(gameUser)
end

-- 玩家站起
function LHDBScene:onUserStandup(wChairID)
    -- --dump(wChairID)
    self:updateRoomInfo()
end

-- 玩家掉线
function LHDBScene:onUserOffline(gameUser)
    -- dump(gameUser)
end

-- 玩家游戏
function LHDBScene:onUserPlaying(gameUser)
    -- --dump(gameUser)
end

-- 玩家积分改变
function LHDBScene:onUserScore(gameUser)
    -- --dump(gameUser)
    self:updateUserScore(gameUser)
end

-- 场景消息
function LHDBScene:onGameScene(data)
    if self.gameDisConnection == true then
        -- 重置基类数据
        self:onResetData()
        -- 清除头像数据
        self:autoSitDown()
        self:onResetGameDisConnection()
    end
    self:resetGameScene()

    local gameStatus = PlazaManager.gameStatus.cbGameStatus
    if gameStatus == GameCMD.GS_LHDB_FREE then
        -- 空闲状态
        self:onSceneFree(data)
    elseif gameStatus == GameCMD.GS_LHDB_BET then -- 下注状态
        self:onScenePlay(data)
    end
    self:updateRoomInfo()
end

-- 游戏消息
function LHDBScene:onGame(cmdID, data)
    local parseFunc = {
        [GameCMD.SUB_S_GAME_START] = self.onSubGameStart,
        [GameCMD.SUB_S_NEXT_GAME] = self.onSubNextGame,
        [GameCMD.SUB_S_GAME_END] = self.onSubGameEnd,
        [GameCMD.SUB_S_MESSAGE_INFO] = self.onSubMsgInfo,
        [GameCMD.SUB_S_UPDATEGOLDPOOL] = self.onSubUpDateGoldPool,
        [GameCMD.SUB_S_CLOSE_GAME] = handler(self, closeGame),
        [GameCMD.SUB_S_SCENE] = self.onSceneStart
    }
    if not parseFunc[cmdID] then
        print("un define cmd id:", cmdID)
        return
    end
    parseFunc[cmdID](self, data)
end

-- scene message
function LHDBScene:onSceneFree(data)
    local params = GameMessage.onSceneFree(data)
    -- dump(params, "场景--空闲状态--GS_LHDB_FREE")
    -- self.logic_:loadSceneFreeData(params)
end

function LHDBScene:onScenePlay(data)
    -- local params = GameMessage.onScenePlay(data)
    -- self.logic_:loadScenePlayData(params)
end

local function parseGameStart(self, params)
    overtimeReconnect(self, false)
    self.logic_:loadGameData(params)

    self.ballCount_ = self.logic_:getTotalBall()
    self.bet_:init{
        minBet = params.llMinBetPoint,
        maxBet = params.llMaxBetPoint
    }
    local betCount, betLines = self.bet_:getBetAndLines()
    self.bet_:setLines(self.cachebetLines_ and self.cachebetLines_[2] or params.lBetCount)
    self.bet_:setBetCount(self.cachebetLines_ and self.cachebetLines_[1] or params.llBetPoint)

    self.gate_:setGate(self.logic_:getGate())

    self.betInfo_:setOwnerGold(params.llCardPoint)
    self.betInfo_:setTotalBet(params.llNowPoint)
    self.betInfo_:setGoldPool(params.llCurrentTotal)
    self.betInfo_:setBallCount(self.ballCount_)

    self.center_:initGateAndLockBox(self.logic_:getGate(), self.logic_:getLockBox())

    -- 第四关
    if self.logic_:getGate() == 4 then
        -- 吐珠结束
        if LHDBTBLayer:isFinished() then
            sendNewGame(self)
            return
        end
        local params = {}
        params.total = self.logic_:getTotalBall()
        params.lottery = self.logic_:getLotteryBall()
        params.bet = self.logic_:getTotalBet()
        params.score = self.logic_:getScore()
        params.pool = self.logic_:getGoldPool()
        params.finishCall = handler(self, sendNewGame)
        LHDBTBLayer:show(self, params)

        self.cachebetLines_ = {self.bet_:getBetAndLines()}
    else
        LHDBTBLayer:close()
        if self.gameState_ ~= GameState.REPLY then
            self.gameState_ = GameState.FINISH
            self.bet_:autoBet()
        end
    end
end

function LHDBScene:onSceneStart(data)
    local params = GameMessage.onSubGameStart(data)
    parseGameStart(self, params)
end

function LHDBScene:onSubGameStart(data)
    local params = GameMessage.onSubGameStart(data)
    self.cacheSubGameData_ = {}
    parseGameStart(self, params)
end

function LHDBScene:doSubNextGame(params)
    -- dump(params, "游戏--下一局")
    self.logic_:loadGameData(params)

    self.gameState_ = GameState.REPLY
    self.bet_:receiptBet()
    self.betInfo_:setGoldPool(params.llCurrentTotal)

    self.gate_:setGate(self.logic_:getGate())

    self.center_:updateGateAndLockBox(self.logic_:getGate(), self.logic_:getLockBox())
    self.center_:setGemDropFactor(self.bet_:getSpeedFactor())
    self.center_:loadBetScore(params.lBetCount * params.llBetPoint)
    self.center_:dropGems(clone(self.logic_:getGems()), params)
end

local function isRepeat(gems1, gems2)
    if not gems1 or not gems2 then
        return false
    end
    for i = 1, 60 do
        if gems1[i] ~= gems2[i] then
            return false
        end
    end
    return true
end

function LHDBScene:onSubNextGame(data)
    overtimeReconnect(self, false)
    local params = GameMessage.onSubGameStart(data)

    table.insert(self.cacheSubGameData_, params)
    if #self.cacheSubGameData_ == 1 then
        self:doSubNextGame(params)
    else
        if PlazaManager.uploadBuglyLog then
            local cnt = #self.cacheSubGameData_
            local isRep = isRepeat(self.cacheSubGameData_[cnt - 1].gems, params.gems)
            local str = string.format("is repeat: %d, count: %d", isRep and 1 or 0, cnt)
            PlazaManager.uploadBuglyLog("连环夺宝多次下发:", str)
        end
    end
end

function LHDBScene:onSubGameEnd(data)
    -- local params = GameMessage.onSubGameEnd(data)
end

function LHDBScene:onSubMsgInfo(data)
    local params = GameMessage.onSubMsgInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end
    self.logic_:loadBroadcast(showStr)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
    LHDBGoldPool:addBroadcast(showStr)
end

function LHDBScene:onSubUpDateGoldPool(data)
    local params = GameMessage.onSubUpdateGoldPool(data)
    -- dump(params, "游戏--更新彩金池")
    self.betInfo_:setGoldPool(params.llCurrentTotal)
end

function LHDBScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    self.logic_:loadBroadcast(szTrumpetContent)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
end

return LHDBScene
