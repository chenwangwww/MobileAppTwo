-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local HallNodeRoomList = class("HallNodeRoomList", function()
    return display.newNode()
end)
local Layout = require "app.components.Layout"
local ScrollView = require "app.components.ScrollView"

function HallNodeRoomList:ctor(args)
    self.data = args
    self.size = cc.size(1334, 520)
    self:setContentSize(self.size)
    self:enableNodeEvents()
    self.tConfig = require "app.views.hall.GameRoomConfig"

    if self.data ~= nil and self.data.dwKindID ~= nil and type(self.data.dwKindID) == "number" then
        self:initView()
    end
end

function HallNodeRoomList:onEnter()
    self.eventData = {}
    self.eventData.onRequestServerListFinish = function()
        self:onRequestServerListFinish()
    end -- 金币变化消息
    game.registerEvent(GameDefine.RequestServerListFinish, self.eventData.onRequestServerListFinish)

    self.refreshTime = os.time()
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if (os.difftime(os.time(), self.refreshTime) <= 30) then
            return
        end
        self.refreshTime = os.time()
        if self.data ~= nil and self.data.dwKindID ~= nil and type(self.data.dwKindID) == "number" then
            PlazaManager.getRefreshModule().onRequestServerListByKindID(self.data.dwKindID)
        end
    end, 10, false)

    local scheduleScriptHandler = nil
    local function onQuestRefreshServerList()
        if scheduleScriptHandler ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleScriptHandler)
        end
        if self.data ~= nil and self.data.dwKindID ~= nil and type(self.data.dwKindID) == "number" then
            -- 请求刷新
            PlazaManager.getRefreshModule().onRequestServerListByKindID(self.data.dwKindID)
        end
    end
    scheduleScriptHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onQuestRefreshServerList, 1, false)
end

function HallNodeRoomList:onExit()
    game.unregisterEvent(GameDefine.RequestServerListFinish, self.eventData.onRequestServerListFinish)

    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
end

function HallNodeRoomList:onClearUp()
    self:disableNodeEvents()
end

