local MLCSLang = class("MLCSLang")
-- cc.exports.SubLang = require("game.mlcs.src.MLCSLang").new()
function MLCSLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎来到秘鲁传说",
        [2] = "当前有免费摇奖，不能修改下注数额。",
        [3] = "金币不足，请及时充值~",
        [4] = "免费旋转",
        [5] = "总赢利",
        [6] = "设置"

    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(1010),
        [2] = "The current lottery is free spin and the bet amount cannot be modified.",
        [3] = "Insufficient gold coins, please recharge in time~",
        [4] = "Free Spins",
        [5] = "Total Profit",
        [6] = "Settings"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function MLCSLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return MLCSLang

