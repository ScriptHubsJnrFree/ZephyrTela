--========================================================
-- ZEPHYR HUB | MOVIMIENTO + NOCLIP + FLY + TROMPO CURVA
-- LOCAL SCRIPT - VERSION COMPACTA
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

--========================================================
-- CONFIGURACION
--========================================================

local MovementEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local TrompoEnabled = false

local BoostSpeed = 40
local TrompoSpeed = 50

local FlySpeed = 50
local MinFlySpeed = 16
local MaxFlySpeed = 1000

-- Controles Fly
local MovingForward = false
local MovingBack = false
local MovingLeft = false
local MovingRight = false
local MovingUp = false
local MovingDown = false

-- Personaje
local Character
local Humanoid
local RootPart

-- Fly
local FlyAttachment
local FlyPosition
local FlyOrientation

-- GUIs
local ScreenGui, FlyControls, VerticalControls

--========================================================
-- FLY
--========================================================

local function DisableFly()
	if FlyPosition then
		FlyPosition:Destroy()
		FlyPosition = nil
	end

	if FlyOrientation then
		FlyOrientation:Destroy()
		FlyOrientation = nil
	end

	if FlyAttachment then
		FlyAttachment:Destroy()
		FlyAttachment = nil
	end

	if RootPart then
		RootPart.AssemblyLinearVelocity = Vector3.zero
		RootPart.AssemblyAngularVelocity = Vector3.zero
	end
end

local function EnableFly()
	if not RootPart then
		return
	end

	DisableFly()

	FlyAttachment = Instance.new("Attachment")
	FlyAttachment.Parent = RootPart

	FlyPosition = Instance.new("AlignPosition")
	FlyPosition.Attachment0 = FlyAttachment
	FlyPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	FlyPosition.Position = RootPart.Position
	FlyPosition.MaxForce = 1000000
	FlyPosition.Responsiveness = 200
	FlyPosition.Parent = RootPart

	FlyOrientation = Instance.new("AlignOrientation")
	FlyOrientation.Attachment0 = FlyAttachment
	FlyOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	FlyOrientation.CFrame = RootPart.CFrame
	FlyOrientation.MaxTorque = 1000000
	FlyOrientation.Responsiveness = 200
	FlyOrientation.Parent = RootPart
end

--========================================================
-- RECONECTAR AL REAPARECER
--========================================================

local function OnCharacterAdded(NewCharacter)
	Character = NewCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")

	MovingForward = false
	MovingBack = false
	MovingLeft = false
	MovingRight = false
	MovingUp = false
	MovingDown = false

	if FlyEnabled then
		task.wait(0.1)
		EnableFly()

		if FlyControls then
			FlyControls.Visible = true
		end

		if VerticalControls then
			VerticalControls.Visible = true
		end
	end

	if TrompoEnabled then
		task.wait(0.1)
		Humanoid.AutoRotate = false
	end
end

Player.CharacterAdded:Connect(OnCharacterAdded)

if Player.Character then
	OnCharacterAdded(Player.Character)
end

--========================================================
-- GUI
--========================================================

local PlayerGui = Player:WaitForChild("PlayerGui")

local OldGui = PlayerGui:FindFirstChild("ZephyrHub")
if OldGui then
	OldGui:Destroy()
end

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZephyrHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- PANEL
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 250, 0, 440)
Main.Position = UDim2.new(0.5, -125, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

--========================================================
-- TITULO
--========================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -42, 0, 38)
Title.Position = UDim2.new(0, 7, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZEPHYR HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

--========================================================
-- MINIMIZAR
--========================================================

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 34, 0, 34)
Minimize.Position = UDim2.new(1, -38, 0, 2)
Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Main

Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 7)

--========================================================
-- SCROLL
--========================================================

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -8, 1, -48)
Scroll.Position = UDim2.new(0, 4, 0, 43)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 610)
Scroll.Parent = Main

--========================================================
-- CREAR BOTON COMPACTO
--========================================================

local function CreateButton(Name, Text, Y)
	local Button = Instance.new("TextButton")

	Button.Name = Name
	Button.Size = UDim2.new(1, -20, 0, 38)
	Button.Position = UDim2.new(0, 10, 0, Y)

	Button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	Button.BorderSizePixel = 0

	Button.Text = Text
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextSize = 12
	Button.Font = Enum.Font.GothamBold

	Button.Parent = Scroll

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

	return Button
end

--========================================================
-- VELOCIDAD BOOST
--========================================================

