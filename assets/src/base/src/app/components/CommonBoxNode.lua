local Buttons = require "app.components.Buttons"

local CommonBoxNode = class("CommonBoxNode", function()
    return cc.Node:create()
end)

-- dataList[i].name
function CommonBoxNode:ctor(dataList, defeatIndex, onBackFunction, rowWidth, rowHeight, iconWidth, iconIsLeft, fontName, fontColor, fontSize, textMarginWidth)
    self.dataList = dataList
    self.ChooseIndex = defeatIndex
    self.onBackFunction = onBackFunction
    self.rowWidth = rowWidth
    self.rowHeight = rowHeight
    self.iconWidth = iconWidth
    self.iconIsLeft = iconIsLeft
    self.fontName = fontName
    self.fontColor = fontColor
    self.fontSize = fontSize
    self.textMarginWidth = textMarginWidth

    if self.ChooseIndex > #self.dataList then
        self.ChooseIndex = 1
    end
    if self.rowWidth == nil or self.rowWidth <= 0 then
        self.rowWidth = 650
    end
    if self.rowHeight == nil or self.rowHeight <= 0 then
        self.rowHeight = 64
    end
    if self.iconWidth == nil or self.iconWidth <= 0 then
        self.iconWidth = 87
    end
    if self.iconIsLeft == nil then
        self.iconIsLeft = false
    end
    if self.fontName == nil then
        self.fontName = GameDefine.FontName
    end
    if self.fontColor == nil then
        self.fontColor = cc.c3b(0x9d, 0xb2, 0xdd)
    end
    if self.fontSize == nil then
        self.fontSize = 30
    end
    if self.textMarginWidth == nil then
        self.textMarginWidth = 10
    end

    self.inputImagePath = "app/common/combobox/inputImage.png"
    self.iconPath_1 = "app/common/combobox/icon_1.png"
    self.iconPath_2 = "app/common/combobox/icon_2.png"
    self.listBgPath = "app/common/combobox/listBg.png"
    self.itemBgTopPath = "app/common/combobox/itemBgTop.png"
    self.itemBgMidPath = "app/common/combobox/itemBgMid.png"
    self.itemBgDownPath = "app/common/combobox/itemBgDown.png"

    self:setContentSize(cc.size(self.rowWidth, self.rowHeight))
    self:setAnchorPoint(display.LEFT_CENTER)

    local panel_top = ccui.Layout:create()
    panel_top:setContentSize(cc.size(self.rowWidth, self.rowHeight))
    panel_top:setAnchorPoint(display.CENTER)

    local inputImage = ccui.ImageView:create(self.inputImagePath)
    inputImage:setAnchorPoint(display.LEFT_BOTTOM)
    inputImage:setPosition(0, 0)
    panel_top:addChild(inputImage)
    self.inputImage = inputImage

    local textStr = ""
    if self.dataList[self.ChooseIndex].nameStr ~= nil then
        textStr = self.dataList[self.ChooseIndex].nameStr
    else
        textStr = self.dataList[self.ChooseIndex].name
    end
    local text_choose = ccui.Text:create(textStr, self.fontName, self.fontSize)
    text_choose:setTextColor(self.fontColor)
    text_choose:setAnchorPoint(display.LEFT_CENTER)
    panel_top:addChild(text_choose)
    self.text_choose = text_choose

    if self.iconIsLeft == true then
        self.text_choose:setPosition(self.iconWidth + self.textMarginWidth, self.rowHeight / 2)
    else
        self.text_choose:setPosition(self.textMarginWidth, self.rowHeight / 2)
    end

    if self.iconIsLeft == true then
        local path = self.iconPath_1
        self.iconPath_1 = self.iconPath_2
        self.iconPath_2 = path
    end

    local icon_menu = ccui.ImageView:create(self.iconPath_1)
    icon_menu:setAnchorPoint(display.LEFT_CENTER)
    panel_top:addChild(icon_menu)
    self.icon_menu = icon_menu
    if self.iconIsLeft == true then
        self.icon_menu:setPosition(self.iconWidth / 2, self.rowHeight / 2)
        self.icon_menu:setAnchorPoint(display.CENTER)
        self.icon_menu:setRotation(180)
    else
        self.icon_menu:setPosition(self.rowWidth - self.iconWidth, self.rowHeight / 2)
    end

    local function menuClick()
        if (self.panel_ItemList:isVisible() == true) then
            self.panel_ItemList:setVisible(false)
            self.icon_menu:loadTexture(self.iconPath_1)
        else
            self.panel_ItemList:setVisible(true)
            self.icon_menu:loadTexture(self.iconPath_2)
        end
    end

    local menubtn = Buttons.createButton(false, 1, menuClick)
    Buttons.initButtonWithNode(menubtn, panel_top)
    menubtn:setAnchorPoint(display.LEFT_BOTTOM)
    menubtn:setPosition(0, 0)
    self:addChild(menubtn)
    self.menubtn = menubtn

    local height_1 = #self.dataList * self.rowHeight
    if #self.dataList > 10 then
        height_1 = 9 * self.rowHeight
    end
    local panel_ItemList = ccui.Layout:create()
    panel_ItemList:setContentSize(cc.size(self.rowWidth, height_1))
    panel_ItemList:setAnchorPoint(display.LEFT_TOP)
    panel_ItemList:setPosition(0, 0)
    panel_ItemList:setVisible(false)
    self:addChild(panel_ItemList)
    self.panel_ItemList = panel_ItemList

    local itmeListbg = ccui.Scale9Sprite:create(self.listBgPath)
    local bgSize = itmeListbg:getContentSize()
    itmeListbg:setCapInsets(cc.rect(10, 10, bgSize.width - 10 * 2, bgSize.height - 10 * 2))
    itmeListbg:setAnchorPoint(display.LEFT_BOTTOM)
    itmeListbg:setPosition(0, 0)
    self.itmeListbg = itmeListbg
    self.panel_ItemList:addChild(itmeListbg)

    self:createListView()
    self:RefreshSize()

    self:onSwallowClickEvent()
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
    local textStr = ""
    if self.dataList[self.ChooseIndex].nameStr ~= nil then
        textStr = self.dataList[self.ChooseIndex].nameStr
    else
        textStr = self.dataList[self.ChooseIndex].name
    end
    self.text_choose:setString(textStr)
    self.panel_ItemList:setVisible(false)
    self.icon_menu:loadTexture(self.iconPath_1)
    self.onBackFunction(self.dataList[self.ChooseIndex])
