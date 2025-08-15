local Layout = require "app.components.Layout"
local Buttons = require "app.components.Buttons"
local SFUtils = require "app.components.SpriteFrameUtils"

local _M = {}

local lblColor = cc.c3b(80, 75, 75)

function _M.delSpace(s)
    assert(type(s) == "string")
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function _M.getGameTypeName(gameType)
    local types = {
        [game.GAME_TYPE_DouDiZhu] = _M.getLGString("doudizhu"),
        [game.GAME_TYPE_DouNiu] = _M.getLGString("douniu"),
        [game.GAME_TYPE_JinHua] = _M.getLGString("zajinhua"),
        [game.GAME_TYPE_MJ_ShaoYang] = _M.getLGString("sy_mahjong"),
        [game.GAME_TYPE_ZP_ShaoYang] = _M.getLGString("sy_zipai")
    }

    return types[gameType]
end

-- type 1 天小时分钟 type 2 
function _M.formatTime(seconds, type)
    if type == nil then
        type = 2
    end

    local s = seconds % 60
    local m = math.floor((seconds / 60)) % 60
    local h = math.floor((seconds / 3600)) % 24
    local day = math.floor((seconds / (3600 * 24)))

    if type == 1 then
        return string.format("%02d:%02d:%02d", h, m, s)
    elseif type == 2 then
        if day > 0 then
            return string.format("%d%s %02d:%02d", day, _M.getLGString("day"), h, m)
        else
            return string.format("%02d:%02d", h, m)
        end
    end
end

