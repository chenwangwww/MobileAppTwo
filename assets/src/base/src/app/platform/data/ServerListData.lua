--[[
	房间数据
]] cc.exports.ServerListData = {}

local _gameServerMap = {}
local _gameKindMap = {}
local _gameTypeMap = {}

local _currGameServerMap = {} -- 临时房间列表（在刷新时用）
local _currGameKindMap = {} -- 临时游戏类型列表（在刷新时用）
local _currGameTypeMap = {} -- 临时游戏类型列表（在刷新时用）

-- 电玩城游戏列表映射
function ServerListData.getCoinGameMap()
    local coinGameList = ServerListData.getGameListByJoinID(GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER)
    if coinGameList == nil then
        coinGameList = {}
    end

    local tMap = {}
    for key, var in pairs(coinGameList) do
        tMap[var.wKindID] = var
    end
    return tMap
end

function ServerListData.getGameKindData()
    return _gameKindMap
end

function ServerListData.getGameTypeData()
    return _gameTypeMap
end

-- 根据SortID排序
local function sortBySortID(item1, item2)
    if item1.wSortID < item2.wSortID then
        return true
    else
        return false
    end
end

-- 根据OnLineCount排序
local function sortByOnLineCount(item1, item2)
    if item1.dwOnLineCount < item2.dwOnLineCount then
        return true
    else
        return false
    end
end

local function insertGameKind(kindMap, gameKind)
    local bExsit = false
    for k, v in pairs(kindMap) do
        if v.wKindID == gameKind.wKindID then
            kindMap[k] = gameKind
            bExsit = true
            break
        end
    end
    if not bExsit then
        table.insert(kindMap, gameKind)
    end
    table.sort(kindMap, sortBySortID)
end

local function insertGameServer(serverMap, gameServer)
    -- debugLog(debugLogType,"insertGameServer gameServer.wServerID"..gameServer.wServerID)
    local bExsit = false
    for k, v in pairs(serverMap) do
        if v.wServerID == gameServer.wServerID then
            serverMap[k] = gameServer
            bExsit = true
            break
        end
    end
    if not bExsit then
        table.insert(serverMap, gameServer)
    end

    table.sort(serverMap, sortBySortID)
end

local function insertGameType(typeMap, gameType)
    local bExsit = false
    for k, v in pairs(typeMap) do
        if v.wTypeID == gameType.wTypeID then
            typeMap[k] = gameType
            bExsit = true
            break
        end
    end
    if not bExsit then
        table.insert(typeMap, gameType)
    end

    table.sort(typeMap, sortBySortID)
end

function ServerListData.readGameTypeListKind(d)
    local count = 0
    while (d:isNextRead()) do
        count = count + 1
        local tagGameType = {}
        tagGameType.wJoinID = d:readUInt16()
        tagGameType.wSortID = d:readUInt16()
        tagGameType.wTypeID = d:readUInt16()
        tagGameType.szTypeName = d:readUString(64)

        --       printLog("ServerListData","readGameTypeListKind:tagGameType.wSortID == "..tagGameType.wSortID .."  tagGameType.wTypeID == "..tagGameType.wTypeID.."  tagGameType.szTypeName =="..tagGameType.szTypeName)

        insertGameType(_currGameTypeMap, tagGameType)
    end
end

function ServerListData.readGameListKind(d)
    -- debugLog(debugLogType,"readGameListKind...")
    local count = 0
    while (d:isNextRead()) do
        count = count + 1
        -- debugLog(debugLogType,"start read readGameListKind   count =="..count)
        local tagGameKind = {}
        tagGameKind.wTypeID = d:readUInt16() -- 类型索引
        tagGameKind.wJoinID = d:readUInt16() -- 挂接索引
        tagGameKind.wSortID = d:readUInt16() -- 排序索引
        tagGameKind.wKindID = d:readUInt16() -- 类型索引
        tagGameKind.wGameID = d:readUInt16() -- 模块索引
        tagGameKind.dwOnLineCount = d:readUInt32() -- 在线人数
        tagGameKind.dwFullCount = d:readUInt32() -- 满员人数
        tagGameKind.szKindName = d:readUString(64) -- 游戏名字
        tagGameKind.szProcessName = d:readUString(64) -- 进程名字

        if PlazaManager.tIsGameShowMap[tagGameKind.wKindID] then
            insertGameKind(_currGameKindMap, tagGameKind)
            --[[
            printLog("ServerListData",
                "readGameListKind  tagGameKind.wTypeID = " .. tagGameKind.wTypeID .. " tagGameKind.wKindID = " .. tagGameKind.wKindID .. " tagGameKind.szKindName = " .. tagGameKind.szKindName)
            -- ]]
        end
    end
