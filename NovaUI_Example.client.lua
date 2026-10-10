-- =================================================================
-- SCRIPT CHẠY UI LIBRARY NOVA UI (DẠNG LOADSTRING GITHUB)
-- Bản test: các chức năng chạy thật + Dynamic Island
-- LƯU Ý: file NovaUI.lua trên GitHub phải là bản đã có Dynamic Island
-- =================================================================

-- 1. Tải và nạp Library từ GitHub
local rawUrl = "https://raw.githubusercontent.com/Pitaya-real/PitayaUI/refs/heads/main/NovaUI.lua"
local NovaUI = loadstring(game:HttpGet(rawUrl))()

-- Dịch vụ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local function getCharacter()
	return LocalPlayer.Character
end

local function getHumanoid()
	local c = getCharacter()
	return c and c:FindFirstChildOfClass("Humanoid")
end

-- 2. Tạo cửa sổ menu chính
local Window = NovaUI:CreateWindow({
	Title = "NovaMenu",
	SubTitle = "Game của tôi",

	Logo = "73866843639743",
	FloatingIcon = "73866843639743",

	Size = UDim2.fromOffset(620, 420),
	Accent = Color3.fromRGB(167, 139, 250),
	MinimizeKey = Enum.KeyCode.M,
	Acrylic = true,
})

-- 3. Tạo các Tab
local Tabs = {
	Audio    = Window:AddTab({ Title = "Âm thanh", Icon = "🔊" }),
	Graphics = Window:AddTab({ Title = "Đồ họa", Icon = "🎨" }),
	Controls = Window:AddTab({ Title = "Điều khiển", Icon = "🎮" }),
	Player   = Window:AddTab({ Title = "Người chơi", Icon = "👤" }),
	Look     = Window:AddTab({ Title = "Giao diện", Icon = "⚙️" }),
}

local Options = NovaUI.Options

---------------------------------------------------------------------
-- Âm thanh (chạy thật: chỉnh Volume của các Sound trong game)
-- Nhạc = Sound trong SoundService, Hiệu ứng = Sound trong workspace
---------------------------------------------------------------------
local baseVolume = setmetatable({}, { __mode = "k" })
local musicOn, musicVol, sfxVol = true, 0.7, 0.85

local function scaleSound(s, mult)
	if baseVolume[s] == nil then
		baseVolume[s] = s.Volume
	end
	s.Volume = baseVolume[s] * mult
end

local function refreshSounds()
	for _, s in ipairs(SoundService:GetDescendants()) do
		if s:IsA("Sound") then
			scaleSound(s, if musicOn then musicVol else 0)
		end
	end
	for _, s in ipairs(workspace:GetDescendants()) do
		if s:IsA("Sound") then
			scaleSound(s, sfxVol)
		end
	end
end

Tabs.Audio:AddSection("Nhạc")

Tabs.Audio:AddToggle("Music", {
	Title = "Bật nhạc nền",
	Description = "Tắt thì nhạc trong SoundService bị câm",
	Default = true,
	Callback = function(on)
		musicOn = on
		refreshSounds()
	end,
})

Tabs.Audio:AddSlider("MusicVolume", {
	Title = "Âm lượng nhạc",
	Description = "Điều chỉnh độ lớn nhạc nền",
	Default = 70,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		musicVol = value / 100
		refreshSounds()
	end,
})

Tabs.Audio:AddSlider("SfxVolume", {
	Title = "Hiệu ứng âm thanh",
	Description = "Tiếng bước chân, va chạm",
	Default = 85,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		sfxVol = value / 100
		refreshSounds()
	end,
})

---------------------------------------------------------------------
-- Đồ họa
---------------------------------------------------------------------
local qualityMap = {
	["Thấp"] = Enum.QualityLevel.Level01,
	["Trung bình"] = Enum.QualityLevel.Level05,
	["Cao"] = Enum.QualityLevel.Level10,
	["Siêu cao"] = Enum.QualityLevel.Level21,
}

Tabs.Graphics:AddSection("Hình ảnh")

Tabs.Graphics:AddDropdown("Quality", {
	Title = "Chất lượng hình ảnh",
	Description = "Giảm xuống nếu máy bị giật",
	Values = { "Thấp", "Trung bình", "Cao", "Siêu cao" },
	Default = 2,
	Callback = function(name)
		local level = qualityMap[name]
		if level then
			pcall(function()
				settings().Rendering.QualityLevel = level
			end)
		end
	end,
})

Tabs.Graphics:AddToggle("Shadows", {
	Title = "Đổ bóng",
	Description = "Bóng đổ của nhân vật và vật thể",
	Default = true,
	Callback = function(on)
		Lighting.GlobalShadows = on
	end,
})

