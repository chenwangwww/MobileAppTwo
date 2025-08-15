--[[
LHDBTBLayer.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBTBInfo = require("game.lhdb.src.panel.LHDBTBInfo")
local LHDBSound = require("game.lhdb.src.LHDBSound")
local LHDBGameEnd = require("game.lhdb.src.panel.LHDBGameEnd")

local PREFIX = "Game/LHDB/Scene/"

local DragonConfig = {
    [0] = {
        armature = "long2",
        bone = "long2",
        pos = cc.p(-90, 5),
        standby = "long2_daiji",
        shoot = "long2_kou",
        shootDT = 1.0
    },
    [1] = {
        armature = "long2",
        bone = "long2",
        pos = cc.p(-85, 5),
        standby = "long2_daiji",
        shoot = "long2_kou",
        shootDT = 1.0
    },
    [2] = {
        armature = "long1",
        bone = "lianhuanpao",
        pos = cc.p(0, 35),
        standby = "long1_daiji",
        shoot = "long1_zhangzui",
        shootDT = 0.7
    },
    [3] = {
        armature = "long2",
        bone = "long2",
        pos = cc.p(90, 5),
        standby = "long2_daiji",
        shoot = "long2_kou",
        shootDT = 1.0
    },
    [4] = {
        armature = "long2",
        bone = "long2",
        pos = cc.p(95, 5),
        standby = "long2_daiji",
        shoot = "long2_kou",
        shootDT = 1.0
    }
}

local function createDragon(index)
    local armatureName = index == 2 and "long1" or "long2"
    local dragonBonesName = index == 2 and "lianhuanpao" or "long2"
    local factory = db.CCFactory:getFactory()
    local armatureDisplay = factory:buildArmatureDisplay(DragonConfig[index].armature, DragonConfig[index].bone)
    if index > 2 then
        armatureDisplay:setScaleX(-1)
    end
    armatureDisplay:move(DragonConfig[index].pos)
    return armatureDisplay
end

local Plate = class("Plate")

function Plate:ctor(root)
    self.root_ = root

    self.ballTemplate_ = self.root_:getChildByName("img_longZhuEnd")
    self.ball_ = 0

    self:blink(true)
end

function Plate:addTouchCallback(callback)
    self.root_:getChildByName("img_plate"):addClickEventListener(callback)
end

function Plate:ballEnter(srcPos, callback)
    LHDBSound.shootBall()
    local localPos = self.root_:convertToNodeSpace(srcPos)
    local imgBall = self.ballTemplate_:clone()
    imgBall:addTo(self.root_)
    imgBall:move(localPos)
    local ballPos = cc.p(self.ballTemplate_:getPosition())

    local moveEndCall = function()
        LHDBSound.enterBall()

        local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_long3_tuzhu_end.csb")
        local pnl = anim:getChildByName("Panel_6")
        pnl:getChildByName("select_1"):setVisible(self.isSelect_)
        pnl:getChildByName("select_2"):setVisible(self.isSelect_)
        local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_long3_tuzhu_end.csb")
        action:gotoFrameAndPlay(0, false)
        anim:runAction(action)
        local imgPlate = self.root_:getChildByName("img_plate")
        local enterNode = imgPlate:getChildByName("node_enter")
        anim:move(enterNode:getPosition()):addTo(imgPlate)
        anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), cc.RemoveSelf:create()))

        self.ball_ = self.ball_ + 1
        self.root_:getChildByName("txt_plate"):setString(self.ball_)
        if callback then
            callback()
        end
    end
    local seq = cc.Sequence:create(cc.Show:create(), cc.MoveTo:create(0.4, ballPos), cc.CallFunc:create(moveEndCall), cc.RemoveSelf:create())
    imgBall:runAction(seq)
end

function Plate:blink(enable)
    if enable then
        self.blinkAnim_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/DBBlink.csb")
        local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/DBBlink.csb")
        action:gotoFrameAndPlay(0)
        self.blinkAnim_:runAction(action)
        local imgPlate = self.root_:getChildByName("img_plate")
        self.blinkAnim_:move(imgPlate:getChildByName("node_blink"):getPosition()):addTo(imgPlate)
    elseif self.blinkAnim_ then
        self.blinkAnim_:removeSelf()
        self.blinkAnim_ = nil
    end
end

function Plate:getBallStartPos()
    return self.root_:convertToWorldSpace(cc.p(self.root_:getChildByName("img_longZhuStart"):getPosition()))
end

