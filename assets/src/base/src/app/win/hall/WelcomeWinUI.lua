local WelcomeWinUI = class("WelcomeWinUI", require "app.win.base.GameWindowBase")

function WelcomeWinUI:ctor(pageData)
    self.winSize = cc.size(1136, 668)
    self.right_size = cc.size(self.winSize.width - 330, self.winSize.height - 100)
    self.rightcx, self.rightcy = self.right_size.width / 2, self.right_size.height / 2

    WelcomeWinUI.super.ctor(self, self.winSize, true, false)
    self:setName("WelcomeWinUI")
    self.chooseChk = false

    self:addBasePanel()
    self:addTopBg()

    local img_bg_top = cc.Scale9Sprite:create("app/win/welcome/titlebg1.png") -- 568 76
    -- img_bg_top:setCapInsets(CCRectMake(50, 1, 10, 66))
    -- img_bg_top:setContentSize(cc.size(516, 68))
    img_bg_top:setAnchorPoint(display.CENTER)
    img_bg_top:setPosition(self.midWidth, self.winSize.height - 30)
    self.panelNode:addChild(img_bg_top)

    local btnSize = cc.size(284, 68)
    self.toptab_selected = cc.Scale9Sprite:create("app/win/welcome/titlebg2.png") -- 53 66
    self.toptab_selected:setCapInsets(CCRectMake(49, 1, 2, 64))
    self.toptab_selected:setContentSize(btnSize)
    img_bg_top:addChild(self.toptab_selected)

    local function onWelcomBtnClick(ref)
        self:createActiveOrWelcomPanle(false)
    end
    self.welcomBtn = GameUtil.newBlankBtn(img_bg_top, btnSize, onWelcomBtnClick):align(display.CENTER, 142, 38)
    self.welcomLabel = GameUtil.addTitleTTF(LangCtrl:getLang().word321, self.welcomBtn)

    local function onActiveBtnClick(ref)
        self:createActiveOrWelcomPanle(true)
    end
    self.activeBtn = GameUtil.newBlankBtn(img_bg_top, btnSize, onActiveBtnClick):align(display.CENTER, 426, 38)
    self.activeLabel = GameUtil.addTitleTTF(LangCtrl:getLang().word322, self.activeBtn)

    local showPanel = cc.Node:create()
    showPanel:setContentSize(self.winSize)
    showPanel:align(display.CENTER, self.midWidth, self.midHeight):addTo(self.panelNode)
    self.showPanel = showPanel

    self:addCloseBtn()

    if self:getActivMinSortID() < self:getWelcomMinSortID() then
        self:createActiveOrWelcomPanle(true)
    else
        self:createActiveOrWelcomPanle(false)
    end
end

function WelcomeWinUI:onEnter()
    WelcomeWinUI.super.onEnter(self)

    self.panelNode:setScale(0.5)
    self.panelNode:runAction(cc.ScaleTo:create(0.2, 1.0))

    self.refreshTime = os.time()
    self:stopScheduler()
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        local listView = self.showPanel:getChildByName("buttonListView")
        if listView == nil then
            return
        end

        if os.difftime(os.time(), self.refreshTime) >= 9 and self.chooseChk == false then
            self.refreshTime = os.time()
            local index = listView:getCurSelectedIndex()

            local itemList = listView:getItems()
            local count = #itemList

            local nextIndex = index + 1
            if nextIndex >= count then
                nextIndex = 0
            end

            listView:setCurSelectedIndex(nextIndex)
        end
    end, 3, false)
end

function WelcomeWinUI:onExit()
    self.rightNode = nil
    self:stopScheduler()
    for i = 1, PlazaManager.WelcomeCount do
        if PlazaManager.WelcomeDataList[i].wContentType == 0 or PlazaManager.WelcomeDataList[i].wContentType == 1 then
            PlazaManager.WelcomeDataList[i].msgState = 1
        end
    end

    WelcomeWinUI.super.onExit(self)
end

function WelcomeWinUI:stopScheduler()
    if self.schedulerID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function WelcomeWinUI:onClearUp()
    self.rightNode = nil
    self:stopScheduler()
    WelcomeWinUI.super.onClearUp(self)
end

