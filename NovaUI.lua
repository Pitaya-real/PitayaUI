--[[
	NovaUI v2 - thư viện UI kính mờ cho Roblox, cách dùng giống Fluent
	Loại script: ModuleScript (đặt tên "NovaUI" trong ReplicatedStorage)
	GUI được đặt trong PlayerGui của người chơi.

	local NovaUI = require(game.ReplicatedStorage.NovaUI)
	local Window = NovaUI:CreateWindow({ Title = "...", SubTitle = "...", Logo = "", FloatingIcon = "" })
	local Tabs = { Main = Window:AddTab({ Title = "Chính" }) }
	local Options = NovaUI.Options

	Tabs.Main:AddToggle("Id", { Title = "...", Description = "...", Default = false, Callback = function(v) end })
	Options.Id:OnChanged(function(v) end)
	Options.Id:SetValue(true)
	print(Options.Id.Value)
	NovaUI:Notify({ Title = "...", Content = "...", Duration = 3 })
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")

local NovaUI = {}
NovaUI.Version = "2.0"
NovaUI.Options = {}

local Window = {}
Window.__index = Window
local Tab = {}
Tab.__index = Tab

local WHITE = Color3.new(1, 1, 1)
local DARK = Color3.fromRGB(21, 16, 31)
local OFF = Color3.fromRGB(85, 80, 105)
local GLASS = Color3.fromRGB(24, 18, 46)

---------------------------------------------------------------------
-- Hàm phụ
---------------------------------------------------------------------

local function tween(inst, props, time, style, direction)
	local t = TweenService:Create(
		inst,
		TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function create(class, props)
	local inst = Instance.new(class)
	local parent = props.Parent
	for k, v in pairs(props) do
		if k ~= "Parent" then
			inst[k] = v
		end
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end

local function corner(inst, radius)
	return create("UICorner", { CornerRadius = radius or UDim.new(0, 8), Parent = inst })
end

local function stroke(inst, color, transparency, thickness)
	return create("UIStroke", {
		Color = color or WHITE,
		Transparency = transparency or 0.8,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = inst,
	})
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function toScreen(v3)
	local inset = GuiService:GetGuiInset()
	return Vector2.new(v3.X + inset.X, v3.Y + inset.Y)
end

local function follow(input, onMove, onEnd)
	local isTouch = input.UserInputType == Enum.UserInputType.Touch
	local moveConn, endConn
	moveConn = UserInputService.InputChanged:Connect(function(i)
		if (isTouch and i == input) or (not isTouch and i.UserInputType == Enum.UserInputType.MouseMovement) then
			onMove(i.Position)
		end
	end)
	endConn = input.Changed:Connect(function()
		if input.UserInputState == Enum.UserInputState.End then
			moveConn:Disconnect()
			endConn:Disconnect()
			if onEnd then
				onEnd()
			end
		end
	end)
end

local function toVec2(v, fallback)
	if typeof(v) == "Vector2" then
		return v
	elseif typeof(v) == "UDim2" then
		return Vector2.new(v.X.Offset, v.Y.Offset)
	end
	return fallback
end

local function toKeyCode(k)
	if typeof(k) == "EnumItem" then
		return k
	end
	if type(k) == "string" then
		local ok, res = pcall(function()
			return Enum.KeyCode[k]
		end)
		if ok and res then
			return res
		end
	end
	return Enum.KeyCode.Unknown
end

local function toAsset(v)
	if type(v) == "number" then
		return "rbxassetid://" .. v
	elseif type(v) == "string" and v ~= "" then
		if tonumber(v) then
			return "rbxassetid://" .. v
		elseif v:find("rbxasset") or v:find("http") then
			return v
		end
	end
	return ""
end

local function args(id, opts)
	if type(id) == "table" then
		return nil, id
	end
	return id, opts or {}
end

---------------------------------------------------------------------
-- Tạo cửa sổ
---------------------------------------------------------------------

function NovaUI:CreateWindow(config)
	config = config or {}
	local cfg = {
		Name = config.Title or config.Name or "NovaUI",
		Subtitle = config.SubTitle or config.Subtitle or "",
		Logo = toAsset(config.Logo),
		FloatingIcon = toAsset(config.FloatingIcon),
		Accent = config.Accent or Color3.fromRGB(167, 139, 250),
		ToggleKey = config.MinimizeKey or config.ToggleKey or Enum.KeyCode.M,
		Transparency = config.Transparency or 0.3,
		BlurSize = config.BlurSize or 16,
		FloatingButton = config.FloatingButton ~= false,
		StartOpen = config.StartOpen ~= false,
		Font = config.Font or Enum.Font.BuilderSans,
		FontMedium = config.FontMedium or Enum.Font.BuilderSansMedium,
		Version = config.Version or "v2.0",
		Parent = config.Parent,
	}
	local blurOn = true
	if config.Acrylic ~= nil then
		blurOn = config.Acrylic
	elseif config.Blur ~= nil then
		blurOn = config.Blur
	end
	cfg.Blur = blurOn

	local touch = UserInputService.TouchEnabled
	cfg.Size = toVec2(config.Size, if touch then Vector2.new(520, 360) else Vector2.new(620, 420))
	cfg.MinSize = toVec2(config.MinSize, if touch then Vector2.new(400, 280) else Vector2.new(460, 320))

	local self = setmetatable({}, Window)
	self.Config = cfg
	self.Options = NovaUI.Options
	self.Accent = cfg.Accent
	self.LW, self.LH = cfg.Size.X, cfg.Size.Y
	self.MinSize = cfg.MinSize
	self.Scale = 1
	self.Pos = nil
	self.FabPos = nil
	self.ToggleKey = cfg.ToggleKey
	self.IsOpen = false
	self.Tabs = {}
	self.ActiveTab = nil
	self._accent = {}
	self._keybinds = {}
	self._conns = {}
	self._binding = false
	self._notifyOrder = 0
	NovaUI._window = self

	local parent = cfg.Parent or Players.LocalPlayer:WaitForChild("PlayerGui")
	local guiName = "NovaUI_" .. cfg.Name
	local old = parent:FindFirstChild(guiName)
	if old then
		old:Destroy()
	end
	local gui = create("ScreenGui", {
		Name = guiName,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parent,
	})
	self.Gui = gui

	local holder = create("Frame", {
		Name = "Window",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(self.LW, self.LH),
		Visible = false,
		Parent = gui,
	})
	self.Holder = holder

	local main = create("CanvasGroup", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(self.LW, self.LH),
		BackgroundColor3 = GLASS,
		BackgroundTransparency = cfg.Transparency,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = holder,
	})
	corner(main, UDim.new(0, 18))
	stroke(main, WHITE, 0.72, 1)
	self.Main = main
	self.UIScale = create("UIScale", { Scale = 1, Parent = main })

	local sheen = create("Frame", {
		Name = "Sheen",
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = main,
	})
	corner(sheen, UDim.new(0, 18))
	create("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.9),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Parent = sheen,
	})

	-- thanh tiêu đề
	local title = create("Frame", {
		Name = "TitleBar",
		Position = UDim2.fromOffset(12, 12),
		Size = UDim2.new(1, -24, 0, 46),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Parent = main,
	})
	corner(title, UDim.new(0, 12))

	local logo = create("Frame", {
		Name = "Logo",
		Position = UDim2.fromOffset(10, 8),
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = self.Accent,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = title,
	})
	corner(logo, UDim.new(0, 8))
	self._logo = logo
	self._logoText = create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Font = cfg.FontMedium,
		TextSize = 16,
		Text = string.upper(string.sub(cfg.Name, 1, 1)),
		TextColor3 = DARK,
		Parent = logo,
	})
	self._logoImage = create("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Crop,
		Visible = false,
		Parent = logo,
	})
	create("TextLabel", {
		Name = "Name",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(50, 6),
		Size = UDim2.new(1, -110, 0, 20),
		Font = cfg.FontMedium,
		TextSize = 15,
		Text = cfg.Name,
		TextColor3 = WHITE,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = title,
	})
	create("TextLabel", {
		Name = "Subtitle",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(50, 25),
		Size = UDim2.new(1, -110, 0, 16),
		Font = cfg.Font,
		TextSize = 12,
		Text = cfg.Subtitle,
		TextColor3 = WHITE,
		TextTransparency = 0.35,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = title,
	})
	local closeBtn = create("TextButton", {
		Name = "Close",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 1,
		Font = cfg.FontMedium,
		TextSize = 15,
		Text = "X",
		TextColor3 = WHITE,
		Parent = title,
	})
	corner(closeBtn, UDim.new(0, 8))
	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, { BackgroundTransparency = 0.85 }, 0.15)
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, { BackgroundTransparency = 1 }, 0.15)
	end)
	closeBtn.MouseButton1Click:Connect(function()
		self:Close()
	end)

	-- thân: tab bên trái, trang bên phải
	local body = create("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 68),
		Size = UDim2.new(1, -24, 1, -118),
		Parent = main,
	})
	local rail = create("ScrollingFrame", {
		Name = "Rail",
		Size = UDim2.new(0, 150, 1, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		Parent = body,
	})
	corner(rail, UDim.new(0, 12))
	self._rail = rail

	local indicator = create("Frame", {
		Name = "Indicator",
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = self.Accent,
		BackgroundTransparency = 0.78,
		BorderSizePixel = 0,
		Visible = false,
		Parent = rail,
	})
	corner(indicator, UDim.new(0, 8))
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(0, 3, 1, -14),
		BackgroundColor3 = self.Accent,
		BorderSizePixel = 0,
		Parent = indicator,
	})
	corner(bar, UDim.new(0, 2))
	self._indicator = indicator
	self:_onAccent(function()
		indicator.BackgroundColor3 = self.Accent
		bar.BackgroundColor3 = self.Accent
	end)

	self._pages = create("Frame", {
		Name = "Pages",
		Position = UDim2.fromOffset(160, 0),
		Size = UDim2.new(1, -160, 1, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = body,
	})
	corner(self._pages, UDim.new(0, 12))

	-- thanh trạng thái
	local status = create("Frame", {
		Name = "Status",
		Position = UDim2.new(0, 12, 1, -40),
		Size = UDim2.new(1, -24, 0, 28),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Parent = main,
	})
	corner(status, UDim.new(0, 10))
	self._footer = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -80, 1, 0),
		Font = cfg.Font,
		TextSize = 12,
		TextColor3 = WHITE,
		TextTransparency = 0.35,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = status,
	})
	create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -36, 0, 0),
		Size = UDim2.new(0, 50, 1, 0),
		Font = cfg.Font,
		TextSize = 12,
		Text = cfg.Version,
		TextColor3 = WHITE,
		TextTransparency = 0.35,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = status,
	})

	-- tay nắm kéo giãn ở góc dưới bên phải
	local grip = create("TextButton", {
		Name = "Resize",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -4, 1, -4),
		Size = UDim2.fromOffset(26, 26),
		ZIndex = 20,
		Parent = main,
	})
	for _, spec in ipairs({ { 14, 0.58 }, { 8, 0.8 } }) do
		create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(spec[2], spec[2]),
			Size = UDim2.fromOffset(spec[1], 2),
			Rotation = -45,
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			ZIndex = 21,
			Parent = grip,
		})
	end

	title.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		local start = Vector2.new(input.Position.X, input.Position.Y)
		local origin = self.Pos
		follow(input, function(pos)
			self.Pos = origin + (Vector2.new(pos.X, pos.Y) - start)
			self:_layout(true)
		end)
	end)
	grip.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		local start = Vector2.new(input.Position.X, input.Position.Y)
		local lw, lh = self.LW, self.LH
		follow(input, function(pos)
			local d = (Vector2.new(pos.X, pos.Y) - start) / self.Scale
			self.LW, self.LH = lw + d.X, lh + d.Y
			self:_layout(true)
		end)
	end)

	-- nơi hiện thông báo (góc dưới bên phải, hiện cả khi menu đang đóng)
	self._notifyHolder = create("Frame", {
		Name = "Notifications",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.new(0, 300, 1, -32),
		ZIndex = 100,
		Parent = gui,
	})
	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Parent = self._notifyHolder,
	})

	-- nút nổi
	if cfg.FloatingButton then
		local fab = create("TextButton", {
			Name = "Floating",
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = self.Accent,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(54, 54),
			ZIndex = 50,
			Parent = gui,
		})
		corner(fab, UDim.new(1, 0))
		stroke(fab, WHITE, 0.45, 1)
		self._fab = fab
		self._fabText = create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Font = cfg.FontMedium,
			TextSize = 22,
			Text = string.upper(string.sub(cfg.Name, 1, 1)),
			TextColor3 = DARK,
			ZIndex = 51,
			Parent = fab,
		})
		self._fabImage = create("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			Visible = false,
			ZIndex = 52,
			Parent = fab,
		})
		corner(self._fabImage, UDim.new(1, 0))

		fab.InputBegan:Connect(function(input)
			if not isPress(input) then
				return
			end
			local start = Vector2.new(input.Position.X, input.Position.Y)
			local origin = self.FabPos
			local moved = false
			follow(input, function(pos)
				local d = Vector2.new(pos.X, pos.Y) - start
				if not moved and d.Magnitude > 6 then
					moved = true
				end
				if moved then
					self.FabPos = origin + d
					self:_layoutFab()
				end
			end, function()
				if not moved then
					self:Toggle()
				end
			end)
		end)
	end

	if cfg.Blur then
		self._blur = Lighting:FindFirstChild("NovaUIBlur") or create("BlurEffect", {
			Name = "NovaUIBlur",
			Size = 0,
			Parent = Lighting,
		})
	end

	table.insert(
		self._conns,
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed or self._binding or input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if input.KeyCode == self.ToggleKey then
				self:Toggle()
				return
			end
			for _, kb in ipairs(self._keybinds) do
				if kb.get() == input.KeyCode then
					task.spawn(kb.press)
				end
			end
		end)
	)
	table.insert(
		self._conns,
		gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			self:_layout(false)
		end)
	)

	self:SetMinimizeKey(self.ToggleKey)
	self:SetLogo(cfg.Logo)
	self:SetFloatingIcon(cfg.FloatingIcon)
	self:_layout(false)
	if cfg.StartOpen then
		task.defer(function()
			self:Open()
		end)
	end
	return self
