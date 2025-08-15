local MessageBox = require "app.components.MessageBox"
local _M = {}

local phraseConfig = {
    [01] = "快点啊，我等到花儿也谢了",
    [02] = "又断线了，网络怎么这么差啊",
    [03] = "不要走，决战到 天亮",
    [04] = "你的牌打得也挺好的啊",
    [05] = "你是妹妹还是哥哥",
    [06] = "和你合作真是太愉快了",
    [07] = "大家好，很高兴见到各位",
    [08] = "真是不好意思，我得离开一会儿",
    [09] = "不要吵了，专心玩游戏吧"
}

function _M.createPhraseList(size, callback)

    local listView = ccui.ListView:create()
    listView:setDirection(SCROLLVIEW_DIR_VERTICAL)
    listView:setContentSize(size)
    listView:setTouchEnabled(true)

    listView:addEventListenerListView(function(target, eventType)
        if (eventType == ccui.ListViewEventType.ONSELECTEDITEM_START) then
            local itemList = target:getItems()
            for k, item in pairs(itemList) do
                item:getChildByName("image"):setVisible(false)
            end

            local index = target:getCurSelectedIndex()
            local image = target:getItem(index):getChildByName("image")
            image:setVisible(true)
        elseif (eventType == ccui.ListViewEventType.ONSELECTEDITEM_END) then

            local index = target:getCurSelectedIndex()
            local image = target:getItem(index):getChildByName("image")
            image:setVisible(false)
            local tag = target:getItem(index):getTag()
            callback(tag)
        end
    end)

    for i, v in ipairs(phraseConfig) do
        local node = ccui.Layout:create()
        node:setContentSize(size.width, 100)
        node:setTouchEnabled(true)
        node:setTag(i)

        local image = ccui.ImageView:create("app/win/chat/EmoPhrase/word_btn_bg.png")
        image:setContentSize(cc.size(size.width, 100))
        image:setAnchorPoint(display.LEFT_BOTTOM)
        image:setPosition(0, 0)
        image:setVisible(false)
        image:setName("image")
        node:addChild(image)

        local text = ccui.Text:create(v, GameDefine.FontName, 30)
        text:setTextColor(cc.WHITE)
        text:setAnchorPoint(display.LEFT_CENTER)
        text:setPosition(0, 50)
        node:addChild(text)

        listView:pushBackCustomItem(node)
    end

    return listView
end

-- sex 2 boy dire left|right
function _M.createPhraseNode(positon, direct, seqNo, sex)
    local str = string.format("app/sound/quick_chat/%s/v%d.mp3", sex == 2 and "boy" or "girl", seqNo)
    MusicManager.playEffect(str)

    local node_1 = display.newNode()
    local lbl = ccui.Text:create(phraseConfig[seqNo], GameDefine.FontName, 30)
    local lblSize = lbl:getContentSize()

    local sprite_1 = cc.Sprite:create("app/win/chat/EmoPhrase/kuang_1.png")
    local sprite_2 = cc.Sprite:create("app/win/chat/EmoPhrase/kuang_2.png")
    local sprite_3 = cc.Sprite:create("app/win/chat/EmoPhrase/kuang_3.png")
    sprite_3:setScaleX(lblSize.width / 53)

    lbl:setPosition(lblSize.width / 2 + 15, 40)
    lbl:setAnchorPoint(display.CENTER)

    node_1:setContentSize(cc.size(lblSize.width + 30, 80))
    sprite_1:setAnchorPoint(display.LEFT_BOTTOM)
    sprite_1:setPosition(0, 0)
    node_1:addChild(sprite_1)

    sprite_3:setAnchorPoint(display.LEFT_BOTTOM)
    sprite_3:setPosition(15, 0)
    node_1:addChild(sprite_3)

    sprite_2:setAnchorPoint(display.LEFT_BOTTOM)
    sprite_2:setPosition(15 + lblSize.width, 0)
    node_1:addChild(sprite_2)

    node_1:addChild(lbl)
    local sprite_icon_direct = {}
    if (direct == GameDefine.Direct.Top) then
        sprite_icon_direct = cc.Sprite:create("app/win/chat/voice/icon_rec_top.png")
        sprite_icon_direct:setAnchorPoint(display.CENTER_BOTTOM)
        sprite_icon_direct:setPosition((lblSize.width + 30) / 2, 80)
        node_1:setAnchorPoint(display.CENTER_TOP)
    elseif (direct == GameDefine.Direct.Down) then
        sprite_icon_direct = cc.Sprite:create("app/win/chat/voice/icon_rec_down.png")
        sprite_icon_direct:setAnchorPoint(display.CENTER_TOP)
        sprite_icon_direct:setPosition((lblSize.width + 30) / 2, 0)
        node_1:setAnchorPoint(display.CENTER_BOTTOM)
    elseif (direct == GameDefine.Direct.Left) then
        sprite_icon_direct = cc.Sprite:create("app/win/chat/voice/icon_rec_left.png")
        sprite_icon_direct:setAnchorPoint(display.RIGHT_CENTER)
        sprite_icon_direct:setPosition(0, 40)
        node_1:setAnchorPoint(display.LEFT_CENTER)
    else
        sprite_icon_direct = cc.Sprite:create("app/win/chat/voice/icon_rec_right.png")
        sprite_icon_direct:setAnchorPoint(display.LEFT_CENTER)
        sprite_icon_direct:setPosition(lblSize.width + 30, 40)
        node_1:setAnchorPoint(display.RIGHT_CENTER)
    end
    node_1:addChild(sprite_icon_direct)

    node_1:setPosition(positon)
    return node_1
end

return _M
