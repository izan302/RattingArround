-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"

-- Dependencias
local Actor = Actor or require "src/Actor"

--Self
local Rat = Actor:extend()

function Rat:new(_x, _y)
    Rat.super.new(self, "src/textures/rat.png", _x, _y, 128)
    self.rot = 0
    self.collider = world:newBSGRectangleCollider(self.position.x, self.position.y, self.width/2, self.height, 5)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("Rat", {ignores = {'Door'}})

    -- Rectángulo rojo fijo
    self.redRectX = 0
    self.redRectY = 0
  
    -- Rectángulo verde en movimiento
    self.greenRectX = 0
    self.greenRectY = 0
    self.greenSpeed = 100  -- Velocidad en píxeles por segundo

    self.infectedpoints = 0
    self.cooldownBoton = 0

--[[===========================================================================================================
                                            PLAYING STATE
===============================================================================================================]]
    self.stateMachine:addState("playing", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("playing")
            self.forward = Vector(0, 0)
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            self.position.x = self.collider:getX()
            self.position.y = self.collider:getY()

            local velocidadX = 0
            local velocidadY = 0
            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
                velocidadY = self.speed * -1
            end
            if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
                velocidadY = self.speed           
            end
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                velocidadX = self.speed
            end
            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                velocidadX = self.speed * -1
            end
            if self.collider:enter("Door") then
                local other = self.collider:getEnterCollisionData("Door").collider
                
                self.stateMachine:changeState("infecting")
            end
            self.collider:setLinearVelocity(velocidadX, velocidadY)
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
                                            INFECTING STATE
===============================================================================================================]]
    self.stateMachine:addState("infecting", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("infecting")
            -- Coloca de manera random el rectángulo rojo
            local posX = love.graphics.getWidth() / 2 - 150
            local posY = love.graphics.getHeight() / 2 - 10
            self:redrawRedRect(posX, posY)  -- Método para establecer la posición del rectángulo rojo
            self.greenRectX = posX
            self.greenRectY = posY
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            if love.keyboard.isDown("escape") then
                self.stateMachine:changeState("playing")
            end

            -- Movimiento Rectángulo Verde
            self.greenRectX = self.greenRectX + self.greenSpeed * dt

            if self.greenRectX <= love.graphics.getWidth() / 2 - 150 or self.greenRectX + 10 >= love.graphics.getWidth() / 2 + 150 then
                self.greenSpeed = -self.greenSpeed
            end
                
            -- SkillChecks
            local redColisionRect = self.redRectX + 30 -- 30 es la anchura del rectángulo rojo
            local greenColisionRect = self.greenRectX + 10 -- 10 es la anchura del rectángulo verde

            self.cooldownBoton = self.cooldownBoton + dt

            -- Verifica si el espacio se presiona cuando el rectángulo verde está sobre el rojo
            if love.keyboard.isDown("space") and self.cooldownBoton > 1 then
                if self.greenRectX < redColisionRect and greenColisionRect > self.redRectX and
                   self.greenRectY == self.redRectY then
                    self.infectedpoints = self.infectedpoints + 1
                    print(self.infectedpoints)
                    self.cooldownBoton = 0
                    -- Cambia de posición el rectángulo rojo
                    self:redrawRedRect(love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 10)
                    
                    self.greenSpeed = self.greenSpeed * 1.4 
                    if self.infectedpoints >= 5 then
                        self.stateMachine:changeState("playing")
                        self.infectedpoints = 0 
                        self.greenSpeed = 100
                    end
                else
                    self:redrawRedRect(love.graphics.getWidth() / 2 - 150, love.graphics.getHeight() / 2 - 10)
                    self.cooldownBoton = 0
                end    
            end
        end,
        draw = function () -- Se ejecuta con cada draw si el estado está activo
            local xx = self.position.x
            local ox = self.origin.x
            local yy = self.position.y
            local oy = self.origin.y
            local rr = self.rot
            love.graphics.draw(self.image, xx, yy, rr, 1, 1, ox, oy)

            -- Dibuja el fondo (rectángulo blanco)
            love.graphics.setColor(1, 1, 1) 
            local posX = love.graphics.getWidth() / 2 - 150
            local posY = love.graphics.getHeight() / 2 - 10
            love.graphics.rectangle("fill", posX, posY, 300, 20)

            -- Rectángulo Rojo
            love.graphics.setColor(1, 0, 0) 
            love.graphics.rectangle("fill", self.redRectX, self.redRectY, 30, 20)
            
            -- Rectángulo Verde
            love.graphics.setColor(0, 1, 0) 
            love.graphics.rectangle("fill", self.greenRectX, self.greenRectY, 10, 20)
            
            love.graphics.setColor(1, 1, 1, 1)
        end,
        exit = function () -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState() a cualquier otro estado

        end
    })

    -- Método para establecer la posición del rectángulo rojo
    function self:redrawRedRect(posX, posY)
        self.redRectX = love.math.random(posX, posX + 300 - 30)
        self.redRectY = love.math.random(posY, posY + 20 - 20)
    end

    self.stateMachine:changeState("playing") -- Hace que la rata empiece con el estado "playing"
end

return Rat
