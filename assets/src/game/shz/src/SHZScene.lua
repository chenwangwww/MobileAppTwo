local SHZScene = class("SHZScene", require("app.views.base.BaseGameScene"))
local SHZ_CMD = require("game.shz.src.SHZ_CMD")
local CButton = require("base.src.app.components.Buttons")

local function getRes(path)
    return "game/shz/res/" .. path
end
local GamePng = {"jump_shz_%02d.png", "jump_zyt_%02d.png", "jump_ttxd_%02d.png", "jump_song_%02d.png", "jump_lin_%02d.png", "jump_lu_%02d.png", "jump_dadao_%02d.png", "jump_yin_%02d.png",
                 "jump_futou_%02d.png"}
local playerPlist = {"game1/itemAction/shuihuzhuan.plist", "game1/itemAction/zhongyitang.plist", "game1/itemAction/titianxingdao.plist", "game1/itemAction/song.plist", "game1/itemAction/lin.plist",
                     "game1/itemAction/lu.plist", "game1/itemAction/dadao.plist", "game1/itemAction/yinqiang.plist", "game1/itemAction/futou.plist"}
local playerPng = {"action_shz_%02d.png", "action_zyt_%02d.png", "action_ttxd_%02d.png", "action_song_%02d.png", "action_lin_%02d.png", "action_lu_%02d.png", "action_dadao_%02d.png",
                   "action_yinqiang_%02d.png", "action_futou_%02d.png"}
local playerPngCount = {57, 36, 47, 37, 35, 41, 31, 54, 42}
local m_cbCardLine = {{6, 7, 8, 9, 10}, {1, 2, 3, 4, 5}, {11, 12, 13, 14, 15}, {1, 7, 13, 9, 5}, {11, 7, 3, 9, 15}, {1, 2, 8, 4, 5}, {11, 12, 8, 14, 15}, {6, 12, 13, 14, 10}, {6, 2, 3, 4, 10}}
local m_cbMarioType = {9, 5, 7, 1, 8, 6, 9, 3, 5, 7, 8, 2, 9, 4, 6, 8, 5, 3, 9, 4, 7, 8, 6, 2}
local m_bLineType = {}

function SHZScene:onCreate()
    cc.exports.SubLang = require("game.shz.src.SHZLang").new()
    SHZScene.super.onCreate(self)
    self:init()
    -- local opengl = cc.Director:getInstance():getOpenGLView()
    -- opengl:setFrameSize(1280,720)
    -- opengl:setDesignResolutionSize(1334,750,cc.ResolutionPolicy.SHOW_ALL)
    self.nCheckCount = 0
    self.m_GameSpriteArray = {}
    self.m_GameBoxSpriteArray = {}
    self.m_GameLightSpriteArray = {}
    self.m_animationSpriteArray = {}
    self.m_GameLineSpriteArray = {}
    self.scheduler = cc.Director:getInstance():getScheduler()
    self:initUI()
end
-- 初始化
function SHZScene:init()
    self.userScore = 0
    self.cellScore = 0
    self.tableScore = 0
    self.winScore = 0
    self.m_bFirst = 0
    self.dwMarioScrollCount = 0
    self.m_lWinScore = 0
    self.isAutoPlay = false
    self.controlIsAutoPlay = false
    self.CardType = {}
    self.times = 0
    self.cbMarioMiddleCard = {}
    -- 按钮间隔时间（上次按钮时间)
    self.lastTime = GameUtil.getSystemTime() - 1000

    -- 按钮间隔常量
    self.constTime = 1

    self.isGame3 = false

    self.wSeq = 0

    self.isStopMario = true

    self.userGame1Status = SHZ_CMD.game1_state_Free

    self.scorllData = {}
end
-- 进入游戏1
function SHZScene:initUI()
    self.game1Layer = cc.Layer:create()
    self:addChild(self.game1Layer)
    self.game1BG = display.newSprite(getRes("game1/game1Bg.png")):move(display.center)

    self.gameLayerSize1 = self.game1Layer:getContentSize()
    self.midGameLayerWidth1 = self.gameLayerSize1.width / 2
    self.midGameLayerHeight1 = self.gameLayerSize1.height / 2

    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/itemAction/box_frame.plist"))
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/itemAction/light.plist"))

    local posx, posy
    for i = 0, 2 do
        for j = 0, 4 do
            local sprite = cc.Sprite:create(getRes("common/game1_comon_1.png"))
            posx, posy = 105 + j * 230, 575 - i * 160
            sprite:setPosition(posx, posy)
            sprite:setAnchorPoint(display.LEFT_TOP)
            sprite:addTo(self.game1Layer)
            table.insert(self.m_GameSpriteArray, sprite)

            local boxSprite = cc.Sprite:createWithSpriteFrameName("game1_box_1.png")
            boxSprite:setPosition(posx, posy)
            boxSprite:setAnchorPoint(display.LEFT_TOP)
            boxSprite:setVisible(false)
            self.game1BG:addChild(boxSprite)
            table.insert(self.m_GameBoxSpriteArray, boxSprite)

            local lightSprite = cc.Sprite:createWithSpriteFrameName("common_light_01.png")
            lightSprite:setPosition(posx, posy)
            lightSprite:setAnchorPoint(display.LEFT_TOP)
            lightSprite:setVisible(false)
            self.game1BG:addChild(lightSprite)
            table.insert(self.m_GameLightSpriteArray, lightSprite)
        end
    end
    self.game1BG:addTo(self.game1Layer)

    for i = 1, 9 do
        local spriteLine = cc.Sprite:create(getRes(string.format("game1/prizeLine/%02d.png", i)))
        spriteLine:setPosition(cc.p(self.midGameLayerWidth1, self.midGameLayerHeight1))
        spriteLine:setVisible(false)
        spriteLine:addTo(self.game1Layer)
        table.insert(self.m_GameLineSpriteArray, spriteLine)
    end
    -- 创建文字滚动
    self.strList = {}
    self.strList[1] = SubLang:word(1)
    local hornNode = self:createHorn()
    hornNode:align(display.CENTER_BOTTOM, 640, 585):addTo(self.game1Layer)
    self:addGame1UI()
    self:addGame1Title()
end
-- 创建文字滚动控件
function SHZScene:createHorn()
    local size = cc.size(580, 40)
    local node = display.newNode()
    node:setContentSize(size)
    node.currentSelect = 1

    local lbl = cc.Label:create()
    lbl:setSystemFontSize(23)
    local lblSize = lbl:getContentSize()
    local msgSize = cc.size(580, 30)

    local cliper = cc.ClippingNode:create();
    cliper:setContentSize(msgSize)

    local drawNode = cc.DrawNode:create()
    local drawPos = {cc.p(45, 0), cc.p(msgSize.width, 0), cc.p(msgSize.width, msgSize.height), cc.p(45, msgSize.height)}
    local color = cc.c4f(1, 1, 1, 1)
    drawNode:drawSolidPoly(drawPos, 4, color)

    cliper:setStencil(drawNode)
    lbl:setAnchorPoint(display.LEFT_CENTER)
    lbl:setPosition(0, msgSize.height / 2)
    lbl:setTextColor(cc.c3b(0x00, 0x00, 0x00))
    cliper:addChild(lbl)

    cliper:setPosition(0, 0)
    node:addChild(cliper)
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
-- 场景消息
function SHZScene:onGameScene(data)
    local params = {}
    if (PlazaManager.gameStatus.cbGameStatus == SHZ_CMD.GAME_SCENE_FREE) or (PlazaManager.gameStatus.cbGameStatus == SHZ_CMD.GAME_SCENE_PLAY) then
        if self.gameDisConnection == true then
            game.sendEvent(GameDefine.GR_QUEST_READY)
        end
        -- self:stopAllActions()
        if self.userGame1Status == SHZ_CMD.game1_state_scroll then
            return
        end
        params.lCellScore = data:readInt64()
        params.lUserScore = data:readInt64()
        params.lTableScore = data:readInt64()
        params.record = {}
        for i = 1, 10 do
            params.record[i] = data:readUInt8()
        end
        params.bMarioStatus = data:readInt32()
        params.dwMarioScrollCount = data:readInt32()

        params.winScore = data:readInt64()
        params.cbMarioMiddleCard = {}
        for i = 1, 4 do
            params.cbMarioMiddleCard[i] = data:readInt8()
        end
        params.cbMarioCardIndex = data:readInt8()
        params.last_winScore = data:readInt64()
        params.gameName = data:readUString(64)
        params.lUserFirstScore = data:readInt64()
        params.lNormalWinScore = data:readInt64()
        params.wSeq = data:readInt16()

        cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/game1_itemCommon.plist"))
        for i = 1, 15 do
            local sprite = self.m_GameSpriteArray[i]
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("common_icon_00.png")
            sprite:initWithSpriteFrame(frame)
            sprite:setAnchorPoint(display.LEFT_TOP)
        end
        self:initGame1Params()
        self.m_lWinScore = 0
        self.cellScore = params.lCellScore
        self.userScore = params.lUserScore
        self.tableScore = params.lTableScore
        local record = {}
        for i = 1, 10 do
            record[i] = params.record[i]
        end

    end
    if self.game3Layer ~= nil then
        self.game3Layer:stopActionByTag(100)
    end
    if self.userScoreLabel then
        self.userScoreLabel:setString(tostring(self.userScore))
        self.tableScoreLabel:setString(tostring(self.tableScore))
        self.allyafenLabel:setString(tostring(self.tableScore * 9))
        self.allGetLabel:setString(tostring(0))
    end
    local bMarioStatus = params.bMarioStatus
    self.m_bFirst = 0
    self.isGame3 = false
    self.wSeq = 0
    self.isStopMario = true
    if bMarioStatus ~= 0 then
        self.isStopMario = false
        self.m_bFirst = 1
        self.dwMarioScrollCount = params.dwMarioScrollCount
        if self.dwMarioScrollCount == 0 then
            self.dwMarioScrollCount = 1
        end
        self.winScore = params.winScore
        self.lUserScore3 = self.userScore
        self.userScore = self.userScore - self.winScore

        for i = 1, 4 do
            self.cbMarioMiddleCard[i] = params.cbMarioMiddleCard[i]
        end
        self.cbMarioCardIndex = params.cbMarioCardIndex
        local last_winScore = params.last_winScore
        self.winScore = self.winScore - last_winScore
        local gameName = params.gameName
        self.lUserFirstScore = params.lUserFirstScore

        if self.userScoreLabel then
            self.userScoreLabel:setString(tostring(self.lUserFirstScore))
        end
        self.lNormalWinScore = params.lNormalWinScore
        self.wSeq = params.wSeq

        self:addGame3Layer(last_winScore)
    else
        self:cleanGame3()
        self:cleanGame2()
        self.game1Layer:setVisible(true)
        if self.isAutoPlay == true then
            local seq = cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                self:startGame()
            end))
            seq:setTag(SHZ_CMD.Game1_To_Game1)
            self.game1Layer:runAction(seq)
        end
    end
