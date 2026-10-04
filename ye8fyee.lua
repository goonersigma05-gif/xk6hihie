--// Vape UI Recreation (matches screenshot: 2-panel sidebar + module list)
--// Target: Roblox Luau (Executor + Studio)
--// Usage (from your GitHub):
--//   local Vape = loadstring(game:HttpGet("https://raw.githubusercontent.com/goonersigma05-gif/xk6hihie/refs/heads/main/ye8fyee.lua"))()
--//   local Window = Vape:Window({ ToggleKey = Enum.KeyCode.RightShift })
--//   local Combat = Window:Tab("Combat")
--//   local Sprint = Combat:Module({ Name = "Sprint", Enabled = false, Callback = function(v) print(v) end })
--//   Sprint:Toggle({ Name = "AutoSprint", Default = true })
--//   Sprint:Slider({ Name = "Speed", Min = 16, Max = 50, Default = 22 })

local VapeLib = {}
VapeLib.__index = VapeLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local THEME = {
	Background  = Color3.fromRGB(10, 10, 11),
	Panel       = Color3.fromRGB(13, 13, 14),
	Row         = Color3.fromRGB(17, 17, 19),
	RowHover    = Color3.fromRGB(22, 22, 25),
	Element     = Color3.fromRGB(24, 24, 28),
	Stroke      = Color3.fromRGB(32, 32, 38),
	Text        = Color3.fromRGB(210, 210, 215),
	TextDim     = Color3.fromRGB(145, 145, 155),
	TextDark    = Color3.fromRGB(100, 100, 112),
	Accent      = Color3.fromRGB(62, 255, 156), -- vape green
	AccentDim   = Color3.fromRGB(30, 120, 75),
}

local ACCENTS = {}
local function RegisterAccent(obj, prop)
	prop = prop or "BackgroundColor3"
	table.insert(ACCENTS, {Obj = obj, Prop = prop})
	obj[prop] = THEME.Accent
	return obj
end
local function ApplyAccent(c)
	THEME.Accent = c
	for _, e in ipairs(ACCENTS) do
		if e.Obj and e.Obj.Parent then
			pcall(function() e.Obj[e.Prop] = c end)
		end
	end
end

local ICONS = {
	Combat = "◤",
	Visuals = "◉",
	Render = "◉",
	Utility = "✕",
	World = "○",
	Inventory = "▤",
	Minigames = "◈",
	Other = "⬣",
	Friends = "◯",
	Profiles = "▤",
	Macros = "≡",
}

local function Create(class, props, children)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			pcall(function() obj[k] = v end)
		end
	end
	for _, c in ipairs(children or {}) do c.Parent = obj end
	if props and props.Parent then obj.Parent = props.Parent end
	return obj
end
local function Corner(p, r) return Create("UICorner", {CornerRadius = r or UDim.new(0, 8), Parent = p}) end
local function Stroke(p, c, t) return Create("UIStroke", {Color = c or THEME.Stroke, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
local function Padding(p, l, t, r, b)
	return Create("UIPadding", {PaddingLeft = UDim.new(0, l or 10), PaddingTop = UDim.new(0, t or 8), PaddingRight = UDim.new(0, r or 10), PaddingBottom = UDim.new(0, b or 8), Parent = p})
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
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end
local function GetGuiParent()
	local ok, hui = pcall(function() return gethui and gethui() end)
	if ok and hui then return hui end
	if RunService:IsStudio() and LocalPlayer then
		return LocalPlayer:WaitForChild("PlayerGui")
	end
	return CoreGui
end

local function CreateMiniToggle(parent, default, callback)
	local on = default == true
	local holder = Create("TextButton", {
		Text = "", AutoButtonColor = false,
		BackgroundColor3 = on and THEME.Accent or Color3.fromRGB(45, 45, 52),
		Size = UDim2.new(0, 32, 0, 18), Parent = parent,
	})
	Corner(holder, UDim.new(1, 0))
	local knob = Create("Frame", {
		Size = UDim2.new(0, 12, 0, 12),
		Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255), Parent = holder,
	})
	Corner(knob, UDim.new(1, 0))
	local function set(v, silent)
		on = v == true
		if on then
			Tween(holder, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Accent})
			Tween(knob, TweenInfo.new(0.15), {Position = UDim2.new(1, -15, 0.5, -6)})
		else
			Tween(holder, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 52)})
			Tween(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 3, 0.5, -6)})
		end
		if not silent and callback then task.spawn(callback, on) end
	end
	holder.MouseButton1Click:Connect(function() set(not on) end)
	return holder, set, function() return on end
