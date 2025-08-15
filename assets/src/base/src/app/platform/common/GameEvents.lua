cc.exports.game = game or {}

game.eventHandlers = {}

-- 方法是否在执行中 none/runing
game.execEventState = "none"
-- 添加事件的队列
game.eventChangeQueue = {}

function game.registerEvent(ev, func)
    if game.execEventState == "none" then
        if game.eventHandlers[ev] == nil then
            game.eventHandlers[ev] = {}
        end

        local t = game.eventHandlers[ev]
        t[#t + 1] = {
            fun = func,
            valid = true
        }
    else
        table.insert(game.eventChangeQueue, {"add", ev, func})
    end
end

function game.unregisterEvent(ev, func)
    local t = game.eventHandlers[ev]

    if t then
        for i, v in ipairs(t) do
            if v.fun == func then
                if game.execEventState == "none" then
                    t[i] = t[#t]
                    t[#t] = nil
                else
                    table.insert(game.eventChangeQueue, {"del", ev, func})
                    v.valid = false
                end
                break
            end
        end
    end

    if t ~= nil and #t == 0 then
        game.eventHandlers[ev] = nil
    end
end

function game.sendEvent(ev, ...)
    game.execEventState = "runing"

    local t = game.eventHandlers[ev]

    if t then
        for _, v in ipairs(t) do
            if v.valid then
                v.fun(...)
            end
        end
    end

    game.execEventState = "none"

    while #game.eventChangeQueue ~= 0 do
        local info = game.eventChangeQueue[1]

        if info[1] == "add" then
            if ev == info[2] then
                info[3](...)
            end
            game.registerEvent(info[2], info[3])
        elseif info[1] == "del" then
            game.unregisterEvent(info[2], info[3])
        end

        table.remove(game.eventChangeQueue, 1)
    end
end
