local Layout = require "app.components.Layout"
local GameChatWin = class("GameChatWin", function()
    return cc.Node:create()
end)

--[[ 位置参数示例
              local data={MainPosition={x=1,y=1} --录音框坐标
                         ,PlayViewPosition={ {x=356,y=265,Direct=GameDefine.Direct.Left}     --播放声音框坐标，从玩家自身，逆时针针开始
                                            ,{x=1129,y=556,Direct=GameDefine.Direct.Right}
                                            ,{x=215,y=556,Direct=GameDefine.Direct.Left}
                                            }
                         ,StartCharID=globalUserInfo.wChairID
                         ,PlayCount=DDZ_CMD.GAME_PLAYER
                          }
--]]

local ChatModel = {
    Voice = 1 -- 语音类型
    ,
    Word = 2 -- 文字类型
    ,
    Emo = 3 -- 表情类型
    ,
    CustWord = 4 -- 自定义文字
}
--
local defeatWordList = {{
    word = "快点啊，我等到花儿也谢了",
    pathBoy = "app/sound/quick_chat/boy/v1.mp3",
    pathGirl = "app/sound/quick_chat/girl/v1.mp3"
}, {
    word = "又断线了，网络怎么这么差啊",
    pathBoy = "app/sound/quick_chat/boy/v2.mp3",
    pathGirl = "app/sound/quick_chat/girl/v2.mp3"
}, {
    word = "不要走，决战到 天亮",
    pathBoy = "app/sound/quick_chat/boy/v3.mp3",
    pathGirl = "app/sound/quick_chat/girl/v3.mp3"
}, {
    word = "你的牌打得也挺好的啊",
    pathBoy = "app/sound/quick_chat/boy/v4.mp3",
    pathGirl = "app/sound/quick_chat/girl/v4.mp3"
}, {
    word = "你是妹妹还是哥哥",
    pathBoy = "app/sound/quick_chat/boy/v5.mp3",
    pathGirl = "app/sound/quick_chat/girl/v5.mp3"
}, {
    word = "和你合作真是太愉快了",
    pathBoy = "app/sound/quick_chat/boy/v6.mp3",
    pathGirl = "app/sound/quick_chat/girl/v6.mp3"
}, {
    word = "大家好，很高兴见到各位",
    pathBoy = "app/sound/quick_chat/boy/v7.mp3",
    pathGirl = "app/sound/quick_chat/girl/v7.mp3"
}, {
    word = "真是不好意思，我得离开一会儿",
    pathBoy = "app/sound/quick_chat/boy/v8.mp3",
    pathGirl = "app/sound/quick_chat/girl/v8.mp3"
}, {
    word = "不要吵了，专心玩游戏吧",
    pathBoy = "app/sound/quick_chat/boy/v9.mp3",
    pathGirl = "app/sound/quick_chat/girl/v9.mp3"
}}

local EmoType = {
    Anim = 1,
    Pic = 2
} -- 表情类型  1:帧动画 2:图片
local MoveType = {
    Head = 1,
    MoveMidScen = 2
} -- 移动类型 1:直接显示在头像旁,2:直接显示在界面中心，3:从头像移动到界面中心再播放动画

local defeatEmoList = {{
    EmoName = "烧香",
    EmoType = EmoType.Anim,
    MoveType = MoveType.MoveMidScen,
    AniPicCount = 5,
    IconPath = "emo_4.png",
    AniPath = "ani/emo_4/"
}}

function GameChatWin:ctor()
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

    self:setContentSize(cc.size(display.width, display.height))
    self:setAnchorPoint(display.CENTER)
    self:setPosition(display.cx, display.cy)

    self.viewData = {} -- 页面坐标值
    self.eventData = {} -- 事件列表
    self.messageNodeList = {} -- 消息节点列表

    self.wordList = defeatWordList
    self.emoList = {}
    self.sendLastTime = 0

    self:InitEmoList()
end

