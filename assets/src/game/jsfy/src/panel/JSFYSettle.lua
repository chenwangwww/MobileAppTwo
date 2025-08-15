--[[
JSFYSettle.lua
]] local GameCMD = require("game.jsfy.src.JSFYCMD")
local JSFYSound = require("game.jsfy.src.JSFYSound")

local BigWinUI = class("BigWinUI")

function BigWinUI:ctor(parent)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "LayerWin.csb")
    self.root_:addTo(parent)

    self.root_:align(display.CENTER, display.center)
    local bgSize = self.root_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.root_:setScale(scale)

    self.txtScore_ = self.root_:getChildByName("Image_1"):getChildByName("Text_MageWin")
    self.txtScore_:setString(0)

    self.root_:hide()
end

local function finishReward(self, callback)
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
        self.root_:stopAllActions()
        self.root_:hide()
        if callback then
            callback()
        end
    end)))
end

function BigWinUI:playReward(args, callback)
    JSFYSound.playBigWin()
    JSFYSound.addScore()
    self.root_:show()
    local baseScore = args.base
    local winScore = args.win
    local rate = math.ceil(winScore / baseScore)

    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "LayerWin.csb")
    action:gotoFrameAndPlay(0)
    self.root_:runAction(action)

    local currentScore = 0
    local interval = 0.1
    local tick = 5
    local stepAdd = winScore / tick
    local callFunc = cc.CallFunc:create(function()
        currentScore = currentScore + stepAdd
        currentScore = currentScore > winScore and winScore or currentScore
        self.txtScore_:setString(math.floor(currentScore))
        if currentScore >= winScore then
            finishReward(self, callback)
            return
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(interval), callFunc)
    local rep = cc.RepeatForever:create(seq)
    self.root_:runAction(rep)
end

--------------------------------------------------------------------------------------------------------------------
local JSFYSettle = class("JSFYSettle")

function JSFYSettle:ctor(root)
    self.root_ = root
    self.atlsScore_ = self.root_:getChildByName("atls_win")
    self.atlsScore_:hide()
    self.bmfWinScore_ = self.root_:getChildByName("bmf_win")
    self.bmfWinScore_:setString("")

    self.game_tag = self.root_:getChildByName("game_tag")
    self.game_tag:setString("")

    local parent = self.root_:getParent()
    self.ui_ = BigWinUI.new(parent)
end

function JSFYSettle:updateWinScore(score)
    self.bmfWinScore_:setString(score)
end

function JSFYSettle:updateGameStr(str)
    self.game_tag:setString(str)
end

local function playReward(self, args, callback)
    self.atlsScore_:show()
    self.atlsScore_:setString("")
    if args.SumFreeGold > 0 then
        local score = args.SumFreeGold - args.win
        self.bmfWinScore_:setString(score)
    else
        self.bmfWinScore_:setString("")
    end

    local currentScore = 0
    local interval = 0.1
    local tick = 10
    local winScore = args.win
    local stepAdd = winScore / tick
    local callFunc = cc.CallFunc:create(function()
        currentScore = currentScore + stepAdd
        currentScore = currentScore > winScore and winScore or currentScore
        local strScore = math.floor(currentScore)
        self.atlsScore_:setString(strScore)
        if args.SumFreeGold > 0 then
            local score = args.SumFreeGold - args.win + strScore
            self.bmfWinScore_:setString(score)
        else
            self.bmfWinScore_:setString(strScore)
        end
        if currentScore >= winScore then
            self.atlsScore_:stopAllActions()
            self.atlsScore_:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.Hide:create(), cc.CallFunc:create(callback)))
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(interval), callFunc)
    local rep = cc.RepeatForever:create(seq)
    self.atlsScore_:runAction(rep)
end

local function playBigWin(self, args, callback)
    self.root_:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), cc.CallFunc:create(function()
        self.ui_:playReward(args, callback)
    end)))
end

function JSFYSettle:accumulative(args, callback)
    local ratio = args.win / args.base
    if ratio >= 200 then
        playBigWin(self, args, function()
            playReward(self, args, callback)
        end)
    else
        playReward(self, args, callback)
    end
end

function JSFYSettle:reset()
    self.bmfWinScore_:setString("")
    self.game_tag:setString("")
end

return JSFYSettle
