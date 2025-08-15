-- 金币赠送
local BankNodeGiveGoal = class("BankNodeGiveGoal", function()
    return cc.Node:create()
end)
local BankNodeGiveRecord = require "app.win.bank.BankNodeGiveRecord"

function BankNodeGiveGoal:ctor(bankui)
    self.winSize = bankui.rightSize
    self.midWidth = self.winSize.width / 2
    self.midHeight = self.winSize.height / 2
    self:enableNodeEvents()
    self:setName("BankNodeGiveGoal")

    self:setContentSize(self.winSize)
    self.seachUserSucc = false
    self.strcolor = cc.c3b(168, 142, 113)

    local img_bg_top = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    img_bg_top:setCapInsets(GameDefine.PanelRect2)
    img_bg_top:setContentSize(self.winSize)
    img_bg_top:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)

    -- 箱内存款
    local numbg = ccui.ImageView:create("app/common/mask.png")
    numbg:setScale9Enabled(true)
    numbg:setCapInsets(cc.rect(2, 2, 1, 1))
    numbg:setContentSize(cc.size(240, 40))
    numbg:align(display.LEFT_CENTER, 100, self.winSize.height - 70):addTo(self)
    local numbgSize = numbg:getContentSize()
    local numbgcy = numbgSize.height / 2
    GameUtil.newSprite("app/win/bank/icon_gg_bxx.png", false):align(display.RIGHT_CENTER, -10, numbgcy):addTo(numbg)
    GameUtil.createLabel(LangCtrl:getLang().word136, 24, GameDefine.FontColor, display.LEFT_BOTTOM, cc.p(10, numbgSize.height + 5)):addTo(numbg)
    self.lbl_bankGoal = GameUtil.createLabel("0", 30, GameDefine.FontCoinColor, display.LEFT_CENTER, cc.p(10, numbgcy)):addTo(numbg)
    self.lbl_bankGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserInsure))

    -- 接受者ID
    GameUtil.createLabel(LangCtrl:getLang().word185, 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(50, self.winSize.height - 135)):addTo(img_bg_top)

    local pos_y = self.winSize.height - 180
    local function editboxHandle_GameID(eventname, sender)
        if eventname == "began" then -- 光标进入
        elseif eventname == "ended" then -- 当编辑框失去焦点并且键盘消失的时候调用
        elseif eventname == "return" then -- 当用户点击编辑框的键盘以外的区域，或者键盘的return按钮被点击时所调用
        elseif eventname == "changed" then -- 输入内容改变时调用
            self.seachUserSucc = false
            self:setUserInfoShow(false)

            local idStr = sender:getText()
            if string.len(idStr) == 8 then
                self:sendSeachGiveUserMessage(idStr)
            end
        end
    end
    local edit_GameID = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_GameID:setFont(GameDefine.FontName, 30)
    edit_GameID:setFontColor(GameDefine.FontColor_edit)
    edit_GameID:setMaxLength(8)
    edit_GameID:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_GameID:setPlaceHolder(LangCtrl:getLang().word291)
    edit_GameID:setPlaceholderFontSize(30)
    edit_GameID:setPlaceholderFontName(GameDefine.FontName)
    edit_GameID:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_GameID:align(display.LEFT_CENTER, 50, pos_y):addTo(img_bg_top)
    edit_GameID:registerScriptEditBoxHandler(editboxHandle_GameID)
    self.edit_GameID = edit_GameID

    self.headnode = cc.Node:create()
    self.headnode:setContentSize(cc.size(80, 80))
    self.headnode:align(display.CENTER, 680, pos_y + 120):addTo(self)
    self.headbjk = GameUtil.newSprite("app/common/img_txbjk.png", false):align(display.CENTER, 680, pos_y + 120):addTo(self):setScale(0.55)
    self.lbl_giveNiceName = GameUtil.createLabel("", 24, GameDefine.NameColor, display.CENTER, cc.p(680, pos_y + 50)):addTo(self)

    if GameDefine.bIsTestUI then
        GameUtil.createAvatar(globalUserInfo.headimgurl, 80, true, nil, nil, nil, nil):align(display.CENTER, 40, 40):addTo(self.headnode)
        self.lbl_giveNiceName:setString("名字测试昵称")
    else
        self:setUserInfoShow(false)
    end

    -- 查询按钮
    local function clickSearchUser(btn)
        local giveuserID = self.edit_GameID:getText()
        if string.len(giveuserID) < 5 then
            PlazaManager.showTips(LangCtrl:getLang().word186)
            return
        end
        self:sendSeachGiveUserMessage(giveuserID)
    end
    GameUtil.newDarkLightBtn(self, 2, LangCtrl:getLang().word324, cc.size(150, 50), 30, clickSearchUser, 1.5):align(display.CENTER, 680, pos_y)

    GameUtil.createLabel(LangCtrl:getLang().word187, 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(50, self.winSize.height - 235)):addTo(img_bg_top)
    local posX = 170
    if LangCtrl:isEng() then
        posX = 250
    end
    self.lbl_chineseStr = GameUtil.createLabel("", 20, cc.c3b(0xe2, 0x5b, 0x3b), display.LEFT_CENTER, cc.p(posX, self.winSize.height - 235)):addTo(img_bg_top)

    pos_y = self.winSize.height - 280
    local function editboxHandle_Goal(eventname, sender)
        if eventname == "began" then -- 光标进入
        elseif eventname == "ended" then -- 当编辑框失去焦点并且键盘消失的时候调用
            local numStr = sender:getText()
            local num = tonumber(numStr)
            if num == nil then
                num = 0
            end

            if num > globalUserInfo.lUserInsure then
                num = globalUserInfo.lUserInsure
            end
            sender:setText(tostring(num))

            local chineseStr = GameUtil.getChineNumStr(num)
            self.lbl_chineseStr:setString(chineseStr)
        elseif eventname == "return" then -- 当用户点击编辑框的键盘以外的区域，或者键盘的return按钮被点击时所调用
        elseif eventname == "changed" then -- 输入内容改变时调用
            local numStr = sender:getText()
            local num = tonumber(numStr)
            if num == nil then
                num = 0
            end
            local chineseStr = GameUtil.getChineNumStr(num)
            self.lbl_chineseStr:setString(chineseStr)
        end
    end
    local edit_Goal = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_Goal:setFont(GameDefine.FontName, 30)
    edit_Goal:setFontColor(GameDefine.FontColor_edit)
    edit_Goal:setMaxLength(11)
    edit_Goal:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_Goal:setPlaceHolder(LangCtrl:getLang().word139)
    edit_Goal:setPlaceholderFontSize(30)
    edit_Goal:setPlaceholderFontName(GameDefine.FontName)
    edit_Goal:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_Goal:align(display.LEFT_CENTER, 50, pos_y):addTo(img_bg_top)
    edit_Goal:registerScriptEditBoxHandler(editboxHandle_Goal)
    self.edit_Goal = edit_Goal
    -- 清除按钮
    local function clickClear(btn)
        self.edit_Goal:setText("")
        self.lbl_chineseStr:setString("")
    end
    GameUtil.newDarkLightBtn(img_bg_top, 2, LangCtrl:getLang().word323, cc.size(150, 50), 30, clickClear, 1.5):align(display.CENTER, 680, pos_y)

    local function clicakNum(btn)
        local numStr = self.edit_Goal:getText()
        local num = 0

        if string.len(numStr) > 0 then
            num = tonumber(numStr)
        end

        if num == nil then
            num = 0
        end

        if btn.NumValues == 1 then -- 全部
            num = globalUserInfo.lUserInsure
        elseif (num + btn.NumValues) > globalUserInfo.lUserInsure then
            num = globalUserInfo.lUserInsure
        else
            num = num + btn.NumValues
        end

        self.edit_Goal:setText(tostring(num))

        local chineseStr = GameUtil.getChineNumStr(num)
        self.lbl_chineseStr:setString(chineseStr)
    end

    local lblColor = cc.c3b(134, 122, 108)
    local lblpos = cc.p(87, 32)
    local btn_res = "app/win/bank/bnt_bxx3.png"
    local tNums = {140000, 280000, 700000, 1400000, 7000000, 14000000, 50000000}
    if LangCtrl:isEng() then -- 英文版的价格机制
        tNums = {140000, 280000, 700000, 1400000, 7000000, 14000000, 50000000}
    end

    self.tBtnList = {{
        btnname = LangCtrl:getLang().word188,
        btnvalue = tNums[1]
    }, {
        btnname = LangCtrl:getLang().word189,
        btnvalue = tNums[2]
    }, {
        btnname = LangCtrl:getLang().word190,
        btnvalue = tNums[3]
    }, {
        btnname = LangCtrl:getLang().word191,
        btnvalue = tNums[4]
    }, {
        btnname = LangCtrl:getLang().word192,
        btnvalue = tNums[5]
    }, {
        btnname = LangCtrl:getLang().word193,
        btnvalue = tNums[6]
    }, {
        btnname = LangCtrl:getLang().word194,
        btnvalue = tNums[7]
    }, {
        btnname = LangCtrl:getLang().word195,
        btnvalue = 1
    }}

    if LangCtrl:isCN() and globalUserInfo.cbMemberOrder and globalUserInfo.cbMemberOrder < 4 then
        self.tBtnList = {{
            btnname = "14.5万",
            btnvalue = 145000
        }, {
            btnname = "29万",
            btnvalue = 290000
        }, {
            btnname = "72.5万",
            btnvalue = 725000
        }, {
            btnname = "145万",
            btnvalue = 1450000
        }, {
            btnname = "725万",
            btnvalue = 7250000
        }, {
            btnname = "1450万",
            btnvalue = 14500000
        }, {
            btnname = "5000万",
            btnvalue = 50000000
        }, {
            btnname = LangCtrl:getLang().word195,
            btnvalue = 1
        }}
    end

    for i, v in ipairs(self.tBtnList) do
        local posx = 120 + ((i - 1) % 4) * 185
        local posy = self.winSize.height - 355 - math.floor((i - 1) / 4) * 80
        local btn = GameUtil.createButton(btn_res, nil, clicakNum):move(posx, posy):addTo(img_bg_top)
        btn.NumValues = v.btnvalue
        local lbl = GameUtil.createLabel(v.btnname, 28, lblColor, display.CENTER, lblpos)
        lbl:addTo(btn:getVirtualRenderer())
        lbl:enableOutline(cc.c4b(60, 55, 49, 255), 1)
    end

    local function clickGiveMoney(btn)
        if GameDefine.bIsTestUI then
            self.seachUserSucc = true
        end

        local giveuserID = self.edit_GameID:getText()
        if string.len(giveuserID) < 5 then
            PlazaManager.showTips(LangCtrl:getLang().word186)
            return
        end

        if self.seachUserSucc == false then
            PlazaManager.showTips(LangCtrl:getLang().word196)
            return
        end

        local numStr = self.edit_Goal:getText()
        if numStr == nil or numStr == "" then
            PlazaManager.showTips(LangCtrl:getLang().word197)
            return
        end
        local lTransferScore = tonumber(numStr)
        if lTransferScore == nil then
            PlazaManager.showTips(LangCtrl:getLang().word197)
            return
        end

        if lTransferScore == 0 then
            PlazaManager.showTips(LangCtrl:getLang().word198)
            return
        end
        self:showGiveConfirm(giveuserID, lTransferScore)
    end
    local btn_giveMoney = GameUtil.createButton("app/common/button/btn1.png", nil, clickGiveMoney):move(335, 50):addTo(self)
    GameUtil.addBtnTTF2(LangCtrl:getLang().word16, btn_giveMoney) -- 赠送

    local function clickOpenRecordView(btn)
        local subui = BankNodeGiveRecord.new(self)
        subui:align(display.LEFT_BOTTOM, 0, 0)
        subui:addToOnCheckExist(self)
    end
    local btn = GameUtil.newBlankBtn(self, cc.size(200, 50), clickOpenRecordView):move(650, 40)
    local lbl = GameUtil.addBtnTTF0(LangCtrl:getLang().word325, btn, 24):enableUnderline() -- 下划线
    lbl:align(display.CENTER, 100, 25)
