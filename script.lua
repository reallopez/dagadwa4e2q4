local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local balloonContainer = workspace:WaitForChild("BalloonContainer")

local activated = false

-- Teleporta para uma posição
local function teleportToPosition(position)
    humanoidRootPart.CFrame = CFrame.new(position.X, position.Y + 3, position.Z)
end

local function activate()
    while activated do
        local balloons = {}
        for _, obj in pairs(balloonContainer:GetChildren()) do
            if obj.Name == "BaseBalloon" and obj:IsA("BasePart") then
                table.insert(balloons, obj)
            end
        end
        
        if #balloons == 0 then
            wait(2)
        else
            for _, balloon in ipairs(balloons) do
                if not activated then break end
                
                if balloon and balloon.Parent then
                    -- Salva posição atual
                    local originalPos = humanoidRootPart.Position

                    -- Teleporta para o balloon
                    teleportToPosition(balloon.Position)
                    wait(0.5) -- espera meio segundo só pra garantir

                    -- Fica teleportando no balloon a cada 1 segundo até sumir
                    while balloon and balloon.Parent and activated do
                        teleportToPosition(balloon.Position)
                        wait(1)
                    end

                    -- Volta para a posição original depois de pegar o balloon
                    if activated then
                        teleportToPosition(originalPos)
                        wait(1) -- delay antes do próximo balloon
                    end
                end
            end
        end
        
        wait(0.5)
    end
end

-- Criar UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BalloonActivatorGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.13, 20, 1, -150)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Ativar"
toggleButton.Parent = ScreenGui

toggleButton.MouseButton1Click:Connect(function()
    activated = not activated
    if activated then
        toggleButton.Text = "Desativar"
        coroutine.wrap(activate)()
    else
        toggleButton.Text = "Ativar"
    end
end)