function WelcomeWinUI:createActiveOrWelcomPanle(isActiv)
    self.isActiv = isActiv
    self.showPanel:removeAllChildren()
    self.rightNode = nil
    local activeData = {}
    if isActiv == true then
        self.toptab_selected:setPosition(426, 38)
        self.toptab_selected:setFlippedX(true)
        self.welcomBtn:setEnabled(true)
        self.activeBtn:setEnabled(false)
        self.welcomLabel:setColor(cc.c3b(0x84, 0xa1, 0xc3))
        self.activeLabel:setColor(cc.c3b(255, 255, 255))
        activeData = self:getActivData()
    else
        self.toptab_selected:setPosition(142, 38)
        self.toptab_selected:setFlippedX(false)
        self.welcomBtn:setEnabled(false)
        self.activeBtn:setEnabled(true)
        self.activeLabel:setColor(cc.c3b(0x84, 0xa1, 0xc3))
        self.welcomLabel:setColor(cc.c3b(255, 255, 255))
        activeData = self:getWelcomData()
    end

    if GameDefine.bIsTestUI then
        self:genTestData(activeData)
    end

    -- local btncolor1, btncolor2 = cc.c3b(0x87, 0x7b, 0x6b), cc.c3b(0x44, 0x3d, 0x33)
    local btncolor1, btncolor2 = cc.c3b(0x87, 0x7b, 0x6b), cc.c3b(250, 247, 212)
    if #activeData == 0 then
        local ss = cc.size(self.winSize.width - 40, self.winSize.height - 100)
        local img_bg_3 = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
        img_bg_3:setCapInsets(GameDefine.PanelRect2)
        img_bg_3:setContentSize(ss)
        img_bg_3:align(display.CENTER_BOTTOM, self.midWidth, 20):addTo(self.showPanel)

        if isActiv == true then
            GameUtil.createLabel(LangCtrl:getLang().word120, 36, cc.c3b(0xbc, 0xde, 0xff), display.CENTER, cc.p(ss.width / 2, ss.height / 2 + 50), nil, nil):addTo(img_bg_3)
        else
            GameUtil.createLabel(LangCtrl:getLang().word121, 36, cc.c3b(0xbc, 0xde, 0xff), display.CENTER, cc.p(ss.width / 2, ss.height / 2 + 50), nil, nil):addTo(img_bg_3)
        end
        GameUtil.createLabel("~~~~（>_<）~~~~", 36, cc.c3b(0xbc, 0xde, 0xff), display.CENTER, cc.p(ss.width / 2, ss.height / 2 - 50), nil, nil):addTo(img_bg_3)
    else
        if self.rightNode then
            self.rightNode:removeFromParent()
            self.rightNode = nil
        end
        self.rightNode = cc.Node:create()
        self.rightNode:setContentSize(self.right_size)
        self.rightNode:align(display.RIGHT_BOTTOM, self.winSize.width - 20, 20):addTo(self.showPanel)

        local fontSize = 40
        local fontName = GameDefine.FontName
        if LangCtrl:isEng() then
            fontSize = 30
            fontName = "fonts/fzcy.ttf"
        end

        local buttonListView = ccui.ListView:create()
        buttonListView:setDirection(ccui.ScrollViewDir.vertical)
        buttonListView:setContentSize(cc.size(250, self.right_size.height - 5))
        buttonListView:setBounceEnabled(false)
        buttonListView:setScrollBarEnabled(true)
        buttonListView:setTouchEnabled(true)
        buttonListView:setItemsMargin(10)
        buttonListView:setName("buttonListView")
        buttonListView:addEventListener(function(target, eventType)
            if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
                self.chooseChk = true
            end
            if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
                local index = target:getCurSelectedIndex()
                local itemNode = target:getItem(index)
                local lblName = itemNode:getChildByName("buttonName")
                local userData = itemNode.itemData

                self:createMainPanel(isActiv, userData)

                local itemList = target:getItems()
                for i = 1, #itemList do
                    itemList[i]:setEnabled(true)
                    local templbl = itemList[i]:getChildByName("buttonName")
                    templbl:setColor(btncolor1)
                    templbl:enableOutline(cc.c4b(98, 90, 77, 255), 2)
                end
                itemNode:setEnabled(false)
                lblName:setColor(btncolor2)
                lblName:enableOutline(cc.c4b(68, 59, 52, 255), 1)

                self.refreshTime = os.time()
            end
        end)
        buttonListView:align(display.LEFT_BOTTOM, 35, 20):addTo(self.showPanel)

        local chineseNumList = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}
        for i = 1, #activeData do
            local itemBtn = ccui.Button:create("app/common/button/left_tab1.png", "app/common/button/left_tab1.png", "app/common/button/left_tab2.png")
            local lblstr = activeData[i].wWelcomeName .. tostring(chineseNumList[i] or "")
            local lblName = GameUtil.createLabel(lblstr, fontSize, btncolor1, display.CENTER, cc.p(127, 51), fontName)
            lblName:addTo(itemBtn):setName("buttonName")

            if i == 1 then
                itemBtn:setEnabled(false)
                lblName:setColor(btncolor2)
                lblName:enableOutline(cc.c4b(68, 59, 52, 255), 2)
            else
                itemBtn:setEnabled(true)
                lblName:setColor(btncolor1)
                lblName:enableOutline(cc.c4b(98, 90, 77, 255), 2)
            end
            itemBtn.itemData = activeData[i]

            buttonListView:pushBackCustomItem(itemBtn)
        end
        buttonListView:setCurSelectedIndex(0)
        self:createMainPanel(isActiv, activeData[1])
    end
