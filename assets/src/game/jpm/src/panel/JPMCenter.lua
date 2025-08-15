local JPMCenter = class("JPMCenter", function()
    return cc.Node:create()
end)

local JPMRule = require("game.jpm.src.panel.JPMRule")
local JPMSetting = require("game.jpm.src.panel.JPMSetting")
local GameMessage = require("game.jpm.src.JPMMessage")
local GameCMD = require("game.jpm.src.JPMCMD")
local JumpText = require("game.jpm.src.panel.JumpText")
local JPMSound = require("game.jpm.src.JPMSound")

JPMCenter.State = {
    NORMAL = 0,
    AUTO = 1,
    DISABLE = 2
}

local CARD_IMG = {
    [1] = "game/jpm/res/main/icon_10.png",
    [2] = "game/jpm/res/main/icon_9.png",
    [3] = "game/jpm/res/main/icon_8.png",
    [4] = "game/jpm/res/main/icon_7.png",
    [5] = "game/jpm/res/main/icon_6.png",
    [6] = "game/jpm/res/main/icon_5.png",
    [7] = "game/jpm/res/main/icon_4.png",
    [8] = "game/jpm/res/main/icon_3.png",
    [9] = "game/jpm/res/main/icon_2.png",
    [10] = "game/jpm/res/main/icon_1.png",
    [11] = "game/jpm/res/main/icon_12.png",
    [12] = "game/jpm/res/main/icon_11.png"
}

function JPMCenter:ctor(t1, scene)
    self.root_ = cc.CSLoader:createNode("game/jpm/res/LayerMain.csb")
    self.root_:addTo(self)
    self.scene = scene
    self.frame_cache = cc.SpriteFrameCache:getInstance()

    local uiTop = self.root_:getChildByName("top")
    self.uiCoin = uiTop:getChildByName("coin")
    self.uiCoin:setVisible(false)
    self.uiCoin1 = uiTop:getChildByName("coin1")
    uiTop:getChildByName("btnBack"):addClickEventListener(handler(self, self.onClick))
    uiTop:getChildByName("btnSetting"):addClickEventListener(handler(self, self.onClick))
    uiTop:getChildByName("btnRule"):addClickEventListener(handler(self, self.onClick))
    self.uiFreePanel = uiTop:getChildByName("freespins")
    self.uiFreeSpinsLabel = self.uiFreePanel:getChildByName("freeCount")

    local uiBottom = self.root_:getChildByName("bottom")
    self.uiYazuLabel = uiBottom:getChildByName("yazhulabel")
    self.uiZongXiaZuLabel = uiBottom:getChildByName("zongyazhulabel")
    self.uiJiangjin = uiBottom:getChildByName("jiangjin")
    self.uiBtnSpeed = uiBottom:getChildByName("btnSpeed")
    self.gameSpeed = 1;
    self:changeGameSpeed()
    -- uiBottom:getChildByName("btnAuto"):addClickEventListener(handler(self,self.onClick))
    -- uiBottom:getChildByName("btnRotate"):addClickEventListener(handler(self,self.onClick))

    self.uiBtnSpeed:addClickEventListener(handler(self, self.onClick))
    self.btnStart = uiBottom:getChildByName("btnStart")
    self:changeStartStatus(JPMCenter.State.NORMAL)
    self.isAutoSend = false
    self.btnStart:addTouchEventListener(function(pSender, touchType)
        if self.btnStartState == JPMCenter.State.DISABLE then
            return
        end
        if touchType == ccui.TouchEventType.began then

            if self.btnStartState == JPMCenter.State.NORMAL then
                pSender:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                    self:changeStartStatus(JPMCenter.State.AUTO)
                end)))
            end
        elseif touchType == ccui.TouchEventType.ended then
            pSender:stopAllActions()
            if self.isAutoSend then
                self:changeStartStatus(JPMCenter.State.NORMAL)
                self.isAutoSend = false;
                JPMSound.click()
            else
                JPMSound.clickSpin();
                -- self:changeStartStatus(JPMCenter.State.DISABLE)
                self:sendScrollMessage()
            end
            if self.btnStartState ~= JPMCenter.State.DISABLE then
                self.isAutoSend = self.btnStartState == JPMCenter.State.AUTO
            end
        end
    end)

    uiBottom:getChildByName("yazhujian"):addClickEventListener(handler(self, self.onClickXiaZu))
    uiBottom:getChildByName("yazhujia"):addClickEventListener(handler(self, self.onClickXiaZu))
    self.uiYaZhuJia = uiBottom:getChildByName("yazhujia")
    self.uiYaZhuJian = uiBottom:getChildByName("yazhujian")

    local game = self.root_:getChildByName("game")
    self.cardColumn = {};
    for i = 1, 5 do
        self.cardColumn[i] = game:getChildByName("column" .. (i - 1))
    end
    self.strBlurVsh = cc.FileUtils:getInstance():getStringFromFile("game/jpm/res/example_Simple.vsh")
    self.strBlurFsh = cc.FileUtils:getInstance():getStringFromFile("game/jpm/res/example_Blur.fsh")
    self.uiLines = game:getChildByName("lines")
    self.uiLineScore = game:getChildByName("score")

    self.uiLines:addClickEventListener(handler(self, self.onClick))
    self.uiLines:setVisible(false)

    self.jumpCoin = JumpText.new(self.uiJiangjin)
    self:setWinAllScore(0)
    self.uiNoticePanel = uiTop:getChildByName("notice")
    self.uiNoticeLabel = self.uiNoticePanel:getChildByName("panel"):getChildByName("txt")
    self.isScrolling = false

    -- GameUtil.printNodeTree(1, " - ", self.root_)
