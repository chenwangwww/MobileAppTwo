--[[
LHDBSetting.lua

]] local Switch = class("Switch")

Switch.Status = {
    ON = 1,
    OFF = 2
}

function Switch:ctor(root)
    self.root_ = root
end

function Switch:setStatus(status)
    local off = Switch.Status.OFF == status
    self.root_:setSelected(not off)
end

function Switch:addClickCallback(callback)
    self.root_:addEventListener(callback)
end

local SettingUI = class("SettingUI", function()
    return cc.Node:create()
end)

function SettingUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/lhdb/res/SetLayer.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("SetPanel")
    pnl:move(display.center)
    pnl:setContentSize(display.size)

    self.imgBg_ = pnl:getChildByName("ImgBg")
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.3,
        scale = 1.0
    }

    self.switchMusic_ = Switch.new(self.imgBg_:getChildByName("CheckMusic"))
    self.switchMusic_:addClickCallback(function()
        local off = MusicManager.getMusicVal() == 0
        MusicManager.setBGMVolume(off and 100 or 0)
        self:setMusic(not off)
    end)
    self.switchEffect_ = Switch.new(self.imgBg_:getChildByName("CheckEffect"))
    self.switchEffect_:addClickCallback(function()
        local off = MusicManager.getEffectVal() == 0
        dump(MusicManager.getEffectVal())
        MusicManager.setEffectVolume(off and 100 or 0)
        self:setEffect(not off)
    end)

    self:setMusic(MusicManager.getMusicVal() == 0)
    self:setEffect(MusicManager.getEffectVal() == 0)
end

function SettingUI:setMusic(off)
    self.switchMusic_:setStatus(off and Switch.Status.OFF or Switch.Status.ON)
end

function SettingUI:setEffect(off)
    self.switchEffect_:setStatus(off and Switch.Status.OFF or Switch.Status.ON)
end

function SettingUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("CloseBut"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local LHDBSetting = class("LHDBSetting")

function LHDBSetting:ctor()

end

function LHDBSetting:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = SettingUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function LHDBSetting:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return LHDBSetting
