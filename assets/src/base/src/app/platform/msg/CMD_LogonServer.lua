cc.exports.game = game or {}

-- 1登录命令
game.MDM_GP_LOGON = 1 -- 广场登录
-- 登录模式
game.SUB_GP_LOGON_GAMEID = 1 -- I D 登录
game.SUB_GP_LOGON_ACCOUNTS = 2 -- 帐号登录
game.SUB_GP_REGISTER_ACCOUNTS = 3 -- 注册帐号
game.SUB_GP_CHECK_ACCOUNTS = 4 -- 检测账号
game.SUB_GP_CHECK_NICKNAME = 5 -- 检测昵称

-- 登录结果
game.SUB_GP_LOGON_SUCCESS = 100 -- 登录成功
game.SUB_GP_LOGON_FAILURE = 101 -- 登录失败
game.SUB_GP_LOGON_FINISH = 102 -- 登录完成
game.SUB_GP_VALIDATE_MBCARD = 103 -- 登录失败

game.SUB_GP_CHECK_SUCCESSS = 104 -- 检测账号成功
game.SUB_GP_CHECK_FAILURE = 105 -- 检测账号失败

game.SUB_GP_MATCH_SIGNUPINFO = 106 -- 报名信息
game.SUB_GP_GROWLEVEL_CONFIG = 107 -- 等级配置

-- 升级提示
game.SUB_GP_UPDATE_NOTIFY = 200 -- 升级提示
game.MB_VALIDATE_FLAGS = 0x01 -- 效验密保
game.LOW_VER_VALIDATE_FLAGS = 0x02 -- 效验低版本
-- 携带信息 CMD_GP_LogonSuccess
game.DTP_GP_GROUP_INFO = 1 -- 社团信息
game.DTP_GP_MEMBER_INFO = 2 -- 会员信息
game.DTP_GP_UNDER_WRITE = 3 -- 个性签名
game.DTP_GP_STATION_URL = 4 -- 主页信息

-- 2列表命令
game.MDM_GP_SERVER_LIST = 2 -- 列表信息
-- 获取命令
game.SUB_GP_GET_LIST = 1 -- 获取列表
game.SUB_GP_GET_SERVER = 2 -- 获取房间
game.SUB_GP_GET_ONLINE = 3 -- 获取在线
game.SUB_GP_GET_COLLECTION = 4 -- 获取收藏

game.SUB_MB_GET_GAME_LOBBY_AD = 5 -- 请求游戏消息

-- 列表信息
game.SUB_GP_LIST_TYPE = 100 -- 类型列表
game.SUB_GP_LIST_KIND = 101 -- 种类列表
game.SUB_GP_LIST_NODE = 102 -- 节点列表
game.SUB_GP_LIST_PAGE = 103 -- 定制列表
game.SUB_GP_LIST_SERVER = 104 -- 房间列表
game.SUB_GP_LIST_MATCH = 105 -- 比赛列表
game.SUB_GP_VIDEO_OPTION = 106 -- 视频配置
-- 完成信息
game.SUB_GP_LIST_FINISH = 200 -- 发送完成
game.SUB_GP_SERVER_FINISH = 201 -- 房间完成
-- 在线信息
game.SUB_GR_KINE_ONLINE = 300 -- 类型在线
game.SUB_GR_SERVER_ONLINE = 301 -- 房间在线
game.SUB_GR_ONLINE_FINISH = 302 -- 在线完成

-- 3用户服务命令
game.MDM_GP_USER_SERVICE = 3 -- 用户服务
-- 账号服务
game.SUB_GP_MODIFY_MACHINE = 100 -- 修改机器
game.SUB_GP_MODIFY_LOGON_PASS = 101 -- 修改登录密码
game.SUB_GP_MODIFY_INSURE_PASS_RESULT = 102 -- 修改银行密码结果
game.SUB_GP_MODIFY_UNDER_WRITE = 103 -- 修改签名
game.SUB_GP_VERIFY_PASSWORD = 104 -- 密码验证
game.SUB_GP_SWITCH_PASSWORD = 105 -- 密码类型转换

game.SUB_MB_EXCHANGE_ROOMCARD = 106 -- 银行家族贡献值兑换
game.SUB_MB_EXP_EXCHANGE_ROOMCARD = 108 -- 家族贡献值兑换房卡成功
game.SUB_MB_EXP_EXCHANGE_GOAL = 107 -- 家族贡献值兑换金币成功