end

function CommonBoxNode:createListView()
    local count = #self.dataList
    if #self.dataList > 10 then
        count = 9
    end
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

        local image = ccui.ImageView:create(self.itemBgMidPath)
        image:setAnchorPoint(display.LEFT_BOTTOM)
        image:setPosition(0, 0)
        image:setName("image")
        image:setVisible(false)
        node:addChild(image)

        if i == 1 then
            image:loadTexture(self.itemBgTopPath)
        elseif i == #self.dataList then
            image:loadTexture(self.itemBgDownPath)
        end

        local textStr = ""
        if v.nameStr ~= nil then
            textStr = v.nameStr
        else
            textStr = v.name
        end

        local text = ccui.Text:create(textStr, self.fontName, self.fontSize)
        text:setTextColor(self.fontColor)
        text:setAnchorPoint(display.LEFT_CENTER)

        node:addChild(text)

        if self.iconIsLeft == true then
            text:setPosition(self.iconWidth + self.textMarginWidth, self.rowHeight / 2)
        else
            text:setPosition(self.textMarginWidth, self.rowHeight / 2)
        end

        listView:pushBackCustomItem(node)
    end

    listView:setAnchorPoint(display.LEFT_BOTTOM)
    listView:setPosition(0, 0)
    self.listView = listView
    self.panel_ItemList:addChild(listView)
end

function CommonBoxNode:setImage(inputImagePath, iconPath_1, iconPath_2, listBgPath, itemBgTopPath, itemBgMidPath, itemBgDownPath)
    self.inputImagePath = inputImagePath
    self.iconPath_1 = iconPath_1
    self.iconPath_2 = iconPath_2
    self.listBgPath = listBgPath
    self.itemBgTopPath = itemBgTopPath
    self.itemBgMidPath = itemBgMidPath
    self.itemBgDownPath = itemBgDownPath

    if self.iconIsLeft == true then
        local path = self.iconPath_1
        self.iconPath_1 = self.iconPath_2
        self.iconPath_2 = path
    end

    self.inputImage:loadTexture(self.inputImagePath)
    self.icon_menu:loadTexture(self.iconPath_1)
    self.panel_ItemList:setVisible(false)
    self.itmeListbg:getSprite():setTexture(self.listBgPath)

    local itemList = self.listView:getItems()
    for k, item in pairs(itemList) do
        local image = item:getChildByName("image")
        image:loadTexture(self.itemBgMidPath)
        if i == 1 then
            image:loadTexture(self.itemBgTopPath)
        elseif i == #self.dataList then
            image:loadTexture(self.itemBgDownPath)
        end
    end

    self:RefreshSize()
end

function CommonBoxNode:RefreshSize()
    local imageSize = self.inputImage:getContentSize()
    self.inputImage:setScale(self.rowWidth / imageSize.width, self.rowHeight / imageSize.height)

    imageSize = self.icon_menu:getContentSize()
    self.icon_menu:setScale(self.iconWidth / imageSize.width, self.rowHeight / imageSize.height)

    imageSize = self.itmeListbg:getContentSize()
    local rowNum = #self.dataList
    if #self.dataList > 10 then
        rowNum = 9
    end
    self.itmeListbg:setContentSize(self.rowWidth, rowNum * self.rowHeight)

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
        if not cc.rectContainsPoint(cc.rect(0, -#self.dataList * self.rowHeight, self.rowWidth, (#self.dataList + 1) * self.rowHeight), pos) then
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
    self.icon_menu:loadTexture(self.iconPath_1)
    self.panel_ItemList:setVisible(false)
end

function CommonBoxNode:setTouchEnabled(chk)
    self:hideCardList()
    self.listView:setTouchEnabled(chk)
    self.menubtn:setEnabled(chk)
end

return CommonBoxNode
