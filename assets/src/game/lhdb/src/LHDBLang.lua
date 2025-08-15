local LHDBLang = class("LHDBLang")
-- cc.exports.SubLang = require("game.lhdb.src.LHDBLang").new()
function LHDBLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎进入水浒传",
        [2] = "您的当前金币少于押分!",
        [3] = "此游戏桌已满员，请选择其他桌！",
        [4] = "累计下注:%d,单颗龙珠探中奖励:%d",
        [5] = "%d秒后自动选择"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(1002),
        [2] = "Not enough gold coins!",
        [3] = "This game table is full, please choose another table.",
        [4] = "Cumulative bets:%d, %d Reward / dragon ball",
        [5] = "Automatically select after %d second"

    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function LHDBLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return LHDBLang

