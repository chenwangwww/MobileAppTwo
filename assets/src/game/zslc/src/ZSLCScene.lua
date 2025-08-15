local GameMessage = require("game.zslc.src.ZSLCMessage")
local GameCMD = require("game.zslc.src.ZSLCCMD")
local ZSLCLogic = require("game.zslc.src.ZSLCLogic")
local ZSLCScene = class("ZSLCScene", require("app.views.base.BaseGameScene"))

function ZSLCScene:onCreate()
    cc.exports.SubLang = require("game.zslc.src.ZSLCLang").new()
    self.bIsTest = GameDefine.bIsLocalTest

    ZSLCScene.super.onCreate(self)

    if GameDefine.bIsLocalTest then
        display.loadSpriteFrames("game/zslc/res/diamondtrain.plist", "game/zslc/res/diamondtrain.png")
    end

    self.tBetCache = {} -- 消息缓存

    self.tLightMoves = {} -- 光圈表
    self.tTrainList = {} -- 列车表
    self.tCannonSprite = {} -- 炮弹表
    self.tFireworkSprite = {} -- 烟花表
    self.tBonusList = {} -- 奖中表
    self.stop_sign = {-1, -1, -1} -- 拉霸状态标记
    self.nCurJackpotIdx = 0 -- 当前奖励显示索引
    self.elaspe = 0
    self.bIsInAction = false
    self.bIsSlotComplete = false
    self.nCurCompleteSec = 0
    self.nWaitWinPointSec = 0
    self.nWinPiontTimestamp = 0
    self.theLastMoveIdx = 0
    self.nLastCompleteStamp = 0
    self.nAutoBetInterval = 0
    self.nCurLightVoiceZone = 2
    self.nCurLightVoiceStamp = 0
    self.nLightVoiceInterval1 = 0.1
    self.nLightVoiceInterval2 = 0.15

    -- 基本速度
    self.nBaseSlotSpeed1 = 30
    self.nBaseSlotSpeed2 = 1.5

    self.logic = ZSLCLogic.new(self)

    self.layer = cc.CSLoader:createNode("game/zslc/res/DiamondTrainScene.csb")
    self:addChild(self.layer)
    -- GameUtil.printNodeTree(1, " - ", self.layer)

    self.frame_cache = cc.SpriteFrameCache:getInstance()
    self.scheduler = cc.Director:getInstance():getScheduler()
    self.tPosY = {138, -55}

    self:initNode()
    self:initXian()
    self:initBetTimes()
    self:initWinFnt()
    self:initButton()
    self:initRailroad()
    self:initSlots()
    self:initJP()
    self:initTipsPanel()

    ccui.Helper:doLayout(self.layer)

    self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)

    self:updateBetTimes()
end

function ZSLCScene:initNode()
    self.Image_bg1 = self.layer:getChildByName("Image_bg1")
    self.Image_bg1:loadTexture("game/zslc/res/big_png/img_bg.png", 0)
    -- self.Image_bg1:setContentSize(display.size)
    self.Image_bg2 = self.layer:getChildByName("Image_bg2")
    self.Image_bg2:loadTexture("game/zslc/res/big_png/img_jiqimian1.png", 0)
    self.Button_exit = self.layer:getChildByName("Button_exit")
    self.Button_help = self.layer:getChildByName("Button_help")
    self.Button_setting = self.layer:getChildByName("Button_setting")

    self.Panel_slots = self.Image_bg2:getChildByName("Panel_slots")
    self.Node_JP = self.Image_bg2:getChildByName("Node_JP")
    self.Node_train = self.Image_bg2:getChildByName("Node_train")
    self.Node_fruits = self.Image_bg2:getChildByName("Node_fruits")
    self.Node_num = self.Image_bg2:getChildByName("Node_num")
    self.Image_betTimes = self.Image_bg2:getChildByName("Image_betTimes")
    self.Node_Button = self.Image_bg2:getChildByName("Node_Button")
    self.Node_player = self.Image_bg2:getChildByName("Node_player")

    local imgAvatar = GameUtil.createAvatar(globalUserInfo.headimgurl, 68, false, nil, nil, "img_avatar_1")
    imgAvatar:setPosition(85, 80)
    self.Node_player:addChild(imgAvatar)

    self.Node_player:getChildByName("Text_name"):setString(globalUserInfo.szNickName)
    self.Node_num:getChildByName("bonus_fnt"):setFntFile("game/zslc/res/fnt/fnt_bonus.fnt")
end

function ZSLCScene:initBetTimes()
    self.tBetTimesTxt = {}
    local bg, txt
    for i = 1, 4 do
        bg = self.Image_betTimes:getChildByName("Image_numbg" .. i)
        txt = bg:getChildByName("num_fnt" .. i)
        txt:setFntFile("game/zslc/res/fnt/fnt_yazhu.fnt")
        self.tBetTimesTxt[i] = {
            bg = bg,
            txt = txt
        }
    end
end

function ZSLCScene:initTipsPanel()
    self.Panel_tips = self.layer:getChildByName("Panel_tips")
    local Panel_txt = self.Panel_tips:getChildByName("Panel_txt")
    self.Text_tips = Panel_txt:getChildByName("Text_tips")
    self.Text_tips:setString("")
    self.Panel_tips:setCascadeOpacityEnabled(true)
    self.Panel_tips:setCascadeColorEnabled(true)
    self.Panel_tips:setPosition(display.cx, 750 + 50)
    self.bIsShowTips = false
    self.tips_list = {SubLang:word(1)}
    self.lastMesgInfo = ""

    self:showTips()
end

function ZSLCScene:initWinFnt()
    self.win_fnt = self.Node_num:getChildByName("win_fnt")
    self.win_fnt:setFntFile("game/zslc/res/fnt/fnt_yingdfs.fnt")
    self.nCurPoint = 0
    self.nStarPoint = 0
    self.nEndPoint = 0
    self.nEndPointStamp = 0
    self.win_fnt:setString(0)
    local x, y = self.win_fnt:getPosition()
    self.win_fnt_pos = cc.p(x, y)
end

function ZSLCScene:initXian()
    self.Sprite_xian = self.Image_betTimes:getChildByName("Sprite_xian")
    self.Sprite_xian:setVisible(false)

    local animation = cc.Animation:create()
    local name, frame
    for i = 1, 8 do
        name = "diamondtrain_png/yh_xian" .. i .. ".png"
        self:checkFrame(name)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end
    animation:setDelayPerUnit(0.1)
    animation:setRestoreOriginalFrame(true)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    self.Sprite_xian:runAction(action)
end

function ZSLCScene:initJP()
    local img, fnt
    self.tImgJPBG = {}

    local function onClickJP(sender)
        for k, node in ipairs(self.tImgJPBG) do
            if node == sender then
                if k >= 2 and k <= 6 then
                    if self.bIsInAction then
                        PlazaManager.showTips(SubLang:word(2))
                        return false
                    end

                    if self.logic:isAutoBet() then
                        PlazaManager.showTips(SubLang:word(3))
                        return false
                    end

                    self:resetShow()
                    self:setAllMask(false)
                    self:updateMask()
                    self.logic:setBetTimes(25 * (5 - (k - 2)))
                end
                break
            end
        end
    end

    local tblStr = {SubLang:word(7), SubLang:word(8), "4/5", "3/5", "2/5", "1/5"}
    for i = 1, 6 do
        img = self.Node_JP:getChildByName("Image_jpbg" .. i)
        fnt = self.Node_JP:getChildByName("jp_fnt" .. i)

        if LangCtrl:isCN() then
            fnt:setFntFile("game/zslc/res/fnt/fnt_all.fnt")
        else
            fnt = GameUtil.convFntToTTF(fnt, tblStr[i], 25, 0, -4)
            fnt:setColor(cc.YELLOW)
            fnt:enableOutline(cc.c4b(94, 26, 5, 255), 1)
        end
        img:setTouchEnabled(true)
        img:addClickEventListener(onClickJP)
        self.tImgJPBG[i] = img
    end
end

function ZSLCScene:updateBetTimes()
    local num = self.logic:getBetTimes() -- max 125

    local tbl
    if num >= 25 and num < 50 then
        tbl = {true, true, true, true, true, false}
    elseif num >= 50 and num < 75 then
        tbl = {true, true, true, true, false, true}
    elseif num >= 75 and num < 100 then
        tbl = {true, true, true, false, true, true}
    elseif num >= 100 and num < 125 then
        tbl = {true, true, false, true, true, true}
    elseif num == 125 then
        tbl = {true, false, true, true, true, true}
    else
        tbl = {true, true, true, true, true, true}
    end

    for key, vis in pairs(tbl) do
        if vis then
            self.tImgJPBG[key]:setOpacity(255)
        else
            self.tImgJPBG[key]:setOpacity(0)
        end
    end

    num = self.logic:getBetTimes() * self.logic:getCellScore()
    for i, tbl in pairs(self.tBetTimesTxt) do
        tbl.txt:setString(num)
    end
end

local function getNumStr(num)
    local str
    if num <= 0 then
        if num < -10000 then
            num = -1 * num
            local t1 = math.modf(num / 10000)
            local t2 = math.modf(num % 10000 / 1000)
            str = "-" .. tostring(t1) .. "." .. tostring(t2) .. "万"
        else
            str = tostring(num)
        end
    else
        if num > 10000 then
            local t1 = math.modf(num / 10000)
            local t2 = math.modf(num % 10000 / 1000)
            str = tostring(t1) .. "." .. tostring(t2) .. "万"
        else
            str = tostring(num)
        end
    end
    return str
end

function ZSLCScene:updatePlayerGold()
    local gold = self.logic:getPlayerGold()
    self.Node_player:getChildByName("Text_num"):setString(getNumStr(gold))
end

function ZSLCScene:updateWinPoint()
    if self.analyze == nil then
        return
    end

    if self.analyze.winPoint ~= self.nEndPoint then
        print("tarzan error winPoint:", self.analyze.winPoint, self.nEndPoint, self.nCurPoint)
    end

    self.win_fnt:setString(self.analyze.winPoint)
    self.nCurPoint = self.analyze.winPoint
    self.logic:setPlayerGold(self.analyze.curPoint + self.analyze.winPoint)
    self.logic:setPoolCount(self.analyze.lGoldPool)

    self.nStarPoint = self.nCurPoint
    self.nEndPoint = self.nCurPoint
