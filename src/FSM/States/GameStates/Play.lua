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
    table.insert(actorList, StaticGuard(w/2, h/2))
    table.insert(actorList, MovingGuard(w/2-32, h/2, 100))
    table.insert(actorList, House(w/2, h/2+32))
    table.insert(actorList, Rat(16,16))
end

function PlayState:update(dt)
    for _, v in ipairs(actorList) do
        v:update(dt)
      end
end

function PlayState:draw()
    for _, v in ipairs(actorList) do
        v:draw()
    end
end

function PlayState:exit()
    
end

return PlayState
