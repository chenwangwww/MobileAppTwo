-- region ZoomAvatarWin.lua
-- Author : admin
-- Date   : 2017/7/24
-- 此文件由[BabeLua]插件自动生成
local ZoomAvatarWin = class("ZoomAvatarWin", require("app.win.base.GameWindowBase"))

function ZoomAvatarWin:ctor(spriteFrame)
    local size = cc.size(400, 400)
    ZoomAvatarWin.super.ctor(self, size, false)

    if spriteFrame == nil then
        display.newSprite("app/win/zoomavatar/img_default.png"):align(display.CENTER, self.midWidth, self.midHeight):addTo(self)
    else
        self:initView(spriteFrame)
    end
end

function ZoomAvatarWin:initView(spriteFrame)
    if spriteFrame ~= nil then
        local avatar = cc.Sprite:createWithSpriteFrame(spriteFrame)
        if avatar ~= nil then
            local scale = 0
            -- if avatar:getContentSize().width < 400 then
            scale = 400 / avatar:getContentSize().width
            -- end
            avatar:setScaleX(scale)
            avatar:setScaleY(scale)
            avatar:align(display.CENTER, self.midWidth, self.midHeight):addTo(self)
        end
    end
end

return ZoomAvatarWin

-- endregion
