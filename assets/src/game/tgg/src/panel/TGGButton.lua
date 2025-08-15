local GameMessage = require("game.tgg.src.TGGMessage")
local TGGButton = class("TGGButton")

function TGGButton:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.scheduler = cc.Director:getInstance():getScheduler()

    local Image_gold_bg = scene.layer:getChildByName("Image_gold_bg")
    self.my_gold = Image_gold_bg:getChildByName("my_gold")
    self.my_gold:setFntFile("game/tgg/res/fnt/qtds_label_jb.fnt")

    self.Button_exit = scene.layer:getChildByName("Button_exit")
    self.Button_exit:addClickEventListener(handler(self, self.doExit))
    self.Button_setting = scene.layer:getChildByName("Button_setting")
    self.Button_setting:addClickEventListener(handler(self, self.onSetting))
    self.Button_help = scene.layer:getChildByName("Button_help")
    self.Button_help:addClickEventListener(handler(self, self.onHelp))

    self.Button_speed = scene.layer:getChildByName("Button_speed")
    self.Button_speed:addClickEventListener(handler(self, self.onAddSpeed))
    self.labelspeed = self.Button_speed:getChildByName("labelspeed")
    self.labelspeed:retain()
    self.labelspeed:removeFromParent()
    self.Button_speed:getVirtualRenderer():addChild(self.labelspeed)
    self.labelspeed:release()
    self.labelspeed:setFntFile("game/tgg/res/fnt/qtds_label_jb.fnt")

    self.Panel_bottom1 = scene.layer:getChildByName("Panel_bottom1")
    self.Text_winpoint = self.Panel_bottom1:getChildByName("Text_winpoint")
    self.Text_winpoint:setFntFile("game/tgg/res/fnt/qtds_label_jb.fnt")

    local Image_bet = self.Panel_bottom1:getChildByName("Image_bet")
    self.Button_sub = Image_bet:getChildByName("Button_sub")
    self.Button_sub:addClickEventListener(handler(self, self.onSub))
    self.Button_add = Image_bet:getChildByName("Button_add")
    self.Button_add:addClickEventListener(handler(self, self.onAdd))
    self.Text_totalbet = Image_bet:getChildByName("Text_totalbet")
    self.Text_totalbet:setFntFile("game/tgg/res/fnt/qsnh.fnt")

    self.Button_maxbet = self.Panel_bottom1:getChildByName("Button_maxbet")
    self.Button_maxbet:addClickEventListener(handler(self, self.onMaxBet))

    local Image_maxbet = self.Button_maxbet:getChildByName("Image_maxbet")
    Image_maxbet:retain()
    Image_maxbet:removeFromParent()
    self.Button_maxbet:getVirtualRenderer():addChild(Image_maxbet)
    Image_maxbet:release()

    self.Button_start = self.Panel_bottom1:getChildByName("Button_start")
    self.Button_start:addTouchEventListener(handler(self, self.onTouchBet))

    self.Image_start = self.Button_start:getChildByName("Image_start")
    self.Image_start:retain()
    self.Image_start:removeFromParent()
    self.Button_start:getVirtualRenderer():addChild(self.Image_start)
    self.Image_start:release()
    self.Image_start:ignoreContentAdaptWithSize(true)

    self.btn_start_text = self.Button_start:getChildByName("btn_start_text")
    self.btn_start_text:retain()
    self.btn_start_text:removeFromParent()
    self.Button_start:getVirtualRenderer():addChild(self.btn_start_text)
    self.btn_start_text:release()

    self.Panel_bottom2 = scene.layer:getChildByName("Panel_bottom2")
    self.freeBetFnt = self.Panel_bottom2:getChildByName("freeBetFnt")
    self.freeWinPoint = self.Panel_bottom2:getChildByName("freeWinPoint")
    self.freeTimesFnt = self.Panel_bottom2:getChildByName("freeTimesFnt")
    self.freeCountFnt = self.Panel_bottom2:getChildByName("freeCountFnt")

    self.freeBetFnt:setFntFile("game/tgg/res/fnt/qsnh.fnt")
    self.freeWinPoint:setFntFile("game/tgg/res/fnt/qtds_label_jb.fnt")
    self.freeCountFnt:setFntFile("game/tgg/res/fnt/qsnh.fnt")
    self.freeTimesFnt:setFntFile("game/tgg/res/fnt/tfont.fnt")
    self.Panel_bottom2:setVisible(false)

    self:updateSpeed()
    self:updateAutoBetBtn()
