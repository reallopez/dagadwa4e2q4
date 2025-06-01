-- Criando a UI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ShakeUI"

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 1, -150)
button.Text = "Shake"
button.Parent = screenGui
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 24
button.BorderSizePixel = 0
button.BackgroundTransparency = 0.1
button.Active = true

-- Função do botão
-- Função do botão
button.MouseButton1Click:Connect(function()
    local team = player.Team
    if not team then
        warn("Jogador não está em nenhum time!")
        return
    end

    local tycoon = workspace:FindFirstChild("Tycoons"):FindFirstChild(team.Name)
    if not tycoon then
        warn("Tycoon do time não encontrado!")
        return
    end

    local purchases = tycoon:FindFirstChild("Purchases")
    if not purchases then
        warn("Pasta Purchases não encontrada!")
        return
    end

    -- Aqui pega todas as pastas que contenham "Plants" no nome
    local plantsFolders = {}
    for _, folder in ipairs(purchases:GetChildren()) do
        if folder:IsA("Folder") and string.find(folder.Name, "Plants") then
            table.insert(plantsFolders, folder)
        end
    end

    if #plantsFolders == 0 then
        warn("Nenhuma pasta com 'Plants' encontrada!")
        return
    end

    -- Para cada pasta com "Plants", teleportar para cada item
    for _, plants in ipairs(plantsFolders) do
        for _, item in ipairs(plants:GetChildren()) do
            if item:IsA("BasePart") then
                player.Character:WaitForChild("HumanoidRootPart").CFrame = item.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.5)
            elseif item:IsA("Model") then
                local primary = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                if primary then
                    player.Character:WaitForChild("HumanoidRootPart").CFrame = primary.CFrame + Vector3.new(0, 5, 0)
                    task.wait(0.5)
                end
            end
        end
    end

    print("Finalizado!")
end)

