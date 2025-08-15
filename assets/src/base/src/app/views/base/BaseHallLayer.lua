-- region NewFile_1.lua
-- Author : admin
-- Date   : 2017/9/6
-- 此文件由[BabeLua]插件自动生成
local BaseHallLayer = class("BaseHallLayer", function()
    return display.newLayer()
end)

function BaseHallLayer:ctor(size, index, args)
    self:setContentSize(size)
    self.layer_index = index
    PlazaManager.openHallLayerData = {}
    PlazaManager.openHallLayerData.index = index
    if args ~= nil then
        PlazaManager.openHallLayerData.data = args
    end
    self:enableNodeEvents()
end

function BaseHallLayer:getLayerIndex()
    return self.layer_index
end

function BaseHallLayer:onEnter()
end

function BaseHallLayer:onEnterTransitionFinish()
end

function BaseHallLayer:onExit()
end

function BaseHallLayer:cleanup()
end

return BaseHallLayer

-- endregion
