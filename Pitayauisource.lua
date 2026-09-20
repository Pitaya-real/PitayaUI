local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- =================================================================
-- THEMES PITAYA DARK MODERN
-- =================================================================
PitayaUI.Themes = {
	PitayaUI = {
		Background = Color3.fromRGB(16, 17, 23),
		Window = Color3.fromRGB(22, 24, 34),
		CardBackground = Color3.fromRGB(28, 30, 42),
		CardDark = Color3.fromRGB(20, 22, 30),
		Border = Color3.fromRGB(255, 42, 117),
		TextMain = Color3.fromRGB(240, 242, 250),
		TextSub = Color3.fromRGB(140, 145, 165),
		Accent = Color3.fromRGB(255, 42, 117),         -- Pitaya Pink
		AccentSecondary = Color3.fromRGB(0, 230, 200), -- Pitaya Teal
		TabUnselected = Color3.fromRGB(30, 32, 44),
		TabSelected = Color3.fromRGB(255, 42, 117)
	},
	Dark = {
		Background = Color3.fromRGB(12, 12, 16),
		Window = Color3.fromRGB(18, 18, 24),
		CardBackground = Color3.fromRGB(25, 26, 36),
		CardDark = Color3.fromRGB(18, 20, 28),
		Border = Color3.fromRGB(50, 52, 70),
		TextMain = Color3.fromRGB(245, 245, 245),
		TextSub = Color3.fromRGB(130, 130, 145),
		Accent = Color3.fromRGB(0, 190, 255),
		AccentSecondary = Color3.fromRGB(255, 42, 117),
		TabUnselected = Color3.fromRGB(25, 26, 36),
		TabSelected = Color3.fromRGB(0, 190, 255)
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
-- HÀM KÉO THẢ DỄ DÀNG (DRAGGABLE HELPER)
-- =================================================================
local function MakeDraggable(guiObject, dragHandle)
	dragHandle = dragHandle or guiObject
	local dragging, dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			TweenService:Create(guiObject, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
end

-- =================================================================
-- QUẢN LÝ THEME & FONT
-- =================================================================
function PitayaUI:BindTheme(instance, property, role)
	table.insert(self.ThemeObjects, { Instance = instance, Property = property, Role = role })
	if self.Colors[role] then instance[property] = self.Colors[role] end
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
	WindowObj.TitleText = config.Title or "PITAYA HUB"
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
	ScreenGui.Name = "PitayaUI_Engine"
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game:GetService("CoreGui")
	else
		pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
		if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	end
	WindowObj.ScreenGui = ScreenGui

	-- TỰ ĐỘNG CĂN CHỈNH KÍCH THƯỚC THEO THIẾT BỊ (AUTO RESPONSIVE)
	local vpSize = Camera.ViewportSize
	local targetWidth = math.clamp(vpSize.X * 0.78, 380, 580)
	local targetHeight = math.clamp(vpSize.Y * 0.72, 260, 360)
	
	WindowObj.CurrentWidth = targetWidth
	WindowObj.CurrentHeight = targetHeight

	-- NOTIFICATION CONTAINER
	local NotifContainer = Instance.new("Frame", ScreenGui)
	NotifContainer.Name = "NotifContainer"
	NotifContainer.Size = UDim2.new(0, 240, 1, -40)
	NotifContainer.Position = UDim2.new(1, -250, 0, 20)
	NotifContainer.BackgroundTransparency = 1
	WindowObj.NotifContainer = NotifContainer

	local NotifList = Instance.new("UIListLayout", NotifContainer)
	NotifList.SortOrder = Enum.SortOrder.LayoutOrder
	NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifList.Padding = UDim.new(0, 8)

	-- -------------------------------------------------------------
	-- NÚT NỔI TRÒN CÓ THỂ KÉO THẢ (FLOATING TOGGLE BUTTON)
	-- -------------------------------------------------------------
	local FloatBtnFrame = Instance.new("Frame", ScreenGui)
	FloatBtnFrame.Name = "FloatingToggle"
	FloatBtnFrame.Size = UDim2.new(0, 48, 0, 48)
	FloatBtnFrame.Position = UDim2.new(0, 15, 0.35, 0)
	FloatBtnFrame.BackgroundColor3 = WindowObj.Colors.Window
	AddUICorner(FloatBtnFrame, 24)
	local floatStroke = AddUIStroke(FloatBtnFrame, WindowObj.Colors.Accent, 2)

	local FloatBtnIcon = Instance.new("ImageButton", FloatBtnFrame)
	FloatBtnIcon.Size = UDim2.new(1, -12, 1, -12)
	FloatBtnIcon.Position = UDim2.new(0, 6, 0, 6)
	FloatBtnIcon.BackgroundTransparency = 1
	FloatBtnIcon.Image = WindowObj.LogoId

	MakeDraggable(FloatBtnFrame)

	-- MAIN FRAME (CỬA SỔ CHÍNH)
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, targetWidth, 0, targetHeight)
	MainFrame.Position = UDim2.new(0.5, -targetWidth/2, 0.5, -targetHeight/2)
	MainFrame.BackgroundColor3 = WindowObj.Colors.Window
	MainFrame.BackgroundTransparency = 0.05
	MainFrame.ClipsDescendants = false
	AddUICorner(MainFrame, 12)
	AddUIStroke(MainFrame, WindowObj.Colors.Accent, 1.5)
	WindowObj:BindTheme(MainFrame, "BackgroundColor3", "Window")
	WindowObj.MainFrame = MainFrame

	-- TẠO THANH TIÊU ĐỀ
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 38)
	Topbar.BackgroundTransparency = 1

	MakeDraggable(MainFrame, Topbar)

	local LogoImg = Instance.new("ImageLabel", Topbar)
	LogoImg.Size = UDim2.new(0, 22, 0, 22)
	LogoImg.Position = UDim2.new(0, 12, 0, 8)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = WindowObj.LogoId

	local TitleLbl = Instance.new("TextLabel", Topbar)
	TitleLbl.Size = UDim2.new(1, -90, 1, 0)
	TitleLbl.Position = UDim2.new(0, 40, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = WindowObj.TitleText
	TitleLbl.TextColor3 = WindowObj.Colors.TextMain
	TitleLbl.TextSize = 12
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(TitleLbl, "Bold")

	local CloseBtn = Instance.new("TextButton", Topbar)
	CloseBtn.Size = UDim2.new(0, 28, 0, 28)
	CloseBtn.Position = UDim2.new(1, -34, 0, 5)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
	CloseBtn.TextSize = 14
	WindowObj:BindFont(CloseBtn, "Bold")

	-- ĐÓNG / MỞ UI VỚI ANIMATION
	local isOpen = true
	local function ToggleUI()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			MainFrame.Size = UDim2.new(0, WindowObj.CurrentWidth * 0.8, 0, WindowObj.CurrentHeight * 0.8)
			MainFrame.BackgroundTransparency = 1
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.CurrentWidth, 0, WindowObj.CurrentHeight),
				BackgroundTransparency = 0.05
			}):Play()
		else
			local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, WindowObj.CurrentWidth * 0.8, 0, WindowObj.CurrentHeight * 0.8),
				BackgroundTransparency = 1
			})
			tween:Play()
			tween.Completed:Connect(function()
				if not isOpen then MainFrame.Visible = false end
			end)
		end
	end

	FloatBtnIcon.MouseButton1Click:Connect(ToggleUI)
	CloseBtn.MouseButton1Click:Connect(ToggleUI)

	-- -------------------------------------------------------------
	-- THANH TAB NGANG
	-- -------------------------------------------------------------
	local TabBarFrame = Instance.new("Frame", MainFrame)
	TabBarFrame.Name = "TabBarFrame"
	TabBarFrame.Size = UDim2.new(1, -20, 0, 32)
	TabBarFrame.Position = UDim2.new(0, 10, 0, 38)
	TabBarFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
	AddUICorner(TabBarFrame, 8)

	local TabScroll = Instance.new("ScrollingFrame", TabBarFrame)
	TabScroll.Size = UDim2.new(1, -8, 1, 0)
	TabScroll.Position = UDim2.new(0, 4, 0, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local TabListLayout = Instance.new("UIListLayout", TabScroll)
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TabListLayout.Padding = UDim.new(0, 6)

	-- -------------------------------------------------------------
	-- NỘI DUNG VÙNG TRONG (CONTENT AREA)
	-- -------------------------------------------------------------
	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -20, 1, -95)
	ContentArea.Position = UDim2.new(0, 10, 0, 74)
	ContentArea.BackgroundTransparency = 1
	WindowObj.ContentArea = ContentArea
	WindowObj.TabScroll = TabScroll

	-- -------------------------------------------------------------
	-- NÚT KÉO ĐIỀU CHỈNH KÍCH THƯỚC (RESIZE GRIP CORNER)
	-- -------------------------------------------------------------
	local ResizeGrip = Instance.new("TextButton", MainFrame)
	ResizeGrip.Name = "ResizeGrip"
	ResizeGrip.Size = UDim2.new(0, 16, 0, 16)
	ResizeGrip.Position = UDim2.new(1, -16, 1, -16)
	ResizeGrip.BackgroundTransparency = 1
	ResizeGrip.Text = "◢"
	ResizeGrip.TextColor3 = WindowObj.Colors.Accent
	ResizeGrip.TextSize = 12

	local resizing = false
	local resizeStart, startSize

	ResizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStart
			local newW = math.clamp(startSize.X + delta.X, 360, vpSize.X - 20)
			local newH = math.clamp(startSize.Y + delta.Y, 240, vpSize.Y - 20)

			WindowObj.CurrentWidth = newW
			WindowObj.CurrentHeight = newH
			MainFrame.Size = UDim2.new(0, newW, 0, newH)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	-- FOOTER STATUS BAR
	local FooterLbl = Instance.new("TextLabel", MainFrame)
	FooterLbl.Size = UDim2.new(1, -30, 0, 16)
	FooterLbl.Position = UDim2.new(0, 10, 1, -18)
	FooterLbl.BackgroundTransparency = 1
	FooterLbl.TextColor3 = WindowObj.Colors.TextSub
	FooterLbl.TextSize = 10
	FooterLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(FooterLbl, "Main")

	task.spawn(function()
		while task.wait(1) do
			if ScreenGui.Parent then
				local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				FooterLbl.Text = string.format("User: %s  |  Server: VN  |  Ping: %dms", LocalPlayer.Name, ping)
			end
		end
	end)

	function WindowObj:Log() end

	return WindowObj