end

function BankNodeGiveGoal:showGiveConfirm(giveuserID, lTransferScore)
    local giveNiceName = self.lbl_giveNiceName:getString()
    local giveGameID = giveuserID

    local showPanel = cc.Node:create()
    showPanel:setContentSize(650, 300)

    GameUtil.createLabel(LangCtrl:getLang().word199, 40, cc.c3b(0x9c, 0x96, 0x8a), display.CENTER, cc.p(325, 245)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word180 .. ":", 30, self.strcolor, display.RIGHT_CENTER, cc.p(350, 125)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word185, 30, self.strcolor, display.RIGHT_CENTER, cc.p(350, 95)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word201, 30, self.strcolor, display.RIGHT_CENTER, cc.p(350, 65)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word202, 30, self.strcolor, display.RIGHT_CENTER, cc.p(350, 35)):addTo(showPanel)

    GameUtil.createLabel(tostring(giveNiceName), 24, self.strcolor, display.LEFT_CENTER, cc.p(360, 125)):addTo(showPanel)
    GameUtil.createLabel(tostring(giveGameID), 24, self.strcolor, display.LEFT_CENTER, cc.p(360, 95)):addTo(showPanel)
    GameUtil.createLabel(GameUtil.getShowNumStr(lTransferScore), 24, self.strcolor, display.LEFT_CENTER, cc.p(360, 65)):addTo(showPanel)
    GameUtil.createLabel(GameUtil.getChineNumStr(lTransferScore), 24, cc.c3b(227, 132, 109), display.LEFT_CENTER, cc.p(360, 35)):addTo(showPanel)
    self:showMsgConfirmPanel("yes_no", showPanel, function(okChk)
        if okChk == true then
            if GameDefine.bIsTestUI then
                self:onTransferSucc(self:doTestSuccGive())
            else
                self:sendTransferMessage(lTransferScore, giveuserID)
            end
        end
    end)