end

-- 游戏状态消息
function SHZScene:onGameStatus()

end

-- 游戏消息
function SHZScene:onGame(cmdID, data)
    if cmdID == SHZ_CMD.SUB_S_ADD_SCORE then
        -- 游戏押分
        self:OnSubAddScore(data)
    elseif cmdID == SHZ_CMD.SUB_S_CARD_SCROLL then
        -- 开始滚动
        self:OnSubGameCardScroll(data)
    elseif cmdID == SHZ_CMD.SUB_S_BIG_SMALL then
        -- 比倍游戏
        self:OnSubGameCardBigSmall(data)
    elseif cmdID == SHZ_CMD.SUB_S_MARIO_SCROLL then
        -- 马力游戏
        self:OnSubGameMarioScroll(data)
    elseif cmdID == SHZ_CMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubGameMessageInfo(data)
    end
end
-- 事件
function SHZScene:addEvent()
    game.sendEvent(GameDefine.GR_QUEST_READY)
end
-- 进入场景完成
function SHZScene:onEnterTransitionFinish()
    SHZScene.super.onEnterTransitionFinish(self)
    self:addEvent()
    MusicManager.stopBGM()
    MusicManager.playBGM(getRes("sound_res/xiongdiwushu.mp3"))
end
-- 离开场景
function SHZScene:onExit()
    SHZScene.super.onExit(self)
    LoadingManager.removeLoadRes(203)
    MusicManager.stopBGM()
end

function SHZScene:onExitGame()
    SHZScene.super.onExitGame(self)
end
-- 游戏关闭
function SHZScene:onCloseGameScene()
    self:onExitGame()
end
-- 游戏押分
function SHZScene:OnSubAddScore(data)
    if data == nil then
        return
    end
    self.tableScore = data:readInt64()
    self.tableScoreLabel:setString(tostring(self.tableScore))
    self.allyafenLabel:setString(tostring(self.tableScore * 9))
end

-- 滚动游戏消息处理
function SHZScene:dealScrollData(scrollData)
    self.userGame1Status = SHZ_CMD.game1_state_scroll
    if MusicManager.getEffectVal() > 0 then
        cc.SimpleAudioEngine:getInstance():playEffect(getRes("sound_res/gundong.mp3"))
    end

    self:stopAllItem()
    self.addBtn:setEnabled(false)
    self.subBtn:setEnabled(false)
    self.minBtn:setEnabled(false)
    self.maxBtn:setEnabled(false)
    self.startBtn:setEnabled(false)
    self.startBtn:setVisible(false)
    for i = 1, 45 do
        m_bLineType[i] = false
    end

    for i = 1, 15 do
        self.CardType[i] = scrollData.CardType[i]
    end
    self.userScore = scrollData.userScore
    self.winScore = scrollData.winScore
    self.userScoreLabel:setString(tostring(self.userScore))

    self.stopBtn:setVisible(true)
    self.stopBtn:setEnabled(true)

    local function runLine()
        self.startBtn:setVisible(true)
        self.startBtn:setEnabled(false)
        self.stopBtn:setVisible(false)
        self:CheckLine()
        self:DrawLine(false)
    end
    local function createFlash()
        local jj = 0
        for i = 1, 5 do
            for j = 0, 2 do
                local ii = j * 5 + i
                local seq = cc.Sequence:create(cc.Repeat:create(self:createGameScrollAnimation(), jj),
                    self:createGameAnimate("game1/gameAction/game1_itemJump.plist", GamePng[self.CardType[ii] + 1], 5, 0.01))
                jj = jj + 1
                if jj == 15 then
                    self.m_GameSpriteArray[15]:runAction(cc.Sequence:create(seq, cc.CallFunc:create(runLine)))
                else
                    self.m_GameSpriteArray[ii]:runAction(seq)
                end
            end
        end

    end
    createFlash()
end
local function isReapeat(params1, params2)
    if not params1 or not params2 then
        return false
    end
    for i = 1, 15 do
        if params1[1] ~= params2[1] then
            return false
        end
    end
    return true
end
-- 滚动游戏
function SHZScene:OnSubGameCardScroll(data)
    if data == nil then
        return
    end
    local scrollData_ = {}
    scrollData_.CardType = {}
    for i = 1, 15 do
        scrollData_.CardType[i] = data:readUInt8()
    end
    scrollData_.userScore = data:readInt64()
    scrollData_.winScore = data:readInt64()
    table.insert(self.scorllData, scrollData_)
    if #self.scorllData == 1 then
        self:dealScrollData(scrollData_)
    else
        local cnt = #self.scorllData
        local isRep = isReapeat(self.scorllData[cnt - 1].CardType, scrollData_.CardType)
        local str = string.format("is repeat:%d,count:%d", isRep and 1 or 0, cnt)
        print("水浒传多次下发:", str)
    end
end

-- 大小游戏
function SHZScene:OnSubGameCardBigSmall(data)
    if data == nil then
        return
    end
    self.he:setEnabled(false)
    self.xiao:setEnabled(false)
    self.da:setEnabled(false)
    local dice1Number = data:readUInt8()
    local dice2Number = data:readUInt8()
    local saizi = dice1Number + dice2Number
    self.winScore = data:readInt64()
    self.dice1 = cc.Sprite:create(string.format(getRes("game2/touzi_small_%d.png"), dice1Number))
    self.dice2 = cc.Sprite:create(string.format(getRes("game2/touzi_small_%d.png"), dice2Number))
    self.dice1:setPosition(cc.p(self.midGameLayerWidth2 - self.dice1:getContentSize().width / 2, 260 + self.dice1:getContentSize().height / 2))
    self.dice2:setPosition(cc.p(self.midGameLayerWidth2 + self.dice2:getContentSize().width / 2, 260 + self.dice2:getContentSize().height / 2))
    self.game2Layer:addChild(self.dice1)
    self.game2Layer:addChild(self.dice2)

    self.bigDice1 = cc.Sprite:create(string.format(getRes("game2/touzi_big_%d.png"), dice1Number))
    self.bigDice2 = cc.Sprite:create(string.format(getRes("game2/touzi_big_%d.png"), dice2Number))
    self.bigDice1:setVisible(false)
    self.bigDice2:setVisible(false)
    self.bigDice1:setPosition(cc.p(self.midGameLayerWidth2 - self.bigDice1:getContentSize().width / 2, 240 - self.bigDice1:getContentSize().height / 2))
    self.bigDice2:setPosition(cc.p(self.midGameLayerWidth2 + self.bigDice2:getContentSize().width / 2, 240 - self.bigDice2:getContentSize().height / 2))
    self.game2Layer:addChild(self.bigDice1)
    self.game2Layer:addChild(self.bigDice2)

    if self.p_Gold == nil then
        self.p_Gold = cc.Sprite:create(getRes("game2/bet_gold.png"))
        self.game2Layer:addChild(self.p_Gold)
    end
    if self.XDH == 0 then
        self.p_Gold:setPosition(cc.p(self.gameLayerSize2.width / 6 * 5, 170))
    elseif self.XDH == 1 then
        self.p_Gold:setPosition(cc.p(self.gameLayerSize2.width / 6, 170))
    elseif self.XDH == 2 then
        self.p_Gold:setPosition(cc.p(self.midGameLayerWidth2, 170))
    end
    self.p_Gold:setVisible(true)
    self.game2_light:stopAllActions()
    self.game2_light:setVisible(false)

    self.dealerSprite:stopAllActions()
    self.rightSprite:stopAllActions()
    self.leftSprite:stopAllActions()
    local function diceVisibleAnimate()
        self.bigDice1:setVisible(true)
        self.bigDice2:setVisible(true)
        MusicManager.playEffect(getRes(string.format("sound_res/%ddian.mp3", saizi)))
    end
    if self.winScore == 0 then
        MusicManager.playEffect(getRes("sound_res/shu.mp3"))
        self.allGetLabel:setString(tostring(0))
        local aniamte1 = self:createGameAnimate("game2/dealer/dealer_open.plist", "dealer_open_%02d.png", 14, 0.1)
        local diceVisible = cc.CallFunc:create(diceVisibleAnimate)
        local animate2 = self:createGameAnimate("game2/dealer/dealer_happy.plist", "dealer_happy_%02d.png", 7, 0.1)
        local runFailAnimation = cc.CallFunc:create(function()
            self.userScoreLabel:setString(tostring(self.userScore))
            self.startBtn:setEnabled(true)
            self.biBeiBtn:setEnabled(false)
            self.game1Layer:setVisible(true)
            self:exitGame2()
        end)
        self.dealerSprite:runAction(cc.Sequence:create(aniamte1, diceVisible, animate2, cc.DelayTime:create(2.0), runFailAnimation))
        self.rightSprite:runAction(self:createGameAnimate("game2/right/right_cry.plist", "right_cry_%02d.png", 26, 0.1))
        self.leftSprite:runAction(self:createGameAnimate("game2/left/left_cry.plist", "left_cry_%02d.png", 36, 0.1))
    else
        MusicManager.playEffect(getRes("sound_res/ying.mp3"))
        if self.win2 == nil then
            self.win2 = cc.Sprite:create(getRes("game1/win.png"))
            self.win2:setPosition(cc.p(self.gameLayerSize2.width / 4, 400))
            self.game2Layer:addChild(self.win2)

            self.pwinScore2 = cc.LabelAtlas:_create(tostring(self.winScore), getRes("game1/zhongjiang_num.png"), 101, 101, string.byte("0"))
            self.pwinScore2:setAnchorPoint(display.CENTER)
            self.pwinScore2:setVisible(true)
            self.pwinScore2:setPosition(cc.p(self.gameLayerSize2.width / 8 * 5, self.win2:getPositionY()))
            self.game2Layer:addChild(self.pwinScore2)
        else
            self.win2:setVisible(true)
            self.pwinScore2:setVisible(true)
            self.pwinScore2:setString(tostring(self.winScore))
        end

        self.allGetLabel2:setString(tostring(self.winScore))
        local dealerAniamte1 = self:createGameAnimate("game2/dealer/dealer_open.plist", "dealer_open_%02d.png", 14, 0.1)
        local dealerAniamte2 = self:createGameAnimate("game2/dealer/dealer_cry.plist", "dealer_cry_%02d.png", 15, 0.1)
        local dealerAniamte3 = self:createGameAnimate("game2/dealer/dealer_common.plist", "dealer_common_%02d.png", 8, 0.1, true)
        self.dealerSprite:runAction(cc.Sequence:create(dealerAniamte1, cc.CallFunc:create(diceVisibleAnimate), dealerAniamte2, dealerAniamte3))

        local rightAniamte1 = self:createGameAnimate("game2/right/right_happy.plist", "right_happy_%02d.png", 18, 0.1)
        local rightAniamte2 = self:createGameAnimate("game2/right/right_common2.plist", "right_common_%02d.png", 25, 0.3, true)
        self.rightSprite:runAction(cc.Sequence:create(rightAniamte1, rightAniamte2))

        local leftAnimate1 = self:createGameAnimate("game2/left/left_happy.plist", "left_happy_%02d.png", 55, 0.1)
        local leftAnimate2 = self:createGameAnimate("game2/left/left_common.plist", "left_common_%02d.png", 27, 0.1, true)
        self.leftSprite:runAction(cc.Sequence:create(leftAnimate1, leftAnimate2))

        self.goOn:setEnabled(true)
        self.getScore:setEnabled(true)
    end
