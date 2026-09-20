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
-- THEMES LIQUID GLASS
-- =================================================================
PitayaUI.Themes = {
	PitayaUI = {
		WindowBackground = Color3.fromRGB(15, 18, 28),
		GlassCard = Color3.fromRGB(255, 255, 255),
		GlassCardTransparency = 0.94,
		BorderGlass = Color3.fromRGB(255, 255, 255),
		TextMain = Color3.fromRGB(245, 247, 255),
		TextSub = Color3.fromRGB(160, 165, 185),
		Accent = Color3.fromRGB(255, 45, 120),
		AccentCyan = Color3.fromRGB(0, 230, 255),
	},
	Dark = {
		WindowBackground = Color3.fromRGB(10, 12, 18),
		GlassCard = Color3.fromRGB(255, 255, 255),
		GlassCardTransparency = 0.96,
		BorderGlass = Color3.fromRGB(200, 220, 255),
		TextMain = Color3.fromRGB(240, 240, 245),
		TextSub = Color3.fromRGB(130, 135, 155),
		Accent = Color3.fromRGB(0, 170, 255),
		AccentCyan = Color3.fromRGB(180, 80, 255),
	}
}

PitayaUI.FontPresets = {
	Gotham = { Main = Enum.Font.Gotham, Bold = Enum.Font.GothamBold, Medium = Enum.Font.GothamMedium },
	FredokaOne = { Main = Enum.Font.FredokaOne, Bold = Enum.Font.FredokaOne, Medium = Enum.Font.FredokaOne },
	BuilderSans = { Main = Enum.Font.BuilderSans, Bold = Enum.Font.BuilderSansBold, Medium = Enum.Font.BuilderSansMedium }
}

local function AddUICorner(parent, radiusScale, radiusOffset)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(radiusScale or 0, radiusOffset or 0)
	return corner
end

