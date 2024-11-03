local Object = Object or require "lib/Object"

local Menu = Object:extend()
--[[
    Para hacer un menú, el último parámetro debe ser una tabla
    {
        text = "TEXTO A MOSTRAR",
        type = "referencia al comportamiento que quieras hacer",
        selectable = true (si se puede seleccionar como opción)
        (si es de tipo input)
        base = "tamaño del input"
        (si es del tipo scorePoints)
        points = "numero a mostrar"
    }
]]
function Menu:new(_fontFile, _titleText, _titleSize, _optionSize, _options)
    self.choice = 1

    self.fontFile = _fontFile
    
    self.titleSize = _titleSize
    self.titleText = _titleText
    self.fontTitle = love.graphics.newFont(self.fontFile, self.titleSize)
    
    self.optionSize = _optionSize
    self.menuOptions = _options
    self.fontOption = love.graphics.newFont(self.fontFile, self.optionSize)

    self.menuCooldown = 0
    self.menuCooldownTime = 0.3
    
    self.writingInput = false

    self.bienvenido = love.audio.newSource("src/Audios/mouse.wav","static")
    self.music = love.audio.newSource("src/Audios/MenuSound.wav","static")
    self.music:setVolume(0.1) 

    love.audio.play(self.bienvenido)

    for k, v in ipairs(self.menuOptions) do
        if v.type == "input" then
            self.inputCharSelected = 1
            self.inputText = v.base
            self.lastLetter = string.byte(self.inputText, self.inputCharSelected)
            self.inputShowCharacter = true
            self.inputBlinkCooldown = 0
            self.inputBlinkCooldownTime = 0.3
        end
    end
end



function Menu:update(dt)

    love.audio.play(self.music)
    self.menuCooldown = self.menuCooldown+dt
    if self.menuOptions[self.choice].type == "input" then
        self.inputBlinkCooldown = self.inputBlinkCooldown+dt
    end
    if self.writingInput and self.menuCooldown > self.menuCooldownTime then
        if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and self.menuCooldown > self.menuCooldownTime then
            self.menuCooldown = 0
            if self.lastLetter+1 == 91 then
                self.lastLetter = 65
            else
                self.lastLetter = self.lastLetter+1
            end
            self.inputText = changeChar(self.inputText, self.inputCharSelected, string.char(self.lastLetter))
        end
        if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and self.menuCooldown > self.menuCooldownTime then
            self.menuCooldown = 0
            if self.lastLetter-1 == 64 then
                self.lastLetter = 90
            else
                self.lastLetter = self.lastLetter-1
            end
            self.inputText = changeChar(self.inputText, self.inputCharSelected, string.char(self.lastLetter))
        end
    elseif not self.writingInput and self.menuCooldown > self.menuCooldownTime then
        if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and self.menuCooldown > self.menuCooldownTime then
            self.menuCooldown = 0
            if self.choice == 1 then
                self.choice = #self.menuOptions
            else
                self.choice = self.choice-1
            end
            if not self.menuOptions[self.choice].selectable then
                if self.choice == 1 then
                    self.choice = #self.menuOptions
                else
                    self.choice = self.choice-1
                end
            end
        end
        if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and self.menuCooldown > self.menuCooldownTime then
            self.menuCooldown = 0
            if self.choice == #self.menuOptions then
                self.choice = 1
            else
                self.choice = self.choice+1
            end
            if not self.menuOptions[self.choice].selectable then
                if self.choice == #self.menuOptions then
                    self.choice = 1
                else
                    self.choice = self.choice+1
                end
            end
        end
    end
    
    if (love.keyboard.isDown("return") or love.keyboard.isDown("space")) and self.menuCooldown > self.menuCooldownTime then
        self.menuCooldown = 0
        if self.menuOptions[self.choice].type == "play" then
            stateMachine:changeState("play")
        elseif self.menuOptions[self.choice].type == "score" then
            
        elseif self.menuOptions[self.choice].type == "exit" then
            os.exit()
        elseif self.menuOptions[self.choice].type == "saveToMainMenu" then

        elseif self.menuOptions[self.choice].type == "mainMenu" then
            
        elseif self.menuOptions[self.choice].type == "input" then
            if not self.writingInput then
                self.writingInput = true
                self.inputCharSelected = 1
            elseif self.inputCharSelected < #self.menuOptions[self.choice].base then
                self.inputCharSelected = self.inputCharSelected+1
                self.lastLetter = string.byte(self.inputText, self.inputCharSelected)
            else
                self.writingInput = false
            end
        end
    end
    
    if self.menuOptions[self.choice].type == "input" and self.inputBlinkCooldown > self.inputBlinkCooldownTime then
        self.inputBlinkCooldown = 0
        self.inputShowCharacter = not self.inputShowCharacter
    end
end

function Menu:draw()
    love.graphics.setFont(self.fontTitle)
    love.graphics.printf(self.titleText, 0, h/6, w, "center")
    love.graphics.setFont(self.fontOption)

    local text = ""
    local lastTitleSize = 0
    for i = 1, #self.menuOptions do
        if self.menuOptions[i].type == "totalScore" then
            text = self.menuOptions[i].text..totalScore
        elseif self.menuOptions[i].type == "input" then
            if not self.writingInput then
                text = self.menuOptions[i].text..self.inputText
            else
                if not self.inputShowCharacter then
                    modText = self.inputText:sub(1, self.inputCharSelected - 1) .. " " .. self.inputText:sub(self.inputCharSelected + 1)
                    text = self.menuOptions[i].text..modText
                else
                    text = self.menuOptions[i].text..self.inputText
                end
            end
        elseif self.menuOptions[i].type == "scorePoints" then
            text = self.menuOptions[i].text.." = "..self.menuOptions[i].points
        else
            text = self.menuOptions[i].text
        end

        if self.choice == i and self.menuOptions[i].selectable then
            text = "- "..text.." -"
        end
        if i == 1 then
            lastTitleSize = (h/2)-self.optionSize
            love.graphics.printf(text, 0, lastTitleSize, w, "center")
        else
            lastTitleSize = lastTitleSize+self.optionSize+self.optionSize/2
            love.graphics.printf(text, 0, lastTitleSize, w, "center")
        end
        
    end
end

function changeChar(str, char, newChar)
    local firstHalf = string.sub(str, 1, char-1)
    local secondHalf = string.sub(str, char+1)
    return firstHalf..newChar..secondHalf
end

return Menu