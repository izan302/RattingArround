local Object = Object or require "lib/object"

StateMachine = Object:extend()

function StateMachine:new()
    self.states = {}
    self.currentState = nil
end

function StateMachine:addState(name, state)
    if name and state then
        self.states[name] = state
    else
        print("Define nombre o estado")
    end
end

function StateMachine:changeState(name)
    if self.states[name] then
        if self.currentState and self.currentState.exit then
            self.currentState:exit()
        end
        self.currentState = self.states[name]
        if self.currentState.enter then
            self.currentState:enter()
        end
    else
        print("Estado "..name.." no existe")
    end
end

function StateMachine:update(dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

function StateMachine:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
    if self:is(House) then
        self.currentState.draw()
    end
end

function StateMachine:getCurrentStateName()
    if self.currentState then
        for k, v in pairs(self.states) do
            if self.currentState == v then
                return k
            end
        end
    end
end

return StateMachine