--[[
LHDBTBInfo.lua
]] local GameCMD = require("game.lhdb.src.LHDBCMD")

local LHDBTBInfo = class("LHDBTBInfo")

function LHDBTBInfo:ctor(root)
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
    self:setPrice(0)
    self:setReward(0)
    self:setBallCount(0)
    self:setGoldPool(0)
end

function LHDBTBInfo:setOwnerGold(gold)
    local pnlOwner = self.root_:getChildByName("pnl_owner")
    pnlOwner:getChildByName("txt_gold"):setString(gold)
end

function LHDBTBInfo:setPrice(betCnt)
    local pnlBet = self.root_:getChildByName("pnl_price")
    pnlBet:getChildByName("txt_gold"):setString(betCnt)
end

function LHDBTBInfo:setReward(reward)
    local pnlReward = self.root_:getChildByName("pnl_reward")
    pnlReward:getChildByName("txt_gold"):setString(reward)
end

function LHDBTBInfo:setBallCount(ballCnt)
    self.pnlDragon_:getChildByName("txt_ball"):setString(ballCnt)
end

function LHDBTBInfo:setGoldPool(pool)
    self.imgCaiJin_:getChildByName("bmf_pool"):setString(pool)
end

return LHDBTBInfo
