local RecordNode = class("RecordNode", function()
    return cc.Node:create()
end)

function RecordNode:getRes(path)
    return "app/win/chat/" .. path
end

function RecordNode:ctor()
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function RecordNode:create()
    local node = RecordNode:new()
    node.MessageShowNode = nil -- 消息Node
    node.VoiceRecordNode = nil
    node.ChatModel = {
        Voice = 1 -- 语音类型
        ,
        Word = 2 -- 文字类型
        ,
        Emo = 3 -- 表情类型
    }
    node.Data = {}
    node._eventData = {} -- 事件列表
    node:setContentSize(cc.size(display.width, display.height))
    node:setAnchorPoint(display.CENTER)
    node:setPosition(display.cx, display.cy)

    node.voiceButtonTime = 0
    node.startVoiceChk = false
    node.cancelChk = false
    return node
end

function RecordNode:onEnter()
    self:init()
    self:addListenerEvent()
end

function RecordNode:onExit()
    self:removeListenerEvent()
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
end

function RecordNode:cleanup()
    self:unregisterScriptHandler()
end

function RecordNode:init()
    -----------------语音设置初始化-------------------------------------------------------

    self._recordState = "none"
    self._playState = "none"

    -- --录音初始化数据
    self._onRecordComplete = function(error, duration, filePath)
        if self._recordState == "complete" then
            self._recordState = "none"
            if error == 0 and self.cancelChk == false then
                if duration > 0 then
                    game.fileUpload(GameDefine.uploadUrl, filePath, function(succ, url)
                        if (succ) then
                            self:sendChatWordMessage(self.ChatModel.Voice, 0, 0, url)
                        else
                        end
                    end)
                else
                    if self.VoiceErrorNode ~= nil then
                        self.VoiceErrorNode:removeFromParent()
                        self.VoiceErrorNode = nil
                    end
                    local VoiceErrorNode = display.newNode()
                    VoiceErrorNode:align(display.CENTER, display.cx, display.cy)
                    VoiceErrorNode:setContentSize(331, 299)
                    self:addChild(VoiceErrorNode)
                    self.VoiceErrorNode = VoiceErrorNode
                    self:createPanel_Record_Error(VoiceErrorNode)
                end
            end

            self.cancelChk = false
        end
    end

    self._onRecordPlayComplete = function(error, filePath)
        if self._playState == "start" then
            MusicManager.resumeBGM()
            if (self.MessageShowNode == nil) then
                return
            end
            self.MessageShowNode:removeFromParent()
            self.MessageShowNode = nil
            self._playState = "none"
        end
    end

    game.registerEvent("record_complete", self._onRecordComplete)
    game.registerEvent("record_play_complete", self._onRecordPlayComplete)

    -------------------------------------------------------------------------------------------
    local scheduler = cc.Director:getInstance():getScheduler()

    self.schedulerID = scheduler:scheduleScriptFunc(function()
        if (self.startVoiceChk == true) then
            local difftime = os.difftime(os.time(), self.voiceButtonTime)
            self.RecordVoiceTimeText:setString(tostring(difftime))
            if (difftime >= 15) then
                self:onVoice_Record_End()
            end
        end
    end, 1, false)

end
-- 监听消息
function RecordNode:addListenerEvent()
    -- 语音录音开始
    self._eventData.onVoice_Record_Start = function()
        self:onVoice_Record_Start()
    end
    -- 语音录音结束
    self._eventData.onVoice_Record_End = function()
        self:onVoice_Record_End()
    end
    -- 语音录音取消
    self._eventData.onVoice_Record_Cancel = function()
        self:onVoice_Record_Cancel()
    end
    -- 初始化聊天页面
    self._eventData.InitEmoPhraseWin = function(data)
        self.Data = data
    end
    -- 语音聊天消息
    self._eventData.OnPlayChat = function(data, charid, sex)
        self:OnPlayChat(data, charid, sex)
    end

    game.registerEvent(GameDefine.Voice_Record_Start, self._eventData.onVoice_Record_Start)
    game.registerEvent(GameDefine.Voice_Record_End, self._eventData.onVoice_Record_End)
    game.registerEvent(GameDefine.InitEmoPhraseWin, self._eventData.InitEmoPhraseWin)
    game.registerEvent(GameDefine.ShowUserChat, self._eventData.OnPlayChat)
    game.registerEvent(GameDefine.Voice_Record_Cancel, self._eventData.onVoice_Record_Cancel)