end

function JPMCenter:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "check frame not found frame:" .. tostring(name)
        print("jpm_test: " .. str)

        local png = "game/jpm/res/LayerMain.png"
        local plist = "game/jpm/res/LayerMain.plist"
        self.frame_cache:addSpriteFrames(plist, png)

        -- frame = self.frame_cache:getSpriteFrameByName(name)
    end
    -- return frame ~= nil
end

function JPMCenter:onExit()

end

function JPMCenter:changeStartStatus(state)
    if self.btnStartState == state then
        return;
    end
    self.btnStartState = state;
    self.btnStart:getChildByName("normal"):setVisible(state == JPMCenter.State.NORMAL)
    self.btnStart:getChildByName("auto"):setVisible(state == JPMCenter.State.AUTO)
    self.btnStart:getChildByName("disable"):setVisible(state == JPMCenter.State.DISABLE)
end

function JPMCenter:onScrollEnd()
    if self.btnStartState ~= JPMCenter.State.AUTO then
        self:changeStartStatus(JPMCenter.State.NORMAL)
    end
end

function JPMCenter:setSceneData(params)
    self.params = params;
    self:setUserScore(params.lUserScore)

    self.diZhuBei = params.lBonusCellScore / params.lCellScore
    self.lBonusCellScore = self.diZhuBei * params.lCellScore

    self:refershXiaZu()
end

function JPMCenter:refershXiaZu()
    local params = self.params
    self.lBonusCellScore = params.lCellScore * self.diZhuBei
    self.uiYazuLabel:setText(self.lBonusCellScore)
    self.uiZongXiaZuLabel:setText(params.cbBonusLineCount * self.lBonusCellScore)
end

function JPMCenter:showNotice(msg)
    if msg == nil then
        self.uiNoticePanel:setVisible(false)
        return
    end
    self.uiNoticePanel:setVisible(true);
    self.uiNoticeLabel:setText(msg);
    self.uiNoticeLabel:stopAllActions()
    self.uiNoticeLabel:setPositionX(800)
    self.uiNoticeLabel:runAction(cc.Sequence:create(cc.MoveTo:create(8, cc.p(-550, self.uiNoticeLabel:getPositionY())), cc.CallFunc:create(function()
        self:showNotice(nil);
    end)))
end

function JPMCenter:setUserScore(score)
    self.uiCoin:setString(score)
    -- self.uiCoin1:setText(GameUtil.formatAsset(score or 0));
    self.uiCoin1:setText(score);
end

function JPMCenter:setWinAllScore(score)
    local speed = {0.8, 0.7, 0.6, 0.5};
    self.jumpCoin:setText(score, speed[self.gameSpeed])
end

