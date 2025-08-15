-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/7/24
-- 此文件由[BabeLua]插件自动生成
local Buttons = require "app.components.Buttons"
local BattleInfoWin = require "app.win.BattleInfoWin"
local CommonBoxNode = require "app.components.CommonBoxNode"

local BattleWin = class("BattleWin", require("app.win.base.GameWindowBase"))

function BattleWin:ctor(args)
    local size = cc.size(750, 1334)
    BattleWin.super.ctor(self, size, true)

    self.questDataFinish = false
    self.requestDataType = 0

    local img_bg = GameUtil.newSprite("app/win/common/img_win_bg.png", false):move(377, 654):addTo(self)

    local img_bg_2 = cc.Scale9Sprite:create("app/win/battle/bg_3.png")
    img_bg_2:setCapInsets(CCRectMake(30, 30, 30, 30))
    img_bg_2:setContentSize(cc.size(710, 960))
    img_bg_2:setAnchorPoint(display.CENTER)
    img_bg_2:setPosition(378, 596)
    self:addChild(img_bg_2)

    local img_bg_3 = cc.Scale9Sprite:create("app/win/battle/bg_6.png")
    img_bg_3:setCapInsets(CCRectMake(9, 9, 9, 9))
    img_bg_3:setContentSize(cc.size(680, 930))
    img_bg_3:setAnchorPoint(display.CENTER)
    img_bg_3:setPosition(378, 596)
    self:addChild(img_bg_3)

    local img_bg_4 = cc.Scale9Sprite:create("app/win/battle/bg_4.png")
    img_bg_4:setCapInsets(CCRectMake(5, 5, 5, 5))
    img_bg_4:setContentSize(cc.size(670, 920))
    img_bg_4:setAnchorPoint(display.CENTER)
    img_bg_4:setPosition(378, 596)
    self:addChild(img_bg_4)

    local titleNode = cc.Node:create()
    titleNode:setContentSize(439, 166)
    titleNode:setAnchorPoint(display.CENTER)
    titleNode:setPosition(375, 1240)
    self:addChild(titleNode)

    GameUtil.newSprite("app/win/battle/icon_title_1.png", false):align(display.CENTER, 220, 133):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_bg.png", false):align(display.CENTER, 220, 53):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_icon_2.png", false):align(display.CENTER, 132, 67):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_icon_1.png", false):align(display.CENTER, 319, 67):addTo(titleNode)
    GameUtil.newSprite("app/win/battle/icon_title_2.png", false):align(display.CENTER, 220, 71):addTo(titleNode)

    self.listview = ccui.ListView:create()

    self.listview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    local listSize = cc.size(656, 770)
    self.listview:setItemsMargin(20)
    self.listview:setContentSize(listSize)
    self.listview:setBounceEnabled(false)
    self.listview:setTouchEnabled(true)
    self.listview:setScrollBarEnabled(true)
    self.listview:setPosition(50, 175)
    self.listview:setBackGroundColor(cc.WHITE)
    self:addChild(self.listview)

    -- 关闭按钮
    local function onExitBtnClick(sender)
        self:onClose()
    end
    GameUtil.createButton("app/win/common/btn_close_1.png", "app/win/common/btn_close_2.png", onExitBtnClick):move(688, 1197):addTo(self)

    -- 创建下拉
    local function itemCallBack(itemData)
        local selectIndex = self:getSelectIndex()
        local selectKindID = itemData.kindid
        local listDatas = self:getBattleByKindID(selectIndex, selectKindID)
        self:onUpdateListView(listDatas)
    end

    local gameListType = GameDefine.GAME_LIST_TYPE.NORMAL
    if PlazaManager.isCheck == true then
        gameListType = GameDefine.GAME_LIST_TYPE.CHECK
    end

    local gameListdata_1 = PlazaManager.getGameList(gameListType)
    local gameListdata = {}
    local tGameMap = ServerListData.getCoinGameMap()
    for i = 1, #gameListdata_1 do
        if tGameMap[gameListdata_1[i].kindid] == nil then
            table.insert(gameListdata, gameListdata_1[i])
        end
    end

    local allGame = {}
    allGame.name = "allgame"
    allGame.nameStr = "所有游戏"
    allGame.kindid = 0
    if gameListdata ~= nil then
        table.insert(gameListdata, 1, allGame)
    end

    local gameCommonBoxNode = CommonBoxNode.new(gameListdata, 1, itemCallBack, 650, 64, nil, false, nil, nil, nil, 50)
    gameCommonBoxNode:setAnchorPoint(display.CENTER)
    gameCommonBoxNode:setPosition(375, 1000)
    self:addChild(gameCommonBoxNode)
    self.itemListControl = gameCommonBoxNode

    -- 创建group按钮
    local function updateView(index)
        local selectIndex = self:getSelectIndex()
        local kindID = 0
        if self.itemListControl ~= nil then
            self.itemListControl:setCurSelect(1)
        end

        -- 请求战绩信息
        self:onUpdateListView(self:getGameDatas())
        if self.questDataFinish == false then
            PlazaManager.showConectWaitTips(nil)
            local function onConnectResult(isSuccess, ipsCount)
                PlazaManager.onConnectResult(isSuccess, ipsCount, nil, "请求战绩数据...", "请求战绩数据超时")
            end
            self.requestDataType = selectIndex - 1
            PlazaManager.getLoginModule().onRequestBattle(self.requestDataType, nil, onConnectResult)
        end
    end
    self:createRadioGroup(updateView, img_bg)

    -- 战绩刷新事件
    self.onBattleFinish = function()
        self:onAcceptBattleListFinish()
    end
    game.registerEvent(GameDefine.BATTLE_DATA_FINISH, self.onBattleFinish)

    -- 战绩明细刷新事件
    self.onBattleDetailFinish = function(args)
        self:onUpdateBattleDetail(args)
    end
    game.registerEvent(GameDefine.GP_UPDATE_BATTLE_DETAIL, self.onBattleDetailFinish)

    -- 添加listView事件
    local function onListViewEvent(pSender, eventType)
        if eventType == 1 then
            local list = pSender
            local index = pSender:getCurSelectedIndex()
            local item_ = pSender:getItem(pSender:getCurSelectedIndex())

            if item_ ~= nil then
                local itemData = item_.itemData
                if itemData ~= nil then

                    PlazaManager.showConectWaitTips(nil)
                    local function onConnectResult(isSuccess, ipsCount)
                        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, "请求战绩明细中...", "请求战绩明细超时")
                    end
                    PlazaManager.getLoginModule().onRequestBattleInfo(itemData.szRoomID, onConnectResult)
                end
            end
        end
    end

    self.listview:addEventListenerListView(onListViewEvent)
