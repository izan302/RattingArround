-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"

-- Self
local MovingGuard = Actor:extend()

function MovingGuard:new(_x, _y, _speed, _patrolPoints)
    MovingGuard.super.new(self, "src/textures/guard.png", _x, _y, _speed)
    self.patrolPoints = _patrolPoints
--[[===========================================================================================================
                                                PATROLLING STATE
===============================================================================================================]]
self.stateMachine:addState("patrolling", {
    enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("patrolling")

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
                                                GUARDING STATE
===============================================================================================================]]
    self.stateMachine:addState("guarding", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("guarding")
            self.guardingCooldown = 5 -- Tiempo que se pasa dentro de una cas EN SEGUNDOS
            self.guardingCooldownTimer = 0 
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            self.guardingCooldownTimer = self.guardingCooldownTimer + dt 

            if self.guardingCooldownTimer >= self.guardingCooldown then -- Si ha pasado el tiempo establecido para volver a patrullar, cambia su estado a patrullando
                self.stateMachine:changeState("patrolling")
            end
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

    self.stateMachine:changeState("patrolling") -- Inicia al guardia en estado "patrolling"
end

return MovingGuard