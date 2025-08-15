local GameCMD = require("game.jsfy.src.JSFYCMD")
local GameMessage = require("game.jsfy.src.JSFYMessage")
local JSFYLogic = require("game.jsfy.src.JSFYLogic")
local JSFYSound = require("game.jsfy.src.JSFYSound")

local JSFYCenter = require("game.jsfy.src.panel.JSFYCenter")
local JSFYBet = require("game.jsfy.src.panel.JSFYBet")
local JSFYSettle = require("game.jsfy.src.panel.JSFYSettle")
local JSFYSetting = require("game.jsfy.src.panel.JSFYSetting")
local JSFYHelp = require("game.jsfy.src.panel.JSFYHelp")
local JSFYTreasure = require("game.jsfy.src.panel.JSFYTreasure")

local JSFYScene = class("JSFYScene", require("app.views.base.BaseGameScene"))

local GameState = {
    SEND = 0,
    REPLY = 1,
    FINISH = 2,
    OPENBOX = 3
}

local function initUI(self)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "LayerMain.csb")
    self.root_:addTo(self)

    self.imgBg_ = self.root_:getChildByName("img_bg")
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)
    self.pnlTop_ = self.imgBg_:getChildByName("pnl_top")
    self.pnlBottom_ = self.imgBg_:getChildByName("pnl_bottom")
    -- self.nodeCaiShen_ = self.imgBg_:getChildByName("node_caishen")

    -- self:updateJackpot("")
    self:updateOwnerScore("")
end

function JSFYScene:onCreate()
    cc.exports.SubLang = require("game.jsfy.src.JSFYLang").new()
    JSFYScene.super.onCreate(self)

    initUI(self)
    self.center_ = JSFYCenter.new(self.imgBg_:getChildByName("pnl_center"))
    self.center_:addFinishCallback(handler(self, self.settle))
    self.bet_ = JSFYBet.new(self.imgBg_:getChildByName("pnl_bottom"))
    self.settle_ = JSFYSettle.new(self.imgBg_:getChildByName("node_settle"))
    self:addCallback()

    self.logic_ = JSFYLogic.new()
    self:setWheelSpeed(1)
    self.gameState_ = GameState.FINISH
end

-- 把中宝箱的分跟中线分加在一起更新
function JSFYScene:updateWinScore(score)
    self.settle_:updateWinScore(score)
end

-- 进入场景完成
function JSFYScene:onEnterTransitionFinish()
    JSFYScene.super.onEnterTransitionFinish(self)
    JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    self:addEvent()

    self:playBroadcast()
    self:onQuestReady()
end

function JSFYScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function JSFYScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

function JSFYScene:onExit()
    JSFYScene.super.onExit(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT)
    self:removeEvent()

    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

-- 无消息返回无网络异常提示情况下，主动重试操作
-- 2019.4.8 去掉主动尝试，等待底层消息
-- 2019.4.24 超时刷新重连
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

function JSFYScene:addCallback()
    local btnReturn = self.pnlTop_:getChildByName("Button_Back")
    btnReturn:addClickEventListener(function()
        self:onQuestStandup()
        self:onExitGame()
    end)
    local btnSet = self.pnlTop_:getChildByName("Button_Setting")
    btnSet:addClickEventListener(function()
        JSFYSetting:show(self)
    end)
    local btnRule = self.pnlTop_:getChildByName("Button_Help")
    btnRule:addClickEventListener(function()
        JSFYHelp:show(self)
        -- JSFYTreasure:show(self, nil, function ()
        -- JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
        -- end)
    end)
    local btnSpeed = self.pnlBottom_:getChildByName("Button_Speed")
    btnSpeed:addClickEventListener(function()
        local nxtRatio = self.wheelRatio_ >= 4 and 1 or (self.wheelRatio_ + 1)
        self:setWheelSpeed(nxtRatio)
    end)
    self.bet_:addBetCallback(function(betState)
        self.center_:reset()
        if betState ~= JSFYBet.State.FREE then
            self.settle_:reset()
        end
        JSFYSound.clickSpin()
        if betState == JSFYBet.State.NORMAL or betState == JSFYBet.State.AUTO then
            -- self.center_:startWheel()
            self:updateOwnerScore(self.logic_:getOwnerScore() - self.bet_:getBetCount())
        end
        self.gameState_ = GameState.SEND
        overtimeReconnect(self, true)
    end)
end

function JSFYScene:reConnectCallBack()
    local winInfo = self.logic_:getWinInfo()
    self.center_:showWinLines(winInfo.winLines, winInfo.BonusTab)
end