function GameChatWin:onEnter()
    self.eventData.OpenEmoPhraseWin = function()
        self:onOpenEmoPhraseWin()
    end -- 打开聊天页面
    self.eventData.InitEmoPhraseWin = function(data)
        self.viewData = data
    end -- 初始化聊天页面
    self.eventData.OnPlayChat = function(data, charid, sex)
        self:OnPlayChat(data, charid, sex)
    end -- 语音聊天消息

    game.registerEvent(GameDefine.OpenEmoPhraseWin, self.eventData.OpenEmoPhraseWin)
    game.registerEvent(GameDefine.InitEmoPhraseWin, self.eventData.InitEmoPhraseWin)
    game.registerEvent(GameDefine.ShowUserChat, self.eventData.OnPlayChat)
end

function GameChatWin:onExit()
    game.unregisterEvent(GameDefine.OpenEmoPhraseWin, self.eventData.OpenEmoPhraseWin)
    game.unregisterEvent(GameDefine.InitEmoPhraseWin, self.eventData.InitEmoPhraseWin)
    game.unregisterEvent(GameDefine.ShowUserChat, self.eventData.OnPlayChat)
end

function GameChatWin:cleanup()
    self:unregisterScriptHandler()
end

function GameChatWin:setWordList(wordList)
    self.wordList = wordList
end

function GameChatWin:setEmoList(emoList)
    self.emoList = emoList
end