end

function BankNodeGiveGoal:doTestSuccGive()
    local result = {}

    result.lUserScore = 88888 -- 用户金币
    result.lUserInsure = 88888 -- 银行金币
    result.dwRecordID = 123123123 -- 记录ID
    result.dwSourceUserID = 123123 -- 赠送用户ID
    result.dwTargetUserID = 321321 -- 获赠用户ID
    result.szSourceNickName = "赠送用户昵称" -- 赠送用户昵称
    result.szTargetNickName = "获赠用户昵称" -- 获赠用户昵称
    result.lScore = 666666 -- 赠送游戏币

    result.dtTime = {}
    result.dtTime.wYear = 2023 -- 年
    result.dtTime.wMonth = 12 -- 月
    result.dtTime.wDayOfWeek = 3 -- 星期，0=星期日，1=星期一
    result.dtTime.wDay = 11 -- 日
    result.dtTime.wHour = 12 -- 时
    result.dtTime.wMinute = 58 -- 分
    result.dtTime.wSecond = 23 -- 秒
    result.dtTime.wMilliseconds = 22 -- 毫秒
    return result
end

function BankNodeGiveGoal:setUserInfoShow(isShow)
    self.headnode:setVisible(isShow)
    self.headbjk:setVisible(isShow)
    self.lbl_giveNiceName:setVisible(isShow)