end

function BattleWin:onUpdateListView(battleDatas)

    local function createListItem(data)
        local defaultItem = ccui.Layout:create()
        defaultItem:setTouchEnabled(true)

        local itemHeight = data.dwPlayerCount * 40 + 40 + 1
        local size = cc.size(651, itemHeight)
        defaultItem:setContentSize(size)
        defaultItem.itemData = data

        local topSpr = display.newSprite("app/win/battle/img_item_top_bg.png"):align(display.CENTER_TOP, size.width / 2, itemHeight):addTo(defaultItem)

        local spriteHeight = data.dwPlayerCount * 40
        local sprite = cc.Scale9Sprite:create("app/win/battle/img_item_down_bg.png")
        sprite:setCapInsets(CCRectMake(40, 10, 600, 30))
        sprite:setContentSize(size.width, spriteHeight)
        sprite:align(display.CENTER_TOP, size.width / 2, itemHeight - 41):addTo(defaultItem)

        local gameName = ServerListData.getNameByKindID(data.dwKindID)

        local str = string.format("局号:%s  %s(%s局)", data.szRoomID, gameName, data.dwRoundCount)
        GameUtil.createLabel(str, 25, cc.c3b(0xE1, 0xFF, 0xFF), display.CENTER, cc.p(size.width / 2, 20), nil, cc.size(651, 30), "center", "center", true):addTo(topSpr)

        for i = 1, data.dwPlayerCount do
            local color = cc.c3b(0x9d, 0xb2, 0xdd)
            local y = spriteHeight - (i - 1) * 40 - 5

            local name = GameUtil.subStringFromUTF8(data.names[i], 10)
            local labelScore = "积分"
            if self.requestDataType == 1 then
                labelScore = "金币"
            end
            local score = string.format(labelScore .. ":%s", data.scores[i])
            if (i - 1) == data.dwWinnerChairID then
                color = cc.c3b(0xff, 0xf2, 0xe3)
                local labelCoin = "房卡"
                if self.requestDataType == 1 then
                    labelCoin = "房费"
                end
                local roomCard = string.format(labelCoin .. ":-%s", data.dwRoomPrice)
                GameUtil.createLabel(roomCard, 25, color, display.LEFT_TOP, cc.p(500, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
            end
            GameUtil.createLabel(name, 25, color, display.LEFT_TOP, cc.p(50, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
            GameUtil.createLabel(score, 25, color, display.LEFT_TOP, cc.p(280, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
        end

        return defaultItem
    end

    -- 清楚所有数据
    self.listview:removeAllChildren()

    if battleDatas ~= nil and #battleDatas > 0 then
        for key, var in ipairs(battleDatas) do
            local item = createListItem(var)
            if item ~= nil then
                self.listview:pushBackCustomItem(item)
            end
        end
    end
end

function BattleWin:createRadioGroup(callBack, parent_node)
    local function onBattleRadioGroupEvent(sender, selectedIndex, event_type)
        if sender == nil then
            return
        end

        if callBack ~= nil then
            callBack(selectedIndex)
        end
    end

    self.battleModuleGroup = ccui.RadioButtonGroup:create()
    self.battleModuleGroup:addEventListener(onBattleRadioGroupEvent)
    parent_node:addChild(self.battleModuleGroup)

    local radioBtn_coin = ccui.RadioButton:create("app/win/battle/btn_goal_2.png", "app/win/battle/btn_goal_1.png")
    radioBtn_coin:setTag(0)
    radioBtn_coin:setZoomScale(0)
    radioBtn_coin:setPosition(200, 1110)
    if PlazaManager.isCheck == true then
        radioBtn_coin:setVisible(false)
    end
    parent_node:addChild(radioBtn_coin)
    self.battleModuleGroup:addRadioButton(radioBtn_coin)

    local radioBtn_room = ccui.RadioButton:create("app/win/battle/btn_room_2.png", "app/win/battle/btn_room_1.png")
    radioBtn_room:setTag(1)
    radioBtn_room:setZoomScale(0)
    radioBtn_room:setPosition(552, 1110)
    if PlazaManager.isCheck == true then
        radioBtn_room:setVisible(false)
    end
    parent_node:addChild(radioBtn_room)
    self.battleModuleGroup:addRadioButton(radioBtn_room)

    self.battleModuleGroup:setSelectedButton(1)
end

function BattleWin:getSelectIndex()
    local selectIndex = self.battleModuleGroup:getSelectedButtonIndex()
    if selectIndex == 0 then
        return 2
    else
        return 1
    end
end

function BattleWin:getGameIndex()
    return 0
end

function BattleWin:getGameDatas()
    local selectIndex = self:getSelectIndex()
    local gameIndex = self:getGameIndex()

    local datas = nil
    if PlazaManager.battleData ~= nil and #PlazaManager.battleData > 0 and PlazaManager.battleData[selectIndex] ~= nil and #PlazaManager.battleData[selectIndex] > 0 then
        datas = PlazaManager.battleData[selectIndex]
    end

    return datas
end

function BattleWin:onUpdateBattleDetail(args)
    local index = self.listview:getCurSelectedIndex()
    local item_ = self.listview:getItem(index)

    if item_ ~= nil then
        local itemData = item_.itemData
        if itemData ~= nil then
            args.dwKindID = itemData.dwKindID
            args.szRoomID = itemData.szRoomID
            args.dwPlayerCount = itemData.dwPlayerCount
            args.requestDataType = self.requestDataType
            local rWin = BattleInfoWin.new(self, args)
            if rWin ~= nil then
                local x = (display.width - rWin:getContentSize().width) / 2
                local y = (display.height - rWin:getContentSize().height) / 2
                rWin:move(x, y):addTo(display.getRunningScene())
            end
        end
    end
end

function BattleWin:getBattleByKindID(roomType, kindID)
    local result = {}
    if PlazaManager.battleData ~= nil and #PlazaManager.battleData > 0 and PlazaManager.battleData[roomType] ~= nil and #PlazaManager.battleData[roomType] > 0 then
        local datas = PlazaManager.battleData[roomType]
        for key, var in pairs(datas) do
            if kindID == 0 then
                table.insert(result, var)
            else
                if var.dwKindID == kindID then
                    table.insert(result, var)
                end
            end
        end
    end
    return result
end

function BattleWin:onAcceptBattleListFinish()
    self:onUpdateListView(self:getGameDatas())
end

function BattleWin:onExit()
    game.unregisterEvent(GameDefine.BATTLE_DATA_FINISH, self.onBattleFinish)
    game.unregisterEvent(GameDefine.GP_UPDATE_BATTLE_DETAIL, self.onBattleDetailFinish)
end

return BattleWin

-- endregion
