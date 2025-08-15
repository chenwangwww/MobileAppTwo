--[[
JDNNStatus.lua

]] local GameCMD = require("game.jdnn.src.JDNNCMD")
local JDNNSound = require("game.jdnn.src.JDNNSound")

local JDNNStatus = class("JDNNStatus")

local StateDesc = {
    [GameCMD.GS_TK_FREE] = "等待玩家准备...",
    [GameCMD.SUB_S_CALL_BANKER] = {"叫庄倒计时...", "等待玩家叫庄..."},
    [GameCMD.SUB_S_ADD_SCORE] = {"请选择加注倍数...", "等待玩家加注..."},
    [GameCMD.SUB_S_OPEN_CARD] = {"亮牌倒计时...", "等待玩家亮牌..."}
}

function JDNNStatus:ctor(root)
    self.root_ = root
    -- self.txtClock_ = self.root_:getChildByName("img_clock"):getChildByName("atls_clock")
    -- self.txtTips_ = self.root_:getChildByName("txt_tips")
end

function JDNNStatus:updateTime(time)
    -- self.txtClock_:setString(time)
    if self.state_ == GameCMD.SUB_S_OPEN_CARD and (time > 0 and time <= 5) then
        JDNNSound.playWarning()
    end
end

local function setFreeState(self)
    self.txtClock_:setString(GameCMD.TIME_USER_FREE)
    self.txtTips_:setString(StateDesc[GameCMD.GS_TK_FREE])
end

local function setCallBankerState(self, isCalled)
    self.txtClock_:setString(GameCMD.TIME_USER_CALL_BANKER)
    self.txtTips_:setString(StateDesc[GameCMD.SUB_S_CALL_BANKER][isCalled and 2 or 1])
end

local function setAddScoreState(self, isAdded)
    self.txtClock_:setString(GameCMD.TIME_USER_ADD_SCORE)
    self.txtTips_:setString(StateDesc[GameCMD.SUB_S_ADD_SCORE][isAdded and 2 or 1])
end

local function setOpenCardState(self, isOpened)
    self.txtClock_:setString(GameCMD.TIME_USER_OPEN_CARD)
    self.txtTips_:setString(StateDesc[GameCMD.SUB_S_OPEN_CARD][isOpened and 2 or 1])
end

local function setGameEndState(self)
    self:show(false)
end

function JDNNStatus:setState(gameState, ...)
    self:show(true)
    self.state_ = gameState
    -- if GameCMD.GS_TK_FREE == self.state_ then
    -- 	setFreeState(self)
    -- elseif GameCMD.SUB_S_CALL_BANKER == self.state_ then
    -- 	setCallBankerState(self, ...)
    -- elseif GameCMD.SUB_S_ADD_SCORE == self.state_ then
    -- 	setAddScoreState(self, ...)
    -- elseif GameCMD.SUB_S_OPEN_CARD == self.state_ then
    -- 	setOpenCardState(self, ...)
    -- elseif GameCMD.SUB_S_GAME_END == self.state_ then
    -- 	setGameEndState(self)
    -- else
    -- 	dump("unknow state")
    -- end
end

function JDNNStatus:getState()
    return self.state_
end

function JDNNStatus:show(visible)
    -- self.root_:setVisible(visible)
end

return JDNNStatus
