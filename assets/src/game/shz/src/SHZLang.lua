local SHZLang = class("SHZLang")
-- cc.exports.SubLang = require("game.shz.src.SHZLang").new()
function SHZLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎进入水浒传",
        [2] = "您的当前金币少于押分!"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(203),
        [2] = "Not enough gold coins!"

    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function SHZLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return SHZLang

