cc.exports.game = cc.exports.game or {}

-- 1登录命令
game.MDM_GR_LOGON = 1 -- 登录信息
game.SUB_GR_LOGON_USERID = 1 -- I D 登录
game.SUB_GR_LOGON_MOBILE = 2 -- 手机登录
game.SUB_GR_LOGON_ACCOUNTS = 3 -- 帐户登录
game.SUB_GR_LOGON_OUT = 4 -- 客户端通知服务器断开连接
game.SUB_GR_LOGON_SUCCESS = 100 -- 登录成功
game.SUB_GR_LOGON_FAILURE = 101 -- 登录失败
game.SUB_GR_LOGON_FINISH = 102 -- 登录完成
game.SUB_GR_UPDATE_NOTIFY = 200 -- 升级提示

-- 2配置命令
game.MDM_GR_CONFIG = 2 -- 配置信息
game.SUB_GR_CONFIG_COLUMN = 100 -- 列表配置
game.SUB_GR_CONFIG_SERVER = 101 -- 房间配置
game.SUB_GR_CONFIG_PROPERTY = 102 -- 道具配置
game.SUB_GR_CONFIG_FINISH = 103 -- 配置完成
game.SUB_GR_CONFIG_USER_RIGHT = 104 -- 玩家权限
game.SUB_GR_HISTROY = 200 -- 下发游戏记录(30秒)
game.SUB_GR_TABLE_RULE = 201 -- 下发桌子规则

-- 3用户命令
game.MDM_GR_USER = 3 -- 用户信息
game.SUB_GR_USER_RULE = 1 -- 用户规则
game.SUB_GR_USER_LOOKON = 2 -- 旁观请求
game.SUB_GR_USER_SITDOWN = 3 -- 坐下请求
game.SUB_GR_USER_STANDUP = 4 -- 起立请求
game.SUB_GR_USER_INVITE = 5 -- 用户邀请
game.SUB_GR_USER_INVITE_REQ = 6 -- 邀请请求
game.SUB_GR_USER_REPULSE_SIT = 7 -- 拒绝玩家坐下
game.SUB_GR_USER_KICK_USER = 8 -- 踢出用户
game.SUB_GR_USER_INFO_REQ = 9 -- 请求用户信息
game.SUB_GR_USER_CHAIR_REQ = 10 -- 请求更换位置
game.SUB_GR_USER_CHAIR_INFO_REQ = 11 -- 请求椅子用户信息
game.SUB_GR_USERIP = 15 -- 同桌玩家ip
game.SUB_GR_USER_ENTER = 100 -- 用户进入
game.SUB_GR_USER_SCORE = 101 -- 用户分数
game.SUB_GR_USER_STATUS = 102 -- 用户状态
game.SUB_GR_SIT_FAILED = 103 -- 坐下失败
game.SUB_GR_GATE_MODIFY = 104 -- 更新下发多通道网关IP
game.SUB_GR_USER_CHAT = 201 -- 聊天消息
game.SUB_GR_USER_EXPRESSION = 202 -- 表情消息
game.SUB_GR_WISPER_CHAT = 203 -- 私聊消息
game.SUB_GR_WISPER_EXPRESSION = 204 -- 私聊表情
game.SUB_GR_COLLOQUY_CHAT = 205 -- 会话消息
game.SUB_GR_COLLOQUY_EXPRESSION = 206 -- 会话表情
game.SUB_GR_PROPERTY_BUY = 300 -- 购买道具
game.SUB_GR_PROPERTY_SUCCESS = 301 -- 道具成功
game.SUB_GR_PROPERTY_FAILURE = 302 -- 道具失败
game.SUB_GR_PROPERTY_MESSAGE = 303 -- 道具消息
game.SUB_GR_PROPERTY_EFFECT = 304 -- 道具效应
game.SUB_GR_PROPERTY_TRUMPET = 305 -- 喇叭消息
game.SUB_GR_GLAD_MESSAGE = 400 -- 喜报消息

