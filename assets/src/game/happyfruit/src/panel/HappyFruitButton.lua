local GameMessage = require("game.happyfruit.src.HappyFruitMessage")
local HappyFruitButton = class("HappyFruitButton")

function HappyFruitButton:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.Panel_bottom = scene.layer:getChildByName("Panel_bottom")

    self.Image_guan = scene.layer:getChildByName("Image_guan")
    self.Image_guan:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))

    self.Button_bet = scene.layer:getChildByName("Button_bet")

    self.Button_bet:setScale(self.logic:getWinScale())
    self.Image_guan:setScale(self.logic:getWinScale())

    self.Button_help = scene.layer:getChildByName("Button_help")
    self.Button_sub1 = self.Panel_bottom:getChildByName("Button_sub1")
    self.Button_add1 = self.Panel_bottom:getChildByName("Button_add1")
    self.Button_sub2 = self.Panel_bottom:getChildByName("Button_sub2")
    self.Button_add2 = self.Panel_bottom:getChildByName("Button_add2")

    self.Button_exit = scene.layer:getChildByName("Button_exit")
    self.Button_setting = scene.layer:getChildByName("Button_setting")
    self.Sprite_gang = scene.Panel_center:getChildByName("Sprite_gang")
    self.Image_spin = scene.Panel_center:getChildByName("Image_spin")
    self.Text_free = self.Image_spin:getChildByName("Text_free")

    self.Button_jiasu = scene.layer:getChildByName("Button_jiasu")
    self.speedFnt = self.Button_jiasu:getChildByName("speedFnt")
    self.speedFnt:setFntFile("game/happyfruit/res/fnt/fnt_jiasu.fnt")

    self.Sprite_gangX, self.Sprite_gangY = self.Sprite_gang:getPosition()
    self.Image_spinX, self.Image_spinY = self.Image_spin:getPosition()

    self:bindButton()
    self:updateAutoBetBtn()
    self:updateSpeed()

    -- local x, y = self.Button_setting:getPosition()
    -- self.Button_setting:setVisible(false)
    -- self.Button_help:setPosition(x, y)
end

function HappyFruitButton:updateSpeed()
    local speed = self.logic:getSpeed()
    if speed > 1 then
        self.speedFnt:setString("x" .. speed)
    else
        self.speedFnt:setString("")
    end
end

function HappyFruitButton:onJiaSu()
    MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    self.logic:changeSpeed()
    self:updateSpeed()
end

function HappyFruitButton:bindButton()
    self.Button_bet:addTouchEventListener(handler(self, self.onBet))
    self.Button_help:addClickEventListener(handler(self, self.onHelp))
    self.Button_sub1:addClickEventListener(handler(self, self.onSub1))
    self.Button_sub2:addClickEventListener(handler(self, self.onSub2))
    self.Button_add1:addClickEventListener(handler(self, self.onAdd1))
    self.Button_add2:addClickEventListener(handler(self, self.onAdd2))
    self.Button_exit:addClickEventListener(handler(self, self.doExit))
    self.Button_setting:addClickEventListener(handler(self, self.onSetting))
    self.Button_jiasu:addClickEventListener(handler(self, self.onJiaSu))

    self.Image_spin:setTouchEnabled(true)
    self.Image_spin:addTouchEventListener(handler(self, self.onTouchSpin))
end

