-- region RadioListGroups.lua
-- Author : xyj
-- Date   : 2017/3/23
-- 此文件由[BabeLua]插件自动生成
local Layout = require "app.components.Layout"

local RadioListGroups = class("RadioListGroups", function()
    return display.newLayer()
end)

function RadioListGroups:ctor(data, height)
    self.gameRuleData = data
    self.exchangeCallFunction = nil

    if height == nil then
        height = 720
    end
    local size = cc.size(663, height)
    self:setContentSize(size)
    -- debugDraw(self)

    local listview = ccui.ListView:create()
    listview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    listview:setContentSize(663, height)
    listview:setScrollBarEnabled(false)
    self:addChild(listview)
    -- debugDraw(listview)
    self.listview = listview

    local function onCheckEvent(sender, eventType)
        local checkData = sender.gameData
        if checkData == nil then
            printError("error Check error:onRadioGroupEvent.checkData=nil")
            return
        end

        -- 获取item数据
        local ruleItemData = self.gameRuleData.ruleData.gameRule[checkData.index]
        if ruleItemData == nil then
            printError("error checkData error:checkData.ruleItemData=nil")
            return
        end

        local ruleGroupList = ruleItemData.groups[1].list
        if ruleGroupList ~= nil then
            for key, var in ipairs(ruleGroupList) do
                if #var > 0 then
                    for key1, var1 in ipairs(var) do
                        if var1 == checkData.data then
                            if eventType == ccui.CheckBoxEventType.selected then
                                ruleItemData.groups[1].curSelect[key1] = true
                            elseif eventType == ccui.CheckBoxEventType.unselected then
                                ruleItemData.groups[1].curSelect[key1] = false
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    local function onRadioGroupEvent(sender, selectedIndex, event_type)
        local radioData = sender.gameData
        if radioData == nil then
            printError("error RadioListGroups error:onRadioGroupEvent.radioData=nil")
            return
        end

        -- 获取item数据
        local ruleItemData = self.gameRuleData.ruleData.gameRule[radioData.index]
        if ruleItemData == nil then
            printError("error RadioListGroups error:onRadioGroupEvent.ruleItemData=nil")
            return
        end

        -- 设置选择
        ruleItemData.groups[1].curSelect = selectedIndex + 1

        -- if ruleItemData.isClean == true then
        local items = listview:getItems()
        if items ~= nil and listview:getCurSelectedIndex() ~= -1 then
            -- 删除全部
            listview:removeAllItems()

            -- 重新绘制
            for key, var in ipairs(self.gameRuleData.ruleData.gameRule) do
                local listItem = self:createListItem(var, onRadioGroupEvent, onCheckEvent)
                if listItem ~= nil then
                    listview:pushBackCustomItem(listItem)
                end
            end

            listview:setCurSelectedIndex(0)
        end
        if self.exchangeCallFunction ~= nil then
            self.exchangeCallFunction()
        end
    end

    -- 创建listItem
    for key, var in ipairs(data.ruleData.gameRule) do
        local listItem = self:createListItem(var, onRadioGroupEvent, onCheckEvent)
        if listItem ~= nil then
            listview:pushBackCustomItem(listItem)
        end
    end

    listview:setCurSelectedIndex(0)

end

