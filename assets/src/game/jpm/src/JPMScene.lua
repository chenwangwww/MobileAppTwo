--[[
金瓶梅
]] local GameCMD = require("game.jpm.src.JPMCMD")
local GameMessage = require("game.jpm.src.JPMMessage")
local JPMSound = require("game.jpm.src.JPMSound")

local JPMCenter = require("game.jpm.src.panel.JPMCenter")
local JPMScene = class("JPMScene", require("app.views.base.BaseGameScene"))

local GameState = {
    SEND = 0,
    REPLY = 1,
    FINISH = 2
}

JPMScene.CARD_LINES = {{5, 6, 7, 8, 9}, {10, 11, 12, 13, 14}, {0, 1, 2, 3, 4}, {10, 6, 2, 8, 14}, {0, 6, 12, 8, 4}, {5, 11, 12, 13, 9}, {5, 1, 2, 3, 9}, {10, 11, 7, 3, 4}, {0, 1, 7, 13, 14},
                       {5, 1, 7, 13, 9}, {5, 11, 7, 3, 9}, {10, 6, 7, 8, 14}, {0, 6, 7, 8, 4}, {10, 6, 12, 8, 14}, {0, 6, 2, 8, 4}}

JPMScene.REWARD_SCORE = {
    [1] = {
        [3] = 100,
        [4] = 400,
        [5] = 1200
    },
    [2] = {
        [3] = 80,
        [4] = 250,
        [5] = 800
    },
    [3] = {
        [3] = 50,
        [4] = 150,
        [5] = 500
    },
    [4] = {
        [3] = 30,
        [4] = 100,
        [5] = 300
    },
    [5] = {
        [3] = 20,
        [4] = 60,
        [5] = 200
    },
    [6] = {
        [3] = 10,
        [4] = 40,
        [5] = 150
    },
    [7] = {
        [3] = 8,
        [4] = 30,
        [5] = 100
    },
    [8] = {
        [3] = 6,
        [4] = 20,
        [5] = 80
    },
    [9] = {
        [3] = 5,
        [4] = 15,
        [5] = 60
    },
    [10] = {
        [3] = 4,
        [4] = 10,
        [5] = 50
    }
}

function JPMScene:onCreate()
    cc.exports.SubLang = require("game.jpm.src.JPMLang").new()
    JPMScene.super.onCreate(self)
    self.center = JPMCenter:new(self);
    self.center:addTo(self);
end

function JPMScene:onEnterTransitionFinish()
    JPMScene.super.onEnterTransitionFinish(self)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)
    self:onQuestReady()
end

function JPMScene:addEvent()
    self.onEventPersonalEnd = handler(self, self.onPersonalEnd)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)

    self.onEventShowRoomInfo = handler(self, self.onShowRoomInfo)
    game.registerEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
end

function JPMScene:removeEvent()
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_INFO, self.onEventShowRoomInfo)
    game.unregisterEvent(GameDefine.SC_GR_PRIVATE_END, self.onEventPersonalEnd)
end

function JPMScene:onExit()
    JPMScene.super.onExit(self)
    self.center:onExit()
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION_DEFAULT)
    self:removeEvent()
    self.center:stopAllActions();
    LoadingManager.removeLoadRes(GameCMD.KIND_ID)
end

local function overtimeReconnect(self, open)
    --[[self.root_:stopActionByTag(0xaa)
    if not open then return end
    local seq = cc.Sequence:create(cc.DelayTime:create(8.0), cc.CallFunc:create(function ()
        self:refreshGame()
    end))
    seq:setTag(0xaa)
    self.root_:runAction(seq)--]]
end

function JPMScene:onUserSitDown(gameUser)

end

function JPMScene:onShowRoomInfo(info)

end

function JPMScene:onPersonalEnd(data)

end

function JPMScene:onUserReady(gameUser)

end

function JPMScene:onUserStandup(wChairID)

end

function JPMScene:onUserOffline(gameUser)

end

function JPMScene:onUserPlaying(gameUser)

end

function JPMScene:onUserScore(gameUser)

end

