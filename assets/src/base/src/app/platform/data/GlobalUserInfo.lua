--[[
	客户端玩家自己信息
]] cc.exports.globalUserInfo = {}

globalUserInfo.wMasterOrder = 0 -- 管理等级

globalUserInfo.goldList = {}

-- 基本资料
globalUserInfo.dwUserID = 0 -- 用户 I D
globalUserInfo.dwGameID = 0 -- 游戏 I D

globalUserInfo.wTableID = GameDefine.INVALID_TABLE -- 桌子id
globalUserInfo.wChairID = GameDefine.INVALID_CHAIR -- 椅子索引
globalUserInfo.cbUserStatus = GameDefine.US_NULL -- 用户状态
globalUserInfo.headimgurl = "" -- 头像地址

globalUserInfo.dwUserMedal = nil -- 用户奖牌
globalUserInfo.dwExperience = nil -- 用户经验
globalUserInfo.dwLoveLiness = nil -- 用户魅力
globalUserInfo.dwSpreaderID = nil -- 推广ID
globalUserInfo.szAccounts = nil -- 登录帐号
globalUserInfo.szNickName = nil -- 用户昵称
globalUserInfo.szPassword = nil -- 登录密码
globalUserInfo.szDynamicPass = nil -- 动态密码
globalUserInfo.szLogonIP = nil -- 登录IP
globalUserInfo.szUserChannel = nil -- 渠道号

-- 用户成绩
globalUserInfo.lUserScore = 0 -- 用户游戏币
globalUserInfo.lUserInsure = 0 -- 银行游戏币
globalUserInfo.dwRoomCard = 0 -- 用户房卡(A卡)
globalUserInfo.dwRoomCard_reward = 0 -- 奖励房卡(B卡)
globalUserInfo.dwRoomCard_experience = 0 -- 体验房卡
globalUserInfo.lGrade = 0 -- 用户成绩
globalUserInfo.lTempScore = 0 -- 临时保留分数
globalUserInfo.dwWinCount = 0 -- 胜利盘数
globalUserInfo.dwLostCount = 0 -- 失败盘数
globalUserInfo.dwDrawCount = 0 -- 和局盘数					
globalUserInfo.dwFleeCount = 0 -- 逃跑盘数
globalUserInfo.dwUserMedal = 0 -- 用户奖牌
globalUserInfo.dwExperience = 0 -- 用户经验
globalUserInfo.lLoveLiness = 0 -- 用户魅力

-- 扩展资料
globalUserInfo.cbGender = nil -- 用户性别
globalUserInfo.cbMoorMachine = nil -- 锁定机器
globalUserInfo.szUnderWrite = nil -- 个性签名
-- 社团资料
globalUserInfo.dwGroupID = nil -- 社团索引
globalUserInfo.szGroupName = nil -- 社团名字
-- 会员资料
globalUserInfo.cbMemberOrder = nil -- 会员等级
globalUserInfo.MemberOverDate = nil -- 到期时间
-- 头像信息
globalUserInfo.wFaceID = nil -- 头像索引
globalUserInfo.dwCustomID = nil -- 自定标识
globalUserInfo.CustomFaceInfo = nil -- 自定头像
globalUserInfo.szHeadHttp = nil -- http头像
-- 配置信息
globalUserInfo.cbInsureEnabled = nil -- 银行使能
globalUserInfo.cbHidePay = 0 -- 充值显示或隐藏 1 隐藏 0 显示
-- 扩展资料
-- 用户信息
globalUserInfo.szCompellation = nil -- 资料中的真实名字
globalUserInfo.szMobilePhone = nil -- 资料中的 移动电话
globalUserInfo.szPassPortID = nil -- 资料中的个人真实身份证号
globalUserInfo.szQQ = nil -- 资料中的Q Q 号码 或者微信号
globalUserInfo.szWeixin = nil -- 资料中的微信号

globalUserInfo.szUserNote = nil -- 用户说明
-- 电话号码
globalUserInfo.szSeatPhone = nil -- 固定电话
-- 联系资料
globalUserInfo.szEMail = nil -- 电子邮件
globalUserInfo.szDwellingPlace = nil -- 联系地址

-- 银行信息
globalUserInfo.wRevenueTake = nil -- 税收比例
globalUserInfo.wRevenueTransfer = nil -- 税收比例
globalUserInfo.wRevenueTransferMember = nil -- 税收比例
globalUserInfo.wServerID = nil -- 房间标识
globalUserInfo.lUserScore = nil -- 用户游戏币
globalUserInfo.lUserInsure = nil -- 银行游戏币
globalUserInfo.lTransferPrerequisite = nil -- 转帐条件
globalUserInfo.wBankPassType = nil -- 银行密码类型 密码标识（0、没有密码，1、数字密码。2、手势密码）

globalUserInfo.lFamilyExpTotal = 0 -- 个人家族总贡献值
globalUserInfo.lFamilyExpUsed = 0 -- 个人家族已经使用的贡献值

globalUserInfo.isBindWX = false -- 是否绑定微信（只在游客和账号注册的模式下使用）
globalUserInfo.szRegisterMobile = nil -- 绑定的手机号码，如果为空则是没有绑定

globalUserInfo.cbRegType = nil

globalUserInfo.isBindAccount = false -- 是否绑定登录账户 

function globalUserInfo:updateUserState(wTableID, wChairID, cbUserStatus)
    self.wTableID = wTableID
    self.wChairID = wChairID
    self.cbUserStatus = cbUserStatus
end

function globalUserInfo:getMeClientChairID()
    return self.wChairID + 1
end

function globalUserInfo:getMeServerChairID()
    return self.wChairID
end

