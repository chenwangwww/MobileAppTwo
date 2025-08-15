-- 金币存取
local BankNodeSave = class("BankNodeSave", function()
    return cc.Node:create()
end)

function BankNodeSave:ctor(bankui)
    self.winSize = bankui.rightSize
    self.midWidth = self.winSize.width / 2
    self:enableNodeEvents()
    self:setName("BankNodeSave")
    self:setContentSize(self.winSize)

    self.refreshtime = os.time()

    local imgbgtop = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    imgbgtop:setCapInsets(GameDefine.PanelRect2)
    imgbgtop:setContentSize(cc.size(self.winSize.width, 120))
    imgbgtop:align(display.CENTER_TOP, self.midWidth, self.winSize.height):addTo(self)

    -- 箱内存款
    local numbg = ccui.ImageView:create("app/common/mask.png")
    numbg:setScale9Enabled(true)
    numbg:setCapInsets(cc.rect(2, 2, 1, 1))
    numbg:setContentSize(cc.size(240, 40))
    numbg:align(display.LEFT_CENTER, 100, 49):addTo(imgbgtop)

    local numbgSize = numbg:getContentSize()
    local numbgcy = numbgSize.height / 2
    GameUtil.newSprite("app/win/bank/icon_gg_bxx.png", false):align(display.RIGHT_CENTER, -10, numbgcy):addTo(numbg)
    GameUtil.createLabel(LangCtrl:getLang().word136, 24, GameDefine.FontColor, display.LEFT_BOTTOM, cc.p(10, numbgSize.height + 5)):addTo(numbg)
    self.lbl_bankGoal = GameUtil.createLabel("0", 30, GameDefine.FontCoinColor, display.LEFT_CENTER, cc.p(10, numbgcy)):addTo(numbg)
    self.lbl_bankGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserInsure))

    -- 携带金额
    numbg = ccui.ImageView:create("app/common/mask.png")
    numbg:setScale9Enabled(true)
    numbg:setCapInsets(cc.rect(2, 2, 1, 1))
    numbg:setContentSize(cc.size(240, 40))
    numbg:align(display.CENTER, 615, 49):addTo(imgbgtop)

    GameUtil.newSprite("app/win/bank/icon_gg_gold.png", false):align(display.RIGHT_CENTER, -10, numbgcy):addTo(numbg)
    GameUtil.createLabel(LangCtrl:getLang().word137, 24, GameDefine.FontColor, display.LEFT_BOTTOM, cc.p(10, numbgSize.height + 5)):addTo(numbg)
    self.lbl_outGoal = GameUtil.createLabel("0", 30, GameDefine.FontCoinColor, display.LEFT_CENTER, cc.p(10, numbgcy)):addTo(numbg)
    self.lbl_outGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserScore))

    -- 刷新按钮
    local function clickRefresh(btn)
        self:onRefreshClick()
    end
    GameUtil.addEnlargeBtn("app/hall/top/btn_refresh.png", 1.5, clickRefresh):align(display.LEFT_CENTER, numbgSize.width, numbgcy):addTo(numbg)

    local midsize = cc.size(self.winSize.width, 440)
    local imgbgmid = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    imgbgmid:setCapInsets(GameDefine.PanelRect2)
    imgbgmid:setContentSize(midsize)
    imgbgmid:align(display.CENTER_BOTTOM, self.midWidth, 0):addTo(self)

    GameUtil.createLabel(LangCtrl:getLang().word138, 24, GameDefine.FontColor, display.LEFT_CENTER, cc.p(50, midsize.height - 50)):addTo(imgbgmid)

    local posX = 230
    if LangCtrl:isEng() then
        posX = 260
    end
    self.lbl_chineseStr = GameUtil.createLabel("", 24, cc.c3b(226, 91, 59), display.LEFT_CENTER, cc.p(posX, midsize.height - 55)):addTo(imgbgmid)

    local function editboxHandle(eventname, sender)
        if eventname == "began" then -- 光标进入
        elseif eventname == "ended" then -- 当编辑框失去焦点并且键盘消失的时候调用
            local numStr = sender:getText()
            local num = tonumber(numStr)
            if num == nil then
                num = 0
            end

            if num > math.max(globalUserInfo.lUserInsure, globalUserInfo.lUserScore) then
                num = math.max(globalUserInfo.lUserInsure, globalUserInfo.lUserScore)
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
    edit_Goal:align(display.LEFT_CENTER, 50, midsize.height - 100):addTo(imgbgmid)
    edit_Goal:registerScriptEditBoxHandler(editboxHandle)
    self.edit_Goal = edit_Goal
    -- 清除按钮
    local function clickClear(btn)
        self.edit_Goal:setText("")
        self.lbl_chineseStr:setString("")
    end
    GameUtil.newDarkLightBtn(imgbgmid, 2, LangCtrl:getLang().word323, cc.size(150, 50), 30, clickClear, 1.5):align(display.CENTER, 680, midsize.height - 100)

    local function clicakNum(btn)
        local numStr = self.edit_Goal:getText()
        local num = 0

        if string.len(numStr) > 0 then
            num = tonumber(numStr)
        end

        if num == nil then
            num = 0
        end

        if btn.NumValues == 0 then -- 全部取出
            num = globalUserInfo.lUserInsure
        elseif btn.NumValues == 1 then -- 全部存入
            num = globalUserInfo.lUserScore
        else
            if (num + btn.NumValues) > math.max(globalUserInfo.lUserInsure, globalUserInfo.lUserScore) then
                num = math.max(globalUserInfo.lUserInsure, globalUserInfo.lUserScore)
            else
                num = num + btn.NumValues
            end
        end

        self.edit_Goal:setText(tostring(num))
        local chineseStr = GameUtil.getChineNumStr(num)
        self.lbl_chineseStr:setString(chineseStr)
    end

    local lblColor = cc.c3b(134, 122, 108)
    local lblpos = cc.p(87, 32)
    local btn_res = "app/win/bank/bnt_bxx3.png"
    self.tBtnList = {{
        btnname = LangCtrl:getLang().word140,
        btnvalue = 10000
    }, {
        btnname = LangCtrl:getLang().word141,
        btnvalue = 100000
    }, {
        btnname = LangCtrl:getLang().word142,
        btnvalue = 1000000
    }, {
        btnname = LangCtrl:getLang().word143,
        btnvalue = 10000000
    }, {
        btnname = LangCtrl:getLang().word144,
        btnvalue = 50000000
    }, {
        btnname = LangCtrl:getLang().word145,
        btnvalue = 100000000
    }, {
        btnname = LangCtrl:getLang().word146,
        btnvalue = 1
    }, {
        btnname = LangCtrl:getLang().word147,
        btnvalue = 0
    }}

    for i, v in ipairs(self.tBtnList) do
        local posx = 120 + ((i - 1) % 4) * 185
        local posy = midsize.height - 200 - math.floor((i - 1) / 4) * 80
        local btn = GameUtil.createButton(btn_res, nil, clicakNum):move(posx, posy):addTo(imgbgmid)
        btn.NumValues = v.btnvalue
        local lbl = GameUtil.createLabel(v.btnname, 28, lblColor, display.CENTER, lblpos)
        lbl:addTo(btn:getVirtualRenderer())
        lbl:enableOutline(cc.c4b(60, 55, 49, 255), 1)
    end

    local function clickSaveMoney(btn)
        local optNumStr = self.edit_Goal:getText()
        if optNumStr == nil or optNumStr == "" then
            PlazaManager.showTips(LangCtrl:getLang().word148)
            return
        end

        local optNum = tonumber(optNumStr)
        if optNum == nil then
            PlazaManager.showTips(LangCtrl:getLang().word149)
            return
        end

        if optNum > globalUserInfo.lUserScore then
            PlazaManager.showTips(LangCtrl:getLang().word150)
            return
        end
        self:sendSaveScoreMessage(optNum)
    end
    local btn_saveMoney = GameUtil.createButton("app/common/button/btn2.png", nil, clickSaveMoney):move(self.midWidth - 150, 60):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word20, btn_saveMoney) -- 存入

    local function clickOutMoney(btn)
        local optNumStr = self.edit_Goal:getText()
        if optNumStr == nil or optNumStr == "" then
            PlazaManager.showTips(LangCtrl:getLang().word151)
            return
        end

        local optNum = tonumber(optNumStr)
        if optNum == nil then
            PlazaManager.showTips(LangCtrl:getLang().word152)
            return
        end

        if optNum > globalUserInfo.lUserInsure then
            PlazaManager.showTips(LangCtrl:getLang().word153)
            return
        end
        self:sendTakeScoreMessage(optNum)
    end
    local btn_outMoney = GameUtil.createButton("app/common/button/btn1.png", nil, clickOutMoney):move(self.midWidth + 150, 60):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word19, btn_outMoney) -- 取出
