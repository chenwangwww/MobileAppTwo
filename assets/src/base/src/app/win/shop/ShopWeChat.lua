local ShopWeChat = class("ShopWeChat", require("app.win.base.GameWindowBase"))
local ShopCopyWeChat = require("app.win.shop.ShopCopyWeChat")

function ShopWeChat:ctor()
    ShopWeChat.super.ctor(self, cc.size(1126, 668), true, false)

    self:addBasePanel()
    self:addPanelTitle()
    local image = ccui.ImageView:create("app/win/shop/img_shangcheng.png")
    image:align(display.CENTER_BOTTOM, self.midWidth, self.winSize.height - 66):addTo(self.panelNode)

    self:addCloseBtn()
    -- LangCtrl:getLang().word98
    self.use_scroll = true
    self:setName("ShopWeChat")

    self:initView()
    ----[[
    if GameDefine.bIsTestUI then
        self:doTest()
    end
    if self.use_scroll then
        self:setRankData(3)
    else
        self:updateTableView(3)
    end
    -- ]]
end

function ShopWeChat:onEnter()
    ShopWeChat.super.onEnter(self)
    self.panelNode:setScale(0.5)
    self.panelNode:runAction(cc.ScaleTo:create(0.2, 1.0))

    self.onUpdateGoldAndRoomCard = function()
    end
    self.onRankFinish = function(index)
        if self.use_scroll then
            self:setRankData(index)
        else
            self:updateTableView(index)
        end
    end

    game.registerEvent(GameDefine.UpdataUserGoalInfo, self.onUpdateGoldAndRoomCard)
    game.registerEvent(GameDefine.RANK_DATA_FINISH, self.onRankFinish)

    local elaspe = os.time() - (PlazaManager.rankInfoRefreshTime or 0)
    if elaspe > 180 then
        PlazaManager.rankInfoRefreshTime = os.time()
        PlazaManager.getRefreshModule().onSearchRankInfo(3)
    end

    --[[
    local function doUpdateData()
        PlazaManager.getRefreshModule().onSearchRankInfo(3)
    end
    local seqAc = cc.Sequence:create(cc.CallFunc:create(doUpdateData), cc.DelayTime:create(500))
    self.panelNode:runAction(cc.RepeatForever:create(seqAc))
    --]]
end

function ShopWeChat:onExit()
    self:removeScroll()
    game.unregisterEvent(GameDefine.UpdataUserGoalInfo, self.onUpdateGoldAndRoomCard)
    game.unregisterEvent(GameDefine.RANK_DATA_FINISH, self.onRankFinish)

    ShopWeChat.super.onExit(self)
end
---------------------ui函数------------------------------
function ShopWeChat:initView()
    self.table_size = cc.size(self.winSize.width - 30, self.winSize.height - 90)
    self.item_size = cc.size(266, 280)
    self.itemcx, self.itemcy = self.item_size.width / 2, self.item_size.height / 2

    if self.use_scroll then
        self.scroll = ccui.ScrollView:create()
        self.scroll:setContentSize(self.table_size)
        self.scroll:setDirection(ccui.ScrollViewDir.vertical)
        self.scroll:setAnchorPoint(display.CENTER_BOTTOM)
        self.scroll:setPosition(self.midWidth, 15)
        self.scroll:setBounceEnabled(true)
        self.panelNode:addChild(self.scroll)
    else
        self:createTableView()
    end
end

function ShopWeChat:removeScroll()
    if self.scroll then
        self.scroll:removeFromParent()
        self.scroll = nil
    end

    if self.table_view then
        self.table_view:removeFromParent()
        self.table_view = nil
    end
end

