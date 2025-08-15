--[[
TBNNSetting.lua

]] local TBNNSound = require("game.tbnn.src.TBNNSound")

local SettingUI = class("SettingUI", function()
    return cc.Node:create()
end)

function SettingUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/tbnn/res/SetLayer.csb")
    self.root_:addTo(self)
    self.root_:setContentSize(display.size)

    self.panel_ = self.root_:getChildByName("SetPanel")
    self.panel_:move(display.center)

    self.sldMusic_ = self.panel_:getChildByName("MusicSliderBut")
    self.sldMusic_:addEventListener(function(pSender, eventtype)
        if eventtype == 0 then
            local volume = pSender:getPercent()
            MusicManager.setBGMVolume(volume)
        end
    end)
    self.sldEffect_ = self.panel_:getChildByName("SoundSliderBut")
    self.sldEffect_:addEventListener(function(pSender, eventtype)
        if eventtype == 0 then
            local volume = pSender:getPercent()
            MusicManager.setEffectVolume(volume)
        end
    end)

    self.sldMusic_:setPercent(MusicManager.getMusicVal())
    self.sldEffect_:setPercent(MusicManager.getEffectVal())
end

function SettingUI:addCloseCallback(callback)
    self.panel_:getChildByName("CloseBut"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local TBNNSetting = class("TBNNSetting")

function TBNNSetting:ctor()

end

function TBNNSetting:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = SettingUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function TBNNSetting:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return TBNNSetting
