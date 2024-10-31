-- Librerías
local Object = Object or require "lib/object"
local Vector = Vector or require "lib/vector"
local Sti = Sti or require "lib/sti"
local WindField = WindField or require "lib/windfield"

-- Dependencias
local Actor = Actor or require "src/Actor"

-- Self
local Level = Object:extend()

function Level:new(_map)
    tx, ty = 0, 0
    world = WindField.newWorld(0, 0)
    map = Sti(_map)
    world:addCollisionClass("Rat")
    world:addCollisionClass("Wall")
    world:addCollisionClass("Door")

    self:loadColliders()
end

function Level:update(dt)
    world:update(dt)
    map:update(dt)
end

function Level:draw()
    map:draw(tx, ty)
    world:draw()
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
    for _, collider in pairs(map.layers["Doors"].objects) do
        if collider.shape == "rectangle" then 
            local newCollider = world:newRectangleCollider(collider.x, collider.y, collider.width, collider.height)
            newCollider:setType("static")
            newCollider:setCollisionClass("Door")
        elseif collider.shape == "polygon" then
            local newCollider = world:newPolygonCollider(collider.polygon)
            newCollider:setType("static")
            newCollider:setCollisionClass("Door")
        end
    end
end

return Level