local FISHLKScene = class("FISHLKScene", require("app.views.base.BaseGameScene"))
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
local MathAide = require "game.fishlk.src.MathAide"
local FishManager = require "game.fishlk.src.FISHManager"
local FishBulletManager = require "game.fishlk.src.BulletManager"
local AddAndDownGun = require "game.fishlk.src.AddAndDownGun"
local FishArms = require "game.fishlk.src.FISHArms"
local ChipManager = require "game.fishlk.src.ChipManager"
local FishUI = require "game.fishlk.src.FishUI"
local NoticeFish = require "game.fishlk.src.FISHLKNoticeFish"
local FishMessage = require "game.fishlk.src.FISHLKMessage"
local Fish = require "game.fishlk.src.FISHLKObj"
local CBingo = require "game.fishlk.src.CBingo"
local CBigWheel = require "game.fishlk.src.CBigWheel"
local FishSettings = require "game.fishlk.src.FishSettings"
local FishHelp = require "game.fishlk.src.FishHelp"
local GameFrame = require "game.fishlk.src.FISHBodyFrame"
local function getRes(path)
    return "game/fishlk/res/" .. path
end

local TAG = {
    FISH_SCORE_BOX = 100, -- 鱼币Box
    FISH_SCORE = 101, -- 鱼币
    FISH_ARMS = 102, -- 武器
    FISH_MULTIPLE_BOX = 103, -- 倍数Box
    FISH_MULTIPLE = 104, -- 倍数
    OPEN_MENU_HANDLE = 105, -- 旋转把手
    DOWN_BG = 106, -- 下方菜单组
    RIGHT_BG = 107, -- 右边菜单组
    USER_SCORE_BG = 108, -- 用户分数背景
    USER_SCORE = 109, -- 用户分数
    FISH_CHIP_MANAGER = 110, -- 筹码
    BINGO = 111, -- 彩金盘
    CARD_ION = 112, -- 斧头
    LOCKFISHICON = 113, -- 锁定鱼Icon
    BIGWHEEL = 114, -- 大转盘
    NOTICE = 115, -- 大鱼提示
    ADD_DOWN_GUN = 116, -- 加减炮
    WAIT_JOIN = 117 -- 等待加入标志
}

function FISHLKScene:onCreate()
    cc.exports.SubLang = require("game.fishlk.src.FISHLKLang").new()
    FISHLKScene.super.onCreate(self)
    -- 场景尺寸
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    -- 偏移向量
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    -- 场景2纵向时间轴
    self.m_SceneFish = 0.0
    -- 发射子弹点
    self.m_touchPos = cc.p(self.visibleSize.width / 2, self.visibleSize.height / 2)
    -- 用户炮台点
    self.m_userPos = cc.p(0, 0)
    -- 上次发射时间
    self.m_upFireTime = MathAide.GetBeiJingTime()
    self.m_UsetItemFishScore = {}
    self.m_UsetItemFishScore.fish_score = {}
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        -- 用户渔分
        self.m_UsetItemFishScore.fish_score[i] = 0
    end
    -- 是否退出游戏
    self.isExitGame = false
    -- 携带分数
    self.me_user_score = 0
    -- 鱼消息队列
    self.m_ListFishMsg = {}
    -- 鱼路径队列
    self.m_listFishTrace = {}
    -- 是否定屏
    self.m_stopCreateFish = false
    -- 场景切换中
    self.m_bSwitchScene = false
    -- 是否能量炮
    self.m_bullet_ion = false
    -- 可否开火
    self.m_isFire = false
    -- 开火时间间隔
    self.m_fire_time = 1.0 / 5.0 * 1000
    -- 自动开炮时时间
    self.ftime_fire = 0.0
    -- 游戏的配置
    self:initGameConfig()
    -- 是否重新绘制场景
    self.isRefresh = false
    -- 鱼管理
    self.m_fishMgr = FishManager.new(self)
    self.m_fishMgr.m_FishLock = {}
    -- 刚体数据
    self._dataModel = GameFrame.new(self)
    -- 子弹管理
    self.m_bulletMgr = FishBulletManager.new(self)
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        table.insert(self.m_fishMgr.m_FishLock, nil)
    end
    -- 自动开炮
    self.m_automaticFire = false
    -- 鱼路径调度
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.table_scheduleID = {}
    local scheduleID = nil
    scheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.FishTraceThread), 0, false)
    table.insert(self.table_scheduleID, scheduleID)
    self:init()
    self:startGame()
end
-- 初始化
function FISHLKScene:init()
    local sprite1 = cc.Sprite:create(getRes("tollgate/1.jpg"))
    sprite1:setPosition(cc.p(self.visibleSize.width / 4, self.visibleSize.height / 2))
    sprite1:setScaleX(self.visibleSize.width / 2 / sprite1:getContentSize().width)
    sprite1:setScaleY(self.visibleSize.height / sprite1:getContentSize().height)
    sprite1:setAnchorPoint(display.CENTER)
    sprite1:setZOrder(999)
    sprite1:addTo(self)
    local sprite2 = cc.Sprite:create(getRes("tollgate/2.jpg"))
    sprite2:setPosition(cc.p(self.visibleSize.width / 4 * 3, self.visibleSize.height / 2))
    sprite2:setScaleX(self.visibleSize.width / 2 / sprite2:getContentSize().width)
    sprite2:setScaleY(self.visibleSize.height / sprite2:getContentSize().height)
    sprite2:setAnchorPoint(display.CENTER)
    sprite2:setZOrder(999)
    sprite2:addTo(self)
    sprite1:runAction(cc.Sequence:create(cc.MoveBy:create(2, cc.p(-self.visibleSize.width / 2, 0)), cc.CallFunc:create(function(args)
        args:removeFromParent()
    end)))
    sprite2:runAction(cc.Sequence:create(cc.MoveBy:create(2, cc.p(self.visibleSize.width / 2, 0)), cc.CallFunc:create(function(args)
        args:removeFromParent()
    end)))

    -- 炮台层
    self.m_ArmsLayer = cc.Layer:create()
    self.m_ArmsLayer:ignoreAnchorPointForPosition(false)
    self.m_ArmsLayer:setAnchorPoint(display.CENTER)
    self.m_ArmsLayer:setContentSize(self.visibleSize)
    self.m_ArmsLayer:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_ArmsLayer:setZOrder(99)
    self.m_ArmsLayer:addTo(self)
    -- 鱼层
    self.m_fishLayer = cc.Layer:create()
    self.m_fishLayer:ignoreAnchorPointForPosition(false)
    self.m_fishLayer:setAnchorPoint(display.CENTER)
    self.m_fishLayer:setContentSize(self.visibleSize)
    self.m_fishLayer:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_fishLayer:setZOrder(3)
    self.m_fishLayer:addTo(self)
    if globalUserInfo.wChairID < 4 then
        self.m_fishLayer:setScale(-1)
    end
    -- 子弹层
    self.m_bulletLayer = cc.Layer:create()
    self.m_bulletLayer:ignoreAnchorPointForPosition(false)
    self.m_bulletLayer:setAnchorPoint(display.CENTER)
    self.m_bulletLayer:setContentSize(self.visibleSize)
    self.m_bulletLayer:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_bulletLayer:setZOrder(4)
    self.m_bulletLayer:addTo(self)

    -- 渔网层
    self.m_fishNetLayer = cc.Layer:create()
    self.m_fishNetLayer:ignoreAnchorPointForPosition(false)
    self.m_fishNetLayer:setAnchorPoint(display.CENTER)
    self.m_fishNetLayer:setContentSize(self.visibleSize)
    self.m_fishNetLayer:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_fishNetLayer:setZOrder(5)
    self.m_fishNetLayer:addTo(self)
    if globalUserInfo.wChairID < 4 then
        self.m_fishNetLayer:setScale(-1)
    end

    -- UI层
    self.m_UILayer = cc.Layer:create()
    self.m_UILayer:ignoreAnchorPointForPosition(false)
    self.m_UILayer:setAnchorPoint(display.CENTER)
    self.m_UILayer:setContentSize(self.visibleSize)
    self.m_UILayer:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_UILayer:setZOrder(99)
    self.m_UILayer:addTo(self)

    -- 背景
    self.m_pbg = cc.Sprite:create(getRes("tollgate/bg01.jpg"))
    self.m_pbg:setScaleX(self.visibleSize.width / self.m_pbg:getContentSize().width)
    self.m_pbg:setScaleY(self.visibleSize.height / self.m_pbg:getContentSize().height)
    self.m_pbg:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    self.m_pbg:setZOrder(2)
    self.m_pbg:addTo(self)
    -- 流水
    local animation = cc.Animation:create()
    for i = 1, 16 do
        local strWater = string.format(getRes("tollgate/water/water%d.png"), i)
        local waterTexture = cc.TextureCache:getInstance():addImage(strWater)
        local frame = cc.SpriteFrame:createWithTexture(waterTexture, cc.rect(0, 0, waterTexture:getContentSize().width, waterTexture:getContentSize().height))
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(0.1)
    local animate = cc.Animate:create(animation)
    local pWater = cc.Sprite:create(getRes("tollgate/water/water1.png"))
    pWater:setScaleX(self.visibleSize.width / pWater:getContentSize().width)
    pWater:setScaleY(self.visibleSize.height / pWater:getContentSize().height)
    pWater:setPosition(cc.p(self.origin.x + self.visibleSize.width / 2, self.origin.y + self.visibleSize.height / 2))
    pWater:setZOrder(2)
    pWater:addTo(self)
    pWater:runAction(cc.RepeatForever:create(animate))
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        -- 武器
        local pboard = cc.Node:create()
        pboard:setAnchorPoint(display.CENTER_BOTTOM)

        i = self:ChangeViewChairID(i)

        local pos = {}
        if i == 1 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 10 * 3, self.m_ArmsLayer:getContentSize().height)
        elseif i == 2 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 2, self.m_ArmsLayer:getContentSize().height)
        elseif i == 3 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 10 * 7, self.m_ArmsLayer:getContentSize().height)
        elseif i == 4 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width, self.m_ArmsLayer:getContentSize().height / 2)
        elseif i == 5 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 10 * 7, 0)
        elseif i == 6 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 2, 0)
        elseif i == 7 then
            pos = cc.p(self.m_ArmsLayer:getContentSize().width / 10 * 3, 0)
        elseif i == 8 then
            pos = cc.p(0, self.m_ArmsLayer:getContentSize().height / 2)
        end
        local angle = 0.0
        if i >= 1 and i <= 3 then
            angle = 180
        elseif i == 4 then
            angle = 270
        elseif i == 8 then
            angle = 90
        end

        -- 等待加入
        local offset = -120
        if i < 4 then
            offset = -20
        end
        local fadeout = cc.FadeOut:create(3.0)
        local pWaitJoin = cc.Sprite:createWithSpriteFrameName("wait_join.png")
        pWaitJoin:setPosition(cc.pSub(pos, cc.p(0, pWaitJoin:getContentSize().height + offset)))
        self.m_ArmsLayer:addChild(pWaitJoin)
        if math.mod(i, 2) == 0 then
            pWaitJoin:setVisible(false)
        end
        pWaitJoin:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeout, fadeout:reverse())))
        pWaitJoin:setZOrder(0)
        pWaitJoin:setTag(i + 50)

        pboard:setContentSize(cc.size(146, 66))
        pboard:setRotation(angle)
        pboard:setPosition(pos)
        pboard:setTag(i + 10)
        pboard:setZOrder(0)
        pboard:setScale(0.8)
        self.m_ArmsLayer:addChild(pboard)

        -- 加减炮
        local pAddAndDownGunLayer = AddAndDownGun.new(self, i - 1)
        pAddAndDownGunLayer:setContentSize(pboard:getContentSize())
        pAddAndDownGunLayer:setPosition(display.LEFT_BOTTOM)
        pboard:addChild(pAddAndDownGunLayer)
        pAddAndDownGunLayer:setTag(TAG.ADD_DOWN_GUN)
        pAddAndDownGunLayer:hideAddAndDownGun()

        -- 鱼币框
        local pScore_box = cc.Sprite:createWithSpriteFrameName("fishGodBG.png")
        pScore_box:setAnchorPoint(display.LEFT_CENTER)
        pScore_box:setScaleY(1.5)
        pScore_box:setScaleX(1.3)
        if i == 7 or i == 3 then
            pScore_box:setPosition(cc.p(pboard:getContentSize().width - 575, pScore_box:getContentSize().height / 2))
        else
            pScore_box:setPosition(cc.p(pboard:getContentSize().width + 80, pScore_box:getContentSize().height / 2))
        end

        pboard:addChild(pScore_box)
        pScore_box:setZOrder(1)
        pScore_box:setTag(TAG.FISH_SCORE_BOX)

        local pScore = cc.LabelAtlas:create("0", getRes("FishScoreYellow.png"), 18, 25, string.byte("0"))
        pScore:setAnchorPoint(display.LEFT_CENTER)
        pScore:setPosition(cc.p(50, pScore_box:getContentSize().height / 2))
        pScore_box:addChild(pScore)
        pScore:setString("0")
        pScore:setTag(TAG.FISH_SCORE)

        -- 武器
        if self.m_gameConfig.min_bullet_multiple == nil then
            self.m_gameConfig.min_bullet_multiple = 10000
            self.m_gameConfig.max_bullet_multiple = 99000
        end
        local res_pathArms = {"pt1_%d.png", "pt1_%d.png", "pt2_%d.png", "pt2_%d.png", "pt3_%d.png", "pt3_%d.png", "PT4_%d.png", "PT4_%d.png"}
        local pArms = FishArms.new(string.format(res_pathArms[i], 5))
        pArms:SetArmsFile(i)
        pArms:setAnchorPoint(cc.p(0.5, 0.2))
        pArms:setPosition(cc.p(pboard:getContentSize().width / 2, pboard:getContentSize().height / 2))
        pboard:addChild(pArms)
        pArms:setZOrder(2)
        pArms:setTag(TAG.FISH_ARMS)

        -- 倍数Box
        local pSeat = cc.Sprite:createWithSpriteFrameName("button.png")
        pSeat:setAnchorPoint(display.CENTER_BOTTOM)
        pSeat:setPosition(cc.p(pboard:getContentSize().width / 2, 0))
        pboard:addChild(pSeat)
        pSeat:setZOrder(3)
        pSeat:setTag(TAG.FISH_MULTIPLE_BOX)

        -- 倍数
        local pMultiple = cc.LabelAtlas:create("0", getRes("FishScoreWhite.png"), 26, 37, string.byte("0"))
        pMultiple:setAnchorPoint(display.CENTER)
        pMultiple:setPosition(cc.p(pSeat:getContentSize().width / 2, pSeat:getContentSize().height / 2))
        pSeat:addChild(pMultiple)
        local szBulletMultiple = string.format("%d", self.m_gameConfig.min_bullet_multiple)
        pMultiple:setString(szBulletMultiple)
        pMultiple:setTag(TAG.FISH_MULTIPLE)

        -- 筹码管理
        --[[local fcm = ChipManager.new(self)
		fcm:setAnchorPoint(display.LEFT_BOTTOM)
		fcm:setPosition(display.LEFT_BOTTOM)
		pboard:addChild(fcm)
		fcm:setTag(TAG.FISH_CHIP_MANAGER)--]]

        -- 能量炮&斧头
        local pCard_ion = cc.Sprite:createWithSpriteFrameName("card_ion.png")
        pCard_ion:setPosition(cc.p(pboard:getContentSize().width / 2, pboard:getContentSize().height + pCard_ion:getContentSize().height / 2))
        pboard:addChild(pCard_ion)
        pCard_ion:setTag(TAG.CARD_ION)
        pCard_ion:setZOrder(98)
        pCard_ion:setVisible(false)

        local moveto1 = cc.MoveTo:create(0.6, ccp(pCard_ion:getPositionX() + 5, pCard_ion:getPositionY() + 5))
        local moveto2 = cc.MoveTo:create(0.6, ccp(pCard_ion:getPositionX() + 5, pCard_ion:getPositionY() - 5))
        local moveto3 = cc.MoveTo:create(0.6, ccp(pCard_ion:getPositionX() - 5, pCard_ion:getPositionY() - 5))
        local moveto4 = cc.MoveTo:create(0.6, ccp(pCard_ion:getPositionX() - 5, pCard_ion:getPositionY() + 5))
        local moveto5 = cc.MoveTo:create(0.6, ccp(pCard_ion:getPositionX() + 5, pCard_ion:getPositionY() + 5))
        local seq = cc.Sequence:create(moveto1, moveto2, moveto3, moveto4, moveto5)
        local card_ion_RepeatForever = cc.RepeatForever:create(seq)
        pCard_ion:runAction(card_ion_RepeatForever)

        -- 锁定鱼icon
        local pLockFishIcon = cc.Sprite:createWithSpriteFrameName("lock_flag.png")
        pLockFishIcon:setPosition(cc.p(pboard:getContentSize().width + 30, pboard:getContentSize().height + pLockFishIcon:getContentSize().height / 2))
        pboard:addChild(pLockFishIcon)
        pLockFishIcon:setZOrder(98)
        pLockFishIcon:setTag(TAG.LOCKFISHICON)
        pLockFishIcon:setVisible(false)

        --[[local moveto11 = cc.MoveTo:create(0.6,ccp(pLockFishIcon:getPositionX() + 5, pLockFishIcon:getPositionY() + 5))
        local moveto22 = cc.MoveTo:create(0.6,ccp(pLockFishIcon:getPositionX() + 5, pLockFishIcon:getPositionY() - 5))
        local moveto33 = cc.MoveTo:create(0.6,ccp(pLockFishIcon:getPositionX() - 5, pLockFishIcon:getPositionY() - 5))
        local moveto44 = cc.MoveTo:create(0.6,ccp(pLockFishIcon:getPositionX() - 5, pLockFishIcon:getPositionY() + 5))
        local moveto55 = cc.MoveTo:create(0.6,ccp(pLockFishIcon:getPositionX() + 5, pLockFishIcon:getPositionY() + 5))
        local seq1 = cc.Sequence:create(moveto11,moveto22,moveto33,moveto44,moveto55)
		local lockFishIcon_RepeatForever = cc.RepeatForever:create(seq1)
		pLockFishIcon:runAction(lockFishIcon_RepeatForever)--]]
    end
    -- 分数背景
    local pScoreBG = cc.Sprite:createWithSpriteFrameName("user_score.png")
    pScoreBG:ignoreAnchorPointForPosition(false)
    pScoreBG:setAnchorPoint(display.LEFT_CENTER)
    pScoreBG:setPosition(cc.p(0, self.m_UILayer:getContentSize().height - pScoreBG:getContentSize().height * 5))
    self.m_UILayer:addChild(pScoreBG)
    pScoreBG:setTag(TAG.USER_SCORE_BG)
    pScoreBG:setVisible(false)

    local pUserScore = cc.LabelAtlas:create("0", getRes("white_num.png"), 10, 12, string.byte("0"))
    pUserScore:setAnchorPoint(display.LEFT_CENTER)
    pUserScore:setPosition(cc.p(25, pScoreBG:getContentSize().height / 2))
    pScoreBG:addChild(pUserScore)
    pUserScore:setTag(TAG.USER_SCORE)
    pUserScore:setString("0")
    pUserScore:setVisible(false)

    -- 设置
    self.m_Settings = FishSettings.new(self.m_UILayer)

    self.m_fishUI = FishUI.new(self)
    self.m_fishUI:setContentSize(self.m_UILayer:getContentSize())
    self.m_fishUI:ignoreAnchorPointForPosition(false)
    self.m_fishUI:setAnchorPoint(display.CENTER)
    self.m_fishUI:setPosition(cc.p(self.m_UILayer:getContentSize().width / 2, self.m_UILayer:getContentSize().height / 2))
    self.m_fishUI:setZOrder(999)
    self.m_UILayer:addChild(self.m_fishUI)

    -- 帮助
    self.m_Help = FishHelp.new(self.m_UILayer)

    -- 锁定气泡
    self.m_fishLockLine = {}
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        local temp_fishLockLine = {}
        for x = 1, 39 do
            local pFishLockLine = cc.Sprite:createWithSpriteFrameName("lock_line.png")
            pFishLockLine:setZOrder(99)
            self.m_ArmsLayer:addChild(pFishLockLine)
            pFishLockLine:setVisible(false)
            table.insert(temp_fishLockLine, pFishLockLine)
        end
        local szstr = string.format("lock_flag.png")
        local pFishLockLineNumber = cc.Sprite:createWithSpriteFrameName(szstr)
        self.m_ArmsLayer:addChild(pFishLockLineNumber)
        pFishLockLineNumber:setZOrder(99)
        pFishLockLineNumber:setVisible(false)
        table.insert(temp_fishLockLine, pFishLockLineNumber)
        table.insert(self.m_fishLockLine, temp_fishLockLine)
    end
    self.m_cursor_icon = cc.Sprite:createWithSpriteFrameName("lock_flag.png")
    self.m_cursor_icon:setPosition(cc.p(self.m_ArmsLayer:getContentSize().width / 2, self.m_ArmsLayer:getContentSize().height / 2))
    self.m_ArmsLayer:addChild(self.m_cursor_icon)
    self.m_cursor_icon:setVisible(false)
