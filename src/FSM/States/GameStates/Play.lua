--Librerias
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

--Dependencias
local Actor = Actor or require "src/actor"
local Rat = Rat or require "src/Rat"
local StaticGuard = StaticGuard or require "src/StaticGuard"
local MovingGuard = MovingGuard or require "src/MovingGuard"
local House = House or require "src/House"

-- Self
local PlayState = Object:extend()

function PlayState:enter()
    love.graphics.setColor(1, 1, 1, 1)
    actorList["Rat"] = Rat(w/2, h/2)    
end

function PlayState:update(dt)
    for _, v in pairs(actorList) do
        v:update(dt)
    end
end

function PlayState:draw()
    for _, v in pairs(actorList) do
        v:draw()
    end
end

function PlayState:exit()
    
end

return PlayState
