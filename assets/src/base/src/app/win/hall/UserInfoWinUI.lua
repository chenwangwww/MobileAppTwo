local UserInfoWinUI = class("UserInfoWinUI", require("app.win.base.GameWindowWinBase"))

function UserInfoWinUI:ctor(ismy, personData)
    if ismy or (personData and globalUserInfo and personData.dwGameID == globalUserInfo.dwGameID) then
        ismy = true
        UserInfoWinUI.super.ctor(self, LangCtrl:getLang().word77, true)

        self.personData = {
            szNickName = globalUserInfo.szNickName,
            dwGameID = globalUserInfo.dwGameID,
            szWeixin = globalUserInfo.szWeixin,
            goalScole = globalUserInfo.lUserScore,
            headurl = globalUserInfo.headimgurl
        }
    else
        self.personData = personData
        UserInfoWinUI.super.ctor(self, LangCtrl:getLang().word78, true)
    end
    self:setName("UserInfoWinUI")
    self.ismy = ismy
    self:initView()
end

function UserInfoWinUI:onEnter()
    UserInfoWinUI.super.onEnter(self)

    if self.ismy == true then
        self.eventData = {}
        self:addEvent()
    end
end

function UserInfoWinUI:onExit()
    UserInfoWinUI.super.onExit(self)
    if self.ismy == true then
        self:removeEvent()
    end
    self:disableNodeEvents()
end

function UserInfoWinUI:onClearUp()
    UserInfoWinUI.super.onClearUp(self)
end

function UserInfoWinUI:addEvent()
    self.eventData.onUpdataUserGoalInfoEvent = function()
        self:onUpdataUserGoalInfo()
    end -- 金币变化消息
    self.eventData.onBindPhoneSuccess = function()
        self:initOptBtns()
    end -- 绑定手机号成功
    self.eventData.onUnBindPhoneSuccess = function()
        self:initOptBtns()
    end -- 解除绑定手机号成功

    game.registerEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onUpdataUserGoalInfoEvent)
    game.registerEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.registerEvent(GameDefine.UnBindPhoneSuccess, self.eventData.onUnBindPhoneSuccess)

    self.eventData.onModifyPersonInfo = function(args)
        local niceNameStr = LangCtrl:getLang().word31 .. globalUserInfo.szNickName
        self.lbl_nicename:setString(niceNameStr)
    end
    game.registerEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfo)
end

function UserInfoWinUI:removeEvent()
    game.unregisterEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onUpdataUserGoalInfoEvent)
    game.unregisterEvent(GameDefine.BindPhoneSuccess, self.eventData.onBindPhoneSuccess)
    game.unregisterEvent(GameDefine.UnBindPhoneSuccess, self.eventData.onUnBindPhoneSuccess)
    game.unregisterEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfo)
end

