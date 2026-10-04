--// Vape V4 UI Library | Recreation
--// Target: Roblox Luau (Executor + Studio compatible)
--// Style: Dark Click GUI + Arraylist + Watermark + Notifications
--// Usage:
--//   local Vape = loadstring(game:HttpGet(".../VapeV4Lib.lua"))()
--//   local Window = Vape:Window({ Title = "Vape V4", ToggleKey = Enum.KeyCode.RightShift })
--//   local Combat = Window:Tab("Combat")
--//   local Sprint = Combat:Module({ Name = "Sprint", Enabled = false, Callback = function(v) print(v) end })
--//   Sprint:Slider({ Name = "Speed", Min = 16, Max = 100, Default = 16 })
--//   Sprint:Dropdown({ Name = "Mode", Options = {"Legit","Blatant"}, Default = "Legit" })
--//   Sprint:Toggle({ Name = "AutoJump", Default = true })

local VapeLib = {}
VapeLib.__index = VapeLib

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

--// Theme (Vape V4 accurate-ish)
local THEME = {
	Background   = Color3.fromRGB(13, 13, 16),
	TopBar       = Color3.fromRGB(17, 17, 21),
	Sidebar      = Color3.fromRGB(15, 15, 19),
	Page         = Color3.fromRGB(13, 13, 16),
	Module       = Color3.fromRGB(22, 22, 27),
	ModuleHover  = Color3.fromRGB(27, 27, 33),
	Element      = Color3.fromRGB(29, 29, 36),
	Stroke       = Color3.fromRGB(38, 38, 48),
	StrokeLight  = Color3.fromRGB(52, 52, 66),
	Text         = Color3.fromRGB(235, 235, 240),
	TextDim      = Color3.fromRGB(150, 150, 165),
	TextDark     = Color3.fromRGB(110, 110, 125),
	Accent       = Color3.fromRGB(124, 93, 250), -- vape purple
	Accent2      = Color3.fromRGB(59, 130, 246), -- blue for gradient
	Green        = Color3.fromRGB(52, 211, 153),
	Red          = Color3.fromRGB(248, 113, 113),
}

local ACCENT_OBJECTS = {} -- { obj, prop, gradient? }
local function RegisterAccent(obj, prop)
	prop = prop or "BackgroundColor3"
	table.insert(ACCENT_OBJECTS, {Obj = obj, Prop = prop})
	obj[prop] = THEME.Accent
	return obj
end

local function ApplyAccent(color)
	THEME.Accent = color
	for _, e in ipairs(ACCENT_OBJECTS) do
		if e.Obj and e.Obj.Parent then
			pcall(function()
				e.Obj[e.Prop] = color
			end)
		end
	end
end

--// Utils
local function Create(class, props, children)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			local ok = pcall(function() obj[k] = v end)
			if not ok and type(k) == "string" then
				-- attribute fallback
				pcall(function() obj:SetAttribute(k, v) end)
			end
		end
	end
	for _, c in ipairs(children or {}) do
		c.Parent = obj
	end
	if props and props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function Corner(parent, radius)
	return Create("UICorner", { CornerRadius = radius or UDim.new(0, 6), Parent = parent })
end

