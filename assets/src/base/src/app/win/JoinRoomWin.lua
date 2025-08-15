-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/8/20
-- 此文件由[BabeLua]插件自动生成
local Buttons = require "app.components.Buttons"
local Utils = require "app.components.Utils"
local Layout = require "app.components.Layout"
local ScrollView = require "app.components.ScrollView"

local JoinRoomWin = class("JoinRoomWin", require("app.win.base.GameWindowBase"))

local function newInputPanel(onCompleted)
    local function newInput()
        local eSize = cc.size(96, 96)
        local eNode = display.newNode()
        eNode:setContentSize(eSize)

        display.newSprite("app/win/join_room/join_bg_input.png"):move(eSize.width / 2, 0):addTo(eNode)
        local lbl = Utils.newLabel("", 50, cc.WHITE, display.CENTER, cc.p(eSize.width / 2, eSize.height / 2), eNode, 1)

        function eNode:setString(str)
            lbl:setString(str)
        end

        function eNode:getString()
            return lbl:getString()
        end

        return eNode
    end

    local nodes = {}
    for i = 1, 6 do
        nodes[i] = newInput()
    end

    local node = Layout.createHBox(nodes, 5)

    local idx = 0
    function node:setNum(val)
        idx = idx + 1
        if idx > 6 then
            idx = 6;
            return
        end

        nodes[idx]:setString(val)
        if idx == 6 then
            local str = ""
            for _, v in ipairs(nodes) do
                str = str .. v:getString()
            end
            onCompleted(str)
        end
    end

    function node:delNum()
        if idx < 1 then
            return
        end

        nodes[idx]:setString("")
        idx = idx - 1
    end

    function node:clearNum()
        for _, v in ipairs(nodes) do
            v:setString("")
        end
        idx = 0
    end

    function node:getNum()
        local str = ""
        for _, v in ipairs(nodes) do
            if v:getString() ~= "" then
                str = str .. v:getString()
            end
        end
        return str
    end

    return node
end

local function newNumPanel(onClicked)
    local datas = {{"join_num_1.png", 1}, {"join_num_2.png", 2}, {"join_num_3.png", 3}, {"join_num_4.png", 4}, {"join_num_5.png", 5}, {"join_num_6.png", 6}, {"join_num_7.png", 7},
                   {"join_num_8.png", 8}, {"join_num_9.png", 9}, {"join_confirm.png", 10}, {"join_num_0.png", 0}, {"join_num_del.png", 11}}

    local function createEle(info)
        local eBtn = Buttons.createButton(true, 1, function()
            onClicked(info[2])
        end)
        Buttons.initButtonWithImage(eBtn, "app/win/join_room/" .. info[1])

        return eBtn
    end

    local nodes = {}
    for i, v in ipairs(datas) do
        nodes[i] = createEle(v)
    end

    local node = Layout.createTBox("row", nil, 3, nodes, {
        row = 0,
        col = 0
    })
    return node
end

function JoinRoomWin:ctor()
    local size = cc.size(603, 714)
    JoinRoomWin.super.ctor(self, size, true)

    local bg = display.newSprite("app/win/join_room/bg.png")
    bg:move(self.midWidth, self.midHeight):addTo(self)

    local function onInputComplete(strRoomID)
        PlazaManager.onJoinRoomByRoomID(strRoomID)
    end

    local inputPanel, numPanel = nil, nil

    local function onClickNum(idx)
        if idx < 10 then
            inputPanel:setNum(idx)
        elseif idx == 10 then
            self:onClose()
        elseif idx == 11 then
            inputPanel:delNum()
        end
    end

    inputPanel = newInputPanel(onInputComplete)
    inputPanel:align(display.CENTER_TOP, self.midWidth, size.height - 90):addTo(bg)

    numPanel = newNumPanel(onClickNum):align(display.CENTER_BOTTOM, self.midWidth, 40):addTo(bg)

    GameUtil.newSprite("app/win/join_room/img_title.png", false):move(300, 675):addTo(self)

    local function onCloseEvent(target)
        self:onClose()
    end
    GameUtil.createButton("app/win/common/btn_close_1.png", "app/win/common/btn_close_2.png", onCloseEvent):move(545, 672):addTo(self)
end

return JoinRoomWin

-- endregion