end

function ZSLCScene:updateBonus()
    local num = self.logic:getPoolCount()
    self.Node_num:getChildByName("bonus_fnt"):setString(num)
end

function ZSLCScene:initButton()
    self.Button_stop3 = self.Node_Button:getChildByName("Button_stop3")
    self.Button_stop2 = self.Node_Button:getChildByName("Button_stop2")
    self.Button_stop1 = self.Node_Button:getChildByName("Button_stop1")
    self.Button_clean = self.Node_Button:getChildByName("Button_clean")

    self.Button_bet = self.Node_Button:getChildByName("Button_bet")
    self.Button_start = self.Node_Button:getChildByName("Button_start")
    self.Button_accelerate = self.Node_Button:getChildByName("Button_accelerate")
    self.Fnt_accelerate = self.Button_accelerate:getChildByName("Fnt_accelerate")
    if LangCtrl:isCN() then
        self.Fnt_accelerate:setFntFile("game/zslc/res/fnt/fnt_jiasu.fnt")
    else
        local str = SubLang:word(6) .. self.logic:getSpeed()
        self.Fnt_accelerate = GameUtil.convFntToTTF(self.Fnt_accelerate, str, 30)
        self.Fnt_accelerate:setColor(cc.WHITE)
    end
    self.nAcceleratePosY = self.Fnt_accelerate:getPositionY()

    self.Image_guan = self.Button_start:getChildByName("Image_guan")
    self.Image_guan:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
    self.Image_guan:setVisible(false)
    self.Image_btntips = self.Button_start:getChildByName("Image_btntips")
    self.nBtnTipsPosY = self.Image_btntips:getPositionY()

    self.Button_exit:addClickEventListener(handler(self, self.doExit))
    self.Button_setting:addClickEventListener(handler(self, self.doSetting))
    self.Button_stop3:addClickEventListener(handler(self, self.doStop3))
    self.Button_stop2:addClickEventListener(handler(self, self.doStop2))
    self.Button_stop1:addClickEventListener(handler(self, self.doStop1))
    self.Button_clean:addClickEventListener(handler(self, self.doClean))
    self.Button_bet:addTouchEventListener(handler(self, self.doAddBet))
    self.Button_start:addTouchEventListener(handler(self, self.doStart))
    self.Button_accelerate:addTouchEventListener(handler(self, self.doAccelerate))
    self.Button_help:addClickEventListener(handler(self, self.doHelp))
end

function ZSLCScene:setAllMask(bb)
    for idx, tbl in ipairs(self.tImageMask) do
        tbl.visible = bb
    end
end

function ZSLCScene:updateMask()
    for idx, tbl in ipairs(self.tImageMask) do
        if self.tHightlight[idx] and #self.tHightlight[idx].tLights > 0 then
            tbl.mask:setVisible(false)
        else
            tbl.mask:setVisible(tbl.visible)
        end
    end
end

function ZSLCScene:hideMask(idx)
    local tbl = self.tImageMask[idx]
    if tbl then
        tbl.visible = false
    end
end

function ZSLCScene:initRailroad()
    local list = self.logic:getRailroad()
    self.tRailroad = {}
    self.tHightlight = {}
    self.tImageMask = {}

    local tbl_pos = {
        [4] = {211, 606},
        [12] = {1121, 606},
        [18] = {1121, 180},
        [26] = {211, 180}
    }

    local icon, x, y, scale, iconId, res, mask
    for i = 1, 28 do
        icon = self.Node_fruits:getChildByName("Image_fruits" .. i)
        mask = self.Node_fruits:getChildByName("Image_mask" .. i)
        mask:setOpacity(168)
        mask:setVisible(false)
        self.tImageMask[i] = {
            index = i,
            mask = mask,
            visible = false
        }

        if i >= 4 and i <= 12 then
            icon:setPositionY(tbl_pos[4][2])
        elseif i >= 12 and i <= 18 then
            icon:setPositionX(tbl_pos[12][1])
        elseif i >= 18 and i <= 26 then
            icon:setPositionY(tbl_pos[18][2])
        else
            icon:setPositionX(tbl_pos[4][1])
        end

        scale = icon:getScale()
        iconId = list[i]
        if tbl_pos[i] then
            x, y = tbl_pos[i][1], tbl_pos[i][2]
            icon:setPosition(x, y)
        else
            x, y = icon:getPosition()
        end

        if iconId == 6 then
            res = self.logic:getSlotsIcon(22)
        else
            res = self.logic:getSlotsIcon(iconId)
        end
        icon:setVisible(self:checkFrame(res))
        icon:loadTexture(res, 1)

        self.tRailroad[i] = {
            idx = i,
            iconId = iconId,
            icon = icon,
            x = x,
            y = y,
            scale = scale,
            roate = nil,
            flipX = false, -- 火车
            roate2 = nil -- 烟花
        }

        if i == 4 then
            self.tRailroad[i].roate = 0
            self.tRailroad[i].roate2 = 180
        elseif i == 12 then
            self.tRailroad[i].roate = 90
            self.tRailroad[i].roate2 = 270
        elseif i == 18 then
            self.tRailroad[i].roate = 0
            self.tRailroad[i].flipX = true
            self.tRailroad[i].roate2 = 0
        elseif i == 26 then
            self.tRailroad[i].roate = -90
            self.tRailroad[i].roate2 = 90
        end
    end

end

function ZSLCScene:checkFrame(name)
    local frame = self.frame_cache:getSpriteFrameByName(name)
    if frame == nil then
        local str = "tarzan check frame not found frame:" .. tostring(name)
        print(str)

        local png = "game/zslc/res/diamondtrain.png"
        local plist = "game/zslc/res/diamondtrain.plist"
        self.frame_cache:addSpriteFrames(plist, png)
    end

    frame = self.frame_cache:getSpriteFrameByName(name)
    return frame ~= nil
end

-- 初始化拉霸
function ZSLCScene:initSlots()
    self.tSlots = {{nil, nil}, {nil, nil}, {nil, nil}}
    self.tJPIcon = {{nil, nil}, {nil, nil}, {nil, nil}}
    self.tSlotAnimate = {nil, nil, nil}
    self.tSlotPos = {95, 295, 492}

    local wspos
    for ii, vv in ipairs(self.tSlotPos) do
        wspos = self.Panel_slots:convertToWorldSpace(cc.p(vv, 138))
        self.tSlotPos[ii] = self.Image_bg2:convertToNodeSpace(wspos)
    end

    local animation, name, frame, action

    animation = cc.Animation:create()
    for i = 1, 5 do
        name = "diamondtrain_png/hjlc_liand" .. i .. ".png"
        self:checkFrame(name)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end
    animation:setDelayPerUnit(0.2)
    animation:setRestoreOriginalFrame(true)
    action = cc.RepeatForever:create(cc.Animate:create(animation))
    local acts = {action, action:clone(), action:clone()}

    local icon, img, idx, jp, iconId, Sprite_ani
    for a = 1, 3 do
        for b = 1, 2 do
            iconId = math.random(0, 13)
            icon = self.logic:getSlotsIcon(iconId)
            idx = (b - 1) * 3 + a
            img = self.Panel_slots:getChildByName("Image_slot" .. idx)
            img:setVisible(self:checkFrame(icon))
            img:loadTexture(icon, 1)

            jp = img:getChildByName("Image_jp")
            jp:setVisible(iconId >= 7 and iconId <= 13)

            self.tSlots[a][b] = img
            self.tJPIcon[a][b] = jp
        end

        Sprite_ani = self.Panel_slots:getChildByName("Sprite_ani" .. a)
        Sprite_ani:runAction(acts[a])
        Sprite_ani:setVisible(false)
        self.tSlotAnimate[a] = Sprite_ani
    end
end

function ZSLCScene:hideAllSlotAnimate()
    for a, sprite in pairs(self.tSlotAnimate) do
        sprite:setVisible(false)
    end
end

local function easeOutBack(ratio)
    local invRatio = ratio - 1.0
    local s = 1.70158
    return math.pow(invRatio, 2) * ((s + 1.0) * invRatio + s) + 1.0
end

local function easeOutElastic(ratio)
    if ratio == 0 or ratio == 1 then
        return ratio
    else
        local p = 0.3
        local s = p / 4.0
        return math.pow(2.0, -10.0 * ratio) * math.sin((ratio - s) * (2.0 * math.pi) / p) + 1
    end
end

local function caleScale(posY)
    return 1 - 0.3 * math.min(math.abs(posY - 138), 193) / 193
end

function ZSLCScene:getIconByPosY(a, y)
    local list = self.analyze.tCardBak
    local idx = 1

    if y == 138 then
        idx = 1
    elseif y == -55 then
        idx = 2
    end

    local card = list[a][idx]
    if card == nil then
        print("tarzan error getIconByPosY a, idx, y", a, idx, y)
        dump(list)
    end

    return self.logic:getSlotsIcon(card), card
end

function ZSLCScene:getEndY(y)
    if y >= 138 then
        return 138
    else
        return -55
    end
end

