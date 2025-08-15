local Buttons = require "app.components.Buttons"

local CommonBoxNode = class("CommonBoxNode2", function()
    return cc.Node:create()
end)

-- dataList[i].name
function CommonBoxNode:ctor(dataList, defeatIndex, onBackFunction, rowWidth, rowHeight, iconHeight, inputHeight, iconIsTop, fontName, fontColor, fontSize)
    self.dataList = dataList
    self.ChooseIndex = defeatIndex
    self.onBackFunction = onBackFunction
    self.rowWidth = rowWidth
    self.rowHeight = rowHeight
    self.iconHeight = iconHeight
    self.inputHeight = inputHeight
    self.iconIsTop = iconIsTop
    self.fontName = fontName
    self.fontColor = fontColor
    self.fontSize = fontSize

    if self.ChooseIndex > #self.dataList then
        self.ChooseIndex = 1
    end
    if self.rowWidth == nil or self.rowWidth <= 0 then
        self.rowWidth = 144
    end
    if self.rowHeight == nil or self.rowHeight <= 0 then
        self.rowHeight = 47
    end
    if self.iconHeight == nil or self.iconHeight <= 0 then
        self.iconHeight = 62
    end
    if self.inputHeight == nil or self.inputHeight <= 0 then
        self.inputHeight = 73
    end
    if self.iconIsTop == nil then
        self.iconIsTop = false
    end
    if self.fontName == nil then
        self.fontName = GameDefine.FontName
    end
    if self.fontColor == nil then
        self.fontColor = cc.WHITE
    end
    if self.fontSize == nil then
        self.fontSize = 30
    end

    self.inputImagePath = "app/common/combobox/h_bg_input.png"
    self.iconPath_1 = "app/common/combobox/h_icon_1.png"
    self.iconPath_2 = "app/common/combobox/h_icon_2.png"
    self.listBgPath = "app/common/combobox/h_listBg.png"
    self.itemBgPath = "app/common/combobox/h_itembg.png"

    self:setContentSize(cc.size(self.rowWidth, self.inputHeight))
    self:setAnchorPoint(display.LEFT_CENTER)

    local panel_top = ccui.Layout:create()
    panel_top:setContentSize(cc.size(self.rowWidth, self.inputHeight))
    panel_top:setAnchorPoint(display.CENTER)

    local inputImage = ccui.ImageView:create(self.inputImagePath)
    inputImage:setAnchorPoint(display.LEFT_BOTTOM)
    inputImage:setPosition(0, 0)
    self:addChild(inputImage)
    self.inputImage = inputImage

    local text_choose = ccui.Text:create(self.dataList[self.ChooseIndex].name, self.fontName, self.fontSize)
    text_choose:setTextColor(self.fontColor)
    text_choose:setAnchorPoint(display.CENTER)
    panel_top:addChild(text_choose)
    self.text_choose = text_choose
    self.text_choose:setPosition(self.rowWidth / 2, self.inputHeight / 2)

    local icon_menu_btn = ccui.Button:create(self.iconPath_1, self.iconPath_1)
    icon_menu_btn:setAnchorPoint(display.CENTER)
    panel_top:addChild(icon_menu_btn)
    self.icon_menu_btn = icon_menu_btn
    local iconSize = self.icon_menu_btn:getContentSize()
    if self.iconIsTop == true then
        self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + iconSize.height / 2)
        self.icon_menu_btn:setRotation(180)
    else
        self.icon_menu_btn:setPosition(self.rowWidth / 2, -iconSize.height / 2)
    end
    self.icon_menu_btn:addTouchEventListener(function(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self:menuClick()
        end
    end)

    local function menuTopClick()
        self:menuClick()
    end

    local menubtn = Buttons.createButton(false, 1, menuTopClick)
    Buttons.initButtonWithNode(menubtn, panel_top)
    menubtn:setAnchorPoint(display.LEFT_BOTTOM)
    menubtn:setPosition(0, 0)
    self:addChild(menubtn)
    self.menubtn = menubtn

    local height_1 = #self.dataList * self.rowHeight
    local panel_ItemList = ccui.Layout:create()
    panel_ItemList:setContentSize(cc.size(self.rowWidth, height_1))
    panel_ItemList:setAnchorPoint(display.LEFT_TOP)
    panel_ItemList:setPosition(0, 0)
    panel_ItemList:setVisible(false)
    self:addChild(panel_ItemList)
    self.panel_ItemList = panel_ItemList

    local itmeListbg = ccui.ImageView:create(self.listBgPath)
    itmeListbg:setAnchorPoint(display.LEFT_BOTTOM)
    itmeListbg:setPosition(0, 0)
    self.itmeListbg = itmeListbg
    self.panel_ItemList:addChild(itmeListbg)

    self:createListView()
    self:RefreshSize()

    self:onSwallowClickEvent()
end
function CommonBoxNode:menuClick()
    if (self.panel_ItemList:isVisible() == true) then
        self.panel_ItemList:setVisible(false)
        self.icon_menu_btn:loadTextures(self.iconPath_1, self.iconPath_1)
        local iconSize = self.icon_menu_btn:getContentSize()
        if self.iconIsTop == true then
            self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + iconSize.height / 2)
        else
            self.icon_menu_btn:setPosition(self.rowWidth / 2, -iconSize.height / 2)
        end
    else
        self.panel_ItemList:setVisible(true)
        self.icon_menu_btn:loadTextures(self.iconPath_2, self.iconPath_2)
        local iconSize = self.icon_menu_btn:getContentSize()
        if self.iconIsTop == true then
            self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + iconSize.height / 2 + #self.dataList * self.rowHeight)
        else
            self.icon_menu_btn:setPosition(self.rowWidth / 2, -iconSize.height / 2 - #self.dataList * self.rowHeight)
        end
    end
end

function CommonBoxNode:getCurSelect()
    if self.ChooseIndex == nil or self.ChooseIndex > #self.dataList then
        self.ChooseIndex = 1
    end
    return self.dataList[self.ChooseIndex]
end

function CommonBoxNode:setCurSelect(seqNo)
    self.ChooseIndex = seqNo
    if self.ChooseIndex > #self.dataList then
        self.ChooseIndex = 1
    end
    self.text_choose:setString(self.dataList[self.ChooseIndex].name)
    self.panel_ItemList:setVisible(false)
    self.icon_menu_btn:loadTextures(self.iconPath_1, self.iconPath_1)
    self.onBackFunction(self.dataList[self.ChooseIndex])

    local iconSize = self.icon_menu_btn:getContentSize()
    if self.iconIsTop == true then
        self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + iconSize.height / 2)
    else
        self.icon_menu_btn:setPosition(self.rowWidth / 2, -iconSize.height / 2)
    end
