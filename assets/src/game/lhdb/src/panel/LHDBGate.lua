--[[
LHDBGate.lua

]] local PREFIX = "Game/LHDB/Scene/Level/"

local Gate = class("Gate")

Gate.Status = {
    UNSELECT = 1,
    SELECTED = 2,
    SELECTING = 3
}

function Gate:ctor(root, lvl)
    self.root_ = root
    self.lvl_ = lvl
end

function Gate:setStatus(status)
    self.root_:loadTexture(string.format(PREFIX .. "Img_Dian%02d.png", status), ccui.TextureResType.plistType)
    self.root_:getChildByName("arrow"):loadTexture(string.format(PREFIX .. "Img_JianTou%02d.png", status), ccui.TextureResType.plistType)
    self.root_:getChildByName("word"):loadTexture(string.format(PREFIX .. "img_level_%d_%d.png", self.lvl_, status), ccui.TextureResType.plistType)
end

-----------------------------------------------------------------------------------------------------------
local LHDBGate = class("LHDBGate")

local GATE_COUNT = 4

function LHDBGate:ctor(root)
    self.root_ = root

    self.gate_ = {}
    for i = 1, GATE_COUNT do
        self.gate_[i] = Gate.new(self.root_:getChildByName(string.format("level%02d", i)), i)
    end
    self:setGate(1)
end

local function setProgress(self, lvl)
    local percent = (lvl - 1) / (GATE_COUNT - 1) * 100
    self.root_:getChildByName("prg_jindu"):setPercent(percent)
end

function LHDBGate:setGate(lvl)
    if not lvl or type(lvl) ~= "number" then
        return
    end

    for i, gate in ipairs(self.gate_) do
        local status = lvl > i and Gate.Status.SELECTED or (lvl < i and Gate.Status.UNSELECT or Gate.Status.SELECTING)
        gate:setStatus(status)
    end
    setProgress(self, lvl)
end

return LHDBGate
