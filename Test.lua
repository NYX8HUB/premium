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
    Transparency = 0.2,
    CornerRadius = UDim.new(0, 6),
    TabHeight = 35,
    TabSpacing = 5
}

-- Função para criar cantos arredondados
local function applyUICorner(instance)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = defaultProperties.CornerRadius
    corner.Parent = instance
end

-- Sistema de abas
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

    -- Container de abas (lateral esquerda)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0.25, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    -- Container de conteúdo (lateral direita)
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(0.75, 0, 1, 0)
    contentContainer.Position = UDim2.new(0.25, 0, 0, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

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
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 5
    tabContent.Visible = false
    tabContent.Parent = self._contentContainer

    local newTab = setmetatable({
        id = config.id,
        content = tabContent,
        button = tabButton
    }, Tab)

    -- Evento de clique na aba
    tabButton.MouseButton1Click:Connect(function()
        -- Esconde todas as abas
        for _, tab in pairs(self._tabs) do
            tab.content.Visible = false
            tab.button.BackgroundTransparency = 0.9
        end
        
        -- Mostra apenas a aba clicada
        newTab.content.Visible = true
        tabButton.BackgroundTransparency = 0.7
    end)

    -- Ativa primeira aba
    if #self._tabs == 0 then
        newTab.content.Visible = true
        tabButton.BackgroundTransparency = 0.7
    end

    table.insert(self._tabs, newTab)
    return newTab
end

-- Métodos dos elementos
function Tab:AddToggle(config)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
    toggleFrame.Position = UDim2.new(0.025, 0, 0, #self.content:GetChildren() * 50)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = self.content

    -- (Manter o restante do código do toggle igual à versão anterior)
    -- ... [código do toggle aqui] ...

    return self
end

return function()
    return Library.new()
end