end

-- =================================================================
-- THÔNG BÁO (NOTIFICATION WITH ANIMATION)
-- =================================================================
function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 46)
	notifFrame.BackgroundColor3 = self.Colors.CardDark
	notifFrame.BackgroundTransparency = 1
	AddUICorner(notifFrame, 8)
	AddUIStroke(notifFrame, self.Colors.Accent, 1)

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -16, 0, 16)
	titleLbl.Position = UDim2.new(0, 10, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.Accent
	titleLbl.TextSize = 11
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -16, 0, 18)
	descLbl.Position = UDim2.new(0, 10, 0, 22)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = self.Colors.TextMain
	descLbl.TextSize = 10
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(descLbl, "Main")

	-- Animate In
	TweenService:Create(notifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.1
	}):Play()

	task.delay(duration, function()
		if notifFrame then
			local tw = TweenService:Create(notifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				BackgroundTransparency = 1
			})
			tw:Play()
			tw.Completed:Connect(function() notifFrame:Destroy() end)
		end
	end)
end

-- =================================================================
-- TẠO TAB & COMPONENTS (CẢI TIẾN THẺ VÀ ANIMATION)
-- =================================================================
function PitayaUI:CreateTab(tabName, iconSymbol)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = window.Colors.Accent
	page.Visible = false

	local PageGrid = Instance.new("UIGridLayout", page)
	PageGrid.CellSize = UDim2.new(0.485, 0, 0, 52)
	PageGrid.CellPadding = UDim2.new(0.02, 0, 0, 8)
	PageGrid.SortOrder = Enum.SortOrder.LayoutOrder

	local tabBtn = Instance.new("TextButton", window.TabScroll)
	tabBtn.Size = UDim2.new(0, 90, 1, -4)
	tabBtn.BackgroundColor3 = window.Colors.TabUnselected
	tabBtn.Text = (iconSymbol or "") .. " " .. tabName:upper()
	tabBtn.TextColor3 = window.Colors.TextSub
	tabBtn.TextSize = 10
	AddUICorner(tabBtn, 6)
	window:BindFont(tabBtn, "Bold")

	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			TweenService:Create(t.Button, TweenInfo.new(0.2), {
				BackgroundColor3 = window.Colors.TabUnselected,
				TextColor3 = window.Colors.TextSub
			}):Play()
		end

		page.Visible = true
		page.Position = UDim2.new(0, 0, 0, 6)
		TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()

		TweenService:Create(tabBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = window.Colors.Accent,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	table.insert(window.Tabs, TabObj)

	window.TabScroll.CanvasSize = UDim2.new(0, #window.Tabs * 96, 0, 0)

	if #window.Tabs == 1 then ActivateTab() end

	-- -------------------------------------------------------------
	-- SLIDER COMPONENT (MÀU TỐI SANG TRỌNG + ANIMATION)
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
		AddUIStroke(card, Color3.fromRGB(40, 44, 60), 1)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.5, 0, 0, 18)
		titleLbl.Position = UDim2.new(0, 10, 0, 5)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = sliderText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local valLbl = Instance.new("TextLabel", card)
		valLbl.Size = UDim2.new(0.25, 0, 0, 18)
		valLbl.Position = UDim2.new(0.48, 0, 0, 5)
		valLbl.BackgroundTransparency = 1
		valLbl.Text = "VAL: " .. tostring(default)
		valLbl.TextColor3 = window.Colors.AccentSecondary
		valLbl.TextSize = 10
		window:BindFont(valLbl, "Bold")

		local resetBtn = Instance.new("TextButton", card)
		resetBtn.Size = UDim2.new(0, 42, 0, 16)
		resetBtn.Position = UDim2.new(1, -48, 0, 5)
		resetBtn.BackgroundColor3 = window.Colors.CardDark
		resetBtn.Text = "RESET"
		resetBtn.TextColor3 = window.Colors.TextSub
		resetBtn.TextSize = 8
		AddUICorner(resetBtn, 4)
		AddUIStroke(resetBtn, window.Colors.Accent, 1)

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -20, 0, 6)
		sliderBar.Position = UDim2.new(0, 10, 0, 32)
		sliderBar.BackgroundColor3 = window.Colors.CardDark
		AddUICorner(sliderBar, 3)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.Accent
		AddUICorner(sliderFill, 3)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLbl.Text = "VAL: " .. tostring(value)
			
			TweenService:Create(sliderFill, TweenInfo.new(0.05), {
				Size = UDim2.new(pos, 0, 1, 0)
			}):Play()

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
			TweenService:Create(sliderFill, TweenInfo.new(0.2), {
				Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			}):Play()
			callback(default)
		end)
	end

	-- -------------------------------------------------------------
	-- TOGGLE COMPONENT (CÔNG TẮC BẬT TẮT)
	-- -------------------------------------------------------------
	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "TOGGLE"
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)
		AddUIStroke(card, Color3.fromRGB(40, 44, 60), 1)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.65, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 10, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = toggleText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local switchBtn = Instance.new("TextButton", card)
		switchBtn.Size = UDim2.new(0, 40, 0, 20)
		switchBtn.Position = UDim2.new(1, -46, 0.5, -10)
		switchBtn.BackgroundColor3 = defaultState and window.Colors.Accent or window.Colors.CardDark
		switchBtn.Text = ""
		AddUICorner(switchBtn, 10)

		local dot = Instance.new("Frame", switchBtn)
		dot.Size = UDim2.new(0, 14, 0, 14)
		dot.Position = UDim2.new(0, defaultState and 23 or 3, 0, 3)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		AddUICorner(dot, 7)

		local state = defaultState
		switchBtn.MouseButton1Click:Connect(function()
			state = not state
			TweenService:Create(switchBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = state and window.Colors.Accent or window.Colors.CardDark
			}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, state and 23 or 3, 0, 3)
			}):Play()
			callback(state)
		end)
	end

	-- -------------------------------------------------------------
	-- DROPDOWN COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "DROPDOWN"
		local items = options.Items or {"OPTION 1", "OPTION 2"}
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)
		AddUIStroke(card, Color3.fromRGB(40, 44, 60), 1)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(1, -10, 0, 16)
		titleLbl.Position = UDim2.new(0, 10, 0, 4)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = dropText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 9
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local selectedItem = items[1] or ""
		local dropBtn = Instance.new("TextButton", card)
		dropBtn.Size = UDim2.new(0.65, -10, 0, 22)
		dropBtn.Position = UDim2.new(0, 10, 0, 22)
		dropBtn.BackgroundColor3 = window.Colors.CardDark
		dropBtn.Text = selectedItem
		dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		dropBtn.TextSize = 9
		AddUICorner(dropBtn, 4)

		local actionBtn = Instance.new("TextButton", card)
		actionBtn.Size = UDim2.new(0.3, -5, 0, 22)
		actionBtn.Position = UDim2.new(0.65, 5, 0, 22)
		actionBtn.BackgroundColor3 = window.Colors.AccentSecondary
		actionBtn.Text = "GO"
		actionBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
		actionBtn.TextSize = 10
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
	-- BUTTON COMPONENT (HIỆU ỨNG NẢY NHẸ KHI BẤM)
	-- -------------------------------------------------------------
	function TabObj:AddButton(options)
		options = options or {}
		local btnText = options.Text or "BUTTON"
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.BackgroundColor3 = window.Colors.CardBackground
		AddUICorner(card, 8)
		AddUIStroke(card, Color3.fromRGB(40, 44, 60), 1)

		local btn = Instance.new("TextButton", card)
		btn.Size = UDim2.new(1, -12, 1, -12)
		btn.Position = UDim2.new(0, 6, 0, 6)
		btn.BackgroundColor3 = window.Colors.Accent
		btn.Text = btnText:upper()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 10
		AddUICorner(btn, 6)
		window:BindFont(btn, "Bold")

		btn.MouseButton1Click:Connect(function()
			-- Button Press Bounce Effect
			TweenService:Create(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, -18, 1, -18), Position = UDim2.new(0, 9, 0, 9) }):Play()
			task.wait(0.08)
			TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6) }):Play()
			callback()
		end)
	end

	return TabObj
end

return PitayaUI
