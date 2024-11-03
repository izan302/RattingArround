local Object = Object or require "lib/object"
local Menu = Menu or require "src/menu"
local GameOver = Object:extend()

function GameOver:enter()
    actorList = {}
    local menuOptions = {}
    --self.background = love.graphics.newImage("src/textures/background.jpeg")
    table.insert(menuOptions, {text = "RETRY", type = "play", selectable = true})
    table.insert(menuOptions, {text = "EXIT", type = "exit", selectable = true})
    actorList["Menu"] = Menu("Menu.ttf", "GAME OVER", 50, 30, menuOptions)
end

function GameOver:update(dt)
    for _, v in pairs(actorList) do
        v:update(dt)
    end
end

function GameOver:draw()
    for _, v in pairs(actorList) do
        v:draw()
    end
end

function GameOver:exit()
    actorList["Menu"] = nil
end

return GameOver
