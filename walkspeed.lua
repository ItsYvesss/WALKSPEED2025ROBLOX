local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent and ServerScript if they don't exist
local remoteName = "SetSpeed"
if not ReplicatedStorage:FindFirstChild(remoteName) then
    local event = Instance.new("RemoteEvent")
    event.Name = remoteName
    event.Parent = ReplicatedStorage
end

if not ReplicatedStorage:FindFirstChild("SpeedHandler") then
    local serverScript = Instance.new("Script")
    serverScript.Name = "SpeedHandler"
    serverScript.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")

        local event = ReplicatedStorage:WaitForChild("SetSpeed")

        event.OnServerEvent:Connect(function(player, speed)
            if type(speed) == "number" and speed >= 0 and speed <= 1000 then
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = speed
                end
            end
        end)
    ]]
    serverScript.Parent = ReplicatedStorage
end

-- GUI Creation
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "WalkSpeedGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 140)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 8)

local drag = Instance.new("TextButton", mainFrame)
drag.Size = UDim2.new(1, 0, 0, 20)
drag.BackgroundTransparency = 1
drag.Text = ""

local UIS = game:GetService("UserInputService")
local dragging, offset

drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        offset = Vector2.new(input.Position.X - mainFrame.Position.X.Offset, input.Position.Y - mainFrame.Position.Y.Offset)
    end
end)

drag.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        mainFrame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
    end
end)

-- Toggle Button
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.15, -35)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Open"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local toggleUICorner = Instance.new("UICorner", toggleButton)
toggleUICorner.CornerRadius = UDim.new(0, 6)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "Close" or "Open"
end)

-- Label
local label = Instance.new("TextLabel", mainFrame)
label.Size = UDim2.new(1, 0, 0, 40)
label.BackgroundTransparency = 1
label.Text = "WALKSPEED"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextScaled = true

-- TextBox
local textBox = Instance.new("TextBox", mainFrame)
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0.5, 0)
textBox.PlaceholderText = "Enter a number"
textBox.Text = ""
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Font = Enum.Font.Gotham

local textCorner = Instance.new("UICorner", textBox)
textCorner.CornerRadius = UDim.new(0, 6)

-- Set Button
local setButton = Instance.new("TextButton", mainFrame)
setButton.Size = UDim2.new(0.4, 0, 0, 30)
setButton.Position = UDim2.new(0.3, 0, 0.8, 0)
setButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
setButton.Text = "Set"
setButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setButton.Font = Enum.Font.Gotham
setButton.TextScaled = true

local setButtonCorner = Instance.new("UICorner", setButton)
setButtonCorner.CornerRadius = UDim.new(0, 6)

-- Submit on Focus Lost
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local speed = tonumber(textBox.Text)
        if speed and speed > 0 and speed < 1000 then
            ReplicatedStorage:WaitForChild("SetSpeed"):FireServer(speed)
        end
    end
end)

-- Submit on Set Button Click
setButton.MouseButton1Click:Connect(function()
    local speed = tonumber(textBox.Text)
    if speed and speed > 0 and speed < 1000 then
        ReplicatedStorage:WaitForChild("SetSpeed"):FireServer(speed)
    end
end)

-- Entrance animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame:TweenSize(UDim2.new(0, 260, 0, 140), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)