function JPMScene:onGameScene(data)
    if self.gameDisConnection == true then
        self:onResetData()
        self:autoSitDown()
    end
    self.freeSpine = 0;
    if PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_ST_FREE then
        -- self:onSceneFree(data)
    elseif PlazaManager.gameStatus.cbGameStatus == GameCMD.GS_ST_PLAY then
        self:onScenePlay(data)
    end

    self.center:stopAllActions();
    self:resetCardData();
    self.center:setWinScore(0)
    self.center:setWinAllScore(0);

    if self.freeSpine > 0 or self.center.btnStartState == JPMCenter.State.AUTO then
        self.center:sendScrollMessage();
    end
end

function JPMScene:onGame(cmdID, data)
    if cmdID == GameCMD.SUB_S_CARD_SCROLL and data ~= nil then
        self:onGameCardScroll(GameMessage.onGameCardScroll(data))
    elseif cmdID == GameCMD.SUB_S_MESSAGE_INFO and data ~= nil then
        local str = GameMessage.onSubMessageInfo(data).szContent
        local showStr = GameUtil.filterMultMsg(str, 1)
        if showStr == nil or showStr == "" then
            return
        end
        self.center:showNotice(showStr)
    end
end

function JPMScene:onScenePlay(data)
    local params = GameMessage.onScenePlay(data);
    self.sceneData = params
    self.center:setSceneData(params);
    self.freeSpine = params.wFreeCount;
    self.center:setFreeSpines(self.freeSpine)
end

local testCardType = {{2, 2, 9, 2, 2}, {6, 9, 4, 6, 3}, {7, 12, 9, 8, 8}, {6, 2, 9, 7, 2}, {9, 10, 6, 5, 11}, {8, 2, 2, 4, 10}, {3, 6, 10, 4, 9}, {2, 3, 2, 5, 3}, {4, 3, 11, 7, 2}, {3, 2, 9, 12, 8},
                      {5, 6, 9, 7, 11}, {6, 12, 5, 12, 8}, {2, 6, 4, 11, 10}, {6, 6, 3, 12, 8}, {10, 11, 2, 8, 11}, {7, 6, 12, 4, 10}, {7, 11, 4, 6, 8}, {4, 8, 2, 7, 2}, {8, 3, 3, 0, 3},
                      {10, 10, 10, 6, 10}}

function JPMScene:onGameCardScroll(data)
    self.center:setUserScore(data.lUserScore);
    -- self.center:setWinScore(data.lWinScore)
    self.cbCardType = data.cbCardType

    self.freeSpine = data.wSumFreeCount;
    self.lWinScore = data.lWinScore
    self.lRoundScore = 0;
    self.center.isScrolling = false

    --[[data.cbCardType = {};
	for k = 1,20 do
		data.cbCardType[21-k] = {};
		for i = 1, 5 do
			data.cbCardType[21-k][i] = testCardType[k][i]
		end
	end
	self.cbCardType = data.cbCardType--]]
    self.center:setCardData(self.cbCardType, handler(self, self.onCardCalc))
end

function JPMScene:resetCardData()
    self.cbCards = {};
    local defaultArr = {10, 9, 8, 7, 6};
    for i = 1, 3 do
        self.cbCards[i] = {10, 9, 8, 7, 6};
        --[[for j=1,5 do
			self.cbCards[i][j] = defaultArr[i]
		end--]]
    end
    self.center:resetCard(self.cbCards)
end

--[[local CARD_LINES = {
	{ 5, 6, 7, 8, 9 }, { 0, 1, 2, 3, 4 }, { 10, 11, 12, 13, 14 }, { 10, 6, 2, 8, 14 }, { 0, 6, 12, 8, 4 },
	{ 5, 11, 12, 13, 9 },{ 5, 1, 2, 3, 9 }, { 10, 11, 7, 3, 4 },{ 0, 1, 7, 13, 14 } ,{ 5, 1, 7, 13, 9 },
	{ 5, 11, 7, 3, 9 },{ 10, 6, 7, 8, 14 }, { 0, 6, 7, 8, 4 } ,{ 10, 6, 12, 8, 14 }, { 0, 6, 2, 8, 4 }
}]]

