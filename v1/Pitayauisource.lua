--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0 = {};
v0.__index = v0;
local v2 = game:GetService("Players");
local v3 = v2.LocalPlayer;
local v4 = v3:WaitForChild("PlayerGui");
local v5 = game:GetService("TweenService");
local v6 = game:GetService("UserInputService");
local v7 = game:GetService("Workspace");
v0.Themes = {PitayaUI={Background=Color3.fromRGB(18, 10, 16),Window=Color3.fromRGB(26, 13, 21),Border=Color3.fromRGB(44, 21, 32),TextMain=Color3.fromRGB(245, 238, 241),TextSub=Color3.fromRGB(166, 127, 143),Accent=Color3.fromRGB(232, 20, 111),AccentHover=Color3.fromRGB(250, 45, 130),SidebarUnselected=Color3.fromRGB(23, 12, 18),SidebarHover=Color3.fromRGB(40, 20, 30),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(76, 199, 89)}},Dark={Background=Color3.fromRGB(18, 18, 18),Window=Color3.fromRGB(28, 28, 28),Border=Color3.fromRGB(50, 50, 50),TextMain=Color3.fromRGB(240, 240, 240),TextSub=Color3.fromRGB(160, 160, 160),Accent=Color3.fromRGB(80, 140, 240),AccentHover=Color3.fromRGB(100, 160, 255),SidebarUnselected=Color3.fromRGB(38, 38, 38),SidebarHover=Color3.fromRGB(55, 55, 55),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}},Ocean={Background=Color3.fromRGB(10, 20, 30),Window=Color3.fromRGB(16, 30, 45),Border=Color3.fromRGB(30, 60, 85),TextMain=Color3.fromRGB(240, 248, 255),TextSub=Color3.fromRGB(130, 170, 200),Accent=Color3.fromRGB(0, 170, 230),AccentHover=Color3.fromRGB(30, 190, 255),SidebarUnselected=Color3.fromRGB(22, 42, 62),SidebarHover=Color3.fromRGB(32, 58, 85),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}},Emerald={Background=Color3.fromRGB(12, 24, 18),Window=Color3.fromRGB(18, 36, 28),Border=Color3.fromRGB(35, 70, 52),TextMain=Color3.fromRGB(240, 255, 245),TextSub=Color3.fromRGB(140, 185, 160),Accent=Color3.fromRGB(46, 204, 113),AccentHover=Color3.fromRGB(72, 220, 134),SidebarUnselected=Color3.fromRGB(26, 50, 38),SidebarHover=Color3.fromRGB(38, 72, 55),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}},Midnight={Background=Color3.fromRGB(8, 8, 14),Window=Color3.fromRGB(14, 14, 24),Border=Color3.fromRGB(30, 30, 50),TextMain=Color3.fromRGB(235, 235, 250),TextSub=Color3.fromRGB(130, 130, 160),Accent=Color3.fromRGB(110, 90, 240),AccentHover=Color3.fromRGB(130, 110, 255),SidebarUnselected=Color3.fromRGB(22, 22, 38),SidebarHover=Color3.fromRGB(34, 34, 56),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}},Cyberpunk={Background=Color3.fromRGB(20, 18, 10),Window=Color3.fromRGB(28, 25, 14),Border=Color3.fromRGB(70, 60, 20),TextMain=Color3.fromRGB(255, 255, 240),TextSub=Color3.fromRGB(180, 170, 110),Accent=Color3.fromRGB(255, 210, 0),AccentHover=Color3.fromRGB(255, 225, 50),SidebarUnselected=Color3.fromRGB(40, 36, 20),SidebarHover=Color3.fromRGB(60, 54, 30),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}},Blood={Background=Color3.fromRGB(20, 12, 12),Window=Color3.fromRGB(30, 18, 18),Border=Color3.fromRGB(65, 30, 30),TextMain=Color3.fromRGB(255, 240, 240),TextSub=Color3.fromRGB(180, 130, 130),Accent=Color3.fromRGB(235, 60, 60),AccentHover=Color3.fromRGB(255, 85, 85),SidebarUnselected=Color3.fromRGB(42, 24, 24),SidebarHover=Color3.fromRGB(62, 35, 35),Dots={Color3.fromRGB(255, 90, 90),Color3.fromRGB(255, 180, 50),Color3.fromRGB(50, 200, 100)}}};
v0.FontPresets = {Gotham={Main=Enum.Font.Gotham,Bold=Enum.Font.GothamBold,Medium=Enum.Font.GothamMedium},Roboto={Main=Enum.Font.Roboto,Bold=Enum.Font.RobotoCondensed,Medium=Enum.Font.Roboto},FredokaOne={Main=Enum.Font.FredokaOne,Bold=Enum.Font.FredokaOne,Medium=Enum.Font.FredokaOne},SourceSans={Main=Enum.Font.SourceSans,Bold=Enum.Font.SourceSansBold,Medium=Enum.Font.SourceSansSemibold},Ubuntu={Main=Enum.Font.Ubuntu,Bold=Enum.Font.Ubuntu,Medium=Enum.Font.Ubuntu},Arcade={Main=Enum.Font.Arcade,Bold=Enum.Font.Arcade,Medium=Enum.Font.Arcade},BuilderSans={Main=Enum.Font.BuilderSans,Bold=Enum.Font.BuilderSansBold,Medium=Enum.Font.BuilderSansMedium}};
local function v10(v21, v22)
	local v23 = Instance.new("UICorner", v21);
	v23.CornerRadius = UDim.new(0, v22);
	return v23;
