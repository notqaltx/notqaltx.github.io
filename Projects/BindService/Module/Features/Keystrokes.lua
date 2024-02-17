local KeyStrokes = {}

local services = {
	ts = game:GetService("TweenService"),
	uis = game:GetService("UserInputService"),
	players = game:GetService("Players")
}
local activeKeyStrokes = {}

function KeyStrokes.CreateKeyStroke(key, frame)
	local keyStroke = Instance.new("TextLabel", frame)
	keyStroke.Name = "KeyStroke"
	keyStroke.Size = UDim2.fromScale(1, 0.032)
	keyStroke.BackgroundTransparency = 1
	keyStroke.BorderSizePixel = 0
	keyStroke.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyStroke.Font = Enum.Font.RobotoMono
	keyStroke.TextScaled = true
	keyStroke.Text = key
	keyStroke.TextXAlignment = Enum.TextXAlignment.Right

	return keyStroke
end
function KeyStrokes.FadeOut(keyStroke)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local fadeTween = services.ts:Create(keyStroke, tweenInfo, { TextTransparency = 1 })
	
	fadeTween:Play()
	fadeTween.Completed:Connect(function()
		keyStroke:Destroy()
	end)
end
function KeyStrokes.ListenForInput()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Keystrokes"
	screenGui.Parent = services.players.LocalPlayer.PlayerGui

	local frame = Instance.new("Frame", screenGui)
	frame.Name = "MainFrame"
	frame.BackgroundTransparency = 1
	frame.Position = UDim2.fromScale(0.86, 0.266)
	frame.Size = UDim2.fromScale(0.121, 0.699)

	local listLayout = Instance.new("UIListLayout", frame)
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local inputConnection = services.uis.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local key = input.KeyCode.Name
			local keyStroke = KeyStrokes.CreateKeyStroke(key, frame)
			table.insert(activeKeyStrokes, keyStroke)
			KeyStrokes.FadeOut(keyStroke)
		end
	end)
	return inputConnection
end
--function KeyStrokes.StopListening(inputConnection)
--	if inputConnection then
--		inputConnection:Disconnect()
--		for _, keyStroke in ipairs(activeKeyStrokes) do
--			keyStroke:Destroy()
--		end
--		services.players:FindFirstChild("Keystrokes"):Destroy()
--		activeKeyStrokes = {}
--	end
--end

return KeyStrokes