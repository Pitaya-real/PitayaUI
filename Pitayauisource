local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- =================================================================
-- BẢNG THEMES CHUẨN PITAYA (MÔ PHỎNG THEO ẢNH GIỚI THIỆU)
-- =================================================================
PitayaUI.Themes = {
	Pitaya = {
		Background = Color3.fromRGB(12, 13, 18),
		Window = Color3.fromRGB(18, 20, 26),
		Card = Color3.fromRGB(24, 27, 36),
		Border = Color3.fromRGB(40, 45, 58),
		TextMain = Color3.fromRGB(245, 245, 250),
		TextSub = Color3.fromRGB(150, 155, 170),
		Accent = Color3.fromRGB(0, 162, 255),        -- Màu Cyan/Xanh đặc trưng
		AccentHover = Color3.fromRGB(30, 180, 255),
		SidebarUnselected = Color3.fromRGB(18, 20, 26),
		SidebarHover = Color3.fromRGB(28, 32, 42),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	},
	Dark = {
		Background = Color3.fromRGB(15, 15, 15),
		Window = Color3.fromRGB(24, 24, 24),
		Card = Color3.fromRGB(32, 32, 32),
		Border = Color3.fromRGB(50, 50, 50),
		TextMain = Color3.fromRGB(240, 240, 240),
		TextSub = Color3.fromRGB(160, 160, 160),
		Accent = Color3.fromRGB(80, 140, 240),
		AccentHover = Color3.fromRGB(100, 160, 255),
		SidebarUnselected = Color3.fromRGB(24, 24, 24),
		SidebarHover = Color3.fromRGB(36, 36, 36),
		Dots = {Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 180, 50), Color3.fromRGB(50, 200, 100)}
	}
}

-- =================================================================
-- BẢNG PHÔNG CHỮ SẴN CÓ
-- =================================================================
PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium },
	Roboto = { Main = Enum.Font.Roboto, Bold = Enum.Font.RobotoCondensed, Medium = Enum.Font.Roboto },
	SourceSans = { Main = Enum.Font.SourceSans, Bold = Enum.Font.SourceSansBold, Medium = Enum.Font.SourceSansSemibold },
	BuilderSans = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Medium = Enum.Font.BuilderSansMedium }
}

local function AddUICorner(parent, radius)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function AddUIStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or Color3.fromRGB(40, 45, 58)
	stroke.Thickness = thickness or 1
	return stroke
end

