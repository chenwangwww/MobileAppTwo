local JLDBScene = class("JLDBScene", require("app.views.base.BaseGameScene"))
local JLDB_CMD = require("game.jldb.src.JLDB_CMD")

local function getRes(path)
    return "game/jldb/res/" .. path
end

local CardImage = {8, 7, 6, 5, 3, 4, 2, 1, 0}
local GoldPositon = {cc.p(105, -470), cc.p(110, -290), cc.p(105, -123), cc.p(306, -292), cc.p(100, -375), cc.p(-105, -291), cc.p(306, -471), cc.p(307, -118)}

function JLDBScene:onCreate()
    cc.exports.SubLang = require("game.jldb.src.JLDBLang").new()
    JLDBScene.super.onCreate(self)
    self:init()
    local opengl = cc.Director:getInstance():getOpenGLView()
    -- opengl:setFrameSize(1280,720)
    opengl:setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.SHOW_ALL)
    local size = cc.Director:getInstance():getVisibleSize()
    -- 加载场景1
    self.rootNode = cc.CSLoader:createNode(getRes("Game1Layer.csb"))
    self.rootNode:setPosition(cc.p(size.width / 2, size.height / 2))
    self.rootNode:setAnchorPoint(display.CENTER)
    self:addChild(self.rootNode)
    -- 创建文字滚动
    self.strList = {}
    self.strList[1] = SubLang:word(1)
    local hornNode = self:createHorn()
    hornNode:align(display.CENTER_BOTTOM, 640, 615):addTo(self.rootNode)
    -- hornNode:setString(self.strList)
    -- self.hornNode=hornNode

    -- 创建奖金池
    self.numNode = self:createNum()
    self.numNode:setNumber(0, self.GoldPool)
    self.numNode:setAnchorPoint(display.LEFT_BOTTOM)
    self.numNode:setPosition(cc.p(405, 675))
    self.rootNode:addChild(self.numNode)
    -- 加载奖池动画
    local PotOpen_animate = cc.CSLoader:createTimeline(getRes("PotOpen_animate.csb"))
    PotOpen_animate:gotoFrameAndPlay(0, 20, true)
    self.rootNode:runAction(PotOpen_animate)
    -- 加载滚动精灵动画
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("respak.plist"))
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("respak2.plist"))
    for i = 1, 9 do
        self.sprite_Array[i] = {}
        local sprite_stencil = cc.Sprite:createWithSpriteFrameName("jldb/scene1/stencil.png")
        local cliper = cc.ClippingNode:create()
        local stencilSize = sprite_stencil:getContentSize()
        cliper:setContentSize(stencilSize)
        cliper:setLocalZOrder(9)
        cliper:setPosition(cc.p(440 + 200 * ((i - 1) % 3), 503 - 173 * (math.floor((i - 1) / 3))))
        self.rootNode:addChild(cliper)

        cliper:setStencil(sprite_stencil)
        cliper:setAlphaThreshold(0.05)
        cliper:addChild(sprite_stencil)
        for j = 1, 5 + i do
            local sprite = cc.Sprite:createWithSpriteFrameName("jldb/ani/8.png")
            sprite:setPosition(display.LEFT_BOTTOM)
            cliper:addChild(sprite)
            self.sprite_Array[i][j] = sprite
        end
    end
    self.animateNode = cc.CSLoader:createNode(getRes("all_show/all_show.csb"))
    self.animateNode:setPosition(cc.p(size.width / 2, size.height / 2))
    self.animateNode:setAnchorPoint(display.CENTER)
    self.animateNode:setLocalZOrder(11)
    self.rootNode:addChild(self.animateNode)

    self.sprite_Number_Array = {8, 8, 8, 8, 8, 8, 8, 8, 8}
    self:animateScroll()
    -- 用户名
    local userName = self.rootNode:getChildByName("userName")
    userName:setString(GameUtil.subStringFromUTF8(globalUserInfo.szNickName, 9))
    -- 用户金币
    self.label_userScore = self.rootNode:getChildByName("label_userCoin")
    self.label_userScore:setString(tostring(self.userScore))
    -- 单局下注
    self.label_betScore = self.rootNode:getChildByName("label_betScore")
    self.label_betScore:setString(tostring(self.tableScore * 8))
    -- 本局所得奖励
    self.label_winSocre = self.rootNode:getChildByName("label_winSocre")
    self.label_winSocre:setString(tostring(self.winScore))
    -- 奖金
    self.gold_info = self.rootNode:getChildByName("caijinBG"):getChildByName("gold_info")
    self.jiangliB = self.rootNode:getChildByName("caijinBG"):getChildByName("jiangliB")
    self.yazhuB = self.rootNode:getChildByName("caijinBG"):getChildByName("yazhuB")
    self.rootNode:getChildByName("caijinBG"):setVisible(false)
    self.rootNode:getChildByName("caijinBG"):setZOrder(1000)

    -- 加减注按钮
    self.btn_reduceBet = self.rootNode:getChildByName("btn_reduceBet")
    self.btn_reduceBet:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                local fenshu = self.tableScore - self.cellScore
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_ADD_SCORE, 1024)
                rpcSend:writeInt64(fenshu)
                rpcSend:release()
            end
        end
    end)

    self.btn_addBet = self.rootNode:getChildByName("btn_addBet")
    self.btn_addBet:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                local fenshu = self.tableScore + self.cellScore
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_ADD_SCORE, 1024)
                rpcSend:writeInt64(fenshu)
                rpcSend:release()
            end
        end
    end)

    self.btn_MaxBet = self.rootNode:getChildByName("btn_MaxBet")
    self.btn_MaxBet:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                local fenshu = self.cellScore * 9
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_ADD_SCORE, 1024)
                rpcSend:writeInt64(fenshu)
                rpcSend:release()
            end
        end
    end)

    -- 自动手动按钮
    self.autoBet = self.rootNode:getChildByName("sprite_operation_bg"):getChildByName("bet_checkBox")
    self.autoBet:addEventListenerCheckBox(function(sender, eventType)
        if self.autoBet:isSelected() then
            self.isAutoPlay = true
            if self.btn_Start:isVisible() then
                self:startGame()
            end
        else
            self.isAutoPlay = false
        end
    end)

    self.btn_Start = self.rootNode:getChildByName("btn_Start")
    self.btn_Start:addTouchEventListener(function(uiwidget, eventType)
        local temp_time = GameUtil.getSystemTime()
        if temp_time - self.lastTime < 500 then
            return
        end
        if (eventType == ccui.TouchEventType.began) then
            self:stopAnimateScroll()
            MusicManager.playEffect(getRes("audio/stop.mp3"))
            self.autoBet:setSelected(false)
            self.isAutoPlay = false
        elseif (eventType == ccui.TouchEventType.ended) then
            self.lastTime = GameUtil.getSystemTime()
            self:startGame()
        end
    end)

    self.btn_Stop = self.rootNode:getChildByName("btn_Stop")
    self.btn_Stop:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.began) then
            self.isAutoPlay = false
            self.btn_Start:setVisible(true)
            self.btn_Start:setEnabled(true)
            self.btn_Stop:setVisible(false)
            self.btn_Stop:setEnabled(false)
            self:stopAnimateScroll()
            --            for k,v in ipairs(self.tableScheduleID) do
            --                 self.scheduler:unscheduleScriptEntry(v)
            --            end
            --            self.tableScheduleID = {}
            for i = 1, JLDB_CMD.ActionCount do
                self.rootNode:stopActionByTag(i)
            end
            self:runAnimate()
            cc.SimpleAudioEngine:getInstance():stopAllEffects()
            MusicManager.playEffect(getRes("audio/stop.mp3"))
            self.autoBet:setSelected(false)
            self.isAutoPlay = false
        end
    end)

    -- 返回按钮
    self.node_btnBack = self.rootNode:getChildByName("node_btnBack")
    self.btn_Back = self.node_btnBack:getChildByName("btn_Back")
    self.btn_Back:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            self:onQuestStandup()
            self:onExitGame()
        end
    end)

    -- 奖励说明按钮
    self.btn_Information = self.rootNode:getChildByName("btn_Information")
    self.btn_Information:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then

            local informationNode = cc.CSLoader:createNode(getRes("Prize_Information.csb"))
            informationNode:setPosition(cc.p(size.width / 2, size.height / 2))
            self:addChild(informationNode)

            local function onTouchBegan(touch, event)
                return true
            end
            local listener = cc.EventListenerTouchOneByOne:create()
            listener:setSwallowTouches(true)
            listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
            informationNode:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, informationNode)

            local btn_backGame = informationNode:getChildByName("btn_backGame")
            btn_backGame:addTouchEventListener(function(uiwidget, eventType)
                if eventType == ccui.TouchEventType.ended then
                    informationNode:removeFromParent()
                end
            end)

            local node_btnBack = informationNode:getChildByName("node_btnBack")
            local btn_Back = node_btnBack:getChildByName("btn_Back")
            btn_Back:addTouchEventListener(function(uiwidget, eventType)
                if eventType == ccui.TouchEventType.ended then
                    self:onQuestStandup()
                    self:onExitGame()
                end
            end)
        end
    end)

    -- 下拉按钮
    local node_btnPull = self.rootNode:getChildByName("node_btnPull")
    local btn_pullDown = node_btnPull:getChildByName("btn_pullDown")
    btn_pullDown:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            btn_pullDown:setVisible(false)
            local node_Set = node_btnPull:getChildByName("node_Set")
            node_Set:setVisible(true)
            -- 上拉按钮
            local btn_pullUp = node_Set:getChildByName("btn_pullUp")
            btn_pullUp:addTouchEventListener(function(uiwidget, eventType)
                if eventType == ccui.TouchEventType.ended then
                    btn_pullDown:setVisible(true)
                    node_Set:setVisible(false)
                end
            end)
            -- 规则按钮
            local btn_Rule = node_Set:getChildByName("btn_Rule")
            btn_Rule:addTouchEventListener(function(uiwidget, eventType)
                if eventType == ccui.TouchEventType.ended then
                    local RuleNode = cc.CSLoader:createNode(getRes("RuleNode.csb"))
                    RuleNode:setAnchorPoint(display.CENTER)
                    RuleNode:setPosition(cc.p(640, 360))
                    self:addChild(RuleNode)

                    local btn_remove = RuleNode:getChildByName("btn_remove")
                    btn_remove:addTouchEventListener(function(uiwidget, eventType)
                        if eventType == ccui.TouchEventType.ended then
                            RuleNode:removeFromParent()
                        end
                    end)
                end
            end)
            -- 设置按钮
            local btn_Set = node_Set:getChildByName("btn_Set")
            btn_Set:addTouchEventListener(function(uiwidget, eventType)
                if eventType == ccui.TouchEventType.ended then
                    local musicNode = cc.CSLoader:createNode(getRes("MusicNode.csb"))
                    musicNode:setAnchorPoint(display.CENTER)
                    musicNode:setLocalZOrder(15)
                    musicNode:setPosition(cc.p(self.rootNode:getContentSize().width / 2, self.rootNode:getContentSize().height / 2))
                    self.rootNode:addChild(musicNode)

                    local function onTouchBegan(touch, event)
                        musicNode:removeFromParent()
                        return true
                    end
                    local listener = cc.EventListenerTouchOneByOne:create()
                    listener:setSwallowTouches(true)
                    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
                    musicNode:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, musicNode)

                    local btn_close = musicNode:getChildByName("btn_close")
                    btn_close:addTouchEventListener(function(uiwidget, eventType)
                        musicNode:removeFromParent()
                    end)
                    local Slider_music = musicNode:getChildByName("Slider_music")
                    Slider_music:setPercent(MusicManager.getMusicVal())
                    Slider_music:addEventListener(function(pSender, eventType)
                        if eventType == 0 then
                            local percent = pSender:getPercent()
                            local volume = percent
                            MusicManager.setBGMVolume(volume)
                        end
                    end)

                    local Slider_effect = musicNode:getChildByName("Slider_effect")
                    Slider_effect:setPercent(MusicManager.getEffectVal())
                    Slider_effect:addEventListener(function(pSender, eventType)
                        if eventType == 0 then
                            local percent = pSender:getPercent()
                            local volume = percent
                            MusicManager.setEffectVolume(volume)
                        end
                    end)
                end

            end)
        end
    end)
    local function onTouchBegan(touch, event)
        btn_pullDown:show()
        node_btnPull:getChildByName("node_Set"):hide()
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node_btnPull:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node_btnPull)
    -- 兰博基尼和香奈儿奖励
    self.label_chanelNum = self.rootNode:getChildByName("label_chanelNum")
    self.label_chanelNum:setString(tostring(self.ChanelCount))
    self.label_chanelReward = self.rootNode:getChildByName("label_chanelReward")
    self.label_chanelReward:setString(tostring(self.ChanelPool))
    self.label_lamboNum = self.rootNode:getChildByName("label_lamboNum")
    self.label_lamboNum:setString(tostring(self.LabCount))
    self.label_lamboReward = self.rootNode:getChildByName("label_lamboReward")
    self.label_lamboReward:setString(tostring(self.LabPool))

    -- 比倍按钮
    self.CompHalfBtn = self.rootNode:getChildByName("CompHalfBtn")
    self.CompHalfBtn:addEventListener(function(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.compNormalBtn:setSelected(false)
            self.compDoubleBtn:setSelected(false)
            if self.winScore > 0 then
                self.btn_entersence2:setEnabled(true)
            end
        elseif eventType == ccui.CheckBoxEventType.unselected then
            if self.compNormalBtn:isSelected() == false and self.compDoubleBtn:isSelected() == false then
                self.btn_entersence2:setEnabled(false)
            end
        end
    end)
    self.compNormalBtn = self.rootNode:getChildByName("compNormalBtn")
    self.compNormalBtn:addEventListener(function(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.CompHalfBtn:setSelected(false)
            self.compDoubleBtn:setSelected(false)
            if self.winScore > 0 then
                self.btn_entersence2:setEnabled(true)
            end
        elseif eventType == ccui.CheckBoxEventType.unselected then
            if self.CompHalfBtn:isSelected() == false and self.compDoubleBtn:isSelected() == false then
                self.btn_entersence2:setEnabled(false)
            end
        end
    end)
    self.compDoubleBtn = self.rootNode:getChildByName("compDoubleBtn")
    self.compDoubleBtn:addEventListener(function(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.CompHalfBtn:setSelected(false)
            self.compNormalBtn:setSelected(false)
            if self.winScore > 0 and self.userScore >= self.winScore then
                self.btn_entersence2:setEnabled(true)
            end
        elseif eventType == ccui.CheckBoxEventType.unselected then
            if self.compNormalBtn:isSelected() == false and self.compDoubleBtn:isSelected() == false then
                self.btn_entersence2:setEnabled(false)
            end
        end
    end)
    self.btn_entersence2 = self.rootNode:getChildByName("btn_entersence2")
    if self.winScore > 0 then
        self.btn_entersence2:setEnabled(true)
    else
        self.btn_entersence2:setEnabled(false)
    end

    self.btn_entersence2:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                self.isAutoPlay = false
                self.autoBet:setSelected(false)
                self.sprite_Number_Array = {}
                for i = 1, 8 do
                    local line = self.rootNode:getChildByName("line")
                    local line_num = line:getChildByName(string.format("line_%d", i))
                    line_num:stopAllActions()
                    line_num:setVisible(false)
                end
                if self.showNode then
                    self.showNode:stopAllActions()
                    self.showNode:setVisible(false)
                end
                for n = 1, 9 do
                    local slot_boarder = self.rootNode:getChildByName("slot_boarder")
                    local slot_boarder_num = slot_boarder:getChildByName(string.format("slot_boarder_%d", n))
                    slot_boarder_num:setVisible(false)
                    slot_boarder_num:stopAllActions()
                end
                if self.CompHalfBtn:isSelected() then
                    self.multiplies = 0.5
                    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
                    rpcSend:writeUInt8(0)
                    rpcSend:release()
                elseif self.compNormalBtn:isSelected() then
                    self.multiplies = 1
                    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
                    rpcSend:writeUInt8(1)
                    rpcSend:release()
                elseif self.compDoubleBtn:isSelected() then
                    self.multiplies = 2
                    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
                    rpcSend:writeUInt8(2)
                    rpcSend:release()
                end
                self:addBiBeiGame()
            end
        end
    end)

    -- GameUtil.printNodeTree(1, " - ", self.rootNode)
end

-- 开始游戏
function JLDBScene:startGame()
    if self:isDisConnect() == true then
        self:refreshGame()
    else
        --		for k,v in ipairs(self.tableScheduleID) do
        --			self.scheduler:unscheduleScriptEntry(v)
        --		end
        --		self.tableScheduleID = {}
        for i = 1, JLDB_CMD.ActionCount do
            self.rootNode:stopActionByTag(i)
        end
        self.sprite_Number_Array = {}
        for i = 1, 8 do
            local line = self.rootNode:getChildByName("line")
            local line_num = line:getChildByName(string.format("line_%d", i))
            line_num:stopAllActions()
            line_num:setVisible(false)
        end
        for n = 1, 9 do
            local slot_boarder = self.rootNode:getChildByName("slot_boarder")
            local slot_boarder_num = slot_boarder:getChildByName(string.format("slot_boarder_%d", n))
            slot_boarder_num:setVisible(false)
            slot_boarder_num:stopAllActions()
        end
        if self.showNode then
            self.showNode:stopAllActions()
            self.showNode:setVisible(false)
        end
        if next(self.tableGoldNOde) ~= nil then
            for k, v in pairs(self.tableGoldNOde) do
                if v then
                    v:stopAllActions()
                    v:removeFromParent()
                end
            end
        end
        self.tableGoldNOde = {}
        if self.LabCount == 7 then
            self.label_lamboNum:setString(tostring(0))
            self.label_lamboReward:setString(tostring(0))
        end
        if self.ChanelCount == 5 then
            self.label_chanelNum:setString(tostring(0))
            self.label_chanelReward:setString(tostring(0))
        end
        self.rootNode:getChildByName("game_flash1"):stopAllActions()
        self.rootNode:getChildByName("game_flash2"):stopAllActions()
        self.rootNode:getChildByName("game_flash1"):setVisible(false)
        self.rootNode:getChildByName("game_flash2"):setVisible(false)
        if self.userScore + self.winScore < self.tableScore * 8 then
            PlazaManager.showTips(SubLang:word(2))
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_CARD_SCROLL, 1024)
            rpcSend:release()
            self.rootNode:stopActionByTag(100)
            local seq = cc.Sequence:create(cc.DelayTime:create(8), cc.CallFunc:create(function()
                self:refreshGame()
            end))
            seq:setTag(100)
            self.rootNode:runAction(seq)
        end
        self.rootNode:getChildByName("caijinBG"):setVisible(false)
        self.label_userScore:stopAllActions()
        self.label_winSocre:stopAllActions()
        self.label_userScore:setScale(1)
        self.label_winSocre:setScale(1)
        if self.slowActId1 ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.slowActId1)
            self.slowActId1 = nil
        end
        self.numNode:stopBlinkAnimation()
    end
