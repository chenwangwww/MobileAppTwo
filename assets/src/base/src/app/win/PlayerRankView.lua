local PlayerRankView = class("PlayerRankView", require("app.win.base.GameWindowWinBase"))
local UserInfoWinUI = require "app.win.hall.UserInfoWinUI"

function PlayerRankView:ctor()
    PlayerRankView.super.ctor(self, LangCtrl:getLang().word223, true, false, cc.size(1000, 650))

    self.use_scroll = false
    self.nRankType = 3 -- 排行榜类别    1、个人排行  2、家族排行.3、个人金币排行
    self:setName("PlayerRankView")

    self.table_data = {}

    self:initView()

    if GameDefine.bIsTestUI then
        self:doTest()
    end

    if self.use_scroll then
        self:setRankData(self.nRankType)
    else
        self:updateTableView(self.nRankType)
    end
    self:updateMyRank(self.nRankType)
end

function PlayerRankView:doTest()
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

function PlayerRankView:onEnter()
    PlayerRankView.super.onEnter(self)

    self.onRankFinish = function(index)
        if index ~= self.nRankType then
            return
        end

        if self.use_scroll then
            self:setRankData(self.nRankType)
        else
            self:updateTableView(self.nRankType)
        end
        self:updateMyRank(self.nRankType)
    end
    game.registerEvent(GameDefine.RANK_DATA_FINISH, self.onRankFinish)

    local elaspe = os.time() - (PlazaManager.rankInfoRefreshTime or 0)
    if elaspe > 180 then
        PlazaManager.rankInfoRefreshTime = os.time()
        PlazaManager.getRefreshModule().onSearchRankInfo(self.nRankType)
    end
end

function PlayerRankView:onExit()
    game.unregisterEvent(GameDefine.RANK_DATA_FINISH, self.onRankFinish)
    PlayerRankView.super.onExit(self)
end

function PlayerRankView:onClearUp()
    self:disableNodeEvents()
    PlayerRankView.super.onClearUp(self)
end

---------------------ui函数------------------------------
function PlayerRankView:initView()

    local bg_3 = ccui.Scale9Sprite:create("app/common/comwin/edit_bg.png")
    bg_3:setCapInsets(cc.rect(3, 3, 2, 2))
    bg_3:setContentSize(864, 50)
    bg_3:align(display.CENTER, self.midWidth, self.winSize.height - 120):addTo(self.panelNode)

    local txtColor = cc.c3b(0xff, 0xff, 0xd6)

    local txt1 = cc.Label:createWithTTF(LangCtrl:getLang().word224, "app/fonts/fzz.ttf", 26)
    txt1:align(display.CENTER, 100, 25)
    txt1:setColor(txtColor)
    txt1:addTo(bg_3)

    txt1 = cc.Label:createWithTTF(LangCtrl:getLang().word225, "app/fonts/fzz.ttf", 26)
    txt1:align(display.CENTER, 400, 25)
    txt1:setColor(txtColor)
    txt1:addTo(bg_3)

    txt1 = cc.Label:createWithTTF(LangCtrl:getLang().word226, "app/fonts/fzz.ttf", 26)
    txt1:align(display.CENTER, 730, 25)
    txt1:setColor(txtColor)
    txt1:addTo(bg_3)

    local bg_4 = ccui.Scale9Sprite:create("app/common/comwin/panel_2.png")
    bg_4:setCapInsets(GameDefine.PanelRect2)
    bg_4:setContentSize(864, 60)
    bg_4:align(display.CENTER, self.midWidth, 60):addTo(self.panelNode)

    self.myRankTxt = cc.Label:createWithTTF(LangCtrl:getLang().word227 .. " --", "app/fonts/fzz.ttf", 26)
    self.myRankTxt:align(display.LEFT_CENTER, 35, 30)
    self.myRankTxt:addTo(bg_4)

    local img_head = GameUtil.createAvatar(globalUserInfo.headimgurl, 60, true, nil, nil, nil, nil)
    img_head:align(display.CENTER, 300, 30):addTo(bg_4)
    local headbgmask = GameUtil.newSprite("app/common/img_txbjk.png", false):align(display.CENTER, 30, 30):addTo(img_head)
    headbgmask:setScale(0.4)

    -- 昵称
    txt1 = cc.Label:createWithTTF(globalUserInfo.szNickName, "app/fonts/fzz.ttf", 26)
    txt1:align(display.LEFT_CENTER, 350, 30)
    txt1:addTo(bg_4)

    -- 金币
    txt1 = cc.Label:createWithTTF(globalUserInfo.lUserScore, "app/fonts/fzz.ttf", 26)
    txt1:align(display.LEFT_CENTER, 690, 30)
    txt1:addTo(bg_4)

    GameUtil.newSprite("app/common/gold_icon.png", false):align(display.CENTER, 650, 30):addTo(bg_4)

    self:addCloseBtn()

    self.table_size = cc.size(self.winSize.width, self.winSize.height - 250)

    if self.use_scroll then
        self.scroll = ccui.ScrollView:create()
        self.scroll:setContentSize(self.table_size)
        self.scroll:setDirection(ccui.ScrollViewDir.vertical)
        self.scroll:setAnchorPoint(display.CENTER_BOTTOM)
        self.scroll:setPosition(self.midWidth, 100)
        self.scroll:setBounceEnabled(true)
        self.panelNode:addChild(self.scroll)
    else
        self:createTableView()
    end