end
function FISHLKScene:callback(dt)
    self:UpDateCreateFish()
    -- self.m_bulletMgr:update(dt)
    self:updateLockFish()
    -- 是否挂机
    if self.m_automaticFire then -- or (self.m_fishUI.isLock and self.m_fishMgr.m_FishLock[globalUserInfo.wChairID+1]~=nil) then
        self.ftime_fire = self.ftime_fire + dt
        if self.ftime_fire >= 1.0 / 5.0 then
            self.ftime_fire = 0.0
            self:sendFireSocket()
        end
    end

end
function FISHLKScene:startGame()
    local szSocre = string.format("%d", self.me_user_score)
    -- 设置分数
    self:FindUserScore():setString(szSocre)
    if self.me_user_score > 0 then
        self:UpScore()
    end
    -- 状态设置
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        local szFishScore = self.m_UsetItemFishScore.fish_score[i]
        self:FindFishScore(i - 1):setString(szFishScore)
        if i == globalUserInfo.wChairID + 1 then
            local userScore = self.m_UsetItemFishScore.fish_score[i]
            -- 子弹倍数
            local bulletMultiple = tonumber(self:FindMultiple(globalUserInfo.wChairID):getString())
            if userScore >= bulletMultiple then
                self.m_isFire = true
            end
        end
    end
    self:bindTouch()
    -- 开启刷新
    local scheduleID = nil
    scheduleID = self.scheduler:scheduleScriptFunc(handler(self, self.callback), 0, false)
    table.insert(self.table_scheduleID, scheduleID)
    -- 加载背景音乐
    MusicManager.stopBGM()
    MusicManager.playBGM(getRes("music/bgm1.mp3"))
    -- 提示自己位置
    local viewID = self:ChangeViewChairID(globalUserInfo.wChairID + 1)
    local pboard = self.m_ArmsLayer:getChildByTag(viewID + 10)
    if pboard == nil then
        return
    end

    self.m_myPosHint = cc.Layer:create()
    self.m_myPosHint:setAnchorPoint(display.CENTER_BOTTOM)
    self.m_myPosHint:setPosition(cc.p(pboard:getContentSize().width / 2, pboard:getContentSize().height))
    self.m_myPosHint:setZOrder(99)
    pboard:addChild(self.m_myPosHint)

    local pYangGuang = cc.Sprite:createWithSpriteFrameName("yangguang.png")
    pYangGuang:setPosition(cc.p(0, pYangGuang:getContentSize().height / 2 - 80))
    self.m_myPosHint:addChild(pYangGuang)
    local rotateto = cc.RotateTo:create(5, 360 * 3)
    local repeatForever = cc.RepeatForever:create(rotateto)
    pYangGuang:runAction(repeatForever)

    local pwz_tx = cc.Sprite:createWithSpriteFrameName("my_weizhi.png")
    pwz_tx:setPosition(cc.p(pYangGuang:getPosition()))
    pwz_tx:setZOrder(1)
    self.m_myPosHint:addChild(pwz_tx)

    -- 用户武器点
    self.m_userPos = self:FindArms(globalUserInfo.wChairID):getParent():convertToWorldSpace(cc.p(self:FindArms(globalUserInfo.wChairID):getPosition()))
    -- 加减炮控制
    self:FindAddAndDownGun(globalUserInfo.wChairID):showAddAndDownGun()

    for i = 1, Fishlk_CMD.GamePlayer_4 do
        local gameUser = self:getTableUser(i)
        if gameUser == nil then
            self:FindGunObj(i - 1):setVisible(false)
            if math.mod(i, 2) == 1 then
                self:FindWaitJoin(i - 1):setVisible(true)
            end
        end
    end
end

-- 是否点击到鱼
function FISHLKScene:isContainsFish(sprite, point)
    local fishPos = cc.p(sprite:getPosition());
    local fishSize = sprite:getContentSize()
    local rotation = sprite:getRotation()
    local x = (point.x - fishPos.x) * math.cos(math.rad(rotation)) - (point.y - fishPos.y) * math.sin(math.rad(rotation)) + fishPos.x
    local y = (point.x - fishPos.x) * math.sin(math.rad(rotation)) + (point.y - fishPos.y) * math.cos(math.rad(rotation)) + fishPos.y
    -- local point = fish:convertToNodeSpace(bullet_to_worldpoint)
    if (x <= fishPos.x + fishSize.width * 0.707 and x >= fishPos.x - fishSize.width * 0.707) and (y <= fishPos.y + fishSize.height * 0.707 and y >= fishPos.y - fishSize.height * 0.707) then
        return true
    end
    return false
end
-- 添加监听事件
function FISHLKScene:bindTouch()
    local function onTouchBegan(touch, event)
        local temp_touchPos = cc.pSub(self:convertToWorldSpace(touch:getLocation()), self.origin)
        local touchFish = nil
        -- for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
        if self.m_fishUI.isLock == true then
            local fishTable = self.m_fishMgr:GetFishList()
            for i = #self.m_fishMgr:GetFishList(), 1, -1 do
                local point = fishTable[i]:getParent():convertToNodeSpace(temp_touchPos)
                if self:isContainsFish(fishTable[i], point) == true then
                    if touchFish ~= nil then
                        if touchFish.m_fishTrace.fish_kind < fishTable[i].m_fishTrace.fish_kind then
                            touchFish = fishTable[i]
                        end
                    else
                        touchFish = fishTable[i]
                    end
                end
            end
        end
        if touchFish ~= nil then
            self.m_fishUI:SetLockFish(touchFish, globalUserInfo.wChairID)
        end
        -- 发射位置点
        self.m_touchPos = cc.pSub(self:convertToWorldSpace(touch:getLocation()), self.origin)
        if MathAide.GetBeiJingTime() - self.m_upFireTime > self.m_fire_time then
            self:sendFireSocket()
            self.m_cursor_icon:setPosition(cc.p(self.m_touchPos.x, self.m_touchPos.y))
        end
        return true
    end
    local function onTouchMoved(touch, event)
        self.m_touchPos = cc.pSub(self:convertToWorldSpace(touch:getLocation()), self.origin)
        self.m_cursor_icon:setPosition(self.m_touchPos)
        if MathAide.GetBeiJingTime() - self.m_upFireTime > self.m_fire_time then
            self:sendFireSocket()
            self.m_cursor_icon:setPosition(cc.p(self.m_touchPos.x, self.m_touchPos.y))
        end
    end

    local function onTouchEnded(touch, event)
    end
    local function onTouchCancelled(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    listener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.m_fishLayer)
end
-- 加密
function FISHLKScene:GetMd5Info(fish_id, bullet_id, dwCurrentTime)
    local gameUserID = globalUserInfo.dwUserID
    local game_id = string.format("%d%d%d%d", gameUserID, fish_id, bullet_id, dwCurrentTime)
    -- 加密数据
    local szServerName = game.md5(game_id)
    -- 根据游戏ID交换一个字符
    for i = 1, 32 do
        if i == math.mod(gameUserID, 10) + 1 then
            local temp1 = string.sub(szServerName, i, i)
            local temp2 = string.sub(szServerName, i * 2 + 4, i * 2 + 4)
            local str1 = string.sub(szServerName, 1, i - 1)
            local str2 = string.sub(szServerName, i + 1, i * 2 + 3)
            local str3 = string.sub(szServerName, i * 2 + 5, -1)
            szServerName = str1 .. temp2 .. str2 .. temp1 .. str3
            break
        end
    end
    szServerName = string.upper(szServerName)
    --[[for i = 1, 32 do
        if string.byte(szServerName,i,i)>=string.byte("a") and string.byte(szServerName,i,i) <= string.byte("z") then
            local temp1 = string.char(bit.band( string.byte(szServerName,i,i),0x5F))
            local str1 = string.sub(szServerName,1,i-1)
            local str2 = string.sub(szServerName,i+1,-1)
            szServerName = str1..temp1..str2
        end
    end --]]
    return szServerName
end
-- 加密
function FISHLKScene:GetMd5Info_1(dwCurrentTime)
    local gameUserID = globalUserInfo.dwUserID
    local game_id = string.format("~2@vkl-%d-%d-&haA", gameUserID, dwCurrentTime)
    -- 加密数据
    local szServerName = game.md5(game_id)
    -- 根据游戏ID交换一个字符
    for i = 1, 32 do
        if i == math.mod(gameUserID, 10) + 1 then
            local temp1 = string.sub(szServerName, i, i)
            local temp2 = string.sub(szServerName, i * 2 + 4, i * 2 + 4)
            local str1 = string.sub(szServerName, 1, i - 1)
            local str2 = string.sub(szServerName, i + 1, i * 2 + 3)
            local str3 = string.sub(szServerName, i * 2 + 5, -1)
            szServerName = str1 .. temp2 .. str2 .. temp1 .. str3
            break
        end
    end

    szServerName = string.upper(szServerName)
    --[[for i = 1, 32 do
        if string.byte(szServerName,i,i)>=string.byte("a") and string.byte(szServerName,i,i) <= string.byte("z") then
            local temp1 = string.char(bit.band( string.byte(szServerName,i,i),0x5F))
            local str1 = string.sub(szServerName,1,i-1)
            local str2 = string.sub(szServerName,i+1,-1)
            szServerName = str1..temp1..str2
        end
    end --]]
    return szServerName
end
-- 计算路径
function FISHLKScene:FishTraceThread()
    local cmd = {}
    cmd.fishTrace = {}
    cmd.fishTrace.init_count = 0
    if self.m_ListFishMsg ~= nil and #self.m_ListFishMsg > 0 then
        cmd = table.remove(self.m_ListFishMsg, 1)
    else
        return
    end
    if cmd.fishTrace.init_count > 0 then
        -- 坐标系数转换
        for i = 1, cmd.fishTrace.init_count do
            -- 屏幕坐标转相对设备坐标
            -- windows坐标转OPGL坐标
            cmd.fishTrace.init_pos[i].y = Fishlk_CMD.kResolutionHeight - cmd.fishTrace.init_pos[i].y
            cmd.fishTrace.init_pos[i].x = cmd.fishTrace.init_pos[i].x / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
            cmd.fishTrace.init_pos[i].y = cmd.fishTrace.init_pos[i].y / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
        end
        -- 鱼路径点
        -- local trace_vector={}
        -- 贝塞尔
        --[[if cmd.fishTrace.trace_type == Fishlk_CMD.TraceType.TRACE_BEZIER then
            local x={}
            local y={}
            for i = 1, cmd.fishTrace.init_count do
                x[i] = cmd.fishTrace.init_pos[i].x
                y[i] = cmd.fishTrace.init_pos[i].y
            end
            local fDistance = MathAide.CalcDistance(x[1],y[1],x[2],y[2]) + MathAide.CalcDistance(x[2], y[2], x[3], y[3])
            local fSpeed = fDistance * 0.0007/1.2 * cmd.fSpeed
            trace_vector = MathAide.BuildBezier(x,y,cmd.fishTrace.init_count,trace_vector,fSpeed)
        end

        --直线
		if cmd.fishTrace.trace_type == Fishlk_CMD.TraceType.TRACE_LINEAR then
			local x={}
			local y={}
			for i = 1,cmd.fishTrace.init_count do
				x[i] = cmd.fishTrace.init_pos[i].x
				y[i] = cmd.fishTrace.init_pos[i].y
			end

			local fDistance = MathAide.CalcDistance(x[1], y[1], x[2], y[2])
			local fSpeed = fDistance * 0.0007 * cmd.fSpeed

			trace_vector = MathAide.BuildLinear(x, y, cmd.fishTrace.init_count, trace_vector, fSpeed)
		end--]]
        local trace_vector = {}
        for i = 1, cmd.fishTrace.init_count do
            local temp_vector = {}
            temp_vector.x = cmd.fishTrace.init_pos[i].x
            temp_vector.y = cmd.fishTrace.init_pos[i].y
            table.insert(trace_vector, temp_vector)
        end
        trace_vector.fSpeed = cmd.fSpeed
        local fishTraceStruct = {}
        fishTraceStruct.fishTrace = cmd.fishTrace
        fishTraceStruct.fishPos = trace_vector
        table.insert(self.m_listFishTrace, fishTraceStruct)
    end
end

-- 获取武器图片
function FISHLKScene:GetArmFileName(userBulletMultiple, isBullet_ion)
    local filename = nil
    if (tonumber(userBulletMultiple) < 100) then
        if isBullet_ion == false then
            filename = 1
        else
            filename = 5
        end
    elseif (tonumber(userBulletMultiple) >= 100 and tonumber(userBulletMultiple) < 1000) then
        if (isBullet_ion == false) then
            filename = 2
        else
            filename = 6
        end
    elseif (tonumber(userBulletMultiple) >= 1000 and tonumber(userBulletMultiple) < 5000) then
        if (isBullet_ion == false) then
            filename = 3
        else
            filename = 7
        end
    else
        if (isBullet_ion == false) then
            filename = 4
        else
            filename = 8
        end
    end
    return filename
end

-- 更新武器
function FISHLKScene:UpDateArms()
    self.m_uodate_arms = true
    local pMuitiple = self:FindMultiple(globalUserInfo.wChairID)
    -- 当前倍数
    local userBulletMultiple = tonumber(pMuitiple:getString())
    local filename = self:GetArmFileName(userBulletMultiple, self.m_bullet_ion)
    local pArms = self:FindArms(globalUserInfo.wChairID)
    if pArms:GetArmsFile() ~= filename then
        pArms:SetArmsFile(string.format("Ani_connon%d_1.png", filename), filename)
        if self.m_bullet_ion then
            MusicManager.playEffect(getRes("music/ion_get.mp3"))
        end
    end
    self.m_uodate_arms = false
end

-- 切换用户武器
function FISHLKScene:ChangeArms(wChairID, bullet_multiple, bullet_ion)
    local filename = self:GetArmFileName(bullet_multiple, bullet_ion)
    local pArms = self:FindArms(wChairID)
    if pArms:GetArmsFile() ~= filename then
        pArms:SetArmsFile(string.format("Ani_connon%d_1.png", filename), filename)
        if bullet_ion then
            MusicManager.playEffect(getRes("music/ion_get.mp3"))
        end
    end
end

-- 分数对象
function FISHLKScene:FindUserScore()
    return self.m_UILayer:getChildByTag(TAG.USER_SCORE_BG):getChildByTag(TAG.USER_SCORE)
end
-- 转换视角
function FISHLKScene:ChangeViewChairID(wChairID)
    local viewChairID = wChairID
    if globalUserInfo.wChairID < 4 then
        if viewChairID < 5 then
            viewChairID = viewChairID + 4
        else
            viewChairID = viewChairID - 4
        end
    end
    return viewChairID
end

function FISHLKScene:FindWaitJoin(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 50)
end
function FISHLKScene:FindGunObj(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10)
end
-- 鱼币对象分数
function FISHLKScene:FindFishScore(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.FISH_SCORE_BOX):getChildByTag(TAG.FISH_SCORE)
end

-- 子弹倍数对象
function FISHLKScene:FindMultiple(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.FISH_MULTIPLE_BOX):getChildByTag(TAG.FISH_MULTIPLE)
end

-- 武器对象
function FISHLKScene:FindArms(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.FISH_ARMS)
end

-- 筹码管理对象
function FISHLKScene:FindChipMgr(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.FISH_CHIP_MANAGER)
end

-- 粒子炮提示对象
function FISHLKScene:FindCardIon(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.CARD_ION)
end

-- 锁定鱼icon
function FISHLKScene:FindLockFishIcon(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.LOCKFISHICON)
end

function FISHLKScene:FindAddAndDownGun(wChairID)
    if wChairID < 0 or wChairID > 7 then
        return nil
    end
    wChairID = wChairID + 1
    wChairID = self:ChangeViewChairID(wChairID)
    return self.m_ArmsLayer:getChildByTag(wChairID + 10):getChildByTag(TAG.ADD_DOWN_GUN)
end

-- 创建鱼
function FISHLKScene:UpDateCreateFish()
    -- 停止创建
    if self.m_stopCreateFish == true then
        return
    end
    local cmd = {}
    if #self.m_listFishTrace <= 0 then
        return
    end
    cmd = self.m_listFishTrace[1]
    table.remove(self.m_listFishTrace, 1)
    if #cmd.fishPos <= 0 then
        return
    end
    self.m_fishMgr:CreateFish(cmd)

    -- 大鱼提示
    if cmd.fishTrace.fish_kind == nil then
        return
    end
    if cmd.fishTrace.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and cmd.fishTrace.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_LK then
        local noticeName
        if cmd.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_18 then -- 鲨鱼
            noticeName = "notice_Shark.png"
        elseif cmd.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_19 then -- 龙
            noticeName = "notice_dragon.png"
        elseif cmd.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_20 then -- 企鹅
            noticeName = "notice_Penguin.png"
        elseif cmd.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_LK then -- 李逵
            noticeName = "notice_lk.png"
        end
        local pnts = self.m_ArmsLayer:getChildByTag(TAG.NOTICE)
        if pnts then
            pnts:removeFromParent()
        end
        local pNotice = NoticeFish.new(noticeName)
        pNotice:setPosition(cc.p(self.visibleSize.width / 2, self.visibleSize.height / 2))
        pNotice:setZOrder(99)
        pNotice:setTag(TAG.NOTICE)
        self.m_ArmsLayer:addChild(pNotice)
    end
end