end
-- 滚动动画
function JLDBScene:animateScroll()
    for i = 1, 9 do
        for j = 1, 5 + i do
            -- math.randomseed(os.time())
            local num = math.random(0, 8)
            if j == 5 + i then
                num = self.sprite_Number_Array[i]
            end
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("jldb/ani/%d.png", num))
            self.sprite_Array[i][j]:initWithSpriteFrame(frame)
            self.sprite_Array[i][j]:setPosition(cc.p(0, -self.sprite_Array[i][j]:getContentSize().height * j))
        end
    end
    for i = 1, 9 do
        for j = 1, 5 + i do
            local moveto = cc.MoveTo:create(j / 8, cc.p(0, 200))
            if j == 5 + i then
                local moveto1 = cc.MoveTo:create(j / 8, display.LEFT_BOTTOM)
                local backin = cc.EaseBounceInOut:create(moveto1)
                -- local seq = cc.Sequence:create(backin)
                self.sprite_Array[i][j]:runAction(backin)
            else
                self.sprite_Array[i][j]:runAction(moveto)
            end
        end
    end
end

-- 停止滚动动画
function JLDBScene:stopAnimateScroll()
    for i = 1, 9 do
        for j = 1, 5 + i do
            self.sprite_Array[i][j]:stopAllActions()
            if j == 5 + i then
                self.sprite_Array[i][j]:setPosition(display.LEFT_BOTTOM)
            else
                self.sprite_Array[i][j]:setPosition(cc.p(0, 200))
            end
        end
    end
