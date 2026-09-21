local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- =================================================================
-- BẢNG THEMES SẴN CÓ
-- =================================================================
PitayaUI.Themes = {
	PitayaUI = {
		Background = Color3.fromRGB(18, 10, 16),
		Window = Color3.fromRGB(26, 13, 21),
		Border = Color3.fromRGB(44, 21, 32),
		TextMain = Color3.fromRGB(245, 238, 241),
		TextSub = Color3.fromRGB(166, 127, 143),
		Accent = Color3.fromRGB(232, 20, 111),
		AccentHover = Color3.fromRGB(250, 45, 130),
		SidebarUnselected = Color3.fromRGB(23, 12, 18),
		SidebarHover = Color3.fromRGB(40, 20, 30),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(76, 199, 89)}
	},
	Dark = {
		Background = Color3.fromRGB(18, 18, 18),
		Window = Color3.fromRGB(28, 28, 28),
		Border = Color3.fromRGB(50, 50, 50),
		TextMain = Color3.fromRGB(240, 240, 240),
		TextSub = Color3.fromRGB(160, 160, 160),
		Accent = Color3.fromRGB(80, 140, 240),
		AccentHover = Color3.fromRGB(100, 160, 255),
		SidebarUnselected = Color3.fromRGB(38, 38, 38),
		SidebarHover = Color3.fromRGB(55, 55, 55),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Ocean = {
		Background = Color3.fromRGB(10, 20, 30),
		Window = Color3.fromRGB(16, 30, 45),
		Border = Color3.fromRGB(30, 60, 85),
		TextMain = Color3.fromRGB(240, 248, 255),
		TextSub = Color3.fromRGB(130, 170, 200),
		Accent = Color3.fromRGB(0, 170, 230),
		AccentHover = Color3.fromRGB(30, 190, 255),
		SidebarUnselected = Color3.fromRGB(22, 42, 62),
		SidebarHover = Color3.fromRGB(32, 58, 85),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Emerald = {
		Background = Color3.fromRGB(12, 24, 18),
		Window = Color3.fromRGB(18, 36, 28),
		Border = Color3.fromRGB(35, 70, 52),
		TextMain = Color3.fromRGB(240, 255, 245),
		TextSub = Color3.fromRGB(140, 185, 160),
		Accent = Color3.fromRGB(46, 204, 113),
		AccentHover = Color3.fromRGB(72, 220, 134),
		SidebarUnselected = Color3.fromRGB(26, 50, 38),
		SidebarHover = Color3.fromRGB(38, 72, 55),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Midnight = {
		Background = Color3.fromRGB(8, 8, 14),
		Window = Color3.fromRGB(14, 14, 24),
		Border = Color3.fromRGB(30, 30, 50),
		TextMain = Color3.fromRGB(235, 235, 250),
		TextSub = Color3.fromRGB(130, 130, 160),
		Accent = Color3.fromRGB(110, 90, 240),
		AccentHover = Color3.fromRGB(130, 110, 255),
		SidebarUnselected = Color3.fromRGB(22, 22, 38),
		SidebarHover = Color3.fromRGB(34, 34, 56),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Cyberpunk = {
		Background = Color3.fromRGB(20, 18, 10),
		Window = Color3.fromRGB(28, 25, 14),
		Border = Color3.fromRGB(70, 60, 20),
		TextMain = Color3.fromRGB(255, 255, 240),
		TextSub = Color3.fromRGB(180, 170, 110),
		Accent = Color3.fromRGB(255, 210, 0),
		AccentHover = Color3.fromRGB(255, 225, 50),
		SidebarUnselected = Color3.fromRGB(40, 36, 20),
		SidebarHover = Color3.fromRGB(60, 54, 30),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Blood = {
		Background = Color3.fromRGB(20, 12, 12),
		Window = Color3.fromRGB(30, 18, 18),
		Border = Color3.fromRGB(65, 30, 30),
		TextMain = Color3.fromRGB(255, 240, 240),
		TextSub = Color3.fromRGB(180, 130, 130),
		Accent = Color3.fromRGB(235, 60, 60),
		AccentHover = Color3.fromRGB(255, 85, 85),
		SidebarUnselected = Color3.fromRGB(42, 24, 24),
		SidebarHover = Color3.fromRGB(62, 35, 35),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	}
}

-- =================================================================
-- BẢNG PHÔNG CHỮ SẴN CÓ (FONT PRESETS)
-- =================================================================
PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium },
	Roboto = { Main = Enum.Font.Roboto, Bold = Enum.Font.RobotoCondensed, Medium = Enum.Font.Roboto },
	FredokaOne = { Main = Enum.Font.FredokaOne, Bold = Enum.Font.FredokaOne, Medium = Enum.Font.FredokaOne },
	SourceSans = { Main = Enum.Font.SourceSans, Bold = Enum.Font.SourceSansBold, Medium = Enum.Font.SourceSansSemibold },
	Ubuntu = { Main = Enum.Font.Ubuntu, Bold = Enum.Font.Ubuntu, Medium = Enum.Font.Ubuntu },
	Arcade = { Main = Enum.Font.Arcade, Bold = Enum.Font.Arcade, Medium = Enum.Font.Arcade },
	BuilderSans = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Medium = Enum.Font.BuilderSansMedium }
}

local function AddUICorner(parent, radius)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function AddUIStroke(parent, color)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color
	stroke.Thickness = 1
	return stroke
end

-- =================================================================
-- QUẢN LÝ THEME VÀ FONT CỦA WINDOW
-- =================================================================
function PitayaUI:BindTheme(instance, property, role)
	table.insert(self.ThemeObjects, {
		Instance = instance,
		Property = property,
		Role = role
	})
	if self.Colors[role] then
		instance[property] = self.Colors[role]
	end
	return instance
end

function PitayaUI:SetTheme(themeName)
	local targetTheme = PitayaUI.Themes[themeName]
	if not targetTheme then return end

	self.CurrentThemeName = themeName
	for k, v in pairs(targetTheme) do
		self.Colors[k] = v
	end

	for _, item in ipairs(self.ThemeObjects) do
		if item.Instance and item.Instance.Parent then
			if self.Colors[item.Role] then
				TweenService:Create(item.Instance, TweenInfo.new(0.3), {
					[item.Property] = self.Colors[item.Role]
				}):Play()
			end
		end
	end
end

function PitayaUI:GetThemes()
	local list = {}
	for name, _ in pairs(PitayaUI.Themes) do
		table.insert(list, name)
	end
	table.sort(list)
	return list
end

function PitayaUI:BindFont(instance, fontRole)
	table.insert(self.FontObjects, {
		Instance = instance,
		Role = fontRole or "Main"
	})
	if self.Fonts[fontRole] then
		instance.Font = self.Fonts[fontRole]
	end
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
	for name, _ in pairs(PitayaUI.FontPresets) do
		table.insert(list, name)
	end
	table.sort(list)
	return list
end

-- =================================================================
-- TẠO CỬA SỔ CHÍNH (CREATE WINDOW)
-- =================================================================
function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "Pitaya Hub | Reilo"
	WindowObj.LogoId = config.Logo or "rbxassetid://73866843639743"
	WindowObj.Tabs = {}
	WindowObj.ThemeObjects = {}
	WindowObj.FontObjects = {}

	-- Khởi tạo Theme
	local selectedTheme = config.Theme or "PitayaUI"
	local baseTheme = PitayaUI.Themes[selectedTheme] or PitayaUI.Themes.PitayaUI
	WindowObj.Colors = {}
	for k, v in pairs(baseTheme) do
		WindowObj.Colors[k] = v
	end
	WindowObj.CurrentThemeName = selectedTheme

	-- Khởi tạo Font
	local selectedFont = config.Font or "Gotham"
	WindowObj.Fonts = PitayaUI.FontPresets[selectedFont] or PitayaUI.FontPresets.Gotham
	WindowObj.CurrentFontName = selectedFont

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = game:GetService("HttpService"):GenerateGUID(false)
	ScreenGui.ResetOnSpawn = false

	if gethui then
		ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = game:GetService("CoreGui")
	else
		local success, _ = pcall(function()
			ScreenGui.Parent = game:GetService("CoreGui")
		end)
		if not success then
			local targetGui = (typeof(PlayerGui) ~= "nil" and PlayerGui) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
			ScreenGui.Parent = targetGui
		end	
	end

	WindowObj.ScreenGui = ScreenGui

	-- Kích thước ban đầu dựa theo màn hình thiết bị
	local Camera = Workspace.CurrentCamera
	local viewportSize = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

	local targetWidth = math.floor(math.min(620, viewportSize.X * 0.88))
	local targetHeight = math.floor(math.min(380, viewportSize.Y * 0.85))

	targetWidth = math.clamp(targetWidth, 340, 1200)
	targetHeight = math.clamp(targetHeight, 230, 800)

	WindowObj.SavedWidth = targetWidth
	WindowObj.SavedHeight = targetHeight

	-- Container cho Notifications
	local NotifContainer = Instance.new("Frame", ScreenGui)
	NotifContainer.Name = "NotifContainer"
	NotifContainer.Size = UDim2.new(0, 280, 1, -40)
	NotifContainer.Position = UDim2.new(1, -300, 0, 20)
	NotifContainer.BackgroundTransparency = 1
	WindowObj.NotifContainer = NotifContainer

	local NotifList = Instance.new("UIListLayout", NotifContainer)
	NotifList.SortOrder = Enum.SortOrder.LayoutOrder
	NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifList.Padding = UDim.new(0, 10)

	-- Nút bật/tắt UI
	local ToggleBtn = Instance.new("ImageButton", ScreenGui)
	ToggleBtn.Name = "OpenCloseToggle"
	ToggleBtn.Size = UDim2.new(0, 46, 0, 46)
	ToggleBtn.Position = UDim2.new(0, 25, 0, 100)
	ToggleBtn.BackgroundColor3 = WindowObj.Colors.Window
	ToggleBtn.Image = WindowObj.LogoId
	ToggleBtn.Active = true
	ToggleBtn.Draggable = true
	AddUICorner(ToggleBtn, 23)
	local toggleStroke = AddUIStroke(ToggleBtn, WindowObj.Colors.Accent)

	WindowObj:BindTheme(ToggleBtn, "BackgroundColor3", "Window")
	WindowObj:BindTheme(toggleStroke, "Color", "Accent")

	-- Khung chính UI
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
	MainFrame.Position = UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
	MainFrame.BackgroundColor3 = WindowObj.Colors.Window
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = true
	AddUICorner(MainFrame, 10)
	local mainStroke = AddUIStroke(MainFrame, WindowObj.Colors.Border)

	WindowObj:BindTheme(MainFrame, "BackgroundColor3", "Window")
	WindowObj:BindTheme(mainStroke, "Color", "Border")
	WindowObj.MainFrame = MainFrame

	-- Animation Mở / Đóng Cửa Sổ
	local isOpen = true
	ToggleBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight),
				Position = UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
			}):Play()
		else
			local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
			tween:Play()
			tween.Completed:Connect(function()
				if not isOpen then MainFrame.Visible = false end
			end)
		end
	end)

	-- Header
	local Header = Instance.new("Frame", MainFrame)
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.BackgroundTransparency = 1

	local dotButtons = {}
	for i, color in ipairs(WindowObj.Colors.Dots) do
		local dot = Instance.new("TextButton", Header)
		dot.Size = UDim2.new(0, 10, 0, 10)
		dot.Position = UDim2.new(0, 15 + (i - 1) * 18, 0, 15)
		dot.BackgroundColor3 = color
		dot.Text = ""
		dot.AutoButtonColor = false
		AddUICorner(dot, 5)
		table.insert(dotButtons, dot)
	end

	local RedButton = dotButtons[1]
	local YellowButton = dotButtons[2]

	RedButton.MouseButton1Click:Connect(function()
		if ScreenGui then ScreenGui:Destroy() end
	end)

	local isMinimized = false
	YellowButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		MainFrame.Visible = not isMinimized
	end)

	local TitleLabel = Instance.new("TextLabel", Header)
	TitleLabel.Size = UDim2.new(1, -100, 1, 0)
	TitleLabel.Position = UDim2.new(0, 80, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = WindowObj.TitleText
	TitleLabel.TextColor3 = WindowObj.Colors.TextSub
	TitleLabel.TextSize = 13
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
	WindowObj:BindTheme(TitleLabel, "TextColor3", "TextSub")
	WindowObj:BindFont(TitleLabel, "Bold")
	WindowObj.TitleLabel = TitleLabel

	local HeaderLine = Instance.new("Frame", Header)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.Position = UDim2.new(0, 0, 1, 0)
	HeaderLine.BackgroundColor3 = WindowObj.Colors.Border
	WindowObj:BindTheme(HeaderLine, "BackgroundColor3", "Border")

	-- Sidebar
	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Size = UDim2.new(0, 140, 1, -41)
	Sidebar.Position = UDim2.new(0, 0, 0, 41)
	Sidebar.BackgroundTransparency = 1

	local SidebarLine = Instance.new("Frame", Sidebar)
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Position = UDim2.new(1, 0, 0, 0)
	SidebarLine.BackgroundColor3 = WindowObj.Colors.Border
	WindowObj:BindTheme(SidebarLine, "BackgroundColor3", "Border")

	local SidebarLogo = Instance.new("ImageLabel", Sidebar)
	SidebarLogo.Size = UDim2.new(0, 48, 0, 48)
	SidebarLogo.Position = UDim2.new(0.5, -24, 0, 10)
	SidebarLogo.BackgroundTransparency = 1
	SidebarLogo.Image = WindowObj.LogoId

	local TabListContainer = Instance.new("Frame", Sidebar)
	TabListContainer.Size = UDim2.new(1, -16, 1, -75)
	TabListContainer.Position = UDim2.new(0, 8, 0, 68)
	TabListContainer.BackgroundTransparency = 1

	local UIList = Instance.new("UIListLayout", TabListContainer)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 6)

	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Size = UDim2.new(1, -141, 1, -41)
	ContentArea.Position = UDim2.new(0, 141, 0, 41)
	ContentArea.BackgroundTransparency = 1
	WindowObj.ContentArea = ContentArea
	WindowObj.TabListContainer = TabListContainer

	-- KÉO GIÃN THU PHÓNG (RESIZE & AUTO SAVE SIZE)
	local ResizeHandle = Instance.new("TextButton", MainFrame)
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
	ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Text = "◢"
	ResizeHandle.TextColor3 = WindowObj.Colors.TextSub
	ResizeHandle.TextSize = 13
	ResizeHandle.ZIndex = 100
	WindowObj:BindTheme(ResizeHandle, "TextColor3", "TextSub")
	WindowObj:BindFont(ResizeHandle, "Bold")

	local isResizing = false
	local dragStart, startSize

	ResizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isResizing = true
			dragStart = input.Position
			startSize = MainFrame.Size
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local currentCam = Workspace.CurrentCamera
			local screenBounds = currentCam and currentCam.ViewportSize or Vector2.new(1280, 720)

			local delta = input.Position - dragStart
			local newWidth = math.clamp(startSize.X.Offset + delta.X, 340, math.max(340, screenBounds.X - 20))
			local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 230, math.max(230, screenBounds.Y - 20))

			WindowObj.SavedWidth = newWidth
			WindowObj.SavedHeight = newHeight
			MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isResizing = false
		end
	end)

	task.spawn(function()
		WindowObj:Notify("Hệ Thống", "Giao diện đã tải hoàn tất!", 4)
	end)

	return WindowObj