end
local function v11(v25, v26)
	local v27 = Instance.new("UIStroke", v25);
	v27.Color = v26;
	v27.Thickness = 1;
	return v27;
end
v0.BindTheme = function(v30, v31, v32, v33)
	table.insert(v30.ThemeObjects, {Instance=v31,Property=v32,Role=v33});
	if (v30.Colors[v33] or (4593 <= 2672)) then
		v31[v32] = v30.Colors[v33];
	end
	return v31;
end;
v0.SetTheme = function(v34, v35)
	local v36 = v0.Themes[v35];
	if not v36 then
		return;
	end
	v34.CurrentThemeName = v35;
	for v253, v254 in pairs(v36) do
		v34.Colors[v253] = v254;
	end
	for v256, v257 in ipairs(v34.ThemeObjects) do
		if ((v257.Instance and v257.Instance.Parent) or (1168 > 3156)) then
			if v34.Colors[v257.Role] then
				v5:Create(v257.Instance, TweenInfo.new(0.3), {[v257.Property]=v34.Colors[v257.Role]}):Play();
			end
		end
	end
end;
v0.GetThemes = function(v38)
	local v39 = {};
	for v258, v259 in pairs(v0.Themes) do
		table.insert(v39, v258);
	end
	table.sort(v39);
	return v39;
end;
v0.BindFont = function(v40, v41, v42)
	table.insert(v40.FontObjects, {Instance=v41,Role=(v42 or "Main")});
	if v40.Fonts[v42] then
		v41.Font = v40.Fonts[v42];
	end
	return v41;
end;
v0.SetFont = function(v43, v44)
	local v45 = v0.FontPresets[v44];
	if (not v45 or (572 > 4486)) then
		return;
	end
	v43.CurrentFontName = v44;
	v43.Fonts = v45;
	for v260, v261 in ipairs(v43.FontObjects) do
		if (v261.Instance and v261.Instance.Parent and v43.Fonts[v261.Role]) then
			v261.Instance.Font = v43.Fonts[v261.Role];
		end
	end
end;
v0.GetFonts = function(v48)
	local v49 = {};
	for v262, v263 in pairs(v0.FontPresets) do
		table.insert(v49, v262);
	end
	table.sort(v49);
	return v49;