end

-- 初始化
function JLDBScene:init()
    self.cellScore = 0
    self.userScore = 0
    self.tableScore = 0
    self.GoldPool = 0
    self.winScore = 0
    self.wMaxPercent = 0
    self.wJettonPercent = 11
    self.lWinscore = 0
    self.LabPool = 0
    self.ChanelPool = 0
    self.LabCount = 0
    self.ChanelCount = 0
    self.multiplies = 1
    self.isAutoPlay = false
    self.showNode = nil
    self.bigSmallRecord = {}
    self.sprite_Array = {}
    self.sprite_Number_Array = {}
    self.scheduler = cc.Director:getInstance():getScheduler()
    -- self.tableScheduleID = {}
    self.tableGoldNOde = {}
    -- 按钮间隔时间（上次按钮时间)
    self.lastTime = GameUtil.getSystemTime()
end

-- 场景消息
function JLDBScene:onGameScene(data)

    if (PlazaManager.gameStatus.cbGameStatus == JLDB_CMD.GAME_SCENE_FREE) or (PlazaManager.gameStatus.cbGameStatus == JLDB_CMD.GAME_SCENE_PLAY) then
        if self.gameDisConnection == true then
            game.sendEvent(GameDefine.GR_QUEST_READY)
        end
        self.cellScore = data:readInt64()
        self.userScore = data:readInt64()
        self.tableScore = data:readInt64()
        for i = 1, 10 do
            self.bigSmallRecord[i] = data:readInt8()
        end
        self.GoldPool = data:readInt64()
        self.LabPool = data:readInt64()
        self.ChanelPool = data:readInt64()
        self.LabCount = data:readInt16()
        self.ChanelCount = data:readInt16()
    end
    self.rootNode:stopActionByTag(100)
    self.label_userScore:setString(tostring(self.userScore))
    self.label_betScore:setString(tostring(self.tableScore * 8))
    self.numNode:setNumber(0, self.GoldPool)
    self.label_chanelNum:setString(tostring(self.ChanelCount))
    self.label_chanelReward:setString(tostring(self.ChanelPool))
    self.label_lamboNum:setString(tostring(self.LabCount))
    self.label_lamboReward:setString(tostring(self.LabPool))
    if self.isAutoPlay == true then
        local seq = cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
            self:startGame()
        end))
        seq:setTag(JLDB_CMD.Game1_To_Game1)
        self.rootNode:runAction(seq)
    end
