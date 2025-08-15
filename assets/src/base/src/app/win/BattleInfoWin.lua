-- region BattleInfoWin.lua
-- Author : xyj
-- Date   : 2017/7/25
-- 此文件由[BabeLua]插件自动生成
local BattleInfoWin = class("BattleInfoWin", require("app.win.base.GameWindowBase"))
local RecordManager = require "app.win.Record.RecordManager"

local niuniuTypeName = {}
niuniuTypeName[0] = "没牛"
niuniuTypeName[1] = "牛一"
niuniuTypeName[2] = "牛二"
niuniuTypeName[3] = "牛三"
niuniuTypeName[4] = "牛四"
niuniuTypeName[5] = "牛五"
niuniuTypeName[6] = "牛六"
niuniuTypeName[7] = "牛七"
niuniuTypeName[8] = "牛八"
niuniuTypeName[9] = "牛九"
niuniuTypeName[10] = "牛牛"
niuniuTypeName[103] = "四花牛"
niuniuTypeName[104] = "五花牛"
niuniuTypeName[105] = "五小牛"
niuniuTypeName[106] = "炸弹"

function BattleInfoWin:ctor(v, battleDetail)
    local size = cc.size(750, 1334)
    BattleInfoWin.super.ctor(self, size, true)

    local img_bg = GameUtil.newSprite("app/win/common/img_win_bg.png", false):move(self.midWidth, self.midHeight):addTo(self)

    local img_bg_2 = cc.Scale9Sprite:create("app/win/battle/bg_3.png")
    img_bg_2:setCapInsets(CCRectMake(30, 30, 30, 30))
    img_bg_2:setContentSize(cc.size(710, 960))
    img_bg_2:setAnchorPoint(display.CENTER)
    img_bg_2:setPosition(self.midWidth, 596)
    self:addChild(img_bg_2)

    local img_bg_3 = cc.Scale9Sprite:create("app/win/battle/bg_6.png")
    img_bg_3:setCapInsets(CCRectMake(9, 9, 9, 9))
    img_bg_3:setContentSize(cc.size(680, 930))
    img_bg_3:setAnchorPoint(display.CENTER)
    img_bg_3:setPosition(self.midWidth, 596)
    self:addChild(img_bg_3)

    local img_bg_4 = cc.Scale9Sprite:create("app/win/battle/bg_4.png")
    img_bg_4:setCapInsets(CCRectMake(5, 5, 5, 5))
    img_bg_4:setContentSize(cc.size(670, 920))
    img_bg_4:setAnchorPoint(display.CENTER)
    img_bg_4:setPosition(self.midWidth, 596)
    self:addChild(img_bg_4)

    local titleNode = cc.Node:create()
    titleNode:setContentSize(439, 166)
    titleNode:setAnchorPoint(display.CENTER)
    titleNode:setPosition(self.midWidth, 1240)
    self:addChild(titleNode)

    GameUtil.newSprite("app/win/battle/icon_title_1.png", false):align(display.CENTER, 220, 133):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_bg.png", false):align(display.CENTER, 220, 53):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_icon_2.png", false):align(display.CENTER, 132, 67):addTo(titleNode)
    GameUtil.newSprite("app/win/common/img_title_icon_1.png", false):align(display.CENTER, 319, 67):addTo(titleNode)
    GameUtil.newSprite("app/win/battle/icon_title_2.png", false):align(display.CENTER, 220, 71):addTo(titleNode)

    -- local img_bg_top = display.newSprite("app/win/common/img_battle_info_top.png"):move(375,1100):addTo(self)
    local str = string.format("局号：%s", battleDetail.szRoomID)
    GameUtil.createLabel(str, 30, cc.c3b(0xE1, 0xFF, 0xFF), display.CENTER, cc.p(375, 1125), nil, nil, "center", "center", true, nil, self)

    -- 关闭按钮
    local function onExitBtnClick(sender)
        self:onClose()
    end

    GameUtil.createButton("app/win/common/btn_close_1.png", "app/win/common/btn_close_2.png", onExitBtnClick):move(688, 1197):addTo(self)

    self.listview = ccui.ListView:create()
    self.listview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    local listSize = cc.size(656, 880)
    self.listview:setItemsMargin(20)
    self.listview:setContentSize(listSize)
    self.listview:setBounceEnabled(false)
    self.listview:setTouchEnabled(true)
    self.listview:setScrollBarEnabled(false)
    self.listview:setPosition(52, 160)
    self:addChild(self.listview)
    debugDraw(self.listview)

    -- 清楚所有数据
    self.listview:removeAllChildren()

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
        local str = string.format("%s (第%d局)", gameName, data.index)
        GameUtil.createLabel(str, 25, cc.WHITE, display.CENTER, cc.p(size.width / 2, 20), nil, cc.size(651, 30), "center", "center", true):addTo(topSpr)

        local playerIndex = 0
        for i = 1, GameDefine.PERSONAL_ROOM_CHAIR do
            local name = GameUtil.subStringFromUTF8(data.names[i], 10)
            if string.len(name) > 0 then
                playerIndex = playerIndex + 1
                local color = cc.c3b(0xE1, 0xFF, 0xFF)
                local y = spriteHeight - (playerIndex - 1) * 40 - 5

                local labelScore = "积分"
                if battleDetail.requestDataType == 1 then
                    labelScore = "金币"
                end
                local score = string.format(labelScore .. ":%s", data.scores[i])

                local isRecord = false
                local gameInfo = PlazaManager.getUrlGameInfoByKindID(data.dwKindID)
                if gameInfo ~= nil then
                    if gameInfo.isRecord == 1 then
                        isRecord = true
                    end
                end

                local niuniuType = ""
                if isRecord == true then
                    if i == 1 then
                        niuniuType = "查看录像"
                    end
                else
                    niuniuType = string.format("牌型:%s", niuniuTypeName[data.reason[i]])
                end

                GameUtil.createLabel(name, 28, color, display.LEFT_TOP, cc.p(20, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
                GameUtil.createLabel(score, 28, color, display.LEFT_TOP, cc.p(300, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
                GameUtil.createLabel(niuniuType, 28, color, display.LEFT_TOP, cc.p(500, y), nil, cc.size(200, 30), nil, nil, nil, true):addTo(sprite)
            end
        end

        return defaultItem
    end

    if battleDetail ~= nil then
        for i = 1, battleDetail.gameCount do
            local battleData = {}
            battleData.dwKindID = battleDetail.dwKindID
            battleData.szRoomID = battleDetail.szRoomID
            battleData.dwPlayerCount = battleDetail.dwPlayerCount
            battleData.index = i
            battleData.names = battleDetail.names
            battleData.scores = battleDetail.scores[i]
            battleData.reason = battleDetail.reason[i]
            local item = createListItem(battleData)
            if item ~= nil then
                self.listview:pushBackCustomItem(item)
            end
        end
    end

    local function onListViewEvent(pSender, eventType)
        if eventType == 1 then
            local index = pSender:getCurSelectedIndex()
            local item_ = pSender:getItem(pSender:getCurSelectedIndex())
            if item_ ~= nil then

                local isRecord = false
                local gameInfo = PlazaManager.getUrlGameInfoByKindID(battleDetail.dwKindID)
                if gameInfo ~= nil then
                    if gameInfo.isRecord == 1 then
                        isRecord = true
                    end
                end

                if isRecord == true then
                    local data = item_.itemData
                    -- 请求录像信息
                    local record_args = {}
                    record_args.szRoomID = battleDetail.szRoomID
                    record_args.recordIndex = data.index

                    -- 创建录像管理信息
                    if PlazaManager.recordManager ~= nil then
                        PlazaManager.recordManager:onClose()
                        PlazaManager.recordManager = nil
                    end
                    local record_params = {}
                    record_params.dwKindID = battleDetail.dwKindID
                    PlazaManager.recordManager = RecordManager.new(record_params)

                    PlazaManager.showConectWaitTips(nil)
                    local function onConnectResult(isSuccess, ipsCount)
                        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, "请求录像数据...", "请求录像数据超时")
                    end
                    PlazaManager.getLoginModule().onRequestRecordInfo(record_args, onConnectResult)

                    print("record_args.szRoomID == " .. record_args.szRoomID .. "  record_args.index == " .. record_args.recordIndex)
                end
            end
        end
    end

    self.listview:addEventListenerListView(onListViewEvent)
end

return BattleInfoWin

-- endregion
