--[[
JPMSound.lua

]] local JPMSound = {}

JPMSound.BGM = {
    NORMAL = 1,
    TREASURE = 2
}

function JPMSound.playEffect(path)
    return ccexp.AudioEngine:play2d(path, false, MusicManager.effectVal)
end

function JPMSound.playBigWin()
    return JPMSound.playEffect("game/jpm/res/audio/BigWin.mp3")
end

function JPMSound.click()
    return JPMSound.playEffect("game/jpm/res/audio/dianji.mp3")
end

function JPMSound.clickSpin()
    return JPMSound.playEffect("game/jpm/res/audio/SpinButton.mp3")
end

function JPMSound.linWin(node)
    local id = JPMSound.playEffect("game/jpm/res/audio/LineWin.mp3")
    node:runAction(cc.Sequence:create(cc.DelayTime:create(0.9), cc.CallFunc:create(function()
        JPMSound.stopEffect(id);
    end)))
    return id;
end

function JPMSound.scatterWin()
    return JPMSound.playEffect("game/jpm/res/audio/ScatterWin.mp3")
end

function JPMSound.turnStart()
    return JPMSound.playEffect("game/jpm/res/audio/TurnFastStart.mp3")
end

function JPMSound.winScore()
    return JPMSound.playEffect("game/jpm/res/audio/score_add.mp3")
end

function JPMSound.turnStop()
    return JPMSound.playEffect("game/jpm/res/audio/TurnStop.mp3")
end

function JPMSound.xiaoChu()
    return JPMSound.playEffect("game/jpm/res/audio/Xiaochu.mp3")
end

function JPMSound.stopEffect(aid)
    ccexp.AudioEngine:stop(aid)
end

return JPMSound
