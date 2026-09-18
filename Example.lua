local PitayaUI = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL_HERE"))()

local Window = PitayaUI:CreateWindow({
	Title = "Pitaya Hub : Blox Fruits",
	Theme = "Pitaya",
	Font = "Gotham"
})

-- Tạo Tab Farm
local FarmTab = Window:CreateTab("Farm")

-- Thêm Section "Select tool"
FarmTab:AddSection("Select tool")

FarmTab:AddDropdown({
	Text = "Choose Weapon",
	Items = {"Melee", "Sword", "Blox Fruit"},
	Default = "Melee",
	Callback = function(selected)
		print("Đã chọn:", selected)
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

-- Thêm Section "Event"
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