end

-- 游戏状态消息
function JLDBScene:onGameStatus()

end

-- 游戏消息
function JLDBScene:onGame(cmdID, data)
    if cmdID == JLDB_CMD.SUB_S_ADD_SCORE then
        -- 游戏押分
        self:OnSubAddScore(data)
    elseif cmdID == JLDB_CMD.SUB_S_CARD_SCROLL then
        -- 开始滚动
        self:OnSubGameCardScroll(data)
    elseif cmdID == JLDB_CMD.SUB_S_BIG_SMALL then
        -- 比倍游戏
        self:OnSubGameCardBigSmall(data)
    elseif cmdID == JLDB_CMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubGameMessageInfo(data)
    elseif cmdID == JLDB_CMD.SUB_S_UPDATEGOLDPOOL then
        self:onSubGameUpdateGoldPool(data)
    end
end
-- 事件
function JLDBScene:addEvent()
    game.sendEvent(GameDefine.GR_QUEST_READY)
end

-- 进入场景完成
function JLDBScene:onEnterTransitionFinish()
    JLDBScene.super.onEnterTransitionFinish(self)
    self:addEvent()
    MusicManager.stopBGM()
    MusicManager.playBGM(getRes("audio/bg.mp3"))
end

-- 离开场景
function JLDBScene:onExit()
    JLDBScene.super.onExit(self)
end

-- 游戏关闭
function JLDBScene:onCloseGameScene()
    self:onExitGame()
end

function JLDBScene:onExitGame()
    JLDBScene.super.onExitGame(self)
    --    for k,v in ipairs(self.tableScheduleID) do
    --          self.scheduler:unscheduleScriptEntry(v)
    --    end
    --    self.tableScheduleID = {}
    MusicManager.stopBGM()
    LoadingManager.removeLoadRes(204)
end

function JLDBScene:OnSubGameCardScroll(data)
    if data == nil then
        return
    end
    self.rootNode:stopActionByTag(100)
    self:stopAnimateScroll()
    self.tmpLabCount = self.LabCount
    self.tmpChanelCount = self.ChanelCount
    self.btn_Start:setVisible(false)
    self.btn_Start:setEnabled(false)
    self.btn_Stop:setVisible(true)
    self.btn_Stop:setEnabled(true)
    self.btn_entersence2:setEnabled(false)
    self.NumberArray = {}
    for i = 1, 9 do
        self.NumberArray[i] = data:readUInt8()
        self.sprite_Number_Array[i] = CardImage[self.NumberArray[i] + 1]
    end
    dump(self.NumberArray)
    self.cbNumber = self.GoldPool
    self.userScore = data:readInt64()
    self.label_userScore:setString(tostring(self.userScore))
    self.label_winSocre:setString(tostring(0))
    self.winScore = data:readInt64()
    self.GoldPool = data:readInt64()
    self.wMaxPercent = data:readInt16()
    self.wJettonPercent = data:readInt16()
    self.lWinscore = data:readInt64()
    self.LabCount = data:readInt16()
    self.ChanelCount = data:readInt16()
    self.LabPool = data:readInt64()
    self.ChanelPool = data:readInt64()

    if MusicManager.getEffectVal() > 0 then
        cc.SimpleAudioEngine:getInstance():playEffect(getRes("audio/gundong.mp3"))
    end
    self:animateScroll()
    --    local scheduleID1=nil
    --    scheduleID1 = self.scheduler:scheduleScriptFunc(function()
    --         self.scheduler:unscheduleScriptEntry(scheduleID1)
    --         self:runAnimate()
    --    end,1.5,false)
    --    table.insert(self.tableScheduleID,scheduleID1)
    local seq = cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
        self:runAnimate()
    end))
    seq:setTag(JLDB_CMD.CardScroll)
    self.rootNode:runAction(seq)
end

