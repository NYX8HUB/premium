-- Biblioteca.lua
local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

-- Configurações padrão
local defaultProperties = {
    PrimaryColor = Color3.fromRGB(0, 170, 127),
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubtextColor = Color3.fromRGB(200, 200, 200),
    SubtextSize = 14,
    SliderColor = Color3.fromRGB(100, 100, 100)
}

-- Métodos da aba
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

function Tab:AddButton(config)
    local elementCount = #self.elements
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.9, 0, 0, 50)
    buttonFrame.Position = UDim2.new(0.05, 0, 0, elementCount * 55)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = self.content

    -- Título e subtexto
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0.5, 0)
    button.Text = config.title or "Button"
    button.BackgroundColor3 = self.lib._primaryColor
    button.TextColor3 = defaultProperties.TextColor
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 16
    button.Parent = buttonFrame

    if config.subtext then
        local subtextLabel = Instance.new("TextLabel")
        subtextLabel.Text = config.subtext
        subtextLabel.Size = UDim2.new(1, 0, 0.5, 0)
        subtextLabel.Position = UDim2.new(0, 0, 0.5, 0)
        subtextLabel.TextColor3 = defaultProperties.SubtextColor
        subtextLabel.TextSize = defaultProperties.SubtextSize
        subtextLabel.Font = Enum.Font.Gotham
        subtextLabel.BackgroundTransparency = 1
        subtextLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtextLabel.Parent = buttonFrame
    end

    -- Evento de clique
    button.MouseButton1Click:Connect(function()
        if config.callback then
            config.callback()
        end
    end)

    table.insert(self.elements, buttonFrame)
    return self
end

function Tab:AddSlider(config)
    local elementCount = #self.elements
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, elementCount * 65)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = self.content

    -- Título e valor
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.title or "Slider"
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.TextColor3 = defaultProperties.TextColor
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(config.default or config.min or 0)
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.TextColor3 = defaultProperties.TextColor
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Parent = sliderFrame

    -- Barra do slider
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0.6, 0)
    track.BackgroundColor3 = defaultProperties.SliderColor
    track.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = self.lib._primaryColor
    fill.Parent = track

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 15, 0, 15)
    button.Position = UDim2.new(0, 0, 0.5, -7)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = ""
    button.Parent = track

    -- Lógica do slider
    local min = config.min or 0
    local max = config.max or 100
    local defaultValue = math.clamp(config.default or min, min, max)
    local currentValue = defaultValue

    local function updateSlider(value)
        currentValue = math.floor(value)
        valueLabel.Text = tostring(currentValue)
        
        local percent = (currentValue - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        button.Position = UDim2.new(percent, -7, 0.5, -7)
        
        if config.callback then
            config.callback(currentValue)
        end
    end

    -- Eventos de arrasto
    local dragging = false
    local function updateValueFromMouse()
        local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
        local absolutePos = track.AbsolutePosition.X
        local absoluteSize = track.AbsoluteSize.X
        
        local percent = math.clamp((mousePos - absolutePos) / absoluteSize, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        
        updateSlider(value)
    end

    button.MouseButton1Down:Connect(function()
        dragging = true
        updateValueFromMouse()
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if dragging then
            updateValueFromMouse()
        end
    end)

    -- Valor inicial
    updateSlider(defaultValue)

    table.insert(self.elements, sliderFrame)
    return self
end

-- Métodos da biblioteca principal
function Library.new()
    local self = setmetatable({}, Library)
    self._tabs = {}
    self._parent = nil
    return self
end

function Library:create(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.3, 0, 0, 450)
    mainFrame.Position = UDim2.new(0.35, 0, 0.5, -225)
    mainFrame.BackgroundColor3 = config.color or defaultProperties.BackgroundColor
    mainFrame.Parent = screenGui

    self._parent = mainFrame
    self._primaryColor = config.color or defaultProperties.PrimaryColor
    return self
end

function Library:newtab(config)
    -- Cria container de abas se não existir
    if not self.tabContainer then
        self.tabContainer = Instance.new("Frame")
        self.tabContainer.Size = UDim2.new(1, 0, 0, 40)
        self.tabContainer.BackgroundTransparency = 1
        self.tabContainer.Parent = self._parent
    end

    -- Cria botão da aba
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.2, -5, 0.8, 0)
    tabButton.Position = UDim2.new(0.2 * #self._tabs, 5, 0.1, 0)
    tabButton.Text = config.name
    tabButton.BackgroundColor3 = defaultProperties.BackgroundColor
    tabButton.TextColor3 = defaultProperties.TextColor
    tabButton.Parent = self.tabContainer

    -- Cria conteúdo da aba
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, -50)
    tabContent.Position = UDim2.new(0, 0, 0, 40)
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 5
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = self._parent

    -- Cria objeto da aba
    local newTab = setmetatable({
        id = config.id,
        elements = {},
        content = tabContent,
        lib = self
    }, Tab)

    -- Configura clique na aba
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self._tabs) do
            tab.content.Visible = false
        end
        newTab.content.Visible = true
    end)

    -- Ativa primeira aba
    if #self._tabs == 0 then
        newTab.content.Visible = true
    end

    self._tabs[config.id] = newTab
    return newTab
end

return function()
    return Library.new()
end