end
-- 玛丽游戏
function SHZScene:OnSubGameMarioScroll(data)
    if data == nil then
        return
    end
    self.userGame1Status = SHZ_CMD.game1_state_Free
    if self.game3Layer ~= nil then
        self.game3Layer:stopActionByTag(100)
    end
    local value = self:onMarioScroll(data)
    if value.cbMarioCardIndex ~= 0xff then
        if value.wSeq <= self.wSeq then
            return
        end
    end
    self.m_bFirst = value.m_bFirst
    self.dwMarioScrollCount = value.dwMarioScrollCount
    self.cbMarioMiddleCard = {}
    for i = 1, 4 do
        self.cbMarioMiddleCard[i] = value.cbMarioMiddleCard[i]
    end
    self.cbMarioCardIndex = value.cbMarioCardIndex
    self.m_lWinScore = value.m_lWinScore
    self.lUserFirstScore = value.lUserFirstScore
    self.lNormalWinScore = value.lNormalWinScore
    self.lUserScore3 = value.lUserScore
    self.wSeq = value.wSeq
    if self.m_bFirst == 0 then
        self:addGame3Layer(0)
    end
end

function SHZScene:onSubGameMessageInfo(data)
    if data == nil then
        return
    end
    local showStr = data:readUString(200 * 2)
    showStr = GameUtil.filterMultMsg(showStr, 1)
    if showStr == nil or showStr == "" then
        return
    end

    table.insert(self.strList, showStr)
    -- self.hornNode:setString(self.strList)
end

function SHZScene:onMarioScroll(data)
    local params = {}
    params.m_bFirst = data:readUInt8()
    params.dwMarioScrollCount = data:readInt32()
    params.cbMarioMiddleCard = {}
    for i = 1, 4 do
        params.cbMarioMiddleCard[i] = data:readInt8()
    end
    params.cbMarioCardIndex = data:readUInt8()
    params.m_lWinScore = data:readInt64()
    params.lUserFirstScore = data:readInt64()
    params.lNormalWinScore = data:readInt64()
    params.lUserScore = data:readInt64()
    params.wSeq = data:readInt16()

    return params
end

-- 马力结束
function SHZScene:OnSubGameStopMario()
    self.m_lWinScore = 0
    self.wSeq = 0
    self.isStopMario = true
    self.isGame3 = false
    local win3 = cc.Sprite:create(getRes("game1/win.png"))
    win3:setPosition(cc.p(self.game3Layer:getContentSize().width / 4, 400))
    self.game3Layer:addChild(win3)
    local pwinScore3 = cc.LabelAtlas:_create(tostring(self.winScore), getRes("game1/zhongjiang_num.png"), 101, 101, string.byte("0"))
    pwinScore3:setAnchorPoint(display.CENTER)
    pwinScore3:setPosition(cc.p(self.game3Layer:getContentSize().width / 8 * 5, win3:getPositionY()))
    self.game3Layer:addChild(pwinScore3)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(3.0), cc.CallFunc:create(function()
        self.biBeiBtn:setEnabled(true)
        self.startBtn:setEnabled(true)
        self.addBtn:setEnabled(true)
        self.subBtn:setEnabled(true)
        self.minBtn:setEnabled(true)
        self.maxBtn:setEnabled(true)
        self.allGetLabel:setString(tostring(self.winScore))
        self.m_Game3SpriteArray = {}
        self.game1Layer:setVisible(true)
        self:cleanGame3()
        if self.controlIsAutoPlay == true then
            self.isAutoPlay = true
            self.controlIsAutoPlay = false
            local seq = cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
                self:startGame()
            end))
            seq:setTag(SHZ_CMD.Game3_To_Game1)
            self.game1Layer:runAction(seq)
        end
    end)))
end
function SHZScene:createButtonWithSpriteFrameName(swallow, normal, press, onclick)
    local sprite = cc.Sprite:createWithSpriteFrameName(normal)
    sprite:setAnchorPoint(display.CENTER)

    local function IsLocationInNode(node, loc)
        local pos = node:convertToNodeSpace(loc)
        local s = node:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        return cc.rectContainsPoint(rect, pos)
    end
    local function onTouchBegan(touch, event)
        if not sprite.enabled then
            return false
        end

        local target = event:getCurrentTarget()
        if not target:isVisible() then
            return false
        end

        local location = touch:getLocation()

        if IsLocationInNode(target, location) then
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(press)
            sprite:initWithSpriteFrame(frame)
            sprite:setAnchorPoint(display.CENTER)
            return true
        end
        return false
    end
    local function onTouchEnded(touch, event)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(normal)
        sprite:initWithSpriteFrame(frame)
        sprite:setAnchorPoint(display.CENTER)
        if onclick then
            onclick(sprite)
        end
    end
    function sprite:isEnabled()
        return self.enabled
    end
    function sprite:setEnabled(enabled)
        self.enabled = enabled
    end

    sprite:setEnabled(true)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(swallow)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    sprite:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, sprite)

    return sprite
end
-- 声音控制
function SHZScene:addMusiceController()
    local m_musicLayer = ccui.Layout:create()
    m_musicLayer:setContentSize(cc.size(560, 334))
    m_musicLayer:setAnchorPoint(display.CENTER)
    m_musicLayer:setPosition(cc.p(self.midGameLayerWidth1, self.midGameLayerHeight1))
    self.game1Layer:addChild(m_musicLayer)

    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("setting/setLayer.plist"))
    local bgMusic = cc.Sprite:createWithSpriteFrameName("bg.png")
    bgMusic:setPosition(cc.p(m_musicLayer:getContentSize().width / 2, m_musicLayer:getContentSize().height / 2))
    m_musicLayer:addChild(bgMusic)

    local exitMusic = self:createButtonWithSpriteFrameName(true, "exit_1.png", "exit_2.png", function()
        m_musicLayer:setVisible(false)
    end):setPosition(cc.p(228 + bgMusic:getPositionX(), 125 + bgMusic:getPositionY())):addTo(m_musicLayer)
    self.musicBtnOpen = self:createButtonWithSpriteFrameName(true, "open_1.png", "open_2.png", function()
        self.musicBtnOff:setVisible(true)
        self.musicBtnOff:setEnabled(true)
        MusicManager.setBGMVolume(0)
        self.musicBtnOpen:setVisible(false)
        self.musicBtnOpen:setEnabled(false)
    end):setPosition(cc.p(350, 130)):addTo(m_musicLayer)
    self.musicBtnOff = self:createButtonWithSpriteFrameName(true, "close_1.png", "close_2.png", function()
        self.musicBtnOff:setVisible(false)
        self.musicBtnOff:setEnabled(false)
        MusicManager.setBGMVolume(50)
        self.musicBtnOpen:setVisible(true)
        self.musicBtnOpen:setEnabled(true)
    end):setPosition(cc.p(350, 130)):addTo(m_musicLayer)
    self.effectBtnOpen = self:createButtonWithSpriteFrameName(true, "open_1.png", "open_2.png", function()
        self.effectBtnOff:setVisible(true)
        self.effectBtnOff:setEnabled(true)
        MusicManager.setEffectVolume(0)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self.effectBtnOpen:setVisible(false)
        self.effectBtnOpen:setEnabled(false)
    end):setPosition(cc.p(350, 230)):addTo(m_musicLayer)
    self.effectBtnOff = self:createButtonWithSpriteFrameName(true, "close_1.png", "close_2.png", function()
        self.effectBtnOff:setVisible(false)
        self.effectBtnOff:setEnabled(false)
        MusicManager.setEffectVolume(50)
        self.effectBtnOpen:setVisible(true)
        self.effectBtnOpen:setEnabled(true)
    end):setPosition(cc.p(350, 230)):addTo(m_musicLayer)
    local musicNum = MusicManager.getMusicVal()
    local effectNum = MusicManager.getEffectVal()
    if musicNum > 0 then
        self.musicBtnOpen:setVisible(true)
        self.musicBtnOpen:setEnabled(true)
        self.musicBtnOff:setVisible(false)
        self.musicBtnOff:setEnabled(false)
    else
        self.musicBtnOpen:setVisible(false)
        self.musicBtnOpen:setEnabled(false)
        self.musicBtnOff:setVisible(true)
        self.musicBtnOff:setEnabled(true)
    end
    if effectNum > 0 then
        self.effectBtnOpen:setVisible(true)
        self.effectBtnOpen:setEnabled(true)
        self.effectBtnOff:setVisible(false)
        self.effectBtnOff:setEnabled(false)
    else
        self.effectBtnOpen:setVisible(false)
        self.effectBtnOpen:setEnabled(false)
        self.effectBtnOff:setVisible(true)
        self.effectBtnOff:setEnabled(true)
    end
