-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHLKChip = class("FISHLKChip", function(fileName)
    return cc.Sprite:create(fileName)
end)

local function getRes(path)
    return "game/fishlk/res/" .. path
end

function FISHLKChip:ctor(fileName, nMaxHeight, color, score)
    self.nMaxHeight = nMaxHeight
    self.nHeight = 0
    self.color = color
    self.score = score
    self:setTextureRect(cc.rect(0, 0, self:getContentSize().width, self.nHeight))
    self.scheduleID = nil
    self.scheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 0, false)
end

function FISHLKChip:closeScheduleID()
    if self.scheduleID then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleID)
        self.scheduleID = nil
    end
end

function FISHLKChip:update(delta)
    if self.nHeight >= self.nMaxHeight then
        self:closeScheduleID()
        self:setTextureRect(cc.rect(0, 0, self:getContentSize().width, self.nMaxHeight))
        -- 分数
        local pScore = cc.LabelAtlas:create(tostring(self.score), getRes("cannon_num.png"), 10, 13, string.byte("0"))
        pScore:setAnchorPoint(display.CENTER_BOTTOM)
        pScore:setPosition(cc.p(self:getContentSize().width / 2 + pScore:getContentSize().width / 2, self:getContentSize().height))
        pScore:setZOrder(1)
        pScore:addTo(self)

        -- 分数背景色
        local pLayerColor = cc.LayerColor:create(self.color)
        pLayerColor:setContentSize(cc.size(pScore:getContentSize().width, pScore:getContentSize().height))
        pLayerColor:setPosition(cc.p(self:getContentSize().width / 2 - pLayerColor:getContentSize().width / 2, self:getContentSize().height))
        pLayerColor:addTo(self)
    end
    self.nHeight = self.nHeight + 6
    self:setTextureRect(cc.rect(0, 0, self:getContentSize().width, self.nHeight))
end

function FISHLKChip:setTextureHeightMax()
    self.nHeight = self.nMaxHeight
    self:setTextureRect(cc.rect(0, 0, self:getContentSize().width, self.nMaxHeight))
end

return FISHLKChip
-- endregion
