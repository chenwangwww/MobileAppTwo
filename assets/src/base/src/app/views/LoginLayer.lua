local LoginLayer = class("LoginLayer", function()
    return display.newLayer()
end)

local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

function LoginLayer:ctor(v, callback)
    self.callback = callback
    self:setContentSize(cc.size(display.width, display.height))
    self:initView()
end

function LoginLayer:initView()
    -- 加载背景
    -- self.imge_bg = display.newSprite("app/login/bg_denglu1.png"):move(display.center):addTo(self)
    -- local contentSize = self.imge_bg:getContentSize()
    -- self.imge_bg:setScale(display.width / contentSize.width, display.height / contentSize.height)

    -- local loginBg = cc.Sprite:create("app/login/bg_denglu2.png")
    -- loginBg:move(display.center):addTo(self)
    local imge_bg = display.newSprite("app/login/bg_denglu3.png"):move(display.center):addTo(self)
    local contentSize = imge_bg:getContentSize()

    -- 计算缩放比例，取宽高比的最大值，确保图片完全覆盖屏幕
    local scaleX = display.width / contentSize.width
    local scaleY = display.height / contentSize.height
    local scale = math.max(scaleX, scaleY) -- 选择较大的缩放比例

    imge_bg:setScale(scale)            -- 等比缩放

    --动画效果
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("login/denglu/denglu.ExportJson")
    -- local armature = ccs.Armature:create("denglu")
    -- armature:getAnimation():playWithIndex(0)
    -- armature:align(display.CENTER, display.cx, display.cy):addTo(self)
    

    local logores = "app/login/logo1.png"
    if LangCtrl:isEng() then
        logores = "app/login/logo2.png"
    end
    local imge_logo = ccui.ImageView:create(logores)
    imge_logo:setAnchorPoint(display.CENTER)
    imge_logo:setPosition(170, display.height - 120)
    -- imge_logo:setScale(0.5)
    self:addChild(imge_logo)

    -- 游戏版本
    self.labelVersion = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 20)
    self.labelVersion:align(display.LEFT_TOP, 20, display.height - 30)
    self.labelVersion:addTo(self)

    -- 底部背景
    -- local downbg = display.newSprite("app/common/mask.png"):align(display.CENTER, display.cx, 35):addTo(self)
    -- downbg:setOpacity(120)
    -- downbg:setScale(display.width / 5, 70 / 5)

    -- 提示
    self.hitLabel = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 18):align(display.CENTER, display.cx, 30)
    self.hitLabel:setColor(cc.c3b(05, 29, 42))
    self.hitLabel:addTo(self)

    -- 申明
    self.declareLabel = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 18):align(display.CENTER, display.cx, 20)
    self.declareLabel:setColor(cc.c3b(05, 29, 42))
    self.declareLabel:addTo(self)

    -- 添加用户协议
    local function onCheckSelectedEvent(sender, eventType)
        PlazaManager.playClickEffect()

        if eventType == ccui.CheckBoxEventType.selected then
            cc.UserDefault:getInstance():setBoolForKey("user_agreement", true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            cc.UserDefault:getInstance():setBoolForKey("user_agreement", false)
        end

        if GameDefine.bIsTestUI then
            local testUI = require("app.win.login.UpdateAppUI")
            testUI.new(PlazaManager.urlGameConfig):addTo(self)
        end
    end

    self.userAgreement = ccui.CheckBox:create("app/login/check_1.png", "app/login/check_2.png")
    self.userAgreement:setPosition(display.cx - 140, display.cy - 250)
    self.userAgreement:setVisible(false)
    self.userAgreement:addTo(self)

    if GameDefine.bIsTestUI then
        self.userAgreement:addEventListener(onCheckSelectedEvent)
    else
        self:setUserAgreementStatue(true)
        self.userAgreement:setTouchEnabled(false)
    end

    -- local isUserAgreement = cc.UserDefault:getInstance():getBoolForKey("user_agreement", false)
    -- self.userAgreement:setSelected(isUserAgreement)

    local function onClickAgreement(target)
        --[[
        if GameDefine.bIsTestUI then
            local testUI = require "app.win.login.AccountCheckPhoneUI"
            local winui = testUI.new()
            winui:setCenterOnScene()
            winui:addToOnCheckExist(display.getRunningScene())
        end
        -- ]]

        --[[
        if GameDefine.bIsTestUI then
            -- local ShareQRCodeWinUI = require "app.win.hall.ShareQRCodeWinUI"
            -- ShareQRCodeWinUI:openView()
            GameUtil.copyMagicToken()
        end
        -- ]]

        -- if self.callback ~= nil then
        --     self.callback(target, 'agreement')
        -- end
    end

    local function onClickKefu()
        --[[
        if GameDefine.bIsTestUI then
            -- local ShareQRCodeWinUI = require "app.win.hall.ShareQRCodeWinUI"
            -- ShareQRCodeWinUI:openView()
            local str = GameUtil.readMagicToken()
            if self.hitLabel ~= nil then
                self.hitLabel:setString(str or "")
            end
            return
        end
        -- ]]

        --[[
        if GameDefine.bIsLocalTest then
            GameUtil.changeRootView_V(true)
            require("game/mjhl/src/MJHLAPP").create():run()
            return
        end
        --]]

        local str = PlazaManager.urlGameConfig.customerServiceUrl
        if str and string.len(str) > 5 then
            cc.Application:getInstance():openURL(str)
        else
            PlazaManager.showTips(LangCtrl:getLang().word1)
        end
    end

    local function onClickYK(target)
        --[[
        do
            GameUtil.openAppByIdx(math.random(1, 2))
            return
        end
        --]]

        if self.callback ~= nil then
            self.callback(target, "youke")
        end
    end

    local function onClickWeiXin(target)
        if self.callback ~= nil then
            self.callback(target, "weixin")
        end
    end

    local function onClickAccountLogin(target)
        --[[
        do
            local SocialShare = require("app.components.SocialShare")
            self.objShare = SocialShare.new()
            self.objShare:addNodeBg()
            local magicToken = "RUBB￥￥娱乐+888元$Huoejlksowej&ladjolasd767$复制此口令->打开RBB>>娱乐"
            self.objShare:addShareText(magicToken)
            self.objShare:addShareBtn()
            self.objShare:align(display.CENTER_BOTTOM, display.cx, 10):addTo(self)
            return
        end
        --]]
        if self.callback ~= nil then
            self.callback(target, "accountLogin")
        end
    end

    local function onClickRegisterAccount(target)
        if self.callback ~= nil then
            self.callback(target, "accountRegister")
        end
    end

    self.btn_agreement = GameUtil.newBlankBtn(self, cc.size(280, 50), onClickAgreement)
    self.btn_agreement:setAnchorPoint(display.LEFT_CENTER)
    self.btn_agreement:setPosition(display.cx - 100, display.cy - 250)
    self.btn_agreement:setVisible(false)

    GameUtil.addBtnTTF0(LangCtrl:getLang().word306, self.btn_agreement, 25):align(display.LEFT_CENTER, 0, 25)

    local btn_kefu = GameUtil.newBlankBtn(self, cc.size(100, 100), onClickKefu):align(display.CENTER, display.width - 80, display.height - 80)
    GameUtil.addBtnSprite("app/login/icon_lxkf.png", btn_kefu):align(display.CENTER, 50, 60)

    GameUtil.addBtnTTF0(LangCtrl:getLang().word305, btn_kefu, 18):align(display.CENTER, 50, 25)

    local pos1, pos2 = cc.p(50, 40), cc.p(170, 40)
    self.btn_yk = GameUtil.createButton("app/login/btn_dl.png", nil, onClickYK):move(display.cx - 358, display.cy - 150)
    self.btn_yk:addTo(self)
    GameUtil.addBtnSprite("app/login/icon_dl_1.png", self.btn_yk):align(display.CENTER, 70, 45)
    GameUtil.addBtnTTF1(LangCtrl:getLang().word302, self.btn_yk, 28):align(display.CENTER, 160, 45)

    self.btn_accountLogin = GameUtil.createButton("app/login/btn_dl.png", nil, onClickAccountLogin):move(display.cx, display.cy - 150)
    self.btn_accountLogin:addTo(self)
    GameUtil.addBtnSprite("app/login/icon_dl_2.png", self.btn_accountLogin):align(display.CENTER, 70, 45)
    GameUtil.addBtnTTF1(LangCtrl:getLang().word303, self.btn_accountLogin, 28):align(display.CENTER, 160, 45)

    self.btn_zc = GameUtil.createButton("app/login/btn_dl.png", nil, onClickRegisterAccount):move(display.cx + 358, display.cy - 150)
    self.btn_zc:setVisible(false)
    self.btn_zc:addTo(self)
    GameUtil.addBtnSprite("app/login/icon_dl_3.png", self.btn_zc):align(display.CENTER, 70, 45)
    GameUtil.addBtnTTF1(LangCtrl:getLang().word304, self.btn_zc, 28):align(display.CENTER, 160, 45)
end

function LoginLayer:setUserAgreementStatue(isSelect)
    if isSelect ~= nil and type(isSelect) == "boolean" then
        self.userAgreement:setSelected(isSelect)
        cc.UserDefault:getInstance():setBoolForKey("user_agreement", isSelect)
    end
end

function LoginLayer:setLoadInfo(args)
    if args ~= nil then
        -- 版本
        if args.versionStr ~= nil and type(args.versionStr) == "string" then
            if self.labelVersion ~= nil then
                print("args.versionStr == " .. args.versionStr)
                self.labelVersion:setString(args.versionStr)
            end
        end

        -- 提示
        if args.hitStr ~= nil and type(args.hitStr) == "string" then
            if self.hitLabel ~= nil then
                self.hitLabel:setString(args.hitStr)
            end
        end

        -- 申明
        if args.declareStr ~= nil and type(args.declareStr) == "string" then
            if self.declareLabel ~= nil then
                self.declareLabel:setString(args.declareStr)
            end
        end
    end
end

function LoginLayer:setLayerVisible()
    self.userAgreement:setVisible(true)
    self.btn_agreement:setVisible(true)
    self.btn_accountLogin:setVisible(true)
    self.btn_zc:setVisible(true)
    if self.btn_wx ~= nil then
        self.btn_wx:setVisible(true)
    end
end

return LoginLayer

-- endregion