end
-- 移除监听消息
function RecordNode:removeListenerEvent()
    game.unregisterEvent(GameDefine.Voice_Record_Start, self._eventData.onVoice_Record_Start)
    game.unregisterEvent(GameDefine.Voice_Record_End, self._eventData.onVoice_Record_End)
    game.unregisterEvent(GameDefine.InitEmoPhraseWin, self._eventData.InitEmoPhraseWin)
    game.unregisterEvent(GameDefine.ShowUserChat, self._eventData.OnPlayChat)
    game.unregisterEvent(GameDefine.Voice_Record_Cancel, self._eventData.onVoice_Record_Cancel)

    game.unregisterEvent("record_complete", self._onRecordComplete)
    game.unregisterEvent("record_play_complete", self._onRecordPlayComplete)
end

-- 录音开始
function RecordNode:onVoice_Record_Start()
    if (os.difftime(os.time(), self.voiceButtonTime) <= 2) then
        PlazaManager.showTips("语音聊天太频繁!")
        return
    end

    if game.isOtherAudioPlaying() then
        PlazaManager.showTips("录音被占用!")
        return
    end
    self.voiceButtonTime = os.time()
    self.startVoiceChk = true

    if game.targetPlatform == cc.PLATFORM_OS_ANDROID then
        MusicManager.pauseBGM()
    end

    game.stopVoicePlay()
    if game.startVoiceRecord() then
        self._recordState = "start"

        if (self.MessageShowNode ~= nil) then
            self.MessageShowNode:removeFromParent()
            self.MessageShowNode = nil
        end

        self.VoiceRecordNode = display.newNode()
        self.VoiceRecordNode:setAnchorPoint(display.CENTER)
        self.VoiceRecordNode:setPosition(display.cx, display.cy)
        self.VoiceRecordNode:setContentSize(331, 299)
        self:addChild(self.VoiceRecordNode)

        self:createPanel_Record_Voice(self.VoiceRecordNode)
    end
end

function RecordNode:onVoice_Record_Cancel()
    if (self.VoiceRecordNode ~= nil) then
        self.cancelChk = true
        self.VoiceRecordNode:showCancelPanel()
    end
end
-- 录音结束
function RecordNode:onVoice_Record_End()
    if (self.startVoiceChk == false) then
        return
    end
    self.voiceButtonTime = os.time()
    self.startVoiceChk = false

    if game.targetPlatform == cc.PLATFORM_OS_ANDROID then
        MusicManager.resumeBGM()
    end

    self._recordState = "complete"

    game.stopVoiceRecord()
    if (self.VoiceRecordNode ~= nil) then
        self.VoiceRecordNode:removeFromParent()
        self.VoiceRecordNode = nil
    end

end

-- 语音消息处理函数
function RecordNode:OnPlayChat(data, charID, sex)
    if (data.MsgType == self.ChatModel.Voice) then
        self:OnPlayVoice(data.ChatString, charID)
    end
end
-- 播放语音
function RecordNode:OnPlayVoice(url, charid)

    game.fileDownload(url, false, function(issucc, videoPath)
        if issucc then
            self._playState = "start"
            game.startVoicePlay(videoPath)
            MusicManager.pauseBGM()
            local seqNo = self:GetSeqNoByCharID(charid, self.Data.StartCharID, self.Data.PlayCount)
            local positon = cc.vec3(self.Data.PlayViewPosition[seqNo].x, self.Data.PlayViewPosition[seqNo].y)
            self:createPanel_PlayVoice(positon, self.Data.PlayViewPosition[seqNo].Direct)
        end
    end)
end

----------------------------------------创建模块函数-----------------------------
-- 创建语音录音界面
-- 点击语音按钮按下时，开始录音，离开时录音结束