local function Stroke(parent, color, thickness, transparency)
	return Create("UIStroke", {
		Color = color or THEME.Stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function Padding(parent, l, t, r, b)
	return Create("UIPadding", {
		PaddingLeft = UDim.new(0, l or 10),
		PaddingTop = UDim.new(0, t or 8),
		PaddingRight = UDim.new(0, r or 10),
		PaddingBottom = UDim.new(0, b or 8),
		Parent = parent,
	})
end

local function Tween(obj, info, props)
	local tw = TweenService:Create(obj, info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function MakeDraggable(handle, target)
	target = target or handle
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function GetGuiParent()
	local ok, hui = pcall(function() return gethui and gethui() end)
	if ok and hui then return hui end
	local ok2, core = pcall(function() return CoreGui end)
	if ok2 then
		-- Studio can't write to CoreGui with plain plugin? use PlayerGui fallback
		if RunService:IsStudio() and LocalPlayer then
			return LocalPlayer:WaitForChild("PlayerGui")
		end
		return core
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

--// Toggle Switch component (returns frame + set function)
local function CreateToggleSwitch(parent, default, callback)
	local on = default and true or false
	local holder = Create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = on and THEME.Accent or Color3.fromRGB(45, 45, 55),
		Size = UDim2.new(0, 36, 0, 20),
		Parent = parent,
	})
	Corner(holder, UDim.new(1, 0))
	Stroke(holder, Color3.fromRGB(60, 60, 75), 1, 0.3)

	local knob = Create("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Parent = holder,
	})
	Corner(knob, UDim.new(1, 0))

	if on then table.insert(ACCENT_OBJECTS, {Obj = holder, Prop = "BackgroundColor3"}) end

	local function set(v, silent)
		on = v and true or false
		-- maintain accent registry: remove/add
		for i = #ACCENT_OBJECTS, 1, -1 do
			if ACCENT_OBJECTS[i].Obj == holder then table.remove(ACCENT_OBJECTS, i) end
		end
		if on then
			table.insert(ACCENT_OBJECTS, {Obj = holder, Prop = "BackgroundColor3"})
			Tween(holder, TweenInfo.new(0.18), {BackgroundColor3 = THEME.Accent})
			Tween(knob, TweenInfo.new(0.18), {Position = UDim2.new(1, -17, 0.5, -7)})
		else
			Tween(holder, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
			Tween(knob, TweenInfo.new(0.18), {Position = UDim2.new(0, 3, 0.5, -7)})
		end
		if not silent and callback then task.spawn(callback, on) end
	end

	holder.MouseButton1Click:Connect(function() set(not on) end)
	return holder, set, function() return on end
end

--// MAIN WINDOW
function VapeLib:Window(opts)
	opts = opts or {}
	local title = opts.Title or "Vape V4"
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	local accent = opts.Accent or THEME.Accent
	THEME.Accent = accent

	local self = {}
	local arrayEntries = {} -- name -> {Frame, Label, SortWidth}
	local tabs = {}
	local firstTab = nil

	-- Root
	local guiParent = GetGuiParent()
	local ScreenGui = Create("ScreenGui", {
		Name = title:gsub("%s+", "") .. "_VapeV4",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		Parent = guiParent,
	})

	-- Watermark (top-left)
	local Watermark = Create("Frame", {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 12, 0, 12),
		Size = UDim2.new(0, 230, 0, 30),
		BackgroundColor3 = Color3.fromRGB(10, 10, 13),
		BackgroundTransparency = 0.25,
		Parent = ScreenGui,
		Visible = opts.Watermark ~= false,
	})
	Corner(Watermark, UDim.new(0, 6))
	Stroke(Watermark, THEME.Stroke, 1, 0.2)
	local WatermarkAccent = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = THEME.Accent,
		Parent = Watermark,
	})
	Corner(WatermarkAccent, UDim.new(0, 6))
	RegisterAccent(WatermarkAccent, "BackgroundColor3")
	local WatermarkLabel = Create("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, -2),
		Position = UDim2.new(0, 10, 0, 2),
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = THEME.Text,
		Text = title .. "  |  -- fps  |  -- ms",
		Parent = Watermark,
	})

	-- Arraylist (top-right)
	local Arraylist = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.new(0, 170, 0, 30),
		BackgroundTransparency = 1,
		Parent = ScreenGui,
		Visible = opts.Arraylist ~= false,
	})
	local ArrayLayout = Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = Arraylist,
	})

	local function RefreshArraylist()
		-- sort by text width desc
		local list = {}
		for name, e in pairs(arrayEntries) do table.insert(list, e) end
		table.sort(list, function(a, b) return (a.Width or 0) > (b.Width or 0) end)
		for i, e in ipairs(list) do
			e.Frame.LayoutOrder = i
		end
	end

	local function SetArrayEntry(name, enabled, suffix)
		suffix = suffix or ""
		local display = suffix ~= "" and (name .. " " .. suffix) or name
		if enabled then
			local e = arrayEntries[name]
			if not e then
				local f = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(10, 10, 13),
					BackgroundTransparency = 0.25,
					Size = UDim2.new(0, 100, 0, 22),
					AutomaticSize = Enum.AutomaticSize.X,
					Parent = Arraylist,
				})
				Corner(f, UDim.new(0, 4))
				Stroke(f, THEME.Stroke, 1, 0.4)
				local bar = Create("Frame", {
					Size = UDim2.new(0, 2, 1, 0),
					BackgroundColor3 = THEME.Accent,
					Parent = f,
				})
				Corner(bar, UDim.new(0, 2))
				RegisterAccent(bar, "BackgroundColor3")
				local lbl = Create("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
					Font = Enum.Font.GothamMedium,
					TextSize = 12,
					TextColor3 = THEME.Text,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = f,
				})
				Padding(lbl, 8, 0, 8, 0)
				arrayEntries[name] = {Frame = f, Label = lbl, Bar = bar, Width = 0}
				e = arrayEntries[name]
			end
			-- rich text: name white + suffix gray
			if suffix ~= "" then
				e.Label.Text = display
				-- can't easily two-tone without RichText; use full text
			else
				e.Label.Text = display
			end
			e.Frame.Visible = true
			-- measure
			task.spawn(function()
				task.wait()
				pcall(function()
					e.Width = e.Label.TextBounds.X + 20
					e.Frame.Size = UDim2.new(0, e.Width, 0, 22)
					RefreshArraylist()
				end)
			end)
		else
			local e = arrayEntries[name]
			if e then e.Frame.Visible = false end
		end
		RefreshArraylist()
	end

	-- FPS / Ping loop for watermark
	do
		local frames = 0
		local last = tick()
		local fps, ms = 60, 30
		RunService.RenderStepped:Connect(function()
			frames = frames + 1
			local now = tick()
			if now - last >= 0.5 then
				fps = math.floor(frames / (now - last) + 0.5)
				frames = 0
				last = now
				pcall(function()
					local ping = "--"
					-- stats ping (studio safe)
					local stats = game:GetService("Stats")
					local net = stats and stats.Network and stats.Network.ServerStatsItem
					local item = net and net:FindFirstChild("Data Ping")
					if item then ping = tostring(math.floor(item:GetValue())) end
					ms = ping
					WatermarkLabel.Text = string.format("%s  |  %d fps  |  %s ms", title, fps, tostring(ping))
				end)
			end
		end)
	end

	-- Notifications (bottom-right)
	local NotifHolder = Create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -14, 1, -14),
		Size = UDim2.new(0, 260, 1, 0),
		BackgroundTransparency = 1,
		Parent = ScreenGui,
	})
	Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = NotifHolder,
	})

	function self:Notify(nOpts)
		nOpts = nOpts or {}
		local nTitle = nOpts.Title or title
		local nText = nOpts.Text or "Notification"
		local dur = nOpts.Duration or 3
		local card = Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(16, 16, 21),
			Size = UDim2.new(0, 250, 0, 56),
			Parent = NotifHolder,
		})
		Corner(card, UDim.new(0, 6))
		Stroke(card, THEME.Stroke, 1, 0)
		local bar = Create("Frame", { Size = UDim2.new(0, 2, 1, -12), Position = UDim2.new(0, 6, 0, 6), BackgroundColor3 = THEME.Accent, Parent = card })
		Corner(bar, UDim.new(0, 2))
		RegisterAccent(bar, "BackgroundColor3")
		Create("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 6), Size = UDim2.new(1, -24, 0, 16),
			Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = THEME.Text, Text = nTitle, Parent = card,
		})
		Create("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.new(0, 16, 0, 24), Size = UDim2.new(1, -24, 0, 26),
			Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = THEME.TextDim, TextWrapped = true, Text = nText, Parent = card,
		})
		card.Position = UDim2.new(1, 20, 0, 0)
		Tween(card, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
		-- fix position tween for list layout: use GroupTransparency? just fade in
		task.delay(dur, function()
			if card and card.Parent then
				local tw = Tween(card, TweenInfo.new(0.3), {BackgroundTransparency = 1})
				for _, d in ipairs(card:GetDescendants()) do
					if d:IsA("TextLabel") then Tween(d, TweenInfo.new(0.3), {TextTransparency = 1}) end
					if d:IsA("Frame") then Tween(d, TweenInfo.new(0.3), {BackgroundTransparency = 1}) end
				end
				tw.Completed:Wait()
				card:Destroy()
			end
		end)
	end

	--// Main Window
	local Main = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 620, 0, 440),
		BackgroundColor3 = THEME.Background,
		BorderSizePixel = 0,
		Parent = ScreenGui,
		ClipsDescendants = true,
	})
	Corner(Main, UDim.new(0, 8))
	Stroke(Main, THEME.StrokeLight, 1, 0.5)
	MakeDraggable(Create("Frame", { -- drag proxy is TopBar below; keep ref
		BackgroundTransparency = 1, Size = UDim2.new(0,0,0,0), Parent = Main,
	}), Main)

	-- TopBar
	local TopBar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = THEME.TopBar,
		BorderSizePixel = 0,
		Parent = Main,
	})
	-- divider
	Create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = THEME.Stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = TopBar })
	MakeDraggable(TopBar, Main)

	-- Logo
	local Logo = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 0),
		Size = UDim2.new(0, 130, 1, 0),
		Font = Enum.Font.GothamBold,
		TextSize = 17,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = THEME.Text,
		Parent = TopBar,
		RichText = true,
		Text = 'vape <font color="rgb(124,93,250)">V4</font>',
	})
	Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 30), Size = UDim2.new(0, 130, 0, 14),
		Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = THEME.TextDark, Text = "RECREATION LIB", Parent = TopBar,
	})

	-- Search
	local SearchBox = Create("TextBox", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 220, 0, 30),
		BackgroundColor3 = THEME.Element,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = THEME.Text,
		PlaceholderColor3 = THEME.TextDark,
		PlaceholderText = "Search ...",
		Text = "",
		ClearTextOnFocus = false,
		Parent = TopBar,
	})
	Corner(SearchBox, UDim.new(0, 6))
	Stroke(SearchBox, THEME.Stroke, 1, 0.2)
	Padding(SearchBox, 10, 0, 10, 0)

	-- Top-right buttons: minimize, close/settings
	local function TopButton(xOff, text)
		local b = Create("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, xOff, 0.5, 0),
			Size = UDim2.new(0, 30, 0, 30),
			BackgroundColor3 = THEME.Element,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = THEME.TextDim,
			Text = text,
			AutoButtonColor = false,
			Parent = TopBar,
		})
		Corner(b, UDim.new(0, 6))
		Stroke(b, THEME.Stroke, 1, 0.3)
		return b
	end
	local CloseBtn = TopButton(-10, "×")
	local MinBtn = TopButton(-46, "–")

	local minimized = false
	local preMinSize = Main.Size
	MinBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			preMinSize = Main.Size
			Tween(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 52)})
			for _, c in ipairs(Main:GetChildren()) do
				if c ~= TopBar and c:IsA("GuiObject") then c.Visible = false end
			end
		else
			Tween(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = preMinSize})
			task.delay(0.1, function()
				for _, c in ipairs(Main:GetChildren()) do
					if c:IsA("GuiObject") then c.Visible = true end
				end
			end)
		end
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
	end)

	-- Body: sidebar + pages
	local Sidebar = Create("Frame", {
		Position = UDim2.new(0, 0, 0, 52),
		Size = UDim2.new(0, 150, 1, -52),
		BackgroundColor3 = THEME.Sidebar,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Create("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = THEME.Stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = Sidebar })
	local SideLayout = Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Sidebar,
	})
	Padding(Sidebar, 10, 12, 10, 12)

	local Pages = Create("Frame", {
		Position = UDim2.new(0, 150, 0, 52),
		Size = UDim2.new(1, -150, 1, -52),
		BackgroundColor3 = THEME.Page,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Parent = Main,
	})

	-- Search filter
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(SearchBox.Text)
		for _, tab in pairs(tabs) do
			for _, mod in ipairs(tab.Modules) do
				if q == "" then
					mod.Container.Visible = true
				else
					mod.Container.Visible = string.find(string.lower(mod.Name), q, 1, true) ~= nil
				end
			end
		end
	end)

	function self:Tab(name)
		assert(type(name) == "string", "Tab name must be string")
		if tabs[name] then return tabs[name] end

		local order = #Pages:GetChildren()
		local SideBtn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = THEME.Sidebar,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = THEME.TextDim,
			Text = "   " .. name,
			AutoButtonColor = false,
			LayoutOrder = order,
			Parent = Sidebar,
		})
		Corner(SideBtn, UDim.new(0, 6))
		Padding(SideBtn, 6, 0, 0, 0)

		local Page = Create("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = THEME.StrokeLight,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = Pages,
		})
		Padding(Page, 12, 12, 12, 12)
		local List = Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Page,
		})

		local tabObj = { Name = name, Button = SideBtn, Page = Page, Modules = {} }

		local function select()
			for _, t in pairs(tabs) do
				t.Page.Visible = false
				Tween(t.Button, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Sidebar, TextColor3 = THEME.TextDim})
			end
			Page.Visible = true
			Tween(SideBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Module, TextColor3 = THEME.Text})
		end
		SideBtn.MouseButton1Click:Connect(select)

		if firstTab == nil then
			firstTab = tabObj
			task.spawn(function()
				task.wait()
				select()
			end)
		end

		--// Module builder
		function tabObj:Module(mOpts)
			mOpts = mOpts or {}
			local modName = mOpts.Name or "Module"
			local modDesc = mOpts.Description or ""
			local enabled = mOpts.Enabled or false
			local callback = mOpts.Callback

			local Container = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 44),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = THEME.Module,
				Parent = Page,
			})
			Corner(Container, UDim.new(0, 6))
			Stroke(Container, THEME.Stroke, 1, 0.3)

			local Header = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundTransparency = 1,
				Parent = Container,
			})
			local NameLabel = Create("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 6),
				Size = UDim2.new(1, -110, 0, 18),
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = THEME.Text,
				Text = modName,
				Parent = Header,
			})
			if modDesc ~= "" then
				Create("TextLabel", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 23),
					Size = UDim2.new(1, -110, 0, 14),
					Font = Enum.Font.Gotham,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = THEME.TextDark,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Text = modDesc,
					Parent = Header,
				})
			end

			local ExpandBtn = Create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -56, 0.5, 0),
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				TextColor3 = THEME.TextDark,
				Text = "›",
				Rotation = 90,
				AutoButtonColor = false,
				Parent = Header,
			})

			local SwitchHolder = Create("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 20),
				BackgroundTransparency = 1,
				Parent = Header,
			})

			local Settings = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Visible = false,
				Parent = Container,
			})
			Create("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 0), BackgroundColor3 = THEME.Stroke, BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = Settings })
			local SetList = Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = Settings,
			})
			Padding(Settings, 12, 10, 12, 10)

			local expanded = false
			local function setExpanded(v)
				expanded = v
				Settings.Visible = v
				Tween(ExpandBtn, TweenInfo.new(0.18), {Rotation = v and 270 or 90})
			end
			ExpandBtn.MouseButton1Click:Connect(function() setExpanded(not expanded) end)
			-- click header (not switch) toggles expand? vape uses arrow; also double purpose: header click toggles module? keep arrow only
			Header.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					-- if clicked empty area, expand? keep simple: nothing
				end
			end)

			local mod = {}
			mod.Name = modName
			mod.Container = Container
			mod.Enabled = enabled

			local function pushArray(state, suffix)
				SetArrayEntry(modName, state, suffix or "")
			end

			local _, setSwitch, getSwitch = CreateToggleSwitch(SwitchHolder, enabled, function(state)
				mod.Enabled = state
				pushArray(state, mod._suffix or "")
				if callback then task.spawn(callback, state) end
			end)
			mod._setSwitch = setSwitch
			mod._suffix = ""

			function mod:SetSuffix(text)
				mod._suffix = text or ""
				if mod.Enabled then pushArray(true, mod._suffix) end
			end

			function mod:SetEnabled(v, silent)
				setSwitch(v, silent)
				mod.Enabled = v and true or false
				pushArray(mod.Enabled, mod._suffix or "")
				if not silent and callback then task.spawn(callback, mod.Enabled) end
			end

			function mod:Toggle(tOpts)
				tOpts = tOpts or {}
				local name = tOpts.Name or "Toggle"
				local def = tOpts.Default or false
				local cb = tOpts.Callback
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = Settings })
				Create("TextLabel", {
					BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0),
					Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = THEME.TextDim, Text = name, Parent = row,
				})
				local swHold = Create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 36, 0, 20), BackgroundTransparency = 1, Parent = row })
				local _, set, get = CreateToggleSwitch(swHold, def, cb)
				if def and cb then task.spawn(cb, true) end
				setExpanded(true)
				return { Set = set, Get = get }
			end

			function mod:Slider(sOpts)
				sOpts = sOpts or {}
				local name = sOpts.Name or "Slider"
				local min = sOpts.Min or 0
				local max = sOpts.Max or 100
				local def = sOpts.Default ~= nil and sOpts.Default or min
				local decimals = sOpts.Decimals or 0
				local cb = sOpts.Callback
				local function fmt(v)
					if decimals <= 0 then return tostring(math.floor(v + 0.5)) end
					return string.format("%." .. decimals .. "f", v)
				end
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = Settings })
				local top = Create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = row })
				Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = top })
				local valLabel = Create("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 56, 1, 0), Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = THEME.Text, Text = fmt(def), Parent = top })
				local bar = Create("TextButton", { Text = "", AutoButtonColor = false, Position = UDim2.new(0, 0, 0, 24), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = Color3.fromRGB(40, 40, 50), Parent = row })
				Corner(bar, UDim.new(1, 0))
				local fill = Create("Frame", { Size = UDim2.new((def - min) / math.max(1e-6, (max - min)), 0, 1, 0), BackgroundColor3 = THEME.Accent, BorderSizePixel = 0, Parent = bar })
				Corner(fill, UDim.new(1, 0))
				RegisterAccent(fill, "BackgroundColor3")
				local knob = Create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new((def - min) / math.max(1e-6, (max - min)), 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Color3.fromRGB(255,255,255), Parent = bar })
				Corner(knob, UDim.new(1, 0))
				Stroke(knob, Color3.fromRGB(0,0,0), 1, 0.6)

				local value = def
				local dragging = false
				local function apply(x)
					local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
					value = min + rel * (max - min)
					if decimals <= 0 then value = math.floor(value + 0.5) end
					fill.Size = UDim2.new(rel, 0, 1, 0)
					knob.Position = UDim2.new(rel, 0, 0.5, 0)
					valLabel.Text = fmt(value)
					if cb then task.spawn(cb, value) end
				end
				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						apply(input.Position.X)
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						apply(input.Position.X)
					end
				end)
				setExpanded(true)
				if cb then task.spawn(cb, value) end
				return { Get = function() return value end, Set = function(v)
					v = math.clamp(v, min, max)
					value = v
					local rel = (v - min) / math.max(1e-6, (max - min))
					fill.Size = UDim2.new(rel, 0, 1, 0)
					knob.Position = UDim2.new(rel, 0, 0.5, 0)
					valLabel.Text = fmt(v)
				end }
			end

			function mod:Dropdown(dOpts)
				dOpts = dOpts or {}
				local name = dOpts.Name or "Dropdown"
				local options = dOpts.Options or {"Option 1"}
				local def = dOpts.Default or options[1]
				local cb = dOpts.Callback
				local current = def
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 32), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Settings })
				Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = row })
				local btn = Create("TextButton", { Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.Text, Text = "  " .. tostring(current) .. "   ▾", AutoButtonColor = false, Parent = row })
				Corner(btn, UDim.new(0, 6))
				Stroke(btn, THEME.Stroke, 1, 0.2)
				local list = Create("Frame", { Position = UDim2.new(0, 0, 0, 52), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(20,20,26), Visible = false, Parent = row, ZIndex = 5 })
				Corner(list, UDim.new(0, 6))
				Stroke(list, THEME.Stroke, 1, 0)
				Create("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 2), Parent = list })
				Padding(list, 4, 4, 4, 4)
				local open = false
				local function refresh()
					for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _, opt in ipairs(options) do
						local ob = Create("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = opt == current and THEME.Accent or Color3.fromRGB(20,20,26), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = opt == current and Color3.fromRGB(255,255,255) or THEME.TextDim, Text = tostring(opt), AutoButtonColor = false, Parent = list })
						Corner(ob, UDim.new(0, 4))
						ob.MouseButton1Click:Connect(function()
							current = opt
							btn.Text = "  " .. tostring(current) .. "   ▾"
							list.Visible = false
							open = false
							row.Size = UDim2.new(1, 0, 0, 52)
							if cb then task.spawn(cb, current) end
							mod:SetSuffix(tostring(current))
							refresh()
						end)
					end
				end
				refresh()
				btn.MouseButton1Click:Connect(function()
					open = not open
					list.Visible = open
					if open then row.Size = UDim2.new(1, 0, 0, 52 + (#options * 28)) else row.Size = UDim2.new(1, 0, 0, 52) end
				end)
				setExpanded(true)
				if cb then task.spawn(cb, current) end
				return { Get = function() return current end, Set = function(v) current = v btn.Text = "  " .. tostring(v) .. "   ▾" refresh() end }
			end

			function mod:Color(cOpts)
				cOpts = cOpts or {}
				local name = cOpts.Name or "Color"
				local def = cOpts.Default or THEME.Accent
				local cb = cOpts.Callback
				local current = def
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = Settings })
				Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = row })
				local prev = Create("TextButton", { Text = "", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 28, 0, 18), BackgroundColor3 = current, AutoButtonColor = false, Parent = row })
				Corner(prev, UDim.new(0, 4))
				Stroke(prev, THEME.StrokeLight, 1, 0)
				-- simple picker popup: hue slider cycles
				local picking = false
				prev.MouseButton1Click:Connect(function()
					picking = not picking
					if picking then
						-- quick rainbow cycle demo: open small hue bar
						local picker = Create("Frame", { Position = UDim2.new(0, 0, 0, 28), Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(18,18,24), Parent = row, ZIndex = 5 })
						Corner(picker, UDim.new(0, 6))
						Stroke(picker, THEME.Stroke, 1, 0)
						Padding(picker, 8, 8, 8, 8)
						local hueBar = Create("TextButton", { Text = "", Size = UDim2.new(1, 0, 0, 14), AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(255,255,255), Parent = picker })
						Corner(hueBar, UDim.new(1, 0))
						Create("UIGradient", { Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
							ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
							ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
							ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
							ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
							ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
						}), Parent = hueBar })
						local darkBar = Create("TextButton", { Text = "", Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 14), AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(255,255,255), Parent = picker })
						Corner(darkBar, UDim.new(1, 0))
						local g = Create("UIGradient", { Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))}), Parent = darkBar })
						local h, s, v = 0.7, 1, 1
						local function applyColor()
							current = Color3.fromHSV(h, s, v)
							prev.BackgroundColor3 = current
							darkBar.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
							if cb then task.spawn(cb, current) end
						end
						local dragH, dragD = false, false
						hueBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragH = true end end)
						darkBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragD = true end end)
						UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragH, dragD = false, false end end)
						UserInputService.InputChanged:Connect(function(i)
							if i.UserInputType == Enum.UserInputType.MouseMovement then
								if dragH then h = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / math.max(1, hueBar.AbsoluteSize.X), 0, 1) applyColor() end
								if dragD then v = 1 - math.clamp((i.Position.X - darkBar.AbsolutePosition.X) / math.max(1, darkBar.AbsoluteSize.X), 0, 1) s = 1 applyColor() end
							end
						end)
						local close = Create("TextButton", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Text = "", Parent = picker })
						task.delay(12, function() if picker and picker.Parent then picker:Destroy() picking = false end end)
						-- close on second click of preview (toggle)
						local conn
						conn = prev.MouseButton1Click:Connect(function()
							if picker and picker.Parent then picker:Destroy() end
							picking = false
							conn:Disconnect()
						end)
					end
				end)
				setExpanded(true)
				return { Get = function() return current end, Set = function(c) current = c prev.BackgroundColor3 = c end }
			end

			function mod:Textbox(tOpts)
				tOpts = tOpts or {}
				local name = tOpts.Name or "Textbox"
				local def = tOpts.Default or ""
				local ph = tOpts.Placeholder or "Enter text..."
				local cb = tOpts.Callback
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Parent = Settings })
				Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = row })
				local box = Create("TextBox", { Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.Text, PlaceholderColor3 = THEME.TextDark, PlaceholderText = ph, Text = def, ClearTextOnFocus = false, Parent = row })
				Corner(box, UDim.new(0, 6))
				Stroke(box, THEME.Stroke, 1, 0.2)
				Padding(box, 8, 0, 8, 0)
				box.FocusLost:Connect(function(enter)
					if enter and cb then task.spawn(cb, box.Text) end
				end)
				setExpanded(true)
				return box
			end

			function mod:Button(bOpts)
				bOpts = bOpts or {}
				local name = bOpts.Name or "Button"
				local cb = bOpts.Callback
				local btn = Create("TextButton", { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.Element, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.Text, Text = name, AutoButtonColor = false, Parent = Settings })
				Corner(btn, UDim.new(0, 6))
				Stroke(btn, THEME.Stroke, 1, 0.2)
				btn.MouseEnter:Connect(function() Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ModuleHover}) end)
				btn.MouseLeave:Connect(function() Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Element}) end)
				btn.MouseButton1Click:Connect(function() if cb then task.spawn(cb) end end)
				setExpanded(true)
				return btn
			end

			function mod:Label(text)
				local lbl = Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), AutomaticSize = Enum.AutomaticSize.Y, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDark, TextWrapped = true, Text = text or "Label", Parent = Settings })
				setExpanded(true)
				return lbl
			end

			function mod:Keybind(kOpts)
				kOpts = kOpts or {}
				local name = kOpts.Name or "Bind"
				local def = kOpts.Default or Enum.KeyCode.V
				local cb = kOpts.Callback
				local current = def
				local row = Create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = Settings })
				Create("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = row })
				local b = Create("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 60, 0, 22), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = THEME.Text, Text = current.Name, AutoButtonColor = false, Parent = row })
				Corner(b, UDim.new(0, 4))
				Stroke(b, THEME.Stroke, 1, 0.3)
				local capturing = false
				b.MouseButton1Click:Connect(function()
					capturing = true
					b.Text = "..."
				end)
				UserInputService.InputBegan:Connect(function(input, gpe)
					if capturing and input.UserInputType == Enum.UserInputType.Keyboard then
						capturing = false
						current = input.KeyCode
						b.Text = current.Name
						return
					end
					if not gpe and input.KeyCode == current and not capturing then
						if cb then task.spawn(cb, current) end
						-- default behavior: toggle module
						if kOpts.ToggleModule ~= false then
							mod:SetEnabled(not mod.Enabled)
						end
					end
				end)
				setExpanded(true)
				return { Get = function() return current end }
			end

			-- init state
			if enabled then
				pushArray(true, "")
				if callback then task.spawn(callback, true) end
			end
			table.insert(tabObj.Modules, mod)
			return mod
		end

		tabs[name] = tabObj
		return tabObj
	end

	function self:SetAccent(color)
		ApplyAccent(color)
	end

	function self:ToggleUI(v)
		ScreenGui.Enabled = v
	end

	function self:Destroy()
		ScreenGui:Destroy()
	end

	function self:SetWatermarkVisible(v)
		Watermark.Visible = v
	end

	function self:SetArraylistVisible(v)
		Arraylist.Visible = v
	end

	-- Toggle key
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == toggleKey then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	-- Apply initial accent
	ApplyAccent(accent)

	return self
end

return VapeLib
