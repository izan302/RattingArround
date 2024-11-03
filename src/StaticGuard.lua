-- Librerías
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"
local Rat = Rat or require "src/Rat"

-- Self
local StaticGuard = Actor:extend()

math.randomseed(os.time())
function StaticGuard:new(_x, _y, _lookingRight)
    StaticGuard.super.new(self, "src/textures/guard.png", _x, _y, 0)
    
    self.stateMachine = StateMachine()
    self.changeDirectionCooldown = math.random(5, 8) -- Tiempo que tarda en darse la vuelta EN SEGUNDOS
    self.changeDirectionCooldownTimer = love.math.random(0, 5)

    self.conoLongitud = 150
    self.conoAngulo = 0.5

    if _lookingRight then
        self.forwardOriginal = Vector(1, 0)
        self.forwardAlt = Vector(0, 1)
    else
        self.forwardOriginal = Vector(-1, 0)
        self.forwardAlt = Vector(0, 1)
    end
    self.forward = self.forwardOriginal

    self.spinCooldownTimer = 0
    self.spinCooldown = 0.3
end

function StaticGuard:update(dt)
    self.changeDirectionCooldownTimer = self.changeDirectionCooldownTimer + dt
    self.spinCooldownTimer = self.spinCooldownTimer + dt

    if self.changeDirectionCooldownTimer >= self.changeDirectionCooldown then
        if self.forward == self.forwardOriginal then
            self.forward = self.forwardAlt
        else
            self.forward = self.forwardOriginal
        end
        self.changeDirectionCooldownTimer = 0
        self.spinCooldownTimer = 0
    end

    for _,k in ipairs(actorList) do
        if k:is(Rat) then
            local dirToRat = Vector(k.position.x - self.position.x, k.position.y - self.position.y):normalized()
            local dotProduct = self.forward.x * dirToRat.x + self.forward.y * dirToRat.y
            local angleToRat = math.acos(math.max(-1, math.min(1, dotProduct)))

            if angleToRat <= self.conoAngulo and (k.position - self.position):len() <= self.conoLongitud and k.stateMachine:getCurrentStateName() == "playing" then
                if self.spinCooldownTimer >= self.spinCooldown then
                    stateMachine:changeState("gameOver")
                end
            end
        end
    end
end

function StaticGuard:draw()
    local triangle1x = (math.cos(math.atan2(self.forward.y, self.forward.x)+self.conoAngulo)*self.conoLongitud)+self.position.x
    local triangle1y = (math.sin(math.atan2(self.forward.y, self.forward.x)+self.conoAngulo)*self.conoLongitud)+self.position.y
    local triangle2x = (math.cos(math.atan2(self.forward.y, self.forward.x)-self.conoAngulo)*self.conoLongitud)+self.position.x
    local triangle2y = (math.sin(math.atan2(self.forward.y, self.forward.x)-self.conoAngulo)*self.conoLongitud)+self.position.y

    love.graphics.setColor(1, 1, 0.2, 0.2)
    love.graphics.polygon("fill", triangle1x,triangle1y,triangle2x,triangle2y,self.position.x,self.position.y)
    love.graphics.setColor(1, 1, 1, 1)

    local xx = self.position.x
    local ox = self.origin.x
    local yy = self.position.y
    local oy = self.origin.y
    local rr = self.rot
    love.graphics.draw(self.image, xx, yy, rr, self.scale, 1, ox, oy)
end

return StaticGuard