function RecordNode:createPanel_Record_Error(VoiceErrorNode)
    local sprite_bg = cc.Sprite:create(self:getRes("voice/kuang_errorRecorddata.png"))
    sprite_bg:setPosition(165, 151)
    VoiceErrorNode:addChild(sprite_bg)

    local sprite_icon_error = cc.Sprite:create(self:getRes("voice/icon_error.png"))
    sprite_icon_error:setPosition(162, 132)
    VoiceErrorNode:addChild(sprite_icon_error)

    local text_error = ccui.Text:create("说话时间太短", GameDefine.FontName, 30)
    text_error:setPosition(164, 242)
    VoiceErrorNode:addChild(text_error)

    VoiceErrorNode:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
        if (self.VoiceErrorNode ~= nil) then
            self.VoiceErrorNode:removeFromParent()
            self.VoiceErrorNode = nil
        end
    end)))
end

function RecordNode:createPanel_Record_Voice(node)

    local sprite_bg = cc.Sprite:create(self:getRes("voice/kuang_recondVoice.png"))
    sprite_bg:setPosition(165, 150)
    node:addChild(sprite_bg)

    local recordPanel = display.newNode()
    recordPanel:setAnchorPoint(display.LEFT_BOTTOM)
    recordPanel:setPosition(0, 0)
    recordPanel:setContentSize(331, 299)
    node:addChild(recordPanel)

    local sprite_icon_maikefeng = cc.Sprite:create(self:getRes("voice/icon_maikefeng.png"))
    sprite_icon_maikefeng:setPosition(128, 183)
    recordPanel:addChild(sprite_icon_maikefeng)

    local sprite_icon_volume = cc.Sprite:create(self:getRes("voice/icon_volume_2_1.png"))
    sprite_icon_volume:setPosition(247, 157)
    recordPanel:addChild(sprite_icon_volume)

    local text_time = GameUtil.createLabel("0\"", 25, cc.WHITE, display.CENTER, cc.p(150, 65))
    recordPanel:addChild(text_time)
    self.RecordVoiceTimeText = text_time

    local text_cancel = GameUtil.createLabel("手指上滑,取消发送", 25, cc.WHITE, display.CENTER, cc.p(150, 30))
    recordPanel:addChild(text_cancel)
    -- local ani = Utils.newFrameSprite("win/Chat/voice/icon_volume_2_%d.png", 7, 15, -1, nil, false)
    -- sprite_icon_volume:addChild(ani)

    local animation = cc.Animation:create()
    for i = 1, 7 do
        local frameName = string.format(self:getRes("voice/icon_volume_2_%d.png"), i)
        local spriteFrame = cc.SpriteFrame:create(frameName, cc.rect(0, 0, 50, 117))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(spriteFrame, frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.15) -- 设置两个帧播放时间，这个动画是播放4帧。
    animation:setRestoreOriginalFrame(true); -- 动画执行完后，是否还原到初始状态

    local action = cc.Animate:create(animation)
    sprite_icon_volume:runAction(cc.RepeatForever:create(action))

    local cancelPanel = display.newNode()
    cancelPanel:setAnchorPoint(display.LEFT_BOTTOM)
    cancelPanel:setPosition(0, 0)
    cancelPanel:setContentSize(331, 299)
    node:addChild(cancelPanel)

    local sprite_cancel = cc.Sprite:create(self:getRes("voice/icon_1.png"))
    sprite_cancel:setAnchorPoint(display.CENTER)
    sprite_cancel:setPosition(165, 183)
    cancelPanel:addChild(sprite_cancel)

    local word_bg = cc.Sprite:create(self:getRes("voice/bg_2.png"))
    word_bg:setAnchorPoint(display.CENTER)
    word_bg:setPosition(165, 40)
    word_bg:setOpacity(150)
    cancelPanel:addChild(word_bg)

    local text_cancel = GameUtil.createLabel("手指松开,取消发送", 25, cc.WHITE, display.CENTER, cc.p(165, 40))
    cancelPanel:addChild(text_cancel)
    cancelPanel:setVisible(false)

    function node:showCancelPanel()
        cancelPanel:setVisible(true)
        recordPanel:setVisible(false)
    end

    function node:showRecordPanel()
        cancelPanel:setVisible(false)
        recordPanel:setVisible(true)
    end

