local _M = {}

local function drawBg(node, color)
    local drawNode = cc.DrawNode:create()
    local size = node:getContentSize()
    local poses = {display.LEFT_BOTTOM, cc.p(size.width, 0), cc.p(size.width, size.height), cc.p(0, size.height)}
    if color == nil then
        color = cc.c4f(0, 0, 0, 1)
    end
    drawNode:drawSolidPoly(poses, 4, color)
    drawNode:setPosition(display.LEFT_BOTTOM)
    node:addChild(drawNode)
end

function _M.play(file, zorder)
    local platform = cc.Application:getInstance():getTargetPlatform()

    if platform ~= cc.PLATFORM_OS_ANDROID and platform ~= cc.PLATFORM_OS_IPHONE and platform ~= cc.PLATFORM_OS_IPAD then
        error("this platfrom not support!")
    end

    if zorder == nil then
        zorder = 0
    end

    if platform == cc.PLATFORM_OS_IPHONE or platform == cc.PLATFORM_OS_IPAD then
        game.playVideo(file, zorder)
        return
    end

    local runningScene = display.getRunningScene()

    local node = display.newNode()
    node:setContentSize(display.size)
    node:setColor(cc.RED)

    drawBg(node)
    runningScene:addChild(node, zorder)

    local video = ccexp.VideoPlayer:create()
    video:setContentSize(display.size);
    video:align(display.CENTER, display.cx, display.cy);
    video:setKeepAspectRatioEnabled(true)
    video:setFullScreenEnabled(false)
    video:setFileName(file)
    node:addChild(video, 255)

    if platform == cc.PLATFORM_OS_ANDROID then
        local function onVideoEventCallback(sener, eventType)
            print(">>>>>接收到消息onVideoEventCallback ", eventType)
            if eventType == ccexp.VideoPlayerEvent.PLAYING then
            elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
            elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
            elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
                video:setFileName(file)
            elseif eventType == 255 then
                print(">>>>>>删除视频控件")
                node:removeFromParent()
            end
        end
        video:addEventListener(onVideoEventCallback)
    end
    video:play()
    node:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
        video:showController()
    end)))

end

return _M
