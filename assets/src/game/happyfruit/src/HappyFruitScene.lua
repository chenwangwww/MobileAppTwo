local GameMessage = require("game.happyfruit.src.HappyFruitMessage")
local GameCMD = require("game.happyfruit.src.HappyFruitCMD")
local HappyFruitLogic = require("game.happyfruit.src.HappyFruitLogic")
local HappyFruitText = require("game.happyfruit.src.panel.HappyFruitText")
local HappyFruitAction = require("game.happyfruit.src.panel.HappyFruitAction")
local HappyFruitButton = require("game.happyfruit.src.panel.HappyFruitButton")
local HappyFruitGoldPool = require("game.happyfruit.src.panel.HappyFruitGoldPool")

local HappyFruitScene = class("HappyFruitScene", require("app.views.base.BaseGameScene"))

function HappyFruitScene:onCreate()
    HappyFruitScene.super.onCreate(self)
    cc.exports.SubLang = require("game.happyfruit.src.HappyFruitLang").new()
    self.logic = HappyFruitLogic.new(self)

    if GameDefine.bIsLocalTest then
        display.loadSpriteFrames("game/happyfruit/res/fruit_machine.plist", "game/happyfruit/res/fruit_machine.png")
    end

    self.layer = cc.CSLoader:createNode("game/happyfruit/res/HappyFruitScene.csb")
    self.bIsScenePlayInit = false
    self.tBetCache = {}

    -- self.layer:setContentSize(display.sizeInPixels)
    self:addChild(self.layer)

    local Image_logo = self.layer:getChildByName("Image_logo")
    Image_logo:setScale(0.8 * self.logic:getWinScale())
    Image_logo:setVisible(false)

    self.Panel_center = self.layer:getChildByName("Panel_center")
    self.Panel_center:setScale(self.logic:getWinScale())

    local Image_0 = self.layer:getChildByName("Image_0")
    Image_0:loadTexture("game/happyfruit/res/png_res/fruit_machine_bg.png", 0)

    local Image_1 = self.Panel_center:getChildByName("Image_1")
    Image_1:loadTexture("game/happyfruit/res/png_res/fruit_machine_dk.png", 0)
    self:showbgdArmature(Image_0, Image_1)

    self.prize_pool_info_btn = self.Panel_center:getChildByName("prize_pool_info_btn")
    self.prize_pool_info_btn:setTouchEnabled(true)
    self.prize_pool_info_btn:addClickEventListener(handler(self, self.onClickPool))

    self.textView = HappyFruitText.new(self)
    self.actionView = HappyFruitAction.new(self)
    self.buttonView = HappyFruitButton.new(self)

    self.Panel_win = self.layer:getChildByName("Panel_win")
    self.Panel_win:setScale(self.logic:getWinScale())
    self.winFont = self.Panel_win:getChildByName("winFont")
    self.winFont:setFntFile("game/happyfruit/res/fnt/shuiguoji2.fnt")

    self.youWin = self.Panel_win:getChildByName("youWin")
    self.bigWinBg = self.Panel_win:getChildByName("bigWinBg")
    self.bigWinIcon = self.Panel_win:getChildByName("bigWinIcon")
    self:showWinArmature()

    self.Panel_tips = self.layer:getChildByName("Panel_tips")
    self.Panel_tips:setScale(self.logic:getWinScale())
    local Panel_txt = self.Panel_tips:getChildByName("Panel_txt")
    self.Text_tips = Panel_txt:getChildByName("Text_tips")
    self.Text_tips:setString("")
    self.Panel_tips:setCascadeOpacityEnabled(true)
    self.Panel_tips:setCascadeColorEnabled(true)
    self.Panel_tips:setPosition(display.cx, 750 + 55)
    self.bIsShowTips = false
    self.tips_list = {SubLang:word(1)}
    self.lastMesgInfo = ""

    self.Panel_free = self.layer:getChildByName("Panel_free")
    self.Panel_free:setScale(self.logic:getWinScale())
    self.freeFont = self.Panel_free:getChildByName("freeFont")
    self.freeFont:setFntFile("game/happyfruit/res/fnt/shuiguoji3.fnt")

    self:showTips()

    ccui.Helper:doLayout(self.layer)

    self.Panel_win:setVisible(false)
    self.Panel_free:setVisible(false)
end

function HappyFruitScene:onClickPool()
    MusicManager.playEffect("game/happyfruit/res/audio/Pool_Open.mp3")
    HappyFruitGoldPool.new(self):addTo(self)
end

function HappyFruitScene:showTips()
    if self.bIsShowTips then
        return
    end

    self.bIsShowTips = true
    local move = cc.MoveTo:create(0.3, cc.p(display.cx, 750 - 25))
    local call = cc.CallFunc:create(handler(self, self.nextTips))
    local seq = cc.Sequence:create(move, call)
    self.Panel_tips:stopAllActions()
    self.Panel_tips:runAction(seq)
