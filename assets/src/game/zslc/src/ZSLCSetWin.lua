local ZSLCSetWin = class("ZSLCSetWin", require("app.win.base.GameWindowBase"))
local SFUtils = require "app.components.SpriteFrameUtils"

function ZSLCSetWin:ctor()
    local size = cc.size(700, 450)
    ZSLCSetWin.super.ctor(self, size, true)
    self:setContentSize(size)
    self:initView(size)
end

function ZSLCSetWin:initView(size)

    local img_bg = ccui.ImageView:create("diamondtrain_png/hjlc_panel.png", ccui.TextureResType.plistType)
    img_bg:setScale9Enabled(true)
    img_bg:setCapInsets(cc.rect(70, 120, 10, 50))
    img_bg:setContentSize(size)
    img_bg:setPosition(size.width / 2, size.height / 2)
    self:addChild(img_bg)

    local img_title = ccui.ImageView:create("diamondtrain_png/hjlc_top_sz.png", ccui.TextureResType.plistType)
    img_title:setPosition(size.width / 2, size.height - 20)
    img_bg:addChild(img_title)

    local img_music = ccui.ImageView:create("diamondtrain_png/wz_yy.png", ccui.TextureResType.plistType)
    img_music:setPosition(size.width / 2 - 220, size.height / 2 + 70)
    self:addChild(img_music)

    local img_effect = ccui.ImageView:create("diamondtrain_png/wz_yx.png", ccui.TextureResType.plistType)
    img_effect:setPosition(size.width / 2 - 220, size.height / 2 - 70)
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
    slider_music:loadBarTexture("diamondtrain_png/hjlc_sz1.png", ccui.TextureResType.plistType)
    slider_music:loadProgressBarTexture("diamondtrain_png/hjlc_sz2.png", ccui.TextureResType.plistType)
    slider_music:loadSlidBallTextureNormal("diamondtrain_png/hjlc_sz3.png", ccui.TextureResType.plistType)
    slider_music:loadSlidBallTexturePressed("diamondtrain_png/hjlc_sz3.png", ccui.TextureResType.plistType)
    slider_music:setMaxPercent(100)
    slider_music:setPercent(musicvolume)
    slider_music:setPosition(size.width / 2 + 40, size.height / 2 + 67)
    slider_music:addTo(self)
    slider_music:addEventListener(onMusicVolumeChange)

    local slider_effect = ccui.Slider:create()
    slider_effect:loadBarTexture("diamondtrain_png/hjlc_sz1.png", ccui.TextureResType.plistType)
    slider_effect:loadProgressBarTexture("diamondtrain_png/hjlc_sz2.png", ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTextureNormal("diamondtrain_png/hjlc_sz3.png", ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTexturePressed("diamondtrain_png/hjlc_sz3.png", ccui.TextureResType.plistType)
    slider_effect:setMaxPercent(100)
    slider_effect:setPercent(effectvolume)
    slider_effect:setPosition(size.width / 2 + 40, size.height / 2 - 73)
    slider_effect:addTo(self)
    slider_effect:addEventListener(onEffectVolumeChange)

    -- 退出设置
    local function onExitBtnClick(sender)
        self:onClose()
    end
    GameUtil.createButton("diamondtrain_png/bnt_guanbi1.png", nil, onExitBtnClick, ccui.TextureResType.plistType):move(size.width - 30, size.height - 30):addTo(img_bg)

end

return ZSLCSetWin

--[[
local ZSLCSetWin = class("ZSLCSetWin", require("app.win.base.GameWindowBase"))
local SFUtils = require "app.components.SpriteFrameUtils"

function ZSLCSetWin:ctor()
    local size = cc.size(545, 480)
    ZSLCSetWin.super.ctor(self, size, true)
    self:setContentSize(size)
    self:initView(size)
end

function ZSLCSetWin:initView(size)

    local img_bg = SFUtils.newSprite("setting_png/setting_bg.png")
    img_bg:move(size.width / 2, size.height / 2):addTo(self)

    local img_title = ccui.ImageView:create("setting_png/setting_title.png",ccui.TextureResType.plistType)
    img_title:setPosition(size.width/2, size.height-20)
    img_bg:addChild(img_title)

    local img_music = ccui.ImageView:create("setting_png/setting_musicon.png",ccui.TextureResType.plistType)
    img_music:setPosition(size.width/2-180,size.height/2+70)
    self:addChild(img_music)

    local img_effect = ccui.ImageView:create("setting_png/setting_effecton.png",ccui.TextureResType.plistType)
    img_effect:setPosition(size.width/2-180,size.height/2-70)
    self:addChild(img_effect)

    local effectvolume = MusicManager.getEffectVal()
    local musicvolume = MusicManager.getMusicVal()

    local function onMusicVolumeChange(pSender,eventtype)
        if eventtype == 0 then
            local  percent = pSender:getPercent()
            local  volume= percent
            MusicManager.setBGMVolume(volume)
        end
    end

    local function onEffectVolumeChange(pSender,eventtype)
        if eventtype == 0 then
  		    local  percent = pSender:getPercent()
  		    local  volume= percent
  		    MusicManager.setEffectVolume(volume)
  	    end
    end

    local slider_music = ccui.Slider:create()
    slider_music:loadBarTexture("setting_png/setting_bar_track.png",ccui.TextureResType.plistType)
    slider_music:loadProgressBarTexture("setting_png/setting_bar_progress.png",ccui.TextureResType.plistType)
    slider_music:loadSlidBallTextureNormal("setting_png/setting_normal1.png",ccui.TextureResType.plistType)
    slider_music:loadSlidBallTexturePressed("setting_png/setting_normal1.png",ccui.TextureResType.plistType)
    slider_music:setMaxPercent(100)
    slider_music:setPercent(musicvolume)
    slider_music:setPosition(size.width/2+40, size.height/2+67)
    slider_music:addTo(self)
    slider_music:addEventListener(onMusicVolumeChange)

    local slider_effect = ccui.Slider:create()
    slider_effect:loadBarTexture("setting_png/setting_bar_track.png",ccui.TextureResType.plistType)
    slider_effect:loadProgressBarTexture("setting_png/setting_bar_progress.png",ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTextureNormal("setting_png/setting_normal1.png",ccui.TextureResType.plistType)
    slider_effect:loadSlidBallTexturePressed("setting_png/setting_normal1.png",ccui.TextureResType.plistType)
    slider_effect:setMaxPercent(100)
    slider_effect:setPercent(effectvolume)
    slider_effect:setPosition(size.width/2+40, size.height/2-73)
    slider_effect:addTo(self)
    slider_effect:addEventListener(onEffectVolumeChange)

    --退出设置
    local function onExitBtnClick(sender)
        self:onClose()
    end
    GameUtil.createButton("setting_png/setting_btn_close.png", nil, onExitBtnClick,ccui.TextureResType.plistType)
      :move(size.width-20, size.height-40)
      :addTo(img_bg)

end

return ZSLCSetWin

--]]

