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
    self.collider:setCollisionClass("Rat")
--[[===========================================================================================================
                                            PLAYING STATE
===============================================================================================================]]
    self.stateMachine:addState("playing", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("playing")
            self.forward = Vector(0,0)
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

        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            if love.keyboard.isDown("escape") then
                self.stateMachine:changeState("playing")
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

    self.stateMachine:changeState("playing") -- Hace que la rata empiece con el estado "playing"
end

function Rat:VisualCheck(vectorX, vectorY, enemyX, enemyY)
    local ratVectorX = self.position.x-enemyX
    local ratVectorY = self.position.y-enemyY
    local distancia = math.sqrt(ratVectorX * ratVectorX + ratVectorY * ratVectorY)
    local angle = math.atan2(ratVectorY, ratVectorX) - math.atan2(vectorY, vectorX);
    
    if distancia < 150 then 
        if angle < 1 and angle > -1 then
        print("dead")
        else
        print("safe")
        end
    end

end

return Rat