end

function ServerListData.readGameServer(d)
    local count = 0
    while (d:isNextRead()) do
        count = count + 1
        local tagGameServer = {}
        tagGameServer.wKindID = d:readUInt16() -- 名称索引
        tagGameServer.wNodeID = d:readUInt16() -- 节点索引
        tagGameServer.wSortID = d:readUInt16() -- 排序索引
        tagGameServer.wServerID = d:readUInt16() -- 房间索引
        tagGameServer.wServerPort = d:readUInt16() -- 房间端口
        tagGameServer.dwOnLineCount = d:readUInt32() -- 在线人数
        tagGameServer.dwFullCount = d:readUInt32() -- 满员人数
        tagGameServer.szServerAddr = d:readUString(64) -- 服务地址
        tagGameServer.szServerName = d:readUString(64) -- 房间名称

        tagGameServer.szGateAddr = {}
        for i = 1, 20 do
            local gateAddr = d:readUString(32) -- 服务地址
            table.insert(tagGameServer.szGateAddr, gateAddr)
        end

        tagGameServer.szGateAddr1 = {}
        for i = 1, 20 do
            local gateAddr1 = d:readUString(32) -- 备用地址1
            table.insert(tagGameServer.szGateAddr1, gateAddr1)
        end

        tagGameServer.szGateAddr2 = {}
        for i = 1, 20 do
            local gateAddr2 = d:readUString(32) -- 备用地址2
            table.insert(tagGameServer.szGateAddr2, gateAddr2)
        end

        tagGameServer.wGatePort = {}
        for i = 1, 20 do
            local gatePort = d:readUInt16() -- 房间端口
            table.insert(tagGameServer.wGatePort, gatePort)
        end

        tagGameServer.bUseGateServer = d:readUInt8() == 1 -- 使用网关

        -- 私人房添加
        tagGameServer.dwSurportType = d:readUInt32() -- 支持类型
        tagGameServer.wTableCount = d:readUInt16() -- 桌子数目
        tagGameServer.wServerType = d:readUInt16() -- 房间类型

        tagGameServer.lCellScore = d:readInt64() -- 单元积分
        tagGameServer.lMinEnterScore = d:readInt64() -- 进入房间最低积分
        tagGameServer.lMaxEnterScore = d:readInt64() -- 进入房间最高积分
        tagGameServer.lMaxUserPerTable = d:readUInt32() -- 每桌最大人数

        if PlazaManager.tIsGameShowMap[tagGameServer.wKindID] then
            insertGameServer(_currGameServerMap, tagGameServer)
            --[[
            printLog("ServerListData",
                "readGameServer  tagGameServer.wKindID = " .. tagGameServer.wKindID .. " tagGameServer.wServerID = " .. tagGameServer.wServerID .. " tagGameServer.szServerAddr = " ..
                    tagGameServer.szServerAddr .. "  tagGameServer.szServerName = " .. tagGameServer.szServerName)
            -- ]]
        end
    end
end

function ServerListData.readGameServerFinish(isAll)
    if isAll == true then
        _gameServerMap = _currGameServerMap
        _gameKindMap = _currGameKindMap
        _gameTypeMap = _currGameTypeMap
        _currGameServerMap = {}
        _currGameKindMap = {}
        _currGameTypeMap = {}
    else
        for i = 1, #_currGameTypeMap do
            insertGameType(_gameTypeMap, _currGameTypeMap[i])
        end

        for i = 1, #_currGameKindMap do
            insertGameKind(_gameKindMap, _currGameKindMap[i])
        end

        for i = 1, #_currGameKindMap do
            for j = #_gameServerMap, 1, -1 do
                if _gameServerMap[j].wKindID == _currGameKindMap[i].wKindID then
                    table.remove(_gameServerMap, j)
                end
            end
        end

        for i = 1, #_currGameServerMap do
            insertGameServer(_gameServerMap, _currGameServerMap[i])
        end

        _currGameServerMap = {}
        _currGameKindMap = {}
        _currGameTypeMap = {}
    end

    if PlazaManager.isCheck then
        ServerListData.addIPV6Address()
    end
