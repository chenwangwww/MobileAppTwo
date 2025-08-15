local HallGoldRoomLayer = class("HallGoldRoomLayer", require("app.views.base.BaseHallLayer"))
local HallNodeTop = require "app.views.hall.HallNodeTop"
local HallNodeBottom = require "app.views.hall.HallNodeBottom"
local HallNodeNotice = require "app.views.hall.HallNodeNotice"
local HallNodeRoomList = require "app.views.hall.HallNodeRoomList"
-- local WeChatManager = require "app.platform.common.WeChatManager"

function HallGoldRoomLayer:ctor(dwKindID, pageIdx)
    self.dwKindID = dwKindID
    self.pageIdx = pageIdx

    local size = cc.size(display.width, display.height)
    HallGoldRoomLayer.super.ctor(self, size, GameDefine.HALL_LAYER_INDEX.GOLD_ROOM, self.dwKindID)
    self:initView()
end

function HallGoldRoomLayer:initView()
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
    topArgs.index = GameDefine.HALL_LAYER_INDEX.GOLD_ROOM
    topArgs.callback = topCallback
    self.topNode = HallNodeTop.new(topArgs)
    self.topNode:align(display.CENTER_TOP, display.cx, display.height):addTo(self)

    if PlazaManager.isCheck ~= true then
        -- 游戏标题

        local gameInfo = ServerListData.getGameByKindID(self.dwKindID)
        local namestr = LangCtrl:gameName(self.dwKindID, gameInfo.szKindName)
        local fontSize = 40
        if LangCtrl:isEng() then
            fontSize = 35
        end
        local lbl = cc.Label:createWithTTF(namestr, "fonts/fzcs.ttf", fontSize)
        lbl:setColor(cc.c3b(255, 240, 165))
        lbl:setAnchorPoint(display.CENTER)
        lbl:setPosition(cc.p(980, 60))
        lbl:enableOutline(cc.c4b(94, 26, 5, 255), 2)
        self.topNode:addChild(lbl)
    end

    -- 公告
    self.noticeNode = HallNodeNotice.new()
    self.noticeNode:align(display.CENTER, display.cx, display.height - 120):addTo(self)

    -- 底部面板
    self.bottomNode = HallNodeBottom.new()
    self.bottomNode:align(display.CENTER_BOTTOM, display.cx, 0):addTo(self)

    -- 房间列表
    if self.dwKindID ~= nil and type(self.dwKindID) == "number" then
        local function goldRoomCallback(args)
            self:onGoldRoomCallback(args)
        end
        local goldRoomArgs = {}
        goldRoomArgs.index = GameDefine.HALL_LAYER_INDEX.GOLD_ROOM
        goldRoomArgs.callback = goldRoomCallback
        goldRoomArgs.dwKindID = self.dwKindID
        self.roomList = HallNodeRoomList.new(goldRoomArgs)
        self.roomList:align(display.CENTER, display.cx, display.cy - 35):addTo(self)
    end
end

function HallGoldRoomLayer:onNodeAction()
    -- GameUtil.runEaseInAction(self.topNode,cc.p(display.cx,display.height))
    -- GameUtil.runEaseInAction(self.bottomNode,cc.p(display.cx,0))
    -- GameUtil.runEaseInAction(self.noticeNode,cc.p(display.cx,display.height-120))
    -- GameUtil.runEaseInAction(self.roomList,cc.p(display.cx,display.cy-30),0.2)
end

function HallGoldRoomLayer:onEnter()
    self:onNodeAction()
end

function HallGoldRoomLayer:onTopCallback(args)
    if args == "back" then
        self:onBackMainHall()
    end
end

function HallGoldRoomLayer:onGoldRoomCallback(args)
    local gameServer = args

    local function onConnectFailer()
        PlazaManager.isOpenGameScene = false
        PlazaManager.resetServerModuleData()
        PlazaManager.resetRoomServer()
        PlazaManager.closeGameSocket()
        PlazaManager.closeWattingTips()
    end

    local function onConnectOutTime()
        onConnectFailer()
        PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word269)
    end

    PlazaManager.showWattingTips(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)

    local function onConnectResult(isSuccess, ipsCount)
        if isSuccess == false then
            if ipsCount and ipsCount > 0 then
                PlazaManager.setWattingData(LangCtrl:getLang().word265, GameDefine.connectTime, onConnectOutTime, nil, true)
            else
                onConnectFailer()
                PlazaManager.showConfirmNode("ok", LangCtrl:getLang().word261)
            end
        else
            PlazaManager.setWattingData(LangCtrl:getLang().word250, GameDefine.processTime, onConnectOutTime, nil, true)
        end
    end

    local args = {}
    args.tagGameServer = gameServer

    args.paramsData = nil
    args.connType = PlazaManager.getServerModule().getLinkActionEnum().link_join
    PlazaManager.getServerModule().onConnectionGR(args, onConnectResult)
end

function HallGoldRoomLayer:onBackMainHall()
    local args = {
        index = GameDefine.HALL_LAYER_INDEX.HALL,
        nPageIdx = self.pageIdx
    }
    game.sendEvent(GameDefine.SWITCH_HALL_LAYER, args)
end

return HallGoldRoomLayer

-- endregion
