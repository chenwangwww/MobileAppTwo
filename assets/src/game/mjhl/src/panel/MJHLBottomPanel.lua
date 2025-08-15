local GameMessage = require("game.mjhl.src.MJHLMessage")
local MJHLBottomPanel = class("MJHLBottomPanel")

function MJHLBottomPanel:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.scheduler = cc.Director:getInstance():getScheduler()

    self.Panel_bottom = scene.layer:getChildByName("Panel_bottom")

    local Image_bottombg = self.Panel_bottom:getChildByName("Image_bottombg")
    -- 头像
    local function clickHeadFunction()

    end
    local img_head = GameUtil.createAvatar(globalUserInfo.headimgurl, 70, true, clickHeadFunction, nil, nil, nil)
    img_head:align(display.CENTER, 85, 460):addTo(Image_bottombg)
    img_head:setName("img_head")

    self.Button_speed = self.Panel_bottom:getChildByName("Button_speed")
    self.Button_speed:addClickEventListener(handler(self, self.onAddSpeed))
    self.labelspeed = self.Button_speed:getTitleRenderer()
    self.labelspeed:setPosition(72, 8)

    self.FntCurWin = self.Panel_bottom:getChildByName("FntCurWin") -- 本轮得分
    self.FntCurWin:setFntFile("game/mjhl/res/fnt/num_mjfs_2.fnt")
    self.nCurBonusNum = 0

    self.Node_bet = self.Panel_bottom:getChildByName("Node_bet")
    self.Button_add = self.Node_bet:getChildByName("Button_add")
    self.Button_add:addClickEventListener(handler(self, self.onAdd))
    self.Button_sub = self.Node_bet:getChildByName("Button_sub")
    self.Button_sub:addClickEventListener(handler(self, self.onSub))

    self.Button_maxbet = self.Node_bet:getChildByName("Button_maxbet")
    self.Button_maxbet:addClickEventListener(handler(self, self.onMaxBet))

    self.Button_auto = self.Node_bet:getChildByName("Button_auto")
    self.Button_auto:addClickEventListener(handler(self, self.onAuto))

    self.Button_start = self.Node_bet:getChildByName("Button_start")
    self.Button_start:addTouchEventListener(handler(self, self.onTouchBet))
    self.btn_start_text = self.Button_start:getTitleRenderer()
    self.btn_start_text:setPosition(60, -10)

    local json = "game/mjhl/res/spine/spin_ske.json"
    local atlas = "game/mjhl/res/spine/spin_ske.atlas"
    self.btnStartSkel = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.btnStartSkel:setPosition(cc.p(60, 60))
    self.Button_start:getVirtualRenderer():addChild(self.btnStartSkel)
    self.btnStartSkel:setAnimation(0, "daiji", true)
    -- FS(方块暂停)  daiji（待机缓速旋转） dianji（点击急加速旋转）  zidong（自动显示方块停止)

    self.Text_coin = self.Node_bet:getChildByName("Text_coin") -- 金币
    self.Text_bet = self.Node_bet:getChildByName("Text_bet") -- 押注
    self.Text_totalbet = self.Node_bet:getChildByName("Text_totalbet") -- 总押注
    self.Text_twinkle = self.Node_bet:getChildByName("Text_twinkle") -- 金币变化量飘动
    self.Text_coin:setString(self.logic:getPlayerGold())
    self.Text_bet:setString("0")
    self.Text_totalbet:setString("0")
    self.Text_twinkle:setVisible(false)

    self.Node_free = self.Panel_bottom:getChildByName("Node_free")
    self.FntFreeLeft = self.Node_free:getChildByName("FntFreeLeft") -- 剩余免费旋转次数
    self.FntFreeLeft:setFntFile("game/mjhl/res/fnt/num_mjfs_2.fnt")
    self.Text_freeTotal = self.Node_free:getChildByName("Text_freeTotal") -- 免费总分
    self.Text_curScore = self.Node_free:getChildByName("Text_curScore") -- 本轮总分

    self.Text_freeTotal:setString("0")
    self.Text_curScore:setString("0")
    self.FntFreeLeft:setString("0")

    self.Node_free:setVisible(false)
    self.Node_bet:setVisible(true)

    self:updateSpeed()
    self:updateAutoBetBtn()
