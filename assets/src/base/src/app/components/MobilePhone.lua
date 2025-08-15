local MobilePhone = class("MobilePhone", function()
    return cc.Node:create()
end)

function MobilePhone:ctor(callback)
    self.callback = callback
    self.winSize = cc.size(800, 60)
    self:setContentSize(self.winSize)

    self.table_size = cc.size(360, 350)
    self.item_size = cc.size(360, 70)
    self.itemcx, self.itemcy = self.item_size.width / 2, self.item_size.height / 2
    self:initData()

    local function onNodeEvent(event)
        if event == "exit" then
            self:closeTableView()
        elseif event == "cleanup" then

        end
    end
    self:registerScriptHandler(onNodeEvent)

    self:initNode()
end

function MobilePhone:verifyMobile()
    local str = self.edit_phone:getText()
    -- 字符长度
    if string.len(str) == 0 then
        print("mobile len is 0")
        self:showPhoneTips()
        return 1
    end

    -- 是否全部是空字符串
    local regStr_remove = GameUtil.reomveString(str, " ")
    if string.len(regStr_remove) == 0 then
        print("mobile str is white space char")
        self:showPhoneTips()
        return 2
    end

    -- 长度是否超出
    local strlen = string.len(str)

    if self.tCurData.length > 0 and strlen ~= self.tCurData.length then
        print("mobile str length invalid:", self.tCurData.length, strlen)
        self:showPhoneTips()
        return 3
    end
    self:hidePhoneTips()
    return 0
end

function MobilePhone:getMobileStr()
    local phoneStr = self.edit_phone:getText()
    local ret = self.tCurData.dialing .. phoneStr
    print("the mobile is:", ret)
    return ret
end

function MobilePhone:getShowStr(mobileStr)
    print("mobileStr--->", mobileStr)
    if self.table_data == nil then
        self:initData()
    end
    for kk, vv in pairs(self.table_data) do
        local s1, s2 = string.find(mobileStr, vv.dialing)
        if s1 == 1 and s2 > 1 then
            local newStr = string.sub(mobileStr, s2 + 1)
            print("newStr---", newStr)
            return newStr
        end
    end
    return mobileStr
end

function MobilePhone:setEditText(mobileStr)
    local str = self:getShowStr(mobileStr)
    self.edit_phone:setText(str)
end

function MobilePhone:initNode()
    -- 手机号码 & 国家区号
    local lbl_phone = cc.Label:createWithTTF(LangCtrl:getLang().word28, GameDefine.FontName, 26)
    lbl_phone:setColor(GameDefine.FontColor)
    lbl_phone:align(display.RIGHT_CENTER, 280, 30):addTo(self)

    local function onSelectCode()
        self:showTableView()
    end

    local btn = ccui.Button:create("app/common/comwin/edit_bg.png")
    btn:setZoomScale(-0.1);
    btn:setScale9Enabled(true)
    btn:setCapInsets(cc.rect(3, 3, 2, 2))
    btn:setContentSize(cc.size(150, 46))
    btn:addClickEventListener(onSelectCode)
    btn:align(display.LEFT_CENTER, 280, 30):addTo(self)

    local lbl = cc.Label:createWithTTF("", "fonts/fzcy.ttf", 26)
    lbl:setColor(GameDefine.FontColor_edit)
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(75, 23)
    lbl:enableOutline(cc.c4b(132, 77, 24, 255), 2) -- 按钮描边颜色
    btn:getVirtualRenderer():addChild(lbl)
    self.country_code = lbl

    lbl = cc.Label:createWithTTF("", "fonts/fzz.ttf", 20)
    lbl:setColor(cc.RED)
    lbl:setPosition(75, 23)
    -- lbl:enableOutline(cc.c4b(132, 77, 24, 255), 2) -- 按钮描边颜色
    lbl:align(display.LEFT_CENTER, 280, 70):addTo(self)
    self.phone_tips = lbl

    if LangCtrl:isEng() then
        self.tCurData = self.table_data[2] or self.table_data[1]
    else
        self.tCurData = self.table_data[6] or self.table_data[1]
    end

    -- btn:setTouchEnabled(false) -- 暂时不用选择

    local lblcode = cc.Label:createWithTTF("-", GameDefine.FontName, 26)
    lblcode:setColor(GameDefine.FontColor)
    lblcode:align(display.CENTER, 445, 30):addTo(self)

    local edbox = ccui.EditBox:create(cc.size(232, 46), "app/common/comwin/edit_bg.png")
    edbox:setFont(GameDefine.FontName, 26)
    edbox:setFontColor(GameDefine.FontColor_edit)
    edbox:setMaxLength(11)
    edbox:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edbox:setPlaceHolder(LangCtrl:getLang().word29)
    edbox:setPlaceholderFontSize(26)
    edbox:setPlaceholderFontName(GameDefine.FontName)
    edbox:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edbox:align(display.LEFT_CENTER, 460, 30):addTo(self)

    local function editboxHandle(eventname, sender)
        if eventname == "ended" then
            if self:verifyMobile() == 0 then
                if self.callback then
                    self.callback(eventname, sender)
                end
            end
        end
    end
    edbox:registerScriptEditBoxHandler(editboxHandle)
    edbox:setName("edit_phone")
    self.edit_phone = edbox
    self:updateChoose()
