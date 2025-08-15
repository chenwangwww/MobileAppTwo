local UpdateAppUI = class("UpdateAppUI", function()
    return cc.Node:create()
end)

local fontName = "app/fonts/fzz.ttf"

function UpdateAppUI:ctor(urlData, compleFunction, removeHallData)
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
    self:setContentSize(cc.size(display.width, display.height))
    self:setName("UpdateAppUI")

    self.compleFunction = compleFunction
    self.removeHallUpdateData = removeHallData

    self:onSwallowClickEvent()

    local mask_Image = ccui.ImageView:create("app/common/mask.png")
    mask_Image:setScale(display.width / 5, display.height / 5)
    mask_Image:align(display.CENTER, display.cx, display.cy)
    mask_Image:setOpacity(180)
    self:addChild(mask_Image)

    local size = cc.size(882, 542)
    local midWidth = size.width / 2
    local panelNode = cc.Node:create()
    panelNode:setContentSize(size)
    panelNode:align(display.CENTER, display.cx, display.cy):addTo(self)
    self.panelNode = panelNode

    local bg_1 = ccui.Scale9Sprite:create("app/common/comwin/panel_1.png")
    bg_1:setCapInsets(GameDefine.PanelRect1)
    bg_1:setContentSize(size.width, size.height)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(panelNode)

    local titlebg = ccui.Scale9Sprite:create("app/common/comwin/panel_titlebg.png")
    titlebg:setCapInsets(GameDefine.PanelRect3)
    titlebg:setContentSize(size.width - 10, 64)
    titlebg:align(display.CENTER_BOTTOM, midWidth, size.height - 68):addTo(panelNode)

    local bg_top = ccui.ImageView:create("app/common/comwin/panel_title.png")
    -- bg_top:ignoreContentAdaptWithSize(false)
    -- bg_top:setContentSize(cc.size(size.width + 10, 95))
    bg_top:align(display.CENTER_BOTTOM, midWidth, size.height - 66):addTo(panelNode)

    GameUtil.addTitleTTF(LangCtrl:getLang().word27, bg_top) -- 版本更新

    local platform = cc.Application:getInstance():getTargetPlatform()
    -- 立即更新
    local function onUpdataClick(uiwidget, eventType)
        if eventType == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
        end
        if eventType == ccui.TouchEventType.ended then
            if GameDefine.bIsTestUI then
                self:removeFromParent()
                return
            end
            self.btn_updata:setEnabled(false)

            -- 清除大厅更新的数据
            if self.removeHallUpdateData ~= nil then
                self.removeHallUpdateData()
            end

            if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
                cc.Application:getInstance():openURL(urlData.updateNote.iosDownUrl)
            elseif platform == cc.PLATFORM_OS_ANDROID then
                self:onDwonloadGame(urlData.updateNote.androidDownUrl)
            elseif platform == cc.PLATFORM_OS_WINDOWS then
                self:onDwonloadGame(urlData.updateNote.winDownUrl)
            end
        end
    end
    local btn_updata = ccui.Button:create("app/common/button/btn1.png"):move(midWidth, 70):addTo(self.panelNode)
    btn_updata:setZoomScale(-0.1)
    btn_updata:addTouchEventListener(onUpdataClick) -- 216 64
    GameUtil.addBtnTTF2(LangCtrl:getLang().word297, btn_updata)

    self.btn_updata = btn_updata

    if urlData.updateNote.imageUrl ~= nil and urlData.updateNote.imageUrl ~= "" then
        self:setUpdataImage(urlData.updateNote.imageUrl)
    end

    local listView = ccui.ListView:create()
    listView:setContentSize(560, 240)
    listView:align(display.CENTER_TOP, midWidth, size.height - 90):addTo(self.panelNode)
    listView:setItemsMargin(15)
    self.listView = listView

    local progBg = display.newSprite("app/common/progress/bgprogress2.png")
    progBg:align(display.CENTER, midWidth, 140):addTo(self.panelNode)

    local progSp = cc.ProgressTimer:create(display.newSprite("app/common/progress/progress2.png"))
    progSp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progSp:setBarChangeRate(display.RIGHT_BOTTOM)
    progSp:setMidpoint(display.LEFT_TOP)
    progSp:align(display.CENTER, midWidth, 140):addTo(self.panelNode)
    self.progSp = progSp

    local proglbl = cc.Label:createWithTTF("100%", fontName, 24)
    proglbl:setColor(cc.c3b(0xa8, 0xa2, 0x94))
    proglbl:setAnchorPoint(display.CENTER)
    proglbl:setPosition(midWidth, 160)
    proglbl:addTo(self.panelNode)
    self.proglbl = proglbl

    if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
        progBg:setVisible(false)
        progSp:setVisible(false)
        proglbl:setVisible(false)
    end

    local vesionStr = ""
    local fileSizeStr = ""
    if platform == cc.PLATFORM_OS_ANDROID then
        vesionStr = urlData.androidmainVersion
        fileSizeStr = urlData.updateNote.androidFileSize
    else
        vesionStr = urlData.iosmainVersion
        fileSizeStr = urlData.updateNote.iosFileSize
    end
    local msgstr = urlData.updateNote.updateContentList
    local updatecContentList = string.split(msgstr, "=")
    --[[
    vesionStr="版本：2017.12.12"
    fileSizeStr="版本大小：35.2KB"
    updatecContentList={
      "1.新增大厅快速加入入口"
     ,"2.新增大厅快速加入入口"
     ,"3.新增大厅快速加入入口"
     ,"4.新增大厅快速加入入口"
    }
    --]]
    self:setVersionInfo(vesionStr, fileSizeStr, updatecContentList)
