--[[
	常量类
]] cc.exports.GameDefine = {}

-- 是否测试版本
-- 测试版本  ip:GameDefine.loginIp_test
GameDefine.isTestGame = false
GameDefine.bIsTestUI = false
GameDefine.bIsLocalTest = false -- 无服务器本地单机模式测试
GameDefine.bIsLocalSkipGameList = false -- 本地测试是否忽略gamelist.json更新

GameDefine.playerHostIPStr = nil
GameDefine.hostlists = {}

GameDefine.loginIp = {"47.242.120.134", "47.242.120.134", "47.242.120.134"}
GameDefine.loginPort = {7500, 7501, 7502, 7503, 7504, 7505}
GameDefine.IPGroupCount = 4
GameDefine.ConfineIPList = {} -- 通道IP过滤

-- 测试服务器地址

GameDefine.loginIp_test = {"47.242.120.134"}
GameDefine.loginPort_test = {7500}

-- 审核版本ip
GameDefine.loginIp_check = {"47.242.120.134", "47.242.120.134"}
GameDefine.loginPort_check = {8300, 8301, 8302, 61300, 61301, 61302}

-- 配置文件更新地址 每个平台配置文件单独 方便后期控制
GameDefine.platformUpdateUrl = {
    ["android"] = "http://47.242.120.134:8108/r8yl/gameres/assets/android/app/gamelist1.json",
    ["ios"] = "https://47.242.120.134:9108/r8yl/gameres/assets/ios/app/gamelist2.json"
}

-- 更新地址
GameDefine.updateAddress = ""

GameDefine.uploadUrl = ""
GameDefine.tongjiUrl = ""
GameDefine.searchUrl = ""

-- 更新推送token地址
GameDefine.updateIosPushToken = ""

-- 分享地址
GameDefine.shareAddress = ""

-- 字体
GameDefine.FontName = "fonts/fzz.ttf"

GameDefine.FontColor = cc.c3b(0xbc, 0xde, 0xff)
GameDefine.FontColor_edit = cc.c3b(0x5c, 0x75, 0x8e)
GameDefine.FontCoinColor = cc.c3b(0xd5, 0xc7, 0x61)
GameDefine.NameColor = cc.c3b(0xe4, 0xd6, 0xb6)

GameDefine.PanelRect1 = cc.rect(15, 15, 176, 618)
GameDefine.PanelRect2 = cc.rect(15, 15, 2, 2)
GameDefine.PanelRect3 = cc.rect(3, 3, 2, 2)

-- 网络连接时间 (审核30  正常10)
GameDefine.waitTime = 30

-- 网络处理时间
GameDefine.processTime = 15

-- 网络连接时间
GameDefine.connectTime = 15

-- 消息类型掩码
GameDefine.SMT_CHAT = 0x0001 -- 聊天消息
GameDefine.SMT_EJECT = 0x0002 -- 弹出消息
GameDefine.SMT_GLOBAL = 0x0004 -- 全局消息
GameDefine.SMT_PROMPT = 0x0008 -- 提示消息
GameDefine.SMT_TABLE_ROLL = 0x0010 -- 滚动消息

-- 消息控制掩码
GameDefine.SMT_CLOSE_ROOM = 0x0100 -- 关闭房间
GameDefine.SMT_CLOSE_GAME = 0x0200 -- 关闭游戏
GameDefine.SMT_CLOSE_LINK = 0x0400 -- 中断连接

-- 用户状态
GameDefine.US_NULL = 0x00 -- 没有状态
GameDefine.US_FREE = 0x01 -- 站立状态
GameDefine.US_SIT = 0x02 -- 坐下状态
GameDefine.US_READY = 0x03 -- 同意状态
GameDefine.US_LOOKON = 0x04 -- 旁观状态
GameDefine.US_PLAYING = 0x05 -- 游戏状态
GameDefine.US_OFFLINE = 0x06 -- 断线状态
GameDefine.US_NOCHIP = 0x07 -- 筹码输光状态

-- 游戏状态
GameDefine.GAME_STATUS_FREE = 0 -- 空闲状态
GameDefine.GAME_STATUS_PLAY = 100 -- 游戏状态
GameDefine.GAME_STATUS_WAIT = 200 -- 等待状态
GameDefine.GAME_STATUS_END = 900 -- 总结束状态

-- 游戏桌子状态
GameDefine.GAME_TableSTATUS_FREE = 0 -- 空闲状态
GameDefine.GAME_TableSTATUS_PLAY = 1 -- 游戏状态

