local TGGLang = class("TGGLang")
-- cc.exports.SubLang = require("game.tgg.src.TGGLang").new()
function TGGLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎来到跳高高",
        [2] = "当前有免费摇奖，不能修改下注数额。",
        [3] = "金币不足，请及时充值~",
        [4] = "长按自动",
        [5] = "自动游戏中",
        [6] = "游戏中"

    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(1011),
        [2] = "The current lottery is free spin and the bet amount cannot be modified.",
        [3] = "Insufficient gold coins, please recharge in time~",
        [4] = "Long press auto",
        [5] = "Automatic",
        [6] = "in game"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function TGGLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return TGGLang

