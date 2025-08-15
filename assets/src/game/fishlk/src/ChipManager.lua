-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishChip = require "game.fishlk.src.FISHLKChip"
local ChipManager = class("ChipManager", function()
    return cc.Layer:create()
end)

function ChipManager:ctor()
    self.bColor = true
    self.fTime = 0
    self.nCount = 0
    self.scheduleID = nil
    self.scheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update2), 0, false)
    self:enableNodeEvents()
end

function ChipManager:onExit()
    if self.scheduleID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID)
    end
end

function ChipManager:AddChip(score)
    self.nCount = self.nCount + 1
    if self.bColor == true then
        self.bColor = false
    else
        self.bColor = true
    end
    -- 分数背景色
    local color = cc.c4b(255, 0, 0, 255)
    if self.bColor == true then
        color = cc.c4b(0, 255, 0, 255)
    end

    -- 筹码高度
    local chipHeight = 0
    local index = score / 10000
    if index >= 0 and index <= 1 then
        chipHeight = 306 / 55 * 1
    elseif index >= 50 then
        chipHeight = 306 / 55 * 55
    else
        chipHeight = 306 / 55 * index
    end
    local pFishChip = FishChip.new("game/fishlk/res/chip.png", chipHeight, color, score)
    pFishChip:setAnchorPoint(display.LEFT_BOTTOM)
    pFishChip:setPosition(cc.p(self:getParent():getContentSize().width - pFishChip:getContentSize().width + self.nCount * pFishChip:getContentSize().width, 0))
    pFishChip:addTo(self)

    -- 最多保持3个筹码
    if self.nCount > 3 then
        for i = 1, self.nCount do
            local chips = self:getChildren()
            local chip = chips[i]
            chip:setTextureHeightMax()
        end
        local chips = self:getChildren()
        local chip = chips[1]
        self:removeChip(chip)
    end
end

function ChipManager:update2(delta)
    self.fTime = self.fTime + delta
    -- 每隔5秒销毁第一个筹码
    if self.fTime >= 5.0 then
        self.fTime = 0.0
        if self.nCount > 0 then
            local chips = self:getChildren()
            local chip = chips[1]
            self:removeChip(chip)
        end
    end
end

function ChipManager:removeChip(node)
    if node == nil then
        return
    end
    node:closeScheduleID()
    node:removeFromParent()
    self.nCount = self.nCount - 1
    -- 将每个筹码移动到最靠左
    for i = 1, self.nCount do
        local chips = self:getChildren()
        local chip = chips[i]
        local point = cc.p(chip:getPositionX() - chip:getContentSize().width, chip:getPositionY())
        local pmove = cc.MoveTo:create(0.5, point)
        chip:runAction(pmove)
    end
end
return ChipManager
-- endregion
