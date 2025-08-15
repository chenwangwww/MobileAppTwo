local GameUserInfoWin = class("GameUserInfoWin", require("app.win.base.GameWindowBase"))

function GameUserInfoWin:ctor(userData, isGoal)
    GameUserInfoWin.super.ctor(self, cc.size(672, 542), true)
    self:align(display.LEFT_BOTTOM, display.cx - 336, display.cy - 271)
    self:addBasePanel()
    self:addPanelTitle(LangCtrl:getLang().word78)
    self:addCloseBtn()

    if userData ~= nil then
        local img_head = GameUtil.createAvatar(userData.avatarURL, 100, true, nil, nil, nil):align(display.CENTER, self.midWidth, 390):addTo(self)

        local headbgmask = ccui.ImageView:create("app/common/img_txbjk.png"):align(display.CENTER, 50, 50):addTo(img_head)
        headbgmask:setScale(0.7)

        ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, 336, 310):addTo(self):setScaleX((self.winSize.width - 20) / 6)

        -- 昵称
        GameUtil.createLabel(LangCtrl:getLang().word31, 28, GameDefine.NameColor, display.LEFT_CENTER, cc.p(20, 280)):addTo(self)
        GameUtil.createLabel(userData.szNickName, 28, GameDefine.NameColor, display.RIGHT_CENTER, cc.p(620, 280)):addTo(self)

        ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, 336, 250):addTo(self):setScaleX((self.winSize.width - 20) / 6)

        local diffY = 60
        if PlazaManager.curGameType ~= GameDefine.GAME_TYPE.GAME_GENRE_GOLD then
            diffY = 0
            -- IP
            GameUtil.createLabel("IP:", 28, GameDefine.NameColor, display.LEFT_CENTER, cc.p(20, 220)):addTo(self)
            GameUtil.createLabel(userData.userIP, 28, GameDefine.NameColor, display.RIGHT_CENTER, cc.p(620, 220)):addTo(self)

            ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, 336, 190):addTo(self):setScaleX((self.winSize.width - 20) / 6)
        end
        -- ID
        GameUtil.createLabel("ID:", 28, GameDefine.NameColor, display.LEFT_CENTER, cc.p(20, 160 + diffY)):addTo(self)
        GameUtil.createLabel(userData.dwGameID, 28, GameDefine.NameColor, display.RIGHT_CENTER, cc.p(620, 160 + diffY)):addTo(self)

        ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, 336, 130 + diffY):addTo(self):setScaleX((self.winSize.width - 20) / 6)

        -- ID
        local str_name = LangCtrl:getLang().word327
        if isGoal == true then
            str_name = LangCtrl:getLang().word328
        end
        GameUtil.createLabel(str_name, 28, GameDefine.NameColor, display.LEFT_CENTER, cc.p(20, 100 + diffY)):addTo(self)
        GameUtil.createLabel(userData.lScore, 28, GameDefine.NameColor, display.RIGHT_CENTER, cc.p(620, 100 + diffY)):addTo(self)

        ccui.ImageView:create("app/win/bank/img_line.png"):align(display.CENTER, 336, 70 + diffY):addTo(self):setScaleX((self.winSize.width - 20) / 6)
    end
end

function GameUserInfoWin:onExit()
    game.sendEvent(GameDefine.OnEmoPhraseWinClose)
end

return GameUserInfoWin
