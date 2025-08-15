-- 赠送记录
local BankNodeGiveRecord = class("BankNodeGiveRecord", function()
    return cc.Node:create()
end)

function BankNodeGiveRecord:ctor(giveui)
    self.winSize = giveui.winSize
    self.midWidth = giveui.midWidth
    self.midHeight = giveui.midHeight

    self:enableNodeEvents()
    self:setName("BankNodeGiveRecord")
    self:setContentSize(self.winSize)

    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = self:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, 0, self.winSize.width, self.winSize.height), pos) then
            return false
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    local anchor = display.CENTER
    local imgpanelbg = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    imgpanelbg:setCapInsets(GameDefine.PanelRect2)
    imgpanelbg:setContentSize(self.winSize)
    imgpanelbg:align(anchor, self.midWidth, self.midHeight):addTo(self)

    GameUtil.createLabel(LangCtrl:getLang().word177, 30, GameDefine.FontColor, display.LEFT_CENTER, cc.p(20, 500)):addTo(self)
    GameUtil.createLabel(LangCtrl:getLang().word178, 18, cc.c3b(0x87, 0x7b, 0x6b), display.RIGHT_CENTER, cc.p(self.winSize.width - 20, 490)):addTo(self)

    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth - 200, 442):addTo(imgpanelbg):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth, 442):addTo(imgpanelbg):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth + 200, 442):addTo(imgpanelbg):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth, 420):addTo(imgpanelbg):setScaleX((self.winSize.width - 30) / 6)

    local lblcolor = cc.c3b(0xc8, 0xb0, 0x9c)
    GameUtil.createLabel(LangCtrl:getLang().word179, 20, lblcolor, anchor, cc.p(self.midWidth - 300, 440)):addTo(imgpanelbg)
    GameUtil.createLabel(LangCtrl:getLang().word180, 20, lblcolor, anchor, cc.p(self.midWidth - 100, 440)):addTo(imgpanelbg)
    GameUtil.createLabel(LangCtrl:getLang().word181, 20, lblcolor, anchor, cc.p(self.midWidth + 100, 440)):addTo(imgpanelbg)
    GameUtil.createLabel(LangCtrl:getLang().word182, 20, lblcolor, anchor, cc.p(self.midWidth + 300, 440)):addTo(imgpanelbg)

    local recordListView = ccui.ListView:create()
    recordListView:setDirection(ccui.ScrollViewDir.vertical)
    recordListView:setContentSize(cc.size(self.winSize.width, 310))
    recordListView:setBounceEnabled(true)
    recordListView:setScrollBarEnabled(true)
    recordListView:setTouchEnabled(true)
    recordListView:align(display.CENTER_TOP, self.midWidth, 420):addTo(imgpanelbg)
    self.recordListView = recordListView

    local function clickBackFunction()
        self:removeFromParent()
    end
    local btn_back = GameUtil.createButton("app/common/button/btn1.png", nil, clickBackFunction):align(anchor, self.midWidth, 50):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word17, btn_back) -- 返回
end

function BankNodeGiveRecord:onEnter()
    self:addEvent()

    if GameDefine.bIsTestUI then
        self:onSeachGiveRecordSucc({})
    else
        self:sendRequestGiveGoalRecord()
    end
end

function BankNodeGiveRecord:onExit()
    self:removeEvent()
end

function BankNodeGiveRecord:onClearUp()
    self:disableNodeEvents()
end

function BankNodeGiveRecord:addEvent()
    self.eventData = {}
    self.eventData.onSeachGiveRecordSucc = function(data)
        self:onSeachGiveRecordSucc(data)
    end -- 查询用户成功

    game.registerEvent(GameDefine.Bank_Back_SeachGiveRecordSucc, self.eventData.onSeachGiveRecordSucc)
end

function BankNodeGiveRecord:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_SeachGiveRecordSucc, self.eventData.onSeachGiveRecordSucc)
end

----------------------------------------UI 函数------------------------