-- 刷新锁定气泡
function FISHLKScene:updateLockFish()
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        if self.m_fishMgr.m_FishLock[i] ~= nil then
            -- 用户点
            local pArm = self:FindArms(i - 1)
            local userPos = cc.pSub(pArm:getParent():convertToWorldSpace(cc.p(pArm:getPosition())), self.origin)
            -- 目标位置
            local fishLockPos = {}

            if globalUserInfo.wChairID < 4 then
                fishLockPos.x = (self.visibleSize.width - self.m_fishMgr.m_FishLock[i]:getPos().x) -- /Fishlk_CMD.kResolutionWidth * self.visibleSize.width
                fishLockPos.y = (self.visibleSize.height - self.m_fishMgr.m_FishLock[i]:getPos().y) -- /Fishlk_CMD.kResolutionHeight * self.visibleSize.height
            else
                fishLockPos.x = self.m_fishMgr.m_FishLock[i]:getPos().x
                fishLockPos.y = self.m_fishMgr.m_FishLock[i]:getPos().y
            end
            -- 角度
            local angle = MathAide.IsAngle(userPos, fishLockPos)
            local temp_ViewID = self:ChangeViewChairID(i)
            if temp_ViewID >= 1 and temp_ViewID <= 3 then
                angle = angle - 90
            elseif temp_ViewID == 4 then
                angle = angle - 180
            elseif temp_ViewID >= 5 and i <= temp_ViewID then
                angle = angle + 90
            end
            local pArms = self:FindArms(i - 1)
            pArm:setRotation(angle)
            -- 是否在屏幕内
            if self.m_fishMgr:IsFishMaxScene(self.m_fishMgr.m_FishLock[i]) then
                self:HideLock(i - 1)
                -- 目标距离
                local fDistance = cc.pGetDistance(userPos, fishLockPos)
                -- 需要多少气泡
                local lockCount = math.ceil(fDistance / 40)
                for x = 1, lockCount - 2 do
                    local lockPos = {}
                    lockPos.x = (fishLockPos.x - userPos.x) / fDistance * (40.0 * x) + userPos.x
                    lockPos.y = (fishLockPos.y - userPos.y) / fDistance * (40.0 * x) + userPos.y
                    if x < 2 then
                        self.m_fishLockLine[i][x]:setPosition(userPos)
                    else
                        self.m_fishLockLine[i][x]:setPosition(lockPos)
                    end
                    self.m_fishLockLine[i][x]:setVisible(true)
                end
                self.m_fishLockLine[i][40]:setPosition(fishLockPos)
                self.m_fishLockLine[i][40]:setVisible(true)
                self.m_fishLockLine[i][1]:setVisible(false)
            else -- 超出屏幕
                self.m_fishMgr.m_FishLock[i] = nil
                self:HideLock(i - 1)
                if i == globalUserInfo.wChairID + 1 then
                    self.m_fishUI:LockFish(i - 1)
                end
            end
        else
            self:FindLockFishIcon(i - 1):setVisible(false)
            self:HideLock(i - 1)
        end
    end
end

-- 隐藏气泡
function FISHLKScene:HideLock(wChairID)
    for i = 1, 40 do
        self.m_fishLockLine[wChairID + 1][i]:setVisible(false)
    end
end

-- 发送子弹消息
function FISHLKScene:sendFireSocket()
    -- 子弹倍数
    if globalUserInfo.wChairID == GameDefine.INVALID_CHAIR then
        return
    end
    local bulletMultiple = tonumber(self:FindMultiple(globalUserInfo.wChairID):getString())

    -- 否是可以发射子弹
    self.m_isFire = function()
        if self.m_UsetItemFishScore.fish_score[globalUserInfo.wChairID + 1] >= bulletMultiple then
            return true
        end
        return false
    end

    -- 发射条件
    if self.m_isFire and self.m_bSwitchScene == false then
        local cmd = {}
        cmd.bullet_kind = self:GetBulletKing()
        cmd.bullet_multiple = bulletMultiple

        -- 锁定的鱼
        local lockFish = self.m_fishMgr.m_FishLock[globalUserInfo.wChairID + 1]
        local fire_pos = {}
        if lockFish ~= nil then
            -- 锁定鱼状态 将鱼位置发送给服务器
            cmd.lock_fishid = lockFish:GetFishID()
            fire_pos.x = lockFish:getPos().x / self.visibleSize.width * Fishlk_CMD.kResolutionWidth
            fire_pos.y = self.visibleSize.height - lockFish:getPos().y
            fire_pos.y = fire_pos.y / self.visibleSize.height * Fishlk_CMD.kResolutionHeight
        else
            -- 未锁定状态
            cmd.lock_fishid = 0
            fire_pos.x = self.m_touchPos.x / self.visibleSize.width * Fishlk_CMD.kResolutionWidth
            fire_pos.y = self.visibleSize.height - self.m_touchPos.y
            fire_pos.y = fire_pos.y / self.visibleSize.height * Fishlk_CMD.kResolutionHeight
            -- fire_pos.x = self.m_touchPos.x / self.visibleSize.width * Fishlk_CMD.kResolutionWidth
            -- fire_pos.y = self.m_touchPos.y / self.visibleSize.height * Fishlk_CMD.kResolutionHeight
        end
        cmd.fire_pos = fire_pos
        cmd.chair_id = globalUserInfo.wChairID
        cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
        local get_string = self:GetMd5Info_1(cmd.dwCurrentTime)
        cmd.validate_info = get_string

        FishMessage.send_CMD_C_UserFire(cmd)

        -- 记录上次发射子弹的时间
        self.m_upFireTime = MathAide.GetBeiJingTime()

        local pArms = self:FindArms(cmd.chair_id)

        -- 武器角度
        local tempos = function()
            if lockFish ~= nil then
                return lockFish:getPos()
            end
            return self.m_touchPos
        end
        local tempos = self.m_touchPos
        if lockFish ~= nil then
            if globalUserInfo.wChairID < 4 then
                tempos.x = (self.visibleSize.width - lockFish:getPos().x) -- / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
                tempos.y = (self.visibleSize.height - lockFish:getPos().y) -- / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
            else
                tempos = cc.p(lockFish:getPos())
            end

        end
        local fArmsAngle = MathAide.IsAngle(self.m_userPos, tempos) + 90
        local temp_ViewID = self:ChangeViewChairID(cmd.chair_id + 1)
        if temp_ViewID >= 1 and temp_ViewID <= 3 then
            fArmsAngle = fArmsAngle + 180
        end
        if temp_ViewID == 4 then
            fArmsAngle = fArmsAngle + 90
        end
        if temp_ViewID == 8 then
            fArmsAngle = fArmsAngle - 90
        end
        pArms:setRotation(fArmsAngle)
        -- pArms:fire()
        -- 提示位置移除
        if self.m_myPosHint ~= nil then
            self.m_myPosHint:removeFromParent()
            self.m_myPosHint = nil
        end
    else
        -- 取消挂机
        if self.m_isFire == false then
            self.m_fishUI:HangGame(false)
        end
    end
end

-- 子弹类型
function FISHLKScene:GetBulletKing()
    local bulletkind = nil

    local pMuitiple = self:FindMultiple(globalUserInfo.wChairID)
    -- 当前倍数
    local userBulletMultiple = tonumber(pMuitiple:getString())

    if userBulletMultiple < 100 then
        if self.m_bullet_ion == false then
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_1_NORMAL
        else
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_1_ION
        end
    elseif userBulletMultiple >= 100 and userBulletMultiple < 1000 then
        if self.m_bullet_ion == false then
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_2_NORMAL
        else
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_2_ION
        end
    elseif userBulletMultiple >= 1000 and userBulletMultiple < 5000 then
        if self.m_bullet_ion == false then
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_3_NORMAL
        else
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_3_ION
        end
    else
        if self.m_bullet_ion == false then
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_4_NORMAL
        else
            bulletkind = Fishlk_CMD.BulletKind.BULLET_KIND_4_ION
        end
    end

    return bulletkind
end

-- 场景消息
function FISHLKScene:onGameScene(data)
    if self.isExitGame == true then
        return
    end
    self:initParams()
    local params = FishMessage.CMD_S_GameState(data)
    self.me_user_score = params.me_user_score
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        self.m_UsetItemFishScore.fish_score[i] = params.fish_score[i]
    end
    self:updateUserScore()
end
-- 初始化数据
function FISHLKScene:initParams()
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        self.m_fishMgr.m_FishLock[i] = nil
    end
end
function FISHLKScene:updateUserScore()
    self:FindUserScore():setString(tostring(self.me_user_score))
    for i = 1, Fishlk_CMD.GamePlayer_4 do
        self:FindFishScore(i - 1):setString(tostring(self.m_UsetItemFishScore.fish_score[i]))
    end
    if self.me_user_score > 0 then
        self:UpScore()
    end
end
-- 游戏状态消息
function FISHLKScene:onGameStatus()
    -- 子类实现
end
-- 上分
function FISHLKScene:UpScore()
    local cmd = {}
    cmd.chair_id = globalUserInfo.wChairID
    cmd.increase = true
    cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
    local get_string = self:GetMd5Info_1(cmd.dwCurrentTime)
    cmd.validate_info = get_string
    FishMessage.send_CMD_C_ExchangeFishScore(cmd)
end
-- 游戏消息
function FISHLKScene:onGame(cmdID, data)
    if self.isExitGame == true then
        return
    end
    if cmdID == Fishlk_CMD.SUB_S_GAME_CONFIG then -- 游戏配置
        self:OnSocketGameConfig(data)
    elseif cmdID == Fishlk_CMD.SUB_S_FISH_TRACE then -- 鱼轨迹
        while (data:isNextRead()) do
            self:OnSocketFishTrace(data)
        end
    elseif cmdID == Fishlk_CMD.SUB_S_EXCHANGE_FISHSCORE then -- 兑换鱼币
        self:OnSocketExchangeFishScore(data)
    elseif cmdID == Fishlk_CMD.SUB_S_USER_FIRE then -- 玩家开火
        self:OnSocketUserFire(data)
    elseif cmdID == Fishlk_CMD.SUB_S_CATCH_FISH then -- 捕获鱼
        self:OnSocketCatchFish(data)
    elseif cmdID == Fishlk_CMD.SUB_S_BULLET_ION_TIMEOUT then -- 大炮过时
        self:OnSocketBulletIonTimeout(data)
    elseif cmdID == Fishlk_CMD.SUB_S_LOCK_TIMEOUT then -- 定屏过时
        self:OnSocketLockTimeout()
    elseif cmdID == Fishlk_CMD.SUB_S_CATCH_SWEEP_FISH then -- 打中鱼王炸弹
        self:OnSocketCatchSweepFish(data)
    elseif cmdID == Fishlk_CMD.SUB_S_CATCH_SWEEP_FISH_RESULT then -- 捕获结果
        self:OnSocketCatchSweepFishResult(data)
    elseif cmdID == Fishlk_CMD.SUB_S_HIT_FISH_LK then -- 击中李逵
        self:OnSocketHitFishLk(data)
    elseif cmdID == Fishlk_CMD.SUB_S_HIT_FISH_TASK then -- 击中任务鱼
        self:OnSocketHitFishTask(data)
    elseif cmdID == Fishlk_CMD.SUB_S_SWITCH_SCENE then -- 切换场景
        self:OnSocketSwitchScene(data, false)
    elseif cmdID == Fishlk_CMD.SUB_S_SCENE_END then -- 场景结束
        self:OnSocketSceneEnd()
    elseif cmdID == Fishlk_CMD.SUB_S_TREASURE_BOX_RESULT then -- 大转盘
        self:OnSocketTreasureBoxResult(data)
    elseif cmdID == Fishlk_CMD.SUB_S_GRAB_LK then -- 抢李逵结果
        self:OnSubGrabLK(data)
    elseif cmdID == Fishlk_CMD.SUB_S_GAME_STAT_SCENE then
        self:OnSocketSwitchScene(data, true)
    elseif cmdID == Fishlk_CMD.SUB_S_GAME_STAT_SCENE2 then
        self:onSocketGameStat_Scene2(data)
    end
end

-- 玩家进入消息
function FISHLKScene:onUserEnter(gameUser)
    -- 子类实现
end

-- 玩家积分改变消息
function FISHLKScene:onUserScore(gameUser)
    -- 子类实现
end

-- 玩家坐下
function FISHLKScene:onUserSitDown(gameUser)
    if gameUser.wChairID < 0 or gameUser.wChairID > 7 then
        return
    end
    self:FindGunObj(gameUser.wChairID):setVisible(true)
    self:FindWaitJoin(gameUser.wChairID):setVisible(false)
end

-- 玩家准备
function FISHLKScene:onUserReady(gameUser)
    -- 子类实现
end

-- 玩家站起
function FISHLKScene:onUserStandup(wChairID)
    -- 玩家退出处理
    self:HideLock(wChairID)
    self.m_fishMgr.m_FishLock[wChairID + 1] = nil

    self:FindFishScore(wChairID):setString("0")

    local szBulletMuitiple = tostring(self.m_gameConfig.min_bullet_multiple)
    self:FindMultiple(wChairID):setString(szBulletMuitiple)

    local pArms = self:FindArms(wChairID)
    --[[if pArms:GetArmsFile() ~= 1 then
		pArms:SetArmsFile("Ani_connon1_1.png",1)
	end --]]

    pArms:setRotation(0)

    self:FindCardIon(wChairID):setVisible(false)
    self:FindLockFishIcon(wChairID):setVisible(false)

    self:FindGunObj(wChairID):setVisible(false)
    self:FindWaitJoin(wChairID):setVisible(true)
end

-- 玩家掉线
function FISHLKScene:onUserOffline(gameUser)
    -- 子类实现
end

-- 玩家游戏
function FISHLKScene:onUserPlaying(gameUser)

end
-- 初始化游戏配置
function FISHLKScene:initGameConfig()
    self.m_gameConfig = {}
    self.m_gameConfig.exchange_ratio_userscore = 0 -- 玩家积分
    self.m_gameConfig.exchange_ratio_fishscore = 0 -- 鱼币
    self.m_gameConfig.exchange_count = 0 -- 兑换数量

    self.m_gameConfig.min_bullet_multiple = 10000 -- 最小子弹倍数
    self.m_gameConfig.max_bullet_multiple = 99000 -- 最大子弹倍数

    self.m_gameConfig.bomb_range_width = 0
    self.m_gameConfig.bomb_range_height = 0

    self.m_gameConfig.bGrabLKonoff = 0
    self.m_gameConfig.lBaseScore = 0
    self.m_gameConfig.fish_multiple = {}
    self.m_gameConfig.fish_speed = {}
    self.m_gameConfig.fish_bounding_box_width = {}
    self.m_gameConfig.fish_bounding_box_height = {}
    self.m_gameConfig.fish_hit_radius = {}
    local fish_speed = {5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 3, 3, 3, 2, 1, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 2}
    for i = 1, Fishlk_CMD.FishKind.FISH_KIND_COUNT do
        self.m_gameConfig.fish_multiple[i] = 1 -- 鱼倍数
        self.m_gameConfig.fish_speed[i] = fish_speed[i] -- 鱼速度
        self.m_gameConfig.fish_bounding_box_width[i] = 1
        self.m_gameConfig.fish_bounding_box_height[i] = 1
        self.m_gameConfig.fish_hit_radius[i] = 1
    end
    self.m_gameConfig.bullet_speed = {}
    self.m_gameConfig.net_radius = {}
    for i = 1, Fishlk_CMD.BulletKind.BULLET_KIND_COUNT do
        self.m_gameConfig.bullet_speed[i] = 20
        self.m_gameConfig.net_radius[i] = 50
    end
end
-- 游戏配置
function FISHLKScene:OnSocketGameConfig(data)
    -- 获取数据
    local value = FishMessage.CMD_S_GameConfig(data)
    -- 兑换比例
    self.m_gameConfig.exchange_ratio_userscore = value.exchange_ratio_userscore -- 玩家积分
    self.m_gameConfig.exchange_ratio_fishscore = value.exchange_ratio_fishscore -- 鱼币
    self.m_gameConfig.exchange_count = value.exchange_count -- 兑换数量

    self.m_gameConfig.min_bullet_multiple = value.min_bullet_multiple -- 最小子弹倍数
    self.m_gameConfig.max_bullet_multiple = value.max_bullet_multiple -- 最大子弹倍数

    self.m_gameConfig.bomb_range_width = value.bomb_range_width
    self.m_gameConfig.bomb_range_height = value.bomb_range_height

    self.m_gameConfig.bGrabLKonoff = value.bGrabLKonoff
    self.m_gameConfig.lBaseScore = value.lBaseScore
    self.m_gameConfig.fish_multiple = {}
    self.m_gameConfig.fish_speed = {}
    self.m_gameConfig.fish_bounding_box_width = {}
    self.m_gameConfig.fish_bounding_box_height = {}
    self.m_gameConfig.fish_hit_radius = {}
    for i = 1, Fishlk_CMD.FishKind.FISH_KIND_COUNT do
        self.m_gameConfig.fish_multiple[i] = value.fish_multiple[i] -- 鱼倍数
        self.m_gameConfig.fish_speed[i] = value.fish_speed[i] -- 鱼速度
        self.m_gameConfig.fish_bounding_box_width[i] = value.fish_bounding_box_width[i]
        self.m_gameConfig.fish_bounding_box_height[i] = value.fish_bounding_box_height[i]
        self.m_gameConfig.fish_hit_radius[i] = value.fish_hit_radius[i]
    end
    self.m_gameConfig.bullet_speed = {}
    self.m_gameConfig.net_radius = {}
    for i = 1, Fishlk_CMD.BulletKind.BULLET_KIND_COUNT do
        self.m_gameConfig.bullet_speed[i] = value.bullet_speed[i]
        self.m_gameConfig.net_radius[i] = value.net_radius[i]
    end
end
-- 鱼路径
function FISHLKScene:OnSocketFishTrace(data)
    -- 获取数据
    local value = FishMessage.CMD_S_FishTrace(data)
    local fish = {}
    fish.fishTrace = {}
    fish.fishTrace.init_pos = {}
    for i = 1, 5 do
        fish.fishTrace.init_pos[i] = value.init_pos[i]
    end
    fish.fishTrace.init_count = value.init_count
    fish.fishTrace.fish_kind = value.fish_kind
    fish.fishTrace.fish_id = value.fish_id
    fish.fishTrace.trace_type = value.trace_type

    if self.m_gameConfig.fish_speed == nil then
        return
    end
    fish.fSpeed = self.m_gameConfig.fish_speed[value.fish_kind + 1]

    -- 添加队列
    table.insert(self.m_ListFishMsg, fish)
end
-- 兑换鱼币

function FISHLKScene:OnSocketExchangeFishScore(data)
    -- 获取数据
    local value = FishMessage.CMD_S_ExchangeFishScore(data)
    if value.swap_fish_score < 0 then
        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = 0
    else
        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.swap_fish_score
    end

    local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
    local pFishScore = self:FindFishScore(value.chair_id)
    pFishScore:setString(szFishScore)

    -- 判断自己
    if value.chair_id == globalUserInfo.wChairID then
        -- 本次兑换金币
        local score = value.swap_fish_score * (self.m_gameConfig.exchange_ratio_userscore / self.m_gameConfig.exchange_ratio_fishscore)
        self.me_user_score = self.me_user_score - score

        local szScore = 0
        if self.me_user_score > 0 then
            szScore = self.me_user_score
        end
        -- 设置分数
        self:FindUserScore():setString(tostring(szScore))
        if self.me_user_score > 0 then
            self:UpScore()
        end
        --[[if self.m_myPosHint ~= nil then
			self.m_myPosHint:removeFromParent()
			self.m_myPosHint = nil
		end --]]
    end
end

-- 玩家开火