end
-- 规则
function SHZScene:addRule()
    -- self.game1Layer:setTouchEnabled(false)
    local node = cc.Node:create()
    node:setAnchorPoint(display.CENTER)
    node:setContentSize(cc.size(1334, 750))
    node:setPosition(display.center)
    self.game1Layer:addChild(node)
    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    local scroll = ccui.ScrollView:create()
    scroll:setContentSize(cc.size(1334, 750))
    scroll:setDirection(ccui.ScrollViewDir.horizontal)
    scroll:setAnchorPoint(display.CENTER)
    scroll:setPosition(display.center)
    scroll:setInnerContainerSize(cc.size(1334 * 4, 750))
    scroll:setBounceEnabled(true)
    node:addChild(scroll)

    for i = 1, 4 do
        display.newSprite(getRes(string.format("loading/preBg_%02d.png", i))):setPosition(cc.p((i - 0.5) * 1334, 750 / 2)):addTo(scroll)
    end

    -- 返回按钮
    GameUtil.createButton(getRes("game1/game1_back_1.png"), getRes("game1/game1_back_2.png"), function()
        self.game1Layer:removeChild(node)
    end):setPosition(cc.p(50, 700)):addTo(node)

end
-- 游戏一桌面UI
function SHZScene:addGame1UI()
    -- 游戏币
    self.userScoreLabel = GameUtil.createLabel(self.userScore, 24, cc.WHITE, display.LEFT_CENTER, cc.p(120, 85)):addTo(self.game1Layer)
    self.tableScoreLabel = GameUtil.createLabel(self.tableScore, 24, cc.WHITE, display.LEFT_CENTER, cc.p(550, 85)):addTo(self.game1Layer)
    self.yaxianLabel = GameUtil.createLabel(9, 24, cc.WHITE, display.LEFT_CENTER, cc.p(425, 85)):addTo(self.game1Layer)
    self.allyafenLabel = GameUtil.createLabel(self.tableScore * 9, 24, cc.WHITE, display.LEFT_CENTER, cc.p(835, 85)):addTo(self.game1Layer)
    self.allGetLabel = GameUtil.createLabel(0, 24, cc.WHITE, display.LEFT_CENTER, cc.p(1000, 85)):addTo(self.game1Layer)
    self.win = cc.Sprite:create(getRes("game1/win.png")):setPosition(cc.p(self.gameLayerSize1.width / 4, 350)):setVisible(false):addTo(self.game1Layer)
    self.pwinScore = cc.LabelAtlas:_create(tostring(self.winScore), getRes("game1/zhongjiang_num.png"), 101, 101, string.byte("0"))
    self.pwinScore:setAnchorPoint(display.CENTER)
    self.pwinScore:setVisible(false)
    self.pwinScore:setPosition(cc.p(self.gameLayerSize1.width / 8 * 5, self.win:getPositionY()))
    self.game1Layer:addChild(self.pwinScore)
    -- 全屏英雄和武器
    self.allHero = cc.Sprite:create(getRes("game1/AllHero.png"))
    self.allHero:setPosition(cc.p(self.midGameLayerWidth1, 500))
    self.allHero:setVisible(false)
    self.allHero:setScale(2)
    self.game1Layer:addChild(self.allHero)

    self.allArms = cc.Sprite:create(getRes("game1/AllArms.png"))
    self.allArms:setPosition(cc.p(self.midGameLayerWidth1, 500))
    self.allArms:setVisible(false)
    self.allArms:setScale(2)
    self.game1Layer:addChild(self.allArms)
    -- 返回按钮
    GameUtil.createButton(getRes("game1/game1_back_1.png"), getRes("game1/game1_back_2.png"), function()
        --[[if self:isDisConnect()==true then
									self:onExitGame()
								else
									SHZScene.super.onQuestStandup()
								end --]]
        SHZScene.super.onQuestStandup()
        self:onExitGame()
    end):setPosition(cc.p(60, 690)):addTo(self.game1Layer)
    -- 设置按钮
    GameUtil.createButton(getRes("game1/game1_set_1.png"), getRes("game1/game1_set_2.png"), function()
        self:addMusiceController()
    end):setAnchorPoint(display.CENTER):setPosition(cc.p(1310, 714)):addTo(self.game1Layer)
    -- 帮助按钮
    GameUtil.createButton(getRes("game1/game1_help_1.png"), getRes("game1/game1_help_2.png"), function()
        self:addRule()
    end):setAnchorPoint(display.CENTER):setPosition(cc.p(1310, 648)):addTo(self.game1Layer)
    -- 押分
    self.minBtn = GameUtil.createButton(getRes("game1/game1_min_1.png"), getRes("game1/game1_min_2.png"), function()
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_ADD_SCORE, 1024)
            rpcSend:writeInt64(self.cellScore)
            rpcSend:release()
        end
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(50, 30)):addTo(self.game1Layer)
    self.maxBtn = GameUtil.createButton(getRes("game1/game1_max_1.png"), getRes("game1/game1_max_2.png"), function()
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_ADD_SCORE, 1024)
            rpcSend:writeInt64(self.cellScore * 9)
            rpcSend:release()
        end
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(self.minBtn:getContentSize().width + self.minBtn:getPositionX(), 30)):addTo(self.game1Layer)
    self.subBtn = GameUtil.createButton(getRes("game1/game1_sub_1.png"), getRes("game1/game1_sub_2.png"), function()
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local fenshu = tonumber(self.tableScoreLabel:getString()) - self.cellScore
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_ADD_SCORE, 1024)
            rpcSend:writeInt64(fenshu)
            rpcSend:release()
        end
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(self.maxBtn:getContentSize().width + self.maxBtn:getPositionX() + 30, 30)):addTo(self.game1Layer)
    self.addBtn = GameUtil.createButton(getRes("game1/game1_add_1.png"), getRes("game1/game1_add_2.png"), function()
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local fenshu = tonumber(self.tableScoreLabel:getString()) + self.cellScore
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_ADD_SCORE, 1024)
            rpcSend:writeInt64(fenshu)
            rpcSend:release()
        end
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(self.subBtn:getContentSize().width + self.subBtn:getPositionX(), 30)):addTo(self.game1Layer)

    local bibeiX, bibeiY = self.addBtn:getContentSize().width + self.addBtn:getPositionX() + 30, 30
    self.biBeiBtn = GameUtil.createButton(getRes("game1/game1_multiply_1.png"), getRes("game1/game1_multiply_2.png"), function()
        self.win:setVisible(false)
        self.pwinScore:setVisible(false)
        self.flash:stopAllActions()
        self.flash:setVisible(false)
        self.jianTou:stopAllActions()
        self.jianTou:setVisible(false)
        for i = 1, SHZ_CMD.ActionCount do
            self.game1Layer:stopActionByTag(i)
        end
        if self.isAutoPlay == true then
            self.isAutoPlay = false
            self.controlIsAutoPlay = true
        end
        self.game1Layer:setVisible(false)
        self.biBeiBtn:setEnabled(false)
        cc.SimpleAudioEngine:getInstance():stopAllEffects()
        self:addGame2Layer()
    end):setAnchorPoint(display.LEFT_CENTER):setEnabled(false):setPosition(cc.p(bibeiX, bibeiY)):addTo(self.game1Layer)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/flash.plist"))
    self.flash = cc.Sprite:createWithSpriteFrameName("game1_flash_01.png")
    self.flash:setAnchorPoint(display.LEFT_CENTER)
    self.flash:setVisible(false)
    self.flash:setPosition(bibeiX - 12, bibeiY - 3)
    self.game1Layer:addChild(self.flash)
    self.jianTou = cc.Sprite:create(getRes("game1/arrow.png"))
    self.jianTou:setAnchorPoint(display.CENTER_BOTTOM)
    self.jianTou:setVisible(false)
    self.jianTou:setPosition(cc.p(780, 75))
    self.game1Layer:addChild(self.jianTou)

    -- 自动游戏
    self.autoBtn = GameUtil.createButton(getRes("game1/game1_auto_1.png"), getRes("game1/game1_auto_2.png"), function()
        if self.isAutoPlay then
            self.isAutoPlay = false
            self.checkSprite:setVisible(self.isAutoPlay)
            self.autoBtn:stopAllActions()
        else
            self.isAutoPlay = true
            self.checkSprite:setVisible(self.isAutoPlay)
            self:doCheckAuto()
        end
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(self.biBeiBtn:getContentSize().width + bibeiX + 30, 30)):addTo(self.game1Layer)
    self.autoBtnSize = self.autoBtn:getContentSize()
    self.checkSprite = cc.Sprite:create(getRes("game1/game1_check.png"))
    self.checkSprite:setPosition(cc.p(self.autoBtnSize.width / 4, self.autoBtnSize.height / 2))
    self.checkSprite:setVisible(self.isAutoPlay)
    self.autoBtn:addChild(self.checkSprite)
    -- 开始按钮
    self.startBtn = GameUtil.createButton(getRes("game1/game1_start_1.png"), getRes("game1/game1_start_2.png"), function()
        self:startGame()
    end):setAnchorPoint(display.LEFT_CENTER):setPosition(cc.p(self.autoBtnSize.width + self.autoBtn:getPositionX() + 25, 50)):addTo(self.game1Layer)
    -- 停止按钮
    self.stopBtn = GameUtil.createButton(getRes("game1/game1_stop_1.png"), getRes("game1/game1_stop_2.png"), function()
        self:doStop()
    end):setAnchorPoint(display.LEFT_CENTER):setVisible(false):setPosition(cc.p(self.autoBtnSize.width + self.autoBtn:getPositionX() + 25, 50)):addTo(self.game1Layer)
end

function SHZScene:doCheckAuto()
    local function doAutoCheck()
        if not self.startBtn:isEnabled() or self.game3Layer or self.game2Layer then
            self.nCheckCount = 0
            return
        end

        self.nCheckCount = self.nCheckCount + 1
        if self.nCheckCount >= 6 then
            self.isAutoPlay = true
            self:startGame()
        end
    end
    self.autoBtn:stopAllActions()
    local seq = cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(doAutoCheck))
    self.autoBtn:runAction(cc.RepeatForever:create(seq))
    if self.startBtn:isEnabled() then
        self:startGame()
    end
end