end

function MJHLBottomPanel:setScoreChange(num)
    if num == 0 or num == nil then
        return
    end

    if num > 0 then
        self.Text_twinkle:setString("+" .. num)
    else
        self.Text_twinkle:setString(num)
    end

    self.Text_twinkle:setVisible(true)
    self.Text_twinkle:setPositionY(211)
    self.Text_twinkle:setOpacity(255)
    local nSpeed = self.logic:getSpeed()
    local aa1 = cc.MoveTo:create(0.5 - (nSpeed - 1) * 0.08, cc.p(149, 258))
    local aa2 = cc.DelayTime:create(0.5 - (nSpeed - 1) * 0.08)
    local aa3 = cc.FadeOut:create(0.2 - (nSpeed - 1) * 0.03)
    local aa4 = cc.Hide:create()
    self.Text_twinkle:runAction(cc.Sequence:create(aa1, aa2, aa3))
end

function MJHLBottomPanel:setCurFreeScore(curScore)
    self.Text_freeTotal:setString(self.logic.lFreeSumGold) -- 免费总分
    self.Text_curScore:setString(curScore) -- 本轮总分
end

function MJHLBottomPanel:updateFreeSpinLeft()
    self.FntFreeLeft:setString(self.logic:getSumFreeCount())
end

function MJHLBottomPanel:setRoundDropBonus(num, weight)
    if self.nCurBonusNum == num then
        return
    end

    local nSpeed = self.logic:getSpeed()
    local times = 10 - (nSpeed - 1)
    local startNum = 0
    if num < self.nCurBonusNum or num == 0 then
        self.FntCurWin:stopAllActions()
        self.FntCurWin:setString(num)
        self.nCurBonusNum = num
        return
    else
        startNum = self.nCurBonusNum + math.ceil((num - self.nCurBonusNum) / 10)
    end
    self.nCurBonusNum = num

    local addNum = math.ceil((num - startNum) / times)
    self.FntCurWin:setString(startNum)

    local function doRepeatFun()
        startNum = startNum + addNum
        if startNum >= num then
            startNum = self.nCurBonusNum
            self.FntCurWin:stopAllActions()
        end
        self.FntCurWin:setString(startNum)
    end

    local seq = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(doRepeatFun))
    self.FntCurWin:runAction(cc.RepeatForever:create(seq))

    local json = "game/mjhl/res/spine/jinbi.json"
    local atlas = "game/mjhl/res/spine/jinbi.atlas"
    local skelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.Panel_bottom:addChild(skelNode)

    skelNode:setPosition(cc.p(375, 288))
    skelNode:setAnimation(0, "animation" .. weight, true)
    skelNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.6 - (nSpeed - 1) * 0.1), cc.RemoveSelf:create()))
    skelNode:setScale(0.1)
    -- skelNode:setTimeScale(self.nSpeed)
end

function MJHLBottomPanel:setButtonState(bb)
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

function MJHLBottomPanel:updateSpeed()
    local speed = self.logic:getSpeed()
    self.labelspeed:setString("x" .. speed)
end

function MJHLBottomPanel:updateGold()
    self.Text_coin:setString(self.logic:getPlayerGold())
end

function MJHLBottomPanel:updateBetGold(doSpine)
    self.Text_bet:setString(self.logic.lBonusCellScore)
    self.Text_totalbet:setString(self.logic:getBetGold())

    -- local maxScore = self.logic.wMultiCell[#self.logic.wMultiCell] * self.logic.lCellScore
    -- if doSpine and maxScore == self.logic.lBonusCellScore then
    --     local json = 'game/mjhl/res/spine/jinbi.json'
    --     local atlas = 'game/mjhl/res/spine/jinbi.atlas'
    --     local skelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    --     self.Text_totalbet:addChild(skelNode)

    --     skelNode:setPosition(cc.p(65, 17))
    --     skelNode:setAnimation(0, "animation3", false)
    --     skelNode:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.RemoveSelf:create()))
    --     skelNode:setScale(0.1)
    -- end
end

function MJHLBottomPanel:onAddSpeed()
    PlazaManager.playClickEffect()
    self.logic:changeSpeed()
    self:updateSpeed()
end