function JSFYScene:settle()
    local winInfo = self.logic_:getWinInfo()
    local function nextRound()
        if winInfo.bonusCnt > 0 then -- free scroll
            self.bet_:changeStatus(JSFYBet.State.FREE, self.logic_:getBonusCount())
            self:playFreeStart(winInfo.bonusCnt, function()
                self.gameState_ = GameState.FINISH
                self.bet_:autoBet(false)
            end)
        elseif self.logic_:JugeisBonus() == 1 then -- open box
            self.settle_:updateGameStr("Open the Treasure Box!")
            self.gameState_ = GameState.OPENBOX
            JSFYTreasure:show(self, self.logic_:getBoxData(), function()
                JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
                self.gameState_ = GameState.FINISH
                self.bet_:autoBet(true)
            end, false)
        else
            self.gameState_ = GameState.FINISH
            self.bet_:autoBet(false)
        end
    end
    local function freeScatterTotal()
        if winInfo.freeTotal > 0 then
            self:playFreeEnd(winInfo.freeTotal, function()
                nextRound()
            end)
            -- elseif winInfo.scatterTotal > 0 then
            --     self:playScatterEnd(winInfo.scatterTotal, nextRound)
        else
            nextRound()
        end
    end
    self.center_:showWinLines(winInfo.winLines, winInfo.BonusTab)
    if self.logic_:getWinScore() > 0 then
        JSFYSound.winScore()
        local params = {
            base = self.bet_:getLineBet(),
            win = self.logic_:getWinScore(),
            SumFreeGold = self.logic_:getWinInfo().freeTotal
        }
        self.settle_:accumulative(params, function()
            -- self:updateOwnerScore(self.logic_:getOwnerScore())
            freeScatterTotal()
        end)
    else
        freeScatterTotal()
    end
end

function JSFYScene:freeWheel(callback)
    -- TODO:
    if callback then
        callback()
        return
    end
end

function JSFYScene:updateJackpot(goldPool)
    -- self.pnlTop_:getChildByName("bmf_jackpot"):setString(goldPool)
end

function JSFYScene:updateOwnerScore(score)
    local bgCoin = self.imgBg_:getChildByName("bg_coin")
    bgCoin:getChildByName("txt_coin"):setString(score)
end

function JSFYScene:playFreeStart(bonus, callback)
    -- local bgSize = self.imgBg_:getContentSize()
    -- local freeStartAnim = GameCMD.addAnim("ani/fx_mianfei.csb", self.imgBg_, 0, false):move(bgSize.width/2, bgSize.height/2)
    -- freeStartAnim:getChildByName("Panel_1_0_0"):getChildByName("free_count"):setString(bonus)
    -- freeStartAnim:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    -- TODO:

    if callback then
        callback()
    end
    JSFYSound.freeStart()
end