end

function CommonBoxNode:createListView()
    local count = #self.dataList
    local listView = ccui.ListView:create()
    listView:setDirection(SCROLLVIEW_DIR_VERTICAL)
    listView:setContentSize(cc.size(self.rowWidth, count * self.rowHeight))
    listView:setTouchEnabled(true)

    listView:addEventListenerListView(function(target, eventType)
        if (eventType == ccui.ListViewEventType.ONSELECTEDITEM_START) then
            local itemList = target:getItems()
            for k, item in pairs(itemList) do
                item:getChildByName("image"):setVisible(false)
            end

            local index = target:getCurSelectedIndex()
            local image = target:getItem(index):getChildByName("image")
            image:setVisible(true)

        elseif (eventType == ccui.ListViewEventType.ONSELECTEDITEM_END) then
            local index = target:getCurSelectedIndex()
            local image = target:getItem(index):getChildByName("image")
            image:setVisible(false)

            local tag = target:getItem(index):getTag()
            self:setCurSelect(tag)

        end
    end)

    for i, v in ipairs(self.dataList) do
        local node = ccui.Layout:create()
        node:setContentSize(self.rowWidth, self.rowHeight)
        node:setTouchEnabled(true)
        node:setTag(i)

        local image = ccui.ImageView:create(self.itemBgPath)
        image:setAnchorPoint(display.LEFT_BOTTOM)
        image:setPosition(0, 0)
        image:setName("image")
        image:setVisible(false)
        node:addChild(image)

        local text = ccui.Text:create(v.name, self.fontName, self.fontSize)
        text:setTextColor(self.fontColor)
        text:setAnchorPoint(display.CENTER)
        text:setPosition(self.rowWidth / 2, self.rowHeight / 2)
        node:addChild(text)

        listView:pushBackCustomItem(node)
    end

    listView:setAnchorPoint(display.LEFT_BOTTOM)
    listView:setPosition(0, 0)
    self.listView = listView
    self.panel_ItemList:addChild(listView)
