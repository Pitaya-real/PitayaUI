local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

PitayaUI.Themes = {
	Pitaya = {
		Background = Color3.fromRGB(8, 10, 14),
		Window = Color3.fromRGB(16, 18, 24),
		Card = Color3.fromRGB(22, 25, 34),
		Border = Color3.fromRGB(45, 50, 65),
		TextMain = Color3.fromRGB(245, 245, 250),
		TextSub = Color3.fromRGB(150, 155, 170),
		Accent = Color3.fromRGB(0, 162, 255),
		AccentHover = Color3.fromRGB(30, 180, 255)
	}
}

PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium }
}

-- Quản lý File Cấu Hình (Auto Save UI Size & Position)
local ConfigFolder = "PitayaUI"
local ConfigFile = ConfigFolder .. "/ui_config.json"

local function SaveConfig(data)
	pcall(function()
		if writefile then
			if isfolder and not isfolder(ConfigFolder) and makefolder then
				makefolder(ConfigFolder)
			end
			writefile(ConfigFile, HttpService:JSONEncode(data))
		end
	end)
end

local function LoadConfig()
	local success, result = pcall(function()
		if readfile and isfile and isfile(ConfigFile) then
			return HttpService:JSONDecode(readfile(ConfigFile))
		end
	end)
	if success and result then return result end
	return nil
end

-- Định dạng Logo ID
local function FormatAssetId(id)
	if typeof(id) == "number" then
		return "rbxassetid://" .. tostring(id)
	elseif typeof(id) == "string" then
		if string.find(id, "rbxassetid://") or string.find(id, "http") then
			return id
		elseif tonumber(id) then
			return "rbxassetid://" .. id
		end
	end
	return "rbxassetid://115347218827913"
end

local function AddUICorner(parent, radius)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function AddUIStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or Color3.fromRGB(45, 50, 65)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0
	return stroke
end

-- Xử lý Dragging (Kéo thả mượt)
local function MakeDraggable(gui, handle)
	handle = handle or gui
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Xử lý Resizing (Thu phóng bằng góc dưới phải)
local function MakeResizable(gui, handle, minSize, maxSize, onResizeEnd)
	minSize = minSize or Vector2.new(500, 320)
	maxSize = maxSize or Vector2.new(900, 600)
	local resizing, resizeStart, startSize

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = gui.AbsoluteSize
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if resizing then
				resizing = false
				if onResizeEnd then onResizeEnd(gui.Size) end
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newW = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
			local newH = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
			gui.Size = UDim2.new(0, newW, 0, newH)
		end
	end)
end

function PitayaUI:BindFont(instance, fontRole)
	table.insert(self.FontObjects, { Instance = instance, Role = fontRole or "Main" })
	if self.Fonts[fontRole] then instance.Font = self.Fonts[fontRole] end
	return instance
end