-- =================================================================
-- QUẢN LÝ THEME VÀ FONT
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
	WindowObj.TitleText = config.Title or "PitayaUI | Hub"
	WindowObj.LogoId = config.Logo or "rbxassetid://115347218827913"
	WindowObj.Tabs = {}
	WindowObj.ThemeObjects = {}
	WindowObj.FontObjects = {}

	-- Khởi tạo Theme & Font
	local selectedTheme = config.Theme or "Pitaya"
	local baseTheme = PitayaUI.Themes[selectedTheme] or PitayaUI.Themes.Pitaya
	WindowObj.Colors = {}
	for k, v in pairs(baseTheme) do
		WindowObj.Colors[k] = v
	end
	WindowObj.CurrentThemeName = selectedTheme

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
		pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
		if not ScreenGui.Parent then
			ScreenGui.Parent = PlayerGui
		end
	end

	WindowObj.ScreenGui = ScreenGui

	-- Tự động căn chỉnh kích thước ban đầu theo màn hình thiết bị
	local Camera = Workspace.CurrentCamera
	local viewportSize = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

	local targetWidth = math.floor(math.min(680, viewportSize.X * 0.88))
	local targetHeight = math.floor(math.min(420, viewportSize.Y * 0.85))

	targetWidth = math.clamp(targetWidth, 380, 1200)
	targetHeight = math.clamp(targetHeight, 260, 800)

	WindowObj.SavedWidth = targetWidth
	WindowObj.SavedHeight = targetHeight

	-- Notification Container
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

	-- Floating Toggle Button (Mở/Đóng UI)
	local ToggleBtn = Instance.new("ImageButton", ScreenGui)
	ToggleBtn.Name = "PitayaToggle"
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

	-- Khung chính UI (MainFrame)
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight)
	MainFrame.Position = UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
	MainFrame.BackgroundColor3 = WindowObj.Colors.Background
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.ClipsDescendants = true
	AddUICorner(MainFrame, 10)
	local mainStroke = AddUIStroke(MainFrame, WindowObj.Colors.Border)

	WindowObj:BindTheme(MainFrame, "BackgroundColor3", "Background")
	WindowObj:BindTheme(mainStroke, "Color", "Border")
	WindowObj.MainFrame = MainFrame

	-- Bật/Tắt UI Animation
	local isOpen = true
	ToggleBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.SavedWidth, 0, WindowObj.SavedHeight),
				Position = UDim2.new(0.5, -WindowObj.SavedWidth / 2, 0.5, -WindowObj.SavedHeight / 2)
			}):Play()
		else
			local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
			tween:Play()
			tween.Completed:Connect(function()
				if not isOpen then MainFrame.Visible = false end
			end)
		end
	end)

	-- Sidebar (Menu Trái)
	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Size = UDim2.new(0, 180, 1, 0)
	Sidebar.Position = UDim2.new(0, 0, 0, 0)
	Sidebar.BackgroundColor3 = WindowObj.Colors.Window
	Sidebar.BorderSizePixel = 0
	WindowObj:BindTheme(Sidebar, "BackgroundColor3", "Window")

	local SidebarLine = Instance.new("Frame", Sidebar)
	SidebarLine.Size = UDim2.new(0, 1, 1, 0)
	SidebarLine.Position = UDim2.new(1, -1, 0, 0)
	SidebarLine.BackgroundColor3 = WindowObj.Colors.Border
	WindowObj:BindTheme(SidebarLine, "BackgroundColor3", "Border")

	-- Thanh Search trong Sidebar (Khớp với ảnh)
	local SearchBoxFrame = Instance.new("Frame", Sidebar)
	SearchBoxFrame.Size = UDim2.new(1, -20, 0, 32)
	SearchBoxFrame.Position = UDim2.new(0, 10, 0, 12)
	SearchBoxFrame.BackgroundColor3 = WindowObj.Colors.Background
	AddUICorner(SearchBoxFrame, 6)
	AddUIStroke(SearchBoxFrame, WindowObj.Colors.Border)

	local SearchIcon = Instance.new("TextLabel", SearchBoxFrame)
	SearchIcon.Size = UDim2.new(0, 24, 1, 0)
	SearchIcon.Position = UDim2.new(0, 6, 0, 0)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Text = "🔍"
	SearchIcon.TextSize = 12

	local SearchInput = Instance.new("TextBox", SearchBoxFrame)
	SearchInput.Size = UDim2.new(1, -34, 1, 0)
	SearchInput.Position = UDim2.new(0, 30, 0, 0)
	SearchInput.BackgroundTransparency = 1
	SearchInput.Text = ""
	SearchInput.PlaceholderText = "Search section or Function..."
	SearchInput.TextColor3 = WindowObj.Colors.TextMain
	SearchInput.PlaceholderColor3 = WindowObj.Colors.TextSub
	SearchInput.TextSize = 11
	SearchInput.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(SearchInput, "Main")

	-- Tab Buttons Container
	local TabListContainer = Instance.new("ScrollingFrame", Sidebar)
	TabListContainer.Size = UDim2.new(1, -10, 1, -55)
	TabListContainer.Position = UDim2.new(0, 5, 0, 50)
	TabListContainer.BackgroundTransparency = 1
	TabListContainer.ScrollBarThickness = 0

	local UIList = Instance.new("UIListLayout", TabListContainer)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 4)

	-- Content Area (Nội dung Phải)
	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Size = UDim2.new(1, -180, 1, 0)
	ContentArea.Position = UDim2.new(0, 180, 0, 0)
	ContentArea.BackgroundTransparency = 1
	WindowObj.ContentArea = ContentArea
	WindowObj.TabListContainer = TabListContainer

	-- Tìm kiếm Tab / Chức năng nâng cao
	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local query = string.lower(SearchInput.Text)
		for _, tabData in ipairs(WindowObj.Tabs) do
			local match = string.find(string.lower(tabData.Name), query) ~= nil
			tabData.Button.Visible = match
		end
	end)

	-- Resize Handle (Kéo giãn thu phóng & tự lưu kích thước)
	local ResizeHandle = Instance.new("TextButton", MainFrame)
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.Size = UDim2.new(0, 18, 0, 18)
	ResizeHandle.Position = UDim2.new(1, -18, 1, -18)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Text = "◢"
	ResizeHandle.TextColor3 = WindowObj.Colors.TextSub
	ResizeHandle.TextSize = 12
	ResizeHandle.ZIndex = 100
	WindowObj:BindTheme(ResizeHandle, "TextColor3", "TextSub")

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
			local newWidth = math.clamp(startSize.X.Offset + delta.X, 380, math.max(380, screenBounds.X - 20))
			local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 260, math.max(260, screenBounds.Y - 20))

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

	return WindowObj
