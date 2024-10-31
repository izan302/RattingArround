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
--[[===========================================================================================================
                                            PLAYING STATE
===============================================================================================================]]
    self.stateMachine:addState("playing", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("playing")
            self.forward = Vector(0,0)
        end,
        update = function(_, dt) -- Se ejecuta con cada update si el estado está activo
            if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
                self.forward = Vector(0, -1)
                self.position = self.position+self.forward*self.speed*dt
            end
            if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
                self.forward = Vector(0, 1)
                self.position = self.position+self.forward*self.speed*dt
            end
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
                self.forward = Vector(1, 0)
                self.position = self.position+self.forward*self.speed*dt
            end
            if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
                self.forward = Vector(-1, 0)
                self.position = self.position+self.forward*self.speed*dt
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

--[[===========================================================================================================
                                            INFECTING STATE
===============================================================================================================]]
    self.stateMachine:addState("infecting", {
        enter = function() -- Se ejecuta 1 vez, al hacer self.stateMachine:changeState("infecting")

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

    self.stateMachine:changeState("playing") -- Hace que la rata empiece con el estado "playing"
end

return Rat