function ZSLCScene:tumbleSlot(dt)
    local img, y, res, count, card

    for a = 1, 3 do
        if self.stop_sign[a] == 1 then
            count = #self.analyze.tCardList[a]
            for b = 1, 2 do
                img = self.tSlots[a][b]
                y = img:getPositionY()
                y = y - (self.nBaseSlotSpeed1 * self.logic:getActionSpeed())
                if y < -55 then
                    y = 386 + y
                    if count > 0 then
                        card = table.remove(self.analyze.tCardList[a])
                        if card then
                            res = self.logic:getSlotsIcon(card)
                            img:setVisible(self:checkFrame(res))
                            img:loadTexture(res, 1)

                            self.tJPIcon[a][b]:setVisible(card >= 7 and card <= 13)
                        else
                            print("tarzan error getSlotsIcon a, b, count", a, b, count)
                            dump(self.analyze.tCardList)
                        end

                        if #self.analyze.tCardList[a] == 0 then
                            self.stop_sign[a] = 2
                        end
                    end
                end
                img:setPositionY(y)
                img:setScale(caleScale(y))
            end

            if self.stop_sign[a] == 2 then
                self:stopVoiceId()
                -- local str = string.format("game/zslc/res/sound/slotFruitStop%d.mp3", a)
                MusicManager.playEffect("game/zslc/res/sound/slotFruitStop1.mp3")
                for b = 1, 2 do
                    img = self.tSlots[a][b]
                    y = img:getPositionY()
                    self.slow_action[a][b] = {
                        start = y,
                        over = self:getEndY(y),
                        sec = self.nBaseSlotSpeed2 / self.logic:getActionSpeed(),
                        now = self.elaspe
                    }
                end
            end
        elseif self.stop_sign[a] == 2 then
            local slow, ratio, progress
            for b = 1, 2 do
                img = self.tSlots[a][b]
                slow = self.slow_action[a][b]
                ratio = (self.elaspe - slow.now) / slow.sec
                -- progress = easeOutBack(ratio)
                progress = easeOutElastic(ratio)
                y = slow.start + (slow.over - slow.start) * progress
                img:setPositionY(y)
                img:setScale(caleScale(y))

                if y <= self.tPosY[2] then
                    img:setVisible(false)
                end

                if ratio >= 1 then
                    self.stop_sign[a] = 0
                end
            end

            if self.stop_sign[a] == 0 then
                for b = 1, 2 do
                    img = self.tSlots[a][b]
                    slow = self.slow_action[a][b]
                    img:setPositionY(slow.over)
                    img:setScale(caleScale(slow.over))
                end
            end
        elseif self.stop_sign[a] == 3 then -- 手动立即停止
            for b = 1, 2 do
                img = self.tSlots[a][b]
                y = self.tPosY[b]
                img:setPositionY(y)
                img:setScale(caleScale(y))
                local frame_name, card = self:getIconByPosY(a, y)
                img:setVisible(self:checkFrame(frame_name))
                img:loadTexture(frame_name, 1)

                self.tJPIcon[a][b]:setVisible(card >= 7 and card <= 13)
            end
            self.stop_sign[a] = 0
        end
    end

    if self:isSlotComplete() and not self.bIsSlotComplete then
        self.bIsSlotComplete = true

        local card, timesIdx = self:getSameCard()
        if card ~= -1 then
            self.Sprite_xian:setVisible(true)

            local wsPos = self.tBetTimesTxt[4].bg:convertToWorldSpace(cc.p(60, 22))
            local nsPos = self.Image_bg2:convertToNodeSpace(wsPos)

            local num = self.logic:getWinPoint(card, timesIdx)
            self.nWinPiontTimestamp = self.elaspe
            self:newFontPoint(num, nsPos, self.elaspe)

        else
            self.Sprite_xian:setVisible(false)
        end
    end
end

function ZSLCScene:getSameCard()
    local tbl = {}
    for i = 1, 3 do
        if self.analyze.slots[i] >= 7 and self.analyze.slots[i] <= 13 then
            table.insert(tbl, self.analyze.slots[i] - 7)
        elseif self.analyze.slots[i] >= 0 and self.analyze.slots[i] <= 6 then
            table.insert(tbl, self.analyze.slots[i])
        end
    end

    if #tbl > 0 then
        local one = tbl[1]
        for kk, vv in ipairs(tbl) do
            if vv ~= one then
                return -1, 0
            end
        end
        if self.analyze.slots[2] == 14 then
            return tbl[1], 4
        else
            return tbl[1], 3
        end
    else
        return -1, 0
    end
end

function ZSLCScene:getSameWithSlotsIdx(idx)
    local tbl = self.logic:getRailroad()
    local temp = tbl[idx]

    local ret = {}

    if temp then
        for i = 1, 3 do
            if self.analyze.slots[i] >= 7 and self.analyze.slots[i] <= 13 then
                if self.analyze.slots[i] - 7 == temp then
                    table.insert(ret, i)
                end
            elseif self.analyze.slots[i] >= 0 and self.analyze.slots[i] <= 6 then
                if self.analyze.slots[i] == temp then
                    table.insert(ret, i)
                end
            end

            if i == 1 and #ret > 0 and self.analyze.slots[2] == 14 then
                table.insert(ret, 2)
            end
        end
    else
        print("tarzan isSameWithSlots error:", idx)
    end

    return ret
end

function ZSLCScene:slowAddPoint(dt)
    if self.nCurPoint == self.nEndPoint then
        return
    end

    local diff = self.elaspe - self.startPointSec
    if diff >= self.nSlowPointSec then
        self.nCurPoint = self.nEndPoint
    else
        local ratio = diff / self.nSlowPointSec
        self.nCurPoint = math.floor(self.nStarPoint + (self.nEndPoint - self.nStarPoint) * ratio)
    end

    self.win_fnt:setString(self.nCurPoint)

    if self.nCurPoint == self.nEndPoint then
        if self.nEndPointStamp == self.nWinPiontTimestamp then
            self.nWinPiontTimestamp = 0
            self:checkComplete()
        else
            print("tarzan: not the same stamp =>", self.nEndPointStamp, self.nWinPiontTimestamp)
        end
    end
end

function ZSLCScene:setAddPoint(point, stamp)
    self.nEndPoint = self.nEndPoint + point
    self.nStarPoint = self.nCurPoint
    self.startPointSec = self.elaspe
    self.nEndPointStamp = stamp
    MusicManager.playEffect("game/zslc/res/sound/FunBonusExplode.mp3")
end

function ZSLCScene:checkMoveEnd(idx1)
    local temp = self:getSameWithSlotsIdx(idx1)
    local num
    self.theLastMoveIdx = idx1
    for _, idx2 in ipairs(temp) do
        num = self.logic:getMarioWinPoint(idx1, 1)
        self:addBonus(idx1, idx2, num)
    end
end

function ZSLCScene:addBonus(idx1, idx2, num)
    local tbl = {
        nStartMarioIdx = idx1,
        nEndSlotIdx = idx2,
        nBonusNum = num,
        nStartSec = 0
    }
    table.insert(self.tBonusList, tbl)
end

function ZSLCScene:onBonusMove(dt)
    for idx, tbl in ipairs(self.tBonusList) do
        if tbl.nStartSec == 0 then
            if idx == 1 or self.elaspe - self.tBonusList[idx - 1].nStartSec > self.nMaxWaitBonusSec then
                tbl.nStartSec = self.elaspe
                self:createBonusNode(tbl.nStartMarioIdx, tbl.nEndSlotIdx, tbl.nBonusNum)
            end
            break
        end
    end
end

function ZSLCScene:createBonusNode(startMarioIdx, endSlotIdx, num)
    if num <= 0 then
        return
    end

    MusicManager.playEffect("game/zslc/res/sound/PositiveOut.mp3")
    self.nWinPiontTimestamp = self.elaspe
    local stamp = self.elaspe

    local tbl = self.logic:getRailroad()
    local res = self.logic:getSlotsIcon(tbl[startMarioIdx])
    local curX, curY = self.tRailroad[startMarioIdx].x, self.tRailroad[startMarioIdx].y

    local img = ccui.ImageView:create(res, 1)
    img:setPosition(curX, curY)
    img:setScale(0.44)
    self.Image_bg2:addChild(img)

    local endPos = self.tSlotPos[endSlotIdx]

    local function showAddPoint()
        self.tSlotAnimate[endSlotIdx]:setVisible(true)
        self:newFontPoint(num, endPos, stamp)
    end

    local sec = 0.5 / self.logic:getActionSpeed()
    local a1 = cc.MoveTo:create(sec, endPos)
    local a2 = cc.ScaleTo:create(sec, 0.8)
    local a3 = cc.Spawn:create(a1, a2)

    local a4 = cc.CallFunc:create(showAddPoint)
    local a5 = cc.RemoveSelf:create()
    local seq = cc.Sequence:create(a3, a4, a5)
    img:runAction(seq)
end

function ZSLCScene:newFontPoint(num, pos, stamp)

    local function addSlowPoint()
        self:setAddPoint(num, stamp)
    end

    local txtNode = ccui.TextBMFont:create("+" .. tostring(num), "game/zslc/res/fnt/fnt_hdfs.fnt")
    txtNode:setScale(0.5)
    txtNode:setPosition(pos)
    self.Image_bg2:addChild(txtNode)

    local sec = 0.2 / self.logic:getActionSpeed()
    local a1 = cc.MoveTo:create(sec, cc.p(pos.x, pos.y - 80))
    local a2 = cc.ScaleTo:create(sec, 1.2)
    local a3 = cc.Spawn:create(a1, a2)

    sec = 0.3 / self.logic:getActionSpeed()
    local random_move = cc.MoveTo:create(sec, cc.p(pos.x, pos.y + math.random(0, 35)))

    sec = 0.3 / self.logic:getActionSpeed()
    local a4 = cc.MoveTo:create(sec, self.win_fnt_pos)
    local a5 = cc.ScaleTo:create(sec, 0.5)

    -- local d1 = cc.DelayTime:create(0.)

    local a6 = cc.Spawn:create(a4, a5)
    local a7 = cc.CallFunc:create(addSlowPoint)
    local a8 = cc.RemoveSelf:create()
    local seq = cc.Sequence:create(a3, random_move, a6, a7, a8)
    txtNode:runAction(seq)
end

function ZSLCScene:isSlotComplete()
    return (self.stop_sign[1] == 0 and self.stop_sign[2] == 0 and self.stop_sign[3] == 0)
end

function ZSLCScene:checkComplete()
    if self.nCurJackpotIdx == -1 and self.bIsSlotComplete and self.bIsInAction then

        if self.elaspe - self.nWinPiontTimestamp >= self.nWaitWinPointSec then
            print("tarzan: Complete OK !")
            self:updateWinPoint()
            self.bIsInAction = false

            -- self:stopTimer()
        else
            print("tarzan: wait complete:", self.elaspe - self.nWinPiontTimestamp, self.nWaitWinPointSec)
        end
    else
        print("tarzan checkComplete:", self.nCurJackpotIdx, self.bIsSlotComplete, self.bIsInAction)
    end
