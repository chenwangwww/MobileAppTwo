-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local FISHCMD = require "game.fishlk.src.FISHLK_CMD"
local bit = require "bit"
local _M = {}
---------------------------接收----------------------------------------
-- 游戏状态
function _M.CMD_S_GameState(data)
    local params = {}
    params.game_version = data:readUInt32() -- 游戏版本
    params.fish_score = {}
    for i = 1, FISHCMD.GamePlayer_4 do
        params.fish_score[i] = data:readInt64() -- 鱼币
    end
    params.exchange_fish_score = {}
    for i = 1, FISHCMD.GamePlayer_4 do
        params.exchange_fish_score[i] = data:readInt64() -- 兑换的分数
    end
    params.me_user_score = data:readInt64() -- 携带分数
    params.dwleftTime = data:readUInt32()
    return params
end
-- 游戏配置
function _M.CMD_S_GameConfig(data)
    local params = {}
    -- 鱼币兑换比列
    params.exchange_ratio_userscore = data:readInt64() -- 玩家积分
    params.exchange_ratio_fishscore = data:readInt64() -- 鱼币
    params.exchange_count = data:readInt64() -- 兑换数量
    -- 子弹倍数区间
    params.min_bullet_multiple = data:readInt32() -- 最小子弹倍数
    params.max_bullet_multiple = data:readInt32() -- 最大子弹倍数
    -- 炸弹影响范围
    params.bomb_range_width = data:readInt32() -- 宽度
    params.bomb_range_height = data:readInt32() -- 高度
    -- 鱼的信息
    params.fish_multiple = {}
    for i = 1, FISHCMD.FishKind.FISH_KIND_COUNT do
        params.fish_multiple[i] = data:readInt32() -- 鱼的倍数
    end
    params.fish_speed = {}
    for i = 1, FISHCMD.FishKind.FISH_KIND_COUNT do
        params.fish_speed[i] = data:readInt32() -- 鱼的速度
    end
    params.fish_bounding_box_width = {}
    for i = 1, FISHCMD.FishKind.FISH_KIND_COUNT do
        params.fish_bounding_box_width[i] = data:readInt32() -- 鱼的边框宽度
    end
    params.fish_bounding_box_height = {}
    for i = 1, FISHCMD.FishKind.FISH_KIND_COUNT do
        params.fish_bounding_box_height[i] = data:readInt32() -- 鱼的边框高度
    end
    params.fish_hit_radius = {}
    for i = 1, FISHCMD.FishKind.FISH_KIND_COUNT do
        params.fish_hit_radius[i] = data:readInt32() -- 鱼的击中半径
    end
    -- 子弹信息
    params.bullet_speed = {}
    for i = 1, FISHCMD.BulletKind.BULLET_KIND_COUNT do
        params.bullet_speed[i] = data:readInt32() -- 子弹速度
    end
    params.net_radius = {}
    for i = 1, FISHCMD.BulletKind.BULLET_KIND_COUNT do
        params.net_radius[i] = data:readInt32() -- 渔网半径
    end
    params.bGrabLKonoff = data:readInt32() -- 抢李逵开关
    params.lBaseScore = data:readInt64() -- 抢李逵底注
    return params
end

-- 鱼的轨迹
function _M.CMD_S_FishTrace(data)
    local params = {}
    params.init_pos = {}
    for i = 1, 5 do
        local init_pos = {}
        init_pos.x = data:readFloat()
        init_pos.y = data:readFloat()
        params.init_pos[i] = init_pos
    end
    params.init_count = data:readInt32() -- 鱼群轨迹节点数量
    params.fish_kind = data:readInt32() -- 鱼类型
    params.fish_id = data:readInt32() -- 鱼id
    params.trace_type = data:readInt32() -- 轨迹类型 0直线 1贝塞尔曲线
    return params
end

-- 兑换鱼分
function _M.CMD_S_ExchangeFishScore(data)
    local params = {}
    params.chair_id = data:readUInt16() -- 玩家座位
    params.swap_fish_score = data:readInt64() -- 交换鱼分
    params.exchange_fish_score = data:readInt64() -- 兑换鱼分
    return params