---------------------------消息处理---------------------------------------
function GameChatWin:onOpenEmoPhraseWin()
    -- self:createEmoPhraseView(self.Data.MainPosition)
    if (self:getChildByName("winNode") ~= nil) then
        self:getChildByName("winNode"):setVisible(true)
        return
    end

    local winNode = cc.Node:create()
    winNode:setName("winNode")
    winNode:setContentSize(640, 526)
    winNode:align(display.LEFT_BOTTOM, self.viewData.MainPosition.x, self.viewData.MainPosition.y):addTo(self)
    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = winNode:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, 0, 640, 526), pos) and winNode:isVisible() == true then
            winNode:setVisible(false)
            game.sendEvent(GameDefine.OnEmoPhraseWinClose)
            return false
        elseif winNode:isVisible() == false then
            return false
        end
        return true
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    winNode:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, winNode)

    local bg_1 = ccui.Scale9Sprite:create("app/win/chat/EmoPhrase/bg.png")
    bg_1:setCapInsets(cc.rect(10, 10, 64 - 20, 84 - 20))
    bg_1:setContentSize(640, 526)
    bg_1:align(display.LEFT_BOTTOM, 0, 0):addTo(winNode)

    local listNode = cc.Node:create()
    listNode:setContentSize(560, 430)
    listNode:align(display.LEFT_BOTTOM, 0, 96):addTo(winNode)

    local function showPhrasePanel()
        listNode:removeAllChildren()
        local phraseNode = self:newPhraseListView()
        phraseNode:align(display.LEFT_BOTTOM, 10, 15):addTo(listNode)

        if winNode:getChildByName("phraseBtn") ~= nil then
            winNode:getChildByName("phraseBtn"):setEnabled(false)
        end
        if winNode:getChildByName("emoBtn") ~= nil then
            winNode:getChildByName("emoBtn"):setEnabled(true)
        end
    end
    local phraseBtn = GameUtil.createButton("app/win/chat/EmoPhrase/btn_sss_kslt2.png", "app/win/chat/EmoPhrase/btn_sss_kslt1.png", showPhrasePanel)
    phraseBtn:loadTextureDisabled("app/win/chat/EmoPhrase/btn_sss_kslt1.png")
    phraseBtn:setName("phraseBtn")
    phraseBtn:align(display.LEFT_BOTTOM, 560, 96):addTo(winNode)
    local function showEmoPanel()
        listNode:removeAllChildren()
        local emoNode = self:newEmoScrollView()
        emoNode:align(display.LEFT_BOTTOM, 10, 15):addTo(listNode)

        if winNode:getChildByName("phraseBtn") ~= nil then
            winNode:getChildByName("phraseBtn"):setEnabled(true)
        end
        if winNode:getChildByName("emoBtn") ~= nil then
            winNode:getChildByName("emoBtn"):setEnabled(false)
        end
    end
    local emoBtn = GameUtil.createButton("app/win/chat/EmoPhrase/btn_sss_bq2.png", "app/win/chat/EmoPhrase/btn_sss_bq1.png", showEmoPanel)
    emoBtn:loadTextureDisabled("app/win/chat/EmoPhrase/btn_sss_bq1.png")
    emoBtn:setName("emoBtn")
    emoBtn:align(display.LEFT_TOP, 560, 526):addTo(winNode)

    local phraseNode = self:newPhraseListView()
    phraseNode:align(display.LEFT_BOTTOM, 10, 15):addTo(listNode)

    if winNode:getChildByName("phraseBtn") ~= nil then
        winNode:getChildByName("phraseBtn"):setEnabled(false)
    end
    if winNode:getChildByName("emoBtn") ~= nil then
        winNode:getChildByName("emoBtn"):setEnabled(true)
    end

    local bg_2 = ccui.Scale9Sprite:create("app/win/chat/EmoPhrase/img_sss_sfdb.png")
    bg_2:setCapInsets(cc.rect(40, 30, 68 - 50, 92 - 60))
    bg_2:setContentSize(640, 96)
    bg_2:align(display.LEFT_BOTTOM, 0, 0):addTo(winNode)

    -- 玩家输入
    local edit_input = ccui.EditBox:create(cc.size(460, 66), "app/win/chat/EmoPhrase/input_sss_lt.png")
    edit_input:setFont(GameDefine.FontName, 28)
    edit_input:setFontColor(cc.c3b(0x2e, 0x3e, 0x8c))
    edit_input:setMaxLength(34)
    edit_input:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    edit_input:setPlaceHolder("  输入文字")
    edit_input:setPlaceholderFontSize(28)
    edit_input:setPlaceholderFontName(GameDefine.FontName)
    edit_input:setPlaceholderFontColor(cc.c3b(0x2e, 0x3e, 0x8c))
    edit_input:align(display.LEFT_CENTER, 10, 48):addTo(bg_2)
    self.edit_input = edit_input

    local function sendCustPanel()
        if PlazaManager.isPhoneAndPadPlatform() then
            PlazaManager.showTips("苹果系统下暂不支持")
            return
        end

        local inputStr = self.edit_input:getText()
        if string.len(inputStr) > 0 then
            self:sendChatWordMessage(ChatModel.CustWord, 0, 0, inputStr)
            self.edit_input:setText("")
            self:getChildByName("winNode"):setVisible(false)
            game.sendEvent(GameDefine.OnEmoPhraseWinClose)
        else
            PlazaManager.showTips("输入字符串不能为空")
        end
    end
    local btnSend = GameUtil.createButton("app/win/chat/EmoPhrase/bnt_sss_fs1.png", "app/win/chat/EmoPhrase/bnt_sss_fs2.png", sendCustPanel):align(display.LEFT_CENTER, 480, 48):addTo(bg_2)

    if PlazaManager.isPhoneAndPadPlatform() then
        self.edit_input:setEnabled(false)
    end
end

function GameChatWin:OnPlayChat(data, charID, sex)
    if data.MsgType == ChatModel.Word then
        self:OnPlayWord(data.Index, charID, sex)
    elseif data.MsgType == ChatModel.Emo then
        self:OnPlayEmo(data.Index, data.ChatString, charID)
    elseif data.MsgType == ChatModel.CustWord then
        self:onPlayCustWord(data.ChatString, charID, sex)
    end

end