-- Fullbright: lưu cài đặt cũ rồi trả lại khi tắt
local savedLight
Tabs.Graphics:AddToggle("Fullbright", {
	Title = "Sáng toàn bản đồ",
	Description = "Xóa bóng tối và sương mù",
	Default = false,
	Callback = function(on)
		if on then
			savedLight = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				FogEnd = Lighting.FogEnd,
				Ambient = Lighting.Ambient,
				OutdoorAmbient = Lighting.OutdoorAmbient,
			}
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1e6
			Lighting.Ambient = Color3.new(1, 1, 1)
			Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		elseif savedLight then
			for k, v in pairs(savedLight) do
				Lighting[k] = v
			end
			savedLight = nil
		end
	end,
})

Tabs.Graphics:AddButton({
	Title = "Đặt lại đồ họa",
	Description = "Trả về cài đặt mặc định",
	ButtonText = "Đặt lại",
	Callback = function()
		Options.Quality:SetValue("Trung bình")
		Options.Shadows:SetValue(true)
		Options.Fullbright:SetValue(false)
		NovaUI:Notify({ Title = "Đồ họa", Content = "Đã đặt lại về mặc định", Duration = 2.5 })
	end,
})

---------------------------------------------------------------------
-- Điều khiển
---------------------------------------------------------------------
Tabs.Controls:AddSection("Phím và camera")

Tabs.Controls:AddSlider("CameraSensitivity", {
	Title = "Độ nhạy camera",
	Description = "Độ nhạy chuột (áp dụng cho máy tính)",
	Default = 50,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		pcall(function()
			UserSettings():GetService("UserGameSettings").MouseSensitivity = value / 50
		end)
	end,
})

Tabs.Controls:AddSlider("FOV", {
	Title = "Tầm nhìn (FOV)",
	Description = "Góc nhìn của camera",
	Default = 70,
	Min = 30,
	Max = 120,
	Rounding = 0,
	Callback = function(value)
		local cam = workspace.CurrentCamera
		if cam then
			cam.FieldOfView = value
		end
	end,
})

Tabs.Controls:AddKeybind("MenuKey", {
	Title = "Phím mở menu",
	Description = "Bấm vào rồi nhấn phím mới (Esc để hủy)",
	Default = "M",
	ChangedCallback = function(keyName)
		Window:SetMinimizeKey(keyName)
		NovaUI:Notify({ Title = "Đã đổi phím", Content = "Phím mở menu: " .. keyName })
	end,
})

---------------------------------------------------------------------
-- Người chơi (chạy thật, có Dynamic Island hiện trạng thái)
---------------------------------------------------------------------
Tabs.Player:AddSection("Di chuyển")

-- Tốc độ chạy: vòng Heartbeat giữ WalkSpeed khi đang bật
local speedOn, speedValue = false, 16
RunService.Heartbeat:Connect(function()
	if speedOn then
		local hum = getHumanoid()
		if hum and hum.WalkSpeed ~= speedValue then
			hum.WalkSpeed = speedValue
		end
	end
end)

Tabs.Player:AddToggle("SpeedHack", {
	Title = "Chạy nhanh",
	Description = "Dùng tốc độ ở thanh bên dưới",
	Default = false,
	Callback = function(on)
		speedOn = on
		if not on then
			local hum = getHumanoid()
			if hum then
				hum.WalkSpeed = 16
			end
		end
	end,
})

Tabs.Player:AddSlider("WalkSpeed", {
	Title = "Tốc độ chạy",
	Description = "Mặc định của game là 16",
	Default = 50,
	Min = 16,
	Max = 200,
	Rounding = 0,
	Callback = function(value)
		speedValue = value
	end,
})
speedValue = 50

