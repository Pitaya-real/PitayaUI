-- =================================================================
-- SCRIPT MẪU HƯỚNG DẪN SỬ DỤNG (EXAMPLE.LUA)
-- Tương thích hoàn toàn với Pitayauisource.lua v3.5
-- =================================================================

-- 1. Tải thư viện PitayaUI
-- (Thay link raw pastebin/github của bạn vào đây nếu đã tải file source lên)
local PitayaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourName/YourRepo/main/Pitayauisource.lua"))()

-- 2. Khởi tạo Cửa sổ chính (CreateWindow)
local Window = PitayaUI:CreateWindow({
	Title = "SCRIPT MASTER HUB - PITAYA EDITION",
	Logo = "rbxassetid://115347218827913",
	Theme = "PitayaUI",  -- Tùy chọn: "PitayaUI" hoặc "Dark"
	Font = "Gotham"      -- Tùy chọn: "Gotham", "FredokaOne", "BuilderSans"
})

-- Gửi thông báo Popup chào mừng
Window:Notify("PITAYA UI", "Đã tải giao diện thành công!", 4)

-- 3. Tạo các Tab chức năng dạng hàng ngang (Top Horizontal Tabs)
local MainTab = Window:CreateTab("Main", "🔥")
local TeleportTab = Window:CreateTab("Teleport", "🌐")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- =================================================================
-- TAB 1: MAIN (Chức năng chính)
-- =================================================================

-- Nút gạt Toggle Switch
MainTab:AddToggle({
	Text = "Auto Farm Level",
	Default = false,
	Callback = function(state)
		if state then
			print("Trạng thái Auto Farm: BẬT")
		else
			print("Trạng thái Auto Farm: TẮT")
		end
	end
})

MainTab:AddToggle({
	Text = "Auto Collect Coins",
	Default = true,
	Callback = function(state)
		print("Auto Coins:", state)
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

-- Dropdown kèm nút bấm Action "GO"
TeleportTab:AddDropdown({
	Text = "Chọn Đảo Dịch Chuyển",
	Items = {"Starter Island", "Pirate Island", "Marine Base", "Sky Island"},
	Callback = function(selectedItem)
		Window:Notify("TELEPORT", "Đang chuyển đến: " .. selectedItem, 3)
		print("Đã chọn dịch chuyển tới:", selectedItem)
	end
})

-- Nút bấm Button
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

-- Thay đổi Theme trực tiếp realtime
SettingsTab:AddDropdown({
	Text = "Đổi Theme",
	Items = Window:GetThemes(),
	Callback = function(themeName)
		Window:SetTheme(themeName)
		Window:Notify("THEME", "Đã đổi Theme thành: " .. themeName, 2)
	end
})

-- Thay đổi Font trực tiếp realtime
SettingsTab:AddDropdown({
	Text = "Đổi Font",
	Items = Window:GetFonts(),
	Callback = function(fontName)
		Window:SetFont(fontName)
		Window:Notify("FONT", "Đã đổi Font thành: " .. fontName, 2)
	end
})

-- Nút tắt GUI
SettingsTab:AddButton({
	Text = "Unload UI",
	Callback = function()
		Window.ScreenGui:Destroy()
	end
})