end

function HappyFruitScene:hideTips()
    self.bIsShowTips = false
    local move = cc.MoveTo:create(0.2, cc.p(display.cx, 750 + 55))
    self.Text_tips:stopAllActions()
    self.Panel_tips:runAction(move)
end

function HappyFruitScene:nextTips()
    local str = self.tips_list[1]
    if #self.tips_list > 1 then
        str = table.remove(self.tips_list, 2)
    end

    if str == nil then
        self.Text_tips:setString("")
        self:hideTips()
        return
    end

    self.Text_tips:setString(str)
    local ss = self.Text_tips:getContentSize()
    self.Text_tips:setAnchorPoint(display.LEFT_CENTER)
    self.Text_tips:setPosition(750, 25)

    local sec = (750 + ss.width) / 150
    local move1 = cc.MoveTo:create(sec, cc.p(-ss.width, 25))
    local call = cc.CallFunc:create(handler(self, self.nextTips))
    local seq = cc.Sequence:create(move1, delay, move2, move3, call)
    self.Text_tips:runAction(seq)
end

local function slowAction(callback, funRatio, start, over, sec)
    local elaspe, ratio, progress, value = 0, 0, 0, 0
    local function updateTime(dt)
        elaspe = elaspe + dt
        ratio = elaspe / sec
        progress = funRatio(ratio)
        value = start + (over - start) * progress
        if ratio >= 1 or elaspe >= sec then
            value = over
        end
        callback(value)
    end
    return cc.Director:getInstance():getScheduler():scheduleScriptFunc(updateTime, 0, false)
end

function HappyFruitScene:stopSlowAct1()
    if self.slowActId1 then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.slowActId1)
        self.slowActId1 = nil
    end
end

function HappyFruitScene:stopSlowAct2()
    if self.slowActId2 then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.slowActId2)
        self.slowActId2 = nil
    end
end

function HappyFruitScene:setShowWin(num)
    if num <= 0 then
        self.textView:setWinGolds(num)
        self.logic:updateAfterResult(self.analyze.result)
        if self.funEndShow then
            self.funEndShow()
            self.funEndShow = nil
        end
        return
    end

    MusicManager.playEffect("game/happyfruit/res/audio/bjWin.mp3")
    self.Panel_win:setVisible(true)
    self.winFont:setString("0")

    self.youWin:setPositionY(320)
    local youWinX = self.youWin:getPositionX()
    self.youWin:runAction(cc.MoveTo:create(0.5 / self.logic:getActionSpeed(), cc.p(youWinX, 241)))

    local voice = "game/happyfruit/res/audio/midWin.mp3"
    if self.analyze.lTimes >= 5 then
        self.bigWinBg:setVisible(true)
        self.bigWinIcon:setVisible(true)
        local res = "SGKH_WZ_tbl.png"
        if self.analyze.w777 >= 3 then
            res = "SGKH_ddcc.png"
            voice = "game/happyfruit/res/audio/Pool_Win.mp3"
        elseif self.analyze.lTimes >= 100 then
            res = "SGKH_JS_wz3.png"
        elseif self.analyze.lTimes >= 40 then
            res = "SGKH_JS_wz2.png"
            voice = "game/happyfruit/res/audio/bigWin.mp3"
        elseif self.analyze.lTimes >= 10 then
            res = "SGKH_JS_wz1.png"
        end
        self.win_armature:setPosition(634, 420)
        self.bigWinIcon:loadTexture(res, 1)
        self.Panel_win:setPositionY(385)
    else
        self.win_armature:setPosition(634, 350)
        self.bigWinBg:setVisible(false)
        self.bigWinIcon:setVisible(false)
        self.Panel_win:setPositionY(425)
    end

    local delay = cc.DelayTime:create(2 / self.logic:getActionSpeed())
    local call = cc.CallFunc:create(handler(self, self.hideWinPanel))
    local sequence = cc.Sequence:create(delay, call)
    self.Panel_win:runAction(sequence)

    local function update_value(value)
        self.winFont:setString(tostring(math.floor(value)))
        if value == num then
            self.logic:updateAfterResult(self.analyze.result)
            MusicManager.playEffect(voice)
            self:stopSlowAct1()
        end
    end

    local function linear(ratio)
        return ratio
    end
    self.slowActId1 = slowAction(update_value, linear, 0, num, 0.8 / self.logic:getActionSpeed())
end

