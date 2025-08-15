require("cocos/cocos2d/json")
require("cocos/network/NetworkConstants")

local HttpUtils = {}
local HttpUtilsInitChk = false
local HttpRequestList = {}
local HttpSeqNo = 0

local function insertRequest(requestdata)
    table.insert(HttpRequestList, requestdata)
    HttpUtils.initTimeOut()
end

local function deleteRequest(posIndex)
    table.remove(HttpRequestList, posIndex)
end

function HttpUtils.initTimeOut()
    if HttpUtilsInitChk == false then
        HttpUtils.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
            for i = #HttpRequestList, 1, -1 do
                if os.difftime(os.time(), HttpRequestList[i].time) >= HttpRequestList[i].diffTime and HttpRequestList[i].RequestObj.DeleteChk == false then
                    HttpRequestList[i].RequestObj:unregisterScriptHandler()
                    HttpRequestList[i].callback(false, nil)
                    deleteRequest(i)
                elseif HttpRequestList[i].RequestObj.DeleteChk == true then
                    deleteRequest(i)
                end
            end

            if #HttpRequestList == 0 then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(HttpUtils.schedulerID)
                HttpUtilsInitChk = false
            end
        end, 1, false)
        HttpUtilsInitChk = true
    end
end

function HttpUtils.GetJsonByPost(url, paramastr, time, callback)

    local xhr = cc.XMLHttpRequest:new()

    xhr.DeleteChk = false
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- xhr:setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xhr:open("POST", url)
    local function loginCallback()
        print("xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response = xhr.response
            if type(callback) == "function" then
                callback(true, response)
            end
        else
            if type(callback) == "function" then
                callback(false, nil)
            end
        end
        xhr.DeleteChk = true
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(loginCallback)
    xhr:send(paramastr)

    if time == nil then
        time = 30
    end
    HttpSeqNo = HttpSeqNo + 1
    local requestdata = {}
    requestdata.HttpSeqNo = HttpSeqNo
    requestdata.RequestObj = xhr
    requestdata.time = os.time()
    requestdata.diffTime = time
    requestdata.callback = callback
    insertRequest(requestdata)

end

function HttpUtils.GetJsonByGet(url, paramastr, time, callback)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xhr.DeleteChk = false
    local reqstr = url .. "?" .. paramastr
    xhr:open("GET", reqstr)

    local function onReadyStateChange() -- 请求响应函数  
        print("xhr.readyState is:", xhr.readyState, "xhr.status is: ", xhr.status)
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response = xhr.response
            if type(callback) == "function" then
                callback(true, response)
            end
        else
            if type(callback) == "function" then
                callback(false, nil)
            end
        end

        xhr.DeleteChk = true
        xhr:unregisterScriptHandler()
    end

    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send()

    if time == nil then
        time = 10
    end
    HttpSeqNo = HttpSeqNo + 1
    local requestdata = {}
    requestdata.HttpSeqNo = HttpSeqNo
    requestdata.RequestObj = xhr
    requestdata.time = os.time()
    requestdata.diffTime = time
    requestdata.callback = callback

    insertRequest(requestdata)
end

return HttpUtils
