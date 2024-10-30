local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"
local Actor = Actor or require "src/actor"

local PlayState = Object:extend()

function PlayState:enter()

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
