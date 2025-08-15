cc.exports.function_switch = cc.exports.function_switch or {}

function_switch.datas_ = {
    ["chat.red_packet"] = true,
    ["chat.red_packet_jielong"] = true,
    ["chat.yuezhan"] = true
}

function function_switch.getDataList()
    return function_switch.datas_
end

function function_switch.switch(key, isOpen)
    function_switch.datas_[key] = isOpen
end

function function_switch.switchAll(isOpen)
    for k, v in pairs(function_switch.datas_) do
        function_switch.datas_[k] = isOpen
    end
end

function function_switch.isOpen(key)
    return function_switch.datas_[key]
end

return _M
