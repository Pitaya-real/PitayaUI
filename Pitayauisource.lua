local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Services = setmetatable({}, {
	__index = function(_, service)
		local s = game:GetService(service)
		return (cloneref and cloneref(s)) or s
	end
})

local Players = Services.Players
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CoreGui = Services.CoreGui
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local HttpService = Services.HttpService
local Workspace = Services.Workspace

-- Hàm xử lý Parent an toàn (Ưu tiên gethui > CoreGui > PlayerGui)
local function ParentToSafeGui(screenGui)
	if gethui then
		screenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(screenGui)
		screenGui.Parent = CoreGui
	else
		local success = pcall(function()
			screenGui.Parent = CoreGui
		end)
		if not success or not screenGui.Parent then
			screenGui.Parent = PlayerGui
		end
	end
end

-- Danh sách Themes
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
	},
	Dark = {
		Background = Color3.fromRGB(15, 15, 15),
		Window = Color3.fromRGB(25, 25, 25),
		Card = Color3.fromRGB(35, 35, 35),
		Border = Color3.fromRGB(60, 60, 60),
		TextMain = Color3.fromRGB(255, 255, 255),
		TextSub = Color3.fromRGB(170, 170, 170),
		Accent = Color3.fromRGB(120, 80, 220),
		AccentHover = Color3.fromRGB(140, 100, 240)
	},
	Blood = {
		Background = Color3.fromRGB(14, 8, 8),
		Window = Color3.fromRGB(24, 16, 16),
		Card = Color3.fromRGB(34, 22, 22),
		Border = Color3.fromRGB(65, 45, 45),
		TextMain = Color3.fromRGB(250, 245, 245),
		TextSub = Color3.fromRGB(170, 150, 150),
		Accent = Color3.fromRGB(255, 50, 50),
		AccentHover = Color3.fromRGB(255, 80, 80)
	},
	Ocean = {
		Background = Color3.fromRGB(6, 14, 20),
		Window = Color3.fromRGB(12, 24, 34),
		Card = Color3.fromRGB(18, 34, 48),
		Border = Color3.fromRGB(30, 60, 80),
		TextMain = Color3.fromRGB(240, 250, 255),
		TextSub = Color3.fromRGB(140, 175, 195),
		Accent = Color3.fromRGB(0, 200, 200),
		AccentHover = Color3.fromRGB(50, 230, 230)
	}
}

-- Danh sách Font Presets
PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium },
	Roboto = { Main = Enum.Font.Roboto, Bold = Enum.Font.RobotoMono, Medium = Enum.Font.Roboto },
	Code = { Main = Enum.Font.Code, Bold = Enum.Font.Code, Medium = Enum.Font.Code },
	SourceSans = { Main = Enum.Font.SourceSans, Bold = Enum.Font.SourceSansBold, Medium = Enum.Font.SourceSansSemibold }
}

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
			return HttpService:JSONEncode(readfile(ConfigFile))
		end
	end)
	if success and result then return result end
	return nil
end

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

local function MakeDraggable(gui, handle, getScale, onDragEnd)
	handle = handle or gui
	local dragging = false
	local dragStart = Vector3.new()
	local startPos = UDim2.new()

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				dragging = false
				if onDragEnd then onDragEnd(gui.Position) end
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local scale = getScale and getScale() or 1
			local delta = (input.Position - dragStart) / scale
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function MakeResizable(gui, handle, minSize, maxSize, getScale, onResize, onResizeEnd)
	minSize = minSize or Vector2.new(500, 300)
	maxSize = maxSize or Vector2.new(950, 650)
	local resizing = false
	local resizeStart = Vector3.new()
	local startSize = Vector2.new()

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = Vector2.new(gui.Size.X.Offset, gui.Size.Y.Offset)
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
			local scale = getScale and getScale() or 1
			local delta = (input.Position - resizeStart) / scale
			local newW = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
			local newH = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
			gui.Size = UDim2.new(0, newW, 0, newH)
			if onResize then onResize(gui.Size) end
		end
	end)
