--[[
CSDScene.lua
天降财神
]] local GameCMD = require("game.csd.src.CSDCMD")
local GameMessage = require("game.csd.src.CSDMessage")
local CSDLogic = require("game.csd.src.CSDLogic")
local CSDSound = require("game.csd.src.CSDSound")

local CSDCenter = require("game.csd.src.panel.CSDCenter")
local CSDBet = require("game.csd.src.panel.CSDBet")
local CSDSettle = require("game.csd.src.panel.CSDSettle")
local CSDSetting = require("game.csd.src.panel.CSDSetting")
local CSDHelp = require("game.csd.src.panel.CSDHelp")
local CSDGoldHistory = require("game.csd.src.panel.CSDGoldHistory")

local CSDScene = class("CSDScene", require("app.views.base.BaseGameScene"))

local CaiShenState = {
    FORBID = 0, -- 封印
    APPARENT = 1, -- 天降财神
    SCATTER = 2, -- 散财
    FREE = 3, -- 空闲
    BREAK = 4 -- 破壳
}

local GameState = {
    SEND = 0,
    REPLY = 1,
    FINISH = 2
}

local function initTopAnim(self)
    GameCMD.addAnim("ani/fx_dingbu.csb", self.pnlTop_:getChildByName("top_anim"))
end

local function initCaiShenAnim(self)
    self.caiShenAnim_ = GameCMD.addAnim("ani/fx_01_caishen.csb", self.nodeCaiShen_:getChildByName("caishen_anim"))
    self:showCaiShen(CaiShenState.FORBID)
    local imgLuZi = self.nodeCaiShen_:getChildByName("img_xianglu")
    GameCMD.addAnim("ani/fx_luzi_liuguang.csb", imgLuZi:getChildByName("xianglu_anim"))
    self.jossAnim_ = GameCMD.addAnim("ani/fx_02_saoxiang.csb", imgLuZi:getChildByName("shaoxiang_anim"))
    self:showXiangLu(true)
    self:lightJoss(false)
end

local function initUI(self)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Scene.csb")
    self.root_:addTo(self)

    self.imgBg_ = self.root_:getChildByName("img_bg")
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)
    self.pnlTop_ = self.imgBg_:getChildByName("pnl_top")
    self.pnlBottom_ = self.imgBg_:getChildByName("pnl_bottom")
    self.nodeCaiShen_ = self.imgBg_:getChildByName("node_caishen")

    self.bmf_speed = self.pnlBottom_:getChildByName("btn_speed"):getChildByName("bmf_num")
    if LangCtrl:isEng() then
        local posx = self.bmf_speed:getPositionX()
        self.bmf_speed:setPositionX(posx + 5)
    end

    self:updateJackpot("")
    self:updateOwnerScore("")
    initTopAnim(self)
    initCaiShenAnim(self)
end

function CSDScene:onCreate()
    cc.exports.SubLang = require("game.csd.src.CSDLang").new()
    CSDScene.super.onCreate(self)

    initUI(self)
    self.center_ = CSDCenter.new(self.imgBg_:getChildByName("node_center"))
    self.center_:addFinishCallback(handler(self, self.settle))
    self.bet_ = CSDBet.new(self.imgBg_:getChildByName("pnl_bottom"))
    self.settle_ = CSDSettle.new(self.imgBg_:getChildByName("node_settle"))
    self.goldHistory_ = CSDGoldHistory.new(self.imgBg_:getChildByName("pnl_rank"))
    self:addCallback()

    self.logic_ = CSDLogic.new()
    self:setWheelSpeed(1)
    self.gameState_ = GameState.FINISH

    -- GameUtil.printNodeTree(1, " - ", self.root_)
end

-- 进入场景完成
function CSDScene:onEnterTransitionFinish()
    CSDScene.super.onEnterTransitionFinish(self)
    self:addEvent()

    self:playBroadcast()
    self:onQuestReady()
end

function CSDScene:addEvent()
    -- 私人场结束
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function CSDScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

function CSDScene:onExit()
    CSDScene.super.onExit(self)
    self:removeEvent()

    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

