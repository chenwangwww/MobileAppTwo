--[[
TBNNOperate.lua

]] local TBNNOperate = class("TBNNOperate")

TBNNOperate.Type = {
    OPEN_CARD = 0,
    READY = 1,
    AUTO = 2
}

TBNNOperate.State = {
    FREE = 0,
    READY = 1,
    DISPATCH = 2,
    COVER = 3,
    OPENED = 4
}

local function init(self)
    self:showReady(false)
    self:showOpenCard(false)
end

function TBNNOperate:ctor(root, callback)
    self.root_ = root
    self.btnOpen_ = self.root_:getChildByName("btn_open")
    self.btnReady_ = self.root_:getChildByName("btn_ready")
    self.btnAuto_ = self.root_:getChildByName("btn_auto")

    init(self)
end

function TBNNOperate:addClickCallback(callback)
    self.btnReady_:addClickEventListener(function()
        if callback then
            callback(TBNNOperate.Type.READY)
            self.btnReady_:hide()
        end
    end)
    self.btnOpen_:addClickEventListener(function()
        if callback then
            callback(TBNNOperate.Type.OPEN_CARD)
            self.btnOpen_:hide()
        end
    end)
    self.btnAuto_:addClickEventListener(handler(TBNNOperate.Type.AUTO, callback))
end

function TBNNOperate:showReady(visible)
    self.btnReady_:setVisible(visible)
end

function TBNNOperate:showOpenCard(visible)
    self.btnOpen_:setVisible(visible)
end

function TBNNOperate:showTrustee(isTrustee)
    self.btnAuto_:loadTextureNormal(isTrustee and "NoHostingBut.png" or "HostingBut.png", ccui.TextureResType.plistType)
end

function TBNNOperate:onGameStart()
    init(self)
    self:setState(TBNNOperate.State.DISPATCH)
end

function TBNNOperate:onGameEnd()
    self:showReady(true)
    self:showOpenCard(false)
    self:setState(TBNNOperate.State.FREE)
end

function TBNNOperate:setState(state)
    self.operState_ = state
end

function TBNNOperate:getState()
    return self.operState_
end

return TBNNOperate
