-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local Logger = {};

local WRITE_LOG_TO_FILE = false

function Logger:new(Logger)
    local obj = {}
    setmetatable(obj, {
        __index = Logger
    })
    return obj
end

function Logger:print(...)
    local arg = {...}
    self:LogInfo(arg)
end

function Logger:getStackInfo(info)
    local format = "/"
    if USE_PASS_MODE then
        format = "%u"
    end
    --[[
	local t_index = getLastIndex(info.source,format)
    local t_len = string.len(info.source)
    local className = string.sub(info.source,t_index+1,t_len)]] --
    local t_stackInfo = info.source .. ":" .. info.currentline
    local tab = os.date("*t", time)
    local t_string = "[" .. tab.month .. "/" .. tab.day .. " " .. tab.hour .. ":" .. tab.min .. ":" .. tab.sec .. " " .. t_stackInfo .. "] "
    return t_string
end

function Logger:LogInfo(arg)
    -- local arg = {...}
    local tab = os.date("*t", time)
    local t_string = self:getStackInfo(debug.getinfo(3, "Sln"))
    -- print("165"..t_string)
    for i, v in pairs(arg) do
        t_string = t_string .. tostring(v) .. " "
    end
    print(t_string)
    if WRITE_LOG_TO_FILE then
        t_string = t_string .. "\n"
        -- local file = io.open("/mnt/sdcard/FoltLog.log","a")
        local file = io.open("C:/log.txt", "a")
        assert(file)
        file:write(t_string)
        file:close()
        return
    end
end

return Logger;

-- endregion