-- 参数定义
GameDefine.INVALID_CHAIR = 0xFFFF -- 无效椅子
GameDefine.INVALID_TABLE = 0xFFFF -- 无效桌子
GameDefine.INVALID_CARD = 0xFFFF -- 无效牌
GameDefine.MAX_CHAIR = 100 -- 最大椅子数
GameDefine.MAX_TABLE = 512 -- 最大桌子数

-- 性别定义
GameDefine.GENDER_FEMALE = 2 -- 女性性别
GameDefine.GENDER_MANKIND = 1 -- 男性性别

-- 数据长度
GameDefine.LEN_MD5 = 33 -- 加密密码
GameDefine.LEN_USERNOTE = 32 -- 备注长度
GameDefine.LEN_ACCOUNTS = 32 -- 帐号长度
GameDefine.LEN_NICKNAME = 32 -- 昵称长度
GameDefine.LEN_PASSWORD = 33 -- 密码长度
GameDefine.LEN_GROUP_NAME = 32 -- 社团名字
GameDefine.LEN_UNDER_WRITE = 32 -- 社团名字
GameDefine.LEN_QQ = 16 -- Q Q 号码
GameDefine.LEN_WEIXIN = 33 -- 微信号码
GameDefine.LEN_EMAIL = 33 -- 电子邮件
GameDefine.LEN_USER_NOTE = 256 -- 用户备注
GameDefine.LEN_SEAT_PHONE = 33 -- 固定电话
GameDefine.LEN_MOBILE_PHONE = 16 -- 移动电话 12==>16
GameDefine.LEN_PASS_PORT_ID = 19 -- 证件号码
GameDefine.LEN_COMPELLATION = 16 -- 真实名字
GameDefine.LEN_DWELLING_PLACE = 128 -- 联系地址
GameDefine.LEN_HEADIMGURL = 164 -- 头像地址
GameDefine.LEN_ERROR_INFO = 260 -- 错误信息

-- 机器标识
GameDefine.LEN_NETWORK_ID = 13 -- 网卡长度
GameDefine.LEN_MACHINE_ID = 33 -- 序列长度

-- 列表数据
GameDefine.LEN_TYPE = 32 -- 种类长度
GameDefine.LEN_KIND = 32 -- 类型长度
GameDefine.LEN_NODE = 32 -- 节点长度
GameDefine.LEN_PAGE = 32 -- 定制长度
GameDefine.LEN_SERVER = 32 -- 房间长度
GameDefine.LEN_PROCESS = 32 -- 进程长度

GameDefine.PERSONAL_ROOM_CHAIR = 8 -- 私人房间座子上椅子的最大数目

-- socket标识
GameDefine.LOGIN_SOCKET = "LOGIN_SOCKET"
GameDefine.GAME_SOCKET = "GAME_SOCKET"
GameDefine.REFRESH_SOCKET = "REFRESH_SOCKET"

-- module标识
GameDefine.LOGIN_MODULE = "LoginModule"
GameDefine.GAME_MODULE = "ServerModule"
GameDefine.REFRESH_MODULE = "RefreshModule"

-- 登录方式   0：游客登录  1：微信登录  2：账号登录  3：qq登录  4：手机登录
GameDefine.LOGIN_TYPE = {
    YK = 0,
    WEIXIN = 1,
    ACCOUNT = 2,
    QQ = 3,
    PHONE = 4
}

GameDefine.HALL_LAYER_INDEX = {
    HALL = 1, -- 大厅
    GOLD_ROOM = 2, -- 金币房间列表
    GOALHALL = 21, -- 金币大厅
    FAMILY = 3, -- 家族
    BATTLE = 4, -- 对战
    ROOMCARD = 5, -- 房卡
    COIN = 6, -- 电玩城
    COIN_GAME = 7, -- 电玩城对应的游戏房间
    ROOMLIST = 8, -- 房间列表
    GOALHALL_ROOMLIST = 9, -- 金币大厅房间列表
    TVHALL = 10, -- 视频大厅
    GOALHALL_ROOM = 11 -- 金币大厅房间
}

-- 1、个人贡献排行 2、家族排行 3、金币排行
GameDefine.RANK_TYPE = {
    USER = 1,
    FAMILY = 2,
    COIN = 3
}