end

---------------------------------------------------------------------
-- Bố cục và tự căn theo thiết bị
---------------------------------------------------------------------

function Window:_viewport()
	local s = self.Gui.AbsoluteSize
	if s.X < 1 or s.Y < 1 then
		local cam = workspace.CurrentCamera
		return if cam then cam.ViewportSize else Vector2.new(1280, 720)
	end
	return s
end

function Window:_computeScale()
	local vp = self:_viewport()
	local minScale = if UserInputService.TouchEnabled then 0.75 else 0.6
	local s = math.clamp(math.min(vp.X / 1280, vp.Y / 720), minScale, 1.25)
	s = math.min(s, (vp.X * 0.96) / self.LW, (vp.Y * 0.92) / self.LH)
	return math.max(s, 0.3)
end

function Window:_layout(keepScale)
	local vp = self:_viewport()
	if not keepScale then
		self.Scale = self:_computeScale()
	end
	local s = self.Scale
	local maxW, maxH = vp.X * 0.98 / s, vp.Y * 0.98 / s
	self.LW = math.clamp(self.LW, math.min(self.MinSize.X, maxW), maxW)
	self.LH = math.clamp(self.LH, math.min(self.MinSize.Y, maxH), maxH)

	self.Main.Size = UDim2.fromOffset(self.LW, self.LH)
	self.Holder.Size = UDim2.fromOffset(self.LW * s, self.LH * s)
	if self.IsOpen then
		self.UIScale.Scale = s
	end

	if not self.Pos then
		self.Pos = Vector2.new((vp.X - self.LW * s) / 2, (vp.Y - self.LH * s) / 2)
	end
	local px = math.clamp(self.Pos.X, 0, math.max(0, vp.X - self.LW * s))
	local py = math.clamp(self.Pos.Y, 0, math.max(0, vp.Y - self.LH * s))
	self.Pos = Vector2.new(px, py)
	self.Holder.Position = UDim2.fromOffset(px, py)

	local ns = math.clamp(s, 0.8, 1.1)
	self._notifyHolder.Size = UDim2.new(0, math.floor(300 * ns), 1, -32)
	self:_layoutFab()
