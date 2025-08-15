local FISHLKLang = class("FISHLKLang")
-- cc.exports.SubLang = require("game.fishlk.src.FISHLKLang").new()
function FISHLKLang:ctor()
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

function FISHLKLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return FISHLKLang

