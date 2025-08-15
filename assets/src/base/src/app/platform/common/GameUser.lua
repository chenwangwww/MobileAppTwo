--[[
	游戏玩家类
]] local _M = {}

function _M.createGameUser()
    local gameUser = {}

    gameUser.szNickName = "" -- 昵称
    gameUser.ip = "" -- ip
    gameUser.avatarURL = "" -- 头像地址

    -- 用户属性
    gameUser.dwGameID = 0 -- 游戏 I D
    gameUser.dwUserID = 0 -- 用户 I D
    gameUser.dwGroupID = 0 -- 社团 I D

    -- 头像信息
    gameUser.wFaceID = 0 -- 头像索引
    gameUser.dwCustomID = 0 -- 自定标识

    -- 用户属性
    gameUser.cbGender = 0 -- 用户性别  0:男，1:女
    gameUser.cbMemberOrder = 0 -- 会员等级
    gameUser.cbMasterOrder = 0 -- 管理等级

    -- 用户状态
    gameUser.wTableID = 0 -- 桌子索引
    gameUser.wChairID = 0 -- 椅子索引
    gameUser.cbUserStatus = GameDefine.US_NULL -- 用户状态

    -- 积分信息
    gameUser.lScore = 0 -- 用户分数
    gameUser.lGrade = 0 -- 用户成绩
    gameUser.lInsure = 0 -- 用户银行
    gameUser.lTempScore = 0 -- 临时保留分数
    gameUser.dwRoomCard = 0 -- 用户房卡
    gameUser.dwRoomCard_reward = 0 -- 奖励房卡
    gameUser.dwRoomCard_experience = 0 -- 体验房卡

    -- 游戏信息
    gameUser.dwWinCount = 0 -- 胜利盘数
    gameUser.dwLostCount = 0 -- 失败盘数
    gameUser.dwDrawCount = 0 -- 和局盘数
    gameUser.dwFleeCount = 0 -- 逃跑盘数
    gameUser.dwUserMedal = 0 -- 用户奖牌
    gameUser.dwExperience = 0 -- 用户经验
    gameUser.lLoveLiness = 0 -- 用户魅力

    function gameUser:updateUserStatus(wTableID, wChairID, cbUserStatus)
        self.wTableID = wTableID
        self.wChairID = wChairID
        self.cbUserStatus = cbUserStatus
    end

    function gameUser:updateUserScore(data)
        self.lScore = data.lScore -- 用户分数
        self.lGrade = data.lGrade -- 用户成绩
        self.lInsure = data.lInsure -- 用户银行
        self.lTempScore = data.lTempScore -- 临时保留分数
        self.dwWinCount = data.dwWinCount -- 胜利盘数
        self.dwLostCount = data.dwLostCount -- 失败盘数                                                                          
        self.dwDrawCount = data.dwDrawCount -- 和局盘数
        self.dwFleeCount = data.dwFleeCount -- 逃跑盘数
        self.dwUserMedal = data.dwUserMedal -- 用户奖牌
        self.dwExperience = data.dwExperience -- 用户经验
        self.lLoveLiness = data.lLoveLiness -- 用户魅力
        self.dwRoomCard = data.dwRoomCard -- 用户房卡
        self.dwRoomCard_reward = data.dwRoomCard_reward -- 奖励房卡
        self.dwRoomCard_experience = data.dwRoomCard_experience -- 体验房卡
    end

    return gameUser
end

return _M
