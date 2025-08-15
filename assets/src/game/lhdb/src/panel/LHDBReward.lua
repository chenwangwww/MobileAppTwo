--[[
LHDBReward.lua
]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBSound = require("game.lhdb.src.LHDBSound")

local BigWinUI = class("BigWinUI")

function BigWinUI:ctor(parent)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Reward/bigwin.csb")
    self.root_:addTo(parent)

    self.root_:move(display.center)
    local pnlBg = self.root_:getChildByName("tiaoguo")
    local bgSize = pnlBg:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.root_:setScale(scale)

    self.txtScore_ = self.root_:getChildByName("shuzi_0"):getChildByName("ShuZi")
    self.txtScore_:setString(0)

    self.root_:hide()
end

local function finishReward(self, callback)
    LHDBSound.stopBGM()
    LHDBSound.settleReward()
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        LHDBSound.playBGM()
        self.root_:hide()
        if callback then
            callback()
        end
    end)))
end

function BigWinUI:playReward(args, callback)
    LHDBSound.stopBGM()
    LHDBSound.playBigWin()
    self.root_:show()
    local baseScore = args.base
    local winScore = args.win
    local rate = math.ceil(winScore / baseScore)

    local endIndex = 1200
    if rate < 50 then
        endIndex = 300
    elseif rate < 200 then
        endIndex = 600
    elseif rate < 500 then
        endIndex = 900
    end

    local dt = endIndex / 60
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Reward/bigwin.csb")
    action:gotoFrameAndPlay(0, endIndex, false)
    action:setTimeSpeed(3)
    dt = dt / 3
    self.root_:runAction(action)

    local currentScore = 0
    local interval = 0.1
    local tick = dt / interval
    local stepAdd = winScore / tick
    local callFunc = cc.CallFunc:create(function()
        currentScore = currentScore + stepAdd
        currentScore = currentScore > winScore and winScore or currentScore
        self.txtScore_:setString(math.floor(currentScore))
        if currentScore >= winScore then
            self.root_:stopAllActions()
            finishReward(self, callback)
            return
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(interval), callFunc)
    local rep = cc.RepeatForever:create(seq)
    self.root_:runAction(rep)
end
--------------------------------------------------------------------------------------------------------------------
local JackpotUI = class("JackpotUI")

function JackpotUI:ctor(parent)
    -- body
end
--------------------------------------------------------------------------------------------------------------------
local LHDBReward = class("LHDBReward")

function LHDBReward:register(parent)
    self.ui_ = BigWinUI.new(parent)
end

LHDBReward.Type = {
    BIG_WIN = 0,
    JACKPOT = 1
}

function LHDBReward:show(args, callback)
    self.ui_:playReward(args, callback)
end

return LHDBReward
