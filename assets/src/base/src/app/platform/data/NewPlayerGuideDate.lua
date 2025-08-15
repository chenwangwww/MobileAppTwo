local newPlayerGuideDate = {}

function newPlayerGuideDate:getGameRoomData()
    local gameServerList = {}

    local tagGameServer = {}
    tagGameServer.wKindID = 7
    tagGameServer.wNodeID = 2001
    tagGameServer.wSortID = 1
    tagGameServer.wServerID = 6001
    tagGameServer.dwOnLineCount = 123
    tagGameServer.dwFullCount = 240
    tagGameServer.szServerName = "十三水-学徒房"
    tagGameServer.wTableCount = 60 -- 桌子数目
    tagGameServer.lCellScore = 500
    tagGameServer.lMinEnterScore = 25000
    tagGameServer.lMaxEnterScore = 500000
    tagGameServer.lMaxUserPerTable = 4
    table.insert(gameServerList, tagGameServer)

    local tagGameServer = {}
    tagGameServer.wKindID = 7
    tagGameServer.wNodeID = 4001
    tagGameServer.wSortID = 2
    tagGameServer.wServerID = 6002
    tagGameServer.dwOnLineCount = 155
    tagGameServer.dwFullCount = 240
    tagGameServer.szServerName = "十三水-精英房"
    tagGameServer.wTableCount = 60 -- 桌子数目
    tagGameServer.lCellScore = 2000
    tagGameServer.lMinEnterScore = 100000
    tagGameServer.lMaxEnterScore = 1000000
    tagGameServer.lMaxUserPerTable = 4
    table.insert(gameServerList, tagGameServer)

    return gameServerList
end

function newPlayerGuideDate:getGameRoomListData_server()
    local tagGameServer = {}
    tagGameServer.wKindID = 7
    tagGameServer.wNodeID = 2001
    tagGameServer.wSortID = 1
    tagGameServer.wServerID = 6001
    tagGameServer.dwOnLineCount = 123
    tagGameServer.dwFullCount = 240
    tagGameServer.szServerName = "十三水-学徒房"
    tagGameServer.wTableCount = 60 -- 桌子数目
    tagGameServer.lCellScore = 500
    tagGameServer.lMinEnterScore = 25000
    tagGameServer.lMaxEnterScore = 500000
    tagGameServer.lMaxUserPerTable = 4

    return tagGameServer
end

function newPlayerGuideDate:getGameRoomListData_RoomList()
    local roomListData = {}
    roomListData.tableCount = 20
    roomListData.tableList = {}

    for i = 1, 20 do
        local tableInfo = {}
        tableInfo.cbTableLock = 0 -- 锁定标志
        tableInfo.cbPlayStatus = 1 -- 游戏标志
        tableInfo.cbTableGameLock = 0 -- 游戏被桌主锁定标志
        -- 桌子状态
        tableInfo.m_wOwnerID = GameDefine.INVALID_CHAIR -- 桌主
        tableInfo.szRoomID = tostring(666666 + i) -- 房间号
        -- 属性变量
        tableInfo.wTableID = i -- 桌子号码
        tableInfo.wChairCount = 4 -- 椅子数目
        tableInfo.gameUserList = {1, 2, 3, 4} -- 用户信息
        table.insert(roomListData.tableList, tableInfo)
    end

    return roomListData
end
function newPlayerGuideDate:GameScen_IniGameRoomData()
    PlazaManager.curGameType = GameDefine.GAME_TYPE.GAME_GENRE_GOLD
    PlazaManager.getGoalRoomInfo().szRoomID = "789654"
    PlazaManager.getGoalRoomInfo().RoomGrade = GameDefine.GameRoomType.FirstType
    PlazaManager.getGoalRoomInfo().lCellScore = 500 -- 单元金币
    PlazaManager.getGoalRoomInfo().lMinEnterScore = 25000 -- 进入房间最低金币
    PlazaManager.getGoalRoomInfo().lMaxEnterScore = 1000000 -- 进入房间最高金币
    PlazaManager.getGoalRoomInfo().lMaxUserPerTable = 4 -- 每桌最大人数

    PlazaManager.gameStatus.cbGameStatus = GameDefine.GAME_STATUS_FREE
    PlazaManager.curKindID = 7
end

function newPlayerGuideDate:GameScen_ResetGameRoomData()
    PlazaManager.curGameType = 0
    PlazaManager.getGoalRoomInfo().szRoomID = ""
    PlazaManager.getGoalRoomInfo().RoomGrade = 0
    PlazaManager.getGoalRoomInfo().lCellScore = 0 -- 单元金币
    PlazaManager.getGoalRoomInfo().lMinEnterScore = 0 -- 进入房间最低金币
    PlazaManager.getGoalRoomInfo().lMaxEnterScore = 0 -- 进入房间最高金币
    PlazaManager.getGoalRoomInfo().lMaxUserPerTable = 0 -- 每桌最大人数

    PlazaManager.gameStatus.cbGameStatus = 0
    PlazaManager.curKindID = 0
