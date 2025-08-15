-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local _M = {}

-- 阶乘
function _M.Factorial(number)
    if number == 1 or number == 0 then
        return 1
    end
    if number == 2 then
        return 2
    end
    local factorial = 1
    for i = 2, number do
        factorial = factorial * i
    end
    return factorial
end

-- 组合
function _M.Combination(count, r)
    return _M.Factorial(count) / (_M.Factorial(r) * _M.Factorial(count - r))
end

-- 计算距离
function _M.CalcDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

-- 计算角度
function _M.CalcAngle(x1, y1, x2, y2)
    local distance = _M.CalcDistance(x1, y1, x2, y2)
    if distance == 0.0 then
        return 0.0
    end
    local sin_value = (x1 - x2) / distance
    local angle = math.acos(sin_value)
    if y1 < y2 then
        angle = 2 * math.pi - angle
    end
    angle = angle + math.pi / 2
    return angle
end

-- 建立线性路径
function _M.BuildLinear(init_x, init_y, init_count, trace_vector, distance)
    trace_vector = {}
    if init_count < 2 then
        return
    end
    if distance <= 0.0 then
        return
    end
    local distance_total = _M.CalcDistance(init_x[init_count], init_y[init_count], init_x[1], init_y[1])
    if distance_total <= 0.0 then
        return
    end
    local cos_value = math.abs(init_y[init_count] - init_y[1]) / distance_total
    local angle = math.acos(cos_value)
    local point = {}
    point.x = init_x[1]
    point.y = init_y[1]
    table.insert(trace_vector, point)
    local temp_distance = 0.0
    local size = 0
    while (temp_distance < distance_total) do
        local temp_point = {}
        size = table.maxn(trace_vector)
        if init_x[init_count] < init_x[1] then
            temp_point.x = init_x[1] - math.sin(angle) * (distance * size)
        else
            temp_point.x = init_x[1] + math.sin(angle) * (distance * size)
        end
        if init_y[init_count] < init_y[1] then
            temp_point.y = init_y[1] - math.cos(angle) * (distance * size)
        else
            temp_point.y = init_y[1] + math.cos(angle) * (distance * size)
        end
        table.insert(trace_vector, temp_point)
        temp_distance = _M.CalcDistance(temp_point.x, temp_point.y, init_x[1], init_y[1])
    end
    size = table.maxn(trace_vector)
    trace_vector[size].x = init_x[init_count]
    trace_vector[size].y = init_y[init_count]
    return trace_vector
end

-- 建立线性路径（角度）
function _M.BuildLinear_A(init_x, init_y, init_count, trace_vector, distance)
    trace_vector = {}
    if (init_count < 2) then
        return
    end
    if distance <= 0 then
        return
    end
    local distance_total = _M.CalcDistance(init_x[init_count], init_y[init_count], init_x[1], init_y[1])
    if distance_total <= 0 then
        return
    end
    local cos_value = math.abs(init_y[init_count] - init_y[1]) / distance_total
    local temp_angle = math.acos(cos_value)
    local point = {}
    point.x = init_x[1]
    point.y = init_y[1]
    point.angle = 1
    table.insert(trace_vector, point)
    local temp_distance = 0
    local temp_pos = {}
    temp_pos.x = 0
    temp_pos.y = 0
    temp_pos.angle = 0
    local size = 0
    while temp_distance < distance_total do
        size = table.maxn(trace_vector)
        if init_x[init_count] < init_x[1] then
            point.x = init_x[1] - math.sin(temp_angle) * (distance * size)
        else
            point.x = init_x[1] + math.sin(temp_angle) * (distance * size)
        end
        if init_y[init_count] < init_y[1] then
            point.y = init_y[1] - math.cos(temp_angle) * (distance * size)
        else
            point.y = init_y[1] + math.cos(temp_angle) * (distance * size)
        end
        local temp_dis = _M.CalcDistance(point.x, point.y, temp_pos.x, temp_pos.y)
        if temp_dis ~= 0 then
            local temp_value = (point.x - temp_pos.x) / temp_dis
            if (point.y - temp_pos.y) >= 0 then
                point.angle = math.acos(temp_value)
            else
                point.angle = point.angle - math.acos(temp_value)
            end
        else
            point.angle = 1
        end
        temp_pos.x = point.x
        temp_pos.y = point.y
        table.insert(trace_vector, point)
        temp_distance = _M.CalcDistance(point.x, point.y, init_x[1], init_y[1])
    end
    size = table.maxn(trace_vector)
    trace_vector[size].x = init_x[init_count]
    trace_vector[size].y = init_y[init_count]
    return trace_vector