-- 无消息返回无网络异常提示情况下，主动重试操作
-- 2019.4.8 去掉主动尝试，等待底层消息
-- 2019.4.24 超时刷新重连
local function overtimeReconnect(self, open)
    self.root_:stopActionByTag(0xaa)
    if not open then
        return
    end
    local seq = cc.Sequence:create(cc.DelayTime:create(8.0), cc.CallFunc:create(function()
        self:refreshGame()
    end))
    seq:setTag(0xaa)
    self.root_:runAction(seq)
end

function CSDScene:addCallback()
    local btnReturn = self.pnlTop_:getChildByName("btn_close")
    btnReturn:addClickEventListener(function()
        self:onQuestStandup()
        self:onExitGame()
    end)
    local btnSet = self.pnlTop_:getChildByName("btn_set")
    btnSet:addClickEventListener(function()
        CSDSetting:show(self)
    end)
    local btnRule = self.pnlBottom_:getChildByName("btn_help")
    btnRule:addClickEventListener(function()
        CSDHelp:show(self)
    end)
    local btnSpeed = self.pnlBottom_:getChildByName("btn_speed")
    btnSpeed:addClickEventListener(function()
        local nxtRatio = self.wheelRatio_ >= 4 and 1 or (self.wheelRatio_ + 1)
        self:setWheelSpeed(nxtRatio)
    end)
    self.bet_:addBetCallback(function(betState)
        self.center_:reset()
        self.settle_:reset()
        if betState == CSDBet.State.NORMAL or betState == CSDBet.State.AUTO then
            self:playScrollBGM(CSDSound.BGM.NORMAL)
            -- self.center_:startWheel()
            self:updateOwnerScore(self.logic_:getOwnerScore() - self.bet_:getBetCount())
        else
            self:playScrollBGM(CSDSound.BGM.FREE)
        end
        self.gameState_ = GameState.SEND
        overtimeReconnect(self, true)
    end)
end

function CSDScene:settle()
    local winInfo = self.logic_:getWinInfo()
    local function nextRound()
        if winInfo.bonusCnt > 0 then -- free scroll
            self.bet_:changeStatus(CSDBet.State.FREE, self.logic_:getBonusCount())
            self:playFreeStart(winInfo.bonusCnt, function()
                self.gameState_ = GameState.FINISH
                self.bet_:autoBet()
            end)
        elseif winInfo.bScatter then -- scatter scroll
            self:setJossNum(self.logic_:getJossCount())
            self.bet_:changeStatus(CSDBet.State.GXFC, self.logic_:getScatterCount())
            self:playScatterStart(function()
                self:showCaiShen(CaiShenState.APPARENT, function()
                    self.gameState_ = GameState.FINISH
                    self.bet_:autoBet()
                end)
            end)
        else
            self.gameState_ = GameState.FINISH
            self.bet_:autoBet()
        end
    end
    local function freeScatterTotal()
        if winInfo.freeTotal > 0 then
            self:playFreeEnd(winInfo.freeTotal, function()
                if winInfo.scatterTotal > 0 then
                    self:playScatterEnd(winInfo.scatterTotal, nextRound)
                    self:showCaiShen(CaiShenState.FORBID)
                else
                    nextRound()
                end
            end)
        elseif winInfo.scatterTotal > 0 then
            self:playScatterEnd(winInfo.scatterTotal, nextRound)
            self:showCaiShen(CaiShenState.FORBID)
        else
            nextRound()
        end
    end
    self.center_:showWinLines(winInfo.winLines)
    if self.logic_:getWinScore() > 0 then
        CSDSound.winScore()
        local params = {
            base = self.bet_:getLineBet(),
            win = self.logic_:getWinScore()
        }
        self.settle_:accumulative(params, function()
            self:updateOwnerScore(self.logic_:getOwnerScore())
            self:collectJoss(function()
                freeScatterTotal()
            end)
        end)
    else
        self:collectJoss(function()
            freeScatterTotal()
        end)
    end
end

function CSDScene:setJossNum(num)
    self.nodeCaiShen_:getChildByName("xiang_num"):setString(string.format("%d/%d", num or 0, GameCMD.MAX_JOSS))