-- 创建动画
function SHZScene:createGameAnimate(gamePlist, gamePng, count, perUnit, isLoop)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes(gamePlist))
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format(gamePng, i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(perUnit)
    if isLoop then
        animation:setLoops(-1)
    end
    local animate = cc.Animate:create(animation)
    return animate
end
-- 游戏1标题
function SHZScene:addGame1Title()
    -- 创建打鼓动画
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/dagu.plist"))
    local dagu = cc.Sprite:createWithSpriteFrameName("action_dagu_01.png")
    dagu:setPosition(cc.p(200, self.game1BG:getContentSize().height - 80))
    dagu:runAction(cc.RepeatForever:create(self:createGameAnimate("game1/gameAction/dagu.plist", "action_dagu_%02d.png", 29, 0.1)))
    self.game1BG:addChild(dagu)
    -- 创建摇旗动画
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/piaoqi.plist"))
    self.piaoqi = cc.Sprite:createWithSpriteFrameName("action_wyaoqi_01.png")
    self.piaoqi:setAnchorPoint(display.LEFT_BOTTOM)
    self.piaoqi:setPosition(cc.p(969, self.game1BG:getContentSize().height - 174))
    self.piaoqi:runAction(cc.RepeatForever:create(self:createGameAnimate("game1/gameAction/piaoqi.plist", "action_wyaoqi_%02d.png", 43, 0.1)))
    self.game1BG:addChild(self.piaoqi)
    -- 创建标题动画
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/shz_title.plist"))
    local title = cc.Sprite:createWithSpriteFrameName("action_title_01.png")
    title:setPosition(cc.p(self.game1BG:getContentSize().width / 2, self.game1BG:getContentSize().height - 63))
    title:runAction(cc.RepeatForever:create(self:createGameAnimate("game1/gameAction/shz_title.plist", "action_title_%02d.png", 10, 0.1)))
    self.game1BG:addChild(title)
end
-- 添加游戏2
function SHZScene:addGame2Layer()
    self.game2Layer = cc.Layer:create()
    self:addChild(self.game2Layer)

    self.gameLayerSize2 = self.game2Layer:getContentSize()
    self.midGameLayerWidth2 = self.gameLayerSize2.width / 2
    self.midGameLayerHeight2 = self.gameLayerSize2.height / 2
    local Game2_BG_1 = cc.Sprite:create(getRes("game2/game2_bg.png")):setPosition(cc.p(self.midGameLayerWidth2, self.midGameLayerHeight2)):addTo(self.game2Layer)
    local Game2_BG_2 = cc.Sprite:create(getRes("game2/game2_bg_Down.png")):setAnchorPoint(display.LEFT_BOTTOM):setPosition(display.LEFT_BOTTOM):addTo(self.game2Layer)
    self.userScoreLabel2 = GameUtil.createLabel(self.userScore, 24, cc.WHITE, display.LEFT_BOTTOM, cc.p(170, 37)):addTo(self.game2Layer)
    self.tableScoreLabel2 = GameUtil.createLabel(self.winScore, 24, cc.WHITE, display.LEFT_BOTTOM, cc.p(520, 75)):addTo(self.game2Layer)
    self.allGetLabel2 = GameUtil.createLabel(0, 24, cc.WHITE, display.LEFT_BOTTOM, cc.p(830, 75)):addTo(self.game2Layer)
    local function bibeiStart()
        self.banBi:setEnabled(false)
        self.quanBi:setEnabled(false)
        self.beiBi:setEnabled(false)
        self.dealerSprite:stopAllActions()
        self.rightSprite:stopAllActions()
        self.leftSprite:stopAllActions()
        self.dealerSprite:setPositionY(self.dealerSprite:getPositionY() + 20)
        local dealerAnimate1 = self:createGameAnimate("game2/dealer/dealer_dice1.plist", "dealer_dice_%02d.png", 18, 0.1)
        local dealerAnimate2 = self:createGameAnimate("game2/dealer/dealer_dice2.plist", "dealer_dice2_%02d.png", 11, 0.1)
        local dealerCallfunc = cc.CallFunc:create(function()
            self.dealerSprite:setPositionY(self.dealerSprite:getPositionY() - 20)
            MusicManager.playEffect(getRes("sound_res/xia.mp3"))
        end)
        local dealerAnimate3 = self:createGameAnimate("game2/dealer/dealer_common.plist", "dealer_common_%02d.png", 8, 0.1, true)
        local dealerSeq = cc.Sequence:create(dealerAnimate1, dealerAnimate2, dealerCallfunc, dealerAnimate3)
        self.dealerSprite:runAction(dealerSeq)

        local rightAnimate1 = self:createGameAnimate("game2/right/right_cheer1.plist", "right_cheer_%02d.png", 15, 0.1)
        local rightAnimate2 = self:createGameAnimate("game2/right/right_cheer2.plist", "right_cheer_%02d.png", 14, 0.1)
        local rightAnimate3 = self:createGameAnimate("game2/right/right_common2.plist", "right_common_%02d.png", 25, 0.3, true)
        self.rightSprite:runAction(cc.Sequence:create(rightAnimate1, rightAnimate2, rightAnimate3))

        local leftAnimate1 = self:createGameAnimate("game2/left/left_cheer.plist", "left_cheer_%02d.png", 29, 0.1)
        local leftAnimate2 = self:createGameAnimate("game2/left/left_common.plist", "left_common_%02d.png", 27, 0.1, true)
        local function AreaClick(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                if self:isDisConnect() == true then
                    self:refreshGame()
                else
                    local nowTime = GameUtil.getSystemTime()
                    if nowTime - self.lastTime < self.constTime then
                        return
                    end
                    self.lastTime = nowTime
                    self.XDH = sender:getTag()

                    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_BIG_SMALL, 1024)
                    rpcSend:writeUInt8(sender:getTag())
                    rpcSend:release()
                    self.xiao:setEnabled(false)
                    self.he:setEnabled(false)
                    self.da:setEnabled(false)
                end
            end
        end
        local leftCallfunc = cc.CallFunc:create(function()
            if self.game2_light == nil then
                self.game2_light = cc.Sprite:create(getRes("game2/game2_light.png"))
                self.game2_light:setAnchorPoint(display.CENTER_BOTTOM)
                self.game2_light:setPosition(cc.p(self.midGameLayerWidth2 - 15, 78))
                self.game2_light:setVisible(true)
                self.game2_light:runAction(cc.RepeatForever:create(cc.Blink:create(1, 1)))
                self.game2Layer:addChild(self.game2_light)
            else
                self.game2_light:setVisible(true)
            end
            if self.xiao == nil then
                local wwi = self.gameLayerSize2.width / 3
                self.xiao = ccui.Button:create(getRes("game2/game2_btn_get_01.png"))
                self.xiao:setScaleX(wwi / self.xiao:getContentSize().width)
                self.xiao:setScaleY(130 / self.xiao:getContentSize().height)
                self.xiao:setAnchorPoint(display.LEFT_BOTTOM)
                self.xiao:setPosition(cc.p(0, 110))
                self.xiao:setEnabled(true)
                self.xiao:setTag(1)
                self.xiao:setOpacity(0)
                self.xiao:addTouchEventListener(AreaClick)
                self.game2Layer:addChild(self.xiao)

                self.he = ccui.Button:create(getRes("game2/game2_btn_get_01.png"))
                self.he:setScaleX(wwi / self.he:getContentSize().width)
                self.he:setScaleY(130 / self.he:getContentSize().height)
                self.he:setAnchorPoint(display.LEFT_BOTTOM)
                self.he:setPosition(cc.p(wwi, 110))
                self.he:setEnabled(true)
                self.he:setTag(2)
                self.he:setOpacity(0)
                self.he:addTouchEventListener(AreaClick)
                self.game2Layer:addChild(self.he)

                self.da = ccui.Button:create(getRes("game2/game2_btn_get_01.png"))
                self.da:setScaleX(wwi / self.he:getContentSize().width)
                self.da:setScaleY(130 / self.he:getContentSize().height)
                self.da:setAnchorPoint(display.LEFT_BOTTOM)
                self.da:setPosition(cc.p(wwi * 2, 110))
                self.da:setEnabled(true)
                self.da:setTag(0)
                self.da:setOpacity(0)
                self.da:addTouchEventListener(AreaClick)
                self.game2Layer:addChild(self.da)
            else
                self.xiao:setEnabled(true)
                self.he:setEnabled(true)
                self.da:setEnabled(true)
            end
        end)
        self.leftSprite:runAction(cc.Sequence:create(leftAnimate1, leftCallfunc, leftAnimate2))
    end
    self.banBi = GameUtil.createButton(getRes("game2/game2_btn_half_01.png"), getRes("game2/game2_btn_half_02.png"), function()
        bibeiStart()
        self.userScore = self.userScore + math.ceil(self.winScore / 2)
        self.userScoreLabel2:setString(tostring(self.userScore))
        self.tableScoreLabel2:setString(tostring(math.floor(self.winScore / 2)))
        MusicManager.playEffect(getRes("sound_res/yaosaizi.mp3"))
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
            rpcSend:writeUInt8(0)
            rpcSend:release()
        end
    end):setPosition(cc.p(440, 30)):setAnchorPoint(display.LEFT_CENTER):setEnabled(true):addTo(self.game2Layer)
    self.quanBi = GameUtil.createButton(getRes("game2/game2_btn_All_01.png"), getRes("game2/game2_btn_All_02.png"), function()
        bibeiStart()
        MusicManager.playEffect(getRes("sound_res/yaosaizi.mp3"))
        self.userScoreLabel2:setString(tostring(self.userScore))
        self.tableScoreLabel2:setString(tostring(self.winScore))
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
            rpcSend:writeUInt8(1)
            rpcSend:release()
        end
    end):setPosition(cc.p(self.banBi:getPositionX() + self.banBi:getContentSize().width, 30)):setAnchorPoint(display.LEFT_CENTER):setEnabled(true):addTo(self.game2Layer)
    self.beiBi = GameUtil.createButton(getRes("game2/game2_btn_Double_01.png"), getRes("game2/game2_btn_Double_02.png"), function()
        bibeiStart()
        MusicManager.playEffect(getRes("sound_res/yaosaizi.mp3"))
        self.userScore = self.userScore - self.winScore
        self.userScoreLabel2:setString(tostring(self.userScore))
        self.tableScoreLabel2:setString(tostring(self.winScore * 2))
        if self:isDisConnect() == true then
            self:refreshGame()
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_HALF_ALL_DOUBLE, 1024)
            rpcSend:writeUInt8(2)
            rpcSend:release()
        end
    end):setPosition(cc.p(self.quanBi:getPositionX() + self.quanBi:getContentSize().width, 30)):setAnchorPoint(display.LEFT_CENTER):setEnabled(true):addTo(self.game2Layer)
    if self.userScore < self.winScore then
        self.beiBi:setEnabled(false)
    end

    self.goOn = GameUtil.createButton(getRes("game2/game2_btn_GoOn_01.png"), getRes("game2/game2_btn_GoOn_02.png"), function()
        if self.win2 and self.pwinScore2 then
            self.win2:setVisible(false)
            self.pwinScore2:setVisible(false)
        end
        self.goOn:setEnabled(false)
        self.xiao:setEnabled(true)
        self.da:setEnabled(true)
        self.he:setEnabled(true)
        self.tableScoreLabel2:setString(tostring(self.winScore))
        self.allGetLabel2:setString(tostring(0))
        self.p_Gold:setVisible(false)
        self.dice1:removeFromParent()
        self.dice2:removeFromParent()
        self.bigDice1:removeFromParent()
        self.bigDice2:removeFromParent()
        self.banBi:setEnabled(true)
        self.quanBi:setEnabled(true)
        if self.userScore < self.winScore then
            self.beiBi:setEnabled(false)
        else
            self.beiBi:setEnabled(true)
        end
    end):setPosition(cc.p(self.beiBi:getPositionX() + self.beiBi:getContentSize().width, 30)):setAnchorPoint(display.LEFT_CENTER):setEnabled(false):addTo(self.game2Layer)
    self.getScore = GameUtil.createButton(getRes("game2/game2_btn_get_01.png"), getRes("game2/game2_btn_get_02.png"), function()
        -- self.userScore = self.userScore + self.winScore
        self.userScoreLabel2:setString(tostring(self.userScore + self.winScore))
        self.userScoreLabel:setString(tostring(self.userScore))
        self.allGetLabel:setString(tostring(self.winScore))
        self.startBtn:setEnabled(true)
        self.biBeiBtn:setEnabled(true)
        self.game1Layer:setVisible(true)
        self:exitGame2()
    end):setPosition(cc.p(1170, 50)):setEnabled(false):addTo(self.game2Layer)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game2/dealer/dealer_common.plist"))
    self.dealerSprite = cc.Sprite:createWithSpriteFrameName("dealer_common_01.png")
    self.dealerSprite:setAnchorPoint(display.CENTER)
    self.dealerSprite:setPosition(cc.p(self.midGameLayerWidth2, 480))
    self.dealerSprite:runAction(cc.RepeatForever:create(self:createGameAnimate("game2/dealer/dealer_common.plist", "dealer_common_%02d.png", 8, 0.1)))
    self.game2Layer:addChild(self.dealerSprite)

    self.rightSprite = cc.Sprite:create()
    self.rightSprite:setAnchorPoint(display.RIGHT_BOTTOM)
    self.rightSprite:setPosition(cc.p(self.gameLayerSize2.width, 258))
    self.rightSprite:runAction(cc.RepeatForever:create(self:createGameAnimate("game2/right/right_common2.plist", "right_common_%02d.png", 25, 0.3)))
    self.game2Layer:addChild(self.rightSprite)

    self.leftSprite = cc.Sprite:create()
    self.leftSprite:setAnchorPoint(display.LEFT_BOTTOM)
    self.leftSprite:setPosition(cc.p(0, 275))
    self.leftSprite:runAction(cc.RepeatForever:create(self:createGameAnimate("game2/left/left_common.plist", "left_common_%02d.png", 27, 0.1)))
    self.game2Layer:addChild(self.leftSprite)