----------------------------------------创建模块函数-----------------------------
-- 创建表情下拉列表
function GameChatWin:newEmoScrollView()
    local nodeSize = cc.size(530, 400)

    local function onEmoListClick(uiwidget, eventType)
        if eventType == ccui.TouchEventType.ended then
            local index = uiwidget:getTag()
            local difftime = os.difftime(os.time(), self.sendLastTime)
            if (difftime <= 2) then
                PlazaManager.showTips("抱歉，你说话速度太快了，请休息一会")
                return
            end
            self.sendLastTime = os.time()
            self:sendChatWordMessage(ChatModel.Emo, index, 0, "")
            self:getChildByName("winNode"):setVisible(false)
            game.sendEvent(GameDefine.OnEmoPhraseWinClose)
        end
    end

    local buttonList = {}
    if self.emoList ~= nil and #self.emoList > 0 then
        for i, itemdata in ipairs(self.emoList) do
            local button = ccui.Button:create("app/emoanim/" .. itemdata.IconPath)
            button:setTag(i)
            button:setAnchorPoint(display.CENTER)
            button:addTouchEventListener(onEmoListClick)
            buttonList[i] = button
        end
    end

    local container = Layout.createTBox("row", nil, 5, buttonList, {
        row = 10,
        col = 10
    })
    local scrollView = cc.ScrollView:create()
    scrollView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scrollView:setViewSize(nodeSize)
    scrollView:setContainer(container)
    scrollView:setContentOffset(scrollView:minContainerOffset())

    return scrollView
end
-- 创建短语下拉列表
function GameChatWin:newPhraseListView()
    local phraseNode = ccui.ListView:create()
    phraseNode:setDirection(SCROLLVIEW_DIR_VERTICAL)
    phraseNode:setContentSize(cc.size(560, 400))
    phraseNode:setTouchEnabled(true)

    phraseNode:addEventListenerListView(function(target, eventType)
        if (eventType == ccui.ListViewEventType.ONSELECTEDITEM_START) then

        elseif (eventType == ccui.ListViewEventType.ONSELECTEDITEM_END) then
            local index = target:getCurSelectedIndex()
            local difftime = os.difftime(os.time(), self.sendLastTime)
            if (difftime < 2) then
                PlazaManager.showTips("抱歉，你说话速度太快了，请休息一会")
                return
            end
            self.sendLastTime = os.time()
            self:sendChatWordMessage(ChatModel.Word, index + 1, 0, "")
            self:getChildByName("winNode"):setVisible(false)
            game.sendEvent(GameDefine.OnEmoPhraseWinClose)
        end
    end)

    for i = 1, #self.wordList do
        local btn_word = ccui.Button:create("app/win/chat/EmoPhrase/word_btn_1.png", "app/win/chat/EmoPhrase/word_btn_2.png")
        btn_word:setScale9Enabled(true)
        btn_word:setCapInsets(cc.rect(2, 2, 6, 6))
        btn_word:setContentSize(560, 100)
        phraseNode:pushBackCustomItem(btn_word)

        local text = ccui.Text:create(self.wordList[i].word, GameDefine.FontName, 30)
        text:setTextColor(cc.WHITE)
        text:align(display.LEFT_CENTER, 20, 50):addTo(btn_word)

    end

    return phraseNode
end

----------------------------发送消息---------------------------------------------------------

function GameChatWin:sendChatWordMessage(chatModel, index, tagUserID, str)

    local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_FRAME, game.SUB_GF_USER_CHAT, 1024)
    rpcSend:writeUInt16(128) -- 字符串长度
    rpcSend:writeUInt16(chatModel) -- 消息类型
    rpcSend:writeUInt16(index) -- 索引
    rpcSend:writeUInt32(tagUserID) -- 目标用户
    rpcSend:writeUString(str, 128 * 2) -- 字符串
    rpcSend:release()
end

function GameChatWin:GetSeqNoByCharID(charID, startCharID, PlayCount)
    return GameUtil.switchViewChairID(charID, startCharID, PlayCount)
