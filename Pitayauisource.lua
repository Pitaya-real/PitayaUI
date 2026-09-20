local PitayaUI = {}
PitayaUI.__index = PitayaUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- =================================================================
-- HÀM TRỢ GIÚP GIAO DIỆN
-- =================================================================
local function AddUICorner(parent, radiusScale, radiusOffset)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(radiusScale or 0, radiusOffset or 8)
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
-- TẠO CỬA SỔ CHÍNH (PITAYA GLASS STYLE)
-- =================================================================
function PitayaUI:CreateWindow(config)
	config = config or {}
	local WindowObj = setmetatable({}, PitayaUI)
	WindowObj.TitleText = config.Title or "SCRIPT MASTER HUB - PITAYA EDITION v3.5"
	WindowObj.LogoId = config.Logo or "rbxassetid://10723321812" -- Asset Dragonfruit tách nền
	WindowObj.Tabs = {}

	-- Màu sắc chuẩn Theme Pitaya Light Glass
	WindowObj.Colors = {
		WindowBg = Color3.fromRGB(232, 236, 242),
		TopbarBg = Color3.fromRGB(240, 243, 248),
		TabBarBg = Color3.fromRGB(28, 32, 42),
		CardBg = Color3.fromRGB(255, 255, 255),
		CardTransparency = 0.25,
		TextMain = Color3.fromRGB(20, 25, 35),
		TextSub = Color3.fromRGB(100, 110, 125),
		AccentPink = Color3.fromRGB(245, 65, 125),
		AccentCyan = Color3.fromRGB(0, 220, 230),
		DarkBtnBg = Color3.fromRGB(32, 36, 48)
	}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "PitayaMasterHub_UI"
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game:GetService("CoreGui")
	else
		pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
		if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	end
	WindowObj.ScreenGui = ScreenGui

	-- Khung chính cửa sổ
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0, 520, 0, 360)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.BackgroundColor3 = WindowObj.Colors.WindowBg
	MainFrame.BackgroundTransparency = 0.05
	MainFrame.ClipsDescendants = false
	AddUICorner(MainFrame, 0, 14)
	AddUIStroke(MainFrame, Color3.fromRGB(255, 255, 255), 2, 0.2)

	WindowObj.MainFrame = MainFrame

	-- TOPBAR (Thanh tiêu đề + Nút Đóng/Thu nhỏ)
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 38)
	Topbar.BackgroundTransparency = 1

	-- Kéo thả Cửa sổ
	local winDragging, winDragStart, winStartPos
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

	-- Logo Pitaya (Không nền)
	local LogoImg = Instance.new("ImageLabel", Topbar)
	LogoImg.Size = UDim2.new(0, 24, 0, 24)
	LogoImg.Position = UDim2.new(0, 12, 0, 7)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = WindowObj.LogoId

	-- Tiêu đề Window
	local TitleLbl = Instance.new("TextLabel", Topbar)
	TitleLbl.Size = UDim2.new(1, -110, 1, 0)
	TitleLbl.Position = UDim2.new(0, 42, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = WindowObj.TitleText
	TitleLbl.TextColor3 = WindowObj.Colors.TextMain
	TitleLbl.TextSize = 13
	TitleLbl.Font = Enum.Font.FredokaOne
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

	-- Nút Thu nhỏ (-) và Đóng (X)
	local ControlsContainer = Instance.new("Frame", Topbar)
	ControlsContainer.Size = UDim2.new(0, 50, 1, 0)
	ControlsContainer.Position = UDim2.new(1, -55, 0, 0)
	ControlsContainer.BackgroundTransparency = 1

	local MinimizeBtn = Instance.new("TextButton", ControlsContainer)
	MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
	MinimizeBtn.Position = UDim2.new(0, 0, 0.5, -10)
	MinimizeBtn.BackgroundTransparency = 1
	MinimizeBtn.Text = "─"
	MinimizeBtn.TextColor3 = WindowObj.Colors.TextMain
	MinimizeBtn.TextSize = 12
	MinimizeBtn.Font = Enum.Font.GothamBold

	local CloseBtn = Instance.new("TextButton", ControlsContainer)
	CloseBtn.Size = UDim2.new(0, 20, 0, 20)
	CloseBtn.Position = UDim2.new(0, 25, 0.5, -10)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "✕"
	CloseBtn.TextColor3 = WindowObj.Colors.TextMain
	CloseBtn.TextSize = 13
	CloseBtn.Font = Enum.Font.GothamBold

	local isOpen = true
	local function ToggleUI()
		isOpen = not isOpen
		MainFrame.Visible = isOpen
	end

	MinimizeBtn.MouseButton1Click:Connect(ToggleUI)
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	-- -------------------------------------------------------------
	-- THANH TAB NGANG (ĐÃ SỬA LỖI VỆT CẢNH VÀ CĂN CHỈNH)
	-- -------------------------------------------------------------
	local TabBarContainer = Instance.new("Frame", MainFrame)
	TabBarContainer.Name = "TabBarContainer"
	TabBarContainer.Size = UDim2.new(1, -20, 0, 42)
	TabBarContainer.Position = UDim2.new(0, 10, 0, 38)
	TabBarContainer.BackgroundColor3 = WindowObj.Colors.TabBarBg
	AddUICorner(TabBarContainer, 0, 10)

	local TabScroll = Instance.new("ScrollingFrame", TabBarContainer)
	TabScroll.Size = UDim2.new(1, -10, 1, 0)
	TabScroll.Position = UDim2.new(0, 5, 0, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 0
	TabScroll.ClipsDescendants = true

	local TabListLayout = Instance.new("UIListLayout", TabScroll)
	TabListLayout.FillDirection = Enum.FillDirection.Horizontal
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 4)
	TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	-- Thanh chỉ báo gạch chân màu Cyan (Active Tab Indicator)
	local ActiveLineIndicator = Instance.new("Frame", TabScroll)
	ActiveLineIndicator.Name = "ActiveLineIndicator"
	ActiveLineIndicator.Size = UDim2.new(0, 40, 0, 3)
	ActiveLineIndicator.Position = UDim2.new(0, 0, 1, -5)
	ActiveLineIndicator.BackgroundColor3 = WindowObj.Colors.AccentCyan
	ActiveLineIndicator.BorderSizePixel = 0
	ActiveLineIndicator.Visible = false
	ActiveLineIndicator.ZIndex = 5
	AddUICorner(ActiveLineIndicator, 0, 2)

	WindowObj.ActiveLineIndicator = ActiveLineIndicator

	-- -------------------------------------------------------------
	-- NỘI DUNG TABS
	-- -------------------------------------------------------------
	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -20, 1, -90)
	ContentArea.Position = UDim2.new(0, 10, 0, 85)
	ContentArea.BackgroundTransparency = 1
	ContentArea.ClipsDescendants = false

	WindowObj.ContentArea = ContentArea
	WindowObj.TabScroll = TabScroll
	WindowObj.TabListLayout = TabListLayout

	return WindowObj