end

function TGGButton:setButtonState(bb)
    if bb and self.logic:getSumFreeCount() <= 0 then
        self.Button_add:setEnabled(true)
        self.Button_sub:setEnabled(true)
        self.Button_maxbet:setEnabled(true)
    else
        self.Button_add:setEnabled(false)
        self.Button_sub:setEnabled(false)
        self.Button_maxbet:setEnabled(false)
    end
    -- self.Button_start:setEnabled(bb)
end

function TGGButton:updateSpeed()
    local speed = self.logic:getSpeed()
    self.labelspeed:setString(speed)
end

function TGGButton:updateGold()
    self.my_gold:setString(self.logic:getPlayerGold())
end

function TGGButton:updateWinGold(gold)
    self.Text_winpoint:setString(gold)
end

function TGGButton:updateBetGold()
    self.Text_totalbet:setString(self.logic:getBetGold())
end

function TGGButton:onAddSpeed()
    PlazaManager.playClickEffect()
    self.logic:changeSpeed()
    self:updateSpeed()
end

function TGGButton:showFreeBetResult(show)
    if not self.Panel_bottom2:isVisible() then
        MusicManager.playEffect(string.format("game/tgg/res/audio/enterFree%d.mp3", math.random(1, 2)))
    end
    self.Panel_bottom2:setVisible(true)
    self.Panel_bottom1:setVisible(false)
    self.freeWinPoint:setString(self.logic.result.lWinScore) -- 总赢利
    self.freeCountFnt:setString(self.logic:getSumFreeCount()) -- 免费旋转
    self.freeTimesFnt:setString("x" .. self.logic.result.wSumBS)
    self.freeBetFnt:setString(self.logic:getBetGold())

    if show == 1 then
        if self.logic.result.wSumBS >= 1 then
            local xx = (self.logic.result.wSumBS - 1) % 12 + 1
            MusicManager.playEffect(string.format("game/tgg/res/audio/%dX.mp3", xx))
        end
        self.freeTimesFnt:setVisible(true)
        self.freeWinPoint:setVisible(false)
    else
        self.freeTimesFnt:setVisible(false)
        self.freeWinPoint:setVisible(true)
    end
end

function TGGButton:delayShowNormal(sec)
    local function doCallFun()
        self:showNormalBottom()
    end
    self.Panel_bottom2:stopAllActions()
    self.Panel_bottom2:runAction(cc.Sequence:create(cc.DelayTime:create(sec), cc.CallFunc:create(doCallFun)))
end

function TGGButton:showNormalBottom()
    if self.Panel_bottom1:isVisible() then
        return
    end

    MusicManager.playEffect("game/tgg/res/audio/endFree.mp3")
    self.logic:setSumFreeCount(0)
    self:updateWinGold(0)
    self.Panel_bottom2:stopAllActions()
    self.Panel_bottom1:setVisible(true)
    self.Panel_bottom2:setVisible(false)
end

function TGGButton:updateAutoBetBtn()
    local btn_res = "tggpic/zi_kaishi.png"
    local str = SubLang:word(4)
    if self.logic:isAutoBet() then
        btn_res = "tggpic/btn_tzzd.png"
        str = SubLang:word(5)
    elseif self.scene.actionView and self.scene.actionView:isInAction() then
        btn_res = "tggpic/zi_tingzhi.png"
        str = SubLang:word(6)
    end
    self.Image_start:loadTexture(btn_res, 1)
    self.btn_start_text:setString(str)
end

function TGGButton:updateCheckAuto()
    self.Button_start:stopAllActions()
    if self.logic:isAutoBet() then
        PlazaManager.tgg_auto_play_state = 1
        self.nCheckCount = 0
        local function doCheckAuto()
            if self.scene.actionView:isInAction() then
                self.nCheckCount = 0
                return
            end

            self.nCheckCount = self.nCheckCount + 1
            if self.nCheckCount >= 3 then
                self.logic:setIsAutoBet(true)
                self:doBet()
            end
        end
        local seq = cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(doCheckAuto))
        self.Button_start:runAction(cc.RepeatForever:create(seq))
    else
        PlazaManager.tgg_auto_play_state = 0
    end
end

