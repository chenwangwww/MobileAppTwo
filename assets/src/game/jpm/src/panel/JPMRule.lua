local JPMCenter = class("JPMCenter", function()
    return cc.Node:create()
end)

local JPMSound = require("game.jpm.src.JPMSound")

function JPMCenter:ctor()
    self.root_ = cc.CSLoader:createNode("game/jpm/res/Rule.csb")
    self.root_:addTo(self)

    self.pageView = self.root_:getChildByName("PageView")
    self.pageView:setCurrentPageIndex(0)
    local panel = self.root_:getChildByName("Panel");
    panel:getChildByName("btnLeft"):addClickEventListener(handler(self, self.onClick))
    panel:getChildByName("btnRight"):addClickEventListener(handler(self, self.onClick))
    panel:getChildByName("btnClose"):addClickEventListener(handler(self, self.onClick))
end

function JPMCenter:onClick(e)
    JPMSound.click();
    local tag = e:getTag()
    local idx = self.pageView:getCurrentPageIndex();
    if tag == 0 then
        if idx > 0 then
            self.pageView:scrollToPage(idx - 1)
        end
    elseif tag == 1 then
        if idx < 2 then
            self.pageView:scrollToPage(idx + 1)
        end
    elseif tag == 2 then
        self:removeFromParent()
    end
end

return JPMCenter
