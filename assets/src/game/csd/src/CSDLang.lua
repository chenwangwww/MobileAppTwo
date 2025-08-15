local CSDLang = class("CSDLang")
-- cc.exports.SubLang = require("game.csd.src.CSDLang").new()
function CSDLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "您的余额不足",
        [2] = "彩金中奖玩家",
        [3] = "音乐",
        [4] = "音效"
    }

    self.tWordEng = {
        [1] = "Not enough gold coins!",
        [2] = "jackpot\n winner",
        [3] = "Music",
        [4] = "Effect"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function CSDLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return CSDLang