end

function WelcomeWinUI:createMainPanel(isActiv, itemdata)
    self.rightNode:removeAllChildren()

    local img_bg_3 = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    img_bg_3:setCapInsets(GameDefine.PanelRect2)
    img_bg_3:setContentSize(self.right_size)
    img_bg_3:align(display.CENTER, self.rightcx, self.rightcy):addTo(self.rightNode)

    self.isActiv = isActiv
    if isActiv == false then
        local textListView = ccui.ListView:create()
        textListView:setContentSize(self.right_size.width - 20, self.right_size.height - 60)
        textListView:align(display.LEFT_BOTTOM, 30, 30):addTo(self.rightNode)

        local lbl_content = GameUtil.createLabel(itemdata.szContent, 30, cc.c3b(0xbc, 0xde, 0xff), display.LEFT_BOTTOM, display.LEFT_BOTTOM)
        lbl_content:setMaxLineWidth(self.right_size.width - 60)
        lbl_content:setLineHeight(40)
        lbl_content:setLineBreakWithoutSpace(false)

        local contentLayer = ccui.Layout:create()
        contentLayer:setContentSize(lbl_content:getContentSize())
        contentLayer:addChild(lbl_content)
        textListView:pushBackCustomItem(contentLayer)
    else

        if GameDefine.bIsTestUI then
            local avatarSp = cc.Sprite:create("app/win/welcome/active" .. math.random(1, 2) .. ".png")
            if avatarSp ~= nil then
                local spSize = avatarSp:getContentSize()
                local sx = self.right_size.width / spSize.width
                local sy = self.right_size.height / spSize.height
                avatarSp:setScale(sx, sy)
                self.rightNode:removeAllChildren()
                avatarSp:align(display.CENTER, self.rightcx, self.rightcy):addTo(self.rightNode)
            end
            return
        end

        local pic_url = PlazaManager.urlGameConfig.activityPictureUrl
        if itemdata and pic_url and string.len(pic_url) > 0 and itemdata.szContent and string.len(itemdata.szContent) > 0 then
            local urlPath = pic_url .. itemdata.szContent .. os.date(".jpg?time=%Y%m%d%H", os.time())

            game.fileDownload(urlPath, false, function(succ, localPath)
                print("down picture =====>", urlPath, succ, localPath)
                if succ and self.isActiv == true and self.rightNode ~= nil then
                    local avatarSp = cc.Sprite:create(localPath)
                    if avatarSp ~= nil then
                        local spSize = avatarSp:getContentSize()
                        local sx = self.right_size.width / spSize.width
                        local sy = self.right_size.height / spSize.height
                        avatarSp:setScale(sx, sy)
                        self.rightNode:removeAllChildren()
                        avatarSp:align(display.CENTER, self.rightcx, self.rightcy):addTo(self.rightNode)
                    end
                end
            end, nil, false)
        end
    end