game.SUB_MB_QUERY_BIND_PHONE = 113 -- 查询账号绑定的手机号码
game.SUB_MB_QUERY_BIND_PHONE_SUCCESS = 114 -- 查询账号绑定的手机号码成功
game.SUB_MB_QUERY_BIND_PHONE_FAILURE = 115 -- 查询账号绑定的手机号码失败

game.SUB_MB_MODIFY_LOGON_PASS_PHONE = 116 -- 通过手机号修改密码
game.SUB_MB_MODIFY_LOGON_PASS_PHONE_SUCCESS = 117 -- 通过手机号修改密码成功
game.SUB_MB_MODIFY_LOGON_PASS_PHONE_FAILURE = 118 -- 通过手机号修改密码失败

game.SUB_GP_MODIFY_INSURE_PASS_NEW = 120 -- 修改银行密码

game.SUB_MB_MODIFYINDIVIDUAL_SUCCESS = 124 -- 修改资料成功
game.SUB_MB_MODIFYINDIVIDUAL_FAILURE = 125 -- 修改资料失败
game.SUB_MB_SHAREFRIENDS_SUCCESS = 126 -- 分享成功
game.SUB_MB_SHAREFRIENDS_FAILURE = 127 -- 分享失败
game.SUB_MB_GIVE_ALMS_SUCCESS = 128 -- 领取救济金成功
game.SUB_MB_GIVE_ALMS_FAILURE = 129 -- 领取救济金失败
game.SUB_MB_SEND_SMS_SUCCESS = 130 -- 请求验证码成功
game.SUB_MB_SEND_SMS_FAILURE = 131 -- 请求验证码失败

game.SUB_MB_BIND_PHONE_SUCCESS = 132 -- 申请绑定手机成功
game.SUB_MB_BIND_PHONE_FAILURE = 133 -- 申请绑定手机失败
game.SUB_MB_UNBIND_PHONE_SUCCESS = 134 -- 申请解除绑定手机成功
game.SUB_MB_UNBIND_PHONE_FAILURE = 135 -- 申请解除绑定手机失败

-- 个人资料
game.SUB_GP_QUERY_INDIVIDUAL_PC = 300 -- 查询详细资料
game.SUB_GP_USER_INDIVIDUAL = 301 -- 查询详细资料结果
game.SUB_GP_QUERY_INDIVIDUAL = 302 -- 查询个人信息
game.SUB_GP_MODIFY_INDIVIDUAL = 303 -- 修改资料
game.SUB_GP_QUERY_ACCOUNTINFO = 304 -- 个人信息
game.SUB_GP_QUERY_INGAME_SEVERID = 305 -- 游戏状态

game.SUB_MB_USER_SCORE_RECORD_START = 306 -- 战绩接受开始
game.SUB_MB_USER_SCORE_RECORD = 307 -- 战绩
game.SUB_MB_USER_SCORE_RECORD_END = 308 -- 战绩接收结束
game.SUB_MB_USER_SCORE_DETAIL = 309 -- 请求战绩详细信息
game.SUB_MB_MODIFY_INDIVIDUAL = 310 -- 请求修改个人信息
game.SUB_MB_SHAREFRIENDS = 311 -- 微信分享
game.SUB_MB_USER_SCORE_DETAIL_START = 312 -- 战绩明细开始
game.SUB_MB_USER_SCORE_DETAIL_END = 313 -- 战绩明细结束
game.SUB_MB_GAME_RECORD_START = 314 -- 录像开始
game.SUB_MB_GAME_RECORD = 315 -- 游戏录像
game.SUB_MB_GAME_RECORD_END = 316 -- 录像结束
game.SUB_MB_GIVE_ALMS = 317 -- 请求领取救济金
game.SUB_MB_SEND_SMS = 318 -- 请求登录验证码

game.SUB_MB_NOTICE_MESSAGE_START = 319 -- 接受游戏获奖滚动消息开始
game.SUB_MB_NOTICE_MESSAG = 320 -- 接受游戏获奖游戏消息
game.SUB_MB_NOTICE_MESSAGE_END = 321 -- 接受游戏获奖游戏消息结束

game.SUB_MB_BIND_PHONE = 322 -- 申请绑定手机
game.SUB_MB_UNBIND_PHONE = 323 -- 申请解除绑定手机

