local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Pegando o nome do time
local team = player.Team
if not team then
    warn("Jogador não está em nenhum time!")
    return
end
local teamName = team.Name

-- Pasta do Tycoon
local tycoonsFolder = Workspace:WaitForChild("Tycoons")
local teamFolder = tycoonsFolder:FindFirstChild(teamName)
if not teamFolder then
    warn("Não encontrou a pasta do time dentro de Tycoons!")
    return
end

local buttonsFolder = teamFolder:WaitForChild("Buttons")

-- Criando GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "AutoBuyGui"

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 1, -70)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "AutoBuy: OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.BorderSizePixel = 0
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Noclip
local noclip = true
RunService.Stepped:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then
                v.CanCollide = false
            end
        end
    end
end)

-- Função de voar até o botão
local autoBuyEnabled = false
local moving = false

local function flyTo(targetPos)
    moving = true
    local speed = 100 -- Velocidade
    while moving and (hrp.Position - targetPos).Magnitude > 5 do
        local direction = (targetPos - hrp.Position).Unit
        hrp.CFrame = hrp.CFrame + direction * speed * RunService.Heartbeat:Wait()
    end
    moving = false
end

local function autoBuy()
    while autoBuyEnabled do
        pcall(function()
            local stats = player:WaitForChild("leaderstats")
            local money = stats:WaitForChild("Money").Value
            local prestige = stats:WaitForChild("Prestige").Value

            for _, item in pairs(buttonsFolder:GetDescendants()) do
                if item:IsA("BasePart") or item:IsA("Part") or item:IsA("MeshPart") then
                    local cost = item:GetAttribute("Cost") or (item:FindFirstChild("Cost") and item.Cost.Value) or 0
                    local prestigeNeeded = item:GetAttribute("PrestigeNeeded") or 0

                    local canBuy = true

                    if cost > 0 and money < cost then
                        canBuy = false
                    end

                    if prestigeNeeded > 0 and prestige < prestigeNeeded then
                        canBuy = false
                    end

                    if canBuy then
                        flyTo(item.Position)
                        task.wait(0.3)
                    end
                end
            end
        end)
        task.wait(1)
    end
end

-- Toggle
ToggleButton.MouseButton1Click:Connect(function()
    autoBuyEnabled = not autoBuyEnabled

    if autoBuyEnabled then
        ToggleButton.Text = "AutoBuy: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        task.spawn(autoBuy)
    else
        ToggleButton.Text = "AutoBuy: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        moving = false
    end
end)
