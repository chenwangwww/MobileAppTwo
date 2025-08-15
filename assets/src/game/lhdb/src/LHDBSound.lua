--[[
LHDBSound.lua

]] local LHDBSound = {}

local function getPath(file)
    return "game/lhdb/res/Sound/" .. file
end

function LHDBSound.playBGM(index)
    MusicManager.playBGM(getPath(string.format("background%d.mp3", index or 1)))
end

function LHDBSound.stopBGM()
    MusicManager.stopBGM()
end

function LHDBSound.playBigWin()
    MusicManager.playBGM(getPath("bigwin.mp3"))
end

function LHDBSound.enterBall()
    MusicManager.playEffect(getPath("ball_enter.mp3"))
end

function LHDBSound.flyBall()
    MusicManager.playEffect(getPath("ballfly.mp3"))
end

function LHDBSound.clickButton()
    MusicManager.playEffect(getPath("button_click.mp3"))
end

function LHDBSound.closeDoor()
    MusicManager.playEffect(getPath("closedoor.mp3"))
end

function LHDBSound.dropGem()
    MusicManager.playEffect(getPath("drop_gems.mp3"))
end

function LHDBSound.settleReward()
    MusicManager.playEffect(getPath("lingqu.mp3"))
end

function LHDBSound.openDoor()
    MusicManager.playEffect(getPath("movedoor.mp3"))
end

function LHDBSound.removeGems()
    MusicManager.playEffect(getPath("remove_gems.mp3"))
end

function LHDBSound.removeKey()
    MusicManager.playEffect(getPath("remove_key.mp3"))
end

function LHDBSound.getScore()
    MusicManager.playEffect(getPath("score.mp3"))
end

function LHDBSound.shootBall()
    MusicManager.playEffect(getPath("shoot_ball.mp3"))
end

function LHDBSound.throwGems()
    MusicManager.playEffect(getPath("throw_gems.mp3"))
end

return LHDBSound
