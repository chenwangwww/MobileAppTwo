local JLDBLang = class("JLDBLang")
-- cc.exports.SubLang = require("game.jldb.src.JLDBLang").new()
function JLDBLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎进入九连夺宝",
        [2] = "您的当前金币少于押注金币"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(204),
        [2] = "Not enough gold coins!"

    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function JLDBLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return JLDBLang