end

function ZSLCScene:updateTime(dt)
    self.elaspe = self.elaspe + dt

    if self.bIsInAction then
        self:setAllMask(true)
        self:tumbleSlot(dt)
        self:onLightMove(dt)
        self:onTrainMove(dt)
        self:onCannonMove(dt)
        self:onFirework(dt)
        self:showJackpot(dt)
        self:onBonusMove(dt)
        self:slowAddPoint(dt)
        self:updateMask()

        -- 第一光圈也到达了目的地, 开始显示特殊奖励
        if self.nCurJackpotIdx == 0 and self:getStateLightMove(1) == 1 then
            self.nCurJackpotIdx = 1
            -- print("tarzan nCurJackpotIdx:", self.nCurJackpotIdx, #self.analyze.jackpot)
        end
    else

        if self.nLastCompleteStamp > 0 and self.elaspe - self.nLastCompleteStamp >= self.nAutoBetInterval then
            self.nLastCompleteStamp = self.elaspe
            if not self:doNextBetMsg() and self.logic:isAutoBet() then
                self:sendDoBet()
            end

        end
    end
end

function ZSLCScene:nextJackpot()
    local tbl = self.analyze.jackpot[self.nCurJackpotIdx]
    if tbl and tbl.nCompleteState == 1 then
        local nextIdx = self.nCurJackpotIdx + 1
        tbl = self.analyze.jackpot[nextIdx]
        if tbl then
            self.nCurJackpotIdx = nextIdx
            -- print("tarzan nCurJackpotIdx:", self.nCurJackpotIdx, #self.analyze.jackpot)
        end
    end
end

-- 显示特殊中奖
function ZSLCScene:showJackpot(dt)
    if self.nCurCompleteSec > 0 and self.elaspe - self.nCurCompleteSec < self.nMaxWait then
        -- print("tarzan wait...", self.elaspe - self.nCurCompleteSec)
        return
    end

    self.nCurCompleteSec = 0
    if self.nCurJackpotIdx <= 0 then
        return
    end

    local tbl = self.analyze.jackpot[self.nCurJackpotIdx]
    local last
    if tbl and tbl.nCompleteState ~= 1 then
        if tbl.marioType == 1 then -- 火车
            if tbl.tMarioIdxs[4] then
                if tbl.record[1] == nil then -- 还未进行动作
                    local tTargetIdxs = self:getTrainIds(tbl.tMarioIdxs[4], 4)
                    tbl.record[1] = {
                        timestamp = self.elaspe,
                        agentIdx = 0
                    }
                    tbl.record[1].agentIdx = self:addTrain(tTargetIdxs) -- 加入一趟目标
                elseif self:getStateTrip(tbl.record[1].agentIdx) == 1 then -- 查询动作完成否？
                    tbl.nCompleteState = 1
                end
            else
                tbl.nCompleteState = 1
            end
        elseif tbl.marioType == 15 then -- 烟花

            for kk, targetIdx in ipairs(tbl.tMarioIdxs) do
                if kk == 1 then
                    if tbl.record[kk] == nil then
                        tbl.record[kk] = {
                            timestamp = self.elaspe,
                            agentIdx = 0
                        }
                        tbl.record[kk].agentIdx = self:addFirework(targetIdx)
                        break
                    end
                else
                    if tbl.record[kk] == nil then
                        if self:getStateFirework(tbl.record[kk - 1].agentIdx) == 1 then
                            tbl.record[kk] = {
                                timestamp = self.elaspe,
                                agentIdx = 0
                            }
                            tbl.record[kk].agentIdx = self:addFirework(targetIdx)
                        end
                        break
                    end
                end
            end

            local all_ok = 0
            for _, temp_tbl in ipairs(tbl.record) do
                if self:getStateFirework(temp_tbl.agentIdx) == 1 then
                    all_ok = all_ok + 1
                end
            end
            if all_ok == #tbl.tMarioIdxs then
                tbl.nCompleteState = 1
            end

        elseif tbl.marioType == 22 then -- 坦克

            for kk, targetIdx in ipairs(tbl.tMarioIdxs) do
                if kk == 1 then
                    if tbl.record[kk] == nil then
                        tbl.record[kk] = {
                            timestamp = self.elaspe,
                            agentIdx = 0
                        }
                        tbl.record[kk].agentIdx = self:addCannonball(targetIdx)
                        break
                    end
                else
                    if tbl.record[kk] == nil then
                        if self:getStateCannon(tbl.record[kk - 1].agentIdx) == 1 then
                            tbl.record[kk] = {
                                timestamp = self.elaspe,
                                agentIdx = 0
                            }
                            tbl.record[kk].agentIdx = self:addCannonball(targetIdx)
                        end
                        break
                    end
                end
            end

            local all_ok = 0
            for _, temp_tbl in ipairs(tbl.record) do
                if self:getStateCannon(temp_tbl.agentIdx) == 1 then
                    all_ok = all_ok + 1
                end
            end
            if all_ok == #tbl.tMarioIdxs then
                tbl.nCompleteState = 1
            end

        else
            tbl.nCompleteState = 1
            -- print("tarzan what fuck this name:", tbl.marioType)
            -- dump(tbl)
        end

        if tbl.nCompleteState == 1 then
            if self.nCurJackpotIdx == #self.analyze.jackpot then -- 是否最后一个完成
                self.nCurJackpotIdx = -1
                self:updateTheLastNode()
                self:checkComplete()
            else
                self:nextJackpot()
            end
        end
    elseif self.nCurJackpotIdx == 1 and tbl == nil then -- 一个奖励都没有
        self.nCurJackpotIdx = -1
        self:updateTheLastNode()
        self:checkComplete()
    end
end

function ZSLCScene:updateTheLastNode()
    self.nLastCompleteStamp = self.elaspe

    do
        return
    end
    local tbl = self.tHightlight[self.theLastMoveIdx]
    if tbl == nil then
        return
    end

    if #tbl.tLights > 1 then
        for ii = #tbl.tLights, 2, -1 do
            table.remove(tbl.tLights, ii):removeFromParent()
        end
    end

    local sec = 0.5 -- / self.logic:getActionSpeed()
    local seq = cc.Sequence:create(cc.Show:create(), cc.DelayTime:create(sec), cc.Hide:create(), cc.DelayTime:create(sec))
    tbl.tLights[1]:stopAllActions()
    tbl.tLights[1]:runAction(cc.RepeatForever:create(seq))
end

function ZSLCScene:getTrainIds(headId, len)
    local tbl = {}
    for i = 1, len do
        table.insert(tbl, self:calcTrainIdx(i, headId))
    end
    return tbl
end

function ZSLCScene:resetShow()
    self:hideAllHighlight()
    self:cleanLightMoves()
    self:cleanTrain()
    self:cleanCannon()
    self:cleanFirework()
    self:hideAllSlotAnimate()

    self.win_fnt:setString(0)
    self.Sprite_xian:setVisible(false)
end

function ZSLCScene:startAction()
    self.bIsInAction = true

    self:resetShow()

    self.logic:updateActionSpeed()
    self.analyze = self.logic:getAnalyze()

    self.nCurPoint = 0
    self.nStarPoint = 0
    self.nEndPoint = 0
    self.nEndPointStamp = 0
    self.tBonusList = {}
    self.theLastMoveIdx = 0

    self.nAutoBetInterval = 3 / self.logic:getActionSpeed()
    self.nWaitWinPointSec = 2 / self.logic:getActionSpeed()
    self.nMaxWaitBonusSec = 0.5 / self.logic:getActionSpeed()
    self.nMaxWait = 0.8 / self.logic:getActionSpeed()
    self.nSlowPointSec = 0.5 / self.logic:getActionSpeed()
    self.nLightVoiceInterval1 = 0.05 / self.logic:getActionSpeed()
    self.nLightVoiceInterval2 = 0.1 / self.logic:getActionSpeed()

    self.nLastCompleteStamp = 0
    self.nWinPiontTimestamp = 0
    self.elaspe = 0
    self:addLightMove(self.analyze.marioIdx)
    self.nCurJackpotIdx = 0
    self.nCurCompleteSec = 0
    self.nCurLightVoiceZone = 2
    self.nCurLightVoiceStamp = 0

    self.stop_sign = {1, 1, 1}
    self.slow_action = {{}, {}, {}}
    self.bIsSlotComplete = false

    self:stopVoiceId()
    self.voiceId = ccexp.AudioEngine:play2d("game/zslc/res/sound/slotFruitStart.mp3", false, MusicManager.effectVal)
    -- self.schedulerID = self.scheduler:scheduleScriptFunc(handler(self, self.updateTime), 0, false)
end

function ZSLCScene:cleanTrain()
    for i, train in pairs(self.tTrainList) do
        for ii, tbl in pairs(train.carriage) do
            tbl.sprite:removeFromParent()
        end
    end

    self.tTrainList = {}
end

function ZSLCScene:addTrain(tTargetIdxs)
    ccexp.AudioEngine:play2d("game/zslc/res/sound/train_whistle.mp3", false, MusicManager.effectVal)
    local voiceId = ccexp.AudioEngine:play2d("game/zslc/res/sound/train_move_loop.mp3", true, MusicManager.effectVal)
    local train = {
        carriage = {},
        nCompleteState = 0,
        voiceId = voiceId,
        nWaitSec = 2,
        nNowSec = self.elaspe
    }
    local res, posIdx
    for i, idx in ipairs(tTargetIdxs) do
        if i == 1 then
            res = "diamondtrain_png/hc_1.png"
        elseif i == #tTargetIdxs then
            res = "diamondtrain_png/hc_3.png"
        else
            res = "diamondtrain_png/hc_2.png"
        end

        self:checkFrame(res)
        local sprite = ccui.ImageView:create(res, 1)
        sprite:setScale9Enabled(true)
        sprite:setCapInsets(cc.rect(1, 1, 103, 72))
        sprite:setVisible(false)
        posIdx = 2 - i
        if posIdx < 1 then
            posIdx = posIdx + 28
        end
        local curX, curY = self.tRailroad[posIdx].x, self.tRailroad[posIdx].y
        sprite:setPosition(curX, curY)

        if posIdx >= 26 or posIdx == 1 then
            sprite:setRotation(-90)
            sprite:setFlippedX(false)
        else
            sprite:setRotation(0)
            sprite:setFlippedX(true)
        end
        self.Node_train:addChild(sprite)

        local tbl = {
            curX = curX,
            curY = curY,
            targetIdx = idx,
            nCompleteState = 0,

            minCircle = 1,
            sprite = sprite,
            speedType = 1,
            startZone = posIdx,
            curZone = posIdx,
            minStart = 5,
            stepMove = 5,
            varStart = 25,
            nStartZoneABS = 15,
            minEnd = 5,
            varEnd = 25,
            nEndZoneABS = 15
        }
        table.insert(train.carriage, tbl)
    end

    if #train.carriage > 0 then
        table.insert(self.tTrainList, train)
        return #self.tTrainList
    end

    return 0
end

function ZSLCScene:getStateTrip(idx)
    local tbl = self.tTrainList[idx]
    if tbl then
        return tbl.nCompleteState
    end

    return -1
end

function ZSLCScene:calcTrainIdx(key, maxIdx)
    local newIdx = maxIdx - key + 1
    if newIdx < 1 then
        newIdx = newIdx + 28
    end
    return newIdx
end

function ZSLCScene:onTrainMove(dt)

    local move_dis, isMoveOK, limitSpeed
    local stateCfg, isLastOne
    local nOK = 0
    local checkOK = true

    for aa, train in ipairs(self.tTrainList) do

        if train.nCompleteState ~= 1 then

            if train.nWaitSec == 0 or self.elaspe - train.nNowSec >= train.nWaitSec then
                nOK = 0
                checkOK = true

                for kk = #train.carriage, 1, -1 do
                    if not train.carriage[kk].sprite:isVisible() then
                        checkOK = false
                        break
                    end
                end

                for bb, tbl in ipairs(train.carriage) do

                    if tbl.nCompleteState ~= 1 then
                        if bb == 1 then
                            limitSpeed = nil
                        else
                            limitSpeed = train.carriage[1].stepMove
                        end
                        isLastOne = bb == #train.carriage and bb > 1
                        isMoveOK, stateCfg = self:trainMove(tbl, checkOK, isLastOne, limitSpeed)
                        tbl.sprite:setPosition(tbl.curX, tbl.curY)
                        self:hideMask(tbl.curZone)

                        if tbl.curZone == 8 or tbl.curZone == 22 then
                            tbl.sprite:setContentSize(cc.size(270, 68))
                        else
                            tbl.sprite:setContentSize(cc.size(88, 68))
                        end

                        if stateCfg then
                            if stateCfg.roate ~= nil then
                                tbl.sprite:setRotation(stateCfg.roate)
                            end

                            if stateCfg.flipX ~= nil then
                                tbl.sprite:setFlippedX(stateCfg.flipX)
                            end
                        end

                        if not checkOK and tbl.curY >= self.tRailroad[1].y then
                            tbl.sprite:setVisible(true)
                        end

                        if isMoveOK then
                            self:checkMoveEnd(tbl.targetIdx)
                            tbl.nCompleteState = 1
                        end
                    end

                    if tbl.nCompleteState == 1 then
                        nOK = nOK + 1
                    end
                end

                if nOK == #train.carriage then -- 本趟列车全部到达目的地
                    train.nCompleteState = 1

                    local temp = train.carriage[1].targetIdx
                    if temp == 15 or temp == 22 or temp == 1 then
                        self.nCurCompleteSec = self.elaspe
                    end

                    if train.voiceId then
                        ccexp.AudioEngine:stop(train.voiceId)
                        train.voiceId = nil
                    end

                    for i, tbl in ipairs(train.carriage) do
                        tbl.sprite:setVisible(false)
                        self:highlightTarget(tbl.targetIdx)
                    end
                end
            end
        end
    end
end

function ZSLCScene:cleanCannon()
    for _, tbl in pairs(self.tCannonSprite) do
        tbl.sprite:removeFromParent()
    end

    self.tCannonSprite = {}
end

function ZSLCScene:getStateCannon(idx)
    local tbl = self.tCannonSprite[idx]
    if tbl then
        return tbl.nCompleteState
    end

    return -1
end

function ZSLCScene:createCannon()
    local frame, name
    local animation = cc.Animation:create()
    for i = 1, 7 do
        name = "diamondtrain_png/tk_ph_" .. i .. ".png"
        self:checkFrame(name)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end

    animation:setDelayPerUnit(0.05)
    animation:setRestoreOriginalFrame(true)

    local sprite = cc.Sprite:createWithSpriteFrameName("diamondtrain_png/tk_ph_1.png");
    sprite:setPosition(588, 188)
    self.Node_fruits:addChild(sprite)

    local action = cc.Sequence:create(cc.Animate:create(animation), cc.RemoveSelf:create())
    sprite:runAction(action)

    animation = cc.Animation:create()
    for i = 1, 4 do
        name = "diamondtrain_png/tk_pd_" .. i .. ".png"
        self:checkFrame(name)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end
    animation:setDelayPerUnit(0.2)
    animation:setRestoreOriginalFrame(true)

    sprite = cc.Sprite:createWithSpriteFrameName("diamondtrain_png/tk_pd_1.png");
    local curX, curY = 588, self.tRailroad[23].y
    sprite:setPosition(curX, curY)
    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    sprite:runAction(action)
    sprite:setAnchorPoint(cc.p(0.2, 0.5))
    self.Node_fruits:addChild(sprite)

    local voiceId = ccexp.AudioEngine:play2d("game/zslc/res/sound/cannon_fly.mp3", false, MusicManager.effectVal)

    return sprite, curX, curY, voiceId
end

function ZSLCScene:addCannonball(targetIdx)
    local tbl = {
        voiceId = nil,
        curX = nil,
        curY = nil,
        targetIdx = targetIdx,
        nCompleteState = 0,

        minCircle = 0,
        sprite = nil,
        speedType = 0,
        startZone = 15,
        curZone = 15,
        minStart = 40,
        stepMove = 40,
        varStart = 0,
        nStartZoneABS = 1,
        minEnd = 40,
        varEnd = 0,
        nEndZoneABS = 1,
        nWaitSec = 0.6,
        nNowSec = self.elaspe
    }
    table.insert(self.tCannonSprite, tbl)
    return #self.tCannonSprite
end

function ZSLCScene:onCannonMove(dt)
    local isMoveOK, stateCfg
    for _, tbl in pairs(self.tCannonSprite) do
        if tbl.nCompleteState ~= 1 then
            if tbl.nWaitSec == 0 or self.elaspe - tbl.nNowSec >= tbl.nWaitSec then
                if tbl.sprite then
                    isMoveOK, stateCfg = self:trainMove(tbl, true, false, nil)
                    tbl.sprite:setPosition(tbl.curX, tbl.curY)

                    if stateCfg and stateCfg.roate2 ~= nil then
                        tbl.sprite:setRotation(stateCfg.roate2)
                    end

                    if isMoveOK then
                        tbl.nCompleteState = 1
                        self:explodeAnimate(tbl.sprite, "diamondtrain_png/tk_yd_%d.png", 1, 9)
                        self:highlightTarget(tbl.targetIdx)
                        self:checkMoveEnd(tbl.targetIdx)

                        if tbl.voiceId then
                            ccexp.AudioEngine:stop(tbl.voiceId)
                            tbl.voiceId = nil
                            ccexp.AudioEngine:play2d("game/zslc/res/sound/cannon_explode.mp3", false, MusicManager.effectVal)
                        end
                    end
                else
                    tbl.sprite, tbl.curX, tbl.curY, tbl.voiceId = self:createCannon()
                end
            end
        end
    end
end

function ZSLCScene:addLightMove(targetIdx)
    local res = "diamondtrain_png/img_xuanzhong.png"
    self:checkFrame(res)
    local light = ccui.ImageView:create(res, 1)
    light:setPosition(self.tRailroad[2].x, self.tRailroad[2].y)
    light:setScale9Enabled(true)
    light:setCapInsets(cc.rect(30, 30, 28, 8))
    self.Node_fruits:addChild(light)

    local tbl = {
        curX = self.tRailroad[2].x,
        curY = self.tRailroad[2].y,
        targetIdx = targetIdx,
        nCompleteState = 0,

        minCircle = 2,
        light = light,
        speedType = 1,
        startZone = 2,
        curZone = 2,
        minStart = 5,
        stepMove = 5,
        varStart = 35,
        nStartZoneABS = 15,
        minEnd = 2,
        varEnd = 38,
        nEndZoneABS = 20,
        nWaitSec = 0.2,
        nNowSec = self.elaspe
    }
    table.insert(self.tLightMoves, tbl)
    return #self.tLightMoves
end

function ZSLCScene:cleanLightMoves()
    for _, tbl in pairs(self.tLightMoves) do
        tbl.light:removeFromParent()
    end
    self.tLightMoves = {}
end

function ZSLCScene:getStateLightMove(idx)
    local tbl = self.tLightMoves[idx]
    if tbl then
        return tbl.nCompleteState
    end

    return -1
end

function ZSLCScene:onLightMove(dt)
    local isMoveOK, stateCfg

    for _, tbl in pairs(self.tLightMoves) do
        if tbl.nCompleteState == 0 then
            if tbl.nWaitSec == 0 or self.elaspe - tbl.nNowSec >= tbl.nWaitSec then
                isMoveOK, stateCfg = self:trainMove(tbl, true, false, nil)
                tbl.light:setPosition(self.tRailroad[tbl.curZone].x, self.tRailroad[tbl.curZone].y)
                if tbl.curZone == 8 or tbl.curZone == 22 then
                    tbl.light:setContentSize(cc.size(270, 68))
                else
                    tbl.light:setContentSize(cc.size(88, 68))
                end

                self:hideMask(tbl.curZone)
                self:lightVoice(tbl)

                if isMoveOK then
                    tbl.nCompleteState = 1

                    if tbl.targetIdx == 15 or tbl.targetIdx == 22 or tbl.targetIdx == 1 then
                        self.nCurCompleteSec = self.elaspe
                    end

                    self:checkMoveEnd(tbl.targetIdx)
                    self:highlightTarget(tbl.targetIdx)
                    tbl.light:setVisible(false)
                end

            end

        end

    end
end

function ZSLCScene:lightVoice(tbl)
    if self.nCurLightVoiceZone == tbl.curZone then
        return
    end

    local interval = self.elaspe - self.nCurLightVoiceStamp

    --[[
    if tbl.speedType == 1 or tbl.speedType == -1 then
        if interval < self.nLightVoiceInterval2 then
            return
        end
    else
        if interval < self.nLightVoiceInterval1 then
            return
        end
    end
    --]]

    -- print("tarzan cur voice zone, interval:", tbl.curZone, interval)
    self.nCurLightVoiceZone = tbl.curZone
    self.nCurLightVoiceStamp = self.elaspe

    ccexp.AudioEngine:play2d("game/zslc/res/sound/light_move2.mp3", false, MusicManager.effectVal)
end

function ZSLCScene:cleanFirework()
    for _, tbl in pairs(self.tFireworkSprite) do
        tbl.sprite:removeFromParent()
    end

    self.tFireworkSprite = {}
end

function ZSLCScene:getStateFirework(idx)
    local tbl = self.tFireworkSprite[idx]
    if tbl then
        return tbl.nCompleteState
    end

    return -1
end

function ZSLCScene:onFirework(dt)
    local isMoveOK, stateCfg
    for _, tbl in pairs(self.tFireworkSprite) do
        if tbl.nCompleteState == 0 then
            if tbl.nWaitSec == 0 or self.elaspe - tbl.nNowSec >= tbl.nWaitSec then
                if tbl.sprite then
                    isMoveOK, stateCfg = self:trainMove(tbl, true, false, nil)
                    tbl.sprite:setPosition(tbl.curX, tbl.curY)

                    if stateCfg and stateCfg.roate2 ~= nil then
                        tbl.sprite:setRotation(stateCfg.roate2)
                    end

                    if isMoveOK then
                        ccexp.AudioEngine:play2d("game/zslc/res/sound/firework_explode.mp3", false, MusicManager.effectVal)
                        tbl.nCompleteState = 1
                        self:explodeAnimate(tbl.sprite, "diamondtrain_png/yh_zk_%d.png", 1, 9)
                        self:highlightTarget(tbl.targetIdx)
                        self:checkMoveEnd(tbl.targetIdx)
                    end
                else
                    tbl.sprite, tbl.curX, tbl.curY = self:createFirework()
                end
            end
        end
    end
end

function ZSLCScene:createFirework()
    local frame, name

    local animation = cc.Animation:create()
    for i = 1, 5 do
        name = "diamondtrain_png/yh_xlz_" .. i .. ".png"
        self:checkFrame(name)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end
    animation:setDelayPerUnit(0.2)
    animation:setRestoreOriginalFrame(true)

    local sprite = cc.Sprite:createWithSpriteFrameName("diamondtrain_png/yh_xlz_1.png")
    local curX, curY = self.tRailroad[15].x, self.tRailroad[15].y
    sprite:setPosition(curX, curY)
    sprite:setAnchorPoint(cc.p(0.3, 0.5))
    sprite:setRotation(self.tRailroad[12].roate2)

    local action = cc.RepeatForever:create(cc.Animate:create(animation))
    sprite:runAction(action)
    self.Node_fruits:addChild(sprite)

    ccexp.AudioEngine:play2d("game/zslc/res/sound/firework_fire.mp3", false, MusicManager.effectVal)

    return sprite, curX, curY
end

function ZSLCScene:addFirework(targetIdx)

    local tbl = {
        curX = nil,
        curY = nil,
        targetIdx = targetIdx,
        nCompleteState = 0,

        minCircle = 0,
        sprite = nil,
        speedType = 0,
        startZone = 15,
        curZone = 15,
        minStart = 40,
        stepMove = 40,
        varStart = 0,
        nStartZoneABS = 1,
        minEnd = 40,
        varEnd = 0,
        nEndZoneABS = 1,
        nWaitSec = 0.6,
        nNowSec = self.elaspe
    }

    table.insert(self.tFireworkSprite, tbl)
    return #self.tFireworkSprite
end

function ZSLCScene:explodeAnimate(sprite, resfmt, num1, num2)
    local frame, name
    local animation = cc.Animation:create()
    for i = num1, num2 do
        name = string.format(resfmt, i)
        frame = self.frame_cache:getSpriteFrameByName(name)
        if frame then
            animation:addSpriteFrame(frame)
        else
            print("tarzan no this frame:", name)
        end
    end

    animation:setDelayPerUnit(0.05)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Sequence:create(cc.Animate:create(animation), cc.Hide:create())
    sprite:stopAllActions()
    sprite:setAnchorPoint(display.CENTER)
    sprite:runAction(action)
end

function ZSLCScene:getAbsIdx(idx1, idx2)
    if idx2 < idx1 then
        return 28 - idx1 + idx2
    else
        return idx2 - idx1
    end
end

function ZSLCScene:updateSpeed(tbl)
    if tbl.speedType == 1 and (tbl.minStart + tbl.varStart) > tbl.stepMove then -- 加速
        local dis = self:getAbsIdx(tbl.startZone, tbl.curZone)
        local ratio = math.max(math.min(dis / tbl.nStartZoneABS, 1), 0)
        tbl.stepMove = tbl.varStart * ratio + tbl.minStart
        if ratio == 1 then
            tbl.speedType = 0 -- 均速
        end
    end

    if tbl.speedType ~= 1 and tbl.minCircle == 0 and tbl.minEnd < tbl.stepMove then -- 最后一圈减速
        local dis = self:getAbsIdx(tbl.curZone, tbl.targetIdx)
        if dis <= tbl.nEndZoneABS and dis > 0 then
            tbl.speedType = -1
            local ratio = math.max(math.min(dis / tbl.nEndZoneABS, 1), 0)
            tbl.stepMove = tbl.varEnd * ratio + tbl.minEnd

            if ratio == 0 then
                tbl.speedType = 0 -- 均速
            end
        end
    end
end

local upzone = {26, 27, 28, 1, 2, 3, 4}
function ZSLCScene:trainMove(tbl, checkOK, isLastOne, limitSpeed)
    local move_dis = 0
    if limitSpeed then
        move_dis = limitSpeed * self.logic:getActionSpeed() -- max142
    else
        self:updateSpeed(tbl)
        move_dis = tbl.stepMove * self.logic:getActionSpeed() -- max142
    end

    local targetIdx = tbl.targetIdx
    local curX, curY = tbl.curX, tbl.curY
    local newX, newY = tbl.curX, tbl.curY
    local tarX, tarY = self.tRailroad[targetIdx].x, self.tRailroad[targetIdx].y

    local stateCfg = nil
    local isMoveOK = false
    local zone = 0

    if curX == self.tRailroad[4].x and curY < self.tRailroad[4].y and curY >= self.tRailroad[26].y then -- 上行
        newY = curY + move_dis

        if checkOK and (targetIdx <= 4 or targetIdx > 26) then -- 检查是否到目标
            if curY < tarY and newY >= tarY then -- 到目标
                if tbl.minCircle > 0 then
                    tbl.minCircle = tbl.minCircle - 1
                else
                    newY = tarY
                    isMoveOK = true
                end
            end
        end

        if (not isMoveOK) or (isMoveOK and isLastOne) then -- 还没到目标，检查是否要转弯或者移动完成检查最后一个是否要转向
            local diff = newY - self.tRailroad[4].y
            if diff >= 0 then -- 需转向
                newX = curX + diff
                newY = self.tRailroad[4].y
                stateCfg = self.tRailroad[4]

                if checkOK and (targetIdx > 4 and targetIdx <= 12) then -- 转弯后检查是否到目标
                    if newX >= tarX then -- 到目标
                        if tbl.minCircle > 0 then
                            tbl.minCircle = tbl.minCircle - 1
                        else
                            newX = tarX
                            isMoveOK = true
                        end
                    end
                end

                for mm = 5, 12 do -- 计算当前区域
                    if newX > self.tRailroad[mm - 1].x and newX <= self.tRailroad[mm].x then
                        zone = mm
                        break
                    end
                end
            end
        end

        if zone == 0 then
            for mm = 2, #upzone do
                if newY > self.tRailroad[upzone[mm - 1]].y and newY <= self.tRailroad[upzone[mm]].y then
                    zone = upzone[mm]
                    break
                end
            end
        end
    elseif curY == self.tRailroad[4].y and curX < self.tRailroad[12].x and curX >= self.tRailroad[4].x then -- 右行
        newX = curX + move_dis

        if checkOK and (targetIdx > 4 and targetIdx <= 12) then -- 检查是否到目标
            if curX < tarX and newX >= tarX then -- 到目标
                if tbl.minCircle > 0 then
                    tbl.minCircle = tbl.minCircle - 1
                else
                    newX = tarX
                    isMoveOK = true
                end
            end
        end

        if (not isMoveOK) or (isMoveOK and isLastOne) then -- 还没到目标，检查是否要转弯或者移动完成检查最后一个是否要转向
            local diff = newX - self.tRailroad[12].x
            if diff >= 0 then -- 需转向
                newY = curY - diff
                newX = self.tRailroad[12].x
                stateCfg = self.tRailroad[12]

                if checkOK and (targetIdx > 12 and targetIdx <= 18) then -- 检查是否到目标
                    if newY <= tarY then -- 到目标
                        if tbl.minCircle > 0 then
                            tbl.minCircle = tbl.minCircle - 1
                        else
                            newY = tarY
                            isMoveOK = true
                        end
                    end
                end

                for mm = 13, 18 do
                    if newY < self.tRailroad[mm - 1].y and newY >= self.tRailroad[mm].y then
                        zone = mm
                        break
                    end
                end
            end
        end

        if zone == 0 then
            for mm = 5, 12 do
                if newX > self.tRailroad[mm - 1].x and newX <= self.tRailroad[mm].x then
                    zone = mm
                    break
                end
            end
        end

    elseif curX == self.tRailroad[12].x and curY <= self.tRailroad[12].y and curY > self.tRailroad[18].y then -- 下行
        newY = curY - move_dis

        if checkOK and (targetIdx > 12 and targetIdx <= 18) then -- 检查是否到目标
            if curY > tarY and newY <= tarY then -- 到目标
                if tbl.minCircle > 0 then
                    tbl.minCircle = tbl.minCircle - 1
                else
                    newY = tarY
                    isMoveOK = true
                end
            end
        end

        if (not isMoveOK) or (isMoveOK and isLastOne) then -- 还没到目标，检查是否要转弯或者移动完成检查最后一个是否要转向
            local diff = newY - self.tRailroad[18].y
            if diff <= 0 then -- 需转向
                newX = curX + diff
                newY = self.tRailroad[18].y
                stateCfg = self.tRailroad[18]

                if checkOK and (targetIdx > 18 and targetIdx <= 26) then -- 检查是否到目标
                    if newX <= tarX then -- 到目标
                        if tbl.minCircle > 0 then
                            tbl.minCircle = tbl.minCircle - 1
                        else
                            newX = tarX
                            isMoveOK = true
                        end
                    end
                end

                for mm = 19, 26 do
                    if newX < self.tRailroad[mm - 1].x and newX >= self.tRailroad[mm].x then
                        zone = mm
                        break
                    end
                end
            end
        end

        if zone == 0 then
            for mm = 13, 18 do
                if newY < self.tRailroad[mm - 1].y and newY >= self.tRailroad[mm].y then
                    zone = mm
                    break
                end
            end
        end

    elseif curY == self.tRailroad[18].y and curX <= self.tRailroad[18].x and curX > self.tRailroad[26].x then -- 左行
        newX = curX - move_dis

        if checkOK and (targetIdx > 18 and targetIdx <= 26) then -- 检查是否到目标
            if curX > tarX and newX <= tarX then -- 到目标
                if tbl.minCircle > 0 then
                    tbl.minCircle = tbl.minCircle - 1
                else
                    newX = tarX
                    isMoveOK = true
                end
            end
        end

        if (not isMoveOK) or (isMoveOK and isLastOne) then -- 还没到目标，检查是否要转弯或者移动完成检查最后一个是否要转向
            local diff = newX - self.tRailroad[26].x
            if diff <= 0 then -- 需转向
                newY = curY - diff
                newX = self.tRailroad[26].x
                stateCfg = self.tRailroad[26]

                if checkOK and (targetIdx <= 4 or targetIdx > 26) then -- 检查是否到目标
                    if newY >= tarY then -- 到目标
                        if tbl.minCircle > 0 then
                            tbl.minCircle = tbl.minCircle - 1
                        else
                            newY = tarY
                            isMoveOK = true
                        end
                    end
                end

                for mm = 2, #upzone do
                    if newY > self.tRailroad[upzone[mm - 1]].y and newY <= self.tRailroad[upzone[mm]].y then
                        zone = upzone[mm]
                        break
                    end
                end
            end
        end

        for mm = 19, 26 do
            if newX < self.tRailroad[mm - 1].x and newX >= self.tRailroad[mm].x then
                zone = mm
                break
            end
        end
    else
        local str = string.format("tarzan what fuck this curX:%d, curY:%d", curX, curY)
        assert(false, str)
        dump(self.tRailroad)
    end

    tbl.curX, tbl.curY = newX, newY
    tbl.curZone = zone

    return isMoveOK, stateCfg, zone
end

function ZSLCScene:highlightTarget(idx)
    if self.tRailroad[idx] == nil then
        local str = string.format("tarzan idx error:%d", idx)
        assert(false, str)
    end

    local res = "diamondtrain_png/img_xuanzhong.png"
    self:checkFrame(res)
    local light = ccui.ImageView:create(res, 1)
    light:setPosition(self.tRailroad[idx].x, self.tRailroad[idx].y)
    self.Node_fruits:addChild(light)
    if self.tHightlight[idx] == nil then
        self.tHightlight[idx] = {
            index = idx,
            tLights = {}
        }
    end
    table.insert(self.tHightlight[idx].tLights, light)

    if idx == 8 or idx == 22 then
        light:setScale9Enabled(true)
        light:setCapInsets(cc.rect(30, 30, 28, 8))
        light:setContentSize(cc.size(270, 68))
    end

    local sec = 0.5 / self.logic:getActionSpeed()
    local fade1 = cc.FadeTo:create(sec, 68)
    local fade2 = cc.FadeTo:create(sec, 255)
    local rep = cc.RepeatForever:create(cc.Sequence:create(fade1, fade2))
    light:runAction(rep)

    return light
end

function ZSLCScene:hideAllHighlight()
    for _, tbl in pairs(self.tHightlight) do
        for _, light in pairs(tbl.tLights) do
            light:removeFromParent()
        end
    end

    self.tHightlight = {}
end

function ZSLCScene:stopTimer()
    if self.schedulerID then
        self.scheduler:unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
end

function ZSLCScene:stopVoiceId()
    if self.voiceId then
        ccexp.AudioEngine:stop(self.voiceId)
        self.voiceId = nil
    end
end

function ZSLCScene:updateAutoBetBtn()
    local btn_str = ""
    if self.logic:isAutoBet() then
        btn_str = "diamondtrain_png/bnt_ks4.png" -- "点击取消"
        self.Image_guan:setVisible(true)
    else
        btn_str = "diamondtrain_png/bnt_ks3.png" -- 长按自动开始
        self.Image_guan:setVisible(false)
    end

    self.Image_btntips:loadTexture(btn_str, 1)
end

function ZSLCScene:doSetting()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")

    local ZSLCSetWin = require("game.zslc.src.ZSLCSetWin")
    local setWin = ZSLCSetWin.new(self)
    local x = (display.width - setWin:getContentSize().width) / 2
    local y = (display.height - setWin:getContentSize().height) / 2
    setWin:move(x, y):addTo(self)
end

function ZSLCScene:doExit()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    self:onQuestStandup()
    self:onExitGame()
end

function ZSLCScene:doStop3()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    self.stop_sign[3] = 3
end

function ZSLCScene:doStop2()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    self.stop_sign[2] = 3
end

function ZSLCScene:doStop1()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    self.stop_sign[1] = 3
end

function ZSLCScene:doClean()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")

    if self.bIsInAction then
        PlazaManager.showTips(SubLang:word(2))
        return false
    end

    if self.logic:isAutoBet() then
        PlazaManager.showTips(SubLang:word(3))
        return false
    end

    self:resetShow()
    self:setAllMask(false)
    self:updateMask()

    self.logic:setBetTimes(1)
end

function ZSLCScene:stopAutoAddBetSchedule()
    if self.scheduleAutoAddBet then
        self.scheduler:unscheduleScriptEntry(self.scheduleAutoAddBet)
        self.scheduleAutoAddBet = nil
    end
end

function ZSLCScene:doAddBet(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        self:stopAutoAddBetSchedule()
        self.nAutoAddBetElaspe = 0

        if self.bIsInAction then
            PlazaManager.showTips(SubLang:word(2))
            return false
        end

        if self.logic:isAutoBet() then
            PlazaManager.showTips(SubLang:word(3))
            return false
        end

        local function addSec(dt)
            self.nAutoAddBetElaspe = self.nAutoAddBetElaspe + dt
            if self.nAutoAddBetElaspe > 0.5 then
                local function addBetNow()
                    self.logic:addBetTimes(1)
                    ccexp.AudioEngine:play2d("game/zslc/res/sound/light_move1.mp3", false, MusicManager.effectVal)
                end
                self:stopAutoAddBetSchedule()
                self.scheduleAutoAddBet = self.scheduler:scheduleScriptFunc(addBetNow, 0.05, false)
            end
        end
        self:resetShow()
        self:setAllMask(false)
        self:updateMask()

        self.scheduleAutoAddBet = self.scheduler:scheduleScriptFunc(addSec, 0.1, false)
        MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    elseif eventType == ccui.TouchEventType.moved then

    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self:stopAutoAddBetSchedule()

        if self.bIsInAction then
            return false
        end

        if self.logic:isAutoBet() then
            return false
        end

        if self.nAutoAddBetElaspe < 0.5 then
            self.logic:addBetTimes(1)
        end
    end
end

function ZSLCScene:doHelp()
    MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
    self:showHelpTips()
end

function ZSLCScene:doAccelerate(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
        self.Fnt_accelerate:setPositionY(self.nAcceleratePosY - 10)
    elseif eventType == ccui.TouchEventType.moved then
        if sender:isHighlighted() then
            self.Fnt_accelerate:setPositionY(self.nAcceleratePosY - 10)
        else
            self.Fnt_accelerate:setPositionY(self.nAcceleratePosY)
        end

    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        if eventType == ccui.TouchEventType.ended then
            self.logic:changeSpeed()
            local num = self.logic:getSpeed()
            self.Fnt_accelerate:setString(SubLang:word(6) .. num)
        end

        self.Fnt_accelerate:setPositionY(self.nAcceleratePosY)
    end
end

function ZSLCScene:doStart(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
        self.Image_btntips:setPositionY(self.nBtnTipsPosY - 10)
        if not self.logic:isAutoBet() then
            local callFunc = cc.CallFunc:create(function()
                self.logic:setIsAutoBet(true)
                if not self.bIsInAction then
                    self:sendDoBet()
                end
            end)
            local seq = cc.Sequence:create(cc.DelayTime:create(0.5), callFunc)
            seq:setTag(0x10)
            sender:runAction(seq)
        end
        self.autoBet_ = self.logic:isAutoBet()
    elseif eventType == ccui.TouchEventType.moved then
        if sender:isHighlighted() then
            self.Image_btntips:setPositionY(self.nBtnTipsPosY - 10)
        else
            self.Image_btntips:setPositionY(self.nBtnTipsPosY)
        end
    elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
        self.Image_btntips:setPositionY(self.nBtnTipsPosY)
        if self.autoBet_ then
            self.logic:setIsAutoBet(false)
        else
            if sender:getActionByTag(0x10) then
                sender:stopActionByTag(0x10)
                if not self.bIsInAction then
                    self:sendDoBet()
                else
                    self:checkComplete()
                    -- PlazaManager.showTips("动作还未完成")
                end
                sender:setTouchEnabled(false)
                sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
                    sender:setTouchEnabled(true)
                end)))
            end
        end
    end
end

function ZSLCScene:sendDoBet()
    if self.bIsTest then
        self:doBetTest()
        return
    end

    local bet = self.logic:getBetTimes()
    if bet == 0 then
        PlazaManager.showTips(SubLang:word(4))
        return
    end
    bet = bet * self.logic:getCellScore()
    if bet > self.logic:getPlayerGold() then
        PlazaManager.showTips(SubLang:word(5))
        return
    end

    GameMessage.sendCardScroll(bet)
end

function ZSLCScene:doBetTest()
    local tbl = self.logic:createTest()
    self.logic:setBetResult(tbl)
    self:startAction()
end

function ZSLCScene:showTips()
    if self.bIsShowTips then
        return
    end

    self.bIsShowTips = true
    local move = cc.MoveTo:create(0.3, cc.p(display.cx, 750))
    local call = cc.CallFunc:create(handler(self, self.nextTips))
    local seq = cc.Sequence:create(move, call)
    self.Panel_tips:stopAllActions()
    self.Panel_tips:runAction(seq)
end

function ZSLCScene:hideTips()
    self.bIsShowTips = false
    local move = cc.MoveTo:create(0.2, cc.p(display.cx, 750 + 50))
    self.Text_tips:stopAllActions()
    self.Panel_tips:runAction(move)
end

function ZSLCScene:nextTips()
    local str = self.tips_list[1]
    if #self.tips_list > 1 then
        str = table.remove(self.tips_list, 2)
    end

    if str == nil then
        self.Text_tips:setString("")
        self:hideTips()
        return
    end

    self.Text_tips:setString(str)
    local ss = self.Text_tips:getContentSize()
    self.Text_tips:setAnchorPoint(display.LEFT_CENTER)
    self.Text_tips:setPosition(750, 20)

    local sec = (750 + ss.width) / 150
    local move1 = cc.MoveTo:create(sec, cc.p(-ss.width, 20))
    local call = cc.CallFunc:create(handler(self, self.nextTips))
    local seq = cc.Sequence:create(move1, delay, move2, move3, call)
    self.Text_tips:runAction(seq)
end

-- 进入场景完成
function ZSLCScene:onEnterTransitionFinish()
    ccexp.AudioEngine:preload("game/zslc/res/sound/background.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/cannon_explode.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/cannon_fly.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/clickBt.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/firework_explode.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/firework_fire.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/slotFruitStart.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/slotFruitStop1.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/slotFruitStop2.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/slotFruitStop3.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/train_move_loop.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/train_whistle.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/light_move1.mp3")
    ccexp.AudioEngine:preload("game/zslc/res/sound/light_move2.mp3")

    MusicManager.playBGM("game/zslc/res/sound/background.mp3")

    if self.bIsTest then
        return
    end

    ZSLCScene.super.onEnterTransitionFinish(self)
    self:addEvent()
    self:onQuestReady()
end

function ZSLCScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function ZSLCScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

-- 响应切换后台时
function ZSLCScene:onEnterBackground(isEnterBackground)
    ZSLCScene.super.onEnterBackground(self, isEnterBackground)
    self.isBackRun = isEnterBackground

    if isEnterBackground == true then
        print("tarzan Switch to the background.")
    else
        print("tarzan Switch to the foreground.")
    end
end

function ZSLCScene:onExit()
    ZSLCScene.super.onExit(self)
    self:removeEvent()
    self:stopTimer()
    self:stopAutoAddBetSchedule()

    MusicManager.stopBGM()
    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

-- =============继承父类的方法==============
-- 玩家坐下
function ZSLCScene:onUserSitDown(gameUser)

end

function ZSLCScene:onShowRoomInfo(info)

end

function ZSLCScene:onPersonalEnd(data)

end

-- 玩家准备
function ZSLCScene:onUserReady(gameUser)

end

-- 玩家站起
function ZSLCScene:onUserStandup(wChairID)

end

-- 玩家掉线
function ZSLCScene:onUserOffline(gameUser)

end

-- 玩家游戏
function ZSLCScene:onUserPlaying(gameUser)

end

-- 玩家积分改变
function ZSLCScene:onUserScore(gameUser)

end

-- 场景消息
function ZSLCScene:onGameScene(data)
    if self.gameDisConnection == true then
        -- 重置基类数据
        self:onResetData()
        -- 清除头像数据

        self:autoSitDown()
        -- PlazaManager.showTips("服务器连接成功")
    end

    if PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_FREE then
        -- 空闲状态
        -- self:onSceneFree(data)

        if self.gameDisConnection then
            self:onResetGameDisConnection()
        end
    elseif PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_PLAY then
        -- 游戏状态
        self:onResetGameDisConnection()

        self:onScenePlay(data)
    end
end

-- 游戏消息
function ZSLCScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL then
        -- 卡片滚动
        self:onSubCardScroll(data)
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubMessageInfo(data)
    elseif cmdID == GameCMD.SUB_S_SENDGOLD_INFO then
        self:onSubSendGoldInfo(data)
    elseif cmdID == GameCMD.SUB_S_UPDATEGOLDPOOL then
        self:onSubUpdateGoldPool(data)
    end
end

function ZSLCScene:onSceneFree(data)
    local params = GameMessage.onSceneFree(data)
end

function ZSLCScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data)
    self.logic:setCellScore(params.lCellScore)
    self.logic:setPlayerGold(params.lUserScore)
    self.logic:setMultCell(params.wMultiCell)
    self.logic:setJetCellScore(params.lJetCellScore)
    self.logic:setPoolCount(params.lGoldPool)
    self.logic:setGameRoomName(params.szGameRoomName)
    self.logic:setCardTimes(params.dwCardTimes)
end

function ZSLCScene:onSubCardScroll(data)
    local params = GameMessage.onSubCardScroll(data, self.logic)
    -- print("tarzan ==============onSubCardScroll=================")
    -- dump(params)

    if self.bIsInAction then
        table.insert(self.tBetCache, params)
    else
        self:doBetMsg(params)
    end

    --[[
    if math.random(0, 2) == 1 then
        table.insert(self.tips_list, "这是测试消息,消息的随机码为:" .. math.random(1, 999999))
        self:showTips()
    end
    --]]
end

function ZSLCScene:doNextBetMsg()
    local msg = table.remove(self.tBetCache, 1)
    if msg then
        print("tarzan =====doNextBetMsg=====")
        self:doBetMsg(msg)
        return true
    end
    return false
end

function ZSLCScene:doBetMsg(params)
    self.logic:setBetResult(params)
    self:startAction()
end

function ZSLCScene:onSubUpdateGoldPool(data)
    local params = GameMessage.onSubUpdateGoldPool(data)
    self.logic:setPoolCount(params.lGoldPool)
end

function ZSLCScene:onSubMessageInfo(data)
    local params = GameMessage.onSubMessageInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end

    table.insert(self.tips_list, showStr)
    self:showTips()
end

function ZSLCScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    table.insert(self.tips_list, szTrumpetContent)
    self:showTips()
end

function ZSLCScene:onSubSendGoldInfo(data)
    local params = GameMessage.onSubSendGoldInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end

    self.lastMesgInfo = showStr
    table.insert(self.tips_list, showStr)
    self:showTips()
    game.sendEvent("EventUpdateFruitLastGoldInfo")
end

function ZSLCScene:closeHelpTips()
    if self.helpNode then
        MusicManager.playEffect("game/zslc/res/sound/clickBt.mp3")
        self.helpNode:removeFromParent()
        self.helpNode = nil
    end
end

function ZSLCScene:showHelpTips()
    if self.helpNode then
        return
    end

    self.helpNode = cc.Node:create()
    self:addChild(self.helpNode)

    local mask = ccui.ImageView:create("diamondtrain_png/tips_bg.png", 1)
    mask:setScale9Enabled(true)
    mask:setCapInsets(cc.rect(30, 30, 10, 10))
    mask:setContentSize(cc.size(display.width + 100, display.height + 100))
    mask:setPosition(display.cx, display.cy)
    mask:setTouchEnabled(true)
    self.helpNode:addChild(mask)

    local bg = ccui.ImageView:create("diamondtrain_png/hjlc_panel.png", 1)
    bg:setScale9Enabled(true)
    bg:setCapInsets(cc.rect(70, 120, 10, 50))
    bg:setContentSize(cc.size(1180, 650))
    bg:setPosition(display.cx, display.cy)
    self.helpNode:addChild(bg)

    local title = ccui.ImageView:create("diamondtrain_png/hjlc_top.png", 1)
    title:setPosition(590, 635)
    bg:addChild(title)

    local normalImage = "diamondtrain_png/bnt_guanbi2.png"
    local selectedImage = "diamondtrain_png/bnt_guanbi1.png"
    local button = ccui.Button:create(normalImage, selectedImage, nil, 1)
    button:setPosition(1150, 635)
    button:addClickEventListener(handler(self, self.closeHelpTips))
    bg:addChild(button)

    local listView = ccui.ListView:create()
    listView:setContentSize(cc.size(1068, 558))
    listView:setAnchorPoint(0, 0)
    listView:setPosition(56, 44)
    bg:addChild(listView)

    local image1 = ccui.ImageView:create("game/zslc/res/big_png/hjlc_bl1.png", 0)
    listView:pushBackCustomItem(image1)

    local image2 = ccui.ImageView:create("game/zslc/res/big_png/hjlc_bl2.png", 0)
    listView:pushBackCustomItem(image2)
end

return ZSLCScene
