-- =================================================================
-- EXAMPLE SCRIPT - PITAYA UI (FULL FUNCTIONAL)
-- =================================================================

-- 1. LOAD THƯ VIỆN (Nếu dùng File local thì thay bằng require, hoặc loadstring URL)
local PitayaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pitaya-real/PitayaUI/refs/heads/main/Pitayauisource.lua"))()

-- 2. KHỞI TẠO CÁC SERVICE ROBLOX
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Hàm hỗ trợ lấy Humanoid và HumanoidRootPart an toàn
local function getHumanoid()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:FindFirstChild("HumanoidRootPart")
end

-- 3. TẠO CỬA SỔ CHÍNH (WINDOW) VỚI LOADING SCREEN
local Window = PitayaUI:CreateWindow({
	Title = "Pitaya Hub | Premium",
	Logo = "rbxassetid://73866843639743",
	Theme = "PitayaUI",
	Font = "Gotham",
	Loading = true, -- Bật màn hình Loading Screen trước khi hiện UI
	LoadingTitle = "<b>Pitaya Hub</b> Premium"
})

-- =================================================================
-- TAB 1: NGƯỜI CHƠI (PLAYER)
-- =================================================================
local PlayerTab = Window:CreateTab("Nhân Vật", "👤")

-- Ví dụ tự động tô đậm bằng BoldText = true hoặc dùng HTML tag <b>...</b>
PlayerTab:AddLabel("--- Chỉ Số Cơ Bản ---", {BoldText = true})

-- Slider: Tốc độ di chuyển (Tô đậm chữ)
PlayerTab:AddSlider({
	Text = "Tốc Độ Di Chuyển (Speed)",
	BoldText = true,
	Min = 16,
	Max = 250,
	Default = 16,
	Callback = function(val)
		local hum = getHumanoid()
		if hum then 
			hum.WalkSpeed = val 
		end
	end
})

-- Slider: Nhảy cao
PlayerTab:AddSlider({
	Text = "Độ Cao Nhảy (JumpPower)",
	Min = 50,
	Max = 400,
	Default = 50,
	Callback = function(val)
		local hum = getHumanoid()
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = val
		end
	end
})

PlayerTab:AddLabel("--- Kỹ Năng Đặt Biệt ---", {BoldText = true})

-- Toggle: Nhảy vô hạn (Inf Jump)
local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled then
		local hum = getHumanoid()
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

PlayerTab:AddToggle({
	Text = "Nhảy Vô Hạn (Inf Jump)",
	BoldText = true,
	Default = false,
	Callback = function(state)
		infJumpEnabled = state
		Window:Notify("Hệ Thống", "Nhảy vô hạn: " .. (state and "<b>ĐÃ BẬT</b>" or "<b>ĐÃ TẮT</b>"), 2)
	end
})

-- Button: Tự sát
PlayerTab:AddButton({
	Text = "Tự Sát (Reset Character)",
	BoldText = true,
	Callback = function()
		local hum = getHumanoid()
		if hum then 
			hum.Health = 0 
		end
	end
})

-- =================================================================
-- TAB 2: THẾ GIỚI & HIỂN THỊ (VISUALS)
-- =================================================================
local VisualTab = Window:CreateTab("Thế Giới", "🌐")

VisualTab:AddLabel("--- Camera & Môi Trường ---", {BoldText = true})

-- Slider: Field of View (FOV)
VisualTab:AddSlider({
	Text = "Góc Nhìn Camera (FOV)",
	Min = 70,
	Max = 120,
	Default = 70,
	Callback = function(val)
		if Workspace.CurrentCamera then
			Workspace.CurrentCamera.FieldOfView = val
		end
	end
})

-- Toggle: Fullbright
local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness

VisualTab:AddToggle({
	Text = "Bật Sáng Tối Đa (Fullbright)",
	BoldText = true,
	Default = false,
	Callback = function(state)
		if state then
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.Brightness = 2
		else
			Lighting.Ambient = oldAmbient
			Lighting.Brightness = oldBrightness
		end
	end
})

VisualTab:AddLabel("--- Dịch Chuyển ---", {BoldText = true})

-- TextBox: Teleport
VisualTab:AddTextBox({
	Text = "Teleport",
	BoldText = true,
	Placeholder = "Nhập tên người chơi...",
	Callback = function(text, enterPressed)
		if enterPressed and text ~= "" then
			local targetFound = false
			for _, target in ipairs(Players:GetPlayers()) do
				if target ~= LocalPlayer and string.find(string.lower(target.Name), string.lower(text)) then
					local myRoot = getRootPart()
					local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
					
					if myRoot and targetRoot then
						myRoot.CFrame = targetRoot.CFrame
						Window:Notify("Dịch Chuyển", "Đã tới vị trí: <b>" .. target.Name .. "</b>", 3)
						targetFound = true
						break
					end
				end
			end
			
			if not targetFound then
				Window:Notify("Lỗi", "Không tìm thấy người chơi này!", 3)
			end
		end
	end
})

-- =================================================================
-- TAB 3: CÀI ĐẶT GIAO DIỆN (SETTINGS)
-- =================================================================
local SettingsTab = Window:CreateTab("Cài Đặt", "⚙️")

SettingsTab:AddLabel("--- Tùy Chỉnh UI ---", {BoldText = true})

-- Dropdown: Đổi Theme
SettingsTab:AddDropdown({
	Text = "Chủ Đề",
	BoldText = true,
	Items = Window:GetThemes(),
	Default = "PitayaUI",
	Callback = function(selectedTheme)
		Window:SetTheme(selectedTheme)
		Window:Notify("Theme", "Đã chuyển giao diện sang: <b>" .. selectedTheme .. "</b>", 2)
	end
})

-- Dropdown: Đổi Font
SettingsTab:AddDropdown({
	Text = "Phông Chữ",
	BoldText = true,
	Items = Window:GetFonts(),
	Default = "Gotham",
	Callback = function(selectedFont)
		Window:SetFont(selectedFont)
		Window:Notify("Phông Chữ", "Đã cập nhật Font: <b>" .. selectedFont .. "</b>", 2)
	end
})

-- Button: Test Notification
SettingsTab:AddButton({
	Text = "Kiểm Tra Thông Báo Mẫu",
	BoldText = true,
	Callback = function()
		Window:Notify("Thông Báo Mẫu", "Toàn bộ chức năng UI đang chạy <b>ổn định</b>!", 4)
	end
})