function globalUserInfo:updateUserScore(data, bUpdateScore)
    if bUpdateScore == true then
        self.lUserScore = data.lScore -- 用户游戏币
    end

    self.lUserInsure = data.lInsure -- 银行游戏币
    self.dwRoomCard = data.dwRoomCard -- 用户房卡
    self.dwRoomCard_reward = data.dwRoomCard_reward -- 奖励房卡
    self.dwRoomCard_experience = data.dwRoomCard_experience -- 体验房卡
    self.lGrade = data.lGrade -- 用户成绩
    self.lTempScore = data.lTempScore -- 临时保留分数

    self.dwWinCount = data.dwWinCount -- 胜利盘数
    self.dwLostCount = data.dwLostCount -- 失败盘数
    self.dwDrawCount = data.dwDrawCount -- 和局盘数					
    self.dwFleeCount = data.dwFleeCount -- 逃跑盘数
    self.dwUserMedal = data.dwUserMedal -- 用户奖牌
    self.dwExperience = data.dwExperience -- 用户经验
    self.lLoveLiness = data.lLoveLiness -- 用户魅力

end

-- 更新金币
function globalUserInfo:updateScore(lUserScore, lInsure)
    if lUserScore ~= nil then
        self.lUserScore = lUserScore
    end

    if lInsure ~= nil then
        self.lUserInsure = lInsure
    end
end
-- 更新房卡
function globalUserInfo:updateRoomCard(dwRoomCard)
    self.dwRoomCard = dwRoomCard
end

function globalUserInfo:updateRoomCard2(dwRoomCard_1, dwRoomCard_2)
    self.dwRoomCard = dwRoomCard_1
    self.dwRoomCard_reward = dwRoomCard_2
end

-- 更新银行金币
function globalUserInfo:updateBankScore(lInsure)
    self.lUserInsure = lInsure
end

function globalUserInfo:resetUserInfo()
    self.goldList = {}
    self.dwUserID = 0 -- 用户 I D
    self.dwGameID = 0 -- 游戏 I D
    self.wTableID = GameDefine.INVALID_TABLE -- 桌子id
    self.wChairID = GameDefine.INVALID_CHAIR -- 椅子索引
    self.cbUserStatus = GameDefine.US_NULL -- 用户状态
    self.headimgurl = "" -- 头像地址

    self.dwUserMedal = nil -- 用户奖牌
    self.dwExperience = nil -- 用户经验
    self.dwLoveLiness = nil -- 用户魅力
    self.dwSpreaderID = nil -- 推广ID
    self.szAccounts = nil -- 登录帐号
    self.szNickName = nil -- 用户昵称
    self.szPassword = nil -- 登录密码
    self.szDynamicPass = nil -- 动态密码
    self.szLogonIP = nil -- 登录IP
    self.szUserChannel = nil -- 渠道号

    -- 用户成绩
    self.lUserScore = 0 -- 用户游戏币
    self.lUserInsure = 0 -- 银行游戏币
    self.dwRoomCard = 0 -- 用户房卡(A卡)
    self.dwRoomCard_reward = 0 -- 奖励房卡(B卡)
    self.dwRoomCard_experience = 0 -- 体验房卡
    self.lGrade = 0 -- 用户成绩
    self.lTempScore = 0 -- 临时保留分数
    self.dwWinCount = 0 -- 胜利盘数
    self.dwLostCount = 0 -- 失败盘数
    self.dwDrawCount = 0 -- 和局盘数					
    self.dwFleeCount = 0 -- 逃跑盘数
    self.dwUserMedal = 0 -- 用户奖牌
    self.dwExperience = 0 -- 用户经验
    self.lLoveLiness = 0 -- 用户魅力

    -- 扩展资料
    self.cbGender = nil -- 用户性别
    self.cbMoorMachine = nil -- 锁定机器
    self.szUnderWrite = nil -- 个性签名
    -- 社团资料
    self.dwGroupID = nil -- 社团索引
    self.szGroupName = nil -- 社团名字
    -- 会员资料
    self.cbMemberOrder = nil -- 会员等级
    self.MemberOverDate = nil -- 到期时间
    -- 头像信息
    self.wFaceID = nil -- 头像索引
    self.dwCustomID = nil -- 自定标识
    self.CustomFaceInfo = nil -- 自定头像
    self.szHeadHttp = nil -- http头像
    -- 配置信息
    self.cbInsureEnabled = nil -- 银行使能
    self.cbHidePay = 0 -- 充值显示或隐藏 1 隐藏 0 显示
    -- 扩展资料
    -- 用户信息
    self.szUserNote = nil -- 用户说明
    self.szCompellation = nil -- 真实名字
    -- 电话号码
    self.szSeatPhone = nil -- 固定电话
    self.szMobilePhone = nil -- 移动电话
    -- 联系资料
    self.szQQ = nil -- Q Q 号码
    self.szWeixin = nil
    self.szEMail = nil -- 电子邮件
    self.szDwellingPlace = nil -- 联系地址

    -- 银行信息
    self.wRevenueTake = nil -- 税收比例
    self.wRevenueTransfer = nil -- 税收比例
    self.wRevenueTransferMember = nil -- 税收比例
    self.wServerID = nil -- 房间标识
    self.lUserScore = nil -- 用户游戏币
    self.lUserInsure = nil -- 银行游戏币
    self.lTransferPrerequisite = nil -- 转帐条件
    self.wBankPassType = nil -- 银行密码类型
    self.lFamilyExpTotal = 0 -- 个人家族总贡献值
    self.lFamilyExpUsed = 0 -- 个人家族已经使用的贡献值
    self.isBindWX = false

    self.szRegisterMobile = nil -- 绑定的手机号码，如果为空则是没有绑定
    self.personCardID = nil -- 个人真实身份证号

    self.cbRegType = nil
end

