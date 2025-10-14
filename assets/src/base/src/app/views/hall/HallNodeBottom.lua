local HallNodeBottom = class("HallNodeBottom", function()
    return display.newNode()
end)

local WelcomeWinUI = require "app.win.hall.WelcomeWinUI"
local ShareQRCodeWinUI = require "app.win.hall.ShareQRCodeWinUI"
local InputPassWinUI = require "app.win.bank.InputPassWinUI"

function HallNodeBottom:ctor(args)
    self.data = args
    self:setContentSize(cc.size(1334, 110))
    self:initView()
end

function HallNodeBottom:initView()
    -- 背景
    local bg_1 = ccui.Scale9Sprite:create("app/hall/bottom/img_buttom_bg.png")
    bg_1:setCapInsets(cc.rect(1, 1, 1332, 109)) -- 1334 111
    bg_1:setContentSize(display.width, 111)
    bg_1:align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)

    -- 分享
    local function onClickOfficeSite(target)
        self:onButtomCallback("share")
    end
    local btn = GameUtil.newBlankBtn(self, cc.size(120, 60), onClickOfficeSite):align(display.CENTER, 150, 50)
    GameUtil.addBtnSprite("app/hall/bottom/icon_zdt_fx.png", btn):align(display.RIGHT_BOTTOM, 55, 0)
    self:addBtnLabel(LangCtrl:getLang().word317, btn):align(display.LEFT_BOTTOM, 60, 0)

    -- 保险箱
    local function onClickOpenBank(target)
        self:onButtomCallback("bxx")
    end
    btn = GameUtil.newBlankBtn(self, cc.size(120, 60), onClickOpenBank):align(display.CENTER, 340, 50)
    GameUtil.addBtnSprite("app/hall/bottom/icon_zdt_bxx.png", btn):align(display.RIGHT_BOTTOM, 55, 0)
    self:addBtnLabel(LangCtrl:getLang().word128, btn):align(display.LEFT_BOTTOM, 60, 0)

    ---客服
    local function onClickCustServer(target)
        self:onButtomCallback("kf")
    end
    btn = GameUtil.newBlankBtn(self, cc.size(120, 60), onClickCustServer):align(display.CENTER, 550, 50)
    GameUtil.addBtnSprite("app/hall/bottom/icon_zdt_kf.png", btn):align(display.RIGHT_BOTTOM, 55, 0)
    self:addBtnLabel(LangCtrl:getLang().word318, btn):align(display.LEFT_BOTTOM, 60, 0)

    ---公告
    local function onClickOpenWelcome(target)
        self:onButtomCallback("gg")
    end
    btn = GameUtil.newBlankBtn(self, cc.size(150, 60), onClickOpenWelcome):align(display.CENTER, 750, 50)
    local sprite = GameUtil.addBtnSprite("app/hall/bottom/icon_zdt_hd.png", btn):align(display.RIGHT_BOTTOM, 78, 0)
    self:addBtnLabel(LangCtrl:getLang().word319, btn):align(display.LEFT_BOTTOM, 80, 0)
    self.sprHit_gg = GameUtil.newSprite("app/hall/bottom/img_hd.png", false):align(display.CENTER, 5, 58):addTo(sprite)

    local isios = PlazaManager.platform == cc.PLATFORM_OS_IPHONE or PlazaManager.platform == cc.PLATFORM_OS_IPAD or PlazaManager.platform == cc.PLATFORM_OS_MAC

    if isios then
        -- 显示排行版
        self:createRankBtn(cc.p(1180, 56))
    else
        -- 充值
        self:createShopBtn(cc.p(1180, 56))
    end

    ---官网
    local function GetStringByUrl(apiUrl, successCallback, errorCallback)
        local xhr = cc.XMLHttpRequest:new()
    -- 1. 关键修改：设置为 TEXT，以接收字符串数据
        xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_TEXT
        xhr:open("GET", apiUrl)

        local function onDownloadString()
            -- 确保在回调结束时注销处理，防止内存泄漏
            local function cleanup()
                xhr:unregisterScriptHandler()
            end
            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                -- 2. 获取响应字符串
                local responseString = xhr.response
                if responseString and type(successCallback) == "function" then
                    -- 成功：将字符串传递给回调函数
                    successCallback(responseString)
                end  
                cleanup()
            else
                cc.log(string.format("HTTP 请求失败或状态码异常. Status: %d, ReadyState: %d", xhr.status, xhr.readyState))     
                if type(errorCallback) == "function" then
                    errorCallback()
                end
                cleanup()
            end
        end

        xhr:registerScriptHandler(onDownloadString)
        xhr:send()
    end
    local function onClickguanwang(target)
        local apiUrl = "http://170.33.42.24:9001/api/index/getXyAppUrl"
        local url = ""
        GetStringByUrl(
            apiUrl, 
            function(data)
                print("成功获取到字符串数据：", data)
                -- 在这里处理返回的字符串（如解析 JSON 或显示文本）
                -- local json_data = require("cjson").decode(data)
                url = data
                cc.Application:getInstance():openURL(url)
            end,
            function()
                print("获取字符串失败！")
            end
        )
    end
    btn = GameUtil.newBlankBtn(self, cc.size(120, 60), onClickguanwang):align(display.CENTER, 950, 50)
    GameUtil.addBtnSprite("app/hall/bottom/icon_zdt_web.png", btn):align(display.RIGHT_BOTTOM, 55, 0)
    self:addBtnLabel(LangCtrl:getLang().word361, btn):align(display.LEFT_BOTTOM, 60, 0)