function ShopWeChat:setRankData(index)
    if index ~= 3 then
        return
    end

    self.scroll:removeAllChildren()
    if PlazaManager.rankData ~= nil and PlazaManager.rankData[index] ~= nil and #PlazaManager.rankData[index] > 0 then
        local rankDatas = PlazaManager.rankData[index]
        local scroll_height = math.max((self.item_size.height + 5) * math.ceil(#rankDatas / 4), self.table_size.height)
        self.scroll:setInnerContainerSize(cc.size(self.table_size.width, scroll_height))
        for i, v in ipairs(rankDatas) do
            local posx = self.itemcx + ((i - 1) % 4) * (self.item_size.width + 10)
            local posy = scroll_height - self.itemcy - math.floor((i - 1) / 4) * (self.item_size.height + 10)
            local goodItemNode = self:createGoodeItem(v)
            goodItemNode:align(display.CENTER, posx, posy):addTo(self.scroll)
        end
    end
end

function ShopWeChat:createTableView()
    self.table_view = cc.TableView:create(self.table_size)
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setPosition(cc.p(15, 15))
    self.table_view:setDelegate()
    self.panelNode:addChild(self.table_view)
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

function ShopWeChat:updateTableView(index)
    if index ~= 3 then
        return
    end

    local list = {}
    if PlazaManager.rankData ~= nil and PlazaManager.rankData[index] ~= nil and #PlazaManager.rankData[index] > 0 then
        list = PlazaManager.rankData[index]
    end

    if #list > 0 then
        self.table_data = {{}}
        for i, v in ipairs(list) do
            if #self.table_data[#self.table_data] >= 4 then
                table.insert(self.table_data, {})
            end
            table.insert(self.table_data[#self.table_data], v)
        end
    else
        self.table_data = {}
    end

    self.table_view:reloadData()
end

function ShopWeChat:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeChildByName("ShopTableWidget")
    end

    local node = self:createTableCell(idx)
    cell:addChild(node)
    return cell
end

function ShopWeChat:tableCellTouched(table, cell)
end

function ShopWeChat:cellSizeForTable(table, idx)
    return self.table_size.width, self.item_size.height + 10
end

function ShopWeChat:numberOfCellsInTableView()
    return #self.table_data
end

function ShopWeChat:createTableCell(idx)
    local widget = ccui.Widget:create()
    widget:setContentSize(cc.size(self.table_size.width, self.item_size.height + 10))
    widget:setAnchorPoint(display.CENTER)
    local posy = self.itemcy + 5
    widget:setPosition(self.table_size.width / 2, posy)
    widget:setName("ShopTableWidget")

    local tData = self.table_data[idx + 1]
    for i, v in ipairs(tData) do
        local posx = self.itemcx + ((i - 1) % 4) * (self.item_size.width + 10)
        local goodItemNode = self:createGoodeItem(v)
        goodItemNode:align(display.CENTER, posx, posy):addTo(widget)
    end
    return widget
end

function ShopWeChat:doTest()
    if PlazaManager.rankData == nil then
        PlazaManager.rankData = {}
    end
    PlazaManager.rankData[3] = {}

    for i = 1, 30 do
        local item = {
            index = i,
            dwGameID = 55,
            lScore = 0,
            szName = "test" .. i,
            wRankType = i,
            szFaceAddr = "",
            szWeixin = math.random(88888, 9999999)
        }
        table.insert(PlazaManager.rankData[3], item)
    end
end

function ShopWeChat:createGoodeItem(data)
    local goodNode = cc.Node:create()
    goodNode:setContentSize(self.item_size)

    -- 背景
    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    bg_1:setCapInsets(GameDefine.PanelRect3)
    bg_1:setContentSize(self.item_size)
    bg_1:align(display.CENTER, self.itemcx, self.itemcy):addTo(goodNode)

    -- local avatarurl = string.trim(data.szFaceAddr or '')
    -- local avatarurl = PlazaManager.urlGameConfig.shopAvatarUrl
    -- local faceAddr = nil
    -- 暂时屏蔽
    -- if avatarurl and string.len(avatarurl) > 0 then
    --     faceAddr = avatarurl .. data.dwGameID .. os.date('.jpg?time=%Y%m%d%H', os.time())
    -- end

    -- GameUtil.createAvatar(faceAddr, 136, false, nil, nil, nil, false):addTo(goodNode):align(display.CENTER_TOP, self.itemcx, self.item_size.height - 10)

    local headres = "app/win/shop/img_sc_weixin.png"
    if LangCtrl:isEng() then
        headres = "app/win/shop/img_sc_line.png"
    end
    local head = cc.Sprite:create(headres):addTo(goodNode)
    head:align(display.CENTER_TOP, self.itemcx, self.item_size.height - 10)

    GameUtil.createLabel(LangCtrl:getLang().word82 .. tostring(data.szWeixin), 24, cc.c3b(0xc8, 0xad, 0x6a), display.CENTER, cc.p(self.itemcx, 105), GameDefine.FontName, nil, nil, nil, true, false):addTo(
        goodNode)

    local function onBtnclick(sender, event)
        -- 播放点击音效
        if event == ccui.TouchEventType.began then
            local pos
            if self.use_scroll then
                pos = self.scroll:convertToNodeSpace(sender:getTouchBeganPosition())
            else
                pos = self.table_view:convertToNodeSpace(sender:getTouchBeganPosition())
            end

            if pos.y > self.table_size.height or pos.y < 0 then
                return false
            end
            PlazaManager.playClickEffect()
            return true
        elseif event == ccui.TouchEventType.ended then
            local pos1 = sender:getTouchBeganPosition()
            local pos2 = sender:getTouchEndPosition()

            local pos
            if self.use_scroll then
                pos = self.scroll:convertToNodeSpace(pos2)
            else
                pos = self.table_view:convertToNodeSpace(pos2)
            end

            if pos.y > self.table_size.height or pos.y < 0 then
                return
            end

            local d = cc.pGetDistance(pos2, pos1)
            if d > 20 then
                return
            end
            ShopCopyWeChat:openShopPayWin(sender.wechat)
        end
    end

    local btnres = "app/win/shop/bnt_sc.png"
    local btn_buy = ccui.Button:create(btnres):move(self.itemcx, 45):addTo(goodNode)
    btn_buy:addTouchEventListener(onBtnclick)
    btn_buy:setSwallowTouches(false)
    btn_buy:setZoomScale(-0.1)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word15, btn_buy, 131, 31) -- 充值

    btn_buy.wechat = data
    return goodNode
end

function ShopWeChat:openView()
    -- local is_yk_need_bind = globalUserInfo.cbRegType == 0 and globalUserInfo.isBindAccount == false
    -- if is_yk_need_bind then
    --     require('app.win.hall.BindAccountTipWinUI'):openView(false)
    --     return
    -- end

    local isios = PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD or PlazaManager.platform == cc.PLATFORM_OS_MAC
    if isios then
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word200)
        return
    end

    local view = ShopWeChat.new()
    view:setCenterOnScene()
    view:addToOnCheckExist(display.getRunningScene())
end

return ShopWeChat