local function AddUIStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
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
			TweenService:Create(item.Instance, TweenInfo.new(0.4), { [item.Property] = self.Colors[item.Role] }):Play()
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
-- TẠO CỬA SỔ CHÍNH
-- =================================================================
function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "PITAYA GLASS UI"
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
	ScreenGui.Name = "PitayaUI_LiquidEngine"
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game:GetService("CoreGui")
	else
		pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
		if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	end
	WindowObj.ScreenGui = ScreenGui

	local vpSize = Camera.ViewportSize
	local targetWidth = math.clamp(vpSize.X * 0.72, 380, 520)
	local targetHeight = math.clamp(vpSize.Y * 0.68, 280, 380)
	
	WindowObj.CurrentWidth = targetWidth
	WindowObj.CurrentHeight = targetHeight

	-- NOTIFICATION CONTAINER
	local NotifContainer = Instance.new("Frame", ScreenGui)
	NotifContainer.Name = "NotifContainer"
	NotifContainer.Size = UDim2.new(0, 220, 0, 200)
	NotifContainer.Position = UDim2.new(1, -230, 1, -210)
	NotifContainer.BackgroundTransparency = 1
	WindowObj.NotifContainer = NotifContainer

	local NotifList = Instance.new("UIListLayout", NotifContainer)
	NotifList.SortOrder = Enum.SortOrder.LayoutOrder
	NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifList.Padding = UDim.new(0, 6)

	-- -------------------------------------------------------------
	-- NÚT FLOATING TOGGLE (CẮT VIỀN ĐEN BẰNG CANVAS MỞ RỘNG)
	-- -------------------------------------------------------------
	local FloatBtnFrame = Instance.new("Frame", ScreenGui)
	FloatBtnFrame.Name = "FloatingToggle"
	FloatBtnFrame.Size = UDim2.new(0, 52, 0, 52)
	FloatBtnFrame.Position = UDim2.new(0, 20, 0.35, 0)
	FloatBtnFrame.BackgroundColor3 = WindowObj.Colors.WindowBackground
	FloatBtnFrame.BackgroundTransparency = 0.1
	FloatBtnFrame.Active = true
	AddUICorner(FloatBtnFrame, 1, 0)

	local floatStroke = AddUIStroke(FloatBtnFrame, WindowObj.Colors.BorderGlass, 1.8, 0.2)
	local floatGrad = Instance.new("UIGradient", floatStroke)
	floatGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, WindowObj.Colors.AccentCyan),
		ColorSequenceKeypoint.new(1, WindowObj.Colors.Accent)
	})

	local LogoMaskGroup = Instance.new("CanvasGroup", FloatBtnFrame)
	LogoMaskGroup.Size = UDim2.new(1, 0, 1, 0)
	LogoMaskGroup.Position = UDim2.new(0, 0, 0, 0)
	LogoMaskGroup.BackgroundTransparency = 1
	AddUICorner(LogoMaskGroup, 1, 0)

	-- Zoom nhẹ ảnh lên 125% để đẩy phần đen vuông của asset ra khỏi khung tròn
	local FloatBtnIcon = Instance.new("ImageLabel", LogoMaskGroup)
	FloatBtnIcon.Size = UDim2.new(1.25, 0, 1.25, 0)
	FloatBtnIcon.Position = UDim2.new(-0.125, 0, -0.125, 0)
	FloatBtnIcon.BackgroundTransparency = 1
	FloatBtnIcon.Image = WindowObj.LogoId
	FloatBtnIcon.ScaleType = Enum.ScaleType.Crop
	FloatBtnIcon.Active = false

	-- Kéo thả nút Floating
	local isDragging = false
	local hasDragged = false
	local dragStart, startPos

	FloatBtnFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			hasDragged = false
			dragStart = input.Position
			startPos = FloatBtnFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if delta.Magnitude > 5 then hasDragged = true end
			FloatBtnFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end)

	-- -------------------------------------------------------------
	-- MAIN FRAME CỬA SỔ CHÍNH
	-- -------------------------------------------------------------
	local MainFrame = Instance.new("CanvasGroup", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, targetWidth, 0, targetHeight)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.BackgroundColor3 = WindowObj.Colors.WindowBackground
	MainFrame.GroupTransparency = 0
	MainFrame.BackgroundTransparency = 0.18
	AddUICorner(MainFrame, 0, 16)

	local mainStroke = AddUIStroke(MainFrame, Color3.fromRGB(255, 255, 255), 1.5, 0.4)
	local mainGrad = Instance.new("UIGradient", mainStroke)
	mainGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, WindowObj.Colors.AccentCyan),
		ColorSequenceKeypoint.new(1, WindowObj.Colors.Accent)
	})
	mainGrad.Rotation = 45

	WindowObj.MainFrame = MainFrame

	-- TOPBAR
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 40)
	Topbar.BackgroundTransparency = 1

	local winDragging = false
	local winDragStart, winStartPos

	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			winDragging = true
			winDragStart = input.Position
			winStartPos = MainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if winDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - winDragStart
			MainFrame.Position = UDim2.new(
				winStartPos.X.Scale, winStartPos.X.Offset + delta.X,
				winStartPos.Y.Scale, winStartPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			winDragging = false
		end
	end)

	-- Logo Topbar
	local TopLogoMask = Instance.new("CanvasGroup", Topbar)
	TopLogoMask.Size = UDim2.new(0, 24, 0, 24)
	TopLogoMask.Position = UDim2.new(0, 10, 0, 8)
	TopLogoMask.BackgroundTransparency = 1
	AddUICorner(TopLogoMask, 1, 0)

	local LogoImg = Instance.new("ImageLabel", TopLogoMask)
	LogoImg.Size = UDim2.new(1.25, 0, 1.25, 0)
	LogoImg.Position = UDim2.new(-0.125, 0, -0.125, 0)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = WindowObj.LogoId
	LogoImg.ScaleType = Enum.ScaleType.Crop

	local TitleLbl = Instance.new("TextLabel", Topbar)
	TitleLbl.Size = UDim2.new(1, -80, 1, 0)
	TitleLbl.Position = UDim2.new(0, 42, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = WindowObj.TitleText
	TitleLbl.TextColor3 = WindowObj.Colors.TextMain
	TitleLbl.TextSize = 12
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(TitleLbl, "Bold")

	local CloseBtn = Instance.new("TextButton", Topbar)
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -34, 0, 5)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 110)
	CloseBtn.TextSize = 13
	WindowObj:BindFont(CloseBtn, "Bold")

	-- ANIMATION MỞ / ĐÓNG CĂN TÂM
	local isOpen = true
	local function ToggleUI()
		isOpen = not isOpen
		if isOpen then
			MainFrame.Visible = true
			MainFrame.Size = UDim2.new(0, 0, 0, 0)
			MainFrame.GroupTransparency = 1
			TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowObj.CurrentWidth, 0, WindowObj.CurrentHeight),
				GroupTransparency = 0
			}):Play()
		else
			local tw = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				GroupTransparency = 1
			})
			tw:Play()
			tw.Completed:Connect(function()
				if not isOpen then MainFrame.Visible = false end
			end)
		end
	end

	FloatBtnFrame.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not hasDragged then
			ToggleUI()
		end
	end)

	CloseBtn.MouseButton1Click:Connect(ToggleUI)

	-- -------------------------------------------------------------
	-- THANH TAB NGANG (ĐÃ TỰ ĐỘNG CĂN CHỈNH - KHÔNG CHỒNG NHAU)
	-- -------------------------------------------------------------
	local TabBarFrame = Instance.new("Frame", MainFrame)
	TabBarFrame.Name = "TabBarFrame"
	TabBarFrame.Size = UDim2.new(1, -20, 0, 32)
	TabBarFrame.Position = UDim2.new(0, 10, 0, 42)
	TabBarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TabBarFrame.BackgroundTransparency = 0.5
	AddUICorner(TabBarFrame, 0, 8)
	AddUIStroke(TabBarFrame, Color3.fromRGB(255, 255, 255), 1, 0.9)

	local TabScroll = Instance.new("ScrollingFrame", TabBarFrame)
	TabScroll.Size = UDim2.new(1, -6, 1, 0)
	TabScroll.Position = UDim2.new(0, 3, 0, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0

	local TabListLayout = Instance.new("UIListLayout", TabScroll)
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 6)
	TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	-- Indicator Trượt
	local LiquidTabIndicator = Instance.new("Frame", TabScroll)
	LiquidTabIndicator.Name = "LiquidTabIndicator"
	LiquidTabIndicator.Size = UDim2.new(0, 80, 1, -6)
	LiquidTabIndicator.Position = UDim2.new(0, 0, 0, 3)
	LiquidTabIndicator.BackgroundColor3 = WindowObj.Colors.Accent
	LiquidTabIndicator.Visible = false
	LiquidTabIndicator.ZIndex = 1
	AddUICorner(LiquidTabIndicator, 0, 6)

	WindowObj.LiquidTabIndicator = LiquidTabIndicator

	-- -------------------------------------------------------------
	-- CONTENT AREA
	-- -------------------------------------------------------------
	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -20, 1, -96)
	ContentArea.Position = UDim2.new(0, 10, 0, 80)
	ContentArea.BackgroundTransparency = 1
	WindowObj.ContentArea = ContentArea
	WindowObj.TabScroll = TabScroll
	WindowObj.TabListLayout = TabListLayout

	-- FOOTER STATUS BAR
	local FooterLbl = Instance.new("TextLabel", MainFrame)
	FooterLbl.Size = UDim2.new(1, -24, 0, 14)
	FooterLbl.Position = UDim2.new(0, 10, 1, -16)
	FooterLbl.BackgroundTransparency = 1
	FooterLbl.TextColor3 = WindowObj.Colors.TextSub
	FooterLbl.TextSize = 9
	FooterLbl.TextXAlignment = Enum.TextXAlignment.Left
	WindowObj:BindFont(FooterLbl, "Main")

	task.spawn(function()
		while task.wait(1) do
			if ScreenGui.Parent then
				local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
				FooterLbl.Text = string.format("User: %s  |  Status: Active  |  Ping: %dms", LocalPlayer.Name, ping)
			end
		end
	end)

	function WindowObj:Log() end
	return WindowObj
