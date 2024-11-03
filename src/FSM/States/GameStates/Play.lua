--Librerias
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"


--Dependencias
local Actor = Actor or require "src/actor"
local Rat = Rat or require "src/Rat"
local StaticGuard = StaticGuard or require "src/StaticGuard"
local MovingGuard = MovingGuard or require "src/MovingGuard"
local House = House or require "src/House"
local Level = Level or require "src/Level"

-- Self
local PlayState = Object:extend()

function PlayState:enter()
    table.insert(actorList, Level("src/Maps/Map_1.lua"))
    love.graphics.setColor(1, 1, 1, 1)

    patrolPoints = {}
    table.insert(patrolPoints, {x = 143, y = 206})
    table.insert(patrolPoints, {x = 591, y = 172})
    table.insert(patrolPoints, {x = 143, y = 491})
    table.insert(patrolPoints, {x = 623, y = 460})
    table.insert(actorList, MovingGuard(64, patrolPoints))

    table.insert(actorList, Rat(w/2, h/4*3))
    self.toolCooldown = 0.5
    self.toolCooldownTimer = 0.5 
end

function PlayState:update(dt)
    -- TOOL for listing Guard points disable on release
    self.toolCooldownTimer = self.toolCooldownTimer+dt
    if love.mouse.isDown(1) and self.toolCooldownTimer > self.toolCooldown then
        local mouseX, mouseY = love.mouse.getPosition()
        print("X: "..mouseX.." | Y: "..mouseY)
       -- print(map:convertPixelToTile(love.mouse.getPosition()))
        self.toolCooldownTimer = 0
    end
    -- END of TOOL
    for _, v in pairs(actorList) do
        v:update(dt)
    end
end

function PlayState:draw()
    for _, v in ipairs(actorList) do
        if v:is(Level) then
            v:draw()
        end
    end

    for _, v in ipairs(actorList) do
        if not v:is(Level) then
            v:draw()
        end
    end
end

function PlayState:exit()
    
end

return PlayState
