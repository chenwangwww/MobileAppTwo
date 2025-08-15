local HallNodeGameList = class("HallNodeGameList", function()
    return display.newNode()
end)

function HallNodeGameList:ctor(nPageIdx)
    self:setContentSize(cc.size(800, 440))
    self:initView(nPageIdx or globalUserInfo.nGameListPageIdx)
end

local tAniMap = {
    [1006] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_hbsl/zdt_hbsl.ExportJson",
        aniname = "zdt_hbsl",
        offsetX = 0,
        offsetY = 0
    },
    -- 红包扫雷
    [1001] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_bcbm/zdt_bcbm.ExportJson",
        aniname = "zdt_bcbm",
        offsetX = 0,
        offsetY = 0
    },
    -- 奔驰宝马
    [1005] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_csd/zdt_csd.ExportJson",
        aniname = "zdt_csd",
        offsetX = 0,
        offsetY = 0
    },
    -- 财神到
    [10] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_hlzz/zdt_hlzz.ExportJson",
        aniname = "zdt_hlzz",
        offsetX = 0,
        offsetY = 0
    },
    -- 欢乐至尊
    [27] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_hpnn/zdt_hpnn.ExportJson",
        aniname = "zdt_hpnn",
        offsetX = 0,
        offsetY = 0
    },
    -- 火拼牛牛
    [204] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_jldb/zdt_jldb.ExportJson",
        aniname = "zdt_jldb",
        offsetX = 0,
        offsetY = 0
    },
    -- 九连夺宝
    [1009] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_jpm/zdt_jpm.ExportJson",
        aniname = "zdt_jpm",
        offsetX = 0,
        offsetY = 0
    },
    -- 金瓶梅
    [1008] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_jsfy/zdt_jsfy.ExportJson",
        aniname = "zdt_jsfy",
        offsetX = 0,
        offsetY = 0
    },
    -- 僵尸风云
    [1002] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_lhdb/zdt_lhdb.ExportJson",
        aniname = "zdt_lhdb",
        offsetX = 0,
        offsetY = 0
    },
    -- 连环夺宝
    [33] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_lkpy/zdt_lkpy.ExportJson",
        aniname = "zdt_lkpy",
        offsetX = 0,
        offsetY = 0
    },
    -- 李逵劈鱼
    [205] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_sgkh/zdt_sgkh.ExportJson",
        aniname = "zdt_sgkh",
        offsetX = 0,
        offsetY = 0
    },
    -- 水果狂欢
    [203] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_shz/zdt_shz.ExportJson",
        aniname = "zdt_shz",
        offsetX = 0,
        offsetY = 0
    },
    -- 水浒传
    [7] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_sss/zdt_sss.ExportJson",
        aniname = "zdt_sss",
        offsetX = 0,
        offsetY = 0
    },
    -- 十三水
    [28] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_tbnn/zdt_tbnn.ExportJson",
        aniname = "zdt_tbnn",
        offsetX = 0,
        offsetY = 0
    },
    -- 通比牛牛
    [1004] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_hl30m/zdt_hl30m.ExportJson",
        aniname = "zdt_hl30m",
        offsetX = 0,
        offsetY = 0
    },
    -- 欢乐30秒
    [1003] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_hjlc/zdt_hjlc.ExportJson",
        aniname = "zdt_hjlc",
        offsetX = 0,
        offsetY = 0
    },
    -- 钻石列车
    [1010] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_blcs/zdt_blcs.ExportJson",
        aniname = "zdt_blcs",
        offsetX = 0,
        offsetY = 0
    },
    -- 秘鲁传说
    [1011] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_tgg/zdt_tgg.ExportJson",
        aniname = "zdt_tgg",
        offsetX = 0,
        offsetY = 0
    },
    -- 跳高高
    [1012] = {
        expjson = "app/hall/gamelist/zdt_ani/zdt_mjhl/zdt_mjhl.ExportJson",
        aniname = "zdt_mjhl",
        offsetX = 0,
        offsetY = 0
    }
    -- 麻将胡了
}