function HappyFruitScene:showWinArmature()
    local json = "game/happyfruit/res/armature/sli.ExportJson"
    local png = "game/happyfruit/res/armature/sli0.png"
    local plist = "game/happyfruit/res/armature/sli0.plist"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(png, plist, json)

    self.win_armature = ccs.Armature:create("sli")
    self.win_armature:getAnimation():play("SGKH_sli", -1, 1)
    self.win_armature:getAnimation():setSpeedScale(self.logic:getActionSpeed())
    self.Panel_win:addChild(self.win_armature, -1)
end

function HappyFruitScene:showbgdArmature(parent1, parent2)
    local json = "game/happyfruit/res/armature/bgd.ExportJson"
    local png = "game/happyfruit/res/armature/bgd0.png"
    local plist = "game/happyfruit/res/armature/bgd0.plist"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(png, plist, json)

    json = "game/happyfruit/res/armature/bgd2.ExportJson"
    png = "game/happyfruit/res/armature/bgd20.png"
    plist = "game/happyfruit/res/armature/bgd20.plist"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(png, plist, json)

    local sz = parent1:getContentSize()
    local ani = ccs.Armature:create("bgd")
    ani:setPosition(sz.width / 2, sz.height / 2)
    ani:getAnimation():play("BGD", -1, 1)
    ani:getAnimation():setSpeedScale(self.logic:getActionSpeed())
    parent1:addChild(ani)

    sz = parent2:getContentSize()
    ani = ccs.Armature:create("bgd2")
    ani:setPosition(sz.width / 2, sz.height / 2)
    ani:getAnimation():play("BGD2", -1, 1)
    ani:getAnimation():setSpeedScale(self.logic:getActionSpeed())
    parent2:addChild(ani)
end

function HappyFruitScene:hideWinPanel()
    self.Panel_win:setVisible(false)
    self:stopSlowAct1()
    self.textView:setWinGolds(self.win_num)
    self.win_num = 0
    if self.funEndShow then
        self.funEndShow()
        self.funEndShow = nil
    end
end

function HappyFruitScene:setShowFreeAndWin(analyze, funEndShow)
    self.analyze = analyze
    self.free_num, self.win_num = self.analyze.result.cbBonusCount, self.analyze.result.lWinScore
    self.funEndShow = funEndShow

    if self.free_num <= 0 then
        self:setShowWin(self.win_num)
        return
    end

    local function getNumStr(value)
        local str = tostring(value)
        --[[
        local len = string.len(str)
        if len == 1 then
            str = "000" .. str
        elseif len == 2 then
            str = "00" .. str
        elseif len == 3 then
            str = "0" .. str
        end
        --]]
        return str
    end

    MusicManager.playEffect("game/happyfruit/res/audio/midWin.mp3")
    self.Panel_free:setVisible(true)
    self.freeFont:setString(getNumStr(self.free_num))

    local delay = cc.DelayTime:create(1.5 / self.logic:getActionSpeed())
    local call = cc.CallFunc:create(handler(self, self.hideFreePanel))
    local sequence = cc.Sequence:create(delay, call)
    self.Panel_free:runAction(sequence)

    --[[
    local function update_value(value)
        self.freeFont:setString(getNumStr(math.floor(value)))
        if value == self.free_num then
            self:stopSlowAct2()
        end
    end

    local function linear(ratio)
        return ratio
    end
    self.freeFont:setString("0000")
    self.slowActId2 = slowAction(update_value, linear, 0, self.free_num, 0.3)
    --]]
end

function HappyFruitScene:hideFreePanel()
    self.Panel_free:setVisible(false)
    self:stopSlowAct2()
    self.free_num = 0
    self:setShowWin(self.win_num)
end

-- 进入场景完成
function HappyFruitScene:onEnterTransitionFinish()
    HappyFruitScene.super.onEnterTransitionFinish(self)
    self:addEvent()

    ccexp.AudioEngine:preload("game/happyfruit/res/audio/BackgroundPlaying.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/bigWin.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/bjWin.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/clickBt.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/midWin.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/Pool_Open.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/Pool_Win.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStart.mp3")

    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStop1.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStop2.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStop3.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStop4.mp3")
    ccexp.AudioEngine:preload("game/happyfruit/res/audio/slotFruitStop5.mp3")

    MusicManager.playBGM("game/happyfruit/res/audio/BackgroundPlaying.mp3")

    self:onQuestReady()
end

function HappyFruitScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function HappyFruitScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

-- 响应切换后台时
function HappyFruitScene:onEnterBackground(isEnterBackground)
    HappyFruitScene.super.onEnterBackground(self, isEnterBackground)
    self.isBackRun = isEnterBackground

    if isEnterBackground == true then
        print("Switch to the background.")
    else
        print("Switch to the foreground.")
    end
end