-- Nhảy vô hạn
local jumpConn
Tabs.Player:AddToggle("InfiniteJump", {
	Title = "Nhảy vô hạn",
	Description = "Bấm nhảy liên tục trên không",
	Default = false,
	Callback = function(on)
		if jumpConn then
			jumpConn:Disconnect()
			jumpConn = nil
		end
		if on then
			jumpConn = UserInputService.JumpRequest:Connect(function()
				local hum = getHumanoid()
				if hum then
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end
	end,
})

-- Xuyên tường: nhớ CanCollide cũ để trả lại khi tắt
local noclipConn
local noclipSaved = {}
Tabs.Player:AddToggle("Noclip", {
	Title = "Xuyên tường",
	Description = "Đi xuyên qua vật thể",
	Default = false,
	Callback = function(on)
		if noclipConn then
			noclipConn:Disconnect()
			noclipConn = nil
		end
		if on then
			noclipConn = RunService.Stepped:Connect(function()
				local char = getCharacter()
				if not char then
					return
				end
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then
						noclipSaved[part] = true
						part.CanCollide = false
					end
				end
			end)
		else
			for part in pairs(noclipSaved) do
				if part.Parent then
					part.CanCollide = true
				end
			end
			table.clear(noclipSaved)
		end
	end,
})

Tabs.Player:AddSection("Tiện ích")

-- ESP: viền sáng quanh người chơi khác
local espOn = false
local espFolder = {}
local function clearESP()
	for _, h in pairs(espFolder) do
		h:Destroy()
	end
	table.clear(espFolder)
end
task.spawn(function()
	while true do
		task.wait(1)
		if espOn then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and not espFolder[plr] then
					local hl = Instance.new("Highlight")
					hl.FillTransparency = 0.7
					hl.OutlineColor = Color3.new(1, 1, 1)
					hl.Adornee = plr.Character
					hl.Parent = plr.Character
					espFolder[plr] = hl
				end
			end
			for plr, hl in pairs(espFolder) do
				if not plr.Parent or not hl.Parent then
					hl:Destroy()
					espFolder[plr] = nil
				end
			end
		end
	end
end)

Tabs.Player:AddToggle("ESP", {
	Title = "Viền người chơi (ESP)",
	Description = "Nhìn thấy người chơi khác xuyên vật thể",
	Default = false,
	Callback = function(on)
		espOn = on
		if not on then
			clearESP()
		end
	end,
})

-- Chống AFK
local afkConn
Tabs.Player:AddToggle("AntiAFK", {
	Title = "Chống AFK",
	Description = "Không bị đá khi đứng yên lâu",
	Default = false,
	Callback = function(on)
		if afkConn then
			afkConn:Disconnect()
			afkConn = nil
		end
		if on then
			afkConn = LocalPlayer.Idled:Connect(function()
				pcall(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end)
			end)
		end
	end,
})

Tabs.Player:AddSection("Hồ sơ")

Tabs.Player:AddInput("DisplayName", {
	Title = "Tên hiển thị",
	Description = "Nhấn Enter để đổi (chỉ bạn thấy)",
	Placeholder = "Nhập tên của bạn",
	Finished = true,
	Callback = function(text)
		if text:gsub("%s", "") == "" then
			NovaUI:Notify({ Title = "Tên hiển thị", Content = "Hãy nhập nội dung trước" })
			return
		end
		local hum = getHumanoid()
		if hum then
			hum.DisplayName = text
		end
		NovaUI:Notify({ Title = "Đã lưu tên", Content = text })
	end,
})

Tabs.Player:AddInput("GiftCode", {
	Title = "Mã quà tặng",
	Description = "Nhập mã rồi nhấn Enter",
	Placeholder = "NOVA2026",
	Finished = true,
	Callback = function(code)
		NovaUI:Notify({ Title = "Mã quà tặng", Content = "Đã gửi mã: " .. code })
	end,
})

Tabs.Player:AddToggle("ShowName", {
	Title = "Hiện tên trên đầu",
	Description = "Người khác thấy tên của bạn",
	Default = true,
	Callback = function(on)
		local hum = getHumanoid()
		if hum then
			hum.DisplayDistanceType = if on then Enum.HumanoidDisplayDistanceType.Viewer else Enum.HumanoidDisplayDistanceType.None
		end
	end,
})

Tabs.Player:AddParagraph({
	Title = "Ghi chú",
	Content = "Các toggle ở tab này sẽ hiện lên Dynamic Island phía trên màn hình khi bật hoặc tắt.",
})

---------------------------------------------------------------------
-- Giao diện
---------------------------------------------------------------------
Tabs.Look:AddSection("Tùy chỉnh menu")

Tabs.Look:AddColorpicker("Accent", {
	Title = "Màu chủ đạo",
	Description = "Đổi màu nhấn của toàn menu",
	Default = Color3.fromRGB(167, 139, 250),
	Callback = function(color)
		Window:SetAccent(color)
	end,
})

Tabs.Look:AddSlider("Opacity", {
	Title = "Độ đậm cửa sổ",
	Description = "Kéo lên để nền đậm hơn, kéo xuống để nhìn xuyên hơn",
	Default = 70,
	Min = 10,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		Window:SetOpacity(value / 100)
	end,
})

Tabs.Look:AddSection("Thử nghiệm")

Tabs.Look:AddButton({
	Title = "Thông báo thử",
	Description = "Xem hiệu ứng thông báo (island cũng hiện)",
	ButtonText = "Thử",
	Callback = function()
		NovaUI:Notify({
			Title = "Xin chào",
			Content = "Đây là thông báo từ NovaUI",
			SubContent = "Tự biến mất sau 3 giây",
			Duration = 3,
		})
	end,
})

Tabs.Look:AddButton({
	Title = "Thử Dynamic Island",
	Description = "Chỉ hiện chữ trên island, không có thông báo góc phải",
	ButtonText = "Thử",
	Callback = function()
		Window:Island({ Title = "Dynamic Island", Content = "Hoạt động tốt!", Duration = 3 })
	end,
})

-- Chọn tab mặc định
Window:SelectTab(1)

NovaUI:Notify({
	Title = "NovaMenu",
	Content = "Nhấn nút tròn hoặc phím M để ẩn hiện menu",
	Duration = 4,
})