end
-- 退出游戏2 
function SHZScene:exitGame2()
    if self.controlIsAutoPlay == true then
        self.isAutoPlay = true
        self.controlIsAutoPlay = false
        local seq = cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function()
            self:startGame()
        end))
        seq:setTag(SHZ_CMD.Game2_To_Game1)
        self.game1Layer:runAction(seq)
    end

    self:cleanGame2()
end

function SHZScene:cleanGame2()
    if self.game2Layer then
        self.game2Layer:removeAllChildren()
        self.game2Layer:removeFromParent()
        self.game2Layer = nil
    end

    self.game2_light = nil
    self.xiao = nil
    self.he = nil
    self.da = nil
    self.p_Gold = nil
    self.win2 = nil
    self.pwinScore2 = nil
end

function SHZScene:cleanGame3()
    if self.game3Layer ~= nil then
        self.game3Layer:removeAllChildren()
        self.game3Layer:removeFromParent()
        self.game3Layer = nil
    end
end

-- 游戏3中间四个中奖动画处理
function SHZScene:MidFourAnimation()
    local isSame4 = false
    local isSameRight3 = false
    local isSameLeft3 = false
    if self.cbMarioMiddleCard[1] == self.cbMarioMiddleCard[2] and self.cbMarioMiddleCard[2] == self.cbMarioMiddleCard[3] then
        isSameLeft3 = true
        isSameRight3 = false
        if self.cbMarioMiddleCard[3] == self.cbMarioMiddleCard[4] then
            isSame4 = true
            isSameLeft3 = false
        end
    else
        if self.cbMarioMiddleCard[2] == self.cbMarioMiddleCard[3] and self.cbMarioMiddleCard[3] == self.cbMarioMiddleCard[4] then
            isSameRight3 = true
        end
    end
    if isSame4 == true then
        for i = 1, 4 do
            local boxSprite = self.game3Layer:getChildByTag(i + 4)
            boxSprite:setVisible(true)
            boxSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/box_frame.plist", "game1_box_%d.png", 6, 0.1), 3))
            local lightSprite = self.game3Layer:getChildByTag(i + 8)
            lightSprite:setVisible(true)
            lightSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/light.plist", "common_light_%02d.png", 9, 0.1), 3))
        end
    else
        if isSameLeft3 == true then
            for i = 1, 3 do
                local boxSprite = self.game3Layer:getChildByTag(i + 4)
                boxSprite:setVisible(true)
                boxSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/box_frame.plist", "game1_box_%d.png", 6, 0.1), 3))
                local lightSprite = self.game3Layer:getChildByTag(i + 8)
                lightSprite:setVisible(true)
                lightSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/light.plist", "common_light_%02d.png", 9, 0.1), 3))
            end
        else
            if isSameRight3 == true then
                for i = 2, 4 do
                    local boxSprite = self.game3Layer:getChildByTag(i + 4)
                    boxSprite:setVisible(true)
                    boxSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/box_frame.plist", "game1_box_%d.png", 6, 0.1), 3))
                    local lightSprite = self.game3Layer:getChildByTag(i + 8)
                    lightSprite:setVisible(true)
                    lightSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/light.plist", "common_light_%02d.png", 9, 0.1), 3))
                end
            end
        end
    end
end
-- 进入游戏3
function SHZScene:addGame3Layer(last_winScore)
    self.isGame3 = true
    if self.isStopMario == true then
        return
    end
    if self.cbMarioCardIndex == 0xff then
        -- local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET,game.MDM_GF_GAME,SHZ_CMD.SUB_C_STOP_MARIO,1024)
        -- rpcSend:release()
        self:OnSubGameStopMario()
        return
    end

    if self.m_bFirst == 1 then
        self.m_Game3SpriteArray = {}
        self.m_lWinScore = self.m_lWinScore + last_winScore
        self.game1Layer:setVisible(false)
        self.win:setVisible(false)
        self.pwinScore:setVisible(false)

        -- 游戏层3 马力游戏
        self:cleanGame3()
        self.game3Layer = cc.Layer:create()
        self:addChild(self.game3Layer)
        for i = 1, 4 do
            local sprite = cc.Sprite:create(getRes(string.format("game3/icon/icon_%02d.png", self.cbMarioMiddleCard[i])))
            local j = self.cbMarioMiddleCard[i] + 1
            sprite:setPosition(cc.p(223 * (i - 1) + 210, 183))
            sprite:setTag(i)
            sprite:setScaleX(1.2)
            sprite:setAnchorPoint(display.LEFT_BOTTOM)
            self.game3Layer:addChild(sprite)
            local boxSprite = cc.Sprite:createWithSpriteFrameName("game1_box_1.png")
            boxSprite:setPosition(cc.p(223 * (i - 1) + 336, 247))
            boxSprite:setAnchorPoint(display.CENTER)
            boxSprite:setVisible(false)
            boxSprite:setTag(i + 4)
            boxSprite:setZOrder(2)
            self.game3Layer:addChild(boxSprite)

            local lightSprite = cc.Sprite:createWithSpriteFrameName("common_light_01.png")
            lightSprite:setPosition(cc.p(223 * (i - 1) + 336, 247))
            lightSprite:setAnchorPoint(display.CENTER)
            lightSprite:setVisible(false)
            lightSprite:setTag(i + 8)
            lightSprite:setZOrder(2)
            self.game3Layer:addChild(lightSprite)
            if i == 4 then
                local seq = cc.Sequence:create(cc.Repeat:create(self:createGameScrollAnimation(), 3), self:createGameAnimate("game1/gameAction/game1_itemJump.plist", GamePng[j], 5, 0.01),
                    cc.CallFunc:create(function()
                        self:MidFourAnimation()
                    end))
                sprite:runAction(seq)
            else
                local seq = cc.Sequence:create(cc.Repeat:create(self:createGameScrollAnimation(), 3), self:createGameAnimate("game1/gameAction/game1_itemJump.plist", GamePng[j], 5, 0.01))
                sprite:runAction(seq)
            end
        end
        local m_Game3_Bg = cc.Sprite:create(getRes("game3/game3_bg.png"))
        m_Game3_Bg:setPosition(cc.p(self.game3Layer:getContentSize().width / 2, self.game3Layer:getContentSize().height / 2))
        self.game3Layer:addChild(m_Game3_Bg)
        -- 玩家金币
        self.userScoreLabel3 = cc.LabelAtlas:_create(self.lUserFirstScore, getRes("game3/time.png"), 22, 27, string.byte("0"))
        self.userScoreLabel3:setPosition(cc.p(340, 132))
        self.game3Layer:addChild(self.userScoreLabel3)
        self.allGetLabel3 = cc.LabelAtlas:_create(self.winScore, getRes("game3/time.png"), 22, 27, string.byte("0"))
        self.allGetLabel3:setPosition(cc.p(655, 132))
        self.game3Layer:addChild(self.allGetLabel3)
        self.tableScoreLabel3 = cc.LabelAtlas:_create(self.tableScore * 9, getRes("game3/time.png"), 22, 27, string.byte("0"))
        self.tableScoreLabel3:setPosition(cc.p(970, 132))
        self.game3Layer:addChild(self.tableScoreLabel3)
        self.countLabel3 = cc.LabelAtlas:_create(self.dwMarioScrollCount, getRes("game3/time.png"), 22, 27, string.byte("0"))
        self.countLabel3:setPosition(cc.p(710, 390))
        self.game3Layer:addChild(self.countLabel3)
        for i = 1, 24 do
            local sprite = cc.Sprite:create(getRes(string.format("game3/icon/icon_%02d.png", m_cbMarioType[i])))
            sprite:setAnchorPoint(display.LEFT_CENTER)
            if i >= 1 and i <= 7 then
                sprite:setPosition(cc.p(20 + (20 + 169) * (i - 1), 750 - 25 - 94 / 2))
            elseif i > 7 and i <= 13 then
                sprite:setPosition(cc.p(20 + (20 + 169) * 6, 750 - 25 - 48 - (94 + 10) * (i - 7)))
            elseif i > 13 and i <= 19 then
                sprite:setPosition(cc.p(20 + (20 + 169) * 6 - (20 + 169) * (i - 13), 4 + 94 / 2))
            else
                sprite:setPosition(cc.p(20, 4 + 48 + (94 + 10) * (i - 19)))
            end
            sprite:setVisible(false)
            self.game3Layer:addChild(sprite)
            table.insert(self.m_Game3SpriteArray, sprite)
        end
    else
        for i = 1, 4 do
            local sprite = self.game3Layer:getChildByTag(i)
            local j = self.cbMarioMiddleCard[i] + 1
            if i == 4 then
                local seq = cc.Sequence:create(cc.Repeat:create(self:createGameScrollAnimation(), 3), self:createGameAnimate("game1/gameAction/game1_itemJump.plist", GamePng[j], 5, 0.01),
                    cc.CallFunc:create(function()
                        self:MidFourAnimation()
                    end))
                sprite:runAction(seq)
            else
                local seq = cc.Sequence:create(cc.Repeat:create(self:createGameScrollAnimation(), 3), self:createGameAnimate("game1/gameAction/game1_itemJump.plist", GamePng[j], 5, 0.01))
                sprite:runAction(seq)
            end
        end
        self.countLabel3:setString(tostring(self.dwMarioScrollCount))
    end

    self.game3Layer:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
        if self.times == nil then
            self.times = 0
        end
        self.times = self.times + 1
        self:GameGundong()
    end)))
