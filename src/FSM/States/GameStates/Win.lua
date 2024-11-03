local Object = Object or require "lib/object"
local Menu = Menu or require "src/menu"
local WinState = Object:extend()

function WinState:enter()
    actorList = {}
    local menuOptions = {}
    --self.background = love.graphics.newImage("src/textures/background.jpeg")
    table.insert(menuOptions, {text = "NEXT LEVEL", type = "play", selectable = false})
    table.insert(menuOptions, {text = "EXIT", type = "exit", selectable = true})
    actorList["Menu"] = Menu("Menu.ttf", "YOU WIN", 50, 30, menuOptions)
end

function WinState:update(dt)
    for _, v in pairs(actorList) do
        v:update(dt)
    end
end

function WinState:draw()
    for _, v in pairs(actorList) do
        v:draw()
    end
end

function WinState:exit()
    actorList["Menu"] = nil
end

return WinState
