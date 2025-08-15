--[[
CSDSound.lua

]] local CSDSound = {}

CSDSound.BGM = {
    NORMAL = 0,
    FREE = 1,
    SCATTER = 2
}

local function getPath(file)
    return "game/csd/res/sound/" .. file
end

function CSDSound.scroll(bgm, callback)
    CSDSound.musicId_ = ccexp.AudioEngine:play2d(getPath(bgm ~= CSDSound.BGM.NORMAL and "running1.mp3" or "running.mp3"), false, MusicManager.musicVal)
    ccexp.AudioEngine:setFinishCallback(CSDSound.musicId_, callback)
    return CSDSound.musicId_
end

function CSDSound.stopBGM()
    if CSDSound.musicId_ then
        ccexp.AudioEngine:stop(CSDSound.musicId_)
        CSDSound.musicId_ = nil
    end
end

function CSDSound.setBGMVolume(val)
    local music_volume = val / 100.0
    cc.UserDefault:getInstance():setIntegerForKey("music_volume", val)
    MusicManager.musicVal = music_volume
    if CSDSound.musicId_ then
        ccexp.AudioEngine:setVolume(CSDSound.musicId_, MusicManager.musicVal)
    end
end

function CSDSound.isPlaying(audioId)
    return ccexp.AudioEngine:getState(audioId) == 1
end

function CSDSound.playBigWin()
    CSDSound.stopBGM()
    CSDSound.musicId_ = ccexp.AudioEngine:play2d(getPath("winstart.mp3"), false, MusicManager.musicVal)
end

function CSDSound.scrollStop()
    MusicManager.playEffect(getPath("onestop.mp3"))
end

function CSDSound.addTime()
    MusicManager.playEffect(getPath("addtime.mp3"))
end

function CSDSound.pour()
    MusicManager.playEffect(getPath("dao.mp3"))
end

function CSDSound.drop()
    MusicManager.playEffect(getPath("diaoluo.mp3"))
end

function CSDSound.freeStart()
    MusicManager.playEffect(getPath("freestart.mp3"))
end

function CSDSound.freeTotal()
    CSDSound.winEnd()
end

function CSDSound.goldMove()
    MusicManager.playEffect(getPath("goldmove.mp3"))
end

function CSDSound.throw()
    MusicManager.playEffect(getPath("reng.mp3"))
end

function CSDSound.scatter()
    MusicManager.playEffect(getPath("scatter.mp3"))
end

function CSDSound.split()
    MusicManager.playEffect(getPath("shixiang.mp3"))
end

function CSDSound.columnWild()
    MusicManager.playEffect(getPath("wild.mp3"))
end

function CSDSound.winScore()
    MusicManager.playEffect(getPath("wining.mp3"))
end

function CSDSound.winEnd()
    MusicManager.playEffect(getPath("winend.mp3"))
end

function CSDSound.flyXiang()
    MusicManager.playEffect(getPath("xiangMove.mp3"))
end

function CSDSound.playXiang()
    MusicManager.playEffect(getPath("xiangPlay.mp3"))
end

function CSDSound.showScatter()
    MusicManager.playEffect(getPath("yuncai.mp3"))
end

return CSDSound
