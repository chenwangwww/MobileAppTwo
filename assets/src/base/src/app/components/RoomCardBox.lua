local Buttons = require "app.components.Buttons"
local SpriteFrameUtils = require "app.components.SpriteFrameUtils"

local RoomCardBox = class("RoomCardBox", function()
    return cc.Node:create()
end)

function RoomCardBox:ctor(onBackFunction)
    local size = cc.size(260, 50)
    self:setContentSize(size)

    self:onSwallowClickEvent()

    SpriteFrameUtils.newSprite("app/hall/personinfo/bg_2.png", false):move(130, 24):addTo(self)

    -- 房卡按钮
    local function onClickOpenShop(args)
        onBackFunction(3)
    end
    GameUtil.createButton("app/hall/personinfo/btn_room_1.png", "app/hall/personinfo/btn_room_2.png", onClickOpenShop):move(45, 23):addTo(self)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("app/hall/personinfo/anilCard_2/DH_fk0.png", "app/hall/personinfo/anilCard_2/DH_fk0.plist",
        "app/hall/personinfo/anilCard_2/DH_fk.ExportJson")
    local armature = ccs.Armature:create("DH_fk")
    armature:getAnimation():play("fk")
    armature:align(display.CENTER, 45, 27)
    self:addChild(armature)
    --[[
    local sprite_anil=GameUtil.newSprite("app/hall/personinfo/anilCard/anil_0.png",false):align(display.CENTER , 45, 30):addTo(self) 
    local animation_1=cc.Animation:create()
    for i=1,5 do   
        local  frameName=string.format("app/hall/personinfo/anilCard/anil_%d.png",i)
        animation_1:addSpriteFrameWithFile(frameName)
    end
    animation_1:setDelayPerUnit(12/60)
    animation_1:setRestoreOriginalFrame(true)
    
    local animate_1=cc.Animate:create(animation_1)
    local animate_2=cc.Sequence:create(animate_1,cc.DelayTime:create(1))
    sprite_anil:runAction(cc.RepeatForever:create(animate_2))
    --]]

    -- 赠按钮
    local function onClickOpenBank_give(args)
        onBackFunction(1)
    end

    if PlazaManager.isCheck == false then -- 审查版本不显示
        GameUtil.createButton("app/hall/personinfo/btn_give_1.png", "app/hall/personinfo/btn_give_2.png", onClickOpenBank_give):move(210, 22):addTo(self)
    end

    local totalCardNum = globalUserInfo.dwRoomCard + globalUserInfo.dwRoomCard_reward + globalUserInfo.dwRoomCard_experience
    self.lbl_totalCardNum = GameUtil.createLabel(totalCardNum, 30, nil, display.CENTER, cc.p(123, 24), GameDefine.FontName, nil, nil, nil, true, false):addTo(self)

    local menubtnNode = cc.Node:create()
    menubtnNode:setContentSize(120, 36)

    local function menuClick()
        if PlazaManager.isCheck == false then -- 审查版本不显示
            if (self.panel_cardList:isVisible() == true) then
                self.panel_cardList:setVisible(false)
            else
                self.panel_cardList:setVisible(true)
            end
        end
    end

    local menubtn = Buttons.createButton(true, 1, menuClick)
    Buttons.initButtonWithNode(menubtn, menubtnNode)
    menubtn:setAnchorPoint(display.CENTER)
    menubtn:setPosition(123, 24)
    self:addChild(menubtn)

    local panel_cardList = ccui.Layout:create()
    panel_cardList:setContentSize(cc.size(202, 240))
    panel_cardList:setAnchorPoint(display.CENTER_TOP)
    panel_cardList:setPosition(125, 0)
    panel_cardList:setVisible(false)
    self:addChild(panel_cardList)
    self.panel_cardList = panel_cardList

    local img_bg = SpriteFrameUtils.newSprite("app/hall/personinfo/bg_roommenu.png", false)
    img_bg:setScaleX(202 / img_bg:getContentSize().width)
    img_bg:setAnchorPoint(display.LEFT_BOTTOM)
    img_bg:setPosition(2, 0)
    panel_cardList:addChild(img_bg)

    local str_card_1 = string.format("A卡 %d张", globalUserInfo.dwRoomCard)
    self.lbl_card_1 = GameUtil.createLabel(str_card_1, 25, cc.WHITE, display.LEFT_CENTER, cc.p(25, 217), GameDefine.FontName, nil, nil, nil, true, false):addTo(panel_cardList)
    local str_card_2 = string.format("B卡 %d张", globalUserInfo.dwRoomCard_reward)
    self.lbl_card_2 = GameUtil.createLabel(str_card_2, 25, cc.WHITE, display.LEFT_CENTER, cc.p(25, 175), GameDefine.FontName, nil, nil, nil, true, false):addTo(panel_cardList)
    local str_card_3 = string.format("体验卡 %d张", globalUserInfo.dwRoomCard_experience)
    self.lbl_card_3 = GameUtil.createLabel(str_card_3, 25, cc.WHITE, display.LEFT_CENTER, cc.p(25, 133), GameDefine.FontName, nil, nil, nil, true, false):addTo(panel_cardList)

    local function giveCardClick()
        panel_cardList:setVisible(false)
        onBackFunction(1)
    end

    local function refreshClick()
        onBackFunction(2)
    end

    local btn_givecard = GameUtil.createButton("app/hall/personinfo/btn_giveroom_1.png", "app/hall/personinfo/btn_giveroom_2.png", giveCardClick)
    btn_givecard:setAnchorPoint(display.CENTER)
    btn_givecard:setPosition(101, 83)
    panel_cardList:addChild(btn_givecard)

    local btn_refresh = GameUtil.createButton("app/hall/personinfo/btn_refresh_1.png", "app/hall/personinfo/btn_refresh_2.png", refreshClick)
    btn_refresh:setAnchorPoint(display.CENTER)
    btn_refresh:setPosition(101, 28)
    panel_cardList:addChild(btn_refresh)

end

function RoomCardBox:updateRoomCardData()
    self.lbl_totalCardNum:setString(tostring(globalUserInfo.dwRoomCard + globalUserInfo.dwRoomCard_reward + globalUserInfo.dwRoomCard_experience))

    local str_card_1 = string.format("A卡 %d张", globalUserInfo.dwRoomCard)
    self.lbl_card_1:setString(str_card_1)

    local str_card_2 = string.format("B卡 %d张", globalUserInfo.dwRoomCard_reward)
    self.lbl_card_2:setString(str_card_2)

    local str_card_3 = string.format("体验卡 %d张", globalUserInfo.dwRoomCard_experience)
    self.lbl_card_3:setString(str_card_3)
end

function RoomCardBox:hideCardList()
    self.panel_cardList:setVisible(false)
end

function RoomCardBox:onSwallowClickEvent()
    local function onTouchBegan(touch, event)
        local loc = touch:getLocation()
        local pos = self:convertToNodeSpace(loc)
        if not cc.rectContainsPoint(cc.rect(0, -240, 260, 240), pos) then
            self:runAction(cc.CallFunc:create(function()
                self:hideCardList()
            end))
        end
        return true
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(false)
    self.listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener, self)
end

return RoomCardBox