end

function BankNodeGiveGoal:onEnter()
    self:addEvent()
end

function BankNodeGiveGoal:onExit()
    self:removeEvent()
end

function BankNodeGiveGoal:onClearUp()
    self:disableNodeEvents()
end

function BankNodeGiveGoal:addEvent()
    self.eventData = {}
    self.eventData.onSeachGiveUserSucc = function(data)
        self:onSeachGiveUserSucc(data)
    end -- 查询用户成功
    self.eventData.onSeachGiveUserFail = function(data)
        self:onSeachGiveUserFail(data)
    end -- 查询用户失败
    self.eventData.onTransferSucc = function(data)
        self:onTransferSucc(data)
    end -- 赠送金币成功

    game.registerEvent(GameDefine.Bank_Back_SeachGiveUserSucc, self.eventData.onSeachGiveUserSucc)
    game.registerEvent(GameDefine.Bank_Back_SeachGiveUserFail, self.eventData.onSeachGiveUserFail)
    game.registerEvent(GameDefine.Bank_Back_TransferSucc, self.eventData.onTransferSucc)
end

function BankNodeGiveGoal:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_SeachGiveUserSucc, self.eventData.onSeachGiveUserSucc)
    game.unregisterEvent(GameDefine.Bank_Back_SeachGiveUserFail, self.eventData.onSeachGiveUserFail)
    game.unregisterEvent(GameDefine.Bank_Back_TransferSucc, self.eventData.onTransferSucc)
end

------------------------------------逻辑函数-----------------------------
function BankNodeGiveGoal:sendSeachGiveUserMessage(giveuserID)
    local data = {}
    data.GiveUserID = giveuserID

    local function failFuntion()
        self.edit_GameID:setText("")
        self.headnode:removeAllChildren()
        self.lbl_giveNiceName:setString("")
        self:setUserInfoShow(false)
    end

    PlazaManager.showConectWaitTips(failFuntion)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, failFuntion, LangCtrl:getLang().word203, LangCtrl:getLang().word204)
    end
    PlazaManager.getLoginModule().onSendSeachGiveUserInfo(data, onConnectResult)
