local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoInserirGui"
screenGui.Parent = playerGui

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 150, 0, 50)
autoBtn.Position = UDim2.new(0.13, 20, 1, -70)
autoBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 22
autoBtn.Text = "Auto Inserir: OFF"
autoBtn.Parent = screenGui

local autoAtivo = false
local autoCoroutine

local function inserirFruta()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local team = player.Team and player.Team.Name
    if not team then
        warn("Você não está em nenhum time!")
        return
    end

    local tycoon = Workspace:FindFirstChild("Tycoons") and Workspace.Tycoons:FindFirstChild(team)
    if not tycoon then
        warn("Tycoon do time não encontrado")
        return
    end

    local addFruitButton = tycoon:FindFirstChild("Essentials")
        and tycoon.Essentials:FindFirstChild("JuiceMaker")
        and tycoon.Essentials.JuiceMaker:FindFirstChild("AddFruitButton")

    if not addFruitButton then
        warn("AddFruitButton não encontrado")
        return
    end

    local promptAttachment = addFruitButton:FindFirstChild("PromptAttachment")
    if not promptAttachment then
        warn("PromptAttachment não encontrado")
        return
    end

    local addPrompt = promptAttachment:FindFirstChild("AddPrompt")
    if not addPrompt or not addPrompt:IsA("ProximityPrompt") then
        warn("AddPrompt não encontrado ou não é ProximityPrompt")
        return
    end

    local originalCFrame = humanoidRootPart.CFrame

    local btnPos = addFruitButton.Position
    local targetPos = btnPos + Vector3.new(0, 3, -3)

    humanoidRootPart.CFrame = CFrame.new(targetPos, btnPos)

    wait(0.3)

    local triggered = false
    local connection
    connection = addPrompt.Triggered:Connect(function(playerWhoTriggered)
        if playerWhoTriggered == player then
            triggered = true
            connection:Disconnect()
        end
    end)

    addPrompt:InputHoldBegin()
    wait(0.3)
    addPrompt:InputHoldEnd()

    local timer = 0
    while not triggered and timer < 2 do
        wait(0.1)
        timer = timer + 0.1
    end

    if not triggered then
        warn("Não foi possível ativar o AddPrompt. Tente aproximar-se manualmente.")
    end

    wait(0.5)
    humanoidRootPart.CFrame = originalCFrame
end

autoBtn.MouseButton1Click:Connect(function()
    autoAtivo = not autoAtivo
    autoBtn.Text = autoAtivo and "Auto Inserir: ON" or "Auto Inserir: OFF"
    
    if autoAtivo then
        autoCoroutine = coroutine.create(function()
            while autoAtivo do
                inserirFruta()
                wait(10)
            end
        end)
        coroutine.resume(autoCoroutine)
    end
end)
