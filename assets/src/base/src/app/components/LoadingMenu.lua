-- zhke
local _M = {}

local touchpos = 0 -- 拖动位置
local touchposlift = 592
local gameListItem = {}
local gameListData = {}

local function createGameItem(data)
    if data == nil then
        return nil
    end

    local path = ""
    local isUpdateStatus = PlazaManager.checkGameVersion(data.wKindID)
    path = string.format("app/common/gameIamge/%s.png", data.wKindID)
    local item = cc.Sprite:create(path)
    if item == nil then
        item = cc.Sprite:create("app/common/gameIamge/default.png")
    end

    local icon_update = cc.Sprite:create("app/common/down_icon_2.png")
    icon_update:setName("icon_update")
    icon_update:setPosition(170, 235)
    item:addChild(icon_update)
    icon_update:setVisible(false)

    local icon_updating = cc.Sprite:create("app/common/down_icon_4.png")
    icon_updating:setName("icon_updating")
    icon_updating:setPosition(110, 250)
    item:addChild(icon_updating)
    icon_updating:setVisible(false)

    if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        icon_update:setVisible(true)
    end

    local gameData = data
    local bSelected = false
    local bMoveScale = false

    function item:getData()
        local len = #gameListItem
        for i = 1, len do
            if gameListItem[i]:getScale() == 1 then
                return gameListData[i]
            end
        end
    end

    function item:setSelected(isSelected)
        bSelected = isSelected
    end

    function item:getSelected()
        return bSelected
    end

    function item:setMoveScale(value)
        bMoveScale = value
    end

    function item:getMoveScale()
        return bMoveScale
    end

    return item
end

