--[[
CSDHelp.lua

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

local HelpUI = class("HelpUI", function()
    return cc.Node:create()
end)

function HelpUI:ctor()
    self.root_ = cc.CSLoader:createNode("game/csd/res/Help.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("panel")
    pnl:setContentSize(display.size)

    self.imgBg_ = pnl:getChildByName("img_bg")
    self.imgBg_:move(display.center)
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.3,
        scale = 1.0
    }

    local function switchPageIcon(index)
        for i = 0, 3 do
            self.imgBg_:getChildByName("icon_" .. i):loadTexture(string.format("Img_Yuan%02d.png", i == index and 2 or 1), ccui.TextureResType.plistType)
        end
    end
    local pageView = self.imgBg_:getChildByName("help_page")
    pageView:addEventListener(function()
        switchPageIcon(pageView:getCurrentPageIndex())
    end)

    local function switchPageView(i)
        local targetIndex = pageView:getCurrentPageIndex() + i
        local num = #pageView:getItems()
        local nxtIndex = targetIndex >= num and 0 or (targetIndex < 0 and num - 1 or targetIndex)
        pageView:scrollToPage(nxtIndex)
        switchPageIcon(nxtIndex)
    end
    self.imgBg_:getChildByName("btn_right"):addClickEventListener(handler(1, switchPageView))
    self.imgBg_:getChildByName("btn_left"):addClickEventListener(handler(-1, switchPageView))
    pageView:scrollToPage(0)
end

function HelpUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("btn_close"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local CSDHelp = class("CSDHelp")

function CSDHelp:ctor()

end

function CSDHelp:show(parent)
    if not parent then
        return
    end
    self:close()

    self.ui_ = HelpUI.new()
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function CSDHelp:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return CSDHelp
