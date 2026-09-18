local PitayaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pitaya-real/PitayaUI/refs/heads/main/Pitayauisource.lua"))()

local Window = PitayaUI:CreateWindow({
	Title = "RealKid Hub : Blox Fruits",
	Logo = "rbxassetid://115347218827913",
	Theme = "Pitaya",
	Font = "Gotham"
})

-- ========================================================
-- TAB CHÍNH: FARM
-- ========================================================
local FarmTab = Window:CreateTab("Farm")

FarmTab:AddSection("Select tool")

FarmTab:AddDropdown({
	Text = "Choose Weapon",
	Items = {"Melee", "Sword", "Blox Fruit"},
	Default = "Melee",
	Callback = function(selected)
		print("Đã chọn weapon:", selected)
	end
})

FarmTab:AddSlider({
	Text = "Độ cao Farm (Melee/Sword)",
	Min = 0,
	Max = 100,
	Default = 30,
	Callback = function(val)
		print("Độ cao farm:", val)
	end
})

FarmTab:AddSection("Event")

FarmTab:AddToggle({
	Text = "Auto Secret Quest",
	SubText = "Hỗ trợ làm nhiệm vụ bí mật 23/39 quest",
	Default = false,
	Callback = function(state)
		print("Auto Secret Quest:", state)
	end
})

FarmTab:AddButton({
	Text = "Random Magnet Event",
	SubText = "Quay ngẫu nhiên sự kiện bằng Magnet Token",
	Callback = function()
		Window:Notify("Thông Báo", "Đã bấm quay ngẫu nhiên!", 3)
	end
})

FarmTab:AddToggle({
	Text = "Auto Random Magnet Event",
	SubText = "Tự quay khi có ít nhất 500 Magnet Token",
	Default = false,
	Callback = function(state)
		print("Auto Random Magnet Event:", state)
	end
})

-- ========================================================
-- TAB SETTINGS: ĐỔI THEME VÀ FONT TRỰC TIẾP
-- ========================================================
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:AddSection("Giao Diện & Font Chữ")

SettingsTab:AddDropdown({
	Text = "Đổi Theme",
	Items = {"Pitaya", "Dark", "Blood", "Ocean"},
	Default = "Pitaya",
	Callback = function(selectedTheme)
		Window:SetTheme(selectedTheme)
		Window:Notify("Settings", "Đã đổi Theme sang: " .. selectedTheme, 2)
	end
})

SettingsTab:AddDropdown({
	Text = "Đổi Font",
	Items = {"Gotham", "Roboto", "Code", "SourceSans"},
	Default = "Gotham",
	Callback = function(selectedFont)
		Window:SetFont(selectedFont)
		Window:Notify("Settings", "Đã đổi Font sang: " .. selectedFont, 2)
	end
})