-------------------UI主界面---------------------------------
function UserInfoWinUI:initView()
    -- 头像
    local img_head = GameUtil.createAvatar(self.personData.headurl, 150, true, nil, nil, nil, nil)
    img_head:align(display.CENTER, 220, 350):addTo(self.panelNode)
    GameUtil.newSprite("app/common/img_txbjk.png", false):align(display.CENTER, 75, 75):addTo(img_head)

    self.lbl_posx = 380
    -- 金币
    self:createGoalNode(cc.p(self.lbl_posx, 400), self.panelNode, self.personData.goalScole)

    -- ID
    local idStr = string.format("ID：%s", self.personData.dwGameID)
    self.lbl_gameid = GameUtil.createLabel(idStr, 30, GameDefine.FontColor, display.LEFT_CENTER, cc.p(self.lbl_posx, 320), nil, cc.size(270, 35)):addTo(self.panelNode)

    -- ID复制
    local function onCopyID(args)
        if GameDefine.bIsTestUI then
            local testUI = require "app.win.GameUserInfoWin"
            local gameUser = {
                avatarURL = self.personData.headurl,
                cbGender = GameDefine.GENDER_FEMALE,
                szNickName = "test nick name",
                userIP = "192.168.88.99",
                dwGameID = 1234214,
                lScore = 9999888
            }
            testUI.new(gameUser, math.random(0, 1) == 1):addTo(self)
        else
            local copyStr = LangCtrl:getLang().word79 .. self.personData.dwGameID
            self:onCopyData(copyStr, LangCtrl:getLang().word80)
        end
    end

    GameUtil.newDarkLightBtn(self.panelNode, 1, LangCtrl:getLang().word26, cc.size(100, 50), 28, onCopyID):align(display.CENTER, 750, 320)

    -- 昵称
    local niceNameStr = LangCtrl:getLang().word31 .. self.personData.szNickName
    self.lbl_nicename = GameUtil.createLabel(niceNameStr, 30, GameDefine.FontColor, display.LEFT_CENTER, cc.p(self.lbl_posx, 260), nil, cc.size(580, 35)):addTo(self.panelNode)

    self:initOptBtns()
    self:addCloseBtn()

    if self.ismy then
        -- 完善资料按钮
        local function onClickFinishInfo()
            PlazaManager.showTips(LangCtrl:getLang().word354)
            -- self:openFinishPersonDataWin()
        end
        local btn_Finish = GameUtil.createButton("app/common/button/btn2.png", nil, onClickFinishInfo):move(self.midWidth + 150, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word23, btn_Finish) -- 完善资料
    else
        local function onClickOK()
            self:removeFromParent()
        end
        local btn_OK = GameUtil.createButton("app/common/button/btn1.png", nil, onClickOK):move(self.midWidth, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_OK) -- 确定
    end
end

----------------其他UI--------------------------------
-- 创建金币按钮控件
function UserInfoWinUI:createGoalNode(pos, node, lUserScore)
    local bg_goal = ccui.Scale9Sprite:create("app/hall/top/img_gold_bg.png")
    bg_goal:setCapInsets(cc.rect(20, 1, 200, 45)) -- 240 48
    local bg_size = cc.size(330, 45)
    bg_goal:setContentSize(bg_size)
    bg_goal:align(display.LEFT_CENTER, pos.x, pos.y):addTo(node)

    local midHeight = bg_size.height / 2

    GameUtil.newSprite("app/common/gold_icon.png", false):align(display.CENTER, 20, midHeight):addTo(bg_goal)

    local goalStr = GameUtil.formatAsset(lUserScore)
    self.lbl_gold = GameUtil.createLabel(goalStr, 30, GameDefine.FontCoinColor, display.CENTER, cc.p(160, midHeight), nil, nil, "center"):addTo(bg_goal)

    if self.ismy then
        local function onClickOpenShop(res)
            self:openShopWin()
        end
        GameUtil.createButton("app/common/icon_jiaohao.png", nil, onClickOpenShop):align(display.CENTER, bg_size.width - 20, midHeight):addTo(bg_goal)
    end
end

