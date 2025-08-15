local MJHLTopPanel = class("MJHLTopPanel")

function MJHLTopPanel:ctor(scene)
    self.scene = scene
    self.logic = scene.logic
    self.Panel_top = scene.layer:getChildByName("Panel_top")

    self.Button_exit = self.Panel_top:getChildByName("Button_exit")
    self.Button_exit:addClickEventListener(handler(self, self.doExit))
    self.Button_setting = self.Panel_top:getChildByName("Button_setting")
    self.Button_setting:addClickEventListener(handler(self, self.onSetting))
    self.Button_help = self.Panel_top:getChildByName("Button_help")
    self.Button_help:addClickEventListener(handler(self, self.onHelp))

    self.Image_multi1 = self.Panel_top:getChildByName("Image_multi1")
    self.Image_multi2 = self.Panel_top:getChildByName("Image_multi2")
    self.Image_multi3 = self.Panel_top:getChildByName("Image_multi3")
    self.Image_multi4 = self.Panel_top:getChildByName("Image_multi4")
    self.tImageMulti = {self.Image_multi1, self.Image_multi2, self.Image_multi3, self.Image_multi4}
    self.tTopMulti = {1, 2, 3, 5}
    self.nTopMulti = 1

    self.Panel_fullScreen = scene.layer:getChildByName("Panel_fullScreen")
    self.fullScreenMask = self.Panel_fullScreen:getChildByName("fullScreenMask")
    self.fullScreeNode1 = self.Panel_fullScreen:getChildByName("Node_1")
    local node2 = self.Panel_fullScreen:getChildByName("Node_2")
    self.fntNum = node2:getChildByName("fntNum")
    self.fntNum:setFntFile("game/mjhl/res/fnt/num_mjfs_2.fnt")
    self.okButton = node2:getChildByName("okButton")
    self.okButton:addClickEventListener(handler(self, self.onFullScreenOk))
    self.Panel_fullScreen:setVisible(false)
    self.fullScreenMask:setVisible(false)
    self.fullScreenMask:setOpacity(122)

    self.tFunQueue = {}
    self:doRepeatPlayAudio()
end

function MJHLTopPanel:doRepeatPlayAudio()
    local function doRepeatFun()
        if self.scene.actionView:isInAction() then
            return
        end
        MusicManager.playEffect("game/mjhl/res/audio/wait/" .. math.random(1, 11) .. ".mp3")
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(10), cc.CallFunc:create(doRepeatFun))
    self.Panel_top:runAction(cc.RepeatForever:create(seq))
end

function MJHLTopPanel:setTopMulti(ii)
    local idx = ii
    if idx > 4 then
        idx = 4
    end
    local res = nil

    local nowMulti = self.tTopMulti[idx]
    if self.logic.result.bFreeGame == 1 then
        for i = 1, 4 do
            if i == idx then
                res = "mjhl_csi/mahjong_multifree_gold_x" .. (self.tTopMulti[i] * 2) .. ".png"
            else
                res = "mjhl_csi/mahjong_multifree_gray_" .. (self.tTopMulti[i] * 2) .. ".png"
            end
            self.tImageMulti[i]:loadTexture(res, 1)
        end
        nowMulti = nowMulti * 2
    else
        for i = 1, 4 do
            if i == idx then
                res = "mjhl_csi/mahjong_multi_gold_x" .. self.tTopMulti[i] .. ".png"
            else
                res = "mjhl_csi/mahjong_multi_gray_x" .. self.tTopMulti[i] .. ".png"
            end
            self.tImageMulti[i]:loadTexture(res, 1)
        end
    end

    if nowMulti > 1 and self.nTopMulti ~= nowMulti then
        MusicManager.playEffect("game/mjhl/res/audio/" .. nowMulti .. "mul.mp3")
    end
    self.nTopMulti = nowMulti
end

function MJHLTopPanel:hideWinFreeSpin()
    self:removeFullScreenSkel()
    self:stopWinVoiceId()
    self.fntNum:stopAllActions()
    self.okButton:stopAllActions()
    self.okButton:setVisible(false)
    self.Panel_fullScreen:setVisible(false)
    self.fullScreenMask:setVisible(false)
    if #self.tFunQueue > 0 then
        local info = table.remove(self.tFunQueue, 1)
        info.fun(info.obj, info.arg)
    else
        self.scene.actionView:onHideFullScreenSkel()
    end