function HallNodeGameList:initView(nPageIdx)
    local pageIconControl = self:createPageViewIcon()
    pageIconControl:align(display.CENTER, 400, 0):addTo(self)
    self.pageIconControl = pageIconControl

    local gamePageView = ccui.PageView:create()
    gamePageView:setTouchEnabled(true)
    gamePageView:setContentSize(1000, 500)
    gamePageView:align(display.LEFT_BOTTOM, 0, 20)
    gamePageView:setDirection(ccui.ListViewDirection.horizontal)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            self.nCurPageIdx = sender:getCurPageIndex()
            globalUserInfo.nGameListPageIdx = self.nCurPageIdx
            self:updateChoose(self.nCurPageIdx + 1)
        end
    end
    gamePageView:addEventListener(pageViewEvent)
    gamePageView.pageCount = 0
    self:addChild(gamePageView)
    self.gamePageView = gamePageView

    local gameListData = self:getGameList()
    if GameDefine.bIsTestUI then
        gameListData = self:doTestAddGame()
    end
    local pageCount = math.floor((#gameListData - 1) / 6) + 1
    if #gameListData == 0 then
        pageCount = 0
    end

    for pageSeqNo = 1, pageCount do
        local pageView = ccui.Layout:create()
        pageView:setContentSize(1000, 500)
        self.gamePageView:addPage(pageView)

        for i = 1, 6 do
            local gameSeqNo = (pageSeqNo - 1) * 6 + i
            if gameSeqNo > #gameListData then
                break
            end

            local posy = 360 - (math.floor((i - 1) / 3) * 240)
            local posx = 150 + (i - 1) % 3 * 300
            local pos = cc.p(posx, posy)

            local gameItem = self:createGameItem(gameListData[gameSeqNo], pos)
            gameItem:addTo(pageView)
            -- debugDraw(pageView)
        end
    end
    self.gamePageView.pageCount = pageCount

    -- 左边箭头
    local function onClickLeft(target)
        local pageindex = self.gamePageView:getCurPageIndex() - 1
        self:setPageShow(pageindex)
    end
    self.btn_left = GameUtil.createButton("app/hall/gamelist/img_hdtip.png", nil, onClickLeft):move(-20, 250):addTo(self):setRotation(180)

    -- 右边箭头
    local function onClickRight(target)
        local pageindex = self.gamePageView:getCurPageIndex() + 1
        self:setPageShow(pageindex)
    end
    self.btn_right = GameUtil.createButton("app/hall/gamelist/img_hdtip.png", nil, onClickRight):move(910, 250):addTo(self)

    self.btn_left:setVisible(false)
    if pageCount > 1 then
        self.btn_right:setVisible(true)
    else
        self.btn_right:setVisible(false)
    end

    self.pageIconControl:updataView(pageCount, 1)

    if nPageIdx ~= nil and nPageIdx >= 1 and nPageIdx <= pageCount then
        self.nCurPageIdx = nPageIdx
        self.gamePageView:setCurPageIndex(nPageIdx)
        self:updateChoose(self.nCurPageIdx + 1)
    else
        self.gamePageView:setCurPageIndex(0)
    end
end

function HallNodeGameList:setPageShow(pageindex)
    globalUserInfo.nGameListPageIdx = pageindex
    self.nCurPageIdx = pageindex
    self.gamePageView:scrollToPage(pageindex)
    self:updateChoose(self.nCurPageIdx + 1)
end

function HallNodeGameList:updateChoose(chooseIndex)
    self.pageIconControl:setChooseIcon(chooseIndex)
    if self.gamePageView.pageCount > 1 and chooseIndex == 1 then
        self.btn_left:setVisible(false)
        self.btn_right:setVisible(true)
    elseif self.gamePageView.pageCount > 1 and chooseIndex > 1 and chooseIndex < self.gamePageView.pageCount then
        self.btn_left:setVisible(true)
        self.btn_right:setVisible(true)
    elseif self.gamePageView.pageCount > 1 and chooseIndex == self.gamePageView.pageCount then
        self.btn_left:setVisible(true)
        self.btn_right:setVisible(false)
    end
end

function HallNodeGameList:createPageViewIcon()
    local iconPanel = ccui.Layout:create()

    function iconPanel:setChooseIcon(currIndex)
        local iconList = self:getChildren()
        for i = 1, #iconList do
            if iconList[i]:getTag() == currIndex then
                iconList[i]:loadTexture("app/hall/gamelist/img_hdtip2.png")
            else
                iconList[i]:loadTexture("app/hall/gamelist/img_hdtip3.png")
            end
        end
    end

    function iconPanel:updataView(count, curIndex)
        self:removeAllChildren()
        for i = 1, count do
            local posX = 30 * (i - (count + 1) / 2)
            local image_icon = ccui.ImageView:create("app/hall/gamelist/img_hdtip3.png")
            image_icon:setAnchorPoint(display.CENTER)
            image_icon:setPosition(posX, 0)
            image_icon:setTag(i)
            self:addChild(image_icon)

            if i == curIndex then
                image_icon:loadTexture("app/hall/gamelist/img_hdtip2.png")
            end
        end
    end
    return iconPanel
end

-- 创建游戏按钮
function HallNodeGameList:createGameItem(gameInfo, pos)
    local function onClickGame(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            sender:runAction(cc.ScaleTo:create(0.1, 0.9))
            PlazaManager.playClickEffect()
        elseif eventtype == ccui.TouchEventType.ended then
            sender:runAction(cc.ScaleTo:create(0.1, 1.0))

            local posx, posy = sender:getPosition()
            local downPos = sender:getParent():convertToWorldSpace(cc.p(posx, posy))

            local gameinfo = sender.gameInfo
            local function callFinishFunc(result, wKindID)
                local isUpdateStatus = PlazaManager.checkGameVersion(wKindID)
                if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NORMAL then
                    if sender:getChildByName("icon_updata") ~= nil then
                        sender:getChildByName("icon_updata"):setVisible(false)
                    end
                end
            end
            self:onChooseGameItem(gameinfo, downPos, callFinishFunc)
        elseif eventtype == ccui.TouchEventType.canceled then
            sender:runAction(cc.ScaleTo:create(0.1, 1.0))
        end
    end

    local gameItem = ccui.Layout:create()
    gameItem:setContentSize(250, 250)
    gameItem:align(display.CENTER, pos.x, pos.y)
    gameItem:setTouchEnabled(true)
    gameItem:addTouchEventListener(onClickGame)
    gameItem.gameInfo = gameInfo

    local anicfg = tAniMap[gameInfo.wKindID]
    if anicfg and cc.FileUtils:getInstance():isFileExist(anicfg.expjson) then
        local inputImage = ccui.ImageView:create("app/hall/gamelist/zdt_ani/bg_db.png")
        inputImage:align(display.CENTER, 125, 125):addTo(gameItem)

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(anicfg.expjson)
        -- 加载动画所用到的数据
        local armature = ccs.Armature:create(anicfg.aniname) -- 创建动画对象
        armature:getAnimation():playWithIndex(0) -- 设置动画对象执行的动画名称
        -- armature:getAnimation():play(anicfg.aniname)
        -- armature:getAnimation():setSpeedScale(0.5)
        armature:align(display.CENTER, 125 + anicfg.offsetX, 125 + anicfg.offsetY):addTo(gameItem)

        local namestr = LangCtrl:gameName(gameInfo.wKindID, gameInfo.szKindName)
        local content = cc.Label:createWithTTF(namestr, "app/fonts/fzcy.ttf", 36)
        content:setColor(cc.c3b(237, 230, 175))
        -- content:enableOutline(cc.c4b(132, 77, 24, 255), 2)
        content:enableOutline(cc.c4b(94, 26, 5, 255), 2)
        content:align(display.CENTER, 125, 30):addTo(gameItem)
    else
        GameUtil.newSprite("app/hall/gamelist/gameicon/game_defeal.png", false):align(display.CENTER, 125, 125):addTo(gameItem)
        GameUtil.createLabel(gameInfo.szKindName, 32, cc.BLACK, display.CENTER, cc.p(125, 70)):addTo(gameItem)
    end
    -- 更新图标
    local isUpdateStatus = PlazaManager.checkGameVersion(gameInfo.wKindID)
    if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        local img_updata = GameUtil.newSprite("app/hall/gamelist/tip_gx.png", false):align(display.CENTER, 125, 210):addTo(gameItem)
        img_updata:setName("icon_updata")
    end

    -- debugDraw(gameItem)
    return gameItem
end

-- 游戏点击事件
function HallNodeGameList:onChooseGameItem(gameinfo, pos, callFinishFunc)
    --[[if PlazaManager.platform == cc.PLATFORM_OS_MAC or PlazaManager.platform == cc.PLATFORM_OS_WINDOWS then
        --检测是否有资源
        local isExist = false
        local gameInfo = PlazaManager.getUrlGameInfoByKindID(gameinfo.wKindID)
        if gameInfo ~= nil then
            local loadingClassName = string.format("game/%s/src/%sLoading",gameInfo.name,string.upper(gameInfo.name))
            if cc.FileUtils:getInstance():isFileExist(loadingClassName..".lua") or cc.FileUtils:getInstance():isFileExist(loadingClassName..".luac") then
                isExist = true
            end
        end

        if isExist == false then
            PlazaManager.showConfirmNode("ok","检测游戏资源不存在")
            return
        end
    end
    --]]
    local isUpdateStatus = PlazaManager.checkGameVersion(gameinfo.wKindID)
    if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        PlazaManager.onDownloadGame(gameinfo.wKindID, callFinishFunc, pos)
    else
        self:setGameCreateTimeRecord(gameinfo.wKindID)

        local args = {
            index = GameDefine.HALL_LAYER_INDEX.GOLD_ROOM,
            wKindID = gameinfo.wKindID,
            nPageIdx = self.nCurPageIdx
        }
        game.sendEvent(GameDefine.SWITCH_HALL_LAYER, args)
    end
end

function HallNodeGameList:getGameList()
    local gameListData = ServerListData.getGameListOnMain()
    self:sortGameList(gameListData)

    return gameListData
end

function HallNodeGameList:doTestAddGame()
    local tAllGames = {}
    local games = PlazaManager.urlGameConfig.list
    local gameMap = ServerListData.getGameKindData()
    for k, v in pairs(games) do
        if LangCtrl.tGamesMap[v.kindid] then
            local tt = {
                szKindName = v.nameStr,
                wKindID = v.kindid,
                wGameID = v.kindid,
                dwFullCount = math.random(0, 99),
                dwOnLineCount = math.random(0, 99),
                wJoinID = 64,
                wSortID = 1,
                wTypeID = 1
            }
            table.insert(gameMap, tt)
            table.insert(tAllGames, tt)
        end
    end
    return tAllGames
end

---------------------游戏排序记录-------------------
-- 保存游戏点击次数
function HallNodeGameList:setGameCreateTimeRecord(dwKindID)
    local jsonStr = cc.UserDefault:getInstance():getStringForKey("GameChooseRecord", "{}")
    local recordData = json.decode(jsonStr)
    if recordData == nil then
        recordData = {}
    end

    local exit = false
    for i = 1, #recordData do
        if recordData[i].dwKindID == dwKindID then
            recordData[i].totalTimes = recordData[i].totalTimes + 1
            recordData[i].recordTime = os.time()
            exit = true
            break
        end
    end

    if exit == false then
        local gameRecord = {
            dwKindID = dwKindID,
            totalTimes = 1,
            recordTime = os.time()
        }
        table.insert(recordData, gameRecord)
    end
    local saveJsonStr = json.encode(recordData)
    cc.UserDefault:getInstance():setStringForKey("GameChooseRecord", saveJsonStr)
end

-- 获取游戏点击次数
function HallNodeGameList:getGameCreateTimeRecord()
    local jsonStr = cc.UserDefault:getInstance():getStringForKey("GameChooseRecord", "{}")
    local recordData = json.decode(jsonStr)
    if recordData == nil then
        recordData = {}
    end

    local diffTime = 24 * 60 * 60 * 5 -- 5天的时间差
    for i = #recordData, 1, -1 do
        if os.difftime(os.time(), recordData[i].recordTime) > diffTime then
            table.remove(recordData, i)
        end
    end

    local saveJsonStr = json.encode(recordData)
    cc.UserDefault:getInstance():setStringForKey("GameChooseRecord", saveJsonStr)

    return recordData
end

function HallNodeGameList:sortGameList(gameListData)
    local recordListData = self:getGameCreateTimeRecord()

    for i = 1, #gameListData do
        for j = i + 1, #gameListData do
            local gameTimes_1 = 0
            local gameTimes_2 = 0
            for k = 1, #recordListData do
                if gameListData[i].wKindID == recordListData[k].dwKindID then
                    gameTimes_1 = math.floor(recordListData[k].totalTimes / 5)
                end
                if gameListData[j].wKindID == recordListData[k].dwKindID then
                    gameTimes_2 = math.floor(recordListData[k].totalTimes / 5)
                end
            end

            if gameListData[i].wSortID > 10000 and gameListData[j].wSortID > 10000 then
                if gameListData[i].wSortID > gameListData[j].wSortID then
                    local itemdata = gameListData[i]
                    gameListData[i] = gameListData[j]
                    gameListData[j] = itemdata
                end
            elseif gameListData[i].wSortID <= 10000 and gameListData[j].wSortID > 10000 then
                local itemdata = gameListData[i]
                gameListData[i] = gameListData[j]
                gameListData[j] = itemdata
            elseif gameListData[i].wSortID <= 10000 and gameListData[j].wSortID <= 10000 then
                if gameTimes_2 > gameTimes_1 or (gameTimes_2 == gameTimes_1 and gameListData[i].wSortID > gameListData[j].wSortID) then
                    local itemdata = gameListData[i]
                    gameListData[i] = gameListData[j]
                    gameListData[j] = itemdata
                end
            end
        end
    end
end
return HallNodeGameList
