-- 完善资料
local FinishPersonDataWinUI = class("FinishPersonDataWinUI", require("app.win.base.GameWindowWinBase"))
local MobilePhone = require("app.components.MobilePhone")

function FinishPersonDataWinUI:ctor(callbackfuncion)
    FinishPersonDataWinUI.super.ctor(self, LangCtrl:getLang().word23, true, false)
    self:setName("FinishPersonDataWinUI")

    self.callbackfuncion = callbackfuncion

    self:initView()
end

function FinishPersonDataWinUI:onEnter()
    FinishPersonDataWinUI.super.onEnter(self)

    self.eventData = {}
    self.eventData.onModifyPersonInfoSuccess = function(data)
        self:onModifyPersonInfoSuccess(data)
    end
    self.eventData.onModifyPersonInfoFail = function(data)
        self:onModifyPersonInfoFail(data)
    end
    self.eventData.onSeachUserInfoPCSuccess = function(data)
        self:onSeachUserInfoPCSuccess(data)
    end

    game.registerEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfoSuccess)
    game.registerEvent(GameDefine.ModifyPersonInfoFail, self.eventData.onModifyPersonInfoFail)
    game.registerEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onSeachUserInfoPCSuccess)

    self:sendSearchUserInfoPC()
end

function FinishPersonDataWinUI:onExit()
    game.unregisterEvent(GameDefine.ModifyPersonInfoSuccess, self.eventData.onModifyPersonInfoSuccess)
    game.unregisterEvent(GameDefine.ModifyPersonInfoFail, self.eventData.onModifyPersonInfoFail)
    game.unregisterEvent(GameDefine.UpdataUserGoalInfo, self.eventData.onSeachUserInfoPCSuccess)

    if self.callbackfuncion ~= nil then
        self.callbackfuncion()
    end
    FinishPersonDataWinUI.super.onExit(self)
end

