local HappyFruitLang = class("HappyFruitLang")
-- cc.exports.SubLang = require("game.happyfruit.src.HappyFruitLang").new()
function HappyFruitLang:ctor()
    -- SubLang:word(1)
    self.tWordCN = {
        [1] = "欢迎来到水果狂欢",
        [2] = "\n\n\n点击取消",
        [3] = "\n\n\n长按自动投注",
        [4] = "当前自动投注中",
        [5] = "当前免费摇奖，不能修改",
        [6] = "最少押1线",
        [7] = "积分不足！",
        [8] = "连线数量",
        [9] = "单线投入",
        [10] = "所有玩家的获利将有小部分计入彩池",
        [11] = "开\n奖\n比\n例",
        [12] = "赢得",
        [13] = "奖池"
    }

    self.tWordEng = {
        [1] = "Welcome to " .. LangCtrl:gameName(205), -- "欢迎来到水果狂欢",
        [2] = "\n\n\nClick to cancel", -- "\n\n\n点击取消",
        [3] = "\n\n\nLong press\n   auto", -- "\n\n\n长按自动投注",
        [4] = "Currently betting automatically", -- "当前自动投注中",
        [5] = "The current lottery is free and cannot be modified.", -- "当前免费摇奖，不能修改",
        [6] = "Bet at least one line.", -- "最少押1线",
        [7] = "Not enough points.", -- "积分不足！",
        [8] = "lines", -- "连线数量",
        [9] = "bet/line", -- "单线投入"
        [10] = "A small portion of all player profits will go into the bonus pool",
        [11] = "lottery\nratio",
        [12] = "win",
        [13] = "bonus"
    }

    self.tAllLang = {self.tWordCN, self.tWordEng}
    self.nCurIdx = LangCtrl.nCurIdx
    if self.nCurIdx > #self.tAllLang or self.nCurIdx < 1 then
        self.nCurIdx = 1
    end
end

function HappyFruitLang:word(idx)
    return self.tAllLang[self.nCurIdx][idx] or ""
end

return HappyFruitLang

