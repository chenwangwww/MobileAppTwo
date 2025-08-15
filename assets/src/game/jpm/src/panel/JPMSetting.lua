local JPMSetting = class("JPMSetting", function()
    return cc.Node:create()
end)

local JPMSound = require("game.jpm.src.JPMSound")

function JPMSetting:ctor()
    self.root_ = cc.CSLoader:createNode("game/jpm/res/Setting.csb")
    self.root_:addTo(self)

    local panel = self.root_:getChildByName("Panel")
    self.uiMusic = panel:getChildByName("music");
    self.uiSound = panel:getChildByName("sound");

    local nicklbl = panel:getChildByName("Text_1")
    nicklbl:setText(globalUserInfo.szNickName)
    if LangCtrl:isEng() then
        local xx = nicklbl:getPositionX()
        nicklbl:setPositionX(xx + 30)
    end

    self.uiMusic:setSelected(MusicManager.getMusicVal() == 100)
    self.uiSound:setSelected(MusicManager.getEffectVal() == 100)
    self.uiMusic:addEventListenerCheckBox(function(t, r)
        JPMSound.click()
        local v = r == 0 and 100 or 0
        MusicManager.setBGMVolume(v)
    end)

    self.uiSound:addEventListenerCheckBox(function(t, r)
        JPMSound.click()
        local v = r == 0 and 100 or 0
        MusicManager.setEffectVolume(v)
    end)

    panel:getChildByName("btnClose"):addClickEventListener(handler(self, self.onClick))
end

function JPMSetting:onClick(e)
    JPMSound.click()
    self:removeFromParent()
end

return JPMSetting
