-- region HappyFruitSetWin.lua
-- Author : admin
-- Date   : 2017/9/2
-- 此文件由[BabeLua]插件自动生成
local HappyFruitSetWin = class("HappyFruitSetWin", require("app.win.base.GameWindowBase"))
local SFUtils = require "app.components.SpriteFrameUtils"

function HappyFruitSetWin:ctor()
    local size = cc.size(545, 480)
    HappyFruitSetWin.super.ctor(self, size, true)
    self:setContentSize(size)
    self:initView(size)
end

function HappyFruitSetWin:initView(size)

    local img_bg = SFUtils.newSprite("fruit_machine_set_bg.png")
    img_bg:move(size.width / 2, size.height / 2):addTo(self)
    local img_size = img_bg:getContentSize()

    local img_title = ccui.ImageView:create("fruit_machine_setting_title.png", ccui.TextureResType.plistType)
    img_title:setPosition(img_size.width / 2, img_size.height - 20)
    img_bg:addChild(img_title)

    local img_music = ccui.ImageView:create("fruit_machine_musicon.png", ccui.TextureResType.plistType)
    img_music:setPosition(size.width / 2 - 180, size.height / 2 + 70)
    self:addChild(img_music)

    local img_effect = ccui.ImageView:create("fruit_machine_effecton.png", ccui.TextureResType.plistType)
    img_effect:setPosition(size.width / 2 - 180, size.height / 2 - 70)
    self:addChild(img_effect)

    local effectvolume = MusicManager.getEffectVal()
    local musicvolume = MusicManager.getMusicVal()

    local function onMusicVolumeChange(pSender, eventtype)
        if eventtype == 0 then
            local percent = pSender:getPercent()
            local volume = percent
            MusicManager.setBGMVolume(volume)
        end
    end

    local function onEffectVolumeChange(pSender, eventtype)
        if eventtype == 0 then
            local percent = pSender:getPercent()
            local volume = percent
            MusicManager.setEffectVolume(volume)
        end
    end

    local slider_music = ccui.Slider:create()
    slider_music:loadBarTexture("fruit_machine_bar_track.png", ccui.TextureResType.plistType)
    slider_music:loadProgressBarTexture("fruit_machine_bar_progress.png", ccui.TextureResType.plistType)
    slider_music:loadSlidBallTextureNormal("fruit_machine_normal1.png", ccui.TextureResType.plistType)
    slider_music:loadSlidBallTexturePressed("fruit_machine_normal1.png", ccui.TextureResType.plistType)
    slider_music:setMaxPercent(100)
    slider_music:setPercent(musicvolume)
    slider_music:setPosition(size.width / 2 + 40, size.height / 2 + 67)
    slider_music:addTo(self)
    slider_music:addEventListener(onMusicVolumeChange)

    local slider_effect = ccui.Slider:create()
    slider_effect:loadBarTexture("fruit_machine_bar_track.png", ccui.TextureResType.plistType)
    slider_effect:loadProgressBarTexture("fruit_machine_bar_progress.png", ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTextureNormal("fruit_machine_normal1.png", ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTexturePressed("fruit_machine_normal1.png", ccui.TextureResType.plistType)
    slider_effect:setMaxPercent(100)
    slider_effect:setPercent(effectvolume)
    slider_effect:setPosition(size.width / 2 + 40, size.height / 2 - 73)
    slider_effect:addTo(self)
    slider_effect:addEventListener(onEffectVolumeChange)

    -- 退出设置
    local function onExitBtnClick(sender)
        self:onClose()
    end
    GameUtil.createButton("fruit_machine_btn_close.png", nil, onExitBtnClick, ccui.TextureResType.plistType):move(img_bg:getContentSize().width - 20, img_bg:getContentSize().height - 40):addTo(img_bg)

end

return HappyFruitSetWin

-- endregion