end

function PitayaUI:BindFont(instance, fontRole)
	table.insert(self.FontObjects, { Instance = instance, Role = fontRole or "Main" })
	if self.Fonts[fontRole] then instance.Font = self.Fonts[fontRole] end
	return instance
end

function PitayaUI:RegisterTheme(instance, property, colorRole)
	table.insert(self.ThemeObjects, { Instance = instance, Property = property, Role = colorRole })
	if self.Colors[colorRole] then
		instance[property] = self.Colors[colorRole]
	end
	return instance
end

function PitayaUI:SetTheme(themeName)
	local baseTheme = PitayaUI.Themes[themeName]
	if not baseTheme then return end
	for k, v in pairs(baseTheme) do
		self.Colors[k] = v
	end
	for _, obj in ipairs(self.ThemeObjects) do
		if obj.Instance and obj.Instance.Parent then
			obj.Instance[obj.Property] = self.Colors[obj.Role]
		end
	end
end

function PitayaUI:SetFont(fontName)
	local preset = PitayaUI.FontPresets[fontName]
	if not preset then return end
	self.Fonts = preset
	for _, item in ipairs(self.FontObjects) do
		if item.Instance and item.Instance.Parent then
			item.Instance.Font = self.Fonts[item.Role] or Enum.Font.Gotham
		end
	end
end

