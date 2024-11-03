local StateMachine = StateMachine or require "src/FSM/StateMachine"
local PlayState = PlayState or require "src/FSM/States/GameStates/Play"
local MenuState = MenuState or require "src/FSM/States/GameStates/Menu"
local WinState = WinState or require "src/FSM/States/GameStates/Win"
local GameOverState = GameOverState or require "src/FSM/States/GameStates/GameOver"
local IntroState = InstroState or require "src/FSM/States/GameStates/Intro"

-- GLOBAL
actorList = {}

--[[===========================================================================================================
                                                  NO TOCAR
===============================================================================================================]]
function love.load()
  w, h = love.graphics.getDimensions()

  stateMachine = StateMachine()
  stateMachine:addState("play", PlayState())
  stateMachine:addState("menu", MenuState())
  stateMachine:addState("win", WinState())
  stateMachine:addState("intro", IntroState())
  stateMachine:addState("gameOver", GameOverState())
  stateMachine:changeState("intro") -- Carga el estado "play" para modificar la pantalla de juego, id a "src/FSM/States/GameStates/Play"
end

function love.update(dt)
  stateMachine:update(dt)
end

function love.draw()
  stateMachine:draw()
end