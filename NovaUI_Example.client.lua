--[[
	Ví dụ dùng NovaUI (cách viết giống Fluent)
	Loại script: LocalScript (đặt trong StarterPlayer > StarterPlayerScripts)
	Cần có ModuleScript tên "NovaUI" trong ReplicatedStorage.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NovaUI = require(ReplicatedStorage:WaitForChild("NovaUI"))

local Window = NovaUI:CreateWindow({
	Title = "NovaMenu",
	SubTitle = "Game của tôi",

	-- Đổi ảnh bằng code: dán Asset ID ảnh của bạn (số hoặc "rbxassetid://...").
	-- Để trống thì dùng chữ cái đầu của tên menu.
	Logo = "",
	FloatingIcon = "",

	Size = UDim2.fromOffset(620, 420), -- kéo góc dưới phải để giãn
	Accent = Color3.fromRGB(167, 139, 250),
	MinimizeKey = Enum.KeyCode.M, -- phím ẩn hoặc hiện menu
	Acrylic = true, -- làm nhòe nền game khi mở menu
})

local Tabs = {
	Audio = Window:AddTab({ Title = "Âm thanh" }),
	Graphics = Window:AddTab({ Title = "Đồ họa" }),
	Controls = Window:AddTab({ Title = "Điều khiển" }),
	Player = Window:AddTab({ Title = "Người chơi" }),
	Look = Window:AddTab({ Title = "Giao diện" }),
}

local Options = NovaUI.Options

---------------------------------------------------------------------
-- Âm thanh
---------------------------------------------------------------------
Tabs.Audio:AddSection("Nhạc")

Tabs.Audio:AddToggle("Music", {
	Title = "Bật nhạc nền",
	Description = "Phát nhạc khi vào game",
	Default = true,
})
Options.Music:OnChanged(function(on)
	print("Nhạc nền:", on)
end)

Tabs.Audio:AddSlider("MusicVolume", {
	Title = "Âm lượng nhạc",
	Description = "Điều chỉnh độ lớn nhạc nền",
	Default = 70,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
	Callback = function(value)
		print("Âm lượng nhạc:", value)
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
})

---------------------------------------------------------------------
-- Đồ họa
---------------------------------------------------------------------
Tabs.Graphics:AddSection("Hình ảnh")

-- Dropdown xổ ra sẽ đẩy các hàng bên dưới trượt xuống
Tabs.Graphics:AddDropdown("Quality", {
	Title = "Chất lượng hình ảnh",
	Description = "Giảm xuống nếu máy bị giật",
	Values = { "Thấp", "Trung bình", "Cao", "Siêu cao" },
	Default = 2, -- số thứ tự hoặc tên đều được
})

Tabs.Graphics:AddToggle("Shadows", {
	Title = "Đổ bóng",
	Description = "Bóng đổ của nhân vật và vật thể",
	Default = true,
	Callback = function(on)
		game:GetService("Lighting").GlobalShadows = on
	end,
})

Tabs.Graphics:AddButton({
	Title = "Đặt lại đồ họa",
	Description = "Trả về cài đặt mặc định",
	ButtonText = "Đặt lại",
	Callback = function()
		Options.Quality:SetValue("Trung bình")
		Options.Shadows:SetValue(true)
		NovaUI:Notify({ Title = "Đồ họa", Content = "Đã đặt lại về mặc định", Duration = 2.5 })
	end,
})

---------------------------------------------------------------------
-- Điều khiển
---------------------------------------------------------------------
Tabs.Controls:AddSection("Phím và camera")

Tabs.Controls:AddSlider("CameraSensitivity", {
	Title = "Độ nhạy camera",
	Description = "Tốc độ xoay khi kéo màn hình",
	Default = 50,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Suffix = "%",
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

Tabs.Controls:AddDropdown("MoveMode", {
	Title = "Kiểu di chuyển",
	Description = "Cách điều khiển nhân vật",
	Values = { "Cần điều khiển", "Chạm để đi" },
	Default = "Cần điều khiển",
})

---------------------------------------------------------------------
-- Người chơi
---------------------------------------------------------------------
Tabs.Player:AddSection("Hồ sơ")

Tabs.Player:AddInput("DisplayName", {
	Title = "Tên hiển thị",
	Description = "Nhấn Enter để lưu",
	Placeholder = "Nhập tên của bạn",
	Finished = true, -- chỉ chạy Callback khi nhấn Enter
	Callback = function(text)
		if text:gsub("%s", "") == "" then
			NovaUI:Notify({ Title = "Tên hiển thị", Content = "Hãy nhập nội dung trước" })
			return
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
		-- Gửi mã lên server bằng RemoteEvent của game bạn ở đây
		NovaUI:Notify({ Title = "Mã quà tặng", Content = "Đã gửi mã: " .. code })
	end,
})

Tabs.Player:AddToggle("ShowName", {
	Title = "Hiện tên trên đầu",
	Description = "Người khác thấy tên của bạn",
	Default = true,
})

Tabs.Player:AddParagraph({
	Title = "Ghi chú",
	Content = "Ô nhập, nút, đoạn ghi chú như thế này đều dùng được trong mọi tab.",
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

Tabs.Look:AddButton({
	Title = "Thông báo thử",
	Description = "Xem hiệu ứng thông báo",
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

-- Chọn tab đầu tiên
Window:SelectTab(1)

NovaUI:Notify({
	Title = "NovaMenu",
	Content = "Nhấn nút tròn hoặc phím M để ẩn hiện menu",
	Duration = 4,
})

-- Các hàm hay dùng khác:
--   Options.Music.Value                         đọc giá trị hiện tại
--   Options.Music:SetValue(false)               đổi giá trị bằng code
--   Window:SetLogo("rbxassetid://...")          đổi logo cạnh tên menu
--   Window:SetFloatingIcon("rbxassetid://...")  đổi ảnh nút nổi
--   Window:Open() / Window:Close() / Window:Toggle()
--   NovaUI:Destroy()
