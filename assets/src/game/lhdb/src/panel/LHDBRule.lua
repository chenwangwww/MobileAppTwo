--[[
LHDBRule.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")

local RuleUI = class("RuleUI", function()
    return cc.Node:create()
end)

local PREFIX = "Game/LHDB/Scene/Help/"

local RuleItem = {
    RULE = 0,
    GOLD_POOL = 1,
    GATE_ONE = 2,
    GATE_TWO = 3,
    GATE_THREE = 4
}

local function initItemTouch(self)
    for k, item in pairs(self.ruleItem_) do
        item:addClickEventListener(function()
            self:selectItem(k)
        end)
    end
end

function RuleUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/lhdb/res/HelpLayer.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("Panel_1")
    pnl:move(display.center)
    pnl:setContentSize(display.size)

    self.imgBg_ = pnl:getChildByName("ImgBg")
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.3,
        scale = 1.0
    }

    self.ruleItem_ = {}
    for i = 0, 4 do
        self.ruleItem_[i] = self.imgBg_:getChildByName("BtnItem" .. i)
    end
    initItemTouch(self)
end

function RuleUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("BtnClose"):addClickEventListener(callback)
end

function RuleUI:selectItem(typ)
    typ = typ or RuleItem.RULE
    for k, item in pairs(self.ruleItem_) do
        local selected = k == typ
        item:setTouchEnabled(not selected)
        item:loadTextureNormal(PREFIX .. string.format("but_BiaoQian_%02d.png", selected and 2 or 1), ccui.TextureResType.plistType)
        item:getChildByName("text"):loadTexture(PREFIX .. string.format("ImgItem%d_%d.png", k, selected and 2 or 1), ccui.TextureResType.plistType)
    end
    self.imgBg_:getChildByName("Content"):loadTexture(GameCMD.RES_PATH .. "Scene/Help/" .. string.format("content_%d.jpg", typ))
end

-------------------------------------------------------------------------------------------------------------

local LHDBRule = class("LHDBRule")

LHDBRule.Item = RuleItem

function LHDBRule:ctor()

end

function LHDBRule:show(parent, ruleItem)
    if not parent then
        return
    end
    self:close()

    self.ui_ = RuleUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)

    self.ui_:selectItem(ruleItem)
end

function LHDBRule:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return LHDBRule
