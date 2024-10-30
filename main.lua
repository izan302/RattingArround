
local StateMachine = StateMachine or require "src/FSM/StateMachine"
local MenuState = MenuState or require "src/FSM/States/GameStates/Menu"
local PlayState = PlayState or require "src/FSM/States/GameStates/Play"

actorList = {}

function love.load()
  w, h = love.graphics.getDimensions()
  
  stateMachine = StateMachine()
  stateMachine:addState("play", PlayState())
  stateMachine:changeState("play")
end

function love.update(dt)
  stateMachine:update(dt)
end

function love.draw()
  stateMachine:draw()
end