function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "RealKid Hub : Blox Fruits"
	WindowObj.LogoId = FormatAssetId(config.Logo)
	WindowObj.Tabs = {}
	WindowObj.FontObjects = {}

	local savedConfig = LoadConfig() or {}
	WindowObj.SavedWidth = savedConfig.Width or 650
	WindowObj.SavedHeight = savedConfig.Height or 370

	local selectedTheme = config.Theme or "Pitaya"
	local baseTheme = PitayaUI.Themes[selectedTheme] or PitayaUI.Themes.Pitaya
	WindowObj.Colors = {}
	for k, v in pairs(baseTheme) do WindowObj.Colors[k] = v end
	WindowObj.Fonts = PitayaUI.FontPresets.Gotham

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = HttpService:GenerateGUID(false)
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = game:GetService("CoreGui")
	else pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end); if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end end
	WindowObj.ScreenGui = ScreenGui

	-- Tự động căn chỉnh UI cho tương thích điện thoại & máy tính (UIScale)
	local UIScale = Instance.new("UIScale", ScreenGui)
	local Camera = Workspace.CurrentCamera
	local function UpdateAutoScaling()
		local viewport = Camera.ViewportSize
		local baseWidth = 850
		UIScale.Scale = math.clamp(viewport.X / baseWidth, 0.5, 1)
	end
	UpdateAutoScaling()
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateAutoScaling)

	-- Notification Container
	local NotifContainer = Instance.new("Frame", ScreenGui)
	NotifContainer.Name = "NotifContainer"
	NotifContainer.Size = UDim2.new(0, 260, 1, -40)
	NotifContainer.Position = UDim2.new(1, -280, 0, 20)
	NotifContainer.BackgroundTransparency = 1
	WindowObj.NotifContainer = NotifContainer

	local NotifList = Instance.new("UIListLayout", NotifContainer)
	NotifList.SortOrder = Enum.SortOrder.LayoutOrder
	NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifList.Padding = UDim.new(0, 8)

	-- Nút Toggle nổi bật (Có Logo)
	local ToggleBtn = Instance.new("ImageButton", ScreenGui)
	ToggleBtn.Name = "PitayaToggle"
	ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
	ToggleBtn.Position = UDim2.new(0, 20, 0, 100)
	ToggleBtn.BackgroundColor3 = WindowObj.Colors.Window
	ToggleBtn.Image = WindowObj.LogoId
	ToggleBtn.Active = true
	AddUICorner(ToggleBtn, 23)
	AddUIStroke(ToggleBtn, WindowObj.Colors.Accent, 2)
	MakeDraggable(ToggleBtn)

	-- Main Frame
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
	MainFrame.Position = savedConfig.PosX and savedConfig.PosY and UDim2.new(0, savedConfig.PosX, 0, savedConfig.PosY) or UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
	MainFrame.BackgroundColor3 = WindowObj.Colors.Background
	MainFrame.BackgroundTransparency = 0.45
	MainFrame.ClipsDescendants = false
	AddUICorner(MainFrame, 10)
	AddUIStroke(MainFrame, Color3.fromRGB(255, 255, 255), 1, 0.85)
	WindowObj.MainFrame = MainFrame

	-- Thanh Header làm vùng kéo thả Drag
	local HeaderDragBar = Instance.new("Frame", MainFrame)
	HeaderDragBar.Size = UDim2.new(1, 0, 0, 28)
	HeaderDragBar.BackgroundTransparency = 1
	MakeDraggable(MainFrame, HeaderDragBar)

	-- Title chính giữa
	local TitleLabel = Instance.new("TextLabel", HeaderDragBar)
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = WindowObj.TitleText
	TitleLabel.TextColor3 = WindowObj.Colors.Accent
	TitleLabel.TextSize = 13
	WindowObj:BindFont(TitleLabel, "Bold")

	-- Nút Resize ở góc dưới bên phải
	local ResizeGrip = Instance.new("ImageLabel", MainFrame)
	ResizeGrip.Size = UDim2.new(0, 14, 0, 14)
	ResizeGrip.Position = UDim2.new(1, -16, 1, -16)
	ResizeGrip.BackgroundTransparency = 1
	ResizeGrip.Image = "rbxassetid://6031097225"
	ResizeGrip.ImageColor3 = WindowObj.Colors.TextSub
	ResizeGrip.Active = true

	MakeResizable(MainFrame, ResizeGrip, Vector2.new(520, 320), Vector2.new(900, 600), function(newSize)
		SaveConfig({
			Width = newSize.X.Offset,
			Height = newSize.Y.Offset,
			PosX = MainFrame.Position.X.Offset,
			PosY = MainFrame.Position.Y.Offset
		})
	end)

	-- Animation Bật/Tắt UI
	local isOpen = true
	ToggleBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth * 0.85, 0, WindowObj.SavedHeight * 0.85)
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
			}):Play()
		else
			local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, WindowObj.SavedWidth * 0.85, 0, WindowObj.SavedHeight * 0.85)
			})
			tween:Play()
			tween.Completed:Connect(function()
				if not isOpen then MainFrame.Visible = false end
			end)
		end
	end)

	-- 1. Sidebar Trái
	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 175, 1, -36)
	Sidebar.Position = UDim2.new(0, 8, 0, 28)
	Sidebar.BackgroundColor3 = WindowObj.Colors.Window
	Sidebar.BackgroundTransparency = 0.05
	AddUICorner(Sidebar, 8)
	AddUIStroke(Sidebar, WindowObj.Colors.Border, 1)

	local SearchBoxFrame = Instance.new("Frame", Sidebar)
	SearchBoxFrame.Size = UDim2.new(1, -16, 0, 28)
	SearchBoxFrame.Position = UDim2.new(0, 8, 0, 8)
	SearchBoxFrame.BackgroundColor3 = WindowObj.Colors.Background
	AddUICorner(SearchBoxFrame, 6)
	AddUIStroke(SearchBoxFrame, WindowObj.Colors.Border, 1)

	local SearchInput = Instance.new("TextBox", SearchBoxFrame)
	SearchInput.Size = UDim2.new(1, -12, 1, 0)
	SearchInput.Position = UDim2.new(0, 8, 0, 0)
	SearchInput.BackgroundTransparency = 1
	SearchInput.Text = ""
	SearchInput.PlaceholderText = "🔍 Search section or Functi..."
	SearchInput.TextColor3 = WindowObj.Colors.TextMain
	SearchInput.PlaceholderColor3 = WindowObj.Colors.TextSub
	SearchInput.TextSize = 10
	SearchInput.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(SearchInput, "Main")

	local TabListContainer = Instance.new("ScrollingFrame", Sidebar)
	TabListContainer.Size = UDim2.new(1, -8, 1, -44)
	TabListContainer.Position = UDim2.new(0, 4, 0, 40)
	TabListContainer.BackgroundTransparency = 1
	TabListContainer.ScrollBarThickness = 0

	local UIList = Instance.new("UIListLayout", TabListContainer)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 3)

	-- 2. Content Frame Phải
	local ContentFrame = Instance.new("Frame", MainFrame)
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Size = UDim2.new(1, -201, 1, -36)
	ContentFrame.Position = UDim2.new(0, 191, 0, 28)
	ContentFrame.BackgroundColor3 = WindowObj.Colors.Window
	ContentFrame.BackgroundTransparency = 0.05
	AddUICorner(ContentFrame, 8)
	AddUIStroke(ContentFrame, WindowObj.Colors.Border, 1)

	local TabHeaderBar = Instance.new("Frame", ContentFrame)
	TabHeaderBar.Size = UDim2.new(1, 0, 0, 30)
	TabHeaderBar.BackgroundTransparency = 1

	local CurrentTabTitle = Instance.new("TextLabel", TabHeaderBar)
	CurrentTabTitle.Size = UDim2.new(1, -30, 1, 0)
	CurrentTabTitle.Position = UDim2.new(0, 12, 0, 0)
	CurrentTabTitle.BackgroundTransparency = 1
	CurrentTabTitle.Text = "Tab"
	CurrentTabTitle.TextColor3 = WindowObj.Colors.TextMain
	CurrentTabTitle.TextSize = 12
	CurrentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(CurrentTabTitle, "Bold")
	WindowObj.CurrentTabTitle = CurrentTabTitle

	local ContentArea = Instance.new("Frame", ContentFrame)
	ContentArea.Size = UDim2.new(1, -16, 1, -36)
	ContentArea.Position = UDim2.new(0, 8, 0, 32)
	ContentArea.BackgroundTransparency = 1

	WindowObj.ContentArea = ContentArea
	WindowObj.TabListContainer = TabListContainer

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(SearchInput.Text)
		for _, tabData in ipairs(WindowObj.Tabs) do
			tabData.Button.Visible = (string.find(string.lower(tabData.Name), query) ~= nil)
		end
	end)

	return WindowObj
