local Library = {}
Library.__index = Library

local Tab = {}
Tab.__index = Tab

local defaultProperties = {
    PrimaryColor = Color3.fromRGB(0, 170, 127),
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(180, 180, 180) -- Cor mais escura para o subtítulo
}

-- Métodos da aba
function Tab:AddToggle(config)
    local elementCount = #self.elements

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
    toggleFrame.Position = UDim2.new(0.05, 0, 0, elementCount * 45)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.content

    local label = Instance.new("TextLabel")
    label.Text = config.title or "Toggle"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextColor3 = defaultProperties.TextColor
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0.1, 0)
    toggleButton.Text = "Off"
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.Parent = toggleFrame

    local isToggled = false
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.Text = isToggled and "On" or "Off"
        toggleButton.BackgroundColor3 = isToggled and self.lib._primaryColor or Color3.fromRGB(80, 80, 80)
        
        if config.callback then
            config.callback(isToggled)
        end
    end)

    table.insert(self.elements, toggleFrame)
    return self
end

function Tab:AddButton(config)
    local elementCount = #self.elements

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.9, 0, 0, 40)
    buttonFrame.Position = UDim2.new(0.05, 0, 0, elementCount * 45)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = self.content

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = config.title or "Button"
    button.BackgroundColor3 = self.lib._primaryColor
    button.TextColor3 = defaultProperties.TextColor
    button.Parent = buttonFrame

    button.MouseButton1Click:Connect(function()
        if config.callback then
            config.callback()
        end
    end)

    table.insert(self.elements, buttonFrame)
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

    -- **Título Principal**
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.text or "Título"
    titleLabel.Size = UDim2.new(0, 150, 0, 30)
    titleLabel.Position = UDim2.new(0.02, 0, 0.02, 0)
    titleLabel.TextColor3 = defaultProperties.TextColor
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = mainFrame

    -- **Subtítulo**
    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Text = config.subtext or "Subtítulo"
    subTitleLabel.Size = UDim2.new(0, 150, 0, 25)
    subTitleLabel.Position = UDim2.new(0, titleLabel.Position.X.Offset + titleLabel.Size.X.Offset + 10, 0.025, 0)
    subTitleLabel.TextColor3 = defaultProperties.SubTextColor
    subTitleLabel.TextSize = 16
    subTitleLabel.Font = Enum.Font.Gotham
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Parent = mainFrame

    self._parent = mainFrame
    self._primaryColor = config.color or defaultProperties.PrimaryColor
    return self
end

function Library:newtab(config)
    if not self.tabContainer then
        self.tabContainer = Instance.new("Frame")
        self.tabContainer.Size = UDim2.new(1, 0, 0, 40)
        self.tabContainer.BackgroundTransparency = 1
        self.tabContainer.Parent = self._parent
    end

    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.2, -5, 0.8, 0)
    tabButton.Position = UDim2.new(0.2 * #self._tabs, 5, 0.1, 0)
    tabButton.Text = config.name
    tabButton.BackgroundColor3 = defaultProperties.BackgroundColor
    tabButton.TextColor3 = defaultProperties.TextColor
    tabButton.Parent = self.tabContainer

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, -50)
    tabContent.Position = UDim2.new(0, 0, 0, 40)
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 5
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = self._parent

    local newTab = setmetatable({
        id = config.id,
        elements = {},
        content = tabContent,
        lib = self
    }, Tab)

    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self._tabs) do
            tab.content.Visible = false
        end
        newTab.content.Visible = true
    end)

    if #self._tabs == 0 then
        newTab.content.Visible = true
    end

    self._tabs[config.id] = newTab
    return newTab
end

return function()
    return Library.new()
end