end

function MobilePhone:editboxHandle()

end

function MobilePhone:updateChoose()
    self:hidePhoneTips()
    self.edit_phone:setPlaceHolder(self.tCurData.tips2)
    self.country_code:setString(self.tCurData.showStr)
end

function MobilePhone:showPhoneTips()
    self.phone_tips:setString(self.tCurData.tips1)
end

function MobilePhone:hidePhoneTips()
    self.phone_tips:setString("")
end

function MobilePhone:closeTableView()
    if self.areacodeView then
        self.areacodeView:removeFromParent()
        self.areacodeView = nil
    end
end

function MobilePhone:showTableView()
    self:closeTableView()
    local scene = display.getRunningScene()
    local downPos = self:convertToWorldSpace(cc.p(420, 150))
    self.areacodeView = cc.Node:create()
    scene:addChild(self.areacodeView)

    local mask = ccui.ImageView:create("app/common/mask.png")
    mask:setScale9Enabled(true)
    mask:setCapInsets(cc.rect(2, 2, 1, 1))
    mask:setContentSize(display.size)
    mask:setOpacity(168)
    mask:align(display.CENTER, display.cx, display.cy):addTo(self.areacodeView)

    local bgSize = cc.size(self.table_size.width + 70, self.table_size.height + 140)
    local midBgWidth = bgSize.width / 2
    local bg = ccui.Scale9Sprite:create("app/common/comwin/tipbg.png") -- 103, 111
    bg:setCapInsets(cc.rect(45, 50, 13, 11))
    bg:setContentSize(bgSize)
    bg:align(display.LEFT_TOP, downPos.x, downPos.y):addTo(self.areacodeView)

    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = bg:convertToNodeSpace(loc)
        local rect = cc.rect(0, 0, bgSize.width, bgSize.height)
        if not cc.rectContainsPoint(rect, pos) then
            bg:runAction(cc.CallFunc:create(function()
                self:closeTableView()
            end))
        end
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    bg:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, bg)

    local titlebg = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    titlebg:setCapInsets(GameDefine.PanelRect2)
    titlebg:setCascadeOpacityEnabled(true)
    titlebg:setContentSize(cc.size(self.table_size.width, 60))
    titlebg:align(display.CENTER, midBgWidth, bgSize.height - 60):addTo(bg)

    local tableViewBg = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    tableViewBg:setCapInsets(GameDefine.PanelRect2)
    tableViewBg:setCascadeOpacityEnabled(true)
    tableViewBg:setContentSize(cc.size(self.table_size.width, self.table_size.height))
    tableViewBg:align(display.LEFT_BOTTOM, midBgWidth - self.itemcx, 35):addTo(bg)

    GameUtil.createLabel(LangCtrl:getLang().word347, 28, GameDefine.FontCoinColor, display.CENTER, cc.p(midBgWidth, bgSize.height - 60), "fonts/fzcy.ttf", nil, nil, nil, true, false):addTo(bg)

    self.tableViewPos = cc.p(midBgWidth - self.itemcx, 35)
    self:addTableView(bg)