end

function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 48)
	notifFrame.BackgroundColor3 = self.Colors.Card
	AddUICorner(notifFrame, 6)
	AddUIStroke(notifFrame, self.Colors.Border, 1)

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -16, 0, 16)
	titleLbl.Position = UDim2.new(0, 8, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.Accent
	titleLbl.TextSize = 11
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -16, 0, 20)
	descLbl.Position = UDim2.new(0, 8, 0, 22)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = self.Colors.TextMain
	descLbl.TextSize = 10
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(descLbl, "Main")

	task.delay(duration, function()
		if notifFrame and notifFrame.Parent then notifFrame:Destroy() end
	end)
end

function PitayaUI:CreateTab(tabName)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 2
	page.Visible = false

	local PageList = Instance.new("UIListLayout", page)
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.Padding = UDim.new(0, 8)

	local tabBtn = Instance.new("TextButton", window.TabListContainer)
	tabBtn.Size = UDim2.new(1, 0, 0, 30)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = ""

	local activeBar = Instance.new("Frame", tabBtn)
	activeBar.Size = UDim2.new(0, 3, 1, -10)
	activeBar.Position = UDim2.new(0, 0, 0.5, -10)
	activeBar.BackgroundColor3 = window.Colors.Accent
	activeBar.Visible = false
	AddUICorner(activeBar, 2)

	local tabTextLabel = Instance.new("TextLabel", tabBtn)
	tabTextLabel.Size = UDim2.new(1, -16, 1, 0)
	tabTextLabel.Position = UDim2.new(0, 14, 0, 0)
	tabTextLabel.BackgroundTransparency = 1
	tabTextLabel.Text = tabName
	tabTextLabel.TextColor3 = window.Colors.TextSub
	tabTextLabel.TextSize = 11
	tabTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	window:BindFont(tabTextLabel, "Medium")

	-- Animation chuyển Tab
	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			t.ActiveBar.Visible = false
			t.TextLabel.TextColor3 = window.Colors.TextSub
		end
		page.Visible = true
		activeBar.Visible = true
		TweenService:Create(tabTextLabel, TweenInfo.new(0.2), {TextColor3 = window.Colors.TextMain}):Play()
		if window.CurrentTabTitle then
			window.CurrentTabTitle.Text = tabName
		end
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	TabObj.ActiveBar = activeBar
	TabObj.TextLabel = tabTextLabel
	TabObj.Name = tabName
	table.insert(window.Tabs, TabObj)

	if #window.Tabs == 1 then ActivateTab() end

	function TabObj:AddSection(text)
		local sectionFrame = Instance.new("Frame", page)
		sectionFrame.Size = UDim2.new(1, 0, 0, 22)
		sectionFrame.BackgroundTransparency = 1

		local line = Instance.new("Frame", sectionFrame)
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 1, -1)
		line.BackgroundColor3 = window.Colors.Border

		local label = Instance.new("TextLabel", sectionFrame)
		label.Size = UDim2.new(1, 0, 1, -2)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = window.Colors.TextSub
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Center
		window:BindFont(label, "Bold")
	end

	function TabObj:AddButton(options)
		options = options or {}
		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, options.SubText and 48 or 38)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border, 1)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -95, 0, 16)
		label.Position = UDim2.new(0, 10, 0, options.SubText and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Button"
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if options.SubText then
			local sub = Instance.new("TextLabel", card)
			sub.Size = UDim2.new(1, -95, 0, 14)
			sub.Position = UDim2.new(0, 10, 0, 24)
			sub.BackgroundTransparency = 1
			sub.Text = options.SubText
			sub.TextColor3 = window.Colors.TextSub
			sub.TextSize = 9
			sub.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(sub, "Main")
		end

		local actionBtn = Instance.new("TextButton", card)
		actionBtn.Size = UDim2.new(0, 68, 0, 22)
		actionBtn.Position = UDim2.new(1, -78, 0.5, -11)
		actionBtn.BackgroundColor3 = window.Colors.Accent
		actionBtn.Text = "Click"
		actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		actionBtn.TextSize = 10
		AddUICorner(actionBtn, 11)
		window:BindFont(actionBtn, "Bold")

		actionBtn.MouseButton1Click:Connect(function()
			TweenService:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 62, 0, 20)}):Play()
			task.wait(0.1)
			TweenService:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 68, 0, 22)}):Play()
			if options.Callback then options.Callback() end
		end)
	end

	function TabObj:AddToggle(options)
		options = options or {}
		local state = options.Default or false
		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, options.SubText and 48 or 38)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border, 1)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -45, 0, 16)
		label.Position = UDim2.new(0, 10, 0, options.SubText and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Toggle"
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if options.SubText then
			local sub = Instance.new("TextLabel", card)
			sub.Size = UDim2.new(1, -45, 0, 14)
			sub.Position = UDim2.new(0, 10, 0, 24)
			sub.BackgroundTransparency = 1
			sub.Text = options.SubText
			sub.TextColor3 = window.Colors.TextSub
			sub.TextSize = 9
			sub.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(sub, "Main")
		end

		local checkSquare = Instance.new("TextButton", card)
		checkSquare.Size = UDim2.new(0, 18, 0, 18)
		checkSquare.Position = UDim2.new(1, -28, 0.5, -9)
		checkSquare.BackgroundColor3 = window.Colors.Background
		checkSquare.Text = state and "✓" or ""
		checkSquare.TextColor3 = window.Colors.Accent
		checkSquare.TextSize = 12
		AddUICorner(checkSquare, 3)
		local stroke = AddUIStroke(checkSquare, state and window.Colors.Accent or window.Colors.Border, 1)

		checkSquare.MouseButton1Click:Connect(function()
			state = not state
			checkSquare.Text = state and "✓" or ""
			TweenService:Create(stroke, TweenInfo.new(0.2), {Color = state and window.Colors.Accent or window.Colors.Border}):Play()
			if options.Callback then options.Callback(state) end
		end)
	end

	function TabObj:AddSlider(options)
		options = options or {}
		local min, max = options.Min or 0, options.Max or 100
		local default = math.clamp(options.Default or min, min, max)

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, 48)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border, 1)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -55, 0, 16)
		label.Position = UDim2.new(0, 10, 0, 6)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Slider"
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local valLabel = Instance.new("TextLabel", card)
		valLabel.Size = UDim2.new(0, 40, 0, 16)
		valLabel.Position = UDim2.new(1, -48, 0, 6)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(default)
		valLabel.TextColor3 = window.Colors.TextSub
		valLabel.TextSize = 10
		window:BindFont(valLabel, "Main")

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -20, 0, 5)
		sliderBar.Position = UDim2.new(0, 10, 0, 31)
		sliderBar.BackgroundColor3 = window.Colors.Background
		AddUICorner(sliderBar, 2)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.Accent
		AddUICorner(sliderFill, 2)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local val = math.floor(min + (max - min) * pos)
			valLabel.Text = tostring(val)
			TweenService:Create(sliderFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
			if options.Callback then options.Callback(val) end
		end

		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true; UpdateSlider(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
		end)
	end

	function TabObj:AddDropdown(options)
		options = options or {}
		local items = options.Items or {}
		local currentChoice = options.Default or items[1] or ""
		local isDropped = false

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, 36)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border, 1)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -30, 0, 36)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = (options.Text or "Dropdown") .. ": " .. tostring(currentChoice)
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local arrow = Instance.new("TextLabel", card)
		arrow.Size = UDim2.new(0, 24, 0, 36)
		arrow.Position = UDim2.new(1, -26, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "›"
		arrow.TextColor3 = window.Colors.TextSub
		arrow.TextSize = 16

		local listContainer = Instance.new("ScrollingFrame", card)
		listContainer.Size = UDim2.new(1, 0, 0, 0)
		listContainer.Position = UDim2.new(0, 0, 0, 36)
		listContainer.BackgroundTransparency = 1
		listContainer.ScrollBarThickness = 2
		listContainer.ClipsDescendants = true

		local listLayout = Instance.new("UIListLayout", listContainer)

		local function ToggleDrop()
			isDropped = not isDropped
			arrow.Text = isDropped and "˅" or "›"
			local listH = isDropped and (#items * 24) or 0
			TweenService:Create(card, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, isDropped and (36 + listH + 4) or 36)}):Play()
			TweenService:Create(listContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, listH)}):Play()
		end

		for _, v in ipairs(items) do
			local btn = Instance.new("TextButton", listContainer)
			btn.Size = UDim2.new(1, 0, 0, 24)
			btn.BackgroundTransparency = 1
			btn.Text = tostring(v)
			btn.TextColor3 = (v == currentChoice) and window.Colors.Accent or window.Colors.TextSub
			btn.TextSize = 10
			window:BindFont(btn, "Main")

			btn.MouseButton1Click:Connect(function()
				currentChoice = v
				label.Text = (options.Text or "Dropdown") .. ": " .. tostring(currentChoice)
				if options.Callback then options.Callback(v) end
				ToggleDrop()
			end)
		end

		local headerBtn = Instance.new("TextButton", card)
		headerBtn.Size = UDim2.new(1, 0, 0, 36)
		headerBtn.BackgroundTransparency = 1
		headerBtn.Text = ""
		headerBtn.MouseButton1Click:Connect(ToggleDrop)
	end

	return TabObj
end

return PitayaUI
