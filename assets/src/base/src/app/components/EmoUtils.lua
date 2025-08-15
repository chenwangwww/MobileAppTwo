local _M = {}

local Layout = require "app.components.Layout"
local Buttons = require "app.components.Buttons"
local Utils = require "app.components.Utils"
local PageView = require "app.components.PageView"

local EMO_TYPES = {"gif", "png", "jpg"}

function _M.getEmoType(emoPath)
    for _, v in ipairs(EMO_TYPES) do
        local e = string.match(emoPath, ".+%.(%w+)$")
        if e == v then
            return e
        end
    end
end

function _M.getEmoName(emoPath)
    return string.match(emoPath, ".+/([^/]*%.%w+)$")
end

function _M.getEmoCode(emoPath)
    local emoName = _M.getEmoName(emoPath)
    return string.gsub(emoName, "." .. _M.getEmoType(emoName), "")
end

-- type 0:预览 1:循环 2循环一次
function _M.newEmoNode(emoPath, type, width, height, callback)
    if string.find(emoPath, "/") == nil then
        emoPath = "app/emo/" .. emoPath
    end

    local node = display.newNode()

    local emoType = _M.getEmoType(emoPath)
    local sp = nil

    if emoType == "gif" then
        sp = game.createGifSprite(emoPath, type, callback)
    elseif emoType == "png" or emoType == "jpg" then
        sp = display.newSprite(emoPath)
        if (type == 2) then
            sp:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
                callback(node)
            end)))
        end
    end

    local spSize = sp:getContentSize()

    local size, scaleX, scaleY = nil, 1, 1
    if width ~= nil and height ~= nil then
        if width > display.width then
            width = display.width
        end

        scaleX, scaleY = width / spSize.width, height / spSize.height

        size = cc.size(width, height)
    elseif width ~= nil then
        if width > display.width then
            width = display.width
        end

        scaleX = width / spSize.width
        scaleY = scaleX

        size = cc.size(width, scaleY * spSize.height)
    elseif height ~= nil then
        scaleY = height / spSize.height
        scaleX = scaleY

        size = cc.size(scaleX * spSize.width, height)
    else
        size = spSize
    end

    sp:setScaleX(scaleX):setScaleY(scaleY)

    node:setContentSize(size)
    sp:align(display.CENTER, size.width / 2, size.height / 2):addTo(node)
    return node
end

-- emoFiles:{emoPath} size:cc.size(*, *) rowNum:*, gap:{col, row}, onClicked:function(idx, emoPath) end
function _M.newEmoListPanel(emoDir, size, rowNum, gap, onClicked)
    Utils.copyAppResToWritablePath(emoDir)

    local emoFiles = game.getDirFiles(emoDir)

    local eleWidth = (size.width - (gap.col * (rowNum - 1))) / rowNum
    local nodes = {}
    for i, v in ipairs(emoFiles) do

        local emoType = _M.getEmoType(v)
        if emoType == "png" or emoType == "jpg" or emoType == "gif" then
            local btn = Buttons.createButton(false, 0.9, function()
                onClicked(i, _M.getEmoName(v))
            end)
            local node = _M.newEmoNode(_M.getEmoName(v), 0, eleWidth, eleWidth)
            node:setAnchorPoint(display.CENTER)
            Buttons.initButtonWithNode(btn, node)
            nodes[#nodes + 1] = btn
            nodes[#nodes]:setAnchorPoint(display.CENTER)
        end
    end

    local container = Layout.createTBox("row", nil, rowNum, nodes, gap)

    local scrollView = cc.ScrollView:create()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scrollView:setViewSize(size)
    scrollView:setContainer(container)
    scrollView:setContentOffset(scrollView:minContainerOffset())

    return scrollView
end

local EMOJIS = {"🙂", "😄", "😃", "😀", "😊", "😉", "😍", "😘", "😚", "😗", "😙", "😜", "😝", "😛", "😳", "😁", "😔", "😌", "😒", "😞", "😣", "😢", "😂",
                "", "😪", "😥", "😰", "😅", "😓", "😩", "😫", "😨", "😱", "😠", "😡", "😤", "😖", "😆", "😋", "😷", "😎", "😴", "😵", "😲", "😟", "😦",
                "😧", "😈", "😮", "😬", "😐", "😕", "😯", "😶", "😇", "😏", "😑", "😺", "😸", "😻", "😼", "🙀", "😿", "😹", "😾", "👹", "👺", "👂", "🚩"}

function _M.newEmojiListPanel(size, rowNum, colNum, gap, onClicked)
    local eleWidth = (size.width - (gap.col * (colNum))) / colNum
    local pageCount = math.ceil(#EMOJIS * 1.0 / (rowNum * colNum))

    local function newPanel(page)
        local nodes = {}
        local startIdx = (page - 1) * rowNum * colNum + 1
        local endIdx = math.min(startIdx + rowNum * colNum - 1, #EMOJIS)

        for i = startIdx, endIdx, 1 do
            local btn = Buttons.createButton(false, 0.9, function()
                onClicked(EMOJIS[i])
            end)
            local node = cc.Label:createWithSystemFont(EMOJIS[i], "fonts/pingfang.ttf", 50)
            node:setAnchorPoint(display.CENTER)

            btn:setContentSize(cc.size(eleWidth, eleWidth))
            btn:setAnchorPoint(display.CENTER)
            node:align(display.CENTER, eleWidth / 2, eleWidth / 2):addTo(btn)

            nodes[#nodes + 1] = btn
        end

        local container = Layout.createTBox("row", nil, colNum, nodes, gap, {
            left = gap.col / 2,
            right = gap.col / 2
        })
        return container
    end

    local function onInit(page, idx)
        local panel = newPanel(idx)
        panel:align(display.LEFT_TOP, 0, size.height):addTo(page)
    end

    local function onPageTurning(page, idx)
    end

    --- common/emojipage_%.png
    --- emojipage_1.png emojipage_1_light.png
    local pageView = PageView.create(size, cc.p(0, 50), "", pageCount, 0, onInit, onPageTurning)

    return pageView
end

return _M
