local GameMessage = require("game.mlcs.src.MLCSMessage")
local GameCMD = require("game.mlcs.src.MLCSCMD")
local MLCSLogic = require("game.mlcs.src.MLCSLogic")
local MLCSAction = require("game.mlcs.src.panel.MLCSAction")
local MLCSButton = require("game.mlcs.src.panel.MLCSButton")
local MLCSScene = class("MLCSScene", require("app.views.base.BaseGameScene"))

function MLCSScene:onCreate()
    cc.exports.SubLang = require("game.mlcs.src.MLCSLang").new()
    MLCSScene.super.onCreate(self)
    self.logic = MLCSLogic.new(self)
    if self.logic.bIsTest then
        display.loadSpriteFrames("game/mlcs/res/mlcs.plist", "game/mlcs/res/mlcs.png")
    end

    self.layer = cc.CSLoader:createNode("game/mlcs/res/MLCSScene.csb")
    self.tBetCache = {}

    -- self.layer:setContentSize(display.sizeInPixels)
    self:addChild(self.layer)

    local Image_bg1 = self.layer:getChildByName("Image_bg1")
    Image_bg1:loadTexture("game/mlcs/res/bigbg/ml_bg2.png", 0)

    --[[
    self.layer:setOpacity(5)
    Image_bg1:setVisible(false)
    local Image_bg2 = self.layer:getChildByName('Image_bg2')
    Image_bg2:setVisible(false)
    --]]
    self.buttonView = MLCSButton.new(self)
    self.actionView = MLCSAction.new(self)

    self.Panel_tips = self.layer:getChildByName("Panel_tips")
    local Panel_txt = self.Panel_tips:getChildByName("Panel_txt")
    self.Text_tips = Panel_txt:getChildByName("Text_tips")
    self.Text_tips:setString("")
    self.Panel_tips:setCascadeOpacityEnabled(true)
    self.Panel_tips:setCascadeColorEnabled(true)
    self.bIsShowTips = false
    self.tips_list = {SubLang:word(1)}
    self:nextTips()

    ccui.Helper:doLayout(self.layer)
end

function MLCSScene:showBroadcastTips()
    if self.bIsShowTips then
        return
    end

    self:nextTips()
end

function MLCSScene:nextTips()
    local str = self.tips_list[1]
    if #self.tips_list > 1 then
        str = table.remove(self.tips_list, 2)
    end

    if str == nil then
        self.bIsShowTips = false
        self.Text_tips:setString("")
        self.Text_tips:stopAllActions()
        self.Panel_tips:setVisible(false)
        return
    end

    self.bIsShowTips = true
    self.Panel_tips:setVisible(true)
    self.Text_tips:setString(str)
    local ss = self.Text_tips:getContentSize()
    self.Text_tips:setAnchorPoint(display.LEFT_CENTER)
    self.Text_tips:setPosition(750, 25)

    local sec = (750 + ss.width) / 150
    local move1 = cc.MoveTo:create(sec, cc.p(-ss.width, 25))
    local call = cc.CallFunc:create(handler(self, self.nextTips))
    local seq = cc.Sequence:create(move1, call)
    self.Text_tips:runAction(seq)
end

-- 进入场景完成
function MLCSScene:onEnterTransitionFinish()
    MLCSScene.super.onEnterTransitionFinish(self)
    self:addEvent()

    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_explosion1.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_explosion2.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_explosion3.mp3")

    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_stone_fall1.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_stone_fall2.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_stone_fall3.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_stone_fall4.mp3")
    ccexp.AudioEngine:preload("game/mlcs/res/audio/gquest_stone_fall5.mp3")

    MusicManager.playBGM("game/mlcs/res/audio/background.mp3")

    self:onQuestReady()
end

function MLCSScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function MLCSScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

-- 响应切换后台时
function MLCSScene:onEnterBackground(isEnterBackground)
    MLCSScene.super.onEnterBackground(self, isEnterBackground)
    self.isBackRun = isEnterBackground

    if isEnterBackground == true then
        print("Switch to the background.")
    else
        print("Switch to the foreground.")
    end
end

function MLCSScene:onExit()
    MLCSScene.super.onExit(self)
    self:removeEvent()

    self.actionView:onExit()
    self.buttonView:onExit()
    PlazaManager.mlcs_auto_play_state = 0
    -- MusicManager.stopBGM()
    -- LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

