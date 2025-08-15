local JPMLang = class("JPMLang")
-- cc.exports.SubLang = require("game.jpm.src.JPMLang").new()
function JPMLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = ""

    }

    self.tWordEng = {
        [1] = ""
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function JPMLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return JPMLang