end

-- =================================================================
-- TẠO TAB MỚI
-- =================================================================
function PitayaUI:CreateTab(tabName, iconSymbol)
	local TabObj = {}
	local window = self

	local page = Instance.new("ScrollingFrame", window.ContentArea)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = window.Colors.AccentCyan
	page.Visible = false
	page.ClipsDescendants = false

	local PageList = Instance.new("UIListLayout", page)
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.Padding = UDim.new(0, 8)

	-- Nút Tab dạng Icon trên - Chữ dưới
	local tabBtn = Instance.new("TextButton", window.TabScroll)
	tabBtn.Size = UDim2.new(0, 75, 1, 0)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = ""

	local iconLbl = Instance.new("TextLabel", tabBtn)
	iconLbl.Size = UDim2.new(1, 0, 0, 18)
	iconLbl.Position = UDim2.new(0, 0, 0, 4)
	iconLbl.BackgroundTransparency = 1
	iconLbl.Text = iconSymbol or "★"
	iconLbl.TextColor3 = window.Colors.TextSub
	iconLbl.TextSize = 13
	iconLbl.Font = Enum.Font.GothamBold

	local textLbl = Instance.new("TextLabel", tabBtn)
	textLbl.Size = UDim2.new(1, 0, 0, 14)
	textLbl.Position = UDim2.new(0, 0, 0, 22)
	textLbl.BackgroundTransparency = 1
	textLbl.Text = tabName:upper()
	textLbl.TextColor3 = window.Colors.TextSub
	textLbl.TextSize = 9
	textLbl.Font = Enum.Font.GothamBold

	local function ActivateTab()
		for _, t in ipairs(window.Tabs) do
			t.Page.Visible = false
			TweenService:Create(t.IconLbl, TweenInfo.new(0.2), { TextColor3 = window.Colors.TextSub }):Play()
			TweenService:Create(t.TextLbl, TweenInfo.new(0.2), { TextColor3 = window.Colors.TextSub }):Play()
		end

		page.Visible = true
		window.ActiveLineIndicator.Visible = true

		-- Cập nhật thanh trượt Cyan ngay bên dưới Tab active chuẩn xác
		local targetX = tabBtn.AbsolutePosition.X - window.TabScroll.AbsolutePosition.X + window.TabScroll.CanvasPosition.X
		TweenService:Create(window.ActiveLineIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, targetX + 10, 1, -5),
			Size = UDim2.new(0, tabBtn.AbsoluteSize.X - 20, 0, 3)
		}):Play()

		TweenService:Create(iconLbl, TweenInfo.new(0.2), { TextColor3 = window.Colors.AccentPink }):Play()
		TweenService:Create(textLbl, TweenInfo.new(0.2), { TextColor3 = window.Colors.AccentPink }):Play()
	end

	tabBtn.MouseButton1Click:Connect(ActivateTab)

	TabObj.Page = page
	TabObj.Button = tabBtn
	TabObj.IconLbl = iconLbl
	TabObj.TextLbl = textLbl

	table.insert(window.Tabs, TabObj)

	task.defer(function()
		window.TabScroll.CanvasSize = UDim2.new(0, window.TabListLayout.AbsoluteContentSize.X + 10, 0, 0)
		if #window.Tabs == 1 then
			ActivateTab()
		end
	end)

	-- -------------------------------------------------------------
	-- COMPONENT 1: SLIDER FULL CARD (KÈM NÚT RESET)
	-- -------------------------------------------------------------
	function TabObj:AddSlider(options)
		options = options or {}
		local sliderText = options.Text or "SLIDER"
		local min = options.Min or 0
		local max = options.Max or 100
		local default = options.Default or min
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 48)
		card.BackgroundColor3 = window.Colors.CardBg
		card.BackgroundTransparency = window.Colors.CardTransparency
		AddUICorner(card, 0, 10)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.5)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.5, 0, 0, 20)
		titleLbl.Position = UDim2.new(0, 12, 0, 6)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = sliderText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 11
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left

		local valLbl = Instance.new("TextLabel", card)
		valLbl.Size = UDim2.new(0.3, 0, 0, 20)
		valLbl.Position = UDim2.new(0.48, 0, 0, 6)
		valLbl.BackgroundTransparency = 1
		valLbl.Text = "VALUE: " .. tostring(default)
		valLbl.TextColor3 = window.Colors.TextMain
		valLbl.TextSize = 10
		valLbl.Font = Enum.Font.GothamBold

		local resetBtn = Instance.new("TextButton", card)
		resetBtn.Size = UDim2.new(0, 56, 0, 22)
		resetBtn.Position = UDim2.new(1, -66, 0, 5)
		resetBtn.BackgroundColor3 = window.Colors.AccentPink
		resetBtn.Text = "RESET"
		resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		resetBtn.TextSize = 9
		resetBtn.Font = Enum.Font.GothamBold
		AddUICorner(resetBtn, 0, 6)

		local sliderTrack = Instance.new("Frame", card)
		sliderTrack.Size = UDim2.new(1, -24, 0, 5)
		sliderTrack.Position = UDim2.new(0, 12, 0, 32)
		sliderTrack.BackgroundColor3 = Color3.fromRGB(180, 190, 200)
		AddUICorner(sliderTrack, 0, 3)

		local sliderFill = Instance.new("Frame", sliderTrack)
		sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
		sliderFill.BackgroundColor3 = window.Colors.AccentPink
		AddUICorner(sliderFill, 0, 3)

		local sliderThumb = Instance.new("Frame", sliderFill)
		sliderThumb.Size = UDim2.new(0, 12, 0, 12)
		sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
		sliderThumb.Position = UDim2.new(1, 0, 0.5, 0)
		sliderThumb.BackgroundColor3 = window.Colors.AccentCyan
		AddUICorner(sliderThumb, 1, 0)

		local dragging = false
		local function UpdateSlider(input)
			local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * pos)
			valLbl.Text = "VALUE: " .. tostring(value)
			sliderFill.Size = UDim2.new(pos, 0, 1, 0)
			callback(value)
		end

		sliderTrack.InputBegan:Connect(function(input)
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
			valLbl.Text = "VALUE: " .. tostring(default)
			sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			callback(default)
		end)
	end

	-- -------------------------------------------------------------
	-- COMPONENT 2: TOGGLE CARD
	-- -------------------------------------------------------------
	function TabObj:AddToggle(options)
		options = options or {}
		local toggleText = options.Text or "TOGGLE"
		local defaultState = options.Default or false
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 38)
		card.BackgroundColor3 = window.Colors.CardBg
		card.BackgroundTransparency = window.Colors.CardTransparency
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.5)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 12, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = toggleText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left

		local switchBtn = Instance.new("TextButton", card)
		switchBtn.Size = UDim2.new(0, 42, 0, 20)
		switchBtn.Position = UDim2.new(1, -50, 0.5, -10)
		switchBtn.BackgroundColor3 = defaultState and window.Colors.AccentCyan or Color3.fromRGB(120, 130, 145)
		switchBtn.Text = ""
		AddUICorner(switchBtn, 1, 0)

		local dot = Instance.new("Frame", switchBtn)
		dot.Size = UDim2.new(0, 14, 0, 14)
		dot.Position = UDim2.new(0, defaultState and 24 or 4, 0, 3)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		AddUICorner(dot, 1, 0)

		local state = defaultState
		switchBtn.MouseButton1Click:Connect(function()
			state = not state
			TweenService:Create(switchBtn, TweenInfo.new(0.2), {
				BackgroundColor3 = state and window.Colors.AccentCyan or Color3.fromRGB(120, 130, 145)
			}):Play()
			TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(0, state and 24 or 4, 0, 3)
			}):Play()
			callback(state)
		end)
	end

	-- -------------------------------------------------------------
	-- COMPONENT 3: BUTTON CARD (NÚT BẤM CƠ BẢN)
	-- -------------------------------------------------------------
	function TabObj:AddButton(options)
		options = options or {}
		local btnText = options.Text or "CLICK BUTTON"
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 38)
		card.BackgroundColor3 = window.Colors.CardBg
		card.BackgroundTransparency = window.Colors.CardTransparency
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.5)

		local btn = Instance.new("TextButton", card)
		btn.Size = UDim2.new(1, -12, 1, -10)
		btn.Position = UDim2.new(0, 6, 0, 5)
		btn.BackgroundColor3 = window.Colors.AccentPink
		btn.Text = btnText:upper()
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 10
		btn.Font = Enum.Font.GothamBold
		AddUICorner(btn, 0, 6)

		btn.MouseButton1Click:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.08), { Size = UDim2.new(1, -18, 1, -14), Position = UDim2.new(0, 9, 0, 7) }):Play()
			task.wait(0.08)
			TweenService:Create(btn, TweenInfo.new(0.1), { Size = UDim2.new(1, -12, 1, -10), Position = UDim2.new(0, 6, 0, 5) }):Play()
			callback()
		end)
	end

	-- -------------------------------------------------------------
	-- COMPONENT 4: DROPDOWN MENU + NÚT BẤM (GIỐNG MẪU TELEPORT TO)
	-- -------------------------------------------------------------
	function TabObj:AddDropdown(options)
		options = options or {}
		local dropText = options.Text or "TELEPORT TO:"
		local items = options.Items or {}
		local default = options.Default or items[1] or "Select..."
		local hasActionButton = options.ActionButton ~= false
		local actionText = options.ActionText or "GO"
		local callback = options.Callback or function() end

		local card = Instance.new("Frame", page)
		card.Size = UDim2.new(1, -6, 0, 48)
		card.BackgroundColor3 = window.Colors.CardBg
		card.BackgroundTransparency = window.Colors.CardTransparency
		card.ZIndex = 10
		AddUICorner(card, 0, 8)
		AddUIStroke(card, Color3.fromRGB(255, 255, 255), 1, 0.5)

		local titleLbl = Instance.new("TextLabel", card)
		titleLbl.Size = UDim2.new(0.38, 0, 1, 0)
		titleLbl.Position = UDim2.new(0, 12, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = dropText:upper()
		titleLbl.TextColor3 = window.Colors.TextMain
		titleLbl.TextSize = 10
		titleLbl.Font = Enum.Font.GothamBold
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left

		local dropHeader = Instance.new("TextButton", card)
		dropHeader.Size = UDim2.new(hasActionButton and 0.42 or 0.56, 0, 0, 26)
		dropHeader.Position = UDim2.new(0.38, 0, 0.5, -13)
		dropHeader.BackgroundColor3 = window.Colors.DarkBtnBg
		dropHeader.Text = tostring(default) .. "  ▼"
		dropHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
		dropHeader.TextSize = 9
		dropHeader.Font = Enum.Font.GothamBold
		AddUICorner(dropHeader, 0, 6)

		local actionBtn
		if hasActionButton then
			actionBtn = Instance.new("TextButton", card)
			actionBtn.Size = UDim2.new(0, 48, 0, 26)
			actionBtn.Position = UDim2.new(1, -56, 0.5, -13)
			actionBtn.BackgroundColor3 = window.Colors.AccentCyan
			actionBtn.Text = actionText
			actionBtn.TextColor3 = window.Colors.TextMain
			actionBtn.TextSize = 10
			actionBtn.Font = Enum.Font.GothamBold
			AddUICorner(actionBtn, 0, 6)
		end

		-- Menu danh sách xổ xuống
		local dropList = Instance.new("ScrollingFrame", card)
		dropList.Size = UDim2.new(hasActionButton and 0.42 or 0.56, 0, 0, 0)
		dropList.Position = UDim2.new(0.38, 0, 1, 4)
		dropList.BackgroundColor3 = window.Colors.DarkBtnBg
		dropList.Visible = false
		dropList.ZIndex = 100
		dropList.ScrollBarThickness = 2
		dropList.ScrollBarImageColor3 = window.Colors.AccentCyan
		AddUICorner(dropList, 0, 6)

		local listLayout = Instance.new("UIListLayout", dropList)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local isOpen = false
		local selectedValue = default

		local function ToggleDrop()
			isOpen = not isOpen
			if isOpen then
				dropList.Visible = true
				local targetH = math.min(#items * 24, 90)
				dropList.CanvasSize = UDim2.new(0, 0, 0, #items * 24)
				TweenService:Create(dropList, TweenInfo.new(0.2), { Size = UDim2.new(hasActionButton and 0.42 or 0.56, 0, 0, targetH) }):Play()
				dropHeader.Text = tostring(selectedValue) .. "  ▲"
			else
				local tw = TweenService:Create(dropList, TweenInfo.new(0.15), { Size = UDim2.new(hasActionButton and 0.42 or 0.56, 0, 0, 0) })
				tw:Play()
				tw.Completed:Connect(function()
					if not isOpen then dropList.Visible = false end
				end)
				dropHeader.Text = tostring(selectedValue) .. "  ▼"
			end
		end

		dropHeader.MouseButton1Click:Connect(ToggleDrop)

		for _, item in ipairs(items) do
			local itemBtn = Instance.new("TextButton", dropList)
			itemBtn.Size = UDim2.new(1, 0, 0, 24)
			itemBtn.BackgroundTransparency = 1
			itemBtn.Text = tostring(item)
			itemBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
			itemBtn.TextSize = 9
			itemBtn.Font = Enum.Font.GothamMedium
			itemBtn.ZIndex = 101

			itemBtn.MouseButton1Click:Connect(function()
				selectedValue = item
				dropHeader.Text = tostring(selectedValue) .. "  ▼"
				ToggleDrop()
				if not hasActionButton then callback(selectedValue) end
			end)
		end

		if actionBtn then
			actionBtn.MouseButton1Click:Connect(function()
				callback(selectedValue)
			end)
		end
	end

	return TabObj
end

return PitayaUI