end

function PlayerRankView:setRankData(index)
    self.scroll:removeAllChildren()
    if PlazaManager.rankData ~= nil and PlazaManager.rankData[index] ~= nil and #PlazaManager.rankData[index] > 0 then
        local rankDatas = PlazaManager.rankData[index]
        local scroll_height = math.max(80 * #rankDatas, self.table_size.height)
        self.scroll:setInnerContainerSize(cc.size(self.winSize.width, scroll_height))
        for i, v in ipairs(rankDatas) do
            local posy = scroll_height - 40 - (i - 1) * 80
            local goodItemNode = self:createGoodeItem(v)
            goodItemNode:align(display.CENTER, self.midWidth, posy):addTo(self.scroll)
        end
    end
end

function PlayerRankView:updateMyRank(index)
    local str = LangCtrl:getLang().word227 .. " --"
    if PlazaManager.rankData ~= nil and PlazaManager.rankData[index] ~= nil and #PlazaManager.rankData[index] > 0 then
        local rankDatas = PlazaManager.rankData[index]
        for i, v in ipairs(rankDatas) do
            if v.dwGameID == globalUserInfo.dwGameID then
                str = LangCtrl:getLang().word227 .. v.index
            end
        end
    end
    self.myRankTxt:setString(str)
end

function PlayerRankView:createTableView()
    self.table_view = cc.TableView:create(self.table_size)
    self.table_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.table_view:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.table_view:setPosition(cc.p(0, 100))
    self.table_view:setDelegate()
    self.panelNode:addChild(self.table_view)
    self.table_view:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.table_view:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.table_view:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
end

function PlayerRankView:updateTableView(index)
    self.table_data = {}
    if PlazaManager.rankData ~= nil and PlazaManager.rankData[index] ~= nil and #PlazaManager.rankData[index] > 0 then
        self.table_data = PlazaManager.rankData[index]
    end

    self.table_view:reloadData()
end

function PlayerRankView:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeChildByName("ShopTableWidget")
    end

    local tData = self.table_data[idx + 1]
    local node = self:createGoodeItem(tData)
    node:setAnchorPoint(display.CENTER)
    node:setPosition(self.midWidth, 40)
    cell:addChild(node)
    return cell
end

function PlayerRankView:tableCellTouched(table, cell)
end

function PlayerRankView:cellSizeForTable(table, idx)
    return self.winSize.width, 80
end

function PlayerRankView:numberOfCellsInTableView()
    return #self.table_data
end

function PlayerRankView:createGoodeItem(data)
    local goodNode = cc.Node:create()
    goodNode:setContentSize(864, 80)
    goodNode:setName("ShopTableWidget")
    data.lScore = 888000000 -- 固定8.8亿
    -- 背景
    local bg_1 = ccui.ImageView:create("app/win/rank/img_lin.png")
    bg_1:align(display.CENTER, 432, 1):addTo(goodNode)

    if data.index == 1 then
        GameUtil.newSprite("app/win/rank/icon_goldph1.png", false):align(display.CENTER, 100, 40):addTo(goodNode)
    elseif data.index == 2 then
        GameUtil.newSprite("app/win/rank/icon_goldph2.png", false):align(display.CENTER, 100, 40):addTo(goodNode)
    elseif data.index == 3 then
        GameUtil.newSprite("app/win/rank/icon_goldph3.png", false):align(display.CENTER, 100, 40):addTo(goodNode)
    else
        ccui.TextBMFont:create(tostring(data.index), "app/win/rank/fnt_goldph.fnt"):align(display.CENTER, 100, 40):addTo(goodNode)
    end

    -- 星星动画
    if data.index >= 1 and data.index <= 3 then
        local sprite_anil = GameUtil.newSprite("app/win/rank/anil_rankitem/p_1.png", false):align(display.CENTER, 100, 40):addTo(goodNode)
        local animation_1 = cc.Animation:create()
        for i = 1, 8 do
            local frameName = string.format("app/win/rank/anil_rankitem/p_%d.png", i)
            animation_1:addSpriteFrameWithFile(frameName)
        end
        animation_1:setDelayPerUnit(8 / 60)
        animation_1:setRestoreOriginalFrame(true)

        local animate_1 = cc.Animate:create(animation_1)
        local animate_2 = cc.Sequence:create(animate_1)
        sprite_anil:runAction(cc.RepeatForever:create(animate_2))
    end

    local faceAddr = nil
    --[[
    local szFaceAddr = string.trim(data.szFaceAddr or '')
    local avatarurl = PlazaManager.urlGameConfig.shopAvatarUrl
    if avatarurl and string.len(avatarurl) > 0 then
        faceAddr = avatarurl .. szFaceAddr .. os.date('.jpg?time=%Y%m%d%H', os.time())
    end
    --]]
    -- 头像
    local img_head = GameUtil.createAvatar(faceAddr, 60, true, nil, nil, nil, nil)
    img_head:align(display.CENTER, 300, 40):addTo(goodNode)
    local headbgmask = GameUtil.newSprite("app/common/img_txbjk.png", false):align(display.CENTER, 30, 30):addTo(img_head)
    headbgmask:setScale(0.4)

    local txtColor = cc.c3b(0xf2, 0xdf, 0x4f)
    GameUtil.createLabel(tostring(data.szName), 24, txtColor, display.LEFT_CENTER, cc.p(350, 40), GameDefine.FontName, nil, nil, nil, true, false):addTo(goodNode)

    local goalStr = GameUtil.formatAsset(data.lScore)
    GameUtil.createLabel(goalStr, 24, txtColor, display.LEFT_CENTER, cc.p(690, 40), GameDefine.FontName, nil, nil, nil, true, false):addTo(goodNode)
    GameUtil.newSprite("app/common/gold_icon.png", false):align(display.CENTER, 650, 40):addTo(goodNode)

    local function onClickItem(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
        elseif eventtype == ccui.TouchEventType.ended then
            local pos1 = sender:getTouchBeganPosition()
            local pos2 = sender:getTouchEndPosition()
            local d = cc.pGetDistance(pos2, pos1)
            if d > 30 then
                return
            end

            local personData = {
                szNickName = data.szName,
                dwGameID = data.dwGameID,
                szWeixin = data.szWeixin,
                goalScole = data.lScore,
                headurl = nil -- data.szFaceAddr
            }
            local winui = UserInfoWinUI.new(false, personData)
            winui:setCenterOnScene()
            winui:addToOnCheckExist(display.getRunningScene())
        elseif eventtype == ccui.TouchEventType.canceled then
        end
    end

    local btnNode = ccui.Layout:create()
    btnNode:align(display.CENTER, 432, 40):addTo(goodNode)
    btnNode:setTouchEnabled(true)
    btnNode:setSwallowTouches(false)
    btnNode:addTouchEventListener(onClickItem)
    btnNode:setContentSize(864, 70)

    -- btnNode:setBackGroundColorType(1)
    -- btnNode:setBackGroundColor(cc.c3b(0xFF, 0xFF, 0))

    return goodNode
end

function PlayerRankView:openView()
    local view = PlayerRankView.new()
    view:setCenterOnScene()
    view:addToOnCheckExist(display.getRunningScene())
end

return PlayerRankView