end

-- 点击创建房间时查询更新服务器
function ServerListData.readAndUpdataGameServer(d)
    local tagGameServer = {}
    tagGameServer.wKindID = d:readUInt16() -- 名称索引
    tagGameServer.wNodeID = d:readUInt16() -- 节点索引
    tagGameServer.wSortID = d:readUInt16() -- 排序索引
    tagGameServer.wServerID = d:readUInt16() -- 房间索引
    tagGameServer.wServerPort = d:readUInt16() -- 房间端口
    tagGameServer.dwOnLineCount = d:readUInt32() -- 在线人数
    tagGameServer.dwFullCount = d:readUInt32() -- 满员人数
    tagGameServer.szServerAddr = d:readUString(64) -- 服务地址
    tagGameServer.szServerName = d:readUString(64) -- 房间名称

    tagGameServer.szGateAddr = {}
    for i = 1, 20 do
        local gateAddr = d:readUString(32) -- 服务地址
        table.insert(tagGameServer.szGateAddr, gateAddr)
    end

    tagGameServer.szGateAddr1 = {}
    for i = 1, 20 do
        local gateAddr1 = d:readUString(32) -- 备用地址1
        table.insert(tagGameServer.szGateAddr1, gateAddr1)
    end

    tagGameServer.szGateAddr2 = {}
    for i = 1, 20 do
        local gateAddr2 = d:readUString(32) -- 备用地址2
        table.insert(tagGameServer.szGateAddr2, gateAddr2)
    end

    tagGameServer.wGatePort = {}
    for i = 1, 20 do
        local gatePort = d:readUInt16() -- 房间端口
        table.insert(tagGameServer.wGatePort, gatePort)
    end

    tagGameServer.bUseGateServer = d:readUInt8() == 1 -- 使用网关

    -- 私人房添加
    tagGameServer.dwSurportType = d:readUInt32() -- 支持类型
    tagGameServer.wTableCount = d:readUInt16() -- 桌子数目
    tagGameServer.wServerType = d:readUInt16() -- 房间类型

    tagGameServer.lCellScore = d:readInt64() -- 单元积分
    tagGameServer.lMinEnterScore = d:readInt64() -- 进入房间最低积分
    tagGameServer.lMaxEnterScore = d:readInt64() -- 进入房间最高积分
    tagGameServer.lMaxUserPerTable = d:readUInt32() -- 每桌最大人数

    insertGameServer(_gameServerMap, tagGameServer)
    --    printLog("ServerListData","readAndUpdataGameServer  tagGameServer.wKindID = "..tagGameServer.wKindID.." tagGameServer.wServerID = "..tagGameServer.wServerID.." tagGameServer.szServerAddr = "..tagGameServer.szServerAddr .."  tagGameServer.szServerName = "..tagGameServer.szServerName)

    return tagGameServer
end

function ServerListData.getGameServerByServerID(wServerID)
    for k, v in pairs(_gameServerMap) do
        if v.wServerID == wServerID then
            return v
        end
    end
    return nil
end

function ServerListData.getGameServerByKindID(wKindID)
    local gameServers = {}
    for k, v in pairs(_gameServerMap) do
        if v.wKindID == wKindID then
            table.insert(gameServers, v)
        end
    end
    return gameServers
end

function ServerListData.getGameByKindID(wKindID)
    local gameInfo = nil
    for k, v in pairs(_gameKindMap) do
        if v.wKindID == wKindID then
            gameInfo = v
            break
        end
    end

    return gameInfo
end

