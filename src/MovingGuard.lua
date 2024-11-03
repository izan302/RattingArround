-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"

-- Self
local MovingGuard = Actor:extend()

function MovingGuard:new(_speed, _patrolPoints)
    MovingGuard.super.new(self, "src/textures/guard.png", _patrolPoints[1].x, _patrolPoints[1].y, _speed) -- El primer punto de patrol es el spawnpoint
    self.patrolPoints = _patrolPoints
    self.currentPoint = 1
    self.isGoingBack = false
    self.scale = 1
--[[===========================================================================================================
                                                PATROLLING STATE
===============================================================================================================]]
self.stateMachine:addState("patrolling", {
    enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("patrolling
        
    end,
    update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
        local PatrolDirectionX = self.patrolPoints[self.currentPoint].x - self.position.x
        local PatrolDirectionY = self.patrolPoints[self.currentPoint].y - self.position.y
        local distancia = math.sqrt(PatrolDirectionX * PatrolDirectionX + PatrolDirectionY * PatrolDirectionY)
        if distancia > 1 then
            self.forward = Vector(PatrolDirectionX / distancia, PatrolDirectionY / distancia)
            if self.position.x > self.patrolPoints[self.currentPoint].x then
                self.scale = -1  
            else 
                self.scale = 1
            end
            self.position = self.position + self.forward * self.speed * dt
        else
            self:arrivedAtPoint()
        end
    end,
    draw = function () -- Se ejecuta con cada draw si el estado está activo
        
        triangle1x = (math.cos(math.atan2(self.forward.y, self.forward.x)+0.5)*150)+self.position.x
        triangle1y = (math.sin(math.atan2(self.forward.y, self.forward.x)+0.5)*150)+self.position.y
        triangle2x = (math.cos(math.atan2(self.forward.y, self.forward.x)-0.5)*150)+self.position.x
        triangle2y = (math.sin(math.atan2(self.forward.y, self.forward.x)-0.5)*150)+self.position.y
        
        love.graphics.setColor(1, 1, 0.2, 0.2)
        love.graphics.polygon("fill", triangle1x,triangle1y,triangle2x,triangle2y,self.position.x,self.position.y)
        love.graphics.setColor(1, 1, 1, 1)
        
        local xx = self.position.x
        local ox = self.origin.x
        local yy = self.position.y
        local oy = self.origin.y
        local rr = self.rot
        love.graphics.draw(self.image, xx, yy, rr, self.scale, 1, ox, oy)
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

        end,
        exit = function () -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

    self.stateMachine:changeState("patrolling") -- Inicia al guardia en estado "patrolling"
end

function MovingGuard:arrivedAtPoint()
    if self.currentPoint == #self.patrolPoints then
        self.isGoingBack = true
    elseif self.currentPoint == 1 then
        self.isGoingBack = false
    end
    if self.isGoingBack then
        self.currentPoint = self.currentPoint-1
    else
        self.currentPoint = self.currentPoint+1
    end
    -- if Point is NOT infected house then move to door and changeState("guarding")
end
return MovingGuard