function UserInfoWinUI:initOptBtns()
    self.panelNode:removeChildByName("lbl_lastRow")
    self.panelNode:removeChildByName("btn_lastRow")
    self.panelNode:removeChildByName("btn_BindPhone")

    local isExitPhone = false

    if self.ismy and globalUserInfo.szRegisterMobile ~= nil and string.len(globalUserInfo.szRegisterMobile) > 0 then
        isExitPhone = true
        -- 手机号
        local MobilePhone = require("app.components.MobilePhone")
        local phoneStr = MobilePhone:getShowStr(globalUserInfo.szRegisterMobile)
        phoneStr = LangCtrl:getLang().word28 .. phoneStr
        GameUtil.createLabel(phoneStr, 28, GameDefine.FontColor, display.LEFT_CENTER, cc.p(self.lbl_posx, 200), nil, cc.size(370, 35)):addTo(self.panelNode):setName("lbl_lastRow")

        -- 手机复制
        local function onCopyPhone(args)
            self:onCopyData(globalUserInfo.szRegisterMobile, LangCtrl:getLang().word81)
        end

        GameUtil.newDarkLightBtn(self.panelNode, 1, LangCtrl:getLang().word26, cc.size(100, 50), 28, onCopyPhone):align(display.CENTER, 750, 200):setName("btn_lastRow")

        -- 解除绑定
        local function onClickCancelBindPhone()
            self:openBindPhoneWin(false)
        end
        local btn_UnBindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickCancelBindPhone):move(self.midWidth - 150, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word22, btn_UnBindPhone) -- 解除绑定
        btn_UnBindPhone:setName("btn_BindPhone")
    end

    if not isExitPhone and self.personData.szWeixin ~= nil and string.len(self.personData.szWeixin) > 0 then
        -- 微信号
        local qqStr = LangCtrl:getLang().word82 .. self.personData.szWeixin
        GameUtil.createLabel(qqStr, 28, GameDefine.FontColor, display.LEFT_CENTER, cc.p(self.lbl_posx, 200), nil, cc.size(270, 35)):addTo(self.panelNode):setName("lbl_lastRow")

        local function onCopyQQ(args)
            local copyStr = self.personData.szWeixin
            self:onCopyData(copyStr, LangCtrl:getLang().word83)
            -- GameUtil.openAppByIdx(1)
        end
        GameUtil.newDarkLightBtn(self.panelNode, 1, LangCtrl:getLang().word26, cc.size(100, 50), 28, onCopyQQ):align(display.CENTER, 750, 200):setName("btn_lastRow")
    end

    if self.ismy and not isExitPhone then
        -- 绑定手机
        local function onClickBindPhone()
            local is_yk_need_bind = globalUserInfo.cbRegType == 0 and globalUserInfo.isBindAccount == false
            if is_yk_need_bind then
                require("app.win.hall.BindAccountWinUI"):openView(false)
                return
            end

            if globalUserInfo.cbRegType == 1 and globalUserInfo.isBindAccount == false then
                require("app.win.hall.BindAccountWinUI"):openView()
            else
                self:openBindPhoneWin(true)
            end
        end
        local btn_BindPhone = GameUtil.createButton("app/common/button/btn1.png", nil, onClickBindPhone):move(self.midWidth - 150, 110):addTo(self.panelNode)

        GameUtil.addBtnTTF2(LangCtrl:getLang().word21, btn_BindPhone) -- 绑定手机

        btn_BindPhone:setName("btn_BindPhone")
    end
end

-------------------------打开页面或者其他逻辑函数-------------------
-- 打开商城
function UserInfoWinUI:openShopWin()
    if GameDefine.bIsTestUI then
        self:openBindPhoneWin(false)
    else
        require("app.win.shop.ShopWeChat"):openView()
    end
end

-- 打开绑定手机号
function UserInfoWinUI:openBindPhoneWin(isBand)
    local ui = require("app.win.hall.BindPhoneWinUI").new(isBand)
    ui:setCenterOnScene()
    ui:addTo(display.getRunningScene())
end

-- 打开完善资料
function UserInfoWinUI:openFinishPersonDataWin()
    local function callbackfuncion()
        self:initOptBtns()
    end
    local ui = require("app.win.hall.FinishPersonDataWinUI").new(callbackfuncion)
    ui:setCenterOnScene()
    ui:addTo(display.getRunningScene())
end

-- 复制数据到粘贴板
function UserInfoWinUI:onCopyData(copystr, successtr)
    local platform = cc.Application:getInstance():getTargetPlatform()
    if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD or platform == cc.PLATFORM_OS_ANDROID then
        game.systemCopy(copystr)
        PlazaManager.showTips(successtr)
    else
        PlazaManager.showTips(LangCtrl:getLang().word84)
    end
end
-----------------------消息处理函数---------------------------

-- 收到金币变化消息
function UserInfoWinUI:onUpdataUserGoalInfo()
    local goalStr = GameUtil.formatAsset(globalUserInfo.lUserScore)
    self.lbl_gold:setString(goalStr)
end

return UserInfoWinUI