function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "RealKid Hub : Blox Fruits"
	WindowObj.LogoId = FormatAssetId(config.Logo)
	WindowObj.Tabs = {}
	WindowObj.FontObjects = {}
	WindowObj.ThemeObjects = {}

	local savedConfig = LoadConfig() or {}
	WindowObj.SavedWidth = savedConfig.Width or 650
	WindowObj.SavedHeight = savedConfig.Height or 370

	local selectedTheme = config.Theme or "Pitaya"
	local baseTheme = PitayaUI.Themes[selectedTheme] or PitayaUI.Themes.Pitaya
	WindowObj.Colors = {}
	for k, v in pairs(baseTheme) do WindowObj.Colors[k] = v end

	local selectedFont = config.Font or "Gotham"
	WindowObj.Fonts = PitayaUI.FontPresets[selectedFont] or PitayaUI.FontPresets.Gotham

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = HttpService:GenerateGUID(false)
	ScreenGui.ResetOnSpawn = false
	ParentToSafeGui(ScreenGui)
	WindowObj.ScreenGui = ScreenGui

	local UIScale = Instance.new("UIScale", ScreenGui)
	local Camera = Workspace.CurrentCamera
	local function UpdateAutoScaling()
		local viewport = Camera.ViewportSize
		local baseWidth = 850
		UIScale.Scale = math.clamp(viewport.X / baseWidth, 0.5, 1)
	end
	UpdateAutoScaling()
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateAutoScaling)

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

	local ToggleBtn = Instance.new("ImageButton", ScreenGui)
	ToggleBtn.Name = "PitayaToggle"
	ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
	ToggleBtn.Position = UDim2.new(0, 20, 0, 100)
	WindowObj:RegisterTheme(ToggleBtn, "BackgroundColor3", "Window")
	ToggleBtn.Image = WindowObj.LogoId
	ToggleBtn.Active = true
	AddUICorner(ToggleBtn, 23)
	local toggleStroke = AddUIStroke(ToggleBtn, WindowObj.Colors.Accent, 2)
	WindowObj:RegisterTheme(toggleStroke, "Color", "Accent")
	MakeDraggable(ToggleBtn, nil, function() return UIScale.Scale end)

	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
	MainFrame.Position = savedConfig.PosX and savedConfig.PosY and UDim2.new(0, savedConfig.PosX, 0, savedConfig.PosY) or UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
	WindowObj:RegisterTheme(MainFrame, "BackgroundColor3", "Background")
	MainFrame.BackgroundTransparency = 0.1
	MainFrame.ClipsDescendants = false
	AddUICorner(MainFrame, 10)
	local mainStroke = AddUIStroke(MainFrame, WindowObj.Colors.Border, 1)
	WindowObj:RegisterTheme(mainStroke, "Color", "Border")
	WindowObj.MainFrame = MainFrame

	local function SaveCurrentState()
		SaveConfig({
			Width = WindowObj.SavedWidth,
			Height = WindowObj.SavedHeight,
			PosX = MainFrame.Position.X.Offset,
			PosY = MainFrame.Position.Y.Offset
		})
	end

	local HeaderDragBar = Instance.new("Frame", MainFrame)
	HeaderDragBar.Size = UDim2.new(1, 0, 0, 28)
	HeaderDragBar.BackgroundTransparency = 1
	MakeDraggable(MainFrame, HeaderDragBar, function() return UIScale.Scale end, function() SaveCurrentState() end)

	local TitleLabel = Instance.new("TextLabel", HeaderDragBar)
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = WindowObj.TitleText
	WindowObj:RegisterTheme(TitleLabel, "TextColor3", "Accent")
	TitleLabel.TextSize = 13
	WindowObj:BindFont(TitleLabel, "Bold")

	local ResizeGrip = Instance.new("ImageLabel", MainFrame)
	ResizeGrip.Size = UDim2.new(0, 18, 0, 18)
	ResizeGrip.Position = UDim2.new(1, -18, 1, -18)
	ResizeGrip.BackgroundTransparency = 1
	ResizeGrip.Image = "rbxassetid://6031097225"
	WindowObj:RegisterTheme(ResizeGrip, "ImageColor3", "TextSub")
	ResizeGrip.Active = true
	ResizeGrip.ZIndex = 10

	MakeResizable(
		MainFrame, ResizeGrip, Vector2.new(500, 300), Vector2.new(950, 650),
		function() return UIScale.Scale end,
		function(newSize)
			WindowObj.SavedWidth = newSize.X.Offset
			WindowObj.SavedHeight = newSize.Y.Offset
		end,
		function() SaveCurrentState() end
	)

	local isOpen = true
	ToggleBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth * 0.85, 0, WindowObj.SavedHeight * 0.85)
			TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
			}):Play()
		else
			local tween = TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, WindowObj.SavedWidth * 0.85, 0, WindowObj.SavedHeight * 0.85)
			})
			tween:Play()
			tween.Completed:Connect(function() if not isOpen then MainFrame.Visible = false end end)
		end
	end)

	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 175, 1, -36)
	Sidebar.Position = UDim2.new(0, 8, 0, 28)
	WindowObj:RegisterTheme(Sidebar, "BackgroundColor3", "Window")
	Sidebar.BackgroundTransparency = 0.05
	AddUICorner(Sidebar, 8)
	local sidebarStroke = AddUIStroke(Sidebar, WindowObj.Colors.Border, 1)
	WindowObj:RegisterTheme(sidebarStroke, "Color", "Border")

	local SearchBoxFrame = Instance.new("Frame", Sidebar)
	SearchBoxFrame.Size = UDim2.new(1, -16, 0, 28)
	SearchBoxFrame.Position = UDim2.new(0, 8, 0, 8)
	WindowObj:RegisterTheme(SearchBoxFrame, "BackgroundColor3", "Background")
	AddUICorner(SearchBoxFrame, 6)
	local searchStroke = AddUIStroke(SearchBoxFrame, WindowObj.Colors.Border, 1)
	WindowObj:RegisterTheme(searchStroke, "Color", "Border")

	local SearchInput = Instance.new("TextBox", SearchBoxFrame)
	SearchInput.Size = UDim2.new(1, -12, 1, 0)
	SearchInput.Position = UDim2.new(0, 8, 0, 0)
	SearchInput.BackgroundTransparency = 1
	SearchInput.Text = ""
	SearchInput.PlaceholderText = "🔍 Tìm kiếm..."
	WindowObj:RegisterTheme(SearchInput, "TextColor3", "TextMain")
	WindowObj:RegisterTheme(SearchInput, "PlaceholderColor3", "TextSub")
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

	local ContentFrame = Instance.new("Frame", MainFrame)
	ContentFrame.Name = "ContentFrame"
	ContentFrame.Size = UDim2.new(1, -201, 1, -36)
	ContentFrame.Position = UDim2.new(0, 191, 0, 28)
	WindowObj:RegisterTheme(ContentFrame, "BackgroundColor3", "Window")
	ContentFrame.BackgroundTransparency = 0.05
	AddUICorner(ContentFrame, 8)
	local contentStroke = AddUIStroke(ContentFrame, WindowObj.Colors.Border, 1)
	WindowObj:RegisterTheme(contentStroke, "Color", "Border")

	local TabHeaderBar = Instance.new("Frame", ContentFrame)
	TabHeaderBar.Size = UDim2.new(1, 0, 0, 30)
	TabHeaderBar.BackgroundTransparency = 1

	local CurrentTabTitle = Instance.new("TextLabel", TabHeaderBar)
	CurrentTabTitle.Size = UDim2.new(1, -30, 1, 0)
	CurrentTabTitle.Position = UDim2.new(0, 12, 0, 0)
	CurrentTabTitle.BackgroundTransparency = 1
	CurrentTabTitle.Text = "Tab"
	WindowObj:RegisterTheme(CurrentTabTitle, "TextColor3", "TextMain")
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
	self:RegisterTheme(notifFrame, "BackgroundColor3", "Card")
	AddUICorner(notifFrame, 6)
	local stroke = AddUIStroke(notifFrame, self.Colors.Border, 1)
	self:RegisterTheme(stroke, "Color", "Border")

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -16, 0, 16)
	titleLbl.Position = UDim2.new(0, 8, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	self:RegisterTheme(titleLbl, "TextColor3", "Accent")
	titleLbl.TextSize = 11
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -16, 0, 20)
	descLbl.Position = UDim2.new(0, 8, 0, 22)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	self:RegisterTheme(descLbl, "TextColor3", "TextMain")
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
	window:RegisterTheme(activeBar, "BackgroundColor3", "Accent")
	activeBar.Visible = false
	AddUICorner(activeBar, 2)

	local tabTextLabel = Instance.new("TextLabel", tabBtn)
	tabTextLabel.Size = UDim2.new(1, -16, 1, 0)
	tabTextLabel.Position = UDim2.new(0, 14, 0, 0)
	tabTextLabel.BackgroundTransparency = 1
	tabTextLabel.Text = tabName
	window:RegisterTheme(tabTextLabel, "TextColor3", "TextSub")
	tabTextLabel.TextSize = 11
	tabTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	window:BindFont(tabTextLabel, "Medium")

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
		window:RegisterTheme(line, "BackgroundColor3", "Border")

		local label = Instance.new("TextLabel", sectionFrame)
		label.Size = UDim2.new(1, 0, 1, -2)
		label.BackgroundTransparency = 1
		label.Text = text
		window:RegisterTheme(label, "TextColor3", "TextSub")
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Center
		window:BindFont(label, "Bold")
	end

	function TabObj:AddButton(options)
		options = options or {}
		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, options.SubText and 48 or 38)
		window:RegisterTheme(card, "BackgroundColor3", "Card")
		AddUICorner(card, 6)
		local stroke = AddUIStroke(card, window.Colors.Border, 1)
		window:RegisterTheme(stroke, "Color", "Border")

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -95, 0, 16)
		label.Position = UDim2.new(0, 10, 0, options.SubText and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Button"
		window:RegisterTheme(label, "TextColor3", "TextMain")
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if options.SubText then
			local sub = Instance.new("TextLabel", card)
			sub.Size = UDim2.new(1, -95, 0, 14)
			sub.Position = UDim2.new(0, 10, 0, 24)
			sub.BackgroundTransparency = 1
			sub.Text = options.SubText
			window:RegisterTheme(sub, "TextColor3", "TextSub")
			sub.TextSize = 9
			sub.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(sub, "Main")
		end

		local actionBtn = Instance.new("TextButton", card)
		actionBtn.Size = UDim2.new(0, 68, 0, 22)
		actionBtn.Position = UDim2.new(1, -78, 0.5, -11)
		window:RegisterTheme(actionBtn, "BackgroundColor3", "Accent")
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
		window:RegisterTheme(card, "BackgroundColor3", "Card")
		AddUICorner(card, 6)
		local strokeCard = AddUIStroke(card, window.Colors.Border, 1)
		window:RegisterTheme(strokeCard, "Color", "Border")

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -45, 0, 16)
		label.Position = UDim2.new(0, 10, 0, options.SubText and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Toggle"
		window:RegisterTheme(label, "TextColor3", "TextMain")
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if options.SubText then
			local sub = Instance.new("TextLabel", card)
			sub.Size = UDim2.new(1, -45, 0, 14)
			sub.Position = UDim2.new(0, 10, 0, 24)
			sub.BackgroundTransparency = 1
			sub.Text = options.SubText
			window:RegisterTheme(sub, "TextColor3", "TextSub")
			sub.TextSize = 9
			sub.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(sub, "Main")
		end

		local checkSquare = Instance.new("TextButton", card)
		checkSquare.Size = UDim2.new(0, 18, 0, 18)
		checkSquare.Position = UDim2.new(1, -28, 0.5, -9)
		window:RegisterTheme(checkSquare, "BackgroundColor3", "Background")
		checkSquare.Text = state and "✓" or ""
		window:RegisterTheme(checkSquare, "TextColor3", "Accent")
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
		window:RegisterTheme(card, "BackgroundColor3", "Card")
		AddUICorner(card, 6)
		local strokeCard = AddUIStroke(card, window.Colors.Border, 1)
		window:RegisterTheme(strokeCard, "Color", "Border")

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -55, 0, 16)
		label.Position = UDim2.new(0, 10, 0, 6)
		label.BackgroundTransparency = 1
		label.Text = options.Text or "Slider"
		window:RegisterTheme(label, "TextColor3", "TextMain")
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local valLabel = Instance.new("TextLabel", card)
		valLabel.Size = UDim2.new(0, 40, 0, 16)
		valLabel.Position = UDim2.new(1, -48, 0, 6)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(default)
		window:RegisterTheme(valLabel, "TextColor3", "TextSub")
		valLabel.TextSize = 10
		window:BindFont(valLabel, "Main")

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -20, 0, 5)
		sliderBar.Position = UDim2.new(0, 10, 0, 31)
		window:RegisterTheme(sliderBar, "BackgroundColor3", "Background")
		AddUICorner(sliderBar, 2)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		window:RegisterTheme(sliderFill, "BackgroundColor3", "Accent")
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
		window:RegisterTheme(card, "BackgroundColor3", "Card")
		AddUICorner(card, 6)
		local strokeCard = AddUIStroke(card, window.Colors.Border, 1)
		window:RegisterTheme(strokeCard, "Color", "Border")

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -30, 0, 36)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = (options.Text or "Dropdown") .. ": " .. tostring(currentChoice)
		window:RegisterTheme(label, "TextColor3", "TextMain")
		label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local arrow = Instance.new("TextLabel", card)
		arrow.Size = UDim2.new(0, 24, 0, 36)
		arrow.Position = UDim2.new(1, -26, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "›"
		window:RegisterTheme(arrow, "TextColor3", "TextSub")
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
			window:RegisterTheme(btn, "TextColor3", (v == currentChoice) and "Accent" or "TextSub")
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
		headerBtn.Text = "haha"
		headerBtn.MouseButton1Click:Connect(ToggleDrop)
	end

	return TabObj
end

return PitayaUI