function JLDBScene:runAnimate()
    self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        local animate = self:getAniamte(self.NumberArray)
        if animate then
            self.showNode:runAction(animate)
            MusicManager.playEffect(getRes("audio/all.mp3"))
        end
    end), cc.CallFunc:create(function()
        self.btn_Start:setVisible(true)
        self.btn_Start:setEnabled(true)
        self.btn_Stop:setVisible(false)
        self.btn_Stop:setEnabled(false)
        local scaleby1 = cc.ScaleBy:create(0.3, 2, 2)
        local scaleby2 = cc.ScaleBy:create(0.3, 2, 2)

        self.numNode:setNumber(self.cbNumber, self.GoldPool)
        self.label_chanelNum:setString(tostring(self.ChanelCount))
        self.label_chanelReward:setString(tostring(self.ChanelPool))
        self.label_lamboNum:setString(tostring(self.LabCount))
        self.label_lamboReward:setString(tostring(self.LabPool))
        if self.tmpLabCount ~= self.LabCount then
            local game_flash1 = self.rootNode:getChildByName("game_flash1")
            game_flash1:setVisible(true)
            game_flash1:runAction(cc.Blink:create(10, 10))
        end
        if self.tmpChanelCount ~= self.ChanelCount then
            local game_flash2 = self.rootNode:getChildByName("game_flash2")
            game_flash2:setVisible(true)
            game_flash2:runAction(cc.Blink:create(10, 10))
        end
        local temp_gold = self.winScore - self.lWinscore
        if self.LabCount == 7 then
            temp_gold = temp_gold - self.LabPool
            local moveto = cc.MoveTo:create(1, cc.p(742, 38))
            local easeBackIn = cc.EaseBackIn:create(moveto)
            local labAniamte = cc.CSLoader:createNode(getRes("GoldAnimate.csb"))
            labAniamte:setAnchorPoint(display.CENTER)
            labAniamte:setLocalZOrder(11)
            labAniamte:setPosition(cc.p(self.label_lamboReward:getPositionX(), self.label_lamboReward:getPositionY()))
            self.rootNode:addChild(labAniamte)
            local goldAniamte = cc.CSLoader:createTimeline(getRes("GoldAnimate.csb"))
            goldAniamte:gotoFrameAndPlay(0, 3, true)
            labAniamte:runAction(goldAniamte)
            table.insert(self.tableGoldNOde, labAniamte)
            labAniamte:runAction(cc.Sequence:create(easeBackIn, cc.CallFunc:create(function()
                labAniamte:removeFromParent()
                for k, v in ipairs(self.tableGoldNOde) do
                    if v == labAniamte then
                        table.remove(self.tableGoldNOde, k)
                    end
                end
            end)))
        end

        if self.ChanelCount == 5 then
            temp_gold = temp_gold - self.ChanelPool
            local moveto1 = cc.MoveTo:create(1, cc.p(742, 38))
            local easeBackIn1 = cc.EaseBackIn:create(moveto1)
            local chanelAniamte = cc.CSLoader:createNode(getRes("GoldAnimate.csb"))
            chanelAniamte:setAnchorPoint(display.CENTER)
            chanelAniamte:setLocalZOrder(11)
            chanelAniamte:setPosition(cc.p(self.label_chanelReward:getPositionX(), self.label_chanelReward:getPositionY()))
            self.rootNode:addChild(chanelAniamte)
            local goldAniamte = cc.CSLoader:createTimeline(getRes("GoldAnimate.csb"))
            goldAniamte:gotoFrameAndPlay(0, 3, true)
            chanelAniamte:runAction(goldAniamte)
            table.insert(self.tableGoldNOde, chanelAniamte)
            chanelAniamte:runAction(cc.Sequence:create(easeBackIn1, cc.CallFunc:create(function()
                chanelAniamte:removeFromParent()
                for k, v in ipairs(self.tableGoldNOde) do
                    if v == chanelAniamte then
                        table.remove(self.tableGoldNOde, k)
                    end
                end
            end)))

        end

        if self.winScore > 0 then
            self.label_userScore:runAction(cc.Sequence:create(cc.DelayTime:create(1), scaleby1, scaleby1:reverse()))
            self.label_winSocre:setString(tostring(self.winScore))
            self.label_winSocre:runAction(cc.Sequence:create(cc.DelayTime:create(1), scaleby2, scaleby2:reverse()))
            self.btn_entersence2:setEnabled(true)
        else
            self.btn_entersence2:setEnabled(false)
        end
        if temp_gold > 0 then
            self.rootNode:getChildByName("caijinBG"):setVisible(true)
            self.numNode:blinkAnimation()
            -- self.gold_info:setString(tostring(temp_gold))
            self.jiangliB:setString(tostring(self.wMaxPercent))
            self.yazhuB:setString(tostring(self.wJettonPercent))
            self.slowActId1 = nil
            local function update_value(value)
                self.gold_info:setString(tostring(math.floor(value)))
                if value == temp_gold then
                    if self.slowActId1 then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.slowActId1)
                        self.slowActId1 = nil
                    end
                end
            end

            local function linear(ratio)
                return ratio
            end
            self.slowActId1 = self:slowAction(update_value, linear, 0, temp_gold, 0.8)
        end
        if self.isAutoPlay == true then
            --                 local scheduleID2=nil
            --                 scheduleID2 = self.scheduler:scheduleScriptFunc(function()
            --                       self.scheduler:unscheduleScriptEntry(scheduleID2)
            --                       if self.isAutoPlay==true then
            --                            self:startGame()
            --                       end
            --                 end,2,false)
            --                 table.insert(self.tableScheduleID,scheduleID2)
            local seq = cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function()
                self:startGame()
            end))
            seq:setTag(JLDB_CMD.Game1_End)
            self.rootNode:runAction(seq)
        end
    end)))
end

function JLDBScene:slowAction(callback, funRatio, start, over, sec)
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

function JLDBScene:OnSubAddScore(data)
    if data == nil then
        return
    end
    self.tableScore = data:readInt64()
    self.label_betScore:setString(tostring(self.tableScore * 8))

end

function JLDBScene:OnSubGameCardBigSmall(data)
    if data == nil then
        return
    end

    local dice1 = data:readUInt8()
    local dice2 = data:readUInt8()
    self.winScore = data:readInt64()
    self.userScore = self.userScore + (1 - self.multiplies) * self.winScore
    self.winScore = self.winScore * self.multiplies
    self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        self:diceAniamtion(dice1, dice2)
    end), cc.CallFunc:create(function()
        self.label_userScore2:setString(tostring(self.userScore))
        self.label_betCoin:setString(tostring(self.winScore))
        local scaleby1 = cc.ScaleBy:create(0.1, 2, 2)
        local scaleby3 = cc.ScaleBy:create(0.1, 2, 2)
        local scaleby2 = cc.ScaleBy:create(1, 2, 2)
        if self.winScore > 0 then
            self.label_userScore2:runAction(cc.Sequence:create(scaleby1, scaleby1:reverse()))
            self.label_betCoin:runAction(cc.Sequence:create(scaleby3, scaleby3:reverse()))
            local Sprite_Win = self.Game2Layer:getChildByName("Sprite_Win")
            Sprite_Win:setVisible(true)
            Sprite_Win:runAction(scaleby2)
        else
            local Sprite_lose = self.Game2Layer:getChildByName("Sprite_lose")
            Sprite_lose:setVisible(true)
            Sprite_lose:runAction(cc.Sequence:create(scaleby2, cc.DelayTime:create(1), cc.CallFunc:create(function()
                self.label_betCoin = nil
                self.label_userScore2 = nil
                self.Game2Layer:removeAllChildren()
                self.Game2Layer:removeFromParent()
                self.Game2Layer = nil
                MusicManager.stopBGM()
                MusicManager.playBGM(getRes("audio/bg.mp3"))
                self.label_userScore:setString(tostring(self.userScore + self.winScore))
                self.label_winSocre:setString(tostring(0))
                self.btn_entersence2:setEnabled(false)
                self:stopAllActions()
            end)))
        end
    end), cc.DelayTime:create(2), cc.CallFunc:create(function()
        if self.winScore > 0 then
            self.btn_Small:setEnabled(true)
            self.btn_Tie:setEnabled(true)
            self.btn_Big:setEnabled(true)
            self.btn_Small:getChildByName("sprite_bet_gold"):setVisible(false)
            self.btn_Tie:getChildByName("sprite_bet_gold"):setVisible(false)
            self.btn_Big:getChildByName("sprite_bet_gold"):setVisible(false)
            self.Game2Layer:getChildByName("dice1_animate"):setVisible(false)
            self.Game2Layer:getChildByName("dice2_animate"):setVisible(false)
            self.Game2Layer:getChildByName("Sprite_Win"):setVisible(false)
            self.Game2Layer:getChildByName("Sprite_Win"):setScale(0.5, 0.5)
        end
    end)))
