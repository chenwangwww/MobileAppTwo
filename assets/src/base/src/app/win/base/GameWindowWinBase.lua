local GameWindowWinBase = class("GameWindowWinBase", require("app.win.base.GameWindowBase"))

function GameWindowWinBase:ctor(titleStr, showBg, isOpenBgClick, windowsSize)
    local winSize = cc.size(950, 590)
    if windowsSize ~= nil then
        winSize = cc.size(windowsSize.width, windowsSize.height)
    end
    GameWindowWinBase.super.ctor(self, winSize, showBg, isOpenBgClick)

    self:addBasePanel()
    -- self:addPanelBg()
    self:addPanelTitle(titleStr)
end

function GameWindowWinBase:onExit()
    GameWindowWinBase.super.onExit(self)
end

function GameWindowWinBase:onEnter()
    GameWindowWinBase.super.onEnter(self)

    self.panelNode:setScale(0.5)
    self.panelNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function GameWindowWinBase:onClearUp()
    GameWindowWinBase.super.onClearUp(self)
end

return GameWindowWinBase
