--[[
	工具类
]] cc.exports.GameUtil = {}

local SFUtils = require "app.components.SpriteFrameUtils"
local Utils = require "app.components.Utils"
local bit = require "bit"
local math = require "math"
local json = require("json")

local target_platform = cc.Application:getInstance():getTargetPlatform()

local function drawNodeRoundRect(rect, radius, color)
    local drawNode = cc.DrawNode:create()
    drawNode:setContentSize(rect.width, rect.height)

    local segments = 100
    local origin = cc.p(rect.x, rect.y)
    local destination = cc.p(rect.x + rect.width, rect.y + rect.height)
    local points = {}

    -- 算出1/4圆
    local coef = math.pi / 2 / segments
    local vertices = {}

    for i = 0, segments do
        local rads = (segments - i) * coef
        local x = radius * math.sin(rads)
        local y = radius * math.cos(rads)

        table.insert(vertices, cc.p(x, y))
    end

    local tagCenter = cc.p(0, 0)
    local minX = math.min(origin.x, destination.x)
    local maxX = math.max(origin.x, destination.x)
    local minY = math.min(origin.y, destination.y)
    local maxY = math.max(origin.y, destination.y)
    local dwPolygonPtMax = (segments + 1) * 4
    local pPolygonPtArr = {}

    -- 左上角
    tagCenter.x = minX + radius
    tagCenter.y = maxY - radius

    for i = 0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右上角
    tagCenter.x = maxX - radius
    tagCenter.y = maxY - radius

    for i = 0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右下角
    tagCenter.x = maxX - radius
    tagCenter.y = minY + radius

    for i = 0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 左下角
    tagCenter.x = minX + radius
    tagCenter.y = minY + radius

    for i = 0, segments do
        local x = tagCenter.x - vertices[#vertices - i].x
        local y = tagCenter.y - vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    if color == nil then
        color = cc.c4f(0, 0, 0, 0)
    end

    drawNode:drawSolidPoly(pPolygonPtArr, #pPolygonPtArr, color)

    return drawNode
end

-- 创建头像
local function newAvatarNode(path, width, isCircle, circleAgn)
    if isCircle == nil then
        isCircle = true
    end
    if circleAgn == nil then
        circleAgn = 10
    end

    local size = cc.size(width, width)

    local node = display.newNode()
    node:retain()
    node:setAnchorPoint(display.CENTER)
    node:setContentSize(size)

    local avatarSp = nil
    local _remove = false
    local function update()
        local function addAvatar(spriteAvatar)
            if tolua.isnull(node) or _remove or spriteAvatar == nil then
                return
            end
            if isCircle or circleAgn > 0 then
                local cliper = cc.ClippingNode:create()
                cliper:setContentSize(size)
                local drawNode = nil
                local color = cc.c4f(1, 1, 1, 1)
                if isCircle then
                    drawNode = cc.DrawNode:create()
                    drawNode:drawSolidCircle(cc.p(size.width / 2, size.height / 2), size.width / 2, 360, 100, color)
                else
                    drawNode = drawNodeRoundRect(cc.rect(0, 0, size.width, size.width), circleAgn, color)
                end
                cliper:setStencil(drawNode)

                spriteAvatar:move(size.width / 2, size.height / 2):addTo(cliper)
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(scale)

                node:removeAllChildren()
                node:addChild(cliper)
            else
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(width / avatarSize.width)
                spriteAvatar:move(size.width / 2, size.height / 2)

                node:removeAllChildren()
                spriteAvatar:addTo(node)
            end
        end

        if path == nil or #path == 0 or path == " " then
            path = "app/common/icon/icon_1.png"
        end

        if string.sub(path, 1, 4) ~= "http" then
            avatarSp = cc.Sprite:create(path)
            if avatarSp == nil then
                avatarSp = cc.Sprite:create("app/common/icon/icon_1.png")
            end
            addAvatar(avatarSp)
        else
            local isHttpDownload = false
            if target_platform == cc.PLATFORM_OS_ANDROID then
                if game.getIsWifi ~= nil and game.getIsWifi() == false then
                    isHttpDownload = true
                    print("android环境下 没有链接wifi")
                end
            end

            if isHttpDownload == false then
                print("启动Downloader下载头像", path)
                game.fileDownload(path, false, function(succ, localPath)
                    if succ == true then
                        print("头像下载成功 localPath == " .. localPath)
                        if cc.FileUtils:getInstance():isFileExist(localPath) and cc.FileUtils:getInstance():getStringFromFile(localPath) == "" then
                            cc.FileUtils:getInstance():removeFile(localPath)
                        end

                        if _remove == true then
                            return
                        end
                        avatarSp = cc.Sprite:create(localPath)
                        if avatarSp == nil then
                            avatarSp = cc.Sprite:create("app/common/icon/icon_1.png")
                        end
                    else
                        if _remove == true then
                            return
                        end
                        print("头像下载失败", path)
                        avatarSp = cc.Sprite:create("app/common/icon/icon_1.png")
                    end
                    addAvatar(avatarSp)
                end, nil, false)
            else
                -- 首先判断头像是否存在
                local imgFileName = game.md5(path) .. "data"
                local imgFileAddress = cc.FileUtils:getInstance():getWritablePath() .. ".dwqpgame/res/dwqpgametemp/" .. imgFileName
                print("imgFileName , imgFileAddress == ", imgFileName, imgFileAddress)
                if cc.FileUtils:getInstance():isFileExist(imgFileAddress) == true then
                    avatarSp = cc.Sprite:create(imgFileAddress)
                    if avatarSp == nil then
                        avatarSp = cc.Sprite:create("app/common/icon/icon_1.png")
                    end
                    addAvatar(avatarSp)
                else
                    print("启动http下载头像 下载头像开始  ", os.time(), path)
                    -- 不存在。启动http下载
                    local xhr = cc.XMLHttpRequest:new()
                    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER
                    xhr:open("GET", path)

                    local function onDownloadImage()
                        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                            local fileData = xhr.response
                            local size = table.getn(fileData)
                            local file = io.open(imgFileAddress, "wb+")
                            for i = 1, size do
                                file:write(string.char(fileData[i]))
                            end
                            file:close()
                            avatarSp = cc.Sprite:create(imgFileAddress)
                            if avatarSp == nil then
                                avatarSp = cc.Sprite:create("app/common/icon/icon_1.png")
                            end
                            addAvatar(avatarSp)
                        else
                            xhr:unregisterScriptHandler()
                        end
                    end

                    xhr:registerScriptHandler(onDownloadImage)
                    xhr:send()
                end
            end
        end
    end

    update()

    function node:updateAvatar(_path)
        path = _path
        update()
    end

    function node:getSprFrame()
        if avatarSp ~= nil then
            return avatarSp:getSpriteFrame()
        end
        return nil
    end

    local function onEnterOrExit(tag)
        if tag == "exit" then
            node:release()
            _remove = true
        end
    end

    node:registerScriptHandler(onEnterOrExit)

    return node
end

-- 游戏视图转换
function GameUtil.switchViewChairID(chairID, selfChair, maxPlayerCount, switchCount)
    if chairID == GameDefine.INVALID_CHAIR then
        return GameDefine.INVALID_CHAIR
    end

    if switchCount == nil or type(switchCount) ~= "number" then
        switchCount = GameDefine.PERSONAL_ROOM_CHAIR
    end
    if chairID >= switchCount and chairID ~= selfChair then
        return chairID
    end

    local chair = chairID + (maxPlayerCount - selfChair)
    local tempindex = math.mod(chair, maxPlayerCount)
    local tem = maxPlayerCount - tempindex
    local index = math.mod(tem, maxPlayerCount)

    if index > maxPlayerCount or index < 0 then
        return GameDefine.INVALID_CHAIR
    end

    return index + 1
end

function GameUtil.convertNetAvatarToLocalPath(avatarPath)
    local result = avatarPath

    if avatarPath == nil or #avatarPath == 0 or avatarPath == " " then
        result = "app/common/icon/icon_1.png"
    elseif string.sub(result, 1, 4) ~= "http" then
        result = "app/common/icon/" .. result
    end

    return result
end

--[[  创建头像
        avatarPath:路径
        avatarWidth:大小
       isCircle:是否圆型
       callback:回调方法
       avatarPathType:加载头像路径类别 (nil 加载 icon下的avatarPath资源   其他直接加载avatarPath资源)
       avatarFramePath:头像框
       openBigAvater:是否打开大头像
]]
function GameUtil.createAvatar(avatarPath, avatarWidth, isCircle, callback, avatarPathType, avatarFramePath, openBigAvater)
    local function getPath(aPath, aType)
        local result = aPath

        if aPath == nil or #aPath == 0 or aPath == " " then
            result = "app/common/icon/icon_1.png"
        end

        if string.sub(result, 1, 4) ~= "http" then
            if aType == nil then
                result = "app/common/icon/" .. result
            end
        end

        return result
    end

    local path = getPath(avatarPath, avatarPathType)

    local isOpenBigAvater
    if openBigAvater == nil then
        isOpenBigAvater = true
    else
        isOpenBigAvater = false
    end

    -- 是否圆形
    if isCircle == nil then
        isCircle = false
    end

    local size = nil
    if avatarWidth ~= nil and type(avatarWidth) == "number" then
        size = cc.size(avatarWidth, avatarWidth)
    end

    local img_avatar = nil
    local img_avatar_frame = nil

    -- 头像底
    if avatarFramePath ~= nil then
        local avatar_path = string.format("app/common/%s.png", avatarFramePath)
        local avatar_frame_path = string.format("app/common/%s_1.png", avatarFramePath)

        img_avatar = cc.Sprite:create(avatar_path)
        img_avatar_frame = cc.Sprite:create(avatar_frame_path)

        if img_avatar ~= nil and img_avatar_frame ~= nil and size == nil then
            size = img_avatar_frame:getContentSize()
        end
    end

    if size == nil then
        size = cc.size(80, 80)
    end

    local node = display.newNode()
    node:setAnchorPoint(display.CENTER)
    node:setContentSize(size)
    node.avatarData = nil
    node.avatar_pathType = avatarPathType

    if img_avatar ~= nil then
        img_avatar:move(size.width / 2, size.height / 2):addTo(node)
    end
    local avatar = newAvatarNode(path, size.width, isCircle, 0):move(size.width / 2, size.height / 2):addTo(node)
    if img_avatar_frame ~= nil then
        img_avatar_frame:move(size.width / 2, size.height / 2):addTo(node)
    end

    function node:setData(args)
        self.avatarData = args
    end

    function node:updateAvatar(aPath)
        if avatar ~= nil then
            local path = getPath(aPath, self.avatar_pathType)
            avatar:updateAvatar(path)
        end
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
        if IsLocationInNode(target, location) then
            PlazaManager.playClickEffect()

            if callback == nil then
                --[[
                if isOpenBigAvater == true then
                    -- 默认放大图片
                    if avatar ~= nil then
                        local spriteFrame = avatar:getSprFrame()
                        if spriteFrame ~= nil then
                            local avatarWin = require("app.win.ZoomAvatarWin").new(spriteFrame)
                            if avatarWin ~= nil then
                                local x = (display.width - avatarWin:getContentSize().width) / 2
                                local y = (display.height - avatarWin:getContentSize().height) / 2
                                avatarWin:move(x, y):addTo(display.getRunningScene(), 100)
                            end
                        end
                    end
                end
                --]]
                return true
            else
                return callback(node.avatarData)
            end
        end
        return false
    end

    -- if callback ~= nil then
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)
    -- end

    return node
end

function GameUtil.newSprite(path)
    return SFUtils.newSprite(path)
end

function GameUtil.createButton(img_normal, img_press, onClicked, loadType, animation, img_Enabled)
    if img_normal == nil then
        return nil
    end

    local function onClickedCallBack(ref)
        -- 播放点击音效
        PlazaManager.playClickEffect()
        -- 回调
        if onClicked ~= nil then
            onClicked(ref)
        end
    end

    local btn = nil
    if img_press ~= nil then
        if loadType == nil then
            btn = ccui.Button:create(img_normal, img_press, img_Enabled)
        else
            btn = ccui.Button:create(img_normal, img_press, img_Enabled, loadType)
        end
    else
        if loadType == nil then
            btn = ccui.Button:create(img_normal)
        else
            btn = ccui.Button:create(img_normal, nil, nil, loadType)
        end
        if btn ~= nil then
            btn:setZoomScale(-0.1)
        end
    end

    btn:addClickEventListener(onClickedCallBack)

    return btn
end

function GameUtil.createTouchButton(img_normal, img_press, onTouchEvent, loadType)
    if img_normal == nil and img_press == nil then
        return nil
    end

    local function onTouchCallBack(ref, event)
        -- 播放点击音效
        if event == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
        end
        -- 回调
        if onTouchEvent ~= nil then
            onTouchEvent(ref, event)
        end
    end

    local btn = nil
    if img_press ~= nil then
        if loadType == nil then
            btn = ccui.Button:create(img_normal, img_press)
        else
            btn = ccui.Button:create(img_normal, img_press, nil, loadType)
        end
    else
        if loadType == nil then
            btn = ccui.Button:create(img_normal)
        else
            btn = ccui.Button:create(img_normal, nil, nil, loadType)
        end
        if btn ~= nil then
            btn:setZoomScale(-0.1)
        end
    end

    btn:addTouchEventListener(onTouchCallBack)

    return btn
end

function GameUtil.createLabel(text, fontSize, color, anchorPos, pos, fontName, txtSize, halignment, valignment, bold, isShowEmoji, node)
    -- 字体
    if fontName == nil then
        fontName = GameDefine.FontName
    end

    if color == nil then
        color = cc.WHITE
    end

    -- 横
    local h_align = cc.TEXT_ALIGNMENT_LEFT
    if type(halignment) == "string" then
        if halignment == "center" then
            h_align = cc.TEXT_ALIGNMENT_CENTER
        elseif halignment == "right" then
            h_align = cc.TEXT_ALIGNMENT_RIGHT
        end
    end

    -- 纵
    local v_align = cc.VERTICAL_TEXT_ALIGNMENT_TOP
    if type(valignment) == "string" then
        if valignment == "center" then
            v_align = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
        elseif valignment == "buttom" then
            v_align = cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM
        end
    end

    local txt_Size = cc.size(0, 0)
    if txtSize == nil then
        txt_Size = cc.size(0, 0)
    else
        local width = txtSize.width
        local height = txtSize.height

        txt_Size = cc.size(width, height)
    end

    local lbl = nil
    if isShowEmoji == true then
        lbl = cc.Label:createWithSystemFont(text, fontName, fontSize, txt_Size, h_align, v_align)
    else
        lbl = cc.Label:createWithTTF(text, fontName, fontSize, txt_Size, h_align, v_align)
    end

    if color then
        lbl:setColor(color)
    end
    if anchorPos then
        lbl:setAnchorPoint(anchorPos)
    end
    if pos then
        lbl:setPosition(pos)
    end
    if bold ~= nil and bold == true then
        lbl:enableBold()
    end
    if node then
        node:addChild(lbl)
    end
    -- if outline == nil then outline = 1 end
    --   if outline ~= -1 then
    --      lbl:enableOutline(cc.c4b(0, 0, 0, 255), outline)
    --   end
    return lbl
end

-- 创建文字滚动控件
function GameUtil.createHorn(width)
    local size = cc.size(width == nil and 700 or width, 40)
    local node = display.newNode()
    node:setContentSize(size)
    node.currentSelect = 1
    node.msgStrList = {}

    display.newSprite("app/common/img_horn.png"):move(size.width / 2, size.height / 2):addTo(node)
    display.newSprite("app/common/icon_horn.png"):move(5, size.height / 2):addTo(node)

    local msgSize = cc.size(size.width, 43)
    local cliper = cc.ClippingNode:create()
    cliper:setContentSize(msgSize)
    cliper:setPosition(25, 0)
    node:addChild(cliper)

    local drawNode = cc.DrawNode:create()
    local drawPos = {display.LEFT_BOTTOM, cc.p(msgSize.width, 0), cc.p(msgSize.width, msgSize.height), cc.p(0, msgSize.height)}
    local color = cc.c4f(1, 1, 1, 1)
    drawNode:drawSolidPoly(drawPos, 4, color)
    cliper:setStencil(drawNode)

    local lbl = GameUtil.createLabel("", 26, cc.WHITE)
    lbl:setAnchorPoint(display.LEFT_CENTER)
    lbl:setPosition(msgSize.width, msgSize.height / 2)
    lbl:setName("movelbl")
    cliper:addChild(lbl)

    function node:setString(msgList)
        if (msgList == nil or #msgList == 0) then
            return
        end
        node.msgStrList = msgList
        node.currentSelect = 1

        cliper:removeChildByName("movelbl")
        local curlbl = GameUtil.createLabel(node.msgStrList[node.currentSelect], 26, cc.WHITE, display.LEFT_CENTER, cc.p(msgSize.width, msgSize.height / 2))
        curlbl:setName("movelbl")
        cliper:addChild(curlbl)
    end

    local speed = 100.0
    local function onUpdate(dt)
        if #node.msgStrList > 0 then -- 开始滚动
            local x = cliper:getChildByName("movelbl"):getPositionX() - dt * speed
            cliper:getChildByName("movelbl"):setPositionX(x)
            local lblSize = cliper:getChildByName("movelbl"):getContentSize()
            if x + lblSize.width < 0 then
                node.currentSelect = (node.currentSelect + 1) % (#node.msgStrList + 1)
                if node.currentSelect == 0 then
                    node.currentSelect = 1
                end
                cliper:removeChildByName("movelbl")
                local curlbl = GameUtil.createLabel(node.msgStrList[node.currentSelect], 26, cc.WHITE, display.LEFT_CENTER, cc.p(msgSize.width, msgSize.height / 2))
                curlbl:setName("movelbl")
                cliper:addChild(curlbl)
            end
        end
    end

    node:scheduleUpdateWithPriorityLua(onUpdate, 1)

    return node
end

function GameUtil.getHttpJsonData(strPost, url, params, callback)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

    if strPost == "GET" then
        xhr:open(strPost, url)
    elseif strPost == "POST" then
    end

    local function onReadyStateChanged(args)
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response = xhr.response -- 获得响应数据
            local ok, datatable
            if response then
                ok, datatable = pcall(function()
                    return json.decode(response)
                end)

                if not ok then
                    datatable = nil
                end
            end

            if type(callback) == "function" then
                callback(datatable)
            end
        else
            if type(callback) == "function" then
                callback(nil)
            end
        end
    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
end

-- 判断是否不合法字符串
function GameUtil.isChineseString(msg)
    local result = false
    local len = #msg

    if len == 0 then
        return result
    end

    for i = 1, len do
        local curByte = string.byte(msg, i)
        if curByte < 0 or curByte > 127 then
            result = true
            break
        end
    end
    return result
end

--
function GameUtil.subStringFromUTF8(msg, len, isCharCount, isShow)
    local result = msg
    local msgLen = #msg

    if msgLen == 0 then
        return ""
    end

    local byteCount = 0
    local charCount = 0

    for i = 1, msgLen do
        local curByte = string.byte(msg, i)

        if curByte > 0 and curByte <= 127 then
            byteCount = byteCount + 1
            charCount = charCount + 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = byteCount + 2
            charCount = charCount + 1
        elseif curByte >= 224 and curByte < 239 then
            byteCount = byteCount + 3
            charCount = charCount + 1
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = byteCount + 4
            charCount = charCount + 1
        end

        if isCharCount == nil or isCharCount == true then
            if charCount == len then
                if i < msgLen then
                    if isShow == nil or isShow == true then
                        result = string.sub(msg, 1, byteCount) .. "..."
                    else
                        result = string.sub(msg, 1, byteCount)
                    end
                else
                    result = string.sub(msg, 1, byteCount)
                end
            end
        else
            if byteCount == len then
                result = string.sub(msg, 1, byteCount)
            end
        end
    end

    return result
end

-- 删除字符串中的空格
function GameUtil.reomveString(str, remove)
    local lcSubStrTab = {}
    while true do
        if #str == 0 then
            break
        end
        local lcPos = string.find(str, remove)
        if not lcPos then
            lcSubStrTab[#lcSubStrTab + 1] = str
            break
        end
        local lcSubStr = string.sub(str, 1, lcPos - 1)
        lcSubStrTab[#lcSubStrTab + 1] = lcSubStr
        str = string.sub(str, lcPos + 1, #str)
    end
    local lcMergeStr = ""
    local lci = 1
    while true do
        if lcSubStrTab[lci] then
            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]
            lci = lci + 1
        else
            break
        end
    end
    return lcMergeStr
end

-- 解析ip地址
function GameUtil.int2ip(data)
    local result = ""
    if data ~= nil and type(data) == "number" then
        local ip1 = bit.band(data, 0xFF)

        local data_8 = bit.rshift(data, 8)
        local ip2 = bit.band(data_8, 0xFF)

        local data_16 = bit.rshift(data, 16)
        local ip3 = bit.band(data_16, 0xFF)

        local data_24 = bit.rshift(data, 24)
        local ip4 = bit.band(data_24, 0xFF)

        result = string.format("%d.%d.%d.%d", ip1, ip2, ip3, ip4)
    end
    return result
end

function GameUtil.formatAsset(val, isG32)
    return Utils.formatAsset(val, isG32)
end

function GameUtil.getChineNumStr(num)
    if not LangCtrl:isCN() then
        return tostring(num)
    end

    local numStr = tostring(num)
    if (numStr == nil or numStr == "") then
        return ""
    end
    if (numStr == "0") then
        return "零"
    end

    local szChMoney = ""
    local szNum = 0
    local iLen = 0
    local iNum = 0
    local iAddZero = 0
    local hzUnit = {"", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千"}
    local hzNum = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}

    szNum = tonumber(numStr)
    if nil == szNum or szNum == "." or szNum == "0" or szNum == "+" or szNum == "-" then
        return ""
    end

    iLen = string.len(numStr)

    if iLen > 15 or iLen == 0 or szNum < 0 then
        return ""
    end

    for i = 1, iLen do
        iNum = string.sub(szNum, i, i)
        if iNum == "0" then
            iAddZero = iAddZero + 1
            local pos = iLen - i + 1
            if ((pos == 5 or pos == 9 or pos == 13 or pos == 17) and iAddZero < 4) then
                szChMoney = szChMoney .. hzUnit[pos]
            end
        else
            if iAddZero > 0 then
                szChMoney = szChMoney .. hzNum[1]
            end

            szChMoney = szChMoney .. hzNum[iNum + 1] .. hzUnit[iLen - i + 1] -- //转换为相应的数字
            iAddZero = 0
        end
    end

    return szChMoney
end

function GameUtil.getShowNumStr(num)
    local numStr = tostring(math.abs(num))
    local len = string.len(numStr)
    local count = math.floor((len - 1) / 4)

    local showStr = ""
    for i = 1, count do
        if showStr ~= "" then
            showStr = string.sub(numStr, len - i * 4 + 1, len - i * 4 + 4) .. "," .. showStr
        else
            showStr = string.sub(numStr, len - i * 4 + 1, len - i * 4 + 4)
        end
    end
    if len > 4 and (len - count * 4) > 0 then
        showStr = string.sub(numStr, 1, len - count * 4) .. "," .. showStr
    elseif len <= 4 then
        showStr = numStr
    end

    if num < 0 then
        showStr = "-" .. showStr
    end
    return showStr
end

-- 身份证验证
--[[检验身份证号码真伪算法: 
17位加权因子:7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2  
检验码:{ "1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2" } 
算法:身份证前17位号码每位和相应位加权因子相乘,然后累加; 
得数MOD 11后的值就是校验码的索引值;  
]]
function GameUtil.IDVerification(idcard)
    if idcard == nil or string.len(idcard) ~= 18 then
        return false
    end

    -- // wi =2(n-1)(mod 11)
    local wi = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1}
    -- // verify digit
    local vi = {"1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"}

    local function isBirthDate(date)
        local year = tonumber(date:sub(1, 4))
        local month = tonumber(date:sub(5, 6))
        local day = tonumber(date:sub(7, 8))
        if year < 1900 or year > 2100 or month > 12 or month < 1 then
            return false
        end
        -- //月份天数表
        local month_days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        local bLeapYear = (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
        if bLeapYear then
            month_days[2] = 29
        end

        if day > month_days[month] or day < 1 then
            return false
        end

        return true
    end

    local function isAllNumberOrWithXInEnd(str)
        local ret = str:match("%d+X?")
        return ret == str
    end

    local function checkSum()
        local nums = {}
        local _idcard = idcard:sub(1, 17)
        for ch in _idcard:gmatch "." do
            table.insert(nums, tonumber(ch))
        end
        local sum = 0
        for i, k in ipairs(nums) do
            sum = sum + k * wi[i]
        end

        return vi[sum % 11 + 1] == idcard:sub(18, 18)
    end

    local function verifyIDCard()
        if not isAllNumberOrWithXInEnd(idcard) then
            return false
        end
        -- //第1-2位为省级行政区划代码，[11, 65] (第一位华北区1，东北区2，华东区3，中南区4，西南区5，西北区6)
        local nProvince = tonumber(idcard:sub(1, 2))
        if (nProvince < 11 or nProvince > 65) then
            return false
        end

        -- //第3-4为为地级行政区划代码，第5-6位为县级行政区划代码因为经常有调整，这块就不做校验

        -- //第7-10位为出生年份；//第11-12位为出生月份 //第13-14为出生日期
        if not isBirthDate(idcard:sub(7, 14)) then
            return false
        end

        if not checkSum(idcard) then
            return false
        end

        return true
    end

    local result = false
    result = verifyIDCard()
    return result
end

function GameUtil.runEaseInAction(target, pos, runTime, callback)
    if target ~= nil and pos ~= nil then
        if runTime == nil then
            runTime = 0.1
        end

        local move_ease_in = cc.EaseSineIn:create(cc.MoveTo:create(runTime, pos))
        local action = nil
        if callback ~= nil then
            action = cc.Sequence:create(move_ease_in, cc.CallFunc:create(callback))
        else
            action = cc.Sequence:create(move_ease_in)
        end

        target:runAction(action)
    end
end

function GameUtil.getSystemTime()
    local time = game.getSystemTime()
    return time
end

-- 设置竖版  vertical
function GameUtil.changeRootView_V()
    ChangeRootView.changeRootViewV()
    display.changeRootView(true, false)
end

-- 设置横版  horizontal
function GameUtil.changeRootView_H(isScreenFit)
    ChangeRootView.changeRootViewH()
    display.changeRootView(false, false)
end

-- 设置游戏是否全屏
function GameUtil.setGameScreenFit(isScreenFit)
    local result = false
    if isScreenFit ~= nil and type(isScreenFit) == "boolean" then
        result = isScreenFit
    end
    print("设置游戏是否全屏")
    print(isScreenFit)
    display.setGameScreenFit(result)
end

-- 测试打印csb节点树下所有子节点的名称
function GameUtil.printNodeTree(num, gap, node)
    if node.getString then
        print(num, gap, node:getName(), " = ", node:getString())
    else
        print(num, gap, node:getName())
    end

    local list = node:getChildren()
    if #list > 0 then
        for k, v in ipairs(list) do
            GameUtil.printNodeTree(num + 1, gap .. " -- ", v)
        end
    end
end

-- "app/hall/top/img_avatar.png" 这文件也是为老版本跟新所保留
-- 老版本热跟新时需要这个接口，无老版本时可以删除了
function GameUtil.createScaleButton(img_normal, img_press, scaleNum, imgPos, loadType, onTouchEvent)
    local showbtn = nil
    if loadType == nil then
        showbtn = ccui.ImageView:create(img_normal)
    else
        showbtn = ccui.ImageView:create(img_normal, loadType)
    end
    local function onClickbtnNode(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            if img_press ~= nil then
                if loadType == nil then
                    showbtn:loadTexture(img_press)
                else
                    showbtn:loadTexture(img_press, loadType)
                end
            else
                showbtn:setScale(1.2)
            end
        end

        if eventtype == ccui.TouchEventType.ended or eventtype == ccui.TouchEventType.canceled then
            if loadType == nil then
                showbtn:loadTexture(img_normal)
            else
                showbtn:loadTexture(img_normal, loadType)
            end
            showbtn:setScale(1)
        end

        if eventtype == ccui.TouchEventType.ended then
            if onTouchEvent ~= nil then
                onTouchEvent(sender)
            end
        end
    end

    local sszz = showbtn:getContentSize()
    local sw, sh = sszz.width * scaleNum, sszz.height * scaleNum

    local btnView = ccui.Layout:create()
    btnView:setContentSize(sw, sh)
    btnView:setTouchEnabled(true)
    btnView:addTouchEventListener(onClickbtnNode)

    if imgPos == nil then
        showbtn:align(display.CENTER, sw / 2, sh / 2):addTo(btnView)
    else
        showbtn:align(display.CENTER, imgPos.x, imgPos.y):addTo(btnView)
    end
    return btnView
end

function GameUtil.addEnlargeBtn(img_normal, scaleNum, onTouchEvent)
    local showbtn = ccui.ImageView:create(img_normal)

    local function onClickbtnNode(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            showbtn:setScale(0.9)
        end

        if eventtype == ccui.TouchEventType.ended or eventtype == ccui.TouchEventType.canceled then
            showbtn:setScale(1)
        end

        if eventtype == ccui.TouchEventType.ended then
            if onTouchEvent ~= nil then
                onTouchEvent(sender)
            end
        end
    end

    local sszz = showbtn:getContentSize()
    local sw, sh = sszz.width * scaleNum, sszz.height * scaleNum
    local btnView = ccui.Layout:create()
    btnView:setContentSize(sw, sh)
    btnView:setTouchEnabled(true)
    btnView:addTouchEventListener(onClickbtnNode)

    showbtn:align(display.CENTER, sw / 2, sh / 2):addTo(btnView)
    return btnView
end

function GameUtil.addBtnSprite(str, parent)
    local icon = cc.Sprite:create(str)
    parent:getVirtualRenderer():addChild(icon)
    return icon
end

function GameUtil.addBtnTTF0(str, parent, size)
    local lbl = cc.Label:createWithTTF(str, "fonts/fzz.ttf", size)
    lbl:setColor(cc.c3b(0xb2, 0xa6, 0x92)) -- baa692
    -- lbl:enableOutline(cc.c4b(0, 0, 0, 122), 1) -- 按钮描边颜色 --cc.c4b(132, 77, 24, 255)
    parent:getVirtualRenderer():addChild(lbl)
    return lbl
end

function GameUtil.addBtnTTF1(str, parent, size)
    local lbl = cc.Label:createWithTTF(str, "fonts/fzz.ttf", size)
    lbl:setColor(cc.c3b(0x4e, 0x30, 0x18))
    -- lbl:enableOutline(cc.c4b(0, 0, 0, 122), 1)
    parent:getVirtualRenderer():addChild(lbl)
    return lbl
end

function GameUtil.addBtnTTF2(str, parent, x, y)
    local lbl = cc.Label:createWithTTF(str, "fonts/fzcy.ttf", 35)
    -- lbl:setColor(cc.c3b(72, 42, 16))
    lbl:setColor(cc.c3b(247, 254, 236))
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(x or 108, y or 32)
    lbl:enableOutline(cc.c4b(132, 77, 24, 255), 2) -- 按钮描边颜色
    parent:getVirtualRenderer():addChild(lbl)
    return lbl
end

function GameUtil.addTitleTTF(str, parent)
    local lbl = cc.Label:createWithTTF(str, "fonts/fzcs.ttf", 35)
    lbl:setColor(cc.c3b(255, 240, 165))
    lbl:setAnchorPoint(display.CENTER)
    local ss = parent:getContentSize()
    lbl:setPosition(ss.width / 2, ss.height / 2 - 2)
    lbl:enableOutline(cc.c4b(94, 26, 5, 255), 1) -- 标题描边颜色
    parent:addChild(lbl)
    return lbl
end

function GameUtil.newBlankBtn(parent, size, cbf)
    local btn = ccui.Button:create("app/common/blank.png")
    btn:setZoomScale(-0.1);
    btn:setScale9Enabled(true)
    btn:setCapInsets(cc.rect(1, 1, 2, 2))
    btn:setContentSize(size)
    btn:addTo(parent)
    btn:addClickEventListener(cbf)
    return btn
end

function GameUtil.newDarkLightBtn(parent, btnidx, btnstr, btnsize, fontsize, cbf, sc)
    local btn, lbl, newSize
    local btnres = "app/common/button/btn_dark.png"
    if btnidx == 2 then
        btnres = "app/common/button/btn_light.png"
    end

    if sc then
        newSize = cc.size(btnsize.width * sc, btnsize.height * sc)
        btn = GameUtil.newBlankBtn(parent, newSize, cbf)

        local bg_1 = ccui.Scale9Sprite:create(btnres)
        bg_1:setCapInsets(cc.rect(12, 12, 3, 12))
        bg_1:setContentSize(btnsize)
        bg_1:align(display.CENTER, newSize.width / 2, newSize.height / 2)
        btn:getVirtualRenderer():addChild(bg_1)
    else
        newSize = btnsize
        btn = ccui.Button:create(btnres)
        btn:setZoomScale(-0.1);
        btn:setScale9Enabled(true)
        btn:setCapInsets(cc.rect(12, 12, 3, 12)) -- 27 36
        btn:setContentSize(btnsize)
        btn:addTo(parent)
        btn:addClickEventListener(cbf)
    end

    lbl = cc.Label:createWithTTF(btnstr, "fonts/fzz.ttf", fontsize)
    lbl:setColor(cc.c3b(255, 255, 213))
    -- lbl:enableOutline(cc.c4b(0, 0, 0, 122), 1)
    btn:getVirtualRenderer():addChild(lbl)
    lbl:align(display.CENTER, newSize.width / 2, newSize.height / 2)

    return btn
end

function GameUtil.convFntToTTF(fntNode, lblstr, fontsize, ox, oy)
    local x, y = fntNode:getPosition()
    local parent = fntNode:getParent()
    local lbl = cc.Label:createWithTTF(lblstr, "fonts/fzcy.ttf", fontsize)
    -- lbl:setColor(cc.WHITE)
    -- lbl:enableOutline(cc.c4b(0, 0, 0, 122), 1)
    parent:addChild(lbl)
    lbl:align(display.CENTER, x + (ox or 0), y + (oy or 0))
    fntNode:removeFromParent()
    return lbl
end

function GameUtil.convImgToTTF(img, lblstr, fsize)
    local x, y = img:getPosition()
    local parent = img:getParent()

    local lbl = cc.Label:createWithTTF(lblstr, "fonts/fzcs.ttf", fsize)
    lbl:setColor(cc.c3b(255, 240, 165))
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(x, y)
    lbl:enableOutline(cc.c4b(94, 26, 5, 255), 1) -- 描边颜色
    parent:addChild(lbl)
    img:removeFromParent()
    return lbl
end

function GameUtil.parseMultMsg(str)
    if type(str) ~= "string" then
        return str
    end

    local list = string.split(str, "|||")
    local ret = list[1]
    if LangCtrl:isEng() and list[2] and list[2] ~= "" then
        ret = list[2]
    end
    if ret == nil or ret == "" then
        ret = str
    end

    return ret
end

function GameUtil.filterMultMsg(str, bNo)
    if type(str) ~= "string" then
        return nil
    end

    local ret = nil
    if str and str ~= "" then
        local list = string.split(str, "|||")
        if LangCtrl:isCN() then
            if list[1] and list[1] ~= "" then
                ret = list[1]
            else
                print("========>cn msg str:", str)
            end
        else
            if list[2] and list[2] ~= "" then
                ret = list[2]
            else
                print("========>en msg str:", str)
            end
        end

        if ret == nil and bNo ~= 1 then
            ret = "~~~~（>_<）~~~~"
        end
    end

    return ret
end

function GameUtil.copyMagicToken(str)
    if not PlazaManager.isPhoneAndPadPlatform() then
        print("skip! is not phone!")
        return
    end
    local magicToken = "RUBB￥￥娱乐+888元$Huoejlksowej&ladjolasd767$复制此口令->打开RBB>>娱乐"
    game.systemCopy(magicToken)
    PlazaManager.showTips("复制成功，快去粘贴给好友吧！")
end

function GameUtil.readMagicToken()
    if not PlazaManager.isPhoneAndPadPlatform() then
        print("skip! is not phone!")
        return
    end

    local readStr = game.systemPaste()
    print("read magic token:", readStr)
    game.systemCopy("")
    return readStr
end

function GameUtil.openAppByIdx(appidx)
    if PlazaManager.platform == cc.PLATFORM_OS_ANDROID then
        local tStr = {
            [1] = {"com.tencent.mm", "com.tencent.mm.ui.LauncherUI"},
            [2] = {"com.tencent.mobileqq", "com.tencent.mobileqq.activity.SplashActivity"}
        }
        local packageName = tStr[appidx][1]
        local mainActivity = tStr[appidx][2]
        local result = game.isInstalledApp(packageName)
        if result then
            game.onRunOtherAPP(packageName, mainActivity)
        else
            PlazaManager.showTips("App未安装")
        end
    elseif PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD then
        local tStr = {
            [1] = "weixin://",
            [2] = "mqq://"
        }
        local name = tStr[appidx]
        local result = game.isInstalledApp(name)
        if result then
            game.onStartApp(name, "", "")
        else
            PlazaManager.showTips("App未安装")
        end
    else
        print("skip on win32!!")
    end
end
