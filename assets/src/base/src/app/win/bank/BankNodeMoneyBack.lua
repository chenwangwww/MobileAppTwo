-- 流水返点
local BankNodeMoneyBack = class("BankNodeMoneyBack", function()
    return cc.Node:create()
end)

function BankNodeMoneyBack:ctor(bankui, data)
    self.winSize = bankui.rightSize
    self.midWidth = self.winSize.width / 2
    self.midHeight = self.winSize.height / 2
    self:enableNodeEvents()
    self:setName("BankNodeMoneyBack")
    self:setContentSize(self.winSize)
    self.tackMoneyBackSucc = false
    self.data = data

    local img_bg_top = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    img_bg_top:setCapInsets(GameDefine.PanelRect2)
    img_bg_top:setContentSize(self.winSize)
    img_bg_top:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)

    local itemListView = ccui.ListView:create()
    itemListView:setDirection(ccui.ScrollViewDir.vertical)
    itemListView:setContentSize(cc.size(self.winSize.width, 420))
    itemListView:setBounceEnabled(true)
    itemListView:setScrollBarEnabled(true)
    itemListView:align(display.CENTER_TOP, self.midWidth, self.winSize.height - 10):addTo(self)
    self.itemListView = itemListView

    local function clickTakeMoney(btn)
        if self.moneyBackData == nil then
            PlazaManager.showTips(LangCtrl:getLang().word159)
            return
        end

        if self.moneyBackData.lNewRunningGold <= 0 and self.moneyBackData.lNewTax <= 0 and self.moneyBackData.lLuckyValue <= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word160)
            return
        end

        self:sendTakeMoneyBack()
    end
    local btn_TakeMoney = GameUtil.createButton("app/common/button/btn1.png", nil, clickTakeMoney):move(self.midWidth, 50):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word19, btn_TakeMoney) -- 取出

    local lbl = GameUtil.createLabel(LangCtrl:getLang().word161, 20, cc.c3b(0xc4, 0xa9, 0x6c), display.LEFT_CENTER, cc.p(self.midWidth + 150, 50)):addTo(self)
    lbl:setMaxLineWidth(250)
    lbl:setLineBreakWithoutSpace(false)
end

function BankNodeMoneyBack:onEnter()
    self:addEvent()
    if GameDefine.bIsTestUI then
        self.data = self:genTestData()
        self:initView(self.data)
    else
        if self.data ~= nil then
            self:initView(self.data)
        else
            self:sendRequestMoneyBack()
        end
    end
end

function BankNodeMoneyBack:genTestData()
    globalUserInfo.cbMemberOrder = 5
    local data = {}
    data.lNewRunningGold = math.random(0, 9999) -- 可领取的流水返点金币（实际可提数）
    data.lSumRunningGold = math.random(0, 9999) -- 已结算流水
    data.lNewTax = math.random(0, 9999) -- 可领取赠送返点
    data.lSumTax = math.random(0, 9999) -- 已结算的赠送返点
    data.wRate = math.random(0, 9999) -- 流水返点率（千分之几）
    data.lYesterdayWinLose = math.random(-99999, 999999) -- 昨日总输赢，捕鱼活动
    data.lLuckyValue = math.random(0, 9999) -- 今日可提昨日活动返点
    data.szNote = "返点测试数据"
    return data
end

function BankNodeMoneyBack:onExit()
    self:removeEvent()
end

function BankNodeMoneyBack:onClearUp()
    self:disableNodeEvents()
end

function BankNodeMoneyBack:addEvent()
    self.eventData = {}
    self.eventData.onRequestMoneyBackSucc = function(data)
        self:onRequestMoneyBackSucc(data)
    end -- 绑定手机号成功

    game.registerEvent(GameDefine.Bank_Back_RequestMoneyBackSucc, self.eventData.onRequestMoneyBackSucc)
end

function BankNodeMoneyBack:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_RequestMoneyBackSucc, self.eventData.onRequestMoneyBackSucc)
end