function JPMScene:onCardCalc()
    --[[	if self.turnSoundId then
		JPMSound.stopEffect(self.turnSoundId);
	end
	self.turnSoundId = nil;--]]

    local gto = function(key)
        local colume = math.floor(key / 5)
        local line = key - colume * 5;
        local v = self.cbCardType[colume + 1][line + 1];
        return v;
    end

    local free = false
    local scatter = {};
    local scatterCount = 1;
    for i = 1, 15 do
        local v1 = gto(i - 1);
        if v1 == 11 then
            scatter[scatterCount] = i - 1;
            scatterCount = scatterCount + 1
        end
    end
    --[[	if scatterCount >3 then
		JPMSound.scatterWin()
	end--]]
    -- self.currentFreeScroll = self.currentFreeScroll or scatterCount >=3;

    local match = function(d1, d2)
        return (d2 < 10 and d1 < 10 and d1 == d2) or (d1 == 10 and d2 <= 10) or (d2 == 10 and d1 <= 10);
    end

    local canLines = {};
    self.removePoint = {}
    self.removePointLen = 0
    self.currentReward = 0;

    for i = 1, 15 do
        local linedata = JPMScene.CARD_LINES[i];

        local v1 = gto(linedata[1]);
        local v2 = gto(linedata[2]);
        local v3 = gto(linedata[3]);
        local v4 = gto(linedata[4]);
        local v5 = gto(linedata[5]);

        if v1 == nil or v2 == nil or v3 == nil or v4 == nil or v5 == nil then
            break
        end

        local count = 0
        local data = {}
        if match(v1, v2) then
            if match(v3, v2) and match(v3, v1) then
                if match(v3, v4) and match(v4, v1) and match(v2, v4) then
                    if match(v4, v5) and match(v5, v1) and match(v5, v2) and match(v5, v3) then
                        data = {linedata[1], linedata[2], linedata[3], linedata[4], linedata[5]}
                        count = 5
                    else
                        count = 4
                        data = {linedata[1], linedata[2], linedata[3], linedata[4]}
                    end
                else
                    data = {linedata[1], linedata[2], linedata[3]}
                    count = 3
                end
            end
        end
        if count > 0 then
            canLines[self.removePointLen] = count;
            self.removePointLen = self.removePointLen + 1

            self.center:showLine(i);

            local tempcard = {v1, v2, v3, v4, v5}

            local maxTimes = 0;
            local rCard = 10
            local maxLineCount = 0
            for k = 3, count do
                local mincard = v1
                for o = 1, k do
                    mincard = math.min(mincard, tempcard[o])
                end
                local r = mincard
                if r == 10 then
                    r = 0
                end
                if maxTimes <= JPMScene.REWARD_SCORE[r + 1][k] then
                    rCard = mincard
                    maxTimes = JPMScene.REWARD_SCORE[r + 1][k]
                    maxLineCount = k
                end
            end
            self.removePoint[self.removePointLen] = {};
            for p = 1, maxLineCount do
                self.removePoint[self.removePointLen][p] = linedata[p]
            end
            self.currentReward = self.currentReward + maxTimes
        end
    end

    local watchTimes = {1.5, 1.3, 1.1, 1.0}
    local nextTime = watchTimes[self.center.gameSpeed]
    if self.lWinScore == 0 then
        nextTime = nextTime + 0.5
    end

    if self.removePointLen == 0 then
        self.center:setFreeSpines(self.freeSpine)

        if self.freeSpine > 0 then

            self.center:setWinScore(0)
            self.center:setWinAllScore(0)
            -- self.center.jumpCoin:stopScroll()
            self.center:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), cc.CallFunc:create(function()
                self.center:startSendRevert()
                GameMessage.sendBounsScroll()
            end)))
        else
            self.center:onScrollEnd()

            self.center:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), cc.CallFunc:create(function()
                self.center:autoStartScroll()
            end)))
        end
    else
        JPMSound.scatterWin()
        self.center:setWinScore(self.currentReward * self.center.lBonusCellScore)
        self.lRoundScore = self.lRoundScore + self.currentReward * self.center.lBonusCellScore
        self.center:setWinAllScore(self.lRoundScore)
        if self.removePointLen == 1 then
            JPMSound.linWin(self.center)
        end
        JPMSound.xiaoChu();
        self.center:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), cc.CallFunc:create(function()
            JPMSound.winScore();
        end)))

        self.center:runAction(cc.Sequence:create(cc.DelayTime:create(watchTimes[self.center.gameSpeed]), cc.CallFunc:create(handler(self, self.startCrash))))
    end
end

function JPMScene:startCrash()
    self.center:hideAllLine();
    self.center:setWinScore(0)
    if self.removePointLen == 0 then
        self.center:autoStartScroll()
    else
        self.center:removePoint(self.removePointLen, self.removePoint, self.cbCardType, handler(self, self.onCardCalc));
    end
end

return JPMScene