end

-- 建立贝塞尔曲线
function _M.BuildBezier(init_x, init_y, init_count, trace_vector, distance)
    trace_vector = {}
    local index = 0
    local temp_pos_pre = {
        x = 0.0,
        y = 0.0
    }
    local t = 0.0
    local count = init_count - 1
    local temp_distance = distance
    local temp_value = 0.0
    while t <= 1.00 do
        local temp_pos = {
            x = 0.0,
            y = 0.0
        }
        index = 0
        while index <= count do
            temp_value = math.pow(t, index) * math.pow(1.0 - t, count - index) * _M.Combination(count, index)
            temp_pos.x = temp_pos.x + init_x[index + 1] * temp_value
            temp_pos.y = temp_pos.y + init_y[index + 1] * temp_value
            index = index + 1
        end
        local pos_space = 0.0
        if table.maxn(trace_vector) > 0 then
            local back_pos = temp_pos_pre
            pos_space = _M.CalcDistance(back_pos.x, back_pos.y, temp_pos.x, temp_pos.y)
        end
        if pos_space >= temp_distance or table.maxn(trace_vector) == 0 then
            table.insert(trace_vector, temp_pos)
            temp_pos_pre.x = temp_pos.x
            temp_pos_pre.y = temp_pos.y
        end
        t = t + 1.0 / 1600.0
    end
    return trace_vector
end

-- 建立快速贝塞尔曲线
function _M.BuildBezierFase(init_x, init_y, init_count, trace_vector, distance)
    trace_vector = {}
    local index = 1
    local temp_pos = {
        x = 0.0,
        y = 0.0
    }
    local temp_pos_pre = {
        x = 0.0,
        y = 0.0
    }
    local t = 0.0
    local temp_distance = distance
    local temp_value = 0.0
    while t <= 1.0 do
        temp_pos.x = 0.0
        temp_pos.y = 0.0
        index = 1
        while index <= init_count do
            temp_value = math.pow(t, index) * math.pow(1.0 - t, init_count - index) * _M.Combination(init_count, index)
            temp_pos.x = temp_pos.x + init_x[index] * temp_value
            temp_pos.y = temp_pos.y + init_y[index] * temp_value
            index = index + 1
        end
        local pos_space = 0.0
        if table.maxn(trace_vector) > 0 then
            pos_space = _M.CalcDistance(temp_pos_pre.x, temp_pos_pre.y, temp_pos.x, temp_pos.y)
        end
        if (pos_space >= temp_distance) or table.maxn(trace_vector) == 0 then
            table.insert(trace_vector, temp_pos)
            temp_pos_pre.x = temp_pos.x
            temp_pos_pre.y = temp_pos.y
        end
        t = t + 0.01
    end
    return trace_vector
end

-- 建立贝塞尔曲线（角度）
function _M.BuildBezier_angle(init_x, init_y, init_count, trace_vector, distance)
    trace_vector = {}
    local posl = {}
    posl.x = init_x[1]
    posl.y = init_y[1]
    posl.angle = 1.0
    table.insert(trace_vector, posl)

    local index = 1
    local temp_pos0 = {
        x = 0.0,
        y = 0.0
    }
    local t = 0.0
    local temp_distance = distance
    local temp_pos = {
        x = 0.0,
        y = 0.0,
        angle = 0.0
    }
    local temp_pos_pre = {
        x = 0.0,
        y = 0.0
    }
    local temp_value = 0.0
    while t < 1.0 do
        temp_pos.x = 0.0
        temp_pos.y = 0.0
        index = 1
        while index <= init_count do
            temp_value = math.pow(t, index) * math.pow(1.0 - t, init_count - index) * _M.Combination(init_count, index)
            temp_pos.x = temp_pos.x + init_x[index] * temp_value
            temp_pos.y = temp_pos.y + init_y[index] * temp_value
            index = index + 1
        end
        local pos_space = 0.0
        if table.maxn(trace_vector) > 0 then
            pos_space = _M.CalcDistance(temp_pos_pre.x, temp_pos_pre.y, temp_pos.x, temp_pos.y)
        end
        if pos_space >= temp_distance or table.maxn(trace_vector) == 0 then
            if table.maxn(trace_vector) > 0 then
                local temp_dis = _M.CalcDistance(temp_pos.x, temp_pos.y, temp_pos0.x, temp_pos0.y)
                if temp_dis ~= 0.0 then
                    local temp_value = (temp_pos.x - temp_pos0.x) / temp_dis
                    if (temp_pos.y - temp_pos0.y) > 0.0 then
                        temp_pos.angle = math.acos(temp_value)
                    else
                        temp_pos.angle = -math.acos(temp_value)
                    end
                else
                    temp_pos.angle = 1.0
                end
            else
                temp_pos.angle = 1.0
            end
            table.insert(trace_vector, temp_pos)
            temp_pos_pre.x = temp_pos.x
            temp_pos_pre.y = temp_pos.y
            temp_pos_pre.angle = temp_pos.angle
            temp_pos0.x = temp_pos.x
            temp_pos0.y = temp_pos.y
        end
        t = t + 0.00001
    end
    return trace_vector
