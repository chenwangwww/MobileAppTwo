--[[
JSFYSetting.lua

]] local JSFYSound = require("game.jsfy.src.JSFYSound")

local Switch = class("Switch")

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
    self.root_ = cc.CSLoader:createNode("game/jsfy/res/LayerSetting.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("Panel_bg")
    pnl:setContentSize(display.size)

    self.imgBg_ = self.root_:getChildByName("image_bg")
    self.imgBg_:move(display.center)
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.15,
        scale = 1.0
    }

    local lbl = self.imgBg_:getChildByName("Text_3_effect")
    lbl:setString(SubLang:word(6))
    local xx = lbl:getPositionX() - 5
    lbl:setPositionX(xx)
    lbl = self.imgBg_:getChildByName("Text_music")
    lbl:setString(SubLang:word(5))
    local xx = lbl:getPositionX() - 5
    lbl:setPositionX(xx)

    self.switchMusic_ = Switch.new(self.imgBg_:getChildByName("CheckBox_music"))
    self.switchMusic_:addClickCallback(function()
        local off = MusicManager.getMusicVal() == 0
        MusicManager.setBGMVolume(off and 100 or 0)
        self:setMusic(not off)
    end)
    self.switchEffect_ = Switch.new(self.imgBg_:getChildByName("CheckBox_effect"))
    self.switchEffect_:addClickCallback(function()
        local off = MusicManager.getEffectVal() == 0
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
    self.imgBg_:getChildByName("Button_close"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local JSFYSetting = class("JSFYSetting")

function JSFYSetting:ctor()

end

function JSFYSetting:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = SettingUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function JSFYSetting:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return JSFYSetting
