local InputPassWinUI = class("InputNumPassNode", require("app.win.base.GameWindowWinBase"))

function InputPassWinUI:ctor()
    local winSize = cc.size(842, 648)
    InputPassWinUI.super.ctor(self, LangCtrl:getLang().word123, true, false, winSize)
    self:setName("InputPassWinUI")

    local inputlen = 760
    local gap = inputlen / 6
    local startx = self.midWidth - (inputlen / 2) + (gap / 2)
    local posY = self.winSize.height - 120

    self.lbl_pass = {}
    for i = 1, 6 do
        local posx = startx + gap * (i - 1)
        local imggap = ccui.ImageView:create("app/win/bank/img_shurukuang.png")
        imggap:setPosition(posx, posY)
        self.panelNode:addChild(imggap)

        local lbl_pass = GameUtil.createLabel("", 60, GameDefine.FontColor_edit, display.CENTER, cc.p(posx, posY - 15)):addTo(self.panelNode)
        -- lbl_pass:setAdditionalKerning(40)
        self.lbl_pass[i] = lbl_pass
    end

    GameUtil.createLabel(LangCtrl:getLang().word124, 20, GameDefine.FontColor, display.CENTER, cc.p(self.midWidth, posY - 55)):addTo(self.panelNode)

    local buttonName = {"1", "2", "3", "4", "5", "6", "7", "8", "9", LangCtrl:getLang().word125, "0", LangCtrl:getLang().word126}

    self.passValus = {}
    self.passCount = 0
    local function setPassString()
        for i = 1, self.passCount do
            self.lbl_pass[i]:setString("*")
        end

        for i = self.passCount + 1, 6 do
            self.lbl_pass[i]:setString("")
        end
    end
    local function onNumItemClicked(itemNode)
        local i = itemNode.itemValue
        local isMide = false
        if 1 <= i and i <= 9 then
            if self.passCount < 6 then
                self.passCount = self.passCount + 1
                self.passValus[self.passCount] = tostring(i)
                isMide = true
            end
        elseif i == 10 then
            self.passCount = 0
            isMide = true
        elseif i == 11 then
            if self.passCount < 6 then
                self.passCount = self.passCount + 1
                self.passValus[self.passCount] = tostring(0)
                isMide = true
            end
        elseif i == 12 then
            if self.passCount > 0 then
                self.passCount = self.passCount - 1
            end
            isMide = true
        end
        setPassString()
        if self.passCount == 6 and isMide == true then
            -- 向服务器发送登录命令
            local passStr = ""
            for i = 1, self.passCount do
                passStr = passStr .. tostring(self.passValus[i])
            end
            self:sendLoginBankMessage(passStr)
        end
    end

    inputlen = 810
    gap = inputlen / 3
    startx = (self.winSize.width - inputlen + gap) / 2
    for i = 1, 12 do
        local posx = startx + gap * ((i - 1) % 3)
        local posy = self.winSize.height - 250 - 110 * math.floor((i - 1) / 3)
        local itemBtn = GameUtil.createButton("app/win/bank/bnt_bxxmm.png", nil, onNumItemClicked)
        itemBtn:align(display.CENTER, posx, posy):addTo(self.panelNode)
        itemBtn.itemValue = i

        local txtnum = cc.Label:createWithTTF(buttonName[i], "app/fonts/fzcy.ttf", 50)
        txtnum:align(display.CENTER, 128, 51)
        txtnum:setColor(cc.c3b(250, 255, 255))
        txtnum:enableOutline(cc.c3b(0x0c, 0x28, 0x8e), 3)
        txtnum:addTo(itemBtn:getVirtualRenderer())
    end

    self:addCloseBtn()
end

function InputPassWinUI:onEnter()
    InputPassWinUI.super.onEnter(self)

    self:addEvent()
end

function InputPassWinUI:onExit()
    self:removeEvent()
    InputPassWinUI.super.onExit(self)
end

function InputPassWinUI:onClearUp()
    self:disableNodeEvents()
    InputPassWinUI.super.onClearUp(self)
end

function InputPassWinUI:addEvent()
    self.eventData = {}
    self.eventData.onLogonBankSucc = function()
        self:onLogonBankSucc()
    end -- 绑定手机号成功

    game.registerEvent(GameDefine.Bank_Back_LogonSucc, self.eventData.onLogonBankSucc)
end

function InputPassWinUI:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_LogonSucc, self.eventData.onLogonBankSucc)
end

-- 0-没有密码，1-数字密码,2-手势密码
function InputPassWinUI:sendLoginBankMessage(passStr)
    if PlazaManager.bankPassType == 0 and passStr ~= "000000" then
        PlazaManager.showTips(LangCtrl:getLang().word127)
        return
    end
    local mdPassStr = game.md5(passStr)

    local data = {}
    data.passType = 1
    data.passStr = mdPassStr

    PlazaManager.bankPassType = 1
    PlazaManager.bankPassStr = mdPassStr
    PlazaManager.bankOpenType = 1
    PlazaManager.bankIsLogonSucc = false

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word100, LangCtrl:getLang().word101)
    end
    PlazaManager.getLoginModule().onLoginBank(data, onConnectResult)
end

function InputPassWinUI:onLogonBankSucc()
    self:removeFromParent()
end

return InputPassWinUI