end

-- 玩家开火
function _M.CMD_S_UserFire(data)
    local params = {}
    params.bullet_kind = data:readInt32() -- 子弹类型
    params.bullet_id = data:readInt32() -- 子弹id
    params.chair_id = data:readUInt16() -- 玩家座位id
    params.android_chairid = data:readUInt16() -- 机器人座位id
    local fire_pos = {}
    fire_pos.x = data:readFloat() -- 玩家开火点x
    fire_pos.y = data:readFloat() -- 玩家开火点y
    params.fire_pos = fire_pos
    params.bullet_multiple = data:readInt32() -- 子弹倍数
    params.lock_fishid = data:readInt32() -- 锁定鱼的id
    params.fish_score = data:readInt64() -- 鱼的分数
    return params
end

-- 捕获鱼
function _M.CMD_S_CatchFish(data)
    local params = {}
    params.chair_id = data:readUInt16() -- 玩家座位id
    params.android_chairid = data:readUInt16() -- 机器人信息索引id
    params.fish_id = data:readInt32() -- 鱼的id
    params.fish_kind = data:readInt32() -- 鱼的类型
    params.bullet_ion = data:readInt8() -- 是否为离子炮
    params.fish_score = data:readInt64() -- 鱼分
    params.bullet_mul = data:readInt32() -- 鱼的倍数
    params.award = data:readInt32() -- 中奖类型
    return params
end