end;
v0.CreateWindow = function(v50, v51)
	v51 = v51 or {};
	local v52 = setmetatable({}, v0);
	v52.TitleText = v51.Title or "Pitaya Hub | Reilo";
	v52.LogoId = v51.Logo or "rbxassetid://73866843639743";
	v52.ShowLoading = ((v51.Loading == nil) and true) or v51.Loading;
	v52.LoadingTitle = v51.LoadingTitle or "Pitaya Hub";
	v52.Tabs = {};
	v52.ThemeObjects = {};
	v52.FontObjects = {};
	local v60 = v51.Theme or "PitayaUI";
	local v61 = v0.Themes[v60] or v0.Themes.PitayaUI;
	v52.Colors = {};
	for v264, v265 in pairs(v61) do
		v52.Colors[v264] = v265;
	end
	v52.CurrentThemeName = v60;
	local v64 = v51.Font or "Gotham";
	v52.Fonts = v0.FontPresets[v64] or v0.FontPresets.Gotham;
	v52.CurrentFontName = v64;
	local v67 = Instance.new("ScreenGui");
	v67.Name = game:GetService("HttpService"):GenerateGUID(false);
	v67.ResetOnSpawn = false;
	if gethui then
		v67.Parent = gethui();
	elseif ((1404 == 1404) and syn and syn.protect_gui) then
		syn.protect_gui(v67);
		v67.Parent = game:GetService("CoreGui");
	else
		local v603, v604 = pcall(function()
			v67.Parent = game:GetService("CoreGui");
		end);
		if (not v603 or (3748 < 2212)) then
			local v614 = ((typeof(v4) ~= "nil") and v4) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
			v67.Parent = v614;
		end
	end
	v52.ScreenGui = v67;
	local v71 = v7.CurrentCamera;
	local v72 = (v71 and v71.ViewportSize) or Vector2.new(1280, 720);
	local v73 = math.floor(math.min(620, v72.X * 0.88));
	local v74 = math.floor(math.min(380, v72.Y * 0.85));
	v73 = math.clamp(v73, 340, 1200);
	v74 = math.clamp(v74, 230, 800);
	v52.SavedWidth = v73;
	v52.SavedHeight = v74;
	local v77;
	if (v52.ShowLoading or (1180 == 2180)) then
		v77 = Instance.new("Frame", v67);
		v77.Name = "LoadingFrame";
		v77.Size = UDim2.new(0, 320, 0, 190);
		v77.Position = UDim2.new(0.5, -160, 0.5, -95);
		v77.BackgroundColor3 = v52.Colors.Window;
		v77.ClipsDescendants = true;
		v10(v77, 12);
		local v498 = v11(v77, v52.Colors.Border);
		v52:BindTheme(v77, "BackgroundColor3", "Window");
		v52:BindTheme(v498, "Color", "Border");
		local v499 = Instance.new("ImageLabel", v77);
		v499.Size = UDim2.new(0, 50, 0, 50);
		v499.Position = UDim2.new(0.5, -25, 0, 18);
		v499.BackgroundTransparency = 1;
		v499.Image = v52.LogoId;
		local v505 = Instance.new("TextLabel", v77);
		v505.Size = UDim2.new(1, 0, 0, 20);
		v505.Position = UDim2.new(0, 0, 0, 75);
		v505.BackgroundTransparency = 1;
		v505.Text = v52.LoadingTitle;
		v505.TextColor3 = v52.Colors.TextMain;
		v505.TextSize = 14;
		v505.RichText = true;
		v52:BindTheme(v505, "TextColor3", "TextMain");
		v52:BindFont(v505, "Bold");
		local v515 = Instance.new("TextLabel", v77);
		v515.Size = UDim2.new(1, 0, 0, 18);
		v515.Position = UDim2.new(0, 0, 0, 98);
		v515.BackgroundTransparency = 1;
		v515.Text = "Đang tải tài nguyên...";
		v515.TextColor3 = v52.Colors.TextSub;
		v515.TextSize = 11;
		v515.RichText = true;
		v52:BindTheme(v515, "TextColor3", "TextSub");
		v52:BindFont(v515, "Main");
		local v524 = Instance.new("Frame", v77);
		v524.Size = UDim2.new(0.8, 0, 0, 6);
		v524.Position = UDim2.new(0.1, 0, 0, 130);
		v524.BackgroundColor3 = v52.Colors.SidebarUnselected;
		v10(v524, 3);
		v52:BindTheme(v524, "BackgroundColor3", "SidebarUnselected");
		local v529 = Instance.new("Frame", v524);
		v529.Size = UDim2.new(0, 0, 1, 0);
		v529.BackgroundColor3 = v52.Colors.Accent;
		v10(v529, 3);
		v52:BindTheme(v529, "BackgroundColor3", "Accent");
		local v533 = Instance.new("TextLabel", v77);
		v533.Size = UDim2.new(1, 0, 0, 18);
		v533.Position = UDim2.new(0, 0, 0, 145);
		v533.BackgroundTransparency = 1;
		v533.Text = "0%";
		v533.TextColor3 = v52.Colors.Accent;
		v533.TextSize = 11;
		v52:BindTheme(v533, "TextColor3", "Accent");
		v52:BindFont(v533, "Bold");
		task.spawn(function()
			local v572 = {{p=0.25,txt="Đang khởi tạo Theme..."},{p=0.55,txt="Đang cấu hình giao diện..."},{p=0.85,txt="Đang chuẩn bị thành phần..."},{p=1,txt="Hoàn tất!"}};
			for v605, v606 in ipairs(v572) do
				v5:Create(v529, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=UDim2.new(v606.p, 0, 1, 0)}):Play();
				v515.Text = v606.txt;
				v533.Text = math.floor(v606.p * 100) .. "%";
				task.wait(0.4);
			end
			task.wait(0.2);
			v5:Create(v77, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0),Position=UDim2.new(0.5, 0, 0.5, 0)}):Play();
			task.wait(0.3);
			v77:Destroy();
		end);
	end
	local v78 = Instance.new("Frame", v67);
	v78.Name = "NotifContainer";
	v78.Size = UDim2.new(0, 280, 1, -40);
	v78.Position = UDim2.new(1, -300, 0, 20);
	v78.BackgroundTransparency = 1;
	v52.NotifContainer = v78;
	local v84 = Instance.new("UIListLayout", v78);
	v84.SortOrder = Enum.SortOrder.LayoutOrder;
	v84.VerticalAlignment = Enum.VerticalAlignment.Bottom;
	v84.Padding = UDim.new(0, 10);
	local v90 = Instance.new("ImageButton", v67);
	v90.Name = "OpenCloseToggle";
	v90.Size = UDim2.new(0, 46, 0, 46);
	v90.Position = UDim2.new(0, 25, 0, 100);
	v90.BackgroundColor3 = v52.Colors.Window;
	v90.Image = v52.LogoId;
	v90.Active = true;
	v90.Draggable = true;
	v10(v90, 23);
	local v99 = v11(v90, v52.Colors.Accent);
	v52:BindTheme(v90, "BackgroundColor3", "Window");
	v52:BindTheme(v99, "Color", "Accent");
	local v100 = Instance.new("Frame", v67);
	v100.Name = "MainFrame";
	v100.Size = UDim2.new(0, v52.SavedWidth, 0, v52.SavedHeight);
	v100.Position = UDim2.new(0.5, -v52.SavedWidth / 2, 0.5, -v52.SavedHeight / 2);
	v100.BackgroundColor3 = v52.Colors.Window;
	v100.Active = true;
	v100.Draggable = true;
	v100.ClipsDescendants = true;
	v100.Visible = not v52.ShowLoading;
	v10(v100, 10);
	local v109 = v11(v100, v52.Colors.Border);
	v52:BindTheme(v100, "BackgroundColor3", "Window");
	v52:BindTheme(v109, "Color", "Border");
	v52.MainFrame = v100;
	if ((4090 < 4653) and v52.ShowLoading) then
		task.delay(1.9, function()
			v100.Visible = true;
		end);
	end
	local v111 = true;
	v90.MouseButton1Click:Connect(function()
		v111 = not v111;
		if v111 then
			v100.Visible = true;
			v5:Create(v100, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=UDim2.new(0, v52.SavedWidth, 0, v52.SavedHeight),Position=UDim2.new(0.5, -v52.SavedWidth / 2, 0.5, -v52.SavedHeight / 2)}):Play();
		else
			local v575 = v5:Create(v100, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0),Position=UDim2.new(0.5, 0, 0.5, 0)});
			v575:Play();
			v575.Completed:Connect(function()
				if (not v111 or (2652 < 196)) then
					v100.Visible = false;
				end
			end);
		end
	end);
	local v112 = Instance.new("Frame", v100);
	v112.Size = UDim2.new(1, 0, 0, 40);
	v112.BackgroundTransparency = 1;
	local v115 = {};
	for v267, v268 in ipairs(v52.Colors.Dots) do
		local v269 = Instance.new("TextButton", v112);
		v269.Size = UDim2.new(0, 10, 0, 10);
		v269.Position = UDim2.new(0, 15 + ((v267 - 1) * 18), 0, 15);
		v269.BackgroundColor3 = v268;
		v269.Text = "";
		v269.AutoButtonColor = false;
		v10(v269, 5);
		table.insert(v115, v269);
	end
	local v116 = v115[1];
	local v117 = v115[2];
	v116.MouseButton1Click:Connect(function()
		if v67 then
			v67:Destroy();
		end
	end);
	local v118 = false;
	v117.MouseButton1Click:Connect(function()
		v118 = not v118;
		v100.Visible = not v118;
	end);
	local v119 = Instance.new("TextLabel", v112);
	v119.Size = UDim2.new(1, -100, 1, 0);
	v119.Position = UDim2.new(0, 80, 0, 0);
	v119.BackgroundTransparency = 1;
	v119.Text = v52.TitleText;
	v119.TextColor3 = v52.Colors.TextSub;
	v119.TextSize = 13;
	v119.RichText = true;
	v119.TextXAlignment = Enum.TextXAlignment.Center;
	v52:BindTheme(v119, "TextColor3", "TextSub");
	v52:BindFont(v119, "Bold");
	v52.TitleLabel = v119;
	local v131 = Instance.new("Frame", v112);
	v131.Size = UDim2.new(1, 0, 0, 1);
	v131.Position = UDim2.new(0, 0, 1, 0);
	v131.BackgroundColor3 = v52.Colors.Border;
	v52:BindTheme(v131, "BackgroundColor3", "Border");
	local v136 = Instance.new("Frame", v100);
	v136.Size = UDim2.new(0, 140, 1, -41);
	v136.Position = UDim2.new(0, 0, 0, 41);
	v136.BackgroundTransparency = 1;
	local v140 = Instance.new("Frame", v136);
	v140.Size = UDim2.new(0, 1, 1, 0);
	v140.Position = UDim2.new(1, 0, 0, 0);
	v140.BackgroundColor3 = v52.Colors.Border;
	v52:BindTheme(v140, "BackgroundColor3", "Border");
	local v144 = Instance.new("ImageLabel", v136);
	v144.Size = UDim2.new(0, 48, 0, 48);
	v144.Position = UDim2.new(0.5, -24, 0, 10);
	v144.BackgroundTransparency = 1;
	v144.Image = v52.LogoId;
	local v149 = Instance.new("Frame", v136);
	v149.Size = UDim2.new(1, -16, 1, -75);
	v149.Position = UDim2.new(0, 8, 0, 68);
	v149.BackgroundTransparency = 1;
	local v153 = Instance.new("UIListLayout", v149);
	v153.SortOrder = Enum.SortOrder.LayoutOrder;
	v153.Padding = UDim.new(0, 6);
	local v156 = Instance.new("Frame", v100);
	v156.Size = UDim2.new(1, -141, 1, -41);
	v156.Position = UDim2.new(0, 141, 0, 41);
	v156.BackgroundTransparency = 1;
	v52.ContentArea = v156;
	v52.TabListContainer = v149;
	local v162 = Instance.new("TextButton", v100);
	v162.Name = "ResizeHandle";
	v162.Size = UDim2.new(0, 18, 0, 18);
	v162.Position = UDim2.new(1, -18, 1, -18);
	v162.BackgroundTransparency = 1;
	v162.Text = "◢";
	v162.TextColor3 = v52.Colors.TextSub;
	v162.TextSize = 13;
	v162.ZIndex = 100;
	v52:BindTheme(v162, "TextColor3", "TextSub");
	v52:BindFont(v162, "Bold");
	local v171 = false;
	local v172, v173;
	v162.InputBegan:Connect(function(v276)
		if ((4135 < 4817) and ((v276.UserInputType == Enum.UserInputType.MouseButton1) or (v276.UserInputType == Enum.UserInputType.Touch))) then
			v171 = true;
			v172 = v276.Position;
			v173 = v100.Size;
		end
	end);
	v6.InputChanged:Connect(function(v277)
		if (v171 and ((v277.UserInputType == Enum.UserInputType.MouseMovement) or (v277.UserInputType == Enum.UserInputType.Touch))) then
			local v578 = v7.CurrentCamera;
			local v579 = (v578 and v578.ViewportSize) or Vector2.new(1280, 720);
			local v580 = v277.Position - v172;
			local v581 = math.clamp(v173.X.Offset + v580.X, 340, math.max(340, v579.X - 20));
			local v582 = math.clamp(v173.Y.Offset + v580.Y, 230, math.max(230, v579.Y - 20));
			v52.SavedWidth = v581;
			v52.SavedHeight = v582;
			v100.Size = UDim2.new(0, v581, 0, v582);
		end
	end);
	v6.InputEnded:Connect(function(v278)
		if ((272 == 272) and ((v278.UserInputType == Enum.UserInputType.MouseButton1) or (v278.UserInputType == Enum.UserInputType.Touch))) then
			v171 = false;
		end
	end);
	task.spawn(function()
		if v52.ShowLoading then
			task.wait(2);
		end
		v52:Notify("Hệ Thống", "Giao diện đã tải hoàn tất!", 4);
	end);
	return v52;