----------------------------------------UI 函数------------------------
function BankNodeMoneyBack:initView(data)
    self.itemListView:removeAllItems()
    self.moneyBackData = data
    self.itemcount = 0
    -- 可提返点
    local itemNode_1 = ccui.Layout:create()
    itemNode_1:setContentSize(self.winSize.width, 105)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(display.CENTER, self.midWidth, 1):addTo(itemNode_1):setScaleX((self.winSize.width - 20) / 6)
    GameUtil.newSprite("app/win/bank/icon_gg1.png", false):align(display.CENTER, 50, 80):addTo(itemNode_1)
    GameUtil.createLabel(LangCtrl:getLang().word162, 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(80, 80)):addTo(itemNode_1)

    local str_1 = string.format(LangCtrl:getLang().word163, data.wRate / 10, data.wRate / 10)

    GameUtil.createLabel(str_1, 20, cc.c3b(0xc4, 0xa9, 0x6c), display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 60)):addTo(itemNode_1)

    local str_2 = string.format(LangCtrl:getLang().word164, GameUtil.getShowNumStr(data.lNewRunningGold))
    GameUtil.createLabel(str_2, 30, cc.c3b(0xfa, 0x70, 0), display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 25)):addTo(itemNode_1)
    self.itemListView:pushBackCustomItem(itemNode_1)
    self.itemcount = self.itemcount + 1

    --[[
    -- 返点累计已提金币
    local itemNode_2 = ccui.Layout:create()
    itemNode_2:setContentSize(660, 105)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(display.CENTER, self.midWidth, 1):addTo(itemNode_2):setScaleX(self.winSize.width / 6)
    GameUtil.newSprite("app/win/bank/icon_gg2.png", false):align(display.CENTER, 50, 80):addTo(itemNode_2)
    GameUtil.createLabel("累计已提金币", 24, cc.c3b(0x87, 0x7b, 0x6b), display.LEFT_CENTER, cc.p(80, 80)):addTo(itemNode_2)

    local str_3 = string.format("%s/金币", GameUtil.getShowNumStr(data.lSumRunningGold))
    GameUtil.createLabel(str_3, 30, cc.c3b(0xc8, 0xb0, 0x9c), display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 25)):addTo(itemNode_2)
    self.itemListView:pushBackCustomItem(itemNode_2)
    self.itemcount = self.itemcount + 1
    -- ]]

    -- 会员等级大于等于4级才有赠送返点权限
    if globalUserInfo.cbMemberOrder ~= nil and globalUserInfo.cbMemberOrder >= 4 then
        -- 可提赠送金币
        local itemNode_3 = ccui.Layout:create()
        itemNode_3:setContentSize(660, 105)
        GameUtil.newSprite("app/win/bank/img_line.png", false):align(display.CENTER, self.midWidth, 1):addTo(itemNode_3):setScaleX((self.winSize.width - 20) / 6)
        GameUtil.newSprite("app/win/bank/icon_gg3.png", false):align(display.CENTER, 50, 80):addTo(itemNode_3)
        GameUtil.createLabel(LangCtrl:getLang().word165, 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(80, 80)):addTo(itemNode_3)

        local str_4 = string.format(LangCtrl:getLang().word164, GameUtil.getShowNumStr(data.lNewTax))
        GameUtil.createLabel(str_4, 30, cc.c3b(0xfa, 0x70, 0), display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 25)):addTo(itemNode_3)
        self.itemListView:pushBackCustomItem(itemNode_3)
        self.itemcount = self.itemcount + 1

        --[[
        -- 累计已提赠送金币
        local itemNode_4 = ccui.Layout:create()
        itemNode_4:setContentSize(660, 105)
        GameUtil.newSprite("app/win/bank/img_line.png", false):align(display.CENTER, self.midWidth, 1):addTo(itemNode_4):setScaleX(self.winSize.width / 6)
        GameUtil.newSprite("app/win/bank/icon_gg2.png", false):align(display.CENTER, 50, 80):addTo(itemNode_4)
        GameUtil.createLabel("累计已提赠送金币", 24, cc.c3b(0x87, 0x7b, 0x6b), display.LEFT_CENTER, cc.p(80, 80)):addTo(itemNode_4)

        local str_5 = string.format("%s/金币", GameUtil.getShowNumStr(data.lSumTax))
        GameUtil.createLabel(str_5, 30, cc.c3b(0xc8, 0xb0, 0x9c), display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 25)):addTo(itemNode_4)
        self.itemListView:pushBackCustomItem(itemNode_4)
        self.itemcount = self.itemcount + 1
        -- ]]
    end

    --[[
    -- 捕鱼活动返点领取
    local itemNode_5 = ccui.Layout:create()
    itemNode_5:setContentSize(660, 105)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(display.CENTER, self.midWidth, 1):addTo(itemNode_5):setScaleX(self.winSize.width / 6)
    GameUtil.newSprite("app/win/bank/icon_gg1.png", false):align(display.CENTER, 50, 80):addTo(itemNode_5)
    GameUtil.createLabel("捕鱼活动返点", 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(80, 80)):addTo(itemNode_5)

    local str_5_1 = string.format("昨日总输赢：%s", GameUtil.getShowNumStr(data.lYesterdayWinLose))
    GameUtil.createLabel(str_5_1, 22, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 80)):addTo(itemNode_5)

    GameUtil.createLabel("请在今日24小时之前领取,过期作废", 20, GameDefine.FontColor, display.LEFT_CENTER, cc.p(35, 25)):addTo(itemNode_5)

    local str_5_2 = string.format("%s/金币", GameUtil.getShowNumStr(data.lLuckyValue))
    GameUtil.createLabel(str_5_2, 30, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(self.winSize.width - 30, 25)):addTo(itemNode_5)

    self.itemListView:pushBackCustomItem(itemNode_5)
    self.itemcount = self.itemcount + 1
    -- ]]

    self.itemListView:setTouchEnabled(self.itemcount > 4)
end

------------------------------------逻辑函数-----------------------------

function BankNodeMoneyBack:sendRequestMoneyBack()
    self.moneyBackData = nil

    local data = {}
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    local function failFunction()
        self.moneyBackData = nil
    end
    PlazaManager.showConectWaitTips(failFunction)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, failFunction, LangCtrl:getLang().word166, LangCtrl:getLang().word167)
    end
    PlazaManager.getLoginModule().onRequestMoneyBack(data, onConnectResult)
end

function BankNodeMoneyBack:sendTakeMoneyBack()
    local data = {}
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word168, LangCtrl:getLang().word169)
    end

    PlazaManager.getLoginModule().onTakeMoneyBack(data, onConnectResult)
end

function BankNodeMoneyBack:onRequestMoneyBackSucc(data)
    PlazaManager.closeWattingTips()
    self:initView(data)
    self.tackMoneyBackSucc = true
    PlazaManager.showTips(data.szNote)
end

function BankNodeMoneyBack:getTakeChk()
    return self.tackMoneyBackSucc
end

return BankNodeMoneyBack
