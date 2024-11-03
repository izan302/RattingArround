local Object = Object or require "lib/object"

local Intro = Object:extend()

function Intro:enter()
    self.ratNormal = love.graphics.newImage("src/textures/ratinicio.png")
    self.ratPointing = love.graphics.newImage("src/textures/ratpoint.png")
    self.ratGun = love.graphics.newImage("src/textures/ratgun.png")

    self.picture = self.ratNormal

    self.mouthHeight = 5
    self.cooldownMouth = 0.2
    self.cooldownMouthTimer = 0

    self.currentSource =  love.audio.newSource("src/Audios/intro1.mp3","static")
    love.audio.play(self.currentSource)
    self.pointTimer = 0
    self.mouthPosX = w/2+20
    self.mouthPosY = h/2+5

    self.gunActive = false
    self.mainMenuTimer = -1
    self.mainMenuCooldown = 0.5
end

function Intro:update(dt)
    self.cooldownMouthTimer = self.cooldownMouthTimer+dt
    if self.pointTimer >= 0 then
        self.pointTimer = self.pointTimer+dt
    end
    if self.mainMenuTimer >= 0 then
        self.mainMenuTimer = self.mainMenuTimer+dt
    end
    if self.pointTimer >= 2.5 then
        self.picture = self.ratPointing
        self.mouthPosX = self.mouthPosX+80
        self.mouthPosY = self.mouthPosY-20
        self.pointTimer = -1
    end
    if not self.currentSource:isPlaying() and not self.gunActive then
        self.currentSource = love.audio.newSource("src/Audios/intro2.mp3","static")
        love.audio.play(self.currentSource)
        self.picture = self.ratGun
        self.gunActive = true
        self.mouthPosX = self.mouthPosX+50
    end

    if self.gunActive and not self.currentSource:isPlaying() then
        self.currentSource = love.audio.newSource("src/Audios/intro3.mp3","static")
        love.audio.play(self.currentSource)
        self.mainMenuTimer = 0
    end

    if self.mainMenuTimer >= self.mainMenuCooldown then
        love.audio.stop()
        stateMachine:changeState("menu")
    end
    if self.cooldownMouthTimer >= self.cooldownMouth then
        if self.mouthHeight == 5 then
            self.mouthHeight = 10
        else
            self.mouthHeight = 5
        end
        self.cooldownMouthTimer = 0
    end

    if love.keyboard.isDown("escape") then
        love.audio.stop()
        stateMachine:changeState("menu")
    end
end

function Intro:draw()
    love.graphics.draw(self.picture, w/2-self.picture:getWidth()/2, h/2-self.picture:getHeight()/2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", self.mouthPosX, self.mouthPosY, 20, self.mouthHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("ESC to skip intro", 0, 0, w, "left")
end

function Intro:exit()
    music = love.audio.newSource("src/Audios/MenuSound.wav","static")
    music:setVolume(0.1)
    love.audio.play(music)
end

return Intro
