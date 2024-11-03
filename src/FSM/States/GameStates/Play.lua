--Librerias
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"


--Dependencias
local House = House or require "src/House"
local Level = Level or require "src/Level"

-- Self
local PlayState = Object:extend()

-- Global
scoreObjective = 0
currentScore = 0
function PlayState:enter()
    table.insert(actorList, Level("src/Maps/Map_1.lua"))
    love.graphics.setColor(1, 1, 1, 1)
    
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
    print(currentScore, scoreObjective)
    if currentScore == scoreObjective then
        print("win")
        stateMachine:changeState("win")
    end
end

function PlayState:draw()
    for _, v in ipairs(actorList) do
        if v:is(Level)  then
            v:draw()
        end
    end

    for _, v in ipairs(actorList) do
        if v:is(House)  then
            v:draw()
        end
    end

    for _, v in ipairs(actorList) do
        if not v:is(Level) and not v:is(House) then
            v:draw()
        end
    end
end

function PlayState:exit()
    w = 800
    h = 480
    love.window.setMode(w, h)
    currentScore = 0
end

return PlayState