end

function Window:_layoutFab()
	if not self._fab then
		return
	end
	local vp = self:_viewport()
	local size = math.clamp(math.floor(54 * self.Scale + 0.5), 44, 64)
	if not self.FabPos then
		self.FabPos = Vector2.new(16, vp.Y - size - 16)
	end
	local fx = math.clamp(self.FabPos.X, 0, math.max(0, vp.X - size))
	local fy = math.clamp(self.FabPos.Y, 0, math.max(0, vp.Y - size))
	self.FabPos = Vector2.new(fx, fy)
	self._fab.Size = UDim2.fromOffset(size, size)
	self._fab.Position = UDim2.fromOffset(fx, fy)
	self._fabText.TextSize = math.floor(size * 0.4)
end

function Window:_onAccent(fn)
	table.insert(self._accent, fn)
	fn()
end

---------------------------------------------------------------------
-- Điều khiển cửa sổ
---------------------------------------------------------------------

function Window:Open()
	if self.IsOpen then
		return
	end
	self.IsOpen = true
	self:_layout(false)
	self.Holder.Visible = true
	self.UIScale.Scale = self.Scale * 0.92
	self.Main.GroupTransparency = 1
	tween(self.UIScale, { Scale = self.Scale }, 0.45)
	tween(self.Main, { GroupTransparency = 0 }, 0.3)
	if self._blur then
		tween(self._blur, { Size = self.Config.BlurSize }, 0.4)
	end