end
-- 建立圆圈
function _M.BuildCircle(center_x, center_y, radius, fish_pos, fish_count)
    assert(fish_count > 0, "")
    if (fish_count <= 0) then
        return
    end
    local cell_radian = 2 * math.pi / fish_count
    for i = 1, fish_count do
        local temp_pos = {}
        temp_pos.x = center_x + radius * math.cos(i * cell_radian)
        temp_pos.y = center_y + radius * math.sin(i * cell_radian)
        table.insert(fish_pos, temp_pos)
    end
    return fish_pos
end

-- 建立圆圈（角度）
function _M.BuildCircle_A(center_x, center_y, radius, fish_pos, fish_count, rotate, rotate_speed)
    if fish_count <= 0 then
        return
    end
    local cell_radian = 2 * math.pi / fish_count
    local last_pos = {}
    for i = 1, fish_count do
        last_pos.x = center_x + radius * math.cos((i - 1) * cell_radian + rotate - rotate_speed)
        last_pos.y = center_y + radius * math.sin((i - 1) * cell_radian + rotate - rotate_speed)
        fish_pos[i].x = center_x + radius * math.cos((i - 1) * cell_radian + rotate)
        fish_pos[i].y = center_y + radius * math.sin((i - 1) * cell_radian + rotate)
        local temp_dis = _M.CalcDistance(fish_pos[i].x, fish_pos[i].y, last_pos.x, last_pos.y)
        if temp_dis ~= 0.0 then
            local temp_value = (fish_pos[i].x - last_pos.x) / temp_dis
            if (fish_pos[i].y - last_pos.y) >= 0.0 then
                fish_pos[i].angle = math.acos(temp_value)
            else
                fish_pos[i].angle = -math.acos(temp_value)
            end
        else
            fish_pos[i].angle = math.pi / 2
        end
    end
    return fish_pos
end

function _M.IsAngle(start_pos, end_pos)
    if cc.pGetDistance(start_pos, end_pos) == 0 then
        return 0
    end
    local degress = 0
    if end_pos.x == start_pos.x then
        if end_pos.y > start_pos.y then
            degress = math.pi / 2
        end
        if end_pos.x < start_pos.y then
            degress = -math.pi / 2
        end
    else
        local ftan
        if end_pos.x < start_pos.x then
            ftan = -(end_pos.y - start_pos.y) / (end_pos.x - start_pos.x)
        else
            ftan = (end_pos.y - start_pos.y) / (end_pos.x - start_pos.x)
        end
        -- 弧度
        degress = math.atan(ftan)
    end
    -- 转角度
    if end_pos.x < start_pos.x then
        degress = degress / math.pi * 180
        degress = degress + 180
    elseif end_pos.x > start_pos.x then
        degress = degress / math.pi * -180
    elseif end_pos.x == start_pos.x then
        degress = _M.CalcAngle(start_pos.x, start_pos.y, end_pos.x, end_pos.y)
        degress = degress / math.pi * 180
        degress = degress - 90
    end
    return degress
end

function _M.GetCurrentBeiJingTime()
    return os.time()
end

function _M.GetBeiJingTime()
    return GameUtil.getSystemTime()
end

return _M
-- endregion