end

----------------------------------------------------------------------
-- 播放文字
function GameChatWin:OnPlayWord(indexid, charid, sex)
    if (self.messageNodeList[charid + 1] ~= nil) then
        self.messageNodeList[charid + 1]:removeFromParent()
        self.messageNodeList[charid + 1] = nil
    end
    if indexid > 0 and indexid <= #self.wordList then
        local voicePath = self.wordList[indexid].pathBoy
        if sex == GameDefine.GENDER_FEMALE then
            local voicePath = self.wordList[indexid].pathGirl
        end
        MusicManager.playEffect(voicePath)

        local seqNo = self:GetSeqNoByCharID(charid, self.viewData.StartCharID, self.viewData.PlayCount)
        local position = self.viewData.PlayViewPosition[seqNo]
        local direct = self.viewData.PlayViewPosition[seqNo].Direct

        self:showWord(seqNo, position, direct, self.wordList[indexid].word, charid)
    end
end

-- 播放输入文字
function GameChatWin:onPlayCustWord(wordstr, charid, sex)
    if (self.messageNodeList[charid + 1] ~= nil) then
        self.messageNodeList[charid + 1]:removeFromParent()
        self.messageNodeList[charid + 1] = nil
    end

    local seqNo = self:GetSeqNoByCharID(charid, self.viewData.StartCharID, self.viewData.PlayCount)
    local position = self.viewData.PlayViewPosition[seqNo]
    local direct = self.viewData.PlayViewPosition[seqNo].Direct

    self:showWord(seqNo, position, direct, wordstr, charid)

end

function GameChatWin:showWord(seqNo, position, direct, wordstr, charid)
    local wordNode = cc.Node:create()
    wordNode:setPosition(position)
    local lbl_word = ccui.Text:create(wordstr, GameDefine.FontName, 30)
    local lbl_word_Size = lbl_word:getContentSize()
    lbl_word:align(display.LEFT_CENTER, 10, 40)
    wordNode:setContentSize(cc.size(lbl_word_Size.width + 20, 80))

    local sprite_bg = ccui.Scale9Sprite:create("app/win/chat/EmoPhrase/bg_kuang.png")
    sprite_bg:setCapInsets(cc.rect(10, 10, 20, 20))
    sprite_bg:setContentSize(lbl_word_Size.width + 20, 80)
    sprite_bg:align(display.LEFT_CENTER, 0, 40)
    wordNode:addChild(sprite_bg)

    wordNode:addChild(lbl_word)

    local sprite_icon_direct = cc.Sprite:create("app/win/chat/EmoPhrase/bg_icon.png")
    sprite_icon_direct:setAnchorPoint(display.CENTER)
    wordNode:addChild(sprite_icon_direct)
    if direct == GameDefine.Direct.Top then
        sprite_icon_direct:setRotation(180)
        sprite_icon_direct:setPosition((lbl_word_Size.width + 20) / 2, 47)
        wordNode:setAnchorPoint(display.CENTER_TOP)
    elseif direct == GameDefine.Direct.Down then
        sprite_icon_direct:setPosition((lbl_word_Size.width + 20) / 2, -7)
        wordNode:setAnchorPoint(display.CENTER_BOTTOM)
    elseif direct == GameDefine.Direct.Left then
        sprite_icon_direct:setRotation(90)
        sprite_icon_direct:setPosition(-7, 40)
        wordNode:setAnchorPoint(display.LEFT_CENTER)
    else
        sprite_icon_direct:setRotation(270)
        sprite_icon_direct:setPosition(lbl_word_Size.width + 20 + 7, 40)
        wordNode:setAnchorPoint(display.RIGHT_CENTER)
    end

    wordNode:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(function()
        if (self.messageNodeList[charid + 1] == nil) then
            return
        end
        self.messageNodeList[charid + 1]:removeFromParent()
        self.messageNodeList[charid + 1] = nil
    end)))

    self:addChild(wordNode)
    self.messageNodeList[charid + 1] = wordNode