function JPMCenter:setWinScore(score)
    if score == 0 then
        return self.uiLineScore:setVisible(false);
    end
    self.uiLineScore:setString(score)
    self.uiLineScore:stopAllActions();
    self.uiLineScore:setVisible(true);
    self.uiLineScore:setScale(5.0)
    self.uiLineScore:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function JPMCenter:refershReward(str)
    self.uiJiangjin:setString(str)
end

function JPMCenter:setFreeSpines(c)
    self.uiFreePanel:setVisible(c > 0)
    self.uiFreeSpinsLabel:setString(c);
end

function JPMCenter:onClick(e)
    JPMSound.click()
    local tag = e:getTag()
    if tag == 1 then
        JPMRule:new():addTo(self);
    elseif tag == 2 then
        JPMSetting:new():addTo(self);
    elseif tag == 0 then
        self.scene:onQuestStandup()
        self.scene:onExitGame()
        cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT)
        self.scene:removeEvent()

        LoadingManager.removeLoadRes(GameCMD.KIND_ID)
    elseif tag == 3 then
        self.scene:onCardCalc()
    elseif tag == 4 then
        -- self:sendScrollMessage()
    elseif tag == 5 then
        self:changeGameSpeed()
    elseif tag == 28 then
        --	self.scene:startCrash()
        self.uiLines:setVisible(false)
    end
end

function JPMCenter:onClickXiaZu(e)
    if e:getTag() == 45 and self.diZhuBei > 1 then
        self.diZhuBei = self.diZhuBei - 1
        self:refershXiaZu();
        JPMSound.click()
    elseif e:getTag() == 46 and self.diZhuBei < #self.params.wMultiCell then
        self.diZhuBei = self.diZhuBei + 1
        self:refershXiaZu();
        JPMSound.click()
    end
end

function JPMCenter:changeGameSpeed()
    self.gameSpeed = (self.gameSpeed + 1)
    if self.gameSpeed == 5 then
        self.gameSpeed = 1
    end
    self.uiBtnSpeed:getChildByName("1"):setVisible(self.gameSpeed == 1)
    self.uiBtnSpeed:getChildByName("2"):setVisible(self.gameSpeed == 2)
    self.uiBtnSpeed:getChildByName("3"):setVisible(self.gameSpeed == 3)
    self.uiBtnSpeed:getChildByName("4"):setVisible(self.gameSpeed == 4)
end

function JPMCenter:sendScrollMessage()
    if self.btnStartState ~= JPMCenter.State.AUTO then
        self:changeStartStatus(JPMCenter.State.DISABLE)
    end
    GameMessage.sendCardScroll(self.lBonusCellScore, self.params.cbBonusLineCount)
    self:setYaZhuBtnEnable(false)
    self:setWinAllScore(0)
    self:setWinScore(0)
    self:startSendRevert()
    self:setWinAllScore(0)
    --[[if self.isAutoSend == false then 
		self.btnStart:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function ()
			--self:changeStartStatus(JPMCenter.State.AUTO)
			if self.btnStart.state_ ~= JPMCenter.State.AUTO then self:changeStartStatus(JPMCenter.State.NORMAL) end
		end)))
	end--]]
end

function JPMCenter:setYaZhuBtnEnable(e)
    self.uiYaZhuJian:setEnabled(e)
    self.uiYaZhuJia:setEnabled(e)
    if e then
        self.uiYaZhuJia:setColor(cc.WHITE)
        self.uiYaZhuJian:setColor(cc.WHITE)
    else
        self.uiYaZhuJia:setColor(cc.c3b(57, 57, 57))
        self.uiYaZhuJian:setColor(cc.c3b(57, 57, 57))
    end
end

function JPMCenter:startSendRevert()
    if self.timeoutaction then
        self:stopAction(self.timeoutaction)
    end
    self.timeoutFunc = function()
        self.scene:refreshGame()
    end
    self.timeoutaction = self:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(function()
        self.timeoutaction = nil
        if self.timeoutFunc then
            self.timeoutFunc()
        end
    end)))
end

function JPMCenter:autoStartScroll()
    if self.btnStartState == JPMCenter.State.AUTO then
        self:sendScrollMessage()
    else
        self:setYaZhuBtnEnable(true)
    end
end