function HappyFruitButton:onBet(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        self:startCalcTime()
        MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    elseif eventType == ccui.TouchEventType.moved then
    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self:stopSchedule()
        if self.elaspe < 0.5 then
            self.logic:setIsAutoBet(false)
            if self.scene.actionView:isCanPlayNext() then
                self:autoMove()
            end
        end
    end
end

function HappyFruitButton:startCalcTime()
    self:stopSchedule()
    self.elaspe = 0
    self.schedule1 = self.scheduler:scheduleScriptFunc(handler(self, self.calcTime), 0.1, false)
end

function HappyFruitButton:stopSchedule()
    if self.schedule1 then
        self.scheduler:unscheduleScriptEntry(self.schedule1)
        self.schedule1 = nil
    end
end

function HappyFruitButton:calcTime(dt)
    self.elaspe = self.elaspe + dt
    if self.elaspe >= 0.5 then
        if self.scene.actionView:isCanPlayNext() then
            if self.logic:isAutoBet() then
                return
            end
            self.logic:setIsAutoBet(true)
            self:autoMove()
            self:stopSchedule()
        end
    end
end

function HappyFruitButton:updateAutoBetBtn()
    local btn_res = "fruit_machine_btn_touzhu.png"
    local btn_str = ""
    if self.logic:isAutoBet() then
        btn_res = "fruit_machine_btn_zidongtou.png"
        btn_str = SubLang:word(2)
        self.Image_guan:setVisible(true)
    else
        btn_str = SubLang:word(3)
        self.Image_guan:setVisible(false)
    end

    if self.logic:getBonusCount() > 0 then
        btn_str = ""
        btn_res = "fruit_machine_btn_free_bet.png"
        self.Image_guan:setVisible(true)
    end

    self.Button_bet:loadTextureNormal(btn_res, 1)
    self.Button_bet:setTitleText(btn_str)
    self.Button_bet:setTitleFontSize(22)
    self.Button_bet:setTitleColor(cc.WHITE)
end

function HappyFruitButton:onHelp()
    local HappyFruitHelpLayer = require("game.happyfruit.src.panel.HappyFruitHelpLayer")
    local view = HappyFruitHelpLayer.new(self.scene)
    view:setIgnoreAnchorPointForPosition(false)
    view:setAnchorPoint(display.CENTER)
    view:setPosition(display.cx, display.cy)
    self.scene:addChild(view)
end

function HappyFruitButton:onSub1()
    MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(4))
        return
    end

    if self.logic:getBonusCount() > 0 then
        PlazaManager.showTips(SubLang:word(5))
        return
    end

    if self.scene.actionView:isCanPlayNext() then
        self.logic:addLineCount(-1)
        self.scene.actionView:stopShowAnalyze()
        self.logic:setIsAutoBet(false)
    end
end

function HappyFruitButton:onSub2()
    MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(4))
        return
    end

    if self.logic:getBonusCount() > 0 then
        PlazaManager.showTips(SubLang:word(5))
        return
    end

    if self.scene.actionView:isCanPlayNext() then
        self.logic:addLineBet(-1)
    end
end

function HappyFruitButton:onAdd1()
    MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(4))
        return
    end

    if self.logic:getBonusCount() > 0 then
        PlazaManager.showTips(SubLang:word(5))
        return
    end

    if self.scene.actionView:isCanPlayNext() then
        self.logic:addLineCount(1)
        self.scene.actionView:stopShowAnalyze()
        self.logic:setIsAutoBet(false)
    end
end

function HappyFruitButton:onAdd2()
    MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(4))
        return
    end

    if self.logic:getBonusCount() > 0 then
        PlazaManager.showTips(SubLang:word(5))
        return
    end

    if self.scene.actionView:isCanPlayNext() then
        self.logic:addLineBet(1)
    end
end

function HappyFruitButton:onSetting()
    local HappyFruitSetWin = require("game.happyfruit.src.panel.HappyFruitSetWin")
    local setWin = HappyFruitSetWin.new(self)
    local x = (display.width - setWin:getContentSize().width) / 2
    local y = (display.height - setWin:getContentSize().height) / 2
    setWin:move(x, y):addTo(self.scene)
end

function HappyFruitButton:onTouchSpin(sender, eventType)
    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(4))
        return
    end

    if eventType == ccui.TouchEventType.began then
        if not self.scene.actionView:isCanPlayNext() then
            return
        end

        MusicManager.playEffect("game/happyfruit/res/audio/clickBt.mp3")
        self.scene.actionView:stopShowAnalyze()
        self.logic:setIsAutoBet(false)
    elseif eventType == ccui.TouchEventType.moved then
        if not self.scene.actionView:isCanPlayNext() then
            return
        end

        local pos1 = sender:getTouchBeganPosition()
        local pos2 = sender:getTouchMovePosition()
        local disSpin = math.max(math.min(pos2.y - pos1.y, 0), -150)
        self.Sprite_gang:setPositionY(self.Sprite_gangY + disSpin * 0.6)
        self.Image_spin:setPositionY(self.Image_spinY + disSpin)

    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self.Sprite_gang:setPositionY(self.Sprite_gangY)
        self.Image_spin:setPositionY(self.Image_spinY)

        if GameDefine.bIsLocalTest then
            self:doTestBet()
            return
        end

        if self.scene:isDisConnect() or globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
            self.scene.actionView:setCanPlay(true)
            if globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
                print("不在游戏状态中,请返回大厅重新进入")
                -- PlazaManager.showTips("不在游戏状态中,请返回大厅重新进入")
            else
                -- self.scene:onReconnection()
            end
            return
        end

        if not self.scene.actionView:isCanPlayNext() then
            return
        end

        local pos1 = sender:getTouchBeganPosition()
        local pos2 = sender:getTouchEndPosition()
        local disSpin = math.max(math.min(pos2.y - pos1.y, 0), -150)
        if disSpin < -50 then
            self:doBet()
        end
    end
end