end

function BankNodeGiveGoal:sendTransferMessage(lTransferScore, giveuserID)
    local data = {}
    data.lTransferScore = lTransferScore
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr
    data.gameID = tostring(giveuserID)

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word205, LangCtrl:getLang().word206)
    end
    PlazaManager.getLoginModule().onSendGiveGoal(data, onConnectResult)
end

function BankNodeGiveGoal:onSeachGiveUserSucc(data)
    PlazaManager.closeWattingTips()
    self:setUserInfoShow(true)
    self.headnode:removeAllChildren()
    GameUtil.createAvatar(data.szHeadImg, 80, true, nil, nil, nil, nil):align(display.CENTER, 40, 40):addTo(self.headnode)
    self.lbl_giveNiceName:setString(data.szNickName)
    self.seachUserSucc = true
end

function BankNodeGiveGoal:onSeachGiveUserFail(data)
    PlazaManager.closeWattingTips()
    PlazaManager.showTips(data.szDescribeString, cc.p(display.cx, display.cy + 195))
    self.edit_GameID:setText("")
    self.headnode:removeAllChildren()
    self.lbl_giveNiceName:setString("")
    self:setUserInfoShow(false)
end

function BankNodeGiveGoal:onTransferSucc(data)
    self.lbl_bankGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserInsure))
    self.edit_Goal:setText("")
    self.lbl_chineseStr:setString("")
    PlazaManager.closeWattingTips()

    local showPanel = cc.Node:create()
    showPanel:setContentSize(650, 300)

    local posX = 200
    if LangCtrl:isEng() then
        posX = 100
    end

    local yesicon = ccui.ImageView:create("app/login/img_yes.png"):align(display.CENTER, posX, 260):addTo(showPanel)

    local succtips = cc.Label:createWithTTF(LangCtrl:getLang().word326, "app/fonts/fzcs.ttf", 28)
    succtips:align(display.LEFT_CENTER, 50, 13)
    succtips:setColor(cc.c3b(111, 178, 86))
    succtips:addTo(yesicon)

    local leftX, rightX = 130, 580
    GameUtil.createLabel(LangCtrl:getLang().word179 .. ":", 24, self.strcolor, display.RIGHT_CENTER, cc.p(leftX, 150)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word207, 24, self.strcolor, display.RIGHT_CENTER, cc.p(rightX, 150)):addTo(showPanel)

    GameUtil.createLabel(LangCtrl:getLang().word180 .. ":", 24, self.strcolor, display.RIGHT_CENTER, cc.p(leftX, 120)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word185, 24, self.strcolor, display.RIGHT_CENTER, cc.p(rightX, 120)):addTo(showPanel)

    GameUtil.createLabel(LangCtrl:getLang().word201, 24, self.strcolor, display.RIGHT_CENTER, cc.p(leftX, 90)):addTo(showPanel)
    GameUtil.createLabel(LangCtrl:getLang().word202, 24, self.strcolor, display.RIGHT_CENTER, cc.p(leftX, 60)):addTo(showPanel)

    GameUtil.createLabel(tostring(data.szSourceNickName), 24, self.strcolor, display.LEFT_CENTER, cc.p(leftX + 5, 150), nil, cc.size(180, 30)):addTo(showPanel)
    GameUtil.createLabel(tostring(data.dwSourceUserID), 24, self.strcolor, display.LEFT_CENTER, cc.p(rightX + 5, 150)):addTo(showPanel)

    GameUtil.createLabel(tostring(data.szTargetNickName), 24, self.strcolor, display.LEFT_CENTER, cc.p(leftX + 5, 120), nil, cc.size(180, 30)):addTo(showPanel)
    GameUtil.createLabel(tostring(data.dwTargetUserID), 24, self.strcolor, display.LEFT_CENTER, cc.p(rightX + 5, 120)):addTo(showPanel)

    GameUtil.createLabel(GameUtil.getShowNumStr(data.lScore), 24, self.strcolor, display.LEFT_CENTER, cc.p(leftX + 5, 90)):addTo(showPanel)
    GameUtil.createLabel(GameUtil.getChineNumStr(data.lScore), 24, cc.c3b(227, 132, 109), display.LEFT_CENTER, cc.p(leftX + 5, 60)):addTo(showPanel)

    local dtTime = data.dtTime
    local timestr = string.format("%s-%s-%s %s:%s:%s", dtTime.wYear, dtTime.wMonth, dtTime.wDay, dtTime.wHour, dtTime.wMinute, dtTime.wSecond)
    GameUtil.createLabel(timestr, 24, self.strcolor, display.RIGHT_CENTER, cc.p(680, 30)):addTo(showPanel)

    GameUtil.createLabel(LangCtrl:getLang().word208, 24, self.strcolor, display.CENTER, cc.p(325, -15)):addTo(showPanel)

    self:showMsgConfirmPanel("ok", showPanel, nil)
