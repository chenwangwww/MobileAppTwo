-- Author : admin
-- Date   : 2017/9/29
-- 此文件由[BabeLua]插件自动生成
local GameListPageView = class("GameListPageView", function()
    return cc.Node:create()
end)

local downPos = {cc.p(display.cx - 305, display.cy + 203), cc.p(display.cx - 55, display.cy + 203), cc.p(display.cx + 175, display.cy + 203), cc.p(display.cx - 305, display.cy - 97),
                 cc.p(display.cx - 55, display.cy - 97), cc.p(display.cx + 175, display.cy - 97)}

function GameListPageView:ctor(gameDataList, wKindID, downLoadFunction, createRoomFunction, gameHallType)
    self.gameDataList = gameDataList
    self.ChooseGameKindID = 0
    self.downLoadFunction = downLoadFunction
    self.createRoomFunction = createRoomFunction
    self:setContentSize(750, 630)

    if gameHallType == nil then
        self.gameHallType = GameDefine.GAME_TYPE.GAME_GENRE_ROOM -- 约战房
    else
        self.gameHallType = gameHallType
    end
    local iconPanelList = self:onCreatePageViewIcon(1, 1)
    iconPanelList:align(display.CENTER_BOTTOM, 375, 0)
    self:addChild(iconPanelList, 10)
    self.iconPanelList = iconPanelList
    iconPanelList:setChooseIcon(1)

    local gamePageView = ccui.PageView:create()
    gamePageView:setTouchEnabled(true)
    gamePageView:setContentSize(750, 610)
    gamePageView:setPosition(0, 0)
    gamePageView:setAnchorPoint(display.LEFT_BOTTOM)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            self.iconPanelList:setChooseIcon(sender:getCurPageIndex() + 1)
        end
    end
    gamePageView:addEventListener(pageViewEvent)
    self:addChild(gamePageView)
    self.gamePageView = gamePageView

    self:setData(gameDataList, wKindID)
end

--------------------创建-----------------------------------------------------
function GameListPageView:onCreatePageViewIcon(count, curIndex)
    local iconPanel = ccui.Layout:create()

    function iconPanel:setChooseIcon(currIndex)
        local iconList = self:getChildren()
        for i = 1, #iconList do
            if iconList[i]:getTag() == currIndex then
                iconList[i]:loadTexture("app/hall/cardRoom/icon_1.png")
            else
                iconList[i]:loadTexture("app/hall/cardRoom/icon_2.png")
            end
        end
    end

    function iconPanel:updataView(count, curIndex)
        local totalwidth = 30 * (count - 1) + 20
        local heigth = 20
        self:removeAllChildren()
        self:setContentSize(totalwidth, heigth)
        for i = 1, count do
            local posX = 10 + 30 * (i - 1)
            local image_icon = ccui.ImageView:create("app/hall/cardRoom/icon_2.png")
            image_icon:setAnchorPoint(display.CENTER)
            image_icon:setPosition(posX, 10)
            image_icon:setTag(i)
            self:addChild(image_icon)

            if i == curIndex then
                image_icon:loadTexture("app/hall/cardRoom/icon_1.png")
            end
        end
    end

    iconPanel:updataView(count, curIndex)
    return iconPanel
end

