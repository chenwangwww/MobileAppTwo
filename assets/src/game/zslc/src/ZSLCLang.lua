local ZSLCLang = class("ZSLCLang")
-- cc.exports.SubLang = require("game.zslc.src.ZSLCLang").new()
function ZSLCLang:ctor()
    -- SubLang:word()
    self.tWordCN = {
        [1] = "欢迎来到黄金战车",
        [2] = "请等待动作完成后再操作",
        [3] = "请取消自动后再操作",
        [4] = "请先押注!",
        [5] = "金币不足!",
        [6] = "加速x",
        [7] = "彩金",
        [8] = "全部"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(1003),
        [2] = "Please wait until the action is completed before proceeding.",
        [3] = "Please wait until the automatic cancellation is completed before proceeding.",
        [4] = "Please bet first!",
        [5] = "Not enough gold coins!",
        [6] = "fast x",
        [7] = "bonus",
        [8] = "all"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function ZSLCLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return ZSLCLang