end

function CSDScene:collectJoss(callback)
    local pos = self.center_:collectJoss()
    if not pos then
        if callback then
            callback()
        end
        return
    end
    CSDSound.playXiang()

    pos = self.nodeCaiShen_:convertToNodeSpace(pos)
    local anim = GameCMD.addAnim("ani/fx_qiufeiru.csb", self.nodeCaiShen_)
    anim:move(pos):hide()
    -- key
    anim:getChildByName("Panel_1"):getChildByName("Particle_1"):setPositionType(0)
    local endPos = cc.p(self.nodeCaiShen_:getChildByName("img_xianglu"):getPosition())
    local endFly = cc.CallFunc:create(function()
        local seq = cc.Sequence:create(cc.DelayTime:create(0.3), cc.RemoveSelf:create())
        GameCMD.addAnim("ani/fx_qiufeiru_hit.csb", self.nodeCaiShen_):move(endPos):runAction(seq)
        self:lightJoss(true)
        self:setJossNum(self.logic_:getJossCount())
        self:showCaiShen(CaiShenState.BREAK, function()
            self:lightJoss(false)
            if callback then
                callback()
            end
        end)
    end)
    local startFly = cc.CallFunc:create(function()
        CSDSound.flyXiang()
    end)
    local controlPnt1 = cc.p(self.nodeCaiShen_:getChildByName("xiang_start"):getPosition())
    local controlPnt2 = cc.p(self.nodeCaiShen_:getChildByName("xiang_ps2"):getPosition())
    local dist = cc.pGetDistance(pos, endPos)
    local dt = math.pow(dist / 1000, 0.25)
    local bezier = cc.BezierTo:create(dt, {controlPnt1, controlPnt2, endPos})
    anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), startFly, cc.Show:create(), bezier, endFly, cc.RemoveSelf:create()))
end

function CSDScene:showCaiShen(state, callback)
    local nodeCaiShen = self.nodeCaiShen_:getChildByName("caishen_anim")
    local caiShenAction = self.caiShenAnim_:getActionByTag(0)
    if not caiShenAction then
        return
    end
    local caiShenFunc = {
        [CaiShenState.FORBID] = function()
            self:showXiangLu(true)
            caiShenAction:gotoFrameAndPlay(930, 1100, true)
        end,
        [CaiShenState.APPARENT] = function()
            self:showXiangLu(false)
            CSDSound.showScatter()
            caiShenAction:gotoFrameAndPlay(120, 425, false)
            nodeCaiShen:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(callback)))
        end,
        [CaiShenState.SCATTER] = function()
            -- 550 call
            caiShenAction:gotoFrameAndPlay(500, 640, false)
            nodeCaiShen:runAction(cc.Sequence:create(cc.DelayTime:create(0.9), cc.CallFunc:create(callback)))
        end,
        [CaiShenState.FREE] = function()
            caiShenAction:gotoFrameAndPlay(740, 880, true)
        end,
        [CaiShenState.BREAK] = function()
            CSDSound.split()
            caiShenAction:gotoFrameAndPlay(1100, 1240, false)
            nodeCaiShen:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(callback)))
        end
    }
    nodeCaiShen:stopAllActions()
    if caiShenFunc[state] then
        caiShenFunc[state]()
    end
end

function CSDScene:freeWheel(wildIndexs, callback)
    if not next(wildIndexs) and callback then
        callback()
        return
    end
    local lightAnim = {}
    local template = self.nodeCaiShen_:getChildByName("yuanbao")
    for i, wIndex in ipairs(wildIndexs) do
        local worldPos = self.center_:getPatternPosition(wIndex)
        local localPos = self.nodeCaiShen_:convertToNodeSpace(worldPos)
        local col = (wIndex - 1) % GameCMD.PATTERN_COL + 1
        local nodeThrow = self.nodeCaiShen_:getChildByName("reng_" .. col - 1)
        if not lightAnim[col] then
            local anim = GameCMD.addAnim("ani/fx_03_bejing.csb", nodeThrow, 0, 90, false)
            anim:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.RemoveSelf:create()))
            lightAnim[col] = anim
        end
        local gold = template:clone()
        local throwX = nodeThrow:getPosition()
        gold:move(throwX, 780):addTo(self.nodeCaiShen_)
        local spawn = cc.Spawn:create(cc.MoveTo:create(0.4, localPos), cc.RotateBy:create(0.4, 45))
        gold:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), spawn, cc.CallFunc:create(function()
            if i == #wildIndexs then
                CSDSound.drop()
            end
            local seq = cc.Sequence:create(cc.DelayTime:create(0.5), i == #wildIndexs and callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create())
            local anim = GameCMD.addAnim("ani/fx_zazhong.csb", self.nodeCaiShen_, 0, 50, false)
            anim:move(localPos):runAction(seq)
        end), cc.RemoveSelf:create()))
    end
