-- UI
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "ObbyAutoFarmGui"

Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 250, 0, 50)
Button.Position = UDim2.new(0.13, 20, 1, -230)
Button.Text = "Ativar Farm Obby"
Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.BorderSizePixel = 0
Button.AutoButtonColor = true

-- Variáveis
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local stats = player:WaitForChild("Stats")
local obbyParts = workspace:WaitForChild("ObbyParts")
local startPart = obbyParts:WaitForChild("RealObbyStartPart")
local victoryPart = obbyParts:WaitForChild("Stages"):WaitForChild("Hard"):WaitForChild("VictoryPart")

local ativo = false -- Controle de toggle

-- Função para verificar cooldown
local function temCooldown()
    return stats:GetAttribute("Multiply_Multiplier_ObbyCooldown") ~= nil
end

-- Função principal de farm
local function iniciarFarm()
    while ativo do
        if not temCooldown() then
            -- Teleporta para o start
            hrp.CFrame = startPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(1) -- espera 1 segundo

            -- Teleporta para o victory
            hrp.CFrame = victoryPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(1) -- espera 1 segundo

        else
            -- Está em cooldown, espera e verifica de novo
            Button.Text = "Em cooldown... (Aguardando)"
            repeat
                task.wait(1)
            until not temCooldown() or not ativo
        end
        task.wait(0.5) -- Delay pequeno antes de repetir
    end
end

-- Toggle no botão
Button.MouseButton1Click:Connect(function()
    ativo = not ativo
    if ativo then
        Button.Text = "Farm Ativado (Clique para parar)"
        task.spawn(iniciarFarm)
    else
        Button.Text = "Ativar Farm Obby"
    end
end)
