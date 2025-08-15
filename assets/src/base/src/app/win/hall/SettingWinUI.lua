local SettingWinUI = class("SettingWinUI", require("app.win.base.GameWindowWinBase"))

function SettingWinUI:ctor()
    SettingWinUI.super.ctor(self, LangCtrl:getLang().word220, true)
    self:setName("SettingWinUI")

    local offres = "app/win/setting/bnt_off.png"
    local onres = "app/win/setting/bnt_on.png"

    self.bIsShowLang = false
    self.initeChk = false

    local moveup = 0
    if self.bIsShowLang then
        moveup = 100
    end
    local namelbl = cc.Label:createWithTTF(LangCtrl:getLang().word221, GameDefine.FontName, 36)
    namelbl:setColor(GameDefine.FontColor)
    namelbl:align(display.RIGHT_CENTER, 450, self.midHeight + 50 + moveup):addTo(self.panelNode)

    local function valueMusicChanged(pSender)
        if self.initeChk == true then
            PlazaManager.playClickEffect()
        end

        self.is_music_off = not self.is_music_off
        if self.is_music_off then
            self.pSwitchControlMusic:loadTextures(offres, offres)
            MusicManager.setBGMVolume(0)
        else
            self.pSwitchControlMusic:loadTextures(onres, onres)
            MusicManager.setBGMVolume(100)
        end
    end

    self.pSwitchControlMusic = ccui.Button:create(onres, onres)
    self.pSwitchControlMusic:addClickEventListener(valueMusicChanged)
    self.pSwitchControlMusic:align(display.LEFT_CENTER, 470, self.midHeight + 50 + moveup):addTo(self.panelNode)

    namelbl = cc.Label:createWithTTF(LangCtrl:getLang().word222, GameDefine.FontName, 36)
    namelbl:setColor(GameDefine.FontColor)
    namelbl:align(display.RIGHT_CENTER, 450, self.midHeight - 50 + moveup):addTo(self.panelNode)

    local function valueEffectChanged(pSender)
        if self.initeChk == true then
            PlazaManager.playClickEffect()
        end

        self.is_effect_off = not self.is_effect_off
        if self.is_effect_off then
            self.pSwitchControlEffect:loadTextures(offres, offres)
            MusicManager.setEffectVolume(0)
        else
            self.pSwitchControlEffect:loadTextures(onres, onres)
            MusicManager.setEffectVolume(100)
        end
    end

    self.pSwitchControlEffect = ccui.Button:create(onres, nil)
    self.pSwitchControlEffect:addClickEventListener(valueEffectChanged)
    self.pSwitchControlEffect:align(display.LEFT_CENTER, 470, self.midHeight - 50 + moveup):addTo(self.panelNode)

    local effectvolume = MusicManager.getEffectVal()
    local musicvolume = MusicManager.getMusicVal()
    self.is_music_off = musicvolume == 0
    self.is_effect_off = effectvolume == 0
    if self.is_music_off then
        self.pSwitchControlMusic:loadTextures(offres, offres)
    else
        self.pSwitchControlMusic:loadTextures(onres, onres)
    end

    if self.is_effect_off then
        self.pSwitchControlEffect:loadTextures(offres, offres)
    else
        self.pSwitchControlEffect:loadTextures(onres, onres)
    end

    self:addCloseBtn()

    if self.bIsShowLang then
        namelbl = cc.Label:createWithTTF(LangCtrl:getLang().word320, GameDefine.FontName, 36)
        namelbl:setColor(GameDefine.FontColor)
        namelbl:align(display.RIGHT_CENTER, 450, self.midHeight - 50):addTo(self.panelNode)

        local function changelang()
            LangCtrl:nextLanguage()
            self.curLangLabel:setString(LangCtrl:getCurName())
        end

        local langbtn = GameUtil.createButton("app/common/button/btn2.png", nil, changelang):align(display.LEFT_CENTER, 470, self.midHeight - 50):addTo(self.panelNode)
        self.curLangLabel = GameUtil.addBtnTTF2(LangCtrl:getCurName(), langbtn)
    end

    self.initeChk = true
    if globalUserInfo.cbRegType == 1 and globalUserInfo.isBindAccount == false then
        -- 添加设置账号按钮
        local function onClickBindPhone()
            require("app.win.hall.BindAccountWinUI"):openView(false)
            self:removeFromParent()
        end
        local btn_BindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickBindPhone):move(self.midWidth, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word85, btn_BindPhone) -- 账号设置
    end
end

return SettingWinUI