end

function JLDBScene:onSubGameMessageInfo(data)
    if data == nil then
        return
    end
    local str = data:readUString(200 * 2)
    local showStr = GameUtil.filterMultMsg(str, 1)
    if showStr == nil or showStr == "" then
        return
    end

    table.insert(self.strList, showStr)
    -- self.hornNode:setString(self.strList)
end

function JLDBScene:onSubGameUpdateGoldPool(data)
    if data == nil then
        return
    end
    local number = self.GoldPool
    self.GoldPool = data:readInt64()
    if self.numNode then
        self.numNode:setNumber(number, self.GoldPool)
    end
end

function JLDBScene:getAniamte(NumberArray)
    local isAnimateArray = {}
    if self.showNode ~= nil then
        self.showNode:stopAllActions()
        self.showNode:setVisible(false)
    end
    self.showNode = nil
    for i = 1, 10 do
        isAnimateArray[i] = false
    end
    -- 满盘计算
    local bAllSame = true
    for i = 2, 9 do
        if NumberArray[1] ~= NumberArray[i] then
            bAllSame = false
        end
    end
    -- 全屏判断
    if bAllSame then
        local animate = cc.CSLoader:createTimeline(getRes(string.format("all_show/all_show_%d.csb", NumberArray[1])))
        animate:gotoFrameAndPlay(0, 45, false)
        self.showNode = self.animateNode:getChildByName(string.format("all_show_%d", NumberArray[1]))
        self.showNode:setVisible(true)
        return animate -- 全屏NumberArray[0]动画
    else
        -- 777个数
        local w777Count = 0
        local w777List = {}
        for i = 1, 9 do
            if NumberArray[i] == 0 then
                w777Count = w777Count + 1
                w777List[w777Count] = i
            end
        end

        if w777Count >= 2 then
            for n = 1, w777Count do
                local slot_boarder = self.rootNode:getChildByName("slot_boarder")
                slot_boarder:setLocalZOrder(10)
                local slot_boarder_num = slot_boarder:getChildByName(string.format("slot_boarder_%d", w777List[n]))
                slot_boarder_num:setVisible(true)
                slot_boarder_num:runAction(cc.Blink:create(10, 10))

                local moveto = cc.MoveTo:create(1, cc.p(742, 38))
                local easeBackIn = cc.EaseBackIn:create(moveto)
                local goldnode = cc.CSLoader:createNode(getRes("GoldAnimate.csb"))
                local goldnodePosition = slot_boarder_num:convertToWorldSpace(display.LEFT_BOTTOM)
                goldnode:setAnchorPoint(display.CENTER)
                goldnode:setLocalZOrder(11)
                goldnode:setPosition(cc.p(goldnodePosition.x + slot_boarder_num:getContentSize().width / 2, goldnodePosition.y + slot_boarder_num:getContentSize().height / 2))
                self.rootNode:addChild(goldnode)
                local goldAniamte = cc.CSLoader:createTimeline(getRes("GoldAnimate.csb"))
                goldAniamte:gotoFrameAndPlay(0, 3, true)
                goldnode:runAction(goldAniamte)
                table.insert(self.tableGoldNOde, goldnode)
                goldnode:runAction(cc.Sequence:create(easeBackIn, cc.CallFunc:create(function()
                    goldnode:removeFromParent()
                    for k, v in ipairs(self.tableGoldNOde) do
                        if v == goldnode then
                            table.remove(self.tableGoldNOde, k)
                        end
                    end
                end)))
            end
            MusicManager.playEffect(getRes("audio/win.mp3"))
        end
        if w777Count == 0 then
            bAllSame = true
            for i = 1, 9 do
                if NumberArray[i] > 3 then -- 没有全屏手表
                    bAllSame = false
                    break
                end
            end
            if bAllSame then -- 全屏手表
                isAnimateArray[9] = true
            end
            bAllSame = true
            for i = 1, 9 do
                if NumberArray[i] < 5 then -- 没有全屏车标
                    bAllSame = false
                    break
                end
            end
            if bAllSame then -- 全屏车标
                isAnimateArray[10] = true
            end
        end
        for i = 1, 3 do
            if NumberArray[(i - 1) * 3 + 1] == NumberArray[(i - 1) * 3 + 2] and NumberArray[(i - 1) * 3 + 1] == NumberArray[(i - 1) * 3 + 3] then -- 横向三个相同
                isAnimateArray[i] = true
            else
                bAllSame = true
                for j = 1, 3 do
                    if (NumberArray[(i - 1) * 3 + j] == 0 or NumberArray[(i - 1) * 3 + j] >= 4) then
                        bAllSame = false
                        break
                    end
                end
                if bAllSame then -- 三个都是手表
                    isAnimateArray[i] = true
                else
                    if NumberArray[(i - 1) * 3 + 1] == 8 then -- 前面一个都是兰博基尼
                        isAnimateArray[i] = true
                    end
                end

            end

            if NumberArray[i] == NumberArray[i + 3] and NumberArray[i] == NumberArray[i + 6] then -- 竖向三个相同
                isAnimateArray[3 + i] = true
            else
                bAllSame = true
                for j = 1, 3 do
                    if (NumberArray[(j - 1) * 3 + i] == 0 or NumberArray[(j - 1) * 3 + i] >= 4) then
                        bAllSame = false
                        break
                    end
                end
                if bAllSame then -- 三个都是手表
                    isAnimateArray[3 + i] = true
                else
                    if NumberArray[i] == 8 then -- 前面一个都是兰博基尼
                        isAnimateArray[3 + i] = true
                    end
                end
            end
        end
        if NumberArray[1] == NumberArray[5] and NumberArray[1] == NumberArray[9] then -- 左向下斜线三个相同
            isAnimateArray[7] = true
        else
            bAllSame = true
            if NumberArray[1] == 0 or NumberArray[1] >= 4 then
                bAllSame = false
            end
            if NumberArray[5] == 0 or NumberArray[5] >= 4 then
                bAllSame = false
            end
            if NumberArray[9] == 0 or NumberArray[9] >= 4 then
                bAllSame = false
            end
            if bAllSame then -- 三个都是手表
                isAnimateArray[7] = true
            else
                if NumberArray[1] == 8 then -- 第一个是兰博基尼
                    isAnimateArray[7] = true
                end
            end
        end
        if NumberArray[7] == NumberArray[5] and NumberArray[7] == NumberArray[3] then -- 左向上斜线三个相同
            isAnimateArray[8] = true
        else
            bAllSame = true
            if NumberArray[7] == 0 or NumberArray[7] >= 4 then
                bAllSame = false
            end
            if NumberArray[5] == 0 or NumberArray[5] >= 4 then
                bAllSame = false
            end
            if NumberArray[3] == 0 or NumberArray[3] >= 4 then
                bAllSame = false
            end
            if bAllSame then -- 三个都是手表
                isAnimateArray[8] = true
            else
                if NumberArray[7] == 8 then -- 第一个是兰博基尼
                    isAnimateArray[8] = true
                end
            end
        end
    end
    local iseffect = false
    for i = 1, 8 do
        self.rootNode:getChildByName("line"):getChildByName(string.format("line_%d", i)):stopAllActions()
        if isAnimateArray[i] then
            iseffect = true
            local line = self.rootNode:getChildByName("line")
            line:setLocalZOrder(10)
            local line_num = line:getChildByName(string.format("line_%d", i))
            line_num:setVisible(true)
            line_num:runAction(cc.Blink:create(10, 10))

            local moveby = cc.MoveBy:create(1, GoldPositon[i])
            local easeBackIn = cc.EaseBackIn:create(moveby)

            local line_gold = line_num:getChildByName(string.format("line_gold_%d", i))

            line_gold:setVisible(true)
            line_gold:setTag(100)
            local goldAniamte = line_gold:getActionByTag(100)
            if not goldAniamte then
                goldAniamte = cc.CSLoader:createTimeline(getRes("GoldAnimate.csb"))
                line_gold:runAction(goldAniamte)
            end
            goldAniamte:gotoFrameAndPlay(0, 3, true)
            line_gold:runAction(cc.Sequence:create(easeBackIn, cc.CallFunc:create(function()
                line_gold:setVisible(false)
            end), easeBackIn:reverse()))
        end
    end
    if iseffect then
        MusicManager.playEffect(getRes("audio/win.mp3"))
    end
    for i = 9, 10 do
        if isAnimateArray[i] then
            self.showNode = self.animateNode:getChildByName(string.format("all_show_%d", i))
            self.showNode:setVisible(true)
            local animate = cc.CSLoader:createTimeline(getRes(string.format("all_show/all_show_%d.csb", i)))
            animate:gotoFrameAndPlay(0, 45, false)
            return animate -- 全屏NumberArray[0]动画
        end
    end
    return nil