function RadioListGroups:createListItem(data, onRadioGroupEvent, onCheckEvent)

    -- 创建item里面的group
    local gGroupList = {}
    local function createGroupList()
        local groupCount = #data.groups
        for i = 1, groupCount do
            local gNode = self:createGroup(data.index, data.parentNode, data.groups[i], onRadioGroupEvent, onCheckEvent)
            if gNode ~= nil then
                table.insert(gGroupList, gNode)
            end
        end

        local len = #gGroupList
        if len > 0 then
            local node = Layout.createVBox(gGroupList, 0)
            node:setTag(data.index)
            return node
        end

        return nil
    end

    local itemListNode = createGroupList()

    if itemListNode == nil then
        return nil
    end

    -- 设置item大小
    local size = cc.size(663, itemListNode:getContentSize().height) -- +60 

    -- 创建item
    local defaultItem = ccui.Layout:create()
    defaultItem:setContentSize(size)
    defaultItem.gameData = data

    -- item背景
    local spr = display.newSprite("app/common/img_item.png")
    spr:setAnchorPoint(display.CENTER_TOP)
    spr:move(size.width / 2, size.height):addTo(defaultItem)

    -- 白线
    local sprBottom = display.newSprite("app/common/img_item.png")
    sprBottom:setAnchorPoint(display.CENTER_BOTTOM)
    sprBottom:move(size.width / 2, 0):addTo(defaultItem)

    -- item标题
    local label = cc.Label:createWithTTF(data.title, GameDefine.FontName, 25, cc.size(150, 40), cc.TEXT_ALIGNMENT_RIGHT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    label:setColor(cc.c3b(248, 237, 200))
    label:setColor(cc.c3b(0x8f, 0xc4, 0xe5))
    label:setAnchorPoint(display.LEFT_BOTTOM)
    -- label:enableOutline(cc.c4b(188, 86, 58, 255), 2)
    label:setPosition(0, size.height - 55)
    defaultItem:addChild(label)

    itemListNode:setAnchorPoint(display.RIGHT_BOTTOM)
    itemListNode:setPosition(size.width, size.height / 2 - itemListNode:getContentSize().height / 2)
    defaultItem:addChild(itemListNode)

    return defaultItem
end

function RadioListGroups:createGroup(index, parentNode, data, onRadioGroupEventCallBack, onCheckEventCallBack)

    local function onRadioGroupEvent(sender, selectedIndex, event_type)
        if onRadioGroupEventCallBack ~= nil then
            onRadioGroupEventCallBack(sender, selectedIndex, event_type)
        end
    end

    local function selectedEvent(sender, eventType)
        if onCheckEventCallBack ~= nil then
            onCheckEventCallBack(sender, eventType)
        end
    end

    -- 获取需要显示的控件
    local showListControl = nil
    -- 获取父节点的数据
    local parentCurSelect = 1
    if parentNode ~= 0 then
        local parentData = self.gameRuleData.ruleData.gameRule[parentNode]
        if parentData ~= nil then
            parentCurSelect = parentData.groups[1].curSelect
            if parentCurSelect ~= nil then
                showListControl = data.list[parentCurSelect]
            end
        end
    else
        showListControl = data.list[1]
    end

    if showListControl == nil or #showListControl == 0 then
        return nil
    end

    local sizeWidth = 460
    local node = display.newNode()

    -- 一个radio控件的宽
    local oneRadioWidth = math.floor(sizeWidth / data.rowCount)

    -- 需要显示控件的个数
    local controlCount = 0
    if showListControl ~= nil then
        controlCount = #showListControl
    end
    if controlCount == 0 then
        controlCount = 1
    end

    -- 需要几行来显示这些控件
    local rowLine = math.floor(controlCount / data.rowCount)
    rowLine = rowLine + controlCount % data.rowCount
    if controlCount < data.rowCount then
        rowLine = 1
    end

    if data.isAddHit == 1 then
        rowLine = rowLine
    end

    -- 总group大小
    local size = cc.size(460, 68 + (rowLine - 1) * 68)
    node:setContentSize(size)

    -- 绘制控件
    if showListControl == nil then
        return
    end
    for key, var in ipairs(showListControl) do
        -- 控件坐标
        local divisor = math.floor(key / data.rowCount)
        local remain = key % data.rowCount
        local posx = remain - 1
        local posy = divisor
        if remain == 0 then
            posx = data.rowCount - 1
        end
        if remain == 0 then
            posy = divisor - 1
        end

        local item_node = display.newNode()
        local radio = nil

        local radioData = {}
        radioData.index = index
        radioData.data = var
        if data.controlType == "radio" then
            local radioSpriteName = "app/common/radio_1.png"
            if data.curSelect ~= nil and key == data.curSelect then
                radioSpriteName = "app/common/radio_2.png"
            end
            radio = display.newSprite(radioSpriteName)
            radio.index = key
            radio:setName("radio1")
            radio.gameData = radioData
            radio:setPosition(posx * oneRadioWidth, size.height - 34 - (posy) * 68)
            item_node.controlType = "radio"
        elseif data.controlType == "check" then
            local isShowSelect = false
            if data.curSelect ~= nil and type(data.curSelect) == "table" and #data.curSelect > 0 and key <= #data.curSelect and data.curSelect[key] ~= nil then
                if data.curSelect[key] == true then
                    isShowSelect = true
                end
            end
            radio = display.newSprite("app/login/check_1.png")
            local spr = display.newSprite("app/login/check_2.png")
            spr:setName("check_select")
            spr:setVisible(false)
            spr:setPosition(radio:getContentSize().width / 2, radio:getContentSize().height / 2)
            spr:addTo(radio)
            if isShowSelect == true then
                spr:setVisible(true)
            end
            radio.isShowSelect = isShowSelect
            radio:setName("radio1")
            radio.index = key
            radio.gameData = radioData
            radio:setPosition(posx * oneRadioWidth, size.height - 34 - (posy) * 68)
            item_node.controlType = "check"
        end

        local isColor = false
        if data.controlType == "check" or data.controlType == "radio" then
            if key == data.curSelect then
                isColor = true
            end
        end

        -- 创建label
        local radioLabel = ""
        local labelData = self.gameRuleData.listData[var]
        if labelData ~= nil then
            radioLabel = labelData.label
        end
        local labelPos = cc.p(radio:getPositionX() + radio:getContentSize().width / 2 + 5, radio:getPositionY() - 30 / 2)
        local label = nil
        if isColor == true then
            label = GameUtil.createLabel(radioLabel, 25, cc.c3b(0xc6, 0xe0, 0xff), display.LEFT_BOTTOM, labelPos, GameDefine.FontName)
        else
            label = GameUtil.createLabel(radioLabel, 25, cc.c3b(0x8f, 0xc4, 0xe5), display.LEFT_BOTTOM, labelPos, GameDefine.FontName)
        end

        label.gameData = var

        -- 创建容器
        local w_r = radio:getContentSize().width + label:getContentSize().width
        local w_h = radio:getContentSize().height
        item_node:setContentSize(cc.size(w_r, w_h))
        item_node:setPosition(posx * oneRadioWidth, size.height - 50 - (posy) * 68)

        radio:setPosition(cc.p(radio:getContentSize().width / 2, radio:getContentSize().height / 2))
        label:setPosition(cc.p(radio:getPositionX() + radio:getContentSize().width / 2 + 5, radio:getPositionY() - 30 / 2))
        item_node:addChild(radio)
        item_node:addChild(label)
        item_node.index_test = key

        item_node:addTo(node)

        local function IsLocationInNode(node, loc)
            local pos = node:convertToNodeSpace(loc)
            local s = node:getContentSize()
            local rect = cc.rect(0, 0, s.width, s.height)
            return cc.rectContainsPoint(rect, pos)
        end

        local function onTouchBegan(touch, event)
            local target = event:getCurrentTarget()
            local location = touch:getLocation()
            if IsLocationInNode(target, location) then
                if target ~= nil then
                    local test_sd = target:getChildByName("radio1")
                    if test_sd ~= nil then
                        if target.controlType == "radio" then
                            onRadioGroupEvent(test_sd, test_sd.index - 1, 1)
                        elseif target.controlType == "check" then
                            local spr_ = test_sd:getChildByName("check_select")
                            if spr_ ~= nil then
                                local checkEventType = 0

                                if spr_:isVisible() == true then
                                    checkEventType = 1
                                    spr_:setVisible(false)
                                else
                                    spr_:setVisible(true)
                                end
                                selectedEvent(test_sd, checkEventType)
                            end
                        end
                    else
                        printLog("RadioListGroups", "test_sd == null")
                    end
                end
            end

            return false
        end

        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        item_node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, item_node)

    end

    return node
end

function RadioListGroups:getData()
    return self.gameRuleData
end

function RadioListGroups:setListHeight(heightNum)
    local size = cc.size(663, heightNum)
    self:setContentSize(size)
    self.listview:setContentSize(size)
    self.listview:jumpToTop()
end
function RadioListGroups:setChangeCallFunction(exchangeCallFunction)
    self.exchangeCallFunction = exchangeCallFunction
end

return RadioListGroups

-- endregion
