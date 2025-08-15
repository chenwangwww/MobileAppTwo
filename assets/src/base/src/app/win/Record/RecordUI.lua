-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local RecordUI = class("RecordUI", require("app.win.base.GameWindowBase"))

function RecordUI:ctor()
    local size = cc.size(413, 160)
    RecordUI.super.ctor(self, size, false)
    self:initView(size)
end

function RecordUI:initView(size)
    local node = cc.Node:create()
    local progBg = display.newSprite("app/win/record/img_bg.png")
    local bgsize = progBg:getContentSize()
    node:setContentSize(size)
    node:move(0, 0):addTo(self)
    progBg:move(size.width / 2, bgsize.height / 2):addTo(node)

    local img_speed = ccui.ImageView:create("app/win/record/image_speed_1.png")
    img_speed:setPosition(size.width / 2, size.height - 40)
    img_speed:addTo(node)

    local function loadSpeedRes()
        local level = PlazaManager.recordManager:getPlaySpeedLevel()
        local pngName = string.format("app/win/record/image_speed_%s.png", level)
        img_speed:loadTexture(pngName)
    end

    -- 快退
    local function onClickRetreat(args)
        PlazaManager.recordManager:setPlaySpeedLevel(true)
        loadSpeedRes()
    end

    -- 暂停
    local function onClickPause(args)
        if PlazaManager.recordManager ~= nil then
            PlazaManager.recordManager.isPause = true
            self.btn_pause:setVisible(false)
            self.btn_play:setVisible(true)
        end
    end

    -- 取消暂停
    local function onClickPlay(args)
        if PlazaManager.recordManager ~= nil then
            PlazaManager.recordManager.isPause = false
            self.btn_play:setVisible(false)
            self.btn_pause:setVisible(true)
        end
    end

    -- 快进
    local function onClickInto(args)
        PlazaManager.recordManager:setPlaySpeedLevel(false)
        loadSpeedRes()
    end

    -- 关闭
    local function onClickClose(args)
        game.sendEvent(GameDefine.EXIT_GAMESCENE_FINISH_EVENT)
    end

    GameUtil.createButton("app/win/record/btn_retreat_normal.png", "app/win/record/btn_retreat_select.png", onClickRetreat):move(bgsize.width / 2 - 150, bgsize.height / 2):addTo(progBg)
    self.btn_pause = GameUtil.createButton("app/win/record/btn_pause_normal.png", "app/win/record/btn_pause_select.png", onClickPause):move(bgsize.width / 2 - 50, bgsize.height / 2):addTo(progBg)
    GameUtil.createButton("app/win/record/btn_into_normal.png", "app/win/record/btn_into_select.png", onClickInto):move(bgsize.width / 2 + 60, bgsize.height / 2):addTo(progBg)
    GameUtil.createButton("app/win/record/btn_close_normal.png", "app/win/record/btn_close_select.png", onClickClose):move(bgsize.width / 2 + 150, bgsize.height / 2):addTo(progBg)
    self.btn_play = GameUtil.createButton("app/win/record/btn_play_normal.png", "app/win/record/btn_play_select.png", onClickPlay):move(bgsize.width / 2 - 50, bgsize.height / 2):addTo(progBg):hide()

    local function onTouchBegan(touch, event)
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    node:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, node)
end

return RecordUI

-- endregion