end
function newPlayerGuideDate:getGameScen_UserList()
    local userList = {}
    local gameUser = {}
    gameUser.szNickName = globalUserInfo.szNickName -- 昵称
    gameUser.avatarURL = globalUserInfo.headimgurl -- 头像地址
    gameUser.dwGameID = globalUserInfo.dwGameID -- 游戏 I D
    gameUser.dwUserID = globalUserInfo.dwUserID -- 用户 I D
    gameUser.cbGender = globalUserInfo.cbGender -- 用户性别  0:男，1:女
    gameUser.wTableID = 65 -- 桌子索引
    gameUser.wChairID = 0 -- 椅子索引
    gameUser.cbUserStatus = GameDefine.US_SIT -- 用户状态
    gameUser.lScore = globalUserInfo.lUserScore -- 用户分数
    gameUser.dwRoomCard = globalUserInfo.dwRoomCard -- 用户房卡
    globalUserInfo.wTableID = 65
    globalUserInfo.wChairID = 0
    table.insert(userList, gameUser)

    local gameUser = {}
    gameUser.szNickName = "心动女生" -- 昵称
    gameUser.avatarURL = "icon_6.png" -- 头像地址
    gameUser.dwGameID = 1000352 -- 游戏 I D
    gameUser.dwUserID = 1952 -- 用户 I D
    gameUser.cbGender = 1 -- 用户性别  0:男，1:女
    gameUser.wTableID = 65 -- 桌子索引
    gameUser.wChairID = 1 -- 椅子索引
    gameUser.cbUserStatus = GameDefine.US_READY -- 用户状态
    gameUser.lScore = 150000 -- 用户分数
    gameUser.dwRoomCard = 10 -- 用户房卡
    table.insert(userList, gameUser)

    local gameUser = {}
    gameUser.szNickName = "爱笑女孩" -- 昵称
    gameUser.avatarURL = "icon_7.png" -- 头像地址
    gameUser.dwGameID = 1000353 -- 游戏 I D
    gameUser.dwUserID = 1953 -- 用户 I D
    gameUser.cbGender = 1 -- 用户性别  0:男，1:女
    gameUser.wTableID = 65 -- 桌子索引
    gameUser.wChairID = 2 -- 椅子索引
    gameUser.cbUserStatus = GameDefine.US_READY -- 用户状态
    gameUser.lScore = 255000 -- 用户分数
    gameUser.dwRoomCard = 10 -- 用户房卡
    table.insert(userList, gameUser)

    local gameUser = {}
    gameUser.szNickName = "独孤大侠" -- 昵称
    gameUser.avatarURL = "icon_3.png" -- 头像地址
    gameUser.dwGameID = 1000354 -- 游戏 I D
    gameUser.dwUserID = 1954 -- 用户 I D
    gameUser.cbGender = 0 -- 用户性别  0:男，1:女
    gameUser.wTableID = 65 -- 桌子索引
    gameUser.wChairID = 3 -- 椅子索引
    gameUser.cbUserStatus = GameDefine.US_READY -- 用户状态
    gameUser.lScore = 305000 -- 用户分数
    gameUser.dwRoomCard = 10 -- 用户房卡
    table.insert(userList, gameUser)

    return userList
end