end

function HallNodeBottom:addBtnLabel(str, parent)
    local lbl = cc.Label:createWithTTF(str, "fonts/fzz.ttf", 28)
    lbl:setColor(cc.c3b(0xd2, 0xfb, 0xff))
    lbl:enableBold()
    lbl:enableOutline(cc.c3b(0x01, 0x50, 0x72), 1)
    parent:getVirtualRenderer():addChild(lbl)
    return lbl
end

function HallNodeBottom:createRankBtn(pos)
    local function onClickOpenShop(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            sender:setScale(0.9)
        elseif eventtype == ccui.TouchEventType.ended then
            sender:setScale(1)
            self:onButtomCallback("phb")
        elseif eventtype == ccui.TouchEventType.canceled then
            sender:setScale(1)
        end
    end

    local btnNode = ccui.Layout:create()
    btnNode:align(display.CENTER, pos.x, pos.y):addTo(self)
    btnNode:setTouchEnabled(true)
    btnNode:addTouchEventListener(onClickOpenShop)
    btnNode:setContentSize(220, 120)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("app/hall/bottom/paihangbang/paihangbang.ExportJson")
    local armature = ccs.Armature:create("paihangbang") -- 创建动画对象
    armature:getAnimation():playWithIndex(0) -- 设置动画对象执行的动画名称
    -- armature:getAnimation():setSpeedScale(0.5)
    armature:align(display.CENTER, 110, 60):addTo(btnNode)

    local fntSZ = 35
    if LangCtrl:isEng() then
        fntSZ = 30
    end
    local lbl = cc.Label:createWithTTF(LangCtrl:getLang().word223, "fonts/fzcs.ttf", fntSZ)
    lbl:setColor(cc.c3b(255, 240, 165))
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(130, 50)
    lbl:enableOutline(cc.c4b(94, 26, 5, 255), 1) -- 标题描边颜色
    btnNode:addChild(lbl)
end

function HallNodeBottom:createShopBtn(pos)
    local function onClickOpenShop(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            PlazaManager.playClickEffect()
            sender:setScale(0.9)
        elseif eventtype == ccui.TouchEventType.ended then
            sender:setScale(1)
            self:onButtomCallback("cz")
        elseif eventtype == ccui.TouchEventType.canceled then
            sender:setScale(1)
        end
    end

    local btnNode = ccui.Layout:create()
    btnNode:align(display.CENTER, pos.x, pos.y):addTo(self)
    btnNode:setTouchEnabled(true)
    btnNode:addTouchEventListener(onClickOpenShop)
    btnNode:setContentSize(200, 120)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("app/hall/bottom/shagnchen/zdt_shangcheng.ExportJson")
    local armature = ccs.Armature:create("zdt_shangcheng") -- 创建动画对象
    armature:getAnimation():playWithIndex(0) -- 设置动画对象执行的动画名称
    -- armature:getAnimation():setSpeedScale(0.5)
    armature:align(display.CENTER, 100, 60):addTo(btnNode)
end

function HallNodeBottom:onButtomCallback(args)
    if args == "gw" then
        print("点击官网")
        cc.Application:getInstance():openURL(PlazaManager.urlGameConfig.officialWebsiteUrl)
    elseif args == "bxx" then -- 点击保险箱 --xcj
        local isShowBindAccount = cc.UserDefault:getInstance():getBoolForKey(string.format("bindAccountNextShow_%s", globalUserInfo.dwGameID), true)

        local is_yk_need_bind = globalUserInfo.cbRegType == 0 and globalUserInfo.isBindAccount == false
        if is_yk_need_bind or (isShowBindAccount == true and globalUserInfo.cbRegType == 1 and globalUserInfo.isBindAccount == false) then
            require("app.win.hall.BindAccountTipWinUI"):openView(true)
        else
            self:onOpenBank()
        end
    elseif args == "kf" then
        if GameDefine.bIsTestUI then
            local testui = require "app.win.bank.BankWinUI"
            local winui = testui.new()
            winui:setCenterOnScene()
            winui:addToOnCheckExist(display:getRunningScene())
            return
        end

        local str = PlazaManager.urlGameConfig.customerServiceUrl
        if str and string.len(str) > 5 then
            cc.Application:getInstance():openURL(str)
        else
            PlazaManager.showTips(LangCtrl:getLang().word1)
        end
    elseif args == "gg" then -- 点击公告
        local winui = WelcomeWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display:getRunningScene())
    elseif args == "cz" then -- 点击商店
        require("app.win.shop.ShopWeChat"):openView()
    elseif args == "share" then -- 点击分享
        ShareQRCodeWinUI:openView()
    elseif args == "phb" then -- 排行榜
        require("app.win.PlayerRankView"):openView()
    end
end

function HallNodeBottom:onOpenBank()
    if PlazaManager.bankIsLogonSucc == true and os.difftime(os.time(), PlazaManager.bankLogonTime) < 120 then
        local data = {}
        data.passType = PlazaManager.bankPassType
        data.passStr = PlazaManager.bankPassStr

        PlazaManager.bankOpenType = 1

        PlazaManager.showConectWaitTips(nil)
        local function onConnectResult(isSuccess, ipsCount)
            PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word100, LangCtrl:getLang().word101)
        end

        PlazaManager.getLoginModule().onLoginBank(data, onConnectResult)
    else
        local winui = InputPassWinUI.new()
        winui:setCenterOnScene()
        winui:addToOnCheckExist(display:getRunningScene())
    end
end

return HallNodeBottom

-- endregion