end

-- =================================================================
-- THÔNG BÁO (NOTIFICATION)
-- =================================================================
function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 60)
	notifFrame.Position = UDim2.new(1, 50, 0, 0)
	notifFrame.BackgroundColor3 = self.Colors.Window
	notifFrame.BackgroundTransparency = 1
	AddUICorner(notifFrame, 6)
	local stroke = AddUIStroke(notifFrame, self.Colors.Border)
	stroke.Transparency = 1

	self:BindTheme(notifFrame, "BackgroundColor3", "Window")
	self:BindTheme(stroke, "Color", "Border")

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -20, 0, 20)
	titleLbl.Position = UDim2.new(0, 10, 0, 5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.Accent
	titleLbl.TextSize = 13
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.TextTransparency = 1
	self:BindTheme(titleLbl, "TextColor3", "Accent")
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -20, 0, 25)
	descLbl.Position = UDim2.new(0, 10, 0, 25)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = self.Colors.TextMain
	descLbl.TextSize = 12
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.TextWrapped = true
	descLbl.TextTransparency = 1
	self:BindTheme(descLbl, "TextColor3", "TextMain")
	self:BindFont(descLbl, "Main")

	TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
	TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
	TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

	task.delay(duration, function()
		local hideTween = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 50, 0, 0),
			BackgroundTransparency = 1
		})
		TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
		TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()

		hideTween:Play()
		hideTween.Completed:Connect(function()
			notifFrame:Destroy()
		end)
	end)