end

function Window:Close()
	if not self.IsOpen then
		return
	end
	self.IsOpen = false
	tween(self.UIScale, { Scale = self.Scale * 0.94 }, 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	tween(self.Main, { GroupTransparency = 1 }, 0.22).Completed:Connect(function()
		if not self.IsOpen then
			self.Holder.Visible = false
		end
	end)
	if self._blur then
		tween(self._blur, { Size = 0 }, 0.3)
	end
end

function Window:Toggle()
	if self.IsOpen then
		self:Close()
	else
		self:Open()
	end
end

Window.Minimize = Window.Toggle

function Window:SetMinimizeKey(key)
	self.ToggleKey = toKeyCode(key)
	self._footer.Text = "Nhấn " .. self.ToggleKey.Name .. " để ẩn hoặc hiện menu"
end

function Window:SetLogo(asset)
	asset = toAsset(asset)
	self._logoImage.Image = asset
	self._logoImage.Visible = asset ~= ""
	self._logoText.Visible = asset == ""
end

function Window:SetFloatingIcon(asset)
	if not self._fab then
		return
	end
	asset = toAsset(asset)
	self._fabImage.Image = asset
	self._fabImage.Visible = asset ~= ""
	self._fabText.Visible = asset == ""
end

function Window:SetAccent(color)
	self.Accent = color
	self._logo.BackgroundColor3 = color
	if self._fab then
		tween(self._fab, { BackgroundColor3 = color }, 0.3)
	end
	for _, fn in ipairs(self._accent) do
		fn()
	end
end

function Window:SetOpacity(opacity)
	tween(self.Main, { BackgroundTransparency = 1 - math.clamp(opacity, 0, 1) }, 0.2)
end

function Window:Destroy()
	for _, c in ipairs(self._conns) do
		c:Disconnect()
	end
	if self._blur then
		self._blur.Size = 0
	end
	self.Gui:Destroy()
end

function Window:Notify(opts)
	if type(opts) == "string" then
		opts = { Content = opts }
	end
	opts = opts or {}
	local cfg = self.Config
	local ns = math.clamp(self.Scale, 0.8, 1.1)
	self._notifyOrder += 1

	local slot = create("Frame", {
		LayoutOrder = self._notifyOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self._notifyHolder,
	})
	local card = create("CanvasGroup", {
		Position = UDim2.fromOffset(40, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = GLASS,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = slot,
	})
	corner(card, UDim.new(0, 12))
	local st = stroke(card, self.Accent, 0.4, 1)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		Parent = card,
	})
	create("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card })

	local order = 0
	local function line(text, size, font, transparency)
		order += 1
		return create("TextLabel", {
			LayoutOrder = order,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = font,
			TextSize = math.floor(size * ns + 0.5),
			Text = tostring(text),
			TextColor3 = WHITE,
			TextTransparency = transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = card,
		})
	end
	if opts.Title then
		line(opts.Title, 14, cfg.FontMedium, 0)
	end
	if opts.Content then
		line(opts.Content, 12, cfg.Font, if opts.Title then 0.25 else 0)
	end
	if opts.SubContent then
		line(opts.SubContent, 12, cfg.Font, 0.5)
	end

	tween(card, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, 0.4)
	local closed = false
	local handle = {}
	function handle:Close()
		if closed then
			return
		end
		closed = true
		tween(card, { Position = UDim2.fromOffset(40, 0), GroupTransparency = 1 }, 0.3).Completed:Connect(function()
			slot:Destroy()
		end)
	end
	if opts.Duration ~= false then
		task.delay(opts.Duration or 3, function()
			handle:Close()
		end)
	end
	st.Color = self.Accent
	return handle
end

function NovaUI:Notify(opts)
	if self._window then
		return self._window:Notify(opts)
	end
end

function NovaUI:Destroy()
	if self._window then
		self._window:Destroy()
		self._window = nil
	end
	table.clear(self.Options)
end

---------------------------------------------------------------------
-- Tab
---------------------------------------------------------------------

function Window:AddTab(opts)
	opts = opts or {}
	local cfg = self.Config
	local idx = #self.Tabs + 1
	local name = opts.Title or opts.Name or ("Tab " .. idx)
	local icon = toAsset(opts.Icon)

	local btn = create("TextButton", {
		Name = "Tab_" .. name,
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 8 + (idx - 1) * 42),
		Size = UDim2.new(1, -16, 0, 38),
		Parent = self._rail,
	})
	local textOffset = if icon ~= "" then 38 else 14
	if icon ~= "" then
		create("ImageLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			Image = icon,
			Parent = btn,
		})
	end
	local label = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(textOffset, 0),
		Size = UDim2.new(1, -textOffset, 1, 0),
		Font = cfg.FontMedium,
		TextSize = 14,
		Text = name,
		TextColor3 = WHITE,
		TextTransparency = 0.3,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = btn,
	})
	self._rail.CanvasSize = UDim2.fromOffset(0, idx * 42 + 16)

	local page = create("CanvasGroup", {
		Name = "Page_" .. name,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		GroupTransparency = 1,
		Parent = self._pages,
	})
	local scroll = create("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = WHITE,
		ScrollBarImageTransparency = 0.6,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = page,
	})
	create("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = scroll,
	})
	create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })

	local tab = setmetatable({
		Window = self,
		Name = name,
		Index = idx,
		Label = label,
		Page = page,
		Scroll = scroll,
		_order = 0,
	}, Tab)
	self.Tabs[idx] = tab

	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)
	if idx == 1 then
		self._indicator.Visible = true
		self:SelectTab(tab)
	end
	return tab
