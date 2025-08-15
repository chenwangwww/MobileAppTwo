-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FishBodyFrame = class("FISHBodyFrame")
local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.1, 0.5, 0.5)
local function getRes(path)
    return "game/fishlk/res/" .. path
end
function FishBodyFrame:ctor()
    -- 物体刚体数据
    self.m_bodyList = {}
    self:readyBodyPlist(getRes("body.plist"))
end

-- 解析刚体数据 plist
function FishBodyFrame:readyBodyPlist(param)

    local Path = cc.FileUtils:getInstance():fullPathForFilename(param)
    local datalist = cc.FileUtils:getInstance():getValueMapFromFile(Path)
    local bodies = datalist["bodies"]

    -- 解析数据
    for k, v in pairs(bodies) do
        if k ~= nil then
            local bodyName = k
            local sub = bodies[bodyName]
            local fixtures = sub["fixtures"]
            local polygonsarr = fixtures[1]
            local polygons = polygonsarr["polygons"]

            local points = {}
            for i = 1, #polygons do
                table.insert(points, polygons[i])
            end
            table.insert(self.m_bodyList, {
                k = bodyName,
                p = points
            })
        end
    end
end

function FishBodyFrame:getBodyByType(param)
    local type = string.format("fish%d_01", param + 1)
    return self:getBodyByName(type)
end

function FishBodyFrame:getBodyByName(param)
    if #self.m_bodyList ~= 0 then
        for i = 1, #self.m_bodyList do
            local sublist = self.m_bodyList[i]
            local k = sublist.k

            if k == param then
                local points = sublist.p
                local physicsBody = cc.PhysicsBody:create()
                for s = 1, #points do
                    local onePoint = points[s]
                    local resultPoints = {}
                    for t = 1, #onePoint do
                        local vector = onePoint[t]
                        -- 去掉大括号
                        local result = string.sub(vector, 2, -2)
                        local len = string.len(result)
                        local dindex = string.find(result, ",")

                        local subx = string.sub(result, 1, dindex - 1)
                        local x = tonumber(subx)
                        local suby = string.sub(result, dindex + 1, len)
                        local y = tonumber(suby)

                        local p = cc.p(x, y)
                        table.insert(resultPoints, p)
                    end
                    local shape = cc.PhysicsShapePolygon:create(resultPoints, cc.PHYSICSBODY_MATERIAL_DEFAULT)
                    physicsBody:addShape(shape)
                end
                physicsBody:setGravityEnable(false)
                return physicsBody
            end
        end
    end
end

return FishBodyFrame
-- endregion