end

-- =================================================================
-- TẠO TAB & PHẦN TỬ UI (TABS & COMPONENTS)
-- =================================================================
function PitayaUI:CreateTab(tabName, iconSymbol)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, -20, 1, -20)
	page.Position = UDim2.new(0, 10, 0, 10)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 2
	page.Visible = false

	local PageList = Instance.new("UIListLayout", page)
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.Padding = UDim.new(0, 8)

	local tabBtn = Instance.new("TextButton", window.TabListContainer)
	tabBtn.Size = UDim2.new(1, 0, 0, 36)
	tabBtn.BackgroundColor3 = window.Colors.SidebarUnselected
	tabBtn.Text = ""
	tabBtn.AutoButtonColor = false
	AddUICorner(tabBtn, 8)
	window:BindTheme(tabBtn, "BackgroundColor3", "SidebarUnselected")

	local hasIcon = iconSymbol and iconSymbol ~= ""

	if hasIcon then
		local tabIcon = Instance.new("TextLabel", tabBtn)
		tabIcon.Size = UDim2.new(0, 24, 1, 0)
		tabIcon.Position = UDim2.new(0, 8, 0, 0)
		tabIcon.BackgroundTransparency = 1
		tabIcon.Text = iconSymbol
		tabIcon.TextColor3 = window.Colors.TextSub
		tabIcon.TextSize = 14
		tabIcon.TextXAlignment = Enum.TextXAlignment.Center
		window:BindTheme(tabIcon, "TextColor3", "TextSub")
		window:BindFont(tabIcon, "Medium")
		TabObj.IconLabel = tabIcon
	end

	local tabTextLabel = Instance.new("TextLabel", tabBtn)
	tabTextLabel.Size = UDim2.new(1, hasIcon and -32 or -16, 1, 0)
	tabTextLabel.Position = UDim2.new(0, hasIcon and 32 or 8, 0, 0)
	tabTextLabel.BackgroundTransparency = 1
	tabTextLabel.Text = tabName
	tabTextLabel.TextColor3 = window.Colors.TextSub
	tabTextLabel.TextSize = 13
	tabTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	window:BindTheme(tabTextLabel, "TextColor3", "TextSub")
	window:BindFont(tabTextLabel, "Medium")

	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			TweenService:Create(t.Button, TweenInfo.new(0.2), {
				BackgroundColor3 = window.Colors.SidebarUnselected
			}):Play()

			for _, child in ipairs(t.Button:GetChildren()) do
				if child:IsA("TextLabel") then
					child.TextColor3 = window.Colors.TextSub
				end
			end
		end

		page.Position = UDim2.new(0, 20, 0, 10)
		page.Visible = true
		window.TitleLabel.Text = window.TitleText .. " - " .. tabName

		TweenService:Create(page, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 10, 0, 10)
		}):Play()

		TweenService:Create(tabBtn, TweenInfo.new(0.2), {
			BackgroundColor3 = window.Colors.Accent
		}):Play()

		tabTextLabel.TextColor3 = window.Colors.TextMain
		if TabObj.IconLabel then
			TabObj.IconLabel.TextColor3 = window.Colors.TextMain
		end
	end

	tabBtn.MouseEnter:Connect(function()
		if not page.Visible then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = window.Colors.SidebarHover}):Play()
		end
	end)

	tabBtn.MouseLeave:Connect(function()
		if not page.Visible then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = window.Colors.SidebarUnselected}):Play()
		end
	end)

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	table.insert(window.Tabs, TabObj)

	if #window.Tabs == 1 then ActivateTab() end

	function TabObj:AddLabel(text)
		local label = Instance.new("TextLabel", page)
		label.Size = UDim2.new(1, 0, 0, 22)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = window.Colors.TextSub
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindTheme(label, "TextColor3", "TextSub")
		window:BindFont(label, "Main")
	end

	function TabObj:AddButton(options)
		options = options or {}
		local btnText = options.Text or "Button"
		local callback = options.Callback or function() end

		local btn = Instance.new("TextButton", page)
		btn.Size = UDim2.new(1, -5, 0, 38)
		btn.BackgroundColor3 = window.Colors.Accent
		btn.Text = btnText
		btn.TextColor3 = window.Colors.TextMain
		btn.TextSize = 13
		btn.AutoButtonColor = false
		AddUICorner(btn, 6)
		window:BindTheme(btn, "BackgroundColor3", "Accent")
		window:BindTheme(btn, "TextColor3", "TextMain")
		window:BindFont(btn, "Bold")

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = window.Colors.AccentHover}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = window.Colors.Accent}):Play()
		end)
		btn.MouseButton1Down:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -9, 0, 35)}):Play()
		end)
		btn.MouseButton1Up:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 38)}):Play()
		end)

		btn.MouseButton1Click:Connect(callback)
	end

	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "Toggle"
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local frame = Instance.new("Frame", page)
		frame.Size = UDim2.new(1, -5, 0, 38)
		frame.BackgroundColor3 = window.Colors.Background
		AddUICorner(frame, 6)
		local stroke = AddUIStroke(frame, window.Colors.Border)
		window:BindTheme(frame, "BackgroundColor3", "Background")
		window:BindTheme(stroke, "Color", "Border")

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -65, 1, 0)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = toggleText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindTheme(label, "TextColor3", "TextMain")
		window:BindFont(label, "Medium")

		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(0, 44, 0, 22)
		btn.Position = UDim2.new(1, -52, 0.5, -11)
		btn.BackgroundColor3 = defaultState and window.Colors.Accent or window.Colors.SidebarUnselected
		btn.Text = ""
		btn.AutoButtonColor = false
		AddUICorner(btn, 11)

		local dot = Instance.new("Frame", btn)
		dot.Size = UDim2.new(0, 16, 0, 16)
		dot.Position = UDim2.new(0, defaultState and 24 or 4, 0, 3)
		dot.BackgroundColor3 = window.Colors.TextMain
		AddUICorner(dot, 8)
		window:BindTheme(dot, "BackgroundColor3", "TextMain")

		local state = defaultState
		btn.MouseButton1Click:Connect(function()
			state = not state
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundColor3 = state and window.Colors.Accent or window.Colors.SidebarUnselected
			}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2), {
				Position = UDim2.new(0, state and 24 or 4, 0, 3)
			}):Play()
			callback(state)
		end)
	end

	function TabObj:AddSlider(options)
		options = options or {}
		local sliderText = options.Text or "Slider"
		local min = options.Min or 0
		local max = options.Max or 100
		local default = options.Default or min
		local callback = options.Callback or function() end

		local frame = Instance.new("Frame", page)
		frame.Size = UDim2.new(1, -5, 0, 48)
		frame.BackgroundColor3 = window.Colors.Background
		AddUICorner(frame, 6)
		local stroke = AddUIStroke(frame, window.Colors.Border)
		window:BindTheme(frame, "BackgroundColor3", "Background")
		window:BindTheme(stroke, "Color", "Border")

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -60, 0, 22)
		label.Position = UDim2.new(0, 12, 0, 2)
		label.BackgroundTransparency = 1
		label.Text = sliderText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindTheme(label, "TextColor3", "TextMain")
		window:BindFont(label, "Medium")

		local valLabel = Instance.new("TextLabel", frame)
		valLabel.Size = UDim2.new(0, 50, 0, 22)
		valLabel.Position = UDim2.new(1, -60, 0, 2)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(default)
		valLabel.TextColor3 = window.Colors.Accent
		valLabel.TextSize = 13
		window:BindTheme(valLabel, "TextColor3", "Accent")
		window:BindFont(valLabel, "Bold")

		local sliderBar = Instance.new("Frame", frame)
		sliderBar.Size = UDim2.new(1, -24, 0, 6)
		sliderBar.Position = UDim2.new(0, 12, 0, 32)
		sliderBar.BackgroundColor3 = window.Colors.SidebarUnselected
		AddUICorner(sliderBar, 3)
		window:BindTheme(sliderBar, "BackgroundColor3", "SidebarUnselected")

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.Accent
		AddUICorner(sliderFill, 3)
		window:BindTheme(sliderFill, "BackgroundColor3", "Accent")

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLabel.Text = tostring(value)
			TweenService:Create(sliderFill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
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
	end

	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "Dropdown"
		local items = options.Items or {}
		local defaultItem = options.Default or items[1] or ""
		local callback = options.Callback or function() end

		local isDropped = false
		local headerHeight = 38
		local itemHeight = 32
		local maxVisibleItems = 4
		local currentChoice = defaultItem

		local visibleCount = math.clamp(#items, 1, maxVisibleItems)
		page.ClipsDescendants = false

		local frame = Instance.new("Frame", page)
		frame.Name = "Dropdown"
		frame.Size = UDim2.new(1, -5, 0, headerHeight)
		frame.BackgroundColor3 = window.Colors.Background
		AddUICorner(frame, 6)
		local stroke = AddUIStroke(frame, window.Colors.Border)
		window:BindTheme(frame, "BackgroundColor3", "Background")
		window:BindTheme(stroke, "Color", "Border")

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -40, 0, headerHeight)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = dropText .. ": " .. tostring(currentChoice)
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindTheme(label, "TextColor3", "TextMain")
		window:BindFont(label, "Medium")

		local arrow = Instance.new("TextLabel", frame)
		arrow.Size = UDim2.new(0, 30, 0, headerHeight)
		arrow.Position = UDim2.new(1, -35, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "▼"
		arrow.TextColor3 = window.Colors.TextSub
		arrow.TextSize = 11
		window:BindTheme(arrow, "TextColor3", "TextSub")
		window:BindFont(arrow, "Bold")

		local listContainer = Instance.new("ScrollingFrame", frame)
		listContainer.Size = UDim2.new(1, 0, 0, 0)
		listContainer.Position = UDim2.new(0, 0, 0, headerHeight + 4)
		listContainer.BackgroundColor3 = window.Colors.Window
		listContainer.BorderSizePixel = 0
		listContainer.ZIndex = 50
		listContainer.CanvasSize = UDim2.new(0, 0, 0, #items * itemHeight)
		listContainer.ScrollBarThickness = 2
		listContainer.ClipsDescendants = true
		AddUICorner(listContainer, 6)
		local listStroke = AddUIStroke(listContainer, window.Colors.Border)

		window:BindTheme(listContainer, "BackgroundColor3", "Window")
		window:BindTheme(listStroke, "Color", "Border")

		local listLayout = Instance.new("UIListLayout", listContainer)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local function ToggleDrop()
			isDropped = not isDropped
			arrow.Text = isDropped and "▲" or "▼"
			local targetListH = isDropped and (visibleCount * itemHeight) or 0
			local targetFrameH = isDropped and (headerHeight + targetListH + 8) or headerHeight

			TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -5, 0, targetFrameH)
			}):Play()

			TweenService:Create(listContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, targetListH)
			}):Play()
		end

		local function RefreshItems(newItems)
			items = newItems or items
			for _, child in ipairs(listContainer:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end

			listContainer.CanvasSize = UDim2.new(0, 0, 0, #items * itemHeight)
			visibleCount = math.clamp(#items, 1, maxVisibleItems)

			for i, v in ipairs(items) do
				local itemBtn = Instance.new("TextButton", listContainer)
				itemBtn.Size = UDim2.new(1, 0, 0, itemHeight)
				itemBtn.BackgroundColor3 = window.Colors.Window
				itemBtn.Text = tostring(v)
				itemBtn.TextColor3 = (v == currentChoice) and window.Colors.Accent or window.Colors.TextSub
				itemBtn.TextSize = 12
				itemBtn.ZIndex = 51
				window:BindTheme(itemBtn, "BackgroundColor3", "Window")
				window:BindFont(itemBtn, "Main")

				itemBtn.MouseButton1Click:Connect(function()
					currentChoice = v
					label.Text = dropText .. ": " .. tostring(currentChoice)
					callback(v)
					ToggleDrop()
				end)
			end
		end

		RefreshItems(items)

		local headerBtn = Instance.new("TextButton", frame)
		headerBtn.Size = UDim2.new(1, 0, 0, headerHeight)
		headerBtn.BackgroundTransparency = 1
		headerBtn.Text = ""
		headerBtn.ZIndex = 10
		headerBtn.MouseButton1Click:Connect(ToggleDrop)

		local DropObj = {}
		function DropObj:Refresh(newList)
			RefreshItems(newList)
		end
		return DropObj
	end

	function TabObj:AddTextBox(options)
		options = options or {}
		local boxText = options.Text or "Input"
		local placeholder = options.Placeholder or "Enter text..."
		local callback = options.Callback or function() end

		local frame = Instance.new("Frame", page)
		frame.Size = UDim2.new(1, -5, 0, 38)
		frame.BackgroundColor3 = window.Colors.Background
		AddUICorner(frame, 6)
		local stroke = AddUIStroke(frame, window.Colors.Border)
		window:BindTheme(frame, "BackgroundColor3", "Background")
		window:BindTheme(stroke, "Color", "Border")

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(0, 100, 1, 0)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = boxText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindTheme(label, "TextColor3", "TextMain")
		window:BindFont(label, "Medium")

		local textBox = Instance.new("TextBox", frame)
		textBox.Size = UDim2.new(1, -125, 0, 26)
		textBox.Position = UDim2.new(0, 115, 0.5, -13)
		textBox.BackgroundColor3 = window.Colors.SidebarUnselected
		textBox.Text = ""
		textBox.PlaceholderText = placeholder
		textBox.TextColor3 = window.Colors.TextMain
		textBox.PlaceholderColor3 = window.Colors.TextSub
		textBox.TextSize = 12
		textBox.ClearTextOnFocus = false
		AddUICorner(textBox, 4)
		window:BindTheme(textBox, "BackgroundColor3", "SidebarUnselected")
		window:BindTheme(textBox, "TextColor3", "TextMain")
		window:BindFont(textBox, "Main")

		textBox.FocusLost:Connect(function(enterPressed)
			callback(textBox.Text, enterPressed)
		end)
	end

	return TabObj
end

return PitayaUI