end

function Window:SelectTab(target)
	local tab = if type(target) == "number" then self.Tabs[target] else target
	if not tab or self.ActiveTab == tab then
		return
	end
	local old = self.ActiveTab
	self.ActiveTab = tab

	tween(self._indicator, { Position = UDim2.fromOffset(8, 8 + (tab.Index - 1) * 42) }, 0.38)
	for _, t in ipairs(self.Tabs) do
		tween(t.Label, { TextTransparency = if t == tab then 0 else 0.3 }, 0.25)
	end

	if old then
		tween(old.Page, { GroupTransparency = 1 }, 0.12).Completed:Connect(function()
			if self.ActiveTab ~= old then
				old.Page.Visible = false
			end
		end)
		tab.Page.GroupTransparency = 1
		tab.Page.Position = UDim2.fromOffset(0, 10)
		tab.Page.Visible = true
		tween(tab.Page, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, 0.34)
	else
		tab.Page.GroupTransparency = 0
		tab.Page.Visible = true
	end
	tab.Scroll.CanvasPosition = Vector2.zero
end

---------------------------------------------------------------------
-- Thành phần
---------------------------------------------------------------------

local function newRow(tab, opts, ctrlW, height)
	local win = tab.Window
	local cfg = win.Config
	tab._order += 1
	local row = create("Frame", {
		Name = "Row",
		LayoutOrder = tab._order,
		Size = UDim2.new(1, 0, 0, height or 56),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = tab.Scroll,
	})
	corner(row, UDim.new(0, 10))
	stroke(row, WHITE, 0.84, 1)

	local desc = opts.Description or opts.Content
	local hasDesc = desc ~= nil and desc ~= ""
	local labelW = -(ctrlW + 28)
	create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, if hasDesc then 10 else 0),
		Size = UDim2.new(1, labelW, 0, if hasDesc then 18 else 56),
		Font = cfg.FontMedium,
		TextSize = 14,
		Text = tostring(opts.Title or opts.Name or ""),
		TextColor3 = WHITE,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})
	if hasDesc then
		create("TextLabel", {
			Name = "Description",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 29),
			Size = UDim2.new(1, labelW, 0, 16),
			Font = cfg.Font,
			TextSize = 12,
			Text = tostring(desc),
			TextColor3 = WHITE,
			TextTransparency = 0.38,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = row,
		})
	end
	row.MouseEnter:Connect(function()
		tween(row, { BackgroundTransparency = 0.88 }, 0.15)
	end)
	row.MouseLeave:Connect(function()
		tween(row, { BackgroundTransparency = 0.93 }, 0.15)
	end)
	return row