end

-- =================================================================
-- NOTIFICATION
-- =================================================================
function PitayaUI:Notify(title, text, duration)
	duration = duration or 3
	local notifFrame = Instance.new("Frame", self.NotifContainer)
	notifFrame.Size = UDim2.new(1, 0, 0, 44)
	notifFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
	notifFrame.BackgroundTransparency = 0.15
	AddUICorner(notifFrame, 0, 8)
	AddUIStroke(notifFrame, self.Colors.Accent, 1, 0.3)

	local titleLbl = Instance.new("TextLabel", notifFrame)
	titleLbl.Size = UDim2.new(1, -12, 0, 14)
	titleLbl.Position = UDim2.new(0, 8, 0, 4)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = self.Colors.AccentCyan
	titleLbl.TextSize = 10
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(titleLbl, "Bold")

	local descLbl = Instance.new("TextLabel", notifFrame)
	descLbl.Size = UDim2.new(1, -12, 0, 18)
	descLbl.Position = UDim2.new(0, 8, 0, 20)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = text
	descLbl.TextColor3 = self.Colors.TextMain
	descLbl.TextSize = 9
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	self:BindFont(descLbl, "Main")

	task.delay(duration, function()
		if notifFrame then
			local tw = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				BackgroundTransparency = 1
			})
			tw:Play()
			tw.Completed:Connect(function() notifFrame:Destroy() end)
		end
	end)
end