local BoostLabel = Instance.new("TextLabel")
BoostLabel.Size = UDim2.new(0, 125, 0, 30)
BoostLabel.Position = UDim2.new(0, 10, 0, 5)
BoostLabel.BackgroundTransparency = 1
BoostLabel.Text = "VELOCIDAD BOOST:"
BoostLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostLabel.TextSize = 11
BoostLabel.Font = Enum.Font.GothamBold
BoostLabel.TextXAlignment = Enum.TextXAlignment.Left
BoostLabel.Parent = Scroll

local BoostBox = Instance.new("TextBox")
BoostBox.Size = UDim2.new(0, 75, 0, 28)
BoostBox.Position = UDim2.new(1, -85, 0, 6)
BoostBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
BoostBox.Text = tostring(BoostSpeed)
BoostBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostBox.TextSize = 12
BoostBox.Font = Enum.Font.GothamBold
BoostBox.ClearTextOnFocus = false
BoostBox.Parent = Scroll

Instance.new("UICorner", BoostBox).CornerRadius = UDim.new(0, 6)

BoostBox.FocusLost:Connect(function()
	local Number = tonumber(BoostBox.Text)

	if Number then
		BoostSpeed = math.clamp(Number, 16, 1000)
	end

	BoostBox.Text = tostring(BoostSpeed)
end)

--========================================================
-- BOTONES
--========================================================

local MovementButton = CreateButton(
	"MovementButton",
	"MOVIMIENTO: DESACTIVADO",
	45
)

local NoclipButton = CreateButton(
	"NoclipButton",
	"NOCLIP: DESACTIVADO",
	90
)

--========================================================
-- TROMPO
--========================================================

local TrompoLabel = Instance.new("TextLabel")
TrompoLabel.Size = UDim2.new(0, 130, 0, 30)
TrompoLabel.Position = UDim2.new(0, 10, 0, 140)
TrompoLabel.BackgroundTransparency = 1
TrompoLabel.Text = "VELOCIDAD TROMPO:"
TrompoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TrompoLabel.TextSize = 11
TrompoLabel.Font = Enum.Font.GothamBold
TrompoLabel.TextXAlignment = Enum.TextXAlignment.Left
TrompoLabel.Parent = Scroll

local TrompoFrame = Instance.new("Frame")
TrompoFrame.Size = UDim2.new(0, 85, 0, 28)
TrompoFrame.Position = UDim2.new(1, -95, 0, 141)
TrompoFrame.BackgroundTransparency = 1
TrompoFrame.Parent = Scroll

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 27, 0, 28)
MinusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.new(1, 1, 1)
MinusBtn.TextSize = 17
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = TrompoFrame

Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

local TrompoBox = Instance.new("TextBox")
TrompoBox.Size = UDim2.new(0, 31, 0, 28)
TrompoBox.Position = UDim2.new(0, 27, 0, 0)
TrompoBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TrompoBox.Text = tostring(TrompoSpeed)
TrompoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TrompoBox.TextSize = 11
TrompoBox.Font = Enum.Font.GothamBold
TrompoBox.ClearTextOnFocus = false
TrompoBox.Parent = TrompoFrame

Instance.new("UICorner", TrompoBox).CornerRadius = UDim.new(0, 6)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 27, 0, 28)
PlusBtn.Position = UDim2.new(0, 58, 0, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.new(1, 1, 1)
PlusBtn.TextSize = 17
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = TrompoFrame

Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

MinusBtn.MouseButton1Click:Connect(function()
	TrompoSpeed = math.clamp(TrompoSpeed - 5, 5, 100)
	TrompoBox.Text = tostring(TrompoSpeed)
end)

PlusBtn.MouseButton1Click:Connect(function()
	TrompoSpeed = math.clamp(TrompoSpeed + 5, 5, 100)
	TrompoBox.Text = tostring(TrompoSpeed)
end)

TrompoBox.FocusLost:Connect(function()
	local Num = tonumber(TrompoBox.Text)

	if Num then
		TrompoSpeed = math.clamp(Num, 5, 100)
	end

	TrompoBox.Text = tostring(TrompoSpeed)
end)

local TrompoButton = CreateButton(
	"TrompoButton",
	"TROMPO: DESACTIVADO",
	180
)

--========================================================
-- FLY
--========================================================

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(0, 120, 0, 30)
FlyLabel.Position = UDim2.new(0, 10, 0, 230)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "VELOCIDAD FLY:"
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.TextSize = 11
FlyLabel.Font = Enum.Font.GothamBold
FlyLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyLabel.Parent = Scroll

local FlyBox = Instance.new("TextBox")
FlyBox.Size = UDim2.new(0, 75, 0, 28)
FlyBox.Position = UDim2.new(1, -85, 0, 231)
FlyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FlyBox.Text = tostring(FlySpeed)
FlyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBox.TextSize = 12
FlyBox.Font = Enum.Font.GothamBold
FlyBox.ClearTextOnFocus = false
FlyBox.Parent = Scroll

Instance.new("UICorner", FlyBox).CornerRadius = UDim.new(0, 6)

FlyBox.FocusLost:Connect(function()
	local Number = tonumber(FlyBox.Text)

	if Number then
		FlySpeed = math.clamp(Number, MinFlySpeed, MaxFlySpeed)
	end

	FlyBox.Text = tostring(FlySpeed)
end)

local FlyButton = CreateButton(
	"FlyButton",
	"FLY: DESACTIVADO",
	270
)

--========================================================
-- CONTROLES FLY
--========================================================

FlyControls = Instance.new("Frame")
FlyControls.Name = "FlyControls"
FlyControls.Size = UDim2.new(0, 135, 0, 135)
FlyControls.Position = UDim2.new(0, 10, 1, -150)
FlyControls.BackgroundTransparency = 1
FlyControls.Visible = false
FlyControls.Parent = ScreenGui

VerticalControls = Instance.new("Frame")
VerticalControls.Name = "VerticalControls"
VerticalControls.Size = UDim2.new(0, 75, 0, 125)
VerticalControls.Position = UDim2.new(1, -85, 1, -145)
VerticalControls.BackgroundTransparency = 1
VerticalControls.Visible = false
VerticalControls.Parent = ScreenGui

local function CreateFlyControl(Text, Size, Position, Parent)
	local Button = Instance.new("TextButton")

	Button.Size = Size
	Button.Position = Position
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	Button.Text = Text
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.TextScaled = true
	Button.Parent = Parent

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 9)

	return Button