end

function CSDScene:scatterWheel(columns, callback)
    self:showCaiShen(CaiShenState.SCATTER, function()
        for i, column in ipairs(columns) do
            local startPos = cc.p(self.nodeCaiShen_:getChildByName("reng_start"):getPosition())
            local endPos = cc.p(self.nodeCaiShen_:getChildByName("reng_" .. column - 1):getPosition())
            local moveTo = cc.MoveTo:create(1.0, endPos)
            local seq = cc.Sequence:create(moveTo, cc.CallFunc:create(function()
                self:showCaiShen(CaiShenState.FREE)

                CSDSound.pour()
                local pourSeq = cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function()
                    if i == #columns and callback then
                        callback()
                    end
                end), cc.RemoveSelf:create())
                local pos = cc.p(endPos.x, endPos.y - 110)
                GameCMD.addAnim("ani/fx_02_daoyuanbao.csb", self.nodeCaiShen_):move(pos):runAction(pourSeq)
            end), cc.RemoveSelf:create())
            GameCMD.addAnim("ani/fx_lizi_tuowei.csb", self.nodeCaiShen_):move(startPos):runAction(seq)
        end
        CSDSound.throw()
    end)
end

function CSDScene:lightJoss(light)
    self.jossAnim_:getChildByName("Panel_1"):setVisible(light)
end

function CSDScene:showXiangLu(visible)
    self.nodeCaiShen_:getChildByName("img_xianglu"):setVisible(visible)
end

function CSDScene:updateJackpot(goldPool)
    self.pnlTop_:getChildByName("bmf_jackpot"):setString(goldPool)
end

function CSDScene:updateOwnerScore(score)
    self.pnlTop_:getChildByName("bmf_gold"):setString(score)
end

function CSDScene:playFreeStart(bonus, callback)
    local bgSize = self.imgBg_:getContentSize()
    local freeStartAnim = GameCMD.addAnim("ani/fx_mianfei.csb", self.imgBg_, 0, false):move(bgSize.width / 2, bgSize.height / 2)
    freeStartAnim:getChildByName("Panel_1_0_0"):getChildByName("free_count"):setString(bonus)
    freeStartAnim:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    CSDSound.freeStart()
end

function CSDScene:playScatterStart(callback)
    local bgSize = self.imgBg_:getContentSize()
    local scatterStartAnim = GameCMD.addAnim("ani/fx_sancai.csb", self.imgBg_, 0, false):move(bgSize.width / 2, bgSize.height / 2)
    scatterStartAnim:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    CSDSound.freeStart()
end

