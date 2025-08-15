--[[
	桌子类
]] local _M = {}

function _M.createTable(wTableID, wChairCount)
    local tableInfo = {}

    -- 桌子标志
    tableInfo.cbTableLock = 0 -- 锁定标志
    tableInfo.cbPlayStatus = 0 -- 游戏标志
    tableInfo.cbTableGameLock = 0 -- 游戏被桌主锁定标志
    -- 桌子状态
    tableInfo.m_wOwnerID = GameDefine.INVALID_CHAIR -- 桌主
    tableInfo.szRoomID = "" -- 房间号
    -- 属性变量
    tableInfo.wTableID = wTableID -- 桌子号码
    tableInfo.wChairCount = wChairCount -- 椅子数目
    tableInfo.gameUserList = {} -- 用户信息

    -- 桌子附加属性（特殊游戏）
    tableInfo.gameRule = {} -- 游戏规则
    tableInfo.tableRule = {} -- 桌子规则

    -- 添加玩家
    function tableInfo:addTableUser(gameUser)
        table.insert(self.gameUserList, gameUser)
    end

    -- 删除玩家
    function tableInfo:removeTableUser(gameUser)
        local index = GameDefine.INVALID_CARD
        for key, var in pairs(self.gameUserList) do
            if var.dwUserID == gameUser.dwUserID then
                index = key
                break
            end
        end

        if index ~= GameDefine.INVALID_CARD then
            table.remove(self.gameUserList, index)
        end
    end

    -- 获取空椅子
    function tableInfo:getNullChairCount()
        local count = self.wChairCount - #self.gameUserList
        if count < 0 then
            count = 0
        end
        return count
    end

    function tableInfo:isSitDown(dwUserID)
        for k, v in pairs(self.gameUserList) do
            if v.dwUserID == dwUserID then
                return true
            end
        end

        return false
    end

    -- 更新桌子状态
    function tableInfo:updateStatue(wTableID, cbTableLock, cbPlayStatus, cbTableGameLock, m_wOwnerID, szRoomID)
        if self.wTableID == wTableID then
            self.cbTableLock = cbTableLock
            self.cbPlayStatus = cbPlayStatus
            self.cbTableGameLock = cbTableGameLock
            self.m_wOwnerID = m_wOwnerID
            self.szRoomID = szRoomID
        end
    end

    -- 更新桌子附加属性
    function tableInfo:updateTableGameRule(gameRule)
        if self.wTableID == gameRule.wTableID then
            self.gameRule = gameRule
        end
    end

    -- 更新桌子附加属性
    function tableInfo:updateTableRule(tableRule)
        if self.wTableID == tableRule.wTableID then
            self.tableRule = tableRule
        end
    end

    return tableInfo
end

return _M