-- 游戏模式
GameDefine.GAME_TYPE = {
    GAME_GENRE_GOLD = 0x0001, -- 金币类型
    GAME_GENRE_SCORE = 0x0002, -- 点值类型
    GAME_GENRE_MATCH = 0x0004, -- 比赛类型
    GAME_GENRE_EDUCATE = 0x0008, -- 训练类型
    GAME_GENRE_ROOM = 0x0010, -- 约战类型
    GAME_GENRE_PERSONAL_CHIPS = 0x0020, -- 约战筹码类型（坐下分配筹码，输光旁观）
    GAME_GENRE_GAME_CENTER = 0x0040, -- 电玩城类型（金币类型、防作弊模式自动分配座位）
    GAME_GENRE_VIDEO = 0x0080 -- 视频游戏类型
}

-- 游戏kindID列表
GameDefine.GAME_KINDID = {
    JDNN = 27,
    HZMJ = 310,
    DDZ = 26,
    SQGD = 50,
    TBNN = 28,
    CDD = 602,
    HPSK = 20,
    SHZ = 203,
    JLDB = 204,
    HANGZMJ = 312
}

-- 游戏更新状态
GameDefine.GAME_UPDATE_STATUE = {
    ERROR = 0, -- 出错
    NORMAL = 1, -- 正常
    UPDATE = 2, -- 更新
    NeverDownloaded = 4 -- 从未更新过
}

-- 设备类型
GameDefine.DEVICE_TYPE = {
    PC = 1,
    ANDROID = 2,
    IPHONE = 3,
    IPHONETRUST = 4 -- IOS信任模式
}

-- 游戏列表类型
GameDefine.GAME_LIST_TYPE = {
    NORMAL = 1, -- 正常
    CHECK = 2 -- 审核
}

GameDefine.GameRoomType = {
    NormalType = 0, -- 普通场
    FirstType = 1, -- 学徒房
    MidType = 2, -- 精英房
    HeightType = 3, -- 大师房
    TopType = 4, -- 宗师房
    AntiCheatType = 5, -- 防作弊场
    ExpeType = 6, -- 体验房
    FMHAType = 100, -- 初中高以及防作弊场全部
    ErroType = 200 -- 错误类型
}

-- 付费方式,0:房主付费，1:最大赢家付费，2:族长支付，3：AA支付
GameDefine.RoomPayType = {
    TableOwnerPay = 0, -- 房主付费
    WinUserPay = 1, -- 最大赢家付费
    FamilyOwnerPay = 2, -- 族长支付
    AAPay = 3 -- AA支付
}

-- ===============event===============

-- 退出游戏场景
GameDefine.EXIT_GAMESCENE_FINISH_EVENT = "exit_gameScene_finish_event" -- 退出游戏场景

-- 游戏事件
GameDefine.GR_GAME = "gr_game" -- 游戏消息
GameDefine.GR_GAME_SCENE = "gr_game_scene" -- 游戏场景消息
GameDefine.GR_GAME_STATUS = "gr_game_status" -- 游戏状态消息
GameDefine.GR_USER_ENTER = "gr_user_enter" -- 玩家进入消息
GameDefine.GR_USER_STATUS = "gr_user_status" -- 玩家状态改变消息
GameDefine.GR_USER_SCORE = "gr_user_score" -- 玩家积分改变消息

GameDefine.CS_GR_QUEST_DISMISS_PRIVATE_REPLY = "cs_gr_quest_dismiss_private_reply" -- 解散私人场答复
GameDefine.SC_GR_DISMISS_PRIVATE = "sc_gr_dismiss_private" -- 申请解散私人场
GameDefine.SC_GR_DISMISS_PRIVATE_REPLY = "sc_gr_dismiss_private_reply" -- 解散私人场答复
GameDefine.SC_GR_DISMISS_PRIVATE_RESULT = "sc_gr_dismiss_private_result" -- 解散私人场结果

GameDefine.SC_GR_PRIVATE_INFO = "sc_gr_private_info" -- 私人场详细信息
GameDefine.SC_GR_PRIVATE_END = "sc_gr_private_end" -- 私人场结束

GameDefine.GP_LOGIN_FINISH_EVENT = "gp_login_finish_event" -- gp登录完成
GameDefine.GP_CHECK_ISGAMESERVER_EVENT = "gp_check_isgameserver_event" -- gp查询是否在游戏中
GameDefine.GR_LOGIN_FINISH_EVENT = "gr_login_finish_event" -- gr登录房卡模式完成
GameDefine.GR_LOGIN_FINISH_BATTLE_EBENT = "gr_login_finis_battle_event" -- 登录对战模式完成
GameDefine.SWITCH_HALL_LAYER = "switch_hall_layer" -- 切换大厅layer
GameDefine.RANK_DATA_FINISH = "rank_data_finsih" -- 接收排行榜数据完成
GameDefine.GP_UPDATE_BATTLE_DETAIL = "gp_update_battle_info" -- 刷新战绩详细信息
GameDefine.BATTLE_DATA_FINISH = "battle_data_finsih" -- 接收战绩数据完成