end

-- =================================================================
-- THÔNG BÁO (NOTIFICATION)
-- =================================================================
function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 58)
	notifFrame.Position = UDim2.new(1, 50, 0, 0)
	notifFrame.BackgroundColor3 = self.Colors.Card
	notifFrame.BackgroundTransparency = 1
	AddUICorner(notifFrame, 6)
	local stroke = AddUIStroke(notifFrame, self.Colors.Border)
	stroke.Transparency = 1

	self:BindTheme(notifFrame, "BackgroundColor3", "Card")

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -20, 0, 20)
	titleLbl.Position = UDim2.new(0, 10, 0, 6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.Accent
	titleLbl.TextSize = 13
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.TextTransparency = 1
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -20, 0, 24)
	descLbl.Position = UDim2.new(0, 10, 0, 26)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = self.Colors.TextMain
	descLbl.TextSize = 11
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.TextWrapped = true
	descLbl.TextTransparency = 1
	self:BindFont(descLbl, "Main")

	TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0
	}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
	TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(descLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

	task.delay(duration, function()
		local hideTween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 50, 0, 0),
			BackgroundTransparency = 1
		})
		TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(descLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

		hideTween:Play()
		hideTween.Completed:Connect(function() notifFrame:Destroy() end)
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
	page.ScrollBarImageColor3 = window.Colors.Border
	page.Visible = false

	local PageList = Instance.new("UIListLayout", page)
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.Padding = UDim.new(0, 8)

	-- Tab Button ở Sidebar trái với Vạch Highlight Xanh như trong ảnh
	local tabBtn = Instance.new("TextButton", window.TabListContainer)
	tabBtn.Size = UDim2.new(1, 0, 0, 34)
	tabBtn.BackgroundColor3 = window.Colors.SidebarUnselected
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = ""
	tabBtn.AutoButtonColor = false

	local activeBar = Instance.new("Frame", tabBtn)
	activeBar.Size = UDim2.new(0, 3, 1, -10)
	activeBar.Position = UDim2.new(0, 0, 0.5, -12)
	activeBar.BackgroundColor3 = window.Colors.Accent
	activeBar.Visible = false
	AddUICorner(activeBar, 2)

	local tabTextLabel = Instance.new("TextLabel", tabBtn)
	tabTextLabel.Size = UDim2.new(1, -20, 1, 0)
	tabTextLabel.Position = UDim2.new(0, 15, 0, 0)
	tabTextLabel.BackgroundTransparency = 1
	tabTextLabel.Text = tabName
	tabTextLabel.TextColor3 = window.Colors.TextSub
	tabTextLabel.TextSize = 13
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
		tabTextLabel.TextColor3 = window.Colors.TextMain
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	TabObj.ActiveBar = activeBar
	TabObj.TextLabel = tabTextLabel
	TabObj.Name = tabName
	table.insert(window.Tabs, TabObj)

	if #window.Tabs == 1 then ActivateTab() end

	-- Header / Section Divider (Khớp tiêu đề phân nhóm như trong ảnh "Select tool", "Event")
	function TabObj:AddSection(text)
		local sectionFrame = Instance.new("Frame", page)
		sectionFrame.Size = UDim2.new(1, 0, 0, 24)
		sectionFrame.BackgroundTransparency = 1

		local label = Instance.new("TextLabel", sectionFrame)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = window.Colors.TextSub
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Center
		window:BindFont(label, "Bold")
	end

	function TabObj:AddLabel(text)
		local label = Instance.new("TextLabel", page)
		label.Size = UDim2.new(1, 0, 0, 20)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = window.Colors.TextSub
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Main")
	end

	-- Card Button (Thiết kế dạng Card + Nút Click góc phải)
	function TabObj:AddButton(options)
		options = options or {}
		local btnText = options.Text or "Button"
		local subText = options.SubText or ""
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, subText ~= "" and 50 or 42)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -110, 0, 20)
		label.Position = UDim2.new(0, 12, 0, subText ~= "" and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = btnText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if subText ~= "" then
			local subLabel = Instance.new("TextLabel", card)
			subLabel.Size = UDim2.new(1, -110, 0, 16)
			subLabel.Position = UDim2.new(0, 12, 0, 26)
			subLabel.BackgroundTransparency = 1
			subLabel.Text = subText
			subLabel.TextColor3 = window.Colors.TextSub
			subLabel.TextSize = 10
			subLabel.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(subLabel, "Main")
		end

		local actionBtn = Instance.new("TextButton", card)
		actionBtn.Size = UDim2.new(0, 80, 0, 26)
		actionBtn.Position = UDim2.new(1, -90, 0.5, -13)
		actionBtn.BackgroundColor3 = window.Colors.Accent
		actionBtn.Text = "Click"
		actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		actionBtn.TextSize = 11
		AddUICorner(actionBtn, 13)
		window:BindFont(actionBtn, "Bold")

		actionBtn.MouseButton1Click:Connect(callback)
	end

	-- Card Toggle (Thiết kế dạng Card + Ô tích Vuông Cyan giống hệt ảnh)
	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "Toggle"
		local subText = options.SubText or ""
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, subText ~= "" and 50 or 40)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -50, 0, 18)
		label.Position = UDim2.new(0, 12, 0, subText ~= "" and 6 or 11)
		label.BackgroundTransparency = 1
		label.Text = toggleText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		if subText ~= "" then
			local subLabel = Instance.new("TextLabel", card)
			subLabel.Size = UDim2.new(1, -50, 0, 16)
			subLabel.Position = UDim2.new(0, 12, 0, 26)
			subLabel.BackgroundTransparency = 1
			subLabel.Text = subText
			subLabel.TextColor3 = window.Colors.TextSub
			subLabel.TextSize = 10
			subLabel.TextXAlignment = Enum.TextXAlignment.Left
			window:BindFont(subLabel, "Main")
		end

		local checkSquare = Instance.new("TextButton", card)
		checkSquare.Size = UDim2.new(0, 20, 0, 20)
		checkSquare.Position = UDim2.new(1, -32, 0.5, -10)
		checkSquare.BackgroundColor3 = window.Colors.Background
		checkSquare.Text = defaultState and "✓" or ""
		checkSquare.TextColor3 = window.Colors.Accent
		checkSquare.TextSize = 14
		AddUICorner(checkSquare, 4)
		local squareStroke = AddUIStroke(checkSquare, defaultState and window.Colors.Accent or window.Colors.Border)

		local state = defaultState
		checkSquare.MouseButton1Click:Connect(function()
			state = not state
			checkSquare.Text = state and "✓" or ""
			squareStroke.Color = state and window.Colors.Accent or window.Colors.Border
			callback(state)
		end)
	end

	-- Card Slider (Thanh trượt Cyan ở phía dưới giống chuẩn ảnh)
	function TabObj:AddSlider(options)
		options = options or {}
		local sliderText = options.Text or "Slider"
		local min = options.Min or 0
		local max = options.Max or 100
		local default = options.Default or min
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, 0, 0, 52)
		card.BackgroundColor3 = window.Colors.Card
		AddUICorner(card, 6)
		AddUIStroke(card, window.Colors.Border)

		local label = Instance.new("TextLabel", card)
		label.Size = UDim2.new(1, -80, 0, 20)
		label.Position = UDim2.new(0, 12, 0, 8)
		label.BackgroundTransparency = 1
		label.Text = sliderText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local valBox = Instance.new("Frame", card)
		valBox.Size = UDim2.new(0, 50, 0, 20)
		valBox.Position = UDim2.new(1, -62, 0, 8)
		valBox.BackgroundColor3 = window.Colors.Background
		AddUICorner(valBox, 4)

		local valLabel = Instance.new("TextLabel", valBox)
		valLabel.Size = UDim2.new(1, 0, 1, 0)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(default)
		valLabel.TextColor3 = window.Colors.TextMain
		valLabel.TextSize = 11
		window:BindFont(valLabel, "Main")

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -24, 0, 6)
		sliderBar.Position = UDim2.new(0, 12, 0, 36)
		sliderBar.BackgroundColor3 = window.Colors.Background
		AddUICorner(sliderBar, 3)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.Accent
		AddUICorner(sliderFill, 3)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLabel.Text = tostring(value)
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
	end

	-- Card Dropdown (Giao diện thẻ có mũi tên mở rộng ">")
	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "Dropdown"
		local items = options.Items or {}
		local defaultItem = options.Default or items[1] or ""
		local callback = options.Callback or function() end

		local isDropped = false
		local headerHeight = 40
		local itemHeight = 28
		local currentChoice = defaultItem

		local frame = Instance.new("Frame", page)
		frame.Size = UDim2.new(1, 0, 0, headerHeight)
		frame.BackgroundColor3 = window.Colors.Card
		AddUICorner(frame, 6)
		AddUIStroke(frame, window.Colors.Border)

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, -40, 0, headerHeight)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = dropText .. ": " .. tostring(currentChoice)
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local arrow = Instance.new("TextLabel", frame)
		arrow.Size = UDim2.new(0, 30, 0, headerHeight)
		arrow.Position = UDim2.new(1, -35, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "›"
		arrow.TextColor3 = window.Colors.TextSub
		arrow.TextSize = 18
		window:BindFont(arrow, "Bold")

		local listContainer = Instance.new("ScrollingFrame", frame)
		listContainer.Size = UDim2.new(1, 0, 0, 0)
		listContainer.Position = UDim2.new(0, 0, 0, headerHeight)
		listContainer.BackgroundColor3 = window.Colors.Card
		listContainer.BorderSizePixel = 0
		listContainer.ScrollBarThickness = 2
		listContainer.ClipsDescendants = true

		local listLayout = Instance.new("UIListLayout", listContainer)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local function ToggleDrop()
			isDropped = not isDropped
			arrow.Text = isDropped and "˅" or "›"
			local targetListH = isDropped and (#items * itemHeight) or 0
			local targetFrameH = isDropped and (headerHeight + targetListH + 4) or headerHeight

			TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, targetFrameH)
			}):Play()

			TweenService:Create(listContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, targetListH)
			}):Play()
		end

		for _, v in ipairs(items) do
			local itemBtn = Instance.new("TextButton", listContainer)
			itemBtn.Size = UDim2.new(1, 0, 0, itemHeight)
			itemBtn.BackgroundTransparency = 1
			itemBtn.Text = tostring(v)
			itemBtn.TextColor3 = (v == currentChoice) and window.Colors.Accent or window.Colors.TextSub
			itemBtn.TextSize = 11
			window:BindFont(itemBtn, "Main")

			itemBtn.MouseButton1Click:Connect(function()
				currentChoice = v
				label.Text = dropText .. ": " .. tostring(currentChoice)
				callback(v)
				ToggleDrop()
			end)
		end

		local headerBtn = Instance.new("TextButton", frame)
		headerBtn.Size = UDim2.new(1, 0, 0, headerHeight)
		headerBtn.BackgroundTransparency = 1
		headerBtn.Text = ""
		headerBtn.MouseButton1Click:Connect(ToggleDrop)
	end

	function TabObj:AddTextBox(options)
		options = options or {}
		local boxText = options.Text or "Input"
		local placeholder = options.Placeholder or "Enter text..."
		local callback = options.Callback or function() end

		local frame = Instance.new("Frame", page)
		frame.Size = UDim2.new(1, 0, 0, 40)
		frame.BackgroundColor3 = window.Colors.Card
		AddUICorner(frame, 6)
		AddUIStroke(frame, window.Colors.Border)

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(0, 100, 1, 0)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = boxText
		label.TextColor3 = window.Colors.TextMain
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(label, "Bold")

		local textBox = Instance.new("TextBox", frame)
		textBox.Size = UDim2.new(1, -125, 0, 24)
		textBox.Position = UDim2.new(0, 115, 0.5, -12)
		textBox.BackgroundColor3 = window.Colors.Background
		textBox.Text = ""
		textBox.PlaceholderText = placeholder
		textBox.TextColor3 = window.Colors.TextMain
		textBox.PlaceholderColor3 = window.Colors.TextSub
		textBox.TextSize = 11
		textBox.ClearTextOnFocus = false
		AddUICorner(textBox, 4)
		window:BindFont(textBox, "Main")

		textBox.FocusLost:Connect(function(enterPressed)
			callback(textBox.Text, enterPressed)
		end)
	end

	return TabObj
end

return PitayaUI
