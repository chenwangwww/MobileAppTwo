--[[
JDNNOperate.lua

]] local JDNNOperate = class("JDNNOperate")

JDNNOperate.Type = {
    OPEN_CARD = 0,
    READY = 1,
    AUTO = 2,
    ADD_SCORE = 3
}

JDNNOperate.State = {
    FREE = 0,
    READY = 1,
    ADD_SCORE = 2,
    DISPATCH = 3,
    COVER = 4,
    OPENED = 5
}

local AutoRateTex = {
    [1] = "Srnn_Auto_bt5.png",
    [2] = "Srnn_Auto_bt4.png",
    [4] = "Srnn_Auto_bt2.png",
    [8] = "Srnn_Auto_bt3.png"
}

local function init(self)
    self:showReady(false)
    self:showOpenCard(false)
    self:showAddScore(false)
end

function JDNNOperate:ctor(root, callback)
    self.root_ = root
    self.btnOpen_ = self.root_:getChildByName("btn_open")
    self.btnReady_ = self.root_:getChildByName("btn_ready")
    self.btnAuto_ = self.root_:getChildByName("btn_auto")
    self.pnlBet_ = self.root_:getChildByName("layerBet")

    self.btnAuto_:getChildByName("AutoRate"):hide():ignoreContentAdaptWithSize(true)
    init(self)
end

function JDNNOperate:addClickCallback(callback)
    self.btnReady_:addClickEventListener(function()
        if callback then
            callback(JDNNOperate.Type.READY)
            self.btnReady_:hide()
        end
    end)
    self.btnOpen_:addClickEventListener(function()
        if callback then
            callback(JDNNOperate.Type.OPEN_CARD)
            self.btnOpen_:hide()
        end
    end)
    self.btnAuto_:addClickEventListener(handler(JDNNOperate.Type.AUTO, callback))
    for i = 1, 4 do
        local btnMoney = self.pnlBet_:getChildByName("btnMoney" .. i)
        if btnMoney then
            btnMoney:addClickEventListener(function()
                callback(JDNNOperate.Type.ADD_SCORE, 2 ^ (i - 1))
            end)
        end
    end
end

function JDNNOperate:showReady(visible)
    self.btnReady_:setVisible(visible)
end

function JDNNOperate:showOpenCard(visible)
    self.btnOpen_:setVisible(visible)
end

function JDNNOperate:showAddScore(visible, ...)
    self.pnlBet_:setVisible(visible)
    if visible then
        local maxScore = ...
        for i = 1, 4 do
            local btnMoney = self.pnlBet_:getChildByName("btnMoney" .. i)
            if btnMoney then
                local money = math.ceil(maxScore / (2 ^ (i - 1)))
                btnMoney:getChildByName("txtMoney_tf"):setString(GameUtil.formatAsset(money, false))
            end
        end
    end
end

function JDNNOperate:showTrustee(isTrustee, ...)
    self.btnAuto_:loadTextureNormal(isTrustee and "NoHostingBut.png" or "HostingBut.png", ccui.TextureResType.plistType)
    local autoRate = self.btnAuto_:getChildByName("AutoRate"):hide()
    if isTrustee then
        local rate = ...
        if rate and AutoRateTex[rate] then
            autoRate:loadTexture(AutoRateTex[rate], ccui.TextureResType.plistType):show()
        end
    end
end

function JDNNOperate:onGameStart()
    init(self)
    self:setState(JDNNOperate.State.ADD_SCORE)
end

function JDNNOperate:onGameEnd()
    self:showReady(true)
    self:showOpenCard(false)
    self:showAddScore(false)
    self:setState(JDNNOperate.State.FREE)
end

function JDNNOperate:setState(state)
    self.operState_ = state
end

function JDNNOperate:getState()
    return self.operState_
end

return JDNNOperate
