--[[
	房间类
]] local _M = {}

local GameTable = require("app.platform.common.GameTable")

function _M.configGameServer(data, wServerID, dwOnLineCount)
    local gameServer = {}

    gameServer.tableCount = data.tableCount -- 桌子数目
    gameServer.chairCount = data.chairCount -- 椅子数目
    gameServer.servetType = data.servetType -- 房间类型
    gameServer.serverRule = data.serverRule -- 房间规则
    gameServer.lCellScore = data.lCellScore -- 单元金币
    gameServer.lMinEnterScore = data.lMinEnterScore -- 进入房间最低金币
    gameServer.lMaxEnterScore = data.lMaxEnterScore -- 进入房间最高金币
    gameServer.lMaxUserPerTable = data.lMaxUserPerTable -- 每桌最大人数

    gameServer.totalChairCount = gameServer.tableCount * gameServer.chairCount -- 总椅子数
    gameServer.totalUserCount = 0 -- 总玩家数
    gameServer.dwOnLineCount = dwOnLineCount -- 服务器端传递过来的在线人数
    gameServer.dwOnLineDiffCount = 0 -- 服务器端传递过来的在线人数和客服端统计的总玩家数的差值
    gameServer.gameTableList = {}
    gameServer.gameUserList = {}
    gameServer.wServerID = wServerID

    -- 创建桌子
    for i = 1, gameServer.tableCount do
        local gameTable = GameTable.createTable(i - 1, gameServer.chairCount)
        table.insert(gameServer.gameTableList, gameTable)
    end

    -- 获取桌子
    function gameServer:getTableByTableID(wTableID)
        for key, var in pairs(gameServer.gameTableList) do
            if var.wTableID == wTableID then
                return var
            end
        end
        return nil
    end

    -- 获取玩家
    function gameServer:getUserByUserID(dwUserID)
        for key, var in pairs(self.gameUserList) do
            if var.dwUserID == dwUserID then
                return var
            end
        end
        return nil
    end

    -- 玩家进入房间
    function gameServer:enterRoom(gameUser)
        -- 添加玩家列表
        -- self.gameUserList[gameUser.dwUserID] = gameUser       
        self:exitRoom(gameUser.dwUserID)

        table.insert(self.gameUserList, gameUser)
        gameServer.totalUserCount = gameServer.totalUserCount + 1

        -- 判断玩家是否有桌子
        if gameUser.wTableID ~= GameDefine.INVALID_TABLE then
            local gametable = self:getTableByTableID(gameUser.wTableID)
            if gametable ~= nil then
                gametable:addTableUser(gameUser)
            end
        else
            game.sendEvent(GameDefine.GoalSeverTotalChange)
        end
    end

    -- 玩家离开房间
    function gameServer:exitRoom(dwUserID)
        local gameUser = self:getUserByUserID(dwUserID)
        if gameUser == nil then
            -- printError("exitRoom error:gameUser=nil dwUserID"..dwUserID)
            return
        end

        -- 删除桌子上的玩家
        local gametable = self:getTableByTableID(gameUser.wTableID)
        if gametable ~= nil then
            gametable:removeTableUser(gameUser)
        end

        -- 删除列表中的玩家
        -- self.gameUserList[gameUser.dwUserID] = nil
        local index = -1
        for key, var in pairs(self.gameUserList) do
            if var.dwUserID == gameUser.dwUserID then
                index = key
                break
            end
        end

        if index ~= -1 then
            table.remove(self.gameUserList, index)
            gameServer.totalUserCount = gameServer.totalUserCount - 1
        end

        -- 删除玩家
        gameUser = nil
    end

    -- 玩家状态改变
    function gameServer:updateUserStatus(dwUserID, wTableID, wChairID, cbUserStatus)
        -- 查找玩家
        local gameUser = self:getUserByUserID(dwUserID)
        if gameUser == nil then
            printError("gameServer:updateUserStatus error : dwUserID = " .. dwUserID)
            return
        end

        -- 站起状态
        if cbUserStatus == GameDefine.US_FREE or cbUserStatus == GameDefine.US_NULL then
            local gametable = self:getTableByTableID(gameUser.wTableID)
            if gametable ~= nil then
                gametable:removeTableUser(gameUser)
            end
        end

        local oldTableID = gameUser.wTableID
        local newTableID = wTableID

        -- 更新玩家状态
        gameUser:updateUserStatus(wTableID, wChairID, cbUserStatus)

        -- 坐下状态
        if cbUserStatus == GameDefine.US_SIT then
            local _gametable = self:getTableByTableID(wTableID)
            if _gametable ~= nil and _gametable:isSitDown(dwUserID) == false then
                _gametable:addTableUser(gameUser)
            end
        elseif cbUserStatus == GameDefine.US_READY then -- 准备状态 加入桌子中
            local _gametable = self:getTableByTableID(wTableID)
            if _gametable ~= nil then
                local isSitDown = _gametable:isSitDown(dwUserID)
                if isSitDown == false then
                    _gametable:addTableUser(gameUser)
                end
            end
        elseif cbUserStatus == GameDefine.US_LOOKON then
            printLog("GameServer", "旁观状态")
        elseif cbUserStatus == GameDefine.US_PLAYING then
            printLog("GameServer", "游戏状态")
            local _gametable = self:getTableByTableID(wTableID)
            if _gametable ~= nil then
                local isSitDown = _gametable:isSitDown(dwUserID)
                if isSitDown == false then
                    _gametable:addTableUser(gameUser)
                end
            end
        elseif cbUserStatus == GameDefine.US_OFFLINE then
            printLog("GameServer", "掉线状态")
        elseif cbUserStatus == GameDefine.US_NULL then -- 玩家离开服务器
            self:exitRoom(dwUserID)
        end

        if oldTableID ~= GameDefine.INVALID_CHAIR then
            game.sendEvent(GameDefine.GoalSeverTableChange, oldTableID)
        elseif oldTableID ~= newTableID and newTableID ~= GameDefine.INVALID_CHAIR then
            game.sendEvent(GameDefine.GoalSeverTableChange, newTableID)
        end
        game.sendEvent(GameDefine.GoalSeverTotalChange)
        return gameUser
    end

    -- 更新桌子信息
    function gameServer:updateTableInfo(tableData)

        self.tableCount = tableData.wTableCount
        self.totalChairCount = self.tableCount * self.chairCount

        for i = 1, self.tableCount do
            local tableinfo = tableData.TableStatusArray[i]

            self.gameTableList[i]:updateStatue(i - 1, tableinfo.cbTableLock, tableinfo.cbPlayStatus, tableinfo.cbTableGameLock, tableinfo.m_wOwnerID, tableinfo.szRoomID)
        end
        game.sendEvent(GameDefine.GoalSeverTotalChange)
    end

    -- 更新桌子状态
    function gameServer:updateTableStatue(tableinfo)
        for i = 1, self.tableCount do
            local tableData = self.gameTableList[i]
            if tableData.wTableID == tableinfo.wTableID then
                tableData:updateStatue(tableinfo.wTableID, tableinfo.cbTableLock, tableinfo.cbPlayStatus, tableinfo.cbTableGameLock, tableinfo.m_wOwnerID, tableinfo.szRoomID)
                game.sendEvent(GameDefine.GoalSeverTableChange, tableinfo.wTableID)
                game.sendEvent(GameDefine.GoalSeverTotalChange)
                return
            end
        end
    end

    -- 更新桌子属性
    function gameServer:updateTableGameRule(gameRule)
        local table_info = self:getTableByTableID(gameRule.wTableID)
        if table_info ~= nil then
            table_info:updateTableGameRule(gameRule)
            game.sendEvent(GameDefine.TableGameRuleChange, gameRule)
        end
    end

    -- 更新桌子属性
    function gameServer:updateTableRule(tableRule)
        local table_info = self:getTableByTableID(tableRule.wTableID)
        if table_info ~= nil then
            table_info:updateTableRule(tableRule)
            game.sendEvent(GameDefine.TableRuleChange, tableRule)
        end
    end

    return gameServer
end

return _M
