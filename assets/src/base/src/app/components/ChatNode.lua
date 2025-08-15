local GameChatWin = require "app.win.game.GameChatWin"

local ChatNode = class("ChatNode", function()
    return cc.Node:create()
end)

function ChatNode:ctor()
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function ChatNode:create()
    local node = GameChatWin:new()

    return node
end

function ChatNode:onEnter()
    self:addListenerEvent()
end

function ChatNode:onExit()
    self:removeListenerEvent()
end

function ChatNode:cleanup()
    self:unregisterScriptHandler()
end

return ChatNode