-- 4状态命令
game.MDM_GR_STATUS = 4 -- 状态信息
game.SUB_GR_TABLE_INFO = 100 -- 桌子信息
game.SUB_GR_TABLE_STATUS = 101 -- 桌子状态

-- 5系统命令
game.MDM_CM_SYSTEM = 1000 -- 系统命令
game.SUB_CM_SYSTEM_MESSAGE = 1 -- 系统消息
game.SUB_CM_ACTION_MESSAGE = 2 -- 动作消息
game.SUB_CM_DOWN_LOAD_MODULE = 3 -- 下载消息

-- 6框架命令
game.MDM_GF_FRAME = 100 -- 框架命令
game.SUB_GF_GAME_OPTION = 1 -- 游戏配置
game.SUB_GF_USER_READY = 2 -- 用户准备
game.SUB_GF_LOOKON_CONFIG = 3 -- 旁观配置
game.SUB_GF_USER_CHAT = 10 -- 用户聊天
game.SUB_GF_USER_EXPRESSION = 11 -- 用户表情
game.SUB_GR_TABLE_TALK = 12 -- 用户聊天
game.SUB_GF_GAME_STATUS = 100 -- 游戏状态
game.SUB_GF_GAME_SCENE = 101 -- 游戏场景
game.SUB_GF_LOOKON_STATUS = 102 -- 旁观状态
game.SUB_GF_SYSTEM_MESSAGE = 200 -- 系统消息
game.SUB_GF_ACTION_MESSAGE = 201 -- 动作消息
game.SUB_GF_GRANT_ALMS = 202 -- 发放救济金
game.SUB_GF_USER_GPS = 12 -- 上传GPS
game.SUB_GF_SYSTEM_HORN = 203 -- 接受喇叭消息

-- 7游戏命令
game.MDM_GF_GAME = 200 -- 游戏命令
game.SUB_GR_PERSONAL_TABLE_TIP = 9 -- 包房提示信息

-- 8其他信息
game.DTP_GR_TABLE_PASSWORD = 10 -- 桌子密码

-- 9包房命令
game.MDM_GR_PERSONAL_TABLE = 210 -- 私人房间
game.SUB_GR_CREATE_TABLE = 1 -- 创建桌子
game.SUB_GR_CREATE_SUCCESS = 2 -- 创建成功
game.SUB_GR_CREATE_FAILURE = 3 -- 创建失败
game.SUB_GR_CANCEL_TABLE = 4 -- 解散桌子
game.SUB_GR_CANCEL_REQUEST = 5 -- 请求解散
game.SUB_GR_REQUEST_REPLY = 6 -- 请求答复
game.SUB_GR_REQUEST_RESULT = 7 -- 请求结果
game.SUB_GR_WAIT_OVER_TIME = 8 -- 超时等待
game.SUB_GR_PERSONAL_TABLE_END = 10 -- 结束消息
game.SUB_GR_HOSTL_DISSUME_TABLE = 11 -- 房主强制解散桌子
game.SUB_GR_HOST_DISSUME_TABLE_RESULT = 13 -- 解散桌子
game.SUB_GR_CURRECE_ROOMCARD_AND_BEAN = 16 -- 强制解散桌子后的游戏都和房卡

-- 私人场命令
-- game.MDM_GR_PRIVATE = 10									--私人场命令

-- game.SUB_GR_PRIVATE_INFO = 401								--私人场信息
-- game.SUB_GR_CREATE_PRIVATE = 402							--创建私人场
-- game.SUB_GR_CREATE_PRIVATE_SUCESS = 403						--创建私人场成功
-- game.SUB_GR_JOIN_PRIVATE = 404								--加入私人场
-- game.SUB_GF_PRIVATE_ROOM_INFO = 405							--私人场房间信息
-- game.SUB_GR_PRIVATE_DISMISS	= 406							--私人场请求解散
-- game.SUB_GF_PRIVATE_END	= 407								--私人场结算
-- game.SUB_GR_RIVATE_AGAIN = 408								--创建私人场

