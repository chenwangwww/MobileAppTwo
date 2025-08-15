--[[
JSFYSound.lua

]] local JSFYSound = {}

JSFYSound.BGM = {
    NORMAL = 1,
    TREASURE = 2
}

local function getPath(file)
    return "game/jsfy/res/audio/" .. file
end

function JSFYSound.playBGM(bgm)
    JSFYSound.stopBGM()
    MusicManager.playBGM(getPath(string.format("bg_%d.mp3", bgm)))
end

function JSFYSound.stopBGM()
    MusicManager.stopBGM()
end

function JSFYSound.playBigWin()
    JSFYSound.winEnd()
end

function JSFYSound.scrollStop()
    MusicManager.playEffect(getPath("stop.mp3"))
end

function JSFYSound.bomb()
    MusicManager.playEffect(getPath("bomb.mp3"))
end

function JSFYSound.click()
    MusicManager.playEffect(getPath("dianji.mp3"))
end

function JSFYSound.clickSpin()
    MusicManager.playEffect(getPath("spinclick.mp3"))
end

function JSFYSound.flip()
    MusicManager.playEffect(getPath("fanpai.mp3"))
end

function JSFYSound.freeStart()
    MusicManager.playEffect(getPath("mianfei.mp3"))
end

function JSFYSound.freeTotal()
    JSFYSound.winEnd()
end

function JSFYSound.lineHit()
    MusicManager.playEffect(getPath("hit.mp3"))
end

function JSFYSound.openBox()
    MusicManager.playEffect(getPath("zhongjiang.mp3"))
end

function JSFYSound.addScore()
    MusicManager.playEffect(getPath("score_add.mp3"))
end

function JSFYSound.winScore()
    MusicManager.playEffect(getPath("win1.mp3"))
end

function JSFYSound.winEnd()
    MusicManager.playEffect(getPath("win2.mp3", bgm))
end

return JSFYSound