end

local function makeElement(id, row, kind, value)
	local el = { Id = id, Type = kind, Value = value, Row = row, _listeners = {} }
	function el:OnChanged(fn)
		table.insert(self._listeners, fn)
	end
	function el:SetTitle(text)
		local t = row:FindFirstChild("Title")
		if t then
			t.Text = tostring(text)
		end
	end
	function el:SetDesc(text)
		local d = row:FindFirstChild("Description")
		if d then
			d.Text = tostring(text)
		end
	end
	function el:Destroy()
		row:Destroy()
		if id and NovaUI.Options[id] == self then
			NovaUI.Options[id] = nil
		end
	end
	if id then
		NovaUI.Options[id] = el
	end
	return el
end

local function emit(el, opts, value)
	el.Value = value
	for _, fn in ipairs(el._listeners) do
		task.spawn(fn, value)
	end
	if opts.Callback then
		task.spawn(opts.Callback, value)
	end
end

function Tab:AddSection(text)
	self._order += 1
	local label = create("TextLabel", {
		Name = "Section",
		LayoutOrder = self._order,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Font = self.Window.Config.FontMedium,
		TextSize = 12,
		Text = tostring(text),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Scroll,
	})
	self.Window:_onAccent(function()
		label.TextColor3 = self.Window.Accent
	end)
	return label
end

function Tab:AddParagraph(opts)
	local _, o = args(opts)
	local cfg = self.Window.Config
	self._order += 1
	local card = create("Frame", {
		Name = "Paragraph",
		LayoutOrder = self._order,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Parent = self.Scroll,
	})
	corner(card, UDim.new(0, 10))
	stroke(card, WHITE, 0.84, 1)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		Parent = card,
	})
	create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card })
	local function text(order, value, size, font, transparency)
		return create("TextLabel", {
			LayoutOrder = order,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = font,
			TextSize = size,
			Text = tostring(value or ""),
			TextColor3 = WHITE,
			TextTransparency = transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = card,
		})
	end
	local titleLabel = text(1, o.Title, 14, cfg.FontMedium, 0)
	local contentLabel = text(2, o.Content or o.Description, 12, cfg.Font, 0.3)
	local obj = {}
	function obj:SetTitle(t)
		titleLabel.Text = tostring(t)
	end
	function obj:SetDesc(t)
		contentLabel.Text = tostring(t)
	end
	function obj:Destroy()
		card:Destroy()
	end
	return obj
end

function Tab:AddToggle(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local row = newRow(self, opts, 44)
	local state = opts.Default == true

	local switch = create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(40, 22),
		BackgroundColor3 = OFF,
		BorderSizePixel = 0,
		Parent = row,
	})
	corner(switch, UDim.new(1, 0))
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		Parent = switch,
	})
	corner(knob, UDim.new(1, 0))

	local function render(animate)
		local pos = if state then UDim2.new(0, 21, 0.5, 0) else UDim2.new(0, 3, 0.5, 0)
		local trackColor = if state then win.Accent else OFF
		local knobColor = if state then DARK else WHITE
		if animate then
			tween(knob, { Position = pos, BackgroundColor3 = knobColor }, 0.32)
			tween(switch, { BackgroundColor3 = trackColor }, 0.28)
		else
			knob.Position = pos
			knob.BackgroundColor3 = knobColor
			switch.BackgroundColor3 = trackColor
		end
	end
	win:_onAccent(function()
		render(false)
	end)

	local el = makeElement(id, row, "Toggle", state)
	function el:SetValue(v)
		state = v == true
		render(true)
		emit(self, opts, state)
	end
	switch.MouseButton1Click:Connect(function()
		el:SetValue(not state)
	end)
	return el
end

