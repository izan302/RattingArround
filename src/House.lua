-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"

-- Self
local House = Actor:extend()

function House:new(_x, _y)
    House.super.new(self, "src/textures/house.png", _x, _y)
--[[===========================================================================================================
                                                IDLE STATE
===============================================================================================================]]
    self.stateMachine:addState("idle", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("idle")

        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo

        end,
        draw = function () -- Se ejecuta con cada draw si el estado está activo
            local xx = self.position.x
            local ox = self.origin.x
            local yy = self.position.y
            local oy = self.origin.y
            local rr = self.rot
            love.graphics.draw(self.image, xx, yy, rr, 1, 1, ox, oy)
        end,
        exit = function () -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

--[[===========================================================================================================
                                                GUARDED STATE
===============================================================================================================]]
    self.stateMachine:addState("guarded", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("guarded")

        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo

        end,
        draw = function () -- Se ejecuta con cada draw si el estado está activo
            local xx = self.position.x
            local ox = self.origin.x
            local yy = self.position.y
            local oy = self.origin.y
            local rr = self.rot
            love.graphics.draw(self.image, xx, yy, rr, 1, 1, ox, oy)
        end,
        exit = function () -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

--[[===========================================================================================================
                                                    INFECTED STATE
===============================================================================================================]]
    self.stateMachine:addState("infected", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("infected")

        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo

        end,
        draw = function () -- Se ejecuta con cada draw si el estado está activo
            local xx = self.position.x
            local ox = self.origin.x
            local yy = self.position.y
            local oy = self.origin.y
            local rr = self.rot
            love.graphics.draw(self.image, xx, yy, rr, 1, 1, ox, oy)
        end,
        exit = function () -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

    self.stateMachine:changeState("idle") -- Inicia la casa en estado idle
end

return House