function FISHLKScene:OnSocketUserFire(data)
    -- 获取数据
    local value = FishMessage.CMD_S_UserFire(data)
    if value.lock_fishid > 0 then
        if self.m_fishMgr:GetFishIdToFish(value.lock_fishid) == nil then
            return -- 丢掉锁定鱼消息
        end
    end
    if self.m_bSwitchScene == true then
        return
    end
    local pArms = self:FindArms(value.chair_id)
    pArms:fire()
    -- 用户武器点
    local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), self.origin)
    -- 锁定鱼的ID
    local lock_fish_id = value.lock_fishid
    -- 没有锁定
    if lock_fish_id == -2 then
        -- 不做锁定处理
        lock_fish_id = 0
        self.m_fishMgr.m_FishLock[value.chair_id + 1] = nil
        -- 李逵达人游戏，没有锁定，也发锁定消息
        if self.m_gameConfig.bGrabLKonoff == 1 then
            lock_fish_id = -1
        end
    end

    -- AI 重做锁定处理
    if lock_fish_id == -1 then
        self.m_fishUI:LockFish(value.chair_id, self.m_gameConfig.bGrabLKonoff)
        local fish = self.m_fishMgr.m_FishLock[value.chair_id + 1]
        if fish ~= nil then
            lock_fish_id = fish:GetFishID()
        else
            lock_fish_id = 0
        end
    end
    if globalUserInfo.wChairID == value.chair_id then
        local fish = self.m_fishMgr.m_FishLock[value.chair_id + 1]
        if fish ~= nil then
            lock_fish_id = fish:GetFishID()
        else
            lock_fish_id = 0
        end
        value.lock_fishid = lock_fish_id
    end

    -- 判断锁定鱼
    local fire_pos = {}
    local temp_ViewID = self:ChangeViewChairID(value.chair_id + 1)
    self.m_fishMgr.m_FishLock[value.chair_id + 1] = self.m_fishMgr:GetFishIdToFish(value.lock_fishid);
    if value.lock_fishid > 0 and self.m_fishMgr.m_FishLock[value.chair_id + 1] ~= nil then
        local fish = self.m_fishMgr.m_FishLock[value.chair_id + 1]
        if fish ~= nil then
            if globalUserInfo.wChairID < 4 then
                -- fire_pos.x = (Fishlk_CMD.kResolutionWidth - fish:getPos().x) / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
                -- fire_pos.y = (Fishlk_CMD.kResolutionHeight - fish:getPos().y) / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
                fire_pos.x = (self.visibleSize.width - fish:getPos().x)
                fire_pos.y = (self.visibleSize.height - fish:getPos().y)
            else
                fire_pos.x = fish:getPos().x
                fire_pos.y = fish:getPos().y
            end
            -- 锁定鱼的提示
            local plockFishIcon = self:FindLockFishIcon(value.chair_id)

            local szlockFishIcon = string.format("lock_flag_%02d.png", fish:GetFishTrace().fish_kind + 1)
            plockFishIcon:setSpriteFrame(szlockFishIcon)
            plockFishIcon:setVisible(true)
        end
    else
        if temp_ViewID <= 4 then
            fire_pos.x = (Fishlk_CMD.kResolutionWidth - value.fire_pos.x) / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
            fire_pos.y = value.fire_pos.y / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
        else
            fire_pos.x = value.fire_pos.x / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
            fire_pos.y = Fishlk_CMD.kResolutionHeight - value.fire_pos.y
            fire_pos.y = fire_pos.y / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
        end

    end
    -- 武器角度
    local fArmsAngle = MathAide.IsAngle(userPos, fire_pos) + 90

    if temp_ViewID >= 1 and temp_ViewID <= 3 then
        fArmsAngle = fArmsAngle + 180
    end
    if temp_ViewID == 4 then
        fArmsAngle = fArmsAngle + 90
    end
    if temp_ViewID == 8 then
        fArmsAngle = fArmsAngle - 90
    end
    pArms:setRotation(fArmsAngle)

    -- 是否能量炮
    --[[if value.bullet_kind > Fishlk_CMD.BulletKind.BULLET_KIND_4_NORMAL then
		MusicManager.playEffect(getRes"music/SHELL_8.mp3")
	else--]]
    if globalUserInfo.wChairID == value.chair_id then
        MusicManager.playEffect(getRes("music/SHELL_8.mp3"))
    end
    -- end
    -- 鱼币
    local pFishScore = self:FindFishScore(value.chair_id)

    if self.m_UsetItemFishScore.fish_score[value.chair_id + 1] >= value.bullet_multiple then
        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] - value.bullet_multiple
    end
    local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
    pFishScore:setString(szFishScore)

    if value.chair_id ~= globalUserInfo.wChairID then
        -- 子弹倍数
        local pFindMultiple = self:FindMultiple(value.chair_id)
        local szFindMultiple = tostring(value.bullet_multiple)
        pFindMultiple:setString(szFindMultiple)
        local isIcon = false
        if value.bullet_kind >= Fishlk_CMD.BulletKind.BULLET_KIND_1_ION then
            isIcon = true
        end
        -- self:ChangeArms(value.chair_id, value.bullet_multiple,isIcon)
    end

    -- 创建子弹
    self.m_bulletMgr:fire(value)