-- 获取大厅游戏列表根据TypeID
-- function ServerListData.getRoomGameKindByTypeID(wTypeID)
function ServerListData.getRoomGameListByTypeID(wTypeID)
    local gameKinds = {}
    if wTypeID == -1 then
        for k, v in pairs(_gameKindMap) do
            if (bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_ROOM) > 0 or bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS) > 0) then
                table.insert(gameKinds, v)
            end
        end
    else
        for k, v in pairs(_gameKindMap) do
            if bit.band(v.wTypeID, wTypeID) > 0 and (bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_ROOM) > 0 or bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_PERSONAL_CHIPS) > 0) then
                table.insert(gameKinds, v)
            end
        end
    end
    return gameKinds
end

-- 获取金币大厅游戏列表根据TypeID
function ServerListData.getGoalHallGameListByTypeID(wTypeID)
    local gameKinds = {}
    if wTypeID == -1 then
        for k, v in pairs(_gameKindMap) do
            if bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_GOLD) > 0 then
                table.insert(gameKinds, v)
            end
        end
    else
        for k, v in pairs(_gameKindMap) do
            if bit.band(v.wTypeID, wTypeID) > 0 and bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_GOLD) > 0 then
                table.insert(gameKinds, v)
            end
        end
    end
    return gameKinds
end

-- 获取视频大厅游戏列表根据TypeID
function ServerListData.getTVHallGameListByTypeID(wTypeID)
    local gameKinds = {}
    if wTypeID == -1 then
        for k, v in pairs(_gameKindMap) do
            if bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_VIDEO) > 0 then
                table.insert(gameKinds, v)
            end
        end
    else
        for k, v in pairs(_gameKindMap) do
            if bit.band(v.wTypeID, wTypeID) > 0 and bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_VIDEO) > 0 then
                table.insert(gameKinds, v)
            end
        end
    end
    return gameKinds
end

-- 获取游戏列表根据JoinID
-- function ServerListData.getRoomGameKindByJoinID(wJoinID)
function ServerListData.getGameListByJoinID(wJoinID)
    if type(wJoinID) ~= "number" then
        return {}
    end

    if wJoinID == -1 then
        return _gameKindMap
    end
    local gameKinds = {}
    for k, v in pairs(_gameKindMap) do
        if bit.band(v.wJoinID, wJoinID) > 0 then
            table.insert(gameKinds, v)
        end
    end

    return gameKinds
end

-- 获得大厅游戏列表（金币大厅类型和电玩城类型）
function ServerListData.getGameListOnMain()
    local gameKinds = {}
    PlazaManager.hotShowGameData = nil
    for k, v in pairs(_gameKindMap) do
        if bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_GOLD) > 0 or bit.band(v.wJoinID, GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER) > 0 then
            if v.wGameID == 1011 then -- 跳高高显示到左边显眼位置
                PlazaManager.hotShowGameData = v
            else
                table.insert(gameKinds, v)
            end
        end
    end
    return gameKinds
end

-- 获得在线人数最少的房间
function ServerListData.getOnLineMinServerByKindID(wKindID)
    local gameServers = {}
    for i, v in ipairs(_gameServerMap) do
        if v.wKindID == wKindID and (v.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_ROOM or v.wServerType == GameDefine.GAME_TYPE.GAME_GENRE_GAME_CENTER) then
            table.insert(gameServers, v)
        end
    end

    if #gameServers > 0 then
        table.sort(gameServers, sortByOnLineCount)
        return gameServers[1]
    end

    return nil
end

-- 每个游戏加一个域名登录  审核专用
function ServerListData.addIPV6Address()
    for key, var in ipairs(_gameServerMap) do
        for key1, var1 in ipairs(var.wGatePort) do
            if var1 ~= 0 then
                -- if tonumber(var1) >= 60000 then
                var.szGateAddr[key1] = "login01.daqi78.net"
                -- end
            end
        end
    end
end

function ServerListData.getNameByKindID(kindID)
    if kindID == nil then
        return ""
    end

    if type(kindID) ~= "number" then
        return ""
    end

    for key, var in pairs(_gameKindMap) do
        if var.wKindID == kindID then
            return var.szKindName
        end
    end
    return ""
end