function Tab:AddSlider(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local cfg = win.Config
	local min, max = opts.Min or 0, opts.Max or 100
	local inc = opts.Increment or (if opts.Rounding then 10 ^ -opts.Rounding else 1)
	local suffix = opts.Suffix or ""
	local value = math.clamp(opts.Default or min, min, max)
	local row = newRow(self, opts, 160)

	local holder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(160, 24),
		BackgroundTransparency = 1,
		Parent = row,
	})
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(106, 6),
		BackgroundColor3 = OFF,
		BorderSizePixel = 0,
		Parent = holder,
	})
	corner(bar, UDim.new(1, 0))
	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = win.Accent,
		BorderSizePixel = 0,
		Parent = bar,
	})
	corner(fill, UDim.new(1, 0))
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = bar,
	})
	corner(knob, UDim.new(1, 0))
	local valueLabel = create("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(46, 20),
		BackgroundTransparency = 1,
		Font = cfg.Font,
		TextSize = 12,
		TextColor3 = WHITE,
		TextTransparency = 0.15,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = holder,
	})
	local hit = create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 26),
		ZIndex = 3,
		Parent = bar,
	})
	win:_onAccent(function()
		fill.BackgroundColor3 = win.Accent
	end)

	local function render()
		local a = if max > min then (value - min) / (max - min) else 0
		fill.Size = UDim2.fromScale(a, 1)
		knob.Position = UDim2.fromScale(a, 0.5)
		valueLabel.Text = tostring(value) .. suffix
	end
	render()

	local el = makeElement(id, row, "Slider", value)
	function el:SetValue(v)
		v = math.clamp(math.floor((v - min) / inc + 0.5) * inc + min, min, max)
		v = math.floor(v * 1000000 + 0.5) / 1000000
		if v == value then
			return
		end
		value = v
		render()
		emit(self, opts, value)
	end

	local function fromX(x)
		local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		el:SetValue(min + (max - min) * a)
	end
	hit.InputBegan:Connect(function(input)
		if not isPress(input) then
			return
		end
		self.Scroll.ScrollingEnabled = false
		fromX(toScreen(input.Position).X)
		follow(input, function(pos)
			fromX(toScreen(pos).X)
		end, function()
			self.Scroll.ScrollingEnabled = true
		end)
	end)
	return el
end

function Tab:AddDropdown(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local cfg = win.Config
	local values = opts.Values or opts.Options or {}
	local value = opts.Default
	if type(value) == "number" then
		value = values[value]
	end
	value = value or values[1]
	local row = newRow(self, opts, 130)
	local open = false
	local panelH = #values * 30 + 8

	local hit = create("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56),
		ZIndex = 2,
		Parent = row,
	})
	local chip = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(116, 28),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = row,
	})
	corner(chip, UDim.new(0, 8))
	stroke(chip, WHITE, 0.7, 1)
	local valueLabel = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -30, 1, 0),
		Font = cfg.Font,
		TextSize = 12,
		TextColor3 = WHITE,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 3,
		Parent = chip,
	})
	local arrow = create("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundTransparency = 1,
		Font = cfg.Font,
		TextSize = 9,
		Text = "▼",
		TextColor3 = WHITE,
		ZIndex = 3,
		Parent = chip,
	})

	local panel = create("Frame", {
		Position = UDim2.fromOffset(10, 60),
		Size = UDim2.new(1, -20, 0, panelH),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		Parent = row,
	})
	corner(panel, UDim.new(0, 10))
	stroke(panel, WHITE, 0.84, 1)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		Parent = panel,
	})
	create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = panel })

	local buttons = {}
	local function refresh()
		valueLabel.Text = tostring(value)
		for opt, b in pairs(buttons) do
			b.TextColor3 = if opt == value then win.Accent else WHITE
		end
	end
	win:_onAccent(refresh)

	local function setOpen(state)
		open = state
		-- đổi chiều cao hàng: UIListLayout tự đẩy các hàng bên dưới trượt theo
		tween(row, { Size = UDim2.new(1, 0, 0, if state then 56 + 4 + panelH + 8 else 56) }, 0.38)
		tween(arrow, { Rotation = if state then 180 else 0 }, 0.3)
	end

	local el = makeElement(id, row, "Dropdown", value)
	function el:SetValue(v)
		if table.find(values, v) == nil then
			return
		end
		value = v
		refresh()
		emit(self, opts, value)
	end

	for i, opt in ipairs(values) do
		local b = create("TextButton", {
			Text = tostring(opt),
			AutoButtonColor = false,
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			Font = cfg.Font,
			TextSize = 12,
			TextColor3 = WHITE,
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = i,
			Parent = panel,
		})
		corner(b, UDim.new(0, 7))
		b.MouseEnter:Connect(function()
			tween(b, { BackgroundTransparency = 0.88 }, 0.15)
		end)
		b.MouseLeave:Connect(function()
			tween(b, { BackgroundTransparency = 1 }, 0.15)
		end)
		b.MouseButton1Click:Connect(function()
			el:SetValue(opt)
			setOpen(false)
		end)
		buttons[opt] = b
	end
	refresh()
	hit.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
	return el
end

function Tab:AddButton(opts)
	local _, o = args(opts)
	local win = self.Window
	local cfg = win.Config
	local row = newRow(self, o, 100)
	local btn = create("TextButton", {
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(86, 30),
		BackgroundColor3 = win.Accent,
		BorderSizePixel = 0,
		Font = cfg.FontMedium,
		TextSize = 13,
		Text = o.ButtonText or "Chạy",
		TextColor3 = DARK,
		Parent = row,
	})
	corner(btn, UDim.new(0, 8))
	local press = create("UIScale", { Scale = 1, Parent = btn })
	win:_onAccent(function()
		btn.BackgroundColor3 = win.Accent
	end)
	btn.MouseButton1Down:Connect(function()
		tween(press, { Scale = 0.93 }, 0.1)
	end)
	local function release()
		tween(press, { Scale = 1 }, 0.25, Enum.EasingStyle.Back)
	end
	btn.MouseButton1Up:Connect(release)
	btn.MouseLeave:Connect(release)
	btn.MouseButton1Click:Connect(function()
		if o.Callback then
			task.spawn(o.Callback)
		end
	end)
	return makeElement(nil, row, "Button", nil)
