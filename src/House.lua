
-- Dependencias
local Actor = Actor or require "src/Actor"
local Rat = Rat or require "src/Rat"

-- Self
local House = Actor:extend()

function House:new(_x, _y, _collider, _doorCollider)
    House.super.new(self, "src/textures/skull.png", _x, _y)
    self.collider = _collider
    self.doorCollider = _doorCollider

    -- Rectángulo rojo fijo
    self.redRectX = 0
    self.redRectY = 0

    -- Rectángulo verde en movimiento
    self.greenRectX = 0
    self.greenRectY = 0
    self.greenSpeed = 100 -- Velocidad en píxeles por segundo

    self.infectedpoints = 0
    self.infectedGoal = 5
    self.cooldownBoton = 1

    self.failSkill = love.audio.newSource("src/Audios/failskill.wav","static")
    self.correctskill = love.audio.newSource("src/Audios/correctskill.wav","static")
    self.correctskill:setVolume(0.4) 
    
--[[===========================================================================================================
                                                IDLE STATE
===============================================================================================================]]
    self.stateMachine:addState("idle", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("idle")

        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            if self.doorCollider:enter("Rat") then
                self.stateMachine:changeState("gettingInfected")
                for _, actor in pairs(actorList) do
                    if actor:is(Rat) then
                        actor.stateMachine:changeState("infecting")
                    end
                end
            end
        end,
        draw = function()  -- Se ejecuta con cada draw si el estado está activo

        end,
        exit = function()  -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

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
        draw = function()  -- Se ejecuta con cada draw si el estado está activo

        end,
        exit = function()  -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

    --[[===========================================================================================================
                                                    INFECTED STATE
===============================================================================================================]]
    self.stateMachine:addState("gettingInfected", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("infected")
            -- Coloca de manera random el rectángulo rojo
            local posX = love.graphics.getWidth() / 2 - 150
            local posY = love.graphics.getHeight() / 2 - 10
            self:redrawRedRect(posX, posY) -- Método para establecer la posición del rectángulo rojo
            self.greenRectX = posX
            self.greenRectY = posY
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            -- Movimiento Rectángulo Verde
            self.greenRectX = self.greenRectX + self.greenSpeed * dt

            if self.greenRectX <= love.graphics.getWidth() / 2 - 150 --[[or self.greenRectX + 10 >= love.graphics.getWidth() / 2 + 150]] then
                self.greenSpeed = -self.greenSpeed
                self.greenRectX = self.greenRectX + 12
            end
            if self.greenRectX + 10 >= love.graphics.getWidth() / 2 + 150 then
                self.greenSpeed = -self.greenSpeed
                self.greenRectX = self.greenRectX - 12
            end

            -- SkillChecks
            local redColisionRect = self.redRectX + 30     -- 30 es la anchura del rectángulo rojo
            local greenColisionRect = self.greenRectX + 10 -- 10 es la anchura del rectángulo verde

            self.cooldownBoton = self.cooldownBoton + dt

            -- Verifica si el espacio se presiona cuando el rectángulo verde está sobre el rojo
            if love.keyboard.isDown("space") and self.cooldownBoton > 1 then
                if self.greenRectX < redColisionRect and greenColisionRect > self.redRectX and
                    self.greenRectY == self.redRectY then
                    self.infectedpoints = self.infectedpoints + 1
                    love.audio.play(self.correctskill)
                    self.cooldownBoton = 0
                    -- Cambia de posición el rectángulo rojo
                    self:redrawRedRect(love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 10)

                    self.greenSpeed = self.greenSpeed * 1.4
                    if self.infectedpoints >= self.infectedGoal then
                        self.stateMachine:changeState("infected")
                        self.infectedpoints = 0
                        self.greenSpeed = 100
                    end
                else
                    love.audio.play(self.failSkill)
                    self:redrawRedRect(love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 10)
                    self.cooldownBoton = 0
                end
            end
            if love.keyboard.isDown("escape") then
                self.stateMachine:changeState("idle")
            end
        end,
        draw = function()  -- Se ejecuta con cada draw si el estado está activo

        -- Dibuja el fondo (rectángulo blanco)
        love.graphics.setFont(love.graphics.newFont("Menu.ttf", 30))
            love.graphics.setColor(1, 1, 1)
            local posX = love.graphics.getWidth() / 2 - 150
            local posY = love.graphics.getHeight() / 2 - 10
            love.graphics.rectangle("fill", posX, posY, 300, 20)
            love.graphics.printf(self.infectedGoal-self.infectedpoints, 0, posY-50, w, "center")
            love.graphics.setFont(love.graphics.newFont("Menu.ttf", 20))
            love.graphics.printf("PRESS \"SPACE\" WHEN THE GREEN SQUARE IS IN THE RED SQUARE", 0, posY+50, w, "center")

            -- Rectángulo Rojo
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", self.redRectX, self.redRectY, 30, 20)

            -- Rectángulo Verde
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.greenRectX, self.greenRectY, 10, 20)

            love.graphics.setColor(1, 1, 1, 1)
        end,
        exit = function()  -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

    self.stateMachine:addState("infected", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("guarded")
            self.collider:isActive(false)
            self.doorCollider:isActive(true)
            for _, actor in pairs(actorList) do
                if actor:is(Rat) then
                    actor.stateMachine:changeState("playing")
                end
            end
            currentScore = currentScore + 1
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo

        end,
        draw = function()  -- Se ejecuta con cada draw si el estado está activo
            local xx = self.position.x
            local ox = self.origin.x
            local yy = self.position.y
            local oy = self.origin.y
            local rr = self.rot
            love.graphics.draw(self.image, xx+self.width/2, yy+self.height/2, rr, 1, 1, ox, oy)
        end,
        exit = function()  -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })
    -- Método para establecer la posición del rectángulo rojo
    function self:redrawRedRect(posX, posY)
        self.redRectX = love.math.random(posX, posX + 300 - 30)
        self.redRectY = love.math.random(posY, posY + 20 - 20)
    end

    self.stateMachine:changeState("idle") -- Inicia la casa en estado idle
end

return House