function _M.formatAsset(val, isG32)
    if not LangCtrl:isCN() then
        return tostring(val)
    end

    if val == nil then
        return val
    end
    local valStr = tostring(val)
    if isG32 == nil then
        isG32 = true
    end
    if isG32 then
        if math.abs(val) > 99999999 then
            if string.sub(valStr, #valStr - 7, #valStr - 6) == "00" then
                valStr = string.format("%s亿", string.sub(valStr, 1, #valStr - 8))
            else
                valStr = string.format("%s.%s亿", string.sub(valStr, 1, #valStr - 8), string.sub(valStr, #valStr - 7, #valStr - 6))
            end
        elseif math.abs(val) > 9999 then
            if string.sub(valStr, #valStr - 3, #valStr - 2) == "00" then
                valStr = string.format("%s万", string.sub(valStr, 1, #valStr - 4))
            else
                valStr = string.format("%s.%s万", string.sub(valStr, 1, #valStr - 4), string.sub(valStr, #valStr - 3, #valStr - 2))
            end
        end
    else
        local val_ = val
        if val_ < 0 then
            valStr = tostring(math.abs(val_))
        end
        local len = #valStr
        local valStrs = {}
        local idx = 0
        for i = len, 1, -1 do
            if idx % 3 == 0 then
                valStrs[#valStrs + 1] = ""
            end
            idx = idx + 1

            valStrs[#valStrs] = string.sub(valStr, i, i) .. valStrs[#valStrs]
        end

        local newStr = nil
        for _, v in ipairs(valStrs) do
            if newStr == nil then
                newStr = v
            else
                newStr = v .. "," .. newStr
            end
        end
        if val < 0 then
            newStr = "-" .. newStr
        end
        return newStr
    end
    return valStr
end

function _M.getUTF8Length(text)
    local tab = {}
    for uchar in string.gfind(text, "[%z\1-\127\194-\244][\128-\191]*") do
        tab[#tab + 1] = uchar
    end

    return #tab
end

function _M.subUTF8String(text, len)
    local tab = {}
    for uchar in string.gfind(text, "[%z\1-\127\194-\244][\128-\191]*") do
        tab[#tab + 1] = uchar
    end
    local str = ""
    local idx = 0
    for i, v in ipairs(tab) do
        local curByte = string.byte(v, 1)

        if curByte > 0 and curByte <= 127 then
            idx = idx + 1
        else
            idx = idx + 2
        end

        str = str .. v
        if idx >= len then
            break
        end
    end
    return str
end

function _M.newLabel(text, fontSize, color, anchorPos, pos, node, outline, fontName, contentSize)
    -- if fontName == nil then fontName = GameDefine.FontName end
    if fontName == nil then
        fontName = ""
    end
    if contentSize == nil then
        contentSize = cc.size(0, 0)
    end
    local lbl = cc.Label:createWithSystemFont(text, fontName, fontSize, contentSize)
    if lbl == nil then
        printError("创建失败Label")
    end

    if outline == nil then
        outline = -1
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
    if node then
        node:addChild(lbl)
    end

    if outline ~= -1 then
        lbl:enableOutline(cc.c4b(0, 0, 0, 255), outline)
    end
    return lbl
end

function _M.newBmfLabel(str, path, anchorPos, pos, parent)
    local bmFont = cc.Label:createWithBMFont(path, str)
    if anchorPos then
        bmFont:setAnchorPoint(anchorPos)
    end
    if pos then
        bmFont:setPosition(pos)
    end
    if parent then
        parent:addChild(bmFont)
    end
    return bmFont
end

function _M.newIconVal(icon, val, color, fontSize)
    local sp = display.newSprite(icon)
    if fontSize == nil then
        fontSize = 24
    end
    local lbl = _M.newLabel(val, fontSize, color or lblColor, display.LEFT_CENTER)

    local spSize = sp:getContentSize()
    local lblSize = lbl:getContentSize()

    local size = cc.size(spSize.width + lblSize.width + 5, math.max(spSize.height, lblSize.height))
    local node = display.newNode()
    node:setContentSize(size)

    sp:align(display.LEFT_CENTER, 0, size.height / 2):addTo(node)

    lbl:setPosition(spSize.width + 5, size.height / 2)
    node:addChild(lbl)

    function node:setString(val)
        lbl:setString(val)

        lblSize = lbl:getContentSize()
        local size = cc.size(spSize.width + lblSize.width + 5, math.max(spSize.height, lblSize.height))
        node:setContentSize(size)
    end

    return node
end

function _M.newAsset(icon, val, color, isSimple, fontSize)
    return _M.newIconVal(icon, _M.formatAsset(val, isSimple), color, fontSize)
end

function _M.drawNodeRoundRect(rect, radius, color)
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
    tagCenter.x = minX + radius;
    tagCenter.y = maxY - radius;

    for i = 0, segments do
        local x = tagCenter.x - vertices[i + 1].x
        local y = tagCenter.y + vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右上角
    tagCenter.x = maxX - radius;
    tagCenter.y = maxY - radius;

    for i = 0, segments do
        local x = tagCenter.x + vertices[#vertices - i].x
        local y = tagCenter.y + vertices[#vertices - i].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 右下角
    tagCenter.x = maxX - radius;
    tagCenter.y = minY + radius;

    for i = 0, segments do
        local x = tagCenter.x + vertices[i + 1].x
        local y = tagCenter.y - vertices[i + 1].y

        table.insert(pPolygonPtArr, cc.p(x, y))
    end

    -- 左下角
    tagCenter.x = minX + radius;
    tagCenter.y = minY + radius;

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

function _M.newAvatarNode(path, width, isCircle, circleAgn)
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
            if isCircle or circleAgn > 0 then
                local cliper = cc.ClippingNode:create();
                cliper:setContentSize(size)
                local drawNode = nil
                local color = cc.c4f(1, 1, 1, 1)
                if isCircle then
                    drawNode = cc.DrawNode:create()
                    drawNode:drawSolidCircle(cc.p(size.width / 2, size.height / 2), size.width / 2, 360, 100, color)
                else
                    drawNode = _M.drawNodeRoundRect(cc.rect(0, 0, size.width, size.width), circleAgn, color)
                end
                cliper:setStencil(drawNode)

                spriteAvatar:move(size.width / 2, size.height / 2):addTo(cliper)
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(scale)

                node:addChild(cliper)
            else
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(width / avatarSize.width)
                spriteAvatar:move(size.width / 2, size.height / 2)
                spriteAvatar:addTo(node)
            end
        end

        if path == nil or #path == 0 or path == " " then
            path = "app/common/icon/icon_1.png"
        end

        node:removeAllChildren()
        if string.sub(path, 1, 4) ~= "http" then
            avatarSp = cc.Sprite:create(path)
            if avatarSp ~= nil then
                addAvatar(avatarSp)
            end
        else
            game.fileDownload(path, false, function(succ, localPath)
                if succ then
                    if _remove == true then
                        return
                    end
                    if cc.FileUtils:getInstance():isFileExist(localPath) and cc.FileUtils:getInstance():getStringFromFile(localPath) == "" then
                        cc.FileUtils:getInstance():removeFile(localPath)
                    end
                    avatarSp = cc.Sprite:create(localPath)
                    if avatarSp ~= nil then
                        addAvatar(avatarSp)
                    else
                        print("创建头像失败")
                    end
                end
            end, nil, false)
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

function _M.IsLocationInNode(node, loc)
    local pos = node:convertToNodeSpace(loc)
    local s = node:getContentSize()
    local rect = cc.rect(0, 0, s.width, s.height)
    return cc.rectContainsPoint(rect, pos)
end

-- args ={format="path", num=5, fps=15, loop=0}
function _M.newFrameSprite(format, num, fps, loop, callback, isSpriteFrame, isReverse)
    if fps == nil then
        fps = 15
    end
    if loop == nil then
        loop = 0
    end
    if isReverse == nil then
        isReverse = false
    end

    local currFrame = isReverse and num or 1
    local currdt = 0.0

    local sp = SFUtils.newSprite(string.format(format, currFrame), isSpriteFrame)
    local time = 1.0 / fps

    function sp:skipFrame(num)
        currFrame = num
        local imgstr = string.format(format, currFrame)

        if isSpriteFrame then
            sp:setSpriteFrame(imgstr)
        else
            sp:setTexture(imgstr)
        end
    end

    function sp:run()
        self:stop()
        self:scheduleUpdateWithPriorityLua(function(dt)
            currdt = currdt + dt
            if currdt < time then
                return
            end
            currdt = currdt - time

            if not isReverse then
                if currFrame == num then
                    if loop == 1 then
                        self:unscheduleUpdate()
                        if callback then
                            self:runAction(cc.CallFunc:create(function()
                                callback(self)
                            end))
                        end
                        return
                    end

                    if loop > 0 then
                        loop = loop - 1
                    end

                    currFrame = 1
                else
                    currFrame = currFrame + 1
                end
            else
                if currFrame == 1 then
                    if loop == 1 then
                        self:unscheduleUpdate()
                        if callback then
                            callback(self);
                        end
                        return
                    end

                    if loop > 0 then
                        loop = loop - 1
                    end

                    currFrame = num
                else
                    currFrame = currFrame - 1
                end
            end

            self:skipFrame(currFrame)
        end, 1)
    end

    function sp:stop()
        self:unscheduleUpdate()
    end

    sp:run()

    return sp
end

function _M.equalTile(tile1, tile2)
    return tile1[1] == tile2[1] and tile1[2] == tile2[2]
end

function _M.getMonthMaxDay(year, month)
    local days = 0
    if month == 2 then
        if (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0) then
            days = 29
        else
            days = 28
        end
    else
        if month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12 then
            days = 31
        else
            days = 30
        end
    end
    return days
end

-- fontInfo {name,size, defColor, selColor} collWay = {isAbsPad, pad}
function _M.newCheckBox(defImg, selImg, text, fontInfo, onChange)
    if fontInfo.selColor == nil then
        fontInfo.selColor = fontInfo.defColor
    end

    local isSpriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(defImg)

    local sp = SFUtils.newSprite(defImg, isSpriteFrame)

    local lbl = _M.newLabel(text, fontInfo.size, fontInfo.defColor, nil, nil, nil, 1, fontInfo.name)

    local spSize = sp:getContentSize()
    local lblSize = lbl:getContentSize()
    local w = spSize.width + lblSize.width + 10
    local h = math.max(spSize.height, lblSize.height)

    local node = display.newNode()
    node:setContentSize(cc.size(w, h)):setAnchorPoint(display.CENTER)

    sp:align(display.LEFT_CENTER, 0, h / 2):addTo(node)
    lbl:align(display.LEFT_CENTER, spSize.width + 10, h / 2):addTo(node)

    local isChecked = false

    local btn = Buttons.createButton(true, 0.9, onChange)
    Buttons.initButtonWithNode(btn, node)

    function btn:setChecked(val)
        if val == isChecked then
            return
        end
        isChecked = val

        lbl:setColor(isChecked and fontInfo.selColor or fontInfo.defColor)

        if isSpriteFrame then
            sp:setSpriteFrame(isChecked and selImg or defImg)
        else
            sp:setTexture(isChecked and selImg or defImg)
        end
    end

    function btn:isChecked()
        return isChecked
    end

    return btn
end

-- fontInfo {name,size, defColor, selColor} collWay = {ismult, isAbsPad, pad, chkIdxs}
function _M.newCheckBoxList(defImg, selImg, texts, fontInfo, collWay, onChecked)
    local nodes = {}

    local function onChangeChk(chk)
        if collWay.ismult then
            chk:setChecked(not chk:isChecked())
        else
            if chk:isChecked() then
                return
            end
            for _, v in ipairs(nodes) do
                v:setChecked(v == chk)
            end
        end

        if onChecked then
            onChecked(chk)
        end
    end

    for i, v in ipairs(texts) do
        nodes[i] = _M.newCheckBox(defImg, selImg, v, fontInfo, onChangeChk)
        nodes[i]:setTag(i)
    end

    local node = nil
    if collWay.isAbsPad then
        node = display.newNode()

        local h = 0
        for i, v in ipairs(nodes) do
            h = math.max(h, v:getContentSize().height)
        end

        node:setContentSize(cc.size(collWay.pad * #nodes, h))

        for i, v in ipairs(nodes) do
            v:align(display.LEFT_CENTER, (i - 1) * collWay.pad, h / 2):addTo(node)
        end
    else
        node = Layout.createHBox(nodes, collWay.pad)
    end

    if collWay.chkIdxs ~= nil then
        for _, v in ipairs(collWay.chkIdxs) do
            onChangeChk(nodes[v])
        end
    end

    return node
end

function _M.setCascadeOpacityEnabled(node, val)
    node:setCascadeOpacityEnabled(val)

    local nodes = node:getChildren()
    for _, v in ipairs(nodes) do
        _M.setCascadeOpacityEnabled(v, val)
    end
end

function _M.copyAppResToWritablePath(dir)
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        local storagePath = cc.FileUtils:getInstance():getWritablePath() .. ".qlngame/"
        local androidDir = storagePath .. "res/" .. dir
        if cc.FileUtils:getInstance():isDirectoryExist(androidDir) == false then
            if not cc.FileUtils:getInstance():isDirectoryExist(androidDir) then
                cc.FileUtils:getInstance():createDirectory(androidDir)
            end
            game.copyDirectory("src/base/res/" .. dir, androidDir)
        end
    end
end

function _M.stringSplit(str, delimiter)
    if str == nil or str == "" or delimiter == nil then
        return nil
    end

    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function _M.newAvatarNodeHead(path, width, isCircle, circleAgn)
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
            if isCircle or circleAgn > 0 then
                local cliper = cc.ClippingNode:create();
                cliper:setContentSize(size)
                local drawNode = nil
                local color = cc.c4f(1, 1, 1, 1)
                if isCircle then
                    drawNode = cc.DrawNode:create()
                    drawNode:drawSolidCircle(cc.p(size.width / 2, size.height / 2), size.width / 2, 360, 100, color)
                else
                    drawNode = _M.drawNodeRoundRect(cc.rect(0, 0, size.width, size.width), circleAgn, color)
                end
                cliper:setStencil(drawNode)

                spriteAvatar:move(size.width / 2, size.height / 2):addTo(cliper)
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(scale)

                node:addChild(cliper)
            else
                local avatarSize = spriteAvatar:getContentSize()
                local scale = math.max(size.width / avatarSize.width, size.width / avatarSize.height)
                spriteAvatar:setScale(width / avatarSize.width)
                spriteAvatar:move(size.width / 2, size.height / 2)
                spriteAvatar:addTo(node)
            end
        end

        if path == nil or #path == 0 or path == " " then
            path = "app/common/icon/icon_1.png"
        end

        node:removeAllChildren()
        if string.sub(path, 1, 4) ~= "http" then
            avatarSp = cc.Sprite:create(path)
            if avatarSp ~= nil then
                addAvatar(avatarSp)
            end
        else
            game.fileDownloadHead(path, false, function(succ, localPath)
                if succ then
                    if _remove == true then
                        return
                    end
                    --               if cc.FileUtils:getInstance():isFileExist(localPath) and cc.FileUtils:getInstance():getStringFromFile(localPath) == "" then
                    --                  cc.FileUtils:getInstance():removeFile(localPath)
                    --               end
                    avatarSp = cc.Sprite:create(localPath)
                    if avatarSp ~= nil then
                        addAvatar(avatarSp)
                    else
                        print("创建头像失败")
                    end
                end
            end)
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

return _M

