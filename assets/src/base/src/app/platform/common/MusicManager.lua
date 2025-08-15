cc.exports.MusicManager = {}

function MusicManager.onInit()
    MusicManager.audioID = cc.AUDIO_INVAILD_ID

    local musicVal = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 100)
    local effectVal = cc.UserDefault:getInstance():getIntegerForKey("effect_volume", 100)
    MusicManager.musicVal = musicVal / 100.0
    MusicManager.effectVal = effectVal / 100.0
end

function MusicManager.getMusicVal()
    local music_volume = cc.UserDefault:getInstance():getIntegerForKey("music_volume", 100)
    return music_volume
end

function MusicManager.getEffectVal()
    local effect_volume = cc.UserDefault:getInstance():getIntegerForKey("effect_volume", 100)
    return effect_volume
end

function MusicManager.playEffect(path)
    ccexp.AudioEngine:play2d(path, false, MusicManager.effectVal)
end

function MusicManager.playBGM(path)
    if MusicManager.audioID == cc.AUDIO_INVAILD_ID then
        MusicManager.audioID = ccexp.AudioEngine:play2d(path, true, MusicManager.musicVal)
    end
end

function MusicManager.pauseBGM()
    if MusicManager.audioID ~= cc.AUDIO_INVAILD_ID then
        ccexp.AudioEngine:pause(MusicManager.audioID)
    end
end

function MusicManager.resumeBGM()
    if MusicManager.audioID ~= cc.AUDIO_INVAILD_ID then
        ccexp.AudioEngine:resume(MusicManager.audioID)
    end
end

function MusicManager.stopBGM()
    if MusicManager.audioID ~= cc.AUDIO_INVAILD_ID then
        ccexp.AudioEngine:stop(MusicManager.audioID)
        MusicManager.audioID = cc.AUDIO_INVAILD_ID
    else
        print("MusicManager.audioID == cc.AUDIO_INVAILD_ID")
    end
end

function MusicManager.setBGMVolume(val)
    local music_volume = val / 100.0
    cc.UserDefault:getInstance():setIntegerForKey("music_volume", val)
    MusicManager.musicVal = music_volume
    if MusicManager.audioID ~= cc.AUDIO_INVAILD_ID then
        ccexp.AudioEngine:setVolume(MusicManager.audioID, MusicManager.musicVal)
    end
end

function MusicManager.refreshBGMVolume()
    if MusicManager.audioID ~= cc.AUDIO_INVAILD_ID then
        ccexp.AudioEngine:setVolume(MusicManager.audioID, MusicManager.musicVal)
    end
end

function MusicManager.setEffectVolume(val)
    local effect_volume = val / 100.0
    cc.UserDefault:getInstance():setIntegerForKey("effect_volume", val)
    MusicManager.effectVal = effect_volume
end

function MusicManager.uncacheAll()
    ccexp.AudioEngine:uncacheAll()
end

function MusicManager.uncache(path)
    ccexp.AudioEngine:uncache(path)
end