end

function SHZScene:GameGundong()
    MusicManager.playEffect(getRes("sound_res/Threegundong.mp3"))
    if self.times % 24 > 1 then
        local sprite1 = self.m_Game3SpriteArray[self.times % 24 - 1]
        sprite1:setVisible(false)
        local sprite11 = self.m_Game3SpriteArray[self.times % 24]
        sprite11:setVisible(true)
    elseif self.times % 24 == 0 then
        local sprite2 = self.m_Game3SpriteArray[23]
        sprite2:setVisible(false)
        local sprite22 = self.m_Game3SpriteArray[24]
        sprite22:setVisible(true)
    elseif self.times % 24 == 1 then
        local sprite3 = self.m_Game3SpriteArray[24]
        sprite3:setVisible(false)
        local sprite33 = self.m_Game3SpriteArray[1]
        sprite33:setVisible(true)
    end
    if self.times > 48 and (self.times - 48) % 25 == self.cbMarioCardIndex + 1 then
        self.winScore = self.lUserScore3 - self.lUserFirstScore
        self.allGetLabel3:setString(tostring(self.winScore))
        self.game3Layer:stopAllActions()
        local isaction = false
        for i = 1, 4 do
            local boxSprite = self.game3Layer:getChildByTag(i + 4)
            boxSprite:stopAllActions()
            local lightSprite = self.game3Layer:getChildByTag(i + 8)
            lightSprite:stopAllActions()
        end
        for i = 1, 4 do
            if self.cbMarioMiddleCard[i] == m_cbMarioType[self.cbMarioCardIndex + 1] then
                isaction = true
                local sprite = self.game3Layer:getChildByTag(i)
                sprite:runAction(self:createGameAnimate(playerPlist[self.cbMarioMiddleCard[i] + 1], playerPng[self.cbMarioMiddleCard[i] + 1], playerPngCount[self.cbMarioMiddleCard[i] + 1], 0.1))
            end
        end
        self.times = self.cbMarioCardIndex + 1
        local sprite = self.m_Game3SpriteArray[self.times]
        local func = cc.CallFunc:create(function()
            for i = 1, 4 do
                self.game3Layer:getChildByTag(i):stopAllActions()
                self.game3Layer:getChildByTag(i + 4):setVisible(false)
                self.game3Layer:getChildByTag(i + 8):setVisible(false)
            end
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_MARIO_SCROLL, 1024)
            rpcSend:release()

            local seq = cc.Sequence:create(cc.DelayTime:create(8), cc.CallFunc:create(function()
                self:refreshGame()
            end))
            seq:setTag(100)
            self.game3Layer:runAction(seq)

            local texture = cc.Director:getInstance():getTextureCache():addImage(getRes(string.format("game3/icon/icon_%02d.png", m_cbMarioType[self.cbMarioCardIndex + 1])))
            sprite:setTexture(texture)
            sprite:setTextureRect(cc.rect(0, 0, texture:getContentSize().width, texture:getContentSize().height))
        end)
        if isaction == true then
            self.times = self.cbMarioCardIndex + 1
            local cardNmuber = m_cbMarioType[self.cbMarioCardIndex + 1] + 1
            local seq = cc.Sequence:create(self:createGameAnimate(playerPlist[cardNmuber], playerPng[cardNmuber], playerPngCount[cardNmuber], 0.1), func)
            sprite:runAction(seq)
            MusicManager.playEffect(getRes("sound_res/winsound.mp3"))
        else
            sprite:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), func))
        end
    else
        local tempTime = 0.3 * math.tan(math.rad(self.times / 2))
        self.game3Layer:runAction(cc.Sequence:create(cc.DelayTime:create(tempTime), cc.CallFunc:create(function()
            if self.times == nil then
                self.times = 0
            end
            self.times = self.times + 1
            self:GameGundong()
        end)))
    end
end

-- 滚动动画
function SHZScene:createGameScrollAnimation()
    local pTexture = cc.Director:getInstance():getTextureCache():addImage(getRes("common/common_MoveImg.png"))
    local animation = cc.Animation:create()
    local size = pTexture:getContentSize()
    local hh = size.height / 9
    for i = 0, 8 do
        local frame = cc.SpriteFrame:createWithTexture(pTexture, cc.rect(0, i * hh, size.width, hh))
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(0.01)
    local animate = cc.Animate:create(animation)
    return animate
end

-- 查询中奖
function SHZScene:CheckLine()
    for j = 1, 9 do
        -- 从左至右
        local nSameCount = 0
        local cbTempCardIndex = {}
        for i = 1, 5 do
            cbTempCardIndex[i] = self.CardType[m_cbCardLine[j][i]]
        end
        cbTempCardIndex[6] = 0xFF
        for i = 1, 5 do
            if cbTempCardIndex[i] ~= 0 and cbTempCardIndex[i + 1] ~= 0 and cbTempCardIndex[i + 1] ~= 0xFF then
                if cbTempCardIndex[i] == cbTempCardIndex[i + 1] then
                    nSameCount = nSameCount + 1
                else
                    break
                end
            elseif cbTempCardIndex[i] == 0 and cbTempCardIndex[i + 1] ~= 0 and cbTempCardIndex[i + 1] ~= 0xFF then
                nSameCount = nSameCount + 1
            elseif cbTempCardIndex[i] == 0 and cbTempCardIndex[i + 1] == 0 then
                nSameCount = nSameCount + 1
            elseif cbTempCardIndex[i] ~= 0 and cbTempCardIndex[i + 1] == 0 then
                nSameCount = nSameCount + 1
                cbTempCardIndex[i + 1] = cbTempCardIndex[i]
            end
        end
        -- 5连线
        if nSameCount == 4 then
            m_bLineType[j * 5 - 4] = true
            -- 4连线
        elseif nSameCount == 3 then
            m_bLineType[j * 5 - 3] = true
            -- 3连线
        elseif nSameCount == 2 then
            m_bLineType[j * 5 - 2] = true
        end
        -- 从右至左
        nSameCount = 0
        for i = 2, 6 do
            cbTempCardIndex[i] = self.CardType[m_cbCardLine[j][i - 1]]
        end
        cbTempCardIndex[1] = 0xFF
        for i = 6, 2, -1 do
            if cbTempCardIndex[i] ~= 0 and cbTempCardIndex[i - 1] ~= 0 then
                if cbTempCardIndex[i] == cbTempCardIndex[i - 1] then
                    nSameCount = nSameCount + 1
                else
                    break
                end
            elseif cbTempCardIndex[i] == 0 and cbTempCardIndex[i - 1] ~= 0 then
                nSameCount = nSameCount + 1
            elseif cbTempCardIndex[i] == 0 and cbTempCardIndex[i - 1] == 0 then
                nSameCount = nSameCount + 1
            elseif cbTempCardIndex[i] ~= 0 and cbTempCardIndex[i - 1] == 0 then
                nSameCount = nSameCount + 1
                cbTempCardIndex[i - 1] = cbTempCardIndex[i]
            end
        end
        -- 4连线
        if nSameCount == 3 then
            m_bLineType[j * 5 - 1] = true
            -- 3连线
        elseif nSameCount == 2 then
            m_bLineType[j * 5] = true
        end
    end
end

function SHZScene:doStop()
    cc.SimpleAudioEngine:getInstance():stopAllEffects()

    self.isAutoPlay = false
    self.checkSprite:setVisible(self.isAutoPlay)
    self.autoBtn:stopAllActions()
    for i = 1, SHZ_CMD.ActionCount do
        self.game1Layer:stopActionByTag(i)
    end

    self.startBtn:setVisible(true)
    self.startBtn:setEnabled(false)
    self.stopBtn:setVisible(false)
    self.stopBtn:setEnabled(false)

    self:CheckLine()
    self:DrawLine(true)
end

function SHZScene:stopAllItem()
    cc.SimpleAudioEngine:getInstance():stopAllEffects()
    for i = 1, SHZ_CMD.ActionCount do
        self.game1Layer:stopActionByTag(i)
    end

    self.flash:stopAllActions()
    self.flash:setVisible(false)
    self.jianTou:stopAllActions()
    self.jianTou:setVisible(false)
    self.jianTou:setPosition(cc.p(780, 75))
    self.biBeiBtn:setEnabled(false)

    self.m_animationSpriteArray = {}
    for i = 1, 15 do
        self.m_GameSpriteArray[i]:stopAllActions()

        local boxSprite = self.m_GameBoxSpriteArray[i]
        boxSprite:stopAllActions()
        boxSprite:setVisible(false)

        local lightSprite = self.m_GameLightSpriteArray[i]
        lightSprite:stopAllActions()
        lightSprite:setVisible(false)
    end
    for i = 1, 9 do
        local lineSprite = self.m_GameLineSpriteArray[i]
        lineSprite:setVisible(false)
    end
    self:drawWin(false, false, false)
