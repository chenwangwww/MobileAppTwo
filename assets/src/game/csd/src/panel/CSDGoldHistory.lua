--[[
CSDGoldHistory.lua

]] local GameCMD = require("game.csd.src.CSDCMD")

local Rank = class("Rank")

function Rank:ctor(root)
    self.root_ = root

    self.avatar_ = GameUtil.createAvatar("", 80, false, nil, nil, "img_avatar_1", false):addTo(self.root_):move(self.root_:getChildByName("node_head"):getPosition())
    self:load{}
end

function Rank:load(args)
    -- dump(args)
    args = args or {}
    local nobody = not args.dwGameID or args.dwGameID == 0
    local txtName = self.root_:getChildByName("name")
    txtName:setString(args.szNickName or "")
    GameCMD.subText(txtName, 120)
    self.root_:getChildByName("nobody"):setVisible(nobody)
    self.root_:getChildByName("money"):setVisible(not nobody)
    self.root_:getChildByName("money"):setString(GameUtil.formatAsset(args.lGold or 0))

    self.avatar_:updateAvatar("icon_1.png")
    self.avatar_:hide()
    if not nobody then
        local faceAddr = string.trim(args.szFaceAddr or "")
        self.avatar_:show():updateAvatar(string.len(faceAddr) > 0 and faceAddr or "icon_1.png")
    end
end
-----------------------------------------------------------------------------

local CSDGoldHistory = class("CSDGoldHistory")

function CSDGoldHistory:ctor(root)
    self.root_ = root
    self.rank_ = {}
    local lstRank = self.root_:getChildByName("lst_rank")
    for i = 1, 3 do
        self.rank_[i] = Rank.new(lstRank:getChildByName("rank_" .. i))
    end

    if LangCtrl:isEng() then
        local txt = self.root_:getChildByName("txt_rank")
        txt:setString(SubLang:word(2))
    end

end

function CSDGoldHistory:loadRecords(records)
    for i, rank in ipairs(self.rank_) do
        rank:load(records[i])
    end
end

return CSDGoldHistory
