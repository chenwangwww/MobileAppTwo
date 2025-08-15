local MJHLLang = class("MJHLLang")
-- cc.exports.SubLang = require("game.mjhl.src.MJHLLang").new()
function MJHLLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎来到麻将胡了",
        [2] = "当前有免费摇奖，不能修改下注数额。",
        [3] = "金币不足，请及时充值~",
        [4] = "长按自动",
        [5] = "自动游戏中"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(1012),
        [2] = "The current lottery is free spin and the bet amount cannot be modified.",
        [3] = "Insufficient gold coins, please recharge in time~",
        [4] = "Long press auto",
        [5] = "Automatic"

    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function MJHLLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return MJHLLang