end

local ForwardButton = CreateFlyControl(
	"▲",
	UDim2.new(0, 45, 0, 45),
	UDim2.new(0, 45, 0, 0),
	FlyControls
)

local BackButton = CreateFlyControl(
	"▼",
	UDim2.new(0, 45, 0, 45),
	UDim2.new(0, 45, 0, 90),
	FlyControls
)

local LeftButton = CreateFlyControl(
	"◀",
	UDim2.new(0, 45, 0, 45),
	UDim2.new(0, 0, 0, 45),
	FlyControls
)

local RightButton = CreateFlyControl(
	"▶",
	UDim2.new(0, 45, 0, 45),
	UDim2.new(0, 90, 0, 45),
	FlyControls
)

local UpButton = CreateFlyControl(
	"SUBIR",
	UDim2.new(0, 75, 0, 55),
	UDim2.new(0, 0, 0, 0),
	VerticalControls
)

local DownButton = CreateFlyControl(
	"BAJAR",
	UDim2.new(0, 75, 0, 55),
	UDim2.new(0, 0, 0, 65),
	VerticalControls
)

local function SetupHoldButton(Button, SetState)
	Button.MouseButton1Down:Connect(function()
		SetState(true)
	end)

	Button.MouseButton1Up:Connect(function()
		SetState(false)
	end)

	Button.InputEnded:Connect(function()
		SetState(false)
	end)
end

SetupHoldButton(ForwardButton, function(State)
	MovingForward = State
end)

SetupHoldButton(BackButton, function(State)
	MovingBack = State
end)

SetupHoldButton(LeftButton, function(State)
	MovingLeft = State
end)

SetupHoldButton(RightButton, function(State)
	MovingRight = State
end)

SetupHoldButton(UpButton, function(State)
	MovingUp = State
end)

SetupHoldButton(DownButton, function(State)
	MovingDown = State
end)

--========================================================
-- LOGICA DE BOTONES
--========================================================

MovementButton.MouseButton1Click:Connect(function()
	MovementEnabled = not MovementEnabled

	MovementButton.Text =
		MovementEnabled and
		"MOVIMIENTO: ACTIVADO" or
		"MOVIMIENTO: DESACTIVADO"

	MovementButton.BackgroundColor3 =
		MovementEnabled and
		Color3.fromRGB(50, 180, 90) or
		Color3.fromRGB(180, 50, 50)
end)

NoclipButton.MouseButton1Click:Connect(function()
	NoclipEnabled = not NoclipEnabled

	NoclipButton.Text =
		NoclipEnabled and
		"NOCLIP: ACTIVADO" or
		"NOCLIP: DESACTIVADO"

	NoclipButton.BackgroundColor3 =
		NoclipEnabled and
		Color3.fromRGB(50, 180, 90) or
		Color3.fromRGB(180, 50, 50)
end)