end;
v0.Notify = function(v174, v175, v176, v177)
	v177 = v177 or 3;
	local v178 = Instance.new("Frame", v174.NotifContainer);
	v178.Size = UDim2.new(1, 0, 0, 60);
	v178.Position = UDim2.new(1, 50, 0, 0);
	v178.BackgroundColor3 = v174.Colors.Window;
	v178.BackgroundTransparency = 1;
	v10(v178, 6);
	local v184 = v11(v178, v174.Colors.Border);
	v184.Transparency = 1;
	v174:BindTheme(v178, "BackgroundColor3", "Window");
	v174:BindTheme(v184, "Color", "Border");
	local v186 = Instance.new("TextLabel", v178);
	v186.Size = UDim2.new(1, -20, 0, 20);
	v186.Position = UDim2.new(0, 10, 0, 5);
	v186.BackgroundTransparency = 1;
	v186.Text = v175;
	v186.TextColor3 = v174.Colors.Accent;
	v186.TextSize = 13;
	v186.RichText = true;
	v186.TextXAlignment = Enum.TextXAlignment.Left;
	v186.TextTransparency = 1;
	v174:BindTheme(v186, "TextColor3", "Accent");
	v174:BindFont(v186, "Bold");
	local v198 = Instance.new("TextLabel", v178);
	v198.Size = UDim2.new(1, -20, 0, 25);
	v198.Position = UDim2.new(0, 10, 0, 25);
	v198.BackgroundTransparency = 1;
	v198.Text = v176;
	v198.TextColor3 = v174.Colors.TextMain;
	v198.TextSize = 12;
	v198.RichText = true;
	v198.TextXAlignment = Enum.TextXAlignment.Left;
	v198.TextWrapped = true;
	v198.TextTransparency = 1;
	v174:BindTheme(v198, "TextColor3", "TextMain");
	v174:BindFont(v198, "Main");
	v5:Create(v178, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=UDim2.new(0, 0, 0, 0),BackgroundTransparency=0}):Play();
	v5:Create(v184, TweenInfo.new(0.4), {Transparency=0}):Play();
	v5:Create(v186, TweenInfo.new(0.4), {TextTransparency=0}):Play();
	v5:Create(v198, TweenInfo.new(0.4), {TextTransparency=0}):Play();
	task.delay(v177, function()
		local v279 = v5:Create(v178, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position=UDim2.new(1, 50, 0, 0),BackgroundTransparency=1});
		v5:Create(v184, TweenInfo.new(0.4), {Transparency=1}):Play();
		v5:Create(v186, TweenInfo.new(0.4), {TextTransparency=1}):Play();
		v5:Create(v198, TweenInfo.new(0.4), {TextTransparency=1}):Play();
		v279:Play();
		v279.Completed:Connect(function()
			v178:Destroy();
		end);
	end);