function HappyFruitButton:genTestData()
    -- 卡片滚动
    local params = {}

    -- 卡片类型
    params.cbCardType = {}
    for i = 1, 15 do
        params.cbCardType[i] = math.random(0, 9)
    end

    -- 当前分数（未加上本次所赢得的分数值）
    params.lUserScore = math.random(0, 99999)

    -- 输赢分数 （包含中得彩金的数值）
    params.lWinScore = math.random(0, 99999)

    -- 中得彩金
    params.lWinGold = math.random(0, 99999)

    -- 中得免费摇奖次数
    params.cbBonusCount = math.random(0, 3)

    -- 剩余彩金
    params.lGoldPool = math.random(0, 99999)

    -- 中得免费摇奖总次数
    params.wSumBonusCount = math.random(0, 3)

    -- 本次是否免费摇奖
    params.bBonus = math.random(0, 1)

    return params
end

function HappyFruitButton:doTestBet()
    self.scene.actionView:stopShowAnalyze()
    self.scene.actionView:setCanPlay(false)
    self.scene:overtimeReconnect(false)
    self.scene:doBetMsg(self:genTestData())
end

function HappyFruitButton:doBet()
    if self.scene:isDisConnect() or globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
        print("押注中1")
        -- self.logic:setIsAutoBet(false)
        self.scene.actionView:setCanPlay(false)
        if globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
            print("不在游戏状态中,请返回大厅重新进入")
            -- PlazaManager.showTips("不在游戏状态中,请返回大厅重新进入")
        else
            -- self.scene:onReconnection()
        end
        return
    end

    if not self.scene.actionView:isCanPlayNext() or self.scene.actionView:isInAction() then
        print("skip doBet---->isCanPlayNext, isInAction:", self.scene.actionView:isCanPlayNext(), self.scene.actionView:isInAction())
        return
    end

    self.scene.actionView:stopShowAnalyze()

    if self.logic:getBonusCount() > 0 then
        self.scene.actionView:setCanPlay(false)
        self.scene:overtimeReconnect(true)
        GameMessage.sendBonusScroll()
    else
        local lTableScore = self.logic:getLineBet()
        local cbLineCount = self.logic:getLineCount()
        if cbLineCount == 0 then
            PlazaManager.showTips(SubLang:word(6))
        else
            local gold = self.logic:getPlayerGold()
            if lTableScore * cbLineCount > gold then
                PlazaManager.showTips(SubLang:word(7))
                self.logic:setIsAutoBet(false)
            else
                self.scene.actionView:setCanPlay(false)
                self.scene:overtimeReconnect(true)
                GameMessage.sendCardScroll(lTableScore, cbLineCount)
            end
        end
    end
end

function HappyFruitButton:autoMove()
    if not self.scene.actionView:isCanPlayNext() or self.scene:isDisConnect() or globalUserInfo.wTableID == GameDefine.INVALID_TABLE then
        return
    end
    local sec1 = 0.3 / self.logic:getActionSpeed()
    local sec2 = 0.1 / self.logic:getActionSpeed()
    local move1 = cc.MoveTo:create(sec1, cc.p(self.Sprite_gangX, self.Sprite_gangY - 90))
    local move2 = cc.MoveTo:create(sec2, cc.p(self.Sprite_gangX, self.Sprite_gangY))
    local call = cc.CallFunc:create(handler(self, self.doBet))
    local seq = cc.Sequence:create(move1, call, move2)
    self.Sprite_gang:runAction(seq)

    move1 = cc.MoveTo:create(sec1, cc.p(self.Image_spinX, self.Image_spinY - 150))
    move2 = cc.MoveTo:create(sec2, cc.p(self.Image_spinX, self.Image_spinY))
    seq = cc.Sequence:create(move1, move2)
    self.Image_spin:runAction(seq)
end

function HappyFruitButton:updateSpin()
    local res = "fruit_machine_btn_spin.png"
    --[[
	if self.scene.actionView:isStop() then
		if self.logic:getBonusCount() > 0 then
			res = "fruit_machine_btn_free.png"
		end
	else
		res = "fruit_machine_btn_stop.png"
	end
	--]]

    local free = self.logic:getBonusCount()
    local str = ""
    if free > 0 then
        res = "fruit_machine_btn_free.png"
        str = free
    end

    self.Image_spin:loadTexture(res, 1)
    self.Text_free:setString(str)

    self:updateAutoBetBtn()
end

function HappyFruitButton:doExit()
    self.scene:onQuestStandup()
    self.scene:onExitGame()
    -- self.scene:removeFromParent()
end

function HappyFruitButton:onExit()
    self:stopSchedule()
end

return HappyFruitButton