end

function MobilePhone:addTableView(parent)
    self.table_view = cc.TableView:create(self.table_size)
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setPosition(self.tableViewPos)
    self.table_view:setDelegate()
    parent:addChild(self.table_view)
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.table_view:registerScriptHandler(handler(self, self.scrollViewScriptScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    self:addScrollBar(parent)
    self.table_view:reloadData()
end

function MobilePhone:addScrollBar(parent)
    -- 滚动条元素
    local posX = self.tableViewPos.x + self.table_size.width + 4
    self.clipNode = cc.ClippingNode:create()
    self.clipNode:align(display.LEFT_BOTTOM, posX, self.tableViewPos.y):addTo(parent)

    self.scrollTrack = ccui.Scale9Sprite:create("app/common/comwin/dot1.png") -- 滚动条轨道
    self.scrollTrack:setCapInsets(cc.rect(6, 6, 2, 2))
    local trackSize = cc.size(14, self.table_size.height)
    self.scrollTrack:setContentSize(trackSize)
    self.scrollTrack:setScaleX(0.7)
    self.clipNode:setStencil(self.scrollTrack)
    self.clipNode:setInverted(false)
    self.clipNode:setAlphaThreshold(0)
    self.clipNode:setContentSize(trackSize)
    self.scrollTrack:align(display.LEFT_BOTTOM, 0, 0):addTo(self.clipNode)

    self.scrollThumb = ccui.Scale9Sprite:create("app/common/comwin/dot2.png") -- 滚动条滑块
    self.scrollThumb:setCapInsets(cc.rect(6, 6, 2, 2))
    self.scrollThumb:setScaleX(0.4)
    self.scrollThumb:align(display.LEFT_BOTTOM, 1, 0):addTo(self.clipNode)

    -- 计算内容高度
    self.innerHeight = #self.table_data * self.item_size.height
    self.minOffset = self.table_size.height - self.innerHeight
    -- 计算滑块尺寸和位置
    self.thumbHeight = math.max(self.table_size.height + self.minOffset, 30) -- 最小高度限制
    self.offsetLength = self.table_size.height - self.thumbHeight

    -- 滚动条可见性判断
    self.isScrollEnabled = self.innerHeight > self.table_size.height
    self.clipNode:setVisible(self.isScrollEnabled)
    self.scrollThumb:setContentSize(cc.size(14, self.thumbHeight))
end

function MobilePhone:scrollViewScriptScroll(view)
    --[[
    -- 计算内容高度
    self.innerHeight = self.table_view:getContentSize().height
    self.minOffset = self.table_view:minContainerOffset().y
    -- 计算滑块尺寸和位置
    self.thumbHeight = math.max(self.table_size.height + self.minOffset, 30) -- 最小高度限制
    self.offsetLength = self.table_size.height - self.thumbHeight

    -- 滚动条可见性判断
    self.isScrollEnabled = self.innerHeight > self.table_size.height
    self.clipNode:setVisible(self.isScrollEnabled)
    self.scrollThumb:setContentSize(cc.size(14, self.thumbHeight))
    --]]
    if self.isScrollEnabled then
        -- 根据ContentOffset计算位置比例
        local curOffset = view:getContentOffset().y
        local ratio = (self.minOffset - curOffset) / self.minOffset
        local curPosY = self.offsetLength * (1 - ratio)
        self.scrollThumb:setPositionY(curPosY)
    end
end

function MobilePhone:createTableCell(idx)
    local itemNode = cc.Node:create()
    itemNode:setContentSize(self.item_size)
    itemNode:setAnchorPoint(display.CENTER)
    itemNode:setPosition(self.itemcx, self.itemcy)
    itemNode:setName("AreaCodeWidget")

    local tData = self.table_data[idx + 1]
    ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, self.itemcx, 0):addTo(itemNode):setScaleX(self.item_size.width / 6)

    GameUtil.createLabel(tData.name, 26, GameDefine.NameColor, display.LEFT_CENTER, cc.p(20, self.itemcy), GameDefine.FontName, nil, nil, nil, true, false):addTo(itemNode)

    GameUtil.createLabel(tData.showStr, 26, GameDefine.NameColor, display.RIGHT_CENTER, cc.p(self.item_size.width - 20, self.itemcy), GameDefine.FontName, nil, nil, nil, true, false):addTo(itemNode)

    local function onBtnclick(sender, event)
        -- 播放点击音效
        if event == ccui.TouchEventType.began then
            local pos = self.table_view:convertToNodeSpace(sender:getTouchBeganPosition())
            if pos.y > self.table_size.height or pos.y < 0 then
                return false
            end
            PlazaManager.playClickEffect()
            return true
        elseif event == ccui.TouchEventType.ended then
            local pos1 = sender:getTouchBeganPosition()
            local pos2 = sender:getTouchEndPosition()
            local pos = self.table_view:convertToNodeSpace(pos2)

            if pos.y > self.table_size.height or pos.y < 0 then
                return
            end

            local d = cc.pGetDistance(pos2, pos1)
            if d > 20 then
                return
            end
            self.tCurData = tData
            self:updateChoose()
            self:closeTableView()
        end
    end

    local btn = ccui.Button:create("app/common/blank.png")
    btn:setZoomScale(-0.1);
    btn:setScale9Enabled(true)
    btn:setCapInsets(cc.rect(1, 1, 2, 2))
    btn:setContentSize(self.item_size)
    btn:addTouchEventListener(onBtnclick)
    btn:setSwallowTouches(false)
    btn:align(display.CENTER, self.itemcx, self.itemcy):addTo(itemNode)
    return itemNode
end

function MobilePhone:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeChildByName("AreaCodeWidget")
    end

    local node = self:createTableCell(idx)
    cell:addChild(node)
    return cell
end

function MobilePhone:tableCellTouched(table, cell)

end

function MobilePhone:cellSizeForTable(table, idx)
    return self.table_size.width, self.item_size.height
end

function MobilePhone:numberOfCellsInTableView()
    return #self.table_data
end

function MobilePhone:initData()
    -- area_code  长度为不加区号长度
    self.table_data = {{
        name = "意大利",
        dialing = "0039",
        showStr = "+39",
        length = 10,
        tips1 = "意大利地区格式示例: +39 333 1234567",
        tips2 = "意大利10位号码"
    }, {
        name = "马来西亚",
        dialing = "0060",
        showStr = "+60",
        length = 9,
        tips1 = "马来西亚地区格式示例: +60 12 345 6789",
        tips2 = "马来西亚9位号码"
    }, {
        name = "新加坡",
        dialing = "0065",
        showStr = "+65",
        length = 8,
        tips1 = "新加坡地区格式示例: +65 8123 4567",
        tips2 = "新加坡8位号码"
    }, {
        name = "泰国",
        dialing = "0066",
        showStr = "+66",
        length = 9,
        tips1 = "泰国地区格式示例: +66 81 234 5678",
        tips2 = "泰国9位号码"
    }, {
        name = "日本",
        dialing = "0081",
        showStr = "+81",
        length = 10,
        tips1 = "日本地区格式示例: +81 90-1234-5678",
        tips2 = "日本10位号码"
    }, {
        name = "中国",
        dialing = "0086",
        showStr = "+86",
        length = 11,
        tips1 = "中国地区格式示例: +86 123 4567 7890",
        tips2 = "中国11位号码"
    }, {
        name = "阿联酋",
        dialing = "0971",
        showStr = "+971",
        length = 9,
        tips1 = "阿联酋地区格式示例: +971 50 123 4567",
        tips2 = "阿联酋9位号码"
    }}
end

return MobilePhone

