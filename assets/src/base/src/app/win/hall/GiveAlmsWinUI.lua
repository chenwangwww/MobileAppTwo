-- 领取救济金
local GiveAlmsWinUI = class("GiveAlmsWinUI", require("app.win.base.GameWindowBase"))

function GiveAlmsWinUI:ctor(data, noGiveChk)
    local size = cc.size(680, 500)
    self.super.ctor(self, size, true, false)
    self:setName("GiveAlmsWinUI")

    self:addBasePanel()
    -- self:addPanelBg()
    self:addCloseBtn()

    local bg_icon = ccui.ImageView:create("app/win/givealms/icon_jjj.png")
    bg_icon:align(display.LEFT_CENTER, 100, 270):addTo(self.panelNode)

    if noGiveChk == true then
        self:initViewNo()
    else
        self:initView(data)
    end
end

function GiveAlmsWinUI:initView(data)
    local function onClickLinqu(args)
        PlazaManager.getRefreshModule().onSearchUserGold()
        self:removeFromParent()
    end
    local bg_num = ccui.ImageView:create("app/win/givealms/img_jjj.png")
    bg_num:align(display.RIGHT_CENTER, self.winSize.width - 80, 270):addTo(self.panelNode)

    local timeStr = string.format(LangCtrl:getLang().word292, data.lRemainCount)
    local lbl = GameUtil.createLabel(timeStr, 24, cc.c3b(0xc8, 0xad, 0x6a), display.LEFT_CENTER, cc.p(100, 95)):addTo(self.panelNode)
    lbl:setMaxLineWidth(300)
    lbl:setLineBreakWithoutSpace(false)

    local btn_ok = GameUtil.createButton("app/common/button/btn1.png", nil, onClickLinqu):move(500, 100):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word293, btn_ok)
end

function GiveAlmsWinUI:initViewNo()
    local function onClickOk(args)
        self:removeFromParent()
    end

    local timeStr = string.format(LangCtrl:getLang().word294)
    local lbl_1 = GameUtil.createLabel(timeStr, 28, cc.c3b(0xc8, 0xad, 0x6a), display.RIGHT_CENTER, cc.p(self.winSize.width - 80, 220), nil, cc.size(260, 200)):addTo(self.panelNode)
    lbl_1:setLineHeight(40)
    lbl_1:setAdditionalKerning(3)

    local btn_ok = GameUtil.createButton("app/common/button/btn1.png", nil, onClickOk):move(self.midWidth, 100):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_ok) -- 确定
end

function GiveAlmsWinUI:onExit()
    PlazaManager.getRefreshModule().onSearchUserGold()
    self.super.onExit(self)
end

function GiveAlmsWinUI:onEnter()
    self.super.onEnter(self)

    self.panelNode:setScale(0.5)
    self.panelNode:runAction(cc.ScaleTo:create(0.2, 1.0))
end

function GiveAlmsWinUI:onClearUp()
    self:disableNodeEvents()
    self.super.onClearUp(self)
end

return GiveAlmsWinUI
