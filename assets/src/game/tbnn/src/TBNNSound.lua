--[[
TBNNSound.lua

]] local TBNNSound = {}

local function getPath(file)
    return "game/tbnn/res/sound/" .. file
end

function TBNNSound.playBGM()
    MusicManager.playBGM(getPath("BackAudio.mp3"))
end

function TBNNSound.stopBGM()
    MusicManager.stopBGM()
end

function TBNNSound.playBull(bullTyp)
    MusicManager.playEffect(getPath(string.format("Bull%d.mp3", bullTyp)))
end

function TBNNSound.playStart()
    MusicManager.playEffect(getPath("Start.mp3"))
end

function TBNNSound.playWin()
    MusicManager.playEffect(getPath("Win.mp3"))
end

function TBNNSound.playLose()
    MusicManager.playEffect(getPath("Lose.mp3"))
end

function TBNNSound.shootGun()
    MusicManager.playEffect(getPath("Gun.mp3"))
end

function TBNNSound.playWarning()
    MusicManager.playEffect(getPath("Clock.mp3"))
end

function TBNNSound.dispatchCard()
    MusicManager.playEffect(getPath("SendCard.mp3"))
end

return TBNNSound