end
-- 捕获鱼群
function FISHLKScene:OnSocketCatchFish(data)
    -- 获取数据
    local value = FishMessage.CMD_S_CatchFish(data)
    -- 死鱼特效
    if value.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and value.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_COUNT - 1 then
        local fish = self.m_fishMgr:GetFishIdToFish(value.fish_id)
        if fish ~= nil then
            local fishPos = fish:getPos()
            self:addBombSpeciallyGoodEffect(value.fish_kind, fishPos)

            -- 震动屏幕
            -- local pshake = CCFallOffShake:create(1, 5)  
            -- this->runAction(pshake)
        end
    end

    -- 彩金盘
    if ((value.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and value.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_LK) or
        (value.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_25 and value.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_30)) then

        local viewID = self:ChangeViewChairID(value.chair_id + 1)
        local paddnode = self.m_ArmsLayer:getChildByTag(viewID + 10)

        local pThereareBingo = paddnode:getChildByTag(TAG.BINGO)
        if pThereareBingo then
            pThereareBingo:removeFromParent()
        end

        local pBingo = CBingo.new("bingo_01.png", value.fish_score)
        pBingo:setPosition(cc.p(paddnode:getContentSize().width / 2, paddnode:getContentSize().height + pBingo:getContentSize().height / 2))
        pBingo:setZOrder(99)
        paddnode:addChild(pBingo)
        pBingo:setTag(TAG.BINGO)
        MusicManager.playEffect(getRes "music/bingo.mp3")
    end

    -- 大转盘
    if value.award ~= Fishlk_CMD.Award.AWARD_COUNT then
        local viewID = self:ChangeViewChairID(value.chair_id + 1)
        local paddnode = self.m_ArmsLayer:getChildByTag(viewID + 10)

        local pThereareBigWheel = paddnode:getChildByTag(TAG.BIGWHEEL)
        if pThereareBigWheel then
            pThereareBigWheel:removeFromParent()
        end

        -- 创建大转盘
        local pbigWheel = CBigWheel.new("di.png", value.chair_id, value.award, value.fish_id, self)

        pbigWheel:setPosition(cc.p(paddnode:getContentSize().width / 2, paddnode:getContentSize().height + pbigWheel:getContentSize().height / 2))
        pbigWheel:setZOrder(100)
        paddnode:addChild(pbigWheel)
        pbigWheel:setTag(TAG.BIGWHEEL)
        if value.chair_id == globalUserInfo.wChairID then
            self.m_isFire = false
        end
    end

    -- 定屏炸弹
    if value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_22 then
        self.m_stopCreateFish = true
        self.m_fishMgr:StopMove()
    end

    local fish_list = self.m_fishMgr:GetFishList()

    for i = 1, #fish_list do
        local pFish = fish_list[i]
        local fishID = pFish:GetFishID()
        local temp_point = {}
        if globalUserInfo.wChairID < 4 then
            temp_point.x = (self.visibleSize.width - pFish:getPos().x) / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
            temp_point.y = (self.visibleSize.height - pFish:getPos().y) / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
        else
            temp_point.x = pFish:getPos().x
            temp_point.y = pFish:getPos().y
        end
        if fishID == value.fish_id then
            -- 金币数量索引
            local index = 0
            if value.fish_score > 0 and value.fish_score < 100 then
                index = 2
            end
            if value.fish_score >= 100 and value.fish_score < 1000 then
                index = 3
            end
            if value.fish_score >= 1000 and value.fish_score < 10000 then
                index = 4
            end
            if value.fish_score >= 10000 and value.fish_score < 100000 then
                index = 5
            end
            if value.fish_score >= 100000 and value.fish_score < 1000000 then
                index = 8
            end
            if value.fish_score >= 1000000 and value.fish_score < 10000000 then
                index = 10
            end
            if value.fish_score >= 10000000 then
                index = 12
            end

            -- 坐标系数转换
            local pArms = self:FindArms(value.chair_id)
            local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), self.origin)
            for i = 1, index do
                if index == 1 then
                    local sp = self:creatAnimationSprite("coin2_%02d.png", 12)
                    sp:setPosition(cc.p(temp_point))
                    sp:setZOrder(10)
                    self.m_ArmsLayer:addChild(sp)

                    local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                    local speed = fDistance / 100.0
                    local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, cc.p(userPos))
                    local spCallMoveOver = cc.CallFunc:create(function(args)
                        args:removeFromParent()
                    end)
                    local psq = cc.Sequence:create(pmove, spCallMoveOver)
                    sp:runAction(psq)
                else
                    math.randomseed(GameUtil.getSystemTime())
                    local temp_i = math.random(1, 10) / 10
                    local sp = self:creatAnimationSprite("coin2_%02d.png", 12)
                    local countLeft = math.floor(index / 2)
                    sp:setPosition(cc.p(temp_point.x - (sp:getContentSize().width * (countLeft - i)), temp_point.y + (temp_i * sp:getContentSize().width)))
                    sp:setZOrder(10)
                    self.m_ArmsLayer:addChild(sp)
                    local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                    local speed = fDistance / 100.0
                    local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
                    local easeBackIn1
                    if value.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and value.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_LK then
                        easeBackIn1 = cc.EaseBounceIn:create(pmove)
                    else
                        easeBackIn1 = cc.EaseBackIn:create(pmove)
                    end

                    local spCallMoveOver = cc.CallFunc:create(function(args)
                        args:removeFromParent()
                    end)
                    local psq = cc.Sequence:create(easeBackIn1, spCallMoveOver)
                    sp:runAction(psq)
                end
            end

            local lockFish = self.m_fishMgr.m_FishLock[value.chair_id + 1]
            local userlockFishID = 0
            if lockFish then
                userlockFishID = lockFish:GetFishID()
            end

            -- 销毁鱼
            pFish:death(value.fish_score)

            if value.chair_id == globalUserInfo.wChairID then
                if fishID == userlockFishID then
                    lockFish = nil
                    self.m_isFire = false
                    self.m_fishUI:LockFish(value.chair_id)
                end
            end

            break
        end
    end

    -- 是否能量炮
    --[[if value.bullet_ion ~= 0 then
		self:FindCardIon(value.chair_id):setVisible(true)
		
		if value.chair_id == globalUserInfo.wChairID then
			self.m_bullet_ion = true
			self:UpDateArms()
		else
			local bulletMultiple = tonumber(self:FindMultiple(value.chair_id):getString())
			self:ChangeArms(value.chair_id, bulletMultiple, true)
		end
	end --]]

    -- 添加鱼币
    if value.fish_score > 0 then
        -- 添加筹码
        -- self:addFishChipScore(value.chair_id, value.fish_score)

        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.fish_score
        -- 添加分数
        local pFishScore = self:FindFishScore(value.chair_id)
        local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
        pFishScore:setString(szFishScore)
    end

    -- 音效
    if value.fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_10 and value.fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_17 then
        local szEffect = nil
        math.randomseed(os.time())
        local index = math.random(0, 1) + 1
        if value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_10 then
            szEffect = string.format("music/fish10_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_11 then
            szEffect = string.format("music/fish11_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_12 then
            szEffect = string.format("music/fish12_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_13 then
            szEffect = string.format("music/fish13_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_14 then
            szEffect = string.format("music/fish14_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_15 then
            szEffect = string.format("music/fish15_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_16 then
            szEffect = string.format("music/fish16_%d.mp3", index)
        elseif value.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_17 then
            local index17 = math.random(0, 2) + 1
            szEffect = string.format("music/fish17_%d.mp3", index17)
        end

        MusicManager.playEffect(getRes(szEffect))
    end

    return true
end

-- 大炮超时
function FISHLKScene:OnSocketBulletIonTimeout(data)
    -- 获取数据
    --[[local value = FishMessage.CMD_S_BulletIonTimeout(data)
	if value.chair_id < 0 or value.chair_id > 7 then return end
	
	if value.chair_id == globalUserInfo.wChairID then
		self.m_bullet_ion = false
		self:UpDateArms()
	else
		local bulletMultiple = tonumber(self:FindMultiple(value.chair_id):getString())
		self:ChangeArms(value.chair_id, bulletMultiple, false)
	end 
	self:FindCardIon(value.chair_id):setVisible(false)--]]
    return true
end

-- 定屏过时
function FISHLKScene:OnSocketLockTimeout()
    self.m_stopCreateFish = false
    -- 继续鱼轨迹
    self.m_fishMgr:ActiveMove()
end
-- 打中鱼王&炸弹
function FISHLKScene:OnSocketCatchSweepFish(data)
    -- 获取数据
    local value = FishMessage.CMD_S_CatchSweepFish(data)
    -- 鱼王&炸弹 类型
    local fish_kind = Fishlk_CMD.FishKind.FISH_KIND_COUNT
    local fish_pos = cc.p(0, 0)

    for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
        if fish:GetFishID() == value.fish_id then
            fish_kind = fish:GetFishTrace().fish_kind
            fish_pos = fish:getPos()
        end
    end

    -- 炸弹击中的鱼ID
    local fish_id_list = {}

    local cmd = {}
    cmd.chair_id = value.chair_id
    cmd.fish_id = value.fish_id

    if fish_kind == Fishlk_CMD.FishKind.FISH_KIND_23 then
        for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
            local pos = fish:getPos()
            -- 炸弹范围
            local rect = cc.rect(fish_pos.x - self.m_gameConfig.bomb_range_width / 2, fish_pos.y - self.m_gameConfig.bomb_range_height / 2, fish_pos.x + self.m_gameConfig.bomb_range_width / 2,
                fish_pos.y + self.m_gameConfig.bomb_range_height / 2)
            if cc.rectContainsPoint(rect, pos) then
                table.insert(fish_id_list, fish:GetFishID())
            end
        end
        -- 全屏炸弹
    elseif fish_kind == Fishlk_CMD.FishKind.FISH_KIND_24 then
        for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
            table.insert(fish_id_list, fish:GetFishID())
        end
        -- 鱼王
    elseif (fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_31 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_40) then
        for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
            if (fish_kind - 30 == fish:GetFishTrace().fish_kind) then
                table.insert(fish_id_list, fish:GetFishID())
            end
        end
    end

    cmd.catch_fish_count = #fish_id_list
    cmd.catch_fish_id = {}
    for i = 1, 300 do
        local temp_catch_fish_id = 0
        if (i <= #fish_id_list) then
            temp_catch_fish_id = fish_id_list[i]
        end
        table.insert(cmd.catch_fish_id, temp_catch_fish_id)
    end

    cmd.dwCurrentTime = MathAide.GetCurrentBeiJingTime()
    local get_string = self:GetMd5Info_1(cmd.dwCurrentTime)

    cmd.validate_info = get_string

    FishMessage.send_CMD_C_CatchSweepFish(cmd)
end

-- 鱼王炸弹炸死结果
function FISHLKScene:OnSocketCatchSweepFishResult(data)
    -- 获取数据
    local value = FishMessage.CMD_S_CatchSweepFishResult(data)
    local fish_pos = cc.p(0, 0)
    for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
        if fish:GetFishID() == value.fish_id then
            if globalUserInfo.wChairID < 4 then
                fish_pos.x = (self.visibleSize.width - fish:getPos().x) -- / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
                fish_pos.y = (self.visibleSize.height - fish:getPos().y) -- / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
            else
                fish_pos.x = fish:getPos().x
                fish_pos.y = fish:getPos().y
            end
            if fish:GetFishTrace().fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and fish:GetFishTrace().fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_COUNT - 1 then
                self:addBombSpeciallyGoodEffect(fish:GetFishTrace().fish_kind, fish:getPos())
            end
            if fish:GetFishTrace().fish_kind == Fishlk_CMD.FishKind.FISH_KIND_31 then
                fish:death(value.fish_score / (value.catch_fish_count + 1) * 2)
            else
                fish:death(value.fish_score / (value.catch_fish_count + 1))
            end
        else
            for i = 1, value.catch_fish_count do
                if fish:GetFishID() == value.catch_fish_id[i] then
                    if value.fish_id == Fishlk_CMD.FishKind.FISH_KIND_31 then
                        fish:death(value.fish_score / (value.catch_fish_count + 2))
                    else
                        fish:death(value.fish_score / (value.catch_fish_count + 1))
                    end
                    break
                end
            end
        end
    end

    -- 金币数量索引
    local index = 0
    if value.fish_score > 0 and value.fish_score < 100 then
        index = 2
    end
    if value.fish_score >= 100 and value.fish_score < 1000 then
        index = 3
    end
    if value.fish_score >= 1000 and value.fish_score < 10000 then
        index = 4
    end
    if value.fish_score >= 10000 and value.fish_score < 100000 then
        index = 5
    end
    if value.fish_score >= 100000 and value.fish_score < 1000000 then
        index = 8
    end
    if value.fish_score >= 1000000 and value.fish_score < 10000000 then
        index = 10
    end
    if value.fish_score >= 10000000 then
        index = 12
    end

    -- 坐标系数转换
    local pArms = self:FindArms(value.chair_id)
    local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), self.origin)

    for i = 1, index do
        if index == 1 then
            local sp = self:creatAnimationSprite("coin2_%02d.png", 12)
            sp:setPosition(fish_pos)
            sp:setZOrder(10)
            self.m_ArmsLayer:addChild(sp)

            local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
            local speed = fDistance / 100.0
            local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
            local spCallMoveOver = cc.CallFunc:create(function(args)
                args:removeFromParent()
            end)
            local psq = cc.Sequence:create(pmove, spCallMoveOver)
            sp:runAction(psq)
        else
            math.randomseed(GameUtil.getSystemTime())
            local temp_i = math.random(1, 10) / 10
            local sp = self:creatAnimationSprite("coin2_%02d.png", 12)
            local countLeft = index / 2

            sp:setPosition(cc.p(fish_pos.x - sp:getContentSize().width * countLeft + (i - 1) * sp:getContentSize().width, fish_pos.y + (temp_i * sp:getContentSize().width)))
            sp:setZOrder(10)
            self.m_ArmsLayer:addChild(sp)

            local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
            local speed = fDistance / 100.0
            local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
            local spCallMoveOver = cc.CallFunc:create(function(args)
                args:removeFromParent()
            end)
            local psq = cc.Sequence:create(pmove, spCallMoveOver)
            sp:runAction(psq)
        end
    end

    -- 添加鱼币
    if value.fish_score > 0 then
        -- 添加筹码
        -- self:addFishChipScore(value.chair_id, value.fish_score)

        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.fish_score
        -- 添加分数
        local pFishScore = self:FindFishScore(value.chair_id)
        local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
        pFishScore:setString(szFishScore)
    end
end

-- 击中李逵
function FISHLKScene:OnSocketHitFishLk(data)
    -- 获取数据
    local value = FishMessage.CMD_S_HitFishLK(data)
    local fish_lk = self.m_fishMgr:GetFishLk()
    if fish_lk ~= nil and self.m_fishMgr:IsFishMaxScene(fish_lk) and fish_lk:GetState() ~= Fishlk_CMD.FishState.DEATH then
        local pMultiple = fish_lk:getChildByTag(Fishlk_CMD.FishActiveTag.LK_TAG)
        local szMultiple = tostring(value.fish_multiple)
        pMultiple:setString(szMultiple)
    end
end

-- 击中任务鱼
function FISHLKScene:OnSocketHitFishTask(data)
    -- 获取数据
    local value = FishMessage.CMD_S_HitFishTask(data)
    -- 添加筹码
    local fish_task = self.m_fishMgr:GetFishIdToFish(value.fish_id)
    if fish_task == nil then
        return
    end
    local temp_point = {}
    if globalUserInfo.wChairID < 4 then
        temp_point.x = (self.visibleSize.width - fish_task:getPos().x) / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
        temp_point.y = (self.visibleSize.height - fish_task:getPos().y) / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
    else
        temp_point.x = fish_task:getPos().x
        temp_point.y = fish_task:getPos().y
    end
    local pMultiple = fish_task.getChildByTag(Fishlk_CMD.FishActiveTag.TASK_TAG)
    local szMultiple = tostring(value.fish_life)
    if pMultiple then
        pMultiple:setString(szMultiple)
    end
    if fish_task ~= nil and self.m_fishMgr:IsFishMaxScene(fish_task) and value.chair_id ~= GameDefine.INVALID_CHAIR then
        if value.get_fishscore > 0 then
            -- 添加筹码
            -- self:addFishChipScore(value.chair_id, value.get_fishscore)
            self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.get_fishscore
            -- 添加分数
            localpFishScore = self:FindFishScore(value.chair_id)
            local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
            pFishScore:setString(szFishScore)
        end
        local index = 0
        if value.get_fishscore > 0 and value.get_fishscore < 100 then
            index = 2
        end
        if value.get_fishscore >= 100 and value.get_fishscore < 1000 then
            index = 3
        end
        if value.get_fishscore >= 1000 and value.get_fishscore < 10000 then
            index = 4
        end
        if value.get_fishscore >= 10000 and value.get_fishscore < 100000 then
            index = 5
        end
        if value.get_fishscore >= 100000 and value.get_fishscore < 1000000 then
            index = 8
        end
        if value.get_fishscore >= 1000000 and value.get_fishscore < 10000000 then
            index = 10
        end
        if value.get_fishscore >= 10000000 then
            index = 12
        end

        -- 坐标系数转换
        local pArms = self:FindArms(value.chair_id)
        local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), self.origin)

        for i = 1, index do
            if index == 1 then
                local sp = self:creatAnimationSprite("coin3_%02d.png", 12)
                sp:setPosition(cc.p(temp_point))
                sp:setZOrder(10)
                self.m_ArmsLayer:addChild(sp)

                local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                local speed = fDistance / 100.0
                local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
                local spCallMoveOver = cc.CallFunc:create(function(args)
                    args:removeFromParent()
                end)
                local psq = cc.Sequence:create(pmove, spCallMoveOver)
                sp:runAction(psq)
            else
                local sp = creatAnimationSprite("coin3_%02d.png", 12)

                local countLeft = index / 2

                sp:setPosition(cc.pp(temp_point.x - sp:getContentSize().width * countLeft + (i - 1) * sp:getContentSize().width, temp_point.y))
                sp:setZOrder(10)
                self.m_ArmsLayer:addChild(sp)

                local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                local speed = fDistance / 100.0
                local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
                local spCallMoveOver = cc.CallFunc:create(function(args)
                    args:removeFromParent()
                end)
                local psq = cc.Sequence:create(pmove, spCallMoveOver)
                sp:runAction(psq)
            end
        end
    end
end
-- 切换场景
function FISHLKScene:OnSocketSwitchScene(data, isRefresh)
    -- 获取数据
    local value = nil
    self.isRefresh = isRefresh
    if self.isRefresh == true then
        value = FishMessage.CMD_S_GameStatScene(data)
    else
        value = FishMessage.CMD_S_SwitchScene(data)
    end
    -- dump(value)

    self.m_isFire = false
    self.m_stopCreateFish = false
    self.m_bSwitchScene = true

    self.m_SwitchScene = {}
    self.m_SwitchScene.scene_kind = value.scene_kind
    self.m_SwitchScene.fish_count = value.fish_count

    self.m_SwitchScene.fish_kind = {}
    self.m_SwitchScene.fish_id = {}
    self.m_SwitchScene.nIndex = {}
    self.m_SwitchScene.dwLeftTime = {}
    local temp_time = 0
    for i = 1, value.fish_count do
        self.m_SwitchScene.fish_kind[i] = value.fish_kind[i]
        self.m_SwitchScene.fish_id[i] = value.fish_id[i]
        if self.isRefresh == true then
            self.m_SwitchScene.nIndex[i] = value.nIndex[i] + 1
            if value.dwLeftTime[i] >= 4.5 * 1000 then
                self.m_SwitchScene.dwLeftTime[i] = value.dwLeftTime[i] - 4.5 * 1000
                temp_time = 4.5
            else
                self.m_SwitchScene.dwLeftTime[i] = 0
                temp_time = value.dwLeftTime[i] / 1000
            end
        end
    end

    -- 锁定
    for i = #self.m_ListFishMsg, 1, -1 do
        if self.m_ListFishMsg[i] then
            table.remove(self.m_ListFishMsg, i)
        end
    end
    self.m_ListFishMsg = {}

    -- 删除鱼队列
    for i = #self.m_listFishTrace, 1, -1 do
        if self.m_listFishTrace[i] then
            table.remove(self.m_listFishTrace, i)
        end
    end
    self.m_listFishTrace = {}

    for i = 1, Fishlk_CMD.GamePlayer_4 do
        self.m_fishMgr.m_FishLock[i] = nil
        self:HideLock(i - 1)
    end

    local pMove = cc.MoveTo:create(4.5, cc.p(self.visibleSize.width / 2, self.visibleSize.height / 2))
    local funcall = nil

    MusicManager.stopBGM()
    local szstr = string.format("tollgate/bg%02d.jpg", 1)
    local m_music_bg = getRes("music/bgm1.mp3")
    if value.scene_kind == Fishlk_CMD.SceneKind.SCENE_KIND_1 then
        funcall = cc.CallFunc:create(handler(self, self.scene1))
        szstr = string.format("tollgate/bg%02d.jpg", 2)
        m_music_bg = getRes("music/bgm1.mp3")
    end
    if value.scene_kind == Fishlk_CMD.SceneKind.SCENE_KIND_2 then
        funcall = cc.CallFunc:create(handler(self, self.scene2))
        szstr = string.format("tollgate/bg%02d.jpg", 3)
        m_music_bg = getRes("music/bgm2.mp3")
    end
    if value.scene_kind == Fishlk_CMD.SceneKind.SCENE_KIND_3 then
        funcall = cc.CallFunc:create(handler(self, self.scene3))
        szstr = string.format("tollgate/bg%02d.jpg", 4)
        m_music_bg = getRes("music/bgm1.mp3")
    end
    if value.scene_kind == Fishlk_CMD.SceneKind.SCENE_KIND_4 then
        funcall = cc.CallFunc:create(handler(self, self.scene4))
        szstr = string.format("tollgate/bg%02d.jpg", 5)
        m_music_bg = getRes("music/bgm2.mp3")
    end
    if value.scene_kind == Fishlk_CMD.SceneKind.SCENE_KIND_5 then
        funcall = cc.CallFunc:create(handler(self, self.scene5))
        szstr = string.format("tollgate/bg%02d.jpg", 6)
        m_music_bg = getRes("music/bgm1.mp3")
    end

    MusicManager.playBGM(m_music_bg)
    self.m_sceneTexture = cc.TextureCache:getInstance():addImage(getRes(szstr))

    local seq = cc.Sequence:create(pMove, funcall)
    seq:setTag(10)
    local pMoveSp = cc.Sprite:createWithTexture(self.m_sceneTexture, cc.rect(0, 0, self.m_sceneTexture:getContentSize().width, self.m_sceneTexture:getContentSize().height))
    pMoveSp:setScaleX(self.visibleSize.width / pMoveSp:getContentSize().width)
    pMoveSp:setScaleY(self.visibleSize.height / pMoveSp:getContentSize().height)
    pMoveSp:setPosition(cc.p(self.visibleSize.width + pMoveSp:getContentSize().width / 2, self.visibleSize.height / 2))
    pMoveSp:setZOrder(1)
    self.m_bulletLayer:addChild(pMoveSp)
    pMoveSp:runAction(seq)
    pMoveSp:getActionByTag(10):step(0)
    pMoveSp:getActionByTag(10):step(temp_time)

    local ppwaveTexture = cc.TextureCache:getInstance():addImage(getRes("tollgate/wave.png"))
    local pwave = cc.Sprite:createWithTexture(ppwaveTexture, cc.rect(0, 0, ppwaveTexture:getContentSize().width / 2, ppwaveTexture:getContentSize().height))
    pwave:setScaleX(self.visibleSize.height / pwave:getContentSize().height)
    pwave:setScaleY(self.visibleSize.height / pwave:getContentSize().height)
    pwave:setAnchorPoint(display.LEFT_CENTER)
    pwave:setPosition(cc.p(-40, pMoveSp:getContentSize().height / 2))
    pMoveSp:addChild(pwave)

    local animation = cc.Animation:create()
    for i = 1, 2 do
        local framName = cc.SpriteFrame:createWithTexture(ppwaveTexture, cc.rect((i - 1) * ppwaveTexture:getContentSize().width / 2, 0, ppwaveTexture:getContentSize().width / 2,
            ppwaveTexture:getContentSize().height))
        animation:addSpriteFrame(framName)
    end
    animation:setDelayPerUnit(0.25)
    local animate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(animate)
    pwave:runAction(repeatForever)

    MusicManager.playEffect(getRes("music/wave.mp3"))
end

-- 场景结束
function FISHLKScene:OnSocketSceneEnd()
end
-- 大转盘
function FISHLKScene:OnSocketTreasureBoxResult(data)
    -- 获取数据
    local value = FishMessage.CMD_S_TreasureBoxResult(data)

    ---添加鱼币
    if value.fish_score > 0 then
        -- 添加筹码
        -- self:addFishChipScore(value.chair_id, value.fish_score)

        self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.fish_score

        -- 添加分数
        local pFishScore = self:FindFishScore(value.chair_id)
        local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
        pFishScore:setString(szFishScore)
    end
    if value.chair_id == globalUserInfo.wChairID then
        self.m_isFire = true
    end
end
-- 抢李逵结果
function FISHLKScene:OnSubGrabLK(data)
    -- 获取数据
    local value = FishMessage.CMD_S_GrabLKResult(data)

    -- 添加鱼币
    if value.fish_score > 0 then
        -- 添加筹码
        -- self:addFishChipScore(value.chair_id, value.fish_score)
    end

    self.m_UsetItemFishScore.fish_score[value.chair_id + 1] = self.m_UsetItemFishScore.fish_score[value.chair_id + 1] + value.fish_score
    -- 添加分数
    local pFishScore = self:FindFishScore(value.chair_id)
    local szFishScore = tostring(self.m_UsetItemFishScore.fish_score[value.chair_id + 1])
    pFishScore:setString(szFishScore)

    if value.fish_score > 0 then
        -- 坐标系数转换
        local pArms = self:FindArms(value.chair_id)
        local userPos = cc.pSub(pArms:getParent():convertToWorldSpace(cc.p(pArms:getPosition())), self.origin)
        for wChair = 1, Fishlk_CMD.GamePlayer_4 do
            while true do
                if value.user_Grab_Lkdr_Lose_[wChair] <= 0 then
                    break
                end
                -- 金币数量索引
                local index = 0
                if value.user_Grab_Lkdr_Lose_[wChair] > 0 and value.user_Grab_Lkdr_Lose_[wChair] < 100 then
                    index = 2
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 100 and value.user_Grab_Lkdr_Lose_[wChair] < 1000 then
                    index = 3
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 1000 and value.user_Grab_Lkdr_Lose_[wChair] < 10000 then
                    index = 4
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 10000 and value.user_Grab_Lkdr_Lose_[wChair] < 100000 then
                    index = 5
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 100000 and value.user_Grab_Lkdr_Lose_[wChair] < 1000000 then
                    index = 8
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 1000000 and value.user_Grab_Lkdr_Lose_[wChair] < 10000000 then
                    index = 10
                end
                if value.user_Grab_Lkdr_Lose_[wChair] >= 10000000 then
                    index = 12
                end

                local pArmsSourse = self:FindArms(wChair - 1)
                local SoursePos = cc.pSub(pArmsSourse:getParent():convertToWorldSpace(cc.p(pArmsSourse:getPosition())), self.origin)

                for i = 1, index do
                    if index == 1 then
                        local sp = self:creatAnimationSprite("coin1_%02d.png", 12)
                        sp:setPosition(SoursePos)
                        sp:setZOrder(10)
                        self.m_ArmsLayer:addChild(sp)

                        local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                        local speed = fDistance / 100.0
                        local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
                        local spCallMoveOver = cc.CallFunc:create(function(args)
                            args:removeFromParent()
                        end)
                        local psq = cc.Sequence:create(pmove, spCallMoveOver)
                        sp:runAction(psq)
                    else
                        local sp = self:creatAnimationSprite("coin1_%02d.png", 12)

                        local countLeft = index / 2

                        sp:setPosition(cc.p(SoursePos.x - sp:getContentSize().width * countLeft + (i - 1) * sp:getContentSize().width, SoursePos.y))
                        sp:setZOrder(10)
                        self.m_ArmsLayer:addChild(sp)

                        local fDistance = MathAide.CalcDistance(sp:getPositionX(), sp:getPositionY(), userPos.x, userPos.y)
                        local speed = fDistance / 100.0
                        local pmove = cc.MoveTo:create(speed / 100.0 * 30.0, userPos)
                        local spCallMoveOver = cc.CallFunc:create(function(args)
                            args:removeFromParent()
                        end)
                        local psq = cc.Sequence:create(pmove, spCallMoveOver)
                        sp:runAction(psq)
                    end
                end
            end

        end
    end
    return true
end
-- 场景切换1
function FISHLKScene:scene1(sender)
    self.m_isFire = true
    self.m_bSwitchScene = false
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.m_pbg:setTexture(self.m_sceneTexture)
    sender:removeFromParent()
    if (self.m_SwitchScene.fish_count <= 0) then
        return
    end

    --[[切换场景
    struct CMD_S_SwitchScene
    {
	    SceneKind scene_kind
	    int fish_count
	    FishKind fish_kind[300]
	    int fish_id[300]
    }--]]
    local cmd = {}

    cmd.scene_kind = self.m_SwitchScene.scene_kind
    cmd.fish_count = self.m_SwitchScene.fish_count
    cmd.fish_kind = {}
    cmd.fish_id = {}
    cmd.nIndex = {}
    cmd.dwLeftTime = {}
    for i = 1, self.m_SwitchScene.fish_count do
        cmd.fish_kind[i] = self.m_SwitchScene.fish_kind[i]
        cmd.fish_id[i] = self.m_SwitchScene.fish_id[i]
        if self.isRefresh == true then
            cmd.nIndex[i] = self.m_SwitchScene.nIndex[i]
            cmd.dwLeftTime[i] = self.m_SwitchScene.dwLeftTime[i]
        end
    end
    self.m_SwitchScene.fish_count = 0

    local fishList1 = {}
    local fishList2 = {}
    local fishList3 = {}
    local fishList4 = {}
    local fishList5 = {}
    local fishList6 = {}
    local fishList7 = {}
    local nIndexList1 = {}
    local nIndexList2 = {}
    local nIndexList3 = {}
    local nIndexList4 = {}
    local nIndexList5 = {}
    local nIndexList6 = {}
    local nIndexList7 = {}

    for i = cmd.fish_count, 1, -1 do
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_1 then
            table.insert(fishList1, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList1, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_2 then
            table.insert(fishList2, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList2, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_3 then
            table.insert(fishList3, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList3, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_4 then
            table.insert(fishList4, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList4, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_5 then
            table.insert(fishList5, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList5, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_6 then
            table.insert(fishList6, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList6, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_20 then
            table.insert(fishList7, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList7, cmd.nIndex[i])
            end
        end
    end

    local pCorePos = cc.p(self.visibleSize.width + self.visibleSize.height / 3, self.visibleSize.height / 2)

    local fDistance = cc.pGetDistance(pCorePos, cc.p(-(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), self.visibleSize.height / 2))
    local speed = fDistance * 0.0005

    local posList1 = {}
    posList1 = MathAide.BuildCircle(pCorePos.x, pCorePos.y, self.visibleSize.height / 3, posList1, 100)
    local posList11 = {}
    for i = 1, 100 do
        table.insert(posList11, posList1[i])
    end
    self:createFishScene(false, 0, nIndexList1, cmd.dwLeftTime, fishList1, Fishlk_CMD.FishKind.FISH_KIND_1, posList11,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList2 = {}
    posList2 = MathAide.BuildCircle(pCorePos.x - self.visibleSize.height / 3 / 3, pCorePos.y - self.visibleSize.height / 3 / 3, self.visibleSize.height / 3 / 3, posList2, 30)
    local posList22 = {}
    for i = 1, 30 do
        table.insert(posList22, posList2[i])
    end
    self:createFishScene(false, 134, nIndexList2, cmd.dwLeftTime, fishList2, Fishlk_CMD.FishKind.FISH_KIND_2, posList22,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList3 = {}
    posList3 = MathAide.BuildCircle(pCorePos.x - self.visibleSize.height / 3 / 3, pCorePos.y + self.visibleSize.height / 3 / 3, self.visibleSize.height / 3 / 3, posList3, 17)
    local posList33 = {}
    for i = 1, 17 do
        table.insert(posList33, posList3[i])
    end
    self:createFishScene(false, 100, nIndexList3, cmd.dwLeftTime, fishList3, Fishlk_CMD.FishKind.FISH_KIND_3, posList33,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList4 = {}
    posList4 = MathAide.BuildCircle(pCorePos.x + self.visibleSize.height / 3 / 3, pCorePos.y - self.visibleSize.height / 3 / 3, self.visibleSize.height / 3 / 3, posList4, 30)
    local posList44 = {}
    for i = 1, 30 do
        table.insert(posList44, posList4[i])
    end
    self:createFishScene(false, 164, nIndexList4, cmd.dwLeftTime, fishList4, Fishlk_CMD.FishKind.FISH_KIND_4, posList44,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList5 = {}
    posList5 = MathAide.BuildCircle(pCorePos.x + self.visibleSize.height / 3 / 3, pCorePos.y + self.visibleSize.height / 3 / 3, self.visibleSize.height / 3 / 3, posList5, 17)
    local posList55 = {}
    for i = 1, 17 do
        table.insert(posList55, posList5[i])
    end
    self:createFishScene(false, 117, nIndexList5, cmd.dwLeftTime, fishList5, Fishlk_CMD.FishKind.FISH_KIND_5, posList55,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList6 = {}
    posList6 = MathAide.BuildCircle(pCorePos.x, pCorePos.y, self.visibleSize.height / 3 / 3, posList6, 15)
    local posList66 = {}
    for i = 1, 15 do
        table.insert(posList66, posList6[i])
    end
    self:createFishScene(false, 194, nIndexList6, cmd.dwLeftTime, fishList6, Fishlk_CMD.FishKind.FISH_KIND_6, posList66,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posList77 = {}
    local point20 = {}
    point20.x = pCorePos.x
    point20.y = pCorePos.y
    table.insert(posList77, point20)
    self:createFishScene(false, 209, nIndexList7, cmd.dwLeftTime, fishList7, Fishlk_CMD.FishKind.FISH_KIND_20, posList77,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)
end

-- 创建场景鱼
function FISHLKScene:createFishScene(isLeft, first_nIndex, nIndexList, dwLeftTime, fishList, fish_kind, posList, distance, speed)
    if #fishList < 1 then
        return
    end
    for i = 1, #fishList do
        local fishTrace = {}
        fishTrace.init_pos = {}
        local temp_init_pos1 = {}
        local temp_distance = 0
        local index = i
        if self.isRefresh == true then
            temp_distance = dwLeftTime[1] / 1000 / (distance / speed / 18) * distance
            index = #posList - (nIndexList[i] - first_nIndex) + 1
        end
        if isLeft == true then
            temp_init_pos1.x = posList[index].x + temp_distance
        else
            temp_init_pos1.x = posList[index].x - temp_distance
        end
        temp_init_pos1.y = posList[index].y
        table.insert(fishTrace.init_pos, temp_init_pos1)
        local temp_init_pos2 = {}
        temp_init_pos2.x = temp_init_pos1.x + distance
        temp_init_pos2.y = posList[index].y
        table.insert(fishTrace.init_pos, temp_init_pos2)

        fishTrace.init_count = 2
        fishTrace.fish_kind = fish_kind
        fishTrace.fish_id = fishList[i]
        fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

        local x = {}
        local y = {}
        for j = 1, fishTrace.init_count do
            x[j] = fishTrace.init_pos[j].x
            y[j] = fishTrace.init_pos[j].y
        end

        -- 鱼路径点
        local trace_vector = {}
        -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
        table.insert(trace_vector, temp_init_pos1)
        table.insert(trace_vector, temp_init_pos2)
        trace_vector.fSpeed = speed

        -- 创建鱼
        local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
        local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
        pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

        if fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_20 then
            pFish:setTag(100)
            pFish:setRotation(0)
        end

        self.m_fishMgr:AddSceneFish(pFish)
        self.m_fishLayer:addChild(pFish)
    end
end

-- 场景切换2
function FISHLKScene:scene2(sender)
    self.m_isFire = true
    self.m_bSwitchScene = false
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.m_SceneFish = 0.0
    self.m_pbg:setTexture(self.m_sceneTexture)
    sender:removeFromParent()

    if self.m_SwitchScene.fish_count <= 0 then
        return
    end

    local cmd = {}
    cmd.scene_kind = self.m_SwitchScene.scene_kind
    cmd.fish_count = self.m_SwitchScene.fish_count
    cmd.fish_kind = {}
    cmd.fish_id = {}
    cmd.nIndex = {}
    cmd.dwLeftTime = {}
    for i = 1, self.m_SwitchScene.fish_count do
        cmd.fish_kind[i] = self.m_SwitchScene.fish_kind[i]
        cmd.fish_id[i] = self.m_SwitchScene.fish_id[i]
        if self.isRefresh == true then
            cmd.nIndex[i] = self.m_SwitchScene.nIndex[i]
            cmd.dwLeftTime[i] = self.m_SwitchScene.dwLeftTime[i]
        end
    end
    self.m_SwitchScene.fish_count = 0

    local fishList1 = {}
    local fishList2 = {}
    local fishList3 = {}
    local fishList4 = {}
    local fishList5 = {}
    local fishList6 = {}
    local fishList7 = {}
    local fishList8 = {}
    local nIndexList1_up = {}
    local nIndexList1_down = {}
    local nIndexList2 = {}
    local nIndexList3 = {}
    local nIndexList4 = {}
    local nIndexList5 = {}
    local nIndexList6 = {}
    local nIndexList7 = {}
    local nIndexList8 = {}

    for i = cmd.fish_count, 1, -1 do
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_2 then
            table.insert(fishList1, cmd.fish_id[i])
            if self.isRefresh == true then
                if cmd.nIndex[i] <= 100 then
                    table.insert(nIndexList1_up, cmd.nIndex[i])
                else
                    table.insert(nIndexList1_down, cmd.nIndex[i])
                end

            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_12 then
            table.insert(fishList2, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList2, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_13 then
            table.insert(fishList3, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList3, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_14 then
            table.insert(fishList4, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList4, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_15 then
            table.insert(fishList5, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList5, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_16 then
            table.insert(fishList6, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList6, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_17 then
            table.insert(fishList7, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList7, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_18 then
            table.insert(fishList8, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList8, cmd.nIndex[i])
            end
        end
    end

    local fishList1_1 = {}
    local fishList1_2 = {}
    local up_fish = 101
    local up_fish_B = 200
    if self.isRefresh == true then
        up_fish = #nIndexList1_down + 1
        up_fish_B = #fishList1
    end
    if up_fish_B > 0 then
        for i = up_fish, up_fish_B do
            table.insert(fishList1_1, fishList1[i])
        end
    end

    local down_fish = 1
    local down_fish_B = 100
    if self.isRefresh == true then
        down_fish = 1
        down_fish_B = #nIndexList1_down
    end
    if down_fish_B > 0 then
        for i = down_fish, down_fish_B do
            table.insert(fishList1_2, fishList1[i])
        end
    end

    -- 小鱼间距
    local fspacingW = self.visibleSize.width / (#fishList1 / 2)

    -- 创建鱼
    -- 上方
    for i = 1, #fishList1_1 do
        local fishTrace = {}
        fishTrace.init_pos = {}
        local temp_init_pos1 = {}
        local temp_distance = self.visibleSize.height + 100
        local index = i
        if self.isRefresh == true then
            index = 100 - nIndexList1_up[i] + 1
            if cmd.dwLeftTime[1] / 1000 < 25 then
                temp_distance = self.visibleSize.height + 100 - (cmd.dwLeftTime[1] / 1000) * (2 * 18)
                if temp_distance < self.visibleSize.height - 150 then
                    temp_distance = self.visibleSize.height - 150
                end
                self.m_SceneFish = cmd.dwLeftTime[1] / 1000
            elseif cmd.dwLeftTime[1] / 1000 >= 25 then
                -- math.randomseed(GameUtil.getSystemTime())
                -- local ff = 2--math.random(0,100)/100 * 1.0 + 1.5
                temp_distance = self.visibleSize.height - 150 - ((cmd.dwLeftTime[1] / 1000) - 25) * (2 * 18)
                self.m_SceneFish = cmd.dwLeftTime[1] / 1000
            end
        end
        temp_init_pos1.x = (index - 1) * fspacingW
        temp_init_pos1.y = temp_distance
        table.insert(fishTrace.init_pos, temp_init_pos1)
        local temp_init_pos2 = {}
        temp_init_pos2.x = temp_init_pos1.x
        temp_init_pos2.y = -100
        table.insert(fishTrace.init_pos, temp_init_pos2)

        fishTrace.init_count = 2
        fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_2
        fishTrace.fish_id = fishList1_1[i]
        fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

        local x = {}
        local y = {}
        for j = 1, fishTrace.init_count do
            x[j] = fishTrace.init_pos[j].x
            y[j] = fishTrace.init_pos[j].y
        end

        -- 鱼路径点
        local trace_vector = {}

        -- 1.5 - 2.5之间的数
        -- math.randomseed(GameUtil.getSystemTime())
        local ff = 2 -- math.random(0,100)/100 * 1.0 + 1.5
        -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, ff)
        table.insert(trace_vector, temp_init_pos1)
        table.insert(trace_vector, temp_init_pos2)
        trace_vector.fSpeed = ff
        -- 创建鱼
        local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
        local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
        pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))
        pFish:setTag(201)

        self.m_fishMgr:AddSceneFish(pFish)
        self.m_fishLayer:addChild(pFish)
    end

    -- 下方
    for i = 1, #fishList1_2 do
        local fishTrace = {}
        fishTrace.init_pos = {}
        local temp_init_pos1 = {}
        local temp_distance = -100
        local index = i
        if self.isRefresh == true then
            index = 200 - nIndexList1_down[i] + 1
            if cmd.dwLeftTime[1] / 1000 < 25 then
                temp_distance = -100 + (cmd.dwLeftTime[1] / 1000) * (2 * 18)
                if temp_distance > 150 then
                    temp_distance = 150
                end
                self.m_SceneFish = cmd.dwLeftTime[1] / 1000
            elseif cmd.dwLeftTime[1] / 1000 >= 25 then
                -- math.randomseed(GameUtil.getSystemTime())
                local ff = 2 -- math.random(0,100)/100 * 1.0 + 1.5
                temp_distance = 150 + ((cmd.dwLeftTime[1] / 1000) - 25) * (ff * 18)
                self.m_SceneFish = cmd.dwLeftTime[1] / 1000
            end
        end
        temp_init_pos1.x = (index - 1) * fspacingW
        temp_init_pos1.y = temp_distance
        table.insert(fishTrace.init_pos, temp_init_pos1)

        local temp_init_pos2 = {}
        temp_init_pos2.x = temp_init_pos1.x
        temp_init_pos2.y = self.visibleSize.height + 100
        table.insert(fishTrace.init_pos, temp_init_pos2)

        fishTrace.init_count = 2
        fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_2
        fishTrace.fish_id = fishList1_2[i]
        fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

        local x = {}
        local y = {}
        for j = 1, fishTrace.init_count do
            x[j] = fishTrace.init_pos[j].x
            y[j] = fishTrace.init_pos[j].y
        end

        -- 鱼路径点
        local trace_vector = {}

        -- 1.5 - 2.5之间的数
        -- math.randomseed(GameUtil.getSystemTime())
        local ff = 2 -- math.random(0,100)/100 * 1.0 + 1.5
        -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, ff)
        table.insert(trace_vector, temp_init_pos1)
        table.insert(trace_vector, temp_init_pos2)
        trace_vector.fSpeed = ff
        -- 创建鱼
        local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
        local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
        pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))
        pFish:setTag(202)
        self.m_fishMgr:AddSceneFish(pFish)
        self.m_fishLayer:addChild(pFish)
    end

    local fLeftX = {}
    local fRightX = {}

    local nJianJu = 300

    for i = 1, 7 do
        fLeftX[i] = (-450) - (i - 1) * nJianJu
        fRightX[i] = (self.visibleSize.width + 450) + (i - 1) * nJianJu
    end

    local speed = cc.pGetDistance(cc.p(fLeftX[1], self.visibleSize.height / 2 + self.visibleSize.height / 6),
        cc.p(fLeftX[1] + (self.visibleSize.width + 450) + 7 * nJianJu, self.visibleSize.height / 2 + self.visibleSize.height / 6)) * 0.001
    local count_fishList2 = 2
    if self.isRefresh == true then
        count_fishList2 = #nIndexList2
    end
    if count_fishList2 > 0 then
        for i = 1, count_fishList2 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList2[i] - 207
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[1] - temp_distance
                temp_init_pos2.x = fRightX[1] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[1] + temp_distance
                temp_init_pos2.x = fLeftX[1] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_12
            fishTrace.fish_id = fishList2[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end
            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList3 = 2
    if self.isRefresh == true then
        count_fishList3 = #nIndexList3
    end
    if count_fishList3 > 0 then
        for i = 1, count_fishList3 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList3[i] - 208
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[2] - temp_distance
                temp_init_pos2.x = fRightX[2] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[2] + temp_distance
                temp_init_pos2.x = fLeftX[2] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_13
            fishTrace.fish_id = fishList3[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList4 = 2
    if self.isRefresh == true then
        count_fishList4 = #nIndexList4
    end
    if count_fishList4 > 0 then
        for i = 1, count_fishList4 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList4[i] - 209
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[3] - temp_distance
                temp_init_pos2.x = fRightX[3] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[3] + temp_distance
                temp_init_pos2.x = fLeftX[3] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_14
            fishTrace.fish_id = fishList4[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList5 = 2
    if self.isRefresh == true then
        count_fishList5 = #nIndexList5
    end
    if count_fishList5 > 0 then
        for i = 1, count_fishList5 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList5[i] - 210
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[4] - temp_distance
                temp_init_pos2.x = fRightX[4] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[4] + temp_distance
                temp_init_pos2.x = fLeftX[4] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_15
            fishTrace.fish_id = fishList5[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList6 = 2
    if self.isRefresh == true then
        count_fishList6 = #nIndexList6
    end
    if count_fishList6 > 0 then
        for i = 1, count_fishList6 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList6[i] - 211
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[5] - temp_distance
                temp_init_pos2.x = fRightX[5] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[5] + temp_distance
                temp_init_pos2.x = fLeftX[5] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_16
            fishTrace.fish_id = fishList6[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList7 = 2
    if self.isRefresh == true then
        count_fishList7 = #nIndexList7
    end
    if count_fishList7 > 0 then
        for i = 1, count_fishList7 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList7[i] - 212
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[6] - temp_distance
                temp_init_pos2.x = fRightX[6] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[6] + temp_distance
                temp_init_pos2.x = fLeftX[6] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_17
            fishTrace.fish_id = fishList7[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local count_fishList8 = 2
    if self.isRefresh == true then
        count_fishList8 = #nIndexList8
    end
    if count_fishList8 > 0 then
        for i = 1, count_fishList8 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = nIndexList8[i] - 213
                temp_distance = cmd.dwLeftTime[1] / 1000 * 18 * speed
            end
            if index == 1 then
                temp_init_pos1.x = fRightX[7] - temp_distance
                temp_init_pos2.x = fRightX[7] - (self.visibleSize.width + 450) - 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 - self.visibleSize.height / 6
            else
                temp_init_pos1.x = fLeftX[7] + temp_distance
                temp_init_pos2.x = fLeftX[7] + (self.visibleSize.width + 450) + 7 * nJianJu
                temp_init_pos1.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
                temp_init_pos2.y = self.visibleSize.height / 2 + self.visibleSize.height / 6
            end
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_18
            fishTrace.fish_id = fishList8[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    self.UpDateScene2ScheduleID = nil
    self.UpDateScene2ScheduleID = self.scheduler:scheduleScriptFunc(function(dt)
        self:UpDateScene2(dt)
    end, 0, false)
    table.insert(self.table_scheduleID, self.UpDateScene2ScheduleID)
end

-- 场景2鱼刷新
function FISHLKScene:UpDateScene2(dt)
    for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
        -- 上
        if fish:getTag() == 201 then
            if fish:getPos().y <= self.visibleSize.height - 150 then
                fish:stop()
            end
        end

        -- 下
        if fish:getTag() == 202 then
            if fish:getPos().y >= 150 then
                fish:stop()
            end
        end
    end

    self.m_SceneFish = self.m_SceneFish + dt

    if self.m_SceneFish > 25.0 then
        self.m_SceneFish = 0.0
        if self.UpDateScene2ScheduleID then
            self.scheduler:unscheduleScriptEntry(self.UpDateScene2ScheduleID)
            for i, value in ipairs(self.table_scheduleID) do
                if value == self.UpDateScene2ScheduleID then
                    table.remove(self.table_scheduleID, i)
                end
            end
            self.UpDateScene2ScheduleID = nil
        end

        for i, fish in ipairs(self.m_fishMgr:GetFishList()) do
            if fish:getTag() == 201 or fish:getTag() == 202 then
                fish:active()
            end
        end
    end
end

-- 场景切换3
function FISHLKScene:scene3(sender)
    self.m_isFire = true
    self.m_bSwitchScene = false
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.m_pbg:setTexture(self.m_sceneTexture)
    sender:removeFromParent()
    if (self.m_SwitchScene.fish_count <= 0) then
        return
    end

    local cmd = {}

    cmd.scene_kind = self.m_SwitchScene.scene_kind
    cmd.fish_count = self.m_SwitchScene.fish_count
    cmd.fish_kind = {}
    cmd.fish_id = {}
    cmd.nIndex = {}
    cmd.dwLeftTime = {}
    for i = 1, self.m_SwitchScene.fish_count do
        cmd.fish_kind[i] = self.m_SwitchScene.fish_kind[i]
        cmd.fish_id[i] = self.m_SwitchScene.fish_id[i]
        if self.isRefresh == true then
            cmd.nIndex[i] = self.m_SwitchScene.nIndex[i]
            cmd.dwLeftTime[i] = self.m_SwitchScene.dwLeftTime[i]
        end
    end

    self.m_SwitchScene.fish_count = 0

    local fishList1 = {}
    local fishList2 = {}
    local fishList3 = {}
    local fishList4 = {}
    local fishList5 = {}
    local fishList6 = {}
    local fishList7 = {}

    local nIndexList1_R = {}
    local nIndexList1_L = {}
    local nIndexList2 = {}
    local nIndexList3 = {}
    local nIndexList4 = {}
    local nIndexList5 = {}
    local nIndexList6 = {}
    local nIndexList7 = {}

    for i = cmd.fish_count, 1, -1 do
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_1 then
            table.insert(fishList1, cmd.fish_id[i])
            if self.isRefresh == true then
                if cmd.nIndex[i] <= 50 then
                    table.insert(nIndexList1_R, cmd.nIndex[i])
                else
                    table.insert(nIndexList1_L, cmd.nIndex[i])
                end

            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_3 then
            table.insert(fishList2, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList2, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_4 then
            table.insert(fishList3, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList3, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_16 then
            table.insert(fishList4, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList4, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_2 then
            table.insert(fishList5, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList5, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_5 then
            table.insert(fishList6, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList6, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_17 then
            table.insert(fishList7, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList7, cmd.nIndex[i])
            end
        end
    end
    local pRightCorePos = cc.p(self.visibleSize.width + self.visibleSize.height / 3, self.visibleSize.height / 2)

    local speed = cc.pGetDistance(pRightCorePos, cc.p(pRightCorePos.x - self.visibleSize.width - self.visibleSize.height / 3 * 2 - self.visibleSize.width / 2, pRightCorePos.y)) * 0.00075

    local posRight1 = {}
    posRight1 = MathAide.BuildCircle(pRightCorePos.x, pRightCorePos.y, self.visibleSize.height / 3, posRight1, 50)
    -- 0号鱼50条，2号鱼40条，3号鱼30条，15号鱼1条
    -- 0号鱼50条，1号鱼40条，4号鱼30条，16号鱼1条 
    local R_count = 51
    local R_count_B = 100
    if self.isRefresh == true then
        R_count = #nIndexList1_L + 1
        R_count_B = #fishList1
    end
    if R_count_B > 0 then
        for i = R_count, R_count_B do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i - R_count + 1
            local temp_distance = 0
            if self.isRefresh == true then
                index = #posRight1 - nIndexList1_R[index] + 1
                temp_distance = cmd.dwLeftTime[1] / 1000 * (speed * 18)
            end
            temp_init_pos1.x = posRight1[index].x - temp_distance
            temp_init_pos1.y = posRight1[index].y

            temp_init_pos2.x = temp_init_pos1.x - self.visibleSize.width - self.visibleSize.height / 3 * 2 - self.visibleSize.width / 2
            temp_init_pos2.y = posRight1[index].y
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_1
            fishTrace.fish_id = fishList1[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end
            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end
    local posRight2 = {}
    posRight2 = MathAide.BuildCircle(pRightCorePos.x, pRightCorePos.y, self.visibleSize.height / 3 - 40, posRight2, 40)
    local posRightList2 = {}
    for i = 1, 40 do
        table.insert(posRightList2, posRight2[i])
    end
    self:createFishScene(false, 50, nIndexList2, cmd.dwLeftTime, fishList2, Fishlk_CMD.FishKind.FISH_KIND_3, posRightList2,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posRight3 = {}
    posRight3 = MathAide.BuildCircle(pRightCorePos.x, pRightCorePos.y, self.visibleSize.height / 3 - 80, posRight3, 30)
    local posRightList3 = {}
    for i = 1, 30 do
        table.insert(posRightList3, posRight3[i])
    end
    self:createFishScene(false, 90, nIndexList3, cmd.dwLeftTime, fishList3, Fishlk_CMD.FishKind.FISH_KIND_4, posRightList3,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local posRightList4 = {}
    local point16 = {}
    point16.x = pRightCorePos.x
    point16.y = pRightCorePos.y
    table.insert(posRightList4, point16)
    self:createFishScene(false, 120, nIndexList4, cmd.dwLeftTime, fishList4, Fishlk_CMD.FishKind.FISH_KIND_16, posRightList4,
        -(self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2), speed)

    local pLeftCorePos = cc.p(-self.visibleSize.height / 3, self.visibleSize.height / 2)
    local posLeft1 = {}
    posLeft1 = MathAide.BuildCircle(pLeftCorePos.x, pLeftCorePos.y, self.visibleSize.height / 3, posLeft1, 50)
    local L_count = 1
    local L_count_B = 50
    if self.isRefresh == true then
        L_count = 1
        L_count_B = #nIndexList1_L
    end
    if L_count_B > 0 then
        for i = L_count, L_count_B do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local temp_distance = 0
            if self.isRefresh == true then
                index = #posLeft1 - (nIndexList1_L[i] - 121) + 1
                temp_distance = cmd.dwLeftTime[1] / 1000 * (speed * 18)
            end
            temp_init_pos1.x = posLeft1[index].x + temp_distance
            temp_init_pos1.y = posLeft1[index].y

            temp_init_pos2.x = temp_init_pos1.x + self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2
            temp_init_pos2.y = posLeft1[index].y
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_1
            fishTrace.fish_id = fishList1[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            -- 鱼路径点
            local trace_vector = {}
            -- trace_vector = MathAide.BuildLinear(x, y, fishTrace.init_count, trace_vector, speed)
            table.insert(trace_vector, temp_init_pos1)
            table.insert(trace_vector, temp_init_pos2)
            trace_vector.fSpeed = speed
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, trace_vector, self)
            pFish:setPosition(cc.p(trace_vector[1].x, trace_vector[1].y))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end
    local posLeft2 = {}
    posLeft2 = MathAide.BuildCircle(pLeftCorePos.x, pLeftCorePos.y, self.visibleSize.height / 3 - 40, posLeft2, 40)
    local posleftList2 = {}
    for i = 1, 40 do
        table.insert(posleftList2, posLeft2[i])
    end
    self:createFishScene(true, 171, nIndexList5, cmd.dwLeftTime, fishList5, Fishlk_CMD.FishKind.FISH_KIND_2, posleftList2,
        self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2, speed)

    local posLeft3 = {}
    posLeft3 = MathAide.BuildCircle(pLeftCorePos.x, pLeftCorePos.y, self.visibleSize.height / 3 - 80, posLeft3, 30)
    local posleftList3 = {}
    for i = 1, 30 do
        table.insert(posleftList3, posLeft3[i])
    end
    self:createFishScene(true, 211, nIndexList6, cmd.dwLeftTime, fishList6, Fishlk_CMD.FishKind.FISH_KIND_5, posleftList3,
        self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2, speed)

    local posLeftList4 = {}
    local point17 = {}
    point17.x = pLeftCorePos.x
    point17.y = pLeftCorePos.y
    table.insert(posLeftList4, point17)
    self:createFishScene(true, 241, nIndexList7, cmd.dwLeftTime, fishList7, Fishlk_CMD.FishKind.FISH_KIND_17, posLeftList4,
        self.visibleSize.width + self.visibleSize.height / 3 * 2 + self.visibleSize.width / 2, speed)
end

-- 场景切换4
function FISHLKScene:scene4(sender)
    self.m_isFire = true
    self.m_bSwitchScene = false
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.m_pbg:setTexture(self.m_sceneTexture)
    sender:removeFromParent()
    if (self.m_SwitchScene.fish_count <= 0) then
        return
    end

    local cmd = {}

    cmd.scene_kind = self.m_SwitchScene.scene_kind
    cmd.fish_count = self.m_SwitchScene.fish_count
    cmd.fish_kind = {}
    cmd.fish_id = {}
    cmd.nIndex = {}
    cmd.dwLeftTime = {}
    for i = 1, self.m_SwitchScene.fish_count do
        cmd.fish_kind[i] = self.m_SwitchScene.fish_kind[i]
        cmd.fish_id[i] = self.m_SwitchScene.fish_id[i]
        if self.isRefresh == true then
            cmd.nIndex[i] = self.m_SwitchScene.nIndex[i]
            cmd.dwLeftTime[i] = self.m_SwitchScene.dwLeftTime[i]
        end
    end
    self.m_SwitchScene.fish_count = 0

    local fishList1 = {}
    local fishList2 = {}
    local fishList3 = {}
    local fishList4 = {}
    local fishList5 = {}
    local fishList6 = {}
    local fishList7 = {}
    local fishList8 = {}
    local nIndexList1 = {}
    local nIndexList2 = {}
    local nIndexList3 = {}
    local nIndexList4 = {}
    local nIndexList5 = {}
    local nIndexList6 = {}
    local nIndexList7 = {}
    local nIndexList8 = {}

    for i = 1, cmd.fish_count do
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_11 then
            table.insert(fishList1, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList1, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_12 then
            table.insert(fishList2, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList2, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_13 then
            table.insert(fishList3, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList3, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_14 then
            table.insert(fishList4, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList4, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_15 then
            table.insert(fishList5, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList5, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_16 then
            table.insert(fishList6, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList6, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_17 then
            table.insert(fishList7, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList7, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_18 then
            table.insert(fishList8, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList8, cmd.nIndex[i])
            end
        end
    end

    -- 横向系数
    local f = self.visibleSize.width / self.visibleSize.height

    local x = 200 * f
    local y = 200

    -- 左下角
    local leftDown1 = cc.p(-x, 100 - y)
    local leftDown2 = cc.p(100 * f - x, -y)

    -- 左上角
    local leftUp1 = cc.p(100 * f - x, self.visibleSize.height + y)
    local leftUp2 = cc.p(20 * f - x, self.visibleSize.height - 100 + y)

    -- 右下角
    local rightDown1 = cc.p(self.visibleSize.width + x, 100 - y)
    local rightDown2 = cc.p(self.visibleSize.width - 100 * f + x, -y)

    -- 右上角k
    local rightUp1 = cc.p(self.visibleSize.width - 100 * f + x, self.visibleSize.height + y)
    local rightUp2 = cc.p(self.visibleSize.width + x, self.visibleSize.height - 100 + y)

    -- 鱼间距
    local fishDistance = 180

    local distance = cc.pGetDistance(leftDown1, cc.p(leftDown1.x + self.visibleSize.width * 2.5 * f, leftDown1.y + self.visibleSize.width * 2.5))
    local speed = distance * 0.015
    local count_fishList1 = 8
    local count_fishList2 = 8
    local count_fishList3 = 8
    local count_fishList4 = 8
    local count_fishList5 = 8
    local count_fishList6 = 8
    local count_fishList7 = 8
    local count_fishList8 = 8
    if self.isRefresh == true then
        count_fishList1 = #nIndexList1
        count_fishList2 = #nIndexList2
        count_fishList3 = #nIndexList3
        count_fishList4 = #nIndexList4
        count_fishList5 = #nIndexList5
        count_fishList6 = #nIndexList6
        count_fishList7 = #nIndexList7
        count_fishList8 = #nIndexList8
    end
    if count_fishList1 > 0 then
        for i = 1, count_fishList1 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList1[i]
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = leftDown1.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = leftDown1.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = leftDown1.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = leftDown1.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_11
            fishTrace.fish_id = fishList1[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList2 > 0 then
        for i = 1, #fishList2 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList2[i] - 8
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = leftDown2.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = leftDown2.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = leftDown2.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = leftDown2.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_12
            fishTrace.fish_id = fishList2[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList3 > 0 then
        for i = 1, count_fishList3 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList3[i] - 16
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = rightDown2.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = rightDown2.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = rightDown2.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = rightDown2.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_13
            fishTrace.fish_id = fishList3[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList4 > 0 then
        for i = 1, count_fishList4 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList4[i] - 24
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = rightDown1.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = rightDown1.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = rightDown1.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = rightDown1.y - (index - 1) * fishDistance + self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_14
            fishTrace.fish_id = fishList4[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList5 > 0 then
        for i = 1, count_fishList5 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList5[i] - 32
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = rightUp2.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = rightUp2.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = rightUp2.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = rightUp2.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_15
            fishTrace.fish_id = fishList5[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList6 > 0 then
        for i = 1, count_fishList6 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList6[i] - 40
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = rightUp1.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = rightUp1.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = rightUp1.x + (index - 1) * (fishDistance * f) - self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = rightUp1.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_16
            fishTrace.fish_id = fishList6[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList7 > 0 then
        for i = 1, count_fishList7 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList7[i] - 48
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = leftUp1.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = leftUp1.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = leftUp1.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = leftUp1.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_17
            fishTrace.fish_id = fishList7[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    if count_fishList8 > 0 then
        for i = 1, count_fishList8 do
            local fishTrace = {}
            fishTrace.init_pos = {}
            local temp_init_pos1 = {}
            local temp_init_pos2 = {}
            local index = i
            local movePercent = 0
            local temp_speed = 0
            if self.isRefresh == true then
                index = nIndexList8[i] - 56
                movePercent = cmd.dwLeftTime[1] / 1000 / speed
                temp_speed = cmd.dwLeftTime[1] / 1000
            end
            temp_init_pos1.x = leftUp2.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f * movePercent
            temp_init_pos1.y = leftUp2.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5 * movePercent

            temp_init_pos2.x = leftUp2.x - (index - 1) * (fishDistance * f) + self.visibleSize.width * 2.5 * f
            temp_init_pos2.y = leftUp2.y + (index - 1) * fishDistance - self.visibleSize.width * 2.5
            table.insert(fishTrace.init_pos, temp_init_pos1)
            table.insert(fishTrace.init_pos, temp_init_pos2)
            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_18
            fishTrace.fish_id = fishList8[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local x = {}
            local y = {}
            for j = 1, fishTrace.init_count do
                x[j] = fishTrace.init_pos[j].x
                y[j] = fishTrace.init_pos[j].y
            end

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))

            local pmove = cc.MoveTo:create(speed - temp_speed, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
            local psq = cc.Sequence:create(pmove, funcall)
            pFish:runAction(psq)

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end
end

-- 场景切换5
function FISHLKScene:scene5(sender)
    self.m_isFire = true
    self.m_bSwitchScene = false
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.m_pbg:setTexture(self.m_sceneTexture)
    sender:removeFromParent()
    if (self.m_SwitchScene.fish_count <= 0) then
        return
    end

    local cmd = {}

    cmd.scene_kind = self.m_SwitchScene.scene_kind
    cmd.fish_count = self.m_SwitchScene.fish_count
    cmd.fish_kind = {}
    cmd.fish_id = {}
    cmd.nIndex = {}
    cmd.dwLeftTime = {}
    for i = 1, self.m_SwitchScene.fish_count do
        cmd.fish_kind[i] = self.m_SwitchScene.fish_kind[i]
        cmd.fish_id[i] = self.m_SwitchScene.fish_id[i]
        if self.isRefresh == true then
            cmd.nIndex[i] = self.m_SwitchScene.nIndex[i]
            cmd.dwLeftTime[i] = self.m_SwitchScene.dwLeftTime[i]
        end
    end
    self.m_SwitchScene.fish_count = 0
    local fishList1 = {}
    local fishList2 = {}
    local fishList3 = {}
    local fishList4 = {}
    local fishList5 = {}
    local fishList6 = {}
    local fishList7 = {}
    local fishList8 = {}
    local fishList9 = {}
    local nIndexList1 = {}
    local nIndexList2 = {}
    local nIndexList3 = {}
    local nIndexList4 = {}
    local nIndexList5 = {}
    local nIndexList6 = {}
    local nIndexList7 = {}
    local nIndexList8 = {}
    local nIndexList9 = {}

    local fishList6_1 = {}
    local fishList6_2 = {}
    local nIndexList6_1 = {}
    local nIndexList6_2 = {}

    for i = cmd.fish_count, 1, -1 do
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_1 then
            table.insert(fishList1, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList1, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_2 then
            table.insert(fishList2, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList2, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_3 then
            table.insert(fishList3, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList3, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_5 then
            table.insert(fishList4, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList4, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_4 then
            table.insert(fishList5, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList5, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_6 then
            table.insert(fishList6, cmd.fish_id[i])
            if self.isRefresh == true then
                if cmd.nIndex[i] >= 222 then
                    table.insert(nIndexList6_2, cmd.nIndex[i])
                else
                    table.insert(nIndexList6_1, cmd.nIndex[i])
                end
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_7 then
            table.insert(fishList7, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList7, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_18 then
            table.insert(fishList8, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList8, cmd.nIndex[i])
            end
        end
        if cmd.fish_kind[i] == Fishlk_CMD.FishKind.FISH_KIND_17 then
            table.insert(fishList9, cmd.fish_id[i])
            if self.isRefresh == true then
                table.insert(nIndexList9, cmd.nIndex[i])
            end
        end
    end

    if #fishList6 > 0 then
        for i = 1, 24 do
            table.insert(fishList6_1, fishList6[i])
        end
        for i = 25, #fishList6 do
            table.insert(fishList6_2, fishList6[i])
        end
    end

    local leftCorePos = cc.p(self.visibleSize.width / 2 - self.visibleSize.width / 4, self.visibleSize.height / 2)
    local rightCorePos = cc.p(self.visibleSize.width / 2 + self.visibleSize.width / 4, self.visibleSize.height / 2)

    local leftRound1_1 = {}
    leftRound1_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3, leftRound1_1, 40)

    -- 两个大圈用于贝塞尔线
    local circle1_1 = {}
    circle1_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 + 400, circle1_1, 40)

    local leftRound1_2 = {}
    for i = 36, 40 do
        table.insert(leftRound1_2, circle1_1[i])
    end
    for i = 1, 35 do
        table.insert(leftRound1_2, circle1_1[i])
    end
    local circle1_2 = {}
    circle1_2 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 + 1000, circle1_2, 40)

    local leftRound1_3 = {}
    for i = 31, 40 do
        table.insert(leftRound1_3, circle1_2[i])
    end
    for i = 1, 30 do
        table.insert(leftRound1_3, circle1_2[i])
    end
    local count_fishList1 = 21
    local count_fishList1_B = 60
    if self.isRefresh == true then
        count_fishList1 = 21
        count_fishList1_B = #nIndexList1 + 20
    end
    if count_fishList1_B > 20 then
        for i = count_fishList1, count_fishList1_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_1
            fishTrace.fish_id = fishList1[i - 20]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(leftCorePos.x, leftCorePos.y))

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 40 - nIndexList1[i - 20] + 21
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 40 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(11, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 2)

            local index = temp_i - 20
            local bezierConfig = {cc.p(leftRound1_1[41 - index].x, leftRound1_1[41 - index].y), cc.p(leftRound1_2[41 - index].x, leftRound1_2[41 - index].y),
                                  cc.p(leftRound1_3[41 - index].x, leftRound1_3[41 - index].y)}
            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local rightRound1_1 = {}
    local rightRound1_2 = {}
    local rightRound1_3 = {}
    for i = 1, 40 do
        local temp_rightRound1_1 = {}
        local temp_rightRound1_2 = {}
        local temp_rightRound1_3 = {}
        temp_rightRound1_1.x = leftRound1_1[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound1_1.y = leftRound1_1[i].y

        temp_rightRound1_2.x = leftRound1_2[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound1_2.y = leftRound1_2[i].y

        temp_rightRound1_3.x = leftRound1_3[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound1_3.y = leftRound1_3[i].y
        table.insert(rightRound1_1, temp_rightRound1_1)
        table.insert(rightRound1_2, temp_rightRound1_2)
        table.insert(rightRound1_3, temp_rightRound1_3)
    end

    local count_fishList2 = 21
    local count_fishList2_B = 60
    if self.isRefresh == true then
        count_fishList2 = 21
        count_fishList2_B = #nIndexList2 + 20
    end
    if count_fishList2_B > 0 then
        for i = count_fishList2, count_fishList2_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_2
            fishTrace.fish_id = fishList2[i - 20]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(rightCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3

            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 80 - nIndexList2[i - 20] + 21
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 40 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(12, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 2)

            local index = temp_i - 20
            local bezierConfig = {cc.p(rightRound1_1[41 - index].x, rightRound1_1[41 - index].y), cc.p(rightRound1_2[41 - index].x, rightRound1_2[41 - index].y),
                                  cc.p(rightRound1_3[41 - index].x, rightRound1_3[41 - index].y)}

            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local leftRound2_1 = {}
    leftRound2_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30, leftRound2_1, 40)

    -- 两个大圈用于贝塞尔线
    local circle2_1 = {}
    circle2_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 + 400, circle2_1, 40)

    local leftRound2_2 = {}
    for i = 36, 40 do
        table.insert(leftRound2_2, circle2_1[i])
    end
    for i = 1, 35 do
        table.insert(leftRound2_2, circle2_1[i])
    end
    local circle2_2 = {}
    circle2_2 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 + 1000, circle2_2, 40)

    local leftRound2_3 = {}
    for i = 31, 40 do
        table.insert(leftRound2_3, circle2_2[i])
    end
    for i = 1, 30 do
        table.insert(leftRound2_3, circle2_2[i])
    end
    local count_fishList3 = 21
    local count_fishList3_B = 60
    if self.isRefresh == true then
        count_fishList3 = 21
        count_fishList3_B = #nIndexList3 + 20
    end
    if count_fishList3_B > 0 then
        for i = count_fishList3, count_fishList3_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_3
            fishTrace.fish_id = fishList3[i - 20]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(leftCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30

            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 160 - nIndexList3[i - 20] + 21
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 40 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(9, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 3)

            local index = temp_i - 20
            local bezierConfig = {cc.p(leftRound2_1[41 - index].x, leftRound2_1[41 - index].y), cc.p(leftRound2_2[41 - index].x, leftRound2_2[41 - index].y),
                                  cc.p(leftRound2_3[41 - index].x, leftRound2_3[41 - index].y)}
            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)

            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local rightRound2_1 = {}
    local rightRound2_2 = {}
    local rightRound2_3 = {}
    for i = 1, 40 do
        local temp_rightRound2_1 = {}
        local temp_rightRound2_2 = {}
        local temp_rightRound2_3 = {}
        temp_rightRound2_1.x = leftRound2_1[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound2_1.y = leftRound2_1[i].y

        temp_rightRound2_2.x = leftRound2_2[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound2_2.y = leftRound2_2[i].y

        temp_rightRound2_3.x = leftRound2_3[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound2_3.y = leftRound2_3[i].y

        table.insert(rightRound2_1, temp_rightRound2_1)
        table.insert(rightRound2_2, temp_rightRound2_2)
        table.insert(rightRound2_3, temp_rightRound2_3)
    end

    local count_fishList4 = 21
    local count_fishList4_B = 60
    if self.isRefresh == true then
        count_fishList4 = 21
        count_fishList4_B = #nIndexList4 + 20
    end
    if count_fishList4_B > 0 then
        for i = count_fishList4, count_fishList4_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_5
            fishTrace.fish_id = fishList4[i - 20]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(rightCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 120 - nIndexList4[i - 20] + 21
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 40 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(10, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 3)

            local index = temp_i - 20
            local bezierConfig = {cc.p(rightRound2_1[41 - index].x, rightRound2_1[41 - index].y), cc.p(rightRound2_2[41 - index].x, rightRound2_2[41 - index].y),
                                  cc.p(rightRound2_3[41 - index].x, rightRound2_3[41 - index].y)}

            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local leftRound3_1 = {}
    leftRound3_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 2, leftRound3_1, 24)

    -- 两个大圈用于贝塞尔线
    local circle3_1 = {}
    circle3_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 2 + 400, circle3_1, 24)

    local leftRound3_2 = {}
    for i = 21, 24 do
        table.insert(leftRound3_2, circle3_1[i])
    end
    for i = 1, 20 do
        table.insert(leftRound3_2, circle3_1[i])
    end
    local circle3_2 = {}
    circle3_2 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 2 + 1000, circle3_2, 24)

    local leftRound3_3 = {}
    for i = 23, 24 do
        table.insert(leftRound3_3, circle3_2[i])
    end
    for i = 1, 22 do
        table.insert(leftRound3_3, circle3_2[i])
    end
    local count_fishList5 = 13
    local count_fishList5_B = 36
    if self.isRefresh == true then
        count_fishList5 = 13
        count_fishList5_B = #nIndexList5 + 12
    end
    if count_fishList5_B > 0 then
        for i = count_fishList5, count_fishList5_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_4
            fishTrace.fish_id = fishList5[i - 12]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(leftCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30 * 2
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 184 - nIndexList5[i - 12] + 13
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 24 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(11, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 3)
            local index = temp_i - 12
            local bezierConfig = {cc.p(leftRound3_1[25 - index].x, leftRound3_1[25 - index].y), cc.p(leftRound3_2[25 - index].x, leftRound3_2[25 - index].y),
                                  cc.p(leftRound3_3[25 - index].x, leftRound3_3[25 - index].y)}

            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)

            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local rightRound3_1 = {}
    local rightRound3_2 = {}
    local rightRound3_3 = {}
    for i = 1, 24 do
        local temp_rightRound3_1 = {}
        local temp_rightRound3_2 = {}
        local temp_rightRound3_3 = {}
        temp_rightRound3_1.x = leftRound3_1[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound3_1.y = leftRound3_1[i].y

        temp_rightRound3_2.x = leftRound3_2[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound3_2.y = leftRound3_2[i].y

        temp_rightRound3_3.x = leftRound3_3[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound3_3.y = leftRound3_3[i].y

        table.insert(rightRound3_1, temp_rightRound3_1)
        table.insert(rightRound3_2, temp_rightRound3_2)
        table.insert(rightRound3_3, temp_rightRound3_3)
    end
    local count_fishList6_1 = 13
    local count_fishList6_1_B = 36
    if self.isRefresh == true then
        count_fishList6_1 = 13
        count_fishList6_1_B = #nIndexList6_1 + 12
    end
    if count_fishList6_1_B > 0 then
        for i = count_fishList6_1, count_fishList6_1_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_6
            fishTrace.fish_id = fishList6_1[i - 12]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(rightCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30 * 2
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 208 - nIndexList6_1[i - 12] + 13
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 24 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(12, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 3)
            local index = temp_i - 12
            local bezierConfig = {cc.p(rightRound3_1[25 - index].x, rightRound3_1[25 - index].y), cc.p(rightRound3_2[25 - index].x, rightRound3_2[25 - index].y),
                                  cc.p(rightRound3_3[25 - index].x, rightRound3_3[25 - index].y)}

            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local leftRound4_1 = {}
    leftRound4_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 3, leftRound4_1, 13)

    -- 两个大圈用于贝塞尔线
    local circle4_1 = {}
    circle4_1 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 3 + 400, circle4_1, 13)

    local leftRound4_2 = {}
    for i = 12, 13 do
        table.insert(leftRound4_2, circle4_1[i])
    end
    for i = 1, 11 do
        table.insert(leftRound4_2, circle4_1[i])
    end
    local circle4_2 = {}
    circle4_2 = MathAide.BuildCircle(leftCorePos.x, leftCorePos.y, self.visibleSize.height / 3 - 30 * 3 + 1000, circle4_2, 13)

    local leftRound4_3 = {}
    for i = 10, 13 do
        table.insert(leftRound4_3, circle4_2[i])
    end
    for i = 1, 9 do
        table.insert(leftRound4_3, circle4_2[i])
    end

    local count_fishList6_2 = 7
    local count_fishList6_2_B = 19
    if self.isRefresh == true then
        count_fishList6_2 = 7
        count_fishList6_2_B = #nIndexList6_2 + 6
    end
    if count_fishList6_2_B > 0 then
        for i = count_fishList6_2, count_fishList6_2_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_6
            fishTrace.fish_id = fishList6_2[i - 6]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(leftCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30 * 3
            -- config.time = 1.0 / #fishList6_2 * (i-1)
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 234 - nIndexList6_2[i - 6] + 7
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 13 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(10, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 4)
            local index = temp_i - 6
            local bezierConfig = {cc.p(leftRound4_1[14 - index].x, leftRound4_1[14 - index].y), cc.p(leftRound4_2[14 - index].x, leftRound4_2[14 - index].y),
                                  cc.p(leftRound4_3[14 - index].x, leftRound4_3[14 - index].y)}
            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

    local rightRound4_1 = {}
    local rightRound4_2 = {}
    local rightRound4_3 = {}
    for i = 1, 13 do
        local temp_rightRound4_1 = {}
        local temp_rightRound4_2 = {}
        local temp_rightRound4_3 = {}
        temp_rightRound4_1.x = leftRound4_1[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound4_1.y = leftRound4_1[i].y

        temp_rightRound4_2.x = leftRound4_2[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound4_2.y = leftRound4_2[i].y

        temp_rightRound4_3.x = leftRound4_3[i].x + self.visibleSize.width / 4 * 2
        temp_rightRound4_3.y = leftRound4_3[i].y

        table.insert(rightRound4_1, temp_rightRound4_1)
        table.insert(rightRound4_2, temp_rightRound4_2)
        table.insert(rightRound4_3, temp_rightRound4_3)
    end
    local count_fishList7 = 7
    local count_fishList7_B = 19
    if self.isRefresh == true then
        count_fishList7 = 7
        count_fishList7_B = #nIndexList7 + 6
    end
    if count_fishList7_B > 0 then
        for i = count_fishList7, count_fishList7_B do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_7
            fishTrace.fish_id = fishList7[i - 6]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

            local nulls = {}

            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(rightCorePos)

            local config = {}
            config.centerPoint = cc.p(pFish:getPosition())
            config.radius = self.visibleSize.height / 3 - 30 * 3
            -- config.time = 1.0 / #fishList7 * (i-1)
            local temp_i = i
            local temp_time = 0
            if self.isRefresh == true then
                temp_i = 221 - nIndexList7[i - 6] + 7
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            config.time = 1.0 / 13 * (temp_i - 1)

            local anim = CActionClockwiseRound:create(11, config.centerPoint, config.radius, config.time)
            local repeatAction = cc.Repeat:create(anim, 4)
            local index = temp_i - 6
            local bezierConfig = {cc.p(rightRound4_1[14 - index].x, rightRound4_1[14 - index].y), cc.p(rightRound4_2[14 - index].x, rightRound4_2[14 - index].y),
                                  cc.p(rightRound4_3[14 - index].x, rightRound4_3[14 - index].y)}

            local action = cc.BezierTo:create(5, bezierConfig)

            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local psq = cc.Sequence:create(repeatAction, action, funcall)
            psq:setTag(10)
            pFish:runAction(psq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end
    local count_fishList8 = #fishList8
    if self.isRefresh == true then
        count_fishList8 = #nIndexList8
    end
    if count_fishList8 > 0 then
        local fishTrace = {}

        fishTrace.init_count = 2
        fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_18
        fishTrace.fish_id = fishList8[1]
        fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR

        local nulls = {}

        -- 创建鱼
        local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
        local pFish = Fish.new(frameName, fishTrace, nulls, self)
        pFish:setPosition(cc.p(self.m_fishLayer:getContentSize().width / 2 - self.m_fishLayer:getContentSize().width / 4, self.m_fishLayer:getContentSize().height / 2))

        local temp_time = 0
        if self.isRefresh == true then
            temp_time = cmd.dwLeftTime[1] / 1000
        end

        pFish:setRotation(-45)

        local rotateto = cc.RotateTo:create(45, 360 * 10)
        local pMoveTo = cc.MoveTo:create(10, cc.p(self.origin.x + (100 + self.visibleSize.width * (self.visibleSize.width / self.visibleSize.height)),
            self.origin.y + (self.visibleSize.height / 2 + self.visibleSize.width)))
        local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

        local seq = cc.Sequence:create(rotateto, pMoveTo, funcall)
        seq:setTag(10)
        pFish:runAction(seq)
        pFish:getActionByTag(10):step(0)
        pFish:getActionByTag(10):step(temp_time)
        pFish:setVisible(false)
        pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
            args:setVisible(true)
        end)))
        self.m_fishMgr:AddSceneFish(pFish)
        self.m_fishLayer:addChild(pFish)
    end

    local count_fishList9 = #fishList9
    if self.isRefresh == true then
        count_fishList9 = #nIndexList9
    end
    if count_fishList9 > 0 then
        for i = 1, #fishList9 do
            local fishTrace = {}

            fishTrace.init_count = 2
            fishTrace.fish_kind = Fishlk_CMD.FishKind.FISH_KIND_17
            fishTrace.fish_id = fishList9[i]
            fishTrace.trace_type = Fishlk_CMD.TraceType.TRACE_LINEAR
            local nulls = {}
            local temp_time = 0
            if self.isRefresh == true then
                temp_time = cmd.dwLeftTime[1] / 1000
            end
            -- 创建鱼
            local frameName = string.format("fish%d_01.png", fishTrace.fish_kind + 1)
            local pFish = Fish.new(frameName, fishTrace, nulls, self)
            pFish:setPosition(cc.p(self.m_fishLayer:getContentSize().width / 2 + self.m_fishLayer:getContentSize().width / 4, self.m_fishLayer:getContentSize().height / 2))
            pFish:setRotation(-45)

            local rotateto = cc.RotateTo:create(46, 360 * 10)
            local pMoveTo = cc.MoveTo:create(10, cc.p(self.origin.x + (self.visibleSize.width / 2 + self.visibleSize.width * (self.visibleSize.width / self.visibleSize.height)),
                self.origin.y + (self.visibleSize.height / 2 - self.visibleSize.height / 4 + self.visibleSize.width)))
            local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))

            local seq = cc.Sequence:create(rotateto, pMoveTo, funcall)
            seq:setTag(10)
            pFish:runAction(seq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(temp_time)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))
            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end

end
-- 场景切换6
function FISHLKScene:onSocketGameStat_Scene2(data)
    MusicManager.stopBGM()
    MusicManager.playBGM(getRes("music/bgm1.mp3"))
    local value = FishMessage.CMD_S_GameStatScene2(data)
    -- dump(value)
    self.m_isFire = true
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    if (value.fish_count <= 0) then
        return
    end
    for i = 1, value.fish_count do
        local fishTrace = {}
        fishTrace.init_pos = {}
        fishTrace.init_pos = value.init_pos[i]
        fishTrace.init_count = value.init_count[i]
        fishTrace.fish_kind = value.fish_kind[i]
        fishTrace.fish_id = value.fish_id[i]
        fishTrace.trace_type = value.trace_type[i]
        for j = 1, fishTrace.init_count do
            -- 屏幕坐标转相对设备坐标
            -- windows坐标转OPGL坐标
            fishTrace.init_pos[j].y = Fishlk_CMD.kResolutionHeight - fishTrace.init_pos[j].y
            fishTrace.init_pos[j].x = fishTrace.init_pos[j].x / Fishlk_CMD.kResolutionWidth * self.visibleSize.width
            fishTrace.init_pos[j].y = fishTrace.init_pos[j].y / Fishlk_CMD.kResolutionHeight * self.visibleSize.height
        end
        local nulls = {}
        local speed = self.m_gameConfig.fish_speed[fishTrace.fish_kind + 1]
        -- 创建鱼
        -- local frameName = string.format("fish%d_01.png",fishTrace.fish_kind+1)

        local action = nil
        local fTime = 0
        if fishTrace.trace_type == Fishlk_CMD.TraceType.TRACE_BEZIER then
            local fDistance = MathAide.CalcDistance(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y, fishTrace.init_pos[2].x, fishTrace.init_pos[2].y) +
                                  MathAide.CalcDistance(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y, fishTrace.init_pos[3].x, fishTrace.init_pos[3].y)
            fTime = fDistance / speed / 18
            local bezierConfig =
                {cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y), cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y), cc.p(fishTrace.init_pos[3].x, fishTrace.init_pos[3].y)}
            action = cc.BezierTo:create(fTime, bezierConfig)
        else
            local fDistance = MathAide.CalcDistance(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y, fishTrace.init_pos[2].x, fishTrace.init_pos[2].y)
            fTime = fDistance / speed / 18
            action = cc.MoveTo:create(fTime, cc.p(fishTrace.init_pos[2].x, fishTrace.init_pos[2].y))
        end
        local funcall = cc.CallFunc:create(handler(self, self.removeFishCallBack))
        local seq = cc.Sequence:create(action, funcall)
        seq:setTag(10)
        if value.dwLeftTime[i] / 1000 < fTime then
            local pFish = Fish.new("yuan.png", fishTrace, nulls, self)
            pFish:setPosition(cc.p(fishTrace.init_pos[1].x, fishTrace.init_pos[1].y))
            pFish:runAction(seq)
            pFish:getActionByTag(10):step(0)
            pFish:getActionByTag(10):step(value.dwLeftTime[i] / 1000)
            pFish:setVisible(false)
            pFish:runAction(cc.Sequence:create(cc.DelayTime:create(0.04), cc.CallFunc:create(function(args)
                args:setVisible(true)
            end)))

            self.m_fishMgr:AddSceneFish(pFish)
            self.m_fishLayer:addChild(pFish)
        end
    end
end
-- 移除鱼
function FISHLKScene:removeFishCallBack(fish)
    self.m_fishMgr:RemoveFish(fish)
end
-- 炸弹特效
function FISHLKScene:addBombSpeciallyGoodEffect(fish_kind, fish_pos)
    if fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_18 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_LK then
        -- 绿色
        local emitter = cc.ParticleSystemQuad:create(getRes("SpecialEffects/baozhalvse.plist"))
        -- 设置发射粒子的位置 
        emitter:setPosition(cc.p(fish_pos))
        -- 完成后制动移除 
        emitter:setAutoRemoveOnFinish(true)
        -- 设置粒子系统的持续时间秒 
        -- emitter:setDuration(1.0f)
        self.m_fishLayer:addChild(emitter)
        return
    elseif fish_kind == Fishlk_CMD.FishKind.FISH_KIND_22 then
        -- 定屏
        local emitter = cc.ParticleSystemQuad:create(getRes("SpecialEffects/ding.plist"))
        -- 设置发射粒子的位置 
        emitter:setPosition(cc.p(fish_pos))
        -- 完成后制动移除 
        emitter:setAutoRemoveOnFinish(true)
        -- 设置粒子系统的持续时间秒 
        emitter:setDuration(1.0)
        self.m_fishLayer:addChild(emitter)
        return
    elseif fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_23 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_24 then
        -- 黄色
        local emitter = cc.ParticleSystemQuad:create(getRes("SpecialEffects/baozhahuangse.plist"))
        -- 设置发射粒子的位置 
        emitter:setPosition(cc.p(fish_pos))
        -- 完成后制动移除 
        emitter:setAutoRemoveOnFinish(true)
        -- 设置粒子系统的持续时间秒 
        emitter:setDuration(1.0)
        self.m_fishLayer:addChild(emitter)
        return
    elseif fish_kind >= Fishlk_CMD.FishKind.FISH_KIND_25 and fish_kind <= Fishlk_CMD.FishKind.FISH_KIND_COUNT - 1 then
        -- 蓝色
        local emitter = cc.ParticleSystemQuad:create(getRes("SpecialEffects/quan.plist"))
        -- 设置发射粒子的位置 
        emitter:setPosition(cc.p(fish_pos))
        -- 完成后制动移除 
        emitter:setAutoRemoveOnFinish(true)
        -- 设置粒子系统的持续时间秒 
        emitter:setDuration(1.5)
        self.m_fishLayer:addChild(emitter)
        for i = 0, 360, 36 do
            local emitter1 = cc.ParticleSystemQuad:create(getRes("SpecialEffects/bingjian.plist"))
            -- 设置发射粒子的位置 
            emitter1:setPosition(display.LEFT_BOTTOM)
            -- 完成后制动移除 
            emitter1:setAutoRemoveOnFinish(true)
            -- 设置粒子系统的持续时间秒 
            emitter1:setDuration(2.0)
            emitter:addChild(emitter1)
            emitter1:setRotation(i)
        end
        return
    end
end

function FISHLKScene:creatAnimationSprite(filename, count)
    local pSprite = cc.Sprite:createWithSpriteFrameName(string.format(filename, 1))
    local animation = cc.Animation:create()
    for i = 1, count do
        local frameName = string.format(filename, i)
        local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.1)
    local animate = cc.Animate:create(animation)
    local repeatForever = cc.RepeatForever:create(animate)
    pSprite:runAction(animate)
    return pSprite
end
-- 添加筹码
function FISHLKScene:addFishChipScore(chair_id, score)
    self:FindChipMgr(chair_id):AddChip(score)
end
-- 大转盘结束
function FISHLKScene:TreasureBoxOver(chair_id, award, fish_id)
    local cmd = {}
    cmd.chair_id = chair_id
    cmd.award = award
    cmd.fish_id = fish_id

    FishMessage.send_CMD_C_OpenTeasureBox(cmd)
    self.m_isFire = true
end
-- 退出游戏
function FISHLKScene:ExitGame()
    -- self:onExitGame()
    --[[if self:isDisConnect()==false then
        self:onQuestStandup()
    else
        self:onExitGame()
    end--]]
    self.m_fishMgr:RemoveAllFish()
    self.m_bulletMgr:reMoveAllBullet()
    self.isExitGame = true
    self:onQuestStandup()
    self:onExitGame()
end
-- 前后台切换
function FISHLKScene:onEnterBackground(isEnterBackground)
    if isEnterBackground == true then
        -- 游戏切换到后台
        -- print("---------------游戏切换到后台1------------------")
        self:initParams()
        -- self.m_fishUI:HangGame(false)
    else
        -- 游戏切换到前台
        -- print("---------------游戏切换到前台1------------------")
        self:refreshGame()
    end
end
-- 离开场景
function FISHLKScene:onExit()
    FISHLKScene.super.onExit(self)
    for i = #self.table_scheduleID, 1, -1 do
        if self.table_scheduleID[i] ~= nil then
            self.scheduler:unscheduleScriptEntry(self.table_scheduleID[i])
            table.remove(self.table_scheduleID, i)
        end
    end
    -- 移除碰撞监听
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.contactListener)
    LoadingManager.removeLoadRes(33)
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(getRes("QPAnimation/qipao.ExportJson"))
    cc.Director:getInstance():setAnimationInterval(1 / 60)
end

--
function FISHLKScene:onEnterTransitionFinish()
    FISHLKScene.super.onEnterTransitionFinish(self)
    cc.Director:getInstance():setAnimationInterval(1 / 30)

    cc.Director:getInstance():getRunningScene():initWithPhysics()
    cc.Director:getInstance():getRunningScene():getPhysicsWorld():setGravity(cc.p(0, -100))
    -- cc.Director:getInstance():getRunningScene():getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL);
    self:addContact()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(getRes("QPAnimation/qipao0.png"), getRes("QPAnimation/qipao0.plist"), getRes("QPAnimation/qipao.ExportJson")) -- 加载动画所用到的数据
end

-- 添加碰撞
function FISHLKScene:addContact()
    local function onContactBegin(contact)
        local a = contact:getShapeA():getBody():getNode()
        local b = contact:getShapeB():getBody():getNode()
        local bullet = nil
        local fish = nil
        if a and b then
            if a:getTag() == 1 then
                bullet = a
                fish = b
            else
                bullet = b
                fish = a
            end

        end
        if nil ~= bullet then
            if bullet.m_bullet.lock_fishid > 0 then
                local game_fish = self.m_fishMgr:GetFishIdToFish(bullet.m_bullet.lock_fishid)
                if game_fish ~= nil then
                    if self.m_fishMgr:IsFishMaxScene(game_fish) == true then
                        if game_fish == fish then
                            self.m_bulletMgr:Collisions(fish, bullet:GetBulletCmdDate(), bullet, true)
                            self.m_bulletMgr:removeBullet(bullet)
                        else
                            return true
                        end
                    else
                        bullet.m_bullet.lock_fishid = 0
                    end
                end
            else
                self.m_bulletMgr:Collisions(fish, bullet:GetBulletCmdDate(), bullet, false)
                self.m_bulletMgr:removeBullet(bullet)
            end
        end
        return true
    end
    local dispatcher = self:getEventDispatcher()
    self.contactListener = cc.EventListenerPhysicsContact:create()
    self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    dispatcher:addEventListenerWithSceneGraphPriority(self.contactListener, self)
end
return FISHLKScene