function newPlayerGuideDate:getGameScen_GameStart()
    local startGameData = {}
    startGameData.cbCardData = {0x2c, 0x0c, 0x1a, 0x3d, 0x0d, 0x35, 0x05, 0x02, 0x38, 0x28, 0x18, 0x39, 0x29}

    startGameData.cbSpecialType = 255
    startGameData.wBankerUser = 65535
    startGameData.cbComboCount = 3
    startGameData.CardCombo = {}

    local cardComboData_1 = {}
    cardComboData_1.cbFirstPart = {0x2c, 0x0c, 0x1a}
    cardComboData_1.cbSecondPart = {0x3d, 0x0d, 0x35, 0x05, 0x02}
    cardComboData_1.cbThirdPart = {0x38, 0x28, 0x18, 0x39, 0x29}
    cardComboData_1.cbFirstPartType = 2 -- 1对子
    cardComboData_1.cbSecondPartType = 3 -- 2对子
    cardComboData_1.cbThirdPartType = 7 -- 葫芦
    cardComboData_1.cbExtraFirstShui = 0
    cardComboData_1.cbExtraSecondShui = 0
    cardComboData_1.cbExtraThirdShui = 0
    startGameData.CardCombo[1] = cardComboData_1

    local cardComboData_2 = {}
    cardComboData_2.cbFirstPart = {0x2c, 0x0c, 0x1a}
    cardComboData_2.cbSecondPart = {0x3d, 0x0d, 0x39, 0x29, 0x02}
    cardComboData_2.cbThirdPart = {0x38, 0x28, 0x18, 0x35, 0x05}
    cardComboData_2.cbFirstPartType = 2 -- 1对子
    cardComboData_2.cbSecondPartType = 3 -- 2对子
    cardComboData_2.cbThirdPartType = 7 -- 葫芦
    cardComboData_2.cbExtraFirstShui = 0
    cardComboData_2.cbExtraSecondShui = 0
    cardComboData_2.cbExtraThirdShui = 0
    startGameData.CardCombo[2] = cardComboData_2

    local cardComboData_3 = {}
    cardComboData_3.cbFirstPart = {0x3d, 0x0d, 0x1a}
    cardComboData_3.cbSecondPart = {0x2c, 0x0c, 0x39, 0x29, 0x02}
    cardComboData_3.cbThirdPart = {0x38, 0x28, 0x18, 0x35, 0x05}
    cardComboData_3.cbFirstPartType = 2 -- 1对子
    cardComboData_3.cbSecondPartType = 3 -- 2对子
    cardComboData_3.cbThirdPartType = 7 -- 葫芦
    cardComboData_3.cbExtraFirstShui = 0
    cardComboData_3.cbExtraSecondShui = 0
    cardComboData_3.cbExtraThirdShui = 0
    startGameData.CardCombo[3] = cardComboData_3

    startGameData.cbShowCardTime = 32

    return startGameData
end

function newPlayerGuideDate:getGameScen_GameEnd()
    local params = {}

    -- 玩家牌数据
    params.cbCardData = {{0x3d, 0x0d, 0x1a, 0x2c, 0x0c, 0x39, 0x29, 0x02, 0x38, 0x28, 0x18, 0x35, 0x05}, {0x21, 0x0a, 0x19, 0x17, 0x07, 0x15, 0x04, 0x23, 0x3d, 0x3b, 0x3a, 0x36, 0x32},
                         {0x1d, 0x08, 0x27, 0x3b, 0x0b, 0x24, 0x14, 0x26, 0x31, 0x01, 0x13, 0x03, 0x12}, {0x1c, 0x2a, 0x09, 0x2b, 0x1b, 0x16, 0x06, 0x37, 0x11, 0x22, 0x33, 0x34, 0x25}}

    -- 游戏结束的方式 0:正常结束 1:解散结束
    params.cbEndType = 0

    -- 玩家的特殊牌型  255:无效牌型(普通)   或者  具体的数字表示具体的特殊牌型
    params.cbSpecialType = {255, 255, 255, 255}

    -- 特殊牌型的单元分水数
    params.lSpecialScore = {0, 0, 0, 0}

    -- 玩家每道牌牌型(除非是特殊牌型,则每道牌牌型为 0)
    params.personPartStyle = {{2, 3, 7}, {1, 2, 6}, {1, 3, 3}, {1, 3, 5}}

    -- 比牌数据  即. 每道比较顺序，特殊牌型不比较，特殊牌型座位号为-1 【3】【4】:每一道，比较的座位号
    params.personPartComperSeq = {{3, 2, 1, 0}, {1, 2, 3, 0}, {2, 3, 1, 0}}

    -- 玩家每墩的总水数
    params.personPartScole = {{3, 3, 3}, {1, -3, 1}, {-1, -1, -3}, {-3, 1, -1}}

    -- 玩家两两之间每墩的比较结果
    params.lPartCmpScore = {{{0, 0, 0}, {1, 1, 1}, {1, 1, 1}, {1, 1, 1}}, {{-1, -1, -1}, {0, 0, 0}, {1, -1, 1}, {1, -1, 1}}, {{-1, -1, -1}, {-1, 1, -1}, {0, 0, 0}, {1, -1, -1}},
                            {{-1, -1, -1}, {-1, 1, -1}, {-1, 1, 1}, {0, 0, 0}}}

    -- 玩家每道牌型的额外分
    params.personPartExtraScore = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}

    -- 玩家两两之间每墩的比较结果额外分
    params.lPartCmpExScore = {{{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}, {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
                              {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}}}

    -- 玩家总水数
    params.personTotalScole = {36, -10, -14, -12}

    -- 全垒打用户
    params.personAllShootUser = 0

    -- 全垒打得分
    params.lThreeKillResult = {18, 0, 0, 0}

    -- 总打枪数量  
    params.shootDataCount = 3
    -- 打枪开枪者 (具体有效值长度根据 总打枪数量)
    params.shootPerson1 = {0, 0, 0, 255, 255, 255}

    -- 打枪中枪者 (具体有效值长度根据 总打枪数量)
    params.shootPerson2 = {1, 2, 3, 255, 255, 255}

    -- 庄家用户座位
    params.wBankerUser = 255

    return params

end

return newPlayerGuideDate
