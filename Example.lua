-- =================================================================
-- SCRIPT MẪU CHUẨN (EXAMPLE.LUA)
-- Tương thích hoàn toàn với Pitayauisource.lua v3.5 (Đã xóa Console)
-- =================================================================

-- 1. Load Thư viện PitayaUI
-- (Thay đường dẫn URL chứa file Pitayauisource.lua của bạn vào đây)
local PitayaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pitaya-real/PitayaUI/refs/heads/main/Pitayauisource.lua"))()

-- 2. Khởi tạo Cửa sổ chính (Window)
local Window = PitayaUI:CreateWindow({
	Title = "SCRIPT MASTER HUB - PITAYA EDITION",
	Logo = "rbxassetid://115347218827913",
	Theme = "PitayaUI",  -- Tùy chọn: "PitayaUI" hoặc "Dark"
	Font = "Gotham"      -- Tùy chọn: "Gotham", "FredokaOne", "BuilderSans"
})

-- Thông báo Popup chào mừng
Window:Notify("PITAYA UI", "Đã tải giao diện thành công!", 4)

-- 3. Tạo các Tab chức năng (Thanh Tab Ngang)
local MainTab = Window:CreateTab("Main", "🔥")
local TeleportTab = Window:CreateTab("Teleport", "🌐")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- =================================================================
-- TAB 1: MAIN (Chức năng chính)
-- =================================================================

-- Công tắc Bật/Tắt (Toggle Switch)
MainTab:AddToggle({
	Text = "Auto Farm Level",
	Default = false,
	Callback = function(state)
		print("Trạng thái Auto Farm:", state)
	end
})

MainTab:AddToggle({
	Text = "Auto Collect Coins",
	Default = true,
	Callback = function(state)
		print("Trạng thái Auto Collect:", state)
	end
})

-- Thanh kéo Slider (Có hiển thị chỉ số Realtime và nút RESET)
MainTab:AddSlider({
	Text = "Walkspeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Callback = function(value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = value
		end
	end
})

MainTab:AddSlider({
	Text = "Jump Power",
	Min = 50,
	Max = 300,
	Default = 50,
	Callback = function(value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = value
		end
	end
})

-- =================================================================
-- TAB 2: TELEPORT (Dịch chuyển)
-- =================================================================

-- Dropdown chọn vị trí + Nút bấm GO
TeleportTab:AddDropdown({
	Text = "Dịch chuyển Đảo",
	Items = {"Starter Island", "Pirate Island", "Marine Base", "Sky Island"},
	Callback = function(selectedItem)
		Window:Notify("TELEPORT", "Đã dịch chuyển tới: " .. selectedItem, 3)
		print("Teleported to:", selectedItem)
	end
})

-- Nút bấm thực thi (Button)
TeleportTab:AddButton({
	Text = "Rejoin Server",
	Callback = function()
		local TeleportService = game:GetService("TeleportService")
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end
})

-- =================================================================
-- TAB 3: SETTINGS (Cài đặt Giao diện)
-- =================================================================

-- Đổi Theme trực tiếp Realtime
SettingsTab:AddDropdown({
	Text = "Đổi Theme",
	Items = Window:GetThemes(),
	Callback = function(themeName)
		Window:SetTheme(themeName)
		Window:Notify("THEME", "Đã đổi Theme: " .. themeName, 2)
	end
})

-- Đổi Font trực tiếp Realtime
SettingsTab:AddDropdown({
	Text = "Đổi Font",
	Items = Window:GetFonts(),
	Callback = function(fontName)
		Window:SetFont(fontName)
		Window:Notify("FONT", "Đã đổi Font: " .. fontName, 2)
	end
})

-- Nút tắt / Unload GUI
SettingsTab:AddButton({
	Text = "Unload UI",
	Callback = function()
		Window.ScreenGui:Destroy()
	end
})