function CSDScene:playFreeEnd(freeTotal, callback)
    local bgSize = self.imgBg_:getContentSize()
    local freeEndAnim = GameCMD.addAnim("ani/free_total.csb", self.imgBg_, 0, 130, false):move(bgSize.width / 2, bgSize.height / 2)
    freeEndAnim:runAction(cc.Sequence:create(cc.DelayTime:create(3.5), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    local pnl = freeEndAnim:getChildByName("Panel_1")
    pnl:getChildByName("free_tottal"):setString(5)
    pnl:getChildByName("Panel_2"):getChildByName("ShuZi_0"):setString(freeTotal)
    pnl:getChildByName("btn_lingqu2"):addClickEventListener(function()
        if callback then
            callback()
        end
        freeEndAnim:removeSelf()
    end)
    CSDSound.freeTotal()
end

function CSDScene:playScatterEnd(scatterTotal, callback)
    local bgSize = self.imgBg_:getContentSize()
    local scatterEndAnim = GameCMD.addAnim("ani/caishen_total.csb", self.imgBg_, 0, 130, false):move(bgSize.width / 2, bgSize.height / 2)
    scatterEndAnim:runAction(cc.Sequence:create(cc.DelayTime:create(3.5), callback and cc.CallFunc:create(callback) or nil, cc.RemoveSelf:create()))
    local pnl = scatterEndAnim:getChildByName("Panel_1")
    pnl:getChildByName("caishen_tottal"):setString(4)
    pnl:getChildByName("Panel_2"):getChildByName("ShuZi_0"):setString(scatterTotal)
    pnl:getChildByName("btn_ok"):addClickEventListener(function()
        if callback then
            callback()
        end
        scatterEndAnim:removeSelf()
    end)
    CSDSound.freeTotal()
end

function CSDScene:setWheelSpeed(ratio)
    self.wheelRatio_ = ratio
    self.bmf_speed:setString(ratio)
    self.center_:setWheelSpeed(ratio)
end

function CSDScene:playScrollBGM(bgm)
    if self.scrollMusic_ and CSDSound.isPlaying(self.scrollMusic_) and self.scrollBGM_ == bgm then
        return
    end
    CSDSound.stopBGM()
    self.scrollBGM_ = bgm
    self.scrollMusic_ = CSDSound.scroll(bgm, function()
        -- 摇奖中继续播放
        if self.gameState_ == GameState.REPLY then
            self:playScrollBGM(bgm)
        end
    end)
end

function CSDScene:playBroadcast()
    local pnlBroadcast = self.imgBg_:getChildByName("pnl_broadcast")
    local broadcast = self.logic_:extractBroadcast()
    if not broadcast then
        self.broadcasting_ = false
        pnlBroadcast:hide()
        return
    end
    self.broadcasting_ = true
    pnlBroadcast:show()
    local pnlScroll = pnlBroadcast:getChildByName("pnl_scroll")
    local txt = pnlScroll:getChildByName("txt_broadcast")
    txt:stopAllActions()
    local scrollSize = pnlScroll:getContentSize()
    txt:setPositionX(scrollSize.width)
    txt:setString(broadcast)
    local txtSize = txt:getContentSize()
    txt:moveBy{
        time = 8.0,
        x = -txtSize.width - scrollSize.width,
        y = 0,
        onComplete = handler(self, self.playBroadcast)
    }
end
-- =============继承父类的方法==============
-- 玩家坐下
function CSDScene:onUserSitDown(gameUser)

end

function CSDScene:onShowRoomInfo(info)

end

function CSDScene:onPersonalEnd(data)

end

-- 玩家准备
function CSDScene:onUserReady(gameUser)

end

-- 玩家站起
function CSDScene:onUserStandup(wChairID)

end

-- 玩家掉线
function CSDScene:onUserOffline(gameUser)

end

-- 玩家游戏
function CSDScene:onUserPlaying(gameUser)

end

-- 玩家积分改变
function CSDScene:onUserScore(gameUser)

end

-- 场景消息
function CSDScene:onGameScene(data)
    if self.gameDisConnection == true then
        -- 重置基类数据
        self:onResetData()
        -- 清除头像数据
        self:autoSitDown()
    end
    overtimeReconnect(self, false)
    if PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_FREE then
        -- 空闲状态
        -- self:onSceneFree(data)
    elseif PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_MJ_PLAY then

        self:onScenePlay(data)
    end
end

-- 游戏消息
function CSDScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL then
        overtimeReconnect(self, false)
        -- 卡片滚动
        self:onSubCardScroll(data)
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO then
        -- 中奖消息
        self:onSubMessageInfo(data)
    elseif cmdID == GameCMD.SUB_S_SENDGOLD_INFO then
        self:onSubSendGoldInfo(data)
    elseif cmdID == GameCMD.SUB_S_UPDATEGOLDPOOL then
        self:onSubUpdateGoldPool(data)
    elseif cmdID == GameCMD.SUB_S_GOLD_HISTORY then
        self:onSubGoldHistory(data)
    end
end

function CSDScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data)
    self.logic_:loadSceneData(params)

    self.bet_:loadBetConfig(params)
    self:updateJackpot(params.lGoldPool)
    self:updateOwnerScore(params.lUserScore)
    self:setJossNum(self.logic_:getJossCount())

    -- 发送未返回/重登录
    if self.gameState_ ~= GameState.REPLY then
        self.gameState_ = GameState.FINISH
        if self.logic_:getBonusCount() > 0 then
            -- 免费摇奖
            self.bet_:changeStatus(CSDBet.State.FREE, self.logic_:getBonusCount())
            self:playFreeStart(self.logic_:getBonusCount(), function()
                self.bet_:autoBet()
            end)
        elseif self.logic_:getScatterCount() > 0 then
            -- 散财
            self.bet_:changeStatus(CSDBet.State.GXFC, self.logic_:getScatterCount())
            self:playScatterStart(function()
                self.bet_:autoBet()
            end)
        else
            self.bet_:autoBet()
        end
    end
end

function CSDScene:onSubCardScroll(data)
    local params = GameMessage.onSubCardScroll(data)
    self.logic_:loadCardScollData(params)

    self.gameState_ = GameState.REPLY
    self:updateJackpot(params.lGoldPool)
    if params.bBonus == 1 then
        -- 免费摇奖
        local wilds = {}
        for i, patt in ipairs(params.cbCardType) do
            if patt == GameCMD.PATTERN.WILD then
                table.insert(wilds, i)
            end
        end
        self:freeWheel(wilds, function()
            self.center_:freeWheel(params.cbCardType)
        end)
    elseif params.bSanCai == 1 then
        -- 散财摇奖
        local wildColumns = {}
        local patterns = params.cbCardType
        for i = 1, 5 do
            if patterns[i] == GameCMD.PATTERN.WILD and patterns[i] == patterns[i + 5] and patterns[i] == patterns[i + 10] then
                table.insert(wildColumns, i)
            end
        end
        self:scatterWheel(wildColumns, function()
            self.center_:scatterWheel(params.cbCardType, wildColumns)
        end)
    else
        self.center_:finishWheel(params.cbCardType)
    end
    self.bet_:updateWinJackpot(params.lGoldPool)
    self.bet_:receiptBet()

    local winInfo = self.logic_:getWinInfo()
    if winInfo.ratio and winInfo.ratio * self.bet_:getLineBet() ~= params.lWinScore then
        dump("win score calculate not equal, lWinScore:" .. params.lWinScore .. " ratio:" .. winInfo.ratio .. "*lineBet:" .. self.bet_:getLineBet() .. "=" .. winInfo.ratio * self.bet_:getLineBet())
    end
end

function CSDScene:onSubUpdateGoldPool(data)
    local params = GameMessage.onSubUpdateGoldPool(data)
    self.logic_:setGoldPool(params.lGoldPool)

    self:updateJackpot(params.lGoldPool)
    self.bet_:updateWinJackpot(params.lGoldPool)
end

function CSDScene:onSubGoldHistory(data)
    local params = GameMessage.onSubGoldHistory(data)
    -- dump(params, "游戏--中奖玩家历史记录")

    self.goldHistory_:loadRecords(params)
end

function CSDScene:onSubMessageInfo(data)
    local params = GameMessage.onSubMessageInfo(data)
    local showStr = GameUtil.filterMultMsg(params.szContent, 1)
    if showStr == nil or showStr == "" then
        return
    end
    self.logic_:loadBroadcast(showStr)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
end

function CSDScene:onSubSendGoldInfo(data)
    local params = GameMessage.onSubSendGoldInfo(data)
    -- game.sendEvent("EventUpdateFruitLastGoldInfo")
end

function CSDScene:onAcceptTrumpetContentRoll(szTrumpetContent)
    self.logic_:loadBroadcast(szTrumpetContent)
    if not self.broadcasting_ then
        self:playBroadcast()
    end
end

return CSDScene
