--[[
LHDBMsgBox.lua

]] local GameCMD = require("game.lhdb.src.LHDBCMD")

local MsgBoxUI = class("MsgBoxUI", function()
    return cc.Node:create()
end)

function MsgBoxUI:ctor(args)
    self.root_ = cc.CSLoader:createNode("game/lhdb/res/MsgBox.csb")
    self.root_:addTo(self)

    local pnl = self.root_:getChildByName("MsgPanel")
    pnl:move(display.center)
    pnl:setContentSize(display.size)

    self.imgBg_ = pnl:getChildByName("ImgBg")
    self.imgBg_:setScale(0.6)
    self.imgBg_:scaleTo{
        time = 0.3,
        scale = 1.0
    }

    self.imgBg_:getChildByName("TextMoney"):setString(args.minBet)
end

function MsgBoxUI:addCloseCallback(callback)
    self.imgBg_:getChildByName("CloseBut"):addClickEventListener(callback)
end

-------------------------------------------------------------------------------------------------------------

local LHDBMsgBox = class("LHDBMsgBox")

function LHDBMsgBox:ctor()

end

function LHDBMsgBox:show(parent, args)
    if not parent then
        return
    end
    self:close()

    self.ui_ = MsgBoxUI.new(args)
    self.ui_:addCloseCallback(handler(self, self.close))
    self.ui_:addTo(parent)
end

function LHDBMsgBox:close()
    if self.ui_ then
        self.ui_:removeSelf()
        self.ui_ = nil
    end
end

return LHDBMsgBox