TrompoButton.MouseButton1Click:Connect(function()
	TrompoEnabled = not TrompoEnabled

	TrompoButton.Text =
		TrompoEnabled and
		"TROMPO: ACTIVADO" or
		"TROMPO: DESACTIVADO"

	TrompoButton.BackgroundColor3 =
		TrompoEnabled and
		Color3.fromRGB(50, 180, 90) or
		Color3.fromRGB(180, 50, 50)

	if Humanoid then
		Humanoid.AutoRotate = not TrompoEnabled
	end
end)

FlyButton.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled

	FlyControls.Visible = FlyEnabled
	VerticalControls.Visible = FlyEnabled

	if FlyEnabled then
		EnableFly()
	else
		MovingForward = false
		MovingBack = false
		MovingLeft = false
		MovingRight = false
		MovingUp = false
		MovingDown = false

		DisableFly()
	end

	FlyButton.Text =
		FlyEnabled and
		"FLY: ACTIVADO" or
		"FLY: DESACTIVADO"

	FlyButton.BackgroundColor3 =
		FlyEnabled and
		Color3.fromRGB(50, 180, 90) or
		Color3.fromRGB(180, 50, 50)
end)

--========================================================
-- CURVA DE VELOCIDAD TROMPO
--========================================================

local function GetTrompoRPS(Percent)
	if Percent <= 50 then
		return (Percent / 50) * 10
	else
		local T = (Percent - 50) / 50
		return 10 + (T * T * 90)
	end
end

--========================================================
-- LOOP PRINCIPAL
--========================================================

RunService.RenderStepped:Connect(function(DeltaTime)
	if not RootPart or not Humanoid then
		return
	end

	-- TROMPO
	if TrompoEnabled then
		local RPS = GetTrompoRPS(TrompoSpeed)
		local DegreesPerSecond = RPS * 360

		RootPart.CFrame =
			RootPart.CFrame *
			CFrame.Angles(
				0,
				math.rad(DegreesPerSecond * DeltaTime),
				0
			)
	end

	-- MOVIMIENTO BOOST
	if MovementEnabled and not FlyEnabled then
		local Direction = Humanoid.MoveDirection

		local FlatDirection = Vector3.new(
			Direction.X,
			0,
			Direction.Z
		)

		if FlatDirection.Magnitude <= 0.01 then
			local Velocity = RootPart.AssemblyLinearVelocity

			RootPart.AssemblyLinearVelocity =
				Vector3.new(0, Velocity.Y, 0)
		else
			FlatDirection = FlatDirection.Unit

			local FinalSpeed =
				math.max(
					Humanoid.WalkSpeed,
					BoostSpeed
				)

			RootPart.AssemblyLinearVelocity =
				Vector3.new(
					FlatDirection.X * FinalSpeed,
					RootPart.AssemblyLinearVelocity.Y,
					FlatDirection.Z * FinalSpeed
				)

			if not TrompoEnabled then
				RootPart.CFrame =
					CFrame.lookAt(
						RootPart.Position,
						RootPart.Position + FlatDirection
					)
			end
		end
	end

	-- FLY
	if FlyEnabled then
		local Camera = workspace.CurrentCamera

		if Camera and FlyPosition then
			local Direction = Vector3.zero

			local Look = Camera.CFrame.LookVector
			local Right = Camera.CFrame.RightVector

			local Forward =
				Vector3.new(
					Look.X,
					0,
					Look.Z
				)

			local Side =
				Vector3.new(
					Right.X,
					0,
					Right.Z
				)

			if Forward.Magnitude > 0 then
				Forward = Forward.Unit
			end

			if Side.Magnitude > 0 then
				Side = Side.Unit
			end

			if MovingForward then
				Direction += Forward
			end

			if MovingBack then
				Direction -= Forward
			end

			if MovingLeft then
				Direction -= Side
			end

			if MovingRight then
				Direction += Side
			end

			if MovingUp then
				Direction += Vector3.new(0, 1, 0)
			end

			if MovingDown then
				Direction -= Vector3.new(0, 1, 0)
			end

			if Direction.Magnitude > 0 then
				FlyPosition.Position =
					FlyPosition.Position +
					Direction.Unit *
					FlySpeed *
					DeltaTime
			end
		end
	end
end)

--========================================================
-- NOCLIP
--========================================================

RunService.Stepped:Connect(function()
	if not Character then
		return
	end

	for _, Object in ipairs(Character:GetDescendants()) do
		if Object:IsA("BasePart") then
			Object.CanCollide = not NoclipEnabled
		end
	end
end)

--========================================================
-- MINIMIZAR
--========================================================

local Minimized = false
local OpenSize = Main.Size

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		Main.Size = UDim2.new(0, 170, 0, 38)
		Scroll.Visible = false
		Minimize.Text = "+"
	else
		Main.Size = OpenSize
		Scroll.Visible = true
		Minimize.Text = "-"
	end
end)
