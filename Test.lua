-- Biblioteca.lua
local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

-- Configurações padrão
local defaultProperties = {
    PrimaryColor = Color3.fromRGB(0, 120, 215),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubtextColor = Color3.fromRGB(200, 200, 200),
    SubtextSize = 14,
    Transparency = 0.2,
    CornerRadius = UDim.new(0, 6),
    DragAreaHeight = 30,
    TabHeight = 35,
    TabSpacing = 5
}

-- Função para criar cantos arredondados
local function applyUICorner(instance)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = defaultProperties.CornerRadius
    corner.Parent = instance
end

-- Sistema de arrasto
local function makeDraggable(frame, dragArea)
    local dragging = false
    local dragInput, dragStart, startPos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Métodos da aba
function Tab:AddToggle(config)
    local elementCount = #self.elements
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
    toggleFrame.Position = UDim2.new(0.025, 0, 0, elementCount * 50)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.content

    -- Container do toggle
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(1, 0, 1, 0)
    toggleContainer.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleContainer.BackgroundTransparency = 0.9
    applyUICorner(toggleContainer)
    toggleContainer.Parent = toggleFrame

    -- Título e subtexto
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(0.7, 0, 1, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = toggleContainer

    local label = Instance.new("TextLabel")
    label.Text = config.title or "Toggle"
    label.Size = UDim2.new(1, 0, 0.6, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextColor3 = defaultProperties.TextColor
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.Parent = textContainer

    if config.subtext then
        local subtextLabel = Instance.new("TextLabel")
        subtextLabel.Text = config.subtext
        subtextLabel.Size = UDim2.new(1, 0, 0.4, 0)
        subtextLabel.Position = UDim2.new(0, 5, 0.6, 0)
        subtextLabel.TextColor3 = defaultProperties.SubtextColor
        subtextLabel.TextSize = defaultProperties.SubtextSize
        subtextLabel.Font = Enum.Font.Gotham
        subtextLabel.BackgroundTransparency = 1
        subtextLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtextLabel.Parent = textContainer
    end

    -- Botão do toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 0.7, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = defaultProperties.PrimaryColor
    toggleButton.AutoButtonColor = false
    applyUICorner(toggleButton)
    toggleButton.Parent = toggleContainer

    -- Estado inicial
    local isToggled = not not config.default
    toggleButton.BackgroundTransparency = isToggled and 0 or 0.8

    -- Animação do toggle
    local function updateToggle()
        isToggled = not isToggled
        game:GetService("TweenService"):Create(
            toggleButton,
            TweenInfo.new(0.2),
            {BackgroundTransparency = isToggled and 0 or 0.8}
        ):Play()
        
        if config.callback then
            config.callback(isToggled)
        end
    end

    toggleButton.MouseButton1Click:Connect(updateToggle)

    table.insert(self.elements, toggleFrame)
    return self
end

-- Métodos da biblioteca principal
function Library.new()
    local self = setmetatable({}, Library)
    self._tabs = {}
    self._currentTab = nil
    return self
end

function Library:create(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Container principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.3, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = defaultProperties.BackgroundColor
    mainFrame.BackgroundTransparency = defaultProperties.Transparency
    applyUICorner(mainFrame)
    mainFrame.Parent = screenGui

    -- Área de arrasto
    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, 0, 0, defaultProperties.DragAreaHeight)
    dragArea.BackgroundTransparency = 1
    dragArea.Parent = mainFrame
    makeDraggable(mainFrame, dragArea)

    -- Container de abas (lateral esquerda)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0.25, 0, 1, -defaultProperties.DragAreaHeight)
    tabContainer.Position = UDim2.new(0, 0, 0, defaultProperties.DragAreaHeight)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    -- Container de conteúdo (lateral direita)
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(0.75, 0, 1, -defaultProperties.DragAreaHeight)
    contentContainer.Position = UDim2.new(0.25, 0, 0, defaultProperties.DragAreaHeight)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    self._parent = mainFrame
    self._tabContainer = tabContainer
    self._contentContainer = contentContainer
    self._primaryColor = config.color or defaultProperties.PrimaryColor
    return self
end

function Library:newtab(config)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.9, 0, 0, defaultProperties.TabHeight)
    tabButton.Position = UDim2.new(0.05, 0, 0, #self._tabs * (defaultProperties.TabHeight + defaultProperties.TabSpacing))
    tabButton.Text = config.name
    tabButton.BackgroundColor3 = Color3.new(1, 1, 1)
    tabButton.BackgroundTransparency = 0.9
    tabButton.TextColor3 = defaultProperties.TextColor
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 14
    applyUICorner(tabButton)
    tabButton.Parent = self._tabContainer

    -- Conteúdo da aba
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, -10)
    tabContent.Position = UDim2.new(0, 0, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.Parent = self._contentContainer

    local newTab = setmetatable({
        id = config.id,
        elements = {},
        content = tabContent,
        lib = self
    }, Tab)

    -- Evento de clique na aba
    tabButton.MouseButton1Click:Connect(function()
        if self._currentTab then
            self._currentTab.content.Visible = false
        end
        newTab.content.Visible = true
        self._currentTab = newTab
    end)

    -- Ativar primeira aba
    if #self._tabs == 0 then
        newTab.content.Visible = true
        self._currentTab = newTab
    end

    self._tabs[config.id] = newTab
    return newTab
end

return function()
    return Library.new()
end