function _M.Loadingmenu(callback)
    local size = cc.size(750, 400)
    local node = display.newNode()
    node:setContentSize(size)
    node:setAnchorPoint(display.CENTER)
    local xpos1 = 0
    local xpos2 = 0
    gameListItem = {}
    gameListData = {}

    function node:setData(data, kindid)
        -- 清除数据
        self:removeAllChildren()
        gameListItem = {}
        -- 赋值数据
        gameListData = data

        if gameListData == nil then
            return
        end
        local len = #gameListData
        if len == 0 then
            return
        end
        for i = 1, len do
            local itemSprite = createGameItem(gameListData[i])
            if itemSprite ~= nil then
                itemSprite:setPosition(405 + (i - 1) * 290, size.height / 2)
                itemSprite:setScale(0.7)
                gameListItem[i] = itemSprite
                gameListItem[i]:setLocalZOrder(999)
                node:addChild(itemSprite, 100)
            end
        end
        -- 默认第一个为选中状态
        local defaultkindid = 1
        for i = 1, len do
            if gameListData[i].wKindID == kindid then
                defaultkindid = i
            end
        end

        for i = 1, len do
            if i == defaultkindid then
                gameListItem[i]:setScale(1)
                gameListItem[i]:setSelected(true)
                gameListItem[i]:setLocalZOrder(1000)
                gameListItem[i]:setPosition(405, size.height / 2)
            else
                gameListItem[i]:setScale(0.7)
                gameListItem[i]:setLocalZOrder(999)
                gameListItem[i]:setSelected(false)
            end
            for j = 1, len do
                gameListItem[j]:setPosition(405 + (j - defaultkindid) * 290, size.height / 2)
            end
        end

        if defaultkindid == 1 and len > 2 then
            local add_data_1 = gameListData[len]
            table.insert(gameListData, 1, add_data_1)
            table.remove(gameListData, len + 1)
            node:setData(gameListData, gameListData[2].wKindID)
        elseif defaultkindid == len and len > 2 then
            local add_data = gameListData[1]
            table.insert(gameListData, add_data)
            table.remove(gameListData, 1)
            node:setData(gameListData, gameListData[#gameListData - 1].wKindID)
        end

    end

    function node:updateItemSprite()
        local len = #gameListData
        local path = ""
        for i = 1, len do
            local isUpdateStatus = PlazaManager.checkGameVersion(gameListData[i].wKindID)
            if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
                gameListItem[i]:getChildByName("icon_update"):setVisible(true)
            else
                gameListItem[i]:getChildByName("icon_update"):setVisible(false)
            end
        end
    end

    function node:getSelectItem()
        for key, var in pairs(gameListItem) do
            if var:getSelected() == true then
                return var
            end
        end
        return nil
    end

    local function IsLocationInNode(node, loc)
        local pos = node:convertToNodeSpace(loc)
        local s = node:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        return cc.rectContainsPoint(rect, pos)
    end

    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local location = touch:getLocation()
        xpos1 = location.x
        xpos2 = location.x

        if IsLocationInNode(target, location) then
            for i = 1, #gameListItem do
                local beginpos = gameListItem[i]:getPositionX()
                if beginpos > 325 and beginpos < 498 then
                    gameListItem[i]:setMoveScale(true)
                else
                    gameListItem[i]:setMoveScale(false)
                end
            end
        else
            return
        end

        return true
    end

    local function onTouchMoved(touch, event)
        if touchpos >= 498 then
            return
        end

        if touchposlift <= 325 then
            return
        end

        local target = event:getCurrentTarget()
        local location = touch:getLocation()

        if IsLocationInNode(target, location) then
            local disXpos1 = location.x - xpos2
            local disXpos2 = math.abs(disXpos1)
            if disXpos2 > 325 then
                return
            end

            local disXpos3 = location.x - xpos1
            xpos1 = location.x
            local len = #gameListItem

            for i = 1, len do
                local itemX = gameListItem[i]:getPositionX()
                gameListItem[i]:setPositionX(itemX + disXpos3)

                for i = 1, len do
                    local pos = gameListItem[i]:getPositionX()
                    if pos > 290 and pos <= 531 then
                        gameListItem[i]:setSelected(true)
                    elseif pos <= 166 or pos >= 605 then
                        gameListItem[i]:setSelected(false)
                    end
                end

                if disXpos2 > 5 and gameListItem[i].getSelected() == true and gameListItem[i]:getMoveScale() == false then
                    local scal = math.abs(disXpos1 / 1000)
                    if scal > 0.7 then
                        scal = 0.7
                    end
                    gameListItem[i]:setScale(0.7 + scal)
                    gameListItem[i]:setLocalZOrder(1000)
                else
                    if gameListItem[i].getSelected() == true then
                        local scal = math.abs(disXpos1 / 1000)
                        if scal > 0.7 then
                            scal = 0.7
                        end

                        local scalmuch = gameListItem[i]:getScale() - scal
                        if scalmuch <= 0.7 then
                            scalmuch = 0.7
                        end
                        gameListItem[i]:setScale(scalmuch)
                        gameListItem[i]:setLocalZOrder(999)
                    else
                        gameListItem[i]:setScale(0.7)
                        gameListItem[i]:setLocalZOrder(999)
                    end
                end
            end

            if #gameListItem > 0 then
                touchpos = gameListItem[1]:getPositionX()
                touchposlift = gameListItem[len]:getPositionX()
            end
        else
            return
        end
        return true
    end

    local function onTouchEnded(touch, event)

        local location = touch:getLocation()
        local endPos = location.x

        local numberge = 0

        local len = #gameListItem
        local posid = 1
        local salspri
        for i = 1, len do
            numberge = numberge + 1
            if gameListItem[i].getSelected() == true then
                gameListItem[i]:setScale(1)
                gameListItem[i]:setLocalZOrder(1000)
                gameListItem[i]:setPosition(405, size.height / 2)
                salspri = gameListItem[i]:getPositionX()
                posid = i
            else
                gameListItem[i]:setScale(0.7)
                gameListItem[i]:setLocalZOrder(999)
            end

            for j = 1, len do
                gameListItem[j]:setPosition(405 + (j - posid) * 290, size.height / 2)
            end
        end

        if touchpos >= 498 then
            for i = 1, len do
                gameListItem[i]:setPosition(405 + (i - 1) * 290, size.height / 2)
                if i == 1 then
                    gameListItem[i]:setScale(1)
                    gameListItem[i]:setLocalZOrder(1000)
                end
            end
            touchpos = 0
        end
        if touchposlift <= 325 then
            for i = 1, len do
                gameListItem[i]:setPosition(405 + (i - numberge) * 290, size.height / 2)
                if i == numberge then
                    gameListItem[i]:setScale(1)
                    gameListItem[i]:setLocalZOrder(1000)
                else
                    gameListItem[i]:setScale(0.7)
                    gameListItem[i]:setLocalZOrder(999)
                end
            end
            touchposlift = 592
        end

        local pos = {}
        for i = 1, len do
            pos[i] = gameListItem[i]:getPositionX()
            if pos[i] < 183 or pos[i] > 562 then
                gameListItem[i]:setScale(0.7)
                gameListItem[i]:setLocalZOrder(999)
            else
                -- 滑动选中
            end
        end
        local selinder = 1

        local function touchcallback()
            for i = 1, len do
                if selinder ~= i then
                    gameListItem[i]:setSelected(false)
                else
                    gameListItem[i]:setSelected(true)
                end

            end

            for i = 1, len do
                if gameListItem[i].getSelected() == true then
                    gameListItem[i]:setScale(1)
                    gameListItem[i]:setLocalZOrder(1000)
                    gameListItem[i]:setPosition(405, size.height / 2)
                    salspri = gameListItem[i]:getPositionX()
                    posid = i
                else
                    gameListItem[i]:setScale(0.7)
                    gameListItem[i]:setLocalZOrder(999)
                end

                for j = 1, len do
                    gameListItem[j]:setPosition(405 + (j - posid) * 290, size.height / 2)
                end
            end
        end

        -- 点击选中
        local istouchpoint = math.abs(location.x - xpos2)
        if istouchpoint < 10 then
            for i = 1, #gameListItem do
                if gameListItem[i].getSelected() == true and location.x > 249 and location.x < 561 then
                    if callback then
                        callback(gameListData[i])
                    end
                end
                if gameListItem[i].getSelected() == false and pos[i] - 134 < location.x and pos[i] + 55 > location.x and pos[i] > 570 and pos[i] < 750 then

                    selinder = i
                    touchcallback()
                end

                if gameListItem[i].getSelected() == false and 0 < location.x and pos[i] + 130 > location.x and pos[i] > 0 and pos[i] < 249 then
                    selinder = i
                    touchcallback()
                end

            end

        end

        local lastid = 0
        for i = 1, #gameListItem do
            if gameListItem[i]:getScale() == 1 then
                lastid = i
            end
        end

        if len > 2 then
            if lastid == len then

                local add_data = gameListData[1]
                table.insert(gameListData, add_data)
                table.remove(gameListData, 1)
                node:setData(gameListData, gameListData[#gameListData - 1].wKindID)
            elseif lastid == 1 then

                local add_data_1 = gameListData[len]
                table.insert(gameListData, 1, add_data_1)
                table.remove(gameListData, len + 1)
                node:setData(gameListData, gameListData[2].wKindID)
            end
        end

        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)

    return node
end

return _M