end

function CommonBoxNode:setImage(inputImagePath, iconPath_1, iconPath_2, listBgPath, itemBgPath)
    self.inputImagePath = inputImagePath
    self.iconPath_1 = iconPath_1
    self.iconPath_2 = iconPath_2
    self.listBgPath = listBgPath
    self.itemBgPath = itemBgPath

    self.inputImage:loadTexture(self.inputImagePath)
    self.icon_menu_btn:loadTextures(self.iconPath_1, self.iconPath_1)
    self.panel_ItemList:setVisible(false)
    self.itmeListbg:loadTexture(self.listBgPath)

    local itemList = self.listView:getItems()
    for k, item in pairs(itemList) do
        local image = item:getChildByName("image")
        image:loadTexture(self.itemBgPath)
    end

    self:RefreshSize()
end

function CommonBoxNode:RefreshSize()
    local imageSize = self.inputImage:getContentSize()
    self.inputImage:setScale(self.rowWidth / imageSize.width, self.inputHeight / imageSize.height)

    imageSize = self.icon_menu_btn:getContentSize()
    if self.iconIsTop == true then
        self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + imageSize.height / 2)
    else
        self.icon_menu_btn:setPosition(self.rowWidth / 2, -imageSize.height / 2)
    end

    imageSize = self.itmeListbg:getContentSize()
    self.itmeListbg:setScale(self.rowWidth / imageSize.width, #self.dataList * self.rowHeight / imageSize.height)

    local itemList = self.listView:getItems()
    for k, item in pairs(itemList) do
        imageSize = item:getChildByName("image"):getContentSize()
        item:getChildByName("image"):setScale(self.rowWidth / imageSize.width, self.rowHeight / imageSize.height)
    end
end

function CommonBoxNode:onSwallowClickEvent()
    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = self:convertToNodeSpace(loc)

        if not cc.rectContainsPoint(cc.rect(0, -#self.dataList * self.rowHeight + self.iconHeight, self.rowWidth, #self.dataList * self.rowHeight + self.iconHeight + self.inputHeight), pos) then
            self:runAction(cc.CallFunc:create(function()
                self:hideCardList()
            end))
        end
        return true
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(false)
    self.listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener, self)
end

function CommonBoxNode:hideCardList()
    self.icon_menu_btn:loadTextures(self.iconPath_1, self.iconPath_1)
    self.panel_ItemList:setVisible(false)
    local iconSize = self.icon_menu_btn:getContentSize()
    if self.iconIsTop == true then
        self.icon_menu_btn:setPosition(self.rowWidth / 2, self.inputHeight + iconSize.height / 2)
    else
        self.icon_menu_btn:setPosition(self.rowWidth / 2, -iconSize.height / 2)
    end
end

function CommonBoxNode:setTouchEnabled(chk)
    self:hideCardList()
    self.listView:setTouchEnabled(chk)
    self.menubtn:setEnabled(chk)
end

return CommonBoxNode