end

function BankNodeSave:onEnter()
    self:addEvent()
end

function BankNodeSave:onExit()
    self:removeEvent()
end

function BankNodeSave:onClearUp()
    self:disableNodeEvents()
end

function BankNodeSave:addEvent()
    self.eventData = {}
    self.eventData.onSeachInfoSucc = function()
        self:onSeachInfoSucc()
    end -- 绑定手机号成功
    self.eventData.onSaveTakeBankInfoSucc = function()
        self:onSaveTakeBankInfoSucc()
    end -- 存取款成功

    game.registerEvent(GameDefine.Bank_Back_SeachInfoSucc, self.eventData.onSeachInfoSucc)
    game.registerEvent(GameDefine.Bank_Back_SaveTakeSucc, self.eventData.onSaveTakeBankInfoSucc)
end

function BankNodeSave:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_SeachInfoSucc, self.eventData.onSeachInfoSucc)
    game.unregisterEvent(GameDefine.Bank_Back_SaveTakeSucc, self.eventData.onSaveTakeBankInfoSucc)
end

----------------------------------------UI 函数------------------------

function BankNodeSave:onRefreshClick()
    if os.difftime(os.time(), self.refreshtime) > 1 then
        self.refreshtime = os.time()
        self:sendBankRefreshMessage()
    else
        PlazaManager.showTips(LangCtrl:getLang().word158)
    end
