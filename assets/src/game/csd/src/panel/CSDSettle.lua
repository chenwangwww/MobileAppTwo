--[[
CSDSettle.lua
]] local GameCMD = require("game.csd.src.CSDCMD")
local CSDSound = require("game.csd.src.CSDSound")

local BigWinUI = class("BigWinUI")

function BigWinUI:ctor(parent)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "ani/bigwin.csb")
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
    CSDSound.stopBGM()
    CSDSound.winEnd()
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        self.root_:hide()
        if callback then
            callback()
        end
    end)))
end

function BigWinUI:playReward(args, callback)
    CSDSound.stopBGM()
    CSDSound.playBigWin()
    self.root_:show()
    local baseScore = args.base
    local winScore = args.win
    local rate = math.ceil(winScore / baseScore)

    local endIndex = 1200
    if rate < 100 then
        endIndex = 300
    elseif rate < 200 then
        endIndex = 600
    elseif rate < 500 then
        endIndex = 900
    end

    local delta = endIndex / 60
    local dt = delta ^ (1 / 2.5)
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "ani/bigwin.csb")
    action:gotoFrameAndPlay(0, endIndex, false)
    action:setTimeSpeed(delta / dt)
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
local CSDSettle = class("CSDSettle")

CSDSettle.Type = {
    BIG_WIN = 0,
    JACKPOT = 1
}

function CSDSettle:ctor(root)
    self.root_ = root
    self.bmfScore_ = self.root_:getChildByName("bmf_score")
    self.bmfScore_:hide()
    self.bmfWinScore_ = self.root_:getChildByName("img_wins"):getChildByName("bmf_score")
    self.bmfWinScore_:setString("")

    local parent = self.root_:getParent()
    self.ui_ = BigWinUI.new(parent)
end

local function playReward(self, args, callback)
    self.bmfScore_:show()
    self.bmfScore_:setString("")
    self.bmfWinScore_:setString("")
    local currentScore = 0
    local interval = 0.1
    local tick = 10
    local winScore = args.win
    local stepAdd = winScore / tick
    local callFunc = cc.CallFunc:create(function()
        currentScore = currentScore + stepAdd
        currentScore = currentScore > winScore and winScore or currentScore
        local strScore = math.floor(currentScore)
        self.bmfScore_:setString(strScore)
        self.bmfWinScore_:setString(strScore)
        if currentScore >= winScore then
            self.bmfScore_:stopAllActions()
            self.bmfScore_:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.Hide:create(), cc.CallFunc:create(callback)))
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(interval), callFunc)
    local rep = cc.RepeatForever:create(seq)
    self.bmfScore_:runAction(rep)

    local random = math.random(3, 5)
    for i = 1, random do
        local anim = cc.CSLoader:createNode(GameCMD.RES_PATH .. "ani/fx_jinbi.csb")
        local pos2 = cc.p(self.root_:getChildByName("gold_win_1"):getPosition())
        local pos = cc.pAdd(pos2, cc.p(math.random(1, 100) - 50, math.random(1, 60) - 30))
        anim:hide():move(pos):addTo(self.root_)
        local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "ani/fx_jinbi.csb")
        action:gotoFrameAndPlay(math.random(1, 50))
        anim:runAction(action)

        local delay = cc.DelayTime:create((i - 1) * 0.1)
        local pos3 = cc.p(self.root_:getChildByName("gold_win_2"):getPosition())
        local spawn = cc.Spawn:create(cc.MoveTo:create(0.4, pos3), cc.ScaleTo:create(0.4, 0.5))
        local call = cc.CallFunc:create(function()
            CSDSound.goldMove()
        end)
        local seq = cc.Sequence:create(delay, cc.Show:create(), cc.DelayTime:create(0.3), spawn, call, cc.RemoveSelf:create())
        anim:runAction(seq)
    end
end

local function playBigWin(self, args, callback)
    -- self.ui_ = args.typ == CSDSettle.Type.BIG_WIN and BigWinUI.new(parent) or JackpotUI.new(parent)
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        self.ui_:playReward(args, callback)
    end)))
end

function CSDSettle:accumulative(args, callback)
    local ratio = args.win / args.base
    if ratio >= 50 then
        playBigWin(self, args, function()
            playReward(self, args, callback)
        end)
    else
        playReward(self, args, callback)
    end
end

function CSDSettle:reset()
    self.bmfWinScore_:setString("")
end

return CSDSettle