function GameListPageView:createGameItem(gameData)
    if gameData == nil then
        return nil
    end

    local viewSize = cc.size(210, 265)
    local itenLayout = ccui.Layout:create()
    itenLayout:setContentSize(viewSize)

    local path = string.format("app/common/gameIamge/%s.png", gameData.wKindID)
    if cc.FileUtils:getInstance():isFileExist(path) == false then
        path = string.format("app/common/gameIamge/%s.png", "default")
    end
    local buttonItem = ccui.Button:create(path, path, path)
    local buttonSize = buttonItem:getContentSize()
    buttonItem:setScale(viewSize.width / buttonSize.width, viewSize.width / buttonSize.width)
    buttonItem:setAnchorPoint(display.CENTER)
    buttonItem:setPosition(viewSize.width / 2, viewSize.height / 2)
    buttonItem.gameData = gameData
    buttonItem:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            local isUpdateStatus = PlazaManager.checkGameVersion(uiwidget.gameData.wKindID)
            if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
                uiwidget:getParent():getChildByName("icon_update"):setVisible(false)
                uiwidget:getParent():getChildByName("icon_updating"):setVisible(true)
                local seqNo = uiwidget:getParent():getTag()
                self.downLoadFunction(uiwidget.gameData, downPos[seqNo]) -- 下载资源
            else
                self.createRoomFunction(uiwidget.gameData.wKindID)
            end
        end
    end)
    itenLayout:addChild(buttonItem)
    itenLayout.buttonItem = buttonItem

    local icon_update = cc.Sprite:create("app/common/down_icon_2.png")
    icon_update:setName("icon_update")
    icon_update:setPosition(170, 235)
    itenLayout:addChild(icon_update)
    icon_update:setVisible(false)

    local icon_updating = cc.Sprite:create("app/common/down_icon_4.png")
    icon_updating:setName("icon_updating")
    icon_updating:setPosition(110, 250)
    itenLayout:addChild(icon_updating)
    icon_updating:setVisible(false)

    if self.gameHallType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
        local icon_goalhall = cc.Sprite:create("app/hall/goalHall/icon_1.png")
        icon_goalhall:setPosition(190, 25)
        itenLayout:addChild(icon_goalhall)
    elseif self.gameHallType == GameDefine.GAME_TYPE.GAME_GENRE_VIDEO then
        local icon_tvhall = cc.Sprite:create("app/hall/tvhall/icon_1.png")
        icon_tvhall:setPosition(190, 25)
        itenLayout:addChild(icon_tvhall)
    end

    local isUpdateStatus = PlazaManager.checkGameVersion(gameData.wKindID)
    if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        icon_update:setVisible(true)
    end

    itenLayout.gameData = gameData

    return itenLayout
end

----------------------修改-------------------------------------------------------
function GameListPageView:createPageView()
    self.gamePageView:removeAllPages()

    local totalGameCount = #self.gameDataList
    local totalPageCount = math.floor((totalGameCount - 1) / 6) + 1

    for i = 1, totalPageCount do
        local pageView = ccui.Layout:create()
        pageView:setContentSize(750, 600)

        for j = 1, 6 do
            if ((i - 1) * 6 + j) <= totalGameCount then
                local x = 0
                local y = 0
                if j <= 3 then
                    y = 465
                else
                    y = 170
                end

                x = (j - 1) % 3 * 240 + 130

                local itemNode = self:createGameItem(self.gameDataList[(i - 1) * 6 + j])
                if itemNode ~= nil then
                    itemNode:setAnchorPoint(display.CENTER)
                    itemNode:setPosition(x, y)
                    itemNode:setTag(j)
                    pageView:addChild(itemNode)
                end
            else
                break
            end
        end
        self.gamePageView:addPage(pageView)

    end

    self.iconPanelList:updataView(totalPageCount, 1)
end

function GameListPageView:updateItemSprite(dwKindID)
    local pageList = self.gamePageView:getPages()
    for i = 1, #pageList do
        local gameItemList = pageList[i]:getChildren()
        for j = 1, #gameItemList do
            local wKindID = gameItemList[j].gameData.wKindID
            local isUpdateStatus = PlazaManager.checkGameVersion(wKindID)
            if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
                gameItemList[j]:getChildByName("icon_update"):setVisible(true)
                gameItemList[j]:getChildByName("icon_updating"):setVisible(false)
            else
                gameItemList[j]:getChildByName("icon_update"):setVisible(false)
                gameItemList[j]:getChildByName("icon_updating"):setVisible(false)
            end
        end
    end
end

function GameListPageView:setChooseGame(wKindID, ismove)
    local pageList = self.gamePageView:getPages()
    for i = 1, #pageList do
        local gameItemList = pageList[i]:getChildren()
        for j = 1, #gameItemList do
            if gameItemList[j].gameData.wKindID == wKindID then
                local indexPage = i
                self.ChooseGameKindID = wKindID
                self.iconPanelList:setChooseIcon(indexPage)
                if ismove == false then
                    self.gamePageView:setCurPageIndex(indexPage - 1)
                end
                return
            end
        end
    end

end

function GameListPageView:setData(gameDataList, wKindID)
    self.gameDataList = gameDataList
    self:createPageView()
    self:setChooseGame(wKindID, false)

    local gamePageItem = self.gamePageView:getPage(0)
    if self.ChooseGameKindID == 0 and gamePageItem ~= nil then
        self.iconPanelList:setChooseIcon(1)
        self.gamePageView:setCurPageIndex(0)
    end
end

return GameListPageView
