local _M = {}

local listenerAssetsManager = nil
local am = nil

function _M.delUpdate()
    if am ~= nil then
        am:release()
        if listenerAssetsManager ~= nil then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(listenerAssetsManager)
        end
        am = nil
        return true
    end
    return false
end

function _M.checkUpdate(lcoalManifest, path, isCheckMainVersion, onError, onProgress, onComplete)
    _M.delUpdate()
    listenerAssetsManager = nil
    am = cc.AssetsManagerEx:create(lcoalManifest, path)
    am:setMaxConcurrentTask(1)
    am:retain()

    local function onLoadEnd()
        _M.delUpdate()
    end

    local function onUpdateEvent(event)
        local eventCode = event:getEventCode()
        print("下载事件 == " .. eventCode)
        if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
            print("No local manifest file found, skip assets update.")
            -- onLoadEnd()
            if onError ~= nil and type(onError) == "function" then
                onError(cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
            local assetId = event:getAssetId()
            local percent = event:getPercent()
            local maxCount = event:getMaxAssetCount()
            local currDownLoadIndex = event:getCurrDwonloadIndex()
            if onProgress ~= nil and type(onProgress) == "function" then
                if assetId ~= cc.AssetsManagerExStatic.VERSION_ID and assetId ~= cc.AssetsManagerExStatic.MANIFEST_ID then
                    onProgress(percent, maxCount, currDownLoadIndex)
                end
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
            print("Fail to download manifest file, update skipped.")
            onLoadEnd()
            if onError ~= nil and type(onError) == "function" then
                onError(cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
            print("Update finished.")
            onLoadEnd()
            if onComplete ~= nil and type(onComplete) == "function" then
                onComplete(eventCode)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE then
            print("版本是最新 不需要更新")
            onLoadEnd()
            if onComplete ~= nil and type(onComplete) == "function" then
                onComplete(eventCode)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
            -- 更新错误
            print("更新错误")
            onLoadEnd()
            if onError ~= nil and type(onError) == "function" then
                onError(cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED then
            -- 更新失败
            print("更新失败")
            onLoadEnd()
            if onError ~= nil and type(onError) == "function" then
                onError(cc.EventAssetsManagerEx.EventCode.UPDATE_FAILED)
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND then
            -- 发现新版本
            print("cc.EventAssetsManagerEx.EventCode.NEW_VERSION_FOUND")
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ASSET_UPDATED then
            -- 资源更新
            print("cc.EventAssetsManagerEx.EventCode.ASSET_UPDATED")
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DECOMPRESS then
            print("cc.EventAssetsManagerEx.EventCode.ERROR_DECOMPRESS")
        end
    end

    listenerAssetsManager = cc.EventListenerAssetsManagerEx:create(am, onUpdateEvent)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listenerAssetsManager, 1)
    am:update()
end

return _M

-- endregion
