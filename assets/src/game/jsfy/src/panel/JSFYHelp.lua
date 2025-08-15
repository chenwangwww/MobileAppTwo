--[[
JSFYHelp.lua

]] local HelpUI = class("HelpUI", function()
    return cc.Node:create()
end)

function HelpUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/jsfy/res/LayerRule.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("Panel_Bg")
    pnl:setContentSize(display.size)

    self.imgBg_ = self.root_:getChildByName("Image_Bg")
    self.imgBg_:move(display.center)
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.15,
        scale = 1.0
    }

    local pageView = self.imgBg_:getChildByName("PageView_Rule")
    local function switchPageView(i)
        local targetIndex = pageView:getCurrentPageIndex() + i
        local num = #pageView:getItems()
        local nxtIndex = targetIndex >= num and 0 or (targetIndex < 0 and num - 1 or targetIndex)
        pageView:scrollToPage(nxtIndex)
        -- switchPageIcon(nxtIndex)
    end
    self.imgBg_:getChildByName("Button_PageDown"):addClickEventListener(handler(1, switchPageView))
    self.imgBg_:getChildByName("Button_PageUp"):addClickEventListener(handler(-1, switchPageView))
    pageView:scrollToPage(0)
end

function HelpUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("Button_Back"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local JSFYHelp = class("JSFYHelp")

function JSFYHelp:ctor()

end

function JSFYHelp:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = HelpUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function JSFYHelp:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return JSFYHelp