function BankNodeGiveRecord:addToOnCheckExist(node)
    local exit = false
    if node ~= nil then
        local name = self:getName()
        if name ~= nil and name ~= "" then
            if node:getChildByName(name) ~= nil then
                exit = true
            end
        end
    end
    if exit == false and node ~= nil then
        self:addTo(node)
    end
end

function BankNodeGiveRecord:creatRecordItem(itemData)
    local itemNode = ccui.Layout:create()
    itemNode:setContentSize(cc.size(660, 40))
    local anchor = display.CENTER

    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth - 200, 20):addTo(itemNode):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth, 20):addTo(itemNode):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth + 200, 20):addTo(itemNode):setScaleX(44 / 6):setRotation(90)
    GameUtil.newSprite("app/win/bank/img_line.png", false):align(anchor, self.midWidth, 0):addTo(itemNode):setScaleX((self.winSize.width - 30) / 6)

    local color = cc.c3b(0xd2, 0x8e, 0x68)
    GameUtil.createLabel(itemData.szSourceNickName, 20, color, anchor, cc.p(self.midWidth - 300, 20)):addTo(itemNode)
    GameUtil.createLabel(itemData.szTargetNickName, 20, color, anchor, cc.p(self.midWidth - 100, 20)):addTo(itemNode)

    local strScole = GameUtil.getShowNumStr(itemData.lScore)
    local txtcolor
    if itemData.lScore < 0 then
        txtcolor = cc.c3b(0xff, 0, 0)
    else
        txtcolor = color
    end
    GameUtil.createLabel(strScole, 20, txtcolor, anchor, cc.p(self.midWidth + 100, 20)):addTo(itemNode)

    local dttime = itemData.dtTime
    local strDate = string.format("%d.%d.%d %d:%d:%d", dttime.wYear, dttime.wMonth, dttime.wDay, dttime.wHour, dttime.wMinute, dttime.wSecond)
    GameUtil.createLabel(strDate, 20, color, anchor, cc.p(self.midWidth + 300, 20)):addTo(itemNode)

    return itemNode
end
------------------------------------逻辑函数-----------------------------
function BankNodeGiveRecord:sendRequestGiveGoalRecord()
    local data = {}
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word183, LangCtrl:getLang().word184)
    end

    PlazaManager.getLoginModule().onRequestGiveGoalRecord(data, onConnectResult)
end

function BankNodeGiveRecord:onSeachGiveRecordSucc(data)
    PlazaManager.closeWattingTips()
    if GameDefine.bIsTestUI then
        for i = 1, 15 do
            table.insert(data, self:addTestData())
        end
    end

    for i = 1, #data do
        for j = i + 1, #data do
            if data[i].dwRecordID < data[j].dwRecordID then
                local itemData = data[i]
                data[i] = data[j]
                data[j] = itemData
            end
        end
    end

    if data ~= nil and #data > 0 then
        self.recordListView:removeAllItems()
        for i = 1, #data do
            local itemNode = self:creatRecordItem(data[i])
            self.recordListView:pushBackCustomItem(itemNode)
        end
    end
end

function BankNodeGiveRecord:addTestData()
    local dataRecord = {}
    dataRecord.dwRecordID = math.random(888, 99999) -- 记录ID
    dataRecord.dwSourceUserID = math.random(888, 99999) -- 赠送用户ID
    dataRecord.dwTargetUserID = math.random(888, 99999) -- 被赠送用户ID
    dataRecord.szSourceNickName = "sourcename" -- 赠送用户昵称
    dataRecord.szTargetNickName = "targetname" -- 被赠送用户昵称
    dataRecord.lScore = math.random(-899999988, 99999999)

    local dtTime = {}
    dtTime.wYear = 2021 -- 年
    dtTime.wMonth = 12 -- 月
    dtTime.wDayOfWeek = 5 -- 星期，0=星期日，1=星期一
    dtTime.wDay = 32 -- 日
    dtTime.wHour = 24 -- 时
    dtTime.wMinute = 58 -- 分
    dtTime.wSecond = 58 -- 秒
    dtTime.wMilliseconds = 222 -- 毫秒
    dataRecord.dtTime = dtTime

    return dataRecord
end

return BankNodeGiveRecord
