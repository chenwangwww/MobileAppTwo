local GameMessage = require("game.mlcs.src.MLCSMessage")
local MLCSButton = class("MLCSButton")

function MLCSButton:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.scheduler = cc.Director:getInstance():getScheduler()

    self.Panel_right = scene.layer:getChildByName("Panel_right")

    self.Button_exit = self.Panel_right:getChildByName("Button_exit")
    self.Button_exit:addClickEventListener(handler(self, self.doExit))
    self.Button_setting = self.Panel_right:getChildByName("Button_setting")
    self.Button_setting:addClickEventListener(handler(self, self.onSetting))
    self.Button_help = self.Panel_right:getChildByName("Button_help")
    self.Button_help:addClickEventListener(handler(self, self.onHelp))

    self.Button_speed = scene.layer:getChildByName("Button_speed")
    self.Button_speed:addClickEventListener(handler(self, self.onAddSpeed))
    self.labelspeed = self.Button_speed:getChildByName("labelspeed")
    self.labelspeed:retain()
    self.labelspeed:removeFromParent()
    self.Button_speed:getVirtualRenderer():addChild(self.labelspeed)
    self.labelspeed:release()
    self.labelspeed:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")

    self.Image_top = scene.layer:getChildByName("Image_top")
    self.tMultiplier = {self.Image_top:getChildByName("Image_multiplier1"), self.Image_top:getChildByName("Image_multiplier2"), self.Image_top:getChildByName("Image_multiplier3"),
                        self.Image_top:getChildByName("Image_multiplier4"), self.Image_top:getChildByName("Image_multiplier5")}

    self.tMultipIcon = {{"mlcspic/x1_1.png", "mlcspic/x1_2.png"}, {"mlcspic/x15_1.png", "mlcspic/x15_2.png"}, {"mlcspic/x2_1.png", "mlcspic/x2_2.png"}, {"mlcspic/x25_1.png", "mlcspic/x25_2.png"},
                        {"mlcspic/x3_1.png", "mlcspic/x3_2.png"}}

    self.Panel_bottom = scene.layer:getChildByName("Panel_bottom")
    self.Button_sub = self.Panel_bottom:getChildByName("Button_sub")
    self.Button_sub:addClickEventListener(handler(self, self.onSub))
    self.Button_add = self.Panel_bottom:getChildByName("Button_add")
    self.Button_add:addClickEventListener(handler(self, self.onAdd))
    self.Button_maxbet = self.Panel_bottom:getChildByName("Button_maxbet")
    self.Button_maxbet:addClickEventListener(handler(self, self.onMaxBet))
    self.Button_auto = self.Panel_bottom:getChildByName("Button_auto")
    self.Button_auto:addClickEventListener(handler(self, self.onAuto))
    self.Button_start = self.Panel_bottom:getChildByName("Button_start")
    self.Button_start:addClickEventListener(handler(self, self.onClickStart))

    self.BitmapFontLabel_gold = self.Panel_bottom:getChildByName("BitmapFontLabel_gold")
    self.BitmapFontLabel_count = self.Panel_bottom:getChildByName("BitmapFontLabel_count")
    self.BitmapFontLabel_bet = self.Panel_bottom:getChildByName("BitmapFontLabel_bet")
    self.BitmapFontLabel_gold:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")
    self.BitmapFontLabel_count:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")
    self.BitmapFontLabel_bet:setFntFile("game/mlcs/res/fnt/qtds_label_xs.fnt")

    self.Image_freeSpins = scene.layer:getChildByName("Image_freeSpins")
    self.Image_freeSpins:setVisible(false)
    self.freespin = self.Image_freeSpins:getChildByName("freespin")
    self.freespin:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")

    self.Panel_free = scene.layer:getChildByName("Panel_free")
    self.Panel_free:setVisible(false)
    local Image_bg = self.Panel_free:getChildByName("Image_bg")
    self.freewin = Image_bg:getChildByName("freewin")
    self.freecount = Image_bg:getChildByName("freecount")
    self.freewin:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")
    self.freecount:setFntFile("game/mlcs/res/fnt/qtds_label_jb.fnt")

    if LangCtrl:isEng() then
        local img1 = Image_bg:getChildByName("Image_name1") -- 免费旋转
        local img2 = Image_bg:getChildByName("Image_name2") -- 总赢利
        GameUtil.convImgToTTF(img1, SubLang:word(4), 20)
        GameUtil.convImgToTTF(img2, SubLang:word(5), 20)
    end

    self.Panel_win = scene.layer:getChildByName("Panel_win")

    self:updateSpeed()
    self:updateAutoBetBtn()
    self:updateMultiplier()