-----------------界面ui-------------------------
function FinishPersonDataWinUI:initView()
    local posy = self.winSize.height * 0.7
    -- 真实姓名
    local lbl_realName = cc.Label:createWithTTF(LangCtrl:getLang().word102, GameDefine.FontName, 24)
    lbl_realName:setColor(GameDefine.FontColor)
    lbl_realName:align(display.RIGHT_CENTER, 280, posy):addTo(self.panelNode)

    local edit_realName = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_realName:setFont(GameDefine.FontName, 24)
    edit_realName:setFontColor(GameDefine.FontColor_edit)
    edit_realName:setMaxLength(GameDefine.LEN_COMPELLATION - 1)
    edit_realName:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_realName:setPlaceHolder(LangCtrl:getLang().word103)
    edit_realName:setPlaceholderFontSize(24)
    edit_realName:setPlaceholderFontName(GameDefine.FontName)
    edit_realName:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_realName:align(display.LEFT_CENTER, 280, posy):addTo(self.panelNode)
    self.edit_realName = edit_realName

    -- 输入身份证号
    local lbl_realID = cc.Label:createWithTTF(LangCtrl:getLang().word104, GameDefine.FontName, 24)
    lbl_realID:setColor(GameDefine.FontColor)
    lbl_realID:align(display.RIGHT_CENTER, 280, posy - 70):addTo(self.panelNode)

    local edit_realID = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_realID:setFont(GameDefine.FontName, 24)
    edit_realID:setFontColor(GameDefine.FontColor_edit)
    edit_realID:setMaxLength(GameDefine.LEN_PASS_PORT_ID - 1)
    edit_realID:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_realID:setPlaceHolder(LangCtrl:getLang().word105)
    edit_realID:setPlaceholderFontSize(24)
    edit_realID:setPlaceholderFontName(GameDefine.FontName)
    edit_realID:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_realID:align(display.LEFT_CENTER, 280, posy - 70):addTo(self.panelNode)
    self.edit_realID = edit_realID

    self.objMobile = MobilePhone.new()
    self.objMobile:align(display.LEFT_CENTER, 0, posy - 140):addTo(self.panelNode)

    -- QQ/微信
    local lbl_QQ = cc.Label:createWithTTF(LangCtrl:getLang().word106, GameDefine.FontName, 24)
    lbl_QQ:setColor(GameDefine.FontColor)
    lbl_QQ:align(display.RIGHT_CENTER, 280, posy - 210):addTo(self.panelNode)

    local edit_QQ = ccui.EditBox:create(cc.size(412, 46), "app/common/comwin/edit_bg.png")
    edit_QQ:setFont(GameDefine.FontName, 24)
    edit_QQ:setFontColor(GameDefine.FontColor_edit)
    edit_QQ:setMaxLength(GameDefine.LEN_WEIXIN - 1)
    edit_QQ:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_QQ:setPlaceHolder(LangCtrl:getLang().word107)
    edit_QQ:setPlaceholderFontSize(24)
    edit_QQ:setPlaceholderFontName(GameDefine.FontName)
    edit_QQ:setPlaceholderFontColor(GameDefine.FontColor_edit)
    edit_QQ:align(display.LEFT_CENTER, 280, posy - 210):addTo(self.panelNode)
    self.edit_QQ = edit_QQ

    -- 赋值
    self:initPersonInfo()

    self.modiList = {}
    self.acceptCount = 0
    local function onClickReSet(ref)
        self.modiList = {}
        self.acceptCount = 0
        -- 真实姓名
        local realName = self.edit_realName:getText()
        if realName == nil then
            realName = ""
        end
        if globalUserInfo.szCompellation == nil then
            globalUserInfo.szCompellation = ""
        end

        if string.len(realName) > 0 and string.trim(realName) == "" then
            PlazaManager.showTips(LangCtrl:getLang().word108)
            return
        end

        if globalUserInfo.szCompellation ~= realName then
            local itemData = {
                name = "真实姓名",
                modiType = 3,
                modiStr = realName,
                modiSuccFlag = false
            }
            table.insert(self.modiList, itemData)
        end

        -- 身份证号
        local realID = self.edit_realID:getText()
        if realID == nil then
            realID = ""
        end
        if globalUserInfo.szPassPortID == nil then
            globalUserInfo.szPassPortID = ""
        end

        if string.len(realID) > 0 and (string.trim(realID) == "" or string.len(string.trim(realID)) ~= 18) then
            PlazaManager.showTips(LangCtrl:getLang().word109)
            return
        end

        if string.len(realID) ~= string.len(string.trim(realID)) then
            PlazaManager.showTips(LangCtrl:getLang().word109)
            return
        end

        if string.trim(globalUserInfo.szPassPortID) ~= realID then
            local itemData = {
                name = "身份证号",
                modiType = 4,
                modiStr = realID,
                modiSuccFlag = false
            }
            table.insert(self.modiList, itemData)
        end

        if self.objMobile:verifyMobile() ~= 0 then
            PlazaManager.showTips(LangCtrl:getLang().word110)
            return
        end

        -- 手机号码
        local phoneStr = self.objMobile:getMobileStr()
        if globalUserInfo.szMobilePhone == nil then
            globalUserInfo.szMobilePhone = ""
        end

        if globalUserInfo.szMobilePhone ~= phoneStr then
            local itemData = {
                name = "手机号码",
                modiType = 6,
                modiStr = phoneStr,
                modiSuccFlag = false
            }
            table.insert(self.modiList, itemData)
        end

        -- 微信号
        local szWeixin = self.edit_QQ:getText()
        if szWeixin == nil then
            szWeixin = ""
        end
        if globalUserInfo.szWeixin == nil then
            globalUserInfo.szWeixin = ""
        end

        if string.len(szWeixin) > 0 and string.trim(szWeixin) == "" then
            PlazaManager.showTips(LangCtrl:getLang().word111)
            return
        end

        if globalUserInfo.szWeixin ~= szWeixin then
            local itemData = {
                name = "微信",
                modiType = 7,
                modiStr = szWeixin,
                modiSuccFlag = false
            }
            table.insert(self.modiList, itemData)
        end

        if #self.modiList > 0 then
            PlazaManager.showConectWaitTips(nil)
            local function onConnectResult(isSuccess, ipsCount)
                PlazaManager.onConnectResult(isSuccess, ipsCount, nil, LangCtrl:getLang().word112, LangCtrl:getLang().word113)
                if isSuccess == true then
                    for i = 2, #self.modiList do
                        PlazaManager.getLoginModule().onModifyIndividual(self.modiList[i].modiType, self.modiList[i].modiStr)
                    end
                end
            end
            PlazaManager.getLoginModule().onModifyIndividual(self.modiList[1].modiType, self.modiList[1].modiStr, onConnectResult)
        else
            PlazaManager.showTips(LangCtrl:getLang().word114)
        end
    end

    local btn_ok = GameUtil.createButton("app/common/button/btn1.png", nil, onClickReSet):move(self.midWidth, 110):addTo(self.panelNode)

    GameUtil.addBtnTTF2(LangCtrl:getLang().word11, btn_ok) -- 确定

    self:addCloseBtn()