game.SUB_MB_USER_FAMILY_RANKING_BEGIN = 360 -- 用户请求排行榜开始
game.SUB_MB_USER_FAMILY_RANKING = 361 -- 用户请求排行榜
game.SUB_MB_USER_FAMILY_RANKING_END = 362 -- 用户请求排行榜结束

-- 银行服务
game.SUB_GP_USER_SAVE_SCORE = 400 -- 存款操作
game.SUB_GP_USER_TAKE_SCORE = 401 -- 取款操作
game.SUB_GP_USER_TRANSFER_SCORE = 402 -- 转账操作
game.SUB_GP_USER_TRANSFER_SUCCESS = 417 -- 用户转账成功

game.SUB_GP_USER_INSURE_INFO = 403 -- 查询银行信息成功
game.SUB_GP_QUERY_INSURE_INFO = 404 -- 查询银行信息

game.SUB_GP_USER_INSURE_SUCCESS = 405 -- 银行成功
game.SUB_GP_USER_INSURE_FAILURE = 406 -- 银行失败

game.SUB_GP_QUERY_USER_INFO_REQUEST = 407 -- 查询用户
game.SUB_GP_QUERY_USER_INFO_RESULT = 408 -- 用户信息

game.SUB_GP_TRANSFER_RECORD = 409 -- 查询用户转账记录
game.SUB_GP_USER_TRANSFER_RECORD_RESULT = 410 -- 查询用户转账记录（传输数据）
game.SUB_GP_USER_TRANSFER_RECORD_FINISH = 411 -- 查询用户转账记录完成

game.SUB_GP_USER_INSURE_LOGON = 412 -- 用户银行登录
game.SUB_GP_USER_INSURE_LOGON_SUCCESS = 418 -- 用户银行登录成功
game.SUB_GP_USER_INSURE_LOGON_FAILURE = 419 -- 用户银行登录失败

game.SUB_GP_USER_TRANSFER_SUCCESS = 417 -- 用户赠送金币成功

game.SUB_GP_QUERY_USER_RUNNINGACCOUNT = 413 -- 查询玩家流水
game.SUB_GP_USER_TAKE_RUNNINGACCOUNT = 414 -- 取出玩家流水
game.SUB_GP_USER_RUNNINGACCOUNT_INFO = 420 -- 查询或者取出玩家流水成功
game.SUB_GP_USER_USELIVECARD = 421 -- 卡号密码充值

game.SUB_GP_QUERY_GAME_INSURE_INFO = 415 -- 用户游戏数据查询
game.SUB_GP_USER_GAME_INSURE_INFO = 416 -- 用户游戏数据查询结果

game.SUB_GP_USER_GOLD_TRANSFER = 450 -- 用户用金币购买商品

game.SUB_GP_OPERATE_SUCCESS = 900 -- 银行操作成功
game.SUB_GP_OPERATE_FAILURE = 901 -- 银行操作失败

game.SUB_MB_QUERY_USER_BASIC = 350 -- 根据ID号查询用户（根据ID号查询用户成功）
game.SUB_MB_QUERY_USER_FAIL = 600 -- 根据ID号查询用户成失败

game.SUB_MB_GIVE_USER_ROOMCARD = 351 -- 赠送房卡消息

game.SUB_MB_OPERATE_SPEED_FAIL = 601 -- 操作速度过快
game.SUB_ANS_GIVE_ROOM_CARD_FAIL = 602 -- 赠送房卡失败
game.SUB_ANS_EXC_ROOM_CARD_FAIL = 603 -- 兑换房卡和金币失败

-- 4手机登录命令
game.MDM_MB_LOGON = 100 -- 广场登录
-- 登录模式
game.SUB_MB_LOGON_GAMEID = 1 -- I D 登录
game.SUB_MB_LOGON_ACCOUNTS = 2 -- 帐号登录
game.SUB_MB_REGISTER_ACCOUNTS = 3 -- 注册帐号
game.SUB_MB_BINDWX = 4 -- 绑定微信
game.SUB_MB_BIND_ACCOUNT = 5 -- 绑定账号
-- 登录结果
game.SUB_MB_LOGON_SUCCESS = 100 -- 登录成功
game.SUB_MB_LOGON_FAILURE = 101 -- 登录失败
game.SUB_MB_BINDWX_SUCCESS = 122 -- 绑定微信
game.SUB_MB_BINDWX_FAILURE = 123 -- 绑定失败
game.SUB_MB_BINDACCOUNT_SUCCESS = 130 -- 绑定账户成功
game.SUB_MB_BINDACCOUNT_FAILURE = 131 -- 绑定账户失败
-- 升级提示
game.SUB_MB_UPDATE_NOTIFY = 200
game.SUB_MB_LOAD_FAMILY_LIST = 109 -- 加载家族列表
game.SUB_MB_SELECT_FAMILY = 110 -- 选择家族

