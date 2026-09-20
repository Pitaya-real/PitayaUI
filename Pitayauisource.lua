local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- =================================================================
-- BẢNG THEMES & FONTS
-- =================================================================
PitayaUI.Themes = {
	PitayaUI = {
		Background = Color3.fromRGB(18, 18, 24),
		Window = Color3.fromRGB(24, 26, 36),
		CardBackground = Color3.fromRGB(240, 242, 248),
		CardDark = Color3.fromRGB(32, 34, 46),
		Border = Color3.fromRGB(255, 42, 117),
		TextMain = Color3.fromRGB(20, 20, 30),
		TextDark = Color3.fromRGB(245, 245, 255),
		TextSub = Color3.fromRGB(120, 125, 140),
		Accent = Color3.fromRGB(255, 42, 117),         -- Pitaya Pink
		AccentSecondary = Color3.fromRGB(64, 224, 208),-- Pitaya Cyan
		SidebarUnselected = Color3.fromRGB(240, 240, 245),
		SidebarSelected = Color3.fromRGB(255, 42, 117)
	},
	Dark = {
		Background = Color3.fromRGB(15, 15, 18),
		Window = Color3.fromRGB(22, 22, 28),
		CardBackground = Color3.fromRGB(32, 32, 40),
		CardDark = Color3.fromRGB(28, 28, 35),
		Border = Color3.fromRGB(60, 60, 75),
		TextMain = Color3.fromRGB(240, 240, 240),
		TextDark = Color3.fromRGB(240, 240, 240),
		TextSub = Color3.fromRGB(150, 150, 165),
		Accent = Color3.fromRGB(0, 200, 255),
		AccentSecondary = Color3.fromRGB(255, 42, 117),
		SidebarUnselected = Color3.fromRGB(30, 30, 38),
		SidebarSelected = Color3.fromRGB(0, 200, 255)
	}
}

PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium },
	FredokaOne = { Main = Enum.Font.FredokaOne, Bold = Enum.Font.FredokaOne, Medium = Enum.Font.FredokaOne },
	BuilderSans = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Medium = Enum.Font.BuilderSansMedium }
}

local function AddUICorner(parent, radius)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function AddUIStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

-- =================================================================
-- QUẢN LÝ THEME & FONT
-- =================================================================
function PitayaUI:BindTheme(instance, property, role)
	table.insert(self.ThemeObjects, { Instance = instance, Property = property, Role = role })
	if self.Colors[role] then
		instance[property] = self.Colors[role]
	end
	return instance
end

function PitayaUI:SetTheme(themeName)
	local targetTheme = PitayaUI.Themes[themeName]
	if not targetTheme then return end
	self.CurrentThemeName = themeName
	for k, v in pairs(targetTheme) do self.Colors[k] = v end

	for _, item in ipairs(self.ThemeObjects) do
		if item.Instance and item.Instance.Parent and self.Colors[item.Role] then
			TweenService:Create(item.Instance, TweenInfo.new(0.3), { [item.Property] = self.Colors[item.Role] }):Play()
		end
	end
end

function PitayaUI:GetThemes()
	local list = {}
	for name, _ in pairs(PitayaUI.Themes) do table.insert(list, name) end
	table.sort(list)
	return list
end

function PitayaUI:BindFont(instance, fontRole)
	table.insert(self.FontObjects, { Instance = instance, Role = fontRole or "Main" })
	if self.Fonts[fontRole] then instance.Font = self.Fonts[fontRole] end
	return instance
end

function PitayaUI:SetFont(fontName)
	local targetPreset = PitayaUI.FontPresets[fontName]
	if not targetPreset then return end
	self.CurrentFontName = fontName
	self.Fonts = targetPreset
	for _, item in ipairs(self.FontObjects) do
		if item.Instance and item.Instance.Parent and self.Fonts[item.Role] then
			item.Instance.Font = self.Fonts[item.Role]
		end
	end
end

function PitayaUI:GetFonts()
	local list = {}
	for name, _ in pairs(PitayaUI.FontPresets) do table.insert(list, name) end
	table.sort(list)
	return list
end

