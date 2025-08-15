local AccountLoginUI = class("AccountLoginUI", require("app.win.base.GameWindowWinBase"))

function AccountLoginUI:ctor(value, callback)
    AccountLoginUI.super.ctor(self, LangCtrl:getLang().word10, true, false)
    self:setName("AccountLoginUI")
    self.eventData = {}

    -- 读取本地保存的账号信息
    local writePassCheck = cc.UserDefault:getInstance():getBoolForKey("zh_c_writePassCheck", true)
    local account_local = cc.UserDefault:getInstance():getStringForKey("zh_c_account", "")
    self.password_local = cc.UserDefault:getInstance():getStringForKey("zh_c_password", "")

    local posy = self.winSize.height * 0.68
    local lbl_accoutName = cc.Label:createWithTTF(LangCtrl:getLang().word3, GameDefine.FontName, 30)
    lbl_accoutName:setColor(GameDefine.FontColor)
    lbl_accoutName:align(display.RIGHT_CENTER, 280, posy):addTo(self.panelNode)

    local lbl_passName = cc.Label:createWithTTF(LangCtrl:getLang().word4, GameDefine.FontName, 30)
    lbl_passName:setColor(GameDefine.FontColor)
    lbl_passName:align(display.RIGHT_CENTER, 280, posy - 100):addTo(self.panelNode)

    local editAccount = ccui.EditBox:create(cc.size(412, 56), "app/common/comwin/edit_bg.png")
    editAccount:setFont(GameDefine.FontName, 24)
    editAccount:setFontColor(GameDefine.FontColor_edit)
    editAccount:setMaxLength(30)
    editAccount:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editAccount:setPlaceHolder(LangCtrl:getLang().word5)
    editAccount:setPlaceholderFontSize(24)
    editAccount:setPlaceholderFontName(GameDefine.FontName)
    editAccount:setPlaceholderFontColor(GameDefine.FontColor_edit)
    editAccount:align(display.LEFT_CENTER, 300, posy):addTo(self.panelNode)
    self.editAccount = editAccount

    local editPassword = ccui.EditBox:create(cc.size(412, 56), "app/common/comwin/edit_bg.png")
    editPassword:setFont(GameDefine.FontName, 24)
    editPassword:setFontColor(GameDefine.FontColor_edit)
    editPassword:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    editPassword:setMaxLength(33)
    editPassword:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    editPassword:setPlaceHolder(LangCtrl:getLang().word6)
    editPassword:setPlaceholderFontName(GameDefine.FontName)
    editPassword:setPlaceholderFontSize(24)
    editPassword:setPlaceholderFontColor(GameDefine.FontColor_edit)
    editPassword:align(display.LEFT_CENTER, 300, posy - 100):addTo(self.panelNode)
    self.editPassword = editPassword

    local function onClickCheck_jzmj(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()

            if sender.writePassCheck == false then
                sender.writePassCheck = true
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(true)
                end
            else
                sender.writePassCheck = false
                if sender:getChildByName("bg_check_2") ~= nil then
                    sender:getChildByName("bg_check_2"):setVisible(false)
                end
            end
        end
    end

    local offsetX = 0

    if LangCtrl:isEng() then
        offsetX = 30
    end

    local btn_checkNode = ccui.Layout:create()
    btn_checkNode:align(display.LEFT_CENTER, cc.p(300 - offsetX, posy - 180))
    btn_checkNode:addTo(self.panelNode)
    btn_checkNode:setTouchEnabled(true)
    btn_checkNode:addTouchEventListener(onClickCheck_jzmj)
    btn_checkNode:setContentSize(180, 60)

    local lbl_1 = cc.Label:createWithTTF(LangCtrl:getLang().word2, GameDefine.FontName, 23):align(display.LEFT_CENTER, 50, 30):addTo(btn_checkNode)
    lbl_1:setColor(GameDefine.FontColor)
    local bg_check_1 = ccui.ImageView:create("app/login/check_1.png")
    bg_check_1:align(display.CENTER, 20, 30):addTo(btn_checkNode)

    local bg_check_2 = ccui.ImageView:create("app/login/check_2.png")
    bg_check_2:align(display.CENTER, 20, 30):addTo(btn_checkNode)
    bg_check_2:setName("bg_check_2")
    btn_checkNode.writePassCheck = writePassCheck

    if writePassCheck == false then
        bg_check_2:setVisible(false)
    end

    self.btn_checkNode = btn_checkNode

    if string.len(account_local) > 0 then
        self.editAccount:setText(account_local)
    end
    if writePassCheck == true and string.len(self.password_local) > 0 then
        self.editPassword:setText(self.password_local)
    end

    local function isStrOk(str, limLen)
        -- 字符长度
        if string.len(str) == 0 then
            return 1
        end

        -- 是否全部是空字符串
        local regStr_remove = GameUtil.reomveString(str, " ")
        if string.len(regStr_remove) == 0 then
            return 2
        end

        return 0
    end

    local function onClickAccountLogin(args)
        local regStr = self.editAccount:getText()
        if isStrOk(regStr) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word7)
            return
        end

        -- 长度是否超出
        if string.len(regStr) > 30 then
            PlazaManager.showTips(LangCtrl:getLang().word7)

            return
        end

        if GameUtil.isChineseString(regStr) == true then
            PlazaManager.showTips(LangCtrl:getLang().word8)
            return
        end

        local args = {}

        local password = self.editPassword:getText()
        if isStrOk(password) ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word9)
            return
        end

        if password ~= self.password_local then
            -- 长度是否超出
            if string.len(password) > 33 then
                PlazaManager.showTips(LangCtrl:getLang().word9)
                return
            end
            args.password = game.md5(password)
        else
            args.password = password
        end

        args.sex = 1
        args.account = regStr
        args.openIDAccount = args.account
        args.openIDPassword = args.password

        if PlazaManager.isCheck == true then
            PlazaManager.loginType = GameDefine.LOGIN_TYPE.YK
        else
            PlazaManager.loginType = GameDefine.LOGIN_TYPE.ACCOUNT
        end

        if callback ~= nil then
            callback(args)
        end

        cc.UserDefault:getInstance():setBoolForKey("zh_c_writePassCheck", self.btn_checkNode.writePassCheck)
        cc.UserDefault:getInstance():setStringForKey("zh_c_account", args.account)
        cc.UserDefault:getInstance():setStringForKey("zh_c_password", args.password)
    end

    self:addCloseBtn()

    local btn_login = GameUtil.createButton("app/common/button/btn1.png", nil, onClickAccountLogin):move(self.midWidth, posy - 280):addTo(self.panelNode)
    GameUtil.addBtnTTF2(LangCtrl:getLang().word10, btn_login)

    if PlazaManager.isCheck ~= true then
        local function onClickForgetPass(args)
            -- 忘记密码 步骤1
            local aaui = require("app.win.login.AccountCheckUI").new()
            aaui:setCenterOnScene()
            aaui:addTo(display.getRunningScene())
        end
        local btn = GameUtil.newBlankBtn(self.panelNode, cc.size(150, 50), onClickForgetPass)
        btn:align(display.LEFT_CENTER, cc.p(550 + offsetX, posy - 180))
        local lbl = GameUtil.addBtnTTF0(LangCtrl:getLang().word315, btn, 25)
        lbl:align(display.LEFT_CENTER, 0, 25):enableUnderline()
    end
end

function AccountLoginUI:onEnter()
    AccountLoginUI.super.onEnter(self)
end

function AccountLoginUI:onExit()
    AccountLoginUI.super.onExit(self)
end

return AccountLoginUI
