local Object = Object or require "lib/object"
local Menu = Menu or require "lib/menu"
local MenuState = Object:extend()

function MenuState:enter()
    local menuOptions = {}
    background = love.graphics.newImage("src/textures/background.jpeg")
    color = love.graphics.getColor()
    table.insert(menuOptions, {text = "PLAY", type = "play", selectable = true})
    table.insert(menuOptions, {text = "EXIT", type = "exit", selectable = true})
    actorList["Menu"] = Menu("Menu.ttf", "Rattin' Around", 50, 30, menuOptions)
end

function MenuState:update(dt)
    for _, v in pairs(actorList) do
        v:update(dt)
    end
end

function MenuState:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(background, 0, 0, 0, 1, 0.5)
    love.graphics.setColor(1, 0, 0, 1)
    for _, v in pairs(actorList) do
        v:draw()
    end
end

function MenuState:exit()
    
end

return MenuState