function MJHLBottomPanel:showFreeSpinPanel()
    if self.Node_free:isVisible() then
        return
    end
    MusicManager.stopBGM()
    MusicManager.playBGM("game/mjhl/res/audio/background_free.mp3")
    self.Node_free:setVisible(true)
    self.Node_bet:setVisible(false)

    self.Text_freeTotal:setString(0) -- 免费总分
    self.Text_curScore:setString(0) -- 本轮总分
end

function MJHLBottomPanel:showNormalBottom()
    if self.Node_bet:isVisible() then
        return
    end

    MusicManager.stopBGM()
    MusicManager.playBGM("game/mjhl/res/audio/background.mp3")
    self.logic:setSumFreeCount(0)
    self.Node_free:setVisible(false)
    self.Node_bet:setVisible(true)
end

function MJHLBottomPanel:updateAutoBetBtn()
    local str = SubLang:word(4)
    if self.logic:isAutoBet() then
        str = SubLang:word(5)
    end

    -- FS(方块暂停)  daiji（待机缓速旋转） dianji（点击急加速旋转）  zidong（自动显示方块停止)
    self.btn_start_text:setString(str)
    self:updateCheckAuto()
end

function MJHLBottomPanel:updateCheckAuto()
    self.Button_start:stopAllActions()
    if self.logic:isAutoBet() then
        PlazaManager.mjhl_auto_play_state = 1
        self.nCheckCount = 0
        local function doCheckAuto()
            if self.scene.actionView:isInAction() then
                self.nCheckCount = 0
                return
            end

            self.nCheckCount = self.nCheckCount + 1
            if self.nCheckCount >= 3 then
                if self.logic:isAutoBet() then
                    self.nCheckCount = 0
                    self:doBet()
                else
                    PlazaManager.mjhl_auto_play_state = 0
                    self.Button_start:stopAllActions()
                end
            end
        end
        local seq = cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(doCheckAuto))
        self.Button_start:runAction(cc.RepeatForever:create(seq))
    else
        PlazaManager.mjhl_auto_play_state = 0
    end
end

function MJHLBottomPanel:onSub()
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

function MJHLBottomPanel:onAdd()
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

function MJHLBottomPanel:onMaxBet()
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

function MJHLBottomPanel:onAuto()
    PlazaManager.playClickEffect()
    if self.logic:isAutoBet() then
        self.logic:setIsAutoBet(false)
    else
        self.logic:setIsAutoBet(true)
        self:doBet()
    end
end

function MJHLBottomPanel:onTouchBet(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self:startCalcTime()
        PlazaManager.playClickEffect()
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self:stopSchedule()
        if self.elaspe < 0.5 then
            self.logic:setIsAutoBet(false)
            self:doBet()
        end
    end
end

function MJHLBottomPanel:startCalcTime()
    self:stopSchedule()
    self.elaspe = 0
    self.schedule1 = self.scheduler:scheduleScriptFunc(handler(self, self.calcTime), 0.1, false)
end

function MJHLBottomPanel:stopSchedule()
    if self.schedule1 then
        self.scheduler:unscheduleScriptEntry(self.schedule1)
        self.schedule1 = nil
    end
end

function MJHLBottomPanel:calcTime(dt)
    self.elaspe = self.elaspe + dt
    if self.elaspe >= 0.5 then
        self:stopSchedule()
        if self.logic:isAutoBet() then
            return
        end
        self.logic:setIsAutoBet(true)
        self:doBet()
    end
end

function MJHLBottomPanel:doBet()
    if self.logic.bIsTest then
        if self.scene.actionView:isInAction() then
            return
        end
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
        self.btnStartSkel:setAnimation(0, "daiji", true)
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
            self.btnStartSkel:setAnimation(0, "daiji", true)
            self:setButtonState(true)
            PlazaManager.showTips(SubLang:word(3))
            self.logic:setIsAutoBet(false)
        else
            self.scene:overtimeReconnect(true)
            GameMessage.sendCardScroll(self.logic.lBonusCellScore, self.logic.cbBonusLineCount)
        end
    end
end

function MJHLBottomPanel:onExit()
    self:stopSchedule()
    PlazaManager.mjhl_auto_play_state = 0
end

return MJHLBottomPanel