end

------------------------------------逻辑函数-----------------------------
function BankNodeSave:sendBankRefreshMessage()
    local data = {}
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word134, LangCtrl:getLang().word135)
    end

    PlazaManager.getLoginModule().onSearchBankInfo(data, onConnectResult)
end

-- 发送存款消息
function BankNodeSave:sendSaveScoreMessage(saveScore)
    local data = {}
    data.saveScore = saveScore

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word154, LangCtrl:getLang().word155)
    end

    PlazaManager.getLoginModule().onStoreGold(data, onConnectResult)
end

-- 发送取款消息
function BankNodeSave:sendTakeScoreMessage(takeScore)
    local data = {}
    data.takeScore = takeScore
    data.passType = PlazaManager.bankPassType
    data.passStr = PlazaManager.bankPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word156, LangCtrl:getLang().word157)
    end
    PlazaManager.getLoginModule().onTakeScore(data, onConnectResult)
end

function BankNodeSave:onSeachInfoSucc()
    PlazaManager.closeWattingTips()

    self:onSaveTakeBankInfoSucc()

    if PlazaManager.bankOpenType == 4 then
        PlazaManager.showTips(LangCtrl:getLang().word97)
    end
end

function BankNodeSave:onSaveTakeBankInfoSucc()
    self.lbl_bankGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserInsure))
    self.lbl_outGoal:setString(GameUtil.getShowNumStr(globalUserInfo.lUserScore))
    self.edit_Goal:setText("")
    self.lbl_chineseStr:setString("")
end

return BankNodeSave
