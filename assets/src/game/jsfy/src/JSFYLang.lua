local JSFYLang = class("JSFYLang")
-- cc.exports.SubLang = require("game.jsfy.src.JSFYLang").new()
function JSFYLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "倍",
        [2] = "总奖励：%dx%d=%d",
        [3] = "您的余额不足",
        [4] = "30线",
        [5] = "音乐",
        [6] = "音效"

    }

    self.tWordEng = {
        [1] = "x",
        [2] = "total reward: %dx%d=%d",
        [3] = "Not enough gold coins!",
        [4] = "",
        [5] = "Music",
        [6] = "Effect"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function JSFYLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return JSFYLang