end

function Tab:AddInput(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local cfg = win.Config
	local row = newRow(self, opts, 150)
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(150, 30),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Font = cfg.Font,
		TextSize = 12,
		TextColor3 = WHITE,
		PlaceholderText = opts.Placeholder or "",
		PlaceholderColor3 = Color3.fromRGB(170, 170, 185),
		Text = tostring(opts.Default or ""),
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = row,
	})
	corner(box, UDim.new(0, 8))
	local st = stroke(box, WHITE, 0.7, 1)
	create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = box })

	local el = makeElement(id, row, "Input", box.Text)
	function el:SetValue(v)
		box.Text = tostring(v)
	end

	box:GetPropertyChangedSignal("Text"):Connect(function()
		if opts.Numeric then
			local cleaned = (box.Text:gsub("[^%d%.%-]", ""))
			if cleaned ~= box.Text then
				box.Text = cleaned
				return
			end
		end
		if opts.Finished then
			el.Value = box.Text
		else
			emit(el, opts, box.Text)
		end
	end)
	box.Focused:Connect(function()
		tween(st, { Color = win.Accent, Transparency = 0 }, 0.2)
	end)
	box.FocusLost:Connect(function(enterPressed)
		tween(st, { Color = WHITE, Transparency = 0.7 }, 0.2)
		if enterPressed and opts.Finished then
			emit(el, opts, box.Text)
		end
	end)
	return el
end

function Tab:AddKeybind(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local cfg = win.Config
	local key = toKeyCode(opts.Default)
	local row = newRow(self, opts, 80)
	local chip = create("TextButton", {
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(64, 28),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Font = cfg.Font,
		TextSize = 12,
		Text = key.Name,
		TextColor3 = WHITE,
		Parent = row,
	})
	corner(chip, UDim.new(0, 8))
	local st = stroke(chip, WHITE, 0.7, 1)

	local el = makeElement(id, row, "Keybind", key.Name)
	function el:SetValue(k)
		key = toKeyCode(k)
		chip.Text = key.Name
		self.Value = key.Name
		for _, fn in ipairs(self._listeners) do
			task.spawn(fn, key.Name)
		end
		if opts.ChangedCallback then
			task.spawn(opts.ChangedCallback, key.Name)
		end
	end

	local listening = false
	chip.MouseButton1Click:Connect(function()
		if listening then
			return
		end
		listening = true
		win._binding = true
		chip.Text = "..."
		tween(st, { Color = win.Accent, Transparency = 0 }, 0.2)
		local conn
		conn = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			conn:Disconnect()
			if input.KeyCode ~= Enum.KeyCode.Escape then
				el:SetValue(input.KeyCode)
			else
				chip.Text = key.Name
			end
			listening = false
			tween(st, { Color = WHITE, Transparency = 0.7 }, 0.2)
			task.delay(0.1, function()
				win._binding = false
			end)
		end)
	end)

	if opts.Callback then
		table.insert(win._keybinds, {
			get = function()
				return key
			end,
			press = function()
				opts.Callback(key.Name)
			end,
		})
	end
	return el
end

function Tab:AddColorpicker(id, opts)
	id, opts = args(id, opts)
	local win = self.Window
	local colors = {}
	for _, c in ipairs(opts.Colors or {
		Color3.fromRGB(167, 139, 250),
		Color3.fromRGB(248, 113, 113),
		Color3.fromRGB(45, 212, 191),
		Color3.fromRGB(251, 191, 36),
		Color3.fromRGB(96, 165, 250),
		Color3.fromRGB(244, 114, 182),
	}) do
		table.insert(colors, c)
	end
	local selected = opts.Default or colors[1]
	if table.find(colors, selected) == nil then
		table.insert(colors, 1, selected)
	end
	local width = #colors * 28 - 8
	local row = newRow(self, opts, width)

	local holder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0, 28),
		Size = UDim2.fromOffset(width, 20),
		BackgroundTransparency = 1,
		Parent = row,
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = holder,
	})

	local swatches = {}
	local function refresh()
		for _, s in ipairs(swatches) do
			tween(s.stroke, { Transparency = if s.color == selected then 0 else 1 }, 0.2)
		end
	end

	local el = makeElement(id, row, "Colorpicker", selected)
	function el:SetValue(c)
		selected = c
		refresh()
		emit(self, opts, c)
	end

	for i, c in ipairs(colors) do
		local b = create("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.fromOffset(20, 20),
			BackgroundColor3 = c,
			BorderSizePixel = 0,
			LayoutOrder = i,
			Parent = holder,
		})
		corner(b, UDim.new(1, 0))
		local st = stroke(b, WHITE, if c == selected then 0 else 1, 2)
		table.insert(swatches, { color = c, stroke = st })
		b.MouseButton1Click:Connect(function()
			el:SetValue(c)
		end)
	end
	return el
end

Tab.AddColorPicker = Tab.AddColorpicker

return NovaUI