-- 大转盘
function _M.CMD_S_TreasureBoxResult(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.award = data:readInt32()
    params.bullet_multiple = data:readInt32()
    params.fish_score = data:readInt64()
    return params
end

-- 抢李逵得分
function _M.CMD_S_GrabLKResult(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.fish_score = data:readInt64()
    params.user_Grab_Lkdr_lose = {}
    for i = 1, FISHCMD.GamePlayer_4 do
        params.user_Grab_Lkdr_lose[i] = data:readInt64()
    end
    return params
end

-- 离子炮过期
function _M.CMD_S_BulletIonTimeout(data)
    local params = {}
    params.chair_id = data:readUInt16()
    return params
end

-- 捕获鱼群
function _M.CMD_S_CatchSweepFish(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.fish_id = data:readInt32()
    return params
end

-- 捕获鱼群
function _M.CMD_S_CatchSweepFishResult(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.fish_id = data:readInt32()
    params.fish_score = data:readInt64()
    params.catch_fish_count = data:readInt32()
    params.catch_fish_id = {}
    for i = 1, 300 do
        params.catch_fish_id[i] = data:readInt32()
    end
    return params
end

-- 击中李逵
function _M.CMD_S_HitFishLK(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.fish_id = data:readInt32()
    params.fish_multiple = data:readInt32()
    return params
end

-- 击中任务鱼
function _M.CMD_S_HitFishTask(data)
    local params = {}
    params.chair_id = data:readUInt16()
    params.fish_id = data:readInt32()
    params.get_fishscore = data:readInt32()
    params.fish_life = data:readInt32()
    return params
end
-- 普通场景
function _M.CMD_S_GameStatScene2(data)
    local params = {}
    params.fish_count = data:readInt32()
    params.fish_kind = {}
    for i = 1, 100 do
        params.fish_kind[i] = data:readInt32()
    end
    params.fish_id = {}
    for i = 1, 100 do
        params.fish_id[i] = data:readInt32()
    end
    params.dwLeftTime = {}
    for i = 1, 100 do
        params.dwLeftTime[i] = data:readUInt32()
    end
    params.init_pos = {}
    for i = 1, 100 do
        local temp_init_pos = {}
        for j = 1, 5 do
            local init_pos = {}
            init_pos.x = data:readFloat()
            init_pos.y = data:readFloat()
            temp_init_pos[j] = init_pos
        end
        table.insert(params.init_pos, temp_init_pos)
    end
    params.init_count = {}
    for i = 1, 100 do
        params.init_count[i] = data:readInt32() -- 鱼群轨迹节点数量
    end
    params.trace_type = {}
    for i = 1, 100 do
        params.trace_type[i] = data:readInt32()
    end

    return params
end
-- 重绘场景
function _M.CMD_S_GameStatScene(data)
    local params = {}
    params.scene_kind = data:readInt32()
    params.fish_count = data:readInt32()
    params.fish_kind = {}
    for i = 1, 300 do
        params.fish_kind[i] = data:readInt32()
    end
    params.fish_id = {}
    for i = 1, 300 do
        params.fish_id[i] = data:readInt32()
    end
    params.nIndex = {}
    for i = 1, 300 do
        params.nIndex[i] = data:readInt32()
    end
    params.dwLeftTime = {}
    for i = 1, 300 do
        params.dwLeftTime[i] = data:readUInt32()
    end

    return params
end
-- 切换场景
function _M.CMD_S_SwitchScene(data)
    local params = {}
    params.scene_kind = data:readInt32()
    params.fish_count = data:readInt32()
    params.fish_kind = {}
    for i = 1, 300 do
        params.fish_kind[i] = data:readInt32()
    end
    params.fish_id = {}
    for i = 1, 300 do
        params.fish_id[i] = data:readInt32()
    end
    return params
end

-- 库存操作
function _M.CMD_S_StockOperateResult(data)
    local params = {}
    params.operate_code = data:readUInt8()
    params.stock_score = data:readInt64()
    return params
end

------------------------------发送--------------------------------------------------
-- 大转盘
function _M.send_CMD_C_OpenTeasureBox(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_OPEN_TREASURE_BOX, 1024)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeInt32(data.award)
        rpcSend:writeInt32(data.fish_id)
        rpcSend:release()
    end
end

-- 兑换积分
function _M.send_CMD_C_ExchangeFishScore(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_EXCHANGE_FISHSCORE, 1024)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeUInt8(data.increase and 1 or 0)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end

-- 玩家开火
function _M.send_CMD_C_UserFire(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_USER_FIRE, 1024)
        rpcSend:writeInt32(data.bullet_kind)
        rpcSend:writeFloat(data.fire_pos.x)
        rpcSend:writeFloat(data.fire_pos.y)
        rpcSend:writeInt32(data.bullet_multiple)
        rpcSend:writeInt32(data.lock_fishid)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end

-- 用户锁定鱼
function _M.send_CMD_C_UserLockFish(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_USER_LOCK_FISH, 1024)
        rpcSend:writeInt32(data.lock_fishid)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end

-- 捕获鱼
function _M.send_CMD_C_CatchFish(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_CATCH_FISH, 1024)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeInt32(data.fish_id)
        rpcSend:writeInt32(data.bullet_kind)
        rpcSend:writeInt32(data.bullet_id)
        rpcSend:writeInt32(data.bullet_multiple)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end

-- 捕获鱼群
function _M.send_CMD_C_CatchSweepFish(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_CATCH_SWEEP_FISH, 2048)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeInt32(data.fish_id)
        rpcSend:writeInt32(data.catch_fish_count)
        for i = 1, 300 do
            rpcSend:writeInt32(data.catch_fish_id[i])
        end
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end

-- 击中李逵
function _M.send_CMD_C_HitFishLK(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_HIT_FISH_I, 1024)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeInt32(data.fish_id)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end

end

-- 击中任务鱼
function _M.send_CMD_C_HitFishTask(data)
    if PlazaManager.isSendGameServerPackage() == true then
        local rpcSend = GamePacketSendHelper.create(GameDefine.GAME_SOCKET, game.MDM_GF_GAME, FISHCMD.SUB_C_HIT_FISH_TASK, 1024)
        rpcSend:writeUInt16(data.chair_id)
        rpcSend:writeInt32(data.fish_id)
        rpcSend:writeInt32(data.bullet_multiple)
        rpcSend:writeUInt32(data.dwCurrentTime)
        rpcSend:writeUString(data.validate_info, FISHCMD.LEN_MD5 * 2)
        rpcSend:release()
    end
end
return _M
-- endregion
