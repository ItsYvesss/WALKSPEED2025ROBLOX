-- This is a LocalScript. Place it in StarterGui or StarterPlayerScripts for it to run on the client.
-- WARNING: This script includes an exploit-like feature (speed hack) that can disrupt gameplay and violate Roblox's Terms of Service.
-- Use ONLY for personal testing in private environments (e.g., your own game in Roblox Studio). Do not use in public games, as it may lead to bans.
-- If you're a developer, implement speed mechanics server-side for security and fairness.

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHackGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the main frame (magnificent UI, draggable by default)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true  -- Starts draggable
frame.Parent = screenGui

-- Add a gradient for a "magnificent" look
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
}
gradient.Rotation = 45
gradient.Parent = frame

-- Add corner radius
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Speed Hack GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.Fantasy
title.Parent = frame

-- Speed input TextBox
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.8, 0, 0.2, 0)
speedBox.Position = UDim2.new(0.1, 0, 0.25, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.BackgroundTransparency = 0.3
speedBox.Text = "Enter Speed (e.g., 50)"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextScaled = true
speedBox.Font = Enum.Font.SourceSans
speedBox.ClearTextOnFocus = true
speedBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = speedBox

-- Set button
local setButton = Instance.new("TextButton")
setButton.Size = UDim2.new(0.8, 0, 0.2, 0)
setButton.Position = UDim2.new(0.1, 0, 0.5, 0)
setButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
setButton.BackgroundTransparency = 0.3
setButton.Text = "Set Speed"
setButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setButton.TextScaled = true
setButton.Font = Enum.Font.SourceSansBold
setButton.Parent = frame

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0, 8)
setCorner.Parent = setButton

-- Anchor button (toggles draggability)
local anchorButton = Instance.new("TextButton")
anchorButton.Size = UDim2.new(0.8, 0, 0.15, 0)
anchorButton.Position = UDim2.new(0.1, 0, 0.75, 0)
anchorButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
anchorButton.BackgroundTransparency = 0.3
anchorButton.Text = "Anchor (Draggable: On)"
anchorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
anchorButton.TextScaled = true
anchorButton.Font = Enum.Font.SourceSansBold
anchorButton.Parent = frame

local anchorCorner = Instance.new("UICorner")
anchorCorner.CornerRadius = UDim.new(0, 8)
anchorCorner.Parent = anchorButton

-- Function to play click sound
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://3359534883"  -- Provided sound ID
    sound.Volume = 0.5
    sound.Parent = soundService
    sound:Play()
    sound.Ended:Wait()
    sound:Destroy()
end

-- Hover effect for buttons (expands outside GUI bounds)
local function setupHoverEffect(button)
    local originalSize = button.Size
    local expandedSize = UDim2.new(originalSize.X.Scale + 0.2, originalSize.X.Offset, originalSize.Y.Scale + 0.2, originalSize.Y.Offset)  -- Expands beyond frame
    
    button.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = tweenService:Create(button, tweenInfo, {Size = expandedSize})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = tweenService:Create(button, tweenInfo, {Size = originalSize})
        tween:Play()
    end)
end

-- Apply hover effects to buttons
setupHoverEffect(setButton)
setupHoverEffect(anchorButton)

-- Set button functionality
setButton.MouseButton1Click:Connect(function()
    playClickSound()
    local speed = tonumber(speedBox.Text)
    if speed and speed > 0 then
        humanoid.WalkSpeed = speed
        speedBox.Text = "Speed set to " .. speed
        wait(2)
        speedBox.Text = "Enter Speed (e.g., 50)"
    else
        speedBox.Text = "Invalid speed!"
        wait(2)
        speedBox.Text = "Enter Speed (e.g., 50)"
    end
end)

-- Anchor button functionality
local isAnchored = false
anchorButton.MouseButton1Click:Connect(function()
    playClickSound()
    isAnchored = not isAnchored
    frame.Draggable = not isAnchored
    anchorButton.Text = isAnchored and "Unanchor (Draggable: Off)" or "Anchor (Draggable: On)"
end)

-- Handle character respawn (reset speed if needed, but keep GUI)
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    -- Optionally reset speed to default on respawn, but for hack purposes, keep it
end)