end

function MLCSButton:setButtonState(bb)
    if bb and self.logic:getSumFreeCount() <= 0 then
        self.Button_add:setEnabled(true)
        self.Button_sub:setEnabled(true)
        self.Button_maxbet:setEnabled(true)
    else
        self.Button_add:setEnabled(false)
        self.Button_sub:setEnabled(false)
        self.Button_maxbet:setEnabled(false)
    end
    self.Button_start:setEnabled(bb)
end

function MLCSButton:updateMultiplier()
    for i = 1, 5 do
        if i <= self.logic.nCurGroupIdx then
            self.tMultiplier[i]:loadTexture(self.tMultipIcon[i][2], 1)
        else
            self.tMultiplier[i]:loadTexture(self.tMultipIcon[i][1], 1)
        end
    end
end

function MLCSButton:updateSpeed()
    local speed = self.logic:getSpeed()
    self.labelspeed:setString(speed)
end

function MLCSButton:updateGold()
    self.BitmapFontLabel_gold:setString(self.logic:getPlayerGold())
end

function MLCSButton:updateWinGold(gold)
    self.BitmapFontLabel_count:setString(gold)
end

function MLCSButton:updateBetGold()
    self.BitmapFontLabel_bet:setString(self.logic:getBetGold())
end

function MLCSButton:onAddSpeed()
    PlazaManager.playClickEffect()
    self.logic:changeSpeed()
    self:updateSpeed()
end

function MLCSButton:onAuto()
    PlazaManager.playClickEffect()
    self.logic:setIsAutoBet(not self.logic:isAutoBet())

    if self.logic:isAutoBet() then
        PlazaManager.mlcs_auto_play_state = 1
        if not self.scene.actionView:isInAction() then
            self:doBet()
        end
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
        self.Button_auto:runAction(cc.RepeatForever:create(seq))
    else
        self.Button_auto:stopAllActions()
        PlazaManager.mlcs_auto_play_state = 0
    end
end

function MLCSButton:showGainGold(num)
    MusicManager.playEffect("game/mlcs/res/audio/gquest_bigwin_collectcoin.mp3")
    local speed = self.logic:getSpeed() - 1
    local emitter = cc.ParticleSystemQuad:create("game/mlcs/res/particle/bigWin2.plist")
    emitter:setPosition(cc.p(0, 168))
    emitter:setAutoRemoveOnFinish(true)
    emitter:setDuration(2 - (speed * 0.3)) -- 设置粒子系统的持续时间秒
    self.Panel_win:addChild(emitter)

    local AtlasLabel_num = cc.LabelAtlas:create("0", "game/mlcs/res/fnt/shuzi2.png", 72, 87, string.byte("0"))
    AtlasLabel_num:setPosition(cc.p(0, 518))
    AtlasLabel_num:setAnchorPoint(display.CENTER)
    self.Panel_win:addChild(AtlasLabel_num)
    AtlasLabel_num:setString(num)
    AtlasLabel_num:setScale(0.2)
    AtlasLabel_num:setOpacity(0)

    local seq = cc.Sequence:create(cc.DelayTime:create(0.5 - speed * 0.1), cc.FadeIn:create(0.1), cc.EaseElasticOut:create(cc.ScaleTo:create(0.5 - speed * 0.1, 1)),
        cc.DelayTime:create(1 - speed * 0.1), cc.FadeOut:create(0.3 - speed * 0.05), cc.RemoveSelf:create())
    AtlasLabel_num:runAction(seq)
end

function MLCSButton:showGainFreeCount(count)
    MusicManager.playEffect("game/mlcs/res/audio/gquest_outfree.mp3")
    self.Image_freeSpins:setVisible(true)
    self.freespin:setString(count)
    local speed = self.logic:getSpeed() - 1

    self.Image_freeSpins:setScale(0.2)
    local scale1 = cc.EaseElasticOut:create(cc.ScaleTo:create(0.3 - speed * 0.05, 1))
    local delay = cc.DelayTime:create(2 - speed * 0.3)
    local scale2 = cc.EaseBounceIn:create(cc.ScaleTo:create(0.2 - speed * 0.02, 0.2))
    local hide = cc.Hide:create()
    local seq = cc.Sequence:create(scale1, delay, scale2, hide)
    self.Image_freeSpins:stopAllActions()
    self.Image_freeSpins:runAction(seq)
end