end
-- 骰子动画
function JLDBScene:diceAniamtion(dice1, dice2)
    MusicManager.playEffect(getRes("audio/sice.mp3"))
    local diceAnimate1 = cc.CSLoader:createTimeline(getRes("Dice_animate.csb"))
    diceAnimate1:gotoFrameAndPlay((dice1 - 1) * 10 + 1, dice1 * 10, false)
    local dice1_animate = self.Game2Layer:getChildByName("dice1_animate")
    dice1_animate:setVisible(true)
    dice1_animate:runAction(diceAnimate1)

    local diceAnimate2 = cc.CSLoader:createTimeline(getRes("Dice_animate.csb"))
    diceAnimate2:gotoFrameAndPlay((dice2 - 1) * 10 + 1, dice2 * 10, false)
    local dice2_animate = self.Game2Layer:getChildByName("dice2_animate")
    dice2_animate:setVisible(true)
    dice2_animate:runAction(diceAnimate2)
end
-- 创建文字滚动控件
function JLDBScene:createHorn()
    local size = cc.size(600, 40)
    local node = display.newNode()
    node:setContentSize(size)
    node.currentSelect = 1

    local lbl = cc.Label:create()
    lbl:setSystemFontSize(23)
    local lblSize = lbl:getContentSize()
    local msgSize = cc.size(600, 30)

    local cliper = cc.ClippingNode:create();
    cliper:setContentSize(msgSize)

    local drawNode = cc.DrawNode:create()
    local drawPos = {display.LEFT_BOTTOM, cc.p(msgSize.width, 0), cc.p(msgSize.width, msgSize.height), cc.p(0, msgSize.height)}
    local color = cc.c4f(1, 1, 1, 1)
    drawNode:drawSolidPoly(drawPos, 4, color)

    cliper:setStencil(drawNode)
    lbl:setAnchorPoint(display.LEFT_CENTER)
    lbl:setPosition(0, msgSize.height / 2)
    cliper:addChild(lbl)

    cliper:setPosition(0, 0)
    node:addChild(cliper)

    --[[function node:setString(msgList)
        if (msgList == nil or #msgList == 0) then 
            return 
        end
        node.msgStrList=msgList
        node.currentSelect = 1

        lbl:setString(node.msgStrList[node.currentSelect])
        lblSize = lbl:getContentSize()
        lbl:move(msgSize.width, msgSize.height/2)
    end --]]
    lbl:setString(self.strList[1])
    local speed = 100.0
    local function onUpdate(dt)
        local x = lbl:getPositionX() - dt * speed
        lbl:setPositionX(x)
        lblSize = lbl:getContentSize()
        if x + lblSize.width < 0 then
            local str = self.strList[1]
            if #self.strList > 1 then
                str = table.remove(self.strList, 2)
            end
            lbl:setString(str)
            lbl:setPositionX(msgSize.width)
        end
    end

    lbl:scheduleUpdateWithPriorityLua(onUpdate, 1)

    return node
end
function JLDBScene:onAcceptTrumpetContentRoll(trumpetDataStr)
    local str = trumpetDataStr
    table.insert(self.strList, str)
end

-- 创建数字滚动
function JLDBScene:createNum()
    local node = display.newNode()
    node:setContentSize(cc.size(465, 50))
    local coinNum_Array = {}
    local cliper = cc.ClippingNode:create();
    cliper:setContentSize(cc.size(465, 45))
    local drawNode = cc.DrawNode:create()
    local drawPos = {display.LEFT_BOTTOM, cc.p(465, 0), cc.p(465, 40), cc.p(0, 40)}
    local color = cc.c4f(1, 1, 1, 1)
    drawNode:drawSolidPoly(drawPos, 4, color)
    cliper:setStencil(drawNode)
    cliper:setPosition(display.LEFT_BOTTOM)
    node:addChild(cliper)

    for i = 1, 10 do
        local sprite = cc.Sprite:createWithSpriteFrameName("jldb/scene1/poolprize_coin_num_0.png")
        sprite:setPosition(cc.p(19 + (i - 1) * 48, 15))
        sprite:setOpacity(0)
        cliper:addChild(sprite)
        local PoolPrize_animate = cc.CSLoader:createNode(getRes("PoolPrize_animate.csb"))
        PoolPrize_animate:setAnchorPoint(display.CENTER)
        PoolPrize_animate:setPosition(cc.p(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2))
        PoolPrize_animate:setVisible(false)
        PoolPrize_animate:setTag(10)
        sprite:addChild(PoolPrize_animate)
        coinNum_Array[i] = sprite

        local animate = cc.CSLoader:createTimeline(getRes("PoolPrize_animate.csb"))
        PoolPrize_animate:runAction(animate)
    end

    -- 加载奖池动画
    function node:blinkAnimation()
        for i = 1, 10 do
            local blink = cc.Blink:create(2, 5)
            blink:setTag(1)
            coinNum_Array[i]:runAction(blink)
        end
    end
    function node:stopBlinkAnimation()
        for i = 1, 10 do
            coinNum_Array[i]:stopActionByTag(1)
        end
    end
    function node:setNumber(number, poolNumber)
        local str = tostring(poolNumber)
        local str1 = tostring(number)
        local len = string.len(str)
        local len1 = string.len(str1)
        if len == len1 then
            for i = 1, len do
                local num = tonumber(string.sub(str, i, i))
                local num1 = tonumber(string.sub(str1, i, i))
                coinNum_Array[10 - len + i]:setVisible(true)
                coinNum_Array[10 - len + i]:setOpacity(0)
                local PoolPrize_animate = coinNum_Array[10 - len + i]:getChildByTag(10)
                PoolPrize_animate:setVisible(true)
                local animate = PoolPrize_animate:getActionByTag(10)
                if num > num1 then
                    animate:gotoFrameAndPlay(num1 * 20, num * 20, false)
                elseif num < num1 then
                    animate:gotoFrameAndPlay(0, 20 * num, false)
                    if num == 0 then
                        animate:gotoFrameAndPlay(num1 * 20, 20 * 10, false)
                    end
                end
            end
        else
            for i = 1, len do
                local num = tonumber(string.sub(str, i, i))
                coinNum_Array[10 - len + i]:setVisible(true)
                coinNum_Array[10 - len + i]:setOpacity(0)
                local PoolPrize_animate = coinNum_Array[10 - len + i]:getChildByTag(10)
                PoolPrize_animate:setVisible(true)
                local animate = PoolPrize_animate:getActionByTag(10)
                if num == 0 then
                    animate:gotoFrameAndPlay(0, 20 * 10, false)
                else
                    animate:gotoFrameAndPlay(0, 20 * num, false)
                end
            end
            for i = 1, 10 - len do
                coinNum_Array[i]:setVisible(true)
                coinNum_Array[i]:getChildByTag(10):setVisible(false)
                coinNum_Array[i]:setOpacity(255)
            end
        end

    end

    return node
end
-- 添加比倍游戏
function JLDBScene:addBiBeiGame()
    MusicManager.stopBGM()
    MusicManager.playBGM(getRes("audio/bg2.mp3"))
    --     for k,v in ipairs(self.tableScheduleID) do
    --          self.scheduler:unscheduleScriptEntry(v)
    --     end
    --     self.tableScheduleID = {}
    for i = 1, JLDB_CMD.ActionCount do
        self.rootNode:stopActionByTag(i)
    end

    local size = cc.Director:getInstance():getVisibleSize()
    self.Game2Layer = cc.CSLoader:createNode(getRes("Game2Layer.csb"))
    self.Game2Layer:setPosition(cc.p(size.width / 2, size.height / 2))
    self.Game2Layer:setAnchorPoint(display.CENTER)
    self:addChild(self.Game2Layer)

    local animate = cc.CSLoader:createTimeline(getRes("Game2Animate.csb"))
    animate:gotoFrameAndPlay(0, 15, true)
    local game2Aniamte = self.Game2Layer:getChildByName("game2Aniamte")
    game2Aniamte:runAction(animate)

    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.Game2Layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.Game2Layer)
    -- 游戏币
    self.userScore = self.userScore + self.winScore * (1 - self.multiplies)
    self.label_userScore2 = self.Game2Layer:getChildByName("label_userScore")
    self.label_userScore2:setString(tostring(self.userScore))
    -- 所下金币
    self.winScore = self.winScore * self.multiplies
    self.label_betCoin = self.Game2Layer:getChildByName("label_betCoin")
    self.label_betCoin:setString(tostring(self.winScore))
    -- 返回按钮
    local node_btnBack = self.Game2Layer:getChildByName("node_btnBack")
    local btn_Back = node_btnBack:getChildByName("btn_Back")
    btn_Back:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            self.label_betCoin = nil
            self.label_userScore2 = nil
            self.Game2Layer:removeAllChildren()
            self.Game2Layer:removeFromParent()
            self.Game2Layer = nil
            self.label_userScore:setString(tostring(self.userScore + self.winScore))
            self.label_winSocre:setString(tostring(0))
            self:stopAllActions()
            self.btn_entersence2:setEnabled(false)
            MusicManager.stopBGM()
            MusicManager.playBGM(getRes("audio/bg.mp3"))
            -- auto game
        end
    end)
    -- 小和大
    self.btn_Small = self.Game2Layer:getChildByName("btn_Small")
    self.btn_Small:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                self.btn_Small:setEnabled(false)
                self.btn_Tie:setEnabled(false)
                self.btn_Big:setEnabled(false)
                self.btn_Small:getChildByName("sprite_bet_gold"):setVisible(true)
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_BIG_SMALL, 1024)
                rpcSend:writeUInt8(JLDB_CMD.DICE_SMALL)
                rpcSend:release()
            end

        end
    end)
    self.btn_Tie = self.Game2Layer:getChildByName("btn_Tie")
    self.btn_Tie:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                self.btn_Small:setEnabled(false)
                self.btn_Tie:setEnabled(false)
                self.btn_Big:setEnabled(false)
                self.btn_Tie:getChildByName("sprite_bet_gold"):setVisible(true)
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_BIG_SMALL, 1024)
                rpcSend:writeUInt8(JLDB_CMD.DICE_DRAW)
                rpcSend:release()
            end
        end
    end)
    self.btn_Big = self.Game2Layer:getChildByName("btn_Big")
    self.btn_Big:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self:isDisConnect() == true then
                self:refreshGame()
            else
                self.btn_Small:setEnabled(false)
                self.btn_Tie:setEnabled(false)
                self.btn_Big:setEnabled(false)
                self.btn_Big:getChildByName("sprite_bet_gold"):setVisible(true)
                local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, JLDB_CMD.SUB_C_BIG_SMALL, 1024)
                rpcSend:writeUInt8(JLDB_CMD.DICE_BIG)
                rpcSend:release()
            end
        end
    end)
end
-- 前后台切换
function JLDBScene:onEnterBackground(isEnterBackground)
    if isEnterBackground == true then
        -- 游戏切换到后台
        -- print("---------------游戏切换到后台1------------------")
        -- self.isAutoPlay = false
    end
end
return JLDBScene