-- =================================================================
-- TẠO CỬA SỔ CHÍNH (CREATE WINDOW)
-- =================================================================
function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "SCRIPT MASTER HUB - PITAYA EDITION v3.5"
	WindowObj.LogoId = config.Logo or "rbxassetid://115347218827913"
	WindowObj.Tabs = {}
	WindowObj.ThemeObjects = {}
	WindowObj.FontObjects = {}

	local selectedTheme = config.Theme or "PitayaUI"
	local baseTheme = PitayaUI.Themes[selectedTheme] or PitayaUI.Themes.PitayaUI
	WindowObj.Colors = {}
	for k, v in pairs(baseTheme) do WindowObj.Colors[k] = v end
	WindowObj.CurrentThemeName = selectedTheme

	local selectedFont = config.Font or "Gotham"
	WindowObj.Fonts = PitayaUI.FontPresets[selectedFont] or PitayaUI.FontPresets.Gotham
	WindowObj.CurrentFontName = selectedFont

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "PitayaUI_Executor"
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game:GetService("CoreGui")
	else
		pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
		if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	end
	WindowObj.ScreenGui = ScreenGui

	-- Kích thước Window
	local targetWidth, targetHeight = 650, 380
	WindowObj.SavedWidth = targetWidth
	WindowObj.SavedHeight = targetHeight

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

	-- Floating Buttons (Góc phải)
	local FloatContainer = Instance.new("Frame", ScreenGui)
	FloatContainer.Name = "FloatingControls"
	FloatContainer.Size = UDim2.new(0, 70, 0, 100)
	FloatContainer.Position = UDim2.new(1, -80, 0.4, 0)
	FloatContainer.BackgroundTransparency = 1

	local FloatList = Instance.new("UIListLayout", FloatContainer)
	FloatList.Padding = UDim.new(0, 8)
	FloatList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local HideBtn = Instance.new("TextButton", FloatContainer)
	HideBtn.Size = UDim2.new(0, 65, 0, 40)
	HideBtn.BackgroundColor3 = WindowObj.Colors.Window
	HideBtn.Text = "👁️\nHIDDEN"
	HideBtn.TextColor3 = WindowObj.Colors.TextDark
	HideBtn.TextSize = 10
	AddUICorner(HideBtn, 8)
	AddUIStroke(HideBtn, WindowObj.Colors.Border, 1)

	local MinBtn = Instance.new("TextButton", FloatContainer)
	MinBtn.Size = UDim2.new(0, 65, 0, 40)
	MinBtn.BackgroundColor3 = WindowObj.Colors.Window
	MinBtn.Text = "🗂️\nMINIMIZE"
	MinBtn.TextColor3 = WindowObj.Colors.TextDark
	MinBtn.TextSize = 10
	AddUICorner(MinBtn, 8)
	AddUIStroke(MinBtn, WindowObj.Colors.Border, 1)

	-- MAIN FRAME
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, targetWidth, 0, targetHeight)
	MainFrame.Position = UDim2.new(0.5, -targetWidth/2, 0.45, -targetHeight/2)
	MainFrame.BackgroundColor3 = WindowObj.Colors.Window
	MainFrame.BackgroundTransparency = 0.15
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = false
	AddUICorner(MainFrame, 12)
	
	AddUIStroke(MainFrame, WindowObj.Colors.AccentSecondary, 2)
	WindowObj:BindTheme(MainFrame, "BackgroundColor3", "Window")
	WindowObj.MainFrame = MainFrame

	local isOpen = true
	local function ToggleUI()
		isOpen = not isOpen
		MainFrame.Visible = isOpen
	end
	HideBtn.MouseButton1Click:Connect(ToggleUI)
	MinBtn.MouseButton1Click:Connect(ToggleUI)

	-- TOPBAR
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 42)
	Topbar.BackgroundTransparency = 1

	local LogoImg = Instance.new("ImageLabel", Topbar)
	LogoImg.Size = UDim2.new(0, 26, 0, 26)
	LogoImg.Position = UDim2.new(0, 12, 0, 8)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = WindowObj.LogoId

	local TitleLbl = Instance.new("TextLabel", Topbar)
	TitleLbl.Size = UDim2.new(1, -120, 1, 0)
	TitleLbl.Position = UDim2.new(0, 45, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = WindowObj.TitleText
	TitleLbl.TextColor3 = WindowObj.Colors.TextDark
	TitleLbl.TextSize = 13
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(TitleLbl, "Bold")

	-- Topbar Controls
	local WindowControls = Instance.new("Frame", Topbar)
	WindowControls.Size = UDim2.new(0, 60, 1, 0)
	WindowControls.Position = UDim2.new(1, -65, 0, 0)
	WindowControls.BackgroundTransparency = 1

	local CloseBtn = Instance.new("TextButton", WindowControls)
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(1, -28, 0, 9)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
	CloseBtn.TextSize = 14
	CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

	local MinimizeBtnHeader = Instance.new("TextButton", WindowControls)
	MinimizeBtnHeader.Size = UDim2.new(0, 24, 0, 24)
	MinimizeBtnHeader.Position = UDim2.new(1, -54, 0, 9)
	MinimizeBtnHeader.BackgroundTransparency = 1
	MinimizeBtnHeader.Text = "─"
	MinimizeBtnHeader.TextColor3 = WindowObj.Colors.TextSub
	MinimizeBtnHeader.TextSize = 14
	MinimizeBtnHeader.MouseButton1Click:Connect(ToggleUI)

	-- TAB BAR NGANG
	local TabBarFrame = Instance.new("Frame", MainFrame)
	TabBarFrame.Name = "TabBarFrame"
	TabBarFrame.Size = UDim2.new(1, -24, 0, 36)
	TabBarFrame.Position = UDim2.new(0, 12, 0, 42)
	TabBarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	AddUICorner(TabBarFrame, 8)

	local TabScroll = Instance.new("ScrollingFrame", TabBarFrame)
	TabScroll.Size = UDim2.new(1, -10, 1, 0)
	TabScroll.Position = UDim2.new(0, 5, 0, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local TabListLayout = Instance.new("UIListLayout", TabScroll)
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TabListLayout.Padding = UDim.new(0, 6)

	-- CONTENT AREA (Mở rộng toàn bộ chiều cao còn lại)
	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -24, 1, -90)
	ContentArea.Position = UDim2.new(0, 12, 0, 84)
	ContentArea.BackgroundTransparency = 1
	WindowObj.ContentArea = ContentArea
	WindowObj.TabScroll = TabScroll

	-- FOOTER STATUS BAR
	local FooterFrame = Instance.new("Frame", ScreenGui)
	FooterFrame.Name = "FooterStatusBar"
	FooterFrame.Size = UDim2.new(0, 400, 0, 22)
	FooterFrame.Position = UDim2.new(0, 15, 1, -30)
	FooterFrame.BackgroundTransparency = 1

	local FooterLbl = Instance.new("TextLabel", FooterFrame)
	FooterLbl.Size = UDim2.new(1, 0, 1, 0)
	FooterLbl.BackgroundTransparency = 1
	FooterLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
	FooterLbl.TextSize = 11
	FooterLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(FooterLbl, "Bold")

	task.spawn(function()
		while task.wait(1) do
			if ScreenGui.Parent then
				local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				FooterLbl.Text = string.format("USERNAME: %s  |  SERVER: VIETNAM  |  PING: %dms", LocalPlayer.Name, ping)
			end
		end
	end)

	function WindowObj:Log() end -- Hàm rỗng để đảm bảo tương thích không gây lỗi

	return WindowObj
end

-- =================================================================
-- THÔNG BÁO (NOTIFICATION)
-- =================================================================
function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 50)
	notifFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
	AddUICorner(notifFrame, 8)
	AddUIStroke(notifFrame, self.Colors.Accent, 1)

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -16, 0, 18)
	titleLbl.Position = UDim2.new(0, 10, 0, 6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.Accent
	titleLbl.TextSize = 12
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -16, 0, 20)
	descLbl.Position = UDim2.new(0, 10, 0, 24)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
	descLbl.TextSize = 11
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(descLbl, "Main")

	task.delay(duration, function()
		if notifFrame then notifFrame:Destroy() end
	end)