function Plate:setSelected(isSelect)
    self.isSelect_ = isSelect
    self.root_:getChildByName("img_plate"):loadTexture(string.format(PREFIX .. "Img_Gang_%02d.png", isSelect and 2 or 1), ccui.TextureResType.plistType)
end

function Plate:enableTouch(enable)
    self.root_:getChildByName("img_plate"):setTouchEnabled(enable)
end
-------------------------------------------------------------------------------------------------------------
local Dragon = class("Dragon")

function Dragon:ctor(root, index)
    self.root_ = root
    self.config_ = DragonConfig[index]

    self.dragonArmat_ = createDragon(index)
    if self.dragonArmat_ then
        self.dragonArmat_:addTo(self.root_)
    end
    self:standby()
end

function Dragon:standby()
    self.dragonArmat_:getAnimation():play(self.config_.standby)
end

function Dragon:shoot(callback)
    self.dragonArmat_:getAnimation():play(self.config_.shoot)
    self.isShootting_ = true
    local seq = cc.Sequence:create(cc.DelayTime:create(self.config_.shootDT), cc.CallFunc:create(function()
        self.isShootting_ = false
        self.dragonArmat_:getAnimation():play(self.config_.standby)
        local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_long3_tuzhu_start.csb")
        local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_long3_tuzhu_start.csb")
        action:gotoFrameAndPlay(0, false)
        anim:runAction(action)
        anim:move(0, -10):addTo(self.root_)
        anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(callback), cc.DelayTime:create(0.4), cc.RemoveSelf:create()))
    end))
    self.root_:runAction(seq)
end

function Dragon:isShootting()
    return self.isShootting_
end
-------------------------------------------------------------------------------------------------------------
local TBUI = class("TBUI", function()
    return cc.Node:create()
end)

local function initUI(self)
    self.root_ = cc.CSLoader:createNode("game/lhdb/res/DBLayer.csb")

    self.root_:addTo(self)

    self.imgBg_ = self.root_:getChildByName("img_bg")
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)
end

function TBUI:ctor()
    local factory = db.CCFactory:getFactory()
    factory:loadDragonBonesData(GameCMD.RES_PATH .. "Anims/DragonHead/lianhuanpao_ske.json", "lianhuanpao");
    factory:loadTextureAtlasData(GameCMD.RES_PATH .. "Anims/DragonHead/lianhuanpao_tex.json");
    factory:loadDragonBonesData(GameCMD.RES_PATH .. "Anims/DragonHead/long2_ske.json", "long2");
    factory:loadTextureAtlasData(GameCMD.RES_PATH .. "Anims/DragonHead/long2_tex.json");

    initUI(self)

    if LangCtrl:isEng() then
        local imgWarning = self.imgBg_:getChildByName("txt_warning")
        local posY = imgWarning:getPositionY()
        imgWarning:setPositionY(posY + 30)
    end

    self.tbInfo_ = LHDBTBInfo.new(self.imgBg_:getChildByName("pnl_info"))
    self.plate_ = {}
    self.dragon_ = {}
    local pnlDragon = self.imgBg_:getChildByName("pnl_dragon")
    for i = 0, 4 do
        self.plate_[i] = Plate.new(self.imgBg_:getChildByName(string.format("node_plate%d", i)))
        self.dragon_[i] = Dragon.new(pnlDragon:getChildByName("node_dragon" .. i), i)
    end
end

local function updateTBInfo(self)
    self.tbInfo_:setOwnerGold(self.currentScore_)
    self.tbInfo_:setPrice(self.price_)
    self.tbInfo_:setBallCount(self.leftBall_)
    self.tbInfo_:setReward(self.price_ * self.lottery_)
end

function TBUI:load(args)
    self.currentScore_ = args.score
    self.price_ = args.bet / 100
    self.leftBall_ = args.total
    self.leftLottery_ = args.lottery
    self.lottery_ = 0

    self.tbInfo_:setGoldPool(args.pool)
    updateTBInfo(self)
end

function TBUI:selectPlate(index)
    for i, plate in pairs(self.plate_) do
        plate:setSelected(index == i)
        plate:enableTouch(false)
        plate:blink(false)
    end
    self.selectIndex_ = index
end

function TBUI:addPlateTouchCallback(callback)
    for i, plate in pairs(self.plate_) do
        plate:addTouchCallback(handler(i, callback))
    end
end

function TBUI:promptSelect(delay)
    self.imgBg_:getChildByName("img_tips"):show()
    local imgWarning = self.imgBg_:getChildByName("txt_warning")
    imgWarning:setString(string.format(SubLang:word(5), delay))
    local left = delay
    local seq = cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        left = left - 1
        left = left >= 0 and left or 0
        imgWarning:setString(string.format(SubLang:word(5), left))
    end))
    imgWarning:runAction(cc.Repeat:create(seq, delay))