end

function WelcomeWinUI:genTestData(activlist)
    for i = 1, 8 do
        local result = {}
        result.wWelcomeID = math.random(1, 999) -- 公告ID
        result.wSortID = math.random(1, 9) -- 排序序号
        result.wContentType = math.random(0, 3) -- 内容类型：0-活动(URL),1-游戏公告(纯文本),2-HTML,3.滚动公告
        result.szContent = "公告内容测试， 公告内容测试， 公告内容测试" -- 公告内容
        result.rollTimes = -1 -- 滚动公告（滚动的次数，-1为永久，其他为次数）
        result.msgState = 0 -- 状态 0-未显示，1-显示（游戏公告和活动使用）

        if result.wContentType == 1 then
            result.wWelcomeName = LangCtrl:getLang().word238 -- 公告名称
        else
            result.wWelcomeName = LangCtrl:getLang().word239
        end
        table.insert(activlist, result)
    end
end

function WelcomeWinUI:getActivData()
    local activeData = {}
    if PlazaManager.isCheck == false then
        for i = 1, PlazaManager.WelcomeCount do
            if PlazaManager.WelcomeDataList[i].wContentType == 0 then
                if PlazaManager.WelcomeDataList[i].msgState == 0 then
                    table.insert(activeData, 1, PlazaManager.WelcomeDataList[i])
                else
                    table.insert(activeData, PlazaManager.WelcomeDataList[i])
                end
            end
        end
    end
    return activeData
end

function WelcomeWinUI:getWelcomData()
    local welcomData = {}
    if PlazaManager.isCheck == false then
        for i = 1, PlazaManager.WelcomeCount do
            if PlazaManager.WelcomeDataList[i].wContentType == 1 then
                if PlazaManager.WelcomeDataList[i].msgState == 0 then
                    table.insert(welcomData, 1, PlazaManager.WelcomeDataList[i])
                else
                    table.insert(welcomData, PlazaManager.WelcomeDataList[i])
                end
            end
        end
    else
        local result = {}
        result.wWelcomeID = 1 -- 公告ID
        result.wSortID = 1 -- 排序序号
        result.wContentType = 1 -- 内容类型：0-活动(URL),1-游戏公告(纯文本),2-HTML,3.滚动公告
        result.szContent =
            "    R8娱乐正式上线，欢迎广大玩家入驻！\n    本游戏禁止赌博，游戏内任何虚拟货币跟道具，仅供游戏场景内使用，不得以任何形式变现处理。一经发现，永久封号！请广大玩家合理安排游戏时间，适度游戏，不要沉迷！感谢你对我们游戏的关注和支持。" -- 公告内容
        result.rollTimes = -1 -- 滚动公告（滚动的次数，-1为永久，其他为次数）
        result.msgState = 0 -- 状态 0-未显示，1-显示（游戏公告和活动使用）
        result.wWelcomeName = LangCtrl:getLang().word238 -- 公告名称
        table.insert(welcomData, result)
    end

    return welcomData
end

function WelcomeWinUI:getActivMinSortID()
    local minSortID = 10
    if PlazaManager.isCheck == false then
        for i = 1, PlazaManager.WelcomeCount do
            if PlazaManager.WelcomeDataList[i].wContentType == 0 then
                if minSortID == 0 then
                    minSortID = PlazaManager.WelcomeDataList[i].wSortID
                end
                if minSortID > PlazaManager.WelcomeDataList[i].wSortID then
                    minSortID = PlazaManager.WelcomeDataList[i].wSortID
                end
            end
        end
    end
    return minSortID
end

function WelcomeWinUI:getWelcomMinSortID()
    local minSortID = 10
    for i = 1, PlazaManager.WelcomeCount do
        if PlazaManager.WelcomeDataList[i].wContentType == 1 then
            if minSortID == 0 then
                minSortID = PlazaManager.WelcomeDataList[i].wSortID
            end
            if minSortID > PlazaManager.WelcomeDataList[i].wSortID then
                minSortID = PlazaManager.WelcomeDataList[i].wSortID
            end
        end
    end

    return minSortID
end

return WelcomeWinUI
