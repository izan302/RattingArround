-- Librerías
local Object = Object or require "lib/object"
local Sti = Sti or require "lib/sti"
local WindField = WindField or require "lib/windfield"

-- Dependencias
local Rat = Rat or require "src/Rat"
local StaticGuard = StaticGuard or require "src/StaticGuard"
local MovingGuard = MovingGuard or require "src/MovingGuard"
local House = House or require "src/House"

-- Self
local Level = Object:extend()

function Level:new(_map)
    tx, ty = 0, 0
    map = Sti(_map)
    world = WindField.newWorld(0, 0)
    map:resize(map.width*32, map.height*32)
    h = map.height*32
    w = map.height*32
    love.window.setMode(w, h)
    world:addCollisionClass("Wall")
    world:addCollisionClass("Door")
    world:addCollisionClass("House")
    world:addCollisionClass("Rat" , {ignores = {'House'}})
    self:loadColliders()

    patrolPoints = {}
    table.insert(patrolPoints, {x = 120, y = 208})
    table.insert(patrolPoints, {x = 248, y = 208})
    table.insert(patrolPoints, {x = 373, y = 342})
    table.insert(patrolPoints, {x = 585, y = 178})
    table.insert(patrolPoints, {x = 380, y = 326})
    table.insert(patrolPoints, {x = 380, y = 534})
    table.insert(patrolPoints, {x = 148, y = 501})
    table.insert(patrolPoints, {x = 622, y = 472})
    table.insert(actorList, MovingGuard(64, patrolPoints, false))

    table.insert(actorList, StaticGuard(623, 172, false))
    table.insert(actorList, StaticGuard(106, 204, true))
    table.insert(actorList, StaticGuard(176, 492, false))

    patrolPoints = {}
    table.insert(patrolPoints, {x = 557, y = 458})
    table.insert(patrolPoints, {x = 681, y = 469})
    table.insert(patrolPoints, {x = 688, y = 342})
    table.insert(patrolPoints, {x = 562, y = 336})
    table.insert(actorList, MovingGuard(64, patrolPoints, true))
    table.insert(actorList, Rat(w/2, h/4*3))
end

function Level:update(dt)
    world:update(dt)
    map:update(dt)
end

function Level:draw()
    map:draw(tx, ty)
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle("fill", 0, 0, w, h)
    love.graphics.setColor(1, 1, 1, 1)
end

function Level:loadColliders()
    for _, collider in pairs(map.layers["Walls"].objects) do
        if collider.shape == "rectangle" then 
            local newCollider = world:newRectangleCollider(collider.x, collider.y, collider.width, collider.height)
            newCollider:setType("static")
            newCollider:setCollisionClass("Wall")
        elseif collider.shape == "polygon" then
            local newCollider = world:newPolygonCollider(collider.polygon)
            newCollider:setType("static")
            newCollider:setCollisionClass("Wall")
        end
    end

    for _, collider in pairs(map.layers["Houses"].objects) do
        if collider.shape == "rectangle" then
            for _, doorCollider in pairs(map.layers["Doors"].objects) do
                if doorCollider.shape == "rectangle" then 
                    if doorCollider.x <= collider.x+collider.width and doorCollider.x >= collider.x then
                        if doorCollider.y <= collider.y+collider.height and doorCollider.y >= collider.y then
                            local houseX = collider.x
                            local houseY = collider.y
                            local newCollider = world:newRectangleCollider(collider.x, collider.y, collider.width, collider.height)
                            newCollider:setType("static")
                            newCollider:setCollisionClass("House")

                            doorCollider = world:newRectangleCollider(doorCollider.x, doorCollider.y, doorCollider.width, doorCollider.height)
                            doorCollider:setType("static")
                            doorCollider:setCollisionClass("Door")

                            table.insert(actorList, House(houseX, houseY, newCollider, doorCollider))
                            scoreObjective = scoreObjective+1
                        end
                    end
                end
            end
        end
    end
end

return Level