require "app.platform.lang.TipsWordCN"
require "app.platform.lang.TipsWordEng"

local LangCtrl = class("LangCtrl")

function LangCtrl:ctor()
    self.nCurIdx = 1 -- 1 中文  2 英文
    self:read_only_table(TipsWordCN)
    self:read_only_table(TipsWordEng)
    self.tAllLang = {TipsWordCN, TipsWordEng}
    self.tCurLang = {"简体中文", "English"}
    self:initGames()
end

function LangCtrl:initGames()
    self.tGamesMap = {
        [27] = "word352", -- 火拼牛牛jdnn,
        [28] = "word353", -- 通比牛牛tbnn,
        [33] = "word329", -- 李逵劈鱼
        [203] = "word330", -- 水浒传
        [204] = "word331", -- 九连夺宝
        [205] = "word332", -- 水果狂欢
        [1002] = "word333", -- 连环夺宝
        [1003] = "word334", -- 黄金战车
        [1005] = "word335", -- 财神到
        [1008] = "word336", -- 僵尸风云
        [1009] = "word337", -- 金瓶梅
        [1010] = "word338", -- 秘鲁传说
        [1011] = "word339", -- 跳高高
        [1012] = "word340" -- 麻将胡了
    }
end

function LangCtrl:gameName(kindid, defaultname)
    local id = self.tGamesMap[kindid]
    local str = ""
    if id then
        str = self:getLang()[id]
    end
    if str == "" or str == nil then
        str = defaultname or ""
    end
    return str
end

function LangCtrl:getCurName()
    return self.tCurLang[self.nCurIdx]
end

function LangCtrl:nextLanguage()
    self.nCurIdx = self.nCurIdx + 1
    if self.nCurIdx > #self.tAllLang then
        self.nCurIdx = 1
    end
end

function LangCtrl:setCN()
    self.nCurIdx = 1
end

function LangCtrl:setEng()
    self.nCurIdx = 2
end

function LangCtrl:isCN()
    return self.nCurIdx == 1
end

function LangCtrl:isEng()
    return self.nCurIdx == 2
end

function LangCtrl:getLang()
    return self.tAllLang[self.nCurIdx]
end

function LangCtrl:read_only_table(t)
    local temp = t or {}
    local mt = {
        __index = function(t, k)
            return temp[k]
        end,

        __newindex = function(t, k, v)
            error("table is read only!")
        end
    }
    setmetatable(temp, mt)
    return temp
end

return LangCtrl

