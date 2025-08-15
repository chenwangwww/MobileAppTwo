--[[
JDNNSound.lua

]] local JDNNSound = {}

local function getPath(file)
    return "game/jdnn/res/sound/" .. file
end

function JDNNSound.playBGM()
    MusicManager.playBGM(getPath("BackAudio.mp3"))
end

function JDNNSound.stopBGM()
    MusicManager.stopBGM()
end

function JDNNSound.playBull(bullTyp)
    MusicManager.playEffect(getPath(string.format("Bull%d.mp3", bullTyp)))
end

function JDNNSound.playStart()
    MusicManager.playEffect(getPath("Start.mp3"))
end

function JDNNSound.playWin()
    MusicManager.playEffect(getPath("Win.mp3"))
end

function JDNNSound.playLose()
    MusicManager.playEffect(getPath("Lose.mp3"))
end

function JDNNSound.shootGun()
    MusicManager.playEffect(getPath("Gun.mp3"))
end

function JDNNSound.playWarning()
    MusicManager.playEffect(getPath("Clock.mp3"))
end

function JDNNSound.dispatchCard()
    MusicManager.playEffect(getPath("SendCard.mp3"))
end

function JDNNSound.playBank()
    MusicManager.playEffect(getPath("banker.mp3"))
end

function JDNNSound.betMoney()
    MusicManager.playEffect(getPath("Money.mp3"))
end

return JDNNSound
