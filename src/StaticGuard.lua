-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"

-- Self
local StaticGuard = Actor:extend()

function StaticGuard:new(_x, _y)
    StaticGuard.super.new(self, "src/textures/guard.png", _x, _y, 0)
    
    self.stateMachine = StateMachine()
    self.changeDirectionCooldown = 5 -- Tiempo que tarda en darse la vuelta EN SEGUNDOS
    self.changeDirectionCooldownTimer = 0
end

function StaticGuard:update(dt)
    self.changeDirectionCooldownTimer = self.changeDirectionCooldownTimer + dt
    if self.changeDirectionCooldownTimer >= self.changeDirectionCooldown then
        -- CAMBIAR DIRECCIÓN
    end
end

function StaticGuard:draw()

end

return StaticGuard