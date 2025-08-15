local HappyFruitText = class("HappyFruitText")

function HappyFruitText:ctor(scene)
    self.scene = scene
    self.logic = scene.logic

    self.Panel_bottom = scene.layer:getChildByName("Panel_bottom")
    self.Panel_bottom:setScale(self.logic:getWinScale())

    local Panel_line = scene.Panel_center:getChildByName("Panel_line")
    self.line_box = {}
    for i = 1, 9 do
        self.line_box[i] = Panel_line:getChildByName("Panel_line_" .. i)
        self.line_box[i]:setVisible(false)
    end

    self.prize_pool_num = scene.Panel_center:getChildByName("prize_pool_num")
    self.prize_pool_num:setFntFile("game/happyfruit/res/fnt/shuiguoji4.fnt")
    self.Text_value1 = self.Panel_bottom:getChildByName("Text_value1")
    self.Text_value2 = self.Panel_bottom:getChildByName("Text_value2")
    self.Text_player = self.Panel_bottom:getChildByName("Text_player")
    self.Text_gold = self.Panel_bottom:getChildByName("Text_gold")
    self.Text_bet = scene.Panel_center:getChildByName("Text_bet")

    if not LangCtrl:isCN() then
        local Text_name1 = self.Panel_bottom:getChildByName("Text_name1") -- 连线数量
        local Text_name2 = self.Panel_bottom:getChildByName("Text_name2") -- 单线投入
        Text_name1:setString(SubLang:word(8))
        Text_name2:setString(SubLang:word(9))
    end

    self:updatePoolCount()
    self:setShowLine(-1)
    self:updateSingleBet()
    self:updatePlayerName()
    self:updatePlayerGold()
    self:setWinGolds(0)
end

-- 设置彩金池大小
function HappyFruitText:updatePoolCount()
    local num = self.logic:getPoolCount()
    self.prize_pool_num:setString(tostring(num))
end

-- 设置连线数量
function HappyFruitText:updateLineCount(skip)
    local num = self.logic:getLineCount()
    self.Text_value1:setString(tostring(num))

    if not skip then
        for i = 1, num do
            self.line_box[i]:setVisible(true)
        end

        for i = 9, num + 1, -1 do
            self.line_box[i]:setVisible(false)
        end
    end
end

function HappyFruitText:setShowLine(idx)
    for k, v in pairs(self.line_box) do
        v:setVisible(k == idx)
    end
end

-- 设置单线投入
function HappyFruitText:updateSingleBet()
    local num = self.logic:getLineBet()
    self.Text_value2:setString(tostring(num))
end

-- 设置玩家名字
function HappyFruitText:updatePlayerName()
    local name = self.logic:getPlayerName()
    self.Text_player:setString(tostring(name))
end

-- 设置玩家金币
function HappyFruitText:updatePlayerGold()
    local gold = self.logic:getPlayerGold()
    self.Text_gold:setString(tostring(gold))
end

-- 设置玩家免费摇奖
function HappyFruitText:setWinGolds(gold)
    -- local num = self.logic:getBonusCount()
    -- if num > 0 then
    -- 	self.Text_bet:setString("免费摇奖:" .. tostring(num))
    -- else
    self.Text_bet:setString(gold)
    -- end
end

function HappyFruitText:cleanView()
    self.prize_pool_num:setString("")
    self.Text_value1:setString("")
    self.Text_value2:setString("")
    self.Text_player:setString("")
    self.Text_gold:setString("")
    self.Text_bet:setString("")
end

function HappyFruitText:onExit()

end

return HappyFruitText