function MLCSButton:showFreeBetResult(sec)
    if not self.Panel_free:isVisible() then
        MusicManager.playBGM("game/mlcs/res/audio/gquest_background_free.mp3")
    end

    self.Panel_free:setVisible(true)
    self.Panel_bottom:setVisible(false)
    self.freewin:setString(self.logic:getFreeSumGold()) -- 总赢利
    self.freecount:setString(self.logic:getSumFreeCount()) -- 免费旋转
    self.Panel_free:stopAllActions()
    if sec and sec > 0 then
        local function doCallFun()
            self:showNormalBottom()
        end
        self.Panel_free:runAction(cc.Sequence:create(cc.DelayTime:create(sec), cc.CallFunc:create(doCallFun)))
    end

    local Image_bg2 = self.scene.layer:getChildByName("Image_bg2")
    Image_bg2:loadTexture("mlcspic/di2.png", 1)
end

function MLCSButton:showNormalBottom()
    if self.Panel_bottom:isVisible() then
        return
    end

    self.logic:setSumFreeCount(0)
    self.logic:setFreeSumGold(0)
    self:updateWinGold(0)
    MusicManager.playBGM("game/mlcs/res/audio/background.mp3")
    self.Panel_free:stopAllActions()
    self.Panel_bottom:setVisible(true)
    self.Panel_free:setVisible(false)
    local Image_bg2 = self.scene.layer:getChildByName("Image_bg2")
    Image_bg2:loadTexture("mlcspic/di1.png", 1)
end

function MLCSButton:updateAutoBetBtn()
    local btn_res = "mlcspic/btn_auto_1.png"
    if self.logic:isAutoBet() then
        btn_res = "mlcspic/btn_auto_2.png"
    end
    self.Button_auto:loadTextureNormal(btn_res, 1)
end

function MLCSButton:onHelp()
    PlazaManager.playClickEffect()
    local MLCSHelpLayer = require("game.mlcs.src.panel.MLCSHelpLayer")
    local view = MLCSHelpLayer.new(self.scene)
    view:setIgnoreAnchorPointForPosition(false)
    view:setAnchorPoint(display.CENTER)
    view:setPosition(display.cx, display.cy)
    self.scene:addChild(view)
end

function MLCSButton:onSub()
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

function MLCSButton:onAdd()
    PlazaManager.playClickEffect()
    if self.scene.actionView:isInAction() then
        -- PlazaManager.showTips('请等待游戏结束后再点击...')
        return
    end

    if self.logic:getSumFreeCount() > 0 then
        -- PlazaManager.showTips('当前有免费摇奖，不能修改下注数额。')
        return
    end

    self.logic:changeBetGoldByIdx(1)
end

function MLCSButton:onMaxBet()
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

function MLCSButton:onSetting()
    PlazaManager.playClickEffect()
    local MLCSSettingLayer = require("game.mlcs.src.panel.MLCSSettingLayer")
    local setWin = MLCSSettingLayer.new(self)
    local x = (display.width - setWin:getContentSize().width) / 2
    local y = (display.height - setWin:getContentSize().height) / 2
    setWin:move(x, y):addTo(self.scene)
end

function MLCSButton:onClickStart()
    MusicManager.playEffect("game/mlcs/res/audio/start_game.mp3")
    self:doBet()
end

function MLCSButton:doBet()

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
        self.logic:setFreeSumGold(0)
        self.Panel_bottom:setVisible(true)
        self.Panel_free:setVisible(false)
        local Image_bg2 = self.scene.layer:getChildByName("Image_bg2")
        Image_bg2:loadTexture("mlcspic/di1.png", 1)

        local lTableScore = self.logic:getBetGold()
        local gold = self.logic:getPlayerGold()
        if lTableScore > gold then
            self:setButtonState(true)
            PlazaManager.showTips(SubLang:word(3))
            self.logic:setIsAutoBet(false)
            self.Button_auto:stopAllActions()
        else
            self.scene:overtimeReconnect(true)
            GameMessage.sendCardScroll(self.logic.lBonusCellScore, self.logic.cbBonusLineCount)
        end
    end
end

function MLCSButton:doExit()
    PlazaManager.playClickEffect()
    if self.logic.bIsTest then
        -- self:showFreeBetResult(88, 3)
        -- self:showGainFreeCount(88)
        self:showGainGold(math.random(88, 9999))
        return
    end
    self.scene:onQuestStandup()
    self.scene:onExitGame()
end

function MLCSButton:onExit()
    PlazaManager.mlcs_auto_play_state = 0
end

return MLCSButton