end

function RecordNode:createPanel_PlayVoice(positon, direct)
    if (self.MessageShowNode ~= nil) then
        self.MessageShowNode:removeFromParent()
        self.MessageShowNode = nil
    end
    self.MessageShowNode = display.newNode()
    self.MessageShowNode:setAnchorPoint(display.CENTER)
    self.MessageShowNode:setPosition(positon.x, positon.y)
    self.MessageShowNode:setContentSize(120, 120)
    self:addChild(self.MessageShowNode)

    local sprite_bg = cc.Sprite:create(self:getRes("voice/kuang_voice.png"))
    sprite_bg:setAnchorPoint(display.CENTER)
    sprite_bg:setPosition(62, 56)
    self.MessageShowNode:addChild(sprite_bg)

    local sprite_icon_direct = {}
    if (direct == GameDefine.Direct.Top) then
        sprite_icon_direct = cc.Sprite:create(self:getRes("voice/icon_rec_top.png"))
        sprite_icon_direct:setAnchorPoint(display.CENTER)
        sprite_icon_direct:setPosition(57, 102)
        self.MessageShowNode:setAnchorPoint(display.CENTER_TOP)

    elseif (direct == GameDefine.Direct.Down) then
        sprite_icon_direct = cc.Sprite:create(self:getRes("voice/icon_rec_down.png"))
        sprite_icon_direct:setAnchorPoint(display.CENTER)
        sprite_icon_direct:setPosition(62, 12)
        self.MessageShowNode:setAnchorPoint(display.CENTER_BOTTOM)
    elseif (direct == GameDefine.Direct.Left) then
        sprite_icon_direct = cc.Sprite:create(self:getRes("voice/icon_rec_left.png"))
        sprite_icon_direct:setAnchorPoint(display.CENTER)
        sprite_icon_direct:setPosition(16, 53)
        self.MessageShowNode:setAnchorPoint(display.LEFT_CENTER)
    else
        sprite_icon_direct = cc.Sprite:create(self:getRes("voice/icon_rec_right.png"))
        sprite_icon_direct:setAnchorPoint(display.CENTER)
        sprite_icon_direct:setPosition(108, 53)
        self.MessageShowNode:setAnchorPoint(display.RIGHT_CENTER)
    end

    self.MessageShowNode:addChild(sprite_icon_direct)

    local sprite_icon_animal = cc.Sprite:create(self:getRes("voice/icon_volume_1_1.png"))
    sprite_icon_animal:setAnchorPoint(display.CENTER)
    sprite_icon_animal:setPosition(57, 57)
    self.MessageShowNode:addChild(sprite_icon_animal)

    local animation = cc.Animation:create()
    for i = 1, 3 do
        local frameName = string.format(self:getRes("voice/icon_volume_1_%d.png"), i)
        local spriteFrame = cc.SpriteFrame:create(frameName, cc.rect(0, 0, 28, 45))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(spriteFrame, frameName)
        animation:addSpriteFrame(spriteFrame)
    end
    animation:setDelayPerUnit(0.15) -- 设置两个帧播放时间，这个动画是播放4帧。
    animation:setRestoreOriginalFrame(true); -- 动画执行完后，是否还原到初始状态

    local action = cc.Animate:create(animation)
    sprite_icon_animal:runAction(cc.RepeatForever:create(action))
end

----------------------------发送消息---------------------------------------------------------

function RecordNode:sendChatWordMessage(chatModel, index, tagUserID, str)
    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_CHAT, 1024)
    rpcSend:writeUInt16(128) -- 字符串长度
    rpcSend:writeUInt16(chatModel) -- 消息类型
    rpcSend:writeUInt16(index) -- 索引
    rpcSend:writeUInt32(tagUserID) -- 目标用户
    rpcSend:writeUString(str, 128 * 2) -- 字符串
    rpcSend:release()
end

function RecordNode:GetSeqNoByCharID(charID, startCharID, PlayCount)
    return GameUtil.switchViewChairID(charID, startCharID, PlayCount)
end

return RecordNode
-- endregion