end

-- =================================================================
-- TẠO TAB & COMPONENTS
-- =================================================================
function PitayaUI:CreateTab(tabName, iconSymbol)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.Visible = false

	local PageGrid = Instance.new("UIGridLayout", page)
	PageGrid.CellSize = UDim2.new(0.485, 0, 0, 52)
	PageGrid.CellPadding = UDim2.new(0.02, 0, 0, 8)
	PageGrid.SortOrder = Enum.SortOrder.LayoutOrder

	local tabBtn = Instance.new("TextButton", window.TabScroll)
	tabBtn.Size = UDim2.new(0, 95, 1, -8)
	tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	tabBtn.Text = (iconSymbol or "") .. " " .. tabName:upper()
	tabBtn.TextColor3 = window.Colors.TextSub
	tabBtn.TextSize = 11
	AddUICorner(tabBtn, 6)
	window:BindFont(tabBtn, "Bold")

	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			t.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
			t.Button.TextColor3 = window.Colors.TextSub
		end
		page.Visible = true
		tabBtn.BackgroundColor3 = window.Colors.Accent
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	table.insert(window.Tabs, TabObj)

	window.TabScroll.CanvasSize = UDim2.new(0, #window.Tabs * 102, 0, 0)

	if #window.Tabs == 1 then ActivateTab() end

	-- -------------------------------------------------------------
	-- SLIDER COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddSlider(options)
		options = options or {}
		local sliderText = options.Text or "SLIDER"
		local min = options.Min or 0
		local max = options.Max or 100
		local default = options.Default or min
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.6, 0, 0, 20)
		titleLbl.Position = UDim2.new(0, 10, 0, 4)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = sliderText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 11
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local valLbl = Instance.new("TextLabel", card)
		valLbl.Size = UDim2.new(0.3, 0, 0, 20)
		valLbl.Position = UDim2.new(0.4, 0, 0, 4)
		valLbl.BackgroundTransparency = 1
		valLbl.Text = "VAL: " .. tostring(default)
		valLbl.TextColor3 = window.Colors.TextMain
		valLbl.TextSize = 10
		window:BindFont(valLbl, "Bold")

		local resetBtn = Instance.new("TextButton", card)
		resetBtn.Size = UDim2.new(0, 45, 0, 18)
		resetBtn.Position = UDim2.new(1, -50, 0, 4)
		resetBtn.BackgroundColor3 = window.Colors.Accent
		resetBtn.Text = "RESET"
		resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		resetBtn.TextSize = 9
		AddUICorner(resetBtn, 4)

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -20, 0, 6)
		sliderBar.Position = UDim2.new(0, 10, 0, 32)
		sliderBar.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
		AddUICorner(sliderBar, 3)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.AccentSecondary
		AddUICorner(sliderFill, 3)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLbl.Text = "VAL: " .. tostring(value)
			sliderFill.Size = UDim2.new(pos, 0, 1, 0)
			callback(value)
		end

		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				UpdateSlider(input)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				UpdateSlider(input)
			end
		end)

		resetBtn.MouseButton1Click:Connect(function()
			valLbl.Text = "VAL: " .. tostring(default)
			sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			callback(default)
		end)
	end

	-- -------------------------------------------------------------
	-- TOGGLE COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "TOGGLE"
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.65, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 10, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = toggleText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 11
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local switchBtn = Instance.new("TextButton", card)
		switchBtn.Size = UDim2.new(0, 42, 0, 22)
		switchBtn.Position = UDim2.new(1, -48, 0.5, -11)
		switchBtn.BackgroundColor3 = defaultState and window.Colors.Accent or Color3.fromRGB(160, 160, 175)
		switchBtn.Text = ""
		AddUICorner(switchBtn, 11)

		local dot = Instance.new("Frame", switchBtn)
		dot.Size = UDim2.new(0, 16, 0, 16)
		dot.Position = UDim2.new(0, defaultState and 22 or 3, 0, 3)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		AddUICorner(dot, 8)

		local state = defaultState
		switchBtn.MouseButton1Click:Connect(function()
			state = not state
			TweenService:Create(switchBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = state and window.Colors.Accent or Color3.fromRGB(160, 160, 175)
			}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2), {
				Position = UDim2.new(0, state and 22 or 3, 0, 3)
			}):Play()
			callback(state)
		end)
	end

	-- -------------------------------------------------------------
	-- DROPDOWN COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "DROPDOWN:"
		local items = options.Items or {"OPTION 1", "OPTION 2"}
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(1, -10, 0, 16)
		titleLbl.Position = UDim2.new(0, 10, 0, 4)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = dropText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local selectedItem = items[1] or ""
		local dropBtn = Instance.new("TextButton", card)
		dropBtn.Size = UDim2.new(0.65, -10, 0, 24)
		dropBtn.Position = UDim2.new(0, 10, 0, 22)
		dropBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
		dropBtn.Text = selectedItem
		dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		dropBtn.TextSize = 10
		AddUICorner(dropBtn, 4)

		local actionBtn = Instance.new("TextButton", card)
		actionBtn.Size = UDim2.new(0.3, -5, 0, 24)
		actionBtn.Position = UDim2.new(0.65, 5, 0, 22)
		actionBtn.BackgroundColor3 = window.Colors.AccentSecondary
		actionBtn.Text = "GO"
		actionBtn.TextColor3 = Color3.fromRGB(20, 20, 30)
		actionBtn.TextSize = 11
		AddUICorner(actionBtn, 4)
		window:BindFont(actionBtn, "Bold")

		local idx = 1
		dropBtn.MouseButton1Click:Connect(function()
			idx = idx % #items + 1
			selectedItem = items[idx]
			dropBtn.Text = selectedItem
		end)

		actionBtn.MouseButton1Click:Connect(function()
			callback(selectedItem)
		end)
	end

	-- -------------------------------------------------------------
	-- BUTTON COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddButton(options)
		options = options or {}
		local btnText = options.Text or "BUTTON"
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)

		local btn = Instance.new("TextButton", card)
		btn.Size = UDim2.new(1, -12, 1, -12)
		btn.Position = UDim2.new(0, 6, 0, 6)
		btn.BackgroundColor3 = window.Colors.Accent
		btn.Text = btnText:upper()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 11
		AddUICorner(btn, 6)
		window:BindFont(btn, "Bold")

		btn.MouseButton1Click:Connect(function()
			callback()
		end)
	end

	return TabObj
end

return PitayaUI
