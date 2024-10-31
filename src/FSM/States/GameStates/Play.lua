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

    local patrolPoints = {}
    table.insert(patrolPoints, {x = 20, y = 20})
    table.insert(patrolPoints, {x = 204, y = 20})
    table.insert(patrolPoints, {x = 204, y = 239})
    table.insert(patrolPoints, {x = 454, y = 239})
    table.insert(actorList, MovingGuard(64, patrolPoints))

    self.toolCooldown = 0.5
    self.toolCooldownTimer = 0.5 
end

function PlayState:update(dt)
    -- TOOL for listing Guard points disable on release
    self.toolCooldownTimer = self.toolCooldownTimer+dt
    if love.mouse.isDown(1) and self.toolCooldownTimer > self.toolCooldown then
        local mouseX, mouseY = love.mouse.getPosition()
        print("X: "..mouseX.." | Y: "..mouseY)
        self.toolCooldownTimer = 0
    end
    -- END of TOOL
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
