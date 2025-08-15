-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local LoadLayer = class("LoadLayer", function()
    return display.newLayer()
end)

function LoadLayer:ctor()
    self:setContentSize(cc.size(display.width, display.height))
    self:initView()
end

function LoadLayer:initView()
    -- 加载背景
    -- local imge_bg = display.newSprite("app/login/bg_denglu1.png"):move(display.center):addTo(self)
    -- local contentSize = imge_bg:getContentSize()
    -- imge_bg:setScale(display.width / contentSize.width, display.height / contentSize.height)

    -- local loginBg = cc.Sprite:create("app/login/bg_denglu2.png")
    -- loginBg:move(display.center):addTo(self)
    local imge_bg = display.newSprite("app/login/bg_denglu2.png"):move(display.center):addTo(self)
    local contentSize = imge_bg:getContentSize()

    -- 计算缩放比例，取宽高比的最大值，确保图片完全覆盖屏幕
    local scaleX = display.width / contentSize.width
    local scaleY = display.height / contentSize.height
    local scale = math.max(scaleX, scaleY) -- 选择较大的缩放比例

    imge_bg:setScale(scale)            -- 等比缩放

    -- 游戏版本
    self.labelVersion = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 20)
    self.labelVersion:align(display.LEFT_TOP, 20, display.height - 30)
    self.labelVersion:addTo(self)

    -- 底部背景
    -- local downbg = display.newSprite("app/common/mask.png"):align(display.CENTER, display.cx, 35):addTo(self)
    -- downbg:setOpacity(120)
    -- downbg:setScale(display.width / 5, 62 / 5)

    -- 提示
    self.hitLabel = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 18):align(display.CENTER, display.cx, 50):addTo(self)
    self.hitLabel:setColor(cc.c3b(05, 29, 42))

    -- 申明
    self.declareLabel = cc.Label:createWithTTF("", "app/fonts/fzz.ttf", 18):align(display.CENTER, display.cx, 20):addTo(
    self)
    self.declareLabel:setColor(cc.c3b(05, 29, 42))

    -- 进度条
    self.hitProgress = self:createProgress():align(display.CENTER, display.cx, 100):addTo(self)
end

function LoadLayer:createProgress()
    local node = cc.Node:create()
    local progBg = display.newSprite("app/common/progress/bgprogress3.png")
    local size = progBg:getContentSize()
    node:setContentSize(size)
    progBg:move(size.width / 2, size.height / 2):addTo(node)

    local progSp = cc.ProgressTimer:create(display.newSprite("app/common/progress/progress3.png"))
    progSp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progSp:setBarChangeRate(display.RIGHT_BOTTOM)
    progSp:setMidpoint(display.LEFT_TOP)
    progSp:setPosition(size.width / 2, size.height / 2):addTo(node)

    local lbl = cc.Label:createWithTTF(LangCtrl:getLang().word282, "app/fonts/fzz.ttf", 22)
    lbl:setColor(cc.c3b(0xFF, 0xFF, 0xFF))
    lbl:enableOutline(cc.c4b(0x01, 0x50, 0x72, 0xFF), 2)
    lbl:setAnchorPoint(display.CENTER)
    lbl:setPosition(cc.p(size.width / 2, size.height / 2 + 30))
    node:addChild(lbl)

    function node:setProcress(percent)
        if progSp ~= nil then
            progSp:setPercentage(percent)
        end
    end

    function node:setProcressLabel(procressStr)
        if lbl ~= nil then
            lbl:setString(procressStr)
        end
    end

    function node:onStartLabelAnimation()

    end

    function node:onStopLabelAnimation()

    end

    return node
end

function LoadLayer:setLoadInfo(args)
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

function LoadLayer:setProcress(progress)
    if self.hitProgress ~= nil then
        self.hitProgress:setProcress(progress)
    end
end

function LoadLayer:setProcressLabel(str)
    if self.hitProgress ~= nil then
        self.hitProgress:setProcressLabel(str)
    end
end

return LoadLayer

-- endregion