--------------------逻辑和界面函数----------------------------------------------------------
function HallNodeRoomList:getGameRoomList()
    local serverList = ServerListData.getGameServerByKindID(self.data.dwKindID)

    local serverDataList = {}
    serverDataList[1] = {
        name = LangCtrl:getLang().word271,
        nodeType = GameDefine.GameRoomType.FirstType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[2] = {
        name = LangCtrl:getLang().word272,
        nodeType = GameDefine.GameRoomType.MidType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[3] = {
        name = LangCtrl:getLang().word273,
        nodeType = GameDefine.GameRoomType.HeightType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[4] = {
        name = LangCtrl:getLang().word274,
        nodeType = GameDefine.GameRoomType.TopType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }

    if GameDefine.bIsTestUI then
        for kk, vv in pairs(serverDataList) do
            vv.wKindID = self.data.dwKindID
            vv.lMinEnterScore = math.random(0, 9999)
            vv.lCellScore = math.random(0, 9999)
            vv.dwOnLineCount = math.random(0, 9999)
            vv.dwFullCount = math.random(0, 9999)
            vv.serverList = {{
                wServerType = GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER,
                dwOnLineCount = math.random(0, 9999),
                dwFullCount = math.random(0, 9999)
                -- readAndUpdataGameServer
            }}
        end
    end

    for i = 1, #serverList do
        if serverList[i].wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD or serverList[i].wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
            local nodeType = PlazaManager.getGameRoomType(serverList[i].wNodeID)
            local seqNo = 0
            if nodeType == GameDefine.GameRoomType.FirstType then
                seqNo = 1
            elseif nodeType == GameDefine.GameRoomType.MidType then
                seqNo = 2
            elseif nodeType == GameDefine.GameRoomType.HeightType then
                seqNo = 3
            elseif nodeType == GameDefine.GameRoomType.TopType then
                seqNo = 4
            end

            if seqNo >= 1 and seqNo <= 4 then
                serverDataList[seqNo].wKindID = serverList[i].wKindID
                serverDataList[seqNo].lMinEnterScore = serverList[i].lMinEnterScore
                serverDataList[seqNo].lCellScore = serverList[i].lCellScore
                serverDataList[seqNo].dwOnLineCount = serverDataList[seqNo].dwOnLineCount + serverList[i].dwOnLineCount
                serverDataList[seqNo].dwFullCount = serverDataList[seqNo].dwFullCount + serverList[i].dwFullCount
                table.insert(serverDataList[seqNo].serverList, serverList[i])
            end
        end
    end

    -- 除去0个的和随机选取服务器
    for i = 4, 1, -1 do
        if #serverDataList[i].serverList == 0 then
            table.remove(serverDataList, i)
        else
            serverDataList[i].serverDate = serverDataList[i].serverList[1]
        end
    end

    local function sortByNodeType(item1, item2)
        if item1.nodeType < item2.nodeType then
            return true
        else
            return false
        end
    end

    table.sort(serverDataList, sortByNodeType)

    return serverDataList
end

function HallNodeRoomList:initView()
    self:removeAllChildren()

    local roomList = {}
    local gameRoomList = nil
    if PlazaManager.isCheck == true then
        gameRoomList = self:getCheckGameRoomList()
    else
        gameRoomList = self:getGameRoomList()
    end

    for key, value in ipairs(gameRoomList) do
        local item = self:createItem(value)
        if item ~= nil then
            table.insert(roomList, item)
        end
    end

    if #roomList > 0 then
        local isVertical = false
        local node_width = roomList[1]:getContentSize().width
        if node_width * 4 > 1334 then
            isVertical = true
        end

        local colNum = 2
        if isVertical == false then
            colNum = #roomList
        end
        local offsets = {
            row = 30,
            col = 100
        } -- row:行间距 col列间距
        if isVertical == false then
            offsets = {
                row = 10,
                col = 40
            } -- 横版是的间距
        end

        local pads = {
            left = 10,
            right = 0,
            top = 0,
            bottom = 0
        } -- 列表外间距
        if isVertical == false then
            pads = {
                left = 80,
                right = 0,
                top = 0,
                bottom = 0
            }
        end

        if roomList[1].scollView_offsets ~= nil then
            offsets = roomList[1].scollView_offsets
        end

        if roomList[1].scollView_pads ~= nil then
            pads = roomList[1].scollView_pads
        end

        local layout = Layout.createTBox("row", nil, colNum, roomList, offsets, pads)

        local layout_node = display.newNode()

        if isVertical == false then
            layout_node:setContentSize(layout:getContentSize().width, self.size.height)
            layout:setPosition(0, (layout_node:getContentSize().height - layout:getContentSize().height) / 2)
            layout_node:addChild(layout)
        else
            layout_node:setContentSize(self.size.width, layout:getContentSize().height)
            local layout_x = (layout_node:getContentSize().width - layout:getContentSize().width) / 2
            if #roomList == 1 then
                layout_x = 190
            end
            layout:setPosition(layout_x, 0)
            layout_node:addChild(layout)
        end

        local svSize = cc.size(1334, 520)
        local scrollView = cc.ScrollView:create()

        scrollView:setViewSize(svSize)
        scrollView:setContainer(layout_node)
        if isVertical == false then
            scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
            scrollView:setContentOffset(display.LEFT_BOTTOM)
        else
            scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
            scrollView:setContentOffset(scrollView:minContainerOffset())
        end

        if #roomList > 4 then
            scrollView:setTouchEnabled(true)
        else
            scrollView:setTouchEnabled(false)
        end

        scrollView:addTo(self)
    end
end

function HallNodeRoomList:getRandomServer(serverData)
    print("服务器类型：" .. tostring(serverData.name))
    print("服务器数量：" .. tostring(serverData.serverList))
    local randomSeqNo = {}
    -- 优先选择有人数比例在0.75以下的
    for j = 1, #serverData.serverList do
        if serverData.serverList[j].dwOnLineCount / serverData.serverList[j].dwFullCount < 0.75 then
            table.insert(randomSeqNo, j)
        end
    end
    -- 如果没有0.75以下的服务器，则从所有服务器中随机选择
    if #randomSeqNo == 0 then
        for j = 1, #serverData.serverList do
            table.insert(randomSeqNo, j)
        end
    end
    print("随机选择时服务器数量：" .. tostring(#randomSeqNo))
    local chooseSeqNo = 1
    if #randomSeqNo > 1 then
        chooseSeqNo = math.random(1, #randomSeqNo)
    end
    local chooseServerSeqNo = randomSeqNo[chooseSeqNo]
    serverData.serverDate = serverData.serverList[chooseServerSeqNo]
    print("随机选中的服务器名称：" .. tostring(serverData.serverDate.szServerName))

    return serverData
end

function HallNodeRoomList:createItem(roomItemData)
    local gamenode = nil

    local specilChk = false
    if self.tConfig[roomItemData.wKindID] ~= nil then
        specilChk = true
        gamenode = self:createConfigItem(roomItemData, self.tConfig[roomItemData.wKindID])

        if gamenode == nil then
            specilChk = false
        end
    end

    if specilChk == false then
        local function onClickbtnNode(sender, eventtype)
            if eventtype == ccui.TouchEventType.began then
                sender:runAction(cc.ScaleTo:create(0.15, 0.85))
                PlazaManager.playClickEffect()
            elseif eventtype == ccui.TouchEventType.ended or eventtype == ccui.TouchEventType.canceled then
                if GameDefine.bIsLocalTest then
                    self:doGameTest(sender.roomItemData.wKindID)
                else
                    if self.data ~= nil and self.data.callback ~= nil then
                        if PlazaManager.isCheck == false then
                            self:getRandomServer(sender.roomItemData)
                        end
                        self.data.callback(sender.roomItemData.serverDate)
                    end
                end
                sender:runAction(cc.ScaleTo:create(0.15, 1))
            end
        end

        gamenode = ccui.Layout:create()
        gamenode:setTouchEnabled(true)
        gamenode:addTouchEventListener(onClickbtnNode)
        gamenode:setAnchorPoint(display.CENTER)
        gamenode.roomItemData = roomItemData
        gamenode:setContentSize(407, 228)

        local nodeType = roomItemData.nodeType

        local roomBgPath = "app/hall/gamelist/gameroom/comroom/img_shz_1.png"
        local roomTypePath = "app/hall/gamelist/gameroom/comroom/img_shz_wz1.png"
        local lblBgPath = "app/hall/gamelist/gameroom/comroom/img_moren_1.png"

        if nodeType == GameDefine.GameRoomType.FirstType then
            roomBgPath = "app/hall/gamelist/gameroom/comroom/img_shz_1.png"
            roomTypePath = "app/hall/gamelist/gameroom/comroom/img_shz_wz1.png"
            lblBgPath = "app/hall/gamelist/gameroom/comroom/img_moren_1.png"
        elseif nodeType == GameDefine.GameRoomType.MidType then
            roomBgPath = "app/hall/gamelist/gameroom/comroom/img_shz_2.png"
            roomTypePath = "app/hall/gamelist/gameroom/comroom/img_shz_wz2.png"
            lblBgPath = "app/hall/gamelist/gameroom/comroom/img_moren_2.png"
        elseif nodeType == GameDefine.GameRoomType.HeightType then
            roomBgPath = "app/hall/gamelist/gameroom/comroom/img_shz_3.png"
            roomTypePath = "app/hall/gamelist/gameroom/comroom/img_shz_wz3.png"
            lblBgPath = "app/hall/gamelist/gameroom/comroom/img_moren_3.png"
        elseif nodeType == GameDefine.GameRoomType.TopType then
            roomBgPath = "app/hall/gamelist/gameroom/comroom/img_shz_4.png"
            roomTypePath = "app/hall/gamelist/gameroom/comroom/img_shz_wz4.png"
            lblBgPath = "app/hall/gamelist/gameroom/comroom/img_moren_4.png"
        end

        GameUtil.newSprite(roomBgPath, false):align(display.CENTER, 204, 114):addTo(gamenode)
        GameUtil.newSprite(roomTypePath, false):align(display.CENTER, 204, 150):addTo(gamenode)

        local lblBg = ccui.Scale9Sprite:create(lblBgPath)
        lblBg:setCapInsets(cc.rect(20, 15, 42 - 40, 32 - 15 * 2))
        lblBg:setContentSize(395, 32)
        lblBg:align(display.CENTER, 204, 30):addTo(gamenode)

        local str_1 = LangCtrl:getLang().word275
        local num_1 = roomItemData.dwOnLineCount / roomItemData.dwFullCount
        if num_1 >= 0.75 then
            str_1 = LangCtrl:getLang().word276
        elseif (num_1 >= 0.5 and num_1 < 0.75) or (roomItemData.dwOnLineCount >= 200 and num_1 < 0.75) then
            str_1 = LangCtrl:getLang().word277
        elseif (num_1 >= 0.25 and num_1 < 0.5) or (roomItemData.dwOnLineCount >= 100 and roomItemData.dwOnLineCount < 200 and num_1 < 0.5) then
            str_1 = LangCtrl:getLang().word278
        end

        GameUtil.newSprite("app/hall/gamelist/gameroom/icon_cdt_rs.png", false):align(display.CENTER, 30, 15):addTo(lblBg)
        str_1 = tostring(roomItemData.dwOnLineCount) .. str_1
        GameUtil.createLabel(str_1, 24, cc.WHITE, display.LEFT_CENTER, cc.p(50, 15)):addTo(lblBg)

        local str_2 = GameUtil.formatAsset(roomItemData.lMinEnterScore) .. LangCtrl:getLang().word279
        local lbl_enterScore = GameUtil.createLabel(str_2, 24, cc.WHITE, display.RIGHT_CENTER, cc.p(375, 15)):addTo(lblBg)
        GameUtil.newSprite("app/hall/gamelist/gameroom/icon_cdt_jb.png", false):align(display.RIGHT_CENTER, 375 - lbl_enterScore:getContentSize().width - 5, 15):addTo(lblBg)
    end

    return gamenode
end

function HallNodeRoomList:doGameTest(wKindID)
    print("=========LocalTest  doGameTest========", wKindID)
    do
        PlazaManager.doEnterGame(wKindID)
        return
    end

    if wKindID == 1012 then
        GameUtil.changeRootView_V(true)
        require("game/mjhl/src/MJHLAPP").create():run()
    elseif wKindID == 1011 then -- 跳高高
        require("game/tgg/src/TGGAPP").create():run()
    elseif wKindID == 1010 then -- 秘鲁传说
        require("game/mlcs/src/MLCSAPP").create():run()
    elseif wKindID == 205 then -- 秘鲁传说
        require("game/happyfruit/src/HAPPYFRUITAPP").create():run()
    elseif wKindID == 1003 then -- 黄金战车
        require("game/zslc/src/ZSLCAPP").create():run()
    elseif wKindID == 33 then -- 李逵劈鱼
        require("game/fishlk/src/FISHLKAPP").create():run()
    elseif wKindID == 203 then -- 水浒传
        require("game/shz/src/SHZAPP").create():run()
    elseif wKindID == 204 then -- 九连夺宝
        require("game/jldb/src/JLDBAPP").create():run()
    elseif wKindID == 1002 then -- 连环夺宝
        require("game/lhdb/src/LHDBAPP").create():run()
    elseif wKindID == 1005 then -- 财神到
        require("game/csd/src/CSDAPP").create():run()
    elseif wKindID == 1008 then -- 僵尸风云
        require("game/jsfy/src/JSFYAPP").create():run()
    elseif wKindID == 1009 then -- 金瓶梅
        require("game/jpm/src/JPMAPP").create():run()
    end
end

function HallNodeRoomList:createConfigItem(roomItemData, configData)
    local function onClickbtnNode(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            sender:runAction(cc.ScaleTo:create(0.15, 0.85))
            PlazaManager.playClickEffect()
        elseif eventtype == ccui.TouchEventType.ended or eventtype == ccui.TouchEventType.canceled then
            if GameDefine.bIsLocalTest then
                self:doGameTest(sender.roomItemData.wKindID)
            else
                if self.data ~= nil and self.data.callback ~= nil then
                    if PlazaManager.isCheck == false then
                        self:getRandomServer(sender.roomItemData)
                    end
                    self.data.callback(sender.roomItemData.serverDate)
                end
            end

            sender:runAction(cc.ScaleTo:create(0.15, 1))
        end
    end

    local gamenode = ccui.Layout:create()
    gamenode:setTouchEnabled(true)
    gamenode:addTouchEventListener(onClickbtnNode)
    gamenode:setAnchorPoint(display.CENTER)
    gamenode.roomItemData = roomItemData
    gamenode:setContentSize(configData.size)
    gamenode.scollView_offsets = configData.scollView_offsets
    gamenode.scollView_pads = configData.scollView_pads

    local seqNo = 1
    local nodeType = roomItemData.nodeType
    if nodeType == GameDefine.GameRoomType.FirstType then
        seqNo = 1
    elseif nodeType == GameDefine.GameRoomType.MidType then
        seqNo = 2
    elseif nodeType == GameDefine.GameRoomType.HeightType then
        seqNo = 3
    elseif nodeType == GameDefine.GameRoomType.TopType then
        seqNo = 4
    end

    if configData.img_bg ~= nil then
        local roomBgPath = configData.img_bg.path .. seqNo
        GameUtil.newSprite("app/hall/gamelist/gameroom/" .. roomBgPath, false):align(display.CENTER, configData.size.width / 2, configData.size.height / 2):addTo(gamenode)
    end

    if configData.anil_bg ~= nil then
        local jsonPath = configData.anil_bg.jsonPath
        local animalName = configData.anil_bg.aniName
        local anilPlayName = configData.anil_bg.playName .. seqNo
        local anilPos = configData.anil_bg.pos

        -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonPath..".png",jsonPath..".plist",jsonPath..".ExportJson")
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonPath)
        local armature = ccs.Armature:create(animalName) -- 创建动画对象
        armature:getAnimation():play(anilPlayName) -- 设置动画对象执行的动画名称
        -- armature:setScale(0.8)
        armature:align(display.CENTER, anilPos.x, anilPos.y):addTo(gamenode)

        local ttfSize = 30
        if LangCtrl:isCN() then
            ttfSize = 36
        end
        local content = cc.Label:createWithTTF(roomItemData.name, "app/fonts/fzcy.ttf", ttfSize)
        content:setColor(cc.c3b(237, 230, 175))
        -- content:enableOutline(cc.c4b(132, 77, 24, 255), 2)
        content:enableOutline(cc.c4b(94, 26, 5, 255), 2)
        local titleX = configData.titleX or configData.size.width / 2
        local titleY = configData.titleY or configData.size.height - 20
        content:align(display.CENTER, titleX, titleY):addTo(gamenode)
    end

    if configData.img_word ~= nil then
        local roomTypePath = configData.img_word.path .. seqNo
        GameUtil.newSprite("app/hall/gamelist/gameroom/" .. roomTypePath, false):align(display.CENTER, configData.img_word.pos.x, configData.img_word.pos.y):addTo(gamenode)
    end

    if configData.node_onLineCount ~= nil then
        local lblBgPath = string.format("%s%d.png", configData.node_onLineCount.bgPath, seqNo)

        local lblBg = ccui.Scale9Sprite:create("app/hall/gamelist/gameroom/" .. lblBgPath)
        lblBg:setCapInsets(cc.rect(20, 15, 2, 2))
        lblBg:setContentSize(configData.node_onLineCount.size)
        lblBg:align(display.CENTER, configData.node_onLineCount.pos.x, configData.node_onLineCount.pos.y):addTo(gamenode)

        local midY = configData.node_onLineCount.size.height / 2

        GameUtil.newSprite("app/hall/gamelist/gameroom/" .. configData.node_onLineCount.iconPath, false):align(display.CENTER, 20, midY):addTo(lblBg)

        local str_1 = LangCtrl:getLang().word275
        local num_1 = roomItemData.dwOnLineCount / roomItemData.dwFullCount
        if num_1 >= 0.75 then
            str_1 = LangCtrl:getLang().word276
        elseif (num_1 >= 0.5 and num_1 < 0.75) or (roomItemData.dwOnLineCount >= 200 and num_1 < 0.75) then
            str_1 = LangCtrl:getLang().word277
        elseif (num_1 >= 0.25 and num_1 < 0.5) or (roomItemData.dwOnLineCount >= 100 and roomItemData.dwOnLineCount < 200 and num_1 < 0.5) then
            str_1 = LangCtrl:getLang().word278
        end

        str_1 = tostring(roomItemData.dwOnLineCount) .. str_1
        if configData.node_onLineCount.wordDirect == "right" then
            GameUtil.createLabel(str_1, 24, cc.WHITE, display.RIGHT_CENTER, cc.p(configData.node_onLineCount.size.width - 10, midY)):addTo(lblBg)
        else
            GameUtil.createLabel(str_1, 24, cc.WHITE, display.LEFT_CENTER, cc.p(40, midY)):addTo(lblBg)
        end
    end

    if configData.node_minEnter ~= nil then
        if configData.node_minEnter.samelineChk == true then
            local str_2 = GameUtil.formatAsset(roomItemData.lMinEnterScore) .. LangCtrl:getLang().word279
            local lbl_enterScore = GameUtil.createLabel(str_2, 24, cc.WHITE, display.RIGHT_CENTER, cc.p(configData.node_onLineCount.size.width - 10, configData.node_minEnter.pos.y)):addTo(gamenode)
            GameUtil.newSprite("app/hall/gamelist/gameroom/" .. configData.node_minEnter.iconPath, false):align(display.RIGHT_CENTER,
                configData.node_onLineCount.size.width - lbl_enterScore:getContentSize().width - 20, configData.node_minEnter.pos.y):addTo(gamenode)
        else
            local lblBgPath = string.format("%s%d.png", configData.node_minEnter.bgPath, seqNo)

            local lblBg = ccui.Scale9Sprite:create("app/hall/gamelist/gameroom/" .. lblBgPath)
            lblBg:setCapInsets(cc.rect(20, 15, 2, 2))
            lblBg:setContentSize(configData.node_minEnter.size)
            lblBg:align(display.CENTER, configData.node_minEnter.pos.x, configData.node_minEnter.pos.y):addTo(gamenode)

            local midY = configData.node_minEnter.size.height / 2

            GameUtil.newSprite("app/hall/gamelist/gameroom/" .. configData.node_minEnter.iconPath, false):align(display.CENTER, 20, midY):addTo(lblBg)

            local str_2 = GameUtil.formatAsset(roomItemData.lMinEnterScore) .. LangCtrl:getLang().word279 .. "  "
            if configData.node_minEnter.wordDirect == "right" then
                GameUtil.createLabel(str_2, 24, cc.WHITE, display.RIGHT_CENTER, cc.p(configData.node_minEnter.size.width - 10, midY)):addTo(lblBg)
            else
                GameUtil.createLabel(str_2, 24, cc.WHITE, display.LEFT_CENTER, cc.p(40, midY)):addTo(lblBg)
            end
        end
    end

    if configData.node_dizhu ~= nil then
        local lblBgPath = string.format("%s%d.png", configData.node_dizhu.bgPath, seqNo)

        local lblBg = ccui.Scale9Sprite:create("app/hall/gamelist/gameroom/" .. lblBgPath)
        lblBg:setCapInsets(cc.rect(20, 15, 2, 2))
        lblBg:setContentSize(configData.node_dizhu.size)
        lblBg:align(display.CENTER, configData.node_dizhu.pos.x, configData.node_dizhu.pos.y):addTo(gamenode)

        local midY = configData.node_dizhu.size.height / 2

        GameUtil.createLabel(LangCtrl:getLang().word280, 28, cc.WHITE, display.LEFT_CENTER, cc.p(10, midY)):addTo(lblBg)

        local str_2 = GameUtil.formatAsset(roomItemData.lCellScore) .. "  "
        if configData.node_minEnter.wordDirect == "right" then
            GameUtil.createLabel(str_2, 28, cc.WHITE, display.RIGHT_CENTER, cc.p(configData.node_dizhu.size.width - 10, midY)):addTo(lblBg)
        else
            GameUtil.createLabel(str_2, 28, cc.WHITE, display.LEFT_CENTER, cc.p(80, midY)):addTo(lblBg)
        end
    end

    if configData.txt_other ~= nil then
        local str_txt = configData.txt_other.word[seqNo]
        local pos = configData.txt_other.pos
        if LangCtrl:isCN() then
            ccui.TextBMFont:create(str_txt, configData.txt_other.fntPath):align(display.CENTER, pos.x, pos.y):addTo(gamenode)
        else
            local lbl = cc.Label:createWithTTF(str_txt, "fonts/fzz.ttf", 24)
            lbl:align(display.CENTER, pos.x, pos.y):addTo(gamenode)
            lbl:setColor(cc.YELLOW)
            lbl:enableOutline(cc.c4b(94, 26, 5, 255), 1)
        end
    end

    return gamenode
end

function HallNodeRoomList:getCheckGameRoomList()
    local serverList = ServerListData.getGameServerByKindID(self.data.dwKindID)

    local serverDataList = {}
    serverDataList[1] = {
        name = LangCtrl:getLang().word271,
        nodeType = GameDefine.GameRoomType.FirstType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[2] = {
        name = LangCtrl:getLang().word272,
        nodeType = GameDefine.GameRoomType.MidType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[3] = {
        name = LangCtrl:getLang().word273,
        nodeType = GameDefine.GameRoomType.HeightType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }
    serverDataList[4] = {
        name = LangCtrl:getLang().word274,
        nodeType = GameDefine.GameRoomType.TopType,
        wKindID = 0,
        lMinEnterScore = 0,
        lCellScore = 0,
        dwOnLineCount = 0,
        dwFullCount = 0,
        serverList = {},
        serverDate = nil
    }

    for i = 1, #serverList do
        if serverList[i].wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GOLD or serverList[i].wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER then
            local nodeType = PlazaManager.getGameRoomType(serverList[i].wNodeID)
            local seqNo = 0
            if nodeType == GameDefine.GameRoomType.FirstType then
                seqNo = 1
            elseif nodeType == GameDefine.GameRoomType.MidType then
                seqNo = 2
            elseif nodeType == GameDefine.GameRoomType.HeightType then
                seqNo = 3
            elseif nodeType == GameDefine.GameRoomType.TopType then
                seqNo = 4
            end

            if seqNo >= 1 and seqNo <= 4 then
                serverDataList[seqNo].wKindID = serverList[i].wKindID
                serverDataList[seqNo].lMinEnterScore = serverList[i].lMinEnterScore
                serverDataList[seqNo].lCellScore = serverList[i].lCellScore
                serverDataList[seqNo].dwOnLineCount = serverDataList[seqNo].dwOnLineCount + serverList[i].dwOnLineCount
                serverDataList[seqNo].dwFullCount = serverDataList[seqNo].dwFullCount + serverList[i].dwFullCount

                table.insert(serverDataList[seqNo].serverList, serverList[i])
            end
        end
    end

    -- 除去0个的和随机选取服务器
    for i = 4, 1, -1 do
        if #serverDataList[i].serverList == 0 then
            table.remove(serverDataList, i)
        else
            print("服务器类型：" .. tostring(i))
            print("服务器数量：" .. tostring(#serverDataList[i].serverList))
            local chooseSeqNo = 1
            local count = #serverDataList[i].serverList
            chooseSeqNo = math.random(1, count)
            print("随机选择时服务器数量：")
            serverDataList[i].serverDate = serverDataList[i].serverList[chooseSeqNo]
            print("随机选中的服务器名称：" .. tostring(serverDataList[i].serverDate.szServerName))
        end
    end

    local function sortByNodeType(item1, item2)
        if item1.nodeType < item2.nodeType then
            return true
        else
            return false
        end
    end

    table.sort(serverDataList, sortByNodeType)

    return serverDataList
end

------------------------消息处理函数------------------------------------------
function HallNodeRoomList:onRequestServerListFinish()
    if self.data ~= nil and self.data.dwKindID ~= nil and type(self.data.dwKindID) == "number" then
        self:initView()
    end
end

return HallNodeRoomList

-- endregion
