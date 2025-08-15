--[[
CSDSetting.lua

]] local CSDSound = require("game.csd.src.CSDSound")

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
    self.root_ = cc.CSLoader:createNode("game/csd/res/Setting.csb")
    self.root_:addTo(self)
    -- GameUtil.printNodeTree(1, " - ", self.root_)
    local pnl = self.root_:getChildByName("panel")
    pnl:setContentSize(display.size)

    self.imgBg_ = pnl:getChildByName("img_bg")
    self.imgBg_:move(display.center)
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.3,
        scale = 1.0
    }

    if LangCtrl:isEng() then
        local Image_1 = self.imgBg_:getChildByName("Image_1")
        GameUtil.convImgToTTF(Image_1, SubLang:word(4), 30)

        local Image_2 = self.imgBg_:getChildByName("Image_2")
        GameUtil.convImgToTTF(Image_2, SubLang:word(3), 30)
    end

    self.switchMusic_ = Switch.new(self.imgBg_:getChildByName("CheckMusic"))
    self.switchMusic_:addClickCallback(function()
        local off = MusicManager.getMusicVal() == 0
        CSDSound.setBGMVolume(off and 100 or 0)
        self:setMusic(not off)
    end)
    self.switchEffect_ = Switch.new(self.imgBg_:getChildByName("CheckEffect"))
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
    self.imgBg_:getChildByName("btn_close"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local CSDSetting = class("CSDSetting")

function CSDSetting:ctor()

end

function CSDSetting:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = SettingUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function CSDSetting:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return CSDSetting
