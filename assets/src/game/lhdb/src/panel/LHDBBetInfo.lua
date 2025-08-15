--[[
LHDBBetInfo.lua
]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBSound = require("game.lhdb.src.LHDBSound")

local PREFIX = "Game/LHDB/Scene/"

local LHDBBetInfo = class("LHDBBetInfo")

function LHDBBetInfo:ctor(root)
    self.root_ = root

    -- caijin anim
    self.imgCaiJin_ = self.root_:getChildByName("img_caiJin")
    local nodeCaiJin = self.imgCaiJin_:getChildByName("node_caiJin")
    local anims = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_caijinhuo.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_caijinhuo.csb")
    action:gotoFrameAndPlay(0)
    anims:runAction(action)
    anims:addTo(nodeCaiJin)

    -- dragon anim
    self.pnlDragon_ = self.root_:getChildByName("pnl_dragon")
    local nodeDragon = self.pnlDragon_:getChildByName("node_dragon")
    local anims = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_longzhu.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_longzhu.csb")
    action:gotoFrameAndPlay(0)
    anims:runAction(action)
    anims:addTo(nodeDragon)

    self:setOwnerGold(0)
    self:setTotalBet(0)
    self:setBallCount(0)
    self:setGoldPool(0)
end

function LHDBBetInfo:setOwnerGold(gold)
    local pnlOwner = self.root_:getChildByName("pnl_owner")
    pnlOwner:getChildByName("txt_gold"):setString(gold)
end

function LHDBBetInfo:setTotalBet(betCnt)
    local pnlBet = self.root_:getChildByName("pnl_total")
    pnlBet:getChildByName("txt_gold"):setString(betCnt)
end

function LHDBBetInfo:setBallCount(ballCnt)
    self.pnlDragon_:getChildByName("txt_ball"):setString(ballCnt)
end

function LHDBBetInfo:setGoldPool(pool)
    self.imgCaiJin_:getChildByName("bmf_pool"):setString(pool)
end

function LHDBBetInfo:addBall(ballNum, ballPos)
    local localPos = self.pnlDragon_:convertToNodeSpace(ballPos)
    local endPos = cc.p(self.pnlDragon_:getChildByName("BallEndPos"):getPosition())
    local controlPnt1 = cc.p(localPos.x - 85, localPos.y + 150)
    local controlPnt2 = cc.p((endPos.x + controlPnt1.x) / 2, (endPos.y + controlPnt1.y) / 2 + 20)

    local ball = cc.Sprite:createWithSpriteFrameName(PREFIX .. "Img_LongZhu01.png")
    ball:move(localPos):addTo(self.pnlDragon_)
    local blink = cc.Blink:create(0.9, 3)
    local dist = cc.pGetDistance(localPos, endPos)
    local dt = math.pow(dist / 1500, 0.25)
    local streakCall = function()
        local streak = cc.MotionStreak:create(0.25, 3, 32, cc.WHITE, GameCMD.RES_PATH .. "Scene/streak.png")
        streak:addTo(self.pnlDragon_, -1)
        local seq = cc.Sequence:create(cc.BezierTo:create(dt, {controlPnt1, controlPnt2, endPos}), cc.RemoveSelf:create())
        streak:move(localPos):runAction(seq)

        LHDBSound.flyBall()
    end
    local bezierTo = cc.BezierTo:create(dt, {controlPnt1, controlPnt2, endPos})
    local endCallFunc = cc.CallFunc:create(function()
        self:setBallCount(ballNum)
    end)
    local seq = cc.Sequence:create(blink, cc.CallFunc:create(streakCall), bezierTo, endCallFunc, cc.RemoveSelf:create())
    ball:runAction(seq)
end

function LHDBBetInfo:addGoldPoolCallback(callback)
    self.imgCaiJin_:getChildByName("btn_pool"):addClickEventListener(callback)
end

return LHDBBetInfo
