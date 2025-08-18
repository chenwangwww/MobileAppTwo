-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local HallMainLayer = class("HallMainLayer", require("app.views.base.BaseHallLayer"))

local WeChatManager = require "app.platform.common.WeChatManager"
local HallNodeTop = require "app.views.hall.HallNodeTop"
local HallNodeBottom = require "app.views.hall.HallNodeBottom"
local HallNodeGameList = require "app.views.hall.HallNodeGameList"
local HallNodeNotice = require "app.views.hall.HallNodeNotice"
local HallNodePicture = require "app.views.hall.HallNodePicture"

function HallMainLayer:ctor(nPageIdx)
    self.nPageIdx = nPageIdx
    local size = cc.size(display.width, display.height)
    HallMainLayer.super.ctor(self, size, GameDefine.HALL_LAYER_INDEX.HALL)
    self:initView()
end

function HallMainLayer:initView()
    -- 背景
    -- local imge_bg = GameUtil.newSprite("app/hall/bg_zdt.png", false):align(display.LEFT_BOTTOM, 0, 0):addTo(self)
    -- local contentSize = imge_bg:getContentSize()
    -- imge_bg:setScale(display.width / contentSize.width, display.height / contentSize.height)
    local imge_bg = GameUtil.newSprite("app/hall/bg_zdt.png", false)
    :align(display.CENTER_BOTTOM, display.cx, 0)  -- 水平居中，垂直底部对齐
    :addTo(self)
    local contentSize = imge_bg:getContentSize()
    -- 计算缩放比例，保持宽高比不变，确保图片覆盖全屏
    local scale = math.max(display.width / contentSize.width, display.height / contentSize.height)
    imge_bg:setScale(scale)

    -- 顶部面板
    local function topCallback(args)
        self:onTopCallback(args)
    end
    local topArgs = {}
    topArgs.index = GameDefine.HALL_LAYER_INDEX.HALL
    topArgs.callback = topCallback
    self.topNode = HallNodeTop.new(topArgs)
    self.topNode:align(display.CENTER_TOP, display.cx, display.height):addTo(self)

    -- 游戏列表
    self.gameListNode = HallNodeGameList.new(self.nPageIdx)
    self.gameListNode:align(display.CENTER, display.cx + 120, display.cy - 50):addTo(self)

    if PlazaManager.hotShowGameData then
        self:createHotShow()
    else
        -- 分享图片
        self.pictureNode = HallNodePicture.new()
        self.pictureNode:align(display.CENTER, display.cx - 420, display.cy - 30):addTo(self)
    end

    -- 公告
    self.noticeNode = HallNodeNotice.new()
    self.noticeNode:align(display.CENTER, display.cx, display.height - 120):addTo(self)

    -- 底部面板
    self.bottomNode = HallNodeBottom.new()
    self.bottomNode:align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)
end