end

function SHZScene:finallySprite(bIsStop, bIsGray)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(getRes("game1/gameAction/game1_itemCommon.plist"))
    local sprite, frame, resname
    for i = 1, 15 do
        sprite = self.m_GameSpriteArray[i]
        if bIsStop then
            sprite:stopAllActions()
        end

        if bIsGray then
            resname = string.format("common_icon_1%d.png", self.CardType[i])
        else
            resname = string.format("common_icon_0%d.png", self.CardType[i])
        end
        frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(resname)
        sprite:initWithSpriteFrame(frame)
        sprite:setAnchorPoint(display.LEFT_TOP)
    end
end

function SHZScene:DrawLine(bIsStop)
    for i = 0, 45 do
        if m_bLineType[i] == true then
            local a = math.ceil(i / 5)
            local b = i % 5
            if b == 0 then
                for y = 5, 3, -1 do
                    local sprite = self.m_GameSpriteArray[m_cbCardLine[a][y]]
                    self:addAnimationSprite(sprite, m_cbCardLine[a][y])
                end
            elseif b == 1 then
                for y = 1, 5 do
                    local sprite = self.m_GameSpriteArray[m_cbCardLine[a][y]]
                    self:addAnimationSprite(sprite, m_cbCardLine[a][y])
                end
            elseif b == 2 then
                for y = 1, 4 do
                    local sprite = self.m_GameSpriteArray[m_cbCardLine[a][y]]
                    self:addAnimationSprite(sprite, m_cbCardLine[a][y])
                end
            elseif b == 3 then
                for y = 1, 3 do
                    local sprite = self.m_GameSpriteArray[m_cbCardLine[a][y]]
                    self:addAnimationSprite(sprite, m_cbCardLine[a][y])
                end
            elseif b == 4 then
                for y = 5, 2, -1 do
                    local sprite = self.m_GameSpriteArray[m_cbCardLine[a][y]]
                    self:addAnimationSprite(sprite, m_cbCardLine[a][y])
                end
            end
            MusicManager.playEffect(getRes("sound_res/gundong_1.mp3"))
            local sprite = self.m_GameLineSpriteArray[a]
            sprite:setVisible(true)
        end
    end
    local m_bAllHero = true
    local m_bAllArm = true;
    for x = 1, 15 do
        if self.CardType[x] < 6 then
            m_bAllArm = false
        end
        if self.CardType[x] < 3 or self.CardType[x] > 5 then
            m_bAllHero = false
        end
    end
    if m_bAllHero == true then
        if self.winScore / self.cellScore ~= 450 then
            m_bAllHero = false
        end
    end
    if m_bAllArm == true then
        if self.winScore / self.cellScore ~= 135 then
            m_bAllArm = false
        end
    end

    if m_bAllArm == true or m_bAllHero == true then
        if bIsStop then
            self:finallySprite(true, false)
        end

        for i = 1, 15 do
            local boxSprite = self.m_GameBoxSpriteArray[i]
            boxSprite:setVisible(true)
            boxSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/box_frame.plist", "game1_box_%d.png", 6, 0.1), 3))
        end
        for i = 1, 9 do
            local lineSprite = self.m_GameLineSpriteArray[i]
            lineSprite:setVisible(false)
        end
    else

        if _G.next(self.m_animationSpriteArray) ~= nil then
            self:finallySprite(bIsStop, true)
        elseif bIsStop then
            self:finallySprite(bIsStop, false)
        end

        for i = 1, 15 do
            if self.m_animationSpriteArray[i] ~= nil then
                local j = self.CardType[i] + 1
                self.m_animationSpriteArray[i]:runAction(self:createGameAnimate(playerPlist[j], playerPng[j], playerPngCount[j], 0.1))
                local boxSprite = self.m_GameBoxSpriteArray[i]
                boxSprite:setVisible(true)
                boxSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/box_frame.plist", "game1_box_%d.png", 6, 0.1), 3))
                local lightSprite = self.m_GameLightSpriteArray[i]
                lightSprite:setVisible(true)
                lightSprite:runAction(cc.Repeat:create(self:createGameAnimate("game1/itemAction/light.plist", "common_light_%02d.png", 9, 0.1), 3))
            end
        end
    end

    self.userScoreLabel:setString(tostring(self.userScore))
    self.allGetLabel:setString(tostring(self.winScore))
    if self.winScore ~= 0 then
        if MusicManager.getEffectVal() > 0 then
            cc.SimpleAudioEngine:getInstance():playEffect(getRes("sound_res/winsound.mp3"))
        end
        self:drawWin(true, m_bAllHero, m_bAllArm)
        if self.m_bFirst == 1 then
            if self.isAutoPlay then
                self.isAutoPlay = false
                self.controlIsAutoPlay = true
            end
            self.biBeiBtn:setEnabled(false)
            self.addBtn:setEnabled(false)
            self.subBtn:setEnabled(false)
            self.minBtn:setEnabled(false)
            self.maxBtn:setEnabled(false)
            self.startBtn:setEnabled(false)
            -- 进入游戏3
            self.userGame1Status = SHZ_CMD.game1_state_Free
            if self.isGame3 == false then
                self:runAction(cc.Sequence:create(cc.DelayTime:create(3.0), cc.CallFunc:create(function()
                    self.isGame3 = true
                    self.times = 0
                    self.isStopMario = false
                    self:addGame3Layer(0)
                end)))
            else
                self:drawWin(false, false, false)
                self.game1Layer:setVisible(false)
            end
        else
            self.flash:setVisible(true)
            self.flash:stopAllActions()
            self.flash:runAction(cc.RepeatForever:create(self:createGameAnimate("game1/gameAction/flash.plist", "game1_flash_%02d.png", 10, 0.1)))
            self.jianTou:setVisible(true)
            local by1 = cc.MoveBy:create(0.5, cc.p(0, -5))
            local by2 = cc.MoveBy:create(0.5, cc.p(0, 5))
            self.jianTou:runAction(cc.RepeatForever:create(cc.Sequence:create(by1, by2)))
            self.biBeiBtn:setEnabled(true)
            self.addBtn:setEnabled(true)
            self.subBtn:setEnabled(true)
            self.minBtn:setEnabled(true)
            self.maxBtn:setEnabled(true)
            self.startBtn:setEnabled(true)
            self.userGame1Status = SHZ_CMD.game1_state_Free
            if self.isAutoPlay == true then
                local seq = cc.Sequence:create(cc.DelayTime:create(5.0), cc.CallFunc:create(function()
                    self:startGame()
                end))
                seq:setTag(SHZ_CMD.Auto_Win)
                self.game1Layer:runAction(seq)
            end
        end
    else
        self.startBtn:setEnabled(true)
        self.addBtn:setEnabled(true)
        self.subBtn:setEnabled(true)
        self.minBtn:setEnabled(true)
        self.maxBtn:setEnabled(true)
        self.userGame1Status = SHZ_CMD.game1_state_Free
        if self.isAutoPlay == true then
            local seq = cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function()
                self:startGame()
            end))
            seq:setTag(SHZ_CMD.Auto_Lost)
            self.game1Layer:runAction(seq)
        end
    end
end
function SHZScene:addAnimationSprite(sprite, index)
    if self.m_animationSpriteArray[index] == nil then
        self.m_animationSpriteArray[index] = sprite
    end
end
function SHZScene:drawWin(isShow, m_bAllHero, m_bAllArm)
    self.win:setVisible(isShow)
    self.pwinScore:setVisible(isShow)
    self.allArms:setVisible(m_bAllArm)
    self.allHero:setVisible(m_bAllHero)
    if isShow then
        self.pwinScore:setString(tostring(self.winScore))
    end
end
function SHZScene:startGame()
    self.nCheckCount = 0
    if self:isDisConnect() == true then
        self:refreshGame()
    else
        table.remove(self.scorllData, 1)
        if #self.scorllData >= 1 then
            self:dealScrollData(self.scorllData[1])
            return
        end
        if self:initGame1Params() == false then
            return
        end
        if self.userScore < self.tableScore * 9 then
            PlazaManager.showTips(SubLang:word(2))
        else
            local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, SHZ_CMD.SUB_C_CARD_SCROLL, 1024)
            rpcSend:release()
            self.startBtn:setEnabled(false)
            self.addBtn:setEnabled(false)
            self.subBtn:setEnabled(false)
            self.minBtn:setEnabled(false)
            self.maxBtn:setEnabled(false)
            local seq = cc.Sequence:create(cc.DelayTime:create(8), cc.CallFunc:create(function()
                self:refreshGame()
            end))
            seq:setTag(SHZ_CMD.Connect)
            self.game1Layer:runAction(seq)
        end
    end
end

function SHZScene:initGame1Params()
    self.startBtn:setEnabled(true)
    self.addBtn:setEnabled(true)
    self.subBtn:setEnabled(true)
    self.minBtn:setEnabled(true)
    self.maxBtn:setEnabled(true)

    local nowTime = GameUtil.getSystemTime()
    if nowTime - self.lastTime < 1000 then
        return false
    end
    self.lastTime = nowTime
    self.userScore = self.userScore + self.winScore
    self.winScore = 0

    self.userScoreLabel:setString(tostring(self.userScore))
    self.allGetLabel:setString(tostring(self.winScore))
    self:stopAllItem()
    return true
end
-- 前后台切换
function SHZScene:onEnterBackground(isEnterBackground)
    if isEnterBackground == true then
        -- 游戏切换到后台
    else
        if self.game3Layer ~= nil then
            self.game3Layer:stopAllActions()
            self:refreshGame()
        end
    end
end
function SHZScene:onAcceptTrumpetContentRoll(trumpetDataStr)
    local str = trumpetDataStr
    table.insert(self.strList, str)
end
--[[function SHZScene:createImageView(png)
   local sprite = cc.Sprite:create(png)
   local function onTouchBegan(touch,event)
      local target = event:getCurrentTarget()
      local location = touch:getLocation()
      local pos = target:convertToNodeSpace(location)
      local s = target:getContentSize()
      local rect = cc.rect(0,0,s.width,s.height)
      if cc.rectContainsPoint(rect,pos)  then
         return true
      else 
         return false
      end
   end
   local listener = cc.EventListenerTouchOneByOne:create()
   listener:setSwallowTouches(true)
   listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
   sprite:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,sprite)
   return sprite
end--]]
return SHZScene
