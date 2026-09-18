local PitayaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pitaya-real/PitayaUI/refs/heads/main/Pitayauisource.lua"))()

local Window = PitayaUI:CreateWindow({
	Title = "RealKid Hub : Blox Fruits",
	Logo = "rbxassetid://115347218827913",
	Theme = "Pitaya"
})

Window:CreateTab("Discord")
Window:CreateTab("Server")
Window:CreateTab("Shop")

local FarmTab = Window:CreateTab("Farm")

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
		print("Độ cao:", val)
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

Window:CreateTab("Skill Settings")
Window:CreateTab("Hop Farm")
Window:CreateTab("Stack Farming")
Window:CreateTab("Fishing/Slap Fish")
Window:CreateTab("Esp")