end

function MJHLTopPanel:removeFullScreenSkel()
    if self.fullScreenSkelNode then
        self.fullScreenSkelNode:removeFromParent()
        self.fullScreenSkelNode = nil
    end
end

function MJHLTopPanel:onFullScreenOk()
    PlazaManager.playClickEffect()
    -- if self.okBtnAniIdx == "2"  then --结算领奖
    -- elseif self.okBtnAniIdx == "4" then --免费旋转开始
    -- end
    self.okBtnAni:setAnimation(0, "animation" .. self.okBtnAniIdx, false)
    self.okButton:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(handler(self, self.hideWinFreeSpin))))
end

-- ikind  1大奖  2巨奖  3超级巨奖
function MJHLTopPanel:showBigWin(tArg)
    if self.Panel_fullScreen:isVisible() then
        local tt = {
            obj = self,
            fun = self.showBigWin,
            arg = tArg
        }
        table.insert(self.tFunQueue, tt)
        return
    end

    self:stopWinVoiceId()
    self.Panel_fullScreen:setVisible(true)
    self.fullScreenMask:setVisible(true)
    self.okButton:setVisible(false)
    self:removeFullScreenSkel()

    self.fntNum:setScale(0.8)
    self.fntNum:setPositionY(650)

    local nSpeed = self.logic:getSpeed()
    local num = tArg[1]
    local ikind = tArg[2]
    local startNum = math.ceil(num / 10)
    local addNum = math.ceil((num - startNum) / (35 - nSpeed * 6))
    self.fntNum:setString(startNum)

    local function doRepeatFun()
        startNum = startNum + addNum
        if startNum >= num then
            startNum = num
            self.fntNum:stopAllActions()
            self.fntNum:runAction(cc.Sequence:create(cc.DelayTime:create(1 - (nSpeed - 1) * 0.1), cc.CallFunc:create(handler(self, self.hideWinFreeSpin))))
        end
        self.fntNum:setString(startNum)
    end

    self.winVoiceId = ccexp.AudioEngine:play2d("game/mjhl/res/audio/bigwin.mp3", false, MusicManager.effectVal)

    local seq = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(doRepeatFun))
    self.fntNum:runAction(cc.RepeatForever:create(seq))

    local json = "game/mjhl/res/spine/menang.json"
    local atlas = "game/mjhl/res/spine/menang.atlas"
    self.fullScreenSkelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.fullScreeNode1:addChild(self.fullScreenSkelNode)
    self.fullScreenSkelNode:setPosition(cc.p(375, 900))
    self.fullScreenSkelNode:setAnimation(0, "animation" .. ikind, true)
    self.fullScreenSkelNode:setTimeScale(nSpeed)
end

function MJHLTopPanel:stopWinVoiceId()
    if self.winVoiceId then
        ccexp.AudioEngine:stop(self.winVoiceId)
        self.winVoiceId = nil
    end
end

-- 显示获得免费摇奖次数
function MJHLTopPanel:showWinFreeSpin(num)
    if self.Panel_fullScreen:isVisible() then
        local tt = {
            obj = self,
            fun = self.showWinFreeSpin,
            arg = num
        }
        table.insert(self.tFunQueue, tt)
        return
    end

    MusicManager.playEffect("game/mjhl/res/audio/mjhl.mp3")
    self.Panel_fullScreen:setVisible(true)
    self.fntNum:setString(num)
    self.fntNum:setScale(1.5)
    self.fntNum:setPositionY(900)
    self:removeFullScreenSkel()

    local json = "game/mjhl/res/spine/bonus_transition.json"
    local atlas = "game/mjhl/res/spine/bonus_transition.atlas"
    self.fullScreenSkelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.fullScreeNode1:addChild(self.fullScreenSkelNode)

    self.fullScreenSkelNode:setPosition(cc.p(375, 667))
    self.fullScreenSkelNode:setAnimation(0, "animation", false)

    if self.okBtnAni == nil then
        local json = "game/mjhl/res/spine/anniu.json"
        local atlas = "game/mjhl/res/spine/anniu.atlas"
        self.okBtnAni = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        self.okButton:addChild(self.okBtnAni)
        self.okBtnAni:setPosition(192, 72)
        -- animation领奖 animation2领奖  animation3开始 animation4开始
        -- self.okBtnAni:setAnimation(0, "animation3", false) 
    end
    self.okBtnAniIdx = "4"
    self.okBtnAni:setAnimation(0, "animation3", false)
    self.okButton:setVisible(true)

    if self.logic:isAutoBet() then
        local nSpeed = self.logic:getSpeed()
        self.okButton:runAction(cc.Sequence:create(cc.DelayTime:create(2 - (nSpeed - 1) * 0.3), cc.CallFunc:create(handler(self, self.onFullScreenOk))))
    end
