-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/6/7
-- 此文件由[BabeLua]插件自动生成
local Layout = require "app.components.Layout"

local NumKeyboardNode = class("NumKeyboardNode", function()
    return cc.Node:create()
end)

local keyboardExitChk = false
function NumKeyboardNode:getExitChk()
    return keyboardExitChk
end

local imgdatas = {{"btn_1_1.png", "btn_1_2.png", 1}, {"btn_2_1.png", "btn_2_2.png", 2}, {"btn_3_1.png", "btn_3_2.png", 3}, {"btn_4_1.png", "btn_4_2.png", 4}, {"btn_5_1.png", "btn_5_2.png", 5},
                  {"btn_6_1.png", "btn_6_2.png", 6}, {"btn_7_1.png", "btn_7_2.png", 7}, {"btn_8_1.png", "btn_8_2.png", 8}, {"btn_9_1.png", "btn_9_2.png", 9}, {"btn_back_1.png", "btn_back_2.png", 10},
                  {"btn_0_1.png", "btn_0_2.png", 0}, {"btn_del_1.png", "btn_del_2.png", 11}}

local function newNumPanel(onClicked)

    local function createEle(info)
        local eBtn = ccui.Button:create("app/win/numkeyboard/" .. info[1], "app/win/numkeyboard/" .. info[2])
        eBtn:addTouchEventListener(function(uiwidget, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                onClicked(info[3])
            end
        end)
        return eBtn
    end

    local nodes = {}
    for i, v in ipairs(imgdatas) do
        nodes[i] = createEle(v)
    end

    local panelNode = cc.Node:create()
    panelNode:setContentSize(750, 497)

    local image_bg_1 = ccui.ImageView:create("app/win/numkeyboard/bg_keyboard.png")
    image_bg_1:setAnchorPoint(display.LEFT_BOTTOM)
    image_bg_1:setPosition(0, 0)
    panelNode:addChild(image_bg_1)

    local node = Layout.createTBox("row", nil, 3, nodes, {
        row = 0,
        col = 0
    })
    node:setAnchorPoint(display.LEFT_BOTTOM)
    node:setPosition(2, 20)
    panelNode:addChild(node)
    return panelNode
end

function NumKeyboardNode:ctor(postionY, changeFunction, backFunction, deleteFunction, rootNode)
    keyboardExitChk = true
    self.changeFunction = changeFunction
    self.backFunction = backFunction
    self.deleteFunction = deleteFunction
    self.postionY = postionY
    self.rootNode = rootNode
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

    self.oldScenPositionX = self.rootNode:getPositionX()
    self.oldScenPositionY = self.rootNode:getPositionY()

    self:setContentSize(cc.size(750, 1334))

    if (self.postionY < 450) then
        self:setPosition(750 / 2, 1334 / 2 - (520 - self.postionY))
    else
        self:setPosition(750 / 2, 1334 / 2)
    end
    self:setAnchorPoint(display.CENTER)
    self.rootNode:addChild(self)

    local mask_btn = ccui.Button:create("app/win/numkeyboard/mask.png", "app/win/numkeyboard/mask.png")
    mask_btn:setScaleX(750 / 5)
    mask_btn:setScaleY(1334 / 5)
    mask_btn:setPosition(750 / 2, 1334 / 2)
    mask_btn:setAnchorPoint(display.CENTER)
    mask_btn:setOpacity(0)
    mask_btn:setSwallowTouches(false)
    mask_btn:addTouchEventListener(function(uiwidget, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            self:setVisible(false)
            local CallFuncAction = cc.CallFunc:create(function(sender)
                self.rootNode:setPosition(cc.p(self.oldScenPositionX, self.oldScenPositionY))
                keyboardExitChk = false
                if (self ~= nil) then
                    self:removeFromParent()
                end
            end)
            local Sequenc = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(self.oldScenPositionX, self.oldScenPositionY)), cc.DelayTime:create(0.8), CallFuncAction)
            self.rootNode:runAction(Sequenc)
            if (self.backFunction ~= nil) then
                self.backFunction()
            end
        end
    end)
    self:addChild(mask_btn)

    local function onClickNum(id)
        if id < 10 then
            if (self.changeFunction ~= nil) then
                self.changeFunction(id)
            end
        elseif id == 10 then
            if (self ~= nil) then
                self:setVisible(false)
                local CallFuncAction = cc.CallFunc:create(function(sender)
                    self.rootNode:setPosition(cc.p(self.oldScenPositionX, self.oldScenPositionY))
                    if (self.backFunction ~= nil) then
                        self.backFunction()
                    end
                    keyboardExitChk = false
                    if (self ~= nil) then
                        self:removeFromParent()
                    end
                end)
                local Sequenc = cc.Sequence:create(cc.MoveTo:create(0.2, cc.p(self.oldScenPositionX, self.oldScenPositionY)), CallFuncAction)
                self.rootNode:runAction(Sequenc)
            end

        elseif id == 11 then
            if (self.deleteFunction ~= nil) then
                self.deleteFunction()
            end
        end
    end

    local numPanel = newNumPanel(onClickNum):align(display.CENTER_BOTTOM, 750 / 2, 0)
    self:addChild(numPanel)

    if (self.postionY < 450) then
        self.rootNode:runAction(cc.MoveTo:create(0.2, cc.p(self.oldScenPositionX, self.oldScenPositionY + (520 - self.postionY))))
    end
end

function NumKeyboardNode:onEnter()

end

function NumKeyboardNode:onExit()

end

function NumKeyboardNode:cleanup()
    self:unregisterScriptHandler()
    keyboardExitChk = false
end
-----------------------------------------------------------
function NumKeyboardNode:setChangeFunction(changeFunction)
    self.changeFunction = changeFunction
end

function NumKeyboardNode:setBackFunction(backFunction)
    self.backFunction = backFunction
end

function NumKeyboardNode:setDeleteFunction(deleteFunction)
    self.deleteFunction = deleteFunction
end

return NumKeyboardNode

-- endregion
