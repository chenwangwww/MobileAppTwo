local HallNodeTop = class("HallNodeTop", function()
    return display.newNode()
end)

local SettingWinUI = require "app.win.hall.SettingWinUI"
local UserInfoWinUI = require "app.win.hall.UserInfoWinUI"

function HallNodeTop:ctor(args)
    self:enableNodeEvents()
    self.data = args
    self.refreshTime = 0

    self:setContentSize(cc.size(1334, 100))
    self:initView()
end

function HallNodeTop:onEnter()
    self.eventData = {}

    self.eventData.onUpdataUserGoal = function()
        self:onUpdataUserGoal()
    end -- 金币变化消息

    game.registerEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onUpdataUserGoal)

    self.eventData.onModifyPersonInfo = function(args)
        self.lbl_niceName:setString(globalUserInfo.szNickName)
    end
    game.registerEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfo)
end

function HallNodeTop:onExit()
    game.unregisterEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onUpdataUserGoal)
    game.unregisterEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfo)
end

function HallNodeTop:onClearUp()
    self:disableNodeEvents()
end

function HallNodeTop:initView()
    local bg_1 = ccui.Scale9Sprite:create("app/hall/top/img_top_bg.png") -- 521  97
    bg_1:setCapInsets(cc.rect(460, 1, 2, 95))
    bg_1:setContentSize(display.width, 95)
    bg_1:align(display.CENTER_TOP, display.cx, 100):addTo(self)

    -- 头像
    local function clickHeadFunction()
        local winui = UserInfoWinUI.new(true)
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display.getRunningScene())
    end
    local img_head = GameUtil.createAvatar(globalUserInfo.headimgurl, 75, true, clickHeadFunction, nil, nil, nil)
    img_head:align(display.CENTER, 60, 60):addTo(self)
    img_head:setName("img_head")
    local avatarbg = GameUtil.newSprite("app/common/img_txbjk.png", false):align(display.CENTER, 37.5, 37.5):addTo(img_head)
    avatarbg:setScale(0.5)

    -- 昵称
    self.lbl_niceName = GameUtil.createLabel(globalUserInfo.szNickName, 26, cc.c3b(0xff, 0xff, 0xff), display.LEFT_CENTER, cc.p(120, 75), nil, cc.size(200, 30))
    self.lbl_niceName:addTo(self)
    self.lbl_niceName:setName("lbl_niceName")

    -- ID
    local IDStr = string.format("ID: %s", globalUserInfo.dwGameID)
    local lbl_ID = GameUtil.createLabel(IDStr, 26, cc.c3b(0xff, 0xff, 0xff), display.LEFT_CENTER, cc.p(120, 40), nil, cc.size(200, 35)):addTo(self)
    lbl_ID:setName("lbl_ID")

    -- 金币数量
    self:createGoalNode(cc.p(460, 60))

    -- 刷新按钮
    local function onClickRefresh(target)
        if GameDefine.bIsTestUI then
            local testui = require "app.win.hall.GiveAlmsWinUI"
            local testdata = {
                lAlms = 88888,
                lRemainCount = 99999
            }
            local winui = testui.new(testdata, math.random(0, 1) == 1)
            winui:setCenterOnScene()
            winui:addToOnCheckExist(display.getRunningScene())
        end

        if os.difftime(os.time(), self.refreshTime) > 1 then
            self.refreshTime = os.time()
            PlazaManager.getRefreshModule().onSearchUserGold()
        else
            PlazaManager.showTips(LangCtrl:getLang().word158)
        end
    end
    GameUtil.addEnlargeBtn("app/hall/top/btn_refresh.png", 1.5, onClickRefresh):align(display.CENTER, 800, 55):addTo(self)

    -- 设置
    local function onClickSet(target)
        local winui = SettingWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display.getRunningScene())
    end
    GameUtil.addEnlargeBtn("app/hall/top/img_set.png", 1.5, onClickSet):align(display.CENTER, 1150, 60):addTo(self)

    local function onClickClose(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            if self.data ~= nil and self.data.callback ~= nil then
                self.data.callback("close")
            end
        end
    end

    local function onClickBack(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            if self.data ~= nil and self.data.callback ~= nil then
                self.data.callback("back")
            end
        end
    end

    if self.data ~= nil and self.data.index == GameDefine.HALL_LAYER_INDEX.HALL then
        local btnNode = ccui.Layout:create()
        btnNode:setTouchEnabled(true)
        btnNode:addTouchEventListener(onClickClose)
        btnNode:setContentSize(100, 110)
        btnNode:align(display.CENTER, 1270, 40):addTo(self)
        GameUtil.newSprite("app/hall/top/btn_close.png", false):align(display.CENTER, 50, 75):addTo(btnNode)
    else
        local btnNode = ccui.Layout:create()
        btnNode:setTouchEnabled(true)
        btnNode:addTouchEventListener(onClickBack)
        btnNode:setContentSize(100, 110)
        btnNode:align(display.CENTER, 1270, 40):addTo(self)
        GameUtil.newSprite("app/hall/top/btn_return.png", false):align(display.CENTER, 50, 75):addTo(btnNode)
    end
end

-- 创建金币按钮控件
function HallNodeTop:createGoalNode(pos)
    local bg_goal = ccui.Scale9Sprite:create("app/hall/top/img_gold_bg.png")
    -- bg_goal:setCapInsets(cc.rect(20,15,50-40,42-30))
    -- bg_goal:setContentSize(218,42)
    bg_goal:align(display.LEFT_CENTER, pos.x, pos.y):addTo(self)

    local sprite_anil = GameUtil.newSprite("app/hall/top/anil_goal/cold_1.png", false):align(display.CENTER, 10, 23):addTo(bg_goal)
    local animation_1 = cc.Animation:create()
    for i = 1, 7 do
        local frameName = string.format("app/hall/top/anil_goal/cold_%d.png", i)
        animation_1:addSpriteFrameWithFile(frameName)
    end
    animation_1:setDelayPerUnit(7 / 60)
    animation_1:setRestoreOriginalFrame(true)

    local animate_1 = cc.Animate:create(animation_1)
    local animate_2 = cc.Sequence:create(animate_1, cc.DelayTime:create(1))
    sprite_anil:runAction(cc.RepeatForever:create(animate_2))

    local goalStr = GameUtil.formatAsset(globalUserInfo.lUserScore)
    local lbl_goal = GameUtil.createLabel(goalStr, 30, GameDefine.FontCoinColor, display.CENTER, cc.p(110, 20), nil, nil):addTo(bg_goal)
    lbl_goal:setName("lbl_goal")
    self.lbl_goal = lbl_goal

    local function onClickOpenShop(res)
        if GameDefine.bIsTestUI then
            require("app.win.PlayerRankView"):openView()
        else
            require("app.win.shop.ShopWeChat"):openView()
        end
    end

    GameUtil.addEnlargeBtn("app/common/icon_jiaohao.png", 1.5, onClickOpenShop):align(display.CENTER, 230, 20):addTo(bg_goal)
end

function HallNodeTop:refreshGold()
    local goalStr = GameUtil.formatAsset(globalUserInfo.lUserScore)
    self.lbl_goal:setString(goalStr)
end

function HallNodeTop:onUpdataUserGoal()
    PlazaManager.closeWattingTips()
    self:refreshGold()
end

function HallNodeTop:onRefreshGold()
    PlazaManager.getRefreshModule().onSearchUserGold()
end

return HallNodeTop

