--[[
LHDBGameEnd.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")
local LHDBSound = require("game.lhdb.src.LHDBSound")

local GameEndUI = class("GameEndUI", function()
    return cc.Node:create()
end)

function GameEndUI:ctor(args)
    self.root_ = cc.CSLoader:createNode(GameCMD.RES_PATH .. "Anims/fx_tanbaojiangli.csb")
    local action = cc.CSLoader:createTimeline(GameCMD.RES_PATH .. "Anims/fx_tanbaojiangli.csb")
    action:gotoFrameAndPlay(0, 270, false)
    self.root_:move(display.center)
    self.root_:runAction(action)
    self.root_:addTo(self)
    self.imgBg_ = self.root_:getChildByName("Panel_1_0")
    self.imgBg_:getChildByName("TextScore"):setString(args.lottery)
    local bgSize = self.imgBg_:getContentSize()
    local scale = math.min(display.width / bgSize.width, display.height / bgSize.height)
    self.imgBg_:setScale(scale)

    self.imgBg_:getChildByName("txt_desc"):setString(string.format(SubLang:word(4), args.bet, args.price))

    LHDBSound.settleReward()
end

function GameEndUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("BtnSure"):addClickEventListener(function()
        self.root_:stopActionByTag(0xab)
        if callback then
            callback()
        end
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(5.0), cc.CallFunc:create(callback))
    seq:setTag(0xab)
    self.root_:runAction(seq)
end

-------------------------------------------------------------------------------------------------------------

local LHDBGameEnd = class("LHDBGameEnd")

function LHDBGameEnd:ctor()

end

function LHDBGameEnd:show(parent, args, callback)
    if not parent then
        return
    end

    self.ui_ = GameEndUI.new(args)
    self.ui_:addCloseCallback(callback)
    self.ui_:addTo(parent)
end

return LHDBGameEnd