-- =================================================================
-- CREATING TABS & COMPONENTS
-- =================================================================
function PitayaUI:CreateTab(tabName, iconSymbol)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = window.Colors.AccentCyan
	page.Visible = false
	page.ClipsDescendants = false

	local PageList = Instance.new("UIListLayout", page)
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.Padding = UDim.new(0, 8)

	-- Nút Tab
	local tabBtn = Instance.new("TextButton", window.TabScroll)
	tabBtn.Size = UDim2.new(0, 95, 1, -6)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = (iconSymbol or "") .. " " .. tabName:upper()
	tabBtn.TextColor3 = window.Colors.TextSub
	tabBtn.TextSize = 10
	tabBtn.ZIndex = 2
	window:BindFont(tabBtn, "Bold")

	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			TweenService:Create(t.Button, TweenInfo.new(0.25), {
				TextColor3 = window.Colors.TextSub
			}):Play()
		end

		page.Visible = true
		page.Position = UDim2.new(0, 0, 0, 8)
		TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()

		window.LiquidTabIndicator.Visible = true
		TweenService:Create(window.LiquidTabIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, tabBtn.Position.X.Offset, 0, 3),
			Size = UDim2.new(0, tabBtn.AbsoluteSize.X, 1, -6)
		}):Play()

		TweenService:Create(tabBtn, TweenInfo.new(0.25), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	table.insert(window.Tabs, TabObj)

	task.defer(function()
		window.TabScroll.CanvasSize = UDim2.new(0, window.TabListLayout.AbsoluteContentSize.X + 10, 0, 0)
		if #window.Tabs == 1 then
			ActivateTab()
		end
	end)

	-- -------------------------------------------------------------
	-- DROPDOWN MENU CHUẨN (CÓ MENU SỔ XUỐNG XEM TRƯỚC VÀ CHỌN DỄ DÀNG)
	-- -------------------------------------------------------------
	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "DROPDOWN"
		local items = options.Items or {}
		local default = options.Default or items[1] or "Select..."
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 38)
		card.BackgroundColor3 = window.Colors.GlassCard
		card.BackgroundTransparency = window.Colors.GlassCardTransparency
		card.ClipsDescendants = false
		card.ZIndex = 10
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.88)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.42, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 10, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = dropText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local dropHeader = Instance.new("TextButton", card)
		dropHeader.Size = UDim2.new(0.54, 0, 0, 24)
		dropHeader.Position = UDim2.new(0.44, 0, 0.5, -12)
		dropHeader.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
		dropHeader.BackgroundTransparency = 0.3
		dropHeader.Text = "  " .. tostring(default) .. "   ▼"
		dropHeader.TextColor3 = window.Colors.AccentCyan
		dropHeader.TextSize = 9
		dropHeader.TextXAlignment = Enum.TextXAlignment.Center
		AddUICorner(dropHeader, 0, 6)
		AddUIStroke(dropHeader, window.Colors.BorderGlass, 1, 0.7)
		window:BindFont(dropHeader, "Bold")

		-- Khung Menu danh sách tùy chọn sổ xuống
		local dropList = Instance.new("ScrollingFrame", card)
		dropList.Size = UDim2.new(0.54, 0, 0, 0)
		dropList.Position = UDim2.new(0.44, 0, 1, 4)
		dropList.BackgroundColor3 = Color3.fromRGB(12, 14, 24)
		dropList.BackgroundTransparency = 0.05
		dropList.Visible = false
		dropList.ZIndex = 100
		dropList.ScrollBarThickness = 2
		dropList.ScrollBarImageColor3 = window.Colors.AccentCyan
		AddUICorner(dropList, 0, 6)
		AddUIStroke(dropList, window.Colors.Accent, 1, 0.4)

		local listLayout = Instance.new("UIListLayout", dropList)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local isOpen = false
		local function ToggleDrop()
			isOpen = not isOpen
			if isOpen then
				dropList.Visible = true
				local targetH = math.min(#items * 24, 100)
				dropList.CanvasSize = UDim2.new(0, 0, 0, #items * 24)
				TweenService:Create(dropList, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0.54, 0, 0, targetH)
				}):Play()
				dropHeader.Text = "  " .. tostring(default) .. "   ▲"
			else
				local tw = TweenService:Create(dropList, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					Size = UDim2.new(0.54, 0, 0, 0)
				})
				tw:Play()
				tw.Completed:Connect(function()
					if not isOpen then dropList.Visible = false end
				end)
				dropHeader.Text = "  " .. tostring(default) .. "   ▼"
			end
		end

		dropHeader.MouseButton1Click:Connect(ToggleDrop)

		for _, item in ipairs(items) do
			local itemBtn = Instance.new("TextButton", dropList)
			itemBtn.Size = UDim2.new(1, 0, 0, 24)
			itemBtn.BackgroundTransparency = 1
			itemBtn.Text = tostring(item)
			itemBtn.TextColor3 = window.Colors.TextMain
			itemBtn.TextSize = 9
			itemBtn.ZIndex = 101
			window:BindFont(itemBtn, "Main")

			itemBtn.MouseButton1Click:Connect(function()
				default = item
				dropHeader.Text = "  " .. tostring(default) .. "   ▼"
				ToggleDrop()
				callback(item)
			end)
		end
	end

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
		card.Size = UDim2.new(1, -6, 0, 44)
		card.BackgroundColor3 = window.Colors.GlassCard
		card.BackgroundTransparency = window.Colors.GlassCardTransparency
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.88)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.5, 0, 0, 18)
		titleLbl.Position = UDim2.new(0, 10, 0, 4)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = sliderText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		window:BindFont(titleLbl, "Bold")

		local valLbl = Instance.new("TextLabel", card)
		valLbl.Size = UDim2.new(0.25, 0, 0, 18)
		valLbl.Position = UDim2.new(0.5, 0, 0, 4)
		valLbl.BackgroundTransparency = 1
		valLbl.Text = "VAL: " .. tostring(default)
		valLbl.TextColor3 = window.Colors.AccentCyan
		valLbl.TextSize = 10
		window:BindFont(valLbl, "Bold")

		local resetBtn = Instance.new("TextButton", card)
		resetBtn.Size = UDim2.new(0, 44, 0, 16)
		resetBtn.Position = UDim2.new(1, -50, 0, 4)
		resetBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		resetBtn.BackgroundTransparency = 0.5
		resetBtn.Text = "RESET"
		resetBtn.TextColor3 = window.Colors.TextSub
		resetBtn.TextSize = 8
		AddUICorner(resetBtn, 0, 4)
		AddUIStroke(resetBtn, window.Colors.Accent, 1, 0.5)

		local sliderBar = Instance.new("Frame", card)
		sliderBar.Size = UDim2.new(1, -20, 0, 6)
		sliderBar.Position = UDim2.new(0, 10, 0, 28)
		sliderBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		sliderBar.BackgroundTransparency = 0.5
		AddUICorner(sliderBar, 0, 3)

		local sliderFill = Instance.new("Frame", sliderBar)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.Accent
		AddUICorner(sliderFill, 0, 3)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLbl.Text = "VAL: " .. tostring(value)
			
			TweenService:Create(sliderFill, TweenInfo.new(0.08), {
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
	-- TOGGLE COMPONENT
	-- -------------------------------------------------------------
	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "TOGGLE"
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 38)
		card.BackgroundColor3 = window.Colors.GlassCard
		card.BackgroundTransparency = window.Colors.GlassCardTransparency
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.88)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
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
		switchBtn.BackgroundColor3 = defaultState and window.Colors.Accent or Color3.fromRGB(0, 0, 0)
		switchBtn.BackgroundTransparency = defaultState and 0 or 0.5
		switchBtn.Text = ""
		AddUICorner(switchBtn, 0, 10)

		local dot = Instance.new("Frame", switchBtn)
		dot.Size = UDim2.new(0, 14, 0, 14)
		dot.Position = UDim2.new(0, defaultState and 23 or 3, 0, 3)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		AddUICorner(dot, 0, 7)

		local state = defaultState
		switchBtn.MouseButton1Click:Connect(function()
			state = not state
			TweenService:Create(switchBtn, TweenInfo.new(0.22), {
				BackgroundColor3 = state and window.Colors.Accent or Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = state and 0 or 0.5
			}):Play()
			TweenService:Create(dot, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, state and 23 or 3, 0, 3)
			}):Play()
			callback(state)
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
		card.Size = UDim2.new(1, -6, 0, 38)
		card.BackgroundColor3 = window.Colors.GlassCard
		card.BackgroundTransparency = window.Colors.GlassCardTransparency
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.88)

		local btn = Instance.new("TextButton", card)
		btn.Size = UDim2.new(1, -12, 1, -12)
		btn.Position = UDim2.new(0, 6, 0, 6)
		btn.BackgroundColor3 = window.Colors.Accent
		btn.Text = btnText:upper()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 10
		AddUICorner(btn, 0, 6)
		window:BindFont(btn, "Bold")

		btn.MouseButton1Click:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, -18, 1, -18), Position = UDim2.new(0, 9, 0, 9) }):Play()
			task.wait(0.08)
			TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(1, -12, 1, -12), Position = UDim2.new(0, 6, 0, 6) }):Play()
			callback()
		end)
	end

	return TabObj
end

return PitayaUI
