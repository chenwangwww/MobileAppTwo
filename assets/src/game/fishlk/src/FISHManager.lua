-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHManager = class("FISHManager")
local Fish = require "game.fishlk.src.FISHLKObj"
local Fishlk_CMD = require "game.fishlk.src.FISHLK_CMD"
function FISHManager:ctor(FishlkScene)
    self.fish_lk = nil
    self.fish_task = nil
    self.fish_list = {}
    self.FishlkScene = FishlkScene
end
function FISHManager:CreateFish(value)
    -- 创建鱼
    local pFish = Fish.new("yuan.png", value.fishTrace, value.fishPos, self.FishlkScene)
    pFish:setPosition(cc.p(value.fishPos[1].x, value.fishPos[1].y))
    pFish:setTag(value.fishTrace.fish_id)
    -- 李逵判断
    if value.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_LK then
        self.fish_lk = pFish
    end
    -- 任务判断
    if value.fishTrace.fish_kind == Fishlk_CMD.FishKind.FISH_KIND_TASK then
        self.fish_task = pFish
    end
    self:AddSceneFish(pFish)
    self.FishlkScene.m_fishLayer:addChild(pFish)
end

function FISHManager:AddSceneFish(fish)
    table.insert(self.fish_list, fish)
end

function FISHManager:GetFishList()
    return self.fish_list
end

function FISHManager:StopMove()
    for k, v in ipairs(self.fish_list) do
        v:stop()
    end
end

function FISHManager:ActiveMove()
    for k, v in ipairs(self.fish_list) do
        v:active()
    end
end

function FISHManager:RemoveFish(value)
    if value == nil then
        return
    end
    for i = 1, 8 do
        if self.m_FishLock[i] ~= nil then
            if self.m_FishLock[i] == value then
                self.m_FishLock[i] = nil
            end
        end
    end
    -- 判断李逵
    if self.fish_lk ~= nil then
        if value:GetFishID() == self.fish_lk:GetFishID() then
            self.fish_lk = nil
        end
    end
    -- 判断任务
    if self.fish_task ~= nil then
        if value:GetFishID() == self.fish_task:GetFishID() then
            self.fish_task = nil
        end
    end
    for k, v in ipairs(self.fish_list) do
        if v:GetFishID() == value:GetFishID() then
            table.remove(self.fish_list, k)
            v:closeSchdule()
            v:removeFromParent()
            break
        end
    end
end

function FISHManager:RemoveAllFish()
    for k, v in ipairs(self.fish_list) do
        v:closeSchdule()
        v:removeFromParent()
    end
    self.fish_list = {}
    self.fish_lk = nil
    self.fish_task = nil
    for i = 1, 8 do
        self.m_FishLock[i] = nil
    end
end

function FISHManager:GetFishLk()
    return self.fish_lk
end

function FISHManager:GetFishTask()
    return self.fish_task
end

function FISHManager:GetFishIdToFish(lock_fishid)
    for k, v in ipairs(self.fish_list) do
        if v:GetFishID() == lock_fishid then
            return v
        end
    end
    return nil
end

function FISHManager:IsFishMaxScene(fish)
    local fishPos = fish:getPos()
    local size = fish:getContentSize()
    local f = 5
    if fishPos.x > f and fishPos.x < self.FishlkScene.visibleSize.width - f and fishPos.y > f and fishPos.y < self.FishlkScene.visibleSize.height - f then
        return true
    end
    local pos_table = {cc.p(fishPos.x - size.width * 1.414 / 2, fishPos.y - size.width / 2), cc.p(fishPos.x - size.width * 1.414 / 2, fishPos.y + size.width / 2),
                       cc.p(fishPos.x + size.width * 1.414 / 2, fishPos.y - size.width / 2), cc.p(fishPos.x + size.width * 1.414 / 2, fishPos.y + size.width / 2)}
    for k, v in ipairs(pos_table) do
        if v.x > f and v.x < self.FishlkScene.visibleSize.width - f and v.y > f and v.y < self.FishlkScene.visibleSize.height - f then
            return true
        end
    end

    return false
end

return FISHManager
-- endregion