function TGGButton:onSub()
    PlazaManager.playClickEffect()
    if self.scene.actionView:isInAction() then
        -- PlazaManager.showTips('请等待游戏结束后再点击...')
        return
    end

    if self.logic:getSumFreeCount() > 0 then
        PlazaManager.showTips(SubLang:word(2))
        return
    end

    self.logic:changeBetGoldByIdx(-1)
end

function TGGButton:onAdd()
    PlazaManager.playClickEffect()
    if self.scene.actionView:isInAction() then
        -- PlazaManager.showTips('请等待游戏结束后再点击...')
        return
    end

    if self.logic:getSumFreeCount() > 0 then
        PlazaManager.showTips(SubLang:word(2))
        return
    end

    self.logic:changeBetGoldByIdx(1)
end

function TGGButton:onMaxBet()
    PlazaManager.playClickEffect()
    if self.scene.actionView:isInAction() then
        -- PlazaManager.showTips('请等待游戏结束后再点击...')
        return
    end

    if self.logic:getSumFreeCount() > 0 then
        PlazaManager.showTips(SubLang:word(2))
        return
    end

    self.logic:setMaxBetGold()
end

function TGGButton:onTouchBet(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self:startCalcTime()
        PlazaManager.playClickEffect()
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self:stopSchedule()
        if self.elaspe < 0.5 then
            self.logic:setIsAutoBet(false)
            self:updateCheckAuto()
            self:doBet()
        end
    end
end

function TGGButton:startCalcTime()
    self:stopSchedule()
    self.elaspe = 0
    self.schedule1 = self.scheduler:scheduleScriptFunc(handler(self, self.calcTime), 0.1, false)
end

function TGGButton:stopSchedule()
    if self.schedule1 then
        self.scheduler:unscheduleScriptEntry(self.schedule1)
        self.schedule1 = nil
    end
end

function TGGButton:calcTime(dt)
    self.elaspe = self.elaspe + dt
    if self.elaspe >= 0.5 then
        self:stopSchedule()
        if self.logic:isAutoBet() then
            return
        end
        self.logic:setIsAutoBet(true)
        self:updateCheckAuto()
        self:doBet()
    end
end

function TGGButton:doBet()
    if self.logic.bIsTest then
        local params = self.logic:createTestData()
        self.scene:doBetMsg(params)
        return
    end

    if self.scene:isDisConnect() or globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
        if globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
            -- PlazaManager.showTips('不在游戏状态中, 请返回大厅重新进入')
        else
            -- self.scene:onReconnection()
        end
        self:setButtonState(true)
        return
    end

    if self.scene.actionView:isInAction() then
        -- PlazaManager.showTips('请等待游戏结束后再点击...')
        return
    end

    if self.logic:getSumFreeCount() > 0 then
        self.scene:overtimeReconnect(true)
        GameMessage.sendFreeScroll()
    else
        self:showNormalBottom()

        local lTableScore = self.logic:getBetGold()
        local gold = self.logic:getPlayerGold()
        if lTableScore > gold then
            self:setButtonState(true)
            PlazaManager.showTips(SubLang:word(3))
            self.logic:setIsAutoBet(false)
            self:updateCheckAuto()
        else
            self.scene:overtimeReconnect(true)
            GameMessage.sendCardScroll(self.logic.lBonusCellScore, self.logic.cbBonusLineCount)
        end
    end
end

function TGGButton:onHelp()
    PlazaManager.playClickEffect()
    local TGGHelpLayer = require("game.tgg.src.panel.TGGHelpLayer")
    local view = TGGHelpLayer.new(self.scene)
    view:setIgnoreAnchorPointForPosition(false)
    view:setAnchorPoint(display.CENTER)
    view:setPosition(display.cx, display.cy)
    self.scene:addChild(view)
end

function TGGButton:onSetting()
    PlazaManager.playClickEffect()
    local TGGSettingLayer = require("game.tgg.src.panel.TGGSettingLayer")
    local setWin = TGGSettingLayer.new(self)
    local x = (display.width - setWin:getContentSize().width) / 2
    local y = (display.height - setWin:getContentSize().height) / 2
    setWin:move(x, y):addTo(self.scene)
end

function TGGButton:doExit()
    PlazaManager.playClickEffect()
    if self.logic.bIsTest then
        return
    end
    self.scene:onQuestStandup()
    self.scene:onExitGame()
end

function TGGButton:onExit()
    self:stopSchedule()
    PlazaManager.tgg_auto_play_state = 0
end

return TGGButton