end;
v0.CreateTab = function(v210, v211, v212)
	local v213 = {};
	local v214 = v210;
	local v215 = Instance.new("ScrollingFrame", v214.ContentArea);
	v215.Size = UDim2.new(1, -20, 1, -20);
	v215.Position = UDim2.new(0, 10, 0, 10);
	v215.BackgroundTransparency = 1;
	v215.ScrollBarThickness = 2;
	v215.Visible = false;
	local v221 = Instance.new("UIListLayout", v215);
	v221.SortOrder = Enum.SortOrder.LayoutOrder;
	v221.Padding = UDim.new(0, 8);
	local v225 = Instance.new("TextButton", v214.TabListContainer);
	v225.Size = UDim2.new(1, 0, 0, 36);
	v225.BackgroundColor3 = v214.Colors.SidebarUnselected;
	v225.Text = "";
	v225.AutoButtonColor = false;
	v10(v225, 8);
	v214:BindTheme(v225, "BackgroundColor3", "SidebarUnselected");
	local v231 = v212 and (v212 ~= "");
	if v231 then
		local v540 = Instance.new("TextLabel", v225);
		v540.Size = UDim2.new(0, 24, 1, 0);
		v540.Position = UDim2.new(0, 8, 0, 0);
		v540.BackgroundTransparency = 1;
		v540.Text = v212;
		v540.TextColor3 = v214.Colors.TextSub;
		v540.TextSize = 14;
		v540.RichText = true;
		v540.TextXAlignment = Enum.TextXAlignment.Center;
		v214:BindTheme(v540, "TextColor3", "TextSub");
		v214:BindFont(v540, "Medium");
		v213.IconLabel = v540;
	end
	local v232 = Instance.new("TextLabel", v225);
	v232.Size = UDim2.new(1, (v231 and -32) or -16, 1, 0);
	v232.Position = UDim2.new(0, (v231 and 32) or 8, 0, 0);
	v232.BackgroundTransparency = 1;
	v232.Text = v211;
	v232.TextColor3 = v214.Colors.TextSub;
	v232.TextSize = 13;
	v232.RichText = true;
	v232.TextXAlignment = Enum.TextXAlignment.Left;
	v214:BindTheme(v232, "TextColor3", "TextSub");
	v214:BindFont(v232, "Medium");
	local function v243()
		for v552, v553 in ipairs(v214.Tabs) do
			v553.Page.Visible = false;
			v5:Create(v553.Button, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.SidebarUnselected}):Play();
			for v586, v587 in ipairs(v553.Button:GetChildren()) do
				if ((100 <= 3123) and v587:IsA("TextLabel")) then
					v587.TextColor3 = v214.Colors.TextSub;
				end
			end
		end
		v215.Position = UDim2.new(0, 20, 0, 10);
		v215.Visible = true;
		v214.TitleLabel.Text = v214.TitleText .. " - " .. v211;
		v5:Create(v215, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position=UDim2.new(0, 10, 0, 10)}):Play();
		v5:Create(v225, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.Accent}):Play();
		v232.TextColor3 = v214.Colors.TextMain;
		if v213.IconLabel then
			v213.IconLabel.TextColor3 = v214.Colors.TextMain;
		end
	end
	v225.MouseEnter:Connect(function()
		if not v215.Visible then
			v5:Create(v225, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.SidebarHover}):Play();
		end
	end);
	v225.MouseLeave:Connect(function()
		if (not v215.Visible or (1369 > 4987)) then
			v5:Create(v225, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.SidebarUnselected}):Play();
		end
	end);
	v225.MouseButton1Click:Connect(v243);
	v213.Page = v215;
	v213.Button = v225;
	table.insert(v214.Tabs, v213);
	if (#v214.Tabs == 1) then
		v243();
	end
	local function v246(v285, v286)
		if (v286 and not string.find(v285, "<b>")) then
			return "<b>" .. v285 .. "</b>";
		end
		return v285;
	end
	v213.AddLabel = function(v287, v288, v289)
		v289 = ((type(v289) == "table") and v289) or {};
		local v290 = v289.BoldText or false;
		local v291 = Instance.new("TextLabel", v215);
		v291.Size = UDim2.new(1, 0, 0, 22);
		v291.BackgroundTransparency = 1;
		v291.RichText = true;
		v291.Text = v246(v288, v290);
		v291.TextColor3 = v214.Colors.TextSub;
		v291.TextSize = 12;
		v291.TextXAlignment = Enum.TextXAlignment.Left;
		v214:BindTheme(v291, "TextColor3", "TextSub");
		v214:BindFont(v291, (v290 and "Bold") or "Main");
	end;
	v213.AddButton = function(v301, v302)
		v302 = v302 or {};
		local v303 = v302.Text or "Button";
		local v304 = v302.BoldText or false;
		local v305 = v302.Callback or function()
		end;
		local v306 = Instance.new("TextButton", v215);
		v306.Size = UDim2.new(1, -5, 0, 38);
		v306.BackgroundColor3 = v214.Colors.Accent;
		v306.RichText = true;
		v306.Text = v246(v303, v304);
		v306.TextColor3 = v214.Colors.TextMain;
		v306.TextSize = 13;
		v306.AutoButtonColor = false;
		v10(v306, 6);
		v214:BindTheme(v306, "BackgroundColor3", "Accent");
		v214:BindTheme(v306, "TextColor3", "TextMain");
		v214:BindFont(v306, "Bold");
		v306.MouseEnter:Connect(function()
			v5:Create(v306, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.AccentHover}):Play();
		end);
		v306.MouseLeave:Connect(function()
			v5:Create(v306, TweenInfo.new(0.2), {BackgroundColor3=v214.Colors.Accent}):Play();
		end);
		v306.MouseButton1Down:Connect(function()
			v5:Create(v306, TweenInfo.new(0.1), {Size=UDim2.new(1, -9, 0, 35)}):Play();
		end);
		v306.MouseButton1Up:Connect(function()
			v5:Create(v306, TweenInfo.new(0.1), {Size=UDim2.new(1, -5, 0, 38)}):Play();
		end);
		v306.MouseButton1Click:Connect(v305);
	end;
	v213.AddToggle = function(v316, v317)
		v317 = v317 or {};
		local v318 = v317.Text or "Toggle";
		local v319 = v317.BoldText or false;
		local v320 = v317.Default or false;
		local v321 = v317.Callback or function()
		end;
		local v322 = Instance.new("Frame", v215);
		v322.Size = UDim2.new(1, -5, 0, 38);
		v322.BackgroundColor3 = v214.Colors.Background;
		v10(v322, 6);
		local v326 = v11(v322, v214.Colors.Border);
		v214:BindTheme(v322, "BackgroundColor3", "Background");
		v214:BindTheme(v326, "Color", "Border");
		local v327 = Instance.new("TextLabel", v322);
		v327.Size = UDim2.new(1, -65, 1, 0);
		v327.Position = UDim2.new(0, 12, 0, 0);
		v327.BackgroundTransparency = 1;
		v327.RichText = true;
		v327.Text = v246(v318, v319);
		v327.TextColor3 = v214.Colors.TextMain;
		v327.TextSize = 13;
		v327.TextXAlignment = Enum.TextXAlignment.Left;
		v214:BindTheme(v327, "TextColor3", "TextMain");
		v214:BindFont(v327, (v319 and "Bold") or "Medium");
		local v338 = Instance.new("TextButton", v322);
		v338.Size = UDim2.new(0, 44, 0, 22);
		v338.Position = UDim2.new(1, -52, 0.5, -11);
		v338.BackgroundColor3 = (v320 and v214.Colors.Accent) or v214.Colors.SidebarUnselected;
		v338.Text = "";
		v338.AutoButtonColor = false;
		v10(v338, 11);
		local v344 = Instance.new("Frame", v338);
		v344.Size = UDim2.new(0, 16, 0, 16);
		v344.Position = UDim2.new(0, (v320 and 24) or 4, 0, 3);
		v344.BackgroundColor3 = v214.Colors.TextMain;
		v10(v344, 8);
		v214:BindTheme(v344, "BackgroundColor3", "TextMain");
		local v348 = v320;
		v338.MouseButton1Click:Connect(function()
			v348 = not v348;
			v5:Create(v338, TweenInfo.new(0.2), {BackgroundColor3=((v348 and v214.Colors.Accent) or v214.Colors.SidebarUnselected)}):Play();
			v5:Create(v344, TweenInfo.new(0.2), {Position=UDim2.new(0, (v348 and 24) or 4, 0, 3)}):Play();
			v321(v348);
		end);
	end;
	v213.AddSlider = function(v349, v350)
		v350 = v350 or {};
		local v351 = v350.Text or "Slider";
		local v352 = v350.BoldText or false;
		local v353 = v350.Min or 0;
		local v354 = v350.Max or 100;
		local v355 = v350.Default or v353;
		local v356 = v350.Callback or function()
		end;
		local v357 = Instance.new("Frame", v215);
		v357.Size = UDim2.new(1, -5, 0, 48);
		v357.BackgroundColor3 = v214.Colors.Background;
		v10(v357, 6);
		local v361 = v11(v357, v214.Colors.Border);
		v214:BindTheme(v357, "BackgroundColor3", "Background");
		v214:BindTheme(v361, "Color", "Border");
		local v362 = Instance.new("TextLabel", v357);
		v362.Size = UDim2.new(1, -60, 0, 22);
		v362.Position = UDim2.new(0, 12, 0, 2);
		v362.BackgroundTransparency = 1;
		v362.RichText = true;
		v362.Text = v246(v351, v352);
		v362.TextColor3 = v214.Colors.TextMain;
		v362.TextSize = 13;
		v362.TextXAlignment = Enum.TextXAlignment.Left;
		v214:BindTheme(v362, "TextColor3", "TextMain");
		v214:BindFont(v362, (v352 and "Bold") or "Medium");
		local v373 = Instance.new("TextLabel", v357);
		v373.Size = UDim2.new(0, 50, 0, 22);
		v373.Position = UDim2.new(1, -60, 0, 2);
		v373.BackgroundTransparency = 1;
		v373.Text = tostring(v355);
		v373.TextColor3 = v214.Colors.Accent;
		v373.TextSize = 13;
		v214:BindTheme(v373, "TextColor3", "Accent");
		v214:BindFont(v373, "Bold");
		local v381 = Instance.new("Frame", v357);
		v381.Size = UDim2.new(1, -24, 0, 6);
		v381.Position = UDim2.new(0, 12, 0, 32);
		v381.BackgroundColor3 = v214.Colors.SidebarUnselected;
		v10(v381, 3);
		v214:BindTheme(v381, "BackgroundColor3", "SidebarUnselected");
		local v386 = Instance.new("Frame", v381);
		v386.Size = UDim2.new((v355 - v353) / (v354 - v353), 0, 1, 0);
		v386.BackgroundColor3 = v214.Colors.Accent;
		v10(v386, 3);
		v214:BindTheme(v386, "BackgroundColor3", "Accent");
		local v389 = false;
		local function v390(v555)
			local v556 = math.clamp((v555.Position.X - v381.AbsolutePosition.X) / v381.AbsoluteSize.X, 0, 1);
			local v557 = math.floor(v353 + ((v354 - v353) * v556));
			v373.Text = tostring(v557);
			v5:Create(v386, TweenInfo.new(0.05), {Size=UDim2.new(v556, 0, 1, 0)}):Play();
			v356(v557);
		end
		v381.InputBegan:Connect(function(v559)
			if ((v559.UserInputType == Enum.UserInputType.MouseButton1) or (v559.UserInputType == Enum.UserInputType.Touch) or (863 >= 4584)) then
				v389 = true;
				v390(v559);
			end
		end);
		v6.InputEnded:Connect(function(v560)
			if ((v560.UserInputType == Enum.UserInputType.MouseButton1) or (v560.UserInputType == Enum.UserInputType.Touch) or (724 >= 1668)) then
				v389 = false;
			end
		end);
		v6.InputChanged:Connect(function(v561)
			if ((428 < 1804) and v389 and ((v561.UserInputType == Enum.UserInputType.MouseMovement) or (v561.UserInputType == Enum.UserInputType.Touch))) then
				v390(v561);
			end
		end);
	end;
	v213.AddDropdown = function(v391, v392)
		v392 = v392 or {};
		local v393 = v392.Text or "Dropdown";
		local v394 = v392.BoldText or false;
		local v395 = v392.Items or {};
		local v396 = v392.Default or v395[1] or "";
		local v397 = v392.Callback or function()
		end;
		local v398 = false;
		local v399 = 38;
		local v400 = 32;
		local v401 = 4;
		local v402 = v396;
		local v403 = math.clamp(#v395, 1, v401);
		v215.ClipsDescendants = false;
		local v405 = Instance.new("Frame", v215);
		v405.Name = "Dropdown";
		v405.Size = UDim2.new(1, -5, 0, v399);
		v405.BackgroundColor3 = v214.Colors.Background;
		v10(v405, 6);
		local v410 = v11(v405, v214.Colors.Border);
		v214:BindTheme(v405, "BackgroundColor3", "Background");
		v214:BindTheme(v410, "Color", "Border");
		local v411 = Instance.new("TextLabel", v405);
		v411.Size = UDim2.new(1, -40, 0, v399);
		v411.Position = UDim2.new(0, 12, 0, 0);
		v411.BackgroundTransparency = 1;
		v411.RichText = true;
		v411.Text = v246(v393, v394) .. ": " .. tostring(v402);
		v411.TextColor3 = v214.Colors.TextMain;
		v411.TextSize = 13;
		v411.TextXAlignment = Enum.TextXAlignment.Left;
		v214:BindTheme(v411, "TextColor3", "TextMain");
		v214:BindFont(v411, (v394 and "Bold") or "Medium");
		local v422 = Instance.new("TextLabel", v405);
		v422.Size = UDim2.new(0, 30, 0, v399);
		v422.Position = UDim2.new(1, -35, 0, 0);
		v422.BackgroundTransparency = 1;
		v422.Text = "▼";
		v422.TextColor3 = v214.Colors.TextSub;
		v422.TextSize = 11;
		v214:BindTheme(v422, "TextColor3", "TextSub");
		v214:BindFont(v422, "Bold");
		local v430 = Instance.new("ScrollingFrame", v405);
		v430.Size = UDim2.new(1, 0, 0, 0);
		v430.Position = UDim2.new(0, 0, 0, v399 + 4);
		v430.BackgroundColor3 = v214.Colors.Window;
		v430.BorderSizePixel = 0;
		v430.ZIndex = 50;
		v430.CanvasSize = UDim2.new(0, 0, 0, #v395 * v400);
		v430.ScrollBarThickness = 2;
		v430.ClipsDescendants = true;
		v10(v430, 6);
		local v440 = v11(v430, v214.Colors.Border);
		v214:BindTheme(v430, "BackgroundColor3", "Window");
		v214:BindTheme(v440, "Color", "Border");
		local v441 = Instance.new("UIListLayout", v430);
		v441.SortOrder = Enum.SortOrder.LayoutOrder;
		local function v444()
			v398 = not v398;
			v422.Text = (v398 and "▲") or "▼";
			local v563 = (v398 and (v403 * v400)) or 0;
			local v564 = (v398 and (v399 + v563 + 8)) or v399;
			v5:Create(v405, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=UDim2.new(1, -5, 0, v564)}):Play();
			v5:Create(v430, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size=UDim2.new(1, 0, 0, v563)}):Play();
		end
		local function v445(v565)
			v395 = v565 or v395;
			for v590, v591 in ipairs(v430:GetChildren()) do
				if v591:IsA("TextButton") then
					v591:Destroy();
				end
			end
			v430.CanvasSize = UDim2.new(0, 0, 0, #v395 * v400);
			v403 = math.clamp(#v395, 1, v401);
			for v592, v593 in ipairs(v395) do
				local v594 = Instance.new("TextButton", v430);
				v594.Size = UDim2.new(1, 0, 0, v400);
				v594.BackgroundColor3 = v214.Colors.Window;
				v594.Text = tostring(v593);
				v594.TextColor3 = ((v593 == v402) and v214.Colors.Accent) or v214.Colors.TextSub;
				v594.TextSize = 12;
				v594.ZIndex = 51;
				v214:BindTheme(v594, "BackgroundColor3", "Window");
				v214:BindFont(v594, "Main");
				v594.MouseButton1Click:Connect(function()
					v402 = v593;
					v411.Text = v246(v393, v394) .. ": " .. tostring(v402);
					v397(v593);
					v444();
				end);
			end
		end
		v445(v395);
		local v446 = Instance.new("TextButton", v405);
		v446.Size = UDim2.new(1, 0, 0, v399);
		v446.BackgroundTransparency = 1;
		v446.Text = "";
		v446.ZIndex = 10;
		v446.MouseButton1Click:Connect(v444);
		local v451 = {};
		v451.Refresh = function(v567, v568)
			v445(v568);
		end;
		return v451;
	end;
	v213.AddTextBox = function(v453, v454)
		v454 = v454 or {};
		local v455 = v454.Text or "Input";
		local v456 = v454.BoldText or false;
		local v457 = v454.Placeholder or "Enter text...";
		local v458 = v454.Callback or function()
		end;
		local v459 = Instance.new("Frame", v215);
		v459.Size = UDim2.new(1, -5, 0, 38);
		v459.BackgroundColor3 = v214.Colors.Background;
		v10(v459, 6);
		local v463 = v11(v459, v214.Colors.Border);
		v214:BindTheme(v459, "BackgroundColor3", "Background");
		v214:BindTheme(v463, "Color", "Border");
		local v464 = Instance.new("TextLabel", v459);
		v464.Size = UDim2.new(0, 100, 1, 0);
		v464.Position = UDim2.new(0, 12, 0, 0);
		v464.BackgroundTransparency = 1;
		v464.RichText = true;
		v464.Text = v246(v455, v456);
		v464.TextColor3 = v214.Colors.TextMain;
		v464.TextSize = 13;
		v464.TextXAlignment = Enum.TextXAlignment.Left;
		v214:BindTheme(v464, "TextColor3", "TextMain");
		v214:BindFont(v464, (v456 and "Bold") or "Medium");
		local v475 = Instance.new("TextBox", v459);
		v475.Size = UDim2.new(1, -125, 0, 26);
		v475.Position = UDim2.new(0, 115, 0.5, -13);
		v475.BackgroundColor3 = v214.Colors.SidebarUnselected;
		v475.Text = "";
		v475.PlaceholderText = v457;
		v475.TextColor3 = v214.Colors.TextMain;
		v475.PlaceholderColor3 = v214.Colors.TextSub;
		v475.TextSize = 12;
		v475.ClearTextOnFocus = false;
		v10(v475, 4);
		v214:BindTheme(v475, "BackgroundColor3", "SidebarUnselected");
		v214:BindTheme(v475, "TextColor3", "TextMain");
		v214:BindFont(v475, "Main");
		v475.FocusLost:Connect(function(v569)
			v458(v475.Text, v569);
		end);
	end;
	return v213;
end;
return v0;