function HappyFruitScene:onExit()
    HappyFruitScene.super.onExit(self)
    self:stopSlowAct1()
    self:stopSlowAct2()
    self:removeEvent()

    self.textView:onExit()
    self.actionView:onExit()
    self.buttonView:onExit()
    MusicManager.stopBGM()
    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

-- =============继承父类的方法==============
-- 玩家坐下
function HappyFruitScene:onUserSitDown(gameUser)

end

function HappyFruitScene:onShowRoomInfo(info)

end

function HappyFruitScene:onPersonalEnd(data)

end

-- 玩家准备
function HappyFruitScene:onUserReady(gameUser)

end

-- 玩家站起
function HappyFruitScene:onUserStandup(wChairID)

end

-- 玩家掉线
function HappyFruitScene:onUserOffline(gameUser)

end

-- 玩家游戏
function HappyFruitScene:onUserPlaying(gameUser)

end

-- 玩家积分改变
function HappyFruitScene:onUserScore(gameUser)

end

-- 场景消息
function HappyFruitScene:onGameScene(data)
    print("收到场景消息")
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

    self.actionView:setCanPlay(true)
    if (self.logic:isAutoBet() or self.logic:getBonusCount() > 0) and not self.actionView:isInAction() then
        self.buttonView:autoMove()
    end
end

-- 游戏消息
function HappyFruitScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL then
        -- 卡片滚动
        self:onSubCardScroll(data)
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubMessageInfo(data)
    elseif cmdID == GameCMD.SUB_S_SENDGOLD_INFO then
        self:onSubSendGoldInfo(data)
    elseif cmdID == GameCMD.SUB_S_UPDATEGOLDPOOL then
        self:onSubUpdateGoldPool(data)
    end
end

function HappyFruitScene:onSceneFree(data)
    local params = GameMessage.onSceneFree(data)
end

function HappyFruitScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data)
    -- print("==============onScenePlay=================")
    -- dump(params)
    if self.bIsScenePlayInit == false then
        self.bIsScenePlayInit = true
        self.logic:setCellScore(params.lCellScore)
        self.logic:setPlayerGold(params.lUserScore)
        self.logic:setMultCell(params.wMultiCell)
        self.logic:setBonusCount(params.wBonusCount)
        self.logic:setLineCount(params.cbBonusLineCount, true)
        self.logic:setLineBetByVal(params.lBonusCellScore)
        self.logic:setPoolCount(params.lGoldPool)
        self.logic:setGameRoomName(params.szGameRoomName)
    else
        print("=====skip onScenePlay=====")
    end
end

function HappyFruitScene:onSubCardScroll(data)
    self:overtimeReconnect(false)
    local params = GameMessage.onSubCardScroll(data)
    -- print("==============onSubCardScroll=================")
    -- dump(params)

    if self.actionView:isInAction() then
        table.insert(self.tBetCache, params)
    else
        self:doBetMsg(params)
    end

    --[[
    if math.random(0, 2) == 1 then
        table.insert(self.tips_list, "这是测试消息,消息的随机码为:" .. math.random(1, 999999))
        self:showTips()
    end
    --]]
end

function HappyFruitScene:hasBetCache()
    return #self.tBetCache > 0
end

function HappyFruitScene:doNextBetMsg()
    local msg = table.remove(self.tBetCache, 1)
    if msg then
        print("=====doNextBetMsg=====")
        self:doBetMsg(msg)
        return true
    end
    return false
end

function HappyFruitScene:doBetMsg(params)
    self.logic:setPlayerGold(params.lUserScore)
    self.logic:setBetResult(params)
    self.logic:updateActionSpeed()
    self.actionView:startBet()
end

function HappyFruitScene:onSubUpdateGoldPool(data)
    local params = GameMessage.onSubUpdateGoldPool(data)
    self.logic:setPoolCount(params.lGoldPool)
end

function HappyFruitScene:onSubMessageInfo(data)
    local params = GameMessage.onSubMessageInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end
    table.insert(self.tips_list, showStr)
    self:showTips()
    print(params.szContent)
    -- PlazaManager.showTips(params.szContent)
end

function HappyFruitScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    table.insert(self.tips_list, szTrumpetContent)
    self:showTips()
end

function HappyFruitScene:onSubSendGoldInfo(data)
    local params = GameMessage.onSubSendGoldInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end

    self.lastMesgInfo = showStr
    table.insert(self.tips_list, showStr)
    self:showTips()
    game.sendEvent("EventUpdateFruitLastGoldInfo")
    print(params.szContent)
end

function HappyFruitScene:doExitGame()
    if self:isDisConnect() == true then
        self:onExitGame()
        return
    end
end

-- 2019.4.24 超时刷新重连
function HappyFruitScene:overtimeReconnect(enable)
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

return HappyFruitScene