function JPMCenter:resetCard(cards)
    local midWidth = self.cardColumn[1]:getContentSize().width / 2
    for i = 1, 5 do
        self.cardColumn[i]:removeAllChildren();

        for j = 1, 3 do
            local card = cards[j][i];
            local res = CARD_IMG[card]
            self:checkFrame(res)
            local sp = ccui.ImageView:create(res, 1)
            -- cc.Sprite:createWithSpriteFrameName(res)
            self.cardColumn[i]:addChild(sp);
            sp:setPosition(midWidth, 550)
            sp:setTag(j);
            sp:setPosition(cc.p(midWidth, 153 * (j - 0.5)))
        end
    end
    self.uiLines:setVisible(false)
end

function JPMCenter:setCardData(cards, cb)
    self.timeoutFunc = nil
    if self.timeoutaction then
        self:stopAction(self.timeoutaction)
    end
    self.timeoutaction = nil
    local midWidth = self.cardColumn[1]:getContentSize().width / 2

    for i = 1, 20 do
        for j = 1, 5 do
            local card = cards[i][j];
            if card >= 12 then
                cards[i][j] = 11
                card = 11
            end
        end
    end

    local this = self;
    local isFirst = true

    local delaySpeeds = {0.06, 0.04, 0.03, 0.015}
    local moveSpeeds = {0.15, 0.11, 0.07, 0.03}
    local delayTime = delaySpeeds[self.gameSpeed]
    local moveTime = moveSpeeds[self.gameSpeed]
    local turnsoundid = 0;

    for i = 1, 5 do

        ----[[
        local tnodes = self.cardColumn[i]:getChildren()
        for _, vvv in ipairs(tnodes) do
            if not vvv:getActionByTag(999888) then
                local act = cc.Sequence:create(cc.DelayTime:create(0.6), cc.RemoveSelf:create())
                act:setTag(999888)
                vvv:runAction(act)
            end
        end
        -- ]]

        for m = 1, 3 do
            local chd = self.cardColumn[i]:getChildByTag(m);
            if chd then
                if m <= 3 then
                    local act = cc.Sequence:create(cc.DelayTime:create(delayTime * m), cc.MoveBy:create(moveTime, cc.p(0, -650)), cc.RemoveSelf:create())
                    act:setTag(999888)
                    chd:runAction(act)
                else
                    chd:removeFromParent()
                end
            end
        end

        self.cardColumn[i].height = 3
        local k = 3;
        for j = 1, 10 + i * 3 do
            local card = math.random(1, 12)
            local res = CARD_IMG[card]
            self:checkFrame(res)
            local sp = ccui.ImageView:create(res, 1)
            self.cardColumn[i]:addChild(sp);
            sp:setPosition(midWidth, 550)
            local act = cc.Sequence:create(cc.DelayTime:create(delayTime * j), cc.MoveBy:create(moveTime, cc.p(0, -650)), cc.RemoveSelf:create())
            act:setTag(999888)
            sp:runAction(act)
            k = k + 1
        end

        for j = 1, 3 do
            local card = cards[j][i];
            local res = CARD_IMG[card + 1]
            self:checkFrame(res)
            local sp = ccui.ImageView:create(res, 1)
            self.cardColumn[i]:addChild(sp);
            sp:setTag(j);
            sp:setPosition(midWidth, 550)
            local y = 153 * (j - 0.5)
            sp:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime * k), cc.CallFunc:create(function()
                if j == 1 then
                    JPMSound.stopEffect(turnsoundid)
                    turnsoundid = JPMSound.turnStop();
                end
            end), cc.MoveTo:create(moveTime, cc.p(midWidth, y - 25)), cc.MoveTo:create(delayTime / 2, cc.p(midWidth, y)), cc.CallFunc:create(function()
                if isFirst and i == 5 then
                    cb()
                    isFirst = false
                end

            end)))
        end
    end
    self:hideAllLine()
end

function JPMCenter:hideAllLine()
    self.uiLines:setVisible(false)
    for i = 1, 15 do
        self.uiLines:getChildByName(i):setVisible(false)
    end
end

function JPMCenter:showLine(i)
    self.uiLines:setVisible(true)
    self.uiLines:getChildByName(i):setVisible(true)