end

---------------逻辑函数---------------------------
function FinishPersonDataWinUI:initPersonInfo()
    local infoData = {}
    infoData.realName = globalUserInfo.szCompellation
    if infoData.realName == nil then
        infoData.realName = ""
    end

    infoData.personCardID = globalUserInfo.szPassPortID
    if infoData.personCardID == nil then
        infoData.personCardID = ""
    end

    infoData.szMobilePhone = globalUserInfo.szMobilePhone
    if infoData.szMobilePhone == nil then
        infoData.szMobilePhone = ""
    end

    infoData.szWeixin = globalUserInfo.szWeixin
    if infoData.szWeixin == nil then
        infoData.szWeixin = ""
    end

    infoData.realName = string.trim(infoData.realName)
    infoData.personCardID = string.trim(infoData.personCardID)
    infoData.szMobilePhone = string.trim(infoData.szMobilePhone)
    infoData.szWeixin = string.trim(infoData.szWeixin)

    self.edit_realName:setText(infoData.realName)
    self.edit_realID:setText(infoData.personCardID)
    self.objMobile:setEditText(infoData.szMobilePhone)
    self.edit_QQ:setText(infoData.szWeixin)
end

---------------消息处理函数------------------------
function FinishPersonDataWinUI:sendSearchUserInfoPC()
    PlazaManager.getRefreshModule().onSearchUserGold()
end

-- (1、昵称。2、头像，3.真实姓名,4.身份证号码，5.QQ号，6.用于显示的手机号7.微信号)
function FinishPersonDataWinUI:sendModiInfoMessage(modiType, modiStr)
    PlazaManager.getLoginModule().onModifyIndividual(modiType, modiStr)
end

function FinishPersonDataWinUI:onModifyPersonInfoSuccess(data)
    for i = 1, #self.modiList do
        if self.modiList[i].modiType == data.wModifyType then
            self.modiList[i].modiSuccFlag = true
            break
        end
    end
    self.acceptCount = self.acceptCount + 1

    if self.acceptCount == #self.modiList then
        PlazaManager.closeWattingTips()
        local str_1 = ""
        for i = 1, #self.modiList do
            if self.modiList[i].modiSuccFlag == true then
                str_1 = str_1 .. " " .. tostring(self.modiList[i].name)
            end
        end
        if str_1 ~= "" then
            PlazaManager.showTips(LangCtrl:getLang().word115 .. str_1 .. LangCtrl:getLang().word116)
            self:initPersonInfo()
        end
    end
end
function FinishPersonDataWinUI:onModifyPersonInfoFail(data)
    self.acceptCount = self.acceptCount + 1

    if self.acceptCount == #self.modiList then
        PlazaManager.closeWattingTips()
        local str_1 = ""
        for i = 1, #self.modiList do
            if self.modiList[i].modiSuccFlag == true then
                str_1 = str_1 .. " " .. tostring(self.modiList[i].name)
            end
        end
        if str_1 ~= "" then
            PlazaManager.showTips(LangCtrl:getLang().word115 .. str_1 .. LangCtrl:getLang().word116)
            self:initPersonInfo()
        end
    end
end

function FinishPersonDataWinUI:onSeachUserInfoPCSuccess(data)
    self:initPersonInfo()
end
return FinishPersonDataWinUI