end

-- 显示免费摇奖共赢得金币数并点击领奖
function MJHLTopPanel:showAwardSettlement(num)
    if self.Panel_fullScreen:isVisible() then
        local tt = {
            obj = self,
            fun = self.showAwardSettlement,
            arg = num
        }
        table.insert(self.tFunQueue, tt)
        return
    end

    self.Panel_fullScreen:setVisible(true)
    self.fntNum:setScale(0.8)
    self.fntNum:setPositionY(1050)
    self:removeFullScreenSkel()

    local nSpeed = self.logic:getSpeed()
    local startNum = math.ceil(num / 10)
    local addNum = math.ceil((num - startNum) / (35 - nSpeed * 6))
    self.fntNum:setString(startNum)

    local function doRepeatFun()
        startNum = startNum + addNum
        if startNum >= num then
            startNum = num
            self.fntNum:stopAllActions()
        end
        self.fntNum:setString(startNum)
    end

    local seq = cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(doRepeatFun))
    self.fntNum:runAction(cc.RepeatForever:create(seq))

    local json = "game/mjhl/res/spine/total.json"
    local atlas = "game/mjhl/res/spine/total.atlas"
    self.fullScreenSkelNode = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
    self.fullScreeNode1:addChild(self.fullScreenSkelNode)
    self.fullScreenSkelNode:setPosition(cc.p(375, 667))
    self.fullScreenSkelNode:setAnimation(0, "animation", true)

    if self.okBtnAni == nil then
        local json = "game/mjhl/res/spine/anniu.json"
        local atlas = "game/mjhl/res/spine/anniu.atlas"
        self.okBtnAni = sp.SkeletonAnimation:createWithJsonFile(json, atlas, 1)
        self.okButton:addChild(self.okBtnAni)
        self.okBtnAni:setPosition(192, 72)
    end
    self.okBtnAniIdx = "2"
    -- animation领奖 animation2领奖  animation3开始 animation4开始
    self.okBtnAni:setAnimation(0, "animation", false)
    self.okButton:setVisible(true)
    MusicManager.playEffect("game/mjhl/res/audio/Wins.mp3")

    if self.logic:isAutoBet() then
        self.okButton:runAction(cc.Sequence:create(cc.DelayTime:create(2 - (nSpeed - 1) * 0.3), cc.CallFunc:create(handler(self, self.onFullScreenOk))))
    end
end

function MJHLTopPanel:onHelp()
    PlazaManager.playClickEffect()
    local MJHLHelpLayer = require("game.mjhl.src.panel.MJHLHelpLayer")
    local view = MJHLHelpLayer.new(self.scene)
    view:setIgnoreAnchorPointForPosition(false)
    view:setAnchorPoint(display.CENTER)
    view:setPosition(display.cx, display.cy)
    self.scene:addChild(view)
end

function MJHLTopPanel:onSetting()
    PlazaManager.playClickEffect()
    local MJHLSettingLayer = require("game.mjhl.src.panel.MJHLSettingLayer")
    local setWin = MJHLSettingLayer.new(self)
    local x = (display.width - setWin:getContentSize().width) / 2
    local y = (display.height - setWin:getContentSize().height) / 2
    setWin:move(x, y):addTo(self.scene)
end

function MJHLTopPanel:doExit()
    PlazaManager.playClickEffect()
    if self.logic.bIsTest then
        return
    end
    self.scene:onQuestStandup()
    self.scene:onExitGame()
end

function MJHLTopPanel:onExit()
    PlazaManager.mjhl_auto_play_state = 0
end

return MJHLTopPanel