game.SUB_MB_LOAD_FAMILY_LIST_BEGIN = 111
game.SUB_MB_LOAD_FAMILY_LIST_END = 112

game.SUB_MB_REMOVE_ACCOUNT = 7 -- 迁移账号现金及保险箱
game.SUB_MB_REMOVEACCOUNT_SUCCESS = 132 -- 迁移成功
game.SUB_MB_REMOVEACCOUNT_FAILURE = 133 -- 迁移失败

game.SUB_MB_QUERY_REMOVE_ACCOUNT = 8 -- 查询迁移账号现金及保险箱
game.SUB_MB_QUERYREMOVEACCOUNT_SUCCESS = 134 -- 查询迁移账号现金及保险箱成功
game.SUB_MB_QUERYREMOVEACCOUNT_FAILURE = 135 -- 查询迁移账号现金及保险箱失败

-- 5列表命令
game.MDM_MB_SERVER_LIST = 101 -- 列表信息
-- 列表信息
game.SUB_MB_LIST_TYPE = 99 -- 游戏类型
game.SUB_MB_LIST_KIND = 100 -- 种类列表
game.SUB_MB_LIST_SERVER = 101 -- 房间列表
game.SUB_MB_LIST_WELCOME = 102 -- 公告
game.SUB_MB_LIST_FINISH = 200 -- 列表完成

-- 6私人房间命令
game.MDM_MB_PERSONAL_SERVICE = 200 -- 私人房间命令
-- 查询房间
game.SUB_MB_QUERY_GAME_SERVER = 204 -- 查询房间
game.SUB_MB_QUERY_GAME_SERVER_RESULT = 205 -- 查询结果
game.SUB_MB_SEARCH_SERVER_TABLE = 206 -- 搜索房间桌子
game.SUB_MB_SEARCH_RESULT = 207 -- 搜索结果
game.SUB_MB_GET_PERSONAL_PARAMETER = 208 -- 私人房间配置
game.SUB_MB_PERSONAL_PARAMETER = 209 -- 私人房间配置
game.SUB_MB_QUERY_PERSONAL_ROOM_LIST = 210 -- 请求私人房间列表
game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT_BEGIN = 223 -- 请求私人房间列表结果开始
game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT = 211 -- 请求私人房间列表结果
game.SUB_MB_QUERY_PERSONAL_ROOM_LIST_RESULT_END = 224 -- 请求私人房间列表结果结束
game.SUB_MB_PERSONAL_FEE_PARAMETER = 212 -- 私人房间配置
game.SUB_MB_DISSUME_SEARCH_SERVER_TABLE = 213 -- 为解散桌子搜索ID
game.SUB_MB_DISSUME_SEARCH_RESULT = 214 -- 解散桌子搜索房间ID结果
game.SUB_MB_QUERY_USER_ROOM_INFO = 215 -- 玩家请求桌子信息
game.SUB_GR_USER_QUERY_ROOM_SCORE = 216 -- 私人房间单个玩家请求房间成绩
game.SUB_GR_USER_QUERY_ROOM_SCORE_RESULT = 217 -- 私人房间单个玩家请求房间成绩结果
game.SUB_GR_USER_QUERY_ROOM_SCORE_RESULT_FINSIH = 218 -- 私人房间单个玩家请求房间成绩完成
game.SUB_MB_QUERY_PERSONAL_ROOM_USER_INFO = 219 -- 私人房请求玩家的房卡和游戏豆
game.SUB_MB_QUERY_PERSONAL_ROOM_USER_INFO_RESULT = 220 -- 私人房请求玩家的房卡和游戏豆结果
game.SUB_MB_ROOM_CARD_EXCHANGE_TO_SCORE = 221 -- 房卡兑换游戏币
game.SUB_GP_EXCHANGE_ROOM_CARD_RESULT = 222 -- 房卡兑换游戏币结果
