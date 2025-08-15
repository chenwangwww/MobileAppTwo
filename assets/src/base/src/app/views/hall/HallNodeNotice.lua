-- 公告
local HallNodeNotice = class("HallNodeNotice", function()
    return display.newNode()
end)

function HallNodeNotice:ctor(args)
    self.data = args
    self:setContentSize(cc.size(747, 34))
    self:align(display.CENTER_TOP, display.cx, display.height)
    self:initView()
end

function HallNodeNotice:initView()
    local bg_laba = ccui.Scale9Sprite:create("app/common/imgbglaba.png")
    bg_laba:setCapInsets(cc.rect(15, 15, 40 - 30, 34 - 30))
    bg_laba:setContentSize(747, 34)
    bg_laba:align(display.LEFT_BOTTOM, 0, 0):addTo(self)

    GameUtil.newSprite("app/common/xiaolaba.png", false):align(display.CENTER, 25, 17):addTo(self)

    local cliper = cc.ClippingNode:create()
    cliper:setContentSize(700, 34)
    cliper:align(display.LEFT_CENTER, 40, 17):addTo(self)

    local drawNode = cc.DrawNode:create()
    local drawPos = {display.LEFT_BOTTOM, cc.p(700, 0), cc.p(700, 34), cc.p(0, 34)}
    local color = cc.c4f(1, 1, 1, 1)
    drawNode:drawSolidPoly(drawPos, 4, color)
    cliper:setStencil(drawNode)

    local lbl = GameUtil.createLabel("", 24, cc.c3b(249, 251, 238), display.LEFT_CENTER, cc.p(350, 17))
    lbl:setName("movelbl")
    cliper:addChild(lbl)

    self.currentSelect = 1
    self.msgStrList = self:getRollingMsgList()

    if #self.msgStrList > 0 then
        lbl:setString(self.msgStrList[1])
    end

    local speed = 100.0
    local function onUpdate(dt)
        if self ~= nil and self.msgStrList ~= nil and #self.msgStrList > 0 then -- 开始滚动
            local x = cliper:getChildByName("movelbl"):getPositionX() - dt * speed
            cliper:getChildByName("movelbl"):setPositionX(x)

            local lblSize = cliper:getChildByName("movelbl"):getContentSize()

            if x + lblSize.width < 0 then
                self.currentSelect = (self.currentSelect + 1) % (#self.msgStrList + 1)
                if self.currentSelect == 0 then
                    self.currentSelect = 1
                    self.msgStrList = self:getRollingMsgList()
                end

                cliper:removeChildByName("movelbl")
                local showStr = self.msgStrList[self.currentSelect]
                local curlbl = GameUtil.createLabel(showStr, 24, cc.c3b(249, 251, 238), display.LEFT_CENTER, cc.p(700, 17))
                curlbl:setName("movelbl")
                cliper:addChild(curlbl)
            end
        end
    end

    self:scheduleUpdateWithPriorityLua(onUpdate, 1)
end

-- 获得滚动信息
function HallNodeNotice:getRollingMsgList()
    local msgList = {}
    for i = 1, #PlazaManager.GameWelcomeList do
        if PlazaManager.GameWelcomeList[i].msgState == 0 and PlazaManager.GameWelcomeList[i].wContentType == 3 then
            PlazaManager.GameWelcomeList[i].msgState = 1
            table.insert(msgList, PlazaManager.GameWelcomeList[i].szContent)
        end
    end

    if #msgList == 0 then
        local gameWelcomeList = {}
        for i = #PlazaManager.GameWelcomeList, 1, -1 do
            if PlazaManager.GameWelcomeList[i].wContentType == 3 then
                if #msgList <= 5 then
                    table.insert(msgList, PlazaManager.GameWelcomeList[i].szContent)
                    table.insert(gameWelcomeList, PlazaManager.GameWelcomeList[i])
                else
                    break
                end
            end
        end

        PlazaManager.GameWelcomeList = gameWelcomeList
    end

    if #msgList == 0 then
        table.insert(msgList, LangCtrl:getLang().word270)
    end
    return msgList
end

return HallNodeNotice

-- endregion
