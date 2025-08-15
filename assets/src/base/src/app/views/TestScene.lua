local TestScene = class("TestScene", cc.load("mvc").ViewBase)

require "app.platform.common.GameDefine"
require "app.platform.common.PlazaManager"
local Buttons = require "app.components.Buttons"
local Utils = require "app.components.Utils"
local Layout = require "app.components.Layout"

local function changeRootView_V()
    ChangeRootView.changeRootViewV()
    display.changeRootView(false)
end

local function changeRootView_H()
    ChangeRootView.changeRootViewH()
    display.changeRootView(true)
end

local function videoRtcTest(self)
    local bg = display.newNode():setContentSize(display.size):addTo(self)

    print("display.size:", display.size.width, display.size.height)
    debugDraw(bg, cc.c4f(0, 0, 1, 1))

    local lbl = Utils.newLabel("", 22, cc.WHITE, display.CENTER_TOP, cc.p(display.cx, display.height), self, 2)

    local posEditBox;
    local videoWidth = 100
    local function onClickItem(idx)
        if idx == 1 then
            game.addVideoRtcInfo("S_1", 0, display.height - videoWidth, videoWidth, videoWidth);

        elseif idx == 2 then
            game.addVideoRtcInfo("S_3", display.width - videoWidth, display.height - videoWidth, videoWidth, videoWidth);
        elseif idx == 3 then
            game.addVideoRtcInfo("S_2", 0, 0, videoWidth, videoWidth);

        elseif idx == 4 then
            game.addVideoRtcInfo("S_4", display.width - videoWidth, 0, videoWidth, videoWidth);
        elseif idx == 5 then
            local succ = game.initVideoRtc("120.79.84.189:8001", "111999", "S_" .. posEditBox:getText())
            lbl:setString(string.format("初始化视频：%s", succ and "成功" or "失败"))

            self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                game.addVideoRtcInfo("S_" .. posEditBox:getText(), 0, display.height - videoWidth, videoWidth, videoWidth);
            end)))
        elseif idx == 6 then
            game.setVideoRtcVisible(not game:isVideoRtcVisible())
        elseif idx == 7 then
            local val = posEditBox:getText()
            local succ = game.deleteVideoRtcInfo("S_" .. val)
            lbl:setString(string.format("删除视频：%s", succ and "成功" or "失败"))
        elseif idx == 8 then
            game.releaseVideoRtc()
        elseif idx == 9 then
            if display.width > display.height then
                changeRootView_V()
            else
                changeRootView_H()
            end

            self:removeAllChildren()
            self.videoRtcTest(self)
        elseif idx == 10 then
            local val = posEditBox:getText()
            local online = game.isVideoRtcOnline("S_" .. val)
            lbl:setString(string.format("玩家是否打开视频: %s", online and "在线" or "离线"))
        elseif idx == 11 then
            local val = posEditBox:getText()
            local online = game.isVideoAdded("S_" .. val)
            lbl:setString(string.format("玩家是否打开视频: %s", online and "在线" or "离线"))
        end
    end

    local btnStrs = {"左上角", "右上角", "左下角", "右下角", "初始化视频", "隐藏显示视频", "删除视频", "卸载视频", "旋转屏幕", "是否有视频",
                     "是否添加过视频"}
    local btns = {}
    for i, v in ipairs(btnStrs) do
        local lbl = Utils.newLabel(v, 50, cc.WHITE, 0.5)
        local btn = Buttons.createButton(true, 0.9, function(btn)
            onClickItem(i)
        end)
        Buttons.initButtonWithNode(btn, lbl)
        btns[i] = btn
    end

    local node = Layout.createTBox("row", nil, 2, btns, {
        col = 30,
        row = 30
    })
    node:align(display.CENTER_TOP, display.cx, display.height - 50):addTo(self)

    posEditBox = cc.EditBox:create(cc.size(300, 80), "app/login/check_1.png", ccui.TextureResType.localType)
    posEditBox:setFontName("fonts/pingfang.ttf")
    posEditBox:setFontSize(30)
    posEditBox:setFontColor(cc.BLACK)
    posEditBox:setMaxLength(30)
    posEditBox:setPlaceHolder("请输入位子1-4")
    posEditBox:setPlaceholderFont("fonts/pingfang.ttf", 30)
    posEditBox:setPlaceholderFontColor(cc.c3b(125, 0, 0))
    posEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    posEditBox:align(display.CENTER_TOP, display.cx, node:getPositionY() - node:getContentSize().height - 50)
    self:addChild(posEditBox)
end

local function imageCompress(self)
    local fileName = PlazaManager.getWritablePath() .. "imagecompresstest.png"

    local function onCapture(succ, path)
        print(">>>>>", tostring(succ), path)

        local path = game.imageCompress(path)
        print(">>>>>>.压缩后", path, cc.FileUtils:getInstance():getFileSize(path))
    end

    local function onClickItem(idx)
        if idx == 1 then
            cc.utils:captureScreen(onCapture, fileName)
        end
    end

    local btnStrs = {"屏幕截图&压缩测试"}
    local btns = {}
    for i, v in ipairs(btnStrs) do
        local lbl = Utils.newLabel(v, 50, cc.WHITE, 0.5)
        local btn = Buttons.createButton(true, 0.9, function(btn)
            onClickItem(i)
        end)
        Buttons.initButtonWithNode(btn, lbl)
        btns[i] = btn
    end

    local node = Layout.createTBox("row", nil, 2, btns, {
        col = 30,
        row = 30
    })
    node:align(display.CENTER_TOP, display.cx, display.height - 50):addTo(self)
end

function TestScene:onCreate(data)
    self:setContentSize(display.size)

    -- 视频测试
    if 1 == 2 then
        self.videoRtcTest = videoRtcTest
        videoRtcTest(self)
    end

    -- 图片压缩测试
    if 1 == 1 then
        imageCompress(self)
    end
end

function TestScene:onRelease(data)
    game.unregisterEvent(GameDefine.GP_LOGIN_FINISH_EVENT, data.onLoginFinishEvent)
end

return TestScene
