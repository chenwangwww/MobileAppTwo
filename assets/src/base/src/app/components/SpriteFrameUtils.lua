local _M = {}

local _cache = cc.SpriteFrameCache:getInstance()
local _fileUtils = cc.FileUtils:getInstance()

function _M.addSpriteFrames(plist, textureFileName)
    if not _cache:isSpriteFramesWithFileLoaded(plist) then
        if textureFileName == nil then
            _cache:addSpriteFrames(plist)
        else
            _cache:addSpriteFrames(plist, textureFileName)
        end
    end
end

function _M.removeSpriteFrames(plist)
    if _cache:isSpriteFramesWithFileLoaded(plist) then
        _cache:removeSpriteFramesFromFile(plist)
    end
end

-- isSpriteFrame nil 需要先在路径中查找，如果没有就在序列帧中查找  true 序列帧 false, 源文件
function _M.newSprite(imgPath, isSpriteFrame, x, y, params)
    if isSpriteFrame == nil then
        if _cache:getSpriteFrame(imgPath) then
            isSpriteFrame = true
        else
            isSpriteFrame = false
        end
    end

    if isSpriteFrame == true then
        return display.newSprite("#" .. imgPath, x, y, params)
    else
        return display.newSprite(imgPath, x, y, params)
    end
end

return _M