GameDefine.GR_QUEST_READY = "gr_quest_ready" -- 请求准备
GameDefine.GAME_SITDOWN_FAILER = "game_sitdown_failer" -- 房间坐下失败
GameDefine.GAME_USER_IP = "game_user_ip" -- 玩家ip

-- 私人房相关
GameDefine.private_RULE_LEN = 100 -- 房间规则长度
GameDefine.private_SPECIAL_INFO_LEN = 1000 -- 针对房间结束时结算时的一些特殊要求
GameDefine.private_MAX_CREATE_COUNT = 32
GameDefine.private_ROOM_ID_LEN = 7
GameDefine.private_PERSONAL_ROOM_CHAIR = 8 -- 私人房间座子上椅子的最大数目

GameDefine.Direct = {
    Top = 1,
    Down = 2,
    Left = 3,
    Right = 4
}
GameDefine.GF_USER_CHAT = "GF_USER_CHAT" -- 聊天消息
GameDefine.ShowUserChat = "ShowUserChat" -- 聊天消息
GameDefine.Voice_Record_Start = "Voice_Record_Start" -- 语音录音开始
GameDefine.Voice_Record_Cancel = "Voice_Record_Cancel" -- 语音录音取消
GameDefine.Voice_Record_End = "Voice_Record_End" -- 语音录音结束
GameDefine.OpenEmoPhraseWin = "OpenEmoPhraseWin" -- 打开聊天页面
GameDefine.InitEmoPhraseWin = "InitEmoPhraseWin" -- 初始化聊天
GameDefine.OnEmoPhraseWinClose = "OnEmoPhraseWinClose" -- 聊天页面关闭事件

GameDefine.ShopOrderURL_IOS = ""
GameDefine.ShopResultVerifyURL_IOS = ""
GameDefine.ShopOrderURL = "http://le78.com/pay?id=" -- 跳转到外部商城地址

GameDefine.Shop_PayByGoal = "Shop_PayByGoal" -- 用户金币购买商品
GameDefine.UpdataUserGoalInfo = "UpdataUserGoalInfo" -- 更新用户金币消息

GameDefine.Bank_Back_LogonSucc = "Bank_Back_LogonSucc" -- 银行登录成功
GameDefine.Bank_Back_SeachInfoSucc = "Bank_Back_SeachInfoSucc" -- 银行信息查询成功
GameDefine.Bank_Back_SaveTakeSucc = "Bank_Back_SaveTakeSucc" -- 存取款返回成功
GameDefine.Bank_Back_SeachGiveUserSucc = "Bank_Back_SeachGiveUserSucc" -- 根据iD获取赠送者信息成功
GameDefine.Bank_Back_SeachGiveUserFail = "Bank_Back_SeachGiveUserFail" -- 根据iD获取赠送者信息失败
GameDefine.Bank_Back_TransferSucc = "Bank_Back_TransferSucc" -- 银行赠送金币成功
GameDefine.Bank_Back_SeachGiveRecordSucc = "Bank_Back_SeachGiveRecordSucc" -- 银行查询赠送记录成功
GameDefine.Bank_Back_RequestMoneyBackSucc = "Bank_Back_RequestMoneyBackSucc" -- 银行查询流水返点成功
GameDefine.Bank_Back_ModiPassword = "Bank_Back_ModiPassword" -- 修改银行密码
GameDefine.Bank_Back_PassTypeChange = "Bank_Back_PassTypeChange" -- 返回密码转换结果
GameDefine.Bank_Back_SendGiveRoomCrad = "Bank_Back_SendGiveRoomCrad" -- 房卡赠送结果消息
GameDefine.Bank_Back_SendExchangeFamilyExp = "Bank_Back_SendExchangeFamilyExp" -- 家族贡献值兑换_兑换成功
GameDefine.ChatToBank_VerifyPassword = "ChatToBank_VerifyPassword" -- 聊天发红包验证密码消息
GameDefine.BankToChat_VerifyPasswordResult = "BankToChat_VerifyPasswordResult" -- 聊天发红包验证密码消息结果

GameDefine.MachineID = "" -- 机器序列
GameDefine.CCValidation = game.md5("密钥+ID字符串") -- CC验证game.md5("123456")
GameDefine.CCValidationKey = 0xF15BC58E -- cc验证密钥