-- =============继承父类的方法==============
-- 玩家坐下
function MLCSScene:onUserSitDown(gameUser)
end

function MLCSScene:onShowRoomInfo(info)
end

function MLCSScene:onPersonalEnd(data)
end

-- 玩家准备
function MLCSScene:onUserReady(gameUser)
end

-- 玩家站起
function MLCSScene:onUserStandup(wChairID)
end

-- 玩家掉线
function MLCSScene:onUserOffline(gameUser)
end

-- 玩家游戏
function MLCSScene:onUserPlaying(gameUser)
end

-- 玩家积分改变
function MLCSScene:onUserScore(gameUser)
end

-- 场景消息
function MLCSScene:onGameScene(data)
    if self.gameDisConnection == true then
        self:onResetGameDisConnection()
        self:onResetData()
        self:autoSitDown()
    end
    self:overtimeReconnect(false)
    if PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_FREE then
        -- 空闲状态
        -- self:onSceneFree(data)
    elseif PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_PLAY then
        -- 游戏状态
        self:onScenePlay(data)
    end

    self:checkAutoPlay()
end

function MLCSScene:checkAutoPlay()
    if self.logic:getSumFreeCount() > 0 or PlazaManager.mlcs_auto_play_state == 1 then
        if not self.actionView:isInAction() then
            self.buttonView:doBet()
        end

        if PlazaManager.mlcs_auto_play_state == 1 then
            self.logic:setIsAutoBet(true)
        end
    end
end

-- 游戏消息
function MLCSScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL then
        -- 卡片滚动
        self:onSubCardScroll(data)
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubMessageInfo(data)
    elseif cmdID == GameCMD.SUB_S_SENDGOLD_INFO then
        self:onSubSendGoldInfo(data)
    end
end

function MLCSScene:onSceneFree(data)
    local params = GameMessage.onSceneFree(data)
    -- print('==============onSceneFree=================')
    -- dump(params)
end

function MLCSScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data)
    -- print('==============onScenePlay=================')
    -- dump(params)

    self.logic:setPlayerGold(params.lUserScore)
    self.logic:setCellScore(params.lCellScore)
    self.logic:setMultCell(params.wMultiCell)
    self.logic:setFreeSumGold(params.lFreeSumGold)
    self.logic:setSumFreeCount(params.wSumFreeCount)
    self.logic:setGameRoomName(params.szGameRoomName)
    self.logic:setBouncsInfo(params.cbBonusLineCount, params.lBonusCellScore)
end

function MLCSScene:onSubCardScroll(data)
    self:overtimeReconnect(false)
    local params = GameMessage.onSubCardScroll(data)
    -- print('==============onSubCardScroll=================')
    -- dump(params)

    if self.actionView:isInAction() then
        table.insert(self.tBetCache, params)
    else
        self:doBetMsg(params)
    end
end

function MLCSScene:doNextBetMsg()
    local msg = table.remove(self.tBetCache, 1)
    if msg then
        self:doBetMsg(msg)
        return true
    end
    return false
end

function MLCSScene:doBetMsg(params)
    self.logic:setBetResult(params)
    self.actionView:startBet()
end

function MLCSScene:onSubMessageInfo(data)
    local params = GameMessage.onSubMessageInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end
    table.insert(self.tips_list, showStr)
    self:showBroadcastTips()
    -- PlazaManager.showTips(params.szContent)
end

-- 收到游戏喇叭公告(改成游戏中滚动)
function MLCSScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    table.insert(self.tips_list, szTrumpetContent)
    self:showBroadcastTips()
end

function MLCSScene:onSubSendGoldInfo(data)
    local params = GameMessage.onSubSendGoldInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end

    table.insert(self.tips_list, showStr)
    self:showBroadcastTips()
end

function MLCSScene:doExitGame()
    if self:isDisConnect() == true then
        self:onExitGame()
        return
    end
end

-- 2019.4.24 超时刷新重连
function MLCSScene:overtimeReconnect(enable)
    self.layer:stopActionByTag(0xaa)
    if not enable then
        return
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(8.0), cc.CallFunc:create(function()
        self:refreshGame()
    end))
    seq:setTag(0xaa)
    self.layer:runAction(seq)
end

return MLCSScene
