--[[
LHDBGoldPool.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")

local PoolUI = class("PoolUI", function()
    return cc.Node:create()
end)

local PREFIX = "Game/LHDB/Scene/Help/"

function PoolUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/lhdb/res/JackpotList.csb")
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

    self.list_ = self.imgBg_:getChildByName("list_rank")
    self.model_ = self.list_:getChildByName("pnl_item")
    self.list_:setItemModel(self.model_) -- retain once
    self.list_:removeLastItem()
end

function PoolUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("BtnClose"):addClickEventListener(callback)
end

function PoolUI:addHelpCallback(callback)
    self.imgBg_:getChildByName("BtnHelp"):addClickEventListener(callback)
end

function PoolUI:loadBroadcasts(broadcasts)
    self.list_:removeAllItems()
    for i, broadcast in ipairs(broadcasts) do
        local clone = self.model_:clone()
        clone:getChildByName("txt_lottery"):setString(broadcast)
        self.list_:pushBackCustomItem(clone)
    end
end

-------------------------------------------------------------------------------------------------------------

local LHDBGoldPool = class("LHDBGoldPool")

LHDBGoldPool.Item = RuleItem
LHDBGoldPool.Broadcast = {}

function LHDBGoldPool:ctor()
end

local function loadBroadcast(self)
    if self.ui_ then
        self.ui_:loadBroadcasts(self.Broadcast)
    end
end

function LHDBGoldPool:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = PoolUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)

    loadBroadcast(self)
end

function LHDBGoldPool:addHelpCallback(callback)
    if self.ui_ then
        self.ui_:addHelpCallback(callback)
    end
end

function LHDBGoldPool:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

function LHDBGoldPool:addBroadcast(broadcast)
    table.insert(self.Broadcast, broadcast)
    while #self.Broadcast > 30 do
        table.remove(self.Broadcast, 1)
    end
    loadBroadcast(self)
end

return LHDBGoldPool
