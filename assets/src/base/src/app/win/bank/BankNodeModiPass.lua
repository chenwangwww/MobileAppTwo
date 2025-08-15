-- 修改密码
local BankNodeModiPass = class("BankNodeModiPass", function()
    return cc.Node:create()
end)

function BankNodeModiPass:ctor(bankui)
    self.winSize = bankui.rightSize
    self.midWidth = self.winSize.width / 2
    self.midHeight = self.winSize.height / 2
    self:enableNodeEvents()
    self:setName("BankNodeModiPass")
    self:setContentSize(self.winSize)
    self.newPassType = 1
    self.newPassStr = ""

    local img_bg_top = cc.Scale9Sprite:create("app/common/comwin/panel_2.png")
    img_bg_top:setCapInsets(GameDefine.PanelRect2)
    img_bg_top:setContentSize(self.winSize)
    img_bg_top:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)

    local x1, x2 = 170, 180
    -- 原始密码
    GameUtil.createLabel(LangCtrl:getLang().word170, 26, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(x1, 450)):addTo(self)
    local edit_oldPass = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_oldPass:setFont(GameDefine.FontName, 30)
    edit_oldPass:setFontColor(GameDefine.FontColor_edit)
    edit_oldPass:setMaxLength(6)
    edit_oldPass:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_oldPass:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_oldPass:setPlaceHolder(LangCtrl:getLang().word171)
    edit_oldPass:setPlaceholderFontSize(30)
    edit_oldPass:setPlaceholderFontName(GameDefine.FontName)
    edit_oldPass:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_oldPass:align(display.LEFT_CENTER, x2, 450):addTo(self)
    self.edit_oldPass = edit_oldPass

    -- 新密码
    GameUtil.createLabel(LangCtrl:getLang().word66, 26, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(x1, 350)):addTo(self)
    local edit_pass_1 = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_pass_1:setFont(GameDefine.FontName, 30)
    edit_pass_1:setFontColor(GameDefine.FontColor_edit)
    edit_pass_1:setMaxLength(6)
    edit_pass_1:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_pass_1:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_pass_1:setPlaceHolder(LangCtrl:getLang().word67)
    edit_pass_1:setPlaceholderFontSize(30)
    edit_pass_1:setPlaceholderFontName(GameDefine.FontName)
    edit_pass_1:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_pass_1:align(display.LEFT_CENTER, x2, 350):addTo(self)
    self.edit_pass_1 = edit_pass_1

    -- 确认密码
    GameUtil.createLabel(LangCtrl:getLang().word32, 26, GameDefine.FontColor, display.RIGHT_CENTER, cc.p(x1, 250)):addTo(self)
    local edit_pass_2 = ccui.EditBox:create(cc.size(545, 60), "app/common/comwin/edit_bg.png")
    edit_pass_2:setFont(GameDefine.FontName, 30)
    edit_pass_2:setFontColor(GameDefine.FontColor_edit)
    edit_pass_2:setMaxLength(6)
    edit_pass_2:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    edit_pass_2:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    edit_pass_2:setPlaceHolder(LangCtrl:getLang().word36)
    edit_pass_2:setPlaceholderFontSize(30)
    edit_pass_2:setPlaceholderFontName(GameDefine.FontName)
    edit_pass_2:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_pass_2:align(display.LEFT_CENTER, x2, 250):addTo(self)
    self.edit_pass_2 = edit_pass_2

    local function clickModiPass(btn)
        local oldPassword = self.edit_oldPass:getText()
        local newPassword1 = self.edit_pass_1:getText()
        local newPassword2 = self.edit_pass_2:getText()
        if string.len(oldPassword) ~= 6 then
            PlazaManager.showTips(LangCtrl:getLang().word172)
            return
        end

        if string.len(newPassword1) ~= 6 then
            PlazaManager.showTips(LangCtrl:getLang().word172)
            return
        end

        if string.len(newPassword2) ~= 6 then
            PlazaManager.showTips(LangCtrl:getLang().word172)
            return
        end

        if newPassword1 ~= newPassword2 then
            PlazaManager.showTips(LangCtrl:getLang().word53)
            return
        end

        if oldPassword == newPassword1 then
            PlazaManager.showTips(LangCtrl:getLang().word173)
            return
        end

        self:sendModiPassMessage(oldPassword, newPassword1)
    end
    local btn_ModiPass = GameUtil.createButton("app/common/button/btn1.png", nil, clickModiPass):move(self.midWidth, 60):addTo(self)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_ModiPass) -- 确定
end

function BankNodeModiPass:onEnter()
    self:addEvent()
end

function BankNodeModiPass:onExit()
    self:removeEvent()
end

function BankNodeModiPass:onClearUp()
    self:disableNodeEvents()
end

function BankNodeModiPass:addEvent()
    self.eventData = {}
    self.eventData.onModiPassword = function(data)
        self:onModiPassword(data)
    end
    game.registerEvent(GameDefine.Bank_Back_ModiPassword, self.eventData.onModiPassword)
end

function BankNodeModiPass:removeEvent()
    game.unregisterEvent(GameDefine.Bank_Back_ModiPassword, self.eventData.onModiPassword)
end

----------------------------------------UI 函数------------------------

------------------------------------逻辑函数-----------------------------
function BankNodeModiPass:sendModiPassMessage(oldPassword, newPassword)
    local data = {}
    data.passType = 1
    data.newPassStr = game.md5(tostring(newPassword))
    data.oldType = 1
    data.oldPassStr = game.md5(tostring(oldPassword))

    self.newPassType = data.passType
    self.newPassStr = data.newPassStr

    PlazaManager.showConectWaitTips(nil)
    local function onConnectResult(isSuccess, ipsCount)
        PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word174, LangCtrl:getLang().word175)
    end

    PlazaManager.getLoginModule().onSendModiPassMessage(data, onConnectResult)
end

function BankNodeModiPass:onModiPassword(data)
    PlazaManager.closeWattingTips()
    if data.lResultCode == 0 then
        self.edit_oldPass:setText("")
        self.edit_pass_1:setText("")
        self.edit_pass_2:setText("")
        PlazaManager.showTips(LangCtrl:getLang().word176)

        PlazaManager.bankPassType = self.newPassType
        PlazaManager.bankPassStr = self.newPassStr
        PlazaManager.bankIsModiSucc = true
    else
        PlazaManager.showTips(data.szDescribeString)
    end
end
return BankNodeModiPass
