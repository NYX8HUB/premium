-- Biblioteca.lua
local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

-- ... (mantenha as configurações padrão anteriores)

-- Método AddToggle com default
function Tab:AddToggle(config)
    local elementCount = #self.elements
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 50)
    toggleFrame.Position = UDim2.new(0.05, 0, 0, elementCount * 55)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.content

    -- Título e subtexto
    local label = Instance.new("TextLabel")
    label.Text = config.title or "Toggle"
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.TextColor3 = defaultProperties.TextColor
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.Parent = toggleFrame

    if config.subtext then
        local subtextLabel = Instance.new("TextLabel")
        subtextLabel.Text = config.subtext
        subtextLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
        subtextLabel.Position = UDim2.new(0, 0, 0.5, 0)
        subtextLabel.TextColor3 = defaultProperties.SubtextColor
        subtextLabel.TextSize = defaultProperties.SubtextSize
        subtextLabel.Font = Enum.Font.Gotham
        subtextLabel.BackgroundTransparency = 1
        subtextLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtextLabel.Parent = toggleFrame
    end

    -- Botão do toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.Parent = toggleFrame

    -- Estado inicial com default
    local isToggled = not not config.default -- Converte para boolean
    toggleButton.Text = isToggled and "On" or "Off"
    toggleButton.BackgroundColor3 = isToggled 
        and self.lib._primaryColor 
        or Color3.fromRGB(80, 80, 80)

    -- Função de atualização
    local function updateToggle()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "On" or "Off"
        toggleButton.BackgroundColor3 = isToggled 
            and self.lib._primaryColor 
            or Color3.fromRGB(80, 80, 80)
        
        if config.callback then
            config.callback(isToggled)
        end
    end

    toggleButton.MouseButton1Click:Connect(updateToggle)

    -- Executa o callback inicial se necessário
    if config.callback and config.default then
        config.callback(isToggled)
    end

    table.insert(self.elements, toggleFrame)
    return self
end

-- ... (mantenha os outros métodos como AddSlider, AddButton, etc.)

return function()
    return Library.new()
end
