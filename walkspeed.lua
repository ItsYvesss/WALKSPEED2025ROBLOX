-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- === SETUP: RemoteEvent + Server handler ===
-- Create the RemoteEvent if it doesn't exist
local remote = ReplicatedStorage:FindFirstChild("SetSpeed")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "SetSpeed"
	remote.Parent = ReplicatedStorage
end

-- Only create server handler once and only on server
if RunService:IsClient() then
	-- Request server-side script creation
	remote:FireServer("INIT_SERVER_HANDLER")
else
	-- This code runs on server side only
	remote.OnServerEvent:Connect(function(player, data)
		-- Check if it's a normal speed update
		if type(data) == "number" and data >= 0 and data <= 1000 then
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.WalkSpeed = data
			end
		end
	end)
end

-- === CLIENT SIDE GUI ===
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
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
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Draggable
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
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

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
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

-- Set Button
local setButton = Instance.new("TextButton", mainFrame)
setButton.Size = UDim2.new(0.4, 0, 0, 30)
setButton.Position = UDim2.new(0.3, 0, 0.8, 0)
setButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
setButton.Text = "Set"
setButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setButton.Font = Enum.Font.Gotham
setButton.TextScaled = true
Instance.new("UICorner", setButton).CornerRadius = UDim.new(0, 6)

-- Fire speed change
local function setSpeed()
	local speed = tonumber(textBox.Text)
	if speed and speed > 0 and speed <= 1000 then
		remote:FireServer(speed)
	end
end

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		setSpeed()
	end
end)

setButton.MouseButton1Click:Connect(setSpeed)

-- Animate GUI in
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame:TweenSize(UDim2.new(0, 260, 0, 140), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)