GameDefine.OPEN_GAME_WINDOW = "open_game_window" -- 打开游戏窗口
GameDefine.CONNECTION_FAILER = "connect_failer" -- 连接失败
GameDefine.CONNECTION_SUCCESS = "NET_CONNECTION_SUCCESS" -- 连接成功

-- 分享成功
GameDefine.GAME_SHARE_SUCCESS = "game_share_success" -- 分享成功

GameDefine.SaveKindID = "SaveKindID"
GameDefine.SaveServerID = "SaveServerID"

GameDefine.AcceptListWelcome = "AcceptListWelcome"
GameDefine.APP_ENTERBACKGROUND = "app_enterbackground" -- APP前后台切换
GameDefine.APP_THIRDSTART_SUCCESS = "app_thirdstart_success" -- 第三方启动成功
GameDefine.RequestServerListFinish = "RequestServerListFinish" -- 请求房间列表消息完成

GameDefine.BackPrivateRoomListMessage = "BackPrivateRoomListMessage" -- 放回自己创建的私人房房间列表
GameDefine.BackCreatePrivateRoomSucc = "BackCreatePrivateRoomSucc" -- 返回为他人创建私人房成功消息

GameDefine.GoalSeverLoginFinish = "GoalSeverLoginFinish" -- 金币场登录完成
GameDefine.GoalSeverTableChange = "GoalSeverTableChange" -- 金币场桌子变化消息
GameDefine.GoalSeverTotalChange = "GoalSeverTotalChange" -- 金币场总计变化消息

GameDefine.onLoginFailer = "loginModule_loginFailer" -- 登录大厅服务器失败
GameDefine.LoginGameServerFail = "LoginGameServerFail" -- 游戏服务器登录失败

GameDefine.VerifyCode_Request_Success = "VerifyCode_Request_Success" -- 请求发送验证码成功
GameDefine.VerifyCode_Request_Failer = "VerifyCode_Request_Failer" -- 请求发送验证码失败

GameDefine.GiveAlmsSuccess = "GiveAlmsSuccess" -- 大厅领取救济金成功
GameDefine.GiveAlmsSuccessByGame = "GiveAlmsSuccessByGame" -- 游戏领取救济金成功

GameDefine.GameTableStatueChange = "GameTableStatuesChange" -- 游戏桌子状态改变

GameDefine.RequestShopGoodListFinish = "RequestShopGoodListFinish" -- 请求商店商品列表完成
GameDefine.GoldExchangeGoodFinish = "GoldExchangeGoodFinish" -- 商品兑换商品完成

GameDefine.CheckBindPhoneSuccess = "CheckBindPhoneSuccess" -- 检查绑定手机号成功
GameDefine.BindPhoneSuccess = "BindPhoneSuccess" -- 绑定手机号成功
GameDefine.UnBindPhoneSuccess = "UnBindPhoneSuccess" -- 解除绑定手机号成功
GameDefine.ModifyLogonPassSuccess = "ModifyLogonPassSuccess" -- 修改登录密码成功
GameDefine.SeachUserInfoPCSuccess = "SeachUserInfoPCSuccess" -- 查询个人详细信息成功
GameDefine.ModifyPersonInfoSuccess = "ModifyPersonInfoSuccess" -- 修改个人资料成功
GameDefine.ModifyPersonInfoFail = "ModifyPersonInfoFail" -- 修改个人资料失败
GameDefine.CheckLoginAccountSucc = "CheckLoginAccountSucc" -- 检测登录账号或者昵称成功
GameDefine.CheckLoginAccountFail = "CheckLoginAccountFail" -- 检测登录账号或者昵称失败

GameDefine.CheckBindPhone = "CheckBindPhone" -- 检测当前账号是否已经绑定了手机
GameDefine.TableRuleChange = "TableRuleChange" -- 桌子规则
GameDefine.TableGameRuleChange = "TableGameRuleChange" -- 桌子游戏规则

GameDefine.AcceptTrumpetContent = "AcceptTrumpetContent" -- 收到游戏喇叭内容
GameDefine.AcceptTrumpetContentRoll = "AcceptTrumpetContentRoll" -- 收到游戏喇叭内容(改滚动消息)

GameDefine.BindAccountResult = "BindAccountResult" -- 绑定账户结果

GameDefine.DataImportSuccess = "DataImportSuccess" -- 数据迁移成功
GameDefine.CheckDataImportSuccess = "CheckDataImportSuccess" -- 查询数据迁移成功
GameDefine.CheckDataImportFailer = "CheckDataImportFailer" -- 查询数据迁移失败