end

function TBUI:finishSelect(index)
    self.imgBg_:getChildByName("img_tips"):hide()
    local imgWarning = self.imgBg_:getChildByName("txt_warning")
    imgWarning:stopAllActions()
    imgWarning:hide()
    self:selectPlate(index)
end

local function getRandCandidateDragonIndex(self, plateIndex)
    local candidate = {
        [0] = {3, 4},
        [1] = {0, 3, 4},
        [2] = {0, 1, 2, 3, 4},
        [3] = {0, 1, 4},
        [4] = {0, 1}
    }
    local arr = candidate[plateIndex]
    while #arr > 0 do
        local index = math.random(1, #arr)
        local dragonIndex = arr[index]
        table.remove(arr, index)
        if not self.dragon_[dragonIndex]:isShootting() then
            return dragonIndex
        end
    end
end

function TBUI:playShootBall(callback)
    local totalBall = self.leftBall_
    local order = {}
    for i = 1, totalBall do
        table.insert(order, i)
    end
    local lotteryOrder = {}
    for i = 1, self.leftLottery_ do
        local randomIndex = math.random(1, #order)
        table.insert(lotteryOrder, order[randomIndex])
        table.remove(order, randomIndex)
    end
    local unLotteryPlates = {0, 1, 2, 3, 4}
    table.removebyvalue(unLotteryPlates, self.selectIndex_)

    local ballIndex = 1
    local callFunc = cc.CallFunc:create(function()
        local plateIndex = table.indexof(lotteryOrder, ballIndex) and self.selectIndex_ or unLotteryPlates[math.random(1, #unLotteryPlates)]
        local dragonIndex = getRandCandidateDragonIndex(self, plateIndex)
        local dragon = self.dragon_[dragonIndex]
        if not dragon then
            return
        end
        dragon:shoot(function()
            self.plate_[plateIndex]:ballEnter(self.plate_[dragonIndex]:getBallStartPos(), function()
                -- body
                if plateIndex == self.selectIndex_ then
                    self.lottery_ = self.lottery_ + 1
                    self.leftLottery_ = self.leftLottery_ - 1
                    self.currentScore_ = self.currentScore_ + self.price_
                end
                self.leftBall_ = self.leftBall_ - 1
                updateTBInfo(self)
                if self.leftBall_ <= 0 then
                    callback({
                        bet = self.price_ * 100,
                        price = self.price_,
                        lottery = self.price_ * self.lottery_
                    })
                end
            end)
        end)
        ballIndex = ballIndex + 1
        if ballIndex > totalBall then
            self:stopActionByTag(100)
        end
    end)
    local rep = cc.RepeatForever:create(cc.Sequence:create(callFunc, cc.DelayTime:create(0.35)))
    rep:setTag(100)
    self:runAction(rep)
end
-------------------------------------------------------------------------------------------------------------

local LHDBTBLayer = class("LHDBTBLayer")

local AUTO_SELECT_TAG = 99

function LHDBTBLayer:ctor()
    self.finished_ = false
    self.finishCallback_ = nil
end

local function plateTouch(self, index)
    self.ui_:stopActionByTag(AUTO_SELECT_TAG)
    self.ui_:finishSelect(index)
    self.ui_:playShootBall(function(args)
        LHDBGameEnd:show(self.ui_, args, function()
            self.finished_ = true
            if self.finishCallback_ then
                self.finishCallback_()
                self.finishCallback_ = nil
            end
        end)
    end)
end

local function delayAutoSelect(self, delay)
    delay = delay or 15
    self.ui_:promptSelect(delay)
    local seq = cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(function()
        plateTouch(self, math.random(1, 5) - 1)
    end))
    seq:setTag(AUTO_SELECT_TAG)
    self.ui_:runAction(seq)
end

function LHDBTBLayer:show(parent, args)
    if not parent or self.ui_ then
        return
    end

    self.finished_ = false
    self.finishCallback_ = args.finishCall
    self.ui_ = TBUI.new(args)
    self.ui_:addPlateTouchCallback(handler(self, plateTouch))
    self.ui_:addTo(parent)
    self.ui_:load(args)
    delayAutoSelect(self)
end

function LHDBTBLayer:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
    self.finished_ = false
end

function LHDBTBLayer:isFinished()
    return self.finished_
end

return LHDBTBLayer