end

function VapeLib:Window(opts)
	opts = opts or {}
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	if opts.Accent then THEME.Accent = opts.Accent end

	local self = {}
	local tabs = {}
	local tabOrder = {}
	local arrayEntries = {}

	local guiParent = GetGuiParent()
	local ScreenGui = Create("ScreenGui", {
		Name = "VapeRecreation",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		Parent = guiParent,
	})

	--// Arraylist (top-right, optional, vape-style)
	local Arraylist = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.new(0, 160, 0, 20), BackgroundTransparency = 1,
		Parent = ScreenGui, Visible = opts.Arraylist ~= false,
	})
	Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Arraylist})
	local function RefreshArray()
		local list = {}
		for _, e in pairs(arrayEntries) do table.insert(list, e) end
		table.sort(list, function(a, b) return (a.W or 0) > (b.W or 0) end)
		for i, e in ipairs(list) do e.Frame.LayoutOrder = i end
	end
	local function SetArray(name, enabled, suffix)
		suffix = suffix or ""
		local text = suffix ~= "" and (name .. " " .. suffix) or name
		if enabled then
			local e = arrayEntries[name]
			if not e then
				local f = Create("Frame", {BackgroundColor3 = Color3.fromRGB(8, 8, 10), BackgroundTransparency = 0.2, Size = UDim2.new(0, 100, 0, 20), AutomaticSize = Enum.AutomaticSize.X, Parent = Arraylist})
				Corner(f, UDim.new(0, 4))
				local lbl = Create("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.Accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = f})
				Padding(lbl, 8, 0, 8, 0)
				e = {Frame = f, Label = lbl, W = 0}
				arrayEntries[name] = e
			end
			e.Label.Text = text
			e.Frame.Visible = true
			task.spawn(function()
				task.wait()
				pcall(function()
					e.W = e.Label.TextBounds.X + 18
					e.Frame.Size = UDim2.new(0, e.W, 0, 20)
					RefreshArray()
				end)
			end)
		else
			local e = arrayEntries[name]
			if e then e.Frame.Visible = false end
		end
		RefreshArray()
	end

	--// Notifications
	local NotifHolder = Create("Frame", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14),
		Size = UDim2.new(0, 250, 1, 0), BackgroundTransparency = 1, Parent = ScreenGui,
	})
	Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), Parent = NotifHolder})
	function self:Notify(n)
		n = n or {}
		local card = Create("Frame", {BackgroundColor3 = Color3.fromRGB(14, 14, 16), Size = UDim2.new(0, 240, 0, 52), Parent = NotifHolder})
		Corner(card, UDim.new(0, 6))
		Stroke(card, THEME.Stroke, 1)
		Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 15), Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.Text, Text = n.Title or "Vape", Parent = card})
		Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 23), Size = UDim2.new(1, -24, 0, 24), Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, TextColor3 = THEME.TextDim, Text = n.Text or "", Parent = card})
		task.delay(n.Duration or 3, function() if card and card.Parent then card:Destroy() end end)
	end

	--// ===== LEFT PANEL (navigation) =====
	local Nav = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -125, 0.5, 0),
		Size = UDim2.new(0, 225, 0, 480), BackgroundColor3 = THEME.Panel, BorderSizePixel = 0, Parent = ScreenGui,
	})
	Corner(Nav, UDim.new(0, 8))
	Stroke(Nav, THEME.Stroke, 1)

	local NavTop = Create("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Parent = Nav})
	MakeDraggable(NavTop, Nav)
	Create("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0, 120, 1, 0),
		Font = Enum.Font.GothamBlack, TextSize = 19, TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.fromRGB(255, 255, 255), RichText = true,
		Text = 'VAPE <font color="rgb(62,255,156)" size="12"><b>V4</b></font>', Parent = NavTop,
	})
	local GearBtn = Create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = THEME.TextDim, Text = "⚙",
		AutoButtonColor = false, Parent = NavTop,
	})
	GearBtn.MouseButton1Click:Connect(function() self:Notify({Title = "Settings", Text = "Settings page coming soon."}) end)
	Create("Frame", {Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 46), BackgroundColor3 = THEME.Stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = Nav})

	local NavScroll = Create("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 52), Size = UDim2.new(1, 0, 1, -52),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Nav,
	})
	local NavLayout = Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = NavScroll})
	Padding(NavScroll, 8, 4, 8, 4)

	local MiscLabel = Create("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22),
		Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = THEME.TextDark, Text = "  MISC", LayoutOrder = 100, Parent = NavScroll, Visible = false,
	})

	-- no bottom bar (clean, like request: only tabs + gear)

	--// ===== RIGHT PANEL (module list) =====
	local List = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 125, 0.5, 0),
		Size = UDim2.new(0, 235, 0, 480), BackgroundColor3 = THEME.Panel, BorderSizePixel = 0, Parent = ScreenGui,
	})
	Corner(List, UDim.new(0, 8))
	Stroke(List, THEME.Stroke, 1)

	local ListTop = Create("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Parent = List})
	MakeDraggable(ListTop, List)
	local ListIcon = Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(0, 24, 1, 0), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = THEME.Text, Text = "◤", Parent = ListTop})
	local ListTitle = Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 38, 0, 0), Size = UDim2.new(1, -90, 1, 0), Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.Text, Text = "Combat", Parent = ListTop})
	local CollapseBtn = Create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = THEME.TextDim, Text = "^", AutoButtonColor = false, Parent = ListTop})
	Create("Frame", {Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 46), BackgroundColor3 = THEME.Stroke, BackgroundTransparency = 0.3, BorderSizePixel = 0, Parent = List})

	local collapsed = false
	CollapseBtn.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		CollapseBtn.Text = collapsed and "v" or "^"
		for _, c in ipairs(List:GetChildren()) do
			if c ~= ListTop and c:IsA("GuiObject") then c.Visible = not collapsed end
		end
		if collapsed then
			Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, 235, 0, 52)})
		else
			Tween(List, TweenInfo.new(0.2), {Size = UDim2.new(0, 235, 0, 480)})
		end
	end)

	local ListScroll = Create("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 52), Size = UDim2.new(1, 0, 1, -52),
		BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
		ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60),
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = List,
	})
	Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ListScroll})
	Padding(ListScroll, 8, 6, 8, 6)

	local MISC_TABS = {Friends = true, Profiles = true, Macros = true}

	function self:Tab(name, icon)
		assert(type(name) == "string", "Tab name must be string")
		if tabs[name] then return tabs[name] end
		icon = icon or ICONS[name] or "○"
		local isMisc = MISC_TABS[name] == true

		local orderBase = #tabOrder * 10
		local btnOrder = isMisc and (200 + #tabOrder) or (10 + #tabOrder)
		if isMisc then MiscLabel.Visible = true end

		-- nav button (Text scourge fix: must be empty or Roblox shows "Button" behind labels)
		local Btn = Create("TextButton", {
			Text = "",
			Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = THEME.Panel,
			Font = Enum.Font.GothamMedium, TextSize = 13,
			AutoButtonColor = false, LayoutOrder = btnOrder, Parent = NavScroll,
			ClipsDescendants = true,
		})
		Corner(Btn, UDim.new(0, 6))
		Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 22, 1, 0), Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.TextDim, Text = icon, Parent = Btn})
		local NameLbl = Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 34, 0, 0), Size = UDim2.new(1, -80, 1, 0), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = name, Parent = Btn})
		Create("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 16, 0, 16), Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.TextDark, Text = ">", Parent = Btn})

		-- "default" badge for Profiles (like screenshot)
		if name == "Profiles" then
			local badge = Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -30, 0.5, 0), Size = UDim2.new(0, 52, 0, 20), BackgroundColor3 = THEME.Element, Parent = Btn})
			Corner(badge, UDim.new(0, 4))
			Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = THEME.TextDim, Text = "default", Parent = badge})
		end

		-- page (module list container)
		local Page = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, Parent = ListScroll})
		Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Page})

		local tabObj = {Name = name, Button = Btn, NameLabel = NameLbl, Page = Page, Modules = {}}

		local function select()
			for _, t in pairs(tabs) do
				t.Page.Visible = false
				t.Button.BackgroundColor3 = THEME.Panel
				t.NameLabel.TextColor3 = THEME.TextDim
			end
			Page.Visible = true
			Btn.BackgroundColor3 = THEME.Row
			NameLbl.TextColor3 = THEME.Accent
			ListTitle.Text = name
			ListIcon.Text = icon
		end
		Btn.MouseButton1Click:Connect(select)

		table.insert(tabOrder, name)

		function tabObj:Module(mOpts)
			mOpts = mOpts or {}
			local modName = mOpts.Name or "Module"
			local enabled = mOpts.Enabled or false
			local callback = mOpts.Callback

			local Container = Create("Frame", {Size = UDim2.new(1, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = THEME.Panel, Parent = Page})
			local Header = Create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = THEME.Panel, AutoButtonColor = false, Text = "", Parent = Container})
			Corner(Header, UDim.new(0, 6))
			local Title = Create("TextLabel", {
				BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -50, 1, 0),
				Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = enabled and THEME.Accent or THEME.Text, Text = modName, Parent = Header,
			})
			local Dots = Create("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
				Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = THEME.TextDark, Text = "⋮",
				AutoButtonColor = false, Parent = Header,
			})
			Header.MouseEnter:Connect(function() Header.BackgroundColor3 = THEME.RowHover end)
			Header.MouseLeave:Connect(function() Header.BackgroundColor3 = THEME.Panel end)

			local Settings = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(16, 16, 19), Visible = false, Parent = Container})
			Corner(Settings, UDim.new(0, 6))
			Create("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 6), Parent = Settings})
			Padding(Settings, 10, 8, 10, 8)

			local mod = {Name = modName, Container = Container, Enabled = enabled, _suffix = ""}
			local function applyVisual()
				Title.TextColor3 = mod.Enabled and THEME.Accent or THEME.Text
			end
			local function pushArray()
				SetArray(modName, mod.Enabled, mod._suffix)
			end

			Header.MouseButton1Click:Connect(function()
				-- clicking name toggles (but not when clicking dots)
				mod.Enabled = not mod.Enabled
				applyVisual()
				pushArray()
				if callback then task.spawn(callback, mod.Enabled) end
			end)
			local expanded = false
			Dots.MouseButton1Click:Connect(function(ev)
				expanded = not expanded
				Settings.Visible = expanded
				Dots.TextColor3 = expanded and THEME.Text or THEME.TextDark
			end)

			function mod:SetSuffix(t)
				mod._suffix = t or ""
				if mod.Enabled then pushArray() end
			end
			function mod:SetEnabled(v, silent)
				mod.Enabled = v == true
				applyVisual()
				pushArray()
				if not silent and callback then task.spawn(callback, mod.Enabled) end
			end

			local function ensureOpen()
				if not expanded then expanded = true Settings.Visible = true end
			end

			function mod:Toggle(t)
				t = t or {}
				local n = t.Name or "Toggle"
				local def = t.Default or false
				local cb = t.Callback
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = Settings})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -44, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = n, Parent = row})
				local h = Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 32, 0, 18), BackgroundTransparency = 1, Parent = row})
				local _, set, get = CreateMiniToggle(h, def, cb)
				if def and cb then task.spawn(cb, true) end
				ensureOpen()
				return {Set = set, Get = get}
			end

			function mod:Slider(s)
				s = s or {}
				local n = s.Name or "Slider"
				local min, max = s.Min or 0, s.Max or 100
				local def = s.Default ~= nil and s.Default or min
				local dec = s.Decimals or 0
				local cb = s.Callback
				local function fmt(v)
					if dec <= 0 then return tostring(math.floor(v + 0.5)) end
					return string.format("%." .. dec .. "f", v)
				end
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Parent = Settings})
				local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Parent = row})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -50, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = n, Parent = top})
				local val = Create("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 48, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = THEME.Text, Text = fmt(def), Parent = top})
				local bar = Create("TextButton", {Text = "", AutoButtonColor = false, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 5), BackgroundColor3 = Color3.fromRGB(40, 40, 48), Parent = row})
				Corner(bar, UDim.new(1, 0))
				local rel0 = (def - min) / math.max(1e-6, (max - min))
				local fill = Create("Frame", {Size = UDim2.new(rel0, 0, 1, 0), BackgroundColor3 = THEME.Accent, BorderSizePixel = 0, Parent = bar})
				Corner(fill, UDim.new(1, 0))
				local value = def
				local dragging = false
				local function apply(x)
					local r = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
					value = min + r * (max - min)
					if dec <= 0 then value = math.floor(value + 0.5) end
					fill.Size = UDim2.new(r, 0, 1, 0)
					val.Text = fmt(value)
					if cb then task.spawn(cb, value) end
				end
				bar.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						apply(i.Position.X)
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then apply(i.Position.X) end
				end)
				ensureOpen()
				if cb then task.spawn(cb, value) end
				return {Get = function() return value end}
			end

			function mod:Dropdown(d)
				d = d or {}
				local n = d.Name or "Dropdown"
				local options = d.Options or {"Option 1"}
				local cur = d.Default or options[1]
				local cb = d.Callback
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 52), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = Settings})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = n, Parent = row})
				local btn = Create("TextButton", {Position = UDim2.new(0, 0, 0, 19), Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.Text, Text = tostring(cur), AutoButtonColor = false, Parent = row})
				Corner(btn, UDim.new(0, 5))
				local listF = Create("Frame", {Position = UDim2.new(0, 0, 0, 49), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(20, 20, 25), Visible = false, Parent = row, ZIndex = 5})
				Corner(listF, UDim.new(0, 5))
				Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = listF})
				Padding(listF, 3, 3, 3, 3)
				local open = false
				local function refresh()
					for _, c in ipairs(listF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _, opt in ipairs(options) do
						local ob = Create("TextButton", {Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(20, 20, 25), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.TextDim, Text = tostring(opt), AutoButtonColor = false, Parent = listF})
						Corner(ob, UDim.new(0, 4))
						ob.MouseButton1Click:Connect(function()
							cur = opt
							btn.Text = tostring(cur)
							listF.Visible = false
							open = false
							if cb then task.spawn(cb, cur) end
							mod:SetSuffix(tostring(cur))
						end)
					end
				end
				refresh()
				btn.MouseButton1Click:Connect(function()
					open = not open
					listF.Visible = open
				end)
				ensureOpen()
				if cb then task.spawn(cb, cur) end
				return {Get = function() return cur end}
			end

			function mod:Color(c)
				c = c or {}
				local n = c.Name or "Color"
				local cur = c.Default or THEME.Accent
				local cb = c.Callback
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = Settings})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -40, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = n, Parent = row})
				local prev = Create("TextButton", {Text = "", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 26, 0, 16), BackgroundColor3 = cur, AutoButtonColor = false, Parent = row})
				Corner(prev, UDim.new(0, 4))
				local hues = {0, 0.13, 0.33, 0.5, 0.66, 0.83}
				local hi = 1
				prev.MouseButton1Click:Connect(function()
					hi = hi % #hues + 1
					cur = Color3.fromHSV(hues[hi], 0.85, 1)
					prev.BackgroundColor3 = cur
					if cb then task.spawn(cb, cur) end
				end)
				ensureOpen()
				return {Get = function() return cur end}
			end

			function mod:Textbox(t)
				t = t or {}
				local n = t.Name or "Textbox"
				local cb = t.Callback
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, Parent = Settings})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = n, Parent = row})
				local box = Create("TextBox", {Position = UDim2.new(0, 0, 0, 19), Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.Text, PlaceholderColor3 = THEME.TextDark, PlaceholderText = t.Placeholder or "...", Text = t.Default or "", ClearTextOnFocus = false, Parent = row})
				Corner(box, UDim.new(0, 5))
				Padding(box, 8, 0, 8, 0)
				box.FocusLost:Connect(function(enter) if enter and cb then task.spawn(cb, box.Text) end end)
				ensureOpen()
				return box
			end

			function mod:Button(b)
				b = b or {}
				local btn = Create("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = THEME.Element, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.Text, Text = b.Name or "Button", AutoButtonColor = false, Parent = Settings})
				Corner(btn, UDim.new(0, 5))
				btn.MouseButton1Click:Connect(function() if b.Callback then task.spawn(b.Callback) end end)
				ensureOpen()
				return btn
			end

			function mod:Label(text)
				ensureOpen()
				return Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), AutomaticSize = Enum.AutomaticSize.Y, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, TextColor3 = THEME.TextDark, Text = text or "Label", Parent = Settings})
			end

			function mod:Keybind(k)
				k = k or {}
				local cur = k.Default or Enum.KeyCode.V
				local cb = k.Callback
				local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = Settings})
				Create("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -56, 1, 0), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = THEME.TextDim, Text = k.Name or "Bind", Parent = row})
				local b = Create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 52, 0, 20), BackgroundColor3 = THEME.Element, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = THEME.Text, Text = cur.Name, AutoButtonColor = false, Parent = row})
				Corner(b, UDim.new(0, 4))
				local capturing = false
				b.MouseButton1Click:Connect(function() capturing = true b.Text = "..." end)
				UserInputService.InputBegan:Connect(function(input, gpe)
					if capturing and input.UserInputType == Enum.UserInputType.Keyboard then
						capturing = false
						cur = input.KeyCode
						b.Text = cur.Name
						return
					end
					if not gpe and input.KeyCode == cur and not capturing then
						if cb then task.spawn(cb, cur) end
						if k.ToggleModule ~= false then mod:SetEnabled(not mod.Enabled) end
					end
				end)
				ensureOpen()
				return {Get = function() return cur end}
			end

			applyVisual()
			if enabled then pushArray() if callback then task.spawn(callback, true) end end
			table.insert(tabObj.Modules, mod)
			return mod
		end

		tabs[name] = tabObj
		-- auto-select first tab
		if #tabOrder == 1 then
			task.spawn(function() task.wait() select() end)
		end
		return tabObj
	end

	function self:SetAccent(c) ApplyAccent(c) end
	function self:ToggleUI(v) ScreenGui.Enabled = v end
	function self:Destroy() ScreenGui:Destroy() end

	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == toggleKey then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	ApplyAccent(THEME.Accent)
	return self
end

return VapeLib