end

function JPMCenter:addSplashEffect(parent, x, y)
    local sprite = display.newSprite("#game/jpm/res/daoguang/daoguang_animation_3.png")
    if sprite == nil then
        return
    end
    sprite:addTo(parent):move(cc.p(x, y))

    local animation = cc.Animation:create()
    for i = 3, 10 do
        local frameName = "game/jpm/res/daoguang/daoguang_animation_" .. i .. ".png"
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.05)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    local act = cc.Sequence:create(action, cc.RemoveSelf:create())
    act:setTag(999888)
    sprite:runAction(act)
end

function JPMCenter:removePoint(len, datas, cbCardType, finishcb)
    if len == 0 then
        return;
    end
    local midWidth = self.cardColumn[1]:getContentSize().width / 2
    for i = 1, len do
        local team = datas[i];
        for j in ipairs(team) do
            local v = team[j];
            local colume = math.floor(v / 5)
            local line = v - colume * 5;
            local node = self.cardColumn[line + 1]:getChildByTag(colume + 1);
            if node then
                self:addSplashEffect(node:getParent(), node:getPositionX(), node:getPositionY())
                node:removeFromParent()
            end
        end
    end

    local delaySpeeds = {0.08, 0.06, 0.04, 0.02}
    local moveSpeeds = {0.15, 0.11, 0.07, 0.03}
    local delayTime = delaySpeeds[self.gameSpeed]
    local moveTime = moveSpeeds[self.gameSpeed]

    local first = true
    local sizeHeight = 153
    for i = 1, 5 do
        local height = self.cardColumn[i].height
        local bu = 0;
        local chd1 = self.cardColumn[i]:getChildByTag(1);
        local chd2 = self.cardColumn[i]:getChildByTag(2);
        local chd3 = self.cardColumn[i]:getChildByTag(3);
        if chd1 == nil then
            if chd2 then
                chd2:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.MoveTo:create(moveTime, cc.p(midWidth, 50)), cc.MoveTo:create(delayTime, cc.p(midWidth, 75))))
                chd2:setTag(1);
                cbCardType[1][i] = cbCardType[2][i];
                if chd3 then
                    chd3:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.MoveTo:create(moveTime, cc.p(midWidth, sizeHeight + 50)),
                        cc.MoveTo:create(delayTime, cc.p(midWidth, sizeHeight + 75))))
                    chd3:setTag(2);
                    cbCardType[2][i] = cbCardType[3][i];
                    bu = 1
                else
                    bu = 2
                end
            elseif chd3 then
                chd3:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.MoveTo:create(moveTime, cc.p(midWidth, 50)), cc.MoveTo:create(delayTime, cc.p(midWidth, 75))))
                chd3:setTag(1);
                cbCardType[1][i] = cbCardType[3][i];
                bu = 2
            else
                bu = 3
            end
        elseif chd2 == nil then
            if chd3 then
                chd3:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.MoveTo:create(moveTime, cc.p(midWidth, sizeHeight + 50)),
                    cc.MoveTo:create(delayTime, cc.p(midWidth, sizeHeight + 75))))
                chd3:setTag(2);
                cbCardType[2][i] = cbCardType[3][i];
                bu = 1
            else
                bu = 2
            end
        elseif chd3 == nil then
            bu = 1;
        end

        for k = 1, bu do
            if k + height > 20 then
                break
            end
            local card = cbCardType[k + height][i];
            local tag = 3 - (bu - k)
            local res = CARD_IMG[card + 1]
            self:checkFrame(res)
            local sp = ccui.ImageView:create(res, 1)
            self.cardColumn[i]:addChild(sp);
            sp:setTag(tag);
            cbCardType[tag][i] = card;
            sp:setPosition(midWidth, 550)
            sp:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.MoveTo:create(delayTime, cc.p(midWidth, sizeHeight * (tag - 0.5) - 25)),
                cc.MoveTo:create(delayTime / 2, cc.p(midWidth, sizeHeight * (tag - 0.5))), cc.CallFunc:create(function()
                    if first then
                        finishcb()
                    end
                    first = false;
                end)))
        end
        self.cardColumn[i].height = self.cardColumn[i].height + bu
    end
end

return JPMCenter