end

function UpdateAppUI:onEnter()
end

function UpdateAppUI:onExit()
end

function UpdateAppUI:cleanup()
    self:unregisterScriptHandler()
end

-- 对外接口
function UpdateAppUI:setPercent(percent)
    if percent == nil or type(percent) ~= "number" then
        return
    end
    self.progSp:setPercentage(percent)
    self.proglbl:setString(string.format("%.2f%%", percent))
end

-- 版本信息字符创，文件大小字符串，更新内容列表
function UpdateAppUI:setVersionInfo(vesionStr, fileSizeStr, updatecContentList)
    self.listView:removeAllItems()

    local str_vesion = string.format(LangCtrl:getLang().word298, vesionStr)
    local text_vestion = ccui.Text:create(str_vesion, fontName, 24)
    text_vestion:setTextColor(cc.c3b(0xa8, 0xa2, 0x94))
    self.listView:pushBackCustomItem(text_vestion)

    local str_fileSize = string.format(LangCtrl:getLang().word299, fileSizeStr)
    local text_fileSize = ccui.Text:create(str_fileSize, fontName, 24)
    text_fileSize:setTextColor(cc.c3b(0xa8, 0xa2, 0x94))
    self.listView:pushBackCustomItem(text_fileSize)

    if updatecContentList ~= nil and #updatecContentList > 0 then
        local text_title = ccui.Text:create(LangCtrl:getLang().word300, fontName, 24)
        text_title:setTextColor(cc.c3b(0xa8, 0xa2, 0x94))
        self.listView:pushBackCustomItem(text_title)

        for i = 1, #updatecContentList do
            local text_str = ccui.Text:create("           " .. updatecContentList[i], fontName, 24)
            text_str:setTextColor(cc.c3b(0xa8, 0xa2, 0x94))
            self.listView:pushBackCustomItem(text_str)
        end
    end
end

-- 设置更新图片
function UpdateAppUI:setUpdataImage(imagPath)
    game.fileDownload(imagPath, false, function(succ, localPath)
        if succ then
            if cc.FileUtils:getInstance():isFileExist(localPath) and cc.FileUtils:getInstance():getStringFromFile(localPath) == "" then
                cc.FileUtils:getInstance():removeFile(localPath)
            end
            local avatarSp = cc.Sprite:create(localPath)
            if avatarSp ~= nil then
                local spSize = avatarSp:getContentSize()
                avatarSp:setScale(650 / spSize.width, 290 / spSize.height)
                avatarSp:align(display.CENTER_TOP, 351, 400):addTo(self.panelNode)
            end
        end
    end, nil, false)
end
-- 下载更新
function UpdateAppUI:onDwonloadGame(downUrl)
    local function onProgress(percent)
        self:setPercent(percent)
    end

    local function onComplate(isSuccess, apkPath)
        if self.compleFunction ~= nil then
            self.compleFunction(isSuccess, apkPath)
        end
    end

    if downUrl ~= nil and string.len(downUrl) > 5 then
        game.fileDownloadAPK(downUrl, onComplate, onProgress)
    end
end

function UpdateAppUI:onSwallowClickEvent()
    local function onTouchBegan(touch, event)
        return true
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener, self)
end
return UpdateAppUI