-- 创建游戏按钮
function HallMainLayer:createHotShow()
    local function onClickGame(sender, eventtype)
        if eventtype == ccui.TouchEventType.began then
            sender:runAction(cc.ScaleTo:create(0.1, 0.9))
            PlazaManager.playClickEffect()
        elseif eventtype == ccui.TouchEventType.ended then
            sender:runAction(cc.ScaleTo:create(0.1, 1.0))

            local posx, posy = sender:getPosition()
            local downPos = sender:getParent():convertToWorldSpace(cc.p(posx, posy))

            local gameinfo = sender.gameInfo
            local function callFinishFunc(result, wKindID)
                local isUpdateStatus = PlazaManager.checkGameVersion(wKindID)
                if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NORMAL then
                    if sender:getChildByName("icon_updata") ~= nil then
                        sender:getChildByName("icon_updata"):setVisible(false)
                    end
                end
            end
            self.gameListNode:onChooseGameItem(gameinfo, downPos, callFinishFunc)
        elseif eventtype == ccui.TouchEventType.canceled then
            sender:runAction(cc.ScaleTo:create(0.1, 1.0))
        end
    end

    local gameItem = ccui.Layout:create()
    gameItem:setContentSize(300, 400)
    gameItem:align(display.CENTER, display.cx - 490, display.cy - 15):addTo(self)
    gameItem:setTouchEnabled(true)
    gameItem:addTouchEventListener(onClickGame)
    gameItem.gameInfo = PlazaManager.hotShowGameData

    local jsonPath = "app/hall/gamelist/zdt_ani/zdt_tiaogaogao/zdt_tiaogaogao.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(jsonPath)
    local armature = ccs.Armature:create("zdt_tiaogaogao") -- 创建动画对象
    armature:getAnimation():play("tgg") -- 设置动画对象执行的动画名称
    armature:align(display.CENTER, 150, 200):addTo(gameItem)

    local namestr = LangCtrl:gameName(PlazaManager.hotShowGameData.wKindID, PlazaManager.hotShowGameData.szKindName)
    local content = cc.Label:createWithTTF(namestr, "app/fonts/fzcy.ttf", 40)
    content:setColor(cc.c3b(255, 255, 255))
    -- content:enableOutline(cc.c4b(132, 77, 24, 255), 2)
    content:enableOutline(cc.c3b(0x01, 0x50, 0x72), 2)
    content:align(display.CENTER, 150, 48):addTo(gameItem) --  307  478

    -- GameUtil.newSprite("app/hall/gamelist/huobao.png", false):align(display.LEFT_CENTER, 0, 190):addTo(gameItem)

    -- 更新图标
    local isUpdateStatus = PlazaManager.checkGameVersion(PlazaManager.hotShowGameData.wKindID)
    if isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.UPDATE or isUpdateStatus == GameDefine.GAME_UPDATE_STATUE.NeverDownloaded then
        local img_updata = GameUtil.newSprite("app/hall/gamelist/tip_gx.png", false):align(display.CENTER, 170, 400):addTo(gameItem)
        img_updata:setName("icon_updata")
    end
end

function HallMainLayer:onNodeAction()
    -- GameUtil.runEaseInAction(self.topNode,cc.p(display.cx,display.height))
    -- GameUtil.runEaseInAction(self.bottomNode,cc.p(display.cx,0))
    -- GameUtil.runEaseInAction(self.rankNode,cc.p(290,display.cy-30))
    -- GameUtil.runEaseInAction(self.gameListNode,cc.p(900,display.cy-30))
    -- GameUtil.runEaseInAction(self.noticeNode,cc.p(display.cx,display.height-120))
end

function HallMainLayer:onEnter()
    self:onNodeAction()
end

function HallMainLayer:onTopCallback(args)
    if args == "close" then
        self:outLogin()
    end
end

-- 退出登录
function HallMainLayer:outLogin()
    local function afterFunction()
        -- 清除登录数据
        globalUserInfo:resetUserInfo()

        -- 清空服务数据
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()

        -- 关闭网络连接
        PlazaManager.closeRefreshSocket()
        PlazaManager.closeLoginSocket()
        PlazaManager.closeGameSocket()

        -- 清除保存微信的账号数据
        WeChatManager.clearWXData()

        -- 清除保存游客的账号数据
        cc.UserDefault:getInstance():setStringForKey("yk_c_account", "")
        cc.UserDefault:getInstance():setStringForKey("yk_c_password", "")

        -- 清除银行数据
        PlazaManager.resetBankData()
        PlazaManager.BindPhoneTipShowChk = false

        PlazaManager.isGameOutHall = false

        self:runAction(cc.CallFunc:create(function()
            require("app.MyApp"):create():run("LoginScene", true)
        end))
    end

    PlazaManager.showConfirmNode("out_continue", LangCtrl:getLang().word228, nil, function(isChk)
        if (isChk == false) then
            return
        end
        afterFunction()
    end)
end

return HallMainLayer

-- endregion