end

-- 播放表情
function GameChatWin:OnPlayEmo(indexid, emoPath, charid)
    local seqNo = self:GetSeqNoByCharID(charid, self.viewData.StartCharID, self.viewData.PlayCount)
    local positon = self.viewData.PlayViewPosition[seqNo]
    local direct = self.viewData.PlayViewPosition[seqNo].Direct

    if (self.messageNodeList[charid + 1] ~= nil) then
        self.messageNodeList[charid + 1]:removeFromParent()
        self.messageNodeList[charid + 1] = nil
    end

    local afterfunction = function()
        if (self.messageNodeList[charid + 1] == nil) then
            return
        end
        self.messageNodeList[charid + 1]:removeFromParent()
        self.messageNodeList[charid + 1] = nil
    end

    local messageShowNode = cc.Node:create()
    messageShowNode:align(display.CENTER, positon.x, positon.y)
    self:addChild(messageShowNode)
    self.messageNodeList[charid + 1] = messageShowNode

    if direct == GameDefine.Direct.Top then
        messageShowNode:setAnchorPoint(display.CENTER_TOP)
    elseif direct == GameDefine.Direct.Down then
        messageShowNode:setAnchorPoint(display.CENTER_BOTTOM)
    elseif direct == GameDefine.Direct.Left then
        messageShowNode:setAnchorPoint(display.LEFT_CENTER)
    else
        messageShowNode:setAnchorPoint(display.RIGHT_CENTER)
    end

    local sprite_ani = cc.Sprite:create("app/emoanim/" .. self.emoList[indexid].AniPath .. "ani_1.png")
    sprite_ani:align(display.CENTER, 0, 0):addTo(messageShowNode)
    local animate_1 = self:createEmoAnimal(self.emoList[indexid])
    sprite_ani:runAction(cc.RepeatForever:create(animate_1))

    local sprite_size = sprite_ani:getContentSize()
    messageShowNode:setContentSize(sprite_size)
    sprite_ani:align(display.CENTER, sprite_size.width / 2, sprite_size.height / 2)
    if self.emoList[indexid].EmoType == EmoType.Anim then -- 帧动画
        if self.emoList[indexid].MoveType == MoveType.Head then
            messageShowNode:runAction(cc.Sequence:create(cc.DelayTime:create(2), cc.CallFunc:create(afterfunction)))
        elseif self.emoList[indexid].MoveType == MoveType.MoveMidScen then
            local jumpByAction = cc.JumpTo:create(0.4, cc.vec3(display.cx, display.cy), 100, 1)
            messageShowNode:runAction(cc.Sequence:create(jumpByAction, cc.DelayTime:create(1.5), cc.CallFunc:create(afterfunction)))
        end
    end
end

function GameChatWin:InitEmoList()
    local dataFile = cc.FileUtils:getInstance():getStringFromFile("app/emoanim/emoAniList.json")
    local dataList = {}
    if dataFile ~= nil and string.len(dataFile) > 0 then
        dataList = json.decode(dataFile)
    end
    if dataList ~= nil and #dataList > 0 then
        self.emoList = {}
        for i, itemdata in ipairs(dataList) do
            if itemdata.UseChk == 1 then
                table.insert(self.emoList, itemdata)
            end
        end
    end
end

function GameChatWin:createEmoAnimal(emoItemdata)
    -- 建立动画
    local animation_1 = cc.Animation:create()
    for i = 1, emoItemdata.AniPicCount do
        local frameName = string.format("app/emoanim/%sani_%d.png", emoItemdata.AniPath, i)
        animation_1:addSpriteFrameWithFile(frameName)
    end
    animation_1:setDelayPerUnit(8 / 60)
    animation_1:setRestoreOriginalFrame(true)

    local animate_1 = cc.Animate:create(animation_1)

    return animate_1
end

return GameChatWin