end

-- 确定取消框
function BankNodeGiveGoal:showMsgConfirmPanel(types, contentNode, callback)
    local winsize = cc.size(1002, 616)
    local midWidth, midHeight = winsize.width / 2, winsize.height / 2
    local mainNode = display.newNode()
    mainNode:setContentSize(winsize)
    mainNode:align(display.CENTER, display.cx, display.cy):addTo(display.getRunningScene(), 254)

    local function onTouchBegan(touch, event)
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    mainNode:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, mainNode)

    local mask = display.newSprite("app/common/mask.png")
    mask:setScale(display.width / 5, display.height / 5)
    mask:setOpacity(180)
    mask:move(midWidth, midHeight):addTo(mainNode)

    local showNode = display.newNode()
    showNode:setContentSize(winsize)
    showNode:align(display.CENTER, midWidth, midHeight):addTo(mainNode)

    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_1.png")
    bg_1:setCapInsets(GameDefine.PanelRect1)
    bg_1:setContentSize(winsize.width, winsize.height)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(showNode)

    --[[
    local bg_2 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    bg_2:setCapInsets(GameDefine.PanelRect2)
    bg_2:setContentSize(winsize.width - 90, winsize.height - 80)
    bg_2:align(display.LEFT_BOTTOM, 45, 40):addTo(showNode)
    --]]

    local titlebg = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    titlebg:setCapInsets(GameDefine.PanelRect3)
    titlebg:setContentSize(winsize.width - 10, 64)
    titlebg:align(display.CENTER_BOTTOM, midWidth, winsize.height - 68):addTo(showNode)

    local bg_top = ccui.ImageView:create("app/common/comwin/panel_title.png")
    -- bg_top:ignoreContentAdaptWithSize(false)
    -- bg_top:setContentSize(cc.size(winsize.width + 10, 95))
    bg_top:align(display.CENTER_BOTTOM, midWidth, winsize.height - 66):addTo(showNode)

    GameUtil.addTitleTTF(LangCtrl:getLang().word18, bg_top) -- 提示

    if contentNode ~= nil then
        contentNode:align(display.CENTER, midWidth, midHeight + 50):addTo(showNode)
    end

    if types == "ok" then
        local function onClickCallBack(args)
            PlazaManager.playClickEffect()
            mainNode:removeFromParent()
            if callback ~= nil then
                callback(true)
            end
        end
        local okBtn = ccui.Button:create("app/common/button/btn1.png")
        okBtn:addClickEventListener(onClickCallBack)
        okBtn:setZoomScale(-0.1)
        okBtn:align(display.CENTER, midWidth, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, okBtn) -- 确定
    elseif types == "yes_no" then
        local function onYesCallBack(args)
            PlazaManager.playClickEffect()
            mainNode:removeFromParent()
            if callback ~= nil then
                callback(true)
            end
        end

        local function onNoCallBack(args)
            PlazaManager.playClickEffect()
            mainNode:removeFromParent()
            if callback ~= nil then
                callback(false)
            end
        end

        local yesBtn = ccui.Button:create("app/common/button/btn1.png")
        yesBtn:addClickEventListener(onYesCallBack)
        yesBtn:setZoomScale(-0.1)
        yesBtn:align(display.CENTER, midWidth - 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, yesBtn) -- 确定

        local noBtn = ccui.Button:create("app/common/button/btn2.png")
        noBtn:addClickEventListener(onNoCallBack)
        noBtn:setZoomScale(-0.1)
        noBtn:align(display.CENTER, midWidth + 150, 110):addTo(showNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word12, noBtn) -- 取消
    end

    showNode:setScale(0.5)
    showNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

return BankNodeGiveGoal