function JSFYScene:playFreeEnd(freeTotal, callback)
    -- local bgSize = self.imgBg_:getContentSize()
    -- local freeEndAnim = GameCMD.addAnim("ani/free_total.csb", self.imgBg_, 0, 130, false):move(bgSize.width/2, bgSize.height/2)
    -- freeEndAnim:runAction(cc.Sequence:create(cc.DelayTime:create(3.5), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    -- local pnl = freeEndAnim:getChildByName("Panel_1")
    -- pnl:getChildByName("free_tottal"):setString(5)
    -- pnl:getChildByName("Panel_2"):getChildByName("ShuZi_0"):setString(freeTotal)
    -- pnl:getChildByName("btn_lingqu2"):addClickEventListener(function ()
    --     if callback then callback() end
    --     freeEndAnim:removeSelf()
    -- end)
    -- TODO:
    self.settle_:updateGameStr("Free Draw Lottery!")
    if callback then
        callback()
    end
    JSFYSound.freeTotal()
end

function JSFYScene:setWheelSpeed(ratio)
    self.wheelRatio_ = ratio
    self.pnlBottom_:getChildByName("Button_Speed"):getChildByName("bmf_num"):setString(ratio)
    self.center_:setWheelSpeed(ratio)
end

function JSFYScene:playBroadcast()
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
        time = 8.0,
        x = -txtSize.width - scrollSize.width,
        y = 0,
        onComplete = handler(self, self.playBroadcast)
    }
end
-- =============继承父类的方法==============
-- 玩家坐下
function JSFYScene:onUserSitDown(gameUser)

end

function JSFYScene:onShowRoomInfo(info)

end

function JSFYScene:onPersonalEnd(data)

end

-- 玩家准备
function JSFYScene:onUserReady(gameUser)

end

-- 玩家站起
function JSFYScene:onUserStandup(wChairID)

end

-- 玩家掉线
function JSFYScene:onUserOffline(gameUser)

end

-- 玩家游戏
function JSFYScene:onUserPlaying(gameUser)

end

-- 玩家积分改变
function JSFYScene:onUserScore(gameUser)

end

-- 场景消息
function JSFYScene:onGameScene(data)
    if self.gameDisConnection == true then
        -- 重置基类数据
        self:onResetData()
        -- 清除头像数据
        self:autoSitDown()
    end
    overtimeReconnect(self, false)
    if PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_FREE then
        -- 空闲状态
        -- self:onSceneFree(data)
    elseif PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_PLAY then

        self:onScenePlay(data)
    end
end

-- 游戏消息
function JSFYScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL then
        overtimeReconnect(self, false)
        -- 卡片滚动
        self:onSubCardScroll(data)
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubMessageInfo(data)
    elseif cmdID == GameCMD.SUB_S_SENDGOLD_INFO then
        self:onSubSendGoldInfo(data)
        -- elseif cmdID == GameCMD.SUB_S_UPDATEGOLDPOOL then
        -- self:onSubUpdateGoldPool(data)
        -- elseif cmdID == GameCMD.SUB_S_GOLD_HISTORY then
        -- self:onSubGoldHistory(data)
    elseif cmdID == GameCMD.SUB_S_BONUS_RESULT then
        self:onSubBonusResult(data)
    end
end

function JSFYScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data)
    self.logic_:loadSceneData(params)

    self.bet_:loadBetConfig(params)
    -- self:updateJackpot(params.lGoldPool)
    self:updateOwnerScore(params.lUserScore)

    -- 发送未返回/重登录
    if self.gameState_ ~= GameState.REPLY then
        if self.gameState_ == GameState.OPENBOX then
            if self.logic_:JugeisBonus() == 1 then
                JSFYTreasure:DealOpenBoxData(params, function()
                    JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
                    self.bet_:autoBet(true)
                end, true)
            end
        else
            self.gameState_ = GameState.FINISH
            if self.logic_:JugeisBonus() == 1 then
                self.center_:reConnectWheel(params.cbCardType, params.cbAnyCardValue, handler(self, self.reConnectCallBack))
                JSFYTreasure:show(self, params, function()
                    JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
                    self.bet_:autoBet(true)
                    self.settle_:updateGameStr("Open the Treasure Box!")
                end, true)
            elseif self.logic_:getBonusCount() > 0 then
                -- 免费摇奖
                self:updateOwnerScore(params.lUserScore - params.lSumFreeGold)
                self:updateWinScore(params.lSumFreeGold)
                self.bet_:changeStatus(JSFYBet.State.FREE, self.logic_:getBonusCount())
                self:playFreeStart(self.logic_:getBonusCount(), function()
                    self.bet_:autoBet(false)
                end)
                -- elseif self.logic_:getScatterCount() > 0 then
                -- 散财
                -- self.bet_:changeStatus(JSFYBet.State.GXFC, self.logic_:getScatterCount())
                -- self.bet_:autoBet()
            else
                self.bet_:autoBet(false)
                self.settle_:updateGameStr("The Game Begins!")
            end
        end

    end
end

function JSFYScene:onSubCardScroll(data)
    local params = GameMessage.onSubCardScroll(data)
    self.logic_:loadCardScollData(params)

    self.gameState_ = GameState.REPLY
    -- self:updateJackpot(params.lGoldPool)
    if params.bFree == 1 then
        -- 免费摇奖
        self:freeWheel(function()
            self.center_:freeWheel(params.cbCardType, params.cbAnyCardValue)
        end)
    else
        self.center_:finishWheel(params.cbCardType, params.cbAnyCardValue)
    end
    -- self.bet_:updateWinJackpot(params.lGoldPool)
    self.bet_:receiptBet()

    local winInfo = self.logic_:getWinInfo()
    if winInfo.ratio and winInfo.ratio * self.bet_:getLineBet() ~= params.lWinScore then
        dump("win score calculate not equal, lWinScore:" .. params.lWinScore .. " ratio:" .. winInfo.ratio .. "*lineBet:" .. self.bet_:getLineBet() .. "=" .. winInfo.ratio * self.bet_:getLineBet())
    end
end

function JSFYScene:onSubUpdateGoldPool(data)
    local params = GameMessage.onSubUpdateGoldPool(data)
    self.logic_:setGoldPool(params.lGoldPool)

    -- self:updateJackpot(params.lGoldPool)
    -- self.bet_:updateWinJackpot(params.lGoldPool)
end

function JSFYScene:onSubGoldHistory(data)
    local params = GameMessage.onSubGoldHistory(data)
    -- dump(params, "游戏--中奖玩家历史记录")

end

function JSFYScene:onSubBonusResult(data)
    local params = GameMessage.onSubBonusResult(data)
    self.gameState_ = GameState.OPENBOX
    JSFYTreasure:DealOpenBoxData(params, function()
        JSFYSound.playBGM(JSFYSound.BGM.NORMAL)
        self.bet_:autoBet(true)
    end, false)
end

function JSFYScene:onSubMessageInfo(data)
    local params = GameMessage.onSubMessageInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end

    self.logic_:loadBroadcast(showStr)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
end

function JSFYScene:onSubSendGoldInfo(data)
    local params = GameMessage.onSubSendGoldInfo(data)
    game.sendEvent("EventUpdateFruitLastGoldInfo")
end

function JSFYScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    self.logic_:loadBroadcast(szTrumpetContent)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
end

return JSFYScene
