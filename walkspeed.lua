local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 130)
Frame.Position = UDim2.new(0.5, -125, 0.4, -65)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.ClipsDescendants = true
Frame.Visible = true
Frame.Name = "MainFrame"
Frame:TweenSize(UDim2.new(0, 250, 0, 130), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1, 0, 0.4, 0)
Label.Position = UDim2.new(0, 0, 0, 0)
Label.BackgroundTransparency = 1
Label.Text = "WALKSPEED"
Label.Font = Enum.Font.GothamBlack
Label.TextSize = 24
Label.TextColor3 = Color3.fromRGB(255, 255, 255)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(0.8, 0, 0.3, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.55, 0)
TextBox.PlaceholderText = "Enter a number"
TextBox.Text = ""
TextBox.TextSize = 20
TextBox.Font = Enum.Font.Gotham
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local BoxCorner = Instance.new("UICorner", TextBox)
BoxCorner.CornerRadius = UDim.new(0, 8)

-- Function to change speed
TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local speed = tonumber(TextBox.Text)
		if speed and character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = speed
		end
	end
end)
